package com.technokratos.document_service.controller;

import com.technokratos.card_service.dto.CardResponse;
import com.technokratos.card_service.service.CardService;
import com.technokratos.document_service.dto.DocumentResponse;
import com.technokratos.document_service.service.DocumentService;
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
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/documents")
@RequiredArgsConstructor
@Slf4j
public class DocumentController {

    private final CardService cardService;
    private final TransferService transferService;
    private final DocumentService documentService;

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

            DocumentResponse document = documentService.getById(card.openDocumentId());

            log.info(document.toString());

            model.addAttribute("card", card);
            model.addAttribute("document", document);

            return "document-card-opening";

        } catch (Exception e) {
            log.error("Error generating card opening document for cardId: {}", cardId, e);
            redirectAttributes.addFlashAttribute("error", "Не удалось сформировать документ об открытии карты");
            return "redirect:/cards/%s".formatted(cardId);
        }
    }

    @GetMapping("/card-closing/{cardId}")
    public String cardClosingDocument(@PathVariable(name = "cardId") UUID cardId,
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

            if (!card.closeFlag()) {
                redirectAttributes.addFlashAttribute("error", "Документ о закрытии доступен только для закрытых карт");
                return "redirect:/cards";
            }

            model.addAttribute("card", card);

            DocumentResponse documentClosing = documentService.getById(card.closeDocumentId());
            DocumentResponse documentOpening = documentService.getById(card.openDocumentId());

            model.addAttribute("usagePeriod", Duration.between(documentOpening.createdDate(), Instant.now()).toDays());


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
            model.addAttribute("document", documentClosing);
            model.addAttribute("openingDate", documentOpening.createdDate());

            return "document-card-closing";

        } catch (Exception e) {
            log.error("Error generating card closing document for cardId: {}", cardId, e);
            redirectAttributes.addFlashAttribute("error", "Не удалось сформировать документ о закрытии карты: " + e.getMessage());
            return "redirect:/cards";
        }
    }
}