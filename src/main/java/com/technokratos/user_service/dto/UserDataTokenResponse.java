package com.technokratos.user_service.dto;

import java.util.UUID;

public record UserDataTokenResponse(
        String accessToken,
        UUID userId
) {
}
