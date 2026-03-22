package com.technokratos.transfer_service.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record ContractResponse(
        String contractName,
        LocalDateTime createdDate,
        BigDecimal balance
) { }
