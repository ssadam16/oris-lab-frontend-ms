<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Переводы — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .transfer-container { max-width: 820px; margin: 40px auto; padding: 0 20px; }
        .transfer-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .transfer-header {
            background: linear-gradient(135deg, #2563eb, #1e40af);
            color: white;
            padding: 40px 40px;
            text-align: center;
        }
        .transfer-body { padding: 50px 45px; }
        .form-label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 10px;
            display: block;
        }
        .recipient-type {
            display: flex;
            gap: 12px;
            margin-bottom: 32px;
            flex-wrap: wrap;
        }
        .type-btn {
            flex: 1;
            min-width: 140px;
            padding: 16px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 16px;
            background: white;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }
        .type-btn.active {
            border-color: #2563eb;
            background: #2563eb;
            color: white;
            box-shadow: 0 8px 20px rgba(37,99,235,0.25);
        }
        .amount-group {
            background: #f8fafc;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            padding: 12px 20px;
            display: flex;
            align-items: center;
        }
        .amount-group:focus-within { border-color: #2563eb; }
        .amount-input {
            font-size: 2.4rem;
            font-weight: 700;
            background: transparent;
            border: none;
            flex: 1;
            text-align: right;
            outline: none;
        }
        .btn-transfer {
            width: 100%;
            padding: 18px;
            font-size: 1.2rem;
            font-weight: 600;
            border-radius: 16px;
            background: linear-gradient(135deg, #2563eb, #1e40af);
            color: white;
            border: none;
            margin-top: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-transfer:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 35px rgba(37,99,235,0.35);
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<div class="transfer-container">
    <#if success??>
        <div class="alert alert-success" style="margin-bottom:24px;">
            <i class="fas fa-check-circle"></i> ${success}
        </div>
    </#if>
    <#if error??>
        <div class="alert alert-danger" style="margin-bottom:24px;">
            <i class="fas fa-exclamation-triangle"></i> ${error}
        </div>
    </#if>

    <div class="transfer-card">
        <div class="transfer-header">
            <h2><i class="fas fa-paper-plane"></i> Новый перевод</h2>
            <p style="margin-top:8px; opacity:0.95;">Мгновенно • Без комиссии • Надёжно</p>
        </div>

        <div class="transfer-body">
            <form action="/transfers" method="post" id="transferForm">

                <div style="margin-bottom:28px;">
                    <label class="form-label">С карты</label>
                    <select name="sourceContractName" class="form-control" required style="padding:16px; font-size:1.05rem;">
                        <option value="">— Выберите карту —</option>
                        <#list cards as card>
                            <option value="${card.contractName()}">
                                ${card.plasticName()!"Карта"} ••••
                                <#if card.pan()?? && card.pan()?length gte 4>${card.pan()?substring(card.pan()?length-4)}</#if>
                            </option>
                        </#list>
                    </select>
                </div>

                <div style="margin-bottom:28px;">
                    <label class="form-label">Получатель</label>
                    <div class="recipient-type">
                        <label class="type-btn active" data-type="card"><input type="radio" name="recipientType" value="card" checked style="display:none;"> По номеру карты</label>
                        <label class="type-btn" data-type="contract"><input type="radio" name="recipientType" value="contract" style="display:none;"> По договору</label>
                        <label class="type-btn" data-type="phone"><input type="radio" name="recipientType" value="phone" style="display:none;"> По телефону</label>
                    </div>
                </div>

                <div style="margin-bottom:28px;">
                    <label id="recipientLabel" class="form-label">Номер карты получателя</label>
                    <input type="text" name="recipientIdentifier" id="recipientIdentifier"
                           class="form-control" style="padding:16px; font-size:1.1rem;"
                           placeholder="4276 1234 5678 9012" required>
                </div>

                <div style="margin-bottom:28px;">
                    <label class="form-label">Сумма перевода (₽)</label>
                    <div class="amount-group">
                        <input type="number" name="amount" step="0.01" min="1" max="1000000"
                               class="amount-input" placeholder="0.00" required>
                        <span style="font-size:2.2rem; color:#64748b; margin-left:12px;">₽</span>
                    </div>
                </div>

                <div style="margin-bottom:32px;">
                    <label class="form-label">Комментарий <span style="font-weight:400;color:#888;">(необязательно)</span></label>
                    <textarea name="description" class="form-control" rows="3"
                              placeholder="За аренду • Подарок • Возврат долга..."></textarea>
                </div>

                <button type="submit" class="btn-transfer">
                    <i class="fas fa-paper-plane"></i> Выполнить перевод
                </button>
            </form>
        </div>
    </div>

    <div style="text-align:center; margin-top:30px;">
        <a href="/transfers/history" style="color:#2563eb; font-weight:500;">
            <i class="fas fa-history"></i> Посмотреть историю операций →
        </a>
    </div>
</div>

<script>
    document.querySelectorAll('.type-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.type-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            const type = this.dataset.type;
            const label = document.getElementById('recipientLabel');
            const input = document.getElementById('recipientIdentifier');

            if (type === 'card') { label.textContent = 'Номер карты получателя'; input.placeholder = '4276 1234 5678 9012'; }
            else if (type === 'contract') { label.textContent = 'Номер договора получателя'; input.placeholder = 'CONTRACT-12345678'; }
            else if (type === 'phone') { label.textContent = 'Телефон получателя'; input.placeholder = '+7 (999) 123-45-67'; }
        });
    });
</script>
</body>
</html>