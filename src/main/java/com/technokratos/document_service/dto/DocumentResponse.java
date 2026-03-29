package com.technokratos.document_service.dto;

import java.time.Instant;
import java.util.UUID;

public record DocumentResponse(
        UUID id,
        DocumentCreatingRequest.DocumentType docType,
        UUID userId,
        Instant createdDate,
        String userFio,
        String cardNumber
) {
}
