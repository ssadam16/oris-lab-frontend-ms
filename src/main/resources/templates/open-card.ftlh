<#-- templates/open-card.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Открыть карту - TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 40px 0;">
        <div class="card" style="max-width: 600px; margin: 0 auto;">
            <div class="card-header">
                <h2>Открыть новую карту</h2>
                <a href="/cards" class="btn" style="background: var(--light);">← Назад</a>
            </div>

            <#if error??>
                <div class="alert alert-error">${error}</div>
            </#if>

            <form action="/cards/open" method="post">
                <div class="form-group">
                    <label for="cardProductId">Выберите тип карты</label>
                    <select id="cardProductId" name="cardProductId" class="form-control" required>
                        <option value="">Выберите карту</option>
                        <#list products as product>
                            <option value="${product.id()}">
                                ${product.cardName()} - ${product.description()}
                            </option>
                        </#list>
                    </select>
                </div>

                <div class="form-group">
                    <label>Информация о карте</label>
                    <div style="background: var(--light); padding: 20px; border-radius: 12px;">
                        <div style="margin-bottom: 10px;">
                            <strong>💳 Мгновенный выпуск</strong>
                            <p style="color: var(--secondary); font-size: 0.9rem; margin-top: 5px;">
                                Цифровая карта будет готова к использованию сразу после открытия
                            </p>
                        </div>
                        <div style="margin-bottom: 10px;">
                            <strong>🔒 Безопасность</strong>
                            <p style="color: var(--secondary); font-size: 0.9rem; margin-top: 5px;">
                                Ваши данные защищены современными технологиями шифрования
                            </p>
                        </div>
                        <div>
                            <strong>✨ Бесплатное обслуживание</strong>
                            <p style="color: var(--secondary); font-size: 0.9rem; margin-top: 5px;">
                                Первый год обслуживания бесплатно
                            </p>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    Открыть карту
                </button>
            </form>
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