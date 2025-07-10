<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 관리자 - 아티스트 계정 관리</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/adminArtistDetail.css">
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>

			<c:set var="memberVO" value="${artistVO.memberVO }"/>
            <main class="emp-content">
           		<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
					  <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/community/artist/list" style="color:black;">아티스트 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">아티스트 상세</li>
					</ol>
				</nav>
			    <section id="artistDetailSection" class="ea-section">
			        <div class="ea-section-header">
			            <h2 id="artistDetailNameTitle">아티스트 프로필</h2>
			            <div class="ea-header-actions">
			                <a href="/admin/community/artist/update?artNo=${artistVO.artNo}" class="ea-btn outline sm" id="editArtistBtn"><i class="fas fa-edit"></i>수정</a>
			                <form action="/admin/community/artist/deleteArtist" method="post" id="deleteForm" style="display: inline-block;">
			                    <input type="hidden" name="artNo" value="${artistVO.artNo}">
			                    <input type="hidden" name="memUsername" value="${artistVO.memUsername}">
			                    <sec:csrfInput/>
			                    <button type="button" class="ea-btn danger sm" id="deleteArtistBtn"><i class="fas fa-trash-alt"></i>삭제</button>
			                </form>
			            </div>
			        </div>

			        <div class="resume-container">

			            <aside class="resume-sidebar">
			                <div class="info-card">
			                    <div class="d-flex justify-content-center align-items-center">
			                        <img src="${artistVO.artProfileImg}" alt="아티스트 프로필 이미지" class="profile-image">
			                    </div>
			                    <h3 class="profile-name">${artistVO.artNm}</h3>
			                    <p class="profile-id">@${artistVO.memUsername}</p>
			                    <div class="status-badge-wrapper">
			                        <span class="status-badge active" id="detailArtistStatus">활동중</span>
			                    </div>
			                    <div class="artist-description mb-5">
			                        ${artistVO.artContent}
			                    </div>
			                </div>
			            </aside>

			            <div class="info-card d-flex" style="gap:50px">
			                <div class="mr-4">
			                    <h4>기본 정보</h4>
			                    <dl class="details-list">
			                        <dt>본명</dt>
			                        <dd>${memberVO.peoName}</dd>
			                        <dt>생년월일</dt>
			                        <dd>${memberVO.memBirth}</dd>
			                        <dt>성별</dt>
			                        <dd>${memberVO.peoGender eq 'M' ? '남성' : '여성'}</dd>
			                        <dt>이메일</dt>
			                        <dd>${memberVO.peoEmail}</dd>
			                    </dl>
			                </div>
			                <div>
			                    <h4>활동 내역</h4>
			                    <div class="d-flex gap-3">
                           <c:choose>
                               <c:when test="${not empty artistVO.groupList}">
                                   <c:forEach items="${artistVO.groupList}" var="group" varStatus="status">
					                    <dl class="details-list">
					                        <dt>소속 그룹</dt>
					                        <dd>${group.artGroupNm}</dd>
					                        <dt>그룹 데뷔일</dt>
					                        <dd>${group.artGroupDebutdate}</dd>
					                        <dt>그룹 담당자</dt>
					                        <dd>${group.empName}</dd>
					                        <dt>활동 여부</dt>
					                        <dd>${group.delYn eq 'Y'? '종료' : '활동중'  }</dd>
					                    </dl>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
					                    <dl class="details-list">
		                                    <dt>소속 그룹</dt>
		                                    <dd>미 소속</dd>
					                    </dl>
                                </c:otherwise>
                            </c:choose>
			                    </div>
			                </div>
			            </div>

			            <div class="info-card mb-4" id="stats-card-full">
			                <h4 class="mb-4">통계</h4>
			                <div class="artist-stats-grid">
			                    <div class="stats-card">
			                        <h3>가장 많이 팔린 굿즈 (Top 3)</h3>
			                        <ol class="leaderboard-list">
			                        	<c:choose>
			                        		<c:when test="${empty memberGoods}">
			                        			<li>아직 팔린 굿즈가 없습니다.</li>
			                        		</c:when>
			                        		<c:otherwise>
			                        			<c:forEach items="${memberGoods}" var="goods">
			                        				<li>
			                        					<img src="${goods.representativeImageUrl}" alt="${goods.goodsNm}">
			                        					<div class="item-info">
			                        						<span class="item-name">${goods.goodsNm}</span>
			                        						<span class="item-sales"><fmt:formatNumber value="${goods.totalSalesAmount}" pattern="###,###,###"></fmt:formatNumber> 개</span>
			                        					</div>
			                        				</li>
			                        			</c:forEach>
			                        		</c:otherwise>
			                        	</c:choose>
			                        </ol>
			                    </div>
			                    <div class="stats-card">
			                        <h3>인기 게시글 (Top 3)</h3>
			                        <ol class="leaderboard-list post-list">
			                        	<c:choose>
			                        		<c:when test="${empty hotPost}">
			                        			<li>아직 작성한 게시글이 없습니다</li>
			                        		</c:when>
			                        		<c:otherwise>
			                        			<c:forEach items="${hotPost}" var="post">
						                            <li>
						                            	<div class="item-info">
						                            		<span class="item-name">${post.comuPostContent}</span>
						                            		<span class="item-likes"><i class="fas fa-heart"></i> <fmt:formatNumber value="${post.comuPostLike}" type="number"></fmt:formatNumber> </span>
					                            		</div>
					                            	</li>
			                        			</c:forEach>
			                        		</c:otherwise>
			                        	</c:choose>
			                        </ol>
			                    </div>
			                </div>
			            </div>
			        </div>
			        <div class="d-flex mb-3">
				        <button type="button" class="ea-btn primary sm" style="margin-left:auto;" id="listBtn"><i class="fas fa-list"></i> 목록</button>
			        </div>
			    </section>
			</main>
        </div>
    </div>

</body>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() {

	let deleteArtistBtn = $("#deleteArtistBtn");
	deleteArtistBtn.on("click",function(){
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
			   		$("#deleteForm").submit();

			    }
			});
	})


	// 목록 가기
	const listBtn = document.getElementById("listBtn");
	listBtn.addEventListener("click",function(){
		let searchWord = sessionStorage.getItem("searchWord") || "";
		let searchType = sessionStorage.getItem("searchType") || "artist";
		let currentPage = sessionStorage.getItem("currentPage") || 1;

		sessionStorage.removeItem("sarchWord");
		sessionStorage.removeItem("searchType");
		sessionStorage.removeItem("currentPage");

		location.href="/admin/community/artist/list?currentPage=" + currentPage+"&searchType="+ searchType +"&searchWord=" + searchWord;
	})
});
</script>
</html>