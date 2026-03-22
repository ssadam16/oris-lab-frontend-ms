<#-- templates/fragments/header.ftlh -->
<header class="header">
    <div class="container">
        <nav class="nav">
            <a href="/" class="logo">TechnoBank</a>
            <div class="nav-links">
                <#assign page = activePage!'' />

                <a href="/" class="<#if page == 'home'>active</#if>">Главная</a>

                <#if session?? && session.userId??>
                    <a href="/cards" class="<#if page == 'cards'>active</#if>">Мои карты</a>
                    <a href="/transfers" class="<#if page == 'transfers'>active</#if>">Переводы</a>
                    <a href="/profile" class="<#if page == 'profile'>active</#if>">Профиль</a>
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