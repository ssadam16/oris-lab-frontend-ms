//package com.technokratos.card_service.service.mock;
//
//import com.technokratos.card_service.dto.*;
//import com.technokratos.card_service.service.CardService;
//import com.technokratos.transfer_service.dto.ContractResponse;
//import com.technokratos.transfer_service.service.TransferService;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.context.annotation.Profile;
//import org.springframework.stereotype.Service;
//
//import java.math.BigDecimal;
//import java.time.LocalDateTime;
//import java.time.format.DateTimeFormatter;
//import java.util.*;
//import java.util.concurrent.ConcurrentHashMap;
//import java.util.stream.Collectors;
//
//@Service
//@Profile("dev")
//@Slf4j
//@RequiredArgsConstructor
//public class CardServiceDevImpl implements CardService {
//
//    private final TransferService transferService;
//
//    private final Map<UUID, CardResponse> cardDatabase = new ConcurrentHashMap<>();
//    private final Map<UUID, CardProductResponse> cardProductDatabase = new ConcurrentHashMap<>();
//
//    private void initMockData() {
//        // Инициализация карточных продуктов
//        UUID productId1 = UUID.fromString("123e4567-e89b-12d3-a456-426614174001");
//        CardProductResponse product1 = new CardProductResponse(
//                productId1,
//                "Classic Card",
//                "Standard debit card",
//                "https://example.com/images/classic-card.png"
//        );
//        cardProductDatabase.put(productId1, product1);
//
//        UUID productId2 = UUID.fromString("123e4567-e89b-12d3-a456-426614174002");
//        CardProductResponse product2 = new CardProductResponse(
//                productId2,
//                "Gold Card",
//                "Premium card with benefits",
//                "https://example.com/images/gold-card.png"
//        );
//        cardProductDatabase.put(productId2, product2);
//
//        // Создаем тестовый контракт через TransferService
//        ContractResponse contract = transferService.createNewContract();
//        // Добавляем немного средств на тестовый контракт
//        if (transferService instanceof TransferServiceDevImpl) {
//            ((TransferServiceDevImpl) transferService).addFunds(contract.contractName(), new BigDecimal("50000.00"));
//        }
//
//        // Инициализация тестовой карты
//        UUID testCardId = UUID.fromString("223e4567-e89b-12d3-a456-426614174000");
//        UUID testUserId = UUID.fromString("a7cb3aa8-e4c5-4338-af0e-a50ab368303e");
//
//        CardResponse testCard = new CardResponse(
//                testCardId,
//                testUserId,
//                "Classic Card Ivanov",           // plasticName
//                product1.cardName(),              // contractName - исправлено: это должно быть имя контракта, а не название продукта
//                contract.contractName(),          // pan - исправлено: здесь должен быть PAN, а не имя контракта
//                generatePan(),                    // expDate - исправлено: должен быть срок действия
//                generateExpDate(),                // cvv - исправлено: должен быть CVV
//                UUID.randomUUID(),                // openDocumentId - исправлено: добавлен ID документа открытия
//                UUID.randomUUID(),                // closeDocumentId - исправлено: добавлен ID документа закрытия
//                product1,                         // cardProduct
//                false                             // closeFlag - добавлен флаг закрытия
//        );
//        cardDatabase.put(testCardId, testCard);
//
//        log.info("Mock CardService initialized with {} products, {} cards",
//                cardProductDatabase.size(), cardDatabase.size());
//    }
//
//    @Override
//    public List<CardProductResponse> getAllCardProducts() {
//        log.info("MOCK: Getting all card products");
//        return new ArrayList<>(cardProductDatabase.values());
//    }
//
//    @Override
//    public CardResponse openNewCardForUser(CardRequest request) {
//        log.info("MOCK: Opening new card for user: {}", request.userId());
//
//        CardProductResponse product = cardProductDatabase.get(request.cardProductId());
//        if (product == null) {
//            throw new RuntimeException("Card product not found: " + request.cardProductId());
//        }
//
//        // Создаем новый контракт через TransferService
//        ContractResponse contract = transferService.createNewContract();
//
//        UUID newCardId = UUID.randomUUID();
//        String plasticName = product.cardName() + " " + newCardId.toString().substring(0, 8);
//        String pan = generatePan();
//        String expDate = generateExpDate();
//        String cvv = generateCvv();
//
//        CardResponse newCard = new CardResponse(
//                newCardId,
//                request.userId(),
//                plasticName,
//                contract.contractName(),     // contractName - имя контракта
//                pan,                         // pan
//                expDate,                     // expDate
//                cvv,                         // cvv
//                UUID.randomUUID(),           // openDocumentId
//                null,                        // closeDocumentId - пока null, так как карта еще не закрыта
//                product,                     // cardProduct
//                false                        // closeFlag
//        );
//
//        cardDatabase.put(newCardId, newCard);
//
//        log.info("MOCK: Card created successfully with id: {}, contract: {}", newCardId, contract.contractName());
//        return newCard;
//    }
//
//    @Override
//    public TransactionResponse getCardStatementForPeriod(UUID cardId, LocalDateTime from, LocalDateTime to) {
//        log.info("MOCK: Getting statement for card: {} from {} to {}", cardId, from, to);
//
//        CardResponse card = cardDatabase.get(cardId);
//        if (card == null) {
//            throw new RuntimeException("Card not found: " + cardId);
//        }
//
//        // Получаем транзакции из TransferService
//        // Примечание: метод getAllTransactionsByContractName должен возвращать TransactionResponse
//        return transferService.getAllTransactionsByContractName(card.contractName());
//    }
//
//    @Override
//    public CardProductResponse getCardProductById(UUID cardProductId) {
//        log.info("MOCK: Getting card product by id: {}", cardProductId);
//
//        CardProductResponse product = cardProductDatabase.get(cardProductId);
//        if (product == null) {
//            throw new RuntimeException("Card product not found: " + cardProductId);
//        }
//
//        return product;
//    }
//
//    @Override
//    public List<CardResponse> getAllUserCards(UUID userId) {
//        log.info("MOCK: Getting all cards for user: {}", userId);
//
//        initMockData();
//
//        return cardDatabase.values().stream()
//                .filter(card -> card.userId().equals(userId))
//                .collect(Collectors.toList());
//    }
//
//    @Override
//    public CardResponse getCardInfoByPan(String pan) {
//        log.info("MOCK: Getting card info by PAN: {}", pan);
//
//        return cardDatabase.values().stream()
//                .filter(card -> card.pan().equals(pan))
//                .findFirst()
//                .orElseThrow(() -> new RuntimeException("Card not found with PAN: " + pan));
//    }
//
//    @Override
//    public CardResponse getCardInfoByCardId(UUID cardId) {
//        log.info("MOCK: Getting card info by card id: {}", cardId);
//
//        CardResponse card = cardDatabase.get(cardId);
//        if (card == null) {
//            throw new RuntimeException("Card not found with id: " + cardId);
//        }
//
//        return card;
//    }
//
//    @Override
//    public CardResponse getCardInfoByContractName(String contractName) {
//        log.info("MOCK: Getting card info by contract name: {}", contractName);
//
//        return cardDatabase.values().stream()
//                .filter(card -> card.contractName().equals(contractName))
//                .findFirst()
//                .orElseThrow(() -> new RuntimeException("Card not found with contract name: " + contractName));
//    }
//
//    @Override
//    public void closeCard(UUID cardId) {
//        log.info("MOCK: Closing card: {}", cardId);
//
//        CardResponse card = cardDatabase.get(cardId);
//        if (card == null) {
//            throw new RuntimeException("Card not found: " + cardId);
//        }
//
//        // Обновляем карту с флагом закрытия вместо удаления
//        CardResponse closedCard = new CardResponse(
//                card.id(),
//                card.userId(),
//                card.plasticName(),
//                card.contractName(),
//                card.pan(),
//                card.expDate(),
//                card.cvv(),
//                card.openDocumentId(),
//                UUID.randomUUID(),  // closeDocumentId
//                card.cardProduct(),
//                true                // closeFlag
//        );
//
//        cardDatabase.put(cardId, closedCard);
//        log.info("MOCK: Card closed successfully: {}", cardId);
//    }
//
//    private String generatePan() {
//        return "4" + String.format("%015d", (long) (Math.random() * 1_000_000_000_000_000L));
//    }
//
//    private String generateExpDate() {
//        LocalDateTime expDate = LocalDateTime.now().plusYears(4);
//        return expDate.format(DateTimeFormatter.ofPattern("MM/yy"));
//    }
//
//    private String generateCvv() {
//        return String.format("%03d", (int) (Math.random() * 1000));
//    }
//}