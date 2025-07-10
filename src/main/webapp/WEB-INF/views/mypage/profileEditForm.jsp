<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DD TOWN - 마이페이지</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <sec:csrfMetaTags />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mypage_common.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .form-group-mypage.password-confirm-area { margin-top: 20px; border-top: 1px solid #eee; padding-top: 20px; }
        .server-message { padding: 10px; margin-bottom: 15px; border-radius: 4px; text-align: center; display: none; }
        .server-message.success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .server-message.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .btn-mypage-primary.loading::after {
            content: ''; position: absolute; width: 16px; height: 16px; top: 50%; left: 50%;
            margin-top: -8px; margin-left: -8px; border: 2px solid #fff;
            border-top-color: transparent; border-radius: 50%; animation: spin 1s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>
    <%@ include file="../modules/headerPart.jsp" %>
        <div class="logo">
            <a href="../2.main/artist_community_main.html">DDTOWN SQUARE</a>
        </div>
        <nav class="utility-nav">
            <ul id="loggedOutNav" style="display: none;">
                <li><a href="../login.html" class="auth-link">로그인</a></li>
                <li><a href="../signup.html" class="signup-link">회원가입</a></li>
            </ul>
            <ul id="loggedInNav" style="display: flex;">
                <li><a href="mypage/alerts" class="icon-btn" title="알림">🔔</a></li>
                <li><a href="<c:url value='/mypage'/>" class="icon-btn active" title="마이페이지">👤</a></li>
                <li><a href="#" class="icon-btn" title="고객센터">👩‍💻</a></li>
                <li>
                    <form id="logoutForm" action="<c:url value='/logout'/>" method="post" style="display:inline;">
                        <sec:csrfInput/>
                        <a href="#" onclick="document.getElementById('logoutForm').submit(); return false;" class="auth-link">로그아웃</a>
                    </form>
                </li>
            </ul>
        </nav>

    <nav class="main-navigation">
        <ul>
            <li><a href="../3.goodshop/goods_shop.html">굿즈샵</a></li>
            <li>
                <a href="#">선호도 조사</a>
                <ul class="submenu">
                    <li><a href="../3.goodshop/preference_vote.html">인기 투표</a></li>
                </ul>
            </li>
            <li><a href="#">콘서트</a></li>
            </ul>
    </nav>


    <div class="mypage-container">
        <aside class="mypage-sidebar">
            <h2>MY PAGE</h2>
            <nav class="mypage-nav">
                <ul>
                    <li class="nav-depth1">
                        <a href="<c:url value='/mypage/' />" class="depth1-menu active-menu">개인정보 관리</a>
                    </li>
                    <li class="nav-depth1">
                        <a href="<c:url value='/mypage/alerts' />" class="depth1-menu">알림 레이아웃</a>
                    </li>
                    <li class="nav-depth1">
                        <a href="mypage_order.html" class="depth1-menu">마이 쇼핑</a>
                        <ul class="nav-depth2">
                            <li><a href="mypage_order.html">주문내역 확인</a></li>
                            <li><a href="mypage_cancel.html">주문 취소/환불</a></li>
                            <li><a href="mypage_membership.html">구독현황(멤버십)</a></li>
                        </ul>
                    </li>
                    <li class="nav-depth1"><a href="<c:url value='/mypage/confirmWithdraw'/>" class="depth1-menu">회원 탈퇴</a></li>
                </ul>
            </nav>
        </aside>

        <main class="mypage-content">
            <section id="profile-info-content" class="mypage-section active-section">
                <div class="mypage-section-header">
                    <h3>기본 정보</h3>
                    <span class="required-info-guide">* 필수입력사항</span>
                </div>

                <div id="serverMessage" class="server-message"></div>
                <c:if test="${not empty profileSuccessMessage}"><div class="server-message success" style="display:block;">${profileSuccessMessage}</div></c:if>
                <c:if test="${not empty profileErrorMessage}"><div class="server-message error" style="display:block;">${profileErrorMessage}</div></c:if>

                <form id="profile-form" class="profile-form" method="post">
                	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <div id="password-confirm-section" class="form-group-mypage password-confirm-area" style="display: none;">
                        <label for="confirm_password">현재 비밀번호 확인</label>
                        <input type="password" id="confirm_password" name="confirm_password" placeholder="정보 수정을 위해 현재 비밀번호를 입력해주세요." required>
                        <button type="button" id="btn-confirm-password" class="btn-mypage-secondary small-btn">확인</button>
                    </div>

                    <div class="form-group-mypage">
                        <label for="username_display">아이디</label>
                        <input type="text" id="username_display" name="username_display" value="<c:out value='${memberVO.username }' />" readonly class="profile-field">
                    </div>
                    <div class="form-group-mypage">
                        <label>비밀번호</label>
                        <div class="password-field-area">
                            <input type="password" value="**********" readonly class="profile-field">
                            <button type="button" id="btn-toggle-password-change" class="btn-mypage-secondary small-btn">비밀번호 변경</button>
                        </div>
                    </div>
                    <div id="password-change-fields" style="display: none; margin-top:15px; padding-top:15px; border-top:1px dashed #eee;">
                        <h4>비밀번호 변경</h4>
                        <div class="form-group-mypage">
                            <label for="current_password_for_change">현재 비밀번호 <span class="required-mark">*</span></label>
                            <input type="password" id="current_password_for_change" name="currentPassword" class="profile-field-pw" placeholder="현재 비밀번호 입력">
                        </div>
                        <div class="form-group-mypage">
                            <label for="new_password">새 비밀번호 <span class="required-mark">*</span></label>
                            <input type="password" id="new_password" name="newPassword" class="profile-field-pw" placeholder="새 비밀번호 (10~16자, 영문/숫자/특수문자 2가지 이상)">
                        </div>
                        <div class="form-group-mypage">
                            <label for="new_password_confirm">새 비밀번호 확인 <span class="required-mark">*</span></label>
                            <input type="password" id="new_password_confirm" name="confirmNewPassword" class="profile-field-pw" placeholder="새 비밀번호 다시 입력">
                        </div>
                        <button type="button" id="btn-save-password" class="btn-mypage-primary small-btn">비밀번호 저장</button>
                        <button type="button" id="btn-cancel-password-change" class="btn-mypage-secondary small-btn">취소</button>
                    </div>

                    <div class="form-group-mypage">
                        <label for="peoFirstNm">이름</label>
                        <input type="text" id="peoFirstNm" name="peoFirstNm" value="<c:out value='${memberVO.peoFirstNm }' />" class="profile-field" readonly>
                    </div>
                    <div class="form-group-mypage">
                        <label for="peoLastNm">성</label>
                        <input type="text" id="peoLastNm" name="peoLastNm" value="<c:out value='${memberVO.peoLastNm }' />" class="profile-field" readonly>
                    </div>
                    <div class="form-group-mypage birthdate-group">
                        <label>생년월일</label>
                        <div class="birthdate-inputs">
                            <input type="text" id="memBirth" name="memBirth" value="<c:out value='${memberVO.memBirth}'/>" class="profile-field year" placeholder="YYYY-MM-DD" readonly>
                        </div>
                    </div>
                    <div class="form-group-mypage gender-group">
                        <label>성별</label>
                        <div class="radio-group-mypage">
                            <label><input type="radio" name="peoGender" value="M" class="profile-field"  ${memberVO.peoGender eq 'M' ? 'checked' : ''} disabled> 남자</label>
                            <label><input type="radio" name="peoGender" value="F" class="profile-field"  ${memberVO.peoGender eq 'F' ? 'checked' : ''} disabled> 여자</label>
                        </div>
                    </div>
                    <div class="form-group-mypage">
                        <label for="memNicknm">닉네임</label>
                        <input type="text" id="memNicknm" name="memNicknm" value="<c:out value='${memberVO.memNicknm }' />" class="profile-field" readonly>
                    </div>
                    <div class="form-group-mypage address-group">
                        <label for="postcode">주소</label>
                        <div class="address-row">
                            <input type="text" id="memZipCode" name="memZipCode" placeholder="우편번호" value="<c:out value='${memberVO.memZipCode }' />"  class="profile-field short-input">
                            <button type="button" id="btn-find-address" class="btn-mypage-secondary" >주소찾기</button>
                        </div>
                        <input type="text" id="memAddress1" name="memAddress1" placeholder="기본주소" value="<c:out value='${memberVO.memAddress1 }' />"  class="profile-field full-width-input">
                        <input type="text" id="memAddress2" name="memAddress2" placeholder="상세주소" value="<c:out value='${memberVO.memAddress2 }' />"  class="profile-field full-width-input">
                    </div>
                    <div class="form-group-mypage phone-group">
                    	<label for="peoPhone">휴대폰 <span class="required-mark">*</span></label>
                        <input type="text" id="peoPhone" name="peoPhone" value="<c:out value='${memberVO.peoPhone}'/>" placeholder="010-1234-5678" class="profile-field">
                    </div>
                    <div class="form-group-mypage">
                        <label for="peoEmail">이메일 <span class="required-mark">*</span></label>
                        <input type="email" id="peoEmail" name="peoEmail" value="<c:out value='${memberVO.peoEmail }'/>" class="profile-field">
                    </div>


                    <div id="form-actions-profile" class="form-actions-mypage profile-actions-area">
                        <button type="button" id="btn-deactivate-account" class="btn-mypage-danger">회원 탈퇴</button>
                        <div class="main-actions">
                            <button type="button" id="btn-edit-profile" class="btn-mypage-primary">정보 수정하기</button>
                        </div>
                    </div>
                </form>
            </section>
        </main>
    </div>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
    <%@ include file="../modules/footerPart.jsp" %>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js" ></script>

    <script>
        $(function(){
            const profileForm = $('#profile-form');
            const formActionsProfile = $('#form-actions-profile');
            const passwordConfirmSection = $('#password-confirm-section');
            const btnConfirmPassword = $('#btn-confirm-password');
            const confirmPasswordInput = $('#confirm_password');
            const serverMessageDiv = $('#serverMessage');
            const btnFindAddress = $('#btn-find-address');
            const btnTogglePasswordChange = $('#btn-toggle-password-change');
            const passwordChangeFields = $('#password-change-fields');
            const btnSavePassword = $('#btn-save-password');
            const btnCancelPasswordChange = $('#btn-cancel-password-change');

            const csrfToken = $("meta[name='_csrf']").attr("content");
            const csrfHeader = $("meta[name='_csrf_header']").attr("content");

            let currentProfileMode = 'view';
            let initialProfileData = {};

            function displayServerMessage(message, isSuccess) {		// 서버메시지
                serverMessageDiv.text(message || '처리 중 오류가 발생했습니다.')
                                .removeClass('success error')
                                .addClass(isSuccess ? 'success' : 'error')
                                .show();
                setTimeout(() => serverMessageDiv.fadeOut(), 5000);
            }
			// 수정 가능한 필드 ID들
            const editableFieldIds = ['memNicknm', 'peoEmail', 'peoPhone', 'memZipCode', 'memAddress1', 'memAddress2'];
			// 수정 가능한 라디오 버튼들 - 수신동의 이메일동의
            const editableRadioNames = ['memberSmsAgree', 'memberEmailAgree'];

            function storeInitialData() {
                editableFieldIds.forEach(id => initialProfileData[id] = $('#' + id).val());
                editableRadioNames.forEach(name => {
                    initialProfileData[name] = $('input[name="' + name + '"]:checked').val() || $('input[name="' + name + '"][value="N"]').val();
                });
                // 다른 수정 불가능하지만 화면에 표시되는 값들도 필요시 저장 (예: 이름, 아이디)
                initialProfileData.username_display = $('#username_display').val();
                initialProfileData.peoGender = $('input[name="peoGender"]:checked').val();

//                 console.log("초기 데이터 저장됨:", initialProfileData);
            }
			// 프로필 저장
            function restoreProfileForm() {
                editableFieldIds.forEach(id => $('#' + id).val(initialProfileData[id] || ''));		// 수정가능한 필드값 반복처리문
                editableRadioNames.forEach(name => {		// value처리
                    const initialValue = initialProfileData[name];
                    if(initialValue) {
                        $('input[name="' + name + '"]').filter('[value="' + initialValue + '"]').prop('checked', true);
                    } else {
                         $('input[name="' + name + '"][value="N"]').prop('checked', true);
                    }
                });
                 // 수정 불가능한 필드도 초기값으로 (만약 서버에서 받은 memberVO가 변경될 수 있다면)
                $('#username_display').val(initialProfileData.username_display || '${memberVO.username}');
                $('input[name="peoGender"]').filter('[value="' + (initialProfileData.peoGender || '${memberVO.peoGender}') + '"]').prop('checked', true);

//                 console.log("폼 데이터 복원됨.");
            }
             // 페이지 로드 시 서버에서 전달된 memberVO 값으로 초기 데이터 저장
            if ($('#username_display').val()) {		// memberVO 로드되었느닞 확인용
                 storeInitialData();	// 초기값 저장
            }

			// 필드 상태 변경 온니리드 -> 수정가능
            function setFieldsState(isEditable) {
                editableFieldIds.forEach(id => {
                    $('#' + id).prop('readonly', !isEditable).prop('disabled', !isEditable);
                });
                editableRadioNames.forEach(name => {
                    $('input[name="' + name + '"]').prop('disabled', !isEditable);
                });
                btnFindAddress.prop('disabled', !isEditable);
            }
			// 폼 모드변경 (view(readonly), edit(수정), edit-pending-passwword(비밀번호 변경))
            function setProfileMode(mode) {
                currentProfileMode = mode;
                const mainActionsContainer = formActionsProfile.find('.main-actions');

                if (mode === 'view') {
                    setFieldsState(false);		// 필드값 비활성화 (초기값)
                    passwordConfirmSection.hide();	// 비밀번호 확인섹션 숨기기
                    passwordChangeFields.hide();	// 비밀번호 변경 섹션 숨기기
                    formActionsProfile.find('#btn-deactivate-account').show();		// 회원정보 수정 버튼 활성화
                    btnTogglePasswordChange.show();	// 비밀번호 변경 섹션 활성화
                    mainActionsContainer.html(`<button type="button" id="btn-edit-profile" class="btn-mypage-primary">정보 수정하기</button>`);
                    $('#btn-edit-profile').off('click').on('click', () => setProfileMode('edit-pending-password'));
                } else if (mode === 'edit-pending-password') {		// 비밀번호 변경
                    setFieldsState(false);		// 필드상태 readonly로 잠금
                    passwordConfirmSection.show();		// 현재 비밀번호, 새 비밀번호 섹션 보여주기
                    confirmPasswordInput.val('').focus();		// 입력할 비밀번호 포커스
                    formActionsProfile.find('#btn-deactivate-account').hide();		// 비활성화된 폼 숨기기
                    btnTogglePasswordChange.hide();		// 비밀번호 변경 버튼 숨기기
                    mainActionsContainer.html(`<button type="button" id="btn-cancel-edit" class="btn-mypage-secondary">취소</button>`);
                    $('#btn-cancel-edit').off('click').on('click', () => {
                        restoreProfileForm();		// 변경사항 저장
                        setProfileMode('view');		// 개인정보 view 다시 띄우기
                    });
                } else if (mode === 'edit') {		//  개인정보 수정 클릭 이후
                    passwordConfirmSection.hide();	// 비밀번호 확인 섹션 숨기기
                    setFieldsState(true);			// 필드값 활성화
                    btnTogglePasswordChange.show();	// 비밀번호 변경 버튼 활성화
                    mainActionsContainer.html(`
                        <button type="submit" id="btn-save-profile" class="btn-mypage-primary">저장하기</button>
                        <button type="button" id="btn-cancel-edit" class="btn-mypage-secondary">취소</button>
                    `);
                    // submit 이벤트는 form에 한 번만 바인딩
                    $('#btn-cancel-edit').off('click').on('click', () => {
                        restoreProfileForm();		// 변경사항 저장
                        setProfileMode('view');		// view모드로 변경
                    });
                }
            }
			// 비밀번호 변경 확인버튼
            btnConfirmPassword.on('click', function() {
                const currentPassword = confirmPasswordInput.val();
                if (!currentPassword) {
                    displayServerMessage('현재 비밀번호를 입력해주세요.', false);
                    confirmPasswordInput.focus();	// 현재비밀번호 입력란 포커스
                    return;
                }
                let headers = {}; headers[csrfHeader] = csrfToken;		// csrf토큰 추가

                $.ajax({
                    url: "/mypage/profile/verifyPassword",
                    type: 'POST',
                    data: { currentPassword: currentPassword },
                    headers: headers,
                    beforeSend: () => btnConfirmPassword.addClass('loading').prop('disabled', true),
                    complete: () => btnConfirmPassword.removeClass('loading').prop('disabled', false),
                    success: response => {
                        if (response.success) {
                            displayServerMessage(response.message, true);
                            setProfileMode('edit');
                        } else {
                            displayServerMessage(response.message || '비밀번호 확인 실패.', false);
                            confirmPasswordInput.focus();
                        }
                    },
                    error: xhr => displayServerMessage('비밀번호 확인 중 오류: ' + (xhr.responseJSON ? xhr.responseJSON.message : '서버 오류'), false)
                });
            });
			// 개인정보 수정 저장
            profileForm.on('submit', function(event) {
                event.preventDefault();
                if (currentProfileMode !== 'edit') return;		// 수정 상태가 아닐때 리턴

                const memberData = {
                	username: '<c:out value="${memberVO.username}"/>',
                	memUsername: '<c:out value="${memberVO.username}"/>',

                	// people 테이블 필드값
                    peoEmail: $('#peoEmail').val(),
                    peoFirstNm: $('#peoFirstNm').val(),
                    peoLastNm: $('#peoLastNm').val(),
                    peoPhone: $('#peoPhone').val(),
                    peoGender: $('input[name="peoGender"]:checked').val(),

                    // member 테이블 필드값
                	memBirth: $('#memBirth').val(),
                	memNicknm: $('#memNicknm').val(),
                    memZipCode: $('#memZipCode').val(),
                    memAddress1: $('#memAddress1').val(),
                    memAddress2: $('#memAddress2').val(),
                    memberSmsAgree: $('input[name="memberSmsAgree"]:checked').val(),
                    memberEmailAgree: $('input[name="memberEmailAgree"]:checked').val(),
                    memBirth: '${memberVO.memBirth}'
                };
//                 console.log("수정할 프로필 데이터 (AJAX 전송용):", memberData);

                let headers = {'Content-Type': 'application/json'}; headers[csrfHeader] = csrfToken;
                const saveButton = $('#btn-save-profile');

                $.ajax({
                    url: '<c:url value="/mypage/profile/update"/>',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(memberData),
                    headers: headers,
                    beforeSend: () => saveButton.addClass('loading').prop('disabled', true),
                    complete: () => saveButton.removeClass('loading').prop('disabled', false),
                    success: function(response) {
                        if (response.success) {
                            displayServerMessage(response.message || '프로필이 저장되었습니다.', true);
                            if(response.updatedProfile) {
                                // 서버에서 받은 최신 정보로 화면 필드 및 initialProfileData 업데이트
                                $('#username_display').val(response.updatedProfile.username || ''); // 아이디도 업데이트
                                $('#peoFirstNm').val(response.updatedProfile.peoFirstNm || '');
                                $('#peoLastNm').val(response.updatedProfile.peoLastNm || '');
                                $('#memBirth').val(response.updatedProfile.memBirth || '');
                                $('#memNicknm').val(response.updatedProfile.memNicknm || '');
                                $('input[name="peoGender"]').filter('[value="' + response.updatedProfile.peoGender + '"]').prop('checked', true);
                                $('#peoEmail').val(response.updatedProfile.peoEmail || '');
                                $('#peoPhone').val(response.updatedProfile.peoPhone || '');
                                $('#memZipCode').val(response.updatedProfile.memZipCode || '');
                                $('#memAddress1').val(response.updatedProfile.memAddress1 || '');
                                $('#memAddress2').val(response.updatedProfile.memAddress2 || '');
                                $('input[name="memberSmsAgree"]').filter('[value="' + response.updatedProfile.memberSmsAgree + '"]').prop('checked', true);
                                $('input[name="memberEmailAgree"]').filter('[value="' + response.updatedProfile.memberEmailAgree + '"]').prop('checked', true);
                                storeInitialData(); // 변경된 값으로 initialData 업데이트
                            }
                            setProfileMode('view');
                        } else {
                            displayServerMessage(response.message || '프로필 저장에 실패했습니다.', false);
                        }
                    },
                    error: xhr => displayServerMessage('프로필 저장 중 오류: ' + (xhr.responseJSON ? xhr.responseJSON.message : '서버 오류 (' + xhr.status + ')'), false)
                });
            });
			// 비밀번호변경 버튼 핸들러
            btnTogglePasswordChange.on('click', function() {
                passwordChangeFields.toggle();
                if (passwordChangeFields.is(':visible')) {
                    $('#current_password_for_change').val('').focus();
                    $('#new_password').val('');
                    $('#new_password_confirm').val('');
                }
            });
			// 비밀번호 변경 취소 버튼 핸들러
            btnCancelPasswordChange.on('click', function() {
                passwordChangeFields.hide();
                displayServerMessage('', true); // 이전 메시지 숨김
            });
			// 비밀번호 저장 핸들러
            btnSavePassword.on('click', function() {
                const payload = {
                    currentPassword: $('#current_password_for_change').val(),
                    newPassword: $('#new_password').val(),
                    confirmNewPassword: $('#new_password_confirm').val()
                };

                if (!payload.currentPassword || !payload.newPassword || !payload.confirmNewPassword) {
                    displayServerMessage('모든 비밀번호 필드를 입력해주세요.', false); return;
                }
                if (payload.newPassword !== payload.confirmNewPassword) {
                    displayServerMessage('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.', false); return;
                }

                let headers = {'Content-Type': 'application/json'}; headers[csrfHeader] = csrfToken;

                $.ajax({
                    url: '<c:url value="/mypage/password/update"/>', type: 'POST',
                    contentType: 'application/json', data: JSON.stringify(payload), headers: headers,
                    beforeSend: () => btnSavePassword.addClass('loading').prop('disabled', true),
                    complete: () => btnSavePassword.removeClass('loading').prop('disabled', false),
                    success: function(response) {
                        displayServerMessage(response.message || '처리 완료.', response.success);
                        if (response.success) {
                            passwordChangeFields.hide();
                            if(response.forceLogout){
                                alert("비밀번호가 변경되었습니다. 보안을 위해 다시 로그인해주세요.");
                                // 로그아웃 폼이 있다면 제출, 없다면 로그인 페이지로 이동
                                if ($('#logoutForm').length > 0) {
                                   $('#logoutForm').submit();
                                } else {
                                   window.location.href = '<c:url value="/login"/>'; // 실제 로그인 폼 경로
                                }
                            }
                        }
                    },
                    error: xhr => displayServerMessage('비밀번호 변경 중 오류: ' + (xhr.responseJSON ? xhr.responseJSON.message : '서버 오류 (' + xhr.status + ')'), false)
                });
            });

            // 회원 탈퇴 AJAX
            $('#btn-deactivate-account').on('click', function() {
                const confirmationText = prompt("회원 탈퇴를 진행하려면 '회원탈퇴에 동의합니다'를 정확히 입력해주세요.");

            	if(confirmationText === null || confirmationText.trim() === ''){		// 빈 문자열이거나 취소 눌렀을때
            		displayServerMessage("회원 탈퇴가 취소되었습니다.", false);
            		return;
            	}

            	const dataToSend = {
            			confirmationText: confirmationText		// 사용자 입력 문자열
            	};

            	let headers = {};
            	headers[csrfHeader] = csrfToken;		// csrf 토큰 추가

            	$.ajax({
            		url: '<c:url value="/mypage/withdraw"/>',
            		type: 'POST',
            		contentType: 'application/x-www-form-urlencoded',
            		data: dataToSend,
            		headers: headers,
            		beforeSend: () => $(this).addClass('loading').prop('disabled', true),
            		complete: () => $(this).removeClass('loading').prop('disabled', false),
            		success: function(response){
            			displayServerMessage(response.message, response.success);
            			if(response.success){
            				if(response.redirectUrl){
            					alert(response.message);
            					window.location.href = response.redirectUrl;
            				} else {
            					alert(response.message);
            					window.location.href = '<c:url value="/"/>';
            				}
            			}
            		},
            		error: function(xhr){
            			displayServerMessage('회원 탈퇴 중 오류 발생!!!' + (xhr.responseJSON ? xhr.responseJSON.message : '서버 오류 (' + xhr.status + ')'), false);
            		}
            	});
            });

            setProfileMode('view');
        });
    </script>
</body>
</html>