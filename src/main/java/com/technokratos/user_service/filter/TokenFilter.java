package com.technokratos.user_service.filter;

import com.technokratos.user_service.dto.UserDataTokenValidationResponse;
import com.technokratos.user_service.service.UserService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@Slf4j
@Order(1)
@Component
public class TokenFilter implements Filter {

    private final UserService userService;

    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/sign-in",
            "/sign-up",
            "/",
            "/css/",
            "/js/",
            "/images/"
    );

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        HttpSession session = request.getSession();

        String path = request.getRequestURI();
        String method = request.getMethod();

        log.info("User want to get {} resource, method {}", path, method);


        Object token = session.getAttribute("token");

        log.info("User access token: {}", token);

        if (isPublicUrl(path, method)) {
            filterChain.doFilter(request, response);
            return;
        }

        if (token != null) {

            UserDataTokenValidationResponse validationResponse = userService.validateToken(token.toString());
            if (validationResponse.validToken()) {
                log.debug("Token is valid: {}", token);
                filterChain.doFilter(request, response);
            } else {
                log.warn("Token is not valid: {}", token);
                response.setStatus(401);
                response.sendRedirect("/sign-in");
            }
        } else {
            response.setStatus(401);
            response.sendRedirect("/sign-in");
        }
    }

    private boolean isPublicUrl(String path, String method) {
        return PUBLIC_URLS.stream().anyMatch(publicUrl ->
                path.equals(publicUrl) ||
                        path.startsWith(publicUrl)
        );
    }
}
