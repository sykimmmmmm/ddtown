<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 굿즈샵 - 주문하기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods.css">
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css" />
	<style type="text/css">
		.floating-nav {
		    position: fixed;
		    bottom: 100px;
		    right: 24px;
		    z-index: 1000;
		    display: flex;
		    flex-direction: column;
		    gap: 15px;
		}
	</style>
</head>
<body class="order-page-body">
    <jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />

    <div class="order-container">
        <div class="order-section">
            <h2>주문 상품</h2>
			<div class="order-items">
			    <c:choose>
			        <c:when test="${not empty orderItems}">
			            <%-- ★★★ 이 라인(totalProductAmount를 0으로 초기화하는 부분)을 삭제합니다. ★★★
			            <c:set var="totalProductAmount" value="0"/>
			            --%>
			            <c:forEach var="item" items="${orderItems}">
			                <div class="order-item"
			                     data-goods-no="${item.goodsNo}"
			                     data-goods-opt-no="${item.goodsOptNo}"
			                     data-qty="${not empty item.cartQty ? item.cartQty : item.orderDetQty}">
			                    <div class="item-image">
			                        <img src="${not empty item.representativeImageUrl ? item.representativeImageUrl : 'https://via.placeholder.com/80x80/E6E6FA/000000?text=No+Image'}" alt="${item.goodsNm}">
			                    </div>
			                    <div class="item-details">
			                        <div class="item-name">${item.goodsNm}</div>
			                        <div class="item-option">옵션: ${not empty item.goodsOptNm ? item.goodsOptNm : '선택 없음'}</div>
			                    </div>
			                    <div class="item-quantity">
			                        수량:
			                        <fmt:formatNumber value="${not empty item.cartQty ? item.cartQty : item.orderDetQty}" type="number"/>
			                    </div>
			                    <div class="item-price">
			                        <c:set var="pricePerUnit" value="0" />
			                        <c:choose>
			                            <c:when test="${not empty item.goodsOptNo and item.goodsOptPrice ne 0}">
			                                <c:set var="pricePerUnit" value="${item.goodsOptPrice}" />
			                            </c:when>
			                            <c:otherwise>
			                                <c:set var="pricePerUnit" value="${item.goodsPrice}" />
			                            </c:otherwise>
			                        </c:choose>
			                        <c:set var="currentItemTotal" value="${pricePerUnit * (not empty item.cartQty ? item.cartQty : item.orderDetQty)}" />
			                        <fmt:formatNumber value="${currentItemTotal}" type="number"/>원
			                    </div>
			                </div>

			            </c:forEach>

			            <%-- ★★★ 이 부분은 컨트롤러에서 전달받은 totalProductAmount를 그대로 사용합니다. ★★★ --%>
			            <div class="total-amount">
			                총 상품 금액: <span id="totalProductAmountDisplay"><fmt:formatNumber value="${totalProductAmount}" type="number"/>원</span>
			            </div>
			        </c:when>
			        <c:otherwise>
			            <p style="text-align: center; padding: 20px;">주문할 상품이 없습니다. 장바구니에서 상품을 선택해주세요.</p>
			        </c:otherwise>
			    </c:choose>
			</div>
        </div>

        <div class="order-section">
            <h2>배송지 정보</h2>
            <form class="delivery-info-form" action="#">
                <div class="form-group">
                    <label for="receiverName">받는 사람</label>
                    <input type="text" id="receiverName" name="receiverName" required
                           value="${not empty memberInfo ? memberInfo.memNicknm : ''}"> <%-- 회원 닉네임 기본값 --%>
                </div>
                <div class="form-group">
                    <label for="receiverPhone">연락처</label>
                    <input type="tel" id="receiverPhone" name="receiverPhone" required
                    	   value = "${not empty memberInfo ? memberInfo.peoPhone: ''}"> <%-- 회원 전화번호 기본값 --%>
                </div>

                <div class="form-group">
                    <label for="orderEmailInput">이메일 주소</label>
                    <input type="email" id="orderEmailInput" name="orderEmailInput" required
                           value="${not empty memberInfo ? memberInfo.peoEmail : ''}"> <%-- 회원 이메일 기본값 --%>
                </div>

                <div class="form-group full-width">
                    <label for="postcode">우편번호</label>
                    <div style="display: flex; gap: 10px;">
                        <input type="text" id="postcode" name="postcode" readonly style="flex-grow: 1;"
                               value="${not empty memberInfo ? memberInfo.memZipCode : ''}"> <%-- 회원 우편번호 기본값 --%>
                        <button type="button" class="address-search-btn" onclick="searchAddress()">주소 검색</button>
                    </div>
                </div>
                <div class="form-group full-width">
                    <label for="address">기본주소</label>
                    <input type="text" id="address" name="address" readonly
                           value="${not empty memberInfo ? memberInfo.memAddress1 : ''}"> <%-- 회원 기본주소 기본값 --%>
                </div>
                <div class="form-group full-width">
                    <label for="addressDetail">상세주소</label>
                    <input type="text" id="addressDetail" name="addressDetail"
                           value="${not empty memberInfo ? memberInfo.memAddress2 : ''}"> <%-- 회원 상세주소 기본값 --%>
                </div>
                <div class="form-group">
                    <label for="deliveryRequest">배송 요청사항</label>
                    <select id="deliveryRequest" name="deliveryRequest" onchange="toggleCustomMessage()">
                        <option value="">배송 요청사항 선택</option>
                        <option value="문 앞에 놓아주세요">문 앞에 놓아주세요</option>
                        <option value="경비실에 맡겨주세요">경비실에 맡겨주세요</option>
                        <option value="배송 전 연락주세요">배송 전 연락주세요</option>
                        <option value="custom">직접 입력</option>
                    </select>
                </div>
                <div class="form-group full-width" id="customMessageArea" style="display: none;">
                    <label for="customMessage">배송 메시지 직접 입력</label>
                    <textarea id="customMessage" name="customMessage" rows="3" maxlength="50" placeholder="최대 50자까지 입력 가능합니다"></textarea>
                </div>

                <input type="hidden" id="orderTypeCodeInput" value="OTC002">
            </form>
        </div>

        <div class="order-section">
            <h2>결제 수단</h2>
            <div class="payment-methods">
                <div class="payment-method selected" data-method="kakao"> <%-- 기본 카카오페이 선택 --%>
                    <img src="https://via.placeholder.com/40x40/E6E6FA/000000?text=K" alt="카카오페이">
                    <div class="method-name">카카오페이</div>
                </div>
                </div>
        </div>

        <div class="order-summary">
            <div class="summary-row">
                <span class="label">총 상품 금액</span>
                <span class="value" id="totalProductAmountDisplay"><fmt:formatNumber value="${totalProductAmount}" type="number"/>원</span>
            </div>
            <div class="summary-row">
                <span class="label">배송비</span>
                <span class="value" id="shippingFeeDisplay">
                    <c:set var="shippingFee" value="${totalProductAmount >= 30000 ? 0 : (totalProductAmount > 0 ? 3000 : 0)}"/> <%-- 3만원 이상 무료 --%>
                    <fmt:formatNumber value="${shippingFee}" type="number"/>원
                </span>
            </div>
            <div class="summary-row total">
                <span class="label">최종 결제 금액</span>
                <span class="value" id="finalPaymentAmountDisplay">
                    <fmt:formatNumber value="${totalProductAmount + shippingFee}" type="number"/>원
                </span>
            </div>
            <div class="payment-agreement">
                <label>
                    <input type="checkbox" id="paymentAgreement">
                    주문 상품 정보 및 결제 진행에 동의합니다. (필수)
                </label>
            </div>
        </div>

        <div class="order-actions">
            <button class="btn-order-cancel" onclick="location.href='${pageContext.request.contextPath}/goods/cart/list'">취소</button> <%-- 장바구니 페이지로 이동 --%>
            <button class="btn-order-submit" id="submitOrderBtn">결제하기</button>
        </div>
    </div>

	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    let csrfToken;
    let csrfHeader;

    const orderSource = '${orderSource}';

    document.addEventListener('DOMContentLoaded', function() {
        const csrfMeta = document.querySelector('meta[name="_csrf"]');
        const csrfHeaderMeta = document.querySelector('meta[name="_csrf_header"]');

        if (csrfMeta && csrfHeaderMeta) {
            csrfToken = csrfMeta.content; // CSRF 토큰 값 (예: "ABCDEFG12345")
            csrfHeader = csrfHeaderMeta.content; // CSRF 헤더 이름 (예: "X-CSRF-TOKEN")
        } else {
            console.error("CSRF meta tags not found or incorrectly configured.");
            // 에러 상황 시 추가적인 처리가 필요할 수 있습니다. 예를 들어, 버튼 비활성화 등
        }

        // 로그인 상태 관리 (컨트롤러에서 isLoggedIn 모델 속성을 받아와 사용)
        const isLoggedIn = ${isLoggedIn};

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
                event.preventDefault(); // 기본 링크 이동 방지
                alert("로그아웃되었습니다.");
                // 실제 로그아웃은 서버 측 URL로 이동하여 처리 (예: form submit 또는 window.location.href)
                window.location.href = '${pageContext.request.contextPath}/logout'; // 실제 로그아웃 URL
            });
        }

        // 외부 푸터 파일 로드
        fetch('${pageContext.request.contextPath}/resources/html/footer.html')
            .then(response => response.ok ? response.text() : Promise.reject('Footer not found'))
            .then(data => {
                const footerPlaceholder = document.getElementById('footer-placeholder');
                if (footerPlaceholder) {
                    footerPlaceholder.innerHTML = data;
                }
            })
            .catch(error => console.error('Error loading footer:', error));

        // 배송 메시지 직접 입력 토글
        function toggleCustomMessage() {
            const deliveryRequest = document.getElementById('deliveryRequest');
            const customMessageArea = document.getElementById('customMessageArea');
            customMessageArea.style.display = deliveryRequest.value === 'custom' ? 'block' : 'none';
        }
        // 페이지 로드 시 초기 상태 설정
        toggleCustomMessage(); // 초기 로드 시 한 번 실행

        // 결제 수단 선택
        const paymentMethods = document.querySelectorAll('.payment-method');
        paymentMethods.forEach(method => {
            method.addEventListener('click', function() {
                paymentMethods.forEach(m => m.classList.remove('selected'));
                this.classList.add('selected');
            });
        });

        // 주소 검색 함수 (Daum 우편번호 서비스 등 API 연동 필요)
        function searchAddress() {
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
        			document.getElementById('postcode').value = data.zonecode;
        			document.getElementById("address").value = addr;
        			// 커서를 상세주소 필드로 이동한다.
        			document.getElementById("addressDetail").focus();
        		}
        	}).open();
        }
        // 전역 함수로 등록하여 HTML onclick에서 호출 가능하게 함
        window.searchAddress = searchAddress;

        // 폼 유효성 검사
        function validateForm() {
            const receiverName = document.getElementById('receiverName').value;
            const receiverPhone = document.getElementById('receiverPhone').value; // <-- 여기서 값을 가져옴
            const orderEmailInput = document.getElementById('orderEmailInput').value; // <-- 여기서 값을 가져옴
            const postcode = document.getElementById('postcode').value;
            const address = document.getElementById('address').value;
            const addressDetail = document.getElementById('addressDetail').value;
            const deliveryRequest = document.getElementById('deliveryRequest');
            const customMessage = document.getElementById('customMessage');
            const paymentAgreement = document.getElementById('paymentAgreement');
            const selectedPayment = document.querySelector('.payment-method.selected');

            if (!receiverName.trim()) {
                alert('받는 사람 이름을 입력해주세요.');
                return false;
            }
            if (!receiverPhone.trim()) { // <-- 유효성 검사
                alert('연락처를 입력해주세요.');
                return false;
            }
            if (!orderEmailInput.trim()) { // <-- 유효성 검사
                alert('이메일 주소를 입력해주세요.');
                return false;
            }
            if (!postcode || !address) {
                alert('주소를 입력해주세요.');
                return false;
            }
            if (!addressDetail.trim()) {
                alert('상세주소를 입력해주세요.');
                return false;
            }
            if (deliveryRequest.value === 'custom' && !customMessage.value.trim()) {
                alert('배송 메시지를 입력해주세요.');
                return false;
            }
            if (!selectedPayment) {
                alert('결제 수단을 선택해주세요.');
                return false;
            }
            if (!paymentAgreement.checked) {
                alert('주문 상품 정보 및 결제 진행 동의가 필요합니다.');
                return false;
            }
            return true;
        }

        // 주문 제출 (결제하기 버튼)
        const submitOrderBtn = document.getElementById('submitOrderBtn');
        if (submitOrderBtn) {
            submitOrderBtn.addEventListener('click', function() {
                if (!isLoggedIn) { // 로그인 여부 재확인
                    alert('로그인이 필요한 기능입니다.');
                    window.location.href = '${pageContext.request.contextPath}/login.html';
                    return;
                }

                if (validateForm()) {
                    submitOrderBtn.disabled = true; // 버튼 비활성화

                    const selectedPayment = document.querySelector('.payment-method.selected');
                    if (selectedPayment.dataset.method === 'kakao') {
                        // 카카오페이 결제 처리 시작
                        const orderItemsElements = document.querySelectorAll('.order-item');
                        const orderItems = [];
                        let totalItemQty = 0;

                        orderItemsElements.forEach(itemEl => {
                            const goodsNo = parseInt(itemEl.dataset.goodsNo);
                            const goodsOptNo = parseInt(itemEl.dataset.goodsOptNo);
                            const qty = parseInt(itemEl.dataset.qty);

                            if (!isNaN(goodsNo) && !isNaN(qty)) {
                                const itemData = {
                                    goodsNo: goodsNo,
                                    qty: qty
                                };
                                if (!isNaN(goodsOptNo)) {
                                    itemData.goodsOptNo = goodsOptNo;
                                } else {
                                    itemData.goodsOptNo = 0;
                                }
                                orderItems.push(itemData);
                                totalItemQty += qty;
                            }
                        });

                        // 배송지 정보 수집 (유효성 검사된 값들을 다시 가져옴)
                        const receiverName = document.getElementById('receiverName').value;
                        const receiverPhone = document.getElementById('receiverPhone').value; // <-- 이제 여기서 최종 값
                        const postcode = document.getElementById('postcode').value;
                        const address1 = document.getElementById('address').value;
                        const address2 = document.getElementById('addressDetail').value;
                        const deliveryRequestSelect = document.getElementById('deliveryRequest');
                        const orderEmail = document.getElementById('orderEmailInput').value; // <-- 이제 여기서 최종 값

                        let orderMemo = deliveryRequestSelect.value;
                        if (orderMemo === 'custom') {
                            orderMemo = document.getElementById('customMessage').value;
                        } else if (orderMemo === '') {
                            orderMemo = null;
                        }

                        // 최종 결제 금액 (화면에서 파싱)
                        const finalAmountDisplay = document.getElementById('finalPaymentAmountDisplay').textContent;
                        const finalAmount = parseInt(finalAmountDisplay.replace(/[^0-9]/g, ''));

                        // 카카오페이 결제 준비 요청 Payload 구성
                        const payReadyPayload = {
                            orderItems: orderItems,
                            totalAmount: finalAmount,
                            totalQuantity: totalItemQty,

                            // OrdersVO에 필요한 나머지 정보
                            orderRecipientNm: receiverName,
                            orderRecipientPhone: receiverPhone, // <-- payload에 포함
                            orderZipCode: postcode,
                            orderAddress1: address1,
                            orderAddress2: address2,
                            orderEmail: orderEmail, // <-- payload에 포함
                            orderMemo: orderMemo,
                            orderTypeCode: document.getElementById('orderTypeCodeInput').value, // <-- orderTypeCodeInput에서 가져옴
                            // 단일 상품일 경우의 상품명 (카카오페이 결제창 요약용)
                            singleGoodsName: orderItems.length === 1 ? document.querySelector('.order-item .item-name').textContent : undefined,
                            isFromCart: (orderSource === 'CART') // 'CART'이면 true, 아니면 false
                        };

//                         console.log("JSP에서 넘어온 orderSource 값:", orderSource); // 디버깅용

                        // 카카오페이 결제 준비 API 호출
                        fetch('${pageContext.request.contextPath}/goods/order/pay/ready', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                [csrfHeader]: csrfToken
                            },
                            body: JSON.stringify(payReadyPayload)
                        })
                        .then(response => {
                            if (!response.ok) {
                                return response.json().then(errorData => {
                                    throw new Error(errorData.message || `서버 오류 발생 (HTTP ${response.status})`);
                                });
                            }
                            return response.json();
                        })
                        .then(data => {
                        		submitOrderBtn.disabled = false; // 버튼 다시 활성화

                            if (data.status === 'success') {
                                window.location.href = data.next_redirect_pc_url;
                            } else {
                                alert('결제 준비 실패: ' + data.message);
                            }
                        })
                        .catch(error => {
                        		submitOrderBtn.disabled = false; // 버튼 다시 활성화
                            console.error('결제 준비 중 오류:', error);
                            alert('결제 준비 중 오류가 발생했습니다: ' + error.message);
                        });

                    } else {
                        submitOrderBtn.disabled = false; // 비활성화 해제
                        alert('선택된 결제 수단이 카카오페이가 아닙니다. 다른 결제 수단은 준비 중입니다.');
                    }
                }
            });
        }
    });
</script>
</body>
</html>