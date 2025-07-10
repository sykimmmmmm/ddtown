<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>



    <section id="profile-info-content" class="mypage-section active-section">
        <div class="mypage-section-header">
            <h3>기본 정보</h3>
            <span class="required-info-guide"><span class="required-mark">* </span>필수입력사항</span>
        </div>

        <div id="serverMessage" class="server-message">
            <c:if test="${not empty profileSuccessMessage}">
                ${profileSuccessMessage}
                <c:set var="initialProfileMessageType" value="success"/>
            </c:if>
            <c:if test="${not empty profileErrorMessage}">
                ${profileErrorMessage}
                <c:set var="initialProfileMessageType" value="error"/>
            </c:if>
        </div>

        <form action="/mypage/profile/update" id="profile-form" class="profile-form" method="post">
        	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            <div class="form-group-mypage">
                <label for="username_display"><span class="required-mark">* </span>아이디</label>
                <input type="text" id="username_display" name="username_display" value="<c:out value='${memberVO.username }' />" readonly class="profile-field">
            </div>
            <div class="form-group-mypage">
                <label><span class="required-mark">* </span>비밀번호</label>
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
                    <input type="password" id="new_password" name="newPassword" class="profile-field-pw" placeholder="새 비밀번호 (8~16자, 영문/숫자/특수문자 2가지 이상)">
                </div>
                <div class="form-group-mypage">
                    <label for="new_password_confirm">새 비밀번호 확인 <span class="required-mark">*</span></label>
                    <input type="password" id="new_password_confirm" name="confirmNewPassword" class="profile-field-pw" placeholder="새 비밀번호 다시 입력">
                </div>
                <button type="button" id="btn-save-password" class="btn-mypage-primary small-btn">비밀번호 저장</button>
                <button type="button" id="btn-cancel-password-change" class="btn-mypage-secondary small-btn">취소</button>
            </div>

            <div class="form-group-mypage">
                <label for="peoFirstNm"><span class="required-mark">* </span>이름</label>
                <input type="text" id="peoFirstNm" name="peoFirstNm" value="<c:out value='${memberVO.peoFirstNm }' />" class="profile-field" readonly>
            </div>
            <div class="form-group-mypage">
                <label for="peoLastNm"><span class="required-mark">* </span>성</label>
                <input type="text" id="peoLastNm" name="peoLastNm" value="<c:out value='${memberVO.peoLastNm }' />" class="profile-field" readonly>
            </div>
            <div class="form-group-mypage birthdate-group">
                <label><span class="required-mark">* </span>생년월일</label>
                <div class="birthdate-inputs">
                    <input type="text" id="memBirth" name="memBirth" value="<c:out value='${memberVO.memBirth}'/>" class="profile-field year" placeholder="YYYY-MM-DD" readonly>
                </div>
            </div>
            <div class="form-group-mypage gender-group">
                <label><span class="required-mark">* </span>성별</label>
                <div class="radio-group-mypage">
                    <label><input type="radio" name="peoGender" value="M" class="profile-field"  ${memberVO.peoGender eq 'M' ? 'checked' : ''} disabled> 남자</label>
                    <label><input type="radio" name="peoGender" value="F" class="profile-field"  ${memberVO.peoGender eq 'F' ? 'checked' : ''} disabled> 여자</label>
                </div>
            </div>
            <div class="form-group-mypage">
                <label for="memNicknm"><span class="required-mark">* </span>닉네임</label>
                <div class="input-with-button">
                    <input type="text" id="memNicknm" name="memNicknm" value="<c:out value='${memberVO.memNicknm }' />" class="profile-field" maxlength="20" readonly>
                    <button type="button" id="btn-check-nicknm-duplicate" class="btn-mypage-secondary small-btn" style="display:none;">중복 확인</button>
                </div>
                <div id="memNicknmValidationMessage" class="validation-message"></div>
            </div>
            <div class="form-group-mypage address-group">
                <label for="postcode">주소</label>
                <div class="address-row">
                    <input type="text" id="memZipCode" name="memZipCode" placeholder="우편번호" value="<c:out value='${memberVO.memZipCode }' />" readonly class="profile-field short-input">
                    <button type="button" id="btn-find-address" class="btn-mypage-secondary" disabled>주소찾기</button>
                </div>
                <input type="text" id="memAddress1" name="memAddress1" placeholder="기본주소" value="<c:out value='${memberVO.memAddress1 }' />"  readonly class="profile-field full-width-input">
                <input type="text" id="memAddress2" name="memAddress2" placeholder="상세주소" value="<c:out value='${memberVO.memAddress2 }' />"  class="profile-field" maxlength="100">
            </div>
            <div class="form-group-mypage phone-group">
            	<label for="peoPhone">휴대폰</label>
                <input type="text" id="peoPhone" name="peoPhone" value="<c:out value='${memberVO.peoPhone}'/>" placeholder="010-1234-5678" class="profile-field" maxlength="13" readonly>
            </div>
            <div class="form-group-mypage">
                <label for="peoEmail">이메일</label>
                <div class="input-with-button">
                    <input type="email" id="peoEmail" name="peoEmail" value="<c:out value='${memberVO.peoEmail }'/>" class="profile-field" maxlength="50" readonly>
                    <button type="button" id="btn-check-email-duplicate" class="btn-mypage-secondary small-btn" style="display:none;">중복 확인</button>
                </div>
                <div id="peoEmailValidationMessage" class="validation-message"></div>
            </div>
            <div id="form-actions-profile" class="form-actions-mypage profile-actions-area">
                <button type="button" id="btn-deactivate-account" class="btn-mypage-danger">회원 탈퇴</button>
                <div class="main-actions">
                    <button type="button" id="btn-edit-profile" class="btn-mypage-primary">정보 수정하기</button>
                </div>
            </div>
        </form>
    </section>
<script>
    $(function(){
        const profileForm = $('#profile-form');
        const formActionsProfile = $('#form-actions-profile');
        const serverMessageDiv = $('.validation-message'); // 메시지 div 변수 저장
        const btnFindAddress = $('#btn-find-address');
        const btnTogglePasswordChange = $('#btn-toggle-password-change');
        const passwordChangeFields = $('#password-change-fields');
        const btnSavePassword = $('#btn-save-password');
        const btnCancelPasswordChange = $('#btn-cancel-password-change');
        const btnDeactivateAccount = $('#btn-deactivate-account'); // 회원 탈퇴 버튼 캐싱

        // 닉네임, 이메일 중복 확인 버튼
        const btnCheckNicknmDuplicate = $('#btn-check-nicknm-duplicate');
        const btnCheckEmailDuplicate = $('#btn-check-email-duplicate');

        const csrfToken = $("meta[name='_csrf']").attr("content");
        const csrfHeader = $("meta[name='_csrf_header']").attr("content");

        let currentProfileMode = 'view';
        let initialProfileData = {}; // 초기 데이터 저장용

        // 닉네임, 이메일 중복 확인 관련 변수 및 초기값
        let validationStatus = {
            memNicknm: true, // 초기 로드 시 기존 닉네임은 유효하다고 가정
            peoEmail: true   // 초기 로드 시 기존 이메일은 유효하다고 가정
        };
        let originalNickname = '<c:out value='${memberVO.memNicknm }' />';
        let originalEmail = '<c:out value='${memberVO.peoEmail }' />';

        // 서버 메시지 표시 함수 (레이아웃 흔들림 방지 개선)
        function displayServerMessage(message, isSuccess) {
            serverMessageDiv.stop(true, true); // 이전 애니메이션 중지

            serverMessageDiv.text(message || '처리 중 오류가 발생했습니다.')
                            .removeClass('success error')
                            .addClass(isSuccess ? 'success' : 'error');

            serverMessageDiv.css({ 'visibility': 'visible', 'opacity': 1 }); // 보이게 설정

            setTimeout(() => {
                serverMessageDiv.animate({ opacity: 0 }, 300, function() { // 0.3초 페이드 아웃
                    $(this).css('visibility', 'hidden'); // 애니메이션 완료 후 숨김
                });
            }, 5000); // 5초 대기 후 페이드 아웃 시작
        }

        // 초기 서버 메시지 처리 (페이지 로드 시)
        <c:if test="${not empty profileErrorMessage || not empty profileSuccessMessage}">
            // serverMessageDiv 변수를 사용하도록 수정
            serverMessageDiv.removeClass('success error')
                       .addClass('<c:out value="${initialProfileMessageType}"/>')
                       .css({ 'visibility': 'visible', 'opacity': 1 });

            setTimeout(() => {
                serverMessageDiv.animate({ opacity: 0 }, 300, function() {
                    $(this).css('visibility', 'hidden');
                });
            }, 5000);
        </c:if>

        // 수정 가능한 필드 ID들
        const editableFieldIds = ['memNicknm', 'peoEmail', 'peoPhone', 'memAddress2'];
        // 수정 가능한 라디오 버튼들 (주석 처리된 SMS, Email 동의 필드가 추가되면 활성화)
        const editableRadioNames = []; // 현재 HTML에 해당 필드 없음. 필요 시 추가

        function storeInitialData() {
            editableFieldIds.forEach(id => initialProfileData[id] = $('#' + id).val());
            editableRadioNames.forEach(name => {
                initialProfileData[name] = $('input[name="' + name + '"]:checked').val() || $('input[name="' + name + '"][value="N"]').val();
            });
            initialProfileData.username_display = $('#username_display').val();
            initialProfileData.peoGender = $('input[name="peoGender"]:checked').val();
            // 모든 `readonly` 필드의 초기값도 저장
            initialProfileData.peoFirstNm = $('#peoFirstNm').val();
            initialProfileData.peoLastNm = $('#peoLastNm').val();
            initialProfileData.memBirth = $('#memBirth').val();
            initialProfileData.memZipCode = $('#memZipCode').val();
            initialProfileData.memAddress1 = $('#memAddress1').val();


            // 중복 확인을 위한 초기 닉네임과 이메일 값 저장
            originalNickname = $('#memNicknm').val();
            originalEmail = $('#peoEmail').val();

//             console.log("초기 데이터 저장됨:", initialProfileData);
            // 초기 로드 시, 현재 닉네임과 이메일은 유효하다고 가정
            validationStatus.memNicknm = true;
            validationStatus.peoEmail = true;
        }

        function restoreProfileForm() {
            editableFieldIds.forEach(id => {
                $('#' + id).val(initialProfileData[id] || '');
                // 복원 시, 중복 확인 메시지 및 상태 초기화
                const $messageDiv = $('#' + id + 'ValidationMessage');
                if ($messageDiv.length) {
                    $messageDiv.text('').removeClass('success error');
                }
                // 원래 값으로 복원되면 유효 상태로
                if (id === 'memNicknm' && $('#' + id).val() === originalNickname) {
                    validationStatus.memNicknm = true;
                    $('#memNicknmValidationMessage').text('현재 닉네임입니다.').addClass('success'); // 추가: 복원 시 메시지
                } else if (id === 'peoEmail' && $('#' + id).val() === originalEmail) {
                    validationStatus.peoEmail = true;
                    $('#peoEmailValidationMessage').text('현재 이메일입니다.').addClass('success'); // 추가: 복원 시 메시지
                } else { // 원래 값이 아니면 유효하지 않은 상태로
                    validationStatus[id] = false;
                }
            });
            editableRadioNames.forEach(name => {
                const initialValue = initialProfileData[name];
                if(initialValue) {
                    $('input[name="' + name + '"]').filter('[value="' + initialValue + '"]').prop('checked', true);
                } else {
                     $('input[name="' + name + '"][value="N"]').prop('checked', true);
                }
            });
            // 수정 불가능한 필드도 초기값으로 복원 (JS에서 변경될 가능성 대비)
            $('#username_display').val(initialProfileData.username_display || '${memberVO.username}');
            $('#peoFirstNm').val(initialProfileData.peoFirstNm || '');
            $('#peoLastNm').val(initialProfileData.peoLastNm || '');
            $('#memBirth').val(initialProfileData.memBirth || '');
            $('#memZipCode').val(initialProfileData.memZipCode || '');
            $('#memAddress1').val(initialProfileData.memAddress1 || '');
            $('input[name="peoGender"]').filter('[value="' + (initialProfileData.peoGender || '${memberVO.peoGender}') + '"]').prop('checked', true);

//             console.log("폼 데이터 복원됨.");
        }

        // 페이지 로드 시 서버에서 전달된 memberVO 값으로 초기 데이터 저장
        if ($('#username_display').val()) { // memberVO 로드되었는지 확인용
             storeInitialData(); // 초기값 저장
        }

        // 필드 상태 변경 (readonly <-> editable)
        function setFieldsState(isEditable) {
            // 이름, 성, 생년월일, 성별은 항상 readonly/disabled 유지
            // 'username_display', 'peoFirstNm', 'peoLastNm', 'memBirth'는 변경 불가
            $('#peoFirstNm').prop('readonly', true);
            $('#peoLastNm').prop('readonly', true);
            $('#memBirth').prop('readonly', true);
            $('input[name="peoGender"]').prop('disabled', true);

            // 나머지 필드는 isEditable 상태에 따라 변경
            ['memNicknm', 'peoEmail', 'peoPhone', 'memAddress2'].forEach(id => {
                $('#' + id).prop('readonly', !isEditable).prop('disabled', !isEditable);
            });
            // 라디오 버튼 (SMS, 이메일 동의)도 isEditable 상태에 따라 변경
            editableRadioNames.forEach(name => {
                $('input[name="' + name + '"]').prop('disabled', !isEditable);
            });
            btnFindAddress.prop('disabled', !isEditable);

            // 중복 확인 버튼 표시/숨김 추가
            btnCheckNicknmDuplicate.css('display', isEditable ? 'inline-block' : 'none');
            btnCheckEmailDuplicate.css('display', isEditable ? 'inline-block' : 'none');
        }

        // 폼 모드 변경 (view, edit)
        function setProfileMode(mode) {
            currentProfileMode = mode;
            const mainActionsContainer = formActionsProfile.find('.main-actions');

            if (mode === 'view') {
                setFieldsState(false); // 필드값 비활성화 (초기값)
                passwordChangeFields.hide(); // 비밀번호 변경 섹션 숨기기
                btnDeactivateAccount.show(); // 회원탈퇴 버튼 활성화
                btnTogglePasswordChange.hide(); // 비밀번호 변경 버튼 숨기기
                btnFindAddress.hide(); // 주소찾기 버튼 숨기기

                // 기존 중복 확인 메시지 초기화
                $('#memNicknmValidationMessage').text('').removeClass('success error');
                $('#peoEmailValidationMessage').text('').removeClass('success error');


                // 기존 정보 수정 버튼의 이벤트 핸들러를 제거하고 다시 연결하여 중복 호출 방지
                mainActionsContainer.html(`<button type="button" id="btn-edit-profile" class="btn-mypage-primary">정보 수정하기</button>`);
                $('#btn-edit-profile').off('click').on('click', () => setProfileMode('edit'));
            } else if (mode === 'edit') { //  개인정보 수정 클릭 이후
                setFieldsState(true); // 필드값 활성화
                btnTogglePasswordChange.show(); // 비밀번호 변경 버튼 활성화
                btnFindAddress.show(); // 주소찾기 버튼 활성화
                btnDeactivateAccount.hide();
                mainActionsContainer.html(`
                    <button type="submit" id="btn-save-profile" class="btn-mypage-primary">저장하기</button>
                    <button type="button" id="btn-cancel-edit" class="btn-mypage-secondary">취소</button>
                `);
                // '취소' 버튼 클릭 이벤트
                $('#btn-cancel-edit').off('click').on('click', () => {
                    restoreProfileForm(); // 변경사항 복원
                    setProfileMode('view'); // view모드로 변경
                });
            }
        }

        // Daum Postcode API 연동
        btnFindAddress.on('click', function(){
            new daum.Postcode({
                oncomplete: function(data){
                    let addr = '';
                    let extraAddr = '';

                    if(data.userSelectedType === 'R'){ // 도로명 주소
                        addr = data.roadAddress;
                    } else { // 지번 주소 선택 ('J')
                        addr = data.jibunAddress;
                    }

                    if(data.userSelectedType === 'R'){
                        if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                            extraAddr += data.bname;
                        }
                        if(data.buildingName !== '' && data.apartment === 'Y'){
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        if(extraAddr !== ''){
                            extraAddr = ' (' + extraAddr + ')';
                        }
                        $("#memAddress2").val(extraAddr);
                    } else {
                        $("#memAddress2").val('');
                    }

                    $('#memZipCode').val(data.zonecode);
                    $('#memAddress1').val(addr);
                    $('#memAddress2').focus();
                }
            }).open();
        });

        // 중복 확인 함수 (닉네임, 이메일)
        function checkDuplication(fieldId, value, type, messageDivId) {
            const $input = $('#' + fieldId);
            const $messageDiv = $('#' + messageDivId);
            $messageDiv.removeClass('success error').text(''); // 이전 메시지 지우기
            validationStatus[fieldId] = false; // 기본적으로 유효하지 않음으로 설정

            // 값이 비어있으면 체크하지 않고 메시지 표시
            if (!value.trim()) {
                let errorMessage = '';
                if (fieldId === 'memNicknm') {
                    errorMessage = '닉네임을 입력해주세요.';
                } else if (fieldId === 'peoEmail') {
                    errorMessage = '이메일을 입력해주세요.';
                }
                Swal.fire({
                    icon: 'warning',
                    title: '입력 필요',
                    text: errorMessage,
                    confirmButtonText: '확인'
                });
                $messageDiv.text(errorMessage).addClass('error');
                return;
            }

            // 현재 값과 원래 값이 같으면 유효하다고 판단하고 서버 요청 보내지 않음
            if (fieldId === 'memNicknm' && value === originalNickname) {
                validationStatus.memNicknm = true;
                $messageDiv.text('현재 닉네임입니다.').addClass('success');
                Swal.fire({
                    icon: 'info',
                    title: '정보',
                    text: '현재 사용 중인 닉네임입니다.',
                    confirmButtonText: '확인'
                });
                return;
            }
            if (fieldId === 'peoEmail' && value === originalEmail) {
                validationStatus.peoEmail = true;
                $messageDiv.text('현재 이메일입니다.').addClass('success');
                Swal.fire({
                    icon: 'info',
                    title: '정보',
                    text: '현재 사용 중인 이메일입니다.',
                    confirmButtonText: '확인'
                });
                return;
            }

            // 이메일 형식 유효성 검사 (AJAX 호출 전에)
            if (fieldId === 'peoEmail') {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(value)) {
                    Swal.fire({
                        icon: 'warning',
                        title: '형식 오류',
                        text: '유효한 이메일 형식이 아닙니다.',
                        confirmButtonText: '확인'
                    });
                    $messageDiv.text('유효한 이메일 형식이 아닙니다.').addClass('error');
                    validationStatus.peoEmail = false;
                    return;
                }
            }

            let requestUrl = '';
            let requestData = {};
            if (type === 'nickname') {
                requestUrl = '<c:url value="/mypage/nickCheck"/>';
                requestData = { memNicknm: value };
            } else if (type === 'email') {
                requestUrl = '<c:url value="/mypage/emailCheck"/>';
                requestData = { peoEmail: value };
            } else {
                Swal.fire({
                    icon: 'error',
                    title: '오류',
                    text: '유효하지 않은 중복 확인 요청입니다.',
                    confirmButtonText: '확인'
                });
                $messageDiv.text('유효하지 않은 중복 확인 요청입니다.').addClass('error');
                return;
            }

            let headers = {'Content-Type': 'application/json'};
            headers[csrfHeader] = csrfToken;

            $.ajax({
                url: requestUrl,
                type: 'POST', // POST로 통일
                contentType: 'application/json',
                data: JSON.stringify(requestData),
                headers: headers,
                success: function(response) {
                    if (response === "OK" || response === "NOTEXIST") {
                        Swal.fire({
                            icon: 'success',
                            title: '사용 가능',
                            text: type === 'nickname' ? '사용 가능한 닉네임입니다.' : '사용 가능한 이메일입니다.',
                            confirmButtonText: '확인'
                        });
                        $messageDiv.text(type === 'nickname' ? '사용 가능한 닉네임입니다.' : '사용 가능한 이메일입니다.').addClass('success');
                        validationStatus[fieldId] = true;
                    } else if (response === "EXIST") {
                        Swal.fire({
                            icon: 'error',
                            title: '중복',
                            text: '이미 사용 중인 ' + (type === 'nickname' ? '닉네임' : '이메일') + '입니다.',
                            confirmButtonText: '확인'
                        });
                        $messageDiv.text('이미 사용 중인 ' + (type === 'nickname' ? '닉네임' : '이메일') + '입니다.').addClass('error');
                        validationStatus[fieldId] = false;
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: '알 수 없는 오류',
                            text: '중복 확인 중 알 수 없는 오류가 발생했습니다.',
                            confirmButtonText: '확인'
                        });
                        $messageDiv.text('중복 확인 중 알 수 없는 오류가 발생했습니다.').addClass('error');
                        validationStatus[fieldId] = false;
                    }
                },
                error: function(xhr) {
                    Swal.fire({
                        icon: 'error',
                        title: '서버 통신 오류',
                        text: '중복 확인 중 서버 통신 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
                        confirmButtonText: '확인'
                    });
                    $messageDiv.text('서버 통신 중 오류가 발생했습니다.').addClass('error');
                    validationStatus[fieldId] = false;
                    console.error("Duplication check error:", xhr);
                }
            });
        }

        // 닉네임 입력 시 중복 확인 메시지 초기화 및 유효성 상태 변경
        $('#memNicknm').on('input', function() {
            if (currentProfileMode === 'edit') {
                $('#memNicknmValidationMessage').text('').removeClass('success error');
                validationStatus.memNicknm = false; // 재확인 필요
            }
        });
        // 닉네임 필드에서 포커스를 잃었을 때 (blur) 중복 확인 트리거
        $('#memNicknm').on('blur', function() {
            if (currentProfileMode === 'edit') {
                checkDuplication('memNicknm', $(this).val(), 'nickname', 'memNicknmValidationMessage');
            }
        });
        // 닉네임 중복 확인 버튼 클릭 이벤트 추가
        btnCheckNicknmDuplicate.on('click', function() {
            if (currentProfileMode === 'edit') {
                checkDuplication('memNicknm', $('#memNicknm').val(), 'nickname', 'memNicknmValidationMessage');
            }
        });


        // 이메일 입력 시 중복 확인 메시지 초기화 및 유효성 상태 변경
        $('#peoEmail').on('input', function() {
            if (currentProfileMode === 'edit') {
                $('#peoEmailValidationMessage').text('').removeClass('success error');
                validationStatus.peoEmail = false; // 재확인 필요
            }
        });
        // 이메일 필드에서 포커스를 잃었을 때 (blur) 중복 확인 트리거
        $('#peoEmail').on('blur', function() {
            if (currentProfileMode === 'edit') {
                checkDuplication('peoEmail', $(this).val(), 'email', 'peoEmailValidationMessage');
            }
        });
        // 이메일 중복 확인 버튼 클릭 이벤트 추가
        btnCheckEmailDuplicate.on('click', function() {
            if (currentProfileMode === 'edit') {
                checkDuplication('peoEmail', $('#peoEmail').val(), 'email', 'peoEmailValidationMessage');
            }
        });


        // 비밀번호 변경 토글 버튼 클릭 이벤트
        btnTogglePasswordChange.on('click', function() {
            passwordChangeFields.toggle(); // 비밀번호 변경 필드를 토글
            // 비밀번호 변경 필드가 열리면 현재 비밀번호 입력창에 포커스
            if (passwordChangeFields.is(':visible')) {
                $('#current_password_for_change').focus();
            } else { // 닫히면 입력값 초기화
                $('#current_password_for_change').val('');
                $('#new_password').val('');
                $('#new_password_confirm').val('');
            }
        });

        // 비밀번호 변경 취소 버튼 클릭 이벤트
        btnCancelPasswordChange.on('click', function() {
            passwordChangeFields.hide(); // 비밀번호 변경 섹션 숨기기
            // 입력 필드 초기화
            $('#current_password_for_change').val('');
            $('#new_password').val('');
            $('#new_password_confirm').val('');
        });

        // 비밀번호 저장 버튼 클릭 이벤트 (SweetAlert 적용)
        btnSavePassword.on('click', function() {
            const currentPw = $('#current_password_for_change').val();
            const newPw = $('#new_password').val();
            const confirmNewPw = $('#new_password_confirm').val();

            // 유효성 검사
            if (currentPw === '') {
                Swal.fire({ icon: 'warning', title: '입력 필요', text: '현재 비밀번호를 입력해주세요.', confirmButtonText: '확인' });
                return;
            }
            if (newPw === '') {
                Swal.fire({ icon: 'warning', title: '입력 필요', text: '새 비밀번호를 입력해주세요.', confirmButtonText: '확인' });
                return;
            }
            if (confirmNewPw === '') {
                Swal.fire({ icon: 'warning', title: '입력 필요', text: '새 비밀번호 확인을 입력해주세요.', confirmButtonText: '확인' });
                return;
            }
            if (newPw !== confirmNewPw) {
                Swal.fire({ icon: 'error', title: '비밀번호 불일치', text: '새 비밀번호가 일치하지 않습니다.', confirmButtonText: '확인' });
                return;
            }
            // 최종 비밀번호 정규식 (8~16자, 영문/숫자/특수문자 중 2가지 이상)
            const finalPasswordRegex = /^(?=.*[a-zA-Z])(?=.*\d|.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,16}$/;

            if (!finalPasswordRegex.test(newPw)) {
                Swal.fire({ icon: 'warning', title: '형식 오류', text: '새 비밀번호는 8~16자이며, 영문/숫자/특수문자 중 2가지 이상을 포함해야 합니다.', confirmButtonText: '확인' });
                return;
            }

            // 서버로 비밀번호 변경 요청
            $.ajax({
                url: '<c:url value="/mypage/password/update"/>',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    currentPassword: currentPw,
                    newPassword: newPw,
                    confirmNewPassword: confirmNewPw
                }),
                headers: {
                    [csrfHeader]: csrfToken
                },
                success: function(response) {
//                     console.log("비밀번호 업데이트 응답 수신:", response); // 응답 확인을 위한 로그

                    // 서버 응답이 {"success": true, "message": "..."} 형태라고 가정
                    if (response.success === true) {
                        Swal.fire({
                            icon: 'success',
                            title: '성공',
                            text: response.message || '비밀번호가 성공적으로 변경되었습니다. 다음 로그인부터 적용됩니다.',
                            confirmButtonText: '확인'
                        }).then(() => {
                            // 성공 시 필드 초기화 및 비밀번호 변경 섹션 숨기기
                            $('#current_password_for_change').val('');
                            $('#new_password').val('');
                            $('#new_password_confirm').val('');
                            passwordChangeFields.hide();
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: '실패',
                            text: response.message || '비밀번호 변경에 실패했습니다. 현재 비밀번호를 확인하거나 잠시 후 다시 시도해주세요.', // 기본 메시지 추가
                            confirmButtonText: '확인'
                        });
                    }
                },
                error: function(xhr) {
                    console.error("Password change error:", xhr); // 자세한 에러 정보 로그
                    let errorMessage = '비밀번호 변경 중 오류가 발생했습니다.';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMessage = xhr.responseJSON.message;
                    } else if (xhr.status === 400) { // Bad Request (예: 유효성 검사 실패, 현재 비밀번호 불일치 등)
                        errorMessage = "입력값을 확인해주세요. (예: 현재 비밀번호 불일치)";
                    } else if (xhr.status === 401 || xhr.status === 403) { // Unauthorized 또는 Forbidden (인증/권한 문제)
                        errorMessage = "인증 오류가 발생했습니다. 다시 로그인해주세요.";
                    }
                    Swal.fire({
                        icon: 'error',
                        title: '서버 오류',
                        text: errorMessage,
                        confirmButtonText: '확인'
                    });
                }
            });
        });

        // 개인정보 수정 저장 (profileForm submit)
        profileForm.on('submit', function(event) {
            event.preventDefault(); // 기본 폼 제출 방지
//             console.log("프로필 폼 제출 시도"); // 디버깅용 로그

            if (currentProfileMode !== 'edit') {
//                 console.log("현재 편집 모드가 아님, 제출 중단.");
                return;
            }

            // 모든 필드가 유효한지 최종 검사
            let allFieldsValid = true;

            // 닉네임 유효성 검사 (입력값이 있고, 기존 닉네임과 다르다면 유효성 검사 상태 확인)
            const currentNickname = $('#memNicknm').val();
            if (currentNickname.trim() !== '' && currentNickname !== originalNickname) {
                if (!validationStatus.memNicknm) {
                    Swal.fire({ icon: 'warning', title: '유효성 오류', text: '닉네임 중복 확인이 필요하거나 유효하지 않습니다.', confirmButtonText: '확인' });
                    allFieldsValid = false;
                }
            } else if (currentNickname.trim() === '' && originalNickname.trim() !== '') {
                 Swal.fire({ icon: 'warning', title: '입력 오류', text: '닉네임을 입력해주세요.', confirmButtonText: '확인' });
                 allFieldsValid = false;
            }


            // 이메일 유효성 검사 (입력값이 있고, 기존 이메일과 다르다면 유효성 검사 상태 확인)
            const currentEmail = $('#peoEmail').val();
            if (currentEmail.trim() !== '' && currentEmail !== originalEmail) {
                if (!validationStatus.peoEmail) {
                    Swal.fire({ icon: 'warning', title: '유효성 오류', text: '이메일 중복 확인이 필요하거나 유효하지 않습니다.', confirmButtonText: '확인' });
                    allFieldsValid = false;
                } else {
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(currentEmail)) {
                        Swal.fire({ icon: 'warning', title: '형식 오류', text: '유효한 이메일 형식이 아닙니다.', confirmButtonText: '확인' });
                        allFieldsValid = false;
                    }
                }
            }

            // 휴대폰 번호 유효성 검사
            const peoPhone = $('#peoPhone').val().trim();
            if (peoPhone !== '') {
                const phoneRegex = /^01(?:0|1|[6-9])-(?:\d{3}|\d{4})-\d{4}$/;
                if (!phoneRegex.test(peoPhone)) {
                    Swal.fire({ icon: 'warning', title: '형식 오류', text: '유효한 휴대폰 번호 형식이 아닙니다. (예: 010-1234-5678)', confirmButtonText: '확인' });
                    allFieldsValid = false;
                }
            }

            if (!allFieldsValid) {
//                 console.log("폼 유효성 검사 실패.");
                return; // 유효성 검사 실패 시 제출 중단
            }

            // 서버로 전송할 데이터를 직접 구성합니다.
            // readonly/disabled 필드도 명시적으로 포함하여 null이 되는 것을 방지합니다.
            const dataToSend = {};
            dataToSend.username = $('#username_display').val(); // 아이디
            dataToSend.peoFirstNm = $('#peoFirstNm').val();     // 이름
            dataToSend.peoLastNm = $('#peoLastNm').val();      // 성
            dataToSend.memBirth = $('#memBirth').val();        // 생년월일
            dataToSend.peoGender = $('input[name="peoGender"]:checked').val(); // 성별

            dataToSend.memNicknm = $('#memNicknm').val();      // 닉네임
            dataToSend.peoEmail = $('#peoEmail').val();        // 이메일
            dataToSend.peoPhone = $('#peoPhone').val();        // 휴대폰
            dataToSend.memZipCode = $('#memZipCode').val();    // 우편번호
            dataToSend.memAddress1 = $('#memAddress1').val();  // 기본주소
            dataToSend.memAddress2 = $('#memAddress2').val();  // 상세주소


            Swal.fire({
                title: '정보를 저장하시겠습니까?',
                text: '변경하신 프로필 정보가 저장됩니다.',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: '저장',
                cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {
                    // AJAX 요청
                    $.ajax({
                        url: profileForm.attr('action'),
                        type: profileForm.attr('method'),
                        contentType: 'application/json', // JSON 형식으로 데이터 전송
                        data: JSON.stringify(dataToSend), // 모든 필드를 포함한 JSON 전송
                        headers: {
                            [csrfHeader]: csrfToken
                        },
                        success: function(response) {
                            if (response.success) {
                                Swal.fire('성공!', response.message || '프로필 정보가 성공적으로 업데이트되었습니다.', 'success').then(() => {
                                    // 성공 시 페이지를 새로고침하여 최신 데이터 반영 및 초기화
                                    location.reload();
                                });

                            } else {
                                Swal.fire('오류!', response.message || '프로필 정보 업데이트에 실패했습니다.', 'error');
                            }
                        },
                        error: function(xhr) {
                            console.error("Profile update error:", xhr);
                            let errorMessage = '프로필 정보 업데이트 중 오류가 발생했습니다.';
                            if (xhr.responseJSON && xhr.responseJSON.message) {
                                errorMessage = xhr.responseJSON.message;
                            } else if (xhr.status === 400) {
                                errorMessage = '잘못된 요청입니다. 입력값을 확인해주세요.';
                            } else if (xhr.status === 401 || xhr.status === 403) {
                                errorMessage = '세션이 만료되었거나 권한이 없습니다. 다시 로그인해주세요.';
                            }
                            Swal.fire('오류!', errorMessage, 'error');
                        }
                    });
                }
            });
        });

        // 회원탈퇴 버튼 클릭 이벤트 추가
        btnDeactivateAccount.on('click', function() {
            Swal.fire({
                title: '회원 탈퇴',
                html: '<div style="text-align: left; margin-bottom: 20px;">' +
                      '<p style="color: #d33; font-weight: bold; margin-bottom: 15px;">⚠️ 회원 탈퇴 시 되돌릴 수 없습니다.</p>' +
                      '<p style="margin-bottom: 15px;">동의하신다면 아래 문구를 정확히 입력해주세요:</p>' +
                      '<p style="background-color: #f8f9fa; padding: 10px; border-radius: 5px; font-weight: bold; color: #495057;">' +
                      '회원탈퇴에 동의합니다' +
                      '</p>' +
                      '</div>',
                input: 'text',
                inputPlaceholder: '회원탈퇴에 동의합니다',
                inputValidator: function(value) {
                    if (!value) {
                        return '문구를 입력해주세요!';
                    }
                    if (value !== '회원탈퇴에 동의합니다') {
                        return '문구가 정확하지 않습니다!';
                    }
                },
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '회원 탈퇴',
                cancelButtonText: '취소',
                reverseButtons: false,
                allowOutsideClick: false,
                allowEscapeKey: false
            }).then(function(result) {
                if (result.isConfirmed) {
                    // 최종 확인
                    Swal.fire({
                        title: '정말 탈퇴하시겠습니까?',
                        text: '모든 데이터가 영구적으로 삭제되며 복구할 수 없습니다.',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: '탈퇴하기',
                        cancelButtonText: '취소',
                        reverseButtons: false
                    }).then(function(finalResult) {
                        if (finalResult.isConfirmed) {
                            // 회원 탈퇴 처리
                            $.ajax({
                                url: '<c:url value="/mypage/withdraw"/>',
                                type: 'POST',
                                contentType: 'application/json',
                                data: JSON.stringify({
                                    confirmationText: '회원탈퇴에 동의합니다'
                                }),
                                headers: {
                                    [csrfHeader]: csrfToken
                                },
                                success: function(response) {
                                    if (response.success) {
                                        Swal.fire({
                                            title: '탈퇴 완료',
                                            text: '회원 탈퇴가 완료되었습니다. 이용해주셔서 감사합니다.',
                                            icon: 'success',
                                            showConfirmButton: false
                                        }).then(function() {
                                            // 로그아웃 처리 후 메인 페이지로 이동
                                            window.location.href = '<c:url value="/logout"/>';
                                        });
                                        setTimeout(() => {
                                        	window.location.reload();
                                        }, 2000);
                                    } else {
                                        Swal.fire({
                                            title: '탈퇴 실패',
                                            text: response.message || '회원 탈퇴 처리 중 오류가 발생했습니다.',
                                            icon: 'error',
                                            confirmButtonText: '확인'
                                        });
                                    }
                                },
                                error: function(xhr) {
                                    console.error("회원 탈퇴 오류:", xhr);
                                    var errorMessage = '회원 탈퇴 처리 중 오류가 발생했습니다.';
                                    if (xhr.responseJSON && xhr.responseJSON.message) {
                                        errorMessage = xhr.responseJSON.message;
                                    } else if (xhr.status === 401 || xhr.status === 403) {
                                        errorMessage = '세션이 만료되었습니다. 다시 로그인해주세요.';
                                    }
                                    Swal.fire({
                                        title: '오류',
                                        text: errorMessage,
                                        icon: 'error',
                                        confirmButtonText: '확인'
                                    });
                                }
                            });
                        }
                    });
                }
            });
        });

        // 초기 모드 설정
        setProfileMode('view');
    });
</script>