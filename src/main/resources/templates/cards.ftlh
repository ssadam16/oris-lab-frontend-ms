<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Мои карты — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .bank-card {
            background: linear-gradient(135deg, #1e3a8a, #3b82f6);
            border-radius: 28px;
            padding: 32px;
            color: white;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            min-height: 380px;
            display: flex;
            flex-direction: column;
        }

        .bank-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 30px 50px rgba(0, 0, 0, 0.25);
        }

        /* Разные градиенты для разных типов карт */
        .bank-card.visa-card {
            background: linear-gradient(135deg, #1e5799, #2b8cce);
        }

        .bank-card.mastercard-card {
            background: linear-gradient(135deg, #cc1f2a, #e3523c);
        }

        .bank-card.mir-card {
            background: linear-gradient(135deg, #2d8f4e, #4bc47c);
        }

        /* Стиль для закрытой карты */
        .bank-card.closed-card {
            background: linear-gradient(135deg, #475569, #64748b);
            filter: grayscale(0.3);
        }

        .bank-card.closed-card:hover {
            transform: translateY(-5px);
        }

        .bank-card::after {
            content: '';
            position: absolute;
            top: -30%;
            right: -30%;
            width: 280px;
            height: 280px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            pointer-events: none;
        }

        .bank-card::before {
            content: '';
            position: absolute;
            bottom: -20%;
            left: -20%;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
            pointer-events: none;
        }

        .card-number {
            font-family: 'Courier New', 'SF Mono', monospace;
            font-size: 1.6rem;
            letter-spacing: 4px;
            margin: 25px 0 20px 0;
            font-weight: 700;
            text-shadow: 0 2px 3px rgba(0, 0, 0, 0.2);
        }

        .balance-section {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 16px 20px;
            margin: 20px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .balance-label {
            font-size: 0.85rem;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 5px;
        }

        .balance-amount {
            font-size: 1.8rem;
            font-weight: 800;
            line-height: 1;
        }

        .balance-currency {
            font-size: 1rem;
            font-weight: 500;
            margin-left: 4px;
        }

        .card-chip {
            position: absolute;
            bottom: 25px;
            right: 25px;
            opacity: 0.25;
            font-size: 3rem;
            pointer-events: none;
        }

        .card-type-badge {
            font-weight: 700;
            letter-spacing: 1px;
            font-size: 1.8rem;
        }

        .card-footer {
            margin-top: auto;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            border-top: 1px solid rgba(255, 255, 255, 0.15);
            padding-top: 20px;
        }

        .owner-info {
            flex: 1;
        }

        .expiry-info {
            text-align: right;
        }

        .owner-label, .expiry-label {
            font-size: 0.7rem;
            opacity: 0.7;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 5px;
        }

        .owner-name, .expiry-date {
            font-weight: 600;
            font-size: 1rem;
        }

        .card-name {
            font-size: 1rem;
            font-weight: 500;
            margin-top: 15px;
            opacity: 0.9;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Анимация для пустого состояния */
        .empty-state {
            text-align: center;
            padding: 100px 40px;
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            border-radius: 32px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.05);
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .empty-icon {
            font-size: 5rem;
            margin-bottom: 20px;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        .btn-create {
            margin-top: 30px;
            padding: 14px 32px;
            font-size: 1.1rem;
            border-radius: 50px;
            transition: all 0.3s;
        }

        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3);
        }

        /* Адаптивность */
        @media (max-width: 768px) {
            .cards-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .bank-card {
                min-height: auto;
                padding: 24px;
            }

            .balance-amount {
                font-size: 1.5rem;
            }

            .card-number {
                font-size: 1.2rem;
                letter-spacing: 2px;
            }
        }

        /* Индикатор статуса карты */
        .card-status {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(0, 0, 0, 0.4);
            padding: 6px 12px;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            backdrop-filter: blur(5px);
            z-index: 2;
        }

        .card-status.active {
            background: rgba(34, 197, 94, 0.9);
            box-shadow: 0 2px 8px rgba(34, 197, 94, 0.3);
        }

        .card-status.blocked {
            background: rgba(239, 68, 68, 0.9);
            box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
        }

        /* Стиль для Wi-Fi иконки */
        .wifi-icon {
            position: absolute;
            top: 25px;
            left: 25px;
            opacity: 0.4;
            font-size: 1.5rem;
            transform: rotate(90deg);
            pointer-events: none;
        }

        /* Затемнение для закрытых карт */
        .closed-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.2);
            pointer-events: none;
            border-radius: 28px;
        }

        .balance-placeholder {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .fa-stack {
            font-size: 0.8rem;
        }

        .text-muted {
            opacity: 0.7;
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 50px 20px; max-width: 1400px; margin: 0 auto;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:40px; flex-wrap:wrap; gap:15px;">
            <div>
                <h1 style="margin:0; font-size:2.8rem; background: linear-gradient(135deg, #1e3a8a, #3b82f6); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">
                    <i class="fas fa-credit-card" style="margin-right:12px;"></i>Мои карты
                </h1>
                <p style="color:#64748b; margin-top:10px; font-size:1.05rem;">Управляйте своими банковскими картами</p>
            </div>
            <a href="/cards/open" class="btn btn-primary"
               style="padding:14px 32px; font-size:1.05rem; border-radius:50px; box-shadow:0 4px 12px rgba(59,130,246,0.3);">
                <i class="fas fa-plus"></i> Открыть новую карту
            </a>
        </div>

        <#if success??>
            <div class="alert alert-success" style="border-radius:16px; animation: fadeIn 0.5s;">${success}</div>
        </#if>
        <#if error??>
            <div class="alert alert-danger" style="border-radius:16px; animation: fadeIn 0.5s;">${error}</div>
        </#if>

        <#if cards?has_content>
            <div class="cards-grid">
                <#list cards as card>
                    <div class="bank-card
                        <#if card.closeFlag()?? && card.closeFlag()>closed-card</#if>
                        <#if !card.closeFlag()?? || !card.closeFlag()>
                            <#if card.cardProduct().cardName()?lower_case?contains("visa")>visa-card
                            <#elseif card.cardProduct().cardName()?lower_case?contains("mastercard")>mastercard-card
                            <#elseif card.cardProduct().cardName()?lower_case?contains("мир") || card.cardProduct().cardName()?lower_case?contains("mir")>mir-card
                            </#if>
                        </#if>"
                         onclick="location.href='/cards/${card.id()}'">

                        <!-- Wi-Fi иконка слева сверху -->
                        <div class="wifi-icon">
                            <i class="fas fa-wifi"></i>
                        </div>

                        <!-- Статус карты -->
                        <div class="card-status ${(card.closeFlag()?? && card.closeFlag())?then('blocked', 'active')}">
                            <i class="fas ${(card.closeFlag()?? && card.closeFlag())?then('fa-ban', 'fa-check-circle')}"></i>
                            ${(card.closeFlag()?? && card.closeFlag())?then('ЗАКРЫТА', 'АКТИВНА')}
                        </div>

                        <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-top: 15px;">
                            <div class="card-type-badge">
                                <#if card.cardProduct().cardName()?lower_case?contains("visa")>
                                    <i class="fab fa-cc-visa"></i> VISA
                                <#elseif card.cardProduct().cardName()?lower_case?contains("mastercard")>
                                    <i class="fab fa-cc-mastercard"></i> Mastercard
                                <#elseif card.cardProduct().cardName()?lower_case?contains("мир") || card.cardProduct().cardName()?lower_case?contains("mir")>
                                    МИР
                                <#else>
                                    💳
                                </#if>
                            </div>
                        </div>

                        <div class="card-number">
                            <#if card.pan()?? && !card.closeFlag()?? || !card.closeFlag()>
                                ${card.pan()?replace("(\\d{4})", "$1 ", "r")}
                            <#else>
                                •••• •••• •••• ••••
                            </#if>
                        </div>

                        <!-- Блок баланса -->
                        <div class="balance-section">
                            <div>
                                <div class="balance-label">
                                    <i class="fas fa-ruble-sign"></i> Доступный баланс
                                </div>
                                <div class="balance-amount">
                                    <#if card.closeFlag()?? && card.closeFlag()>
                                        <span class="text-muted">—</span>
                                    <#else>
                                        ${card.balance()!"0.00"} <span class="balance-currency">₽</span>
                                    </#if>
                                </div>
                            </div>
                            <div>
                                <i class="fas fa-chart-line" style="opacity:0.7; font-size:1.3rem;"></i>
                            </div>
                        </div>

                        <div class="card-footer">
                            <div class="owner-info">
                                <div class="owner-label">Владелец</div>
                                <div class="owner-name">${card.plasticName()!""}</div>
                            </div>
                            <div class="expiry-info">
                                <div class="expiry-label">Действует до</div>
                                <div class="expiry-date">
                                    <#if card.closeFlag()?? && card.closeFlag()>
                                        —
                                    <#else>
                                        ${card.expDate()!"--/--"}
                                    </#if>
                                </div>
                            </div>
                        </div>

                        <div class="card-name">
                            <i class="fas fa-tag"></i>
                            ${card.cardProduct().cardName()!"Моя карта"}
                        </div>

                        <div class="card-chip">
                            <i class="fas fa-microchip"></i>
                        </div>

                        <#if card.closeFlag()?? && card.closeFlag()>
                            <div class="closed-overlay"></div>
                        </#if>
                    </div>
                </#list>
            </div>
        <#else>
            <div class="empty-state">
                <div class="empty-icon">💳✨</div>
                <h2 style="margin: 0 0 12px 0; color:#1e293b;">У вас пока нет карт</h2>
                <p style="color:#64748b; max-width:450px; margin:0 auto 25px auto; font-size:1.05rem;">
                    Откройте первую карту и начните пользоваться всеми возможностями банка
                </p>
                <a href="/cards/open" class="btn btn-primary btn-create">
                    <i class="fas fa-plus"></i> Открыть первую карту
                </a>
            </div>
        </#if>
    </div>
</main>
</body>
</html>