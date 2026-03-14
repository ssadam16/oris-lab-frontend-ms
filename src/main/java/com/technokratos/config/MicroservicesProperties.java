package com.technokratos.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
@Getter@Setter
public class MicroservicesProperties {

    @Value("user-service.url")
    private String userServiceUrl;

}
