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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/pagination.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<%@ include file="../../../modules/headerPart.jsp" %>
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
    a { text-decoration: none; }
    a:hover { color: #007bff; } /* 일관된 링크 호버 색상 */
    th, td {
    	padding: var(--spacing-sm);
    	border: 1px solid var(--border-color);
    	text-align: center;
    }
    hr {
        border: none;
        border-top: 1px solid; /* 부드러운 구분선 */
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
    .content-header-area {
        display: flex;
        justify-content: space-between; /* 제목은 왼쪽, 검색창은 오른쪽으로 */
        align-items: center;
    }
    .content-header-area h1 {
        margin: 0; /* h1 기본 마진 제거 */
    }
    main.emp-content h2 {
	    font-size: 1.7em;
	    font-weight: 700;
	    color: #234aad;
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    margin-bottom: 0;
	}
    /* ---------------------------------- */
    /* 상태 필터 버튼 영역 (새로 추가)        */
    /* ---------------------------------- */
    .filter-search-container {
	    display: flex;
	    justify-content: space-between; /* 양쪽 끝으로 분배 */
	    align-items: center; /* 세로 중앙 정렬 */
	    gap: 20px; /* 요소 간 간격 */
	}
    .status-filter-area {
        padding: 10px 0;
    }
    .status-filter-buttons {
        display: flex;
        gap: 10px;
        align-items: center;
    }

    .status-filter-label {
        font-weight: 600;
        color: #495057;
        margin-right: 10px;
        flex-shrink: 0;
    }
    .filter-btn {
	    padding: 8px 16px;
	    border: 1px solid #dee2e6;
	    border-radius: 20px;
	    font-size: 0.9em;
	    font-weight: 500;
	    cursor: pointer;
	    transition: all 0.2s ease;
	    text-decoration: none;
	    display: inline-block;
	}
	/* 초기 색상 (기존 .active 색상 활용) */
	.filter-btn.all {
	    background-color: #6c757d;
	    color: white;
	}
	.filter-btn.scheduled {
	    background-color: #4D96FF;
	    color: white;
	}
	.filter-btn.presale {
	    background-color: #FFC107;
	    color: #212529;
	}
	.filter-btn.ongoing {
	    background-color: #28A745;
	    color: white;
	}
	.filter-btn.soldout {
	    background-color: #6C757D;
	    color: white;
	}
	.filter-btn.finished {
	    background-color: #DC3545;
	    color: white;
	}
	/* hover 상태에서 색상 유지 또는 약간의 밝기 조정 */
	.filter-btn:hover {
	    opacity: 0.9; /* 밝기 약간 줄임 */
	    border-color: #ced4da;
	    text-decoration: none;
	}
	.filter-btn.active {
	   	border: 2px solid;
	    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
	    font-weight: 600;
	}
    .search-form-wrap {
        align-items: center;
        text-align: right;
        gap: 8px; /* 입력 필드 및 버튼 간 간격 */
        padding: 10px; /* 기존 emp-search-add-bar의 패딩 */
        border-radius: 5px; /* 기존 emp-search-add-bar의 둥근 모서리 */
        flex-shrink: 0;
    }
    .search-form-wrap form { /* form 내부 요소에 대한 flex 정렬 */
         display: inline-flex;
         align-items: center;
         gap: 8px;
    }
    .search-form-wrap input[type="text"],
    .search-form-wrap select {
        width:auto; padding: 8px; border: 1px solid #ced4da; border-radius: 4px; font-size: 0.9em;
    }
    .search-form-wrap input[type="submit"] {
         padding: 8px 15px;
         border-radius: 4px;
         text-decoration: none;
         font-size: 0.9em;
         border: none;
         cursor: pointer;
         width: auto;
         background-color: #234aad;
         color: white;
         display: inline-flex;
         align-items: center;
         gap: 5px;
    }
    .search-form-wrap input[type="submit"]:hover { background-color: #1a3c8a; }
    /* ---------------------------------- */
    /* 목록 페이지 - 테이블                */
    /* ---------------------------------- */
    .list-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
	    background: #fff;
	    margin-bottom: 25px;
	    border-radius: 10px;
	    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
	    overflow: hidden;
	    font-size: 1.3em;
	    white-space: nowrap;
    }
    .list-table th, .list-table td {
	    border: none;
	    padding: 15px;
	    text-align: center;
	    vertical-align: middle;
	}
    .list-table thead th{
        background: #f0f5ff;
	    color: #234aad;
	    font-weight: 700;
	    border-bottom: 1px solid #d0d8e2;
    }
    .list-table tbody tr {
	    transition: background-color 0.2s ease;
	}
    .list-table tbody tr:nth-child(even) {
	    background-color: #f9f9f9;
	}
	.list-table tbody tr:hover {
	    background-color: #eef7ff;
	}
	.list-table td {
	    color: #495057;
	    border-bottom: 1px solid #e9ecef;
	}
	.list-table tbody tr:last-child td {
	    border-bottom: none;
	}
	.list-table .concert-title-cell {
	    display: flex;
	    align-items: center; /* 세로 중앙 정렬 유지 */
	    justify-content: flex-start;
	    gap: 8px;
	}
	.list-table img {
	    width: 80px;
	    height: 80px;
	    object-fit: cover;
	    border-radius: 4px;
	    border: 1px solid #eee;
	    flex-shrink: 0;
	}
	.thumbnail-placeholder {
	    width: 80px;
	    height: 80px;
	    flex-shrink: 0;
	    background-color: #e9ecef;
	    border: 1px solid #dee2e6;
	    border-radius: 4px;
	}
	.list-table .view-link {
	    color: #234aad;
	    font-weight: 500;
	    line-height: 1.2;
	    margin: 0;
	    text-align: left;
	}
	.list-table .view-link:hover {
	    color: #007bff;
	}
    /* ---------------------------------- */
    /* 목록 페이지 - 하단 액션 (페이지네이션 & 등록 버튼)
    /* ---------------------------------- */
    .list-footer-actions {
        display: flex;
        justify-content: flex-end; /* 모든 요소를 오른쪽으로 정렬 */
        align-items: center; /* 세로 중앙 정렬 */
        padding: 30px 0 10px 0; /* 전체 패딩 */
        width: 100%; /* 부모(main)의 전체 너비를 사용하도록 */
        flex-wrap: wrap;
    }
    .pagination-container {
        margin-right: auto;
        display: flex; /* 내부 페이지 번호들을 정렬하기 위해 추가 */
        justify-content: center; /* 페이지 번호들을 중앙으로 정렬 */
        flex-grow: 1; /* 남은 공간을 차지하여 중앙 정렬에 도움 */
        flex-wrap: wrap;
        gap: 6px;
    }
    .pagination { list-style: none; display: flex; padding: 0; margin: 0; gap: 6px; }
    .pagination li a, .pagination li span {
        display: block;
        padding: 8px 14px;
        color: #6c757d;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        transition: all 0.2s;
        min-width: 30px;
        text-align: center;
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
    .add-btn {
        background-color: #234aad;
        color: white;
        padding: 8px 15px;
        border-radius: 4px;
        text-decoration: none;
        font-size: 0.9em;
        border: none;
        cursor: pointer;
        width: auto;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        transition: all 0.2s ease-in-out;
        flex-shrink: 0;
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }
    .add-btn:hover {
    	color : white;
        background-color: #1a3c8a;
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    /* ---------------------------------- */
    /* 상태 표시 배지 색상                */
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
    .status-scheduled { background-color: #4D96FF; } /* 예정: 밝은 파랑 */
    .status-preSale { background-color: #FFC107; color: #212529; } /* 선예매: 노랑, 글자색 어둡게 */
    .status-ongoing { background-color: #28A745; } /* 예매중: 표준 초록 */
    .status-soldout { background-color: #6C757D; } /* 매진: 진한 회색 */
    .status-finished { background-color: #DC3545; } /* 종료: 표준 빨강 */
    .status-unknown { background-color: #ffc107; color: #212529; } /* 알수없음: 기존 유지 */
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
    .btn-primary { background-color: #234aad; color: white; }
    .btn-primary:hover { background-color: #1a3c8a; }
    .btn-secondary { background-color: #6c757d; color: white; }
    .btn-secondary:hover { background-color: #5a6268; }
</style>
</head>
<body>
    <div class="emp-container">
    <%@ include file="../../modules/header.jsp" %>
<%--
        <c:if test="${not empty successMessage}">
            <div class="message success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="message error">${errorMessage}</div>
        </c:if> --%>
	<div class="emp-body-wrapper">
		<%@ include file="../../modules/aside.jsp" %>
	<main class="emp-content" style="position:relative; min-height:600px; width: 20px; font-size: x-small;">
        <div class="content-header-area">
			<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="#" style="color:black;">콘서트 관리</a></li>
                    <li class="breadcrumb-item active" aria-current="page">콘서트 일정 관리</li>
                </ol>
            </nav>
        </div>
		<h2>콘서트 일정 관리</h2>
		<div class="filter-search-container">
	        <!-- 상태별 필터 버튼 영역 -->
			<div class="status-filter-area">
			    <div class="status-filter-buttons">
			        <span class="status-filter-label"></span>
			        <button class="filter-btn all ${empty param.statusFilter ? 'active' : ''}"
			                onclick="location.href='<c:url value='/emp/concert/schedule/list'><c:param name='searchType' value='${empty pagingVO.searchType ? "" : pagingVO.searchType}'/><c:param name='searchWord' value='${empty pagingVO.searchWord ? "" : pagingVO.searchWord}'/></c:url>'">
			            전체 <c:out value="${totalCount != null ? totalCount : 0}" />건
			        </button>
			        <button class="filter-btn scheduled ${param.statusFilter == 'CRSC005' ? 'active' : ''}"
			                onclick="location.href='<c:url value='/emp/concert/schedule/list'><c:param name='statusFilter' value='CRSC005'/><c:param name='searchType' value='${empty pagingVO.searchType ? "" : pagingVO.searchType}'/><c:param name='searchWord' value='${empty pagingVO.searchWord ? "" : pagingVO.searchWord}'/></c:url>'">
			            예정 <c:out value="${statusCounts['CRSC005'] != null ? statusCounts['CRSC005'] : 0}" />건
			        </button>
			        <button class="filter-btn presale ${param.statusFilter == 'CRSC001' ? 'active' : ''}"
			                onclick="location.href='<c:url value='/emp/concert/schedule/list'><c:param name='statusFilter' value='CRSC001'/><c:param name='searchType' value='${empty pagingVO.searchType ? "" : pagingVO.searchType}'/><c:param name='searchWord' value='${empty pagingVO.searchWord ? "" : pagingVO.searchWord}'/></c:url>'">
			            선예매 <c:out value="${statusCounts['CRSC001'] != null ? statusCounts['CRSC001'] : 0}" />건
			        </button>
			        <button class="filter-btn ongoing ${param.statusFilter == 'CRSC002' ? 'active' : ''}"
			                onclick="location.href='<c:url value='/emp/concert/schedule/list'><c:param name='statusFilter' value='CRSC002'/><c:param name='searchType' value='${empty pagingVO.searchType ? "" : pagingVO.searchType}'/><c:param name='searchWord' value='${empty pagingVO.searchWord ? "" : pagingVO.searchWord}'/></c:url>'">
			            예매중 <c:out value="${statusCounts['CRSC002'] != null ? statusCounts['CRSC002'] : 0}" />건
			        </button>
			        <button class="filter-btn soldout ${param.statusFilter == 'CRSC003' ? 'active' : ''}"
			                onclick="location.href='<c:url value='/emp/concert/schedule/list'><c:param name='statusFilter' value='CRSC003'/><c:param name='searchType' value='${empty pagingVO.searchType ? "" : pagingVO.searchType}'/><c:param name='searchWord' value='${empty pagingVO.searchWord ? "" : pagingVO.searchWord}'/></c:url>'">
			            매진 <c:out value="${statusCounts['CRSC003'] != null ? statusCounts['CRSC003'] : 0}" />건
			        </button>
			        <button class="filter-btn finished ${param.statusFilter == 'CRSC004' ? 'active' : ''}"
			                onclick="location.href='<c:url value='/emp/concert/schedule/list'><c:param name='statusFilter' value='CRSC004'/><c:param name='searchType' value='${empty pagingVO.searchType ? "" : pagingVO.searchType}'/><c:param name='searchWord' value='${empty pagingVO.searchWord ? "" : pagingVO.searchWord}'/></c:url>'">
			            종료 <c:out value="${statusCounts['CRSC004'] != null ? statusCounts['CRSC004'] : 0}" />건
			        </button>
			    </div>
			</div>
			<div class="search-form-wrap">
			    <form action="<c:url value='/emp/concert/schedule/list'/>" method="get" id="searchForm">
			        <select name="searchType">
			            <option value="concertNm" ${empty pagingVO.searchType ? '' : pagingVO.searchType == 'concertNm' ? 'selected' : ''}>콘서트명</option>
			            <option value="artistName" ${empty pagingVO.searchType ? '' : pagingVO.searchType == 'artistName' ? 'selected' : ''}>아티스트명</option>
			            <option value="hallName" ${empty pagingVO.searchType ? '' : pagingVO.searchType == 'hallName' ? 'selected' : ''}>공연장명</option>
			        </select>
			        <input type="text" name="searchWord" placeholder="제목, 내용을 입력해주세요." value="<c:out value='${empty pagingVO.searchWord ? "" : pagingVO.searchWord}'/>">
			        <input type="hidden" name="currentPage" value="1">
			        <input type="hidden" name="statusFilter" value="${param.statusFilter}">
			       	<button type="submit" class="btn btn-primary search-bar">
    					<i class="fas fa-search"></i> 검색
					</button>
			    </form>
			</div>
		</div>
		<hr/>
        <table class="list-table">
            <thead>
                <tr>
                    <th>번호</th>
                    <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
                    <th>예매 상태</th>
                    </sec:authorize>
                    <th>콘서트명 (대표이미지)</th>
                    <th>아티스트</th>
                    <th>공연장</th>
                    <th>공연일</th>
                    <th>온라인</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty pagingVO.dataList && pagingVO.totalRecord > 0}">
                        <c:forEach var="concert" items="${pagingVO.dataList}">
                            <tr>
                                <td class="text-center">${concert.concertNo}</td>
                                <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
                                <td class="text-center">
                                	<c:choose>
                                		<c:when test="${concert.concertReservationStatCode == 'CRSC005'}">
                                			<span class="status-badge status-scheduled">예정</span>
                                		</c:when>
                                		<c:when test="${concert.concertReservationStatCode == 'CRSC001'}">
                                			<span class="status-badge status-preSale">선예매</span>
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
                                        <c:if test="${not empty param.statusFilter}">
                                            <c:param name="statusFilter" value="${param.statusFilter}"/>
                                        </c:if>
                                    </c:url>
                                    <a href="${finalDetailUrl}" class="view-link">
                                        <c:out value="${concert.concertNm}"/>
                                    </a>
                                </td>
                                <%-- <td class="text-center"><c:out value="${concert.seatStatus}" default="정보 없음" /></td> --%>
                                <td><c:out value="${concert.artGroupName}"/></td>
                                <td><c:out value="${concert.concertHallName}"/></td>
                                <td class="text-center"><fmt:formatDate value="${concert.concertDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td class="text-center">${concert.concertOnlineYn == 'Y' ? '온라인' : '오프라인'}</td>
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

        <div class="list-footer-actions">
            <div class="pagination-container" id="pagingArea">
                 ${pagingVO.pagingHTML}
            </div>
            <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
                <c:url var="finalRegisterFormUrl" value="/emp/concert/schedule/form">
                    <c:if test="${not empty pagingVO.searchType and not empty pagingVO.searchWord}">
                        <c:param name="searchType" value="${pagingVO.searchType}"/>
                        <c:param name="searchWord" value="${pagingVO.searchWord}"/>
                    </c:if>
                    <c:if test="${not empty pagingVO.currentPage && pagingVO.currentPage > 1}">
                        <c:param name="currentPage" value="${pagingVO.currentPage}"/>
                    </c:if>
                    <c:if test="${not empty param.statusFilter}">
                        <c:param name="statusFilter" value="${param.statusFilter}"/>
                    </c:if>
                </c:url>
                <a href="${finalRegisterFormUrl}" class="add-btn"><i class="fas fa-plus"></i> 등록</a>
            </sec:authorize>
        </div>
	</main>
	</div>
    </div>
    <%@ include file="../../../modules/footerPart.jsp" %>
	<%@ include file="../../../modules/sidebar.jsp" %>
</body>

<script type="text/javascript">

$(function(){
    const pagingArea = $('#pagingArea');
    const searchForm = $('#searchForm');

    if(pagingArea.length > 0) {
        pagingArea.on('click', 'a', function(event) {
            event.preventDefault();
            const page = $(this).data('page');

            const searchType = searchForm.find('select[name="searchType"]').val();
            const searchWord = searchForm.find('input[name="searchWord"]').val();
            const statusFilter = searchForm.find('input[name="statusFilter"]').val() || ''; // statusFilter 값 가져오기

            let targetPageUrl = '${pageContext.request.contextPath}/emp/concert/schedule/list?currentPage=' + page;

            if (searchType && searchWord && searchWord.trim() !== '') {
                targetPageUrl += '&searchType=' + encodeURIComponent(searchType);
                targetPageUrl += '&searchWord=' + encodeURIComponent(searchWord);
            }

            if (statusFilter && statusFilter.trim() !== '') {
                targetPageUrl += '&statusFilter=' + encodeURIComponent(statusFilter);
            }

            window.location.href = targetPageUrl;
        });
    }
});
</script>