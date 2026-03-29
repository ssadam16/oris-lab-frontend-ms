package com.technokratos.user_restriction_service.filter;

import com.technokratos.user_restriction_service.dto.UserRestrictionResponse;
import com.technokratos.user_restriction_service.enums.Restriction;
import com.technokratos.user_restriction_service.service.UserRestrictionService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.util.AntPathMatcher;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class CheckRestrictionsFilter extends OncePerRequestFilter {

    private final UserRestrictionService userRestrictionService;

    private final AntPathMatcher pathMatcher = new AntPathMatcher();

    private final Map<Restriction, List<String>> endpointRestrictions = Map.of(
            Restriction.PARTICULAR, List.of("/cards/open"),
            Restriction.TOTAL, List.of("/cards/open", "/cards/{cardId}", "/transfer")
    );

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

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
        List<String> patterns = endpointRestrictions.getOrDefault(restriction, List.of());

        String requestUri = request.getRequestURI();
        String method = request.getMethod();

        boolean isRestricted = patterns.stream()
                .anyMatch(pattern -> pathMatcher.match(pattern, requestUri));

        if (isRestricted && !method.equals("GET")) {
            throw ForbiddenActionException.byUserId(userId, restriction);
        }

        filterChain.doFilter(request, response);
    }
}