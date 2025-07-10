<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../modules/headerPart.jsp" %>
<c:if test="${not empty sessionScope.showRecaptcha && sessionScope.showRecaptcha eq true }">
	<script src="https://www.google.com/recaptcha/enterprise.js" async defer></script>
</c:if>
<style type="text/css">
body {
     font-family: 'Noto Sans KR', 'Montserrat', Arial, sans-serif;
     margin: 0;
     min-height: 100vh;
     display: flex;
     align-items: center;
     justify-content: center;
     padding: 20px 0;
     /* 오버플로우 숨김 (스크롤바 방지) */
     overflow: hidden;
     /* 내용을 오로라 배경 위에 오도록 z-index 설정 */
     position: relative;
     z-index: 1; /* login-card-custom보다 낮게, aurora-background보다 높게 */
 }

 /* 새로운 오로라 배경을 위한 CSS 클래스 추가 */
 .aurora-background {
    position: fixed; /* 뷰포트에 고정 */
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    /* 초기 그라디언트 색상 및 크기 설정 (JavaScript에서 동적으로 변경될 예정) */
    background: linear-gradient(45deg, #FF00FF, #00FFFF, #FFFF00, #FF0000, #00FF00, #0000FF);
    background-size: 400% 400%; /* 그라디언트 크기를 키워서 애니메이션 시 부드럽게 보이도록 */
    animation: gradientShift 15s ease infinite; /* 그라디언트 위치 이동 애니메이션 */
    z-index: -1; /* 다른 모든 내용보다 뒤에 오도록 */
 }

 @keyframes gradientShift {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
 }

 .login-card-custom {
     max-width: 600px;
     width: 100%;
     height: 900px;
     background: #fff;
     border-radius: 22px;
     box-shadow: 0 4px 24px rgba(0,0,0,0.09);
     padding: 48px 32px 36px 32px;
     border: none;
 }
 .login-title-custom {
     text-align: center;
     font-size: 2.2rem;
     font-weight: 800;
     margin-bottom: 36px;
     letter-spacing: -1px;
     color: #3d246c;
 }
 .form-control {
     padding: 16px 18px;
     border: 1.5px solid #e0e0e0;
     border-radius: 10px;
     font-size: 1.08rem;
     background: #fafbfc;
     transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s;
     height: auto;
 }
 .form-control:focus {
     border-color: #a259e6;
     outline: none;
     background: #fff;
     box-shadow: 0 0 0 0.2rem rgba(162, 89, 230, 0.25);
 }
 .input-group .form-control {
     border-top-right-radius: 0;
     border-bottom-right-radius: 0;
 }
 .input-group .btn.pw-toggle-btn {
     border-top-left-radius: 0;
     border-bottom-left-radius: 0;
     border: 1.5px solid #e0e0e0;
     border-left: 0;
     background: #fafbfc;
     color: #888;
 }

 .input-group .form-control:focus + .btn.pw-toggle-btn {
     border-color: #a259e6;
     box-shadow: none;
     background: #fff;
 }
 .form-check-label.remember-custom {
     font-size: 1.01rem;
     color: #444;
     user-select: none;
 }
 .btn-primary.login-btn-custom {
     width: 100%;
     background: #a259e6;
     color: #fff;
     font-size: 1.22rem;
     font-weight: 700;
     border: none;
     border-radius: 14px;
     padding: 18px 0;
     cursor: pointer;
     transition: background 0.2s;
     box-shadow: 0 2px 8px rgba(162,89,230,0.07);
 }
 .btn-primary.login-btn-custom:hover {
     background: #7c3aed;
 }
 .divider-text-custom {
     text-align: center;
     color: #888;
     font-size: 1.04rem;
     margin: 22px 0 16px 0;
     font-weight: 500;
 }
 .social-login-custom .btn {
     font-size: 1.08rem;
     font-weight: 600;
     border-radius: 10px;
     padding: 12px 4px;
     display: flex;
     align-items: center;
     justify-content: center;
     transition: background-color 0.2s, border-color 0.2s, box-shadow 0.2s;
 }
 .social-login-custom .btn img {
     width: 20px;
     height: 20px;
     margin-right: 10px;
 }
 .social-btn-google-custom {
     border: 1.5px solid #e0e0e0 !important;
     background: #fff !important;
     color: #444 !important;
 }
 .social-btn-google-custom:hover {
     background-color: #f8f9fa !important;
 }
 .social-btn-kakao-custom {
     background: #fee500 !important;
     color: #3c1e1e !important;
     border: none !important;
 }
 .social-btn-kakao-custom:hover {
     background-color: #fdd800 !important;
 }
 .login-links-custom {
     display: flex;
     justify-content: center;
     gap: 16px;
     color: #888;
     font-size: 1.04rem;
     margin-top: 24px;
 }
 .login-links-custom a {
     color: #888;
     text-decoration: none;
     transition: color 0.2s;
 }
 .login-links-custom a:hover {
     color: #a259e6;
     text-decoration: underline;
 }
 .alert.login-error-custom {
     color: #e53935;
     background-color: #fdecea;
     border-color: #fcd9d7;
     font-size: 1.01rem;
     text-align: center;
     padding: 0.75rem 1.25rem;
 }

 @media (max-width: 500px) {
     .login-card-custom {
         padding: 30px 20px 26px 20px;
     }
     .login-title-custom {
         font-size: 1.8rem;
         margin-bottom: 28px;
     }
     .form-control {
         font-size: 0.98rem;
         padding: 13px 15px;
     }
     .btn-primary.login-btn-custom {
         font-size: 1.05rem;
         padding: 13px 0;
     }
     .social-login-custom {
         flex-direction: column;
         gap: 10px !important;
     }
     .login-links-custom {
         font-size: 0.93rem;
         gap: 8px;
     }
 }
</style>
</head>
<body>
	<div class="aurora-background"></div>

	<div class="card login-card-custom">
        <div class="card-body" style="align-content: center;">
            <h2 class="login-title-custom">로그인</h2>

            <c:if test="${not empty sessionScope.error }">
                <div class="alert login-error-custom mb-3 alert-sm" role="alert">
                    <small>${error}</small>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                <sec:csrfInput/>
                <div class="mb-3">
                    <label for="username" class="form-label visually-hidden">아이디</label>
                    <input type="text" class="form-control" id="username" name="username" placeholder="아이디" maxlength="30" required>
                </div>

                <label for="password" class="form-label visually-hidden">비밀번호</label>
                <div class="mb-3">
                	<div style="position: relative;">
	                    <input type="password" class="form-control" id="password" name="password" placeholder="비밀번호" maxlength="20" required>
	                    <button class="btn pw-toggle-btn" type="button" id="passwordToggleBtn" tabindex="-1" style="position: absolute; top:10px; right:0">
	                        <i class="fas fa-eye"></i>
	                    </button>
                	</div>
                    <div id="passwordCaps" class="d-none form-text text-danger small">
                    	Caps Lock이 켜져 있습니다.
                    </div>
                </div>

                <div class="form-check mb-3">
                    <input type="checkbox" class="form-check-input" id="rememberUsername">
                    <label class="form-check-label remember-custom" for="rememberUsername">아이디 저장</label>
                </div>

				<c:if test="${not empty sessionScope.showRecaptcha && sessionScope.showRecaptcha eq true }">
					<div class="g-recaptcha" data-sitekey="6LeEEkQrAAAAAOVnYZFx9QvBNFT1GmwSKVV2M8Km" data-action="LOGIN"></div>
				</c:if>
                <div class="d-grid mb-3 mt-3">
                    <button type="button" class="btn btn-primary login-btn-custom" id="loginBtn">로그인</button>
                </div>
                <div class="d-flex gap-3 justify-content-center">
                	<button type="button" class="btn btn-secondary login-btn-custom" id="adminBtn">관리자</button>
                	<button type="button" class="btn btn-secondary login-btn-custom" id="empBtn">직원</button>
                	<button type="button" class="btn btn-secondary login-btn-custom" id="artistBtn">아티스트</button>
                </div>
            </form>


            <div class="divider-text-custom" style="margin: 40px 0 30px;">또는 다음으로 로그인</div>

            <div class="social-login-custom d-grid mb-4">
				<div>
	                <a href="${pageContext.request.contextPath}/oauth2/authorization/google" class="btn social-btn-google-custom">
						<img src="https://developers.google.com/identity/images/g-logo.png" alt="Google 로그인">
						Google로 로그인
					</a>
				</div>
				<div class="mt-2">
	                <a href="${pageContext.request.contextPath}/oauth2/authorization/kakao" class="btn social-btn-kakao-custom">
			            <img src="https://developers.kakao.com/assets/img/about/logos/kakaolink/kakaolink_btn_medium.png" alt="카카오 로그인">
			            카카오로 로그인
			        </a>
				</div>
            </div>

            <div class="login-links-custom text-center">
                <a href="/auth/form">회원가입</a>
                <span>|</span>
                <a href="/auth/findId" onclick="javascript:window.open(this.href,'_blank','width=600, height=600');return false;">아이디 찾기</a>
                <span>|</span>
                <a href="/auth/resetPw" onclick="javascript:window.open(this.href,'_blank','width=600, height=600');return false;">비밀번호 찾기</a>
            </div>
        </div>
    </div>
    <%@ include file="../modules/footerPart.jsp" %>
</body>
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', () => {
    const auroraBackground = document.querySelector('.aurora-background');

    // 오로라에 어울리는 색상 팔레트 정의
    const colorPalette = [
    	[102, 0, 153],    // 진한 자수정 (Amethyst)
        [153, 51, 204],   // 중간 보라 (Medium Purple)
        [204, 102, 255],  // 밝은 연보라 (Light Lavender)
        [128, 0, 128],    // 깊은 보라 (Deep Purple)
        [230, 230, 250],  // 라벤더 블러시 (Lavender Blush) - 거의 흰색에 가까운 연한 보라
        [93, 63, 211]     // 슬레이트 블루 (Slate Blue) - 보라빛 푸른색
    ];

    let currentColorIndex = 0;
    let nextColorIndex = 1;

    // 그라디언트 CSS 문자열 생성 함수
    function generateGradientString(colors) {
        // 색상 포인트를 6개로 고정하여 더욱 부드러운 오로라 효과를 낼 수 있습니다.
        // 예를 들어, colorPalette의 첫 6개 색상을 사용하거나,
        // 현재 보간된 색상들 중에서 6개를 선택하여 적용합니다.
        // 여기서는 colorPalette의 길이가 최소 6개 이상이라고 가정합니다.
        const numGradientPoints = 6;
        const selectedColors = colors.slice(0, numGradientPoints);
        return `linear-gradient(45deg, \${selectedColors.map(c => `rgb(\${c[0]}, \${c[1]}, \${c[2]})`).join(', ')})`;
    }

    // 두 색상 사이를 보간하는 함수
    function interpolateColor(color1, color2, factor) {
        return color1.map((c, i) => Math.round(c + factor * (color2[i] - c)));
    }

    // 오로라 그라디언트를 업데이트하는 함수
    function updateAuroraGradient() {
        const duration = 15000; // 15초 동안 색상 변화 (조절 가능)
        let startTime = null;

        function animate(currentTime) {
            if (!startTime) startTime = currentTime;
            const progress = (currentTime - startTime) / duration;

            if (progress < 1) {
                const interpolatedColors = [];
                // colorPalette 전체를 순회하며 각 색상 포인트를 보간
                for (let i = 0; i < colorPalette.length; i++) {
                    const startColor = colorPalette[(currentColorIndex + i) % colorPalette.length];
                    const endColor = colorPalette[(nextColorIndex + i) % colorPalette.length];
                    interpolatedColors.push(interpolateColor(startColor, endColor, progress));
                }
                auroraBackground.style.backgroundImage = generateGradientString(interpolatedColors);
                requestAnimationFrame(animate);
            } else {
                // 애니메이션이 끝나면 다음 색상 조합으로 인덱스 업데이트
                currentColorIndex = (currentColorIndex + 1) % colorPalette.length;
                nextColorIndex = (nextColorIndex + 1) % colorPalette.length;
                // 다음 애니메이션을 즉시 시작 (지연 없이 부드러운 전환)
                requestAnimationFrame(updateAuroraGradient);
            }
        }
        requestAnimationFrame(animate); // 애니메이션 시작
    }

    // 페이지 로드 시 오로라 그라디언트 애니메이션 시작
    updateAuroraGradient();
});

$(function(){
	let loginBtn = $("#loginBtn");
	let loginForm = $("#loginForm");
	let passwordToggleBtn = $("#passwordToggleBtn");
	let gRecaptcha = $(".g-recaptcha")[0];
	let capsLockToggle = false;
	let adminBtn = $("#adminBtn");
	let empBtn = $("#empBtn");
	let artistBtn = $("#artistBtn");
	let username = $("#username");
	let password = $("#password");

	username.on("keyup",function(e){
		if(e.keyCode == 13){
			loginBtn.click();
		}
	})

	artistBtn.on("click",function(){
		$("#username").val("artist_songjuongho");
		$("#password").val("1q2w3e4r!");
		loginForm.submit();
	})

	adminBtn.on("click", function(){
		$("#username").val("admin001");
		$("#password").val("1q2w3e4r!");
		loginForm.submit();
	})

	empBtn.on("click", function(){
		$("#username").val("art010");
		$("#password").val("1q2w3e4r!");
		loginForm.submit();
	})


	$(document).on("keydown",function(e){
		if(e.keyCode == 20){
			capsLockToggle = !capsLockToggle;
		}

		if(capsLockToggle && $("#password").is(":focus")){
			$("#passwordCaps").removeClass("d-none");
		}else{
			$("#passwordCaps").addClass("d-none");
		}
	})
	$("#password").on("blur",function(){
		$("#passwordCaps").addClass("d-none");
	}).on("focus",function(){
		if(capsLockToggle){
			$("#passwordCaps").removeClass("d-none");
		}
	}).on("keyup",function(e){
		if(e.keyCode == 13){
			loginBtn.click();
		}
	})

	// 아이디 저장 버튼
	loginBtn.on("click",function(){
		let username = $("#username").val();
		let password = $("#password").val();

		if(username == null || username.trim() == "" ){
			sweetAlert("error", "아이디를 입력해주세요!");
			return false;
		}
		if(password == null || password.trim() == "" ){
			sweetAlert("error", "비밀번호를 입력해주세요!");
			return false;
		}

		if(gRecaptcha != null){
			// 리캡챠 관련
			var recaptchaResponse = grecaptcha.enterprise.getResponse();

			if(recaptchaResponse.length == 0){
				sweetAlert("error","로봇이 아님을 증명해주세요!")
				return false;
			}
		}

		let rememberUsername = $("#rememberUsername").prop("checked");
		if(rememberUsername && username.trim() != ""){
			localStorage.setItem("rememberUsername",username);
		}else{
			localStorage.removeItem("rememberUsername");
		}

		loginForm.submit();
	})

	// 아이디 저장정보 불러오기
	let savedUsername = localStorage.getItem("rememberUsername");
	if(savedUsername){
		$("#username").val(savedUsername);
		$("#rememberUsername").prop("checked","checked")
	}

	passwordToggleBtn.on('click',function(){
		let pass = $(this).prev("#password")
		if(pass.attr("type") == "password"){
			pass.attr("type","text");
			$(this).html('<i class="fas fa-eye-slash"></i>')
		}else{
			pass.attr("type","password");
			$(this).html('<i class="fas fa-eye"></i>')
		}
	})

	let msg = "${msg}";
	if(msg != ""){
		sweetAlert("success",msg);
	}
})
</script>
</html>