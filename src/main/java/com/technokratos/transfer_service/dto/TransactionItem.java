package com.technokratos.transfer_service.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Setter
@Getter
public class TransactionItem {
    private String cardName;
    private String contractName;
    private String type;
    private String direction;
    private String formattedAmount;
    private BigDecimal amount;
    private String description;
    private String date;
    private String time;
    private String counterparty;
}