<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신고 관리 - DDTOWN 관리자</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
     <style>
        .report-detail-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 25px; }
        .report-main-content, .report-processing-panel { background-color: #fff; border: 1px solid #e7eaf3; border-radius: 8px; padding: 25px; box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
        .report-main-content h3, .report-processing-panel h3 { font-size: 1.3em; color: #2c3e50; margin-top: 0; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #eee; }
        .report-info-section dt { font-weight: 500; color: #555; width: 100px; float: left; clear: left; margin-bottom: 10px; }
        .report-info-section dd { margin-left: 110px; margin-bottom: 10px; color: #333; }
        .report-content-preview { border: 1px solid #eee; padding: 15px; border-radius: 4px; background-color: #f9f9f9; margin-top: 10px; min-height: 80px; line-height: 1.6; }
        .report-content-preview img { max-width: 100%; margin-top: 10px; border-radius: 4px; }

        .form-group {
		    /* flexbox를 사용하여 내부 요소들을 한 줄에 나란히 배치 */
		    display: flex;
		    flex-wrap: wrap; /* 공간 부족 시 다음 줄로 넘어가도록 허용 */
		    gap: 15px; /* 라디오 버튼들 사이의 간격 */
		    align-items: center; /* 세로 중앙 정렬 */
		    text-align: center;
		}
	/*
 * Post Detail Modal Styles
 * 게시글 상세 모달 스타일
 */

/* 모달 컨텐츠 중앙 정렬 및 기본 레이아웃 설정 */
#detailPostModal .modal-content {
    width: 1500px;
    min-width: 1500px;
    min-height: 700px;
    margin: auto; /* 화면 중앙에 모달 위치 */
    display: flex; /* flex 컨테이너로 설정 */
    flex-direction: column; /* 자식 요소들을 세로로 정렬 */
}

/* 모달 바디: flex 컨테이너로 설정하여 post-pane과 comment-pane이 가로로 나열되도록 함 */
#detailPostModal .modal-body {
    padding: 0;
    flex-grow: 1; /* 남은 공간을 채우도록 함 */
    /* post-pane과 comment-pane 사이의 전체 여백을 조절하기 위해 justify-content: space-between; 또는 space-around 사용 고려 */
    /* 예: justify-content: space-between; */
}

/* 게시글 내용 영역 (왼쪽) */
#detailPostModal .post-pane {
    /* 기존 width: calc(100% - 350px)는 comment-pane의 width와 정확히 맞춰진 경우
       comment-pane에 margin-left를 주면서 post-pane이 자연스럽게 넓어지도록
       flex-grow: 1을 사용하여 남은 공간을 모두 차지하게 할 수 있습니다. */
    width: auto; /* width를 auto로 변경하거나 100%로 설정하고 flex-grow 사용 */
    flex-grow: 1; /* 남은 모든 공간을 차지 */
    overflow-y: auto; /* 내용이 넘치면 스크롤 */
    flex-shrink: 0; /* 공간이 부족해도 줄어들지 않음 */
    background-color: #fff; /* 흰색 배경 */
    display: flex; /* 내부 요소들을 flex로 정렬 */
    flex-direction: column; /* 내부 요소들을 세로로 정렬 */
}

/* 댓글 영역 (오른쪽) */
#detailPostModal .comment-pane {
    width: 350px; /* 고정 너비 */
    flex-shrink: 0; /* 공간이 부족해도 줄어들지 않음 */
    display: flex; /* 내부 요소들을 flex로 정렬 */
    flex-direction: column; /* 내부 요소들을 세로로 정렬 */
    border-left: 1px solid #eee; /* 왼쪽 경계선 */
    background-color: #f8f9fa; /* 연한 배경색 */
    /* 이곳에 margin-left를 추가하여 comment-pane을 오른쪽으로 이동 */
    margin-left: 20px; /* 20px의 여백 추가, 필요에 따라 이 값을 조절하세요 */
}

/* 게시글 헤더 (작성자 정보 등) */
#detailPostModal .post-pane-header {
    padding: 15px 20px;
    border-bottom: 1px solid #eee;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

#detailPostModal .post-pane-header .comment-avatar {
    width: 60px;
    height: 60px;
    object-fit: cover; /* 이미지가 잘리지 않고 채워지도록 */
}

#detailPostModal .post-pane-header .ms-3 {
    margin-left: 1rem !important; /* Bootstrap ms-2보다 더 큰 간격 */
}

/* 게시글 본문 내용 (이미지, 텍스트) */
#detailPostModal .post-pane-body {
    padding: 20px;
    height: calc(100% - 120px); /* 헤더와 푸터 높이를 제외한 나머지 공간 */
    overflow-y: auto; /* 내용이 넘치면 스크롤 */
    display: flex;
    flex-direction: column;
    align-items: center; /* 수평 중앙 정렬 */
    justify-content: flex-start; /* 수직 상단 정렬 */
}

#detailPostModal .post-pane-body img {
    max-width: 100%; /* 부모 요소의 너비를 넘지 않도록 */
    height: auto; /* 가로 세로 비율 유지 */
    border-radius: 10px;
    margin-bottom: 15px; /* 이미지 하단 여백 */
}

#detailPostModal .post-pane-body p {
    white-space: pre-wrap; /* 공백과 줄바꿈 유지 */
    word-wrap: break-word; /* 긴 단어가 잘리지 않고 줄바꿈 */
    text-align: left; /* 텍스트 왼쪽 정렬 */
    width: 100%; /* 본문 텍스트가 너비 꽉 채우도록 */
    margin-top: 10px; /* 텍스트 상단 여백 */
    margin-bottom: 0; /* 기본 마진 제거 */
}

/* 댓글창 헤더 */
#detailPostModal .comment-pane-header {
    width: 100%;
    height: 54px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-bottom: 1px solid #eee;
    background-color: #fff;
}

#detailPostModal .comment-pane-header strong {
    font-size: 1.1em;
}

/* 댓글 목록 바디 */
#detailPostModal .comment-pane-body {
    width: 100%;
    flex-grow: 1; /* 남은 세로 공간을 모두 채움 */
    background-color: #F2F2F2; /* 연한 회색 배경 */
    overflow-y: auto; /* 내용이 넘치면 스크롤 */
    padding: 10px;
}

/* 댓글 개별 아이템 */
#detailPostModal .comment-item {
    padding: 10px 5px; /* 상하 10px, 좌우 5px 패딩 */
    margin-bottom: 15px; /* 댓글 아이템 간 간격 */
}

#detailPostModal .comment-item:last-child {
    margin-bottom: 0; /* 마지막 댓글 아이템은 하단 마진 없음 */
}

#detailPostModal .comment-item .comment-user-info {
    display: flex;
    align-items: flex-start; /* 프로필 이미지와 텍스트 상단 정렬 */
    gap: 8px; /* 요소 간 간격 */
}

#detailPostModal .comment-item .comment-avatar {
    width: 30px;
    height: 30px;
    object-fit: cover;
    flex-shrink: 0; /* 줄어들지 않음 */
    border-radius: 50%;
}

#detailPostModal .comment-item .comment-main-wrapper {
    flex-grow: 1; /* 남은 공간을 차지 */
}

#detailPostModal .comment-item .comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 5px; /* 헤더와 본문 사이 간격 */
}

#detailPostModal .comment-item .comment-header strong {
    font-size: 0.95em;
    color: #333;
}

#detailPostModal .comment-item .comment-body-text p {
    margin-bottom: 5px; /* 내용과 시간 사이 간격 */
    font-size: 0.9em;
    color: #555;
    white-space: pre-wrap; /* 공백과 줄바꿈 유지 */
    word-wrap: break-word; /* 긴 단어가 잘리지 않고 줄바꿈 */
}

#detailPostModal .comment-item .comment-body-text small {
    font-size: 0.8em;
    color: #888;
}

    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
            <main class="emp-content">
            	<!-- 네비게이션 바 -->
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
					  <li class="breadcrumb-item location"><a href="/admin/community/report/list" style="color:black;">신고 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">상세</li>
					</ol>
				</nav>
                <section id="reportDetailSection" class="ea-section active-section" style="font-size: 21px;">
                    <div class="ea-section-header">
                        <h2 id="reportDetailTitle">신고 내용 상세</h2>
                    </div>
                    <div class="report-detail-grid">
                        <div class="report-main-content">
                            <h3>신고 정보</h3>
                            <dl class="report-info-section">
                            <input type="hidden" id="targetComuPostNo" name="targetComuPostNo" value="${report.targetComuPostNo}" />
                            <input type="hidden" id="targetComuReplyNo" name="targetComuReplyNo" value="${report.targetComuReplyNo}" />
                            <input type="hidden" id="targetChatNo" name="targetChatNo" value="${report.targetChatNo}" />
                            <input type="hidden" id="targetMemUsername" name="targetMemUsername" value="${report.targetMemUsername}" />
                            <input type="hidden" id="artGroupNo" name="artGroupNo" value="${report.artGroupNo}" />
                                <dt>신고 번호:</dt><dd id="reportNo">${report.reportNo }</dd>
                                <dt>신고 유형:</dt>
                                <dd id="reportTargetTypeCodeName">
                                	<c:choose>
                                		<c:when test="${report.reportTargetTypeCode eq 'RTTC001'}">게시글</c:when>
                                		<c:when test="${report.reportTargetTypeCode eq 'RTTC002'}">댓글</c:when>
                                		<c:when test="${report.reportTargetTypeCode eq 'RTTC003'}">채팅</c:when>
                                	</c:choose>
	                            </dd>
	                            <input type="hidden" id="reportTargetTypeCode" value="${report.reportTargetTypeCode}" />
                                <dt>신고 대상:</dt><dd id="detailReportedTarget">${report.targetMemUsername } (${report.peoLastNm}${report.peoFirstNm})</dd>
                                <dt>신고자:</dt><dd id="reported-writer">${report.memUsername }</dd>
                                <dt>신고일:</dt><dd id="detailReportDate">${report.reportRegDate }</dd>
                                <dt>처리 상태:</dt>
                                <dd>
                                	<span class="report-status-badge new" id="detailReportStatus">
	                                	<c:choose>
	                                			<c:when test="${report.reportStatCode eq 'RSC001'}">접수됨</c:when>
				                       			<c:when test="${report.reportStatCode eq 'RSC002'}">처리 완료</c:when>
	                                	</c:choose>
                                	</span>
                                </dd>
                                <input type="hidden" id="reportStatusCodeName" value="${report.reportStatCode}" />
                                <dt>신고 사유</dt>
                                <dd>
                                	<c:choose>
                                			<c:when test="${report.reportReasonCode eq 'RRC001'}">스팸</c:when>
			                       			<c:when test="${report.reportReasonCode eq 'RRC002'}">욕설</c:when>
			                       			<c:when test="${report.reportReasonCode eq 'RRC003'}">음란물</c:when>
			                       			<c:when test="${report.reportReasonCode eq 'RRC004'}">기타</c:when>
                                	</c:choose>
                                </dd>
                                <dt>작성 내용:</dt><dd id="detailReportDate"> ${report.reportedContent}</dd>
                            </dl>
                            <ul class="mailbox-attachments d-flex flex-wrap align-items-stretch clearfix">
	                             <c:choose>
	                             	<c:when test="${not empty report.fileList}">
		                             	 <c:forEach var="file" items="${report.fileList}">
		                             	 	<li style="margin-right: 10px; margin-bottom: 10px;">
			                             	 	<span class="mailbox-attachment-icon">
			                                		<img width="100px" src="${file.webPath}" alt="신고된 이미지"/>
			                            		</span>
			                            	</li>
			                            </c:forEach>
	               				 	</c:when>
               					</c:choose>
               				</ul>
               				</br>
               				<c:if test="${report.reportTargetTypeCode ne 'RTTC003'}">
               				<button type="button" id="goBtn" class="ea-btn primary openPostModal" data-postNum="${report.targetComuPostNo}"
               						 data-post-id="${report.targetComuPostNo}" data-reply-id="${report.targetComuReplyNo}"
               				 		data-chat-id="${report.targetChatNo}" data-type="${report.reportTargetTypeCode}" data-parent-post-id="${report.targetComuPostNo}"
               				 		 data-apt-group-no="${report.artGroupNo}">게시물 보기
               				</button>
							</c:if>
                        </div>
                        <div class="report-processing-panel">
                            <h3>신고 처리</h3>
                            <form id="reportProcessForm" class="ea-form">
                                <div class="form-group">
                                    <input type="radio" id="rrtcDelete" name="reportResultCode" value="RRTC002" ${report.reportResultCode == 'RRTC002' ? 'checked' : ''}">
                                    <label for="rrtcDelete">콘텐츠 삭제</label>
                                    <input type="radio" id="rrtcNoAction" name="reportResultCode" value="RRTC001" ${report.reportResultCode == 'RRTC001' ? 'checked' : ''}">
                                    <label for="rrtcNoAction">조치 없음</label>
                                </div>
                                <input type="hidden" id="currentReportResultCode" value="${report.reportResultCode}" />
                                <div class="ea-form-actions" style="text-align:left;">
                                    <button type="submit" id="TreatBtn" class="ea-btn primary">처리 하기</button>
                                </div>
                            </form>
                            <hr style="margin:25px 0;">
                            <h4>신고 누적 회원 조치</h4>
                            <p id="reportedUserAccumulatedInfo" style="font-size:0.9em; margin-bottom:10px;">
                                신고 대상 회원 (<strong id="reportedUserIdDisplay">${report.targetMemUsername }</strong>) 누적 신고 횟수: <strong id="reportedUserTotalReports">${report.reportedCount }</strong>회
                            </p>
                            <div id="reportersListContainer" style="max-height: 120px; overflow-y: auto; border: 1px solid #eee; padding: 8px; border-radius: 5px; background-color: #f9f9f9; margin-bottom: 15px;">
							    <strong>신고자 목록(사유):</strong>
							    <c:if test="${not empty report.individualReportList}">
							        <c:forEach var="individualReport" items="${report.individualReportList}" varStatus="status">
							            ${individualReport.memUsername} (
								            <c:choose>
	                                			<c:when test="${individualReport.reportReasonCode eq 'RRC001'}">스팸</c:when>
				                       			<c:when test="${individualReport.reportReasonCode eq 'RRC002'}">욕설</c:when>
				                       			<c:when test="${individualReport.reportReasonCode eq 'RRC003'}">음란물</c:when>
				                       			<c:when test="${individualReport.reportReasonCode eq 'RRC004'}">기타</c:when>
	                                		</c:choose>
							            )<c:if test="${!status.last}">, </c:if>
							        </c:forEach>
							    </c:if>
							</div>
                            <button class="ea-btn danger sm" id="forceAddToBlacklistBtn" name="forceAddToBlacklistBtn">즉시 블랙리스트 추가</button>
                            <a href="/admin/community/report/list" class="ea-btn outline sm" style="float: right;"><i class="fas fa-list" ></i> 목록</a>
                        </div>
                    </div>
                </section>
            </main>
        </div>
    </div>

   <!-- 포스트 상세 모달 ver2 -->
	<div class="modal fade" id="detailPostModal" tabindex="-1" aria-hidden="true">
	    <div class="modal-dialog modal-fullscreen-custom">
	    	<div class="modal-close-wrapper"> 
			<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
	        <div class="modal-content" style="width:1500px;min-width:1500px;min-height:700px;margin-left:-500px;">
	            <div class="modal-body p-0">
	                <div class="d-flex h-100">

	                    <div class="post-pane" id="postBox" style="width:70%; overflow-y: auto;" >
	                    </div>

	                    <div class="comment-pane">
						    <div class="comment-pane-header" style="width:350px;height:100px;">
						        <strong class="mx-auto" id="replyCount" style="display: block; text-align: center;"></strong>
						    </div>

						    <div class="comment-pane-body" id="replyList" style="width:350px;height:624px;background-color:#F2F2F2; overflow-y: auto;">
						    </div>
						    <div class="comment-pane-footer" style="width:350px;height:66px;">
						    	<form action="/community/reply/insert" method="get" id="replyForm">
									<input type="hidden" id="boardTypeCode" name="boardTypeCode" />
									<input type="hidden" id="comuPostNo" name="comuPostNo" />
									<input type="hidden" id="artGroupNo" name="artGroupNo" value="${artistGroupVO.artGroupNo }" />
<!-- 								    <div class="input-group">
							        	<textarea id="comuReplyContent" onkeyup="replyContentLengthCheck(this)" name="comuReplyContent" class="form-control" placeholder="댓글을 입력하세요." aria-label="댓글 입력" rows="1" style="resize: none;"></textarea>
							        	<button class="btn btn-primary" type="button" id="replyBtn">등록</button>
								    </div> -->
								</form>
							</div>
							<!-- <div class="text-right pt-2" style="width:350px;height:29px;">
								<span class="pt-1"><span class="cmt-sub-size">0</span>/300</span>
							</div> -->
						</div>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>

    <script>
    const postModal = $("#postModal"); // 해당 포스트 혹은 댓글이달린 원본글을 보여줄 모달
	const postUpdateModal = $("#postUpdateModal"); // 해당 포스트 혹은 댓글이달린 원본글을 보여줄 모달
	const detailBox = $(".detailBox"); // 자신이 쓴 글이나 댓글 div
	const commentSubmitBtn = $("#commentSubmitBtn");

 	let goBtn = $("#goBtn");	//게시물 바로가기 버튼
    //신고 처리 버튼 클릭
    let TreatBtn = $("#TreatBtn");	//처리완료 버튼
    let reportResultCodeSelect = $("#reportResultCode");	//처리조치 드롭다운

    let reportStatusCodeName = $("#reportStatusCodeName").val();
    let currentReportResultCode = $("#currentReportResultCode").val();

    if (reportStatusCodeName === 'RSC002') {
        TreatBtn.prop('disabled', true); // '처리 완료' 버튼 비활성화
        TreatBtn.text('처리 완료됨');     // 버튼 텍스트 변경
        $('input[name="reportResultCode"]').prop('disabled', true);

        if (currentReportResultCode) {
            // currentReportResultCode 값에 따라 해당 라디오 버튼을 선택 상태로 설정
        	$(`input[name="reportResultCode"][value="\${currentReportResultCode}"]`).prop('checked', true);
            const selectedRadioValueAfterProcessing = $('input[name="reportResultCode"]:checked').val();
        }
    }
 	// 날짜 포맷팅 함수
	function padTwoDigits(num) {
	  return num.toString().padStart(2, "0");
	}

    /**
	* 시간.분.초 형식으로 바꾸기 (예: 2024.01.01 10:30)
	*/
	function getFormattedDate(time) {
	  const date = new Date(time);

	  return (
	    [
	      date.getFullYear(),
	      padTwoDigits(date.getMonth() + 1),
	      padTwoDigits(date.getDate()),
	    ].join(".") +
	    " " +
	    [
	      padTwoDigits(date.getHours()),
	      padTwoDigits(date.getMinutes())
	    ].join(":")
	  );
	}

    /**
	* 게시글 모달을 띄우고 내용 불러오는 공통 함수
	*/
	function displayPostModal(comuPostNo){

// 			url : `/api/community/getPost?comuPostNo=\${comuPostNo}&myComuProfileNo=${myComuProfileNo}`,

		$.ajax({
			url : `/api/community/getPost?comuPostNo=\${comuPostNo}`,
			type : "get",
			success : function(postVO){
				$("#boardTypeCode").val(postVO.boardTypeCode);
				$("#comuPostNo").val(comuPostNo);
				$("#artGroupNo").val(postVO.artGroupNo);
				let {artGroupNo, comuPostContent, writerProfile,
					comuPostLike, comuPostReplyCount, comuPostReplyList,
					postFiles, comuPostRegDate, likeYn, comuProfileNo,
					comuPostModDate, fileGroupNo, boardTypeCode} = postVO;


				// 본문 영역
				let postHtml = ``;
				postHtml = `
					<div class="post-pane-header">
	                	<div class="d-flex align-items-center">
	                        <img src="\${writerProfile.comuProfileImg}" class="rounded-circle comment-avatar" style="width: 60px; height: 60px;" >
	                        <div class="ms-2">&nbsp;
	                        <strong class="d-block">\${writerProfile.comuNicknm}</strong>
	                            <small class="text-muted">\${getFormattedDate(comuPostModDate)}</small>
	                        </div>
	                	</div>
	                	<div class="dropdown">
					        <button class="btn btn-link text-secondary p-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
					            <i class="bi bi-three-dots-vertical"></i>
					        </button>
					        <ul class="dropdown-menu"
					`;
				if(writerProfile.comuProfileNo == "${myComuProfileNo}"){
					postHtml += `
						<li><button class="dropdown-item postUpdateBtn" data-bs-toggle="modal"
							data-bs-target="#postUpdateModal"
							data-comu-post-no="\${comuPostNo}"
							data-comu-post-content="\${comuPostContent}"
							data-file-group-no="\${fileGroupNo}"
							>수정</button></li>
			            <li><button class="dropdown-item text-danger postDeleteBtn" data-comu-post-no="\${comuPostNo}" >삭제</button></li>
					`;
				}else{
					postHtml += `
						<li><button class="dropdown-item text-danger postReportBtn" data-comu-post-no="\${comuPostNo}"
							data-bs-toggle="modal"
							data-bs-target="#reportModal"
							data-bs-comuPostNo="\${comuPostNo}"
							data-bs-boardType="\${boardTypeCode}"
							data-bs-comuProfileNo="\${writerProfile.comuProfileNo}"
							data-bs-comuNick="\${writerProfile.comuNicknm}"
							data-bs-comuContent="\${comuPostContent}"
							data-bs-selectType="RTTC001"
							>신고</button>
						</li>
					`;
				}
				postHtml += `
					        </ul>
					    </div>
	                </div>
	                <div class="post-pane-body" style="padding:10px; width: 800px; height: 650px;">
	                `;
           		// 파일 컨테이너는 이제 이 함수 내부에서 지역변수로 사용. 전역 변수 Map은 불필요.
	            if(postFiles != null && postFiles.length > 0){
	            	for(let i in postFiles){
	            		let file = postFiles[i];
	            		postHtml += `
	            			<img src="\${file.webPath}" alt="\${file.fileOriginalNm}" width="50%" style="border-radius:10px;">
	            		`;
	            	}
	            }
	            postHtml += `
	                	<p>\${comuPostContent}<p>
	                </div>
	                <div class="post-pane-footer">
	                `;
	            if(likeYn == 'Y'){
	            postHtml += `
					    <button type="button" class="btn btn-like active" data-comu-post-no="\${comuPostNo}" data-comu-profile-no="${myComuProfileNo}"
					    data-board-type-code="\${boardTypeCode}" data-art-group-no="\${artGroupNo}" data-like-yn="\${likeYn}" id="likeButton">
					        <i class="bi bi-heart-fill"></i>
					    </button>
	            	`;
	            }else{
	            	postHtml += `
					    <button type="button" class="btn btn-like" data-comu-post-no="\${comuPostNo}" data-comu-profile-no="${myComuProfileNo}"
					    	data-board-type-code="\${boardTypeCode}" data-art-group-no="\${artGroupNo}" data-like-yn="\${likeYn}" id="likeButton">
					        <i class="bi bi-heart"></i>
					    </button>
	            	`;
	            }
	            postHtml +=`
					</div>
				`;

				$("#postBox").html(postHtml);

				$("#replyCount").html("답글 " + comuPostReplyCount + "개");

				// 댓글 영역
				let replyHtml = ``;
				for(let reply of comuPostReplyList){
					let {comuReplyContent, boardTypeCode:replyBoardTypeCode, comuReplyRegDate, comuReplyNo, replyMember, comuReplyModDate, comuReplyDelYn} = reply;
					let {comuProfileImg, comuNicknm, comuProfileNo:replyComuProfileNo} = replyMember;
						replyHtml += `
							<div class="comment-item" style="padding-left: 10px;">
								<div class="comment-user-info" style="display: flex; align-items: center; gap: 8px;">
									<img src="\${comuProfileImg}" class="rounded-circle comment-avatar" style="width: 30px; height: 30px;>
				            	<div class="comment-main-wrapper">
				            		<div class="comment-header">
				            			<strong>\${comuNicknm}</strong>
				            	</div>			
	            		`;
						replyHtml +=`
		            		<div class="dropdown">
						        <button class="btn btn-link text-secondary p-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
						            <i class="bi bi-three-dots-vertical"></i>
						        </button>
						        <ul class="dropdown-menu">
			          	`;
						if("${myComuProfileNo}" == replyComuProfileNo){
							replyHtml += `
					            		<li><button class="dropdown-item text-danger replyDeleteBtn" data-comu-post-no="\${comuPostNo}" data-comu-reply-no="\${comuReplyNo}">삭제</button></li>
					            	</ul>
					            </div>
							`;
						}else{
							replyHtml += `
										<li><button class="dropdown-item text-danger replyReportBtn" data-comu-post-no="\${comuPostNo}" data-comu-reply-no="\${comuReplyNo}"
											data-bs-toggle="modal"
											data-bs-target="#reportModal"
											data-bs-comuPostNo="\${comuPostNo}"
											data-bs-comuReplyNo="\${comuReplyNo}"
											data-bs-boardType="\${replyBoardTypeCode}"
											data-bs-comuProfileNo="\${replyComuProfileNo}"
											data-bs-comuNick="\${comuNicknm}"
											data-bs-comuContent="\${comuReplyContent}"
											data-bs-selectType="RTTC002" >신고</button></li>
									</ul>
					            </div>
							`;
						}
						replyHtml += `
						        </div>
						        <div class="comment-body-text" style="padding-left: 40px;">
					        	<p>\${comuReplyContent}</p>
					        	<small class="text-muted">\${getFormattedDate(comuReplyModDate)}</small>
							        </div>
							    </div>
							</div>
						`;
					}
				$("#replyList").html(replyHtml);
				$("#commentSubmitBtn").data("comu-post-no",comuPostNo);
				postModal.data("replyCountInfo",{
					comuPostNo : comuPostNo,
					replyCount : comuPostReplyCount
				});
			},
			error : function(err){
				console.log(err);
				sweetAlert("error","게시글 정보를 불러오는데 실패했습니다.");
			}
		});//end ajax
		// 이 함수가 호출될 때 URL 해시를 업데이트
// 		window.history.replaceState("", document.title, window.location.pathname + window.location.search + "#post-" + comuPostNo);
	}//end displayPostModal

 $(function(){
	 let detailPostModal = $("#detailPostModal");
	 let forceAddToBlacklistBtn = $("#forceAddToBlacklistBtn");

	 const hash = window.location.hash;

	 let openDetailBtnList = document.querySelectorAll(".openPostModal");	//openPostModal클래스 이름을 가진 모든 html을 openDetailBtnList 변수에 저장
		openDetailBtnList.forEach(div => {
			div.addEventListener("click",function(e){					//클릭시 아래 코드 실행
				e.preventDefault();										//버튼 기본통작 막음
				let detailModal = document.getElementById("detailPostModal");	//detailPostModal(모달창)을 detailModal변수명에 저장
				let myDetailModal = new bootstrap.Modal(detailModal);			//myDetailModal의 이름으로 새로운 모달 변수 생성

				let postNum = e.target.closest(".openPostModal").dataset.postnum;	//클릭된 버튼의 data-postnum데이터 가지고 postNum변수에 저장
				myDetailModal.show(postNum);										//모달을 띄우고 postNum 값 저장

				displayPostModal(postNum)											//게시글 내용을 가져와 표시하는 함수 호출

			});
		});


		forceAddToBlacklistBtn.on("click", function(){
			location.href = "/admin/community/blacklist/form?reportNo=${report.reportNo }";
		})


	//처리하기 버튼
     TreatBtn.on("click", function(event){
     	event.preventDefault();	//폼제출 기본동작 방지

     	let reportNo = $("#reportNo").text();
     	let reportTargetTypeCode = $("#reportTargetTypeCode").val();
     	let reportResultCode = $("input[name='reportResultCode']:checked").val();
     	let targetMemUsername = $("#targetMemUsername").val();

     	let targetComuPostNo = $("#targetComuPostNo").val();
     	let targetComuReplyNo = $("#targetComuReplyNo").val();
     	let targetChatNo = $("#targetChatNo").val();
     	//유효성 검사
     	 if (reportResultCode == null || reportResultCode === "") {
 	        sweetAlert("error", "처리 조치를 선택해주세요!");
 	        return false;
 	    }
     	//보낼 데이터
     	let data = {
	reportNo: reportNo,								//신고번호
	reportTargetTypeCode : reportTargetTypeCode,	//글 유형
	reportResultCode : reportResultCode,			//처리코드
	targetMemUsername : targetMemUsername,
	targetComuPostNo : targetComuPostNo,			//게시글 번호
	targetComuReplyNo : targetComuReplyNo,			//댓글번호
	targetChatNo : targetChatNo						//채팅메세지 번호
     	}

     	$.ajax({
     		url:"/admin/community/report/update",
     		type:"post",
     		data: JSON.stringify(data),
     		contentType: "application/json; charset=utf-8",
     		beforeSend : function(xhr) {
     	    	xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
     	    },
     		success: function(res){
     			if(res == "EXIST"){
     				 Swal.fire({
     			            icon: 'success',
     			            title: '성공적으로 처리되었습니다!',
     			            showConfirmButton: false, // 선택 사항: 확인 버튼 숨기기
     			            timer: 1500 // 선택 사항: 1.5초 후 자동으로 닫기
     			        }).then((result) =>{
     			        	location.reload();
     			     });
     			}else{
     				Swal.fire({
     		            icon: 'error',
     		            title: '처리 실패',
     		            text: res.message || "알 수 없는 오류"
     		        });
     			}
     		}
     	})
     });
 });

    </script>
</body>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
</html>