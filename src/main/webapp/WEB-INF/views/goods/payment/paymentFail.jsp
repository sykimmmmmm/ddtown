<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 굿즈샵 - 결제 실패</title>
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
<%--     <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css"> --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods.css">
    <style>
        .payment-fail-container {
            max-width: 600px;
            margin: 80px auto 50px;
            padding: 40px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            text-align: center;
            background-color: #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .payment-fail-container h2 {
            color: #dc3545; /* 빨간색 */
            font-size: 2.2em;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .payment-fail-container h2 .icon {
            font-size: 1.5em;
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
            white-space: nowrap;
        }
        .action-buttons .btn-primary {
            background-color: #6c757d; /* 회색 */
            color: #fff;
            border: none;
        }
 		.action-buttons .btn-primary:hover {
             background-color: #5a6268;
         }
        .action-buttons .btn-secondary {
            background-color: #f8f9fa;
            color: #333;
            border: 1px solid #ccc;
        }
        .action-buttons .btn-secondary:hover {
            background-color: #e2e6ea;
        }
    </style>
</head>
<body class="order-page-body">
	<%@ include file="../../modules/communityHeader.jsp" %>

    <div class="payment-fail-container">
        <h2><span class="icon">❌</span> 결제에 실패했습니다.</h2>
        <div class="payment-details">
            <p>오류 원인:
                <c:choose>
                    <c:when test="${param.reason == 'invalid_order_info'}">
                        <strong>유효하지 않은 주문 정보입니다.</strong>
                    </c:when>
                    <c:when test="${param.reason == 'user_mismatch'}">
                        <strong>결제 요청자와 주문자가 일치하지 않습니다.</strong>
                    </c:when>
                    <c:when test="${param.reason == 'payment_error'}">
                        <strong>결제 처리 중 시스템 오류가 발생했습니다.</strong>
                    </c:when>
                    <c:when test="${param.reason == 'already_subscribed'}">
                        <strong>이미 가입된 멤버십입니다.</strong>
                    </c:when>
                    <c:otherwise>
                        <strong>알 수 없는 오류가 발생했습니다.</strong>
                    </c:otherwise>
                </c:choose>
            </p>
            <p>문제가 계속 발생할 경우 고객센터로 문의해주세요.</p>
        </div>
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/goods/cart/list" class="btn btn-primary">장바구니로 돌아가기</a>
            <a href="${pageContext.request.contextPath}/goods/main" class="btn btn-secondary">쇼핑 계속하기</a>
        </div>
    </div>
    <script>
    </script>
</body>
</html>