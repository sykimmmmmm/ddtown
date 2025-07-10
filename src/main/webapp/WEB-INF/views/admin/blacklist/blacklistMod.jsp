<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
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
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
            <main class="emp-content">
                <section id="blacklistReasonFormSection" class="ea-section active-section">
                    <div class="ea-section-header">
                        <h2 id="blacklistFormTitle">블랙리스트 수정</h2>
                        <button type="button" class="ea-btn primary" id="modpBtn" style="margin-left: auto;">저장</button>&nbsp;
                        <a href="/admin/community/blacklist/detail?banNo=${blacklist.banNo }" class="ea-btn outline">취소</a>
                    </div>
					<form class="apply-form" action="/admin/community/blacklist/update" method="post" id="signupForm">
					<input type="hidden" name="banNo" value="${blacklist.banNo}" />
					<input type="hidden" name="memUsername" value="${blacklist.memUsername}" />
						<sec:csrfInput/>
	                    <div class="current-info">
	                        <p>
	                        	<strong>대상 회원 ID:</strong>
	                        	<span id="memUsername">${blacklist.memUsername }</span>
	                        </p>
	                        <p>
	                        	<strong>현재 지정 사유:</strong>
	                          	<select id="banReasonCode" name="banReasonCode" class="am-filter-select" style="width: 200px;">
	                          		<option value="BRC001" ${blacklist.banReasonCode eq 'BRC001' ? 'selected' : ''}>스팸</option>
									<option value="BRC002" ${blacklist.banReasonCode eq 'BRC002' ? 'selected' : ''}>욕설</option>
									<option value="BRC003" ${blacklist.banReasonCode eq 'BRC003' ? 'selected' : ''}>음란물</option>
									<option value="BRC004" ${blacklist.banReasonCode eq 'BRC004' ? 'selected' : ''}>기타</option>
	                   			</select>
	                        </p>
	                    </div>

	                    <form class="ea-form" id="blacklistReasonForm">
	                        <input type="hidden" id="blacklistRecordId" name="blacklistRecordId">
	                        <input type="hidden" id="targetMemberIdHidden" name="targetMemberId">

	                        <div class="form-group">
	                            <label for="blacklistReasonText">상세 사유</label>
	                            <textarea id="banReasonDetail" name="banReasonDetail" required style="width: 100%;">${blacklist.banReasonDetail }</textarea>
	                        </div>

	                        <div class="form-group-group" style="display: flex; gap: 16px; align-items: flex-end;">
	                            <div class="form-group" style="flex:1;">
	                                <label for="blacklistReleaseDate">해제 예정일 (선택)</label>
	                                <input type="date" id="banEndDate" name="banEndDate" value="${fn:split(blacklist.banEndDate, ' ')[0]}" >
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
            </main>
        </div>
    </div>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
//알림관련
document.addEventListener('DOMContentLoaded', function() {
    var message = '${message}'; // Spring이 전달한 메시지를 받음
	//메세지가 존재하고 비어있지 않으면 표시
    if (message && message.trim() !== '') {
        Swal.fire({
            icon: 'warning', // 실패 알림이므로 warning 또는 error 아이콘
            title: '알림',
            text: message,
            confirmButtonText: '확인'
        });
    }
});

// 날짜 드롭박스 선택 이벤트
$(document).ready(function(){
	$('#blacklistScope').on('change', function(){
 		var selectedDays = $(this).val();		//선택된 값
		var banEndDateInput = $('#banEndDate');	//해제 예정일 input 요소

  		if (selectedDays === '900y'){			//영구 선택 시
	  		banEndDateInput.val('9999-12-31');
	  		banEndDateInput.prop('readonly', true);
	  		banEndDateInput.prop('disabled', false);
  		} else if (selectedDays && selectedDays !== 'manual'){	//그외 선택시
	  		var today = new Date();	//오늘날짜 객체 생성
	  		var futureDate = new Date();	//해제날짜 객체 생성
	  		//오늘날짜에 선택한 날짜 더함
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
            banEndDateInput.prop('disabled', false); // disabled는 false로 유지 (확실히 활성화)
        }

	})
})
$(function(){
	let modpBtn = $("#modpBtn");			//저장하기 Element
	let signupForm = $("#signupForm");		//저장하기 Form Element

	modpBtn.on("click", function(){
		let memUsername = $("#memUsername").val();
		let banReasonCode = $("#banReasonCode").val();
		let banReasonDetail = $("#banReasonDetail").val();
		let banEndDate = $("#banEndDate").val();

		// 유효성 검사
		if (banReasonDetail == null || banReasonDetail === "") {
	        sweetAlert("error", "상세 내용을 입력하여주세요");
	        $("#banReasonDetail").focus();
	        return false;
	    }
		if (banEndDate == null || banEndDate === "") {
	        sweetAlert("error", "해제일을 입력하여주세요");
	        $("#banEndDate").focus();
	        return false;
	    }

		const selectedDate = new Date(banEndDate);
		// 오늘 날짜를 Date 객체로 생성합니다.
		const today = new Date();
		today.setHours(0, 0, 0, 0);
		//해제일이 오늘 이전이면 수정 불가
		if (selectedDate < today) {
		    sweetAlert("error", "해제일은 오늘 날짜 이전으로 설정할 수 없습니다.");
		    $("#banEndDate").focus();
		    return false;
		}

// 		console.log("--- 추가 등록/수정 값 확인 (console.log) ---");
// 	    console.log("신고당한 사람 (memUsername):", memUsername);
// 	    console.log("사유 (banReasonCode):", banReasonCode);
// 	    console.log("상세사유 (banReasonDetail):", banReasonDetail);
// 	    console.log("해제일 (banEndDate):", banEndDate);

	    signupForm.submit();
	})
})

</script>
</body>
</html>