<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>콘서트 공지사항 관리</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/pagination.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <%@ include file="../../modules/translation.jsp" %>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f8f9fa; }
        .container { width: 95%; margin: auto; background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        h1 { text-align: center; color: #343a40; margin-bottom: 25px; }
        .search-add-bar { margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #e9ecef; border-radius: 5px;}
        .search-add-bar form { display: inline-flex; align-items: center; gap: 8px;}
        .search-add-bar input[type="text"], .search-add-bar select { padding: 8px; border: 1px solid #ced4da; border-radius: 4px; font-size: 0.9em;}
        .search-add-bar input[type="submit"], .search-add-bar .add-btn {
            padding: 8px 15px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.9em;
            border: none;
            cursor: pointer;
        }
        .search-add-bar input[type="submit"] { background-color: #007bff; color: white; }
        .search-add-bar input[type="submit"]:hover { background-color: #0056b3; }
        .search-add-bar .add-btn { background-color: #28a745; color: white; }
        .search-add-bar .add-btn:hover { background-color: #1e7e34; }

        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { border: 1px solid #dee2e6; padding: 10px; text-align: left; font-size: 0.95em; }
        th { background-color: #f8f9fa; color: #495057; font-weight: 600; text-align: center;}
        td { vertical-align: middle; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .action-links a, .action-links button {
            margin-right: 5px;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 0.85em;
            border: 1px solid transparent;
        }
        .action-links .view-link { color: #007bff; }
        .action-links .view-link:hover { text-decoration: underline; }
        .action-links .edit-btn { background-color: #ffc107; color: #212529; border-color: #ffc107;}
        .action-links .edit-btn:hover { background-color: #e0a800; }
        .action-links .delete-btn { background-color: #dc3545; color: white; border-color: #dc3545; cursor: pointer; }
        .action-links .delete-btn:hover { background-color: #c82333; }

        .pagination-container { text-align: center; margin-top: 20px; }
        .pagination { display: inline-block; padding-left: 0; list-style: none; border-radius: 4px; }
        .pagination > li { display: inline; }
        .pagination > li > a, .pagination > li > span {
            position: relative;
            float: left;
            padding: 6px 12px;
            margin-left: -1px;
            line-height: 1.42857143;
            color: #007bff;
            text-decoration: none;
            background-color: #fff;
            border: 1px solid #ddd;
        }
        .pagination > li:first-child > a, .pagination > li:first-child > span { margin-left: 0; border-top-left-radius: 4px; border-bottom-left-radius: 4px;}
        .pagination > li:last-child > a, .pagination > li:last-child > span { border-top-right-radius: 4px; border-bottom-right-radius: 4px;}
        .pagination > li > a:hover, .pagination > li > span:hover, .pagination > li > a:focus, .pagination > li > span:focus { z-index: 2; color: #0056b3; background-color: #e9ecef; border-color: #ddd;}
        .pagination > .active > a, .pagination > .active > span, .pagination > .active > a:hover, .pagination > .active > span:hover, .pagination > .active > a:focus, .pagination > .active > span:focus { z-index: 3; color: #fff; cursor: default; background-color: #007bff; border-color: #007bff;}
        .pagination > .disabled > span, .pagination > .disabled > span:hover, .pagination > .disabled > span:focus, .pagination > .disabled > a, .pagination > .disabled > a:hover, .pagination > .disabled > a:focus { color: #6c757d; cursor: not-allowed; background-color: #fff; border-color: #ddd;}

        .message { padding: 15px; margin-bottom: 20px; border-radius: 5px; text-align: center; font-size: 1.05em;}
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .text-center { text-align: center; }
    </style>
</head>
<body>
	<sec:authorize access="isAuthenticated()">
		<form action="/logout" method="post">
				<sec:csrfInput/>
				<button type="submit" class="btn btn-sm btn-primary">로그아웃하기</button>		
		</form>
	</sec:authorize>
    <div class="container">
        <h1>콘서트 공지사항 관리</h1>
		
		<sec:authentication property="principal.username" var="currentLoggedInUsername"/>
		<%-- <sec:authentication property="principal.employeeVO.empUsername" var="empUsername"/> --%>
		
        <c:if test="${not empty successMessage}">
            <div class="message success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="message error">${errorMessage}</div>
        </c:if>

        <div class="search-add-bar">
            <form action="<c:url value='/concert/notice/list'/>" method="get">
                <select name="searchType">
                    <option value="concertNotiTitle" ${pagingVO.searchType == 'concertNotiTitle' ? 'selected' : ''}>공지사항명</option>
                    <option value="concertNotiContent" ${pagingVO.searchType == 'concertNotiContent' ? 'selected' : ''}>내용</option>
                </select>
                <input type="text" name="searchWord" placeholder="검색어 입력" value="<c:out value='${pagingVO.searchWord}'/>">
                <input type="hidden" name="page" value="1"> 
                <input type="submit" value="검색">
            </form>
            
          	<sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
            	<a href="<c:url value='/concert/notice/form'/>" class="add-btn">새 공지사항 등록</a>
            </sec:authorize>
        </div>

        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>공지사항명</th>
                    <th>작성일시</th>
                    <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
                    <th style="width: 150px;">관리</th>
                    </sec:authorize>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty pagingVO.dataList && pagingVO.totalRecord > 0}">
                        <c:forEach var="notice" items="${pagingVO.dataList}">
                            <tr>
                                <td class="text-center">${notice.concertNotiNo}</td>
                                <td>
                                    <a href="<c:url value='/concert/notice/detail/${notice.concertNotiNo}'/>" class="view-link">
                                        <c:out value="${notice.concertNotiTitle}"/>
                                    </a>
                                </td>
                                <td class="text-center"><fmt:formatDate value="${notice.concertRegDate}" pattern="yyyy-MM-dd"/></td>
                                <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
                                <td class="action-links text-center">
                                        <%-- 현재 로그인한 사용자의 empUsername과 공지사항 작성자(notice.empUsername) 비교 --%>
                                        <c:if test="${notice.empUsername == currentLoggedInUsername}">
                                            <a href="<c:url value='/concert/notice/mod/${notice.concertNotiNo}'/>" class="edit-btn">수정</a>
                                            <form action="<c:url value='/concert/notice/delete/${notice.concertNotiNo}'/>" method="post" style="display:inline;">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                <button type="submit" class="delete-btn" onclick="return confirm('정말로 [${notice.concertNotiTitle}] 공지를 삭제하시겠습니까?');">삭제</button>
                                            </form>
                                        </c:if>
                                    </sec:authorize>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" class="text-center">등록된 콘서트 공지사항이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="pagination-container" id="pagingArea">
             ${pagingVO.pagingHTML}
        </div>

    </div> <%-- End of container --%>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
<script type="text/javascript">

	$(function(){
    // 페이지네이션 로직
       const pagingArea = $('#pagingArea');
       if(pagingArea.length > 0) {
           pagingArea.on('click', 'a', function(event) { 
               event.preventDefault();
               const page = $(this).data('page');
               
               // 현재 URL에서 검색 파라미터 유지
               const currentSearchUrl = new URL(window.location.href);
               const searchType = currentSearchUrl.searchParams.get("searchType");
               const searchWord = currentSearchUrl.searchParams.get("searchWord");

               let targetPageUrl = '${pageContext.request.contextPath}/concert/notice/list?page=' + page;

               if (searchType && searchWord) {
                   targetPageUrl += '&searchType=' + encodeURIComponent(searchType);
                   targetPageUrl += '&searchWord=' + encodeURIComponent(searchWord);
               }
               window.location.href = targetPageUrl;
           });
       }
	})
</script>
</body>
</html>