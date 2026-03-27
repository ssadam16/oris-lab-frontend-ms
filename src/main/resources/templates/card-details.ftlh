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
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }
        .info-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.2s;
        }
        .info-card:hover {
            background: #f1f3f5;
        }
        .info-card .label {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6c757d;
            margin-bottom: 8px;
            display: block;
        }
        .info-card .value {
            font-size: 1.2rem;
            font-weight: 600;
            color: #212529;
            word-break: break-all;
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
            text-decoration: none;
            display: inline-block;
            cursor: pointer;
            border: none;
        }
        .btn-danger {
            background: #d32f2f;
            color: white;
        }
        .btn-danger:hover { background: #c62828; }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover { background: #5a6268; }
        .btn-primary {
            background: var(--primary);
            color: white;
        }
        .btn-primary:hover { background: #1a4f8b; }

        .closed-notice {
            background: #fff3f3;
            border: 1px solid #ffcdd2;
            border-radius: 16px;
            padding: 32px;
            text-align: center;
            margin-top: 40px;
        }
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .badge-active {
            background: #e8f5e9;
            color: #2e7d32;
        }
        .badge-closed {
            background: #ffebee;
            color: #c62828;
        }
        .cvv-code {
            font-family: monospace;
            font-size: 1.1rem;
            letter-spacing: 2px;
        }
        .warning-icon {
            color: #f57c00;
            margin-right: 8px;
        }
        hr {
            margin: 24px 0;
            border: none;
            border-top: 1px solid #e9ecef;
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 48px 0 80px;">
        <div style="max-width: 1200px; margin: 0 auto;">

            <!-- Хлебные крошки -->
            <div style="margin-bottom: 32px;">
                <a href="/cards" style="color: var(--primary); text-decoration: none; font-weight: 500;">← Мои карты</a>
                <span style="margin: 0 12px; color: #888;">/</span>
                <span style="color: #444;">Детали карты</span>
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

                <!-- Карта герой -->
                <div class="card-hero ${brand}">
                    <div class="bg-pattern"></div>
                    <div style="position: relative; z-index: 1;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                            <div>
                                <div style="font-size: 0.9rem; opacity: 0.8; margin-bottom: 4px;">Банковская карта</div>
                                <div style="font-size: 1.3rem; font-weight: 600; text-transform: uppercase;">
                                    ${card.cardProduct().cardName()!"Карта"}
                                </div>
                            </div>
                            <div style="font-size: 2.4rem; opacity: 0.95;">
                                <#if n?contains("visa")>💳 VISA
                                <#elseif n?contains("mastercard")>💳 Mastercard
                                <#elseif n?contains("мир") || n?contains("mir")>💳 МИР
                                <#else>💳</#if>
                            </div>
                        </div>

                        <div class="card-number">
                            <#if card.pan()??>
                                ${card.pan()?replace("(\\d{4})", "$1 ", "r")}
                            <#else>•••• •••• •••• ••••</#if>
                        </div>

                        <div class="card-meta">
                            <div>
                                <div style="font-size: 0.9rem; opacity: 0.8; margin-bottom: 4px;">Действует до</div>
                                <div style="font-size: 1.4rem; font-weight: 600;">
                                    <#if card.expDate()??>
                                        ${card.expDate()?substring(5,7)}/${card.expDate()?substring(2,4)}
                                    <#else>--/--</#if>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <div style="font-size: 0.9rem; opacity: 0.8; margin-bottom: 4px;">Владелец</div>
                                <div style="font-size: 1.3rem; font-weight: 500; text-transform: uppercase;">
                                    ${card.plasticName()!"HOLDER NAME"}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Основная информация (все поля) -->
                <div class="info-block">
                    <h3 class="info-title">
                        📋 Детальная информация
                    </h3>

                    <div class="info-grid">
                        <div class="info-card">
                            <span class="label">🆔 ID карты</span>
                            <div class="value" style="font-size: 0.9rem; font-family: monospace;">
                                ${card.id()}
                            </div>
                        </div>

                        <div class="info-card">
                            <span class="label">👤 ID пользователя</span>
                            <div class="value" style="font-size: 0.9rem; font-family: monospace;">
                                ${card.userId()}
                            </div>
                        </div>

                        <div class="info-card">
                            <span class="label">💳 Статус</span>
                            <div class="value">
                                <#if card.closeFlag()>
                                    <span class="badge badge-closed">🔒 Закрыта</span>
                                <#else>
                                    <span class="badge badge-active">✅ Активна</span>
                                </#if>
                            </div>
                        </div>

                        <div class="info-card">
                            <span class="label">📛 Владелец карты</span>
                            <div class="value">${card.plasticName()!"—"}</div>
                        </div>

                        <div class="info-card">
                            <span class="label">📄 Номер договора</span>
                            <div class="value" style="font-size: 0.9rem; font-family: monospace;">
                                ${card.contractName()!"—"}
                            </div>
                        </div>

                        <div class="info-card">
                            <span class="label">🔢 PAN (номер карты)</span>
                            <div class="value" style="font-family: monospace; font-size: 1rem;">
                                <#if card.pan()??>
                                    ${card.pan()}
                                <#else>—</#if>
                            </div>
                        </div>

                        <div class="info-card">
                            <span class="label">📅 Срок действия</span>
                            <div class="value">
                                <#if card.expDate()??>
                                    ${card.expDate()}
                                <#else>—</#if>
                            </div>
                        </div>

                        <div class="info-card">
                            <span class="label">🔒 CVV/CVC</span>
                            <div class="value cvv-code">
                                <#if card.cvv()??>
                                    <span style="letter-spacing: 2px;">${card.cvv()}</span>
                                    <span style="font-size: 0.7rem; color: #6c757d; margin-left: 8px;">(скрыт)</span>
                                <#else>—</#if>
                            </div>
                        </div>

                        <div class="info-card">
                            <span class="label">📄 Документ открытия</span>
                            <div class="value" style="font-size: 0.85rem; font-family: monospace;">
                                ${card.openDocumentId()!"—"}
                            </div>
                        </div>

                        <div class="info-card">
                            <span class="label">📄 Документ закрытия</span>
                            <div class="value" style="font-size: 0.85rem; font-family: monospace;">
                                <#if card.closeDocumentId()??>
                                    ${card.closeDocumentId()}
                                <#else>
                                    <span style="color: #6c757d;">—</span>
                                </#if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Информация о продукте -->
                <#if card.cardProduct()??>
                    <div class="info-block">
                        <h3 class="info-title">
                            🏷️ Информация о продукте
                        </h3>

                        <div class="info-grid">
                            <div class="info-card">
                                <span class="label">🆔 ID продукта</span>
                                <div class="value" style="font-size: 0.85rem; font-family: monospace;">
                                    ${card.cardProduct().id()}
                                </div>
                            </div>

                            <div class="info-card">
                                <span class="label">🏷️ Название продукта</span>
                                <div class="value">${card.cardProduct().cardName()}</div>
                            </div>

                            <#if card.cardProduct().description()?? && card.cardProduct().description()?trim?has_content>
                                <div class="info-card">
                                    <span class="label">📝 Описание</span>
                                    <div class="value" style="font-size: 0.95rem;">${card.cardProduct().description()}</div>
                                </div>
                            </#if>

                            <#if card.cardProduct().cardImageLink()?? && card.cardProduct().cardImageLink()?trim?has_content>
                                <div class="info-card">
                                    <span class="label">🖼️ Изображение</span>
                                    <div class="value">
                                        <a href="${card.cardProduct().cardImageLink()}" target="_blank" style="color: var(--primary);">
                                            Просмотреть изображение →
                                        </a>
                                    </div>
                                </div>
                            </#if>
                        </div>
                    </div>
                </#if>

                <!-- Блок с дополнительной информацией -->
                <div class="info-block">
                    <h3 class="info-title">
                        ℹ️ Дополнительная информация
                    </h3>

                    <div class="info-grid">
                        <div class="info-card">
                            <span class="label">🔐 Безопасность</span>
                            <div class="value">
                                <span style="color: #2e7d32;">✓</span> 3D Secure
                            </div>
                            <div style="margin-top: 8px; font-size: 0.85rem; color: #6c757d;">
                                Бесконтактная оплата
                            </div>
                        </div>

                        <div class="info-card">
                            <span class="label">💸 Лимиты</span>
                            <div class="value">200 000 ₽ / день</div>
                            <div style="margin-top: 8px; font-size: 0.85rem; color: #6c757d;">
                                5 000 000 ₽ / месяц
                            </div>
                        </div>

                        <div class="info-card">
                            <span class="label">🌐 Способы оплаты</span>
                            <div class="value">
                                💳 Pay<br>
                                📱 Apple Pay<br>
                                🤖 Google Pay
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Действия с картой -->
                <div class="actions">
                    <a href="/cards" class="btn-big btn-secondary">
                        ← Назад к списку
                    </a>

                    <#if !card.closeFlag()>
                        <a href="/transfers/history" class="btn-big btn-primary">
                            📊 Операции по карте
                        </a>

                        <form action="/cards/${card.id()}/close" method="post" style="flex:1;"
                              onsubmit="return confirm('Закрыть карту навсегда?\n\nЭто действие нельзя отменить.\n\nПосле закрытия карта будет недоступна для операций.')">
                            <button type="submit" class="btn-big btn-danger">
                                🔒 Закрыть карту
                            </button>
                        </form>
                    </#if>
                </div>

                <!-- Предупреждение для закрытой карты -->
                <#if card.closeFlag()>
                    <div class="closed-notice">
                        <h3 style="margin:0 0 16px; color:#c62828;">
                            ⚠️ Карта закрыта
                        </h3>
                        <p style="margin:0; color:#555; font-size: 1rem;">
                            Карта была закрыта. Вы больше не можете проводить операции по этой карте.
                        </p>
                        <#if card.closeDocumentId()??>
                            <p style="margin: 16px 0 0 0; color: #888; font-size: 0.85rem;">
                                Документ закрытия: ${card.closeDocumentId()}
                            </p>
                        </#if>
                    </div>
                </#if>

            <#else>
                <div style="text-align:center; padding:120px 20px;">
                    <div style="font-size:6rem; opacity:0.3; margin-bottom:32px;">🔍</div>
                    <h2 style="margin-bottom:16px;">Карта не найдена</h2>
                    <p style="color:#666; margin-bottom:40px; max-width:480px; margin-left:auto; margin-right:auto;">
                        Возможно, карта была удалена или у вас нет к ней доступа.
                    </p>
                    <a href="/cards" class="btn-big btn-primary" style="display: inline-block; width: auto;">
                        Вернуться к списку карт
                    </a>
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