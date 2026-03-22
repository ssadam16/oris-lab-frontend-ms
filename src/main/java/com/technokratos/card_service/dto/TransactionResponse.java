package com.technokratos.card_service.dto;

import java.time.LocalDateTime;
import java.util.List;

public record TransactionResponse(
        String contractName,
        LocalDateTime from,
        LocalDateTime to,
        List<TransactionElementResponse> transactionElementResponse
) {
}
