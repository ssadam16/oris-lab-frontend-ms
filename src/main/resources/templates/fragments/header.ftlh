<#-- templates/fragments/header.ftlh -->
<header class="header">
    <div class="container">
        <nav class="nav">
            <a href="/" class="logo">TechnoBank</a>

            <div class="nav-links">
                <#assign currentPage = activePage!'' />

                <a href="/" class="<#if currentPage == 'home'>active</#if>">
                    <i class="fas fa-home"></i> Главная
                </a>

                <#if Session.token?? && Session.userId??>
                    <a href="/cards" class="<#if currentPage == 'cards'>active</#if>">
                        <i class="fas fa-credit-card"></i> Мои карты
                    </a>
                    <a href="/transfers" class="<#if currentPage == 'transfers'>active</#if>">
                        <i class="fas fa-exchange-alt"></i> Переводы
                    </a>
                    <a href="/transfers/history" class="<#if currentPage == 'history'>active</#if>">
                        <i class="fas fa-history"></i> История
                    </a>
                    <a href="/profile" class="<#if currentPage == 'profile'>active</#if>">
                        <i class="fas fa-user"></i> Профиль
                    </a>

                    <form action="/logout" method="post" style="margin-left: 12px;">
                        <button type="submit" class="btn-logout">
                            <i class="fas fa-sign-out-alt"></i> Выйти
                        </button>
                    </form>
                <#else>
                    <a href="/sign-in">Войти</a>
                    <a href="/sign-up">Регистрация</a>
                </#if>
            </div>
        </nav>
    </div>
</header>