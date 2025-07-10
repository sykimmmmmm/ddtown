<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>품목 관리 - DDTOWN 관리자 시스템</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/admin_items.css">
    <%@ include file="../../../modules/headerPart.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
<style>

/* ⭐⭐ 상품 관리 필터 뱃지 스타일 ⭐⭐ */

/* 뱃지 버튼들을 담는 컨테이너 */
/* 이 .filter-buttons는 이제 ea-section-header 내부에 배치됩니다. */
.filter-buttons {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    margin-bottom: 0 !important; /* mb-3 Bootstrap 클래스의 마진을 덮어씌워 0으로 만듦 */
    margin-left: 20px; /* h2와의 간격 */
    flex-grow: 1; /* 남은 공간을 차지하여 검색 폼과 겹치지 않도록 */
}

/* 모든 필터 뱃지 버튼에 공통적으로 적용될 기본 스타일 */
.status-filter-badge {
    display: inline-flex; /* 텍스트 내용에 따라 너비 자동 조절 + flexbox 속성 적용 */
    align-items: center; /* 텍스트 수직 중앙 정렬 */
    justify-content: center; /* 텍스트 수평 중앙 정렬 */
    padding: .25em .8em; /* 뱃지 내부의 상하좌우 여백 조정 (좀 더 넓게) */
    font-size: .85em; /* 폰트 크기 조정 */
    font-weight: 700;
    line-height: 1;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    border-radius: 1rem; /* 더 둥글게 (12px보다 더 부드럽게) */
    color: #fff; /* 글자색 흰색 (기본) */
    margin-right: 10px; /* 각 버튼 사이의 오른쪽 여백 */
    margin-bottom: 8px; /* 줄 바꿈 시 하단 간격 */
    cursor: pointer;
    border: none;
    text-decoration: none;
    min-height: 32px; /* 최소 높이 설정 (버튼들이 일관된 높이를 가지도록) */
    transition: all 0.2s ease-in-out; /* 부드러운 전환 효과 */
}

/* 1. "전체" 필터 뱃지 - 파란색 */
.status-filter-badge.status-filter-all {
    background-color: #0d6efd; /* Bootstrap primary blue */
}

/* 2. 각 상태 코드에 따른 배경색 정의 (상품 상태 코드) */
.status-filter-badge.status-filter-gsc001 { /* 판매중 */
    background-color: #28a745; /* Bootstrap success green */
}
.status-filter-badge.status-filter-gsc002 { /* 품절 */
    background-color: #dc3545; /* Bootstrap danger red */
}
/* 추가 상품 상태가 있다면 여기에 계속 추가하세요 */


/* 선택된 필터 버튼의 스타일 (강조 효과) */
.status-filter-badge.active {
    filter: brightness(1.15); /* 약간 더 밝게 */
}

/* 마우스 호버 시 효과 */
.status-filter-badge:hover {
    filter: brightness(0.9); /* 약간 어둡게 */
    transform: translateY(-1px); /* 살짝 위로 */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 강화 */
}

/* .ea-section-header에 display:flex를 사용하여 <h2>와 .filter-buttons를 나란히 배치 */
.ea-section-header {
    display: flex;
    align-items: center; /* 수직 중앙 정렬 */
    /* justify-content: flex-start; 이면 왼쪽 정렬 (기본값) */
    margin-bottom: 20px; /* 검색 폼과의 간격 */
    flex-wrap: wrap; /* 필요 시 줄 바꿈 허용 */
}

.ea-section-header h2 {
    margin-right: 20px; /* h2와 뱃지 필터 사이 간격 */
    margin-bottom: 0; /* h2의 기본 하단 마진 제거 (수직 정렬 시 필요) */
    white-space: nowrap; /* h2 텍스트가 길어질 경우 줄바꿈 방지 */
}

/* ea-header-actions는 이제 ea-section-header 아래에 별도로 위치하므로,
   이 컨테이너 자체에 flex 속성을 주어 내부 요소들을 정렬합니다. */
.ea-header-actions {
    display: flex;
    align-items: center;
    justify-content: flex-end; /* 내부 요소들을 오른쪽 끝으로 정렬 */
    margin-bottom: 20px; /* 테이블과의 간격 */
    gap: 10px; /* 내부 요소들 사이의 간격 */
    flex-wrap: wrap; /* 반응형을 위해 줄바꿈 허용 */
}

/* 검색 폼 내부의 select, input, button에 대한 세부 조정 */
#searchForm {
    display: flex; /* form 자체도 flex 컨테이너로 만들어 내부 input-group-append 정렬 */
    align-items: center;
    gap: 10px; /* 폼 요소들 사이 간격 */
    flex-wrap: wrap; /* 폼 요소들 줄 바꿈 허용 */
    width: 100%; /* 부모 컨테이너 너비만큼 확장 */
    justify-content: flex-end; /* 폼 요소들을 오른쪽으로 정렬 */
}

#searchForm .ea-filter-select,
#searchForm .ea-search-input {
    flex-shrink: 0; /* 줄어들지 않도록 */
    /* max-width: 200px;  필요시 최대 너비 지정 */
}

/* 테이블의 상품 상태 뱃지 스타일 (목록 내 각 행의 상태 표시) */
.item-status-badge { /* 상품 목록에서 사용될 뱃지 */
    display: inline-block;
    padding: .25em .6em;
    font-size: .75em; /* 목록 내 뱃지는 필터 뱃지보다 작게 */
    font-weight: 600;
    line-height: 1;
    text-align: center;
    white-space: nowrap;
    vertical-align: baseline;
    border-radius: .375rem;
    color: #fff;
}
.item-status-badge.status-GSC001 { /* 판매중 */
    background-color: #28a745; /* success */
}
.item-status-badge.status-GSC002 { /* 품절 */
    background-color: #dc3545; /* danger */
}

/* 검색 폼 내 버튼 (기존 스타일 유지) */
.ea-btn {
    display: inline-block;
    padding: .375rem .75rem;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    color: #212529;
    text-align: center;
    vertical-align: middle;
    cursor: pointer;
    background-color: #f8f9fa;
    border: 1px solid #ced4da;
    border-radius: .25rem;
    transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;
}
.ea-btn:hover {
    color: #212529;
    background-color: #e2e6ea;
    border-color: #dae0e5;
}
/* 검색 버튼 */
.ea-btn .fas.fa-search {
    margin-right: 5px;
}

/* 기존 d-flex justify-content-center align-items-center를 사용하는 부모 컨테이너에 적용 */
.d-flex.justify-content-center.align-items-center {
    /* 기존 justify-content: center; 대신 space-between을 사용합니다. */
    /* 이렇게 하면 첫 번째 요소는 왼쪽, 마지막 요소는 오른쪽, 나머지는 중앙에 공간 배분됩니다. */
    /* 여기서는 페이지네이션과 버튼 컨테이너 두 개이므로, 페이지네이션이 왼쪽에 가까워지고 버튼이 오른쪽에 가까워집니다. */
    justify-content: space-between;
    width: 100%; /* 부모 컨테이너가 가로 전체를 차지하도록 보장 */
    padding: 15px 0; /* 상하 여백 추가 (필요시 조절) */
}

/* 페이지네이션을 중앙에 더 가깝게 만들기 위해 flexbox 정렬을 활용합니다. */
.ea-pagination {
    flex-grow: 1; /* 남은 공간을 차지하여 중앙 정렬에 기여 */
    display: flex; /* 내부 ul을 정렬하기 위해 flex 컨테이너로 만듦 */
    justify-content: center; /* 내부 ul (페이지 링크들)을 중앙 정렬 */
    margin: 0; /* 기본 마진 제거 */
    padding: 0;
}

/* 등록 버튼 컨테이너를 오른쪽으로 밀착시키기 위해 */
.button-container-right {
    flex-shrink: 0; /* 줄어들지 않도록 설정 */
    margin-left: auto; /* 남은 공간을 모두 가져가서 오른쪽으로 밀착시킵니다. */
}
</style>
</head>

<body>
<div class="emp-container">
	<%@ include file="../../modules/header.jsp" %>

	<div class="emp-body-wrapper">
            <%@ include file="../../modules/aside.jsp" %>

            <main class="emp-content" style="font-size: large;">
                <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/admin/goods/items/list" style="color:black;">굿즈샵 관리</a></li>
                        <li class="breadcrumb-item active" aria-current="page">품목 관리</li>
                    </ol>
                </nav>

                <section id="goodsItemsSection" class="ea-section active-section">
                    <div class="ea-section-header">
					    <h2>품목 관리</h2>
						<%-- 필터 버튼 영역 --%>
						<div class="filter-buttons d-flex mb-3"> <%-- "전체" 버튼 --%>
						    <button type="button" class="status-filter-badge status-filter-all
						        <c:if test="${empty param.statusFilter and empty param.artGroupNo and empty param.searchWord}">active</c:if>"
						        onclick="location.href='${pageContext.request.contextPath}/admin/goods/items/list'">
						        전체 <c:out value="${totalAllGoodsCount}"/>건
						    </button>

						    <%-- 각 상태별 버튼 (판매중, 품절 등) --%>
						    <c:forEach var="statusCountMap" items="${goodsStatusCounts}">
						        <c:set var="statusCode" value="${statusCountMap.STATUS_CODE}"/>
						        <c:set var="count" value="${statusCountMap.COUNT}"/>
						        <c:set var="statusName" value="${statusCountMap.STATUS_NAME}"/>

						        <button type="button" class="status-filter-badge status-filter-${fn:toLowerCase(statusCode)}
						            <c:if test="${param.statusFilter eq statusCode}">active</c:if>"
						            onclick="location.href='${pageContext.request.contextPath}/admin/goods/items/list?statusFilter=${statusCode}'">
						            <c:out value="${statusName}"/> <c:out value="${count}"/>건
						        </button>
						    </c:forEach>
						</div>
					</div>

					<%-- ⭐⭐ 상품 재고 현황 섹션 추가 ⭐⭐ --%>
	                <h4>상품 재고 현황</h4>
	                <div class="charts-wrapper">
	                    <div class="chart-item-full-width">
	                        <canvas id="goodsStockChart"></canvas>
	                    </div>
	                </div>
	                <%-- ⭐⭐ 상품 재고 현황 섹션 끝 ⭐⭐ --%>

						<div class="ea-header-actions">
                            <form id="searchForm" method="GET" class="input-group input-group-sm" action="${pageContext.request.contextPath}/admin/goods/items/list">
							    <input type="hidden" name="currentPage" value="1" id="page">
							    <input type="hidden" name="statusFilter" id="hiddenStatusFilter" value="${pagingVO.searchMap.statusFilter}">

							    <select id="artistGroupFilter" name="artGroupNo" class="ea-filter-select">
							        <option value="">아티스트 전체</option>
							        <c:forEach items="${artistGroups}" var="group">
							            <option value="${group.artGroupNo}" ${pagingVO.searchMap.artGroupNo == group.artGroupNo ? 'selected' : ''}>
							                ${group.artGroupNm}
							            </option>
							        </c:forEach>
							    </select>
							    <select id="goodsItemCategoryFilter" name="searchType" class="ea-filter-select">
							        <option value="" ${pagingVO.searchMap.searchType == null || pagingVO.searchMap.searchType == '' ? 'selected' : ''}>최신 등록순</option>
							        <option value="mod_desc" ${pagingVO.searchMap.searchType == 'mod_desc' ? 'selected' : ''}>최신 수정순</option>
							        <option value="price_asc" ${pagingVO.searchMap.searchType == 'price_asc' ? 'selected' : ''}>낮은 가격순</option>
							        <option value="price_desc" ${pagingVO.searchMap.searchType == 'price_desc' ? 'selected' : ''}>높은 가격순</option>
							        <option value="stock_desc" ${pagingVO.searchMap.searchType == 'stock_desc' ? 'selected' : ''}>재고 많은 순</option>
							        <option value="stock_asc" ${pagingVO.searchMap.searchType == 'stock_asc' ? 'selected' : ''}>재고 적은 순</option>
							    </select>

							    <input type="text" id="searchWord" name="searchWord" value="${pagingVO.searchMap.searchWord}" class="ea-search-input" placeholder="상품명, 상품코드로 검색...">

							    <div class="input-group-append">
							        <button type="submit" class="ea-btn primary" id="goodsItemSearchBtn">
							            <i class="fas fa-search"></i>검색
							        </button>
							    </div>
							</form>
						</div>

                    <table class="ea-table" style="font-size: large;">
                        <thead>
                            <tr>
                                <th style="width: 8%;">상품코드</th>
                                <th style="width: 10%;">판매상태</th>
                                <th style="width: 8%;">이미지</th>
                                <th style="width: 10%">아티스트</th>
                                <th>상품명</th>
                                <th style="width: 10%;">판매가격</th>
                                <th style="width: 8%;">재고</th>
                                <th style="width: 10%;">등록일</th>
                            </tr>
                        </thead>
                        <tbody id="goodsItemsTableBody">
                            <c:choose>
                    			<c:when test="${not empty pagingVO.dataList and pagingVO.totalRecord > 0}">
    								<c:forEach items="${pagingVO.dataList}" var="goods">
                                        <tr>
                                            <td>${goods.goodsNo}</td>

                                            <td>
                                                <span class="status-badge status-${goods.statusEngKey.toLowerCase()}" style="font-size: large;">${goods.statusKorName}</span>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty goods.representativeImageUrl}">
                                                        <img src="${pageContext.request.contextPath}${goods.representativeImageUrl}" alt="${goods.goodsNm} 썸네일" class="item-thumbnail">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://via.placeholder.com/50?text=No+Image" alt="이미지 없음" class="item-thumbnail">
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                            	${goods.artGroupName}
                                            </td>
                                            <td><a href="${pageContext.request.contextPath}/admin/goods/items/detail?id=${goods.goodsNo}" class="doc-link">${goods.goodsNm}</a></td>
								            <td><fmt:formatNumber value="${goods.goodsPrice}" type="number" pattern="#,##0" /> 원</td>
								            <td>
								                <%-- 재고 수량 표시 --%>
								                <c:choose>
								                    <c:when test="${goods.stockRemainQty == null || goods.stockRemainQty <= 0}">
								                        <span style="color: red;">품절</span> (0개)
								                    </c:when>
								                    <c:otherwise>
								                        ${goods.stockRemainQty} 개
								                    </c:otherwise>
								                </c:choose>
								            </td>

								            <td><fmt:formatDate value="${goods.goodsRegDate}" pattern="yyyy-MM-dd"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 20px;">등록된 상품이 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>

                    </table>
                    <div class="d-flex justify-content-center align-items-center">
					    <div class="ea-pagination" id="pagingArea">
					        ${pagingVO.pagingHTML }
					    </div>

					    <div class="button-container-right">
					    	<a href="/admin/goods/items/form" class="ea-btn primary" id="itemsAddButton"><i class="fas fa-plus"></i>등록</a>
					    </div>
					</div>
                </section>
            </main>
        </div>
    </div>
</body>
<%@ include file="../../../modules/footerPart.jsp" %>

<%@ include file="../../../modules/sidebar.jsp" %>
<script type="text/javascript">
$(function(){
	Chart.register(ChartDataLabels);
    // 페이지네이션 처리
    const searchForm = document.getElementById("searchForm");
    const pageInput = searchForm.querySelector("input[name='currentPage']");
    const paginationControls = document.getElementById("pagingArea");

    // ⭐⭐⭐ 여기에 모든 DOM 요소 변수를 선언해야 합니다. ⭐⭐⭐
    const hiddenStatusFilter = document.getElementById("hiddenStatusFilter");
    const artistGroupFilter = document.getElementById("artistGroupFilter");
    const goodsItemCategoryFilter = document.getElementById("goodsItemCategoryFilter");
    const searchWordInput = document.getElementById("searchWord");
    const goodsItemSearchBtn = document.getElementById("goodsItemSearchBtn"); // 검색 버튼 참조 추가

    // 개발자 도구 콘솔에 각 요소가 제대로 참조되었는지 로그로 확인
//     console.log("hiddenStatusFilter:", hiddenStatusFilter);
//     console.log("artistGroupFilter:", artistGroupFilter);
//     console.log("goodsItemCategoryFilter:", goodsItemCategoryFilter);
//     console.log("searchWordInput:", searchWordInput);
//     console.log("goodsItemSearchBtn:", goodsItemSearchBtn);
    // 만약 이들 중 하나라도 'null'로 출력되면, 해당 ID를 가진 HTML 요소가 없거나 ID가 잘못된 것임.


    if (paginationControls) {
        paginationControls.addEventListener("click", function(e) {
            e.preventDefault();
            if (e.target.classList.contains("page-link") && (e.target.nodeName === "A" || e.target.nodeName === "SPAN")) {
                pageInput.value = e.target.dataset.page;
                searchForm.submit();
            }
        });
    }

    // ⭐ 뱃지 필터 버튼 클릭 이벤트 ⭐
    $('.badge-filter-btn').on('click', function() {
        const statusToFilter = $(this).data('status');

        // ⭐ 다른 모든 필터 초기화 ⭐
        artistGroupFilter.value = ""; // 아티스트 필터 초기화
        goodsItemCategoryFilter.value = ""; // 정렬 필터 초기화
        searchWordInput.value = ""; // 검색어 초기화

        hiddenStatusFilter.value = statusToFilter; // 선택된 상태 값 설정
        pageInput.value = "1"; // 페이지 초기화
        searchForm.submit();
    });


    //⭐ 아티스트 그룹 필터 변경 이벤트 ⭐
    $('#artistGroupFilter').on('change', function() {
            // ⭐ 다른 모든 필터 초기화 ⭐
            hiddenStatusFilter.value = ""; // 상태 필터 초기화
            goodsItemCategoryFilter.value = ""; // 정렬 필터 초기화
            searchWordInput.value = ""; // 검색어 초기화

            // 아티스트 필터 값은 select 태그의 value로 자동 전송됨
            pageInput.value = "1"; // 페이지 초기화
            searchForm.submit();
    });

    $('#goodsItemCategoryFilter').on('change', function() {
        // ⭐ 다른 모든 필터 초기화 ⭐
        hiddenStatusFilter.value = ""; // 상태 필터 초기화
        artistGroupFilter.value = ""; // 아티스트 필터 초기화
        searchWordInput.value = ""; // 검색어 초기화

        // 정렬 필터 값은 select 태그의 value로 자동 전송됨
        pageInput.value = "1"; // 페이지 초기화
        searchForm.submit();
    });

    goodsItemSearchBtn.addEventListener('click', function(e) {
        // ⭐ 다른 필터 초기화 (검색어와 정렬은 유지) ⭐
        hiddenStatusFilter.value = ""; // 상태 필터 초기화
        artistGroupFilter.value = ""; // 아티스트 필터 초기화
        // goodsItemCategoryFilter.value = ""; // 필요시 정렬도 초기화

        pageInput.value = "1"; // 페이지 초기화
        // searchForm.submit()은 버튼의 기본 동작으로 수행됨
    });

    searchWordInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault(); // 기본 폼 제출 방지

            // ⭐ 다른 필터 초기화 (검색어와 정렬은 유지) ⭐
            hiddenStatusFilter.value = ""; // 상태 필터 초기화
            artistGroupFilter.value = ""; // 아티스트 필터 초기화
            // goodsItemCategoryFilter.value = ""; // 필요시 정렬도 초기화

            pageInput.value = "1"; // 페이지 초기화
            searchForm.submit(); // 폼 제출
        }
    });

    // 테이블 행 클릭 이벤트
    $('#goodsItemsTableBody').on('click', 'tr', function() {
        const goodsNo = $(this).find('td:first').text(); // 첫 번째 td (상품코드)의 텍스트 가져오기
        if (goodsNo) {
            location.href="${pageContext.request.contextPath}/admin/goods/items/detail?id=" + goodsNo;
        }

    });

 // ⭐ 재고 통계 차트 데이터 파싱 ⭐
    const goodsStockCountsMap = {};

    <c:forEach var="item" items="${goodsStockCountsList}">
        goodsStockCountsMap['${item.STOCK_CATEGORY}'] = parseInt('<c:out value="${item.COUNT_VALUE}" default="0"/>', 10);
    </c:forEach>

// 	 console.log("파싱된 goodsStockCountsMap:", goodsStockCountsMap);

	 // 차트 레이블 정의 (사용자에게 보여줄 이름)
	 const stockLabels = [
	     '품절 (0개)',
	     '재고 부족 (1~100개)',
	     '재고 보통 (101~500개)',
	     '재고 충분 (501~5000개)',
	     '재고 매우 많음 (5001개 이상)'
	 ];

	 // 차트 데이터 (레이블 순서와 일치하도록 배열에 담음)
	 const stockValues = [
	     goodsStockCountsMap['SOLD_OUT'] || 0,        // SOLD_OUT 키가 없으면 0을 사용
	     goodsStockCountsMap['LOW_STOCK'] || 0,
	     goodsStockCountsMap['NORMAL_STOCK'] || 0,
	     goodsStockCountsMap['AMPLE_STOCK'] || 0,
	     goodsStockCountsMap['OVERWHELMING_STOCK'] || 0
	 ];
// 	 console.log("stockValues:", stockValues);

    // 차트 배경색 정의 (새로운 구간에 맞춰 추가)
    const stockBackgroundColors = [
        '#dc3545', // 품절: Bootstrap danger red
        '#ffc107', // 재고 부족: Bootstrap warning yellow
        '#0dcaf0', // 재고 보통: Bootstrap info cyan
        '#20c997', // 재고 충분: Bootstrap teal (새로운 색상)
        '#6f42c1'  // 재고 매우 많음: Bootstrap purple (새로운 색상)
    ];

    // Chart.js 인스턴스 생성
    const goodsStockCtx = document.getElementById('goodsStockChart').getContext('2d');
//     console.log("goodsStockCtx:", goodsStockCtx);
    new Chart(goodsStockCtx, {
        type: 'pie', // 파이 차트 (도넛 차트를 원하면 'doughnut'으로 변경)
        data: {
            labels: stockLabels, // 각 조각의 이름
            datasets: [{
                data: stockValues, // 각 조각의 값 (상품 개수)
                backgroundColor: stockBackgroundColors, // 각 조각의 색상
                hoverOffset: 4 // 마우스 오버 시 조각이 약간 튀어나오게 함
            }]
        },
        plugins :[ChartDataLabels], // 이 줄은 그대로 둡니다.
        options: {
            responsive: true, // 반응형으로 크기 조절
            maintainAspectRatio: false, // 부모 컨테이너에 맞춰 비율 유지하지 않음 (높이 조절 가능)

            plugins: {
                title: {
                    display: true,
                    text: '상품 재고 현황', // 차트 제목
                    font: {
                        size: 16,
                        weight: 'bold'
                    },
                    padding: {
                        top: 10,
                        bottom: 20
                    }
                },
                tooltip: { // 툴팁 (마우스 오버 시 정보) 설정
                    callbacks: {
                        label: function(context) {
                        	// ⭐⭐ 이 부분을 수정합니다: stockLabels 배열에서 직접 가져오기 ⭐⭐
                            let label = stockLabels[context.dataIndex] || ''; // context.label 대신 직접 배열에서 인덱스로 접근
                            if (label) {
                                label += ': ';
                            }
                            if (context.parsed !== null) {
                                label += context.parsed + '건'; // 값 뒤에 '건' 추가
                            }
                            return label;
                        }
                    }
                },
             // ⭐⭐⭐ 이 datalabels 섹션을 다음과 같이 수정하거나 추가해주세요 ⭐⭐⭐
                datalabels: {
                    display: function(context) {
                        // 차트 조각 위에만 숫자를 표시 (값이 0이 아닌 경우)
                        return context.dataset.data[context.dataIndex] > 0;
                    },
                    formatter: function(value, context) {
                        // 차트 조각 위에 표시될 텍스트 포맷 (예: '10')
                        return value;
                    },
                    color: '#fff', // 텍스트 색상
                    font: {
                        weight: 'bold',
                        size: 14
                    },
                },
                legend: { // 범례 설정
                    position: 'right', // 범례를 오른쪽에 배치
                    align: 'center',
                    labels: {
                        boxWidth: 20, // 범례 색상 상자 너비
                        padding: 15, // 범례 항목 간 패딩
                        font: {
                            size: 13
                        },
                        // 각 레이블에 해당 퍼센트와 개수를 추가하여 표시
                        generateLabels: function(chart) {
                            const data = chart.data;
                            if (data.labels.length && data.datasets.length) {
                                const total = data.datasets[0].data.reduce((sum, val) => sum + val, 0);
                                return data.labels.map((label, i) => {
                                    const value = data.datasets[0].data[i];
                                    const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                    return {
                                    	// ⭐⭐⭐ data.labels[i]를 사용하여 stockLabels의 실제 텍스트를 가져옵니다. ⭐⭐⭐
                                        text: `\${data.labels[i]} (\${value}건, \${percentage}%)`, // 레이블과 건수, 퍼센트 표시
                                        fillStyle: data.datasets[0].backgroundColor[i],
                                        strokeStyle: data.datasets[0].borderColor ? data.datasets[0].borderColor[i] : '',
                                        lineWidth: data.datasets[0].borderWidth,
                                        // 데이터가 0인 항목은 범례에서도 숨김 (선택 사항)
                                        hidden: data.datasets[0].data[i] === 0,
                                        index: i
                                    };
                                });
                            }
                            return [];
                        }
                    }
                }
            }
        }
    });
});
</script>
</html>