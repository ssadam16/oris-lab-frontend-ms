package com.technokratos.user_restriction_service.service;

import com.technokratos.user_restriction_service.dto.UserRestrictionResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserRestrictionService {

    private final RestTemplate restTemplate;

    @Value("${spring.services.user-restriction-service.url}")
    private String userRestrictionServiceUrl;

    public UserRestrictionResponse getUserRestrictionInfo(String userId) {
        final String url = "%s/%s".formatted(userRestrictionServiceUrl, userId);
        try {
            return restTemplate.getForObject(url, UserRestrictionResponse.class);
        } catch (HttpClientErrorException.NotFound e) {
            log.info("User: {} not blocked", userId);
            return null;
        }
    }
}
