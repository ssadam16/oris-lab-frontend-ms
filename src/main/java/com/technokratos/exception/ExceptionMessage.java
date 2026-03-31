package com.technokratos.exception;

import lombok.Builder;

@Builder
public record ExceptionMessage(
        String message,

        String exceptionName
) {
}
