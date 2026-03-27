package com.technokratos.exception.handler;

import com.technokratos.exception.ServiceException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClientException;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.Date;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    // 404 Not Found
    @ExceptionHandler(ServiceException.class)
    public String handleServiceException(ServiceException e, Model model) {
        log.error("Service exception: {}", e.getMessage());

        model.addAttribute("errorCode", e.getHttpStatus());
        model.addAttribute("exceptionName", e.getClass().getSimpleName());
        model.addAttribute("errorMessage", e.getMessage());

        return "error/error";
    }


    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model) {
        log.error("Exception: {}", e.getMessage());

        model.addAttribute("errorCode", 500);
        model.addAttribute("exceptionName", e.getClass().getSimpleName());
        model.addAttribute("errorMessage", e.getMessage());

        return "error/error";
    }
}