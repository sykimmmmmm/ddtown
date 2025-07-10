<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 관리자 - 아티스트 계정 관리</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/artistDetail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/artist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/adminGroupDetail.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>

            <main class="emp-content" style="font-size: x-large;">
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
					  <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/community/group/list" style="color:black;">그룹 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">그룹 상세</li>
					</ol>
				</nav>
			    <section class="ea-section">
			        <div class="ea-section-header">
			            <h2 id="groupDetailNameTitle">그룹 프로필</h2>
			            <div class="ea-header-actions">
			                <a href="/admin/community/group/update?artGroupNo=${artistGroupVO.artGroupNo}" class="ea-btn outline sm" id="editGroupBtn"><i class="fas fa-edit"></i>수정</a>
			                <form action="/admin/community/group/delete" method="post" id="deleteForm" style="display: inline-block;">
			                    <input type="hidden" name="artGroupNo" value="${artistGroupVO.artGroupNo}">
			                    <sec:csrfInput/>
			                    <button type="button" class="ea-btn danger sm" id="deleteGroupBtn"><i class="fas fa-trash-alt"></i>삭제</button>
			                </form>
			            </div>
			        </div>

			        <div class="group-profile-header">
			            <img src="${artistGroupVO.artGroupProfileImg}" alt="그룹 프로필 이미지" class="profile-image">
			            <div class="profile-info">
			                <h1>${artistGroupVO.artGroupNm}</h1>
			                <p><strong>데뷔일:</strong> ${artistGroupVO.artGroupDebutdate}</p>
			                <p><strong>담당자:</strong> ${artistGroupVO.empName} (@${artistGroupVO.empUsername})</p>
			            </div>
			        </div>

			        <div class="content-section">
			            <h2 class="section-title">멤버</h2>
			            <div class="member-grid">
			                <c:forEach items="${artistGroupVO.artistList}" var="artist">
			                    <div class="member-card">
			                        <img src="${artist.artProfileImg}" alt="${artist.artNm} 프로필 이미지">
			                        <div class="member-name">${artist.artNm}</div>
			                    </div>
			                </c:forEach>
			            </div>
			        </div>

			        <div class="content-section">
			            <h2 class="section-title">디스코그래피</h2>
			            <c:choose>
			                <c:when test="${not empty artistGroupVO.albumList}">
			                    <c:forEach var="album" items="${artistGroupVO.albumList}">
			                        <article class="album-card">
			                            <div class="album-cover">
			                                <img src="${album.albumImg}" alt="${album.albumNm} 커버">
			                            </div>
			                            <div class="album-details">
			                                <h3 class="album-title">${album.albumNm}</h3>
			                                <p class="album-release-date">
			                                    <strong>발매일:</strong> <fmt:formatDate value="${album.albumRegDate}" pattern="yyyy년 MM월 dd일"/>
			                                </p>
			                                <p class="album-description">${album.albumDetail}</p>

			                                <h4>수록곡</h4>
			                                <ul class="track-list">
			                                    <c:forEach var="song" items="${album.albumSongs}">
			                                        <li>
			                                            <span class="track-name">${song.songNm}</span>
			                                            <c:if test="${'Y' eq song.songTitleYn}">
			                                                <span class="title-badge">TITLE</span>
			                                            </c:if>
			                                        </li>
			                                    </c:forEach>
			                                </ul>
			                            </div>
			                        </article>
			                    </c:forEach>
			                </c:when>
			                <c:otherwise>
			                    <p class="empty-message">등록된 앨범 정보가 없습니다.</p>
			                </c:otherwise>
			            </c:choose>
			        </div>
			        <div class="content-section mb-3">
					    <h2 class="section-title">통계</h2>

					    <div class="stats-grid">
					        <div class="stats-card">
					            <h3>멤버십 현황</h3>
					            <div class="membership-stats-content">
					            	<c:if test="${membershipYn eq 'Y' }">
						                <canvas id="membershipChart"></canvas>
					            	</c:if>
					            	<c:if test="${membershipYn eq 'N' }">
						                아직 멤버쉽에 가입한 사람이 없습니다.
					            	</c:if>
					            </div>
					        </div>

					        <div class="stats-card">
					            <h3>가장 많이 팔린 굿즈 (Top 3)</h3>
					            <ol class="leaderboard-list">
					            	<c:choose>
					            		<c:when test="${empty groupGoods}">
					            			아직 판매된 굿즈가 없습니다
					            		</c:when>
					            		<c:otherwise>
					            			<c:forEach items="${groupGoods}" var="goods">
								                <li>
								                    <img src="${goods.representativeImageUrl }" alt="${goods.goodsNm}">
								                    <div class="item-info">
								                        <span class="item-name">${goods.goodsNm}</span>
								                        <span class="item-sales"><fmt:formatNumber value="${goods.totalSalesAmount}" type="number"></fmt:formatNumber> 개</span>
								                    </div>
								                </li>
					            			</c:forEach>
					            		</c:otherwise>
					            	</c:choose>
					            </ol>
					        </div>
					    </div>
					</div>
					<div class="mb-3 d-flex">
						<button type="button" class="ea-btn primary sm ms-auto" id="listBtn"><i class="fas fa-list"></i>목록</button>
					</div>
			    </section>
			</main>
        </div>
    </div>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() {

	const listBtn = document.getElementById("listBtn");
	listBtn.addEventListener("click",function(){
		let searchWord = sessionStorage.getItem("searchWord") || "";
		let currentPage = sessionStorage.getItem("currentPage") || 1;
		sessionStorage.removeItem("searchWord");
		sessionStorage.removeItem("currentPage");

		location.href="/admin/community/group/list?currentPage=" + currentPage + "&searchWord=" + searchWord;
	})

	const deleteGroupBtn = document.getElementById("deleteGroupBtn");
	const deleteForm = document.getElementById("deleteForm");
	deleteGroupBtn.addEventListener("click",function(){
		Swal.fire({
			   title: '정말로 삭제 처리 하시겠습니까?',
			   text: '다시 되돌릴 수 없습니다. 신중하세요.',
			   icon: 'warning',

			   showCancelButton: true, // cancel버튼 보이기. 기본은 원래 없음
			   confirmButtonColor: '#3085d6', // confrim 버튼 색깔 지정
			   cancelButtonColor: '#d33', // cancel 버튼 색깔 지정
			   confirmButtonText: '삭제', // confirm 버튼 텍스트 지정
			   cancelButtonText: '취소', // cancel 버튼 텍스트 지정

			}).then(result => {
			   // 만약 Promise리턴을 받으면,
			    if(result.isConfirmed) { // 만약 모달창에서 confirm 버튼을 눌렀다면
					sweetAlert('success',"처리 완료");
					deleteForm.submit();

			    }
			});
	})

	const chartMap = new Map();
	let membershipJsonData = `${membershipJsonData}`;
	let membershipData = JSON.parse(membershipJsonData);
	let labels = membershipData.map(v=>v.NAME)
	let totalCnt = membershipData[0].CT;
	let datas = [totalCnt-membershipData[1].CT, membershipData[1].CT]
	createChart('membershipChart', 'doughnut',
 		            {
 		                labels: labels,
 		                datasets: [{
 		                    label: "총 구독자 수",
 		                    data: datas,
 		                    backgroundColor : [
 		                    	'#86878a',
 		                    	"#2ecc71"
 		                    ],
 		                    borderColor: ['#86878a',"#2ecc71"],
 		                }]
 		            },
 		            {
 		                responsive: true,
 		                maintainAspectRatio: false,
 		                plugins: {
 		                    legend: {
 		                        display: true,
 		                        position: 'bottom'
 		                    },
 		                    tooltip: {
 		                    	callbacks: {
		                            label: function(context) {
		                                const label = context.label || '';
		                                const value = context.raw;
		                                let percentage = ((value / totalCnt) * 100).toFixed(1) + '%';
		                                if(label == '총 구독 현황'){
		                                	return `\${label} : \${totalCnt}명 (100%)`
		                                }else{
			                                return `\${label}: \${value}명 (\${percentage})`;
		                                }
		                            }
		                        }
 		                    }
 		                }
 		            }
		        )

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
});
</script>
</body>
</html>