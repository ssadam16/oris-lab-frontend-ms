<#-- templates/profile.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Мой профиль - TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        .balance-positive {
            color: var(--success);
            font-weight: bold;
        }

        .card-mini {
            border-radius: 16px;
            padding: 20px;
            color: white;
            cursor: pointer;
            transition: transform 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .card-mini:hover {
            transform: translateY(-5px);
        }

        .card-mini .card-number {
            font-family: monospace;
            font-size: 1.1rem;
            letter-spacing: 2px;
            margin: 15px 0;
        }

        .card-mini .card-expiry {
            font-size: 0.8rem;
            opacity: 0.8;
        }

        .card-mini .card-image-bg {
            position: absolute;
            top: -20px;
            right: -20px;
            width: 120px;
            height: 120px;
            opacity: 0.2;
            pointer-events: none;
        }

        .empty-cards {
            text-align: center;
            padding: 40px;
            background: var(--light);
            border-radius: 16px;
        }

        .card-brand {
            position: relative;
            z-index: 1;
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 40px 0;">

        <#if error??>
            <div class="alert alert-error">${error}</div>
        </#if>

        <#-- Профиль пользователя -->
        <div class="profile-header" style="background: var(--light); border-radius: 16px; padding: 30px; margin-bottom: 40px;">
            <div class="user-info" style="display: flex; align-items: center; gap: 20px;">
                <div class="user-avatar" style="width: 80px; height: 80px; background: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.5rem;">
                    👤
                </div>
                <div class="user-details">
                    <h1 style="margin: 0 0 5px 0;">${user.fio()!"Пользователь"}</h1>
                    <p style="margin: 0; color: var(--secondary);">${user.phone()!"Телефон не указан"}</p>
                    <#if user.email??>
                        <p style="margin: 5px 0 0 0; color: var(--secondary);">${user.email()}</p>
                    </#if>
                </div>
            </div>
        </div>

        <#-- Мои карты -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2 style="color: var(--dark);">Мои карты</h2>
            <a href="/cards/open" class="btn btn-success" style="background: var(--success); color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none;">+ Новая карта</a>
        </div>

        <div class="cards-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px; margin-bottom: 40px;">
            <#if cards?has_content>
                <#list cards as card>
                    <a href="/cards/${card.id()}" style="text-decoration: none;">
                        <div class="card-mini" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                            <#-- Фоновое изображение карты -->
                            <#if card.imageLink()?? && card.imageLink() != "">
                                <img src="${card.imageLink()}"
                                     class="card-image-bg"
                                     alt="card image"
                                     style="position: absolute; top: -20px; right: -20px; width: 120px; height: 120px; opacity: 0.2; pointer-events: none;">
                            </#if>

                            <div class="card-brand" style="position: relative; z-index: 1;">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                                    <div style="font-size: 0.7rem; text-transform: uppercase;">${card.cardName()}</div>
                                    <div style="font-size: 1.2rem;">
                                        <#if card.imageLink()?? && card.imageLink() != "">
                                            💳
                                        <#else>
                                            💳
                                        </#if>
                                    </div>
                                </div>
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <div>
                                        <div class="card-expiry">Срок действия</div>
                                        <div>${card.expDate()}</div>
                                    </div>
                                    <div>
                                        <div class="card-expiry">Договор</div>
                                        <div style="font-size: 0.8rem;">${card.contractName()?substring(0, 8)}..</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </a>
                </#list>
            <#else>
                <div class="empty-cards">
                    <div style="font-size: 3rem; margin-bottom: 10px;">💳</div>
                    <p style="margin-bottom: 20px;">У вас пока нет карт</p>
                    <a href="/cards/open" class="btn btn-primary">Открыть первую карту</a>
                </div>
            </#if>
        </div>

        <#-- Последние операции (заглушка, пока нет микросервиса транзакций) -->
        <h2 style="color: var(--dark); margin: 40px 0 20px;">Последние операции</h2>

        <div class="card">
            <div style="text-align: center; padding: 40px;">
                <div style="font-size: 3rem; margin-bottom: 10px;">📊</div>
                <p style="color: var(--secondary);">Информация о последних операциях будет доступна в ближайшее время</p>
                <p style="color: var(--secondary); font-size: 0.9rem;">Выберите карту для просмотра детальной выписки</p>
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