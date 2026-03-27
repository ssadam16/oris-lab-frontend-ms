<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Переводы — TechnoBank</title>
    <link rel="stylesheet" href="/static/css/main.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .card-hover:hover { transform: translateY(-3px); transition: all 0.2s; }
        .amount-input {
            font-size: 1.6rem;
            font-weight: 600;
            text-align: right;
        }
        .nav-links a.active {
            color: var(--primary);
            font-weight: bold;
            border-bottom: 2px solid var(--primary);
        }
    </style>
</head>
<body>
<#include "fragments/header.ftlh">

<main>
    <div class="container" style="padding: 48px 0 80px;">
        <div style="max-width: 800px; margin: 0 auto;">

            <!-- Сообщения -->
            <#if success??>
                <div class="alert alert-success" style="padding: 16px; border-radius: 12px; margin-bottom: 24px;">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            </#if>
            <#if error??>
                <div class="alert alert-danger" style="padding: 16px; border-radius: 12px; margin-bottom: 24px;">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </#if>

            <div class="card" style="border-radius: 20px; box-shadow: 0 8px 32px rgba(0,0,0,0.08);">
                <div class="card-header" style="background: var(--primary); color: white; border-radius: 20px 20px 0 0;">
                    <h3 style="margin: 0;"><i class="fas fa-exchange-alt"></i> Новый перевод</h3>
                </div>
                <div class="card-body" style="padding: 40px 32px;">

                    <form action="/transfers" method="post" id="transferForm">

                        <!-- Источник (своя карта) -->
                        <div style="margin-bottom: 28px;">
                            <label style="font-weight: 600; display: block; margin-bottom: 8px;">С карты</label>
                            <select name="sourceContractName" class="form-control" required style="padding: 14px; font-size: 1.05rem;">
                                <option value="">— Выберите карту —</option>
                                <#list cards as card>
                                    <option value="${card.contractName()}"
                                            <#if card.pan()?? && card.pan()?length gte 4>
                                        data-pan="${card.pan()?substring(card.pan()?length-4)}"
                                            </#if>>
                                        ${card.plasticName()!"Карта"} ••••
                                        <#if card.pan()?? && card.pan()?length gte 4>
                                            ${card.pan()?substring(card.pan()?length-4)}
                                        </#if>
                                    </option>
                                </#list>
                            </select>
                        </div>

                        <!-- Тип получателя -->
                        <div style="margin-bottom: 28px;">
                            <label style="font-weight: 600; display: block; margin-bottom: 10px;">Получатель</label>
                            <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                <label class="btn-option active" data-type="card">
                                    <input type="radio" name="recipientType" value="card" checked style="display:none;">
                                    По номеру карты
                                </label>
                                <label class="btn-option" data-type="contract">
                                    <input type="radio" name="recipientType" value="contract" style="display:none;">
                                    По договору
                                </label>
                                <label class="btn-option" data-type="phone">
                                    <input type="radio" name="recipientType" value="phone" style="display:none;">
                                    По телефону
                                </label>
                            </div>
                        </div>

                        <!-- Поле получателя -->
                        <div style="margin-bottom: 28px;">
                            <label id="recipientLabel" style="font-weight: 600; display: block; margin-bottom: 8px;">
                                Номер карты получателя
                            </label>
                            <input type="text"
                                   name="recipientIdentifier"
                                   id="recipientIdentifier"
                                   class="form-control"
                                   style="padding: 14px; font-size: 1.1rem;"
                                   placeholder="4276 1234 5678 9012"
                                   required>
                        </div>

                        <!-- Сумма -->
                        <div style="margin-bottom: 28px;">
                            <label style="font-weight: 600; display: block; margin-bottom: 8px;">Сумма перевода (₽)</label>
                            <div style="display: flex; align-items: center; background: #f8f9fa; border-radius: 12px; padding: 4px;">
                                <input type="number"
                                       name="amount"
                                       step="0.01"
                                       min="1"
                                       max="1000000"
                                       class="amount-input form-control"
                                       style="border: none; background: transparent; flex: 1;"
                                       placeholder="0.00"
                                       required>
                                <span style="padding: 0 20px; font-size: 1.4rem; color: #666;">₽</span>
                            </div>
                            <small style="color: #666;">Максимум 1 000 000 ₽ за перевод</small>
                        </div>

                        <!-- Комментарий -->
                        <div style="margin-bottom: 32px;">
                            <label style="font-weight: 600; display: block; margin-bottom: 8px;">Комментарий (необязательно)</label>
                            <textarea name="description"
                                      class="form-control"
                                      rows="3"
                                      placeholder="Например: За аренду квартиры"></textarea>
                        </div>

                        <button type="submit"
                                class="btn btn-primary"
                                style="width: 100%; padding: 16px; font-size: 1.1rem; font-weight: 600;">
                            <i class="fas fa-paper-plane"></i> Выполнить перевод
                        </button>
                    </form>
                </div>
            </div>

            <div style="text-align: center; margin-top: 24px;">
                <a href="/transfers/history" style="color: var(--primary); text-decoration: none;">
                    <i class="fas fa-history"></i> Посмотреть всю историю операций →
                </a>
            </div>
        </div>
    </div>
</main>

<script>
    // Переключение типа получателя
    document.querySelectorAll('.btn-option').forEach(label => {
        label.addEventListener('click', function() {
            document.querySelectorAll('.btn-option').forEach(l => l.classList.remove('active'));
            this.classList.add('active');

            const type = this.dataset.type;
            const labelEl = document.getElementById('recipientLabel');
            const input = document.getElementById('recipientIdentifier');

            if (type === 'card') {
                labelEl.textContent = 'Номер карты получателя';
                input.placeholder = '4276 1234 5678 9012';
            } else if (type === 'contract') {
                labelEl.textContent = 'Номер договора получателя';
                input.placeholder = 'CONTRACT-12345678';
            } else if (type === 'phone') {
                labelEl.textContent = 'Номер телефона получателя';
                input.placeholder = '+7 (999) 123-45-67';
            }
        });
    });

    // Простая валидация суммы
    document.getElementById('transferForm').addEventListener('submit', function(e) {
        const amount = parseFloat(this.amount.value);
        if (amount > 1000000) {
            e.preventDefault();
            alert('Максимальная сумма одного перевода — 1 000 000 ₽');
        }
    });
</script>

<style>
    .btn-option {
        padding: 12px 20px;
        border: 2px solid #ddd;
        border-radius: 12px;
        cursor: pointer;
        transition: all 0.2s;
        flex: 1;
        text-align: center;
    }
    .btn-option.active {
        border-color: var(--primary);
        background: var(--primary);
        color: white;
    }
    .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .alert-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
</style>

</body>
</html>