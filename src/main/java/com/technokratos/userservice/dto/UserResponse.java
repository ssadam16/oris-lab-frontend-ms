package com.technokratos.userservice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Builder;

import java.util.UUID;

@Builder
public record UserResponse(

        @NotNull(message = "ID не может быть null")
        UUID id,

        @NotBlank(message = "Номер телефона не может быть пустым")
        @Pattern(
                regexp = "^(\\+7|8)[\\s-]?\\(?\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{2}[\\s-]?\\d{2}$",
                message = "Некорректный номер телефона РФ"
        )
        String phone,

        @NotBlank(message = "ФИО не может быть пустым")
        String fio
) {
}
