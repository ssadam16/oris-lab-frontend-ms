package com.technokratos.transfer_service.controller;

import com.technokratos.card_service.dto.CardResponse;
import com.technokratos.card_service.dto.TransactionElementResponse;
import com.technokratos.card_service.dto.TransactionResponse;
import com.technokratos.card_service.service.CardService;
import com.technokratos.transfer_service.dto.ContractResponse;
import com.technokratos.transfer_service.dto.TransactionRequest;
import com.technokratos.transfer_service.service.TransferService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/transfers")
@RequiredArgsConstructor
@Slf4j
public class TransferController {

    private final TransferService transferService;
    private final CardService cardService;

    @GetMapping
    public String transfersPage(HttpSession session, Model model) {
        UUID userId = (UUID) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/sign-in";
        }

        try {
            List<CardResponse> cards = cardService.getAllUserCards(userId);
            model.addAttribute("cards", cards);
            model.addAttribute("activePage", "transfers");
            return "transfers";
        } catch (Exception e) {
            log.error("Error loading transfers page", e);
            model.addAttribute("error", "Ошибка загрузки страницы переводов");
            return "error/500";
        }
    }

    @PostMapping
    public String makeTransfer(@RequestParam String sourceContractId,
                               @RequestParam String targetIdentifier,
                               @RequestParam String recipientType,
                               @RequestParam BigDecimal amount,
                               @RequestParam(required = false) String description,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        UUID userId = (UUID) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/sign-in";
        }

        try {
            // Получаем карту по имени контракта
            CardResponse sourceCard = cardService.getCardInfoByContractName(sourceContractId);
            if (!sourceCard.userId().equals(userId)) {
                redirectAttributes.addFlashAttribute("error", "Доступ запрещен");
                return "redirect:/transfers";
            }

            // Получаем контракт получателя
            ContractResponse targetContract;
            if ("card".equals(recipientType)) {
                // По номеру карты
                CardResponse targetCard = cardService.getCardInfoByPan(targetIdentifier);
                targetContract = transferService.getContractByName(targetCard.contractName());
            } else if ("phone".equals(recipientType)) {
                // По номеру телефона - нужно получить пользователя и его контракт
                // В моке просто ищем по контракту
                targetContract = transferService.getContractByName(targetIdentifier);
            } else {
                // По номеру договора
                targetContract = transferService.getContractByName(targetIdentifier);
            }

            if (targetContract == null) {
                redirectAttributes.addFlashAttribute("error", "Получатель не найден");
                return "redirect:/transfers";
            }

            // Получаем UUID контрактов (в моке используем имя контракта как ID)
            UUID sourceContractUuid = UUID.nameUUIDFromBytes(sourceContractId.getBytes());
            UUID targetContractUuid = UUID.nameUUIDFromBytes(targetContract.contractName().getBytes());

            TransactionRequest request = new TransactionRequest(
                    sourceContractUuid,
                    targetContractUuid,
                    amount,
                    description != null ? description : "Перевод"
            );

            transferService.makeTransaction(request);
            redirectAttributes.addFlashAttribute("success",
                    String.format("Перевод %.2f ₽ успешно выполнен", amount));

        } catch (Exception e) {
            log.error("Error making transfer", e);
            redirectAttributes.addFlashAttribute("error",
                    "Ошибка перевода: " + e.getMessage());
        }

        return "redirect:/transfers";
    }

    @GetMapping("/api/contracts/{contractName}/balance")
    @ResponseBody
    public Map<String, Object> getBalance(@PathVariable String contractName, HttpSession session) {
        UUID userId = (UUID) session.getAttribute("userId");
        Map<String, Object> response = new HashMap<>();

        try {
            ContractResponse contract = transferService.getContractByName(contractName);

            // Проверяем, что контракт принадлежит пользователю
            CardResponse card = cardService.getCardInfoByContractName(contractName);
            if (card == null || !card.userId().equals(userId)) {
                response.put("error", "Access denied");
                return response;
            }

            response.put("balance", contract.balance());
            response.put("success", true);
        } catch (Exception e) {
            response.put("error", e.getMessage());
            response.put("success", false);
        }

        return response;
    }

    @GetMapping("/api/transactions/history")
    @ResponseBody
    public List<Map<String, Object>> getTransactionHistory(HttpSession session,
                                                           @RequestParam(defaultValue = "all") String filter,
                                                           @RequestParam(required = false) String from,
                                                           @RequestParam(required = false) String to) {
        UUID userId = (UUID) session.getAttribute("userId");

        try {
            List<CardResponse> userCards = cardService.getAllUserCards(userId);
            Map<String, List<TransactionElementResponse>> allTransactions = new HashMap<>();

            for (CardResponse card : userCards) {
                TransactionResponse txResponse = transferService.getAllTransactionsByContractName(card.contractName());
                allTransactions.put(card.contractName(), txResponse.transactionElementResponse());
            }

            // Форматируем для фронта
            return formatTransactionsForFrontend(allTransactions, filter);
        } catch (Exception e) {
            log.error("Error getting transaction history", e);
            return List.of();
        }
    }

    private List<Map<String, Object>> formatTransactionsForFrontend(Map<String, List<TransactionElementResponse>> transactions, String filter) {
        List<Map<String, Object>> result = new java.util.ArrayList<>();

        for (Map.Entry<String, List<TransactionElementResponse>> entry : transactions.entrySet()) {
            String contractName = entry.getKey();
            for (TransactionElementResponse tx : entry.getValue()) {
                Map<String, Object> formatted = new HashMap<>();
                formatted.put("date", java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm")));
                formatted.put("sourceName", tx.sourceContractId().toString().substring(0, 8));
                formatted.put("targetName", tx.targetContractId().toString().substring(0, 8));
                formatted.put("amount", tx.amount());
                formatted.put("description", tx.description());
                formatted.put("status", "Выполнен");

                // Определяем тип операции
                if (tx.sourceContractId().toString().contains(contractName.substring(0, 8))) {
                    formatted.put("type", "outgoing");
                } else {
                    formatted.put("type", "incoming");
                }

                // Фильтруем
                if ("outgoing".equals(filter) && !"outgoing".equals(formatted.get("type"))) continue;
                if ("incoming".equals(filter) && !"incoming".equals(formatted.get("type"))) continue;

                result.add(formatted);
            }
        }

        // Сортируем по дате (последние сверху)
        result.sort((a, b) -> b.get("date").toString().compareTo(a.get("date").toString()));

        return result;
    }
}