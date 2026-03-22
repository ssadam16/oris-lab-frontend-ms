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

            <#if cards?size == 0>
                <div style="text-align: center; padding: 60px 20px;">
                    <div style="font-size: 4rem; margin-bottom: 20px;">💳</div>
                    <h3 style="margin-bottom: 15px;">У вас пока нет карт</h3>
                    <p style="color: var(--secondary); margin-bottom: 30px;">
                        Откройте свою первую карту и начните пользоваться преимуществами TechnoBank
                    </p>
                    <a href="/cards/open" class="btn btn-primary">Открыть карту</a>
                </div>
            <#else>
                <div class="cards-grid">
                    <#list cards as card>
                        <div class="bank-card" onclick="location.href='/cards/${card.id()}'">
                            <div class="card-chip"></div>
                            <div class="card-number">
                                ${card.pan()?replace("(\\d{4})", "$1 ", "r")}
                            </div>
                            <div class="card-details">
                                <div>
                                    <div style="font-size: 0.8rem; opacity: 0.8;">Владелец</div>
                                    <div>${user.fio()!""}</div>
                                </div>
                                <div>
                                    <div style="font-size: 0.8rem; opacity: 0.8;">Срок действия</div>
                                    <div>${card.expDate()}</div>
                                </div>
                            </div>
                            <div class="card-balance">
                                <#-- Баланс можно добавить из другого сервиса -->
                                💰 0 ₽
                            </div>
                            <div style="margin-top: 15px; font-size: 0.9rem;">
                                ${card.plasticName()}
                            </div>
                        </div>
                    </#list>
                </div>
            </#if>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="container">
        <p>© 2024 TechnoBank. Все права защищены.</p>
    </div>
</footer>

<script>
    function showCardDetails(cardId) {
        window.location.href = '/cards/' + cardId;
    }
</script>
</body>
</html>