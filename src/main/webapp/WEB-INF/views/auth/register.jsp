<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입</title>
<%@ include file="../modules/headerPart.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.js"></script>
<style>
    body {
        /* 배경색을 더 깊은 회색 계열로 변경 */
        background-color: #e0e2e6;
        font-family: 'Pretendard', 'Noto Sans KR', Arial, sans-serif;
    }
    .card {
        background-color: #ffffff;
        border-radius: 18px !important;
        /* 그림자 효과를 더 진하고 강하게 변경 */
        box-shadow: 0 10px 40px rgba(60, 45, 90, 0.25) !important;
        border: none !important;
    }
    .ddtown-title {
        /* 제목 색상을 더 진한 보라색으로 변경 */
        color: #2b1a4f;
        font-weight: 800;
    }
    .form-label {
        /* 라벨 색상을 더 진한 보라색으로 변경 */
        color: #2b1a4f;
        font-weight: 600;
        font-size: 1.01rem;
        margin-bottom: 6px;
    }
    .form-control, .form-select {
        /* 입력 필드 배경색을 약간 더 어둡게 변경 */
        background-color: #f0f0f5;
        border: 1.5px solid #c0c0c0; /* 테두리 색상도 약간 진하게 */
        border-radius: 8px;
        padding: 11px 12px;
        font-size: 1rem;
    }
    .form-control:focus, .form-select:focus {
        /* 포커스 시 테두리 색상을 더 진한 보라색으로 변경 */
        border-color: #8a3be2;
        /* 포커스 그림자도 더 진한 보라색으로 변경 */
        box-shadow: 0 0 0 0.25rem rgba(138, 59, 226, 0.35);
        background-color: #fff;
    }

    /* Primary Button 스타일 (가입하기 버튼 등) */
    .btn-primary {
        /* 기본 버튼 색상을 더 진한 보라색으로 변경 */
        background-color: #8a3be2;
        border-color: #8a3be2;
        color: #fff;
        font-weight: 700;
    }
    .btn-primary:hover {
        /* 호버 시 버튼 색상을 더 깊고 어두운 보라색으로 변경 */
        background-color: #6a2ccf;
        border-color: #6a2ccf;
        color: #fff;
    }

    /* 중복확인 버튼 스타일 */
    .btn-check-custom {
        /* 중복확인 버튼 색상을 더 진한 보라색으로 변경 */
        background: #8a3be2;
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 0 13px;
        font-size: 0.80rem;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.2s;
        line-height: 1.5;
    }
    .btn-check-custom:hover {
        /* 호버 시 중복확인 버튼 색상을 더 깊고 어두운 보라색으로 변경 */
        background: #6a2ccf;
    }
    .input-group .form-control {
        height: auto;
    }

    /* 피드백 메시지 스타일 */
    .form-feedback-custom {
        font-size: 0.93rem;
        margin-top: 4px;
        min-height: 18px;
        display: block;
    }
    .form-feedback-custom.text-success-custom {
        /* 성공 메시지 색상도 더 진한 녹색으로 변경 */
        color: #2e7d32 !important;
        font-weight: 600;
    }
    .form-feedback-custom.text-danger-custom {
        /* 에러 메시지 색상도 더 진한 빨간색으로 변경 */
        color: #c62828 !important;
        font-weight: 600;
    }
    /* 서버에서 내려오는 .invalid-feedback 에도 동일한 에러 색상 적용 */
    .form-control.is-invalid ~ .invalid-feedback,
    .form-control.is-invalid ~ .form-feedback-custom {
        color: #c62828 !important;
    }
    /* 약관 동의 박스 내부 링크 */
    #agreeBox .form-check-label a {
        /* 약관 링크 색상을 더 진한 보라색으로 변경 */
        color: #8a3be2;
        text-decoration: underline;
    }
    /* 하단 로그인 링크 */
    .login-link-custom a {
        /* 로그인 링크 색상을 더 진한 보라색으로 변경 */
        color: #8a3be2;
        font-weight: 600;
    }
    .login-link-custom a:hover {
        /* 호버 시 로그인 링크 색상을 더 깊고 어두운 보라색으로 변경 */
        color: #6a2ccf;
    }
</style>
</head>
<body class="d-flex align-items-center justify-content-center min-vh-100 py-4 py-md-5 ${bodyText }">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-10 col-lg-9 col-xl-8">
                <div class="card p-4 p-lg-5">
                    <div class="card-body">
                        <div class="text-center mb-4" style="position: relative;">
                            <a href="${pageContext.request.contextPath}/" class="h1 text-decoration-none ddtown-title"><b>DDTOWN</b></a>
							<button class="btn btn-secondary btn-sm" id="userBtn" style="position: absolute; right:0;">유저</button>
                        </div>
	                        <p class="text-center mb-4 lead">회원가입</p>
                        <form action="/auth/signup.do" method="post" id="signupForm">
                            <sec:csrfInput/>

                            <div class="mb-3 text-start">
                                <label for="username" class="form-label">아이디</label>
                                <div class="input-group">
                                    <input type="text" class="form-control <c:if test='${not empty errors.username}'>is-invalid</c:if>" id="username" name="username" value="${member.username }" placeholder="아이디는 영문, 숫자, 밑줄(_), 하이픈(-)만 사용할 수 있습니다." required>
                                    <button class="btn btn-check-custom" type="button" id="usernameCheckBtn">중복확인</button>
                                </div>
                                <div id="usernameFeedback" class="form-feedback-custom <c:if test='${not empty errors.username}'>text-danger-custom</c:if>">
    	                            <c:if test="${not empty errors.username}">
                                        ${errors.username}
	                                </c:if>
                                </div>
                            </div>

                            <div class="mb-3 text-start">
                                <label for="password" class="form-label">비밀번호</label>
                                <input type="password" class="form-control <c:if test='${not empty errors.password}'>is-invalid</c:if>" id="password" name="password" placeholder="비밀번호를 입력해주세요" required>
                                <div id="passwordCaps" class="d-none form-text text-danger small">
			                    	Caps Lock이 켜져 있습니다.
			                    </div>
                                <div id="passwordFeedback" class="form-feedback-custom <c:if test='${not empty errors.memPw}'>text-danger-custom</c:if>">
	                                <c:if test="${not empty errors.memPw}">
                                        ${errors.memPw}
	                                </c:if>
                                </div>
                            </div>

                            <div class="mb-3 text-start">
                                <label for="passwordConfirm" class="form-label">비밀번호 확인</label>
                                <input type="password" id="passwordConfirm" name="passwordConfirm" class="form-control" placeholder="비밀번호를 한번 더 입력해주세요" required>
                                <div id="passwordConfirmCaps" class="d-none form-text text-danger small">
			                    	Caps Lock이 켜져 있습니다.
			                    </div>
                                <div class="form-feedback-custom" id="passwordConfirmError"></div>
                            </div>

                            <div class="row g-2 mb-3 text-start">
                                <div class="col">
                                    <label for="memLastNm" class="form-label">성 (Last Name)</label>
                                    <input type="text" class="form-control <c:if test='${not empty errors.peoLastNm}'>is-invalid</c:if>" id="peoLastNm" name="peoLastNm" value="${member.peoLastNm}" placeholder="성을 입력해주세요" required>
                                   	<div id="peoLastNmFeedback" class="form-feedback-custom <c:if test='${not empty errors.peoLastNm}'>text-danger-custom</c:if>">
	                                     <c:if test="${not empty errors.peoLastNm}">
                                            ${errors.peoLastNm}
    	                                </c:if>
                                    </div>
                                </div>
                                <div class="col">
                                    <label for="memFirstNm" class="form-label">이름 (First Name)</label>
                                    <input type="text" class="form-control <c:if test='${not empty errors.peoFirstNm}'>is-invalid</c:if>" id="peoFirstNm" name="peoFirstNm" value="${member.peoFirstNm}" placeholder="이름을 입력해주세요" required>
                                    <div id="peoFirstNmFeedback" class="form-feedback-custom <c:if test='${not empty errors.peoFirstNm}'>text-danger-custom</c:if>">
                                    	<c:if test="${not empty errors.peoFirstNm}">
                                            ${errors.peoFirstNm}
                                    	</c:if>
                                    </div>
                                </div>
                            </div>

		                    <div class="mb-3 text-start">
		                        <label class="form-label">성별</label>
		                        <div class="gender-options">
		                            <div class="form-check form-check-inline">
		                                <input class="form-check-input" type="radio" name="peoGender" id="genderMale" value="M" checked>
		                                <label class="form-check-label" for="genderMale">남자 (Male)</label>
		                            </div>
		                            <div class="form-check form-check-inline">
		                                <input class="form-check-input" type="radio" name="peoGender" id="genderFemale" value="F">
		                                <label class="form-check-label" for="genderFemale">여자 (Female)</label>
		                            </div>
		                        </div>
		                    </div>

                            <div class="mb-3 text-start">
                                <label for="memNicknm" class="form-label">닉네임</label>
                                <div class="input-group">
                                    <input type="text" class="form-control <c:if test='${not empty errors.memNicknm}'>is-invalid</c:if>" id="memNicknm" name="memNicknm" value="${member.memNicknm}" placeholder="닉네임을 입력해주세요">
                                    <button class="btn btn-check-custom" type="button" id="nickCheckBtn">중복확인</button>
                                </div>
                                <div id="nicknameFeedback" class="form-feedback-custom <c:if test='${not empty errors.memNicknm}'>text-danger-custom</c:if>">
    	                            <c:if test="${not empty errors.memNicknm}">
                                        ${errors.memNicknm}
	                                </c:if>
                                </div>
                            </div>

                            <div class="mb-3 text-start">
                                <label for="peoEmail" class="form-label">이메일 주소</label>
                                <div class="input-group">
                                    <input type="email" class="form-control <c:if test='${not empty errors.peoEmail}'>is-invalid</c:if>" id="peoEmail" name="peoEmail" value="${member.peoEmail }" placeholder="이메일을 입력해주세요">
                                    <button class="btn btn-check-custom" type="button" id="emailCheckBtn">중복확인</button>
                                </div>
                                <div id="emailFeedback" class="form-feedback-custom <c:if test='${not empty errors.peoEmail}'>text-danger-custom</c:if>">
	                                <c:if test="${not empty errors.peoEmail}">
                                        ${errors.peoEmail}
	                                </c:if>
                                </div>
                            </div>

                            <div class="mb-4 text-start"> <label for="peoPhone" class="form-label">휴대폰 번호</label>
                                <div class="input-group">
                                    <input type="tel" id="peoPhone" name="peoPhone" class="form-control" placeholder="'-' 없이 숫자만 입력">
                                </div>
                                <div id="phoneFeedback" class="form-feedback-custom"></div>
                            </div>

                            <div class="mb-4 text-start">
                            	<input type="hidden" name="memBirth" id="memBirth"/>
                                <label for="birthYear" class="form-label">생년월일</label>
                                <div class="row g-1">
                                    <div class="col">
                                        <select id="birthYear" name="birthYear" class="form-select w-100" title="년도 선택">
                                            <option value="">년</option>
                                        </select>
                                    </div>
                                    <div class="col">
                                        <select id="birthMonth" name="birthMonth" class="form-select w-100" title="월 선택">
                                            <option value="">월</option>
                                        </select>
                                    </div>
                                    <div class="col">
                                        <select id="birthDay" name="birthDay" class="form-select w-100" title="일 선택">
                                            <option value="">일</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-1 text-start">
                            	<p class="form-label">주소</p>
                            	<div class="d-flex">
									<input type="text" class="form-control" id="memPostCode" name="memZipCode" placeholder="우편번호찾기를 해주세요" readonly>
									<span class="input-group-append">
										<button type="button" class="btn btn-secondary btn-sm btn-flat" onclick="DaumPostcode()">우편번호 찾기</button>
									</span>
                            	</div>
                            	<div id="memZipCodeFeedback" class="form-feedback-custom">
                                </div>
							</div>
							<div class="mb-1 text-start">
								<p class="form-label">기본 주소</p>
								<input type="text" class="form-control" id="memAddress1" name="memAddress1" placeholder="우편번호찾기를 해주세요" readonly>
                            	<div id="memAddressFeedback" class="form-feedback-custom">
                                </div>
							</div>
							<div class="mb-5 text-start">
								<p class="form-label">상세 주소</p>
								<input type="text" class="form-control" id="memAddress2" name="memAddress2" placeholder="상세주소를 입력해주세요">
							</div>

                            <div class="card p-3 text-start mb-4 rounded-3 border" id="agreeBox">
                                <div class="form-check border-bottom pb-2 mb-2">
                                    <input class="form-check-input" type="checkbox" id="agreeAll" name="agreeAll" required>
                                    <label class="form-check-label fw-bold" for="agreeAll">
                                        전체 약관에 동의합니다.
                                    </label>
                                </div>
                                <div class="form-check mb-1">
                                    <input class="form-check-input" type="checkbox" id="memAgree" name="memAgree" value="Y">
                                    <label class="form-check-label small" for="memAgree">
                                        (필수) 이용약관 동의
                                    </label>
                                    <a href="#" class="ms-1 text-decoration-none small" target="_blank" title="개인정보방침 보기">[개인정보방침 보기]</a>
                                </div>
                                <div class="form-check mb-1">
                                    <input class="form-check-input" type="checkbox" id="agreeTermsPrivacy" name="agreeTerms" value="Y">
                                    <label class="form-check-label small" for="agreeTermsPrivacy">
                                        (필수) 개인정보 수집 및 이용 동의
                                    </label>
                                    <a href="#" class="ms-1 text-decoration-none small" target="_blank" title="개인정보 수집 및 이용 동의 보기">[보기]</a>
                                </div>
                            </div>


                            <div class="row g-2">
                                <div class="col-md-8 mb-2 mb-md-0">
                                    <div>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-2 mb-md-0 d-flex gap-2" >
                                    <button type="submit" class="ea-btn btn-primary" id="signupBtn">가입하기</button>
                                    <button type="button" class="ea-btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/login'">뒤로가기</button>
                                </div>
                            </div>
                        </form>


                        <div class="text-center mt-4 small login-link-custom">
                            이미 회원이신가요? <a href="/login" class="text-decoration-none fw-bold">로그인</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
	<%@ include file="../modules/footerPart.jsp" %>

	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</body>
<script type="text/javascript">
$(function(){

	// 아이디 중복확인 이벤트 영역
	let usernameCheckBtn = $("#usernameCheckBtn");		// 아이디 중복확인 버튼 Element
	let idCheckFlag = false;				// 중복확인 flag(true:중복체크 완료, false: 중복체크 미완료)

	// 닉네임 중복확인 이벤트 영역
	let nickCheckBtn = $("#nickCheckBtn");		// 닉네임 중복확인 버튼 Element
	let nickCheckFlag = false;				// 중복확인 flag(true:중복체크 완료, false: 중복체크 미완료)

	// 이메일 중복확인 이벤트 영역
	let emailCheckBtn = $("#emailCheckBtn");		// 이메일 중복확인 버튼 Element
	let emailCheckFlag = false;				// 중복확인 flag(true:중복체크 완료, false: 중복체크 미완료)

	// 비밀번호 확인 이벤트
	let password = $("#password")
	let passwordConfirm = $("#passwordConfirm");
	let passwordCheckFlag = false;
	// 가입하기 영역
	let signupBtn = $("#signupBtn"); 		// 가입하기 버튼 Element
	let signupForm = $("#signupForm");		// 가입하기 Form Element

	// 약관 동의 관련
	let agreeBox = $("#agreeBox");
	let agreeAll = $("#agreeAll");
	let memAgree = $("#memAgree"); // 약관동의체크박스
	let agreeTermsPrivacy = $("#agreeTermsPrivacy"); //개인정보 수신 동의체크박스
	let agreeTermsMarketing = $("#agreeTermsMarketing"); // 마켓팅 수신 동의 체크박스

	$("#username").on("change",function(){
		idCheckFlag = false;
	});
	$("#memNicknm").on("change",function(){
		nickCheckFlag = false;
	})
	$("#peoEmail").on("change",function(){
		emailCheckFlag = false;
	})

	// 아이디 중복확인 버튼 이벤트
	usernameCheckBtn.on("click",function(){
		let usernameInput = $("#username");
		let username = $("#username").val();	// 입력한 아이디 값

		if (!signupForm.validate().element(usernameInput)) {
			idCheckFlag = false;
	        return false;
	    }

		let data = {
			username : username
		};

		$.ajax({
			url : "/auth/idCheck",
			type : "post",
			data : JSON.stringify(data),
			contentType : "application/json; charset=utf-8",
			beforeSend : function(xhr) {
		        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		    },
			success : function(res){
				let usernameFeedback = $("#usernameFeedback");	// error 클래스를 가지고있는 element 중 id요소에 해당하는 Element
				if(res == "NOTEXIST"){	// 아이디 사용가능
					sweetAlert("success","사용가능한 아이디입니다.");
					usernameFeedback.html("사용가능한 아이디입니다!").removeClass("text-danger-custom").addClass("text-success-custom");
					idCheckFlag = true;
				}else{					// 중복된 아이디 사용 불가능
					sweetAlert("error","이미 사용 중인 아이디 입니다.");
					usernameFeedback.html("이미 사용 중인 아이디 입니다.").removeClass("text-success-custom").addClass("text-danger-custom");
					idCheckFlag = false;
				}
			}

		});
	});

	// 닉네임 중복확인 버튼 이벤트
	nickCheckBtn.on("click",function(){
		let nickname = $("#memNicknm");
		let nick = $("#memNicknm").val();	// 입력한 아이디 값

		if (!signupForm.validate().element(nickname)) {
	        nickCheckFlag = false; // 닉네임 중복확인 플래그 초기화
	        return false;
	    }

		let data = {
			memNicknm : nick
		};

		$.ajax({
			url : "/auth/nickCheck",
			type : "post",
			data : JSON.stringify(data),
			contentType : "application/json; charset=utf-8",
			beforeSend : function(xhr) {
		        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		    },
			success : function(res){
				let nicknameFeedback = $("#nicknameFeedback");	// error 클래스를 가지고있는 element 중 id요소에 해당하는 Element
				if(res == "NOTEXIST"){	// 닉네임 사용가능
					sweetAlert("success","사용가능한 닉네임입니다.");
					nicknameFeedback.html("사용가능한 아이디입니다!").css("color","green");
					nickCheckFlag = true;
				}else{					// 중복된 닉네임 사용 불가능
					sweetAlert("error","이미 사용 중인 닉네임 입니다.").removeClass("text-danger-custom").addClass("text-success-custom");
					nicknameFeedback.html("이미 사용 중인 닉네임 입니다.").removeClass("text-success-custom").addClass("text-danger-custom");
					nickCheckFlag = false;
				}
			}

		});
	});
	// 이메일 중복확인 버튼 이벤트
	emailCheckBtn.on("click",function(){
		let emailInput = $("#peoEmail");
		let email = $("#peoEmail").val();	// 입력한 아이디 값

		if (!signupForm.validate().element(emailInput)) {
	        emailCheckFlag = false;
	        return false;
	    }

		let data = {
			peoEmail : email
		};

		$.ajax({
			url : "/auth/emailCheck",
			type : "post",
			data : JSON.stringify(data),
			contentType : "application/json; charset=utf-8",
			beforeSend : function(xhr) {
		        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		    },
			success : function(res){
				let emailFeedback = $("#emailFeedback");	// error 클래스를 가지고있는 element 중 id요소에 해당하는 Element
				if(res == "NOTEXIST"){	// 아이디 사용가능
					sweetAlert("success","사용가능한 이메일입니다.");
					emailFeedback.html("사용가능한 이메일입니다!").removeClass("text-danger-custom").addClass("text-success-custom");
					emailCheckFlag = true;
				}else{					// 중복된 아이디 사용 불가능
					sweetAlert("error","이미 사용 중인 이메일 입니다.");
					emailFeedback.html("이미 사용 중인 이메일 입니다.").removeClass("text-success-custom").addClass("text-danger-custom");
					emailCheckFlag = false;
				}
			}

		});
	});

	let capsLockToggle = false;

	$(document).on("keydown",function(e){
		if(e.keyCode == 20){
			capsLockToggle = !capsLockToggle;
		}

		if(capsLockToggle && password.is(":focus")){
			$("#passwordCaps").removeClass("d-none");
		}else{
			$("#passwordCaps").addClass("d-none");
		}

		if(capsLockToggle && passwordConfirm.is(":focus")){
			$("#passwordConfirmCaps").removeClass("d-none");
		}else{
			$("#passwordConfirmCaps").addClass("d-none");
		}
	})

	const pwRegEx = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,16}$/;
	password.on("blur",function(){
		$("#passwordCaps").addClass("d-none");
		let pwVal = password.val();
		if(!pwRegEx.test(pwVal)){
			$("#passwordFeedback").html("8~16자 영문, 숫자, 특수문자 조합이어야 합니다.").removeClass("text-success-custom").addClass("text-danger-custom");
			passwordCheckFlag = false;
			return false;
		}else{
			passwordCheckFlag = true;
			$("#passwordFeedback").html("").removeClass("text-danger-custom text-success-custom");
		}

	}).on("keyup",pwcheck).on("focus",function(){
		if(capsLockToggle){
			$("#passwordCaps").removeClass("d-none");
		}
	})
	passwordConfirm.on("keyup",pwcheck).on("blur",function(){
		$("#passwordConfirmCaps").addClass("d-none");
	}).on("focus",function(){
		if(capsLockToggle){
			$("#passwordConfirmCaps").removeClass("d-none");
		}
	})


	// 약관 동의 파트
	agreeAll.on("click",function(){
			$("input[type='checkbox']",agreeBox).prop("checked",$(this).prop("checked"));
	});

	// 약관 전체체크 개별 트리거
	$("input[type='checkbox']",agreeBox).on("click",function(){
		let length = $("input[type='checkbox']:not(#agreeAll):checked",agreeBox).length
		if(length < 2){
			agreeAll.prop("checked",false);
		}else{
			agreeAll.prop("checked",true);
		}

	})

	// 생년월일 동적 생성
	let birthYear = $("#birthYear");
	let birthMonth = $("#birthMonth");
	let birthDay = $("#birthDay");

	let date = new Date();
	let year = date.getFullYear();
	for(let i = year - 14 ; i >= 1950; i--){
		birthYear.append(new Option(i,i));
	}
	for(let i = 1; i<=12; i++){
		birthMonth.append(new Option(String(i).padStart(2,'0'),String(i).padStart(2,'0')));
	}
	function createDay(){
		let year = parseInt(birthYear.val());
		let month = parseInt(birthMonth.val());
		year = isNaN(year) ? 1995 : year;
		month = isNaN(month) ? 12 : month;
		birthDay.empty()
		birthDay.append(new Option("일",""))

		if(year != "" && month != ""){
			let day = new Date(year, month, 0).getDate();
			for(let i = 1; i<=day; i++){
				birthDay.append(new Option(String(i).padStart(2,'0'),String(i).padStart(2,'0')))
			}
		}

	}
	birthYear.on("change",createDay);
	birthMonth.on("change",createDay);
	createDay();


	// 밸리데이션 적용하기
	$.validator.addMethod("usernamePattern", function(value, element) {
        return this.optional(element) || /^[a-zA-Z0-9_-]+$/.test(value);
    }, "아이디는 영문, 숫자, 밑줄(_), 하이픈(-)만 사용할 수 있습니다.");

	$.validator.addMethod("passwordCheck",function(value,element){
		return this.optional(element) || /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,16}$/i.test(value);
	},"비밀번호는 특수문자가 1개 이상 포함되어야하며 8~16자리 입니다.");

	$.validator.addMethod("customEmail",function(value,element){
		return this.optional(element) || /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/i.test(value);
	},"이메일 양식에 맞게 작성해주세요");
	$.validator.addMethod("customPhone",function(value,element){
		return this.optional(element) || /^01(?:0|1|[6-9])(?:\d{3}|\d{4})\d{4}$/i.test(value);
	},"휴대폰번호(01X로 시작하는 숫자 10~11자리를 입력해주세요.");

	signupForm.validate({
		rules: {                    // 유효성 검사 규칙
            username: {             // 이름 필드
                required: true,     // 필수 입력
                minlength : 2,       // 최소 입력 길이
                maxlength : 50,
                usernamePattern : true
            },
            password: {             // 비밀번호 필드
            	required: true,     // 필수 입력
                minlength: 8,        // 최소 입력 길이
                maxlength: 16,		// 최대 입력길이
                passwordCheck : true
            },
            confirmPassword: {     // 비밀번호 재확인 필드
            	required: true,     // 필수 입력
                minlength: 8,       // 최소 입력 길이,
                maxlength: 16,
                equalTo: "#password"   // 비밀번호 필드와 동일한 값을 가지도록
            },
            memNicknm: {
            	required :true,
            	maxlength : 30
            },
            peoGender: {
            	required :true
            },
            peoLastNm : {
            	required : true,
            	maxlength : 100
            },
            peoFirstNm : {
            	required : true,
            	maxlength : 100
            },
            peoEmail: {                // 이메일 필드
                required: true,     // 필수 입력
                customEmail : true,
                maxlength : 50
            },
            memBirth : {
            	required : true
            },
            peoPhone: {             // 연락처 필드
                required: true,     // 필수 입력
                customPhone : true,
                maxlength: 11
            },
            memZipCode : {
            	required : true
            },
            memAddress1 :{
            	required : true,
            	maxlength : 30
            },
            memAddress2 : {
            	maxlength : 30
            }
        },
        messages: {                 // 오류값 발생시 출력할 메시지 수동 지정
        	username: {
                required: '필수 입력 항목입니다.',
                minlength: '최소 {0}글자 이상 입력하세요.',
                maxlength: '최대 {0}글자 미만으로 입력하세요.'
            },
            password: {
                required: '필수 입력 항목입니다.',
                minlength: '최소 {0}글자 이상 입력하세요.',
                maxlength: '최대 {0}글자 미만 입력해주세요'
            },
            confirmPassword: {
                required: '필수 입력 항목입니다.',
                minlength: '최소 {0}글자 이상 입력하세요.',
                maxlength: '최대 {0}글자 미만 입력해주세요',
                equalTo: '동일한 비밀번호를 입력해 주세요.'
            },
            memNicknm : {
            	required : '필수 입력 항목입니다.',
            	maxlength : '최대 {0} 글자의 닉네임을 입력해주세요.'
            },
            memBirth : {
            	required : "필수 입력 항목입니다."
            },
            peoEmail: {
                required: '필수 입력 항목입니다.',
                maxlength : '{0} 미만의 이메일 주소를 입력해주세요'
            },
            peoPhone: {
                required: '필수 입력 항목입니다.',
                maxlength : '휴대폰 번호는 -없이 10~11자리 입니다'
            },
            peoLastNm: {
                required: '필수 입력 항목입니다.',
                maxlength : '{0} 자리 미만의 성을 입력해주세요'
            },
            peoFirstNm: {
                required: '필수 입력 항목입니다.',
                maxlength : '{0} 자리 미만의 이름을 입력해주세요'
            },
            memZipCode : {
            	required : "우편번호 찾기를 통해 주소를 입력해주세요."
            },
            memAddress1 :{
            	required : "필수 입력 항목입니다.",
            	maxlength : "{0} 자리 미만의 주소를 입력해주세요."
            },
            memAddress2 : {
            	maxlength : "{0} 자리 미만의 주소를 입력해주세요."
            },
            agreeAll : {
            	required : ""
            }
        },
        errorElement: "span", // 오류 메시지를 div 태그로 감쌉니다.
        errorPlacement: function(error, element) {
            // 각 필드의 name 속성을 확인하여 적절한 위치에 오류 메시지를 표시합니다.
            if (element.attr("name") == "username") {
            	$("#usernameFeedback").empty().append(error);
            } else if (element.attr("name") == "password") {
            	$("#passwordFeedback").empty().append(error);
            } else if (element.attr("name") == "confirmPassword") {
            	$("#passwordConfirmError").empty().append(error);
            } else if (element.attr("name") == "peoPhone") {
            	$("#phoneFeedback").empty().append(error);
            } else if (element.attr("name") == "peoLastNm") {
            	$("#peoLastNmFeedback").empty().append(error);
            } else if (element.attr("name") == "peoFirstNm") {
            	$("#peoFirstNmFeedback").empty().append(error);
            } else if (element.attr("name") == "memNicknm") {
            	$("#nicknameFeedback").empty().append(error);
            } else if (element.attr("name") == "peoEmail") {
            	$("#emailFeedback").empty().append(error);
            } else if (element.attr("name") == "memZipCode") {
            	$("#memZipCodeFeedback").empty().append(error);
            } else if (element.attr("name") == "memAddress1") {
            	$("#memAddressFeedback").empty().append(error);
            } else if (element.attr("name") == "agreeAll") {
            	$("#agreeFeedback").empty().append(error);
            } else {
                // 다른 필드들은 기본 위치에 오류 메시지를 표시하거나,
                // 필요에 따라 추가적인 errorPlacement 로직을 구현합니다.
                error.insertAfter(element);
            }
            // 사용자 정의 스타일 적용
            if (error.text() !== "") {
                error.addClass('form-feedback-custom text-danger-custom');
            }
        },
        highlight: function(element, errorClass, validClass) {
            // 유효하지 않은 필드에 대한 스타일링 (옵션)
            $(element).addClass("is-invalid").removeClass("is-valid");
        },
        unhighlight: function(element, errorClass, validClass) {
            // 유효한 필드에 대한 스타일링 (옵션)
            $(element).removeClass("is-invalid").addClass("is-valid");
            if ($(element).attr("name") == "username") {
            	$("#usernameFeedback").empty();
            } else if ($(element).attr("name") == "password") {
            	$("#passwordFeedback").empty();
            } else if ($(element).attr("name") == "confirmPassword") {
            	$("#passwordConfirmError").empty();
            } else if ($(element).attr("name") == "peoLastNm") {
            	$("#peoLastNmFeedback").empty();
            } else if ($(element).attr("name") == "peoFirstNm") {
            	$("#peoFirstNmFeedback").empty();
            } else if ($(element).attr("name") == "memNicknm") {
            	$("#nicknameFeedback").empty();
            } else if ($(element).attr("name") == "peoEmail") {
            	$("#emailFeedback").empty();
            } else if ($(element).attr("name") == "peoPhone") {
                $("#phoneFeedback").empty().removeClass("text-danger-custom text-success-custom");
            }
        },
        submitHandler: function(form){

        	let passwordFiledsEmpty = $("#password").val().trim() === '' && $("#confirmPassword").val().trim() === '';

        	let year = birthYear.val();
    		let month = birthMonth.val();
    		let day = birthDay.val();

    		if(year && month && day){
    			$("#memBirth").val(year+"/"+month+"/"+day);
    		}else{
    			sweetAlert("error","생년월일을 모두 선택해주세요!");
    			return false;
    		}

    		let peoPhone = $("#peoPhone").val();
    		if(peoPhone.length == 11){
	    		peoPhone = peoPhone.substring(0,3) + "-" + peoPhone.substring(3,7) + "-" + peoPhone.substring(7);
				$("#peoPhone").val(peoPhone);
    		}else if(peoPhone.length == 10){
	    		peoPhone = peoPhone.substring(0,3) + "-" + peoPhone.substring(3,6) + "-" + peoPhone.substring(6);
				$("#peoPhone").val(peoPhone);
    		}



        	// 비밀번호 유효성 검사가 필요한 경우 (생성 모드이거나, 수정 모드에서 비밀번호를 입력한 경우)
            let needsPasswordValidation = !passwordFieldsEmpty;
            // 실제 비밀번호 유효성 (passwordCheckFlag는 외부에서 관리됨)
            let passwordActuallyValid = passwordCheckFlag;

            let finalPasswordCheck = true;
            if (needsPasswordValidation) {
                finalPasswordCheck = passwordActuallyValid;
            }

            if(!idCheckFlag){
            	sweetAlert("error", "ID 중복확인을 해주세요.");
                $("#usernameFeedback").html("ID 중복확인을 완료해주세요.").addClass("text-danger-custom").removeClass("text-success-custom");
                return false;
            }
            if(!finalPasswordCheck){
            	sweetAlert("error", "비밀번호를 확인해주세요.");
            	return false;
            }
            if(!nickCheckFlag){
            	sweetAlert("error", "닉네임 중복확인을 해주세요.");
                $("#nicknameFeedback").html("닉네임 중복확인을 완료해주세요.").addClass("text-danger-custom").removeClass("text-success-custom");
                return false;
            }
            if(!emailCheckFlag){
            	sweetAlert("error", "이메일 중복확인을 해주세요.");
                $("#emailFeedback").html("이메일 중복확인을 완료해주세요.").addClass("text-danger-custom").removeClass("text-success-custom");
                return false;
            }

        	if(idCheckFlag && finalPasswordCheck && nickCheckFlag && emailCheckFlag){
        		form.submit();
        	}
        }
    });

	//비밀번호 일치 확인
	function pwcheck(){
		let pw = $("#password").val();
		let pwconfirm = $("#passwordConfirm").val();
		let error = $("#passwordConfirmError");

		if(pwconfirm === "") {
			passwordCheckFlag = false;
			error.html("").removeClass("text-success-custom text-danger-custom");
            return;
       	}

		if(pw != pwconfirm){
			passwordCheckFlag = false;
			error.html("입력하신 비밀번호와 일치하지 않습니다!").removeClass("text-success-custom").addClass("text-danger-custom");
		}else{
			error.html("입력하신 비밀번호와 일치합니다").removeClass("text-danger-custom").addClass("text-success-custom");
			if(!pwRegEx.test(pw)){
				passwordCheckFlag = false;
			}else{
				passwordCheckFlag = true;
			}
		}
	}


	// 데이터 만들기
	$("#userBtn").on("click",function(){
		userData = {
			username : selectId(),
			password : "1q2w3e4r!",
			peoLastNm : selectLastNm(),
			peoFirstNm : selectFirstNm(),
			peoGender : Math.random() > 0.5 ? 'M' : "F",
			memNicknm : randomNickname(),
			peoEmail : selectEmail(),
			peoPhone : selectPhone(),
			birthYear : "1995",
			birthMonth : "12",
			birthDay : "14",
			memZipCode : "34908",
			memAddress1 : "대전 중구 계룡로 846",
			memAddress2 : "3층",
			memAgree : "true"
		}
		let {username,password,peoLastNm,peoFirstNm,peoGender,memNicknm
			,peoEmail,peoPhone,birthYear,birthMonth,birthDay,memZipCode
			,memAddress1,memAddress2,memAgree} = userData
		$("#username").val(username);
		$("#password").val(password);
		$("#passwordConfirm").val(password);
		$("#peoLastNm").val(peoLastNm);
		$("#peoFirstNm").val(peoFirstNm);
		if(peoGender == 'M'){
			$("#genderFemale").attr("checked",false);
			$("#genderMale").attr("checked",true);
		}else{
			$("#genderMale").attr("checked",false);
			$("#genderFemale").attr("checked",true);
		}
		$("#memNicknm").val(memNicknm);
		$("#peoEmail").val(peoEmail);
		$("#peoPhone").val(peoPhone);
		$("#birthYear").val(birthYear);
		$("#birthMonth").val(birthMonth);
		$("#birthDay").val(birthDay);
		$("#memPostCode").val(memZipCode);
		$("#memAddress1").val(memAddress1);
		$("#memAddress2").val(memAddress2);
		$("#agreeAll").attr("checked",true);
		$("#memAgree").attr("checked",true);
		$("#agreeTermsPrivacy").attr("checked",true);
	})

	function selectId(){
		const idList = [
		    "SkyBird", "SunRise", "MoonLit", "StarGlow", "PureSoul",
		    "KindOne", "WildFox", "CalmWys", "BrightXp", "GldnWay",
		    "AquaRun", "FireFly", "EchoHrt", "SwiftMz", "DeepSea",
		    "BoldLio", "FreeSprt", "NewHope", "TrueVib", "ZenMind",
		    "GudLuck", "FstStep", "NiceDay", "TopTier", "ArcWtch",
		    "BlazRdr", "CldDrp", "DazlSt", "EmberGo", "FrosBte",
		    "GleamXp", "HvnGate", "IroWill", "JmpStrT", "KwiKwiz",
		    "LgtWave", "MzicMd", "NblaRyn", "OceanDp", "PxlDrp",
		    "QikMov", "RynBowX", "SilvStm", "TnsionZ", "UniqUsr",
		    "VlvetDr", "WrdSmtH", "XyloFsh", "YounGld", "ZestFul",
		    "AlphaBt", "BetaGam", "DeltaXp", "EchLodg", "FrgRaid",
		    "GrimSgt", "HumnTch", "InfiNrD", "JoltMstr", "KngFshR",
		    "LushGrn", "MgeBlst", "NovStar", "OpalDrm", "PrimStp",
		    "QwikBlk", "RocKett", "SpcFlow", "TmPuls", "UrbnFx",
		    "VrtxRdr", "WtrMgn", "XenonXp", "YelloWn", "ZenithZ",
		    "AurOraB", "CrtalX", "DragnFl", "EmerLdG", "FlwrBm",
		    "GhstWlkr", "HppyFt", "IceBrkR", "JnglBoy", "KnglTch",
		    "LumenaR", "MysticM", "NtrlVib", "OrgCnsT", "PheonXp",
		    "QestFld", "RngRdr", "SnnyDay", "TrvlXpr", "UtopiaY",
		    "VrtuSol", "WndrLst", "XtraMlg", "YelDrgN", "ZpprFx",
		    "AcornWd", "BldHrt", "CmPndr", "DrkStar", "ElfnDr",
		    "FairyTp", "GrnDrmR", "HushPsh", "IronClD", "JolyRvr",
		    "KnghtX", "LghtShd", "MgnFyr", "NtrlGZ", "OwlWise",
		    "PrsntX", "QikSlv", "RmbrMe", "SleppR", "TigrEye",
		    "UndrGrw", "Vistion", "WildCat", "XcelEnt", "YellOwL",
		    "ZippyGn", "AuraMst", "BlckMr", "DrkAngl", "EssncX",
		    "FstWrd", "GldnEyE", "HapySng", "Invictu", "JrnyMp",
		    "KiloByte", "LoudMuz", "MgnfiyR", "NobelSt", "OptclFx",
		    "PrismXp", "QuikStp", "RchRch", "SptlFt", "TchMast",
		    "UmbraXp", "VlcanO", "Wzrdry", "XpandR", "YungGzR",
		    "ZeroGht", "ApexLeg", "BladeX", "ChronoX", "CyberX",
		    "DarkFx", "EchoXp", "FlyHigh", "GlowUp", "HuntXp",
		    "InvsnX", "JggrNt", "KoolGuy", "LumenX", "MageXp",
		    "NinjaX", "OmegaX", "Phoenix", "QuasarX", "RapidX",
		    "SonicX", "TitanX", "UltraX", "ViperX", "WizrdX",
		    "XtremeX", "YetiXp", "ZodicX", "AmzingX", "BraveX"
		];
		let random = Math.floor(Math.random() * idList.length);
		let num = Math.floor(Math.random() * 300) + 1;
		return idList[random]+num;
	}

	function selectLastNm(){
		const lastList = [
			  "강", "고", "권", "김", "남",
			  "류", "문", "박", "배", "성",
			  "송", "오", "이", "전", "정"
			]
		let random = Math.floor(Math.random() * lastList.length);
		return lastList[random];
	}
	function selectFirstNm(){
		const firstList = [
			  "가람", "가온", "가을", "가인", "가현", "정원", "정우", "정윤", "정인", "정현",
			  "다온", "다운", "다인", "다현", "단비", "재민", "재원", "재윤", "재현", "재희",
			  "라온", "라율", "라희", "로운", "로이", "지민", "지원", "지윤", "지은", "지훈",
			  "마루", "마음", "마하", "명준", "명훈", "찬솔", "찬영", "찬우", "찬희", "창민",
			  "바다", "바름", "보라", "보람", "보미", "하랑", "하율", "하은", "하준", "하진",
			  "사랑", "새론", "새롬", "새별", "새얀", "태민", "태양", "태우", "태윤", "태희",
			  "소담", "소라", "소민", "소율", "소현", "현우", "현준", "현지", "현아", "현승",
			  "수아", "수영", "수오", "수정", "수진", "혜원", "혜정", "혜진", "혜찬", "혜솔",
			  "시우", "시온", "시원", "시윤", "시현", "주원", "주연", "주은", "주현", "주혁",
			  "아름", "아인", "아윤", "여울", "영웅", "준서", "준영", "준우", "준혁", "준희"
			]
		let random = Math.floor(Math.random() * firstList.length);
		return firstList[random];
	}

	function randomNickname() {
	    const adjective = [
	        "행복한", "슬픈", "게으른", "슬기로운", "수줍은",
	        "그리운", "섹시한", "배고픈", "배부른", "부자", "재벌", "웃고있는", "깨발랄한"
	    ];
	    const name = "기린";
	    const number = Math.floor(Math.random() * 300) + 1; // 1부터 99까지의 난수 생성

	    // 배열을 섞는 함수 (Java의 Collections.shuffle과 동일한 기능)
	    function shuffleArray(array) {
	        for (let i = array.length - 1; i > 0; i--) {
	            const j = Math.floor(Math.random() * (i + 1));
	            [array[i], array[j]] = [array[j], array[i]]; // 배열 요소 교환
	        }
	        return array;
	    }

	    const shuffledAdjective = shuffleArray([...adjective]); // 원본 배열을 복사하여 섞음
	    const adj = shuffledAdjective[0]; // 섞인 배열에서 첫 번째 형용사 선택

	    return adj + name + number;
	}

	function selectEmail(){
		const emailList = [
			  "kimchulsoo@gmail.com", "leeyounghee@naver.com", "parkminsu@daum.net", "choisujin@kakao.com", "jungeunji@outlook.com",
			  "kimjihu@gmail.com", "leeseoah@naver.com", "parkjunho@hanmail.net", "choinayeon@kakao.com", "jungdonghyun@outlook.com",
			  "usertest01@gmail.com", "randomid23@naver.com", "myaccount45@daum.net", "supportteam67@kakao.com", "infodesk89@outlook.com",
			  "webmaster123@gmail.com", "adminonly45@naver.com", "servicecenter@daum.net", "contactus99@kakao.com", "helpline00@outlook.com",
			  "developerkim@gmail.com", "designerlee@naver.com", "plannerpark@daum.net", "marketingchoi@kakao.com", "salesjung@outlook.com",
			  "johndoe@gmail.com", "janesmith@naver.com", "chrislee@daum.net", "alexkim@kakao.com", "sarahpark@outlook.com",
			  "businessdev@gmail.com", "projectlead@naver.com", "solutionarch@daum.net", "dataanalyst@kakao.com", "hrmanager@outlook.com",
			  "happyuser77@gmail.com", "luckystar88@naver.com", "brightfuture99@daum.net", "goldenchance00@kakao.com", "silvercloud11@outlook.com",
			  "myprofile2024@gmail.com", "bestid2025@naver.com", "futurevision2026@daum.net", "smartchoice2027@kakao.com", "innovate2028@outlook.com",
			  "koreatech@gmail.com", "seoulbiz@naver.com", "busancity@daum.net", "jejuttravel@kakao.com", "asiapacific@outlook.com",
			  "officeworker@gmail.com", "studentlife@naver.com", "onlineshop@daum.net", "gameplayer@kakao.com", "musiclover@outlook.com",
			  "photographer@gmail.com", "artcreator@naver.com", "bookreader@daum.net", "moviefan@kakao.com", "foodlover@outlook.com",
			  "exerciseman@gmail.com", "travelbug@naver.com", "scienceguy@daum.net", "historybuff@kakao.com", "naturelove@outlook.com",
			  "techgeek@gmail.com", "codingmaster@naver.com", "webexpert@daum.net", "appdev@kakao.com", "sysadmin@outlook.com",
			  "designstudio@gmail.com", "creativemind@naver.com", "digitalart@daum.net", "visualdesign@kakao.com", "brandstory@outlook.com",
			  "customercare@gmail.com", "clientservice@naver.com", "communitymgr@daum.net", "eventplanner@kakao.com", "prspecialist@outlook.com",
			  "globalleader@gmail.com", "markettrend@naver.com", "futuretech@daum.net", "smartliving@kakao.com", "greenearth@outlook.com",
			  "dreammaker@gmail.com", "hopebuilder@naver.com", "peaceseeker@daum.net", "wisdomkeeper@kakao.com", "truthfinder@outlook.com",
			  "earlybird7am@gmail.com", "nightowl1am@naver.com", "middaybreak@daum.net", "weekendfun@kakao.com", "mondayblue@outlook.com"
			]
		let random = Math.floor(Math.random() * emailList.length);
		return emailList[random];
	}
	function selectPhone(){
		const phoneList = [
			  "01023456789", "01087654321", "01011223344", "01099887766", "01055551234",
			  "01000112233", "01078901234", "01043210987", "01067890123", "01034567890",
			  "01010102020", "01030304040", "01050506060", "01070708080", "01090902105",
			  "01012304567", "01087615432", "01022114433", "01077886655", "01012345670",
			  "01000011122", "01078912345", "01043201987", "01067809123", "01034506789",
			  "01023405678", "01087605432", "01011203344", "01099807766", "01055501234",
			  "01000102233", "01078901230", "01043210980", "01067890120", "01034567890",
			  "01010102020", "01030304040", "01050506060", "01070708080", "01090900000",
			  "01012345678", "01087654321", "01011223344", "01099887766", "01055551234",
			  "01000112233", "01078901234", "01043210987", "01067890123", "01034567890"
			]
		let random = Math.floor(Math.random() * phoneList.length);
		return phoneList[random];
	}

});

// 카카오 주소 API(주소 찾기)
function DaumPostcode() {
	new daum.Postcode({
		oncomplete: function(data) {
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var addr = ''; // 주소 변수
			var extraAddr = ''; // 참고항목 변수

			//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
			    addr = data.roadAddress;
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
			    addr = data.jibunAddress;
			}

			// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
			if(data.userSelectedType === 'R'){
			    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
			    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
			    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
			        extraAddr += data.bname;
			    }
			    // 건물명이 있고, 공동주택일 경우 추가한다.
			    if(data.buildingName !== '' && data.apartment === 'Y'){
			        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
			    }
			}

			// 우편번호와 주소 정보를 해당 필드에 넣는다.
			document.getElementById('memPostCode').value = data.zonecode;
			document.getElementById("memAddress1").value = addr;
			// 커서를 상세주소 필드로 이동한다.
			document.getElementById("memAddress2").focus();
		}
	}).open();
 }
</script>
</html>

