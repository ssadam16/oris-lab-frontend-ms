<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Выписка по карте - ${contractName}</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', 'Roboto', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 40px;
        }

        .header h1 {
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .header .card-info {
            display: flex;
            gap: 30px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .header .info-item {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,255,255,0.2);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
        }

        .header .info-item i {
            font-style: normal;
            font-weight: normal;
        }

        /* Period Panel */
        .period-panel {
            background: #f8f9fa;
            padding: 20px 40px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .period-info {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .period-badge {
            background: white;
            padding: 8px 16px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            color: #495057;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .period-badge strong {
            color: #667eea;
        }

        .period-badge::before {
            content: "📅";
            font-size: 16px;
        }

        /* Summary Cards */
        .summary {
            display: flex;
            justify-content: center;
            padding: 30px 40px;
            background: white;
            border-bottom: 1px solid #e9ecef;
        }

        .summary-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px 40px;
            border-radius: 16px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
            min-width: 280px;
        }

        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .summary-card .label {
            font-size: 14px;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 10px;
        }

        .summary-card .value {
            font-size: 32px;
            font-weight: bold;
            color: #212529;
        }

        /* Table */
        .table-wrapper {
            overflow-x: auto;
            padding: 0 40px 40px 40px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        thead {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-bottom: 2px solid #dee2e6;
        }

        th {
            padding: 16px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            color: #495057;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 16px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }

        tbody tr {
            transition: all 0.3s;
        }

        tbody tr:hover {
            background: #f8f9fa;
            transform: scale(1.01);
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .amount {
            font-weight: 700;
            font-size: 16px;
            color: #212529;
        }

        .transaction-date {
            font-family: 'Courier New', monospace;
            font-size: 13px;
            color: #6c757d;
        }

        .contract-badge {
            background: #e7f3ff;
            color: #0066cc;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 500;
            display: inline-block;
        }

        .description {
            max-width: 300px;
            color: #6c757d;
            font-size: 13px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 40px;
            background: #f8f9fa;
            border-radius: 16px;
            margin: 0 40px 40px 40px;
        }

        .empty-state .icon {
            font-size: 64px;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            color: #495057;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6c757d;
        }

        /* Back Button */
        .back-button {
            padding: 0 40px 40px 40px;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 28px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }

        .back-btn:hover {
            transform: translateX(-5px);
            box-shadow: 0 4px 15px rgba(102,126,234,0.4);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                padding: 20px;
            }

            .header h1 {
                font-size: 22px;
            }

            .period-panel, .summary, .table-wrapper {
                padding-left: 20px;
                padding-right: 20px;
            }

            .summary-card {
                padding: 20px;
                min-width: auto;
                width: 100%;
            }

            th, td {
                padding: 12px 8px;
                font-size: 12px;
            }

            .period-info {
                flex-direction: column;
                gap: 10px;
            }
        }

        /* Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        tbody tr {
            animation: fadeIn 0.3s ease-out forwards;
        }
    </style>
</head>

<body>

<div class="container">
    <!-- Header with Card Info -->
    <div class="header">
        <h1>💳 Выписка по карте</h1>
        <div class="card-info">
            <div class="info-item">
                <span>🏷️</span>
                <span><strong>${contractName}</strong></span>
            </div>
            <div class="info-item">
                <span>📅</span>
                <span>Период: ${from} - ${to}</span>
            </div>
        </div>
    </div>

    <!-- Period Panel -->
    <div class="period-panel">
        <div class="period-info">
            <div class="period-badge">
                <strong>С:</strong> ${from}
            </div>
            <div class="period-badge">
                <strong>По:</strong> ${to}
            </div>
        </div>
    </div>

    <#if cardStatement?? && cardStatement.transactions()?? && cardStatement.transactions()?size gt 0>
    <#-- Calculate total turnover (sum of absolute values) -->
        <#assign totalTurnover = 0>
        <#list cardStatement.transactions() as transaction>
            <#assign cleanAmount = transaction.amount()>
            <#if cleanAmount lt 0>
                <#assign totalTurnover = totalTurnover + (cleanAmount * -1)>
            <#else>
                <#assign totalTurnover = totalTurnover + cleanAmount>
            </#if>
        </#list>

        <!-- Summary Cards (only total turnover) -->
        <div class="summary">
            <div class="summary-card">
                <div class="label">💰 Оборот за период</div>
                <div class="value">${totalTurnover?string('0.00')} ₽</div>
            </div>
        </div>

        <!-- Transactions Table -->
        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th>📅 Дата и время</th>
                    <th>👤 Контрагент</th>
                    <th>💰 Сумма</th>
                    <th>📝 Описание</th>
                </tr>
                </thead>
                <tbody>
                <#list cardStatement.transactions() as transaction>
                    <tr>
                        <td class="transaction-date">
                            ${transaction.createdAt()}
                        </td>
                        <td>
                            <#if transaction.targetContractId()??>
                                <span class="contract-badge">${transaction.targetContractId()}</span>
                            <#else>
                                <span style="color: #adb5bd;">—</span>
                            </#if>
                        </td>
                        <td>
                            <span class="amount">${transaction.amount()} ₽</span>
                        </td>
                        <td class="description">
                            ${transaction.description()!"—"}
                        </td>
                    </tr>
                </#list>
                </tbody>
            </table>
        </div>
    <#else>
        <!-- Empty State -->
        <div class="empty-state">
            <div class="icon">📭</div>
            <h3>Нет операций за выбранный период</h3>
            <p>За период с ${from} по ${to} не было совершено ни одной операции</p>
            <a href="/cards" class="back-btn" style="display: inline-flex; margin-top: 20px;">
                🔄 Вернуться к картам
            </a>
        </div>
    </#if>

    <!-- Back Button -->
    <div class="back-button">
        <a href="/cards" class="back-btn">
            ← Назад к списку карт
        </a>
    </div>
</div>

</body>
</html>