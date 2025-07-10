<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 굿즈샵 - 장바구니</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods.css">
	<meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods_cart.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css" />

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.12.2/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.12.2/dist/sweetalert2.all.min.js"></script>
    <style type="text/css">
    	.community-header-wrapper { /* 실제 헤더를 감싸는 클래스나 ID를 사용하세요 */
		    position: fixed; /* 요소를 뷰포트에 고정 */
		    top: 0;          /* 화면 상단에 붙임 */
		    left: 0;         /* 화면 왼쪽에 붙임 */
		    width: 100%;     /* 화면 전체 너비 */
		    z-index: 1000;   /* 다른 콘텐츠 위에 표시되도록 높은 z-index 부여 */
		    background-color: #fff; /* 고정 시 배경이 투명하면 뒤 내용이 비치므로, 색상 지정 (필요에 따라 투명도 조절) */
		    box-shadow: 0 2px 5px rgba(0,0,0,0.1); /* 선택 사항: 그림자 효과로 입체감 주기 */
		}
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
<body class="cart-page-body">
    <jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />

    <div class="cart-container">
        <div class="cart-header"><h1>장바구니</h1></div>

        <div class="cart-controls" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
            <div><label><input type="checkbox" id="selectAllItems"> 전체선택</label></div>
            <button id="deleteSelectedItems" style="padding: 5px 10px; font-size:1.2em; border:1px solid #ddd; background-color:#fff; border-radius:4px; cursor:pointer;">선택삭제</button>
        </div>

        <div class="cart-item-list" id="cartItemList" style="font-size: large;">
		    <c:set var="totalProductPriceInitial" value="0"/>
		    <c:forEach var="cartItem" items="${cartItems}">
		        <div class="cart-item
		        	${cartItem.goodsStatCode eq 'SOLD_OUT' || cartItem.goodsStatCode eq 'UNAVAILABLE' ? 'disabled' : ''}"
		             data-product-id="${cartItem.goodsNo}" data-cart-no="${cartItem.cartNo }">  <%-- goodsNo 사용 --%>
		            <input type="checkbox" class="item-checkbox"
		            	${cartItem.goodsStatCode eq 'SOLD_OUT' || cartItem.goodsStatCode eq 'UNAVAILABLE' ? 'disabled' : ''} checked>
		            <div class="item-image">
		                <img src="${not empty cartItem.representativeImageUrl ? cartItem.representativeImageUrl : 'https://via.placeholder.com/550x550/E6E6FA/000000?text=No+Image'}" <%-- null/empty 체크 추가 --%>
		                     alt="${cartItem.goodsNm}">
		            </div>
		            <div class="item-info">
		                <a href="/goods/detail?goodsNo=${cartItem.goodsNo}" class="item-name">${cartItem.goodsNm}</a> <%-- goodsNo, goodsNm 사용 --%>
		                <span class="item-option">옵션: ${cartItem.goodsOptNm}</span> <%-- goodsOptNm 사용 --%>
		                <c:if test="${cartItem.goodsStatCode eq 'SOLD_OUT'}">
		                    <span class="item-status">(품절)</span>
		                </c:if>
		                <c:if test="${cartItem.goodsStatCode eq 'UNAVAILABLE'}">
		                    <span class="item-status">(상품 정보 없음)</span>
		                </c:if>
		            </div>
		            <div class="item-quantity">
					    <button class="quantity-decrease" ${cartItem.goodsStatCode eq 'SOLD_OUT' || cartItem.goodsStatCode eq 'UNAVAILABLE' ? 'disabled' : ''}>-</button>
					    <input type="number"
						       value="${cartItem.cartQty}"
						       min="1"
						       max="10"
						       readonly
						       ${cartItem.goodsStatCode eq 'SOLD_OUT' || cartItem.goodsStatCode eq 'UNAVAILABLE' ? 'disabled' : ''}
						       data-unit-price="${cartItem.goodsPrice}"
						>
					    <button class="quantity-increase" ${cartItem.goodsStatCode eq 'SOLD_OUT' || cartItem.goodsStatCode eq 'UNAVAILABLE' ? 'disabled' : ''}>+</button>
					</div>
		            <div class="item-price"> <%-- goodsPrice 사용 --%>
		                <fmt:formatNumber value="${cartItem.goodsPrice * cartItem.cartQty}" type="number"/>원 <%-- goodsPrice, cartQty 사용 --%>
		            </div>
		            <div class="item-delete"><button title="삭제">🗑️</button></div>
		        </div>
		        <c:if test="${cartItem.goodsStatCode ne 'SOLD_OUT' && cartItem.goodsStatCode ne 'UNAVAILABLE'}">
		            <c:set var="totalProductPriceInitial" value="${totalProductPriceInitial + (cartItem.goodsPrice * cartItem.cartQty)}"/> <%-- goodsPrice, cartQty 사용 --%>
		        </c:if>
		    </c:forEach>
		</div>

        <div class="cart-summary" style="font-size: large;">
            <h3>주문 요약</h3>
            <div class="summary-row">
                <span class="label">총 상품 금액</span>
                <span class="value" id="totalProductPrice"><fmt:formatNumber value="${totalProductPriceInitial}" type="number"/>원</span>
            </div>
            <div class="summary-row">
                <span class="label">배송비</span>
                <span class="value" id="shippingFee"><fmt:formatNumber value="${totalProductPriceInitial > 0 ? 3000 : 0}" type="number"/>원</span>
            </div>
            <hr style="border:none; border-top:1px dashed #ddd; margin: 15px 0;">
            <div class="summary-row total">
                <span class="label">총 결제 금액</span>
                <span class="value" id="finalTotalPrice"><fmt:formatNumber value="${totalProductPriceInitial + (totalProductPriceInitial > 0 ? 3000 : 0)}" type="number"/>원</span>
            </div>
        </div>

        <div class="cart-actions">
            <a href="${pageContext.request.contextPath}/goods/main" class="btn-keep-shopping" style="font-size: large;">쇼핑 계속하기</a>
            <button class="btn-order" id="orderButton" style="font-size: large;">주문하기</button>
        </div>
    </div>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
<script>
    let csrfToken;
    let csrfHeader;

    function formatCurrency(amount) {
        return new Intl.NumberFormat('ko-KR').format(amount) + '원';
    }

    document.addEventListener('DOMContentLoaded', function() {
        csrfToken = document.querySelector('meta[name="_csrf"]').content;
        csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

        const logoutBtn = document.getElementById('logoutBtn');

        if (logoutBtn) {
            logoutBtn.addEventListener('click', function(event) {
                event.preventDefault();
                Swal.fire({
                    icon: 'success',
                    title: '로그아웃',
                    text: '성공적으로 로그아웃되었습니다.',
                    showConfirmButton: false,
                    timer: 1500
                }).then(() => {
                    const logoutForm = document.getElementById('logoutForm');
                    if(logoutForm) logoutForm.submit();
                    else window.location.href = '${pageContext.request.contextPath}/logout';
                });
            });
        }

        // --- 장바구니 기능 관련 요소 참조 ---
        const cartItemList = document.getElementById('cartItemList');
        const selectAllCheckbox = document.getElementById('selectAllItems');
        const deleteSelectedButton = document.getElementById('deleteSelectedItems');
        const orderButton = document.getElementById('orderButton');

     // --- 장바구니 요약 정보(총 상품 금액, 배송비, 최종 결제 금액) 업데이트 함수 ---
        function updateSummary() {
            let totalProductPrice = 0;

            const selectedCheckboxes = document.querySelectorAll('.cart-item:not(.disabled) .item-checkbox:checked');

            selectedCheckboxes.forEach(checkbox => {
                const item = checkbox.closest('.cart-item');

                const quantityInput = item.querySelector('input[type="number"]');
                if (quantityInput) {
                    const price = parseFloat(quantityInput.dataset.unitPrice) || 0;
                    const quantity = Number(quantityInput.value) || 0;
                    totalProductPrice += price * quantity;
                } else {
                    console.warn("경고: 'input[type=\"number\"]' 요소를 찾을 수 없습니다. 해당 장바구니 항목: ", item);
                }
            });

            const freeShippingThreshold = 30000;
            let shippingFee = 0;
            if (totalProductPrice >= freeShippingThreshold) {
                shippingFee = 0;
            } else if (totalProductPrice > 0) {
                shippingFee = 3000;
            } else {
                shippingFee = 0;
            }

            const finalTotalPrice = totalProductPrice + shippingFee;

            document.getElementById('totalProductPrice').textContent = formatCurrency(totalProductPrice);
            document.getElementById('shippingFee').textContent = formatCurrency(shippingFee);
            document.getElementById('finalTotalPrice').textContent = formatCurrency(finalTotalPrice);

//             console.log('총 상품 금액:', totalProductPrice);
//             console.log('계산된 배송비:', shippingFee);
//             console.log('최종 결제 금액:', finalTotalPrice);

            const allItemCheckboxes = document.querySelectorAll('.cart-item:not(.disabled) .item-checkbox');
            const checkedItemCheckboxes = document.querySelectorAll('.cart-item:not(.disabled) .item-checkbox:checked');

            if (selectAllCheckbox) {
                selectAllCheckbox.checked = allItemCheckboxes.length > 0 && allItemCheckboxes.length === checkedItemCheckboxes.length;
            }
        }

	    async function updateCartItemQuantityInDb(cartNo, newQuantity) {

	        try {
	            const response = await fetch('/goods/cart/updateQuantity', {
	                method: 'POST',
	                headers: {
	                    'Content-Type': 'application/json',
	                    'Accept': 'application/json',
	                    [csrfHeader]: csrfToken
	                },
	                body: JSON.stringify({ cartNo: cartNo, cartQty: newQuantity })
	            });

	            const responseText = await response.text();

	            let data;
	            try {
	                if (responseText && responseText.trim().startsWith('{') && responseText.trim().endsWith('}')) {
	                    data = JSON.parse(responseText);
	                } else {
	                    throw new Error(`서버가 JSON이 아닌 응답을 보냈습니다: ${responseText}`);
	                }
	            } catch (jsonParseError) {
	                console.error("JSON 파싱 오류:", jsonParseError);
	                throw new Error(`서버 응답 JSON 파싱 실패. 응답 내용: ${responseText.substring(0, 100)}...`);
	            }

	            if (!response.ok) {
	                Swal.fire({
                        icon: 'error',
                        title: '수량 업데이트 실패',
                        text: data.message || `서버 오류 발생 (HTTP ${response.status})`,
                        confirmButtonText: '확인'
                    });
	                throw new Error(data.message || `서버 오류 발생 (HTTP ${response.status})`);
	            }

	            if (data.status === 'success') {
	                updateSummary();
	            } else {
	                console.warn('DB 수량 업데이트 실패:', data.message);
	                Swal.fire({
                        icon: 'error',
                        title: '수량 업데이트 실패',
                        text: data.message || '수량 업데이트에 실패했습니다.',
                        confirmButtonText: '확인'
                    });
	            }
	        } catch (error) {
	            console.error('DB 수량 업데이트 중 통신 오류:', error);
	            Swal.fire({
                    icon: 'error',
                    title: '오류 발생',
                    text: '장바구니 수량 업데이트 중 오류가 발생했습니다: ' + error.message,
                    confirmButtonText: '확인'
                });
	            updateSummary();
	        }
	    }

        function handleDeleteItem(itemElement) {
            const cartNo = itemElement.dataset.cartNo;
            if (!cartNo) {
                console.error('장바구니 번호(cartNo)를 찾을 수 없습니다.');
                Swal.fire({
                    icon: 'error',
                    title: '데이터 오류',
                    text: '장바구니 항목 정보를 가져올 수 없습니다.',
                    confirmButtonText: '확인'
                });
                return;
            }

            Swal.fire({
                title: '삭제 확인',
                text: '선택한 상품을 장바구니에서 삭제하시겠습니까?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '삭제',
                cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch('/goods/cart/delete', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'Accept': 'application/json',
                            [csrfHeader]: csrfToken
                        },
                        body: JSON.stringify({ cartNo: parseInt(cartNo) })
                    })
                    .then(response => {
                        if (!response.ok) {
                            return response.json().then(errorData => {
                                throw new Error(errorData.message || '서버 오류가 발생했습니다.');
                            });
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.status === 'success') {
                            Swal.fire({
                                icon: 'success',
                                title: '삭제 완료!',
                                text: '상품이 장바구니에서 삭제되었습니다.',
                                showConfirmButton: false,
                                timer: 1500
                            }).then(() => {
                                itemElement.remove();
                                updateSummary();
                                // 장바구니가 비었는지 확인 후 메시지 표시
                                if (cartItemList.children.length === 0) {
                                    document.querySelector('.cart-summary').style.display = 'none';
                                    document.querySelector('.cart-actions').style.display = 'none';
                                    if(document.querySelector('.empty-cart-message')) { // 이미 JSP에 있을 수 있음
                                        document.querySelector('.empty-cart-message').style.display = 'flex';
                                    } else { // 없으면 동적으로 생성 (최초 로드 시 JSP에서 처리되므로 이 경우는 드물 것)
                                        const emptyMessageDiv = document.createElement('div');
                                        emptyMessageDiv.classList.add('empty-wishlist-message'); // CSS 재활용
                                        emptyMessageDiv.innerHTML = `<p>장바구니에 담긴 상품이 없습니다.</p><a href="${pageContext.request.contextPath}/goods/main" class="btn-shop">쇼핑하러 가기</a>`;
                                        cartItemList.parentNode.insertBefore(emptyMessageDiv, cartItemList.nextSibling);
                                    }
                                }
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: '삭제 실패',
                                text: data.message || '장바구니 삭제에 실패했습니다.',
                                confirmButtonText: '확인'
                            });
                        }
                    })
                    .catch(error => {
                        console.error('장바구니 삭제 중 오류:', error);
                        Swal.fire({
                            icon: 'error',
                            title: '오류 발생',
                            text: '장바구니 삭제 중 오류가 발생했습니다: ' + error.message,
                            confirmButtonText: '확인'
                        });
                    });
                }
            });
        }

	     cartItemList.addEventListener('click', async function(event) {
	         const target = event.target;
	         const item = target.closest('.cart-item');
	         if (!item) return;

	         const cartNo = parseInt(item.dataset.cartNo);
// 	         console.log("파싱된 cartNo (JS):", cartNo);

	         const input = item.querySelector('input[type="number"]');
	         if (!input) {
	             console.error("오류: 'input[type=\"number\"]' 요소를 찾을 수 없습니다. 해당 장바구니 항목:", item);
	             return;
	         }
// 	         console.log("찾은 input 요소:", input);
// 	         console.log("input.value:", input.value);
// 	         console.log("Number(input.value):", Number(input.value));

	         const unitPriceString = input.getAttribute('data-unit-price');
// 	         console.log("input.getAttribute('data-unit-price'):", unitPriceString);

	         const unitPrice = parseFloat(unitPriceString) || 0;
// 	         console.log("parseFloat(unitPriceString):", unitPrice);

	         let currentQuantity = Number(input.value) || 0;

	         if (isNaN(cartNo) || cartNo <= 0 || isNaN(unitPrice) || unitPrice <= 0 || isNaN(currentQuantity) || currentQuantity <= 0) {
	              console.error("유효하지 않은 장바구니 정보 또는 수량입니다. DB 업데이트 요청을 건너뜜.",
	                              "cartNo:", cartNo, "unitPrice:", unitPrice, "currentQuantity:", currentQuantity);
	              Swal.fire({
                      icon: 'error',
                      title: '데이터 오류',
                      text: '장바구니 정보를 가져올 수 없거나 유효하지 않은 수량입니다. 페이지를 새로고침해주세요.',
                      confirmButtonText: '확인'
                  });
	              return;
	         }

	         if (target.closest('.item-delete button')) {
	             handleDeleteItem(item);
	             return;
	         }

	         if (item.classList.contains('disabled')) {
	             return;
	         }

	         if (target.classList.contains('quantity-increase')) {
	             const maxQuantity = parseInt(input.max);
	             let newQuantity = Number(input.value);

	             if (newQuantity < maxQuantity) {
	                 newQuantity += 1;
	                 input.value = newQuantity;

	                 item.querySelector('.item-price').textContent = formatCurrency(unitPrice * newQuantity);

	                 await updateCartItemQuantityInDb(cartNo, newQuantity);
	             } else {
                    Swal.fire({
                        icon: 'info',
                        title: '최대 수량',
                        text: `최대 ${maxQuantity}개까지 주문 가능합니다.`,
                        confirmButtonText: '확인'
                    });
                 }
	         } else if (target.classList.contains('quantity-decrease')) {
	             const minQuantity = parseInt(input.min);
	             let newQuantity = Number(input.value);

	             if (newQuantity > minQuantity) {
	                 newQuantity -= 1;
	                 input.value = newQuantity;

	                 item.querySelector('.item-price').textContent = formatCurrency(unitPrice * newQuantity);

	                 await updateCartItemQuantityInDb(cartNo, newQuantity);
	             } else {
                    Swal.fire({
                        icon: 'info',
                        title: '최소 수량',
                        text: `최소 ${minQuantity}개 이상 주문해야 합니다.`,
                        confirmButtonText: '확인'
                    });
                 }
	         } else if (target.classList.contains('item-checkbox')) {
	             updateSummary();
	         }
	     });

		if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener('change', function() {
                cartItemList.querySelectorAll('.cart-item:not(.disabled) .item-checkbox').forEach(checkbox => {
                    checkbox.checked = this.checked;
                });
                updateSummary();
            });
        }

		if (deleteSelectedButton) {
            deleteSelectedButton.addEventListener('click', function() {
                const selectedCheckboxes = cartItemList.querySelectorAll('.cart-item:not(.disabled) .item-checkbox:checked');
                if (selectedCheckboxes.length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: '선택 필요',
                        text: '삭제할 상품을 선택해주세요.',
                        confirmButtonText: '확인'
                    });
                    return;
                }

                const cartNoList = [];
                selectedCheckboxes.forEach(checkbox => {
                    const cartItemDiv = checkbox.closest('.cart-item');
                    const cartNo = cartItemDiv.dataset.cartNo;
                    if (cartNo) {
                        cartNoList.push(parseInt(cartNo));
                    }
                });

                if (cartNoList.length === 0) {
                    Swal.fire({
                        icon: 'error',
                        title: '데이터 오류',
                        text: '삭제할 장바구니 정보를 찾을 수 없습니다. (데이터 오류)',
                        confirmButtonText: '확인'
                    });
                    return;
                }

                Swal.fire({
                    title: '선택 삭제 확인',
                    text: `선택한 ${cartNoList.length}개 상품을 장바구니에서 삭제하시겠습니까?`,
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#dc3545',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: '삭제',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
                        const requestBody = { cartNoList: cartNoList };

                        fetch('/goods/cart/deleteSelected', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                'Accept': 'application/json',
                                [csrfHeader]: csrfToken
                            },
                            body: JSON.stringify(requestBody)
                        })
                        .then(response => {
                            if (!response.ok) {
                                return response.json().then(errorData => {
                                    throw new Error(errorData.message || '서버 오류가 발생했습니다.');
                                });
                            }
                            return response.json();
                        })
                        .then(data => {
                            if (data.status === 'success' || data.status === 'partial_success') {
                                Swal.fire({
                                    icon: 'success',
                                    title: '삭제 완료!',
                                    text: data.message || '선택한 상품이 장바구니에서 삭제되었습니다.',
                                    showConfirmButton: false,
                                    timer: 1500
                                }).then(() => {
                                    location.reload();
                                });
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: '삭제 실패',
                                    text: data.message || '선택 삭제 중 알 수 없는 오류가 발생했습니다.',
                                    confirmButtonText: '확인'
                                });
                            }
                        })
                        .catch(error => {
                            console.error('장바구니 선택 삭제 중 오류:', error);
                            Swal.fire({
                                icon: 'error',
                                title: '오류 발생',
                                text: '장바구니 선택 삭제 중 오류가 발생했습니다: ' + error.message,
                                confirmButtonText: '확인'
                            });
                        });
                    }
                });
            });
        }

        if (orderButton) {
            orderButton.addEventListener('click', function() {
                const selectedCartItems = document.querySelectorAll('.cart-item:not(.disabled) .item-checkbox:checked');

                if (selectedCartItems.length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: '선택 필요',
                        text: '주문할 상품을 선택해주세요.',
                        confirmButtonText: '확인'
                    });
                    return;
                }

                const selectedCartNoList = [];
                selectedCartItems.forEach(checkbox => {
                    const cartItemDiv = checkbox.closest('.cart-item');
                    const cartNo = cartItemDiv.dataset.cartNo;
                    if (cartNo) {
                        selectedCartNoList.push(parseInt(cartNo));
                    }
                });

                if (selectedCartNoList.length === 0) {
                    Swal.fire({
                        icon: 'error',
                        title: '데이터 오류',
                        text: '주문할 장바구니 정보를 찾을 수 없습니다. (데이터 오류)',
                        confirmButtonText: '확인'
                    });
                    return;
                }

                fetch('/goods/order/prepare', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        [csrfHeader]: csrfToken
                    },
                    body: JSON.stringify({ cartNoList: selectedCartNoList })
                })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(errorData => {
                            throw new Error(errorData.message || '주문 준비 중 서버 오류가 발생했습니다.');
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.status === 'success') {
                        window.location.href = '/goods/order';
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: '주문 실패',
                            text: data.message || '주문 준비에 실패했습니다.',
                            confirmButtonText: '확인'
                        });
                    }
                })
                .catch(error => {
                    console.error('주문 준비 중 오류:', error);
                    Swal.fire({
                        icon: 'error',
                        title: '오류 발생',
                        text: '주문 처리 중 오류가 발생했습니다: ' + error.message,
                        confirmButtonText: '확인'
                    });
                });
            });
        }

        updateSummary();
    });

</script>
</body>
</html>