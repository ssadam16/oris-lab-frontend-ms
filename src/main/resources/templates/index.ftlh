<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechnoBank — Современный банк</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero {
            min-height: 85vh;
            display: flex;
            align-items: center;
            background: linear-gradient(rgba(0,0,0,0.35), rgba(0,0,0,0.45)), url('https://source.unsplash.com/random/1920x1080/?bank,finance') center/cover no-repeat;
            color: white;
            text-align: center;
            position: relative;
        }
        .hero-content {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }
        .hero h1 {
            font-size: 3.8rem;
            font-weight: 700;
            margin-bottom: 20px;
            line-height: 1.1;
        }
        .hero p {
            font-size: 1.35rem;
            margin-bottom: 40px;
            opacity: 0.95;
        }
        .features {
            padding: 100px 0;
            background: white;
        }
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
        }
        .feature-card {
            text-align: center;
            padding: 40px 20px;
        }
        .feature-card i {
            font-size: 3.5rem;
            margin-bottom: 24px;
            color: var(--primary);
        }
    </style>
</head>
<body>
<#assign activePage = 'home'>
<#include "fragments/header.ftlh">

<div class="hero">
    <div class="hero-content">
        <h1>Добро пожаловать в TechnoBank</h1>
        <p>Современный цифровой банк, где всё просто, быстро и безопасно</p>

        <#if !(session?? && session.token??)>
            <a href="/sign-up" class="btn btn-primary" style="font-size: 1.3rem; padding: 18px 40px;">
                Открыть счёт бесплатно
            </a>
            <a href="/sign-in" class="btn" style="background: rgba(255,255,255,0.15); color: white; margin-left: 15px; font-size: 1.3rem; padding: 18px 40px;">
                Войти в аккаунт
            </a>
        <#else>
            <a href="/cards" class="btn btn-primary" style="font-size: 1.3rem; padding: 18px 40px;">
                Перейти к моим картам
            </a>
        </#if>
    </div>
</div>

<div class="features">
    <div class="container">
        <div class="feature-grid">
            <div class="feature-card">
                <i class="fas fa-credit-card"></i>
                <h3>Мгновенные карты</h3>
                <p>Открывайте виртуальные и пластиковые карты за несколько секунд</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-bolt"></i>
                <h3>Мгновенные переводы</h3>
                <p>Переводите деньги по номеру карты, договору или телефону без комиссии</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-shield-alt"></i>
                <h3>Высокая безопасность</h3>
                <p>Современные технологии защиты ваших средств</p>
            </div>
        </div>
    </div>
</div>

<footer class="footer">
    <div class="container">
        <p>© 2026 TechnoBank. Все права защищены.</p>
    </div>
</footer>
</body>
</html>