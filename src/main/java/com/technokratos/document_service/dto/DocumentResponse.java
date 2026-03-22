package com.technokratos.document_service.dto;

import java.time.Instant;
import java.util.UUID;

public record DocumentResponse(
        UUID documentId,
        DocumentCreatingRequest.DocumentType docType,
        UUID userId,
        Instant createdAt,
        String userFio,
        String cardNumber
) {
}
