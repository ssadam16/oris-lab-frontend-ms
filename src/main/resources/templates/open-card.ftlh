<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Открыть карту — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        .products-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 28px;
            margin: 32px 0;
        }
        .product-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            transition: all 0.28s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid #eee;
        }
        .product-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.14);
            border-color: var(--primary);
        }
        .product-visual {
            height: 200px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        .product-visual img {
            max-height: 180px;
            object-fit: contain;
            filter: drop-shadow(0 8px 16px rgba(0,0,0,0.15));
        }
        .product-body {
            padding: 24px 28px;
        }
        .product-title {
            font-size: 1.38rem;
            font-weight: 700;
            margin: 0 0 12px;
            color: var(--dark);
        }
        .product-desc {
            color: #555;
            line-height: 1.55;
            font-size: 0.96rem;
            margin-bottom: 24px;
            min-height: 80px;
        }
        .btn-cta {
            width: 100%;
            padding: 14px;
            font-size: 1.05rem;
            font-weight: 600;
            border-radius: 12px;
        }
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: var(--secondary);
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 48px 0 80px;">
        <div style="max-width: 1200px; margin: 0 auto;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 36px;">
                <h1 style="margin: 0; font-size: 2.2rem;">Открыть новую карту</h1>
                <a href="/cards" class="btn" style="padding: 12px 24px; background: #f1f3f5; color: #333; border-radius: 12px; text-decoration: none; font-weight: 500;">
                    ← Назад к картам
                </a>
            </div>

            <#if error??>
                <div class="alert alert-danger" style="margin-bottom: 32px; padding: 16px; border-radius: 12px; background: #ffebee; color: #c62828; border: 1px solid #ef9a9a;">
                    ${error}
                </div>
            </#if>

            <#if products?has_content>
                <div class="products-container">
                    <#list products as product>
                        <div class="product-card">
                            <div class="product-visual">
                                <#if product.cardImageLink()?? && product.cardImageLink()?trim?has_content>
                                    <img src="${product.cardImageLink()}" alt="${product.cardName()}">
                                <#else>
                                    <div style="font-size: 6rem; opacity: 0.18;">💳</div>
                                </#if>
                            </div>
                            <div class="product-body">
                                <h3 class="product-title">${product.cardName()}</h3>
                                <p class="product-desc">${product.description()!"Современная карта с отличными условиями и мгновенным выпуском."}</p>

                                <form action="/cards/open" method="post">
                                    <input type="hidden" name="cardProductId" value="${product.id()}">
                                    <button type="submit" class="btn btn-primary btn-cta">
                                        Открыть карту
                                    </button>
                                </form>
                            </div>
                        </div>
                    </#list>
                </div>
            <#else>
                <div class="empty-state">
                    <div style="font-size: 5rem; margin-bottom: 24px; opacity: 0.4;">💳</div>
                    <h3 style="margin-bottom: 16px; color: #444;">Пока нет доступных продуктов</h3>
                    <p style="max-width: 480px; margin: 0 auto 32px;">Попробуйте позже или свяжитесь с поддержкой</p>
                    <a href="/cards" class="btn btn-primary">Вернуться к картам</a>
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