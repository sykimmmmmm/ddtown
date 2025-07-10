<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 직원 포털 - 멤버십 관리</title>
    <%@ include file="../../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" >
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
    <style>
        .membership-header-bar { margin-bottom: 18px; flex-wrap: wrap; flex-direction: column; }
        .membership-header-bar .membership-title { font-size: 1.5em; font-weight: 700; color: #234aad; display: flex; align-items: center; gap: 10px; }
        .membership-title-group { display: flex; flex-direction: column; align-items: flex-start; gap: 10px; width: 100%;}
        .summary-info-row { display: flex; align-items: center; gap: 20px; flex-wrap: wrap; justify-content: space-between; width: 100%;}
        .membership-header-bar .membership-title .management-info { font-size: 0.8em; font-weight: 500; color: #555; display: flex; align-items: center; gap: 4px; }
        .membership-header-bar .membership-title .management-info .fas { font-size: 0.85em; color: #234aad; }
        .membership-search-bar { display: flex; align-items: center; gap: 10px; margin-bottom: 0; flex-wrap: wrap; margin-left: auto; }
        .membership-search-bar select,
        .membership-search-bar input[type="text"],
        .membership-search-bar button { padding: 7px 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 1em; height: 38px; box-sizing: border-box; }
        .membership-search-bar select { width: auto; min-width: 120px; max-width: 180px; -webkit-appearance: none; -moz-appearance: none; appearance: none;         /* Standard */
        background-image: url('data:image/svg+xml;utf8,<svg fill="%234A4A4A" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/><path d="M0 0h24v24H0z" fill="none"/></svg>');
        background-repeat: no-repeat; background-position: right 8px center; background-size: 16px; padding-right: 28px; }
    	.membership-search-bar input[type="text"] { flex-grow: 1; min-width: 180px; }
        .membership-search-bar button { background: #1976d2; color: #fff; border: none; cursor: pointer; }
        .membership-info-box { background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); padding: 24px 30px 18px 30px; margin-bottom: 24px; }
        .membership-info-row { display: flex; align-items: center; gap: 32px; margin-bottom: 18px; }
        .membership-info-row .artist-name { font-size: 1.2em; font-weight: 600; color: #234aad; margin-right: 18px; }
        .membership-info-row .info-label { color: #888; font-size: 0.98em; margin-right: 6px; }
        .membership-info-row .info-value { font-size: 1.1em; font-weight: 600; margin-right: 18px; }
        .membership-chart-box { background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); padding: 18px 18px 8px 18px; }
        .membership-chart-title { font-size: 1.1em; font-weight: 600; margin-bottom: 8px; color: #234aad; }
    	.status-badge { display: inline-block; padding: 4px 8px; border-radius: 12px; font-size: 0.85em; font-weight: 600; color: #fff; text-align: center; min-width: 50px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);}
    	.status-badge.active {background-color: #28a745;}
    	.status-badge.expired {background-color: #ffc107; color: #333;}
    	.status-badge.canceled {background-color: #dc3545;}
    	.badges-group {display: flex; gap: 10px; flex-wrap: wrap; }
    	.status-filter-badge { display: inline-block; padding: 6px 12px; border-radius: 18px; font-size: 0.9em; font-weight: 600; color: #fff; text-align: center; cursor: pointer; transition: all 0.2s ease; box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    	min-width: 80px; white-space: nowrap; }
    	.status-filter-badge:hover {opacity: 0.8; transform: translateY(-1px); }
    	.status-filter-badge[data-status="MSSC001"] { background-color: #28a745; } /* 구독중 */
        .status-filter-badge[data-status="MSSC002"] { background-color: #ffc107; color: #333; } /* 만료 */
        .status-filter-badge[data-status="MSSC003"] { background-color: #dc3545; } /* 취소 */
        .status-filter-badge[data-status=""] { background-color: #007bff; } /* 전체 */
        .status-badge { display: inline-block; padding: 4px 8px; border-radius: 12px; font-size: 0.85em; font-weight: 600; color: #fff; text-align: center; min-width: 50px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);}
    	.status-badge.active {background-color: #28a745;}
    	.status-badge.expired {background-color: #ffc107; color: #333;}
    	.status-badge.canceled {background-color: #dc3545;}
    	.top-section-wrapper {display: flex; align-items: flex-start; width: 100%; flex-wrap: wrap; }
    	.chart-grid-container {
	        display: grid;
	        grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); /* 두 개의 차트를 위한 레이아웃 */
	        gap: 24px;
	        margin-top: 20px; /* 멤버십 카드 목록 아래에 충분한 간격 */
	    }
	    .chart-box {
	        background: #fff;
	        border-radius: 8px;
	        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
	        padding: 18px 18px 8px 18px;
	    }
	    .chart-title {
        font-size: 1.2em;
        font-weight: 600;
        margin-bottom: 8px;
        color: #234aad;
        text-align: center; /* 제목 중앙 정렬 */
    	}
    	.mem { text-decoration: none !important; }
    	.ea-table {
	        width: 100%;
	        border-collapse: separate; /* border-spacing 적용을 위해 */
	        border-spacing: 0; /* 셀 경계선이 겹치지 않도록 */
	        background: #fff;
	        margin-bottom: 25px; /* 하단 여백 */
	        border-radius: 10px; /* 테이블 전체에 둥근 모서리 */
	        box-shadow: 0 5px 15px rgba(0,0,0,0.08); /* 테이블 전체에 그림자 */
	        overflow: hidden; /* 둥근 모서리를 위해 내용 숨김 */
	    }

	    .ea-table th, .ea-table td {
	        border: none; /* 기본 테두리 제거 */
	        padding: 15px; /* 패딩 조정 */
	        text-align: center;
	        vertical-align: middle;
	    }

	    .ea-table thead th {
	        background: #f0f5ff; /* 헤더 배경색 (FullCalendar 버튼과 유사) */
	        color: #234aad; /* 헤더 텍스트 색상 */
	        font-weight: 700; /* 더 굵게 */
	        border-bottom: 1px solid #d0d8e2; /* 헤더 하단에 구분선 */
	    }

	    .ea-table tbody tr {
	        transition: background-color 0.2s ease;
	    }

	    .ea-table tbody tr:nth-child(even) {
	        background-color: #f9f9f9; /* 짝수 행 배경색 */
	    }

	    .ea-table tbody tr:hover {
	        background-color: #eef7ff; /* 호버 시 배경색 변경 */
	    }

	    .ea-table tbody td {
	        color: #495057; /* 본문 텍스트 색상 */
	        border-bottom: 1px solid #e9ecef; /* 셀 하단 구분선 */
	    }
	    .ea-table tbody tr:last-child td {
	        border-bottom: none; /* 마지막 행 하단 구분선 제거 */
	    }

	    /* 데이터 없을 때 메시지 */
	    .ea-table tbody tr td[colspan] {
	        padding: 30px 15px;
	        color: #6c757d;
	        font-style: italic;
	    }

	    /* 멤버십명 굵게, 아이콘 색상 */
	    .ea-table strong {
	        font-weight: 700;
	        color: #234aad;
	    }
	    .ea-table .fa-gem {
	        color: #63DEFD;
	    }
	    /* 로그아웃 버튼 css */
	    .emp-logout-btn {
			all:unset;
		    color: #ecf0f1;
		    text-decoration: none;
		    display: flex;
		    align-items: center;
		    gap: 0.5rem;
		    padding: 0.6rem 1.2rem;
		    border-radius: 4px;
		    transition: background-color 0.3s;
		    font-size: 0.95rem;
		}

		.emp-logout-btn:hover {
		    background-color: #34495e;
		    color: #3498db;
		}
		.ea-table .subscriber-name-cell {
		    text-align: left; /* 좌측 정렬 */
		}
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../../modules/aside.jsp" %>
            <main class="emp-content" style="position:relative; min-height:600px; font-size: medium;">
               	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
						<li class="breadcrumb-item"><a class="mem" href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
						<li class="breadcrumb-item"><a class="mem" href="#" style="color:black;">멤버십 관리</a></li>
						<li class="breadcrumb-item active" aria-current="page">구독자 현황</li>
					</ol>
				</nav>
                <div class="membership-header-bar">
                	<div class="top-section-wrapper">
	                	<div class="membership-title-group">
		                	<div class="membership-title">멤버십 구독자 현황</div>
			                	<div class="summary-info-row">

				                    <div class="d-flex justify-content-center align-items-center gap-4">
					                    <span class="management-info">
					                    	<c:choose>
					                    		<c:when test="${not empty pagingVO.dataList }"> <i class="fas fa-user-tie"></i>
					                    			<span>담당 아티스트 : ${pagingVO.dataList[0].artGroupNm }</span>
					                    		</c:when>
					                    		<c:otherwise>
					                    			<i class="fas fa-info-circle" style="margin-right: 5px; color: #888;"></i>
					                    			<span>담당 아티스트가 없습니다.</span>
					                    		</c:otherwise>
					                    	</c:choose>
					                    </span>
					                    <div class="badges-group">
					                    	<span class="status-filter-badge <c:if test="${not empty mbspSubStatCode}">active-filter</c:if>" data-status="">전체 <c:out value="${subCounts.TOTAL != null ? subCounts.TOTAL : 0}"></c:out>건</span>
					                    	<span class="status-filter-badge <c:if test="${mbspSubStatCode eq 'MSSC001'}">active-filter</c:if>" data-status="MSSC001">구독 <c:out value="${subCounts.MSSC001 != null ? subCounts.MSSC001 : 0}"></c:out>건</span>
										    <span class="status-filter-badge <c:if test="${mbspSubStatCode eq 'MSSC002'}">active-filter</c:if>" data-status="MSSC002">만료 <c:out value="${subCounts.MSSC002 != null ? subCounts.MSSC002 : 0}"></c:out>건</span>
										    <span class="status-filter-badge <c:if test="${mbspSubStatCode eq 'MSSC003'}">active-filter</c:if>" data-status="MSSC003">취소 <c:out value="${subCounts.MSSC003 != null ? subCounts.MSSC003 : 0}"></c:out>건</span>
					                    </div>

			          				</div>
				                    <div class="membership-search-bar">
			                			<form class="input-group input-group-sm" method="get" id="searchForm" onchange="this.form.submit();">
			                				<input type="hidden" name="currentPage" value="1" id="currentPage">
			                  				<input type="text" id="searchWord" name="searchWord" value="${pagingVO.searchWord }" class="ea-search-input" placeholder="구독자 아이디를 입력해주세요.">
			                  				<div class="input-group-append">
												<button type="submit" class="ea-btn primary">
													<i class="fas fa-search"></i>검색
												</button>
											</div>
			                			</form>
			          				</div>
				                </div>
	                    	</div>
	                    	<%-- <div class="membership-search-bar">
	                			<form class="input-group input-group-sm" method="get" id="searchForm" onchange="this.form.submit();">
	                				<input type="hidden" name="currentPage" value="1" id="currentPage">
	                  				<input type="text" id="searchWord" name="searchWord" value="${pagingVO.searchWord }" class="ea-search-input" placeholder="구독자 아이디를 입력해주세요.">
	                  				<div class="input-group-append">
										<button type="submit" class="ea-btn primary">
											<i class="fas fa-search"></i>검색
										</button>
									</div>
	                			</form>
	          				</div> --%>
                		</div>
                	</div>
                <hr/>

                <div class="chart-grid-container">
	                <div class="chart-box">
	                	<h4 class="chart-title"><i class="fa-solid fa-calendar-check"></i> 월별 멤버십 신규 가입자 추이 </h4>
	                    <canvas id="monthlySignupsChart"></canvas>
	                </div>
	                <div class="chart-box">
	                	<h4 class="chart-title"><i class="fa-solid fa-crown"></i> 멤버십 장기 가입 고객 Top 3 </h4>
                   		<canvas id="topPayingUsersChart"></canvas>
	                </div>
	            </div>

                <hr/>
                <table class="ea-table" id="membershipSubTable">
                	<thead>
                		<tr>
                			<th>번호</th>
	                		<th>구독상태</th>
	                		<th>멤버십명</th>
	                		<th>아티스트명</th>
	                		<th>구독자명</th>
	                		<th>갱신일시</th>
	                		<th>종료일시</th>
	                		<th>가입일시</th>
                		</tr>
                	</thead>
                	<tbody id="membershipSubTablebody">
                		<c:if test="${empty pagingVO.dataList }">
                			<tr>
                				<td colspan="5" class="text-center">멤버십에 가입된 유저가 없습니다.</td>
                			</tr>
                		</c:if>
                		<c:forEach var="sub" items="${pagingVO.dataList }" varStatus="status">
                			<tr>
                				<td class="text-center"><c:out value="${sub.mbspSubNo}" /></td>
                				<td class="text-center">
                					<c:choose>
                						<c:when test="${sub.mbspSubStatCode eq 'MSSC001' }">
                							<span class="status-badge active">구독중</span>
                						</c:when>
                						<c:when test="${sub.mbspSubStatCode eq 'MSSC002' }">
                							<span class="status-badge expired">만료</span>
                						</c:when>
                						<c:when test="${sub.mbspSubStatCode eq 'MSSC003' }">
                							<span class="status-badge canceled">취소</span>
                						</c:when>
                						<c:otherwise>${sub.mbspSubStatCode }</c:otherwise>
                					</c:choose>
                				</td>
                				<td class="text-center"><i class="fa-solid fa-gem" style="margin-right: 8px; color: #63DEFD;"></i><strong><c:out value="${sub.mbspNm}" /></strong></td>
                				<td class="text-center"><c:out value="${sub.artGroupNm}" /></td>
                				<td class="subscriber-name-cell"><c:out value="${sub.memNicknm }"/></td>
                				<td class="text-center">
                					<fmt:formatDate value="${sub.subModDate}" pattern="yyyy-MM-dd HH:mm" />
                				</td>
                				<td class="text-center">
                					<fmt:formatDate value="${sub.subEndDate}" pattern="yyyy-MM-dd HH:mm" />
                				</td>
                				<td class="text-center">
                					<fmt:formatDate value="${sub.subStartDate}" pattern="yyyy-MM-dd HH:mm" />
                				</td>
                			</tr>
                		</c:forEach>
                	</tbody>
                </table>
                <div class="pagination-container" id="pagingArea">
		             ${pagingVO.pagingHTML}
			    </div>
            </main>
        </div>
    </div>
</body>
<script>

    	$(function(){
    	    const pagingArea = $('#pagingArea');
    	    const searchForm = $('#searchForm');

    	    // 뱃지 클릭 이벤트
   	    	$('.status-filter-badge').on('click', function() {
   	    		const status = $(this).data('status');	// data-status 값
   	    		let targetPageUrl = '${pageContext.request.contextPath}/emp/membership/sub/list?currentPage=1';	// 클릭 시 항상 1페이지

   	    		if(status && status.trim() !== '') {
   	    			targetPageUrl += '&mbspSubStatCode=' + encodeURIComponent(status);
   	    		}
   	    		window.location.href = targetPageUrl;
   	    	});

    	    if(pagingArea.length > 0) {
    	        pagingArea.on('click', 'a', function(event) {
    	            event.preventDefault();
    	            const page = $(this).data('page'); // data-page 속성에서 클릭된 페이지 번호 가져옴

    	            // 검색폼의 현재 searchWord 값을 가져옴
    	            const mbspSubStatCode = searchForm.find('select[name="mbspSubStatCode"]').val();
    	            const searchWord = searchForm.find('input[name="searchWord"]').val();

    	            // 페이지 이동을 위한 URL
    	            let targetPageUrl = '${pageContext.request.contextPath}/emp/membership/sub/list?currentPage=' + page;

    	            if(mbspSubStatCode) {
    	            	targetPageUrl += '&mbspSubStatCode=' + encodeURIComponent(mbspSubStatCode);
    	            }


    	            if (searchWord && searchWord.trim() !== '') {
    	                targetPageUrl += '&searchWord=' + encodeURIComponent(searchWord);
    	            }
    	            window.location.href = targetPageUrl;
    	        });
    	    }
    	});

        // 드롭다운 변경 시 검색 폼 제출
        document.addEventListener('DOMContentLoaded', function() {
        	const statusFilter = document.getElementById('mbspSubStatCode');
        	const searchForm = document.getElementById('searchForm');
        	const hiddenPageInput = document.getElementById('currentPage');

        	if(statusFilter) {
        		statusFilter.addEventListener('change', function() {
        			hiddenPageInput.value = 1;
        			searchForm.submit();	// 드롭다운 변경 시 바로 폼 제출
        		});
        	}

        	// 검색 버튼 클릭 시 (기존 검색 폼 유지)
            searchForm.addEventListener('submit', function(e) {
                hiddenPageInput.value = 1; // 검색 시 1페이지로 이동
            });
        });

        // DOMContentLoaded 이벤트 내에서 사이드바 관련 스크립트 및 초기 차트 렌더링 실행
        document.addEventListener('DOMContentLoaded', function() {
            // 사이드바 메뉴 토글 기능
            const navItemsWithSubmenu = document.querySelectorAll('.emp-sidebar .emp-nav-item.has-submenu');
            navItemsWithSubmenu.forEach(item => {
                const arrow = item.querySelector('.submenu-arrow');
                item.addEventListener('click', function(event) {
                    if (this.getAttribute('href') === '#') {
                        event.preventDefault();
                    }
                    const parentLi = this.parentElement;
                    const submenu = this.nextElementSibling;

                    if (submenu && submenu.classList.contains('emp-submenu')) {
                        const parentUl = parentLi.parentElement;
                        if (parentUl) {
                            Array.from(parentUl.children).forEach(siblingLi => {
                                if (siblingLi !== parentLi) {
                                    const siblingSubmenuControl = siblingLi.querySelector('.emp-nav-item.has-submenu.open');
                                    if (siblingSubmenuControl) {
                                        const siblingSubmenuElement = siblingSubmenuControl.nextElementSibling;
                                        siblingSubmenuControl.classList.remove('open');
                                        if (siblingSubmenuElement && siblingSubmenuElement.classList.contains('emp-submenu')) {
                                            siblingSubmenuElement.style.display = 'none';
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

            // 현재 페이지 URL 기반으로 사이드바 메뉴 활성화 및 펼침
            const currentFullHref = window.location.href;
            document.querySelectorAll('.emp-sidebar .emp-nav-item[href]').forEach(link => {
                const linkHrefAttribute = link.getAttribute('href');
                if (linkHrefAttribute && linkHrefAttribute !== "#" && currentFullHref.endsWith(linkHrefAttribute)) {
                    link.classList.add('active');
                    let currentActiveElement = link;
                    while (true) {
                        const parentLi = currentActiveElement.parentElement;
                        if (!parentLi) break;
                        const parentSubmenuUl = parentLi.closest('ul.emp-submenu');
                        if (parentSubmenuUl) {
                            parentSubmenuUl.style.display = 'block';
                            const controllingAnchor = parentSubmenuUl.previousElementSibling;
                            if (controllingAnchor && controllingAnchor.tagName === 'A' && controllingAnchor.classList.contains('has-submenu')) {
                                controllingAnchor.classList.add('active', 'open');
                                const arrow = controllingAnchor.querySelector('.submenu-arrow');
                                if (arrow) arrow.style.transform = 'rotate(90deg)';
                                currentActiveElement = controllingAnchor;
                            } else { break; }
                        } else { break; }
                    }
                }
            });

            // ==== 통계용 chart.js ====
            // 1. 월별 멤버십 신규 가입자 수 데이터 가져오기 (AJAX)
            fetch('${pageContext.request.contextPath}/emp/membership/sub/chartData/monthlySignups')
            	.then(response => response.json())
            	.then(monthlySignupsData => {
            		const signupLabels = monthlySignupsData.map(item => item.month);
            		const signupCounts = monthlySignupsData.map(item => item.count);
		            const ctx1 = document.getElementById('monthlySignupsChart').getContext('2d');
		           	new Chart(ctx1, {
		           		type: 'line',
		           		data: {
		           			labels: signupLabels,							// x축 레이블 (월)
		           			datasets: [{
		           				label: '월별 신규 가입자 수',
		           				data: signupCounts,							// y축 데이터 (가입자 수)
		           				borderColor: 'rgba(75, 192, 192)',			// 선 색상
		           				backgroundColor: 'rgba(75, 192, 192, 0.2)',	// 선 아래 영역 채우기 색상
		           				tension: 0.3,								// 선의 곡선
		           				fill: true									// 선 아래 영역 채울지 여부
		           			}]
		           		},
		           		options: {
		           			responsive: true,
		           			plugins: {
		           				title: {
		           					display: false,	// 차트 내부 제목 표시 여부
		           					text: '월별 멤버십 신규 가입자 추이'
		           				},
		           				legend: {
		           					display: false
		           				}
		           			},
		           			scales: {	// 축 설정
		           				y: {
		           					beginAtZero: true,	// Y축 0부터 시작
		           					title: {
		           						display: true,
		           						text: '가입자 수'
		           					},
		           					ticks: {
		           						callback: function(value) {
		           							if(Number.isInteger(value)) {
		           								return value;
		           							}
		           						}
		           					}
		           				},
		           				x: {
		           					title: {
		           						display: true,
		           						text: '월'
		           					}
		           				}
		           			}
		           		}
		           	});
            	})
           		.catch(error => console.error('Error fetching monthly signups:', error));

            // 가장 오래된 멤버십 가입 사용자 데이터 가져오기 (AJAX)
          	fetch('${pageContext.request.contextPath}/emp/membership/sub/chartData/topPayingUsers')
          		.then(response => response.json())
          		.then(topPayingUsersData => {

          			// y축 라벨
          			const userLabels = topPayingUsersData.map(item => item.memNicknm);

          			const ctx2 = document.getElementById('topPayingUsersChart').getContext('2d');
          			new Chart(ctx2, {
          				type: 'bar',
          				data: {
          					labels: userLabels,							// y축 레이블 (사용자 닉네임)
          					datasets: [{
          						label : '순위',							// X축 데이터
          						data: [3, 2, 1],
          						backgroundColor: [
              						'rgba(255, 99, 132, 0.7)', 			// 1위 사용자 (붉은 계열)
                                    'rgba(54, 162, 235, 0.7)', 			// 2위 사용자 (푸른 계열)
                                    'rgba(255, 206, 86, 0.7)'  			// 3위 사용자 (노란 계열)
              					],
              					borderColor: [
              						'rgba(255, 99, 132, 1)',
                                    'rgba(54, 162, 235, 1)',
                                    'rgba(255, 206, 86, 1)'
              					],
              					borderWidth: 1
          					}]
          				},
          				plugins :[ChartDataLabels],
          				options: {
          					indexAxis: 'y',			// 수평 막대 그래프로 변경
          					responsive: true,
          					plugins: {
          						title: {
          							display: false,	// 차트 내부 제목 표시 여부
          							text: '멤버십 장기 가입 고객 Top 3'
          						},
          						legend: {
          							display: false
          						},
          						tooltip: {
          							callbacks: {
          								label: function(context) {
          									const index = context.dataIndex;
          									const user = topPayingUsersData[index];
          									return `가입일: \${new Date(user.subStartDate).toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' })}`;
          								}
          							}
          						},
	          					datalabels: {
	          						color: function(context) {
	          							const index = context.dataIndex;
	          							if(index === 0 || index === 1) {
	          								return '#fff';
	          							} else {
	          								return '#666';
	          							}
	          						},
	          						font: function(context) {
	          							const index = context.dataIndex;
	          							const mappedRank = (topPayingUsersData.length - 1) + index - 1;

	          							if(mappedRank === 1) {
	          								return { size: 14, weight: 'bold' };
	          							} else {
	          								return { size: 14, weight: 'bold' };
	          							}
	          						},
	          						backgroundColor: function(context) {
	          							const index = context.dataIndex;
                                        // 막대 색상과 동일하게 설정
                                        const colors = [
                                            'rgba(255, 99, 132, 0.8)', // 1등 (붉은 계열)
                                            'rgba(54, 162, 235, 0.8)', // 2등 (푸른 계열)
                                            'rgba(255, 206, 86, 0.8)'  // 3등 (노란 계열)
                                        ];
                                        return colors[index]; // 해당 인덱스의 색상 반환
	          						},
	          						borderColor: function(context) {
	          							const index = context.dataIndex;
                                        const colors = [
                                            'rgba(255, 99, 132, 1)', // 1등 (붉은 계열) - 불투명하게
                                            'rgba(54, 162, 235, 1)', // 2등 (푸른 계열) - 불투명하게
                                            'rgba(255, 206, 86, 1)'  // 3등 (노란 계열) - 불투명하게
                                        ];
                                        return colors[index]; // 해당 인덱스의 색상 반환
	          						},
	          						borderWidth: 1,
	          						borderRadius: 50,
	          						padding: {
	          							top: 6,
	          							bottom: 6,
	          							left: 6,
	          							right: 6
	          						},
	          						anchor: 'end',
	          						align: 'end',
	          						offset: 4,

	          						// 라벨에 표시될 내용 포맷팅
	          						formatter: function(value, context) {
	          							if(value % 1 === 0 && value >= 1 && value <= topPayingUsersData.length) {
          									const actualRank = topPayingUsersData.length - value + 1;
                                            return actualRank + '등';
          								}
          								return '';
	          						},
	          						display: true	// 데이터 라벨 표시 여부
	          					}
          					},
          					scales: {
          						x: {				// x축 막대 길이 (순위)
          							title: {
	          							display: true,
	          							text: '가입 순위 (오래된 순)'
          							},
	          						beginAtZero: true,
	          						max: topPayingUsersData.length + 0.5,	// 막대 끝 잘리지 않도록
	          						ticks: {
	          							callback: function(value) {
	          								if(value % 1 === 0 && value >= 1 && value <= topPayingUsersData.length) {
	          									const actualRank = topPayingUsersData.length - value + 1;
	                                            return actualRank + '등';
	          								}
	          								return '';
	          							}
          							}
          						},
          						y: {				// y축 사용자 닉네임
          							title: {
          								display: true,
          								text: '사용자 닉네임'
          							}
          						}
          					}
          				}
          			});
          		})
          		.catch(error => console.error('Error fetching top paying users:', error));


        });
    </script>
</html>