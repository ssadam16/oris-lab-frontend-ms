package com.technokratos.user_service.filter;

import com.technokratos.user_service.dto.UserDataTokenValidationResponse;
import com.technokratos.user_service.service.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@RequiredArgsConstructor
@Slf4j
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


        Object tokenObj = session.getAttribute("token");
        String token = tokenObj != null ? tokenObj.toString() : null;

        boolean tokenIsNull = token == null;

        if (isPublicUrl(path, method)) {
            filterChain.doFilter(request, response);
            return;
        }

        if (!tokenIsNull) {

            UserDataTokenValidationResponse validationResponse = userService.validateToken(token);
            if (validationResponse.validToken()) {
                filterChain.doFilter(request, response);
            } else {
                log.warn("Token is not valid {}", token);
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
