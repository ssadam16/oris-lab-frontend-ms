<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Карта ${card.plasticName()!"—"} — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        .card-hero {
            border-radius: 24px;
            padding: 36px 40px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 16px 48px rgba(0,0,0,0.18);
            margin-bottom: 40px;
        }
        .card-hero .bg-pattern {
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 80% 20%, rgba(255,255,255,0.12) 0%, transparent 60%);
            pointer-events: none;
        }
        .card-number {
            font-family: 'Courier New', monospace;
            font-size: 2.1rem;
            letter-spacing: 6px;
            margin: 32px 0 28px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.4);
        }
        .card-meta {
            display: flex;
            justify-content: space-between;
            font-size: 1.05rem;
        }
        .info-block {
            background: white;
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 32px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
        }
        .info-title {
            font-size: 1.32rem;
            margin: 0 0 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #eee;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 14px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-row:last-child { border-bottom: none; }
        .label { color: #666; font-weight: 500; }
        .value { font-weight: 600; color: #222; }

        .actions {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }
        .btn-big {
            flex: 1;
            min-width: 220px;
            padding: 16px 24px;
            font-size: 1.08rem;
            border-radius: 14px;
            font-weight: 600;
            text-align: center;
            transition: all 0.2s;
        }
        .btn-danger {
            background: #d32f2f;
            color: white;
        }
        .btn-danger:hover { background: #c62828; }

        .closed-notice {
            background: #fff3f3;
            border: 1px solid #ffcdd2;
            border-radius: 16px;
            padding: 32px;
            text-align: center;
            margin-top: 40px;
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 48px 0 80px;">
        <div style="max-width: 960px; margin: 0 auto;">

            <div style="margin-bottom: 32px;">
                <a href="/cards" style="color: var(--primary); text-decoration: none; font-weight: 500;">← Мои карты</a>
                <span style="margin: 0 12px; color: #888;">/</span>
                <span style="color: #444;">Детали карты</span>
            </div>

            <#if card??>
                <#assign brand = "default-card">
                <#if card.cardProduct()??>
                    <#assign n = card.cardProduct().cardName()?lower_case>
                    <#if n?contains("visa")><#assign brand="visa">
                    <#elseif n?contains("mastercard")><#assign brand="mastercard">
                    <#elseif n?contains("мир") || n?contains("mir")><#assign brand="mir">
                    </#if>
                </#if>

                <div class="card-hero ${brand}">
                    <div class="bg-pattern"></div>
                    <div style="position: relative; z-index: 1;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                            <div style="font-size: 1.1rem; opacity: 0.9; text-transform: uppercase;">
                                ${card.cardProduct().cardName()!"Карта"}
                            </div>
                            <div style="font-size: 2.4rem; opacity: 0.95;">
                                <#if n?contains("visa")>VISA<#elseif n?contains("mastercard")>Mastercard<#elseif n?contains("мир") || n?contains("mir")>МИР<#else>💳</#if>
                            </div>
                        </div>

                        <div class="card-number">
                            <#if card.pan()??>${card.pan()?replace("(\\d{4})", "$1 ", "r")}<#else>•••• •••• •••• ••••</#if>
                        </div>

                        <div class="card-meta">
                            <div>
                                <div style="font-size: 0.9rem; opacity: 0.8; margin-bottom: 4px;">Действует до</div>
                                <div style="font-size: 1.4rem; font-weight: 600;">${card.expDate()!"--/--"}</div>
                            </div>
                            <div style="text-align: right;">
                                <div style="font-size: 0.9rem; opacity: 0.8; margin-bottom: 4px;">Владелец</div>
                                <div style="font-size: 1.3rem; font-weight: 500; text-transform: uppercase;">${user.fio()!"HOLDER NAME"}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="info-block">
                    <h3 class="info-title">Основная информация</h3>
                    <div class="info-row"><span class="label">Статус</span>
                        <span class="value">
                            <#if card.closeFlag()>
                                <span style="color:#d32f2f; font-weight:600;">Закрыта</span>
                            <#else>
                                <span style="color:#2e7d32; font-weight:600;">Активна</span>
                            </#if>
                        </span>
                    </div>
                    <div class="info-row"><span class="label">Название карты</span><span class="value">${card.plasticName()!"—"}</span></div>
                    <div class="info-row"><span class="label">Договор</span><span class="value">${card.contractName()!"—"}</span></div>
                    <div class="info-row"><span class="label">PAN (маскированный)</span>
                        <span class="value">
                            <#if card.pan()?? && card.pan()?length gt 10>
                                ${card.pan()?substring(0,6)}******${card.pan()?substring(card.pan()?length-4)}
                            <#else>—</#if>
                        </span>
                    </div>
                </div>

                <#if card.cardProduct()??>
                    <div class="info-block">
                        <h3 class="info-title">Продукт</h3>
                        <div class="info-row"><span class="label">Название</span><span class="value">${card.cardProduct().cardName()}</span></div>
                        <#if card.cardProduct().description()??>
                            <div class="info-row"><span class="label">Описание</span><span class="value">${card.cardProduct().description()}</span></div>
                        </#if>
                    </div>
                </#if>

                <div class="actions">
                    <a href="/cards" class="btn-big" style="background:#6c757d; color:white;">← Назад</a>

                    <#if !card.closeFlag()>
                        <a href="/cards/${card.id()}/operations" class="btn-big" style="background:var(--primary); color:white;">Операции по карте</a>

                        <form action="/cards/${card.id()}/close" method="post" style="flex:1;"
                              onsubmit="return confirm('Закрыть карту навсегда?\n\nЭто действие нельзя отменить.')">
                            <button type="submit" class="btn-big btn-danger">
                                Закрыть карту
                            </button>
                        </form>
                    </#if>
                </div>

                <#if card.closeFlag()>
                    <div class="closed-notice">
                        <h3 style="margin:0 0 16px; color:#c62828;">Карта закрыта</h3>
                        <p style="margin:0; color:#555;">Вы больше не можете проводить операции по этой карте.</p>
                    </div>
                </#if>

            <#else>
                <div style="text-align:center; padding:120px 20px;">
                    <div style="font-size:6rem; opacity:0.3; margin-bottom:32px;">🔍</div>
                    <h2 style="margin-bottom:16px;">Карта не найдена</h2>
                    <p style="color:#666; margin-bottom:40px; max-width:480px; margin-left:auto; margin-right:auto;">
                        Возможно, карта была удалена или у вас нет к ней доступа.
                    </p>
                    <a href="/cards" class="btn btn-primary" style="padding:16px 36px; font-size:1.1rem;">Вернуться к списку карт</a>
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