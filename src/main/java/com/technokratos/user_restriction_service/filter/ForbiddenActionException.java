package com.technokratos.user_restriction_service.filter;

import com.technokratos.exception.ServiceException;
import com.technokratos.user_restriction_service.enums.Restriction;
import org.springframework.http.HttpStatus;

import java.util.UUID;

public class ForbiddenActionException extends ServiceException {

    public ForbiddenActionException(String id, Restriction restriction) {
        super("Action not allowed for User (ID=%s), due to Restriction=%s".formatted(id, restriction), HttpStatus.FORBIDDEN);
    }
}