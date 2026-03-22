package com.technokratos.transfer_service.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record TransactionRequest(
        UUID sourceContractId,
        UUID targetContractId,
        BigDecimal amount,
        String description
) {
}
