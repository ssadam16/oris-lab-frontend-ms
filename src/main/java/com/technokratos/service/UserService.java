package com.technokratos.service;

import com.technokratos.config.MicroservicesProperties;
import com.technokratos.dto.UserResponse;
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
private final MicroservicesProperties microservicesProperties;

    public UserResponse getUserById(UUID id) {
        return null;
    }
}
