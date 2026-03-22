<#-- ... остальная часть страницы ... -->

<#if transactions.transactionElementResponse()?size == 0>
    <div style="text-align: center; padding: 40px;">
        <div style="font-size: 3rem; margin-bottom: 10px;">📊</div>
        <p>Нет операций за выбранный период</p>
    </div>
<#else>
    <table style="width: 100%; border-collapse: collapse;">
        <thead>
        <tr style="background: var(--light); border-bottom: 2px solid var(--border);">
            <th style="padding: 12px; text-align: left;">Дата</th>
            <th style="padding: 12px; text-align: left;">Описание</th>
            <th style="padding: 12px; text-align: right;">Сумма</th>
        </tr>
        </thead>
        <tbody>
        <#list transactions.transactionElementResponse() as transaction>
            <tr style="border-bottom: 1px solid var(--border);">
                <td style="padding: 12px;">
                    ${transaction.targetContractId()}
                </td>
                <td style="padding: 12px;">
                    ${transaction.description()}
                </td>
                <td style="padding: 12px; text-align: right; font-weight: bold;">
                    ${transaction.amount()} ₽
                </td>
            </tr>
        </#list>
        </tbody>
    </table>
</#if>