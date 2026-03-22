package com.technokratos.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
@Getter
public class MicroservicesProperties {

    @Value("${spring.services.user-service.url}")
    private String userServiceUrl;

    @Value("${spring.services.document-service.url}")
    private String documentServiceUrl;
}
