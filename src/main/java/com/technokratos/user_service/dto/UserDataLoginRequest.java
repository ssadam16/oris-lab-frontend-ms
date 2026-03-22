package com.technokratos.user_service.dto;

public record UserDataLoginRequest(
        String phone,
        String password
) {
}
