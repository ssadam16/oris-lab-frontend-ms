<DOCUMENT filename="document-card-closing.ftlh">
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Документ о закрытии карты — TechnoBank</title>
        <link rel="stylesheet" href="/static/css/main.css">
        <style>
            body {
                background: linear-gradient(135deg, #fef2f2 0%, #f8f9fa 100%);
                font-family: 'Segoe UI', Arial, sans-serif;
                min-height: 100vh;
            }
            .document {
                max-width: 820px;
                margin: 40px auto;
                padding: 70px 90px;
                background: white;
                border: 3px solid #991b1b;
                border-radius: 12px;
                box-shadow: 0 15px 50px rgba(153, 27, 27, 0.2);
                position: relative;
                overflow: hidden; /* важно, чтобы штамп не вылезал */
            }

            .bank-header {
                text-align: center;
                border-bottom: 4px double #991b1b;
                padding-bottom: 25px;
                margin-bottom: 50px;
            }

            .logo {
                font-size: 2.6rem;
                font-weight: 700;
                color: #991b1b;
                letter-spacing: -1px;
            }

            .title {
                text-align: center;
                font-size: 1.9rem;
                margin: 35px 0 10px;
                color: #991b1b;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .subtitle {
                text-align: center;
                color: #dc2626;
                font-size: 1rem;
                margin-bottom: 30px;
                font-weight: 500;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin: 35px 0;
            }

            td {
                padding: 14px 8px;
                border-bottom: 1px solid #fecaca;
                vertical-align: top;
            }

            .label {
                font-weight: 600;
                width: 42%;
                color: #991b1b;
                background: #fef2f2;
                padding-left: 16px;
            }

            .value {
                background: white;
            }

            .warning-box {
                background: linear-gradient(135deg, #fee2e2 0%, #fff5f5 100%);
                border-left: 4px solid #dc2626;
                padding: 20px;
                margin: 30px 0;
                border-radius: 8px;
            }

            /* ШТАМП НА ЗАДНЕМ ФОНЕ */
            .stamp {
                position: absolute;
                top: 45%;
                left: 50%;
                transform: translate(-50%, -50%) rotate(-35deg);
                font-size: 7.5rem;
                font-weight: 900;
                color: rgba(220, 38, 38, 0.12);
                border: 10px solid rgba(220, 38, 38, 0.18);
                padding: 20px 90px;
                border-radius: 15px;
                background: transparent;
                pointer-events: none;
                z-index: -1;           /* ← вот главное изменение */
                text-transform: uppercase;
                letter-spacing: 12px;
                white-space: nowrap;
                line-height: 1;
                opacity: 0.85;
            }

            .stamp i {
                margin-right: 15px;
                font-size: 6.5rem;
            }

            .signatures {
                margin-top: 80px;
                display: flex;
                justify-content: space-between;
                align-items: flex-end;
                border-top: 2px dashed #fecaca;
                padding-top: 30px;
            }

            .signature-line {
                text-align: center;
                flex: 1;
            }

            .qr-placeholder {
                width: 80px;
                height: 80px;
                background: repeating-linear-gradient(45deg, #f3f4f6, #f3f4f6 10px, #e5e7eb 10px, #e5e7eb 20px);
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                color: #9ca3af;
                margin: 0 auto 10px;
            }

            .footer {
                margin-top: 60px;
                text-align: center;
                color: #6b7280;
                font-size: 0.85rem;
                padding-top: 30px;
                border-top: 1px solid #fecaca;
            }

            @media print {
                .document {
                    margin: 0;
                    padding: 50px;
                    box-shadow: none;
                    border: 1px solid #ccc;
                }
                .stamp {
                    opacity: 0.25;
                    -webkit-print-color-adjust: exact;
                }
            }

            @media (max-width: 640px) {
                .document { padding: 30px 20px; margin: 20px; }
                .stamp { font-size: 4.5rem; padding: 12px 50px; }
            }
        </style>
    </head>
    <body>
    <div class="document">
        <!-- Штамп "ЗАКРЫТО" на заднем фоне -->
        <div class="stamp">
            <i class="fas fa-ban"></i> ЗАКРЫТО
        </div>

        <div class="bank-header">
            <div class="logo">TechnoBank</div>
            <p style="color: #991b1b;">Лицензия Банка России № 0000 от 01.01.2025</p>
        </div>

        <h1 class="title">ДОКУМЕНТ О ЗАКРЫТИИ БАНКОВСКОЙ КАРТЫ</h1>
        <div class="subtitle">
            <i class="fas fa-lock"></i> Карта деактивирована и больше не действительна
        </div>

        <div class="warning-box">
            <p><i class="fas fa-exclamation-triangle"></i> <strong>ВНИМАНИЕ!</strong> Данная карта закрыта и не может быть использована для проведения операций.</p>
            <p><i class="fas fa-clock"></i> Все привязанные автоплатежи и подписки отключены.</p>
            <p><i class="fas fa-coins"></i> Остаток средств на момент закрытия: ${closingBalance} ₽</p>
        </div>

        <table>
            <tr>
                <td class="label">Номер документа</td>
                <td class="value">DOC-CLOSE-${document.id()}</td>
            </tr>
            <tr>
                <td class="label">Дата закрытия</td>
                <td class="value">${document.createdDate()}</td>
            </tr>
            <tr>
                <td class="label">Клиент</td>
                <td class="value">${card.plasticName()!""}</td>
            </tr>
            <tr>
                <td class="label">Номер карты</td>
                <td class="value">${card.pan()?replace("(\\d{4})", "$1 ", "r")}</td>
            </tr>
            <tr>
                <td class="label">Тип карты</td>
                <td class="value">${card.cardProduct().cardName()!""}</td>
            </tr>
            <tr>
                <td class="label">Срок действия</td>
                <td class="value">${card.expDate()!""} (истек)</td>
            </tr>
            <tr>
                <td class="label">Номер договора</td>
                <td class="value">${card.contractName()!""}</td>
            </tr>
            <tr>
                <td class="label">Дата открытия</td>
                <td class="value">${openingDate}</td>
            </tr>
            <tr>
                <td class="label">Срок использования</td>
                <td class="value">${usagePeriod} дней</td>
            </tr>
        </table>

        <div class="signatures">
            <div class="signature-line">
                <div class="qr-placeholder">
                    <i class="fas fa-qrcode"></i>
                </div>
                <p>Электронная подпись</p>
                <p class="name">ТехноБанк</p>
            </div>
            <div class="signature-line">
                <div style="border-top: 2px solid #991b1b; width: 200px; margin: 0 auto;"></div>
                <p>Подпись клиента</p>
                <p class="name">_________________</p>
                <p>${.now?string("dd.MM.yyyy")}</p>
            </div>
            <div class="signature-line">
                <div style="border-top: 2px solid #991b1b; width: 200px; margin: 0 auto;"></div>
                <p>Подпись сотрудника</p>
                <p class="name">А.И. Петров</p>
                <p>Главный специалист</p>
            </div>
        </div>

        <div class="footer">
            <p><i class="fas fa-shield-alt"></i> Документ сформирован автоматически в системе TechnoBank.</p>
            <p>Электронная цифровая подпись является действительной. Храните документ в течение 3 лет.</p>
            <p style="margin-top: 15px; color: #991b1b; font-size: 0.8rem;">
                <i class="fas fa-info-circle"></i> При возникновении вопросов обратитесь в службу поддержки: support@technobank.ru
            </p>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/js/all.min.js"></script>
    </body>
    </html>
</DOCUMENT>