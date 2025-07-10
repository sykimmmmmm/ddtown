<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/modules/grid.min.css" /> 
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_home.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/artist_community.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/artist_community_main.css" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/concert_list.css">
<title>DDTOWN SQUARE</title>

<style type="text/css">

body {
	overflow-x : hidden;
	font-family: sans-serif;
	margin: 0;
    background: linear-gradient(135deg, #1a1a2e 0%, #2a1e4a 50%, #8a2be2 100%); /* 중간색을 약간 더 보라색 계열로 조정 */
    background-attachment: fixed; /* 배경을 뷰포트에 고정 */
    background-size: cover; /* 배경이 전체 영역을 커버하도록 */
    min-height: 100vh;
    margin: 0;
    font-family: "Noto Sans KR", 돋움, Dotum, 굴림, Gulim, Tahoma, Verdana, sans-serif;
    color: #ffffff;
    overflow-x: hidden;
}

.swiper {
	max-width: 1500px;
    height: 400px;
    padding: 70px;
    align-items: center;
}

.swiper-slide {
	text-align: center;
	font-size: 18px;
    display: flex;
    justify-content: center;
    align-items: center;
    border: 1px solid #ddd;
    width: 330px;
    height: 110px;
    box-sizing: border-box;	/* 패딩, 보더가 너비/높이에 포함되도록 */
    overflow: hidden;
    border-radius: 20px;
}

body .swiper-slide {
	width: 330px;
    height: 110px;
}

.swiper-slide a {
    display: flex; /* 링크를 flex 컨테이너로 만들어 내부 이미지 중앙 정렬 */
    width: 1000px;
    height: 200px;
    text-decoration: none; /* 링크 밑줄 제거 */
    justify-content: center;
    align-items: center;
    overflow: hidden; /* 이미지가 넘치면 숨김 */
}

.swiper-slide a img {
    width: 100%; /* 부모(a 태그) 너비에 맞춤 */
    height: 100%; /* 부모(a 태그) 높이에 맞춤 */
    object-fit: scale-down; /* 이미지가 비율을 유지하며 컨테이너를 꽉 채우도록 */
    display: block; /* 이미지 하단 기본 여백 제거 */
}

.concert-page-container {
    max-width: 1700px;
    padding: 40px 40px;
    flex: 1;
    margin: 0 auto;
    align-items: center;
}

.concert-item {
    background-color: #fff;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    overflow: hidden; /* 자식 요소가 둥근 모서리를 넘지 않도록 */
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); /* 그림자 효과 */
    transition: transform 0.2s ease, box-shadow 0.2s ease; /* 호버 효과 */
    display: flex; /* 내부 콘텐츠를 위한 flex */
    flex-direction: column; /* 세로 방향으로 정렬 */
    text-decoration: none; /* 링크 밑줄 제거 */
    color: inherit; /* 텍스트 색상 상속 */
}

.concert-item:hover {
    transform: translateY(-5px); /* 살짝 위로 뜨는 효과 */
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15); /* 그림자 진해짐 */
}

/* 썸네일 이미지 영역 */
.concert-thumbnail {
	position: relative;
    width: 100%;
    height: 350px; /* 이미지 높이 고정 */
    overflow: hidden; /* 이미지가 이 영역을 벗어나지 않도록 */
    display: flex; /* 이미지 중앙 정렬용 */
    justify-content: center;
    align-items: center;
}

.online-badge {
    position: absolute; /* 썸네일 이미지 위에 배치합니다. */
    top: 10px; /* 상단에서 10px 떨어진 곳에 위치합니다. */
    right: 10px; /* 오른쪽에서 10px 떨어진 곳에 위치합니다. */
    background-color: rgba(0, 123, 255, 0.9); /* 파란색 배경, 약간의 투명도 */
    color: white; /* 흰색 글자 */
    padding: 5px 10px; /* 상하 5px, 좌우 10px 패딩 */
    border-radius: 130px; /* 모서리 둥글게 */
    font-size: 1.3em; /* 글자 크기 */
    font-weight: bold; /* 글자 두껍게 */
    display: flex; /* 아이콘과 텍스트를 나란히 정렬 */
    align-items: center; /* 세로 중앙 정렬 */
    gap: 5px; /* 아이콘과 텍스트 사이 간격 */
    z-index: 10; /* 이미지가 덮지 않도록 z-index를 높게 설정 */
}

.online-badge .fas {
    font-size: 1em; /* 아이콘 크기 */
}

.concert-thumbnail img {
    width: 100%;
    height: 100%;
    object-fit: cover; /* 이미지가 컨테이너를 꽉 채우면서 비율 유지 */
    display: block; /* 이미지 하단 여백 제거 */
}

/* 콘서트 정보 텍스트 영역 */
.concert-info {
    padding: 15px;
    display: flex;
    flex-direction: column;
    flex-grow: 1; /* 남은 공간을 정보 영역이 차지하도록 */
    justify-content: space-between; /* 상태 텍스트를 맨 아래로 보냄 */
}

.concert-title {
    font-size: 1.3em;
    font-weight: bold;
    margin-top: 0;
    margin-bottom: 10px;
    color: #333;
    white-space: nowrap; /* 제목이 길어지면 한 줄로 */
    overflow: hidden; /* 넘치는 부분 숨김 */
    text-overflow: ellipsis; /* ...으로 표시 */
}

.concert-artist,
.concert-date,
.concert-venue {
    font-size: 0.9em;
    color: #666;
    margin-bottom: 5px;
    line-height: 1.4;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.concert-status {
    margin-top: auto; /* info 영역 내에서 상태 텍스트를 하단으로 밀어냄 */
    padding-top: 15px; /* 정보와 상태 텍스트 사이 간격 */
    padding-bottom: 15px;
    border-top: 1px solid #eee; /* 구분선 */
    text-align: center; /* 상태 텍스트 중앙 정렬 */
    font-size: 1.1em;
    font-weight: bold;
    background-color: #f8f8f8; /* 약간 밝은 배경색을 추가하여 대비를 줍니다. */
    box-shadow: inset 0 1px 3px rgba(0,0,0,0.05); /* 내부 그림자 추가 */
}

.ended-concert {
	filter: grayscale(100%); /* 모든 색상을 회색조로 변경 */
    opacity: 0.7; /* 약간 투명하게 만들어 비활성 느낌 강조 */
    pointer-events: none; /* 클릭 이벤트를 비활성화하여 선택되지 않도록 합니다. */
    cursor: default; /* 마우스 오버 시 커서를 기본으로 변경 */
}

.concert-list {
    display: grid; /* Grid 레이아웃 사용 */
    grid-template-columns: repeat(5, 1fr); /* 한 줄에 5개의 동일한 너비 열 생성 */
    gap: 25px; /* 콘서트 아이템 간의 간격 (필요에 따라 조절) */
    margin-top: 30px; /* 상단 여백 (필요에 따라 조절) */
}

.scheduled-concert-list .concert-item .concert-date {
    font-size: 1.2em; /* 기본보다 크게 */
    font-weight: bold; /* 글자 두껍게 */
    color: #ff5722; /* 눈에 띄는 주황색 계열 색상 (예시) */
}
body a{
	text-decoration: none;
}

</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />
	
	<div class="swiper concertSwiper">
	  <div class="swiper-wrapper">
	  
	  	<div class="swiper-slide">
		  	<a href="/concert/detail/6" target="concert1">
	        	<img src="${pageContext.request.contextPath}/resources/img/aespa.jpg" alt="콘서트 1 썸네일">
	        </a>
	  	</div>
	  	<div class="swiper-slide">
		  	<a href="/concert/detail/7" target="concert1">
	        	<img src="${pageContext.request.contextPath}/resources/img/ive.jpg" alt="콘서트 2 썸네일">
	        </a>
	  	</div>
	  	<div class="swiper-slide">
		  	<a href="/concert/detail/8" target="concert1">
	        	<img src="${pageContext.request.contextPath}/resources/img/iu.jpg" alt="콘서트 3 썸네일">
	        </a>
	  	</div>
	  	<div class="swiper-slide">
		  	<a href="/concert/detail/14" target="concert1">
	        	<img src="${pageContext.request.contextPath}/resources/img/bm.jpeg" alt="콘서트 4 썸네일">
	        </a>
	  	</div>
	  	<div class="swiper-slide">
		  	<a href="/concert/detail/9" target="concert1">
	        	<img src="${pageContext.request.contextPath}/resources/img/gd.jpg" alt="콘서트 5 썸네일">
	        </a>
	  	</div>
	  	<div class="swiper-slide">
		  	<a href="/concert/detail/25" target="concert1">
	        	<img src="${pageContext.request.contextPath}/resources/img/cp.jpg" alt="콘서트 6 썸네일">
	        </a>
	  	</div>
	  	
	  </div>	
	</div>
	
	<div class="concert-page-container">
		<div class="page-title-area">
			<h2>SCHEDULED</h2>
	    </div>
	    
	    <div class="scheduled-concert-list concert-list">
	    	<c:set var="today" value="<%= new Date() %>" />
	       	<c:choose>
	       		<c:when test="${not empty concertList }">
	       			<c:forEach var="concert" items="${concertList }">
	       				<c:if test="${concert.concertReservationStatCode eq 'CRSC005'}">
	        				<article class="concert-item"
	        					data-concert-type="${concert.concertCatCode }"
	        					data-artist-id="${concert.artGroupNo }"
	        					data-is-soldout="false">
				                <div class="concert-thumbnail">
				                    <img src="${concert.representativeImageUrl}" alt="${concert.concertNm} 썸네일">
				                    <c:if test="${concert.concertCatCode eq 'CCC001' }">
				                    	<div class="online-badge">
				                    		<i class="fas fa-globe"></i>
				                    	</div>
				                    </c:if>
				                </div>
				                <div class="concert-info">
	                            <h3 class="concert-title">${concert.concertNm}</h3>
	                            <c:choose>
	                            <c:when test="${concert.concertStartDate.year eq today.year &&
	                            				concert.concertStartDate.month eq today.month &&
	                            				concert.concertStartDate.date eq today.date }">
	                            	<p class="concert-date"><fmt:formatDate value="${concert.concertStartDate}" pattern="오늘 HH:mm"></fmt:formatDate> OPEN
	                            </c:when>
	                            <c:otherwise>
	                            	<p class="concert-date"><fmt:formatDate value="${concert.concertStartDate}" pattern="yyyy-MM-dd(E) HH:mm"></fmt:formatDate> OPEN
	                            </c:otherwise>
	                            </c:choose>
	                            <p class="concert-artist"><strong>아티스트:</strong> ${concert.artGroupName}</p>
	                            <p class="concert-venue"><strong>장소:</strong> ${concert.concertHallName}</p>
	                        </div>
				            </article>
			            </c:if>
	       			</c:forEach>
	       		</c:when>
	       		<c:otherwise>
	       			<p>등록된 콘서트가 없습니다.</p>
	       		</c:otherwise>
	       	</c:choose>
	    </div>
    </div>
    
	<div class="concert-page-container">
        <div class="page-title-area">
            <h2>CONCERT TICKETING</h2>
        </div>

        <div class="concert-filters-and-tabs">
            <div class="concert-tabs">
                <span class="tab-item active" data-concert-type="all">전체</span>
                <span class="tab-item" data-concert-type="online">온라인</span>
                <span class="tab-item" data-concert-type="offline">오프라인</span>
            </div>
        </div>

        <div class="concert-list ongoing-concert-list">
        	<c:choose>
        		<c:when test="${not empty concertList }">
	        			<c:forEach var="concert" items="${concertList }">
	        				<c:if test="${concert.concertReservationStatCode ne 'CRSC005'}">
		        				<article class="concert-item
		        					<c:if test="${concert.concertReservationStatCode eq 'CRSC004' }">ended-concert</c:if>"
		        					data-concert-type="${concert.concertCatCode }"
		        					data-artist-id="${concert.artGroupNo }"
		        					data-is-soldout="false">
		        					<a href="/concert/detail/${concert.concertNo }" class="concert-link">
					                <div class="concert-thumbnail">
					                    <img src="${concert.representativeImageUrl}" alt="${concert.concertNm} 썸네일">
					                    <c:if test="${concert.concertCatCode eq 'CCC001' }">
					                    	<div class="online-badge">
					                    		<i class="fas fa-globe"></i>
					                    	</div>
					                    </c:if>
					                </div>
					                <div class="concert-info">
		                            <h3 class="concert-title">${concert.concertNm}</h3>
		                            <p class="concert-artist"><strong>아티스트:</strong> ${concert.artGroupName}</p>
		                            <p class="concert-date"><strong>일시:</strong>
		                            <fmt:formatDate value="${concert.concertStartDate}" pattern="yyyy-MM-dd"></fmt:formatDate> ~ <fmt:formatDate value="${concert.concertEndDate}" pattern="yyyy-MM-dd"></fmt:formatDate>
		                            <p class="concert-venue"><strong>장소:</strong> ${concert.concertHallName}</p>
		                            <div class="concert-status">
		                                <c:choose>
		                                    <c:when test="${concert.concertReservationStatCode eq 'CRSC003'}">
		                                        <span class="sold-out" style="color: #dc3545;">매진</span>
		                                    </c:when>
		                                    <c:when test="${concert.concertReservationStatCode eq 'CRSC001'}">
		                                        <span class="pre-sale" style="color: #007bff;">선예매 기간</span>
		                                    </c:when>
		                                    <c:when test="${concert.concertReservationStatCode eq 'CRSC002'}">
		                                        <span class="available" style="color: #28a745;">예매 가능</span>
		                                    </c:when>
		                                    <c:when test="${concert.concertReservationStatCode eq 'CRSC004'}">
		                                        <span class="ended">종료</span>
		                                    </c:when>
		                                </c:choose>
		                            </div>
		                        </div>
		                        </a>
					            </article>
		        			</c:if>
	        			</c:forEach>
        			</c:when>
        		<c:otherwise>
        			<p>등록된 콘서트가 없습니다.</p>
        		</c:otherwise>
        	</c:choose>
        </div>
	</div>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script>
		
    	const swiper = new Swiper('.concertSwiper', {
    		slidesPerView: 3,	// 한 줄에 3개 슬라이드
    		spaceBetween: 30,	// 슬라이드 간의 간격
    		grid: {
    			rows: 2,		// 그리드에서 사용할 행 개수
    			fill: 'row',	// 슬라이드가 그리드를 채우는 방식 (행, 열)
    		},
    	});
    	
    	// 탭 필터링 기능
    	$('.concert-tabs .tab-item').on('click', function() {
    		
    		// 활성화된 탭 변경
    		$('.concert-tabs .tab-item').removeClass('active');
    		$(this).addClass('active');
    		
    		// 클릭된 탭 데이터 타입 가져오기
    		const selectedType = $(this).data('concert-type');
    		
    		// 콘서트 아이템 필터링
    		$('.ongoing-concert-list .concert-item').hide();	// 모든 콘서트 아이템 숨기기
    		
    		if(selectedType == 'all') {
    			$('.ongoing-concert-list .concert-item').show();	// 전체 콘서트 보여줌
    		} else {
    			$('.ongoing-concert-list .concert-item[data-concert-type="' + (selectedType == 'online' ? 'CCC001' : 'CCC002') + '"]').show();
    		}
    	});
    	
    	// 페이지 로드시 '전체' 탭 활성화되도록 초기화
    	$('.concert-tabs .tab-item[data-concert-type="all"]').click();
		
    </script>
</body>
</html>