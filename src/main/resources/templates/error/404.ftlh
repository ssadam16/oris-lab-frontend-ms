<#-- templates/error/404.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Страница не найдена</title>
    <link rel="stylesheet" href="/static/css/main.css">
</head>
<body>

<#include "../fragments/header.ftlh">

<main>
    <div class="container error-container">
        <div class="error-code">404</div>
        <div class="error-message">${errorMessage!"Страница не найдена"}</div>
        <div class="error-details">
            ${details!"Запрашиваемая страница не существует или была удалена"}
        </div>
        <a href="/" class="btn btn-primary">На главную</a>
    </div>
</main>
</body>
</html>