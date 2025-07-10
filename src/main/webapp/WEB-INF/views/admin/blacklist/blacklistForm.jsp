<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>블랙리스트 관리 - DDTOWN 관리자</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .current-info {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border: 1px solid #eee;
            border-radius: 6px;
            font-size: 0.95em;
        }
        .current-info strong {
            color: #333;
        }
        .emp-form .form-group textarea#blacklistReasonText {
            min-height: 150px;
        }

 /* 신고내역  */
        .report-details-box {
    background-color: #ffffff;
    border: 1px solid #e0e0e0; /* 연한 테두리 */
    border-radius: 8px; /* 둥근 모서리 */
    padding: 25px 30px; /* 내부 여백 */
    margin-bottom: 20px; /* 아래 섹션과의 간격 */
    box-shadow: 0 1px 3px rgba(0,0,0,0.05); /* 은은한 그림자 */
}

.report-details-box h2 {
    font-size: 1.4em; /* 제목 폰트 크기 */
    color: #333;
    margin: 0 0 25px 0; /* 제목 아래 간격 */
    font-weight: 600; /* 약간 굵게 */
    padding-bottom: 20px;
    border-bottom: 1px solid #f0f0f0; /* 제목 아래 구분선 */
}

/* ---------------------------------------------------- */
/* 여기가 핵심 변경/추가 부분입니다!              */
/* ---------------------------------------------------- */

/* 새로운 2열 레이아웃을 위한 컨테이너 (info-item-half들을 감쌈) */
.report-details-box .info-row {
    display: flex; /* 내부 info-item-half들을 가로로 나열 */
    gap: 20px; /* info-item-half들 사이의 가로 간격 */
    margin-bottom: 15px; /* info-row 아래 간격 */
}
/* 마지막 info-row의 하단 마진을 줄여 다음 섹션과의 간격을 조정 (선택 사항) */
.report-details-box .info-row:last-of-type {
    margin-bottom: 5px;
}


/* 각 정보 항목 (신고 번호, 유형 등) - info-row 안에서 절반씩 차지 */
/* HTML에 info-item-half 클래스가 있으므로, 이 클래스에 스타일을 적용합니다. */
.report-details-box .info-item-half {
    flex: 1; /* info-row 안에서 가로 공간을 균등하게 분배 */
    display: grid; /* 라벨과 값을 정렬하기 위한 Grid */
    grid-template-columns: 80px 1fr; /* 라벨(80px)과 값(나머지)의 열 너비 (조정 가능) */
    gap: 0 10px; /* 라벨과 값 사이의 간격 */
    font-size: 1em;
    color: #333;
    align-items: baseline; /* 텍스트 베이스라인 정렬 */
    /* 기존 info-item의 마진바텀이 info-row에 의해 대체되므로 필요 없습니다. */
    margin-bottom: 0;
}

/* 기존 info-item 스타일은 '신고 내용' 부분에만 적용되도록 유지. */
/* HTML에서 '신고 내용'은 <div class="info-item content"> 이므로, 이 스타일은 그대로 둡니다. */
.report-details-box .info-item { /* 각 정보 항목 (신고 번호, 유형 등) */
    /* 위에 info-item-half가 flex:1을 가졌으니, info-item은 full-width 스타일로만 작동하도록 재정의 */
    display: grid; /* Grid 레이아웃 사용 */
    grid-template-columns: 80px 1fr; /* 라벨과 값의 열 너비 (info-item-half와 동일하게 80px로 변경) */
    gap: 0 10px; /* 행과 열 사이 간격 */
    margin-bottom: 15px; /* 각 정보 항목 아래 간격 */
    font-size: 1em;
    color: #333;
    align-items: baseline; /* 텍스트 베이스라인 정렬 */
}

/* 라벨 (strong) 스타일 - info-item-half와 info-item에 공통 적용 */
.report-details-box .info-item-half strong,
.report-details-box .info-item strong { /* .info-item.content에도 적용되도록 포함 */
    grid-column: 1; /* 첫 번째 열에 라벨 배치 */
    text-align: right; /* 라벨 오른쪽 정렬 */
    padding-right: 10px;
    color: #555;
    font-weight: normal; /* 이미지의 "대상 회원 ID" 라벨과 유사하게 */
}

/* 값 (span) 스타일 - info-item-half와 info-item에 공통 적용 */
.report-details-box .info-item-half span,
.report-details-box .info-item span { /* .info-item.content에도 적용되도록 포함 */
    grid-column: 2; /* 두 번째 열에 값 배치 */
    word-break: break-word; /* 긴 내용 줄바꿈 */
}

/* '신고 내용' 부분 (info-item에 content 클래스 추가된 경우) */
.report-details-box .info-item.content span {
    border: 1px solid #e0e0e0; /* 테두리 */
    padding: 10px; /* 패딩 */
    border-radius: 5px; /* 둥근 모서리 */
    background-color: #f8f8f8; /* 배경색 */
    min-height: 80px; /* 최소 높이 */
}

/* ---------------------------------------------------- */
/* 핵심 변경/추가 부분 끝                      */
/* ---------------------------------------------------- */

.report-details-box .image-section-title { /* '이미지' 라벨 */
    display: block;
    font-size: 1em; /* 이미지 라벨 폰트 크기 */
    color: #555;
    margin-top: 25px; /* 위쪽 항목과의 간격 */
    margin-bottom: 10px; /* 이미지 목록과의 간격 */
    font-weight: bold;
    padding-top: 20px;
    border-top: 1px solid #f0f0f0; /* 상단 구분선 */
}

.report-details-box .mailbox-attachments {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    flex-wrap: wrap;
    gap: 10px; /* 이미지 간 간격 */
}

.report-details-box .mailbox-attachments li {
    border: 1px solid #e0e0e0; /* 이미지 테두리 */
    border-radius: 5px;
    padding: 5px;
    background-color: #fdfdfd;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
}

.report-details-box .mailbox-attachment-icon img {
    max-width: 100px;
    height: auto;
    display: block;
    border-radius: 3px;
}

.report-details-box .no-image-message {
    color: #777;
    font-style: italic;
    font-size: 0.9em;
    margin-top: 5px; /* 라벨과의 간격 */
}
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
            <main class="emp-content" style="font-size: large;">
            <!-- 네비게이션 바 -->
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
					  <li class="breadcrumb-item location"><a href="/admin/community/blacklist/list" style="color:black;">블랙리스트 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">등록</li>
					</ol>
				</nav>
                <section id="blacklistReasonFormSection" class="ea-section active-section">
                    <div class="ea-section-header">
                        <h2 id="blacklistFormTitle">블랙리스트 등록</h2>
                        <button type="button" class="ea-btn primary" id="signupBtn" style="margin-left: auto;">저장</button>&nbsp;
                        <a href="/admin/community/blacklist/list" class="ea-btn outline" style="float: right;">취소</a>
                    </div>
					<form class="apply-form" action="/admin/community/blacklist/signup" method="post" id="signupForm">
						<sec:csrfInput/>
	                    <div class="current-info">
	                        <p>
	                        	<strong>대상 회원 ID:</strong>
	                        	<input type="text" id="memUsername" name="memUsername" value="${not empty memUsername ? memUsername : report.targetMemUsername}"  style="width: 200px;">
	                        </p>
	                        <p>
	                        	<strong>현재 지정 사유:</strong>
	                          	<select id="banReasonCode" name="banReasonCode" class="am-filter-select" style="width: 200px;">
	                          		<option value="">전체</option>
	                          		<option value="BRC001">스팸</option>
	                          		<option value="BRC002">욕설</option>
	                          		<option value="BRC003">음란물</option>
	                          		<option value="BRC004">기타</option>
	                   			</select>
	                        </p>
	                    </div>

	                    <form class="ea-form" id="blacklistReasonForm">
	                        <input type="hidden" id="blacklistRecordId" name="blacklistRecordId">
	                        <input type="hidden" id="targetMemberIdHidden" name="targetMemberId">

	                        <div class="form-group">
	                            <label for="blacklistReasonText">상세 사유</label>
	                            <textarea id="banReasonDetail" name="banReasonDetail" placeholder="상세 사유를 자세히 작성해주세요." required style="width: 100%;"></textarea>
	                        </div>

	                        <div class="form-group-group" style="display: flex; gap: 16px; align-items: flex-end;">
	                            <div class="form-group" style="flex:1;">
	                                <label for="blacklistReleaseDate">해제 예정일 (선택)</label>
	                                <input type="date" id="banEndDate" name="banEndDate" value="${blacklist.banEndDate }">
	                            </div>
	                            <div class="form-group" style="flex:1;">
	                                <label for="blacklistScope">블랙리스트</label>
	                                <select id="blacklistScope" name="blacklistScope">
	                                	<option value="">기간 선택</option>
	                                    <option value="7">7일</option>
	                                    <option value="30">30일</option>
	                                    <option value="90">90일</option>
	                                    <option value="180">180일</option>
	                                    <option value="900y">영구</option>
	                                </select>
	                            </div>
	                        </div>
	                        <p class="help-text">특정 날짜에 자동으로 해제되도록 설정할 수 있습니다. 비워두면 수동 해제 전까지 유지됩니다.</p>
	                    </form>
                    </form>
                </section>
       <!-- 신고내역 관련 -->
                <c:if test="${not empty report}">
	                <div class="report-details-box" style="white-space: nowrap;">
					    <h2>해당 신고 내역</h2>

					    <div class="info-row">
				            <div class="info-item-half">
				                <strong>신고 번호:</strong> <span>${report.reportNo}</span>
				            </div>
				            <div class="info-item-half">
				                <strong>신고 날짜:</strong> <span>${report.reportRegDate }</span>
				            </div>
				        </div>

					   <div class="info-row">
				            <div class="info-item-half">
				                <strong>신고 유형:</strong> <span>
				                    <c:choose>
				                        <c:when test="${report.reportTargetTypeCode eq 'RTTC001'}">게시글</c:when>
				                        <c:when test="${report.reportTargetTypeCode eq 'RTTC002'}">댓글</c:when>
				                        <c:when test="${report.reportTargetTypeCode eq 'RTTC003'}">채팅</c:when>
				                        <c:otherwise>알 수 없음</c:otherwise>
				                    </c:choose>
				                </span>
				            </div>
				            <div class="info-item-half">
				                <strong>신고 사유:</strong> <span>
				                    <c:choose>
				                        <c:when test="${report.reportReasonCode eq 'RRC001'}">스팸</c:when>
				                        <c:when test="${report.reportReasonCode eq 'RRC002'}">욕설</c:when>
				                        <c:when test="${report.reportReasonCode eq 'RRC003'}">음란물</c:when>
				                        <c:when test="${report.reportReasonCode eq 'RRC004'}">기타</c:when>
				                        <c:otherwise>알 수 없음</c:otherwise>
				                    </c:choose>
				                </span>
				            </div>
				        </div>

					    <div class="info-item content"> <strong>신고 내용:</strong> <span>${report.reportedContent}</span>
					    </div>
					     <c:if test="${not empty report.fileList}">
						    <p class="image-section-title">첨부 이미지:</p> <ul class="mailbox-attachments">
						        <c:choose>
						            <c:when test="${not empty report.fileList}">
						                <c:forEach var="file" items="${report.fileList}">
						                    <li>
						                        <span class="mailbox-attachment-icon">
						                            <img width="100px" src="${file.webPath}" alt="신고된 이미지"/>
						                        </span>
						                    </li>
						                </c:forEach>
						            </c:when>
						            <c:otherwise>
						                <p class="no-image-message">첨부된 이미지가 없습니다.</p>
						            </c:otherwise>
						        </c:choose>
					        </c:if>
					    </ul>
					</div>
				</c:if>
            </main>
        </div>
    </div>

<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
 <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js"></script>
 <script>
 function sweetAlert(type, msg){
	    Swal.fire({
	        title : msg,
	        icon : type,
	        draggable : true
	    });
	}
  // 날짜 드롭박스 선택 이벤트
  $(document).ready(function(){
	  $('#blacklistScope').on('change', function(){
		  var selectedDays = $(this).val();	//선택된 값
		  var banEndDateInput = $('#banEndDate');


		  if (selectedDays === '900y'){		//영구 선택시
			  banEndDateInput.val('9999-12-31');
			  banEndDateInput.prop('readonly', true);
			  banEndDateInput.prop('disabled', false);
		  } else if (selectedDays && selectedDays !== 'manual'){ //영구가 아닐 시
			  var today = new Date();	//오늘날짜 객체 생성
			  var futureDate = new Date();	//해제날짜 객체 생성

			  futureDate.setDate(today.getDate() + parseInt(selectedDays));

			// YYYY-MM-DD 형식으로 변환
              var year = futureDate.getFullYear();
              var month = (futureDate.getMonth() + 1).toString().padStart(2, '0');
              var day = futureDate.getDate().toString().padStart(2, '0');

              var formattedDate = year + '-' + month + '-' + day;

              banEndDateInput.val(formattedDate); // 계산된 날짜를 input에 설정
              banEndDateInput.prop('readonly', false); // readonly 해제
              banEndDateInput.prop('disabled', false); // disabled는 false로 유지 (확실히 활성화)
          } else {										// 기본 "기간 선택" 옵션 또는 기타 선택 시
              banEndDateInput.val(''); // 날짜 비우기
              banEndDateInput.prop('readonly', false); // readonly 해제
              banEndDateInput.prop('disabled', false); // 사용자가 직접 입력할 수 있도록 활성화
          }

	  })
	  $('#blacklistScope').trigger('change');


  })
// 등록하기
$(function(){
	let signupBtn = $("#signupBtn");			//등록하기 Element
	let signupForm = $("#signupForm");			//등록하기 Form

	signupBtn.on("click", function(e){
		let memUsername = $("#memUsername").val();
		let banReasonCode = $("#banReasonCode").val();
		let banReasonDetail = $("#banReasonDetail").val();
		let banEndDate = $("#banEndDate").val();

		// 유효성 검사
		if (memUsername == null || memUsername === "") {
	        sweetAlert("error", "회원아이디를 입력하여주세요"); // Swal.fire 대신 sweetAlert 함수 사용
	        $("#memUsername").focus();
	        return false;
	    }
		if (banReasonCode == null || banReasonCode === "") {
	        sweetAlert("error", "지정 사유를 선택하여주세요"); // Swal.fire 대신 sweetAlert 함수 사용
	        $("#banReasonCode").focus();
	        return false;
	    }
		if (banReasonDetail == null || banReasonDetail === "") {
	        sweetAlert("error", "상세 내용을 입력하여주세요"); // Swal.fire 대신 sweetAlert 함수 사용
	        $("#banReasonDetail").focus();
	        return false;
	    }
		 if (banEndDate === "" && $("#blacklistScope").val() !== "null") {
            sweetAlert("error", "해제 예정일을 선택하거나 '영구'를 선택하여주세요"); // Swal.fire 대신 sweetAlert 함수 사용
            $("#banEndDate").focus();
            return false;
        }

// 		console.log("--- 추가 등록/수정 값 확인 (console.log) ---");
// 	    console.log("신고당한 사람 (memUsername):", memUsername);
// 	    console.log("사유 (banReasonCode):", banReasonCode);
// 	    console.log("상세사유 (banReasonDetail):", banReasonDetail);
// 	    console.log("해제일 (banEndDate):", banEndDate);

	    signupForm.submit();	//폼 제출
	})
})

</script>
</body>
</html>