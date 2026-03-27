package com.technokratos.exception;

import java.util.UUID;

public class UserNotFoundException extends NotFoundException {
    public UserNotFoundException(String phone) {
        super("User with phone: %s not found".formatted(phone));
    }
    public UserNotFoundException(UUID id) {
        super("User with id: %s not found".formatted(id));
    }
}
