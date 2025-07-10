<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>APT 대문</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/mainservice_common.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/artist_community.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/artist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style type="text/css">
    	body {
        background: linear-gradient(135deg, #1a1a2e 0%, #2a1e4a 50%, #8a2be2 100%);
        background-attachment: fixed;
        background-size: cover;
        min-height: 100vh;
        margin: 0;
        font-family: "Noto Sans KR", 돋움, Dotum, 굴림, Gulim, Tahoma, Verdana, sans-serif;
        color: #ffffff; /* 기본 텍스트 색상 흰색 */
        overflow-x: hidden;
    }
    body a {
        text-decoration: none;
        color: inherit; /* 링크 색상 부모 요소 상속 */
    }

    /* 메인 헤더 (mainservice_common.css와 충돌 가능성 있으나, 여기서 직접 정의) */
    .main-header {
        background: rgba(230, 179, 255, 0.08); /* 연보라빛 투명 배경 */
        backdrop-filter: blur(20px);
        border-bottom: 1px solid rgba(255, 255, 255, 0.15);
        box-shadow: 0 4px 25px rgba(0, 0, 0, 0.4);
        position: sticky;
        top: 0;
        z-index: 1000;
        height: 150px;
        border-radius: 0 0 25px 25px;
        transition: all 0.3s ease;
    }
    .main-header.scrolled {
        height: 120px;
        background: rgba(230, 179, 255, 0.15);
        backdrop-filter: blur(25px);
        box-shadow: 0 6px 25px rgba(0, 0, 0, 0.5);
    }

    /* --- 아티스트 상세 페이지 컨테이너 --- */
    .artist-detail-container {
        max-width: 1200px; /* 기존 유지 */
        margin: 30px auto; /* 기존 유지 */
        padding: 0;
        background: rgba(255, 255, 255, 0.08); /* 글래스모피즘 배경 */
        backdrop-filter: blur(25px);
        border-radius: 25px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4);
        border: 1px solid rgba(255, 255, 255, 0.15);
        overflow: hidden;
    }

    /* 아티스트 헤더 섹션 */
    .artist-detail-header {
        position: relative;
        width: 100%;
        height: 650px; /* 고정 높이 유지 */
        overflow: hidden;
        border-radius: 25px 25px 0 0; /* 상단만 둥글게 */
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4);
    }

    .artist-profile-image-large {
        width: 100%;
        height: 130%;
        position: relative;
        z-index: 1;
    }

    .artist-profile-image-large img {
        width: 100%;
        height: 100%;
        object-fit: cover; /* 이미지가 잘리지 않고 영역을 채우도록 */
        filter: brightness(0.6); /* 이미지를 약간 어둡게 */
        display: block;
    }

    /* 아티스트 정보 바 (투명도와 블러 유지) */
    .artist-info-bar {
        position: absolute; /* header 내에서 절대 위치 */
        bottom: 0;
        left: 0;
        width: 100%;
        min-height: 100px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 30px;
        background: rgba(230, 179, 255, 0.1); /* 연보라색이 살짝 도는 투명 배경 */
        backdrop-filter: blur(20px); /* 블러 강도 */
        border-top: 1px solid rgba(255, 255, 255, 0.2); /* 좀 더 선명한 상단 테두리 */
        box-shadow: 0 -5px 25px rgba(0, 0, 0, 0.4); /* 그림자 진하게 */
        z-index: 2;
    }

    .artist-name-description h1 {
        display: flex;
        align-items: center;
        gap: 10px;
        margin: 0;
        font-size: 2.5em;
        color: #ffffff;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3); /* 제목 그림자 */
    }

    .artist-name-description h1 img {
        width: 30px;
        height: 30px;
    }
    /* 액션 버튼 */
    .action-button {
        display: inline-block;
        padding: 14px 25px;
        color: #e6b3ff; /* 연보라색 텍스트 */
        background: rgba(138, 43, 226, 0.3); /* 연보라색 계열 배경 (투명도 30%) */
        border-radius: 30px;
        transition: all 0.3s ease;
        border: 1px solid rgba(138, 43, 226, 0.5); /* 좀 더 선명한 보라색 테두리 */
        font-weight: bold;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3); /* 그림자 */
    }

    .action-button:hover {
        background: rgba(138, 43, 226, 0.5); /* 호버 시 배경색 진하게 (투명도 50%) */
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(138, 43, 226, 0.5); /* 호버 시 그림자 강조 */
    }

    /* 탭 네비게이션 (투명도와 블러 유지) */
    .artist-content-tabs {
        background: rgba(230, 179, 255, 0.1); /* 연보라색이 살짝 도는 투명 배경 */
        backdrop-filter: blur(20px);
        border-radius: 0 0 25px 25px; /* 하단만 둥글게 */
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4);
        margin-bottom: 30px; /* 기존 컨테이너 내부이므로 마진 제거 */
        border: 1px solid rgba(255, 255, 255, 0.15);
        padding: 10px 20px;
        border-top: none; /* 컨테이너 내에서 상단 중복 테두리 제거 */
    }

    .artist-content-tabs ul {
        display: flex;
        justify-content: space-around;
        list-style: none;
        margin: 0;
        padding: 0;
    }

    .artist-content-tabs li {
        flex-grow: 1;
        text-align: center;
    }

    .artist-content-tabs a {
        display: block;
        padding: 15px 20px;
        color: #ffffff;
        font-weight: bold;
        font-size: 1.4em;
        transition: all 0.3s ease;
        border-radius: 20px;
        position: relative; /* active-tab::after를 위한 position */
    }

    .artist-content-tabs a:hover {
        background: rgba(138, 43, 226, 0.25); /* 호버 시 연보라색 배경 */
        color: #ffffff !important;
    }

    .artist-content-tabs a.active-tab {
        background: rgba(138, 43, 226, 0.5); /* 활성 탭 배경색 진하게 */
        color: #ffffff;
    }

    /* 탭 콘텐츠 영역 (투명도와 블러 유지) */
    .artist-content-area {
        padding: 30px; /* 컨테이너 내 패딩 */
    }

    .tab-content {
        background: rgba(230, 179, 255, 0.08); /* 연보라색이 살짝 도는 투명 배경 */
        backdrop-filter: blur(20px);
        border-radius: 25px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4);
        padding: 30px;
        border: 1px solid rgba(255, 255, 255, 0.15);
    }

    .tab-content h2 {
        margin-top: 0;
        margin-bottom: 25px;
        font-size: 2em;
        color: #ffffff;
        font-weight: 900;
        text-shadow: 0 3px 6px rgba(0, 0, 0, 0.4);
        padding-bottom: 10px; /* 기존 유지 */
        border-bottom: 1px solid rgba(255, 255, 255, 0.1); /* 기존 유지 */
    }

    .artist-profile-info p, .artist-meta li, .album-details p, .album-details li {
        color: #e0e0e0; /* 텍스트 색상 약간 밝게 */
        line-height: 1.8;
        font-size: 1.3em;
    }

    .artist-meta {
        list-style: none;
        padding: 0;
        margin-top: 30px;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        padding-top: 20px;
    }

    .artist-meta li {
        margin-bottom: 10px;
    }

    .artist-meta strong {
        color: #ffffff;
        font-weight: bold;
        min-width: 80px;
        display: inline-block;
    }

    /* 멤버 그리드 및 멤버 카드 (색상 조정) */
    .artist-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
        gap: 25px;
        padding: 20px 0;
        margin: 0 auto;
    }

    .artist-item {
        background: rgba(255, 255, 255, 0.12); /* 기존보다 투명도를 살짝 낮춰 좀 더 선명하게 */
        backdrop-filter: blur(18px); /* 블러 강도 조정 */
        border-radius: 20px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.35); /* 그림자 약간 진하게 */
        transition: all 0.3s ease;
        height: 100%;
        border: 1px solid rgba(255, 255, 255, 0.25); /* 테두리 선명하게 */
        overflow: hidden;
        text-align: center;
        padding: 15px;
        cursor: pointer;
        position: relative; /* pseudo-element를 위한 position */
    }

    .artist-item::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(45deg, transparent 35%, rgba(255, 255, 255, 0.15) 55%, transparent 75%);
        transform: translateX(-100%);
        transition: transform 0.6s ease-out;
        z-index: 1;
    }

    .artist-item:hover::before {
        transform: translateX(100%);
    }

    .artist-item:hover {
        transform: translateY(-8px) scale(1.02);
        box-shadow: 0 12px 35px rgba(138, 43, 226, 0.5); /* 호버 시 연보라색 그림자 강조 */
        border-color: rgba(138, 43, 226, 0.7); /* 호버 시 테두리 색상 강조 */
    }

    .artist-item .artist-name {
        font-weight: bold;
        color: #ffffff;
        font-size: 1.2em;
        margin: 0 0 0 0;
        text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        position: relative;
        z-index: 2;
    }

    /* 최근 활동 (색상 조정) */
    .tab-content > div:nth-of-type(2) h2 {
        margin-top: 40px;
        margin-bottom: 25px;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        padding-top: 25px;
    }

    .tab-content ul {
        list-style: none;
        padding: 0;
    }

    .tab-content ul li {
        margin-bottom: 15px;
    }

    .tab-content ul li a {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 20px;
        background: rgba(255, 255, 255, 0.05); /* 투명한 배경 */
        border-radius: 15px;
        transition: all 0.3s ease;
        border: 1px solid rgba(255, 255, 255, 0.1);
        font-size: large;
    }

    .tab-content ul li a:hover {
        background: rgba(138, 43, 226, 0.2); /* 호버 시 연보라색 배경 */
        transform: translateX(5px);
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    }

    .tab-content .feed-title {
        font-weight: bold;
        color: #ffffff;
        flex-grow: 1;
    }

    .tab-content .feed-date {
        color: #e0e0e0;
        font-size: 0.9em;
        white-space: nowrap;
        margin-left: 15px;
    }
    /* 앨범 목록 (색상 조정) */
    .album-list {
        display: flex;
        flex-direction: column;
        gap: 30px;
    }

    .album-item {
        background: rgba(230, 179, 255, 0.08); /* 연보라색이 살짝 도는 투명 배경 */
        backdrop-filter: blur(20px);
        border-radius: 20px;
        box-shadow: 0 10px 35px rgba(0, 0, 0, 0.35);
        border: 1px solid rgba(255, 255, 255, 0.15);
        padding: 25px;
        display: flex; /* Flexbox 적용 */
        align-items: flex-start; /* 아이템 상단 정렬 */
        gap: 30px;
        transition: all 0.4s ease;
    }

    .album-item:hover {
        transform: translateY(-10px) scale(1.02);
        box-shadow: 0 15px 40px rgba(138, 43, 226, 0.5); /* 호버 시 연보라색 그림자 */
        border-color: rgba(138, 43, 226, 0.6);
    }

    .album-cover {
        flex-shrink: 0; /* 이미지가 줄어들지 않도록 */
        width: 250px; /* 이미지 너비 고정 */
        height: 250px; /* 이미지 높이 고정 */
        overflow: hidden; /* 이미지가 영역을 넘지 않도록 */
        border-radius: 15px;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
    }

    .album-cover img {
        width: 100%;
        height: 100%;
        object-fit: cover; /* 이미지가 영역을 꽉 채우도록 */
        display: block;
        border-radius: 15px;
        transition: transform 0.4s ease-out;
    }

    .album-item:hover .album-cover img {
        transform: scale(1.05);
    }

    .album-details {
        flex: 1; /* 남은 공간을 채우도록 */
    }

    .album-details h3.album-title {
        font-size: 1.8em;
        font-weight: bold;
        margin-top: 0;
        margin-bottom: 15px;
        color: #ffffff;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
    }

    .album-release-date {
        font-size: 1em;
        color: #e0e0e0;
        margin-bottom: 10px;
    }

    .album-description {
        font-size: 1em;
        color: #e0e0e0;
        margin-bottom: 20px;
        word-break: break-word;
    }

    .album-details h4 {
        font-size: 1.3em;
        color: #ffffff;
        margin-top: 25px;
        margin-bottom: 10px;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        padding-top: 15px;
    }

   .track-list-table {
	    list-style: none; /* 기본 목록 마커 제거 */
	    padding: 0; /* 기본 패딩 제거 */
	    margin: 0; /* 기본 마진 제거 */
	    background: rgba(255, 255, 255, 0.03); /* 약간 투명한 배경색 */
	    border-radius: 10px; /* 둥근 모서리 */
	    padding: 15px !important; /* 내부 패딩 */
	}

	.track-list-table li {
	    padding: 10px 0; /* 상하 패딩 */
	    margin-bottom: 8px; /* 아래쪽 마진 */
	    border-bottom: 1px solid rgba(255, 255, 255, 0.08); /* 하단 테두리 (약간 투명) */
	    display: flex; /* Flexbox 사용하여 내용 정렬 */
	    justify-content: space-between; /* 양 끝 정렬 */
	    align-items: center; /* 세로 중앙 정렬 */
	    color: #e0e0e0; /* 텍스트 색상 */
	    font-size: 1.2em; /* 글꼴 크기 */
	    transition: background 0.2s ease; /* 배경색 변화에 대한 부드러운 전환 효과 */
	}

	.track-list-table li:last-child {
	    border-bottom: none; /* 마지막 항목의 하단 테두리 제거 */
	}

	.track-list-table li:hover {
	    background: rgba(138, 43, 226, 0.1); /* 호버 시 연보라색 배경 */
	    border-radius: 5px; /* 호버 시 약간 둥근 모서리 */
	}

	.track-title-badge {
	    background: linear-gradient(45deg, #ffd700, #ffed4e); /* 골드 그라데이션 배경 */
	    color: #8a2be2; /* 보라색 텍스트 */
	    font-weight: bold; /* 굵은 글씨 */
	    padding: 4px 8px; /* 내부 패딩 */
	    border-radius: 12px; /* 둥근 모서리 */
	    font-size: 0.9em; /* 작은 글꼴 크기 */
	    margin-left: 10px; /* 왼쪽 마진 */
	    box-shadow: 0 2px 8px rgba(255, 215, 0, 0.3); /* 그림자 효과 */
	    margin-right: 10px;
	}

    /* 아티스트 모달 스타일 */
    .artist-modal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.7);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1001;
        backdrop-filter: blur(10px);
    }

    .artist-modal-content {
        background: rgba(230, 179, 255, 0.2); /* 연보라색이 살짝 도는 투명 배경 */
        backdrop-filter: blur(25px);
        border-radius: 25px;
        box-shadow: 0 15px 50px rgba(0, 0, 0, 0.5);
        padding: 30px;
        max-width: 550px;
        width: 100%;
        text-align: center;
        position: relative;
        border: 1px solid rgba(255, 255, 255, 0.2);
        height: 600px;
    }

    .artist-modal-close {
        position: absolute;
        top: 15px;
        right: 20px;
        color: #ffffff;
        font-size: 2em;
        cursor: pointer;
        transition: color 0.3s ease;
        text-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
    }

    .artist-modal-close:hover {
        color: #e6b3ff;
    }

    .modal-artist-img {
        width: 400px;
        height: 450px;
        border-radius: 25px;
        object-fit: cover;
        margin: 0 auto 20px;
        display: block;
        border: 3px solid rgba(138, 43, 226, 0.3); /* 좀 더 진한 연보라색 테두리 */
        margin-bottom: 20px;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
    }

    .modal-artist-info h3 {
        color: #ffffff;
        font-size: 1.8em;
        font-weight: bold;
        text-shadow: 0 2px 5px rgba(0, 0, 0, 0.4);
        margin-top: 35px;
    }
    </style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />

    <div class="artist-detail-container">
        <header class="artist-detail-header">
            <div class="artist-profile-image-large">
                <img src="${group.artGroupProfileImg }" alt="${group.artGroupNm }의 프로필 배너" />
            </div>
            <div class="artist-info-bar">
                <div class="artist-name-description">
                    <h1 class="d-flex gap-2">
                    	${group.artGroupNm }
                    	<img alt="아티스트 인증 마크" src="${pageContext.request.contextPath }/resources/img/verified.png" style="width: 25px; height: 25px;">
                    </h1>
                </div>
                <div class="artist-actions">
                    <a href="/community/gate/${group.artGroupNo}/apt" class="action-button go-to-apt" id="goToAptBtn">APT 바로가기</a>
                </div>
            </div>
        </header>

        <nav class="artist-content-tabs">
            <ul>
                <li><a href="#" data-tab="profile-content" class="active-tab">프로필 탭</a></li>
                <li><a href="#" data-tab="album-content">앨범 및 음원 정보 조회 탭</a></li>
            </ul>
        </nav>

        <main class="artist-content-area">
            <section id="profile-content" class="tab-content active">

            		<c:choose>
            			<c:when test="${group.artGroupTypeCode == 'AGTC001'}">
            				<h2>그룹 소개</h2>
            			</c:when>
            			<c:otherwise>
            				<h2>아티스트 소개</h2>
            			</c:otherwise>
            		</c:choose>

                <div class="artist-profile-info">
                    <p style="white-space: pre;">${group.artGroupContent}</p>
                    <ul class="artist-meta">
                        <li><strong>데뷔일:</strong> ${group.artGroupDebutdate }</li>
                        <c:set var="representativeSong" value="정보 없음"/> <%-- 기본값 설정 --%>
                        <c:if test="${not empty group.albumList}">
					    <c:forEach items="${group.albumList}" var="album">
					        <c:set var="representativeSong" value="${album.titleSong}"/>
					    </c:forEach>
					</c:if>
					<li><strong>대표곡:</strong> ${representativeSong}</li>
					<li><strong>멤버:</strong>
						<div class="artist-grid" style="grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));">
                            <c:forEach items="${group.artistList }" var="artist">
                                <div class="artist-item" data-name="${artist.artNm}" data-img="${artist.artProfileImg}">
                                    <p class="artist-name">${artist.artNm }</p>
                                </div>
                            </c:forEach>
                        </div>
					</li>


                    </ul>
                </div>
                <div>
	                <h2>최근 활동</h2>
	                <ul>
						<c:choose>
							<c:when test="${not empty noticeList }">
								<li>
									<c:forEach items="${noticeList }" var="notice">
											<a href="/community/notice/post/${notice.comuNotiNo }">
						        				<div class="feed-title">[<c:out value="${notice.codeDescription }" />]<c:out value="${notice.comuNotiTitle }"/></div>
						        				<div class="feed-date"><fmt:formatDate value="${notice.comuNotiRegDate }" pattern="yyyy-MM-dd"/></div>
						        			</a>
									</c:forEach>
								</li>
							</c:when>
						</c:choose>
	                </ul>
                </div>
            </section>

            <section id="album-content" class="tab-content" style="display: none;">
                <h2>앨범 및 음원 정보</h2>

                <div class="album-list">
                <c:if test="${not empty group.albumList}">
			        <div class="album-list">
			            <c:forEach var="album" items="${group.albumList}">
			                <article class="album-item">
			                    <div class="album-cover">
			                        <img src="${album.albumImg}" alt="${album.albumNm} 커버" style="width:350px; height:auto;"/>
			                    </div>
			                    <div class="album-details">
			                        <h3 class="album-title">${album.albumNm}</h3>
			                        <p class="album-release-date">
			                            <strong>발매일:</strong>
			                            <fmt:formatDate value="${album.albumRegDate}" pattern="yyyy년 MM월 dd일" />
			                        </p>
			                        <p class="album-description">${album.albumDetail}</p>

			                        <p><strong>타이틀 곡:</strong>
			                            <c:choose>
			                                <c:when test="${not empty album.titleSong}">
			                                    ${album.titleSong}
			                                </c:when>
			                                <c:otherwise>
			                                    (타이틀 곡 정보 없음)
			                                </c:otherwise>
			                            </c:choose>
			                        </p>

			                        <h4>수록곡 전체:</h4>
			                        <ul class="track-list-table">
			                            <c:forEach var="song" items="${album.albumSongs}">
			                                <li>
			                                    ${song.songNm}
			                                    <c:if test="${'Y' eq song.songTitleYn}">
			                                        <span class="track-title-badge">타이틀</span>
			                                    </c:if>
			                                </li>
			                            </c:forEach>
			                        </ul>
			                    </div>
			                </article>
			            </c:forEach>
			        </div>
			    </c:if>
                </div>
            </section>
        </main>
    </div>

	<div id="artist-modal" class="artist-modal" style="display:none;">
        <div class="artist-modal-content">
            <span class="artist-modal-close">&times;</span>
            <img id="modal-artist-img" src="" alt="아티스트 프로필" class="modal-artist-img">
            <div class="modal-artist-info">
                <h3 id="modal-artist-name"></h3>
            </div>
        </div>
    </div>

	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>

    <script>

        // 수정된 탭 기능
        const tabs = document.querySelectorAll('.artist-content-tabs a');
        const tabContents = document.querySelectorAll('.artist-content-area .tab-content');

        tabs.forEach(tab => {
            tab.addEventListener('click', function(event) {
                event.preventDefault();

                tabs.forEach(t => t.classList.remove('active-tab'));
                this.classList.add('active-tab');

                const targetId = this.dataset.tab;

                tabContents.forEach(content => {
                    if (content.id === targetId) {
                        content.style.display = 'block';
                    } else {
                        content.style.display = 'none';
                    }
                });
            });
        });

        // 페이지 로드 시 첫 번째 탭 활성화 및 해당 콘텐츠 표시
        if (tabs.length > 0 && tabContents.length > 0) {
            tabs[0].classList.add('active-tab');
            const firstTabTargetId = tabs[0].dataset.tab;

            tabContents.forEach(content => {
                if (content.id === firstTabTargetId) {
                    content.style.display = 'block';
                } else {
                    content.style.display = 'none';
                }
            });
        }

        document.addEventListener('DOMContentLoaded', function() {

            const artistItems = document.querySelectorAll('.artist-item');
            const artistModal = document.getElementById('artist-modal');

            const modalCloseBtn = artistModal ? artistModal.querySelector('.artist-modal-close') : null;

            if (artistItems.length > 0 && artistModal) {
                artistItems.forEach(function(item) {
                    item.addEventListener('click', function() {

                        const imgSrc = this.dataset.img;
                        const name = this.dataset.name;

                        if (imgSrc && name) {
                            document.getElementById('modal-artist-img').src = imgSrc;
                            document.getElementById('modal-artist-img').alt = name + " 프로필";
                            document.getElementById('modal-artist-name').textContent = name;

                            artistModal.style.display = 'flex'; // 모달 표시 (flex로 중앙 정렬 가정)
                        } else {
                            console.error('멤버 카드에 data-name 또는 data-img 속성이 없습니다.', this);
                        }
                    });
                });

                if (modalCloseBtn) {
                    modalCloseBtn.addEventListener('click', function() {
                        artistModal.style.display = 'none';
                    });
                }

                // 모달 바깥 클릭 시 닫기
                artistModal.addEventListener('click', function(e) {
                    if (e.target === this) {
                        this.style.display = 'none';
                    }
                });

                // (선택) Esc 키로 모달 닫기
                document.addEventListener('keydown', function(event) {
                    if (event.key === 'Escape' && artistModal.style.display === 'flex') {
                        artistModal.style.display = 'none';
                    }
                });

            } else {
                if (artistItems.length === 0) {
                    console.warn("클릭할 .artist-item 요소를 찾지 못했습니다. HTML 구조를 확인해주세요.");
                }
                if (!artistModal) {
                    console.warn("#artist-modal 요소를 찾지 못했습니다. 모달 HTML이 페이지에 포함되어 있는지 확인해주세요.");
                }
            }
        });

    </script>
</body>
</html>