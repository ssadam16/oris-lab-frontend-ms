package com.technokratos.transfer_service.service;

import com.technokratos.card_service.dto.TransactionElementResponse;
import com.technokratos.card_service.dto.TransactionResponse;
import com.technokratos.transfer_service.dto.ContractResponse;
import com.technokratos.transfer_service.dto.TransactionRequest;

public interface TransferService {

    TransactionElementResponse makeTransaction(TransactionRequest request);

    ContractResponse createNewContract();

    TransactionResponse getAllTransactionsByContractName(String contractName);

    ContractResponse getContractByName(String contractName);

}
