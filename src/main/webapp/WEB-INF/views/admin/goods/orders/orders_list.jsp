<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문내역 관리 - DDTOWN 관리자 시스템</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <%@ include file="../../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/admin_order.css">
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<style>
/* admin_order.css */

/* ⭐⭐ 공통 레이아웃 및 폼 요소 스타일 (필요하다면 유지, 없으면 삭제 가능) ⭐⭐ */
.ea-section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
}

/* admin_order.css 또는 <style> 태그 내에 추가 */
.ea-section-header h2 {
    white-space: nowrap; /* 텍스트가 줄바꿈되지 않도록 강제 */
    margin-right: 20px; /* h2와 필터 버튼 사이 간격 유지 (필요시) */
}

#searchForm {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    align-items: center;
    margin-bottom: 20px;
}
#searchForm > * {
    margin-bottom: 0;
}

.ea-header-actions {
    display: flex;
    gap: 10px;
    align-items: center;
}

/* ⭐⭐ 주문 내역 필터 뱃지 스타일 ⭐⭐ */

/* 뱃지 버튼들을 담는 컨테이너 */
.filter-buttons {
    display: flex; /* 자식 요소들을 한 줄에 배치 */
    flex-wrap: wrap; /* 버튼이 많아지면 다음 줄로 넘어가도록 */
    align-items: center; /* 수직 중앙 정렬 */
    width: 100%; /* 부모 요소 너비 가득 채우기 */
}

/* 모든 필터 뱃지 버튼에 공통적으로 적용될 기본 스타일 */
.status-filter-badge {
    display: inline-flex; /* 텍스트 내용에 따라 너비 자동 조절 + flexbox 속성 적용 */
    align-items: center; /* 텍스트 수직 중앙 정렬 */
    justify-content: center; /* 텍스트 수평 중앙 정렬 */
    font-weight: 700;
    line-height: 1;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    border-radius: 1rem; /* 더 둥글게 */
    color: #fff; /* 글자색 흰색 (기본) */
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

/* 2. 각 상태 코드에 따른 배경색 정의 (주문 상태 코드) */
/* OSC001: 결제 완료 */
.status-filter-badge.status-filter-osc001 {
    background-color: #28a745; /* success (초록) */
}
/* OSC002: 결제 실패 */
.status-filter-badge.status-filter-osc002 {
    background-color: #dc3545; /* danger (빨강) */
}
/* OSC003: 상품 준비중 */
.status-filter-badge.status-filter-osc003 {
    background-color: #ffc107; /* warning (노랑) */
    color: #212529; /* 글자색 검정 */
}
/* OSC004: 배송 중 */
.status-filter-badge.status-filter-osc004 {
    background-color: #0dcaf0; /* info (하늘) */
    color: #212529; /* 글자색 검정 */
}
/* OSC005: 배송 완료 */
.status-filter-badge.status-filter-osc005 {
    background-color: #6610f2; /* purple */
}
/* OSC006: 취소 요청 */
.status-filter-badge.status-filter-osc006 {
    background-color: #fd7e14; /* orange */
}
/* OSC007: 취소 처리중 */
.status-filter-badge.status-filter-osc007 {
    background-color: #6c757d; /* secondary (회색) */
}
/* OSC008: 취소 완료 */
.status-filter-badge.status-filter-osc008 {
    background-color: #20c997; /* teal */
}
/* OSC009: 결제 요청 */
.status-filter-badge.status-filter-osc009 {
    background-color: #e83e8c; /* pink */
}


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

/* 뱃지 내부의 숫자 스타일 */
.status-count {
    margin-left: 5px; /* 텍스트와 숫자 사이 간격 */
    font-weight: 700;
}


/* ⭐⭐ 테이블 내 주문 상태 뱃지 스타일 (목록 내 각 행의 상태 표시) ⭐⭐ */
.order-status-badge {
    display: inline-block;
    font-weight: 600;
    line-height: 1;
    text-align: center;
    white-space: nowrap;
    vertical-align: baseline;
    color: #fff;
    font-size: large;
}
/* OSC001: 결제 완료 */
.order-status-badge.status-OSC001 {
    background-color: #28a745;
}
/* OSC002: 결제 실패 */
.order-status-badge.status-OSC002 {
    background-color: #dc3545;
}
/* OSC003: 상품 준비중 */
.order-status-badge.status-OSC003 {
    background-color: #ffc107;
    color: #212529;
}
/* OSC004: 배송 중 */
.order-status-badge.status-OSC004 {
    background-color: #0dcaf0;
    color: #212529;
}
/* OSC005: 배송 완료 */
.order-status-badge.status-OSC005 {
    background-color: #6610f2;
}
/* OSC006: 취소 요청 */
.order-status-badge.status-OSC006 {
    background-color: #fd7e14;
}
/* OSC007: 취소 처리중 */
.order-status-badge.status-OSC007 {
    background-color: #6c757d;
}
/* OSC008: 취소 완료 */
.order-status-badge.status-OSC008 {
    background-color: #20c997;
}
/* OSC009: 결제 요청 */
.order-status-badge.status-OSC009 {
    background-color: #e83e8c;
}

/* 결제 방법 뱃지 (목록 내 각 행의 결제 방법 표시) */
/* 각 결제 방법에 따라 필요한 경우 추가 정의 */
.status-카카오페이 {
    background-color: #ffca1a; /* 카카오 노랑 */
    color: #212529;
}
.ea-table th {
	text-align: center;
}
/* 필요한 결제 수단에 따라 추가 */

/* 검색 폼 내 버튼 */
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
.ea-btn .fas.fa-search {
    margin-right: 5px;
}

/* 차트 컨테이너 스타일 (선택 사항) */
        .chart-container {
            width: 80%; /* 원하는 너비 설정 */
            margin: 20px auto;
            /* 차트가 목록 위나 옆에 위치하도록 레이아웃 조정 필요 */
        }
        .charts-wrapper {
            display: flex; /* 차트들을 가로로 나열하기 위해 flexbox 사용 */
            justify-content: space-around;
            flex-wrap: wrap; /* 화면이 작아지면 자동으로 줄 바꿈 */
            margin-bottom: 30px;
        }
		.chart-item {
		    width: 48%; /* 두 개의 차트가 한 줄에 오도록 너비 설정 (유지) */
		    max-width: 700px; /* ⭐ 최대 너비를 늘려서 차트가 더 커질 수 있도록 합니다 ⭐ */
		    min-width: 350px; /* ⭐ 최소 너비도 늘려 작은 화면에서 너무 쪼그라들지 않도록 합니다 ⭐ */
		    height: 400px; /* ⭐ 차트 컨테이너의 높이를 명시적으로 설정하여 세로 공간을 확보합니다 ⭐ */
		    padding: 15px;
		    border: 1px solid #eee;
		    border-radius: 8px;
		    box-shadow: 2px 2px 8px rgba(0,0,0,0.1);
		    background-color: #fff;
		    margin: 10px 0; /* 상하 여백 */
		    box-sizing: border-box; /* 패딩과 보더가 너비/높이에 포함되도록 설정 (일반적으로 좋은 습관) */
		}
</style>
<body>
    <div class="emp-container">
        <%@ include file="../../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../../modules/aside.jsp" %>
            <main class="emp-content" style="font-size: large;">
            <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/admin/goods/orders/list" style="color:black;">굿즈샵 관리</a></li>
                        <li class="breadcrumb-item active" aria-current="page">주문 내역 관리</li>
                    </ol>
                </nav>
                <section class="ea-section">
                    <div class="ea-section-header">
                        <h2>주문 내역 관리</h2>
                        
                        <div class="filter-sub-group filter-buttons">
					        <button type="button" class="status-filter-badge status-filter-all ${param.orderStatusFilter == null or param.orderStatusFilter == '' ? 'active' : ''}" data-status-code="">
                                전체 <span class="status-count">${orderStatusCounts["ALL"] != null ? orderStatusCounts["ALL"] : 0} 건</span>
                            </button>
					        <button type="button" class="status-filter-badge status-filter-osc001 ${param.orderStatusFilter == 'OSC001' ? 'active' : ''}" data-status-code="OSC001">
                                결제 완료 <span class="status-count">${orderStatusCounts["OSC001"] != null ? orderStatusCounts["OSC001"] : 0} 건</span>
                            </button>
					        <button type="button" class="status-filter-badge status-filter-osc002 ${param.orderStatusFilter == 'OSC002' ? 'active' : ''}" data-status-code="OSC002">
                                결제 실패 <span class="status-count">${orderStatusCounts["OSC002"] != null ? orderStatusCounts["OSC002"] : 0} 건</span>
                            </button>
					        
					        <button type="button" class="status-filter-badge status-filter-osc008 ${param.orderStatusFilter == 'OSC008' ? 'active' : ''}" data-status-code="OSC008">
                                취소 완료 <span class="status-count">${orderStatusCounts["OSC008"] != null ? orderStatusCounts["OSC008"] : 0} 건</span>
                            </button>
					        <button type="button" class="status-filter-badge status-filter-osc009 ${param.orderStatusFilter == 'OSC009' ? 'active' : ''}" data-status-code="OSC009">
                                결제 요청 <span class="status-count">${orderStatusCounts["OSC009"] != null ? orderStatusCounts["OSC009"] : 0} 건</span>
                            </button>
					    </div>
                    </div>

                    <form id="searchForm" action="/admin/goods/orders/list" method="get" class="filter-group">
					    <input type="hidden" name="currentPage" value="${param.currentPage ne '' and param.currentPage ne null ? param.currentPage : 1}">
					    <input type="hidden" id="orderStatusFilter" name="orderStatusFilter" value="${param.orderStatusFilter}">
						
						<div class="filter-sub-group">
					    <label for="orderDateStart">주문일자:</label>
					    <input type="date" id="orderDateStart" name="orderDateStart" value="${param.orderDateStart}">
					    <span>~</span>
					    <input type="date" id="orderDateEnd" name="orderDateEnd" value="${param.orderDateEnd}">
						</div>
						

					  
					    <div class="filter-sub-group search-group"> 
					    	<input type="text" id="orderSearchInput" name="orderSearchInput" placeholder="주문번호, 회원ID, 닉네임" value="${param.orderSearchInput}">
					        <button type="submit" id="orderSearchBtn" class="ea-btn"><i class="fas fa-search"></i> 검색</button>
					    </div>
					</form>
					
					<h4>주문 통계 현황</h4>
					<div class="charts-wrapper">
				        <div class="chart-item">
				            <canvas id="dailySalesChart"></canvas>
				        </div>
				
				        <div class="chart-item">
				            <canvas id="topSellingGoodsChart"></canvas>
				        </div>
				    </div>
					
                    <table class="ea-table" style="font-size: large;">
                        <thead>
                            <tr>
                                <th style="width:5%; white-space: nowrap;">주문 번호</th>
                                <th style="width:7%;">주문 상태</th>
                                <th>주문 상품</th> 
                                <th style="width:12%;">주문자(이름 / 아이디)</th>
                                <th style="width:10%;">총 주문금액</th>
								<th style="width:15%;">주문 일시</th>
                                <th style="width:7%;">결제 방법</th>
                            </tr>
                        </thead>
						<tbody id="ordersTableBody">
                            <c:choose>
                                <c:when test="${not empty pagingVO.dataList}">
                                    <c:forEach var="order" items="${pagingVO.dataList}">
                                        <tr>
                                            <td style="text-align: center;">
                                                ${order.orderNo}
                                            </td>
                                            
                                            <td style="text-align: center;">
											    <span class="order-status-badge status-${order.orderStatCode}">${order.orderStatName}</span>
											</td>
                                            
                                            <td>
                                            	<a href="/admin/goods/orders/detail?orderNo=${order.orderNo}&amp;currentPage=${pagingVO.currentPage}&amp;orderDateStart=${param.orderDateStart}&amp;orderDateEnd=${param.orderDateEnd}&amp;orderStatusFilter=${param.orderStatusFilter}&amp;orderSearchInput=${param.orderSearchInput}" class="doc-link">
                                                <c:choose>
                                                    <c:when test="${not empty order.orderDetailList}">
                                                        ${order.orderDetailList[0].goodsNm} 
                                                        <c:if test="${order.orderDetailList[0].goodsOptNm != null && order.orderDetailList[0].goodsOptNm != ''}">
                                                            (${order.orderDetailList[0].goodsOptNm})
                                                        </c:if>
                                                        
                                                        <c:if test="${fn:length(order.orderDetailList) > 1}">
                                                            외 ${fn:length(order.orderDetailList) - 1}건
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        - 상품 없음 -
                                                    </c:otherwise>
                                                </c:choose>
                                                </a>
                                            </td>
                                            
                                            
                                            <td>${order.customerName} (${order.customerId})</td>
                                            
                                            
                                            <td style="text-align: right;"><fmt:formatNumber value="${order.orderTotalPrice}" pattern="#,###원"/></td>
                                            <td style="text-align: center;"><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <%-- ⭐ 결제 방법 뱃지 추가 (order.orderPayMethodNm가 코드라면 status-CODE 형식으로) ⭐ --%>
                                            <td style="text-align: center;"><span class="order-status-badge status-${order.orderPayMethodNm}">${order.orderPayMethodNm}</span></td>
                                           	
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center">조회된 주문 내역이 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    <div class="ea-pagination" id="pagingArea">
                    	${pagingVO.pagingHTML }
                    </div>
                </section>
            </main>
        </div>
    </div>
<%@ include file="../../../modules/footerPart.jsp" %>

<%@ include file="../../../modules/sidebar.jsp" %>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const searchForm = document.getElementById("searchForm");
    const pageInput = searchForm.querySelector("input[name='currentPage']");
    const paginationControls = document.getElementById("pagingArea");
    const orderStatusFilterHiddenInput = document.getElementById("orderStatusFilter"); // hidden input
    const statusFilterBadges = document.querySelectorAll(".status-filter-badge"); // 뱃지 버튼들

    const dailySalesData = JSON.parse('<c:out value="${dailySalesDataJson}" escapeXml="false"/>');
    const topSellingGoodsData = JSON.parse('<c:out value="${topSellingGoodsJson}" escapeXml="false"/>');

    const salesLabels = Object.keys(dailySalesData).sort();
    const salesValues = salesLabels.map(label => dailySalesData[label]);

    const dailySalesCtx = document.getElementById('dailySalesChart').getContext('2d');
    new Chart(dailySalesCtx, {
        type: 'line', // 선 그래프
        data: {
            labels: salesLabels, // 날짜 라벨 (예: "06-23")
            datasets: [{
                label: '일별 매출액 (원)',
                data: salesValues,
                borderColor: 'rgb(75, 192, 192)',
                tension: 0.1, // 선의 부드러움 조절
                fill: false // 그래프 아래를 채우지 않음
            }]
        },
        options: {
            responsive: true, // 반응형
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: true,
                    text: '일별 매출 현황'
                }
            },
            scales: {
                y: {
                    beginAtZero: true, // Y축을 0부터 시작
                    title: {
                        display: true,
                        text: '매출액'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: '날짜 (MM-dd)'
                    }
                }
            }
        }
    });

    // --- 인기 상품 TOP N 차트 그리기 ---
    const goodsLabels = topSellingGoodsData.map(item => item.GOODS_NM);
    const goodsValues = topSellingGoodsData.map(item => item.TOTAL_SOLD_QTY);

    const topSellingGoodsCtx = document.getElementById('topSellingGoodsChart').getContext('2d');
    new Chart(topSellingGoodsCtx, {
        type: 'bar', // 막대 그래프
        data: {
            labels: goodsLabels, // 상품명
            datasets: [{
                label: '총 판매량',
                data: goodsValues,
                backgroundColor: 'rgba(153, 102, 255, 0.6)', // 막대 색상
                borderColor: 'rgba(153, 102, 255, 1)', // 테두리 색상
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: true,
                    text: '인기 판매 상품 (TOP 5)'
                },
                legend: {
                    display: false // 범례 숨기기
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '판매량'
                    }
                },
                x: {
                    ticks: {
                        autoSkip: false,
                        // maxRotation과 minRotation을 없애거나 0으로 설정하여 회전을 비활성화
                        // maxRotation: 0,
                        // minRotation: 0,
                        callback: function(value, index, values) {
                            // 레이블이 너무 길면 자르고 "..." 추가
                            const maxLength = 15; // 표시할 최대 글자 수
                            if (value.length > maxLength) {
                                return value.substring(0, maxLength) + '...';
                            }
                            return value;
                        }
                    },
                    title: {
                        display: true,
                        text: '상품명'
                    }
                }
            }
        }
    });

    // 페이지네이션 처리
    if (paginationControls) {
        paginationControls.addEventListener("click", function(e) {
            e.preventDefault();
            const clickedElement = e.target.closest(".page-link");
            if (clickedElement && clickedElement.dataset.page) {
                pageInput.value = clickedElement.dataset.page;
                searchForm.submit();
            }
        });
    }

    // ⭐ 뱃지 필터링 처리 ⭐
    statusFilterBadges.forEach(badge => {
        badge.addEventListener('click', function() {
            const statusCode = this.dataset.statusCode; // data-status-code 값 가져오기
            orderStatusFilterHiddenInput.value = statusCode; // hidden input 업데이트
            pageInput.value = 1; // 필터 변경 시 첫 페이지로 이동
            searchForm.submit(); // 폼 제출
        });
    });

    // 검색 버튼 클릭 시에도 currentPage를 1로 초기화 (선택 사항)
    const orderSearchBtn = document.getElementById("orderSearchBtn");
    if (orderSearchBtn) {
        orderSearchBtn.addEventListener('click', function() {
            pageInput.value = 1;
        });
    }

});
</script>
</body>
</html>