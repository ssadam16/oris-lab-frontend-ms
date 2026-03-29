package com.technokratos.transfer_service.service;

import com.technokratos.card_service.dto.TransactionElementResponse;
import com.technokratos.card_service.dto.TransactionResponse;
import com.technokratos.transfer_service.dto.ContractResponse;
import com.technokratos.transfer_service.dto.TransactionRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Slf4j
@Service
@Profile("prod")
@RequiredArgsConstructor
public class TransferServiceProdImpl implements TransferService {

    private final RestTemplate restTemplate;

    @Value("${spring.services.transfer-service.url}")
    private String transferServiceUrl;

    @Override
    public TransactionElementResponse makeTransaction(TransactionRequest request) {
        final String url = "%s/transactions".formatted(transferServiceUrl);

        log.info("Making transaction to URL: {}", url);
        log.debug("Transaction request: sourceContractId={}, targetContractId={}, amount={}, description={}",
                request.sourceContractName(), request.targetContractName(), request.amount(), request.description());

        TransactionElementResponse response = restTemplate.postForObject(
                url,
                request,
                TransactionElementResponse.class
        );

        log.info("Transaction completed successfully. Source: {}, Target: {}, Amount: {}",
                response != null ? response.sourceContractId() : null,
                response != null ? response.targetContractId() : null,
                response != null ? response.amount() : null);

        return response;
    }

    @Override
    public ContractResponse createNewContract() {
        final String url = "%s/contract".formatted(transferServiceUrl);

        log.info("Creating new contract. URL: {}", url);

        ContractResponse response = restTemplate.postForObject(
                url,
                null,
                ContractResponse.class
        );

        log.info("Contract created successfully. Contract Name: {}, Created Date: {}, Balance: {}",
                response != null ? response.contractName() : null,
                response != null ? response.createdDate() : null,
                response != null ? response.balance() : null);

        return response;
    }

    @Override
    public TransactionResponse getAllTransactionsByContractName(String contractName) {
        final String url = "%s/transactions/%s".formatted(transferServiceUrl, contractName);

        log.info("Fetching all transactions for contract: {}", contractName);
        log.debug("URL: {}", url);

        TransactionResponse response = restTemplate.getForObject(
                url,
                TransactionResponse.class
        );

        log.info("Transaction response {}", response);

        int transactionsCount = response != null && response.transactions() != null
                ? response.transactions().size() : 0;

        log.info("Retrieved {} transactions for contract: {} from {} to {}",
                transactionsCount,
                response != null ? response.contractName() : null,
                response != null ? response.from() : null,
                response != null ? response.to() : null);

        return response;
    }

    @Override
    public ContractResponse getContractByName(String contractName) {
        final String url = "%s/contract/%s".formatted(transferServiceUrl, contractName);

        log.info("Fetching contract by name: {}", contractName);
        log.debug("URL: {}", url);

        ContractResponse response = restTemplate.getForObject(
                url,
                ContractResponse.class
        );

        if (response != null) {
            log.info("Contract found: Name={}, Created={}, Balance={}",
                    response.contractName(), response.createdDate(), response.balance());
        } else {
            log.warn("Contract not found with name: {}", contractName);
        }

        return response;
    }
}