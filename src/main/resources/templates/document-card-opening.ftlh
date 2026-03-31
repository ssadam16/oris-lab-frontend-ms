<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Документ об открытии карты</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        body { background: #f8f9fa; font-family: 'Segoe UI', Arial, sans-serif; }
        .document {
            max-width: 820px;
            margin: 40px auto;
            padding: 70px 90px;
            background: white;
            border: 3px solid #1e293b;
            border-radius: 12px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.15);
            position: relative;
        }
        .bank-header {
            text-align: center;
            border-bottom: 4px double #1e293b;
            padding-bottom: 25px;
            margin-bottom: 50px;
        }
        .logo { font-size: 2.6rem; font-weight: 700; color: #2563eb; letter-spacing: -1px; }
        .title { text-align: center; font-size: 1.9rem; margin: 35px 0 10px; }
        table { width: 100%; border-collapse: collapse; margin: 35px 0; }
        td { padding: 14px 8px; border-bottom: 1px solid #e2e8f0; vertical-align: top; }
        .label { font-weight: 600; width: 42%; color: #475569; }
        .stamp {
            position: absolute;
            top: 220px;
            right: 90px;
            transform: rotate(-30deg);
            font-size: 4.5rem;
            color: rgba(34, 197, 94, 0.15);
            font-weight: bold;
            border: 6px solid rgba(34, 197, 94, 0.15);
            padding: 10px 50px;
            border-radius: 10px;
        }
    </style>
</head>
<body>
<div class="document">
    <div class="bank-header">
        <div class="logo">TechnoBank</div>
        <p>Лицензия Банка России № 0000 от 01.01.2025</p>
    </div>

    <h1 class="title">ДОКУМЕНТ ОБ ОТКРЫТИИ БАНКОВСКОЙ КАРТЫ</h1>

    <table>
        <tr><td class="label">Номер документа</td><td>DOC-OPEN-${document.id()}</td></tr>
        <tr><td class="label">Дата открытия</td><td>${document.createdDate()}</td></tr>
        <tr><td class="label">Клиент</td><td>${card.plasticName()!""}</td></tr>
        <tr><td class="label">Номер карты</td><td>${card.pan()?replace("(\\d{4})", "$1 ", "r")}</td></tr>
        <tr><td class="label">Тип карты</td><td>${card.cardProduct().cardName()!""}</td></tr>
        <tr><td class="label">Срок действия</td><td>${card.expDate()!""}</td></tr>
        <tr><td class="label">Номер договора</td><td>${card.contractName()!""}</td></tr>
    </table>

    <div class="stamp">ОТКРЫТО</div>

    <div style="margin-top:90px; text-align:center; color:#555; font-size:0.95rem;">
        <p>Документ сформирован автоматически в системе TechnoBank.</p>
        <p>Электронная цифровая подпись не требуется.</p>
    </div>
</div>
</body>
</html>