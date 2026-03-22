package com.technokratos.user_service.service;

import com.technokratos.user_service.dto.*;
import java.util.List;
import java.util.UUID;

public interface UserService {

    UserDataUserResponse findById(UUID id);

    List<UserDataUserResponse> findAll();

    void deleteById(UUID id);

    UserDataUserResponse signUp(UserDataUserRequest signUpRequest);

    UserDataTokenResponse signIn(UserDataLoginRequest loginRequest);

    UserDataTokenValidationResponse validateToken(String token);
}