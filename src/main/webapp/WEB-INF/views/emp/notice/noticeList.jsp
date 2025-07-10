<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 공지사항 관리</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/pagination.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/emp_portal_style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <%@ include file="../../modules/headerPart.jsp" %>
<style>
    /* ---------------------------------- */
    /* 공통 & 기본 설정                   */
    /* ---------------------------------- */
    body {
        font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
        margin: 0;
        background-color: #f4f6f9;
        color: #212529;
    }
    a {
	    color: var(--primary-color);
	    text-decoration: none;
	    transition: color var(--transition-fast);
    }
    .text-center { text-align: center; }

    /* ---------------------------------- */
    /* 목록 페이지 - 컨테이너 & 검색 바    */
    /* ---------------------------------- */
    .list-view-container {
        background: #fff;
        padding: 25px 30px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }
    .top-section {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
        flex-wrap: wrap; /* 반응형을 위해 추가 */
        gap: 15px;
    }
    .notice-header-bar .notice-title {
        font-size: 1.8em; /* 공통 타이틀 크기 */
        font-weight: 700;
        color: #234aad;
        display: flex;
        align-items: center;
        gap: 10px;
        flex-grow: 1;
    }
    .emp-search-add-bar {
        padding: 10px;
        border-radius: 5px;
        flex-shrink: 0;
        width: 100%;
    }
    .emp-search-add-bar form {
        display: flex;
        align-items: center;
        gap: 8px;
        flex-wrap: wrap;
        justify-content: flex-end;
       	width: 100%;
    }
    .emp-search-add-bar input[type="text"],
    .emp-search-add-bar select {
        width:auto;
        padding: 8px;
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 0.9em;
        min-width: 150px;
    }
    .emp-search-add-bar input[type="submit"] {
        padding: 8px 15px;
        border-radius: 4px;
        text-decoration: none;
        font-size: 0.9em;
        border: none;
        cursor: pointer;
        width: auto;
        background-color: #007bff;
        color: white;
    }
    .emp-search-add-bar input[type="submit"]:hover { background-color: #0056b3; }
    /* ---------------------------------- */
    /* 목록 페이지 - 테이블                */
    /* ---------------------------------- */
    .list-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0; /* 셀 간격 제거 */
        background: #fff;
        margin-bottom: 25px; /* 하단 여백 */
        border-radius: 10px; /* 테이블 전체에 둥근 모서리 */
        box-shadow: 0 5px 15px rgba(0,0,0,0.08); /* 테이블 전체에 그림자 */
        overflow: hidden; /* 둥근 모서리를 위해 내용 숨김 */
        font-size: 0.95em;
    }
    .list-table thead {
        border-top: none;
        border-bottom: none;
    }
    .list-table th {
        background: #f0f5ff; /* 헤더 배경색 */
        color: #234aad; /* 헤더 텍스트 색상 */
        font-weight: 700; /* 더 굵게 */
        border-bottom: 1px solid #d0d8e2; /* 헤더 하단에 구분선 */
        padding: 15px 12px;
        text-align: center;
    }
    .list-table tbody tr {
        border-bottom: 1px solid #e9ecef; /* 셀 하단 구분선 */
        transition: background-color 0.2s ease;
    }
    .list-table tbody tr:last-child {
        border-bottom: none; /* 마지막 행 하단 구분선 제거 */
    }
    .list-table tbody tr:nth-child(even) {
        background-color: #f9f9f9; /* 짝수 행 배경색 */
    }
    .list-table tbody tr:hover {
        background-color: #eef7ff; /* 호버 시 배경색 변경 */
    }
    .list-table td {
        padding: 15px 12px;
        vertical-align: middle;
        text-align: center;
        color: #495057; /* 본문 텍스트 색상 */
    }
    .list-table .notice-title-cell {
        text-align: left; /* 제목 셀은 왼쪽 정렬 */
        font-weight: 500;
    }
    .list-table .view-link {
        color: #234aad; /* 링크 색상 통일 */
        text-decoration: none;
        transition: color 0.2s;
    }
    .list-table .view-link:hover {
        color: #007bff;
        text-decoration: underline;
    }
    /* 데이터 없을 때 메시지 */
    .list-table tbody tr td[colspan="5"] {
        padding: 50px 0;
        color: #6c757d;
        font-style: italic;
    }
    /* ---------------------------------- */
    /* ⭐최종 재수정: 페이지네이션 및 버튼 정렬⭐ */
    /* ---------------------------------- */
    .pagination-and-button-wrapper {
        display: grid; /* ⭐변경: flex 대신 grid 사용⭐ */
        grid-template-columns: 1fr auto 1fr; /* ⭐추가: 3열 레이아웃 정의 (좌측여백-페이지네이션-우측여백)⭐ */
        align-items: center; /* 수직 가운데 정렬 */
        width: 100%;
        padding: 30px 0 10px 0;
    }
    .pagination-container {
        grid-column: 2 / 3; /* ⭐변경: 그리드 2번째 열에 위치⭐ */
        justify-self: center; /* ⭐추가: 그리드 셀 내에서 가운데 정렬⭐ */
        padding: 0;
        margin: 0; /* 기존 마진 제거 */
    }
    .pagination { list-style: none; display: flex; padding: 0; margin: 0; gap: 6px; }
    .pagination li a, .pagination li span {
        display: block; padding: 8px 14px; color: #6c757d;
        border: 1px solid #dee2e6; border-radius: 6px; transition: all 0.2s;
    }
    .pagination li a:hover { background-color: #e9ecef; border-color: #ced4da; }
    .pagination li.active a, .pagination li.active span {
        background-color: #007bff; color: white; border-color: #007bff; font-weight: 600;
    }
    .pagination li.disabled span { color: #adb5bd; background-color: #f8f9fa; cursor: not-allowed; }

    .add-notice-button-area {
        grid-column: 3 / 4; /* ⭐변경: 그리드 3번째 열에 위치⭐ */
        justify-self: end; /* ⭐추가: 그리드 셀 내에서 오른쪽 끝 정렬⭐ */
    }
    /* ---------------------------------- */
    /* 버튼 UI (공통)                   */
    /* ---------------------------------- */
    .btn {
        display: inline-block; padding: 10px 20px; font-size: 0.95em; font-weight: 500;
        text-align: center; text-decoration: none; border: none; border-radius: 6px;
        cursor: pointer; transition: all 0.2s ease-in-out;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .btn:hover { transform: translateY(-1px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
    .btn-primary { background-color: #234aad; color: white; }
    .btn-primary:hover { background-color: #1a3c8a; }
    .btn-secondary { background-color: #007bff; color: white; }
    .btn-secondary:hover { background-color: #0069d9; }
    .btn-sm { padding: 5px 10px; font-size: 0.85em; }
	.server-message { padding: 10px; margin-bottom: 15px; border-radius: 4px; text-align: center; display: none; }
    .server-message.success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .server-message.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    hr { border: none; border-top: 1px solid !important; /* 부드러운 구분선 */ }
</style>
</head>
<body>

<div class="emp-container">
    <%@ include file="../modules/header.jsp" %>

	<div class="emp-body-wrapper">
		<%@ include file="../modules/aside.jsp" %>
		<main class="emp-content" style="position:relative; min-height:600px; font-size: large;">
			<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
                    <li class="breadcrumb-item active" aria-current="page">공지사항 관리</li>
                </ol>
            </nav>
			<div class="notice-header-bar">
				<div class="notice-title">공지사항 관리</div>
			</div>
			<hr/>
            <div class="list-view-container">
                <div id="serverMessage" class="server-message"></div>
                <c:if test="${not empty successMessage}"><div class="server-message success" style="display:block;">${successMessage}</div></c:if>
                <c:if test="${not empty errorMessage}"><div class="server-message error" style="display:block;">${errorMessage}</div></c:if>

                <div class="top-section">
                    <div class="emp-search-add-bar">
                        <form action="<c:url value='/emp/community/notice/list'/>" method="get" id="searchForm">
                            <sec:authorize access="hasRole('ROLE_ADMIN')">
                                <select name="artGroupNo">
                                    <option value="">전체 아티스트 그룹</option>
                                    <c:forEach var="group" items="${artistGroups}">
                                        <option value="${group.artGroupNo}" ${pagingVO.artGroupNo == group.artGroupNo ? 'selected' : ''}>
                                            <c:out value="${group.artGroupNm}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </sec:authorize>
                            <sec:authorize access="!hasRole('ROLE_ADMIN')">
                                <input type="hidden" name="artGroupNo" value="${pagingVO.artGroupNo}" />
                            </sec:authorize>
                            <input type="hidden" name="searchType" value="titleContent" />
                            <input type="text" name="searchWord" placeholder="검색어 입력" value="<c:out value='${pagingVO.searchWord}'/>">
                            <input type="hidden" name="currentPage" value="1">
                            <button type="submit" class="btn btn-secondary"><i class="fas fa-search"></i> 검색</button>
                        </form>
                    </div>
                </div>

                <table class="list-table">
                    <thead>
                        <tr>
                            <th style="width: 10%;">번호</th>
                            <th style="width: 15%;">카테고리</th>
                            <th style="width: 15%;">아티스트 그룹</th>
                            <th style="width: 45%;">제목</th>
                            <th style="width: 15%;">작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty pagingVO.dataList}">
                                <c:forEach var="notice" items="${pagingVO.dataList}">
                                    <tr>
                                        <td>${notice.comuNotiNo}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${notice.comuNotiCatCode == 'CNCC001'}">일반 공지</c:when>
                                                <c:when test="${notice.comuNotiCatCode == 'CNCC002'}">콘서트 공지</c:when>
                                                <c:otherwise>기타</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                        	<c:out value="${notice.artGroupNm}"/>
                                        </td>
                                        <td class="notice-title-cell">
                                            <c:url var="detailUrl" value="/emp/community/notice/detail/${notice.comuNotiNo}">
                                                <c:param name="searchType" value="${pagingVO.searchType}"/>
                                                <c:param name="searchWord" value="${pagingVO.searchWord}"/>
                                                <c:param name="currentPage" value="${pagingVO.currentPage}"/>
                                                <c:param name="artGroupNo" value="${pagingVO.artGroupNo}"/>
                                            </c:url>
                                            <a href="${detailUrl}" class="view-link"><c:out value="${notice.comuNotiTitle}"/></a>
                                        </td>
                                        <td><fmt:formatDate value="${notice.comuNotiRegDate}" pattern="yyyy-MM-dd"/></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" style="padding: 50px 0;">등록된 공지사항이 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <div class="pagination-and-button-wrapper">
                    <div class="pagination-container" id="pagingArea">
                         ${pagingVO.pagingHTML}
                    </div>
                    <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
                        <div class="add-notice-button-area">
                            <c:url var="formUrl" value="/emp/community/notice/form"/>
                            <a href="${formUrl}" class="btn btn-primary"><i class="fas fa-plus"></i> 등록</a>
                        </div>
                    </sec:authorize>
                </div>
            </div>
		</main>
	</div>
    </div>
	<%@ include file="../../modules/footerPart.jsp" %>
	<%@ include file="../../modules/sidebar.jsp" %>
<script type="text/javascript">

$(function(){
    const pagingArea = $('#pagingArea');
    const searchForm = $('#searchForm');

    if(pagingArea.length > 0) {
        pagingArea.on('click', 'a', function(event) {
            event.preventDefault();
            const page = $(this).data('page'); // data-page 속성에서 클릭된 페이지 번호 가져옴
            let artGroupNo;
            // 관리자면 select, 직원이면 hidden에서 artGroupNo 추출
            if(searchForm.find('select[name="artGroupNo"]').length > 0) {
                artGroupNo = searchForm.find('select[name="artGroupNo"]').val();
            } else {
                artGroupNo = searchForm.find('input[name="artGroupNo"]').val();
            }
            const searchType = searchForm.find('input[name="searchType"]').val();
            const searchWord = searchForm.find('input[name="searchWord"]').val();

            // 페이지 이동을 위한 URL
            let targetPageUrl = '${pageContext.request.contextPath}/emp/community/notice/list?currentPage=' + page;

            if(artGroupNo && artGroupNo.trim() !== ''){
                targetPageUrl += '&artGroupNo=' + encodeURIComponent(artGroupNo);
            }
            if (searchType && searchWord && searchWord.trim() !== '') {
                targetPageUrl += '&searchType=' + encodeURIComponent(searchType);
                targetPageUrl += '&searchWord=' + encodeURIComponent(searchWord);
            }
            window.location.href = targetPageUrl;
        });
    }
});

</script>
</body>
</html>