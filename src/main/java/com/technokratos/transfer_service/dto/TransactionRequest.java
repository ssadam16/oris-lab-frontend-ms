package com.technokratos.transfer_service.dto;

import java.math.BigDecimal;

public record TransactionRequest(
        String sourceContractName,
        String targetContractName,
        BigDecimal amount,
        String description
) {
}
