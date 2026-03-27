package com.technokratos.user_restriction_service.controller;

import com.technokratos.user_restriction_service.service.UserRestrictionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/restrictions")
public class RestrictionController {

    private final UserRestrictionService userRestrictionService;

    @GetMapping("/{id}")
    public String getRestrictionPage(@PathVariable String id, Model model) {
        model.addAttribute("restriction", userRestrictionService.getUserRestrictionInfo(id));
        return "restriction";
    }
}
