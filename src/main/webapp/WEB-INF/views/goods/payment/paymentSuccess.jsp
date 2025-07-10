<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 굿즈샵 - 결제 완료</title>
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods.css">
    <style>
    	body {
		    background: linear-gradient(135deg, #1a1a2e 0%, #2a1e4a 50%, #8a2be2 100%); /* 중간색을 약간 더 보라색 계열로 조정 */
		    background-attachment: fixed; /* 배경을 뷰포트에 고정 */
		    background-size: cover; /* 배경이 전체 영역을 커버하도록 */
		    min-height: 100vh;
		    margin: 0;
		    font-family: "Noto Sans KR", 돋움, Dotum, 굴림, Gulim, Tahoma, Verdana, sans-serif;
		    color: #ffffff;
		    overflow-x: hidden;
		}
        .payment-success-container {
            max-width: 600px;
            margin: 80px auto 50px; /* 헤더와 푸터 사이 여유 공간 */
            padding: 40px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            text-align: center;
            background-color: #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .payment-success-container h2 {
            color: #4CAF50; /* 초록색 */
            font-size: 2.2em;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .payment-success-container h2 .icon {
            font-size: 1.5em; /* 아이콘 크기 */
            margin-right: 10px;
            line-height: 1;
        }
        .payment-details p {
            font-size: 1.1em;
            margin-bottom: 10px;
            color: #555;
        }
        .payment-details strong {
            color: #333;
            font-weight: 700;
        }
        .action-buttons {
            margin-top: 30px;
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .action-buttons .btn {
            padding: 12px 25px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: background-color 0.3s ease;
            white-space: nowrap; /* 버튼 내용 줄바꿈 방지 */
        }
        .action-buttons .btn-primary {
            background-color: #007bff; /* 파란색 */
            color: #fff;
            border: none;
        }
        .action-buttons .btn-primary:hover {
            background-color: #0056b3;
        }
        .action-buttons .btn-secondary {
            background-color: #f8f9fa; /* 밝은 회색 */
            color: #333;
            border: 1px solid #ccc;
        }
        .action-buttons .btn-secondary:hover {
            background-color: #e2e6ea;
        }
    </style>
</head>
<body class="order-page-body">
	<%@ include file ="../../modules/communityHeader.jsp" %>

    <div class="payment-success-container">
        <h2><span class="icon">✅</span> 결제가 성공적으로 완료되었습니다!</h2>
        <div class="payment-details">
			<p>주문 번호: <strong>${orderNm}</strong></p>
			<p>결제 금액: <strong><fmt:formatNumber value="${amount}" type="number"/>원</strong></p>
            <p>주문해주셔서 감사합니다. 소중한 상품은 빠르게 배송될 예정입니다.</p>
        </div>
        <div class="action-buttons">
            <%-- 추후 마이페이지 주문 상세 URL로 변경 필요 --%>
            <a href="${pageContext.request.contextPath}/goods/order/detail?orderNo=${param.orderNo}" class="btn btn-primary">주문 상세 보기</a>
            <a href="${pageContext.request.contextPath}/goods/main" class="btn btn-secondary">쇼핑 계속하기</a>
        </div>
    </div>
	<div style="margin-top: 362px;">
			<!-- FOOTER -->
			<jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />    
		    <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
			<!-- FOOTER END -->
	</div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {

        	let link = localStorage.getItem("url");
        	if(link){
        		localStorage.removeItem('url');
        		location.href = link;
        	}

            // 푸터 로드 (paymentSuccess.jsp에도 필요하다면)
            fetch('${pageContext.request.contextPath}/resources/html/footer.html')
                .then(response => response.ok ? response.text() : Promise.reject('Footer not found'))
                .then(data => {
                    const footerPlaceholder = document.getElementById('footer-placeholder');
                    if (footerPlaceholder) {
                        footerPlaceholder.innerHTML = data;
                    }
                })
                .catch(error => console.error('Error loading footer:', error));

            // 로그인 상태 관리 (Header에 필요하다면)
            const isLoggedIn = <c:out value='${isLoggedIn != null && isLoggedIn}' default='false'/>; // isLoggedIn이 null일 경우를 대비
            const loggedOutNav = document.getElementById('loggedOutNav');
            const loggedInNav = document.getElementById('loggedInNav');
            if (isLoggedIn) {
                if(loggedOutNav) loggedOutNav.style.display = 'none';
                if(loggedInNav) loggedInNav.style.display = 'flex';
            } else {
                if(loggedOutNav) loggedOutNav.style.display = 'flex';
                if(loggedInNav) loggedInNav.style.display = 'none';
            }

            const logoutBtn = document.getElementById('logoutBtn');
            if (logoutBtn) {
                logoutBtn.addEventListener('click', function(event) {
                    event.preventDefault();
                    alert("로그아웃되었습니다.");
                    window.location.href = '${pageContext.request.contextPath}/logout';
                });
            }
        });
    </script>
</body>
</html>