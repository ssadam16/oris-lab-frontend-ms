package com.technokratos.card_service.dto;

import java.util.UUID;

public record CardProductResponse(
        UUID id,
        String cardName,
        String description,
        String cardImageLink
) {
}
