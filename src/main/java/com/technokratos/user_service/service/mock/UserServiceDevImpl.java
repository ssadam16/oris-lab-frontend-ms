package com.technokratos.user_service.service.mock;

import com.technokratos.user_service.dto.*;
import com.technokratos.user_service.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
@Profile("prod")
@Slf4j
public class UserServiceDevImpl implements UserService {

    private final Map<UUID, UserDataUserResponse> userDatabase = new ConcurrentHashMap<>();
    private final Map<String, UserDataTokenResponse> tokenDatabase = new ConcurrentHashMap<>();

    public UserServiceDevImpl() {
        initMockData();
    }

    private void initMockData() {
        UUID testUserId = UUID.fromString("2e1eb3a4-cc06-4396-b6fa-e691a9a21bb3");

        UserDataUserResponse testUser = UserDataUserResponse.builder()
                .id(testUserId)
                .phone("+79001234567")
                .fio("Бутат Бутерат")
                .build();

        userDatabase.put(testUserId, testUser);

        log.info("Mock UserService initialized with test user: {}", testUserId);
    }

    @Override
    public UserDataUserResponse findById(UUID id) {
        log.info("MOCK: Finding user by id: {}", id);

        UserDataUserResponse user = userDatabase.get(id);
        if (user == null) {
            log.warn("MOCK: User not found with id: {}", id);
            throw new RuntimeException("User not found with id: " + id);
        }

        return user;
    }

    @Override
    public List<UserDataUserResponse> findAll() {
        log.info("MOCK: Finding all users");
        return new ArrayList<>(userDatabase.values());
    }

    @Override
    public void deleteById(UUID id) {
        log.info("MOCK: Deleting user by id: {}", id);

        UserDataUserResponse removed = userDatabase.remove(id);
        if (removed == null) {
            log.warn("MOCK: User not found for deletion with id: {}", id);
            throw new RuntimeException("User not found with id: " + id);
        }

        log.info("MOCK: User deleted successfully: {}", removed.phone());
    }

    @Override
    public UserDataUserResponse signUp(UserDataUserRequest signUpRequest) {
        log.info("MOCK: Signing up user with phone: {}", signUpRequest.phone());

        UUID newUserId = UUID.randomUUID();
        UserDataUserResponse newUser = UserDataUserResponse.builder()
                .id(newUserId)
                .phone(signUpRequest.phone())
                .fio(signUpRequest.fio())
                .build();

        userDatabase.put(newUserId, newUser);
        log.info("MOCK: User created successfully with id: {}", newUserId);

        return newUser;
    }

    @Override
    public UserDataTokenResponse signIn(UserDataLoginRequest loginRequest) {
        log.info("MOCK: Signing in user with phone: {}", loginRequest.phone());

        // Поиск пользователя по телефону
        UserDataUserResponse user = userDatabase.values().stream()
                .filter(u -> u.phone().equals(loginRequest.phone()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("User not found with phone: " + loginRequest.phone()));

        // Проверка пароля (в моке принимаем любой пароль)
        log.info("MOCK: Password validation skipped for mock");

        // Генерация mock токена
        String mockToken = UUID.randomUUID().toString();
        UserDataTokenResponse tokenResponse = new UserDataTokenResponse(mockToken, user.id());

        tokenDatabase.put(mockToken, tokenResponse);
        log.info("MOCK: User signed in successfully: {}", user.phone());

        return tokenResponse;
    }

    @Override
    public UserDataTokenValidationResponse validateToken(String token) {
        log.info("MOCK: Validating token: {}", token);

        UserDataTokenResponse tokenResponse = tokenDatabase.get(token);

        if (tokenResponse == null) {
            log.warn("MOCK: Invalid token: {}", token);
            return new UserDataTokenValidationResponse(false);
        }

        log.info("MOCK: Token is valid");
        return new UserDataTokenValidationResponse(true);
    }
}