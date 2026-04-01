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

        .change-period-btn {
            background: white;
            border: 2px solid #667eea;
            color: #667eea;
            padding: 8px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .change-period-btn:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102,126,234,0.4);
        }

        /* Summary Cards */
        .summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            padding: 30px 40px;
            background: white;
            border-bottom: 1px solid #e9ecef;
        }

        .summary-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 16px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
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

        .summary-card.income .value {
            color: #22c55e;
        }

        .summary-card.expense .value {
            color: #ef4444;
        }

        .summary-card.total .value {
            color: #667eea;
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

        .amount-positive {
            color: #22c55e;
            font-weight: 700;
            font-size: 16px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .amount-positive::before {
            content: "↑";
            font-size: 14px;
        }

        .amount-negative {
            color: #ef4444;
            font-weight: 700;
            font-size: 16px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .amount-negative::before {
            content: "↓";
            font-size: 14px;
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

            .summary {
                grid-template-columns: 1fr;
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

    <#if transactions?has_content>
        <!-- Summary Cards -->
        <div class="summary">
            <div class="summary-card income">
                <div class="label">💰 Доходы</div>
                <div class="value">+${totalIncome?string('0.00')} ₽</div>
            </div>
            <div class="summary-card expense">
                <div class="label">💸 Расходы</div>
                <div class="value">-${totalExpense?string('0.00')} ₽</div>
            </div>
            <div class="summary-card total">
                <div class="label">📊 Итого</div>
                <div class="value">${total?string('0.00')} ₽</div>
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
                <#list transactions as tx>
                    <tr>
                        <td class="transaction-date">
                            ${tx.dateTime()}
                        </td>
                        <td>
                            <span class="contract-badge">${tx.counterpartyName()}</span>
                        </td>
                        <td>
                            <#if tx.amount() gt 0>
                                <span class="amount-positive">+${tx.amount()?string('0.00')} ₽</span>
                            <#else>
                                <span class="amount-negative">${tx.amount()?string('0.00')} ₽</span>
                            </#if>
                        </td>
                        <td class="description">
                            ${tx.description()!"—"}
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