package com.technokratos.card_service.controller;

import com.technokratos.card_service.dto.CardProductResponse;
import com.technokratos.card_service.dto.CardRequest;
import com.technokratos.card_service.dto.CardResponse;
import com.technokratos.card_service.service.CardService;
import com.technokratos.user_service.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.UUID;

@RequestMapping("/cards")
@RequiredArgsConstructor
@Controller
@Slf4j
public class CardController {

    private final CardService cardService;
    private final UserService userService;

    @GetMapping
    public String cardsPage(HttpSession session, Model model) {
        UUID userId = (UUID) session.getAttribute("userId");
        List<CardResponse> cards = cardService.getAllUserCards(userId);
        List<CardProductResponse> products = cardService.getAllCardProducts();

        model.addAttribute("cards", cards);
        model.addAttribute("products", products);
        model.addAttribute("user", userService.findById(userId));
        model.addAttribute("activePage", "cards");

        return "cards";
    }

    // Страница открытия новой карты
    @GetMapping("/open")
    public String openCardPage(Model model) {

        try {
            List<CardProductResponse> products = cardService.getAllCardProducts();
            model.addAttribute("products", products);
            model.addAttribute("activePage", "cards");
            return "open-card";
        } catch (Exception e) {
            log.error("Error loading open card page", e);
            model.addAttribute("error", "Ошибка загрузки продуктов");
            return "error/500";
        }
    }

    // Открытие новой карты
    @PostMapping("/open")
    public String openCard(@RequestParam(name = "cardProductId") UUID cardProductId,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        UUID userId = (UUID) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/sign-in";
        }


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


//    // Получение выписки за период (AJAX)
//    @GetMapping("/{cardId}/statement")
//    @ResponseBody
//    public TransactionResponse getStatement(@PathVariable UUID cardId,
//                                            @RequestParam(name = "from") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
//                                            @RequestParam(name = "to") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to,
//                                            HttpSession session) {
//        UUID userId = (UUID) session.getAttribute("userId");
//        if (userId == null) {
//            throw new RuntimeException("Unauthorized");
//        }
//
//        CardResponse card = cardService.getCardInfoByCardId(cardId);
//        if (!card.userId().equals(userId)) {
//            throw new RuntimeException("Access denied");
//        }
//
//        return cardService.getCardStatementForPeriod(cardId, from, to);
//    }
}