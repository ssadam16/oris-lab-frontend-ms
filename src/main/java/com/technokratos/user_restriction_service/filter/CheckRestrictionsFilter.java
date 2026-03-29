package com.technokratos.user_restriction_service.filter;

import com.technokratos.user_restriction_service.enums.Restriction;
import com.technokratos.user_restriction_service.service.UserRestrictionService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class CheckRestrictionsFilter extends OncePerRequestFilter {

    private final UserRestrictionService userRestrictionService;

    private final Map<Restriction, List<String>> endpointRestrictions = Map.of(
            Restriction.PARTICULAR, List.of("/cards/open"),
            Restriction.TOTAL, List.of("/cards/open", "/cards/{cardId}", "/transfer")
    );

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String requestUri = request.getRequestURI();

        UUID userId = (UUID) request.getSession().getAttribute("userId");
        Restriction userRestriction = userRestrictionService.getUserRestrictionInfo(String.valueOf(userId)).blockType();

        if (userRestriction != null) {
            if (endpointRestrictions.get(userRestriction).contains(requestUri) && !request.getMethod().equals("GET")) {
                throw ForbiddenActionException.byUserId(userId, userRestriction);
            }
        }

        filterChain.doFilter(request, response);
    }
}
