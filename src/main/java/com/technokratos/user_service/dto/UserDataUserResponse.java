package com.technokratos.user_service.dto;

import lombok.Builder;

import java.util.UUID;

@Builder
public record UserDataUserResponse (
        UUID id,
        String phone,
        String fio
) {
}
