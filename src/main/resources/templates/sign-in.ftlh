<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Вход в TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        /* Дополнительные стили для ошибок */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-error {
            background-color: #fee2e2;
            border-left: 4px solid #dc2626;
            color: #991b1b;
        }

        .alert-error::before {
            content: "⚠️";
            font-size: 16px;
        }

        .alert-success {
            background-color: #e6f4ea;
            border-left: 4px solid #16a34a;
            color: #166534;
        }

        .alert-success::before {
            content: "✓";
            font-weight: bold;
            font-size: 18px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #374151;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-control.error {
            border-color: #dc2626;
            background-color: #fef2f2;
        }

        .error-message {
            color: #dc2626;
            font-size: 12px;
            margin-top: 4px;
            display: block;
        }

        .btn-primary {
            background-color: #2563eb;
            color: white;
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.2s;
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .card-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e5e7eb;
        }

        .card-header h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
            color: #111827;
        }

        form {
            padding: 24px;
        }

        .form-footer {
            margin-top: 20px;
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
        }

        .form-footer a {
            color: #2563eb;
            text-decoration: none;
            font-size: 14px;
        }

        .form-footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<#include "fragments/header.ftlh">

<main>
    <div class="container" style="max-width: 400px; padding: 60px 0;">
        <div class="card">
            <div class="card-header">
                <h2>Вход в систему</h2>
            </div>

            <!-- Разные типы ошибок -->
            <#if error??>
                <div style="padding: 0 24px;">
                    <div class="alert alert-error">
                        ${error}
                    </div>
                </div>
            </#if>

            <#if message??>
                <div style="padding: 0 24px;">
                    <div class="alert alert-success">
                        ${message}
                    </div>
                </div>
            </#if>

            <form action="/sign-in" method="POST" id="loginForm">
                <div class="form-group">
                    <label for="phone">Телефон</label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           class="form-control ${(phoneError??)?then('error', '')}"
                           value="${(phone)!''}"
                           placeholder="+7 (999) 999-99-99"
                           required>
                    <#if phoneError??>
                        <span class="error-message">${phoneError}</span>
                    </#if>
                </div>

                <div class="form-group">
                    <label for="password">Пароль</label>
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control ${(passwordError??)?then('error', '')}"
                           placeholder="••••••••"
                           required>
                    <#if passwordError??>
                        <span class="error-message">${passwordError}</span>
                    </#if>
                </div>

                <button type="submit" class="btn-primary">
                    Войти
                </button>

                <div class="form-footer">
                    <a href="/sign-up">Нет аккаунта? Зарегистрироваться</a>
                </div>
            </form>
        </div>
    </div>
</main>

<script>
    // Клиентская валидация
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const phone = document.getElementById('phone').value;
        const password = document.getElementById('password').value;
        let hasError = false;

        // Очищаем предыдущие ошибки
        document.querySelectorAll('.error-message').forEach(el => el.remove());
        document.querySelectorAll('.form-control').forEach(el => el.classList.remove('error'));

        // Валидация телефона
        const phoneRegex = /^\+7\s?\(?[0-9]{3}\)?\s?[0-9]{3}-?[0-9]{2}-?[0-9]{2}$/;
        if (!phone.trim()) {
            showError('phone', 'Введите номер телефона');
            hasError = true;
        } else if (!phoneRegex.test(phone) && !/^[0-9]{10,11}$/.test(phone.replace(/\D/g, ''))) {
            showError('phone', 'Введите корректный номер телефона');
            hasError = true;
        }

        // Валидация пароля
        if (!password.trim()) {
            showError('password', 'Введите пароль');
            hasError = true;
        } else if (password.length < 4) {
            showError('password', 'Пароль должен содержать минимум 4 символа');
            hasError = true;
        }

        if (hasError) {
            e.preventDefault();
        }
    });

    function showError(fieldId, message) {
        const field = document.getElementById(fieldId);
        field.classList.add('error');

        const errorSpan = document.createElement('span');
        errorSpan.className = 'error-message';
        errorSpan.textContent = message;

        field.parentNode.appendChild(errorSpan);
    }
</script>

</body>
</html>