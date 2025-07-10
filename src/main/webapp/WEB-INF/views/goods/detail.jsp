<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- Assuming product object is set in request scope --%>
	<title>DDTOWN 굿즈샵 - ${not empty goods.goodsNm ? goods.goodsNm : "상품 상세"}</title>
	<meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
 	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.12.2/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.12.2/dist/sweetalert2.all.min.js"></script>


 	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods_main.css">
 	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
 	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css" />
 	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods_detail.css" />


 	<style type="text/css">
 		.product-image-gallery, .product-purchase-info{
 			width: 100%;
 		}

 		.floating-nav {
		    position: fixed;
		    bottom: 100px;
		    right: 24px;
		    z-index: 1000;
		    display: flex;
		    flex-direction: column;
		    gap: 15px;
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
<body class="product-detail-page-body">
    <jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />

    <div class="detail-container">
        <c:if test="${not empty goods}">
            <div class="product-main-info-wrapper">
				<section class="product-image-gallery">
				    <%-- goods 객체가 유효한지 먼저 확인 --%>
				    <c:if test="${not empty goods}">
				        <div class="product-main-image-detail">
				            <%-- 메인 이미지: goodsVO의 representativeImageUrl 필드를 사용 --%>
				            <img src="${not empty goods.representativeImageUrl ? goods.representativeImageUrl : 'https://via.placeholder.com/550x550/E6E6FA/000000?text=Album+Main'}"
				                 alt="상품 메인 이미지" id="mainProductImageDetail">
				        </div>
				        <div class="product-thumbnail-images-detail">
				            <%-- 썸네일 이미지: goodsVO의 attachmentFileList를 순회하며 AttachmentFileDetailVO의 webPath 사용 --%>
				            <%-- attachmentFileList가 비어있지 않은 경우에만 반복 --%>
				            <c:if test="${not empty goods.attachmentFileList}">
				                <c:forEach var="file" items="${goods.attachmentFileList}" varStatus="loop">
				                    <%-- 대표 이미지와 썸네일 이미지가 중복되지 않도록 필요하다면 조건을 추가할 수 있습니다.
				                         예: <c:if test="${file.fileNo ne goods.representativeImageFile.fileNo}"> --%>
				                    <img src="${file.webPath}"
				                         alt="썸네일 ${loop.count}"
				                         class="${loop.first ? 'active' : ''}" <%-- 첫 번째 이미지만 'active' 클래스 부여 --%>
				                         onclick="changeDetailMainImage('${file.webPath}', '550x550', this)">
				                </c:forEach>
				            </c:if>

				            <%-- 첨부파일(썸네일 포함)이 아예 없거나, 모든 파일이 필터링되어 썸네일로 표시할 것이 없는 경우의 폴백 이미지 --%>
				            <%-- 여기서는 goods.attachmentFileList가 비어있을 때만 폴백 처리합니다. --%>
				            <c:if test="${empty goods.attachmentFileList}">
				                <img src="https://via.placeholder.com/70x70/E6E6FA/000000?text=Thumb1" alt="썸네일 1" class="active" onclick="changeDetailMainImage(this.src, '550x550', this)">
				                <img src="https://via.placeholder.com/70x70/D8BFD8/000000?text=Thumb2" alt="썸네일 2" onclick="changeDetailMainImage(this.src, '550x550', this)">
				            </c:if>
				        </div>
				    </c:if>
				    <%-- goods 객체가 아예 없는 경우 (상품 번호가 잘못되었거나 삭제된 경우 등) --%>
				    <c:if test="${empty goods}">
				        <div style="text-align: center; padding: 50px;">
				            <p>상품 정보를 찾을 수 없습니다.</p>
				            <img src="https://via.placeholder.com/550x550/E6E6FA/000000?text=Product+Not+Found" alt="상품 찾을 수 없음" style="max-width: 100%;">
				        </div>
				    </c:if>
				</section>

                <section class="product-purchase-info">
                        <%-- 컨트롤러에서 "goods"라는 이름으로 넘겨준 객체를 사용합니다. --%>
<%-- 					<div class="artist-tag">${goods.artGroupNo}</div> --%>
					    <h1 class="product-name-detail">${not empty goods.goodsNm ? goods.goodsNm : "상품명 없음"}</h1>
<%-- 					<p class="product-short-description">${not empty goods.goodsContent ? goods.goodsContent : "상품 설명이 없습니다."}</p> --%>

                    <div class="product-price-detail-area">
                        <%-- Initial price set to 0, will be updated by JS if an option is selected --%>
                        <div class="product-price-detail" id="productPrice">
						    <fmt:formatNumber value="${goods.goodsPrice}" type="number" groupingUsed="true" />
						    <span class="currency">원</span>
						</div>
                        <div class="shipping-info-summary">배송비 3,000원 (30,000원 이상 구매 시 무료)</div>
                    </div>


					<div class="product-options-detail">
					    <div class="option-group" style="font-size: medium;">
					        <label for="productOption">옵션 선택</label>
					        <select id="productOption" name="productOption">
					            <option value="">옵션을 선택해주세요</option>
					            <c:forEach var="option" items="${optionList}">
					                <option value="${option.goodsOptNo}" data-price="${option.goodsOptPrice}" data-name="<c:out value='${option.goodsOptNm}'/>">
					                    <c:out value="${option.goodsOptNm}"/> - <fmt:formatNumber value="${option.goodsOptPrice}" type="number" groupingUsed="true" />원
					                </option>
					            </c:forEach>
					        </select>
					    </div>

						<div id="selectedOptionArea" style="margin-top: 10px; margin-bottom: 15px;">

						</div>
					</div>

					<div class="total-price-summary">
					    <span class="total-label">총 상품금액:</span>
					    <span class="total-amount" id="totalProductPriceDetail">
					        <c:choose>
					            <c:when test="${not empty optionList}">0</c:when>
					            <c:otherwise><fmt:formatNumber value="${goods.goodsPrice}" type="number" groupingUsed="true" /></c:otherwise>
					        </c:choose>
					         원
					    </span>
					</div>

                    <div class="product-actions-detail">
						<button class="wish-button" data-goods-no="${goods.goodsNo}">
						    <i class="far fa-heart"></i> 찜하기
						</button>
						<form id="addToCartForm" action="/goods/cart" method="post">
							<button type="button" class="btn-action-detail cart" id="addToCartBtnDetail">장바구니</button>
							<input type="hidden" name="goodsNo" value="${goods.goodsNo}">
							<sec:csrfInput/>
						</form>
                        <button class="btn-action-detail order" id="orderNowBtnDetail">주문하기</button>
                    </div>
                </section>
            </div>

            <div class="product-info-tabs-container">
                <nav class="product-info-tabs">
                    <a href="#" class="tab-link active" data-tab-target="productDescription">상품 상세</a>
                    <a href="#" class="tab-link" data-tab-target="shippingGuide">배송/교환/환불 안내</a>
                </nav>
					<div id="productDescription" class="tab-pane active" style="white-space: pre-wrap; word-break: break-word; padding: 20px;">
					    <h4>상품 정보</h4>
					    <p>${not empty goods.goodsContent ? goods.goodsContent : "상세 상품 정보가 없습니다."}</p>

					    <%-- 상품 상세 이미지 출력 --%>
					    <c:set var="hasDetailImages" value="false"/>
					    <c:forEach var="file" items="${goods.attachmentFileList}">
					        <c:if test="${file.webPath ne goods.representativeImageUrl}">
					            <img src="${file.webPath}" alt="상품 상세 이미지 - ${file.fileOriginalNm}" style="max-width: 100%; height: auto; display: block; margin: 10px 0;">
					            <c:set var="hasDetailImages" value="true"/>
					        </c:if>
					    </c:forEach>

					    <c:if test="${empty goods.attachmentFileList or not hasDetailImages}">
					         <img src="https://via.placeholder.com/700x400/f0f0f0/333?text=상품+상세+이미지+없음" alt="상품 상세 이미지 없음" style="max-width: 100%; height: auto; display: block; margin: 10px 0;">
					    </c:if>
					</div>
                    <div id="shippingGuide" class="tab-pane">
                        <h4>배송/교환/환불 안내</h4>
                        <p><strong>배송 안내</strong><br> - 기본 배송비는 3,000원이며, 30,000원 이상 구매 시 무료배송입니다.<br> - 주문일로부터 평균 2~5 영업일 이내 발송됩니다. (예약 상품 제외)</p>
                        <p><strong>교환/환불 안내</strong><br> - 상품 수령 후 7일 이내에 신청 가능합니다.<br> - 단순 변심의 경우 왕복 배송비가 부과됩니다.<br> - 상품 불량 및 오배송의 경우 배송비는 판매자 부담입니다.</p>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${empty goodsList}">
            <p style="text-align: center; padding: 50px;">상품 정보를 불러올 수 없습니다.</p>
        </c:if>
    </div>

    <nav class="floating-nav">
        <a href="${pageContext.request.contextPath}/goods/cart/list" class="floating-btn" id="floatingCartBtn" title="장바구니">
            🛒
            <span class="item-count-badge" id="cartItemCount" style="display: ${cartItemCount > 0 ? 'flex' : 'none'};">${cartItemCount}</span>
        </a>
        <a href="${pageContext.request.contextPath}/goods/wishlist" class="floating-btn" id="floatingWishlistBtn" title="찜목록">
            ❤️
            <span class="item-count-badge" id="wishlistItemCount" style="display: ${wishCount > 0 ? 'flex' : 'none'};">${wishCount}</span>
        </a>

    </nav>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
<script>
// 메인 상품 이미지를 변경하는 함수는 DOMContentLoaded 밖으로 이동합니다.
function changeDetailMainImage(newSrc, newSize, clickedThumbnail) {
    const mainImage = document.getElementById('mainProductImageDetail');
    if (mainImage) {
        mainImage.src = newSrc; // 클릭된 썸네일의 이미지 경로로 메인 이미지 변경
        // 선택된 썸네일의 'active' 클래스 관리 (포커스 시각화)
        const thumbnails = document.querySelectorAll('.product-thumbnail-images-detail img');
        thumbnails.forEach(thumbnail => {
            thumbnail.classList.remove('active'); // 모든 썸네일에서 active 클래스 제거
        });
        clickedThumbnail.classList.add('active'); // 클릭된 썸네일에 active 클래스 추가
    }
}

document.addEventListener('DOMContentLoaded', function () {

    // --- 1. CSRF 및 로그인 상태 설정 ---
    let csrfTokenValue;
    let csrfHeaderName;
    const csrfInput = document.querySelector("input[name='_csrf']");
    if (csrfInput) {
        csrfTokenValue = csrfInput.value;
        csrfHeaderName = "X-CSRF-TOKEN";
    } else {
        console.error("CSRF 토큰 input을 찾을 수 없습니다.");
    }

    const isLoggedIn = <c:out value='${isLoggedIn ? "true" : "false"}' default='false'/>;

    // --- 2. 네비게이션 및 로그아웃 버튼 설정 ---
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
            const logoutForm = document.getElementById('logoutForm');
            if(logoutForm) logoutForm.submit();
        });
    }

    // --- 탭하면 내용 나오게 하기 ---
    const tabLinks = document.querySelectorAll('.tab-link');
    const tabPanes = document.querySelectorAll('.tab-pane');

    tabLinks.forEach(link => {
        link.addEventListener('click', function(event) {
            event.preventDefault(); // 기본 링크 이동 방지

            tabLinks.forEach(item => { // 모든 tab-link를 순회하며 active 제거
                item.classList.remove('active');
            });

            this.classList.add('active'); // 클릭된 'link' 자신에게 active 클래스 추가

            tabPanes.forEach(pane => {
                pane.classList.remove('active');
            });

            const targetId = this.dataset.tabTarget;
            const targetPane = document.getElementById(targetId);
            if (targetPane) {
                targetPane.classList.add('active');
            }
        });
    });

    // --- 3. 찜하기 기능 (SweetAlert2 적용) ---
    const wishlistButtonEl = document.querySelector('.product-actions-detail .wish-button');
    if (wishlistButtonEl) {
        // 버튼의 모양(UI)을 상태에 따라 바꿔주는 함수
        const updateWishButtonUI = (isWished) => {
            if (isWished) {
                wishlistButtonEl.innerHTML = '<i class="fas fa-heart"></i> 찜 완료';
                wishlistButtonEl.classList.add('wished');
            } else {
                wishlistButtonEl.innerHTML = '<i class="far fa-heart"></i> 찜하기';
                wishlistButtonEl.classList.remove('wished');
            }
        };

        // 페이지가 로딩되면, 가장 먼저 현재 찜 상태를 서버에 물어보는 함수
        const checkInitialStatus = () => {
            if (!isLoggedIn) {
                updateWishButtonUI(false);
                return;
            }

            const currentGoodsNo = wishlistButtonEl.getAttribute('data-goods-no');
            if (!currentGoodsNo) {
                 console.error("초기 찜 상태 확인: goodsNo를 찾을 수 없습니다!");
                 return;
            }

            fetch(`${pageContext.request.contextPath}/goods/wishlist/status?goodsNo=\${currentGoodsNo}`)
                .then(response => {
                    if (!response.ok) throw new Error(`서버 응답 오류 (${response.status})`);
                    return response.json();
                })
                .then(data => {
                    updateWishButtonUI(data.isWished);
                })
                .catch(error => {
                    console.error('초기 찜 상태 확인 중 에러:', error);
                    updateWishButtonUI(false); // 오류 시 기본 상태로
                });
        };

        // 찜 버튼 클릭 이벤트 설정
        wishlistButtonEl.addEventListener('click', function() {
            if (!isLoggedIn) {
                Swal.fire({
                    icon: 'warning',
                    title: '로그인 필요',
                    text: '찜하기 기능은 로그인이 필요합니다.',
                    showCancelButton: true,
                    confirmButtonText: '로그인 페이지로 이동',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    }
                });
                return;
            }

            const currentGoodsNo = this.getAttribute('data-goods-no');
            if (!currentGoodsNo) {
                 Swal.fire('오류', '상품 정보를 찾을 수 없습니다.', 'error');
                 return;
            }

            fetch('${pageContext.request.contextPath}/goods/wishlist', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', [csrfHeaderName]: csrfTokenValue },
                body: JSON.stringify({ goodsNo: parseInt(currentGoodsNo) })
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => {
                        throw new Error(err.message || `서버 오류 (${response.status})`);
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.status === 'success') {
                    if (data.action === 'added') {
                        updateWishButtonUI(true);
                        Swal.fire({
                            icon: 'success',
                            title: '찜 목록에 추가되었습니다!',
                            showConfirmButton: false,
                            timer: 1500
                        });
                    } else if (data.action === 'removed') {
                        updateWishButtonUI(false);
                        Swal.fire({
                            icon: 'info',
                            title: '찜 목록에서 삭제되었습니다.',
                            showConfirmButton: false,
                            timer: 1500
                        });
                    } else { // 예외적인 action 값
                         Swal.fire('알림', data.message || '찜 처리 결과가 불분명합니다.', 'info');
                    }
                } else { // data.status === 'fail' 또는 'error'
                    Swal.fire('실패', data.message || '찜 처리 중 알 수 없는 오류가 발생했습니다.', 'error');
                }
            })
            .catch(error => {
                console.error('찜 처리 에러:', error);
                Swal.fire('오류', '찜 처리 중 오류가 발생했습니다: ' + error.message, 'error');
            });
        });

        // 스크립트가 준비되면, 최초 상태 확인 함수를 바로 실행!
        checkInitialStatus();
    }

    // --- 4. 상품 옵션 기능 ---
    const productOptionSelect = document.getElementById('productOption');
    const selectedOptionArea = document.getElementById('selectedOptionArea');
    const totalProductPriceDetailSpan = document.getElementById('totalProductPriceDetail');

    function updateTotalPrice() {
        let currentTotal = 0;
        const selectedItems = selectedOptionArea.querySelectorAll('.selected-option-item');
        selectedItems.forEach(item => {
            const price = parseFloat(item.dataset.optionPrice);
            const quantity = parseInt(item.querySelector('.quantity').value);
            currentTotal += price * quantity;
        });
        totalProductPriceDetailSpan.textContent = currentTotal.toLocaleString('ko-KR');
    }

    if(productOptionSelect) { // 옵션 select가 있을 때만 이벤트 리스너 등록
        productOptionSelect.addEventListener('change', function () {
            let list = document.getElementsByClassName("selected-option-item");
            const selectedOption = this.options[this.selectedIndex];
            const optionValue = selectedOption.value;
            const optionName = selectedOption.dataset.name;

            for(let i=0; i<list.length; i++){
                if(optionName && optionName.trim() === list[i].dataset.optionName.trim()){ // === 사용 권장
                    Swal.fire({
                        icon: 'info',
                        title: '이미 선택된 옵션',
                        text: '이미 선택하신 상품 옵션입니다.',
                        confirmButtonText: '확인'
                    });
                    this.value = '';
                    return false;
                }
            }

            if (!optionValue || !optionName) return;

            const optionPrice = parseFloat(selectedOption.dataset.price);
            const optionItemDiv = document.createElement('div');
            optionItemDiv.classList.add('selected-option-item');
            optionItemDiv.dataset.optionId = optionValue;
            optionItemDiv.dataset.optionName = optionName;
            optionItemDiv.dataset.optionPrice = optionPrice;

            optionItemDiv.innerHTML = `
                <span class="option-name">\${optionName}</span>
                <span class="option-price-display">(\${optionPrice.toLocaleString('ko-KR')}원)</span>
                <div>
                    <label for="quantity-${optionValue}" class="visually-hidden">\${optionName} 수량</label>
                    <input type="number" id="quantity-${optionValue}" class="quantity" value="1" min="1">
                </div>
                <button type="button" class="remove-option-btn" title="옵션 삭제">&times;</button>
            `;
            selectedOptionArea.appendChild(optionItemDiv);

            optionItemDiv.querySelector('.quantity').addEventListener('input', updateTotalPrice);
            optionItemDiv.querySelector('.remove-option-btn').addEventListener('click', function () {
                this.parentElement.remove();
                updateTotalPrice();
            });

            updateTotalPrice();
            this.value = '';
        });
    }

    // --- 5. 장바구니 버튼 클릭 이벤트 (SweetAlert2 적용) ---
    const addToCartBtn = document.getElementById('addToCartBtnDetail');
    if(addToCartBtn) {
        addToCartBtn.addEventListener('click', function() {
            const form = document.getElementById('addToCartForm');
            const goodsNo = form.querySelector('input[name="goodsNo"]').value;
            const csrfTokenForCart = form.querySelector('input[name="_csrf"]').value;

            const cartItems = [];
            const selectedOptionElements = selectedOptionArea.querySelectorAll('.selected-option-item');

            if (selectedOptionElements.length === 0) {
                Swal.fire({
                    icon: 'warning',
                    title: '옵션 선택',
                    text: '장바구니에 담을 옵션을 선택해주세요.',
                    confirmButtonText: '확인'
                });
                return;
            }

            selectedOptionElements.forEach(item => {
                const goodsOptNo = parseInt(item.dataset.optionId);
                const cartQty = parseInt(item.querySelector('.quantity').value);

                if (isNaN(goodsOptNo) || goodsOptNo <= 0 || isNaN(cartQty) || cartQty < 1) {
                    Swal.fire({
                        icon: 'error',
                        title: '입력 오류',
                        text: '유효하지 않은 상품 옵션 또는 수량이 있습니다. 다시 확인해주세요.',
                        confirmButtonText: '확인'
                    });
                    cartItems.length = 0;
                    return;
                }
                cartItems.push({ goodsNo: goodsNo, goodsOptNo: goodsOptNo, cartQty: cartQty });
            });

            if (cartItems.length === 0) return;

            fetch('${pageContext.request.contextPath}/goods/cart/addMultiple', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfTokenForCart },
                body: JSON.stringify(cartItems)
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || `장바구니 추가 중 서버 오류 (${response.status})`);
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                	// ⭐⭐⭐ 이 부분에 updateCartItemCount() 호출 추가 ⭐⭐⭐
                    // communityHeader.jsp에 정의된 함수를 window 객체를 통해 호출
                    if (typeof window.updateCartItemCount === 'function') {
                        window.updateCartItemCount();
                    } else {
                        console.error("updateCartItemCount 함수를 찾을 수 없습니다. communityHeader.jsp가 제대로 로드되었는지 확인하세요.");
                        // 만약 서버 응답에 newCartCount가 있다면, 그것으로 직접 업데이트하는 비상책도 고려할 수 있습니다.
                        const headerCartItemCountBadge = document.getElementById('headerCartItemCount'); // communityHeader.jsp의 뱃지 ID
                        if (headerCartItemCountBadge && data.newCartCount !== undefined) {
                            headerCartItemCountBadge.textContent = data.newCartCount;
                            headerCartItemCountBadge.style.display = data.newCartCount > 0 ? 'block' : 'none';
                        }
                        // ⭐ 여기에 floatingCartItemCountBadge 업데이트 로직이 필요한데, 현재는 headerCartItemCountBadge만 참조하고 있습니다. ⭐
                        // goodsDetail.jsp 안의 floating nav 뱃지는 id가 cartItemCount 입니다.
                        const floatingCartItemCountBadge = document.getElementById('cartItemCount'); // 이 ID가 floating nav의 뱃지 ID입니다.
                        if (floatingCartItemCountBadge && data.newCartCount !== undefined) {
                            floatingCartItemCountBadge.textContent = data.newCartCount;
                            floatingCartItemCountBadge.style.display = data.newCartCount > 0 ? 'flex' : 'none';
                        }
                    }

                    Swal.fire({
                        icon: 'success',
                        title: '장바구니에 추가되었습니다!',
                        text: '장바구니로 이동하시겠습니까?',
                        showCancelButton: true,
                        confirmButtonText: '이동',
                        cancelButtonText: '계속 쇼핑'
                    }).then((result) => {
                        if (result.isConfirmed) {
                           window.location.href = "${pageContext.request.contextPath}/goods/cart/list";
                        }
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: '추가 실패',
                        text: data.message || "장바구니 추가 실패!",
                        confirmButtonText: '확인'
                    });
                }
            })
            .catch(error => {
                console.error('장바구니 추가 에러:', error);
                Swal.fire({
                    icon: 'error',
                    title: '오류 발생',
                    text: "장바구니 추가 중 알 수 없는 오류가 발생했습니다: " + error.message,
                    confirmButtonText: '확인'
                });
            });
        });
    }

    // --- '주문하기' 버튼 클릭 이벤트 (SweetAlert2 적용) ---
    const orderNowBtnDetail = document.getElementById('orderNowBtnDetail');
    if (orderNowBtnDetail) {
        orderNowBtnDetail.addEventListener('click', function() {
            if (!isLoggedIn) {
                Swal.fire({
                    icon: 'warning',
                    title: '로그인 필요',
                    text: '바로 주문하기는 로그인이 필요합니다.',
                    showCancelButton: true,
                    confirmButtonText: '로그인 페이지로 이동',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    }
                });
                return;
            }

            const goodsNo = <c:out value='${goods.goodsNo}' default='0'/>;
            const goodsNm = '<c:out value="${goods.goodsNm}" escapeXml="true"/>';
            const currentTotalAmount = parseInt(totalProductPriceDetailSpan.textContent.replace(/,/g, ''), 10);

            const orderItems = [];
            const selectedOptionElements = selectedOptionArea.querySelectorAll('.selected-option-item');

            if (selectedOptionElements.length === 0) {
                Swal.fire({
                    icon: 'warning',
                    title: '옵션 선택',
                    text: '주문할 옵션을 선택해주세요.',
                    confirmButtonText: '확인'
                });
                return;
            }

            selectedOptionElements.forEach(item => {
                const goodsOptNo = parseInt(item.dataset.optionId);
                const qty = parseInt(item.querySelector('.quantity').value);
                const optionName = item.dataset.optionName;

                if (isNaN(goodsOptNo) || goodsOptNo < 0 || isNaN(qty) || qty < 1) {
                    Swal.fire({
                        icon: 'error',
                        title: '입력 오류',
                        text: '유효하지 않은 상품 옵션 또는 수량이 있습니다. 다시 확인해주세요.',
                        confirmButtonText: '확인'
                    });
                    orderItems.length = 0;
                    return;
                }
                orderItems.push({
                    goodsNo: goodsNo,
                    goodsNm: goodsNm + (optionName ? ` (${optionName})` : ''),
                    qty: qty,
                    goodsOptNo: goodsOptNo
                });
            });

            if (orderItems.length === 0) {
                return;
            }

            if (currentTotalAmount <= 0) {
                Swal.fire({
                    icon: 'warning',
                    title: '금액 오류',
                    text: '총 주문 금액이 0원입니다. 주문할 수 없습니다.',
                    confirmButtonText: '확인'
                });
                return;
            }

            const payReadyPayload = {
                orderItems: orderItems,
                totalAmount: currentTotalAmount,
                singleGoodsName: goodsNm + (orderItems.length === 1 ? (orderItems[0].goodsNm.includes('(') ? '' : ` (${orderItems[0].goodsNm.split('(')[1].replace(')','')})`) : '')
            };

            orderNowBtnDetail.disabled = true; // 중복 클릭 방지

            fetch('${pageContext.request.contextPath}/goods/order/prepareFromDetail', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    [csrfHeaderName]: csrfTokenValue
                },
                body: JSON.stringify(payReadyPayload)
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || `주문 준비 중 서버 오류 (${response.status})`);
                    });
                }
                return response.json();
            })
            .then(data => {
                orderNowBtnDetail.disabled = false; // 버튼 다시 활성화
                if (data.status === 'success') {
                    window.location.href = '${pageContext.request.contextPath}/goods/order';
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
                orderNowBtnDetail.disabled = false; // 버튼 다시 활성화
                console.error('바로 주문하기 중 오류:', error);
                Swal.fire({
                    icon: 'error',
                    title: '오류 발생',
                    text: '주문 처리 중 오류가 발생했습니다: ' + error.message,
                    confirmButtonText: '확인'
                });
            });
        });
    }

});
</script>
</body>
</html>