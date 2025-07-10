<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN - 직원 시스템</title>
    <%@ include file ="../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
    <link rel="stylesheet" href="https://uicdn.toast.com/grid/latest/tui-grid.css" />
    <script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>
	<script type="text/javascript" src="https://uicdn.toast.com/tui.pagination/v3.4.0/tui-pagination.js"></script>
    <style type="text/css">
    	.dashboard-grid {
    		grid-template-columns: repeat(auto-fit, minmax(20px, 1fr));
    	}
	    .dashboard-grid .card-icon {
            font-size: 2.5em; /* 아이콘 크기 조정 */
            margin-bottom: 10px;
        }
        .dashboard-grid .summary-card .count {
            font-size: 2em; /* 숫자 크기 조정 */
        }
        .main-value {
            font-size: 2.5em;
            font-weight: bold;
            color: #3498db;
            text-align: center;
            margin-bottom: 10px;
        }
        .sub-info {
            font-size: 0.9em;
            color: #666;
            text-align: center;
            margin-top: 5px;
        }
        .trend-indicator {
            font-weight: bold;
            display: inline-block;
            margin-left: 10px;
        }
        .trend-up { color: #28a745; }
        .trend-down { color: #dc3545; }
		.tui-grid-row-odd{
			background-color: rgba(70, 130, 180, 0.5);
		}
		.tui-grid-cell .tui-grid-cell-content{
			color : white;
		}
		.tui-grid-row-even{
			background-color: rgba(100, 149, 237, 0.5);
		}
		.tui-grid-table .tui-grid-cell{
			background-color: inherit;
			border-color : rgba(255, 255, 255, 0.5);
		}
		.tui-grid-cell-header{
			font-weight: bold;
		}
		.tui-grid-table{
			font-size : 1.1em;
			font-weight: bold;
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

            	<div class="portal-welcome-message">
                    <h2>DDTOWN 직원 시스템</h2>
                    <p>환영합니다, ${empVO.peoName} <small>(${empVO.empDepartNm} ${empVO.empPositionNm})</small> 님! 왼쪽 메뉴를 통해 각 항목을 관리할 수 있습니다.</p>
                    <p class="current-time-text">현재 시간: <span id="currentTime"></span></p>
                </div>

                <div class="dashboard-grid">
                	<div class="dashboard-card summary-card">
                		<a href="${pageContext.request.contextPath}/emp/edms/approvalBox" class="emp-menu-item">
	                		<div style="" class="card-icon"><i class="fas fa-file-signature"></i></div>
	                        <div class="card-content">
	                            <h3>전자 결재</h3>
	                            <p class="emp-menu-description">기안서 작성, 결재 요청 확인 및 문서 관리를 진행합니다.</p>
	                        </div>
                        </a>
                	</div>
                	<div class="dashboard-card summary-card">
                		<a href="${pageContext.request.contextPath}/emp/audition/schedule" class="emp-menu-item">
	                		<div class="card-icon"><i class="fas fa-microphone-alt"></i></div>
	                        <div class="card-content">
	                            <h3>오디션 관리</h3>
	                            <p class="emp-menu-description">오디션 공고 등록, 지원자 정보 관리 및 심사를 진행합니다.</p>
	                        </div>
                        </a>
                	</div>
                	<div class="dashboard-card summary-card">
                		<a href="${pageContext.request.contextPath}/emp/group/group-management" class="emp-menu-item">
	                		<div class="card-icon"><i class="fas fa-users"></i></div>
	                        <div class="card-content">
	                            <h3>아티스트 그룹 관리</h3>
	                            <p class="emp-menu-description">커뮤니티 게시글 모니터링, 사용자 관리 및 운영 업무를 수행합니다.</p>
	                        </div>
                        </a>
                	</div>
                	<div class="dashboard-card summary-card">
                		<a href="${pageContext.request.contextPath}/emp/concert/schedule/list" class="emp-menu-item">
	                		<div class="card-icon"><i class="fas fa-ticket-alt"></i></div>
	                        <div class="card-content">
	                            <h3>콘서트 관리</h3>
	                            <p class="emp-menu-description">콘서트 정보 등록, 예매 현황 확인 및 관련 통계를 관리합니다.</p>
	                        </div>
                        </a>
                	</div>
                </div>

                <div class="row g-2 dashboard-statics-grid">
	                <section class="card shadow-sm mb-4">
	                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
	                        <h3 class="h5 mb-0"><i class="fas fa-comments me-2"></i> 커뮤니티 현황</h3>
	                    </div>
	                    <div>
			                <div class="main-value"><span class="postCount">1,234</span> <span style="color: #333;">개</span> <span class="trend-indicator trend-up">▲ 5%</span></div>
			                <div class="sub-info">이번 달 게시글 수 (지난 달 대비)</div>
			            </div>
	                    <div class="card-body chart-body">
	                        <canvas id="communityPostsChart"></canvas>
	                    </div>
	                </section>
	                <section class="card shadow-sm mb-4" >
	                	<div class="card-header bg-white d-flex justify-content-between align-items-center">
	                        <h3 class="h5 mb-0"><i class="fas fa-comments me-2"></i> 전체 멤버십 현황</h3>
	                    </div>
	                    <div class="card-body chart-body">
	                        <canvas id="membershipChart"></canvas>
	                    </div>
	                </section>
                </div>

                <div class="row g-2 dashboard-static-grid" style="height: 400px;">
	                <section class="card shadow-sm mb-4">
	                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
	                        <h3 class="h5 mb-0"><i class="fas fa-comments me-2"></i> 콘서트 D-Day 현황</h3>
	                    </div>
	                    <div class="card-body chart-body">
	                        <canvas id="concertDdayChart"></canvas>
	                    </div>
	                </section>
	                <section class="card shadow-sm mb-4">
	                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
	                        <h3 class="h5 mb-0"><i class="fas fa-wallet me-2"></i> 오디션 현황</h3>
	                    </div>
	                    <div class="card-body chart-body">
	                        <canvas id="auditionChart"></canvas>
	                    </div>
	                </section>
                </div>

                <div class="row g-2 dashboard-static-grid concertGrid">
	                <section class="card shadow-sm mb-4">
	                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
	                        <h3 class="h5 mb-0"><i class="fas fa-comments me-2"></i> 콘서트 매출 현황</h3>
	                    </div>
	                    <div class="card-body chart-body mb-4">
	                        <canvas id="concertRevenueChart" height="400px"></canvas>
	                    </div>
	                    <div id="concertSalesArea">
	                    	<strong><span>월</span> 콘서트별 매출액 </strong>
	                    	<div id="concertSalesGrid"></div>
	                    </div>
	                </section>
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

    getCommunityPostsChart();
	function getCommunityPostsChart(){
		$.ajax({
			url : "/api/admin/stat/getCommunityPostsChart",
			type : "get",
			success : function(res){
				let {postJsonData,upPercent,thisMonthCount} = res;
				$(".postCount").eq(0).text(thisMonthCount);
				if(upPercent.startsWith("▼")){
					$(".trend-indicator").eq(0).removeClass("trend-up").addClass("trend-down").text(upPercent);
				}else{
					$(".trend-indicator").eq(0).removeClass("trend-down").addClass("trend-up").text(upPercent);
				}

				const postData = JSON.parse(postJsonData);
				let labels = postData.map(v => v.DT);
				let datas = postData.map(v => v.COUNT);
				createChart('communityPostsChart', 'line',
			    	    {
			    	        labels: labels,
			    	        datasets: [
			    	        	{
				    	            label: '게시물 수',
				    	            data: datas,
				    	            borderColor: '#34495e',
				    	            tension: 0.2,
				    	            fill: false
			    	        	}
			   	        	]
			    	    },
			    	    {
			    	        responsive: true,
			    	        maintainAspectRatio: false,
			    	        plugins: {
			    	            legend: {
			    	                display: true
			    	            }
			    	        }
			    	    }
			    	);

			},
			error : function(err){
				console.log(err);
			}
		})
	}

	concertDdayChart()
	function concertDdayChart(){
		$.ajax({
			url : "/api/admin/stat/getConcertDdayChart",
			type : "get",
			success : function(res){
				let {concertJsonData} = res;
				let concertData = JSON.parse(concertJsonData);
				let labels = concertData.map(v => v.CONCERT_NM);
				let ddayData = concertData.map(v => v.DDAY);
				const colors = [
					'rgba(255, 99, 132, 0.6)', // D-Day 임박 콘서트 강조
                    'rgba(255, 159, 64, 0.6)',
                    'rgba(75, 192, 192, 0.6)',
                    'rgba(54, 162, 235, 0.6)',
                    'rgba(153, 102, 255, 0.6)',
                    'rgba(255, 206, 86, 0.6)',
                    'rgba(255, 99, 255, 0.6)',
                    'rgba(0, 204, 153, 0.6)' ,
                    'rgba(255, 102, 0, 0.6)',
                    ]
				createChart('concertDdayChart', 'bar',
			            {
			                labels: labels,
			                datasets: [{
			                    label: '남은 일수 (D-Day)',
			                    data: ddayData,
			                    backgroundColor: colors,
			                    borderColor: colors.map(color => color.replace("0.6","1")),
			                    borderWidth: 1
			                }]
			            },
			            {
			                indexAxis: 'y', // 수평 막대 차트
			                responsive: true,
			                maintainAspectRatio: false,
			                plugins: {
			                    title: {
			                        display: true,
			                        text: '예정된 콘서트 D-Day 현황'
			                    },
			                    legend: {
			                        display: false
			                    }
			                },
			                scales: {
			                    x: {
			                        beginAtZero: true,
			                        title: {
			                            display: true,
			                            text: '남은 일수'
			                        },
			                        reverse: true // D-Day가 짧은 것부터 왼쪽으로 오게
			                    },
			                    y: {
			                        title: {
			                            display: true,
			                            text: '콘서트'
			                        },
			                        ticks : {
			                        	callback : function(value,index,ticks){
			                        		const originalLabel = this.getLabelForValue(value);
			                                const maxLength = 25;

			                                if (originalLabel.length > maxLength) {
			                                    return originalLabel.substring(0, maxLength - 1) + '...';
			                                }
			                                return originalLabel;
			                        	}
			                        }
			                    }
			                }
			            }
			        )
			},
			error : function(err){
				console.log(err);
			}
		})
	}



    membershipTotalData()

    function membershipTotalData(){
    	$.ajax({
    		url : "/api/admin/stat/membershipTotalData",
			type : "get",
			success : function(res){
				let {membershipJsonData, recentlyMembershipJsonData} = res;
				const membershipData = JSON.parse(membershipJsonData);
				const totalMembers = Object.values(membershipData).reduce((sum, current) => sum + current.COUNT, 0);
				const labels = membershipData.map(v => v.NAME);
				const datas = membershipData.map(v => v.COUNT);

				const recentlyMembershipData = JSON.parse(recentlyMembershipJsonData);
				const recentlyDatas = recentlyMembershipData.map(v => v.COUNT);
				const recentlyLabels = recentlyMembershipData.map(v => v.NAME);

				const refinedRecentlyData = membershipData.map(v => {
					let name = v.NAME;
					let cnt = 0;
					recentlyMembershipData.forEach(rv => {
						if(name == rv.NAME){
							cnt = rv.COUNT;
						}
					})
					return cnt;
				})

				const CHART_COLORS = [
				    'rgba(54, 162, 235, 0.7)',
				    'rgba(255, 99, 132, 0.7)',
				    'rgba(255, 206, 86, 0.7)',
				    'rgba(75, 192, 192, 0.7)',
				    'rgba(153, 102, 255, 0.7)',
				    'rgba(255, 159, 64, 0.7)',
				    'rgba(255, 0, 0, 0.7)',
				    'rgba(0, 128, 0, 0.7)',
				    'rgba(255, 165, 0, 0.7)',
				    'rgba(0, 255, 255, 0.7)',
				    'rgba(128, 0, 128, 0.7)'
				];
				const BORDER_COLORS = CHART_COLORS.map(color => color.replace('0.7', '1')); // 불투명한 경계선

				createChart('membershipChart', 'doughnut',
        			{
		                labels: labels,
		                datasets: [{
		                    label: '총 회원 수',
		                    data: datas,
		                    backgroundColor: CHART_COLORS.slice(0, labels.length), // 라벨 개수에 맞게 색상 적용
		                    borderColor: BORDER_COLORS.slice(0, labels.length),
		                    borderWidth: 1,
		                    cutout: '50%', // 바깥쪽 링의 안쪽 반지름 (더 크게 만들어서 안쪽 링 공간 확보)
		                    borderRadius: 1 // 링의 모서리 둥글게 처리
		                },{
		                    label: '이 달 가입한 회원 수',
		                    data: refinedRecentlyData,
		                    backgroundColor: CHART_COLORS.slice(0, labels.length), // 라벨 개수에 맞게 색상 적용
		                    borderColor: BORDER_COLORS.slice(0, labels.length),
		                    borderWidth: 1,
		                    cutout: '30%', // 안쪽 링의 바깥쪽 반지름
		                    innerRadius: '0%', // 안쪽 링의 안쪽 반지름 (가운데가 비어있지 않게 0%)
		                    borderRadius: 1
		                }]
		            },
		            {
		                responsive: true,
		                maintainAspectRatio: false,
		                plugins: {
		                    title: {
		                        display: true,
		                        text: `전체 멤버십 현황 (총 \${totalMembers}명)`, // 이 텍스트는 이제 centerText 플러그인에서 처리
		                        position : "top"
		                    },
		                    legend: {
		                        position: 'right' // 범례 위치
		                    },
		                    tooltip: {
		                        callbacks: {
		                            label: function(context) {
		                                const label = context.label || '';
		                                const value = context.raw;
		                                const datasetIndex = context.datasetIndex;
		                                const dataIndex = context.dataIndex;
		                                let percentage = ((value / totalMembers) * 100).toFixed(1) + '%';

		                                if(datasetIndex == 1){
		                                	let beforeValue = datas[dataIndex] - value;
		                                	beforeValue = beforeValue == 0 ? 1 : beforeValue;
		                                	percentage = ((value / beforeValue) * 100).toFixed(1) + "% 증가";
		                                }
		                                return `\${label}: \${value}명 (\${percentage})`;
		                            }
		                        }
		                    },
		                    datalabels :{
		                    	formatter: function(value, context) {
		                            const datasetIndex = context.datasetIndex;
		                            const dataIndex = context.dataIndex;
		                            const label = labels[dataIndex]; // 멤버십 이름
		                            const ctx = context.chart.ctx; // 캔버스 렌더링 컨텍스트

		                            let datasetTotal = 0;
		                            if (datasetIndex === 0) { // 바깥쪽 링 (총 회원 수)
		                                datasetTotal = datas.reduce((sum, current) => sum + current, 0);
		                            } else if (datasetIndex === 1) { // 안쪽 링 (이달 가입 회원 수)
		                                datasetTotal = recentlyDatas.reduce((sum, current) => sum + current, 0);
		                            }

		                            const percentage = (value / datasetTotal) * 100;
		                            const percentageThreshold = 4; // 이 비율 미만일 경우 라벨 줄임표 처리 (조절 필요)

		                            if (datasetIndex === 0) { // 바깥쪽 링
		                                const valueText = `\${value}명`;
		                                let labelToDisplay = label;

		                                if (percentage < percentageThreshold) {
		                                    // 비율이 낮으면 라벨 이름만 줄임표 처리
		                                    const maxLabelNameWidth = 25; // 줄임표 처리될 이름 부분의 최대 너비 (조절 필요)
		                                    let labelNameWidth = ctx.measureText(labelToDisplay).width;

		                                    if (labelNameWidth > maxLabelNameWidth) {
		                                        while (ctx.measureText(labelToDisplay + '...').width > maxLabelNameWidth && labelToDisplay.length > 0) {
		                                            labelToDisplay = labelToDisplay.slice(0, -1);
		                                        }
		                                        labelToDisplay += '...';
		                                    }
		                                }
		                                // 비율이 높으면 전체 이름, 비율이 낮으면 줄임표 처리된 이름
		                                return `\${labelToDisplay} \n \${valueText}`;
		                            } else { // 안쪽 링
		                                // 안쪽 링은 "N명"만 표시하고, 일반적으로 숫자가 짧으므로 줄임표 처리는 하지 않음
		                                // 만약 안쪽 링의 숫자도 매우 길어서 겹친다면, 여기서도 유사한 줄임표 로직을 추가할 수 있습니다.
		                                if(value == 0){
		                                	return "";
		                                }else{
			                                return `\${value}명`;
		                                }
		                            }
		                    	},
		                        color : "black",
		                        font: {
		                            weight: 'bold' // 글씨를 더 진하게
		                        },
		                        anchor : "center", // 라벨 위치 조정
		                        align : "center", // 라벨 정렬 조정
		                    }
		                },
		            },true);
			},
			error : function(err){
				console.log(err);
			}
   		})
   	}

    auditionChart()

    function auditionChart(){
    	$.ajax({
    		url : "/api/admin/stat/getAuditionChart",
    		type : "get",
    		success : function(res){
    			let {auditionJsonData} = res;
    			let auditionData = JSON.parse(auditionJsonData);
    			let labels = auditionData.map(v=> v.NAME);
    			let datas = auditionData.map(v=> v.CNT);
    			createChart('auditionChart', 'bar',
    		            {
    		                labels: labels,
    		                datasets: [{
    		                    label: "진행중인 오디션",
    		                    data: datas,
    		                    backgroundColor: [
	    		                	'rgba(75, 192, 192, 0.6)',
	    		                	'rgba(255, 99, 132, 0.6)',
    		                    ],
    		                    borderColor: [
	    		                    'rgba(75, 192, 192, 1)',
	    		                	'rgba(255, 99, 132, 1)',
    		                    ],
    		                    borderWidth: 1
    		                }
    		                ]
    		            },
    		            {
    		                responsive: true,
    		                maintainAspectRatio: false,
    		                plugins: {
    		                    title: {
    		                        display: true,
    		                        text: '진행 중인 오디션별 지원자 수'
    		                    },
    		                    legend: {
    		                        display: true,
    		                    }
    		                },
    		                scales: {
    		                    y: {
    		                        beginAtZero: true,
    		                        title: {
    		                            display: true,
    		                            text: '지원자 수'
    		                        }
    		                    },
    		                    x:{
    		                    	ticks : {
			                        	callback : function(value,index,ticks){
			                        		const originalLabel = this.getLabelForValue(value);
			                                const maxLength = 25;

			                                if (originalLabel.length > maxLength) {
			                                    return originalLabel.substring(0, maxLength - 1) + '...';
			                                }
			                                return originalLabel;
			                        	}
			                        }
    		                    }
    		                }
    		            }
    		        );
    		},
    		error : function(err){
    			console.log(err);
    		}
    	});
    }

    concertRevChart();
    function concertRevChart(){
    	$.ajax({
    		url : "/api/admin/stat/getConcertRevChart",
    		type : "get",
    		success : function(res){
    			let {concertRevJsonData, concertRevSaleJsonData} = res;
    			let concertRevData = JSON.parse(concertRevJsonData)
    			let labels = concertRevData.map(v=>v.DT)
    			let datas = concertRevData.map(v=>v.PRICE)

    			let initialLabel = labels[labels.length-1];
    			let concertRevSaleData = JSON.parse(concertRevSaleJsonData);
    			const initialData = concertRevSaleData.filter(v=>v.DT == initialLabel);
				displayConcertSale(initialData,initialLabel);
    			createChart('concertRevenueChart', 'bar',
    		            {
    		                labels: labels,
    		                datasets: [{
    		                    label: '매출액 (원)',
    		                    data: datas,
    		                    borderColor: 'rgba(70, 130, 180, 1)',
    		                    backgroundColor : 'rgba(70, 130, 180, 0.7)',
    		                    tension: 0.1,
    		                    fill: true
    		                }]
    		            },
    		            {
    		                responsive: true,
    		                maintainAspectRatio: false,
    		                plugins: {
    		                    title: {
    		                        display: true,
    		                        text: '월별 콘서트 총 매출액 추이'
    		                    },
    		                    legend: {
    		                        display: true
    		                    },
    		                    tooltip: {
    		                        callbacks: {
    		                            label: function(context) {
    		                                const value = context.raw;
    		                                return `\${value.toLocaleString()}원`; // 금액 형식으로 표시
    		                            }
    		                        }
    		                    }
    		                },
    		                onClick : function(event,element){
    		                	if(element != null && element.length > 0){
	    		                	const index = element[0].index;
	    		                	const sortedData = concertRevSaleData.filter(v => v.DT == labels[index]);
	    		                	displayConcertSale(sortedData,labels[index]);
    		                	}
    		                },
    		                scales: {
    		                    y: {
    		                        beginAtZero: true,
    		                        title: {
    		                            display: true,
    		                            text: '매출액 (원)'
    		                        },
    		                        ticks: {
    		                            callback: function(value, index, values) {
    		                                return value.toLocaleString(); // Y축 금액 형식
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
    		        );

    		},
    		error : function(err){
    			console.log(err);
    		}
    	});
    }

    function displayConcertSale(sortedData,label) {
    	let concertSalesArea = $("#concertSalesArea");
    	concertSalesArea.html(`<strong><span style="padding-left : 10px; color:green;">\${label}</span> 콘서트별 매출액 </strong><div class="mt-1 mb-2" id="concertSalesGrid"></div>`)
    	let Grid = tui.Grid;

		const grid = new Grid({
			el : document.getElementById('concertSalesGrid'),
			columns : [
				{
					header : '순위',
					name : 'RANK',
					align : 'center',
					width : 20
				},
				{
					header : '콘서트명',
					name : 'CONCERTNM',
					align : 'left'
				},
				{
					header : '총 매출액',
					name : 'PRICE',
					align : 'right',
					width : 300,
					formatter: ({ value }) => {
				        return value.toLocaleString() + "원";
				 	}
				},

			],
			data : sortedData,
		})

    }

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
})
</script>
</body>
</html>