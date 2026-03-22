<#-- templates/sign-in.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Вход в TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
</head>
<body>

<#include "fragments/header.ftlh">


<main>
    <div class="container" style="max-width: 400px; padding: 60px 0;">
        <div class="card">
            <div class="card-header">
                <h2>Вход в систему</h2>
            </div>

            <#if error??>
                <div class="alert alert-error">
                    ${error}
                </div>
            </#if>

            <form action="/sign-in" method="POST">
                <div class="form-group">
                    <label>Телефон</label>
                    <input type="tel"
                           name="phone"
                           class="form-control"
                           placeholder="+7 (999) 999-99-99"
                           required>
                </div>

                <div class="form-group">
                    <label>Пароль</label>
                    <input type="password"
                           name="password"
                           class="form-control"
                           placeholder="••••••••"
                           required>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    Войти
                </button>
            </form>

            <div style="text-align: center; margin-top: 20px;">
                <a href="/sign-up" style="color: var(--primary); text-decoration: none;">
                    Нет аккаунта? Зарегистрироваться
                </a>
            </div>
        </div>
    </div>
</main>
</body>
</html>