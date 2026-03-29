<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Регистрация — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .auth-container {
            max-width: 460px;
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
        .btn-register {
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
        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(37, 99, 235, 0.35);
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<div class="auth-container">
    <div class="auth-card">
        <div class="auth-header">
            <h2>Создать аккаунт</h2>
            <p style="margin-top: 8px; opacity: 0.9;">Начните пользоваться TechnoBank за минуту</p>
        </div>

        <div class="auth-body">
            <form action="/sign-up" method="post">
                <div style="margin-bottom: 28px;">
                    <label class="form-label">ФИО</label>
                    <input type="text"
                           name="fio"
                           class="form-control"
                           placeholder="Иванов Иван Иванович"
                           required>
                </div>

                <div style="margin-bottom: 28px;">
                    <label class="form-label">Телефон</label>
                    <input type="tel"
                           name="phone"
                           class="form-control"
                           placeholder="+7 (999) 123-45-67"
                           required>
                    <small style="color: #64748b;">Формат: +7XXXXXXXXXX</small>
                </div>

                <div style="margin-bottom: 32px;">
                    <label class="form-label">Пароль</label>
                    <input type="password"
                           name="password"
                           class="form-control"
                           placeholder="Придумайте надёжный пароль"
                           required>
                </div>

                <button type="submit" class="btn-register">
                    <i class="fas fa-user-plus"></i> Зарегистрироваться
                </button>
            </form>

            <div style="text-align: center; margin-top: 32px;">
                <a href="/sign-in" style="color: #2563eb; text-decoration: none; font-weight: 500;">
                    Уже есть аккаунт? Войти
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>