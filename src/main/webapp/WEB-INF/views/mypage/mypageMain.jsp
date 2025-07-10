<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mypageMain.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" ></script>
    <style type="text/css">
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
    </style>
</head>
<body>
    <%@ include file="../modules/communityHeader.jsp" %>

    <div class="mypage-container">
        <%@ include file="../modules/mypageAside.jsp" %>
        <div class="mypage-body-wrapper">
        <main class="mypage-content">
            <h2>MY PAGE</h2>
            <c:choose>
            	<c:when test="${currentPage eq 'profile' or empty currentPage }">
            		<jsp:include page="/WEB-INF/views/mypage/testprofileEditForm.jsp" />
            	</c:when>
            	<c:when test="${currentPage eq 'alerts' }">
            		<jsp:include page="/WEB-INF/views/mypage/alertList.jsp" />
            	</c:when>
            	<c:when test="${currentPage eq 'alertSettings' }">
            		<jsp:include page="/WEB-INF/views/mypage/alertSettingForm.jsp" />
            	</c:when>
            	<c:when test="${currentPage eq 'subDetail' }">
            		<jsp:include page="/WEB-INF/views/mypage/subDetail.jsp" />
            	</c:when>
            	<c:when test="${currentPage eq 'orderList' }">
            	<c:import url="/WEB-INF/views/mypage/orderList.jsp" />
            	</c:when>
            	<c:when test="${currentPage eq 'orderDetail' }">
            	<c:import url="/WEB-INF/views/goods/orderDetail.jsp" />
            	</c:when>
            	<c:otherwise>
            		<p> 다시골라주세여 </p>
            	</c:otherwise>
            </c:choose>
        </main>
        </div>
    </div>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
    <%@ include file="../modules/footerPart.jsp" %>
    <%@ include file="../modules/mypageSidebar.jsp" %>
	<script>
	        // 레이아웃용 전역함수 삭제x
	        function updateHeaderBadgeCount(newCount) {
	            const headerBadge = $('#alertBadge'); // 헤더의 알림 배지 ID
	            if (headerBadge.length) {
	                if (newCount > 0) {
	                    headerBadge.text(newCount > 99 ? "99+" : newCount).show();
	                } else {
	                    headerBadge.hide();
	                }
	            }
	            // 페이지 내의 안읽은 알림 개수 표시 업데이트 (mypage section header)
	            const pageUnreadCountDisplay = $('.unread-count-display');
	            if (pageUnreadCountDisplay.length) {
	                if (newCount > 0) {
	                    pageUnreadCountDisplay.text(newCount > 99 ? "99+" : newCount).show();
	                } else {
	                    pageUnreadCountDisplay.hide();
	                }
	            }
	        }

	        $(document).ready(function() {
	            // 초기 unreadCnt 값을 이용해 헤더 배지 업데이트
	            const initialUnreadCnt = parseInt('${unreadCnt}' || '0');
	            updateHeaderBadgeCount(initialUnreadCnt);

	            // 로그아웃 버튼 이벤트 리스너
	            const logoutButton = document.querySelector('.btn.emp-logout-btn');
	            if (logoutButton) {
	                logoutButton.addEventListener('click', function(e) {
	                    e.preventDefault();
	                    Swal.fire({
	                        title: '로그아웃',
	                        text: '로그아웃 하시겠습니까?',
	                        icon: 'question',
	                        showCancelButton: true,
	                        confirmButtonColor: '#3085d6',
	                        cancelButtonColor: '#d33',
	                        confirmButtonText: '네',
	                        cancelButtonText: '취소'
	                    }).then((result) => {
	                        if (result.isConfirmed) {
	                            // 실제 로그아웃 처리 로직 (폼 서브밋 또는 AJAX 호출)
	                            // 예: document.getElementById('logoutForm').submit();
	                            showAlert('success', '로그아웃', '로그아웃 되었습니다.');
	                            
	                        }
	                    });
	                });
	            }
	        });
	    </script>
	
</body>
</html>