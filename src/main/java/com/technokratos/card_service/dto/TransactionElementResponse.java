package com.technokratos.card_service.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record TransactionElementResponse(
        String sourceContractName,
        String targetContractName,
        BigDecimal amount,
        String description
) {
}
