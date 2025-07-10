<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<header class="site-header">
    <div class="header-container container">
        <div class="logo">
            <%-- 로고 링크도 동적 경로 또는 루트 상대 경로로 만드는 것을 고려하세요. --%>
            <h1><a href="${pageContext.request.contextPath}/corporate/main">DD TOWN</a></h1>
        </div>
        <nav class="main-nav">
            <ul>
                <li class="has-submenu">
                    <a href="${pageContext.request.contextPath}/corporate/finance">기업 정보</a>
                    <ul class="submenu" style="display: none;">
                        <li><a href="${pageContext.request.contextPath}/corporate/finance">재무정보</a></li>
                        <li><a href="${pageContext.request.contextPath}/corporate/about">기업소개</a></li>
                        <li><a href="${pageContext.request.contextPath}/corporate/notice/list">기업공지</a></li>
                        <li><a href="${pageContext.request.contextPath}/corporate/location">기업위치</a></li>
                    </ul>
                </li>
                <li><a href="${pageContext.request.contextPath}/corporate/audition/schedule">오디션</a></li>
                <li><a href="${pageContext.request.contextPath}/corporate/artist/profile">아티스트 프로필</a></li>
                <li><a href="${pageContext.request.contextPath}/community/main">아티스트 커뮤니티</a></li>
            </ul>
        </nav>
    </div>
</header>