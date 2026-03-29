package com.technokratos.card_service.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record TransactionElementResponse(
        String sourceContractId,
        String targetContractId,
        BigDecimal amount,
        String description,
        LocalDateTime createdAt
) {
}
