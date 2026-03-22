package com.technokratos.user_service.controller;

import com.technokratos.user_service.dto.UserDataLoginRequest;
import com.technokratos.user_service.dto.UserDataTokenResponse;
import com.technokratos.user_service.dto.UserDataUserRequest;
import com.technokratos.user_service.dto.UserDataUserResponse;
import com.technokratos.user_service.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;


    @GetMapping("/sign-up")
    public String signUpPage() {
        return "/sign-up";
    }

    @GetMapping("/sign-in")
    public String signInPage() {
        return "/sign-in";
    }

    @PostMapping
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

        return "redirect:/profile";
    }



}
