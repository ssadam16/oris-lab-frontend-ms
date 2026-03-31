package com.technokratos.exception;

import org.springframework.http.HttpStatus;

public class AuthenticationException extends ServiceException {
    public AuthenticationException(String message, HttpStatus httpStatus) {
        super(message, httpStatus);
    }
}
