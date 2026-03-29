<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Карта ${card.plasticName()!"—"} — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .card-hero {
            border-radius: 24px;
            padding: 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
            margin-bottom: 40px;
            background: linear-gradient(135deg, #1e40af, #3b82f6);
        }
        .card-number {
            font-family: 'Courier New', monospace;
            font-size: 2.4rem;
            letter-spacing: 8px;
            margin: 30px 0 25px;
            text-shadow: 0 4px 12px rgba(0,0,0,0.4);
        }
        .info-block {
            background: white;
            border-radius: 20px;
            padding: 32px;
            margin-bottom: 32px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.06);
        }
        .info-title {
            font-size: 1.45rem;
            margin: 0 0 24px 0;
            padding-bottom: 16px;
            border-bottom: 2px solid #f1f5f9;
            color: var(--dark);
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
        }
        .info-card {
            background: #f8fafc;
            border-radius: 14px;
            padding: 20px;
        }
        .label {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            margin-bottom: 6px;
        }
        .value {
            font-weight: 600;
            color: #1e293b;
            word-break: break-all;
        }
        .actions {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }
        .btn-big {
            flex: 1;
            min-width: 220px;
            padding: 18px 24px;
            font-size: 1.1rem;
            border-radius: 16px;
            font-weight: 600;
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 60px 0 100px;">
        <div style="max-width: 1100px; margin: 0 auto;">

            <!-- Хлебные крошки -->
            <div style="margin-bottom: 32px; font-size: 1.05rem;">
                <a href="/cards" style="color: var(--primary); text-decoration: none;">← Мои карты</a>
                <span style="margin: 0 12px; color: #94a3b8;">/</span>
                <span style="color: #475569;">Детали карты</span>
            </div>

            <#if card??>
                <#assign brand = "default-card">
                <#if card.cardProduct()?? && card.cardProduct().cardName()??>
                    <#assign n = card.cardProduct().cardName()?lower_case>
                    <#if n?contains("visa")><#assign brand="visa">
                    <#elseif n?contains("mastercard")><#assign brand="mastercard">
                    <#elseif n?contains("мир") || n?contains("mir")><#assign brand="mir">
                    </#if>
                </#if>

                <!-- Карта-герой -->
                <div class="card-hero">
                    <div style="position: relative; z-index: 2;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                            <div>
                                <div style="font-size: 1rem; opacity: 0.85;">${card.cardProduct().cardName()!"Банковская карта"}</div>
                                <div class="card-number">
                                    <#if card.pan()??>
                                        ${card.pan()?replace("(\\d{4})", "$1 ", "r")}
                                    <#else>•••• •••• •••• ••••</#if>
                                </div>
                            </div>
                            <div style="font-size: 2.8rem; opacity: 0.95;">
                                <#if brand == "visa">VISA
                                <#elseif brand == "mastercard">Mastercard
                                <#elseif brand == "mir">МИР
                                <#else>💳</#if>
                            </div>
                        </div>

                        <div style="display: flex; justify-content: space-between; margin-top: 40px;">
                            <div>
                                <div style="font-size: 0.95rem; opacity: 0.8;">Действует до</div>
                                <div style="font-size: 1.6rem; font-weight: 600;">
                                    <#if card.expDate()??>
                                        ${card.expDate()?substring(5,7)}/${card.expDate()?substring(2,4)}
                                    <#else>--/--</#if>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <div style="font-size: 0.95rem; opacity: 0.8;">Владелец</div>
                                <div style="font-size: 1.4rem; font-weight: 500; text-transform: uppercase;">
                                    ${card.plasticName()!"CARD HOLDER"}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Детальная информация -->
                <div class="info-block">
                    <h3 class="info-title">📋 Основная информация</h3>
                    <div class="info-grid">
                        <div class="info-card">
                            <div class="label">ID карты</div>
                            <div class="value" style="font-family: monospace; font-size: 0.95rem;">${card.id()}</div>
                        </div>
                        <div class="info-card">
                            <div class="label">Номер договора</div>
                            <div class="value" style="font-family: monospace;">${card.contractName()!"—"}</div>
                        </div>
                        <div class="info-card">
                            <div class="label">CVV</div>
                            <div class="value" style="font-family: monospace;">${card.cvv()!"—"}</div>
                        </div>
                        <div class="info-card">
                            <div class="label">Статус</div>
                            <div class="value">
                                <#if card.closeFlag()>
                                    <span style="color:#ef4444;">🔒 Закрыта</span>
                                <#else>
                                    <span style="color:#22c55e;">✅ Активна</span>
                                </#if>
                            </div>
                        </div>
                        <div class="info-card">
                            <div class="label">Владелец</div>
                            <div class="value">${card.plasticName()!"—"}</div>
                        </div>
                    </div>
                </div>

                <!-- Действия -->
                <div class="actions">
                    <a href="/cards" class="btn btn-primary btn-big">
                        ← Назад к списку карт
                    </a>

                    <#if !card.closeFlag()>
                        <a href="/transfers/history" class="btn btn-primary btn-big">
                            📊 Операции по карте
                        </a>

                        <!-- Кнопка документа об открытии карты -->
                        <a href="/documents/card-opening/${card.id()}"
                           class="btn btn-primary btn-big"
                           target="_blank">
                            <i class="fas fa-file-alt"></i> Документ об открытии
                        </a>

                        <form action="/cards/${card.id()}/close" method="post" style="flex:1;"
                              onsubmit="return confirm('Закрыть карту навсегда?\n\nЭто действие нельзя отменить.')">
                            <button type="submit" class="btn btn-danger btn-big">
                                🔒 Закрыть карту
                            </button>
                        </form>
                        <#else>
                            <a href="/documents/card-closing/${card.id()}"
                               class="btn btn-primary btn-big"
                               target="_blank">
                                <i class="fas fa-file-alt"></i> Документ о закрытии
                            </a>

                    </#if>
                </div>

            <#else>
                <div style="text-align:center; padding:120px 40px; background:white; border-radius:20px;">
                    <h2>Карта не найдена</h2>
                    <a href="/cards" class="btn btn-primary" style="margin-top:30px;">Вернуться к картам</a>
                </div>
            </#if>

        </div>
    </div>
</main>

<footer class="footer">
    <div class="container">
        <p>© 2026 TechnoBank. Все права защищены.</p>
    </div>
</footer>
</body>
</html>