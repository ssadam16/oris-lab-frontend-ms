package com.technokratos.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ExceptionController {

    @GetMapping("/error/403")
    public String handle403(HttpServletRequest request, Model model) {
        String errorMessage = (String) request.getAttribute("errorMessage");
        String exceptionName = (String) request.getAttribute("exceptionName");

        model.addAttribute("errorCode", 403);
        model.addAttribute("errorMessage", errorMessage != null ? errorMessage : "Доступ запрещен");
        model.addAttribute("exceptionName", exceptionName != null ? exceptionName : "ForbiddenActionException");

        return "error/403";
    }

}
