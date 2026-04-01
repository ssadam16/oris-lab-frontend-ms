package com.technokratos.user_restriction_service.filter;

import com.technokratos.user_restriction_service.dto.UserRestrictionResponse;
import com.technokratos.user_restriction_service.enums.Restriction;
import com.technokratos.user_restriction_service.service.UserRestrictionService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.util.AntPathMatcher;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;


@Slf4j
@RequiredArgsConstructor
@Component
@Order(2)
public class CheckRestrictionsFilter extends OncePerRequestFilter {

    private final UserRestrictionService userRestrictionService;
    private final AntPathMatcher pathMatcher = new AntPathMatcher();

    // PARTICULAR блокирует только создание карт
    private final List<String> particularRestrictedEndpoints = List.of("/cards/open");

    // Эндпоинты, которые даже при TOTAL должны быть доступны (например, logout, error)
    // Если TOTAL должен блокировать ВСЕ без исключений, то оставьте этот список пустым
    private final List<String> whitelistEndpoints = List.of(
            "/error/**",
            "/logout",
            "/"
            // Добавьте сюда другие публичные эндпоинты, если нужно
    );

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        try {
            UUID userId = (UUID) request.getSession().getAttribute("userId");

            if (userId == null) {
                filterChain.doFilter(request, response);
                return;
            }

            UserRestrictionResponse info = userRestrictionService.getUserRestrictionInfo(userId.toString());

            if (info == null || info.blockType() == null) {
                filterChain.doFilter(request, response);
                return;
            }

            Restriction restriction = info.blockType();
            String requestUri = request.getRequestURI();
            String method = request.getMethod();

            log.debug("User with id: {} has restriction type: {}, URI: {}, Method: {}",
                    userId, restriction, requestUri, method);

            // TOTAL - блокируем ВСЕ запросы
            if (restriction == Restriction.TOTAL) {
                // Проверяем, не находится ли запрос в белом списке (если нужно)
                if (isWhitelisted(requestUri)) {
                    log.debug("Whitelisted endpoint for TOTAL restriction: {}", requestUri);
                    filterChain.doFilter(request, response);
                    return;
                }

                // Блокируем любой запрос
                log.warn("User with id: {} has TOTAL restriction - blocking access to: {} {}",
                        userId, method, requestUri);

                request.setAttribute("errorMessage",
                        "Your account is fully restricted. Access denied for User (ID=" + userId + ")");
                request.setAttribute("exceptionName", "ForbiddenActionException");

                response.sendRedirect(request.getContextPath() + "/error/403");
                return; // Выходим, не вызывая filterChain.doFilter()
            }

            // PARTICULAR - блокируем только создание карт (не-GET запросы к /cards/open)
            if (restriction == Restriction.PARTICULAR) {
                boolean isCardCreation = particularRestrictedEndpoints.stream()
                        .anyMatch(pattern -> pathMatcher.match(pattern, requestUri));

                // Блокируем только НЕ-GET запросы к эндпоинтам создания карт
                if (isCardCreation && !method.equals("GET")) {
                    log.warn("User with id: {} has PARTICULAR restriction - blocking card creation: {} {}",
                            userId, method, requestUri);

                    request.setAttribute("errorMessage",
                            "Card creation is not allowed for User (ID=" + userId + "), due to Restriction=" + restriction);
                    request.setAttribute("exceptionName", "ForbiddenActionException");

                    response.sendRedirect(request.getContextPath() + "/error/403");
                    return;
                }
            }

            // Если блокировка не сработала - пропускаем запрос дальше
            filterChain.doFilter(request, response);

        } catch (Exception e) {
            log.error("Error in filter", e);
            request.setAttribute("errorMessage", "Произошла ошибка при проверке доступа");
            request.getRequestDispatcher("/error/error").forward(request, response);
        }
    }

    private boolean isWhitelisted(String requestUri) {
        return whitelistEndpoints.stream()
                .anyMatch(pattern -> pathMatcher.match(pattern, requestUri));
    }
}