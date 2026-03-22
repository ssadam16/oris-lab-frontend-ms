package com.technokratos.card_service.dto;

import java.util.UUID;

public record CardResponse(
        UUID id,
        UUID userId,
        String plasticName,
        String cardName,
        String contractName,
        String pan,
        String imageLink,
        String expDate,
        String cvv,
        CardProductResponse cardProduct
) {
}
