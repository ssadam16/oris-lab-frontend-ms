package com.technokratos.user_service.service;

import com.technokratos.exception.AuthenticationException;
import com.technokratos.exception.UserAlreadyExistsException;
import com.technokratos.exception.UserNotFoundException;
import com.technokratos.user_service.dto.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserServiceProdImpl implements UserService {

    private final RestTemplate restTemplate;

    @Value("${spring.services.user-service.url}")
    private String userServiceUrl;

    @Override
    public UserDataUserResponse findById(UUID id) {
        final String url = "%s/%s".formatted(userServiceUrl, id);
        log.debug("Calling user service to find user by id: {}", id);
        try {
            return restTemplate.getForObject(url, UserDataUserResponse.class);
        } catch (RestClientException e) {
            throw new UserNotFoundException(id);
        }
    }

    @Override
    public List<UserDataUserResponse> findAll() {
        log.debug("Calling user service to find all users");

        return restTemplate.exchange(
                userServiceUrl,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<UserDataUserResponse>>() {
                }
        ).getBody();
    }

    @Override
    public void deleteById(UUID id) {
        final String url = "%s/%s".formatted(userServiceUrl, id);
        log.debug("Calling user service to delete user by id: {}", id);

        restTemplate.delete(url);
    }

    @Override
    public UserDataUserResponse signUp(UserDataUserRequest signUpRequest) {
        final String url = "%s/register".formatted(userServiceUrl);
        log.debug("Calling user service to sign up user with phone: {}", signUpRequest.phone());

        return restTemplate.postForObject(url, signUpRequest, UserDataUserResponse.class);
    }

    @Override
    public UserDataTokenResponse signIn(UserDataLoginRequest loginRequest) {
        final String url = "%s/login".formatted(userServiceUrl);
        log.debug("Calling user service to sign in user with phone: {}", loginRequest.phone());

        try {
            return restTemplate.postForObject(url, loginRequest, UserDataTokenResponse.class);
        } catch (HttpClientErrorException.NotFound e) {
            throw new UserNotFoundException(loginRequest.phone());
        } catch (HttpClientErrorException.BadRequest e) {
            String responseBody = e.getResponseBodyAsString();
            if (responseBody.contains("password")) {
                throw new AuthenticationException("Неверный пароль", HttpStatus.valueOf(e.getStatusCode().value()));
            }
            throw new AuthenticationException("Некорректный формат запроса", HttpStatus.valueOf(e.getStatusCode().value()));
        } catch (HttpClientErrorException e) {
            throw new AuthenticationException("Ошибка авторизации", HttpStatus.valueOf(e.getStatusCode().value()));
        }
    }

    @Override
    public UserDataTokenValidationResponse validateToken(String token) {
        final String url = "%s/validate".formatted(userServiceUrl);
        log.debug("Calling user service to validate token");

        UserDataTokenRequest tokenRequest = UserDataTokenRequest.builder()
                .accessToken(token)
                .build();

        return restTemplate.postForObject(url, tokenRequest, UserDataTokenValidationResponse.class);
    }
}