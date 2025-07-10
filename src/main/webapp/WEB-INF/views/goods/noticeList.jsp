<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>DDTOWN 굿즈샵 - 공지사항</title>
	<meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
 	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods_main.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods_notice.css">
 	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css" />
    <style type="text/css">
    	.floating-nav {
		    position: fixed;
		    bottom: 100px;
		    right: 24px;
		    z-index: 1000;
		    display: flex;
		    flex-direction: column;
		    gap: 15px;
		}
    </style>
</head>
<body class="notice-list-page-body">
    <jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />

	<div class="notice-list-container">
		<header class="notice-list-header">
			<h1>공지사항</h1>
			<div class="notice-search">
				<%-- GET 방식으로 변경하여 URL 파라미터로 검색어 전달 --%>
				<form action="${pageContext.request.contextPath}/goods/notice/list" method="get">
				    <select name="searchType">
				        <option value="title" ${searchType eq 'title' ? 'selected' : ''}>제목</option>
				        <option value="content" ${searchType eq 'content' ? 'selected' : ''}>내용</option>
				    </select>
					<input type="text" name="searchWord" value="${searchWord}" placeholder="검색어를 입력하세요."/> 
					<input type="submit" value="검색"/>
				</form>
			</div>
		</header>

		<div class="notice-list">
			<table border="1">
				<tr>
					<th align="center" width="80%">제목</th> <%-- 너비 조정 --%>
					<th align="center" width="20%">작성일</th> <%-- 너비 조정 --%>
				</tr>
				<c:choose>
					<c:when test="${empty pagingVO.dataList }"> <%-- pagingVO.dataList 사용 --%>
						<tr>
							<td colspan="2" align="center">조회하실 게시글이 존재하지 않습니다.</td> <%-- colspan 2로 변경 --%>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach items="${pagingVO.dataList }" var="notice"> <%-- pagingVO.dataList 사용 --%>
							<tr>
								<td align="left">
								    <%-- 상세 페이지 링크 수정: 절대 경로 사용 및 현재 페이지, 검색 파라미터 전달 --%>
								    <a href="${pageContext.request.contextPath}/goods/notice/detail/${notice.goodsNotiNo}?currentPage=${pagingVO.currentPage}&searchType=${searchType}&searchWord=${searchWord}">${notice.goodsNotiTitle}</a>
								</td>
								<td align="center"><fmt:formatDate value="${notice.goodsRegDate }" pattern="yyyy-MM-dd" /></td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</table>
		</div>

		<div class="pagination">
			<%-- 이전 페이지 버튼 --%>
			<c:if test="${pagingVO.currentPage > 1}">
				<a href="${pageContext.request.contextPath}/goods/notice/list?currentPage=${pagingVO.currentPage - 1}&searchType=${searchType}&searchWord=${searchWord}"
					class="btn-page prev">&lt;</a>
			</c:if>
			<c:if test="${pagingVO.currentPage == 1}"> <%-- 첫 페이지일 때 비활성화 --%>
				<button class="btn-page prev" disabled>&lt;</button>
			</c:if>

			<c:forEach var="i" begin="${pagingVO.startPage}" end="${pagingVO.endPage}">
				<%-- ⭐ 수정된 부분: URL을 별도의 변수로 먼저 구성하여 EL '+' 연산 문제를 회피 ⭐ --%>
				<c:url var="pageLink" value="/goods/notice/list">
					<c:param name="currentPage" value="${i}"/>
					<c:param name="searchType" value="${searchType}"/>
					<c:param name="searchWord" value="${searchWord}"/>
					<%-- 공지사항에 특화된 검색 조건도 필요하다면 여기에 추가 --%>
					<c:if test="${not empty searchCategoryCode}"><c:param name="searchCategoryCode" value="${searchCategoryCode}"/></c:if>
					<c:if test="${not empty empUsername}"><c:param name="empUsername" value="${empUsername}"/></c:if>
				</c:url>
				<a href="${pageLink}" class="btn-page ${i == pagingVO.currentPage ? 'active' : ''}">${i}</a>
			</c:forEach>

			<%-- 다음 페이지 버튼 --%>
			<c:if test="${pagingVO.currentPage < pagingVO.totalPage}">
				<a href="${pageContext.request.contextPath}/goods/notice/list?currentPage=${pagingVO.currentPage + 1}&searchType=${searchType}&searchWord=${searchWord}"
					class="btn-page next">&gt;</a>
			</c:if>
			<c:if test="${pagingVO.currentPage == pagingVO.totalPage || pagingVO.totalPage == 0}"> <%-- 마지막 페이지이거나 총 페이지가 0일 때 비활성화 --%>
				<button class="btn-page next" disabled>&gt;</button>
			</c:if>
		</div>
	</div>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
	<script>
    </script>
</body>
</html>