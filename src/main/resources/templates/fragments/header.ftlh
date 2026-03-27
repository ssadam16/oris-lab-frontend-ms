<#-- templates/fragments/header.ftlh -->
<header class="header">
    <div class="container">
        <nav class="nav">
            <a href="/" class="logo">TechnoBank</a>
            <div class="nav-links">

                <#-- Безопасное получение activePage с дефолтным значением -->
                <#assign currentPage = activePage!'' />

                <a href="/" class="<#if currentPage == 'home'>active</#if>">Главная</a>

                <#if Session.token?? && Session.userId??>
                    <a href="/cards" class="<#if currentPage == 'cards'>active</#if>">Мои карты</a>
                    <a href="/transfers" class="<#if currentPage == 'transfers'>active</#if>">Переводы</a>
                    <a href="/transfers/history" class="<#if currentPage == 'history'>active</#if>">История</a>
                    <a href="/profile" class="<#if currentPage == 'profile'>active</#if>">Профиль</a>

                    <form action="/logout" method="post" style="display: inline;">
                        <button type="submit" class="btn btn-logout">Выйти</button>
                    </form>
                <#else>
                    <a href="/sign-in">Войти</a>
                    <a href="/sign-up">Регистрация</a>
                </#if>
            </div>
        </nav>
    </div>
</header>

<style>
    .nav-links a.active {
        color: var(--primary);
        font-weight: bold;
        border-bottom: 2px solid var(--primary);
    }
    .nav-links a {
        display: inline-block;
        padding-bottom: 5px;
        text-decoration: none;
    }
    .btn-logout {
        background: var(--danger);
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 8px;
        cursor: pointer;
    }
    .btn-logout:hover {
        background: #dc2626;
    }
</style>