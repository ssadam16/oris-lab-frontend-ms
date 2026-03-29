package com.technokratos.user_restriction_service.filter;

import com.technokratos.user_restriction_service.enums.Restriction;

import java.util.UUID;

public class ForbiddenActionException extends RuntimeException {

    public ForbiddenActionException(String message) {
        super(message);
    }

    public ForbiddenActionException(String message, Throwable cause) {
        super(message, cause);
    }

    public static ForbiddenActionException byUserId(UUID id, Restriction restriction) {
        return new ForbiddenActionException(
                "Action not allowed for User (ID=%s), due to Restriction=%s".formatted(id, restriction)
        );
    }
}