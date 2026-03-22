package com.technokratos.card_service.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record TransactionElementResponse(
        UUID sourceContractId,
        UUID targetContractId,
        BigDecimal amount,
        String description
) {
}
