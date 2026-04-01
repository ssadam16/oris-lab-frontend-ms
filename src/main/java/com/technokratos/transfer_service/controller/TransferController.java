package com.technokratos.transfer_service.controller;

import com.technokratos.card_service.dto.CardResponse;
import com.technokratos.card_service.dto.TransactionElementResponse;
import com.technokratos.card_service.dto.TransactionResponse;
import com.technokratos.card_service.service.CardService;
import com.technokratos.exception.ServiceException;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/transfers")
@RequiredArgsConstructor
@Slf4j
public class TransferController {

    private final TransferService transferService;
    private final CardService cardService;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm");

    @GetMapping
    public String transfersPage(HttpSession session, Model model) {
        UUID userId = (UUID) session.getAttribute("userId");

        try {
            List<CardResponse> allCards = cardService.getAllUserCards(userId);
            List<CardResponse> activeCards = allCards.stream()
                    .filter(card -> !card.closeFlag())
                    .collect(Collectors.toList());

            model.addAttribute("cards", activeCards);
            model.addAttribute("activePage", "transfers");
            model.addAttribute("currentTime", LocalDateTime.now().format(DATE_FORMATTER));

            return "transfers";
        } catch (Exception e) {
            log.error("Error loading transfers page", e);
            model.addAttribute("error", "Ошибка загрузки страницы переводов");
            return "error/error";
        }
    }

    @PostMapping
    public String makeTransfer(
            @RequestParam(name = "sourceContractName") String sourceContractName,
            @RequestParam(name = "recipientType") String recipientType,
            @RequestParam(name = "recipientIdentifier") String recipientIdentifier,
            @RequestParam(name = "amount") BigDecimal amount,
            @RequestParam(name = "description", required = false) String description,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        UUID userId = (UUID) session.getAttribute("userId");

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            redirectAttributes.addFlashAttribute("error", "Сумма должна быть больше 0");
            return "redirect:/transfers";
        }
        if (amount.compareTo(new BigDecimal("1000000")) > 0) {
            redirectAttributes.addFlashAttribute("error", "Максимальная сумма перевода — 1 000 000 ₽");
            return "redirect:/transfers";
        }
        if (recipientIdentifier == null || recipientIdentifier.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Укажите получателя");
            return "redirect:/transfers";
        }

        try {
            CardResponse sourceCard = cardService.getCardInfoByContractName(sourceContractName);
            if (sourceCard == null || !sourceCard.userId().equals(userId) || sourceCard.closeFlag()) {
                redirectAttributes.addFlashAttribute("error", "Карта отправителя недоступна");
                return "redirect:/transfers";
            }

            ContractResponse sourceContract = transferService.getContractByName(sourceContractName);
            if (sourceContract == null || sourceContract.balance().compareTo(amount) < 0) {
                redirectAttributes.addFlashAttribute("error",
                        String.format("Недостаточно средств. Доступно: %.2f ₽", sourceContract != null ? sourceContract.balance() : 0));
                return "redirect:/transfers";
            }

            ContractResponse targetContract = findTargetContract(recipientType, recipientIdentifier);
            if (targetContract == null) {
                redirectAttributes.addFlashAttribute("error", "Получатель не найден");
                return "redirect:/transfers";
            }

            if (sourceContract.contractName().equals(targetContract.contractName())) {
                redirectAttributes.addFlashAttribute("error", "Нельзя переводить самому себе");
                return "redirect:/transfers";
            }

            // 3. Выполнение перевода
            TransactionRequest request = new TransactionRequest(
                    sourceContract.contractName(),
                    targetContract.contractName(),
                    amount,
                    description.trim()
            );

            transferService.makeTransaction(request);

            redirectAttributes.addFlashAttribute("success",
                    String.format("Перевод на сумму %.2f ₽ успешно выполнен", amount));

        } catch (ServiceException e) {
            log.error("Service error during transfer", e);
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            log.error("Unexpected error during transfer", e);
            redirectAttributes.addFlashAttribute("error", "Ошибка при выполнении перевода. Попробуйте позже.");
        }

        return "redirect:/transfers";
    }

    /**
     * Поиск контракта получателя по типу
     */
    private ContractResponse findTargetContract(String type, String identifier) {
        try {
            return switch (type) {
                case "card" -> {
                    CardResponse card = cardService.getCardInfoByPan(identifier.replaceAll("\\s+", ""));
                    yield card != null ? transferService.getContractByName(card.contractName()) : null;
                }
                case "contract" -> transferService.getContractByName(identifier);
                default -> null;
            };
        } catch (Exception e) {
            log.warn("Error finding target contract for type={} id={}", type, identifier, e);
            return null;
        }
    }

    @GetMapping("/history")
    public String historyPage(HttpSession session, Model model) {
        UUID userId = (UUID) session.getAttribute("userId");

        try {
            List<CardResponse> cards = cardService.getAllUserCards(userId);

            List<List<TransactionElementResponse>> transactions = new ArrayList<>();

            for (CardResponse card : cards) {
                TransactionResponse transactionResponse = transferService.getAllTransactionsByContractName(card.contractName());
                transactions.add(transactionResponse.transactions());
            }

            model.addAttribute("transactions", transactions.stream().flatMap(Collection::stream).toList());
            model.addAttribute("cards", cards);
            model.addAttribute("activePage", "history");
            model.addAttribute("currentTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm")));

            return "transfers-history";

        } catch (Exception e) {
            log.error("Error loading history", e);
            model.addAttribute("error", "Ошибка загрузки истории операций: " + e.getMessage());
            return "error/error";
        }
    }
}