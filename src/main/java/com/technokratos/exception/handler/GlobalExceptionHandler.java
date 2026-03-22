package com.technokratos.exception.handler;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClientException;

import java.time.LocalDateTime;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    // 404 Not Found
    @ExceptionHandler(HttpClientErrorException.NotFound.class)
    public String handleNotFound(HttpClientErrorException.NotFound ex, Model model) {
        log.warn("Resource not found in downstream service: {}", ex.getMessage());

        model.addAttribute("errorCode", "404");
        model.addAttribute("errorMessage", "Запрашиваемый ресурс не найден");
        model.addAttribute("details", ex.getMessage());
        model.addAttribute("timestamp", LocalDateTime.now());

        return "error/404"; // путь к вашему view
    }

    // 400 Bad Request
    @ExceptionHandler(HttpClientErrorException.BadRequest.class)
    public String handleBadRequest(HttpClientErrorException.BadRequest ex, Model model) {
        log.warn("Bad request to downstream service: {}", ex.getMessage());

        model.addAttribute("errorCode", "400");
        model.addAttribute("errorMessage", "Некорректный запрос");
        model.addAttribute("details", ex.getResponseBodyAsString());
        model.addAttribute("timestamp", LocalDateTime.now());

        return "error/400";
    }

    // 401/403 ошибки авторизации
    @ExceptionHandler({HttpClientErrorException.Unauthorized.class,
            HttpClientErrorException.Forbidden.class})
    public String handleAuthErrors(HttpClientErrorException ex, Model model) {
        log.warn("Authentication/Authorization error: {}", ex.getMessage());

        model.addAttribute("errorCode", ex.getStatusCode().value());
        model.addAttribute("errorMessage", "Ошибка доступа");
        model.addAttribute("details", "У вас нет прав для просмотра этой страницы");
        model.addAttribute("timestamp", LocalDateTime.now());

        return "error/403";
    }

    // Другие 4xx ошибки
    @ExceptionHandler(HttpClientErrorException.class)
    public String handleOtherClientErrors(HttpClientErrorException ex, Model model) {
        log.error("Client error from downstream service: {} - {}",
                ex.getStatusCode(), ex.getMessage());

        model.addAttribute("errorCode", ex.getStatusCode().value());
        model.addAttribute("errorMessage", "Ошибка при обращении к сервису");
        model.addAttribute("details", "Сервис временно недоступен");
        model.addAttribute("timestamp", LocalDateTime.now());

        return "error/4xx";
    }

    // 5xx ошибки
    @ExceptionHandler(HttpServerErrorException.class)
    public String handleServerErrors(HttpServerErrorException ex, Model model) {
        log.error("Server error from downstream service: {} - {}",
                ex.getStatusCode(), ex.getMessage());

        model.addAttribute("errorCode", "503");
        model.addAttribute("errorMessage", "Сервис временно недоступен");
        model.addAttribute("details", "Ведутся технические работы");
        model.addAttribute("timestamp", LocalDateTime.now());

        return "error/503";
    }

    // Таймауты
    @ExceptionHandler(ResourceAccessException.class)
    public String handleResourceAccessException(ResourceAccessException ex, Model model) {
        log.error("Connection error to downstream service: {}", ex.getMessage());

        model.addAttribute("errorCode", "504");
        model.addAttribute("errorMessage", "Сервис не отвечает");
        model.addAttribute("details", "Превышено время ожидания ответа от сервиса");
        model.addAttribute("timestamp", LocalDateTime.now());

        return "error/504";
    }

    // Все остальные RestClientException
    @ExceptionHandler(RestClientException.class)
    public String handleRestClientException(RestClientException ex, Model model) {
        log.error("Error calling downstream service: {}", ex.getMessage());

        model.addAttribute("errorCode", "500");
        model.addAttribute("errorMessage", "Внутренняя ошибка сервера");
        model.addAttribute("details", "Ошибка при обращении к сервису");
        model.addAttribute("timestamp", LocalDateTime.now());

        return "error/500";
    }

    @ExceptionHandler(Exception.class)
    public String handleException(Exception ex, Model model) {
        log.error("Exception: {}", ex.getMessage());

        model.addAttribute("errorCode", "500");
        model.addAttribute("errorMessage", "Ошибка сервера");
        model.addAttribute("details", ex.getCause());
        model.addAttribute("timestamp", LocalDateTime.now());

        return "error/500";
    }
}