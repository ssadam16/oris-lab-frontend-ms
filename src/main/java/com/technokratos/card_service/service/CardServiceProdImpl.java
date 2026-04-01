package com.technokratos.card_service.service;

import com.technokratos.card_service.dto.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class CardServiceProdImpl implements CardService {

    private final RestTemplate restTemplate;

    @Value("${spring.services.card-service.url}")
    private String cardServiceUrl;

    @Override
    public List<CardProductResponse> getAllCardProducts() {
        final String url = "%s/products".formatted(cardServiceUrl);
        log.debug("Calling card service to get all products: {}", url);

        return restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<CardProductResponse>>() {}
        ).getBody();
    }

    @Override
    public CardResponse openNewCardForUser(CardRequest request) {
        log.debug("Calling card service to open new card for user: {}", request.userId());

        return restTemplate.postForObject(cardServiceUrl, request, CardResponse.class);
    }

    @Override
    public TransactionResponse getCardStatementForPeriod(String contractName, Instant from, Instant to) {
        final String url = "%s/statement/%s?from=%s&to=%s".formatted(cardServiceUrl, contractName, from, to);
        log.debug("Calling card service to get statement: {}", url);

        return restTemplate.getForObject(url, TransactionResponse.class);
    }

    @Override
    public CardProductResponse getCardProductById(UUID cardProductId) {
        final String url = "%s/products/%s".formatted(cardServiceUrl, cardProductId);
        log.debug("Calling card service to get product by id: {}", url);

        return restTemplate.getForObject(url, CardProductResponse.class);
    }

    @Override
    public List<CardResponse> getAllUserCards(UUID userId) {
        final String url = "%s/by-user/%s".formatted(cardServiceUrl, userId);
        log.debug("Calling card service to get all user cards: {}", url);

        return restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<CardResponse>>(){}
        ).getBody();
    }

    @Override
    public CardResponse getCardInfoByPan(String pan) {
        final String url = "%s/by-pan/%s".formatted(cardServiceUrl, pan);
        log.debug("Calling card service to get card by PAN: {}", url);

        return restTemplate.getForObject(url, CardResponse.class);
    }

    @Override
    public CardResponse getCardInfoByCardId(UUID cardId) {
        final String url = "%s/by-id/%s".formatted(cardServiceUrl, cardId);
        log.debug("Calling card service to get card by id: {}", url);

        return restTemplate.getForObject(url, CardResponse.class);
    }

    @Override
    public CardResponse getCardInfoByContractName(String contractName) {
        final String url = "%s/by-contract/%s".formatted(cardServiceUrl, contractName);
        log.debug("Calling card service to get card by contract: {}", url);

        return restTemplate.getForObject(url, CardResponse.class);
    }

    @Override
    public void closeCard(UUID cardId) {
        final String url = "%s/%s".formatted(cardServiceUrl, cardId);
        log.debug("Calling card service to close card: {}", url);

        restTemplate.exchange(
                url,
                HttpMethod.DELETE,
                null,
                Void.class
        );
    }
}