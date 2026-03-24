package com.technokratos.card_service.dto;

import java.util.UUID;

public record CardResponse(
        UUID id,
        UUID userId,
        String plasticName,
        String contractName,
        String pan,
        String expDate,
        String cvv,
        UUID openDocumentId,
        UUID closeDocumentId,
        CardProductResponse cardProduct,
        boolean closeFlag
) {
}
