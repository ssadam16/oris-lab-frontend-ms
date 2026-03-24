<#-- templates/cards.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Мои карты - TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 40px 0;">
        <div class="card">
            <div class="card-header">
                <h2>Мои карты</h2>
                <a href="/cards/open" class="btn btn-primary">+ Открыть новую карту</a>
            </div>

            <#if success??>
                <div class="alert alert-success">${success}</div>
            </#if>
            <#if error??>
                <div class="alert alert-error">${error}</div>
            </#if>

            <#if cards?has_content>
                <div class="cards-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 24px; margin-top: 24px;">
                    <#list cards as card>
                        <div class="bank-card" onclick="location.href='/cards/${card.id()}'" style="cursor: pointer;">
                            <div class="card-chip"></div>
                            <div class="card-number">
                                <#if card.pan()?? && card.pan()?length gte 16>
                                    ${card.pan()?replace("(\\d{4})", "$1 ", "r")}
                                <#else>
                                    •••• •••• •••• ••••
                                </#if>
                            </div>
                            <div class="card-details">
                                <div>
                                    <div style="font-size: 0.8rem; opacity: 0.8;">Владелец</div>
                                    <div>${user.fio()!""}</div>
                                </div>
                                <div>
                                    <div style="font-size: 0.8rem; opacity: 0.8;">Срок действия</div>
                                    <div>${card.expDate()!"--/--"}</div>
                                </div>
                            </div>
                            <div class="card-balance">
                                💰 0 ₽
                            </div>
                            <div style="margin-top: 15px; font-size: 0.9rem;">
                                ${card.plasticName()!"Карта"}
                            </div>
                        </div>
                    </#list>
                </div>
            <#else>
                <div style="text-align: center; padding: 80px 20px;">
                    <div style="font-size: 5rem; margin-bottom: 24px;">💳</div>
                    <h3 style="margin-bottom: 16px;">У вас пока нет карт</h3>
                    <p style="color: var(--secondary); margin-bottom: 32px; max-width: 420px; margin-left: auto; margin-right: auto;">
                        Откройте свою первую карту и начните пользоваться всеми преимуществами TechnoBank
                    </p>
                    <a href="/cards/open" class="btn btn-primary">Открыть карту</a>
                </div>
            </#if>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="container">
        <p>© 2025 TechnoBank. Все права защищены.</p>
    </div>
</footer>

</body>
</html>