<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Открыть карту — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        .product-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 45px rgba(0,0,0,0.15);
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding:60px 20px;">
        <h1 style="text-align:center; margin-bottom:40px; font-size:2.6rem;">Выберите карту для открытия</h1>

        <#if products?has_content>
            <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap:28px;">
                <#list products as product>
                    <div class="product-card">
                        <div style="height:220px; background:#f8fafc; display:flex; align-items:center; justify-content:center;">
                            <#if product.cardImageLink()??>
                                <img src="${product.cardImageLink()}" alt="${product.cardName()}" style="max-height:180px;">
                            <#else>
                                <span style="font-size:6rem; opacity:0.2;">💳</span>
                            </#if>
                        </div>
                        <div style="padding:28px;">
                            <h3>${product.cardName()}</h3>
                            <p style="color:#64748b; min-height:80px;">${product.description()!""}</p>
                            <form action="/cards/open" method="post">
                                <input type="hidden" name="cardProductId" value="${product.id()}">
                                <button type="submit" class="btn btn-primary" style="width:100%; padding:14px;">Открыть карту</button>
                            </form>
                        </div>
                    </div>
                </#list>
            </div>
        <#else>
            <p style="text-align:center; color:#888;">Нет доступных продуктов карт</p>
        </#if>
    </div>
</main>
</body>
</html>