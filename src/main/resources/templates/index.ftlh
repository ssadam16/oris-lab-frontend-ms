<#-- templates/index.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechnoBank - Главная</title>
    <link rel="stylesheet" href="/static/css/main.css">
</head>
<body>
<#assign activePage = 'home'>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 60px 0;">
        <div class="card" style="text-align: center;">
            <h1 style="font-size: 3rem; margin-bottom: 20px; color: var(--primary);">
                Добро пожаловать в TechnoBank! 🚀
            </h1>

            <p style="font-size: 1.2rem; color: var(--secondary); margin-bottom: 40px;">
                Современный банк для современных людей
            </p>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 30px; margin: 50px 0;">
                <div style="padding: 30px;">
                    <div style="font-size: 3rem; margin-bottom: 20px;">💳</div>
                    <h3 style="margin-bottom: 15px;">Удобные карты</h3>
                    <p style="color: var(--secondary);">Мгновенный выпуск цифровых карт</p>
                </div>

                <div style="padding: 30px;">
                    <div style="font-size: 3rem; margin-bottom: 20px;">⚡</div>
                    <h3 style="margin-bottom: 15px;">Мгновенные переводы</h3>
                    <p style="color: var(--secondary);">Переводите деньги за секунды</p>
                </div>

                <div style="padding: 30px;">
                    <div style="font-size: 3rem; margin-bottom: 20px;">🔒</div>
                    <h3 style="margin-bottom: 15px;">Безопасность</h3>
                    <p style="color: var(--secondary);">Ваши деньги под надежной защитой</p>
                </div>
            </div>

            <div style="margin-top: 40px;">
                <#if !(session?? && session.token??)>
                    <a href="/sign-up" class="btn btn-primary" style="margin-right: 15px;">
                        Открыть счёт
                    </a>
                    <a href="/sign-in" class="btn" style="background: var(--light); color: var(--dark);">
                        Войти в банк
                    </a>
                <#else>
                    <a href="/cards" class="btn btn-primary">
                        Мои карты
                    </a>
                </#if>
            </div>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="container">
        <p>© 2024 TechnoBank. Все права защищены.</p>
    </div>
</footer>
</body>
</html>