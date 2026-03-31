<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>История операций — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        .history-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #1e2937;
            margin-bottom: 8px;
        }

        .transactions-table {
            background: white;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 15px 45px rgba(0, 0, 0, 0.08);
        }

        .table-header {
            display: grid;
            grid-template-columns: 160px 180px 100px 1fr 140px;
            background: #f8fafc;
            padding: 20px 32px;
            font-weight: 600;
            color: #64748b;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .transaction-row {
            display: grid;
            grid-template-columns: 160px 180px 100px 1fr 140px;
            padding: 20px 32px;
            border-bottom: 1px solid #f1f5f9;
            transition: background 0.2s;
        }

        .transaction-row:hover {
            background: #f8fafc;
        }

        .amount {
            font-weight: 700;
            font-size: 1.25rem;
            text-align: right;
        }

        .amount-out {
            color: #ef4444;
        }

        .amount-in {
            color: #22c55e;
        }

        .contract-id {
            font-family: monospace;
            font-size: 0.95rem;
            color: #64748b;
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<div class="history-container">
    <h1 class="page-title"><i class="fas fa-history" style="color:#6366f1;"></i> История операций</h1>
    <p style="color:#64748b; margin-bottom: 32px;">Все переводы по вашим картам</p>

    <#if error??>
        <div style="background:#fee2e2; color:#991b1b; padding:18px 24px; border-radius:14px; margin-bottom:28px;">
            ${error}
        </div>
    </#if>

    <#if transactions?? && transactions?has_content>
        <div class="transactions-table">
            <div class="table-header">
                <div>Дата и время</div>
                <div>Откуда</div>
                <div>Куда</div>
                <div>Описание</div>
                <div style="text-align:right;">Сумма</div>
            </div>

            <#list transactions as tx>
                <div class="transaction-row">
                    <!-- Дата -->
                    <div>
                        <strong>${tx.createdAt()?datetime("yyyy-MM-dd'T'HH:mm:ss")?string("dd.MM.yyyy HH:mm")}</strong>
                    </div>

                    <!-- Откуда -->
                    <div class="contract-id">
                        ${tx.sourceContractId()}
                    </div>

                    <!-- Куда -->
                    <div class="contract-id">
                        ${tx.targetContractId()}
                    </div>

                    <!-- Описание -->
                    <div>
                        ${tx.description()! "Перевод"}
                    </div>

                    <!-- Сумма -->
                    <div class="amount">
                        ${tx.amount()?string(",##0.00")} ₽
                    </div>
                </div>
            </#list>
        </div>
    <#else>
        <div style=" text-align:center; padding:100px 40px; background:white; border-radius:24px; box-shadow:0 15px 45px
                 rgba(0,0,0,0.08);
            ">
            <i class="fas fa-inbox" style="font-size:5rem; color:#cbd5e1; margin-bottom:24px;"></i>
            <h3>Операций пока нет</h3>
            <p style="color:#64748b; max-width:400px; margin:20px auto;">
                Сделайте первый перевод — история появится здесь
            </p>
            <a href="/transfers" class="btn btn-primary">Сделать перевод</a>
        </div>
    </#if>

    <div style="text-align:center; margin-top:40px;">
        <a href="/transfers" class="btn" style="background:white; border:2px solid #e2e8f0; color:#2563eb;">
            ← Назад к переводам
        </a>
    </div>
</div>
</body>
</html>