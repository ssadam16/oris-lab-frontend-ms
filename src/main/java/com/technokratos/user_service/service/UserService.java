package com.technokratos.user_service.service;

import com.technokratos.user_service.dto.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Getter
@Setter
@Slf4j
public class UserService {

    private final RestTemplate restTemplate;

    @Value("${spring.services.user-service.url}")
    private String userServiceUrl;

    public UserDataUserResponse findById(UUID id) {
        final String url = "%s/%s".formatted(userServiceUrl, id);

        return restTemplate.getForObject(url, UserDataUserResponse.class);
    }

    public List<UserDataUserResponse> findAll() {
        return restTemplate.exchange(
                userServiceUrl,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<UserDataUserResponse>>() {
                }
        ).getBody();
    }


    public UserDataUserResponse signUp(UserDataUserRequest signUpRequest) {
        final String url = "%s/register".formatted(userServiceUrl);

        return restTemplate.postForObject(
                url,
                signUpRequest,
                UserDataUserResponse.class
        );
    }

    public UserDataTokenResponse signIn(UserDataLoginRequest loginRequest) {

        final String url = "%s/login".formatted(userServiceUrl);

        return restTemplate.postForObject(
                url,
                loginRequest,
                UserDataTokenResponse.class
        );
    }

    public UserDataTokenValidationResponse validateToken(String token) {
        final String url = "%s/validate".formatted(userServiceUrl);

        UserDataTokenRequest tokenRequest = UserDataTokenRequest.builder()
                .accessToken(token)
                .build();

        return restTemplate.postForObject(
                url,
                tokenRequest,
                UserDataTokenValidationResponse.class
        );
    }

}
