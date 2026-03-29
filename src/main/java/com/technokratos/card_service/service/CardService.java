package com.technokratos.card_service.service;

import com.technokratos.card_service.dto.CardProductResponse;
import com.technokratos.card_service.dto.CardRequest;
import com.technokratos.card_service.dto.CardResponse;
import com.technokratos.card_service.dto.TransactionResponse;
import com.technokratos.transfer_service.dto.TransactionItem;
import org.jspecify.annotations.NonNull;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public interface CardService {

    List<CardProductResponse> getAllCardProducts();

    CardResponse openNewCardForUser(CardRequest request);

    TransactionResponse getCardStatementForPeriod(UUID cardId, LocalDateTime from, LocalDateTime to);

    CardProductResponse getCardProductById(UUID cardProductId);

    List<CardResponse> getAllUserCards(UUID userId);

    CardResponse getCardInfoByPan(String pan);

    CardResponse getCardInfoByCardId(UUID cardId);

    CardResponse getCardInfoByContractName(String contractName);

    void closeCard(UUID cardId);
}
