<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 굿즈샵 - 찜목록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods_wishlist.css">
	
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.12.2/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.12.2/dist/sweetalert2.all.min.js"></script>
            
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
        /* 페이징 CSS (예시, 실제 디자인에 맞게 조절) */
        .paging-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 30px;
            margin-bottom: 50px;
            width: 100%;
        }
        .paging-container a,
        .paging-container span {
            display: inline-flex; /* Flexbox를 사용하여 내부 요소를 가운데 정렬 */
            justify-content: center;
            align-items: center;
            padding: 8px 12px;
            margin: 0 5px;
            border: 1px solid #ddd;
            border-radius: 44px;
            text-decoration: none;
            color: #333;
            min-width: 30px; /* 버튼 최소 너비 */
            box-sizing: border-box; /* 패딩, 보더 포함 너비 계산 */
        }
        .paging-container a:hover {
            background-color: #f0f0f0;
        }
        .paging-container .current-page {
            background-color: #8a2be2; /* 보라색으로 변경 */
            color: white;
            border-color: #8a2be2; /* 보라색으로 변경 */
            font-weight: bold;
        }
        .paging-container .prev-next-btn {
            font-size: 1.2em;
            padding: 5px 10px;
        }
        .empty-wishlist-message {
            text-align: center;
            padding: 50px 0;
            color: #666;
        }
        .btn-shop {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #8a2be2; /* 보라색으로 변경 */
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .btn-shop:hover {
            background-color: #6a1aab; /* 보라색 계열의 더 진한 색으로 변경 */
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
    </style>
</head>
<body class="wishlist-page-body">
    <jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />

    <div class="wishlist-container">
        <div class="wishlist-header">
            <h1>찜목록</h1>
        </div>

        <div class="wishlist-items" id="wishlistItems">
            <c:choose>
                <c:when test="${not empty wishedGoodsList}"> <%-- wishedGoodsList는 컨트롤러에서 전달받는 찜 목록 상품 데이터 --%>
                    <c:forEach var="goods" items="${wishedGoodsList}">
                        <div class="wishlist-item" data-goods-no="${goods.goodsNo}"> <%-- 상품 고유 번호 사용 --%>
                            <div class="item-image">
                                <a href="${pageContext.request.contextPath}/goods/detail?goodsNo=${goods.goodsNo}">
                                    <%-- representativeImageUrl 필드는 goodsVO에 있을 것입니다 --%>
                                    
                                    <c:set var="imageUrl" value="${goods.representativeImageUrl}" />
									<c:if test="${empty imageUrl}">
									    <c:set var="imageUrl" value="${pageContext.request.contextPath}/resources/images/default-goods-image.png" />
									</c:if>
									
									<img src="${imageUrl}"
									     alt="${goods.goodsNm}"
									     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/images/default-goods-image.png';">
                                </a>
                            </div>
                            <div class="item-info">
                                <a href="${pageContext.request.contextPath}/goods/detail?goodsNo=${goods.goodsNo}" class="item-name">${goods.goodsNm}</a>
                                <div class="item-price"><fmt:formatNumber value="${goods.goodsPrice}" type="number"/>원</div>
                            </div>
                            <div class="item-actions">
                                <button class="btn-action btn-heart" data-goods-no="${goods.goodsNo}">
                                    <i class="fas fa-heart">   찜 삭제  </i>
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-wishlist-message" style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 50px;">
                        <p>찜한 상품이 없습니다.</p>
                        <a href="${pageContext.request.contextPath}/goods/main" class="btn-shop">쇼핑하러 가기</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

<%---
            ⭐⭐⭐ 이 부분만 아래와 같이 변경합니다! ⭐⭐⭐
            기존 JSTL로 직접 페이징을 그리는 부분을 삭제하고,
            PaginationInfoVO의 getWishlistPagingHTML() 메서드를 호출하여 HTML을 받아옵니다.
        ---%>
        <c:if test="${pagingVO.totalRecord > 0}">
            <div class="paging-container">
                ${pagingVO.getWishlistPagingHTML(pageContext.request.contextPath)}
            </div>
        </c:if>
        <%--- (이전 JSP 페이징 로직 전체 삭제) ---%>


        <div class="empty-wishlist" style="display: none;"></div>
    </div>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp"/>
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
<script>
        let csrfToken;
        let csrfHeader;

        document.addEventListener('DOMContentLoaded', function() {
            // CSRF 토큰 초기화
            const csrfMeta = document.querySelector('meta[name="_csrf"]');
            const csrfHeaderMeta = document.querySelector('meta[name="_csrf_header"]');
            if (csrfMeta && csrfHeaderMeta) {
                csrfToken = csrfMeta.content;
                csrfHeader = csrfHeaderMeta.content;
            } else {
                console.error("CSRF meta tags not found.");
                // CSRF 토큰이 없는 경우에도 SweetAlert2로 사용자에게 알림
                Swal.fire({
                    icon: 'error',
                    title: '초기화 오류',
                    text: '보안 토큰을 불러올 수 없습니다. 페이지를 새로고침해주세요.',
                    confirmButtonText: '확인'
                });
            }

            // 로그인 상태 관리
            const isLoggedIn = <c:out value='${isLoggedIn}' default='false'/>;

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
                    event.preventDefault(); // 기본 폼 제출 방지
                    Swal.fire({
                        icon: 'success',
                        title: '로그아웃',
                        text: '성공적으로 로그아웃되었습니다.',
                        showConfirmButton: false,
                        timer: 1500
                    }).then(() => {
                        // 실제 로그아웃은 서버 측 URL로 이동하여 처리
                        const logoutForm = document.getElementById('logoutForm'); // communityHeader.jsp에 있는 폼을 가정
                        if(logoutForm) logoutForm.submit();
                        else window.location.href = '${pageContext.request.contextPath}/logout'; // 폼이 없으면 직접 이동
                    });
                });
            }

            // 외부 푸터 파일 로드 (경로 수정)
            fetch('${pageContext.request.contextPath}/resources/html/footer.html')
                .then(response => response.ok ? response.text() : Promise.reject('Footer not found'))
                .then(data => {
                    const footerPlaceholder = document.getElementById('footer-placeholder');
                    if (footerPlaceholder) {
                        footerPlaceholder.innerHTML = data;
                    }
                })
                .catch(error => console.error('Error loading footer:', error));

            // 찜목록 아이템 표시/숨김 관리
            const wishlistItemsContainer = document.getElementById('wishlistItems');
            const emptyWishlistMessage = document.querySelector('.empty-wishlist-message');

            function updateWishlistDisplay() {
                const totalWishedGoods = <c:out value='${pagingVO.totalRecord}' default='0'/>;

                if (totalWishedGoods === 0) {
                    wishlistItemsContainer.style.display = 'none';
                    if(emptyWishlistMessage) emptyWishlistMessage.style.display = 'flex';
                } else {
                    wishlistItemsContainer.style.display = 'flex';
                    if(emptyWishlistMessage) emptyWishlistMessage.style.display = 'none';
                }
            }
            updateWishlistDisplay(); // 초기 로드 시 한 번 호출하여 상태 확인

            // 찜 해제 및 장바구니 담기 기능 (이벤트 위임)
            wishlistItemsContainer.addEventListener('click', function(event) {
                const target = event.target;
                const item = target.closest('.wishlist-item');
                if (!item) return;

                const goodsNo = item.dataset.goodsNo;

                // 1. 찜 해제 버튼 클릭 시
                if (target.classList.contains('btn-heart') || target.closest('.btn-heart')) {
                    if (!isLoggedIn) {
                        Swal.fire({
                            icon: 'warning',
                            title: '로그인 필요',
                            text: '찜 해제 기능은 로그인이 필요합니다.',
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

                    Swal.fire({
                        title: '삭제 확인',
                        text: '선택한 상품을 찜목록에서 삭제하시겠습니까?',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#dc3545', // 빨간색
                        cancelButtonColor: '#6c757d', // 회색
                        confirmButtonText: '삭제',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            fetch('${pageContext.request.contextPath}/goods/wishlist', {
                                method: 'POST', // 찜 해제도 POST (토글)
                                headers: {
                                    'Content-Type': 'application/json',
                                    [csrfHeader]: csrfToken
                                },
                                body: JSON.stringify({ goodsNo: parseInt(goodsNo) })
                            })
                            .then(response => {
                                if (!response.ok) {
                                    if (response.status === 401) {
                                        Swal.fire({
                                            icon: 'error',
                                            title: '로그인 필요',
                                            text: '로그인 세션이 만료되었거나 로그인이 필요합니다.',
                                            confirmButtonText: '로그인'
                                        }).then(() => {
                                            window.location.href = '${pageContext.request.contextPath}/login';
                                        });
                                    }
                                    return response.json().then(errorData => {
                                        throw new Error(errorData.message || `서버 오류 발생 (HTTP ${response.status})`);
                                    });
                                }
                                return response.json();
                            })
                            .then(data => {
                                if (data.status === 'success' && data.action === 'removed') {
                                    Swal.fire({
                                        icon: 'success',
                                        title: '삭제 완료!',
                                        text: '찜 목록에서 상품이 삭제되었습니다.',
                                        showConfirmButton: false,
                                        timer: 1500
                                    }).then(() => {
                                        item.remove(); // UI에서 항목 즉시 제거
                                        // 찜 해제 후 페이지를 새로고침하여 페이징 정보와 목록을 정확히 업데이트
                                        window.location.reload(); 
                                    });
                                } else {
                                    Swal.fire({
                                        icon: 'error',
                                        title: '삭제 실패',
                                        text: data.message || '찜 해제에 실패했습니다.',
                                        confirmButtonText: '확인'
                                    });
                                }
                            })
                            .catch(error => {
                                console.error('찜 해제 중 오류:', error);
                                Swal.fire({
                                    icon: 'error',
                                    title: '오류 발생',
                                    text: '찜 해제 중 알 수 없는 오류가 발생했습니다: ' + error.message,
                                    confirmButtonText: '확인'
                                });
                            });
                        }
                    });
                }
                // 2. 장바구니 담기 버튼 클릭 시
                else if (target.classList.contains('btn-cart')) {
                    const defaultQty = 1;

                    if (!isLoggedIn) {
                        Swal.fire({
                            icon: 'warning',
                            title: '로그인 필요',
                            text: '장바구니 담기 기능은 로그인이 필요합니다.',
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

                    // 찜목록의 상품은 옵션이 없는 경우가 많으므로, goodsOptNo가 없을 수도 있음을 고려
                    // 만약 상품에 옵션이 필수로 있고 찜목록에서 옵션 선택 없이 바로 장바구니에 담는 것이 문제라면,
                    // 이 부분에서 "옵션을 선택하려면 상품 상세 페이지로 이동하세요" 같은 안내를 추가해야 합니다.
                    // 현재는 'null'로 넘어가도록 처리합니다.
                    const cartItemToAdd = {
                        goodsNo: parseInt(goodsNo),
                        cartQty: defaultQty,
                        goodsOptNo: item.dataset.goodsOptNo ? parseInt(item.dataset.goodsOptNo) : null
                    };

                    fetch('${pageContext.request.contextPath}/goods/cart/addMultiple', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            [csrfHeader]: csrfToken
                        },
                        body: JSON.stringify([cartItemToAdd])
                    })
                    .then(response => {
                        return response.text().then(text => { // 응답 텍스트를 먼저 받음
                            if (!response.ok) {
                                if (response.status === 401) {
                                    Swal.fire({
                                        icon: 'error',
                                        title: '로그인 필요',
                                        text: '로그인 세션이 만료되었거나 로그인이 필요합니다.',
                                        confirmButtonText: '로그인'
                                    }).then(() => {
                                        window.location.href = '${pageContext.request.contextPath}/login';
                                    });
                                }
                                throw new Error(text || `서버 오류 발생 (HTTP ${response.status})`);
                            }
                            try {
                                return JSON.parse(text); // 성공 시 JSON 파싱 시도
                            } catch (e) {
                                console.error("JSON 파싱 오류:", e, "응답 텍스트:", text);
                                throw new Error("서버 응답 파싱 실패");
                            }
                        });
                    })
                    .then(data => {
                        if (data.success) {
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
                                text: data.message || "장바구니 추가에 실패했습니다.",
                                confirmButtonText: '확인'
                            });
                        }
                    })
                    .catch(error => {
                        console.error('장바구니 추가 중 오류:', error);
                        let errorMessage = '장바구니 추가 중 알 수 없는 오류가 발생했습니다.';
                        try {
                            const errorObj = JSON.parse(error.message); // 에러 메시지가 JSON 형태일 경우 파싱
                            if (errorObj && errorObj.message) {
                                errorMessage = errorObj.message;
                            }
                        } catch (e) { /* 파싱 실패 시 기본 메시지 유지 */ }
                        Swal.fire({
                            icon: 'error',
                            title: '오류 발생',
                            text: errorMessage,
                            confirmButtonText: '확인'
                        });
                    });
                }
                // 3. 상품 이미지/이름 클릭 시 상세페이지로 이동
                else if (target.classList.contains('item-name') || target.closest('.item-image a')) {
                    const item = target.closest('.wishlist-item');
                    if (item) {
                        const goodsNo = item.dataset.goodsNo;
                        window.location.href = `${pageContext.request.contextPath}/goods/detail?goodsNo=${goodsNo}`;
                    }
                }
            });
        });
    </script>
</body>
</html>