package com.technokratos.user_restriction_service.dto;

import com.technokratos.user_restriction_service.enums.Restriction;

public record UserRestrictionResponse(
        String userId,
        Restriction blockType,
        boolean blocked
) {
}
