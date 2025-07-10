<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 관리자 시스템</title>
   	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/admin_portal.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/admin_main_static.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script type="text/javascript">
		$(function(){
			<c:if test="${not empty message }">
				Swal.fire({
						title : "${message }",
						icon : "success",
						draggable : true
					});
				<c:remove var="message" scope="request"/>
				<c:remove var="message" scope="session"/>
			</c:if>
		})
		function sweetAlert(type, msg){
			return Swal.fire({
				title : msg,
				icon : type,
				draggable : true
			});
		}
	</script>
	<style type="text/css">
		table tr th {
			text-align: center;
		}
	</style>
</head>
<body>
	<sec:authentication property="principal.employeeVO" var="empVO"/>
    <div class="emp-container">
        <%@ include file="./modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="./modules/aside.jsp" %>

            <main class="emp-content">
                <div class="portal-welcome-message mb-4">
                    <h2 class="mb-2">DDTOWN 관리자 시스템</h2>
                    <p>환영합니다, ${empVO.peoName} <small>(${empVO.empDepartNm} ${empVO.empPositionNm})</small>님! 왼쪽 메뉴를 통해 각 항목을 관리할 수 있습니다.</p>
                    <p class="current-time-text">현재 시간: <span id="currentTime"></span></p>
                </div>

                <div class="row g-4 dashboard-grid">
                    <div class="col">
                        <div class="card shadow-sm h-100">
                            <div class="card-body text-center dashboard-card summary-card d-flex flex-column justify-content-center align-items-center">
                                <div class="card-icon text-primary"><i class="fas fa-user-plus"></i></div>
                                <h3 class="h6 text-muted">신규 가입 회원</h3>
                                <p class="count"><fmt:formatNumber value="${registerCnt}" type="number"/> <span class="unit"> 명</span></p>
                                <p class="description mb-0">오늘 가입</p>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card shadow-sm h-100">
                            <div class="card-body text-center dashboard-card summary-card d-flex flex-column justify-content-center align-items-center">
                                <div class="card-icon text-info"><i class="fas fa-flag"></i></div>
                                <h3 class="h6 text-muted">미처리 신고</h3>
                                <p class="count"><fmt:formatNumber value="${reportCnt}" type="number"/> <span class="unit">건</span></p>
                                <a href="${pageContext.request.contextPath}/admin/community/report/list" class="card-link mt-2">신고 관리 바로가기 &rarr;</a>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card shadow-sm h-100">
                            <div class="card-body text-center dashboard-card summary-card d-flex flex-column justify-content-center align-items-center">
                                <div class="card-icon text-info"><i class="fas fa-headset"></i></div>
                                <h3 class="h6 text-muted">미처리 문의</h3>
                                <p class="count"><fmt:formatNumber value="${inquiryCnt}" type="number"/> <span class="unit">건</span></p>
                                <a href="${pageContext.request.contextPath}/admin/inquiry/main" class="card-link mt-2">문의 관리 바로가기 &rarr;</a>
                            </div>
                        </div>
                    </div>
                    <div class="col">
					    <div class="card shadow-sm h-100">
					        <div class="card-body text-center dashboard-card summary-card d-flex flex-column justify-content-center align-items-center">
					            <div class="card-icon text-success"><i class="fas fa-calendar-check"></i></div>
					            <h3 class="h6 text-muted">오늘 주문 (굿즈샵)</h3>
					            <p class="count">
					                <fmt:formatNumber value="${orderCnt != null ? orderCnt : 0}" type="number"/> <span class="unit">건</span>
					            </p>
					            <a href="${pageContext.request.contextPath}/admin/goods/orders/list" class="card-link mt-2">주문내역 관리 &rarr;</a>
					        </div>
					    </div>
					</div>
                    <div class="col">
                        <div class="card shadow-sm h-100">
                            <div class="card-body text-center dashboard-card system-status-card d-flex flex-column justify-content-center align-items-center">
                                <div class="card-icon text-secondary"><i class="fas fa-check-circle"></i></div>
                                <h3 class="h6 text-muted">시스템 상태</h3>
                                <p class="status-text <c:out value="${dashboardStats.systemStatusClass != null ? dashboardStats.systemStatusClass : 'normal'}"/> mb-0"><c:out value="${dashboardStats.systemStatusText != null ? dashboardStats.systemStatusText : '정상'}"/></p>
                                <p class="description mb-0">모든 서비스 운영 중</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-2 dashboard-statics-grid">
	                <section class="card shadow-sm mb-4">
	                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
	                        <h3 class="h5 mb-0"><i class="fas fa-users me-2"></i> 사용자 활동 통계</h3>
	                        <div class="stats-filter-group d-flex align-items-center">
	                            <label for="userStatsPeriod" class="form-label mb-0 me-2">기간</label>
	                            <select id="userStatsPeriod" class="form-select form-select-sm">
	                                <option value="daily">일간</option>
	                                <option value="weekly">주간</option>
	                                <option value="monthly">월간</option>
	                            </select>
	                        </div>
	                    </div>
	                    <div class="card-body chart-body">
	                        <div class="chart-container"><canvas id="signupTrendChart"></canvas></div>
	                    </div>
	                    <div class="stats-table-container" style="height: 100%">
	                            <h5 class="h6 mb-3"><strong class="searchWord me-1" style="margin-left:0.5rem; color:green;">오늘 </strong> 가장 많이 구매한 사용자 (Top 5)</h5>
	                            <div class="table-responsive">
	                                <table class="table table-striped table-hover table-bordered caption-top">
	                                    <thead>
	                                        <tr>
	                                            <th>순위</th>
	                                            <th>사용자명</th>
	                                            <th>구매 수량</th>
	                                            <th>총 구매 금액</th>
	                                        </tr>
	                                    </thead>
	                                    <tbody id="topBuyUserTable">
	                                    </tbody>
	                                </table>
	                            </div>
	                        </div>
	                </section>
	                <section class="card shadow-sm mb-4" >
	                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
	                        <h3 class="h5 mb-0"><i class="fas fa-wallet me-2"></i> 분야 별 수익 통계</h3>
	                        <div class="stats-filter-group">
	                            <select id="revenueSectorFilter" class="form-select form-select-sm">
	                                <option value="all">전체 수익</option>
	                                <option value="goodsshop">굿즈샵</option>
	                                <option value="membership">멤버십</option>
	                                <option value="concert">콘서트</option>
	                            </select>
	                        </div>
	                    </div>
	                    <div class="card-body chart-body">
	                        <canvas id="revenueBySectorChart"></canvas>
	                    </div>
	                </section>
                </div>

				<div class="row g-2 dashboard-static-grid">
					<section class="card shadow-sm mb-4">
	                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
	                        <h3 class="h5 mb-0"><i class="fas fa-shopping-cart me-2"></i> 굿즈샵 통계</h3>
	                        <div class="stats-filter-group">
	                            <select id="goodsShopPeriodFilter" class="form-select form-select-sm">
	                                <option value="monthly">월별</option>
	                                <option value="quarter">분기별</option>
	                                <option value="yearly">년별</option>
	                            </select>
	                        </div>
	                    </div>
	                    <div class="card-body">
	                        <div class="row row-cols-1 row-cols-md-3 g-3 mb-4">
	                            <div class="col">
	                                <div class="dashboard-card summary-card">
	                                    <div class="card-icon"><i class="fas fa-dollar-sign"></i></div>
	                                    <div class="card-content">
	                                        <h3>이 달 매출액</h3>
	                                        <p class="count"><fmt:formatNumber value="${goodsStat.PROFITPRICE}" pattern="###,###,###,###"/> <span class="unit">원</span></p>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="col">
	                                <div class="dashboard-card summary-card">
	                                    <div class="card-icon"><i class="fas fa-receipt"></i></div>
	                                    <div class="card-content">
	                                        <h3>이 달 주문 건수</h3>
	                                        <p class="count"><fmt:formatNumber value="${goodsStat.PROFITCOUNT}" pattern="###,###,###,###"/> <span class="unit">건</span></p>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="col">
	                                <div class="dashboard-card summary-card">
	                                    <div class="card-icon"><i class="fas fa-undo-alt"></i></div>
	                                    <div class="card-content">
	                                        <h3>이 달 취소 건수</h3>
	                                        <p class="count"><fmt:formatNumber value="${goodsStat.CANCELCOUNT}" pattern="###,###,###,###"/> <span class="unit">건</span></p>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>

	                        <h4 class="h6 mb-3">판매 통계</h4>
	                        <div class="chart-container"><canvas id="salesRevenueChart"></canvas></div>

	                        <div class="stats-table-container mb-5">
	                            <h5 class="h6 mb-3"><strong class="saleWord me-1" style="margin-left:0.5rem; color:green;">이번 달 </strong> 인기 판매 품목 (Top 5)</h5>
	                            <div class="table-responsive">
	                                <table class="table table-striped table-hover table-bordered caption-top">
	                                    <thead>
	                                        <tr>
	                                            <th>순위</th>
	                                            <th>상품명</th>
	                                            <th>판매수량</th>
	                                            <th>총 판매금액</th>
	                                        </tr>
	                                    </thead>
	                                    <tbody id="topSellingItemsTable">
	                                        <!-- <tr>
	                                            <td>1</td>
	                                            <td>샘플 상품 A</td>
	                                            <td>120</td>
	                                            <td>1,200,000 원</td>
	                                        </tr>
	                                        <tr>
	                                            <td colspan="4" class="text-center text-muted">데이터가 없습니다.</td>
	                                        </tr> -->
	                                    </tbody>
	                                </table>
	                            </div>
	                        </div>

	                        <div class="chart-container justify-content-end gap-2 mb-5">
	                        	<div style="width: 30%">
			                        <h4 class="h6 mb-3 mt-4">주문 취소 통계</h4>
		                        	<div>
			                            <canvas id="returnsCancellationsChart"></canvas>
		                        	</div>
	                        	</div>
	                        	<div class="stats-table-container" style="width: 70%">
		                            <h5 class="h6 mb-3">최근 취소 내역 (최근 5건)</h5>
		                            <div class="table-responsive">
		                                <table class="table table-striped table-hover table-bordered caption-top">
		                                    <thead>
		                                        <tr>
		                                            <th width="10%">주문번호</th>
		                                            <th width="24%">상품명</th>
		                                            <th width="15%">사유</th>
		                                            <th width="22%">상세</th>
		                                            <th width="14%">처리상태</th>
		                                        </tr>
		                                    </thead>
		                                    <tbody id="recentReturnsTable">
		                                    	<c:choose>
		                                    		<c:when test="${empty cancelList}">
				                                        <tr>
				                                            <td colspan="5" class="text-center text-muted">데이터가 없습니다.</td>
				                                        </tr>
		                                    		</c:when>
		                                    		<c:otherwise>
		                                    			<c:forEach items="${cancelList}" var="cancel">
					                                        <tr>
					                                            <td>${cancel.orderNm}</td>
					                                            <td>${cancel.goodsNm}</td>
					                                            <td style="text-align: center;">${cancel.cancelReasonName}</td>
					                                            <td>${cancel.cancelReasonDetail}</td>
					                                            <td style="text-align: center;">
					                                            	<c:if test="${cancel.cancelStatCode eq 'CSC001'}">
					                                            		<span style="color : #6c757d;">${cancel.cancelStatName}</span>
					                                            	</c:if>
					                                            	<c:if test="${cancel.cancelStatCode eq 'CSC002' }">
					                                            		<span style="color : #ffc107;">${cancel.cancelStatName}</span>
					                                            	</c:if>
					                                            	<c:if test="${cancel.cancelStatCode eq 'CSC003' }">
					                                            		<span style="color : #dc3545;">${cancel.cancelStatName}</span>
					                                            	</c:if>
					                                            </td>
					                                        </tr>
		                                    			</c:forEach>
		                                    		</c:otherwise>
		                                    	</c:choose>
		                                    </tbody>
		                                </table>
		                            </div>
		                        </div>
	                        </div>
	                    </div>
	                </section>
				</div>

                <div class="row g-2 dashboard-notice-grid">
                    <div class="col">
                        <div class="card shadow-sm h-100">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h3 class="h5 mb-0"><i class="fas fa-rss me-2"></i> 최근 기업 공지사항</h3>
                                <a href="${pageContext.request.contextPath}/admin/notice/list" class="btn btn-link btn-sm p-0">더보기 &gt;</a>
                            </div>
                            <div class="card-body" style="font-size: large;">
                                <ul class="notice-list">
                                    <c:if test="${empty noticeList}">
                                        <li><p class="text-muted mb-0">등록된 기업 공지사항이 없습니다.</p></li>
                                    </c:if>
                                    <c:forEach var="notice" items="${noticeList}" varStatus="status" begin="0" end="2">
                                        <li>
                                            <a href="${pageContext.request.contextPath}/admin/notice/detail?id=${notice.entNotiNo}"><c:out value="${notice.entNotiTitle}"/></a>
                                            <span class="date"><fmt:formatDate value="${notice.entNotiRegDate}" pattern="yyyy-MM-dd"/></span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="card shadow-sm h-100">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h3 class="h5 mb-0"><i class="fas fa-store-alt me-2"></i> 최근 굿즈샵 공지</h3>
                                <a href="${pageContext.request.contextPath}/admin/goods/notice/list" class="btn btn-link btn-sm p-0">더보기 &gt;</a>
                            </div>
                            <div class="card-body" style="font-size: large;">
                                <ul class="notice-list">
                                     <c:if test="${empty recentGoodsNotices}">
                                        <li><p class="text-muted mb-0">등록된 굿즈샵 공지사항이 없습니다.</p></li>
                                    </c:if>
                                    <%-- ⭐ 'end' 속성을 '2'로 변경하여 3개의 공지사항을 표시합니다. ⭐ --%>
                                    <c:forEach var="notice" items="${recentGoodsNotices}" varStatus="status" begin="0" end="2">
                                        <li>
                                            <a href="${pageContext.request.contextPath}/admin/goods/notice/detail?id=${notice.goodsNotiNo}"><c:out value="${notice.goodsNotiTitle}"/></a>
                                            <span class="date"><fmt:formatDate value="${notice.goodsRegDate}" pattern="yyyy-MM-dd"/></span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
<%@ include file="../modules/footerPart.jsp" %>

<%@ include file="../modules/sidebar.jsp" %>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // 현재 시간 표시 함수
    function updateCurrentTime() {
        const now = new Date();
        const options = {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: false // 24시간 형식
        };
        document.getElementById('currentTime').textContent = now.toLocaleDateString('ko-KR', options);
    }

    // 페이지 로드 시 바로 호출
    updateCurrentTime();
    // 1초마다 시간 업데이트
    setInterval(updateCurrentTime, 1000);


    // 차트관련 객체생성
    const chartMap = {};

    // 페이지 로드시 사용자 활동 통계 호출
    getUserStatData();

    $("#userStatsPeriod").on("change",function(){
    	getUserStatData(this.value)
    })

    //사용자 활동 통계
    function getUserStatData(searchType="daily"){
    	$.ajax({
    		url : "/api/admin/stat/getUserStatData",
    		type : "get",
    		data : "searchType="+searchType,
    		success : function(res){
    			let {signup, mostBuy} = res;
    			let singupList = JSON.parse(signup);
    			let labelData = singupList.map(v=>v.TDATE);
    			let cntData = singupList.map(v=>v.COUNT);
    			createChart('signupTrendChart', 'line',
    					{
    			    		labels: labelData
    			   			, datasets: [
    			   				{
    			   					label: '신규 가입자'
    			   					, data: cntData
    			   					, borderColor : "rgba(46,204,113,1)"
    			   					, backgroundColor: 'rgba(46,204,113,0.2)'
    			   					, fill : true
    			   					, tension : 0.2
    			   				}
    			   			]
    			    	},
    					{
    			    		responsive: true
    			    		, maintainAspectRatio: false
    			    		, plugins: {
    			    			title: {
		           					display: true,	// 차트 내부 제목 표시 여부
		           					text: '신규 가입자 추이'
		           				},
    			    			legend: {
    			    				display: false
   			    				}
    			    		  }
    			   		}
    			    );

    			let mostBuyData = JSON.parse(mostBuy);
    			let dataTable = $("#topBuyUserTable");
    			$(".searchWord").eq(0).text(searchType == 'daily' ? "오늘" : searchType == 'weekly' ? "이번 주" : "이번 달")
    			if(mostBuyData.length == 0){
    				let html = `
    					<tr>
	                        <td colspan='4' class="text-center text-muted" >아직 구매한 사용자가 없습니다.</td>
	                    </tr>
    				`;
    				dataTable.html(html);
    			}else{
    				let html = ``;
   					html += mostBuyDataDisplay(mostBuyData);
    				dataTable.html(html)
    			}

    		},
    		error : function(err){
    			console.error(err);
    		}
    	})
    }

	// 페이지 로드 시 분야별 수익 통계 호출
    getRevenueBySector();

    $("#revenueSectorFilter").on("change",function(){
   		getRevenueBySector(this.value)
    })
    // 분야별 수익 통계
    function getRevenueBySector(searchType='all'){
		$.ajax({
			url : "/api/admin/stat/getRevenueBySector",
			type : "get",
			data : "searchType="+searchType,
			success : function(res){
				let {revenue} = res;
				const revenueData = JSON.parse(revenue);
				const labelData = revenueData.map(v=>v.NAME);
				const priceData = revenueData.map(v=>v.TOTALPRICE);
				// 분야별 수익 통계
			    createChart('revenueBySectorChart', 'bar',
			        {
			    		labels: labelData,
			    		datasets: [
			    			{
			    				label: '수익',
			    				data: priceData,
			    				backgroundColor: ['#1abc9c', '#f39c12',"#2ebacc","#2385cc"]
			    			}
			    		]
			    	},
			        {
			    		indexAxis : 'y',
			    		elements : {
			    			bar : {
			    				borderWidth : 2,
			    			}
			    		},
			    		responsive: true,
			    		maintainAspectRatio: false,
			    		plugins: {
			    			title: {
	           					display: true,	// 차트 내부 제목 표시 여부
	           					text: '분야별 수익 통계'
	           				},
			    			legend: {
			    				display: false,
			    				position : 'right',
			    			}
	           				,datalabels :{
	           					color: 'black',
	           					formatter: function(value, context) {
	           						const numberFormatter = new Intl.NumberFormat('ko-KR');
	           						let formattedPrice = numberFormatter.format(value)
	           					  return formattedPrice + "원";
	           					},
	           					font: {
	           			            weight: 'bold'
	           			        },
	           					anchor: "end",
	           					align : "center"
	           				}
			    		}
			    	}
			    ,true);
			},
			error : function(err){
				console.error(err);
			}

		})
    }

    // 굿즈샵섹션 통계
    getSaleRevenue()

    $("#goodsShopPeriodFilter").on("change",function(){
    	getSaleRevenue(this.value)
    })
    function getSaleRevenue(searchType='monthly'){
    	$.ajax({
    		url : '/api/admin/stat/getSaleRevenue',
    		type : "get",
    		data : "searchType=" + searchType,
    		success : function(res){
    			const {revenueJson, saleJson} = res;
    			let revenue = JSON.parse(revenueJson);
				let labelData = revenue.map(v=>v.TDATE);
				let revenueData = revenue.map(v=>v.TOTALPRICE);

    			createChart('salesRevenueChart', 'line',
    		            {
    		                labels: labelData,
    		                datasets: [{
    		                    label: '매출액',
    		                    data: revenueData,
    		                    borderColor: '#3498db',
    		                    tension: 0.1,
    		                    fill: false // 선 그래프 영역 채우지 않음
    		                }]
    		            },
    		            {
	   		                responsive: true,
	   		                maintainAspectRatio: false,
	   		                plugins: {
	   		                    legend: {
	   		                        display: false,
	   		                        position: 'top'
	   		                    }
	   		                },
	   		                scales: {
	   		                    y: {
	   		                        beginAtZero: true,
	   		                        title: {
	   		                            display: true,
	   		                            text: '매출액 (원)'
	   		                        }
	   		                    }
	   		                }
    		            }
   		        );
				// 인기 판매 품목 top 5
				const saleGoods = JSON.parse(saleJson);
				let saleHtml = ``;
				if(saleGoods.length > 0){
					saleHtml += mostSaleGoodsDisplay(saleGoods, searchType)
				}else{
					saleHtml += `
						<tr>
							<td colspan="4" class="text-center text-muted">판매 품목이 없습니다.</td>
						</tr>
					`;

				}
				$("#topSellingItemsTable").html(saleHtml);

    		},
    		error : function(err){
    			console.error(err);
    		}

    	})
    }

    // 주문 취소 통계
    const cancelStatJson = '${cancelStatJson}'
    const cancelStat = JSON.parse(cancelStatJson);
    let labelData = cancelStat.map(v => v.NAME);
    let cancelData = cancelStat.map(v => v.COUNT);

	createChart('returnsCancellationsChart', 'pie',
			{
                labels: labelData,
                datasets: [{
                    data: cancelData,
                    backgroundColor: [
						'rgba(255, 99, 132, 0.6)', // 빨강
                       'rgba(54, 162, 235, 0.6)', // 파랑
                       'rgba(255, 206, 86, 0.6)'  // 노랑
					],
					borderColor: [					// 선색상
						'rgba(255, 99, 132, 1)',
                       'rgba(54, 162, 235, 1)',
                       'rgba(255, 206, 86, 1)'
					],
                    hoverOffset: 4
                }]
            },
            {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right'
                    },
                    title: {
       					display: false,	// 차트 내부 제목 표시 여부
       					text: '주문 취소 사유 별 통계'
       				},
       				datalabels: {
						    color: function(context) {
						    	const index = context.dataIndex;
						    	if(index === 0 || index === 1) {
						    		return '#fff';
						    	} else {
						    		return '#333';
						    	}
						    },
						    font: {
						        weight: 'bold',
						        size: 16
						    },
						   	borderColor: function(context) {
	                            const index = context.dataIndex;
	                            // 차트 조각의 테두리색과 동일하게 사용
	                            const labelBorders = [
	                                'rgba(255, 99, 132, 1)',
	                                'rgba(54, 162, 235, 1)',
	                                'rgba(255, 206, 86, 1)'
	                            ];
	                            return labelBorders[index];
	                        },
	                        formatter: function(value, context) {
           						const numberFormatter = new Intl.NumberFormat('ko-KR');
           						let formattedPrice = numberFormatter.format(value)
           					  return formattedPrice + "건";
           					}
       				}
                }
            }
       ,true);





 	// 다른 차트들 초기화
    function createChart(id, type, data, options, plugin = false) {
        const ctx = document.getElementById(id);
        if(chartMap[id] != null){
        	chartMap[id].destroy();
        }

        if (ctx) {
        	let myChart = null;
        	if(plugin){
        		myChart= new Chart(ctx.getContext('2d'), {
	                type: type,
	                data: data,
	                plugins : [ChartDataLabels],
	                options: options
	            });
        	}else{
	            myChart = new Chart(ctx.getContext('2d'), {
	                type: type,
	                data: data,
	                options: options
	            });
        	}
            chartMap[id] = myChart;
        }
    }

 	function mostBuyDataDisplay(mostBuyData){
 		let html = ``;
		for(let data of mostBuyData ){
			let {MEM_USERNAME, RANK, TOTALPRICE, TOTALQTY} = data
			const numberFormatter = new Intl.NumberFormat('ko-KR');
			let formattedPrice = numberFormatter.format(TOTALPRICE)
			html += `
				<tr>
                       <td style='text-align : center;'>\${RANK}</td>
                       <td style='text-align : left;'>\${MEM_USERNAME}</td>
                       <td style='text-align : right;'>\${TOTALQTY}개</td>
                       <td style='text-align : right;'>\${formattedPrice}원</td>
                   </tr>
			`;
		}
		let emptysize = 5 - mostBuyData.length;
		if(emptysize > 0){
			html += `
				<tr>
					<td colspan="4" rowspan="\${emptysize}" class="text-center text-muted">추가로 구매한 사용자가 없습니다.</td>
				</tr>
			`;
		}
		return html;
 	}

 	function mostSaleGoodsDisplay(goodsData, searchType){
 		let html = ``;
		for(let data of goodsData ){
			let {NAME, RANK, SALEPRICE, COUNT, DT} = data
	 		$(".saleWord").eq(0).text(DT)
			const numberFormatter = new Intl.NumberFormat('ko-KR');
			let formattedPrice = numberFormatter.format(SALEPRICE)
			html += `
				<tr>
                       <td style='text-align : center;'>\${RANK}</td>
                       <td style='text-align : left;'>\${NAME}</td>
                       <td style='text-align : right;'>\${COUNT}개</td>
                       <td style='text-align : right;'>\${formattedPrice}원</td>
                   </tr>
			`;
		}
		let emptysize = 5 - goodsData.length;
		if(emptysize > 0){
			html += `
				<tr>
					<td colspan="4" rowspan="\${emptysize}" class="text-center text-muted">판매 품목이 없습니다.</td>
				</tr>
			`;
		}
		return html;
 	}

});
</script>
</body>
</html>
