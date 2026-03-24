package com.technokratos.user_service.controller;

import com.technokratos.card_service.dto.CardResponse;
import com.technokratos.card_service.service.CardService;
import com.technokratos.user_service.dto.UserDataLoginRequest;
import com.technokratos.user_service.dto.UserDataTokenResponse;
import com.technokratos.user_service.dto.UserDataUserRequest;
import com.technokratos.user_service.dto.UserDataUserResponse;
import com.technokratos.user_service.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@Controller
@Slf4j
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final CardService cardService;

    @GetMapping("/sign-up")
    public String signUpPage() {
        return "sign-up";
    }

    @GetMapping("/sign-in")
    public String signInPage() {
        return "sign-in";
    }

    @PostMapping("/sign-up")
    public String signUp(@ModelAttribute UserDataUserRequest signUpRequest, Model model) {

        UserDataUserResponse userResponse = userService.signUp(signUpRequest);

        model.addAttribute("message", "Регистрация успешна!");
        model.addAttribute("userResponse", userResponse);
        return "redirect:/sign-in";
    }

    @PostMapping("/sign-in")
    public String signIn(
            @ModelAttribute UserDataLoginRequest loginRequest,
            HttpSession session
    ) {

        UserDataTokenResponse tokenResponse = userService.signIn(loginRequest);

        session.setAttribute("token", tokenResponse.accessToken());
        session.setAttribute("userId", tokenResponse.userId());

        return "redirect:/profile";
    }


    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("activePage", "home");
        return "index";
    }

    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        UUID userId = (UUID) session.getAttribute("userId");

        UserDataUserResponse user = userService.findById(userId);

        List<CardResponse> cards = cardService.getAllUserCards(userId);

        log.info("User {} loaded with {} cards", user.id(), cards.size());

        model.addAttribute("user", user);
        model.addAttribute("cards", cards);
        model.addAttribute("activePage", "profile");

        return "profile";
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "index";
    }
}