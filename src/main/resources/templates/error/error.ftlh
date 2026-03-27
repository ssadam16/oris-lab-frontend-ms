<#-- templates/error/404.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Ошибка сервера</title>
    <link rel="stylesheet" href="/static/css/main.css">
</head>
<body>

<#include "../fragments/header.ftlh">

<main>
    <div class="container error-container">
        <div class="error-code">500</div>
        <div class="error-message">${errorMessage!"Ошибка!"}</div>
        <div class="error-details">
            ${exceptionName!"Ошибка сервера"}
        </div>
        <a href="/" class="btn btn-primary">На главную</a>
    </div>
</main>
</body>
</html>