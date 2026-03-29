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
            grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
            gap: 28px;
            margin-top: 30px;
        }
        .bank-card {
            background: linear-gradient(135deg, #1e3a8a, #3b82f6);
            border-radius: 20px;
            padding: 28px;
            color: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        .bank-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }
        .bank-card::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.15);
            border-radius: 50%;
            pointer-events: none;
        }
        .card-number {
            font-family: 'Courier New', monospace;
            font-size: 1.65rem;
            letter-spacing: 4px;
            margin: 24px 0;
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 50px 20px;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:30px;">
            <h1 style="margin:0; font-size:2.4rem;">Мои карты</h1>
            <a href="/cards/open" class="btn btn-primary" style="padding:12px 28px; font-size:1.05rem;">
                <i class="fas fa-plus"></i> Открыть новую карту
            </a>
        </div>

        <#if success??>
            <div class="alert alert-success">${success}</div>
        </#if>
        <#if error??>
            <div class="alert alert-danger">${error}</div>
        </#if>

        <#if cards?has_content>
            <div class="cards-grid">
                <#list cards as card>
                    <div class="bank-card" onclick="location.href='/cards/${card.id()}'">
                        <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                            <div>
                                <div style="font-size:0.95rem; opacity:0.9;">${card.cardProduct().cardName()!"Банковская карта"}</div>
                                <div class="card-number">
                                    <#if card.pan()??>${card.pan()?replace("(\\d{4})", "$1 ", "r")}<#else>•••• •••• •••• ••••</#if>
                                </div>
                            </div>
                            <div style="font-size:2.2rem; opacity:0.9;">
                                <#if card.cardProduct().cardName()?lower_case?contains("visa")>VISA
                                <#elseif card.cardProduct().cardName()?lower_case?contains("mastercard")>Mastercard
                                <#elseif card.cardProduct().cardName()?lower_case?contains("мир") || card.cardProduct().cardName()?lower_case?contains("mir")>МИР
                                <#else>💳</#if>
                            </div>
                        </div>

                        <div style="margin-top:30px; display:flex; justify-content:space-between; align-items:flex-end;">
                            <div>
                                <div style="font-size:0.85rem; opacity:0.8;">Владелец</div>
                                <div style="font-weight:500;">${user.fio()!""}</div>
                            </div>
                            <div style="text-align:right;">
                                <div style="font-size:0.85rem; opacity:0.8;">Действует до</div>
                                <div>${card.expDate()!"--/--"}</div>
                            </div>
                        </div>

                        <div style="margin-top:20px; font-size:1.1rem; font-weight:500;">
                            ${card.plasticName()!"Моя карта"}
                        </div>
                    </div>
                </#list>
            </div>
        <#else>
            <div style="text-align:center; padding:120px 40px; background:white; border-radius:24px; box-shadow:0 10px 40px rgba(0,0,0,0.08);">
                <div style="font-size:6rem; margin-bottom:20px;">💳</div>
                <h2>У вас пока нет карт</h2>
                <p style="color:#64748b; max-width:420px; margin:20px auto;">Откройте первую карту и начните пользоваться всеми возможностями банка</p>
                <a href="/cards/open" class="btn btn-primary">Открыть первую карту</a>
            </div>
        </#if>
    </div>
</main>
</body>
</html>