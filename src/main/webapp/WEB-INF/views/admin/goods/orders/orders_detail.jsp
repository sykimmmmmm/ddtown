<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 상세 정보 - DDTOWN 관리자 시스템</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <%@ include file="../../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/admin_order.css">
	<meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>

    <style>
        .card-section {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            padding: 28px 28px 18px 28px;
            margin-bottom: 28px;
            border: 1px solid #e7eaf3;
        }
        .section-title {
            font-size: 1.25em;
            color: #2c3e50;
            margin-bottom: 18px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px 32px;
            margin-bottom: 0;
        }
        .info-item {
            background: #f8f9fa;
            border-radius: 7px;
            padding: 16px 18px 10px 18px;
            display: flex;
            flex-direction: column;
            min-width: 0;
            border: 1px solid #e0e0e0;
        }
        .info-item dt {
            font-weight: 600;
            color: #555;
            margin-bottom: 4px;
            font-size: 0.98em;
        }
        .info-item dd {
            margin: 0;
            color: #222;
            font-size: 1.08em;
            word-break: break-all;
        }
        .info-item[style*="grid-column"] {
            grid-column: 1 / -1 !important;
        }
        .ordered-items-table {
            margin: 18px 0 18px 0;
        }
        .order-totals {
            margin-top: 18px;
            padding: 18px 30px;;
            border-top: 1px solid #e0e0e0;
            background: #f8f9fa;
            border-radius: 7px;
            max-width: 320px;
            margin-left: auto;
        }
        .order-totals dl {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin: 0;
        }
        .order-totals dt, .order-totals dd {
            display: inline-block;
            font-size: 1.08em;
            margin: 0;
        }
        .order-totals dt {
            color: #444;
            font-weight: 600;
            width: 140px;
            text-align: left;
        }
        .order-totals dd {
            color: #222;
            text-align: right;
            width: 120px;
            font-weight: 500;
        }
        .order-totals .grand-total dt, .order-totals .grand-total dd {
            font-size: 1.18em;
            font-weight: bold;
            color: #e74c3c;
        }
        .order-totals .grand-total {
            margin-top: 10px;
            border-top: 1.5px solid #e0e0e0;
            padding-top: 10px;
        }
        .admin-memo-section {
            background: #f8f9fa;
            border-radius: 7px;
            border: 1px solid #e0e0e0;
            padding: 18px 18px 10px 18px;
            margin-bottom: 0;
        }
        .admin-memo-section textarea {
            background: #fff;
            border-radius: 5px;
            border: 1px solid #ced4da;
            min-height: 80px;
            font-size: 1em;
            padding: 10px;
        }
        .detail-actions {
            margin-top: 32px;
            text-align: right;
        }
        @media (max-width: 900px) {
            .info-grid { grid-template-columns: 1fr; }
            .order-totals { max-width: 100%; }
        }
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../../modules/aside.jsp" %>
            <main class="emp-content">
            <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/admin/goods/orders/list" style="color:black;">굿즈샵 관리</a></li>
                        <li class="breadcrumb-item"><a href="/admin/goods/orders/list" style="color:black;">주문내역 관리</a></li>
                        <li class="breadcrumb-item active" aria-current="page">주문내역 상세</li>
                    </ol>
                </nav>
                <section class="ea-section">
                    <div class="order-detail-container">
                        <div class="ea-section-header" style="margin-bottom:10px; padding-bottom:10px;">
                            <h2 id="orderDetailTitle">주문 상세 정보 (주문번호: <span id="orderIdTitle">${order.orderNo}</span>)</h2>
                            <div class="ea-header-actions">
	                            <button id="saveOrderChangesBtn2" class="ea-btn primary"><i class="fas fa-save"></i>저장</button>
	                            <button id="cancelOrderBtn" class="ea-btn danger"><i class="fas fa-times-circle"></i> 주문 취소</button>
                            </div>
                        </div>
                        <div class="card-section">
                            <div class="section-title"><i class="fas fa-receipt"></i> 주문 기본 정보</div>
                            <div class="info-grid">
                                <div class="info-item">
                                    <dt>주문번호</dt>
                                    <dd id="orderIdDisplay">${order.orderNo}</dd>
                                </div>
                                <div class="info-item">
                                    <dt>주문일시</dt>
                                    <dd id="orderDateDisplay"><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm:ss"/></dd>
                                </div>
                                <div class="info-item">
                                    <dt>결제상태</dt>
                                    <%-- KAKAO_PAYMENT_API의 PAYMENT_STAT_CODE를 사용 (예: SUCCESS, FAILED, CANCELED) --%>
                                    <dd id="paymentStatusDisplay">${order.paymentVO.paymentStatCodeName}</dd>
                                </div>
                                <div class="info-item">
								    <dt>주문상태</dt>
								    <dd>
								        <select id="overallOrderStatus" name="overallOrderStatus">
								            <option value="OSC001" ${order.orderStatCode eq 'OSC001' ? 'selected' : ''}>결제 완료</option>
								            <option value="OSC002" ${order.orderStatCode eq 'OSC002' ? 'selected' : ''}>결제 실패</option>
								            <%-- <option value="OSC003" ${order.orderStatCode eq 'OSC003' ? 'selected' : ''}>상품 준비중</option>
								            <option value="OSC004" ${order.orderStatCode eq 'OSC004' ? 'selected' : ''}>배송 중</option>
								            <option value="OSC005" ${order.orderStatCode eq 'OSC005' ? 'selected' : ''}>배송완료</option>
								            <option value="OSC006" ${order.orderStatCode eq 'OSC006' ? 'selected' : ''}>취소 요청</option>
								            <option value="OSC007" ${order.orderStatCode eq 'OSC007' ? 'selected' : ''}>취소 처리중</option> --%>
								            <option value="OSC008" ${order.orderStatCode eq 'OSC008' ? 'selected' : ''}>취소 완료</option>
 											<option value="OSC009" ${order.orderStatCode eq 'OSC009' ? 'selected' : ''}>결제 요청</option>
								         </select>
								    </dd>
								</div>
                                <div class="info-item">
                                    <dt>결제수단</dt>
                                    <%-- OrdersVO의 orderPayMethodNm 필드를 사용합니다.
                                         이 필드에 'KAKAO_PAY', 'BANK_TRANSFER' 같은 코드값이 들어온다면,
                                         별도의 공통 코드 매핑으로 한글명('카카오페이', '무통장입금')을 가져오는 것이 좋습니다. --%>
                                    <dd id="paymentMethodDisplay">${order.orderPayMethodNm}</dd>
                                </div>
                                <div class="info-item">
								    <dt>결제일시</dt>
								    <dd id="paymentDateDisplay">
								        <c:choose>
								            <%-- order.paymentVO와 completedAt이 모두 null이 아닌 경우에만 포맷팅 --%>
								            <c:when test="${order.paymentVO != null and order.paymentVO.completedAt != null}">
								                <fmt:formatDate value="${order.paymentVO.completedAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
								            </c:when>
								            <c:otherwise>
								                정보 없음
								            </c:otherwise>
								        </c:choose>
								    </dd>
								</div>
                            </div>
                        </div>
                        <div class="card-section">
                            <div class="section-title"><i class="fas fa-user"></i> 주문자 정보</div>
                            <div class="info-grid">
                                <div class="info-item">
                                    <dt>주문자명</dt>
                                    <dd id="customerNameDisplay">${order.customerName}</dd>
                                </div>
                                <div class="info-item">
                                    <dt>아이디</dt>
                                    <dd id="customerIdDisplay">${order.customerId}</dd>
                                </div>
                                <%-- '주문자 연락처'는 현재 사용하지 않으므로 제거합니다. '수령인 연락처'를 사용합니다. --%>
                                <%--
                                <div class="info-item">
                                    <dt>연락처</dt>
                                    <dd id="customerPhoneDisplay">데이터 없음</dd>
                                </div>
                                --%>
                                <div class="info-item">
                                    <dt>이메일</dt>
                                    <dd id="customerEmailDisplay">${order.orderEmail}</dd>
                                </div>
                            </div>
                        </div>
                        <div class="card-section">
                            <div class="section-title"><i class="fas fa-truck"></i> 배송 정보</div>
                            <div class="info-grid">
                                <div class="info-item">
                                    <dt>수령인명</dt>
                                    <dd id="recipientNameDisplay">${order.orderRecipientNm}</dd>
                                </div>
                                <div class="info-item">
                                    <dt>수령인 연락처</dt>
                                    <%-- OrdersVO의 orderRecipientPhone 필드를 사용합니다. --%>
                                    <dd id="recipientPhoneDisplay">${order.orderRecipientPhone}</dd>
                                </div>
                                <div class="info-item" style="grid-column: 1 / -1;">
                                    <dt>배송주소</dt>
                                    <dd id="shippingAddressDisplay">(${order.orderZipCode}) ${order.orderAddress1} ${order.orderAddress2}</dd>
                                </div>
                                <div class="info-item" style="grid-column: 1 / -1;">
                                    <dt>배송메모</dt>
                                    <dd id="shippingMemoDisplay">${order.orderMemo}</dd>
                                </div>
                                <%-- '운송장번호'는 사용하지 않기로 했으므로 제거합니다. --%>
                                <%--
                                <div class="info-item">
                                    <dt>운송장번호</dt>
                                    <dd id="trackingNumberDisplay">-</dd>
                                </div>
                                --%>
                            </div>
                        </div>
                        <div class="card-section">
                            <div class="section-title"><i class="fas fa-boxes"></i> 주문 상품 목록</div>
                            <table class="ea-table ordered-items-table">
                                <thead>
                                    <tr>
                                        <th style="width:8%;">이미지</th>
                                        <th>상품명/SKU</th>
                                        <th style="width:10%;">옵션</th>
                                        <th style="width:8%;">수량</th>
                                        <th style="width:10%;">판매가</th>
                                        <th style="width:10%;">합계</th>
                                        <th style="width:12%;">상품상태</th>
                                        <th style="width:15%;">비고(관리자용)</th>
                                    </tr>
                                </thead>
                                <tbody id="orderedItemsTableBody">
                                    <c:choose>
                                        <c:when test="${not empty order.orderDetailList}">
                                            <c:forEach var="item" items="${order.orderDetailList}">
                                                <tr>
                                                    <td><img src="${item.representativeImageUrl}" alt="${item.goodsNm}" style="width:50px; height:50px; object-fit:cover;"></td>
                                                    <td>${item.goodsNm}</td>
                                                    <td>${item.goodsOptNm}</td>
                                                    <td>${item.orderDetQty}</td>
                                                    <td><fmt:formatNumber value="${item.goodsOptPrice}" pattern="#,###원"/></td>
                                                    <td><fmt:formatNumber value="${(item.goodsPrice) * item.orderDetQty}" pattern="#,###원"/></td>
                                                    <%-- OrderDetailVO에 상품 상태 필드가 있다면 사용. 없다면 '상품상태' 고정 텍스트 유지 --%>
                                                    <td>${item.goodsStatusKorName}</td>
                                                    <%-- OrderDetailVO에 비고 필드가 있다면 사용. 없다면 '-' 고정 텍스트 유지 --%>
                                                    <td>-</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="8" class="text-center">주문 상품이 없습니다.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
						<div class="order-totals">
						    <dl>
						        <div style="display:flex;justify-content:space-between;align-items:center;">
								    <dt>총 상품금액:</dt><dd id="itemsSubtotal"><fmt:formatNumber value="${order.orderTotalPrice}" pattern="#,###원"/></dd>
								</div>
								<div class="grand-total" style="display:flex;justify-content:space-between;align-items:center;">
								    <dt>최종 결제금액:</dt>
								    <dd class="grand-total" id="grandTotal">
								        <c:choose>
								            <c:when test="${order.orderStatCode eq 'OSC008'}">
								                <fmt:formatNumber value="${order.refundedAmount}" pattern="#,###원"/> (환불 완료)
								            </c:when>
								            <c:otherwise>
								                <fmt:formatNumber value="${order.orderTotalPrice}" pattern="#,###원"/>
								            </c:otherwise>
								        </c:choose>
								    </dd>
								</div>
						    </dl>
						</div>
                        </div>
                        <div class="card-section">
                            <div class="section-title"><i class="fas fa-sticky-note"></i> 관리자 주문 메모</div>
                            <div class="admin-memo-section form-group">
                                <textarea id="orderMemo" name="orderMemo" placeholder="이 주문에 대한 내부 관리용 메모를 남기세요...">${order.orderMemo}</textarea>
                            </div>
                        </div>
                        <div class="detail-actions">
                            <a href="/admin/goods/orders/list?currentPage=${currentPage}&orderDateStart=${orderDateStart}&orderDateEnd=${orderDateEnd}&orderStatusFilter=${orderStatusFilter}&orderSearchInput=${orderSearchInput}" class="ea-btn">목록</a>

                        </div>
                    </div>
                </section>
            </main>
        </div>
    </div>
<%@ include file="../../../modules/footerPart.jsp" %>

<%@ include file="../../../modules/sidebar.jsp" %>
   <script>
    // contextPath는 JSP에서만 사용 가능하므로 변수에 저장하여 JS에서 활용
    const contextPath = "${pageContext.request.contextPath}";

    // ★★★ CSRF 토큰 관련 변수들을 이곳으로 옮깁니다. ★★★
    // 이렇게 하면 모든 이벤트 핸들러에서 이 변수들에 접근할 수 있습니다.
    const csrfToken = document.querySelector('meta[name="_csrf"]').content;
    const csrfHeaderName = document.querySelector('meta[name="_csrf_header"]').content;

    // ★★★ 커스텀 alert 모달 함수 (전역 스코프에 정의) ★★★
    function showCustomAlert(message) {
        alert(message);
    }

    document.addEventListener('DOMContentLoaded', function() {
//         console.log('--- DOMContentLoaded 이벤트 발생. 스크립트 실행 시작 ---');

        // 푸터 로드 (기존과 동일)
        fetch(`${contextPath}/resources/html/footer.html`)
            .then(response => response.ok ? response.text() : Promise.reject('Footer not found'))
            .then(data => {
                const footerPlaceholder = document.getElementById('footer-placeholder');
                if (footerPlaceholder) {
                    footerPlaceholder.innerHTML = data;
                }
            })
            .catch(error => console.error('Error loading footer:', error));

        // 로그인 상태 관리 (기존과 동일)
        // 이 부분은 admin 페이지에서는 필요 없을 수 있습니다. (사용자 로그인 유무가 아닌 관리자 로그인 유무)
        // 필요하다면 admin 관련 로그인 체크 로직으로 변경하세요.
        const isLoggedIn = ${isLoggedIn != null && isLoggedIn};
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
                window.location.href = `${contextPath}/logout`;
            });
        }

        // --- 관리자 주문 상세 페이지 요소들 ---
        const orderNo = document.getElementById('orderIdDisplay').innerText; // 주문 번호 가져오는 ID 확인 필요
        const overallOrderStatusSelect = document.getElementById('overallOrderStatus');
        const adminOrderMemoTextarea = document.getElementById('orderMemo');
        const saveButtons = document.querySelectorAll('#saveOrderChangesBtn, #saveOrderChangesBtn2');
        const cancelOrderBtn = document.getElementById('cancelOrderBtn'); // 주문 취소 버튼

        // 변경사항 저장 버튼 클릭 이벤트 (기존과 동일)
        saveButtons.forEach(button => {
            button.addEventListener('click', function() {
                const updatedOrderStatus = overallOrderStatusSelect.value;
                const updatedAdminMemo = adminOrderMemoTextarea.value;

                const data = {
                	orderNo: orderNo,
                    orderStatCode: updatedOrderStatus,
                    orderMemo: updatedAdminMemo
                };

                fetch('/admin/goods/orders/update', {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        [csrfHeaderName]: csrfToken // ★★★ 통일된 CSRF 방식 적용 ★★★
                    },
                    body: JSON.stringify(data)
                })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(errorData => {
                            throw new Error(errorData.message || '서버 오류 발생');
                        });
                    }
                    return response.json();
                })
                .then(result => {
                    if (result.status === 'OK') {
                        alert('주문 정보가 성공적으로 저장되었습니다.');
                        // location.reload(); // 필요한 경우 주석 해제
                    } else {
                        alert('저장 실패: ' + (result.message || '알 수 없는 오류'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('주문 정보 저장 중 오류가 발생했습니다: ' + error.message);
                });
            });
        });

        // 주문 취소 버튼 클릭 이벤트 (관리자 페이지)
        if (cancelOrderBtn) {
            cancelOrderBtn.addEventListener('click', function() {
                if (!confirm('정말로 이 주문을 취소하시겠습니까? 취소된 주문은 복구하기 어렵습니다.')) {
                    return;
                }

                // CSRF 토큰은 이미 최상단에서 선언되었으므로 여기서 다시 가져올 필요 없습니다.
                // const csrfToken = getCsrfToken(); // 이 두 줄은 삭제!
                // const csrfHeader = getCsrfHeader(); // 이 두 줄은 삭제!

                fetch('/admin/goods/orders/cancel/' + orderNo, {
                    method: 'PUT', // 백엔드 컨트롤러에 @PutMapping으로 매핑되어 있다면 PUT 유지
                    headers: {
                        'Content-Type': 'application/json',
                        [csrfHeaderName]: csrfToken // ★★★ 통일된 CSRF 방식 적용 ★★★
                    },
                })
                .then(response => {
                    if (!response.ok) {
                        return response.text().then(errorMessage => {
                            throw new Error(errorMessage || '서버 오류 발생');
                        });
                    }
                    return response.text();
                })
                .then(result => {
                    if (result === 'SUCCESS') {
                        alert('주문이 성공적으로 취소되었습니다.');
                        overallOrderStatusSelect.value = 'OSC008';
                        location.reload();
                    } else {
                        alert('주문 취소 실패: ' + (result || '알 수 없는 오류'));
                    }
                })
                .catch(error => {
                    console.error('Error cancelling order:', error);
                    alert('주문 취소 중 오류가 발생했습니다: ' + error.message);
                });
            });
        }
    });
</script>
</body>
</html>