package com.technokratos.document_service.dto;

import jakarta.validation.constraints.Pattern;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Builder
@Data
public class DocumentCreatingRequest {

    private DocumentType docType;

    private UUID userId;

    @Pattern(regexp = "^[a-zA-Zа-яА-Я]+$",
            message = "Имя должно содержать только буквы (русские или латинские)")
    private String userFio;

    @Pattern(regexp = "^\\d{16}$",
            message = "Номер карты должен содержать ровно 16 цифр")
    private String cardNumber;

    public enum DocumentType {
        CARD_OPENED,
        CARD_CLOSED,
        TRANSFER_RECEIPT
    }
}