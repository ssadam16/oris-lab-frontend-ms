package com.technokratos.userservice.service;

import com.technokratos.userservice.dto.UserResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserService {

    private final RestTemplate restTemplate;

    private final String USER_BASE_URL = "%s/user".formatted();

    public UserResponse getUserById(UUID id) {
        UserResponse user = restTemplate.getForObject("%s/%s".formatted(USER_BASE_URL, id), UserResponse.class);
        return null;
    }
}
