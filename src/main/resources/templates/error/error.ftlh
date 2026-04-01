<#-- templates/error/500.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Внутренняя ошибка сервера</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        .error-page {
            min-height: calc(100vh - 200px);
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem;
        }

        .error-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 600px;
            width: 100%;
            padding: 3rem;
            text-align: center;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .error-code {
            font-size: 120px;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            line-height: 1;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }

        .error-icon {
            font-size: 80px;
            margin-bottom: 1rem;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.1);
            }
        }

        .error-title {
            font-size: 28px;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 1rem;
        }

        .error-message {
            font-size: 18px;
            color: #4a5568;
            margin-bottom: 1.5rem;
            line-height: 1.6;
        }

        .error-details {
            background: #f7fafc;
            border-left: 4px solid #f56565;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            text-align: left;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            color: #2d3748;
            overflow-x: auto;
            word-break: break-word;
        }

        .error-details pre {
            margin: 0;
            white-space: pre-wrap;
            font-family: inherit;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }

        .btn-secondary {
            background: #edf2f7;
            color: #4a5568;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
            transform: translateY(-2px);
        }

        .support-text {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e2e8f0;
            font-size: 14px;
            color: #718096;
        }

        .support-text a {
            color: #667eea;
            text-decoration: none;
        }

        .support-text a:hover {
            text-decoration: underline;
        }

        @media (max-width: 640px) {
            .error-card {
                padding: 2rem;
                margin: 1rem;
            }

            .error-code {
                font-size: 80px;
            }

            .error-title {
                font-size: 24px;
            }

            .error-message {
                font-size: 16px;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                justify-content: center;
            }
        }
    </style>
</head>
<body>

<#include "../fragments/header.ftlh">

<div class="error-page">
    <div class="error-card">
        <div class="error-icon">🔧</div>
        <div class="error-code">500</div>
        <h1 class="error-title">Внутренняя ошибка сервера</h1>

        <div class="error-message">
            ${errorMessage!"Извините, на сервере произошла непредвиденная ошибка. Наша команда уже работает над её устранением."}
        </div>

        <#if exceptionName?? && exceptionName?has_content>
            <div class="error-details">
                <strong style="color: #f56565;">Техническая информация:</strong>
                <pre>${exceptionName}</pre>
                <#if errorTrace?? && errorTrace?has_content>
                    <details style="margin-top: 0.5rem;">
                        <summary style="cursor: pointer; color: #667eea;">Показать детали</summary>
                        <pre style="margin-top: 0.5rem; font-size: 12px;">${errorTrace}</pre>
                    </details>
                </#if>
            </div>
        </#if>

        <div class="button-group">
            <a href="javascript:history.back()" class="btn btn-secondary">
                ← Вернуться назад
            </a>
            <a href="/" class="btn btn-primary">
                🏠 На главную
            </a>
        </div>

        <div class="support-text">
            <p>Если проблема повторяется, пожалуйста, <a href="/support">свяжитесь с поддержкой</a></p>
            <p style="margin-top: 0.5rem; font-size: 12px;">Код ошибки: 500 | ${.now?string("dd.MM.yyyy HH:mm:ss")}</p>
        </div>
    </div>
</div>

</body>
</html>