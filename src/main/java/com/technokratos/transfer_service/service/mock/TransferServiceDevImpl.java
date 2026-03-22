package com.technokratos.transfer_service.service.mock;

import com.technokratos.card_service.dto.TransactionElementResponse;
import com.technokratos.card_service.dto.TransactionResponse;
import com.technokratos.transfer_service.dto.ContractResponse;
import com.technokratos.transfer_service.dto.TransactionRequest;
import com.technokratos.transfer_service.service.TransferService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Service
@Profile("dev")
@Slf4j
public class TransferServiceDevImpl implements TransferService {

    private final Map<String, ContractResponse> contractDatabase = new ConcurrentHashMap<>();
    private final Map<String, List<TransactionElementResponse>> transactionDatabase = new ConcurrentHashMap<>();

    public TransferServiceDevImpl() {
        initMockData();
    }

    private void initMockData() {
        // Создаем тестовые контракты
        ContractResponse contract1 = new ContractResponse(
                "CONTRACT-001",
                LocalDateTime.now().minusMonths(6),
                new BigDecimal("15000.00")
        );
        contractDatabase.put("CONTRACT-001", contract1);

        ContractResponse contract2 = new ContractResponse(
                "CONTRACT-002",
                LocalDateTime.now().minusMonths(3),
                new BigDecimal("5000.00")
        );
        contractDatabase.put("CONTRACT-002", contract2);

        // Создаем тестовые транзакции для CONTRACT-001
        List<TransactionElementResponse> transactions1 = Arrays.asList(
                new TransactionElementResponse(
                        UUID.fromString("11111111-1111-1111-1111-111111111111"),
                        UUID.fromString("22222222-2222-2222-2222-222222222222"),
                        new BigDecimal("50.00"),
                        "Coffee Shop"
                ),
                new TransactionElementResponse(
                        UUID.fromString("11111111-1111-1111-1111-111111111111"),
                        UUID.fromString("33333333-3333-3333-3333-333333333333"),
                        new BigDecimal("1250.00"),
                        "Rent Payment"
                ),
                new TransactionElementResponse(
                        UUID.fromString("44444444-4444-4444-4444-444444444444"),
                        UUID.fromString("11111111-1111-1111-1111-111111111111"),
                        new BigDecimal("500.00"),
                        "Salary"
                )
        );
        transactionDatabase.put("CONTRACT-001", transactions1);

        // Создаем тестовые транзакции для CONTRACT-002
        List<TransactionElementResponse> transactions2 = Arrays.asList(
                new TransactionElementResponse(
                        UUID.fromString("22222222-2222-2222-2222-222222222222"),
                        UUID.fromString("55555555-5555-5555-5555-555555555555"),
                        new BigDecimal("250.00"),
                        "Restaurant"
                ),
                new TransactionElementResponse(
                        UUID.fromString("66666666-6666-6666-6666-666666666666"),
                        UUID.fromString("22222222-2222-2222-2222-222222222222"),
                        new BigDecimal("100.00"),
                        "Supermarket"
                )
        );
        transactionDatabase.put("CONTRACT-002", transactions2);

        log.info("Mock TransferService initialized with {} contracts, {} transaction sets",
                contractDatabase.size(), transactionDatabase.size());
    }

    @Override
    public TransactionElementResponse makeTransaction(TransactionRequest request) {
        log.info("MOCK: Making transaction from {} to {} amount: {}",
                request.sourceContractId(), request.targetContractId(), request.amount());

        // Проверяем, что контракты существуют
        String sourceContractName = getContractNameById(request.sourceContractId());
        String targetContractName = getContractNameById(request.targetContractId());

        ContractResponse sourceContract = contractDatabase.get(sourceContractName);
        ContractResponse targetContract = contractDatabase.get(targetContractName);

        if (sourceContract == null) {
            throw new RuntimeException("Source contract not found: " + sourceContractName);
        }
        if (targetContract == null) {
            throw new RuntimeException("Target contract not found: " + targetContractName);
        }

        // Проверяем достаточно ли средств
        if (sourceContract.balance().compareTo(request.amount()) < 0) {
            throw new RuntimeException("Insufficient funds. Balance: " + sourceContract.balance() +
                    ", Amount: " + request.amount());
        }

        // Обновляем балансы
        ContractResponse updatedSource = new ContractResponse(
                sourceContract.contractName(),
                sourceContract.createdDate(),
                sourceContract.balance().subtract(request.amount())
        );

        ContractResponse updatedTarget = new ContractResponse(
                targetContract.contractName(),
                targetContract.createdDate(),
                targetContract.balance().add(request.amount())
        );

        contractDatabase.put(sourceContractName, updatedSource);
        contractDatabase.put(targetContractName, updatedTarget);

        // Создаем транзакцию
        TransactionElementResponse transaction = new TransactionElementResponse(
                request.sourceContractId(),
                request.targetContractId(),
                request.amount(),
                request.description()
        );

        // Сохраняем транзакцию для обоих контрактов
        transactionDatabase.computeIfAbsent(sourceContractName, k -> new ArrayList<>()).add(transaction);
        transactionDatabase.computeIfAbsent(targetContractName, k -> new ArrayList<>()).add(transaction);

        log.info("MOCK: Transaction completed successfully");
        return transaction;
    }

    @Override
    public ContractResponse createNewContract() {
        log.info("MOCK: Creating new contract");

        String contractName = "CONTRACT-" + System.currentTimeMillis();
        ContractResponse newContract = new ContractResponse(
                contractName,
                LocalDateTime.now(),
                BigDecimal.ZERO
        );

        contractDatabase.put(contractName, newContract);
        transactionDatabase.put(contractName, new ArrayList<>());

        log.info("MOCK: Contract created: {}", contractName);
        return newContract;
    }

    @Override
    public TransactionResponse getAllTransactionsByContractName(String contractName) {
        log.info("MOCK: Getting all transactions for contract: {}", contractName);

        ContractResponse contract = contractDatabase.get(contractName);
        if (contract == null) {
            throw new RuntimeException("Contract not found: " + contractName);
        }

        List<TransactionElementResponse> transactions = transactionDatabase.getOrDefault(contractName, Collections.emptyList());

        LocalDateTime from = LocalDateTime.now().minusYears(1);
        LocalDateTime to = LocalDateTime.now();

        return new TransactionResponse(
                contractName,
                from,
                to,
                transactions
        );
    }

    @Override
    public ContractResponse getContractByName(String contractName) {
        log.info("MOCK: Getting contract by name: {}", contractName);

        ContractResponse contract = contractDatabase.get(contractName);
        if (contract == null) {
            throw new RuntimeException("Contract not found: " + contractName);
        }

        return contract;
    }

    private String getContractNameById(UUID contractId) {
        // В моке контракт ID - это UUID, но в реальности контракты имеют имя
        // Для простоты считаем, что contractId - это часть имени контракта
        for (String name : contractDatabase.keySet()) {
            if (name.contains(contractId.toString().substring(0, 8))) {
                return name;
            }
        }

        // Если не нашли, создаем новый
        String newContractName = "CONTRACT-" + contractId.toString().substring(0, 8);
        if (!contractDatabase.containsKey(newContractName)) {
            ContractResponse newContract = new ContractResponse(
                    newContractName,
                    LocalDateTime.now(),
                    BigDecimal.ZERO
            );
            contractDatabase.put(newContractName, newContract);
            transactionDatabase.put(newContractName, new ArrayList<>());
        }
        return newContractName;
    }

    // Метод для получения баланса контракта (удобно для тестирования)
    public BigDecimal getBalance(String contractName) {
        ContractResponse contract = contractDatabase.get(contractName);
        return contract != null ? contract.balance() : null;
    }

    // Метод для добавления средств на контракт (для тестирования)
    public void addFunds(String contractName, BigDecimal amount) {
        ContractResponse contract = contractDatabase.get(contractName);
        if (contract != null) {
            ContractResponse updated = new ContractResponse(
                    contract.contractName(),
                    contract.createdDate(),
                    contract.balance().add(amount)
            );
            contractDatabase.put(contractName, updated);
            log.info("MOCK: Added {} to contract {}, new balance: {}", amount, contractName, updated.balance());
        }
    }
}