package com.technokratos.user_service.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Builder;

import java.util.UUID;

@Builder
public record UserDataUserResponse (
        UUID id,
        String phone,
        String fio
) {
}
