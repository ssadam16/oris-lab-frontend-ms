package com.technokratos.card_service.dto;

import java.util.UUID;

public record CardRequest(
        UUID cardProductId,
        UUID userId
) {
}
