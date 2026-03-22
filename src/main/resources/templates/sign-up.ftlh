<#-- templates/sign-up.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Регистрация в TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="max-width: 500px; padding: 60px 0;">
        <div class="card">
            <div class="card-header">
                <h2>Регистрация</h2>
            </div>

            <#if message??>
                <div class="alert alert-success">
                    ${message}
                </div>
            </#if>

            <form action="/sign-up" method="post">
                <div class="form-group">
                    <label>ФИО</label>
                    <input type="text"
                           name="fio"
                           class="form-control"
                           placeholder="Иванов Иван Иванович"
                           required>
                </div>

                <div class="form-group">
                    <label>Телефон</label>
                    <input type="tel"
                           name="phone"
                           class="form-control"
                           placeholder="+7 (999) 999-99-99"
                           required>
                    <small style="color: var(--secondary);">Формат: +7XXXXXXXXXX или 8XXXXXXXXXX</small>
                </div>

                <div class="form-group">
                    <label>Пароль</label>
                    <input type="password"
                           name="password"
                           class="form-control"
                           placeholder="Придумайте пароль"
                           required>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    Зарегистрироваться
                </button>
            </form>

            <div style="text-align: center; margin-top: 20px;">
                <a href="/sign-in" style="color: var(--primary); text-decoration: none;">
                    Уже есть аккаунт? Войти
                </a>
            </div>
        </div>
    </div>
</main>
</body>
</html>