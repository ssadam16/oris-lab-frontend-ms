package com.technokratos.card_service.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record CardResponse(
        UUID id,
        UUID userId,
        String plasticName,
        String contractName,
        String pan,
        String expDate,
        String cvv,
        BigDecimal balance,
        UUID openDocumentId,
        UUID closeDocumentId,
        CardProductResponse cardProduct,
        boolean closeFlag
) {
}
