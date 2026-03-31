package com.technokratos.exception;

import org.springframework.http.HttpStatus;

public class UserAlreadyExistsException extends ServiceException {
    public UserAlreadyExistsException(String phone) {
        super("User with phone %s already exists".formatted(phone), HttpStatus.CONFLICT);
    }
}
