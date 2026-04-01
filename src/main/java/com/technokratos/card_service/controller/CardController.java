package com.technokratos.card_service.controller;

import com.technokratos.card_service.dto.CardProductResponse;
import com.technokratos.card_service.dto.CardRequest;
import com.technokratos.card_service.dto.CardResponse;
import com.technokratos.card_service.dto.TransactionResponse;
import com.technokratos.card_service.service.CardService;
import com.technokratos.transfer_service.service.TransferService;
import com.technokratos.user_service.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RequestMapping("/cards")
@RequiredArgsConstructor
@Controller
@Slf4j
public class CardController {

    private final CardService cardService;
    private final UserService userService;
    private final TransferService transferService;

    @GetMapping
    public String cardsPage(HttpSession session, Model model) {
        UUID userId = (UUID) session.getAttribute("userId");
        List<CardResponse> cards = cardService.getAllUserCards(userId);
        List<CardResponse> cardsWithBalance = new ArrayList<>();

        for (CardResponse card : cards) {
            BigDecimal balance = transferService.getContractByName(card.contractName()).balance();
            CardResponse updatedCard = new CardResponse(
                    card.id(),
                    card.userId(),
                    card.plasticName(),
                    card.contractName(),
                    card.pan(),
                    card.expDate(),
                    card.cvv(),
                    balance,
                    card.openDocumentId(),
                    card.closeDocumentId(),
                    card.cardProduct(),
                    card.closeFlag()
            );
            cardsWithBalance.add(updatedCard);
        }

        model.addAttribute("cards", cardsWithBalance);
        model.addAttribute("activePage", "cards");

        return "cards";
    }

    // Страница открытия новой карты
    @GetMapping("/open")
    public String openCardPage(Model model) {
        List<CardProductResponse> products = cardService.getAllCardProducts();
        model.addAttribute("products", products);
        model.addAttribute("activePage", "cards");
        return "open-card";
    }

    // Открытие новой карты
    @PostMapping("/open")
    public String openCard(@RequestParam(name = "cardProductId") UUID cardProductId,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        UUID userId = (UUID) session.getAttribute("userId");


        CardRequest request = new CardRequest(cardProductId, userId);
        CardResponse card = cardService.openNewCardForUser(request);

        redirectAttributes.addFlashAttribute("success",
                "Карта \"" + card.plasticName() + "\" успешно открыта!");
        return "redirect:/cards";
    }

    // Страница деталей карты
    @GetMapping("/{cardId}")
    public String cardDetails(
            @PathVariable(name = "cardId") UUID cardId,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        UUID userId = (UUID) session.getAttribute("userId");

        CardResponse card = cardService.getCardInfoByCardId(cardId);

        if (!card.userId().equals(userId)) {
            redirectAttributes.addFlashAttribute("error", "Доступ запрещен");
            return "redirect:/cards";
        }

        model.addAttribute("card", card);
        model.addAttribute("user", userService.findById(userId));
        model.addAttribute("activePage", "cards");

        return "card-details";
    }


    // Закрытие карты
    @PostMapping("/{cardId}/close")
    public String closeCard(@PathVariable(name = "cardId") UUID cardId,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        UUID userId = (UUID) session.getAttribute("userId");

        CardResponse card = cardService.getCardInfoByCardId(cardId);

        if (!card.userId().equals(userId)) {
            redirectAttributes.addFlashAttribute("error", "Доступ запрещен");
            return "redirect:/cards";
        }

        cardService.closeCard(cardId);
        redirectAttributes.addFlashAttribute("success",
                "Карта \"" + card.plasticName() + "\" успешно закрыта");
        return "redirect:/cards";
    }


    @GetMapping("/statement")
    public String getStatement(
            @RequestParam(name = "contractName") String contractName,
            @RequestParam(name = "from") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(name = "to") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to,
            Model model
    ) {

        ZoneId zoneId = ZoneId.systemDefault();
        Instant fromInstant = from.atZone(zoneId).toInstant();
        Instant toInstant = to.atZone(zoneId).toInstant();

        TransactionResponse statement = cardService.getCardStatementForPeriod(contractName, fromInstant, toInstant);

        log.info(statement.contractName());

        model.addAttribute("cardStatement", statement);
        model.addAttribute("contractName", contractName);
        model.addAttribute("from", from);
        model.addAttribute("to", to);

        return "card-statement";
    }
}