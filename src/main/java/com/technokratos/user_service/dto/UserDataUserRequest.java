package com.technokratos.user_service.dto;


public record UserDataUserRequest(
        String fio,
        String password,
        String phone
) {
}
