<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.fmt"  prefix="fmt"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>콘서트 일정 상세 정보</title>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<%@ include file="../../../modules/headerPart.jsp" %>
<style>
    /* ---------------------------------- */
    /* 상세 페이지 레이아웃         */
    /* ---------------------------------- */
    h4{
    	font-size: 1.3em; margin-bottom: 18px; color: #234aad; padding-bottom: 10px; border-bottom: 2px solid #234aad; font-weight: 700;
    }
    .detail-view-container {
        background: #fff;
        padding: 30px 35px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        width: 100%;
        margin-bottom: 30px;
        font-size: small;
    }
    .detail-header {
        padding-bottom: 20px;
        border-bottom: 1px solid #dee2e6;
        margin-bottom: 25px;
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
    }
    .detail-title {
        font-size: 2em;
        font-weight: 700;
        margin-bottom: 10px;
        color: #234aad;
        flex-grow: 1;
    }
    .detail-meta {
        font-size: 0.95em;
        color: #555;
        align-items: center;
        gap: 15px;
        flex-wrap: wrap;
        margin-top: 10px;
    }
    .meta-content{
    	display: flex;
    	align-items: center;
    	gap: 12px;
    }
    .detail-meta .btn{
    	margin-left: auto;
    }
    .detail-meta a {
    	text-align: right;
    }
    .detail-meta .divider {
        color: #ccc;
    }
    .detail-content {
        min-height: 100px;
        line-height: 1.7;
        font-size: 1em;
        margin-bottom: 30px;
        padding: 15px;
        white-space: pre-wrap;
        word-break: keep-all;
        background-color: #f8f9fa;
        border-radius: 5px;
        border-inline: 2px solid #234aad;
    	border-block: 2px solid #234aad;
    	overflow: auto;
    }
    .detail-info-table { margin-bottom: 30px;  }
    .detail-info-table h4 { font-size: 1.2em; margin-top: 15px; margin-bottom: 15px; color: #234aad; padding-bottom: 10px; }
    .detail-info-table table {
    	width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .detail-info-table th, .detail-info-table td { border-bottom: 1px solid #e9ecef; padding: 15px; font-size: 0.95em; }
    .detail-info-table th { background-color: #f0f5ff; width: 25%; text-align: left; font-weight: 600; color: #234aad; border-right: 1px solid #e0e5f0; }
	.detail-info-table td {
        background-color: #fafbfc; /* ⭐셀 배경색 통일⭐ */
        color: #495057; /* ⭐셀 텍스트 색상⭐ */
    }
    .detail-info-table tr:last-child th,
    .detail-info-table tr:last-child td {
        border-bottom: none; /* ⭐마지막 행 하단 테두리 제거⭐ */
    }
    .detail-attachments { margin-bottom: 30px; }
    .detail-attachments h4 { font-size: 1.2em; margin-bottom: 15px; color: #234aad; padding-bottom: 10px; border-bottom: 2px solid #234aad;}
    .detail-attachments ul { list-style: none; padding: 0; margin: 0; }
    .detail-attachments li {
    	display: flex; align-items: center; padding: 12px; border-radius: 6px;
        transition: background-color 0.2s; border: 1px solid #e0e5f0;
        background-color: #fdfdff;
    }
    .detail-attachments li:not(:last-child) { margin-bottom: 10px; }
    .detail-attachments li:hover { background-color: #eef7ff; }
    .detail-attachments .file-preview {
    	width: 100px; height: 100px; object-fit: cover;
        border-radius: 6px; margin-right: 15px; border: 1px solid #ced4da;
        box-shadow: 0 1px 4px rgba(0,0,0,0.1);
    }
    .detail-attachments a { text-decoration: none; color: #234aad; }
    .detail-attachments a:hover { text-decoration: underline; }

    /* ---------------------------------- */
    /* 상태 표시 배지             */
    /* ---------------------------------- */
    .status-badge {
        display: inline-block;
        padding: 4px 10px;
        font-size: 1em;
        font-weight: 400;
        border-radius: 20px;
        color: #fff;
    }
    .status-scheduled { background-color: #4D96FF; } /* 예정: 파란색 */
    .status-preSale { background-color: #FFC107; color: #212529; } /* 선예매: 보라색 */
    .status-ongoing { background-color: #28A745; } /* 진행: 초록색 */
    .status-soldout { background-color: #6C757D; } /* 매진: 회색 */
    .status-finished { background-color: #DC3545; } /* 종료: 빨간색 */
    .status-unknown { background-color: #ffc107; color: #212529; } /* 알수없음: 노란색 */

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
    /* 목록 페이지의 '새 일정 등록' 버튼 */
    .btn-primary { background-color: #007bff; color: white; }
    .btn-primary:hover { background-color: #0069d9; }
    
    .btn-list-bottom-right {
        bottom: 5px;      /* 아래쪽에서 30px 떨어지게 */
        right: 35px;       /* 오른쪽에서 35px 떨어지게 (컨테이너 패딩과 동일하게) */
        z-index: 10;       /* 다른 요소 위에 표시되도록 */
    }
    
    /* 상세 페이지 버튼들 */
    .detail-actions {
    	text-align: right; /* 텍스트 정렬은 IE 구형 브라우저 호환성을 위해 유지 */
        display: flex; /* flexbox 사용 */
        justify-content: flex-end; /* 오른쪽 끝으로 정렬 */
        gap: 8px; /* 버튼 간 간격 (필요시 조정) */
    }
    .detail-actions .btn { margin-left: 0; }
    .btn-secondary { background-color: #6c757d; color: white; }
    .btn-secondary:hover { background-color: #5a6268; }
    .btn-warning { background-color: #ffc107; color: #212529; }
    .btn-warning:hover { background-color: #e0a800; }
    .btn-danger { background-color: #dc3545; color: white; }
    .btn-danger:hover { background-color: #c82333; }
    
    /* 좌석 chart.js css */
    .chart-card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        padding: 28px 32px 24px 32px;
        margin-bottom: 32px;
        flex: 1 1 0;
        display: flex;
        flex-direction: column;
        align-items: stretch;
        min-width: 340px;
    }
    .chart-title {
        font-size: 1.15em;
        font-weight: 600;
        color: #34495e;
        margin-bottom: 18px;
        letter-spacing: -1px;
        text-align: left;
    }
    .chart-container {
        width: 100%;
        height: 320px;
        margin: 0 auto;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .seat-status-chart {
        display: flex;
        gap: 32px;
        justify-content: center;
        margin-bottom: 30px;
        margin-top: 30px;
        flex-wrap: wrap;
    }
    .chart-card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        padding: 28px 32px 24px 32px;
        margin-bottom: 0;
        flex: 1 1 0;
        display: flex;
        flex-direction: column;
        align-items: stretch;
        min-width: 380px;
        max-width: 50%;
    }
    .chart-title {
        font-size: 1.5em;
        font-weight: 700;
        color: #234aad;
        margin-bottom: 18px;
        letter-spacing: normal;
        text-align: center;
        padding-bottom: 10px;
        border-bottom: 1px solid #eee;
    }
    .chart-container {
        width: 100%;
        height: 320px;
        margin: 0 auto;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
    }
    .seat-status-chart canvas {
        max-width: 100%;
        max-height: 100%;
        margin: 0 auto;
        display: block;
    }
    
    /* 차트 로딩 및 오류 메시지 스타일 */
    .chart-container > div {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        text-align: center;
        line-height: 1.5;
    }
    
    /* 반응형 차트 */
    @media (max-width: 768px) {
        .seat-status-chart {
            flex-direction: column;
            gap: 20px;
        }
        .chart-card {
            min-width: 100%;
            max-width: 100%;
        }
        .chart-container {
            height: 280px;
        }
    }
</style>
</head>
<body>
	<div class="emp-container">
	<%@ include file="../../modules/header.jsp" %>
		<div class="emp-body-wrapper">
			<%@ include file="../../modules/aside.jsp" %>
			<main class="emp-content" style="position:relative; min-height:600px; font-size: small;">
                <c:if test="${not empty errorMessage}">
                    <div class="message error">${errorMessage}</div>
                </c:if>
						<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
						<ol class="breadcrumb">
						  <li class="breadcrumb-item" style="color: black;">콘서트 관리</li>
						  <li class="breadcrumb-item"><a href="/emp/concert/schedule/list" style="color: black;">콘서트 일정 관리</a></li>
						  <li class="breadcrumb-item active" aria-current="page">콘서트 일정 상세 정보</li>
						</ol>
						</nav><br/>
						<h2>콘서트 상세 정보</h2>
                <c:if test="${not empty concertVO}">
                    <div class="detail-view-container">
                            <h2 class="detail-title"><c:out value="${concertVO.concertNm}"/></h2>
                            <div class="detail-meta">
                            	<div class="meta-content">
                                <span><strong>예매 상태:</strong> 
                                    <c:choose>
                                        <c:when test="${concertVO.concertReservationStatCode == 'CRSC005'}">
                                			<span class="status-badge status-scheduled">예정</span>
                                		</c:when>
                                		<c:when test="${concertVO.concertReservationStatCode == 'CRSC001'}">
                                			<span class="status-badge status-preSale">선예매기간</span>
                                		</c:when>
                                		<c:when test="${concertVO.concertReservationStatCode == 'CRSC002'}">
                                			<span class="status-badge status-ongoing">예매중</span>
                                		</c:when>
                                		<c:when test="${concertVO.concertReservationStatCode == 'CRSC003'}">
                                			<span class="status-badge status-soldout">매진</span>
                                		</c:when>
                                		<c:otherwise>
                                			<span class="status-badge status-finished">종료</span>
                                		</c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="divider">|</span>
                            	<span><strong>콘서트 번호:</strong> <c:out value="${concertVO.concertNo }"  /></span>
                                <span class="divider">|</span>
                                <span><strong>아티스트:</strong> <c:out value="${concertVO.artGroupName}"/></span>
                                <span class="divider">|</span>
                                <span><strong>공연일:</strong> <fmt:formatDate value="${concertVO.concertDate}" pattern="yyyy-MM-dd HH:mm"/></span>
                                <sec:authorize access="isAuthenticated() and hasRole('ROLE_EMPLOYEE')">
                                <c:url var="modUrlWithParams" value="/emp/concert/schedule/mod/${concertVO.concertNo}">
                                    <c:param name="searchType" value="${searchType}" />
                                    <c:param name="searchWord" value="${searchWord}" />
                                    <c:param name="currentPage" value="${currentPage}" />
                                </c:url>
                                <a href="${modUrlWithParams}" class="btn btn-primary"><i class="fa-solid fa-pen-to-square"></i> 수정</a>
                            	</sec:authorize>
                                <form action="<c:url value='/emp/concert/schedule/delete/${concertVO.concertNo}'/>" method="post" style="display:inline;">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('정말로 이 [${concertVO.concertNm}] 일정을 삭제하시겠습니까?');">
                                    	<i class="fa-solid fa-trash-can"></i> 삭제</button>
                                </form>
                            </div>
                        </div>
                        
                        <!-- 차트 섹션 - 항상 표시하도록 수정 -->
                        <div class="seat-status-chart">
                        	<div class="chart-card">
                        		<div class="chart-title">날짜별 좌석 예매 현황</div>
                        		<div class="chart-container">
                        			<canvas id="seatChart"></canvas>
                        		</div>
                        	</div>
                        	<div class="chart-card">
                        		<div class="chart-title">잔여좌석/총좌석</div>
                        		<div class="chart-container">
                        			<canvas id="donutChart"></canvas>
                        		</div>
                        	</div>
                        	<div class="chart-card">
                        		<div class="chart-title">날짜별 티켓 판매금액</div>
                        		<div class="chart-container">
                        			<canvas id="salesChart"></canvas>
                        		</div>
                        		<div id="totalSalesBox" style="text-align:center; margin-top:10px; font-weight:bold; color:#234aad;"></div>
                        	</div>
                        </div>
                        
                        <!-- 디버깅 정보 -->
                        <%-- <div style="background: #f8f9fa; padding: 15px; margin: 20px 0; border-radius: 5px; font-size: 12px; color: #666;">
                        	<strong>디버깅 정보:</strong><br>
                        	콘서트 번호: ${concertVO.concertNo}<br>
                        	예매 시작일: <fmt:formatDate value="${concertVO.concertStartDate}" pattern="yyyy-MM-dd"/><br>
                        	예매 종료일: <fmt:formatDate value="${concertVO.concertEndDate}" pattern="yyyy-MM-dd"/><br>
                        	좌석 상태: ${seatStatus}
                        </div> --%>
                        
                        <div class="detail-info-table">
                            <h4>세부 정보</h4>
                            <table>
                                <tbody>
                                    <tr>
                                        <th>공연장</th>
                                        <td><c:out value="${concertVO.concertHallName}"/></td>
                                    </tr>
                                    <tr>
                                        <th>공연 주소</th>
                                        <td><c:out value="${concertVO.concertAddress}"/></td>
                                    </tr>
                                    <tr>
                                        <th>온/오프라인</th>
                                        <td>${concertVO.concertOnlineYn == 'Y' ? '온라인' : '오프라인'}</td>
                                    </tr>
                                    <tr>
                                        <th>진행 시간</th>
                                        <td>${concertVO.concertRunningTime} 분</td>
                                    </tr>
                                    <tr>
                                        <th>예매/이벤트 기간</th>
                                        <td>
                                            <fmt:formatDate value="${concertVO.concertStartDate}" pattern="yyyy년 MM월 dd일 HH:mm"/> ~ 
                                            <fmt:formatDate value="${concertVO.concertEndDate}" pattern="yyyy년 MM월 dd일 HH:mm"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>콘서트 카테고리 코드</th>
                                        <td>${concertVO.concertCatCode == 'CCC001' ? '온라인' : '오프라인' }</td>
                                    </tr>
                                    <tr>
                                        <th>콘서트 진행 상태 코드</th>
                                        <td>
                                        	<c:choose>
                                        		<c:when test="${concertVO.concertStatCode == 'CTSC001'}">
                                        			<span class="status-badge status-scheduled">예정</span>
                                        		</c:when>
                                        		<c:when test="${concertVO.concertStatCode == 'CTSC002'}">
                                        			<span class="status-badge status-ongoing">진행</span>
                                        		</c:when>
                                        		<c:otherwise>
                                        			<span class="status-badge status-finished">종료</span>
                                        		</c:otherwise>
                                        	</c:choose>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <h4>공연 안내사항</h4>
                        <div class="detail-content" style="white-space:pre;">
                            <c:out value="${concertVO.concertGuide}"/>
                        </div>

                        <c:if test="${not empty concertVO.attachmentFileList}">
                            <div class="detail-attachments">
                                <h4>첨부파일</h4>
                                <ul>
                                    <c:forEach var="file" items="${concertVO.attachmentFileList}">
                                        <li>
                                            <a href="<c:url value='${file.webPath}'/>" target="_blank" title="클릭하여 원본 이미지 보기">
                                                <img src="<c:url value='${file.webPath}'/>" alt="<c:out value='${file.fileOriginalNm}'/>" 
                                                     class="file-preview"
                                                     onerror="this.style.display='none'; this.nextElementSibling.style.marginLeft='0';"/>
                                            </a>
                                            <a href="<c:url value='${file.webPath}'/>" download="${file.fileOriginalNm}">
                                                <c:out value="${file.fileOriginalNm}"/> (<c:out value="${file.fileFancysize}"/>)
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>
                        <div class="detail-actions">
                        	<c:url var="listBackUrl" value="/emp/concert/schedule/list">
	                           <c:param name="searchType" value="${searchType}" />
	                           <c:param name="searchWord" value="${searchWord}" />
	                           <c:param name="currentPage" value="${currentPage}" />
                       		</c:url>
                          	<a href="${listBackUrl}" class="btn btn-secondary btn-list-bottom-right"><i class="fa-solid fa-list"></i> 목록</a>
                       	</div>
                    </div>
                </c:if>
                
                <c:if test="${empty concertVO and empty errorMessage}">
                    <p style="text-align:center; padding: 50px; font-size: 1.1em; color: #555;">해당 콘서트 정보를 찾을 수 없습니다.</p>
                </c:if>
			</main>
		</div>
	</div>
    <%@ include file="../../../modules/footerPart.jsp" %>
	<%@ include file="../../../modules/sidebar.jsp" %>
<script type="text/javascript">
function createCharts() {
    const seatCtx = document.getElementById('seatChart')?.getContext('2d');
    const donutCtx = document.getElementById('donutChart')?.getContext('2d');
    const salesCtx = document.getElementById('salesChart')?.getContext('2d');
    const concertNo = '${concertVO.concertNo}';
    if (!concertNo) return;

    fetch(`/emp/concert/schedule/dailySeatStatus/${concertNo}`)
      .then(res => res.json())
      .then(data => {
        if (!data || data.length === 0) {
            if (seatCtx) seatCtx.canvas.parentNode.innerHTML = '<div style="color:#888;text-align:center;width:100%;padding:60px 0;font-size:14px;">예매 데이터가 없습니다.<br>아직 예매가 시작되지 않았거나 예매 기록이 없습니다.</div>';
            if (donutCtx) donutCtx.canvas.parentNode.innerHTML = '<div style=\"color:#888;text-align:center;width:100%;padding:60px 0;font-size:14px;\">좌석 데이터가 없습니다.</div>';
            if (salesCtx) salesCtx.canvas.parentNode.innerHTML = '<div style=\"color:#888;text-align:center;width:100%;padding:60px 0;font-size:14px;\">판매금액 데이터가 없습니다.<br>아직 예매가 시작되지 않았거나 판매 기록이 없습니다.</div>';
            document.getElementById('totalSalesBox').innerText = '';
            return;
        }
        // Bar 차트: 날짜별 당일 예매 좌석수 (데이터가 있는 날짜만)
        const barData = data.filter(row => row.todayReserved > 0);
        const barLabels = barData.map(row => row.day);
        const todayReserved = barData.map(row => row.todayReserved);
        if (seatCtx) {
            new Chart(seatCtx, {
                type: 'bar',
                data: {
                    labels: barLabels,
                    datasets: [{
                        label: '당일 예매 좌석수',
                        data: todayReserved,
                        backgroundColor: '#ff61c0'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: true, labels: { color: '#234aad', font: { weight: 'bold' } } },
                        tooltip: {
                            callbacks: {
                                label: ctx => ctx.dataset.label + ': ' + ctx.parsed.y + '석'
                            }
                        }
                    },
                    elements: { bar: { borderRadius: 8, borderSkipped: false } },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: {
                                color: '#234aad',
                                align: 'center',
                                anchor: 'center',
                                padding: 8,
                                maxRotation: 45,
                                minRotation: 30,
                                size : 16
                            },
                            title: { display: true, text: '날짜', color: '#234aad' }
                        },
                        y: { grid: { color: '#eee' }, ticks: { color: '#888' }, title: { display: true, text: '좌석 수', color: '#234aad' }, beginAtZero: true }
                    }
                }
            });
        }
        // 도넛: 마지막날 기준 예매/잔여좌석
        if (donutCtx) {
            const last = data[data.length-1];
            new Chart(donutCtx, {
                type: 'doughnut',
                data: {
                    labels: ['예매된 좌석', '잔여 좌석'],
                    datasets: [{
                        data: [last.reservedSeats, last.remainSeats],
                        backgroundColor: ['#4D96FF', '#85e3e7']
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: true, position: 'bottom' },
                        tooltip: {
                            callbacks: {
                                label: ctx => ctx.label + ': ' + ctx.parsed + '석'
                            }
                        }
                    }
                }
            });
        }
        // 판매금액 차트: 날짜별 todaySales (데이터가 있는 날짜만)
        const lineData = data.filter(row => row.todaySales > 0);
        const lineLabels = lineData.map(row => row.day);
        const salesDataArr = lineData.map(row => row.todaySales || 0);
        if (salesCtx) {
            new Chart(salesCtx, {
                type: 'line',
                data: {
                    labels: lineLabels,
                    datasets: [{
                        label: '일별 판매금액',
                        data: salesDataArr,
                        borderColor: 'rgba(255, 99, 132, 1)',
                        backgroundColor: 'rgba(255, 99, 132, 0.1)',
                        fill: true,
                        tension: 0.3,
                        pointRadius: 4,
                        pointBackgroundColor: 'rgba(255, 99, 132, 1)'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: true, labels: { color: '#234aad', font: { weight: 'bold' } } },
                        tooltip: {
                            callbacks: {
                                label: ctx => {
                                    const v = ctx.parsed.y;
                                    if (v >= 1000000) return ctx.dataset.label + ': ' + (v/10000).toLocaleString() + '만';
                                    if (v >= 10000) return ctx.dataset.label + ': ' + (v/10000).toLocaleString() + '만';
                                    if (v >= 1000) return ctx.dataset.label + ': ' + (v/1000).toLocaleString() + '천';
                                    return ctx.dataset.label + ': ' + v.toLocaleString() + '원';
                                }
                            }
                        }
                    },
                    elements: { point: { hoverRadius: 6 } },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: {
                                color: '#234aad',
                                align: 'center',
                                anchor: 'center',
                                padding: 8,
                                maxRotation: 45,
                                minRotation: 30
                            },
                            title: { display: true, text: '날짜', color: '#234aad' }
                        },
                        y: {
                            grid: { color: '#eee' },
                            ticks: {
                                color: '#888',
                                callback: function(value) {
                                    if (value >= 1000000) return (value/10000).toLocaleString() + '만';
                                    if (value >= 10000) return (value/10000).toLocaleString() + '만';
                                    if (value >= 1000) return (value/1000).toLocaleString() + '천';
                                    return value.toLocaleString() + '원';
                                }
                            },
                            title: { display: true, text: '판매금액', color: '#234aad' },
                            beginAtZero: true
                        }
                    }
                }
            });
            // 총 판매금액 표시
            const totalSales = salesDataArr.reduce((a, b) => a + b, 0);
            const totalSalesText = totalSales >= 10000
                ? (totalSales / 10000).toLocaleString() + '만원'
                : totalSales.toLocaleString() + '원';
            document.getElementById('totalSalesBox').innerText = '총 판매금액: ' + totalSalesText;
        }
      });
}
document.addEventListener('DOMContentLoaded', function() {
    createCharts();
});
</script>
</body>
</html>