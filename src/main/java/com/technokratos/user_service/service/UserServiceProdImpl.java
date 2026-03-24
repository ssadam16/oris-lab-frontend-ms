package com.technokratos.user_service.service;

import com.technokratos.user_service.dto.*;
import com.technokratos.user_service.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.UUID;

@Service
@Profile("dev")//поменять на prod
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

        return restTemplate.getForObject(url, UserDataUserResponse.class);
    }

    @Override
    public List<UserDataUserResponse> findAll() {
        log.debug("Calling user service to find all users");

        return restTemplate.exchange(
                userServiceUrl,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<UserDataUserResponse>>() {}
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

        return restTemplate.postForObject(url, loginRequest, UserDataTokenResponse.class);
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