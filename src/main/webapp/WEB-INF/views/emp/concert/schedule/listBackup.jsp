<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>콘서트 일정</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/pagination.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<%@ include file="../../../modules/headerPart.jsp" %>
 <style>
    /* ---------------------------------- */
    /* 공통 & 기본 설정                   */
    /* ---------------------------------- */

    th, td {
    	padding: var(--spacing-sm);
    	border: 1px solid var(--border-color);
    	text-align: center;
    }

    /* ---------------------------------- */
    /* 목록 페이지 - 컨테이너 & 검색 바    */
    /* ---------------------------------- */
    .list-view-container {
        background: #fff;
        padding: 25px 30px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }
    .emp-search-add-bar { margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; padding: 10px; background-color: #e9ecef; border-radius: 5px;}
     .emp-search-add-bar form { display: inline-flex; align-items: center; gap: 8px;}
     .emp-search-add-bar input[type="text"], .emp-search-add-bar select { width:auto; padding: 8px; border: 1px solid #ced4da; border-radius: 4px; font-size: 0.9em;}
     .emp-search-add-bar input[type="submit"], .emp-search-add-bar .add-btn {
         padding: 8px 15px;
         border-radius: 4px;
         text-decoration: none;
         font-size: 0.9em;
         border: none;
         cursor: pointer;
         width: auto;
     }
     .emp-search-add-bar input[type="submit"] { background-color: #007bff; color: white; }
     .emp-search-add-bar input[type="submit"]:hover { background-color: #0056b3; }
     .emp-search-add-bar .add-btn { background-color: #28a745; color: white; }
     .emp-search-add-bar .add-btn:hover { background-color: #1e7e34; }

    /* ---------------------------------- */
    /* 목록 페이지 - 테이블                */
    /* ---------------------------------- */
    .list-table {
        width: 100%;
        border-collapse: collapse; /* 셀 간의 간격 제거 */
        font-size: 0.95em;
    }
    .list-table thead {
        border-top: 2px solid #343a40;
        border-bottom: 1px solid #dee2e6;
    }
    .list-table th {
        padding: 15px 12px;
        font-weight: 600;
        color: #495057;
        text-align: center;
        background-color: #f8f9fa;
    }
    .list-table tbody tr {
        border-bottom: 1px solid #f1f1f1;
        transition: background-color 0.2s;
    }
    .list-table tbody tr:hover {
        background-color: #f4f6f9; /* 마우스 오버 시 배경색 */
    }
    .list-table td {
        padding: 15px 12px;
        vertical-align: middle;
        text-align: center;
    }
    .list-table .concert-title-cell {
        display: flex;
        align-items: center;
        gap: 15px;
        text-align: left;
    }
    img {
        width: 80px;
        height: 80px;
        object-fit: cover;
        border-radius: 4px;
        border: 1px solid #eee;
        margin-right: 10px;
        vertical-align: middle;
    }
    .thumbnail-placeholder {
    width: 60px;    /* .thumbnail-img와 동일한 너비 */
    height: 60px;   /* .thumbnail-img와 동일한 높이 */
    flex-shrink: 0; /* flex 컨테이너 안에서 크기가 줄어들지 않도록 설정 */
    margin-left: 30px;
	}
    .concert-title-cell {
            display: flex;
            align-items: center;
    }
    .list-table .view-link {
        color: #212529;
        font-weight: 500;
    }
    .list-table .view-link:hover {
        color: #007bff;
        text-decoration: underline;
    }

    /* ---------------------------------- */
    /* 목록 페이지 - 페이지네이션         */
    /* ---------------------------------- */
    .pagination-container {
        display: flex;
        justify-content: center;
        padding: 30px 0 10px 0;
    }
    .pagination { list-style: none; display: flex; padding: 0; margin: 0; gap: 6px; }
    .pagination li a, .pagination li span {
        display: block;
        padding: 8px 14px;
        color: #6c757d;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        transition: all 0.2s;
    }
    .pagination li a:hover {
        background-color: #e9ecef;
        border-color: #ced4da;
    }
    .pagination li.active a, .pagination li.active span {
        background-color: #007bff;
        color: white;
        border-color: #007bff;
        font-weight: 600;
    }
    .pagination li.disabled span {
        color: #adb5bd;
        background-color: #f8f9fa;
        cursor: not-allowed;
    }


    /* ---------------------------------- */
    /* 상태 표시 배지                     */
    /* ---------------------------------- */
    .status-badge {
        display: inline-block;
        padding: 5px 12px;
        font-size: 0.8em;
        font-weight: 400;
        border-radius: 12px;
        color: #fff;
        text-transform: uppercase;
    }
    .status-scheduled { background-color: #007bff; } /* 예정: 파란색 */
    .status-preSale { background-color: #b700ff; } /* 선예매: 보라색 */
    .status-ongoing { background-color: #00ff22; } /* 진행: 초록색 */
    .status-soldout { background-color: #8e92c9; } /* 매진: 회색 */
    .status-finished { background-color: #ff0021; } /* 종료: 빨간색 */
    .status-unknown { background-color: #ffc107; color: #212529; } /* 알수없음: 노란색 */


    /* ---------------------------------- */
    /* 버튼 UI (공통)                   */
    /* ---------------------------------- */
    .btn {
        display: inline-block;
        padding: 10px 20px;
        font-size: 0.95em;
        font-weight: 500;
        text-align: center;
        text-decoration: none;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: all 0.2s ease-in-out;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    .btn-primary { background-color: #007bff; color: white; }
    .btn-primary:hover { background-color: #0069d9; }
    .btn-secondary { background-color: #6c757d; color: white; }
    .btn-secondary:hover { background-color: #5a6268; }

</style>
</head>
<body>
    <div class="emp-container">
    <%@ include file="../../modules/header.jsp" %>

        <c:if test="${not empty successMessage}">
            <div class="message success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="message error">${errorMessage}</div>
        </c:if>
	<div class="emp-body-wrapper">
		<%@ include file="../../modules/aside.jsp" %>
	<main class="emp-content" style="position:relative; min-height:600px;">
        <div class="emp-search-add-bar">
            <form action="<c:url value='/emp/concert/schedule/list'/>" method="get" id="searchForm">
                <select name="searchType" onchange="this.form.submit();">
                    <option value="concertNm" ${pagingVO.searchType == 'concertNm' ? 'selected' : ''}>콘서트명</option>
                    <option value="artistName" ${pagingVO.searchType == 'artistName' ? 'selected' : ''}>아티스트명</option>
                    <option value="hallName" ${pagingVO.searchType == 'hallName' ? 'selected' : ''}>공연장명</option>
                </select>
                <input type="text" name="searchWord" placeholder="검색어 입력" value="<c:out value='${pagingVO.searchWord}'/>">
                <input type="hidden" name="currentPage" value="1">
                <input type="submit" value="검색">
            </form>
            <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
                <c:url var="finalRegisterFormUrl" value="/emp/concert/schedule/form">
                    <c:if test="${not empty pagingVO.searchType and not empty pagingVO.searchWord}">
                        <c:param name="searchType" value="${pagingVO.searchType}"/>
                        <c:param name="searchWord" value="${pagingVO.searchWord}"/>
                    </c:if>
                    <c:if test="${not empty pagingVO.currentPage && pagingVO.currentPage > 1}">
                        <c:param name="currentPage" value="${pagingVO.currentPage}"/>
                    </c:if>
                </c:url>
                <a href="${finalRegisterFormUrl}" class="add-btn">새 일정 등록</a>
            </sec:authorize>
        </div>

        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>콘서트명 (대표이미지)</th>
                    <th>아티스트</th>
                    <th>공연장</th>
                    <th>공연일</th>
                    <th>온라인</th>
                    <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
                    <th>예매 상태</th>
                    </sec:authorize>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty pagingVO.dataList && pagingVO.totalRecord > 0}">
                        <c:forEach var="concert" items="${pagingVO.dataList}">
                            <tr>
                                <td class="text-center">${concert.concertNo}</td>
                                <td class="concert-title-cell">
                                	<c:choose>
                                		<c:when test="${not empty concert.representativeImageUrl}">
                                			<img src="<c:url value='${concert.representativeImageUrl}'/>" alt="대표이미지" class="thumbnail-img"/>
                                		</c:when>
                                		<c:otherwise>
                                			<div class="thumbnail-placeholder"></div>
                                		</c:otherwise>
                                	</c:choose>
                                    <c:url var="finalDetailUrl" value="/emp/concert/schedule/detail/${concert.concertNo}">
                                        <c:if test="${not empty pagingVO.searchType and not empty pagingVO.searchWord}">
                                            <c:param name="searchType" value="${pagingVO.searchType}"/>
                                            <c:param name="searchWord" value="${pagingVO.searchWord}"/>
                                        </c:if>
                                        <c:if test="${not empty pagingVO.currentPage && pagingVO.currentPage > 1}">
                                            <c:param name="currentPage" value="${pagingVO.currentPage}"/>
                                        </c:if>
                                    </c:url>
                                    <a href="${finalDetailUrl}" class="view-link">
                                        <c:out value="${concert.concertNm}"/>
                                    </a>
                                </td>
                                <td><c:out value="${concert.artGroupName}"/></td>
                                <td><c:out value="${concert.concertHallName}"/></td>
                                <td class="text-center"><fmt:formatDate value="${concert.concertDate}" pattern="yyyy-MM-dd"/></td>
                                <td class="text-center">${concert.concertOnlineYn == 'Y' ? '온라인' : '오프라인'}</td>
                                <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
                                <td class="text-center">
                                	<c:choose>
                                		<c:when test="${concert.concertReservationStatCode == 'CRSC005'}">
                                			<span class="status-badge status-scheduled">예정</span>
                                		</c:when>
                                		<c:when test="${concert.concertReservationStatCode == 'CRSC001'}">
                                			<span class="status-badge status-preSale">선예매기간</span>
                                		</c:when>
                                		<c:when test="${concert.concertReservationStatCode == 'CRSC002'}">
                                			<span class="status-badge status-ongoing">예매중</span>
                                		</c:when>
                                		<c:when test="${concert.concertReservationStatCode == 'CRSC003'}">
                                			<span class="status-badge status-soldout">매진</span>
                                		</c:when>
                                		<c:otherwise>
                                			<span class="status-badge status-finished">종료</span>
                                		</c:otherwise>
                                	</c:choose>
                                </td>
                                </sec:authorize>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                             <td colspan="8" class="text-center">등록된 콘서트 일정이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        <div class="pagination-container" id="pagingArea">
             ${pagingVO.pagingHTML}
        </div>
	</main>
	</div>
    <footer class="emp-footer">
        <p>&copy; 2025 DDTOWN Entertainment. All rights reserved. (직원 전용)</p>
    </footer>
    </div>
</body>
<%@ include file="../../../modules/footerPart.jsp" %>

<script type="text/javascript">

	const logoutButton = document.querySelector('.btn emp-logout-btn');
	if (logoutButton) {
	    logoutButton.addEventListener('click', function(e) {
	        e.preventDefault();
	        if (confirm('로그아웃 하시겠습니까?')) {
	            alert('로그아웃 되었습니다.');
	        }
	    });
	}
	document.addEventListener('DOMContentLoaded', function() {
        // 메뉴 토글 기능
        const navItemsWithSubmenu = document.querySelectorAll('.emp-sidebar .emp-nav-item.has-submenu');
        navItemsWithSubmenu.forEach(item => {
            const arrow = item.querySelector('.submenu-arrow');
            item.addEventListener('click', function(event) {
                event.preventDefault();
                const parentLi = this.parentElement;
                const submenu = this.nextElementSibling;
                if (submenu && submenu.classList.contains('emp-submenu')) {
                    const parentUl = parentLi.parentElement;
                    if (parentUl) {
                        Array.from(parentUl.children).forEach(siblingLi => {
                            if (siblingLi !== parentLi) {
                                const siblingSubmenuControl = siblingLi.querySelector('.emp-nav-item.has-submenu.open');
                                if (siblingSubmenuControl) {
                                    const siblingSubmenu = siblingSubmenuControl.nextElementSibling;
                                    siblingSubmenuControl.classList.remove('open');
                                    if (siblingSubmenu && siblingSubmenu.classList.contains('emp-submenu')) {
                                        siblingSubmenu.style.display = 'none';
                                    }
                                    const siblingArrow = siblingSubmenuControl.querySelector('.submenu-arrow');
                                    if (siblingArrow) siblingArrow.style.transform = 'rotate(0deg)';
                                }
                            }
                        });
                    }
                }
                this.classList.toggle('open');
                if (submenu && submenu.classList.contains('emp-submenu')) {
                    submenu.style.display = this.classList.contains('open') ? 'block' : 'none';
                    if (arrow) arrow.style.transform = this.classList.contains('open') ? 'rotate(90deg)' : 'rotate(0deg)';
                }
            });
        });
        // 현재 페이지 URL 기반으로 사이드바 메뉴 활성화
        const currentFullHref = window.location.href;
        document.querySelectorAll('.emp-sidebar .emp-nav-item[href]').forEach(link => {
            const linkHrefAttribute = link.getAttribute('href');
            if (linkHrefAttribute && linkHrefAttribute !== "#" && currentFullHref.endsWith(linkHrefAttribute)) {
                link.classList.add('active');
                let currentActiveElement = link;
                while (true) {
                    const parentLi = currentActiveElement.parentElement;
                    if (!parentLi) break;
                    const parentSubmenuUl = parentLi.closest('.emp-submenu');
                    if (parentSubmenuUl) {
                        parentSubmenuUl.style.display = 'block';
                        const controllingAnchor = parentSubmenuUl.previousElementSibling;
                        if (controllingAnchor && controllingAnchor.tagName === 'A' && controllingAnchor.classList.contains('has-submenu')) {
                            controllingAnchor.classList.add('active', 'open');
                            const arrow = controllingAnchor.querySelector('.submenu-arrow');
                            if (arrow) {
                                arrow.style.transform = 'rotate(90deg)';
                            }
                            currentActiveElement = controllingAnchor;
                        } else {
                            break;
                        }
                    } else {
                        break;
                    }
                }
            }
        });
    });


	$(function(){
	    const pagingArea = $('#pagingArea');
	    const searchForm = $('#searchForm');

	    if(pagingArea.length > 0) {
	        pagingArea.on('click', 'a', function(event) {
	            event.preventDefault();
	            const page = $(this).data('page'); // data-page 속성에서 클릭된 페이지 번호 가져옴

	            // 검색폼의 현재 searchType과 searchWord 값을 가져옴
	            const searchType = searchForm.find('select[name="searchType"]').val();
	            const searchWord = searchForm.find('input[name="searchWord"]').val();

	            // 페이지 이동을 위한 URL
	            let targetPageUrl = '${pageContext.request.contextPath}/emp/concert/schedule/list?currentPage=' + page;


	            if (searchType && searchWord && searchWord.trim() !== '') {
	                targetPageUrl += '&searchType=' + encodeURIComponent(searchType);
	                targetPageUrl += '&searchWord=' + encodeURIComponent(searchWord);
	            }
	            window.location.href = targetPageUrl;
	        });
	    }
	});
</script>
</html>