<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 관리자 - 아티스트 계정 관리</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.js"></script>
    <style>
        .artist-name-link {
            font-weight: 500;
            color: #007bff;
            text-decoration: none;
        }
        .artist-name-link:hover {
            text-decoration: underline;
        }
        .form-feedback-custom.text-success-custom {
	        color: #4caf50 !important;
	        font-weight: 600;
	    }
	    .form-feedback-custom.text-danger-custom {
	        color: #e53935 !important;
	        font-weight: 600;
	    }
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>

			<c:set var="artistVO" value="${data.artistVO }"/>
			<c:set var="memberVO" value="${artistVO.memberVO }"/>
			<c:set var="status" value="${data.status }"/>
			<c:set var="title" value="새 아티스트 등록"/>
			<c:set var="text" value="등록"/>
			<c:if test="${status eq 'U' }">
			<c:set var="title" value="아티스트 수정"/>
			<c:set var="text" value="수정"/>
			</c:if>
            <main class="emp-content">
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
					  <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/community/artist/list" style="color:black;">아티스트 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">아티스트 등록</li>
					</ol>
				</nav>
                <section class="ea-section">
                    <div class="ea-section-header">
                        <h2>${title }</h2>
                        <button type="button" id="artistDataBtn" class="btn btn-secondary btn-sm">아티스트</button>
                    </div>

                    <form class="ea-form" id="newArtistForm" action="/admin/community/artist/register" method="post" encType="multipart/form-data">
                    	<sec:csrfInput/>
                    	<c:if test="${status eq 'U' }">
	                    	<input type="hidden" name="artNo" value="${artistVO.artNo }">
	                    	<input type="hidden" name="memUsername" value="${artistVO.memUsername }">
	                    	<input type="hidden" name="artProfileImg" value="${artistVO.artProfileImg }">
                    	</c:if>
                        <div class="form-group">
                            <label for="username">아티스트 ID (시스템 내부용, 영문/숫자)</label>
                            <div class="input-group-button">
                                <input type="text" id="username" name="memberVO.username" value="${memberVO.username }" placeholder="예: ARTIST_A_GROUP, ARTIST_B_SOLO" <c:if test="${status eq 'U' }">readonly</c:if> required>
                                <c:if test="${status ne 'U' }">
	                                <button type="button" class="ea-btn" id="checkArtistIdBtn">중복확인</button>
                                </c:if>
                            </div>
                            <div id="usernameFeedback" class="form-feedback-custom">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="password">비밀번호</label>
                            <input type="password" id="password" name="memberVO.password" placeholder="비밀번호 입력" <c:if test="${status ne 'U' }"> required </c:if> >
                            <div id="passwordCaps" class="d-none form-text text-danger small">
		                    	Caps Lock이 켜져 있습니다.
		                    </div>
		                    <div id="passwordFeedback" class="form-feedback-custom">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">비밀번호 확인</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호 다시 입력" <c:if test="${status ne 'U' }"> required </c:if> >
                            <div id="passwordConfirmCaps" class="d-none form-text text-danger small">
		                    	Caps Lock이 켜져 있습니다.
		                    </div>
		                    <div class="form-feedback-custom" id="passwordConfirmError"></div>
                        </div>

                        <hr style="margin: 30px 0;">

                        <div class="form-group">
                            <label for="artNm">아티스트명</label>
                            <input type="text" id="artNm" name="artNm" value="${artistVO.artNm }"<c:if test="${status ne 'U' }"> required </c:if> >
                        </div>

                        <div class="form-group">
                            <label for="artistDebutDate">데뷔일</label>
                            <input type="text" id="artDebutdate" name="artDebutdate" value="${artistVO.artDebutdate }">
                        </div>

                        <div class="form-group">
                            <label for="artistProfileImage">프로필 이미지</label>
                            <input type="file" id="profileImg" name="profileImg" accept="image/*" class="ea-form-control" style="width:auto; height:auto; padding: 5px;">
                            <div>
	                            <img id="profileImgPreview" src="" alt="">
                            </div>
                        </div>

						<div class="row g-2 mb-3 text-start">
                            <div class="col">
                                <label for="peoLastNm" class="form-label">성 (Last Name)</label>
                                <input type="text" class="form-control" id="peoLastNm" name="memberVO.peoLastNm" value="${memberVO.peoLastNm}" placeholder="성을 입력해주세요">
                            </div>
                            <div class="col">
                                <label for="peoFirstNm" class="form-label">이름 (First Name)</label>
                                <input type="text" class="form-control" id="peoFirstNm" name="memberVO.peoFirstNm" value="${memberVO.peoFirstNm}" placeholder="이름을 입력해주세요">
                            </div>
                        </div>

                        <div class="mb-3 text-start">
	                        <label class="form-label">성별</label>
	                        <c:if test="${peoGender eq 'M' }">checked</c:if>
	                        <div class="gender-options">
	                            <div class="form-check form-check-inline">
	                                <input class="form-check-input" type="radio" name="memberVO.peoGender" id="genderMale" value="M" checked <c:if test="${memberVO.peoGender eq 'M' }">checked</c:if>>
	                                <label class="form-check-label" for="genderMale" style="width:50px; line-height: 1;">남자</label>
	                            </div>
	                            <div class="form-check form-check-inline">
	                                <input class="form-check-input" type="radio" name="memberVO.peoGender" id="genderFemale" value="F" <c:if test="${memberVO.peoGender eq 'F' }">checked</c:if>>
	                                <label class="form-check-label" for="genderFemale" style="width:50px; line-height: 1;">여자</label>
	                            </div>
	                        </div>
	                    </div>

	                    <div class="mb-3 text-start">
                            <label for="peoEmail" class="form-label">이메일 주소</label>
                            <input type="email" class="form-control" id="peoEmail" name="memberVO.peoEmail" value="${memberVO.peoEmail }" placeholder="이메일을 입력해주세요">
                        </div>

	                    <div class="mb-3 text-start">
                            <label for="memBirth" class="form-label">생일</label>
                            <input type="text" class="form-control" id="memBirth" name="memberVO.memBirth" value="${memberVO.memBirth }" placeholder="생일을 입력해주세요 yyyy/mm/dd">
                        </div>

                        <div class="mb-4 text-start"> <label for="peoPhone" class="form-label">휴대폰 번호</label>
                            <div class="input-group">
                                <input type="tel" id="peoPhone" name="memberVO.peoPhone" value="${memberVO.peoPhone }" class="form-control" placeholder="'-' 없이 숫자만 입력">
                            </div>
                            <div id="phoneFeedback" class="form-feedback-custom"></div>
                        </div>

                        <div class="form-group">
                            <label for="artContent">아티스트 소개</label>
                            <textarea id="artContent" name="artContent" placeholder="아티스트에 대한 간략한 소개를 입력하세요." class="ea-form-control">${artistVO.artContent }</textarea>
                        </div>



                        <div class="ea-form-actions">
                        	<c:if test="${status eq 'U' }">
	                            <a href="/admin/community/artist/detail?artNo=${artistVO.artNo }" class="ea-btn outline">취소</a>
                        	</c:if>
                        	<c:if test="${status ne 'U' }">
	                            <a href="/admin/community/artist/list" class="ea-btn outline">취소</a>
                        	</c:if>
                            <button type="submit" class="ea-btn primary" id="registerArtistBtn">${text }</button>
                        </div>
                    </form>
                </section>
            </main>
        </div>
    </div>
</body>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<script type="text/javascript">
let passwordCheckFlag = false;
let idCheckFlag = false;

$(function(){

	// 업데이트일때 브레드크럼 추가
	let updateFlag = "${status}"||'C';
	if(updateFlag == 'U'){
		let activebread = $("ol.breadcrumb").find("li.active");
		let bread = $(`<li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/community/artist/detail?artNo=${artistVO.artNo}" style="color:black;">아티스트 상세</a></li>`)
		activebread.text("아티스트 수정").before(bread);
	}


	let newArtistForm = $("#newArtistForm");	// 폼
	let checkArtistIdBtn = $("#checkArtistIdBtn");	// 아이디 중복체크
	let registerArtistBtn = $("#registerArtistBtn"); // 등록버튼
	let profileImgPreview = $("#profileImgPreview"); // 이미지 미리보기
	let profileImg = $("#profileImg"); // 이미지 파일

	// 이미지 미리보기 이벤트
	profileImg.on("change",function(){
		let files = this.files;
		let file = files[0];
		const maxSize = 2 * 1024 * 1024;
		if(!file.type.startsWith("image/")){
			sweetAlert("error", "이미지 파일만 선택가능합니다.");
			profileImg.val("");
			return false;
		}
		if(file.size > maxSize){
			sweetAlert("error", "파일사이즈는 2MB 제한입니다.");
			profileImg.val("");
			return false;
		}
		let reader = new FileReader();
		reader.onload = function(e){
			profileImgPreview.attr("src", e.target.result);
			profileImgPreview.css("width","150px");
			profileImgPreview.css("height","150px");
		}
		reader.readAsDataURL(file);
	});

	// 비밀번호 capslock 이벤트
	let password = $("#password")
	let confirmPassword = $("#confirmPassword");

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

		if(capsLockToggle && confirmPassword.is(":focus")){
			$("#passwordConfirmCaps").removeClass("d-none");
		}else{
			$("#passwordConfirmCaps").addClass("d-none");
		}
	})

	// 휴대폰번호 자동 완성
	$("#peoPhone").on("focus",function(){
		let val = $(this).val();
		val = val.replaceAll("-","");
		$(this).val(val)
	})

	// 휴대폰번호 - 자동완성
	$("#peoPhone").on("blur",function(){
		let val = $(this).val();
		let newVal = val;
		if(val.length == 11){
			newVal = val.substring(0,3) + "-" + val.substring(3,7) + "-" + val.substring(7)
		}else if(val.length == 10){
			newVal = val.substring(0,3) + "-" + val.substring(3,6) + "-" + val.substring(6)
		}
		$(this).val(newVal);
	})

	// 아이디 중복 체크
	if(checkArtistIdBtn){
		checkArtistIdBtn.on("click",function(){
			let username = $("#username").val();	// 입력한 아이디 값

			if(username == null || username.trim() == "") { // 아이디 입력이 비어있다면
				sweetAlert("error","아이디를 입력해주세요!");
				return false;
			}
			if(username.length > 50){
				sweetAlert("error", "아이디는 최대 50자 미만입니다.");
				idCheckFlag = false;
				return false;
			}
			if(!/^[a-zA-Z0-9_-]+$/.test(username)){
				sweetAlert("error", "아이디는 영문, 숫자, 밑줄(_), 하이픈(-)만 사용할 수 있습니다.");
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
				},
				error : function(err){
					usernameFeedback.html("ID 중복 확인 중 오류 발생").addClass("text-danger-custom").removeClass("text-success-custom");
					sweetAlert("error","ID 중복 확인 중 오류 발생")
					idCheckFlag = false;
				}
			});
		});
	}


	const myform = $("#newArtistForm");
	const currentStatus = '${status}';
	$.validator.addMethod("usernamePattern", function(value, element) {
        return this.optional(element) || /^[a-zA-Z0-9_-]+$/.test(value);
    }, "아이디는 영문, 숫자, 밑줄(_), 하이픈(-)만 사용할 수 있습니다.");

	$.validator.addMethod("passwordCheck",function(value,element){
		return this.optional(element) || /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,16}$/i.test(value);
	},"비밀번호는 특수문자가 1개 이상 포함되어야하며 8~16자리 입니다.");

	$.validator.addMethod("peoEmail",function(value,element)
			{
			return this.optional(element) || /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/i.test(value);
			},"이메일 양식에 맞게 작성해주세요");

	myform.validate({
		rules: {                    // 유효성 검사 규칙
            "memberVO.username": {             // 이름 필드
                required: true,     // 필수 입력
                minlength : 2,       // 최소 입력 길이
                maxlength : 50,		// 최대 입력 길이
                usernamePattern : true
            },
            "memberVO.password": {             // 비밀번호 필드
            	required: function(element) {
                    // 'U' (수정) 모드가 아닐 경우 항상 필수
                    if (currentStatus !== 'U') {
                        return true;
                    }
                    // 'U' (수정) 모드일 경우, 비밀번호 확인 필드에 값이 있거나, 현재 필드에 값이 있으면 필수
                    // 사용자가 비밀번호를 변경하려고 입력하기 시작하면 유효성 검사 적용
                    return $("#confirmPassword").val().length > 0 || $(element).val().length > 0;
                },     // 필수 입력
                minlength: 8,        // 최소 입력 길이
                maxlength: 16,		// 최대 입력길이
                passwordCheck : true
            },
            confirmPassword: {     // 비밀번호 재확인 필드
            	required: function(element) {
                    // 'U' (수정) 모드가 아닐 경우 항상 필수
                    if (currentStatus !== 'U') {
                        return true;
                    }
                    // 'U' (수정) 모드일 경우, 비밀번호 필드에 값이 있으면 필수
                    return $("#password").val().length > 0;
                },     // 필수 입력
                minlength: 8,       // 최소 입력 길이,
                maxlength: 16,
                equalTo: "#password"   // 비밀번호 필드와 동일한 값을 가지도록
            },
            artNm : {
            	required : true,
            	maxlength : 100
            },
            profileImg : {
            	required: function(element) {
                    // 'U' (수정) 모드가 아닐 경우 (즉, 생성 모드일 경우)에만 필수
                    return currentStatus !== 'U';
                }
            },
            "memberVO.peoGender": {
            	required :true
            },
            "memberVO.peoLastNm" : {
            	required : true,
            	maxlength : 100
            },
            "memberVO.peoFirstNm" : {
            	required : true,
            	maxlength : 100
            },
            "memberVO.peoEmail": {                // 이메일 필드
                required: true,     // 필수 입력
                peoEmail : true,
                maxlength : 50
            },
            "memberVO.memBirth" : {
            	required : true
            },
            "memberVO.peoPhone": {             // 연락처 필드
                required: true,     // 필수 입력
                maxlength: 13
            },
            "artContent" : {
            	required : true,
                maxlength : 300
            }
        },
        messages: {                 // 오류값 발생시 출력할 메시지 수동 지정
        	"memberVO.username": {
                required: '필수 입력 항목입니다.',
                minlength: '최소 {0}글자 이상 입력하세요.',
                maxlength: '최대 {0}글자 미만으로 입력하세요.'
            },
            "memberVO.password": {
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
            artNm : {
            	required : "필수 입력 항목입니다.",
            	maxlength : "{0} 미만의 아티스트 명을 입력해주세요"
            },
            profileImg : {
            	required : "필수 입력 항목입니다."
            },
            "memberVO.memBirth" : {
            	required : "필수 입력 항목입니다."
            },
            "memberVO.peoEmail": {
                required: '필수 입력 항목입니다.',
                email: '올바른 이메일 형식으로 입력하세요.',
                maxlength : '{0} 미만의 이메일 주소를 입력해주세요'
            },
            "memberVO.peoPhone": {
                required: '필수 입력 항목입니다.',
                maxlength : '휴대폰 번호는 -없이 10~11자리 입니다'
            },
            "memberVO.peoLastNm": {
                required: '필수 입력 항목입니다.',
                maxlength : '{0} 자리 미만의 성을 입력해주세요'
            },
            "memberVO.peoFirstNm": {
                required: '필수 입력 항목입니다.',
                maxlength : '{0} 자리 미만의 이름을 입력해주세요'
            },
            artContent : {
            	required : "필수 입력 항목입니다.",
                maxlength : '{0} 자리 미만의 내용을 입력해주세요'
            }
        },
        errorElement: "div", // 오류 메시지를 div 태그로.
        errorPlacement: function(error, element) {
            // 각 필드의 name 속성을 확인하여 적절한 위치에 오류 메시지를 표시.
            if (element.attr("name") == "memberVO.username") {
            	$("#usernameFeedback").empty().append(error);
            } else if (element.attr("name") == "memberVO.password") {
            	$("#passwordFeedback").empty().append(error);
            } else if (element.attr("name") == "confirmPassword") {
            	$("#passwordConfirmError").empty().append(error);
            } else if (element.attr("name") == "memberVO.peoPhone") {
            	$("#phoneFeedback").empty().append(error);
            } else {
                // 다른 필드들은 기본 위치에 오류 메시지를 표시
                error.insertAfter(element);
            }
            // 사용자 정의 스타일 적용
            if (error.text() !== "") {
                error.addClass('form-feedback-custom text-danger-custom');
            }
        },
        highlight: function(element, errorClass, validClass) {
            $(element).addClass("is-invalid").removeClass("is-valid");
        },
        unhighlight: function(element, errorClass, validClass) {
            $(element).removeClass("is-invalid").addClass("is-valid");
            if ($(element).attr("name") == "memberVO.username") {
            	$("#usernameFeedback").empty();
            } else if ($(element).attr("name") == "memberVO.password") {
            	$("#passwordFeedback").empty();
            } else if ($(element).attr("name") == "confirmPassword") {
            	$("#passwordConfirmError").empty();
            } else if ($(element).attr("name") == "memberVO.peoPhone") {
                $("#phoneFeedback").empty().removeClass("text-danger-custom text-success-custom");
            }
        },
        submitHandler: function(form){
        	let performIdCheck = currentStatus !== 'U';
        	let idIsCheckedAndValid = !performIdCheck || idCheckFlag; // idCheckFlag는 전역 또는 접근 가능 범위에 있어야 함

            // 비밀번호 필드들이 비어있는지 확인 (수정 모드에서)
            let passwordFieldsEmpty = currentStatus === 'U' && $("#password").val().trim() === '' && $("#confirmPassword").val().trim() === '';
            // 비밀번호 유효성 검사가 필요한 경우 (생성 모드이거나, 수정 모드에서 비밀번호를 입력한 경우)
            let needsPasswordValidation = currentStatus !== 'U' || !passwordFieldsEmpty;
            // 실제 비밀번호 유효성 (passwordCheckFlag는 외부에서 관리됨)
            let passwordActuallyValid = passwordCheckFlag;

            let finalPasswordCheck = true;
            if (needsPasswordValidation) {
                finalPasswordCheck = passwordActuallyValid;
            }
        	if(idIsCheckedAndValid && finalPasswordCheck){
                if(currentStatus === 'U'){
                    myform.attr("action","/admin/community/artist/update");
                }
        		form.submit();
        	} else if (performIdCheck && !idIsCheckedAndValid) {
                sweetAlert("error", "아티스트 ID 중복확인을 해주세요.");
                $("#usernameFeedback").html("ID 중복확인을 완료해주세요.").addClass("text-danger-custom").removeClass("text-success-custom");
            } else if (needsPasswordValidation && !finalPasswordCheck) {
                 sweetAlert("error", "비밀번호를 확인해주세요.");
            }
        }
    });

	// username 필드의 값이 변경되면 idCheckFlag를 false로 설정 (다시 중복확인 필요)
    if (currentStatus !== 'U') {
        $("#username").on("input", function() {
            idCheckFlag = false;
        });
    }

	// 비밀번호 체크 이벤트
    $("#password").on("keyup blur", pwcheck);
    $("#confirmPassword").on("keyup blur", pwcheck);

    // 비밀번호 체크 이벤트
    function pwcheck() {
        const pwVal = $("#password").val();
        const confirmPwVal = $("#confirmPassword").val();
        const pwFeedback = $("#passwordFeedback");
        const confirmPwFeedback = $("#passwordConfirmError");
        const pwRegEx = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,16}$/; // validator와 동일한 정규식

        let isPwValid = false;
        let isConfirmPwValid = false;

        // 수정 모드에서 비밀번호 필드가 모두 비어있으면 변경 안함으로 간주
        if (currentStatus === 'U' && pwVal === '' && confirmPwVal === '') {
            pwFeedback.empty().removeClass("text-danger-custom text-success-custom");
            confirmPwFeedback.empty().removeClass("text-danger-custom text-success-custom");
            passwordCheckFlag = true;
            return;
        }

        // 비밀번호 필드 유효성 검사 (정규식)
        if (pwVal !== '') { // 입력이 있을 때만 검사
            if (!pwRegEx.test(pwVal)) {
                pwFeedback.html("8~16자 영문, 숫자, 특수문자 조합이어야 합니다.").removeClass("text-success-custom").addClass("text-danger-custom");
                isPwValid = false;
            } else {
                pwFeedback.html("").removeClass("text-danger-custom text-success-custom"); // 정규식 통과 시 메시지 없음
                isPwValid = true;
            }
        } else {
             pwFeedback.empty().removeClass("text-danger-custom text-success-custom");
             isPwValid = false;
             if (currentStatus !== 'U') {
            	 isPwValid = false;
             } else if {
            	 ($("#confirmPassword").val().length > 0) isPwValid = false;
             } else {
            	 isPwValid = true; // 수정모드이고 둘다 비면 OK
             }
        }


        // 비밀번호 확인 필드 유효성 검사 (일치 여부)
        if (confirmPwVal !== '' || pwVal !== '') { // 둘 중 하나라도 입력이 시작되면 확인
            if (pwVal !== confirmPwVal) {
                confirmPwFeedback.html("입력하신 비밀번호와 일치하지 않습니다!").removeClass("text-success-custom").addClass("text-danger-custom");
                isConfirmPwValid = false;
            } else {
                 // 일치하고, 첫번째 비밀번호가 유효한 정규식을 통과했을때만 최종 성공
                if(isPwValid) {
                     confirmPwFeedback.html("입력하신 비밀번호와 일치합니다").removeClass("text-danger-custom").addClass("text-success-custom");
                } else {
                     confirmPwFeedback.html("").removeClass("text-danger-custom text-success-custom"); // 첫번째 비번이 아직 유효하지 않으면 메시지 없음
                }
                isConfirmPwValid = isPwValid; // 일치한다면, 첫번째 비번의 유효성에 따름
            }
        } else {
            confirmPwFeedback.empty().removeClass("text-danger-custom text-success-custom");
            isConfirmPwValid = true; // 둘 다 비어있으면 일단 통과 (수정모드)
        }

        // 최종 passwordCheckFlag 설정
        // 두 필드가 모두 비어있는 'U' 모드(위에서 return됨)가 아니고,
        // 비밀번호 규칙을 통과하고, 두 비밀번호가 일치하면 true
        if (pwVal === '' && confirmPwVal === '' && currentStatus === 'U') {
             passwordCheckFlag = true;
        } else if (pwVal === '' && currentStatus !== 'U') { // 생성모드인데 비번이 비면 안됨
             passwordCheckFlag = false;
        } else {
             passwordCheckFlag = isPwValid && (pwVal === confirmPwVal);
        }
    }


    // 데이터 추가버튼
    $("#artistDataBtn").on("click",function(){
    	$("#username").val("artist_ahyeon");
    	$("#password").val("1q2w3e4r!");
    	$("#confirmPassword").val("1q2w3e4r!");
    	$("#artNm").val("아현");
    	$("#peoLastNm").val("김");
    	$("#peoFirstNm").val("가을");
    	$("#peoEmail").val($("#username").val()+"@ddtown.com");
    	$("#memBirth").val("2007/04/11");
    	$("#peoPhone").val("010-2222-0001")
    	$("#artContent").val("크리스 마틴");
    })
});
</script>
</html>