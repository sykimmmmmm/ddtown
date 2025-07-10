<%-- /WEB-INF/views/mypage/alert/alertSettingFormContent.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<style>
    .alert-setting-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 10px; /* 상하 패딩 증가 */
        border-bottom: 1px solid #eee;
    }
    .alert-setting-item:last-child {
        border-bottom: none;
    }
    .alert-setting-label-area label {
        margin-bottom: 0;
        font-size: 1rem; /* 폰트 크기 조정 */
        color: #333;
    }
    /* 토글 스위치 기본 스타일 */
    .toggle-switch {
        position: relative;
        display: inline-block;
        width: 50px;  /* 너비 */
        height: 26px; /* 높이 */
    }
    /* 실제 체크박스는 숨김 */
    .toggle-switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }
    /* 스위치의 배경(슬라이더) */
    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        -webkit-transition: .4s;
        transition: .4s;
        border-radius: 26px; /* 둥근 모서리 */
    }
    /* 스위치의 원형 핸들 */
    .slider:before {
        position: absolute;
        content: "";
        height: 20px; /* 핸들 높이 */
        width: 20px;  /* 핸들 너비 */
        left: 3px;    /* 왼쪽 여백 */
        bottom: 3px;  /* 아래쪽 여백 */
        background-color: white;
        -webkit-transition: .4s;
        transition: .4s;
        border-radius: 50%;
    }
    /* 체크박스가 선택(checked)되었을 때 슬라이더 배경색 변경 */
    input:checked + .slider {
        background-color: #8a2be2; /* 활성화 색상 */
    }
    /* 체크박스가 선택되었을 때 핸들 위치 이동 */
    input:checked + .slider:before {
        -webkit-transform: translateX(24px); /* 핸들 이동 거리 */
        -ms-transform: translateX(24px);
        transform: translateX(24px);
    }

    /* 서버 메시지 표시부 스타일 (흔들림 방지 개선) */
    .server-message {
        margin-bottom: 30px;
        min-width: 220px;
        max-width: 400px;
        font-size: 1.1em;
        padding: 14px 30px;
        text-align: center;
        opacity: 0; /* 초기에는 투명하게 */
        visibility: hidden; /* 초기에는 숨기지만 공간은 차지 */
        transition: opacity 0.3s ease-in-out; /* 부드러운 페이드 효과 */
        box-sizing: border-box; /* 패딩이 너비/높이에 포함되도록 */
        display: flex; /* 텍스트 수직 중앙 정렬을 위해 추가 */
        align-items: center; /* 텍스트 수직 중앙 정렬 */
        justify-content: center; /* 텍스트 수평 중앙 정렬 */
    }
    .server-message.success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }
    .server-message.error {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    .flex-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 20px;
        margin-bottom: 30px;
    }

    .mypage-title-area h3 {
        margin: 0;
        font-size: 1.4rem;
        white-space: nowrap;
    }

    .server-message {
        min-width: 220px;
        max-width: 400px;
        font-size: 1.1em; /* 크기 키움 */
        padding: 14px 30px; /* 좌우 넓힘 */
        margin: 0 20px;
        flex: 1 1 auto;
    }

    .alert-setting-toggle-area-header {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .toggle-label {
        font-size: 1.1em;
        margin-left: 8px;
        color: #333;
        white-space: nowrap;
    }

    .alert-setting-title {
        font-size: 1.3rem;
        font-weight: bold;
        margin-bottom: 18px;
        margin-left: 2px;
    }

    .alert-setting-all {
        background: #f3f7ff;
        border: 1.5px solid #007bff;
        border-radius: 8px;
        font-weight: bold;
        margin-bottom: 10px;
        box-shadow: 0 2px 8px rgba(0,123,255,0.06);
    }

    .alert-setting-all .alert-setting-label-area label {
        font-size: 1.15rem;
        color: #8a2be2;
        font-weight: bold;
    }

    .form-hint-mypage {
        margin: 0 0 18px 2px;
        color: #666;
        font-size: 0.98em;
    }
</style>

<section id="alert-settings-content" class="mypage-section active-section">
    <div class="mypage-section-header flex-header">
        <div class="mypage-title-area">
            <h3>MY PAGE</h3>
        </div>
        <div id="alertSettingServerMessage" class="server-message">
            <c:if test="${not empty alertSettingErrorMessage}">
                ${alertSettingErrorMessage}
                <c:set var="initialMessageType" value="error"/>
            </c:if>
            <c:if test="${not empty alertSettingSuccessMessage}">
                ${alertSettingSuccessMessage}
                <c:set var="initialMessageType" value="success"/>
            </c:if>
        </div>
    </div>

    <div class="alert-setting-title">알림 설정</div>

    <form id="alert-setting-form">
        <div class="alert-setting-item alert-setting-all">
            <div class="alert-setting-label-area">
                <label for="toggle_all">모든 알림</label>
            </div>
            <div class="alert-setting-toggle-area">
                <label class="toggle-switch">
                    <input type="checkbox" class="alert-toggle-checkbox" id="toggle_all" data-type-code="all" ${not empty alertSettings || fn:length(alertSettings) > 0 || alertSettings.stream().allMatch(s -> s.alertEnabledYn eq 'Y') ? 'checked' : ''}>
                    <span class="slider"></span>
                </label>
                <input type="hidden" name="alertEnabledYn_all" value="${not empty alertSettings || fn:length(alertSettings) > 0 || alertSettings.stream().allMatch(s -> s.alertEnabledYn eq 'Y') ? 'Y' : 'N'}">
            </div>
        </div>
        <p class="form-hint-mypage">수신을 원하는 알림 유형을 선택해주세요.</p>

        <c:choose>
            <c:when test="${not empty alertSettings && fn:length(alertSettings) > 0}">
				<c:forEach var="setting" items="${alertSettings}" varStatus="status">
                    <div class="form-group-mypage alert-setting-item">
						<input type="hidden" name="alertTypeCode_${setting.alertTypeCode}" value="${setting.alertTypeCode}">
	                        <div class="alert-setting-label-area">
	                            <label for="toggle_${setting.alertTypeCode}">${setting.alertDescription}</label>
	                        </div>

	                        <div class="alert-setting-toggle-area">
	                            <label class="toggle-switch">
	                                <input type="checkbox" class="alert-toggle-checkbox"
	                                	   id="toggle_${setting.alertTypeCode}"
	                                       data-type-code="${setting.alertTypeCode}"
	                                       ${setting.alertEnabledYn eq 'Y' ? 'checked' : ''}>
	                                <span class="slider"></span>
	                            </label>
	                            <input type="hidden" name="alertEnabledYn_${setting.alertTypeCode}" value="${setting.alertEnabledYn eq 'Y' ? 'Y' : 'N'}">
	                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p class="no-alerts" style="padding: 20px; text-align: center; color: #777;">설정할 알림 유형이 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </form>
</section>

<script>
$(function(){
    const alertSettingForm = $('#alert-setting-form');
    const csrfToken = $("meta[name='_csrf']").attr("content");
    const csrfHeader = $("meta[name='_csrf_header']").attr("content");
    const messageDiv = $('#alertSettingServerMessage'); // 메시지 div를 변수로 저장

    function displayAlertSettingServerMessage(message, isSuccess) {
        // 애니메이션이 진행 중이면 중지하고 현재 상태로 즉시 이동
        messageDiv.stop(true, true);

        // 메시지 설정 및 클래스 적용
        messageDiv.text(message || '처리 중 오류가 발생했습니다.')
                   .removeClass('success error')
                   .addClass(isSuccess ? 'success' : 'error');

        // 메시지를 보이게 하고 투명도를 1로 설정
        messageDiv.css({ 'visibility': 'visible', 'opacity': 1 });

        // 2초 후 메시지 페이드아웃
        setTimeout(() => {
            messageDiv.animate({ opacity: 0 }, 300, function() { // 0.3초간 페이드 아웃
                $(this).css('visibility', 'hidden'); // 애니메이션 완료 후 숨김
            });
        }, 2000); // 2초 대기 후 페이드 아웃
    }

	// 초기 서버 메시지 처리
    <c:if test="${not empty alertSettingErrorMessage || not empty alertSettingSuccessMessage}">
        messageDiv.removeClass('success error')
                   .addClass('<c:out value="${initialMessageType}"/>')
                   .css({ 'visibility': 'visible', 'opacity': 1 }); // 초기 메시지가 있으면 즉시 보이게 설정

        // 초기 메시지 2초 후 페이드 아웃
        setTimeout(() => {
            messageDiv.animate({ opacity: 0 }, 300, function() {
                $(this).css('visibility', 'hidden');
            });
        }, 2000);
    </c:if>

    // 초기 설정 로드
    function loadInitialSettings(){
    	$.ajax({
    		url: '<c:url value="/mypage/alerts/setting"/>',
    		type: 'GET',
    		contentType: 'application/json',
    		headers: { [csrfHeader]: csrfToken},
    		success: function(settings){
    			const toggleAll = $('#toggle_all');
    			const alertToggles = $('.alert-toggle-checkbox').not('#toggle_all');

    			settings.forEach(setting => {
    				const toggle = $(`#toggle_\${setting.alertTypeCode}`);
    				if(toggle.length){
    					toggle.prop('checked', setting.alertEnabledYn === 'Y');
    					toggle.closest('.alert-setting-toggle-area').find(`input[name="alertEnabledYn_\${setting.alertTypeCode}"]`).val(setting.alertEnabledYn);
    				}
    			});

    			// 모든 알림 동기화
    			const allChecked = alertToggles.length === alertToggles.filter(':checked').length;
    			toggleAll.prop('checked', allChecked);
    			$('.input[name="alertEnabledYn_all"]').val(allChecked ? 'Y' : 'N');
    		},
    		error: function(xhr){
    			displayAlertSettingServerMessage('알림 설정 로드 중 오류 발생...', false);
    		}
    	});
    }

    const toggleAll = $('#toggle_all');
    const alertToggles = $('.alert-toggle-checkbox').not('#toggle_all');

    // 전체 토글 변경 시 개별 토글 동기화
    toggleAll.on('change', function(){
    	const isChecked = $(this).is(':checked');
    	alertToggles.prop('checked', isChecked).trigger('change');		// 개별 토글 업데이트
    	$('input[name="alertEnabledYn_all"]').val(isChecked ? 'Y' : 'N');		// 전체토글 온오프시 개별토글도 업뎃
    });

    // 개별 토글 변경 시 전체 토글 상태도 업뎃
    alertToggles.on('change', function(){
    	const allChecked = alertToggles.length === alertToggles.filter(':checked').length;
    	toggleAll.prop('checked', allChecked);
    	$('input[name="alertEnabledYn_all"]').val(allChecked ? 'Y' : 'N');
    	saveToggleSetting($(this));
    });

    // 토글 상태 hidden으로 숨김
    function updateHiddenInput(toggle){
    	const alertEnabledYn = toggle.is(':checked') ? 'Y' : 'N';
    	toggle.closest('.alert-setting-toggle-area').find(`input[name="alertEnabledYn_\${toggle.data('type-code')}"]`).val(alertEnabledYn);
    }

	// 토글 설정 저장 처리
    function saveToggleSetting(toggle){
    	const toggleChange = toggle;		// 현재 토글박스
    	const alertTypeCode = toggleChange.data('type-code');

    	if(!alertTypeCode){
    		console.error('alertTypeCode가 정의되지 않음.', toggleChange);
    		return;
    	}
        // 현재 체크박스의 상태로 'Y' 또는 'N' 값 결정
        const alertEnabledYn = toggleChange.is(':checked') ? 'Y' : 'N';
		const memUsername = '<c:out value="\${pageContext.request.userPrincipal.name}" />';
        // 바로 다음에 위치한 hidden input의 값을 변경하여 폼 제출 시 값 전송
		updateHiddenInput(toggleChange);

        const dataToSave = [{
        	alertTypeCode : alertTypeCode,
        	alertEnabledYn : alertEnabledYn,
        	memUsername : memUsername
        }];

//         console.log('전송 데이터:', JSON.stringify(dataToSave));

        let headers = {'Content-Type': 'application/json'};
        headers[csrfHeader] = csrfToken;

        $.ajax({
        	url: '<c:url value="/mypage/alerts/setting/save"/>',
        	type : 'POST',
        	contentType: 'application/json',
        	data: JSON.stringify(dataToSave),
        	headers: headers,
        	success: function(response){
        		displayAlertSettingServerMessage(response.message || '알림 설정이 업데이트되었습니다.', true);

        	},
        	error: function(xhr){
        		// 실패했을때
        		displayAlertSettingServerMessage('알림 설정 업데이트 중 오류발생!!', false);
        		// 실패 시 토글 상태 되돌리기
        		toggleChange.prop('checked', !toggleChange.is(':checked'));
        	}
        });
    };

    let isSaving = false;

    // 모든 토글 change 바인딩
    $('.alert-toggle-checkbox').on('change', function(){
    	if(isSaving) return;
    	isSaving = true;
    	saveToggleSetting($(this));		// 토글 변경 시 저장
    	setTimeout(() => { isSaving = false; }, 500);		// 0.5초 동안 중복 방지
    });

    // 페이지 로드 초기값 설정
    $(document).ready(function(){
    	loadInitialSettings();
    });
});
</script>