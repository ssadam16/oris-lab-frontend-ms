package com.technokratos.user_restriction_service.dto;

public record UserRestrictionResponse(
        String userId,
        String blockType,
        boolean blocked
) {
}
