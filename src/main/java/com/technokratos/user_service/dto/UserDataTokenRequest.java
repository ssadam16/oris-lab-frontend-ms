package com.technokratos.user_service.dto;

import lombok.Builder;

@Builder
public record UserDataTokenRequest(
        String accessToken
) {
}
