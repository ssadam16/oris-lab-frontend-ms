package com.technokratos.document_service.controller;

import com.technokratos.card_service.dto.CardResponse;
import com.technokratos.card_service.service.CardService;
import com.technokratos.transfer_service.dto.ContractResponse;
import com.technokratos.transfer_service.service.TransferService;
import com.technokratos.user_service.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Controller
@RequestMapping("/documents")
@RequiredArgsConstructor
@Slf4j
public class DocumentController {

    private final CardService cardService;
    private final TransferService transferService;

    @GetMapping
    public String documentsPage(Model model) {
        model.addAttribute("activePage", "documents");
        return "documents";
    }

    // Документ об открытии карты
    @GetMapping("/card-opening/{cardId}")
    public String cardOpeningDocument(@PathVariable(name = "cardId") UUID cardId,
                                      HttpSession session,
                                      Model model,
                                      RedirectAttributes redirectAttributes) {
        UUID userId = (UUID) session.getAttribute("userId");

        try {
            CardResponse card = cardService.getCardInfoByCardId(cardId);

            if (!card.userId().equals(userId)) {
                redirectAttributes.addFlashAttribute("error", "Доступ запрещён");
                return "redirect:/cards";
            }

            model.addAttribute("card", card);

            return "document-card-opening";

        } catch (Exception e) {
            log.error("Error generating card opening document for cardId: {}", cardId, e);
            redirectAttributes.addFlashAttribute("error", "Не удалось сформировать документ об открытии карты");
            return "redirect:/cards/" + cardId;
        }
    }

    @GetMapping("/card-closing/{cardId}")
    public String cardClosingDocument(@PathVariable(name = "cardId") UUID cardId,
                                      HttpSession session,
                                      Model model,
                                      RedirectAttributes redirectAttributes) {
        UUID userId = (UUID) session.getAttribute("userId");

        if (userId == null) {
            redirectAttributes.addFlashAttribute("error", "Необходимо войти в систему");
            return "redirect:/sign-in";
        }

        try {
            CardResponse card = cardService.getCardInfoByCardId(cardId);

            // Проверяем, что карта принадлежит пользователю
            if (!card.userId().equals(userId)) {
                redirectAttributes.addFlashAttribute("error", "Доступ запрещён");
                return "redirect:/cards";
            }

            // Проверяем, что карта действительно закрыта
            if (!card.closeFlag()) {
                redirectAttributes.addFlashAttribute("error", "Документ о закрытии доступен только для закрытых карт");
                return "redirect:/cards";
            }

            // Добавляем дополнительные данные для документа
            model.addAttribute("card", card);

            // Рассчитываем срок использования карты
            if (card.openDocumentId() != null) {
                // Если есть дата открытия, можно добавить логику расчета
                // Например, получить дату открытия из другого сервиса
                model.addAttribute("usagePeriod", "Более 30 дней"); // Временное значение
            } else {
                model.addAttribute("usagePeriod", "Неизвестно");
            }

            // Остаток на момент закрытия - можно получить из transferService
            try {
                ContractResponse contract = transferService.getContractByName(card.contractName());
                BigDecimal closingBalance = contract != null ? contract.balance() : BigDecimal.ZERO;
                model.addAttribute("closingBalance", String.format("%,.2f", closingBalance));
            } catch (Exception e) {
                log.warn("Could not fetch closing balance for card: {}", card.contractName(), e);
                model.addAttribute("closingBalance", "0.00");
            }

            model.addAttribute("currentDate", LocalDateTime.now());
            model.addAttribute("activePage", "cards");

            return "document-card-closing";

        } catch (Exception e) {
            log.error("Error generating card closing document for cardId: {}", cardId, e);
            redirectAttributes.addFlashAttribute("error", "Не удалось сформировать документ о закрытии карты: " + e.getMessage());
            return "redirect:/cards";
        }
    }

    // Чек по переводу (пока заглушка, можно расширить позже)
    @GetMapping("/transfer")
    public String transferDocument(
            @RequestParam(required = false, name = "amount") String amount,
            @RequestParam(required = false, name = "source") String source,
            @RequestParam(required = false, name = "target") String target,
            @RequestParam(required = false, name = "description") String description,
            Model model) {

        model.addAttribute("amount", amount != null ? amount : "0.00");
        model.addAttribute("sourceCardName", source != null ? source : "Ваша карта");
        model.addAttribute("targetContractName", target != null ? target : "Карта получателя");
        model.addAttribute("description", description != null ? description : "Без комментария");

        return "document-transfer";
    }

}