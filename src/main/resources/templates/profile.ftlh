<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Профиль — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        .profile-card { background: white; border-radius: 24px; box-shadow: 0 10px 40px rgba(0,0,0,0.08); padding: 40px; }
        .card-mini {
            border-radius: 20px;
            padding: 24px;
            color: white;
            transition: transform 0.3s;
            cursor: pointer;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .card-mini:hover { transform: translateY(-6px); }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 50px 20px;">
        <div class="profile-card">
            <div style="display:flex; align-items:center; gap:24px; margin-bottom:40px;">
                <div style="width:90px; height:90px; background:linear-gradient(135deg,#2563eb,#1e40af); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:3rem; color:white;">
                    👤
                </div>
                <div>
                    <h1 style="margin:0;">${user.fio()!"Пользователь"}</h1>
                    <p style="color:#64748b; font-size:1.1rem;">${user.phone()!""}</p>
                </div>
            </div>

            <h2 style="margin:0 0 24px 0;">Мои карты</h2>

            <#if cards?has_content>
                <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(320px,1fr)); gap:24px;">
                    <#list cards as card>
                        <a href="/cards/${card.id()}" style="text-decoration:none;">
                            <div class="card-mini" style="background: linear-gradient(135deg, #1e40af, #3b82f6);">
                                <div style="font-size:0.95rem; opacity:0.9;">${card.cardProduct().cardName()!"Карта"}</div>
                                <div style="font-size:1.4rem; margin:16px 0; font-family:monospace;">
                                    <#if card.pan()??>${card.pan()?replace("(\\d{4})", "$1 ", "r")}<#else>•••• •••• •••• ••••</#if>
                                </div>
                                <div style="display:flex; justify-content:space-between;">
                                    <div>
                                        <small>Действует до</small><br>
                                        <strong>${card.expDate()!"--/--"}</strong>
                                    </div>
                                    <div style="text-align:right;">
                                        <small>Договор</small><br>
                                        <strong>${card.contractName()!""}</strong>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </#list>
                </div>
            <#else>
                <div style="text-align:center; padding:80px;">
                    <p style="color:#888;">У вас пока нет карт</p>
                    <a href="/cards/open" class="btn btn-primary">Открыть карту</a>
                </div>
            </#if>
        </div>
    </div>
</main>
</body>
</html>