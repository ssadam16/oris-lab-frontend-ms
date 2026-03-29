<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Вход — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .auth-container {
            max-width: 420px;
            margin: 80px auto;
            padding: 0 20px;
        }
        .auth-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.12);
            overflow: hidden;
        }
        .auth-header {
            background: linear-gradient(135deg, #2563eb, #1e40af);
            color: white;
            padding: 48px 40px 40px;
            text-align: center;
        }
        .auth-header h2 {
            margin: 0;
            font-size: 2rem;
            font-weight: 700;
        }
        .auth-body {
            padding: 50px 40px 40px;
        }
        .form-label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 10px;
            display: block;
        }
        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 14px;
            font-size: 1.05rem;
            transition: all 0.3s;
        }
        .form-control:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.15);
        }
        .btn-login {
            width: 100%;
            padding: 16px;
            font-size: 1.15rem;
            font-weight: 600;
            border-radius: 14px;
            background: linear-gradient(135deg, #2563eb, #1e40af);
            color: white;
            border: none;
            cursor: pointer;
            margin-top: 20px;
            transition: all 0.3s;
        }
        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(37, 99, 235, 0.35);
        }
        .alert {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<div class="auth-container">
    <div class="auth-card">
        <div class="auth-header">
            <h2>Добро пожаловать обратно</h2>
            <p style="margin-top: 8px; opacity: 0.9;">Войдите в свой аккаунт TechnoBank</p>
        </div>

        <div class="auth-body">
            <#if error??>
                <div class="alert" style="background:#fee2e2; color:#991b1b;">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </#if>

            <#if message??>
                <div class="alert" style="background:#d1fae5; color:#166534;">
                    <i class="fas fa-check-circle"></i> ${message}
                </div>
            </#if>

            <form action="/sign-in" method="POST" id="loginForm">
                <div style="margin-bottom: 28px;">
                    <label class="form-label">Телефон</label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           class="form-control"
                           value="${(phone)!''}"
                           placeholder="+7 (999) 123-45-67"
                           required>
                </div>

                <div style="margin-bottom: 28px;">
                    <label class="form-label">Пароль</label>
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control"
                           placeholder="••••••••"
                           required>
                </div>

                <button type="submit" class="btn-login">
                    <i class="fas fa-sign-in-alt"></i> Войти
                </button>
            </form>

            <div style="text-align: center; margin-top: 32px;">
                <a href="/sign-up" style="color: #2563eb; text-decoration: none; font-weight: 500;">
                    Нет аккаунта? Зарегистрироваться
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const phone = document.getElementById('phone').value.trim();
        const password = document.getElementById('password').value.trim();

        if (!phone) {
            alert('Введите номер телефона');
            e.preventDefault();
            return;
        }
        if (!password) {
            alert('Введите пароль');
            e.preventDefault();
        }
    });
</script>
</body>
</html>