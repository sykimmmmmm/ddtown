<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 굿즈샵 - 주문 상세</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css">

    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
        .order-detail-container {
            max-width: 900px;
            margin: 80px auto 50px;
            padding: 40px;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            background-color: #fff;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }
        .order-detail-container h2 {
            font-size: 2.2em;
            color: #2c3e50;
            margin-bottom: 30px;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 15px;
            text-align: center;
            font-weight: 700;
        }
        .section-title {
            font-size: 1.6em;
            color: #34495e;
            margin-top: 35px;
            margin-bottom: 20px;
            border-left: 6px solid #4a90e2;
            padding-left: 15px;
            font-weight: 600;
        }
        .detail-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
            background-color: #fdfdfd; /* 테이블 배경색 */
            border-radius: 8px; /* 테이블 모서리 둥글게 */
            overflow: hidden; /* 둥근 모서리 적용 */
        }
        .detail-table th, .detail-table td {
            padding: 15px;
            border: 1px solid #e9ecef;
            text-align: left;
            vertical-align: middle;
            font-size: 0.95em;
        }
        .detail-table th {
            background-color: #f1f4f8;
            width: 180px;
            font-weight: 600;
            color: #495057;
        }
        .order-items-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
            background-color: #fdfdfd;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }
        .order-items-table th, .order-items-table td {
            padding: 15px;
            border: 1px solid #e9ecef;
            text-align: center;
            font-size: 0.9em;
        }
        .order-items-table th {
            background-color: #e9ecef;
            color: #34495e;
            font-weight: 600;
        }
        .order-items-table td.text-left {
            text-align: left;
        }
        .product-info {
            display: flex;
            align-items: center;
            gap: 18px;
        }
        .product-info img {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #ddd;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        /* 이미지 없음 처리 시 추가될 스타일 */
        .no-image-placeholder {
            width: 80px;
            height: 90px;
            display: flex;
            flex-direction: column; /* 텍스트와 이미지 세로 정렬 */
            align-items: center;
            justify-content: center;
            border: 1px solid #ddd;
            border-radius: 6px;
            background-color: #f2f4f6;
            text-align: center;
            font-size: 0.8em; /* 폰트 크기 조정 */
            color: #888;
            box-sizing: border-box; /* 패딩이 크기에 포함되도록 */
            padding: 8px; /* 약간의 패딩 */
        }
        .no-image-placeholder img {
            width: 45px; /* 기본 이미지 크기 조정 */
            height: 45px;
            object-fit: contain;
            margin-bottom: 5px; /* 텍스트와의 간격 */
            opacity: 0.7;
        }
        .total-summary {
            text-align: right;
            font-size: 1.5em;
            font-weight: bold;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px dashed #e9ecef;
            color: #2c3e50;
        }
        .total-summary strong {
            color: #e74c3c; /* 강조 색상 */
        }
        /* --- 버튼 스타일 통일 --- */
        .button {
            display: inline-flex; /* 버튼 내 아이템 중앙 정렬을 위해 flexbox 사용 */
            align-items: center;
            justify-content: center;
            padding: 12px 25px; /* 패딩 조정 */
            border: none;
            border-radius: 6px; /* 모서리 둥글게 */
            font-size: 1.05em; /* 폰트 크기 조정 */
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.2s ease;
            font-weight: 500;
            white-space: nowrap; /* 텍스트 줄바꿈 방지 */
        }
        .button:hover {
            transform: translateY(-2px); /* 호버 시 약간 위로 이동 */
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .action-buttons {
            display: flex;
            justify-content: center; /* 버튼 중앙 정렬 */
            gap: 15px; /* 버튼 간 간격 */
            margin-top: 40px; /* 상단 여백 증가 */
        }
        .action-buttons .cancel-button {
            background-color: #ff4d4d; /* 취소 버튼은 빨간색 */
            color: #fff;
        }
        .action-buttons .cancel-button:hover {
            background-color: #dc3545;
        }
        .action-buttons .back-button {
            background-color: #95a5a6; /* 돌아가기 버튼은 회색 */
            color: #fff;
        }
        .action-buttons .back-button:hover {
            background-color: #7f8c8d;
        }
        /* 모달 스타일 */
        .modal-overlay {
            display: none; /* 초기에는 숨김 */
            position: fixed; /* 뷰포트에 고정 */
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6); /* 반투명 배경 */
            justify-content: center; /* 자식 요소(modal-content) 수평 중앙 정렬 */
            align-items: center;     /* 자식 요소(modal-content) 수직 중앙 정렬 */
            z-index: 1000;           /* 다른 요소 위에 표시되도록 높은 z-index 부여 */
            backdrop-filter: blur(3px);
        }
        .modal-content {
            background: #fff;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
            width: 450px;
            max-width: 90%;
            text-align: center;
            animation: fadeInScale 0.3s ease-out forwards;
        }
        .modal-content h3 {
            margin-top: 0;
            color: #2c3e50;
            font-size: 2em;
            margin-bottom: 25px;
            font-weight: 700;
        }
        .modal-content p {
            margin-bottom: 30px;
            font-size: 1.15em;
            color: #555;
        }
        .modal-content label {
            display: block;
            text-align: left;
            margin-bottom: 10px;
            font-weight: bold;
            color: #34495e;
            font-size: 1em;
        }
        .modal-content select, .modal-content textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 25px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1em;
            resize: vertical; /* 세로 크기 조절 가능 */
            box-sizing: border-box;
        }
        .modal-content select:focus, .modal-content textarea:focus {
            border-color: #4a90e2; /* 포커스 시 색상 변경 */
            outline: none;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
        }
        .modal-content .modal-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 15px;
        }
        .modal-content .modal-buttons .confirm-btn {
            background-color: #4a90e2;
            color: #fff;
        }
        .modal-content .modal-buttons .confirm-btn:hover {
            background-color: #357ABD;
        }
        .modal-content .modal-buttons .cancel-btn {
            background-color: #95a5a6;
            color: #fff;
        }
        .modal-content .modal-buttons .cancel-btn:hover {
            background-color: #7f8c8d;
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
<body class="order-page-body">
    <jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />

    <div class="order-detail-container">
        <h2>주문 상세</h2>

        <h3 class="section-title">주문 정보</h3>
        <table class="detail-table">
            <tr>
                <th>주문 번호</th>
                <td>${order.orderNm}</td>
            </tr>
            <tr>
                <th>주문일시</th>
                <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy년 MM월 dd일 HH:mm"/></td>
            </tr>
            <tr>
                <th>주문 상태</th>
                <td>${order.orderStatName}</td>
            </tr>
            <tr>
                <th>총 결제 금액</th>
                <td><strong><fmt:formatNumber value="${order.orderTotalPrice}" type="number"/>원</strong></td>
            </tr>
            <tr>
                <th>결제 수단</th>
                <td>${order.orderPayMethodNm}</td>
            </tr>
        </table>

        <h3 class="section-title">주문 상품</h3>
        <table class="order-items-table">
            <thead>
                <tr>
                    <th>상품 정보</th>
                    <th>단가</th>
                    <th>수량</th>
                    <th>금액</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${order.orderDetailList}">
                    <tr>
                        <td class="text-left">
                            <div class="product-info">
                                <c:choose>
                                    <c:when test="${not empty item.representativeImageUrl}">
                                        <img src="${pageContext.request.contextPath}${item.representativeImageUrl}"
                                             alt="${item.goodsNm}" onerror="this.src='${pageContext.request.contextPath}/resources/img/default_goods.png';">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-image-placeholder">
                                            <img src="${pageContext.request.contextPath}/resources/img/default_goods.png"
                                                 alt="이미지 없음">
                                            <span>이미지 없음</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <div>${item.goodsNm}</div>
                                    <c:if test="${not empty item.goodsOptNo}">
                                        <small>(옵션: ${item.goodsOptNm})</small>
                                    </c:if>
                                </div>
                            </div>
                        </td>
                        <td><fmt:formatNumber value="${item.goodsOptPrice eq 0 ? item.goodsPrice : item.goodsOptPrice}" type="number"/>원</td>
                        <td>${item.orderDetQty}개</td>
                        <td><fmt:formatNumber value="${item.goodsOptPrice eq 0 ? item.goodsPrice * item.orderDetQty : item.goodsOptPrice * item.orderDetQty}" type="number"/>원</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <h3 class="section-title">수령인 정보</h3>
        <table class="detail-table">
            <tr>
                <th>수령인</th>
                <td>${order.orderRecipientNm}</td>
            </tr>
            <tr>
                <th>연락처</th>
                <td>${order.orderRecipientPhone}</td>
            </tr>
            <tr>
                <th>주소</th>
                <td>(${order.orderZipCode}) ${order.orderAddress1} ${order.orderAddress2}</td>
            </tr>
            <tr>
                <th>이메일</th>
                <td>${order.orderEmail}</td>
            </tr>
            <c:if test="${not empty order.orderMemo}">
                <tr>
                    <th>배송 요청사항</th>
                    <td>${order.orderMemo}</td>
                </tr>
            </c:if>
        </table>

        <h3 class="section-title">결제 정보</h3>
        <table class="detail-table">
            <tr>
                <th>결제 번호 (TID)</th>
                <td>${order.paymentVO.tid}</td>
            </tr>
            <tr>
                <th>승인 번호 (AID)</th>
                <td>${order.paymentVO.aid}</td>
            </tr>
            <tr>
                <th>결제 금액</th>
                <td><fmt:formatNumber value="${order.paymentVO.totalAmount}" type="number"/>원</td>
            </tr>
            <tr>
                <th>결제 상태</th>
                <td>${order.paymentVO.paymentStatCodeNm}</td>
            </tr>
            <tr>
                <th>결제 승인 일시</th>
                <td><fmt:formatDate value="${order.paymentVO.completedAt}" pattern="yyyy년 MM월 dd일 HH:mm:ss"/></td>
            </tr>
        </table>


        <%-- 주문 취소 버튼 및 돌아가기 버튼 --%>
        <div class="action-buttons">
            <%-- 주문 상태가 '주문 완료' (OSC001) 또는 '결제 요청' (OSC002) 또는 '결제 완료' (PSC001) 일 때만 취소 버튼 표시 --%>
            <c:if test="${order.orderStatCode eq 'OSC001' or order.orderStatCode eq 'OSC002' or order.orderStatCode eq 'PSC001'}">
                 <button type="button" id="cancelOrderBtn" class="button cancel-button" data-order-no="${order.orderNo}">
                    주문 취소
                </button>
            </c:if>
            <a href="${pageContext.request.contextPath}/mypage/orders" class="button back-button">주문 목록</a>
        </div>
    </div>

    <div id="footer-placeholder"></div>

    <%-- 결제 취소 확인 모달 --%>
    <div id="cancelConfirmationModal" class="modal-overlay">
        <div class="modal-content">
            <h3>주문 취소 확인</h3>
            <p><span id="modalOrderNoDisplay"></span>번 주문을 정말로 취소하시겠습니까?</p>
            <label for="cancelReasonCode">취소 사유 선택:</label>
            <select id="cancelReasonCode">
                <option value="">-- 사유 선택 --</option>
                <option value="CRC001">단순 변심</option>
                <option value="CRC002">상품 변경/오류</option>
                <option value="CRC003">배송 지연</option>
            </select>
            <label for="cancelReasonDetail">상세 사유 (선택 사항):</label>
            <textarea id="cancelReasonDetail" rows="3" placeholder="자세한 취소 사유를 입력해주세요."></textarea>
            <div class="modal-buttons">
                <button type="button" id="confirmCancelBtn" class="button confirm-btn">확인</button>
                <button type="button" id="closeModalBtn" class="button cancel-btn">취소</button>
            </div>
        </div>
    </div>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
  <script>
    // contextPath는 JSP에서만 사용 가능하므로 변수에 저장하여 JS에서 활용
    const contextPath = "${pageContext.request.contextPath}";

    document.addEventListener('DOMContentLoaded', function() {

        // --- 주문 취소 기능 관련 JavaScript 시작 (수정된 부분) ---

        const cancelOrderBtn = document.getElementById('cancelOrderBtn'); // '주문 취소' 메인 버튼
        const cancelConfirmationModal = document.getElementById('cancelConfirmationModal'); // 모달 오버레이
        const modalOrderNoDisplay = document.getElementById('modalOrderNoDisplay'); // 모달 내 주문 번호 표시 요소
        const cancelReasonCodeSelect = document.getElementById('cancelReasonCode'); // 취소 사유 select
        const cancelReasonDetailTextarea = document.getElementById('cancelReasonDetail'); // 상세 사유 textarea
        const confirmCancelBtn = document.getElementById('confirmCancelBtn'); // 모달 내 '취소하기' 버튼
        const closeModalBtn = document.getElementById('closeModalBtn'); // 모달 내 '닫기' 버튼

        let currentOrderNo = null; // 현재 취소하려는 주문 번호를 저장할 변수

//         console.log('DOM 요소 로드 상태:');
//         console.log('  cancelOrderBtn:', cancelOrderBtn);
//         console.log('  cancelConfirmationModal:', cancelConfirmationModal);
//         console.log('  modalOrderNoDisplay:', modalOrderNoDisplay);
//         console.log('  cancelReasonCodeSelect:', cancelReasonCodeSelect);
//         console.log('  cancelReasonDetailTextarea:', cancelReasonDetailTextarea);
//         console.log('  confirmCancelBtn:', confirmCancelBtn);
//         console.log('  closeModalBtn:', closeModalBtn);

        // '주문 취소' 메인 버튼 클릭 이벤트 (모달 열기)
        if (cancelOrderBtn) {
            cancelOrderBtn.addEventListener('click', function() {
                currentOrderNo = this.dataset.orderNo; // data-order-no 값 가져오기
//                 console.log('--- "주문 취소" 메인 버튼 클릭됨! currentOrderNo:', currentOrderNo);

                if (modalOrderNoDisplay) {
                    modalOrderNoDisplay.textContent = currentOrderNo; // 모달에 주문 번호 표시
                }

                if (cancelConfirmationModal) {
                    cancelConfirmationModal.style.display = 'flex'; // 모달 표시 (CSS의 flex 설정 활용)
                }

                // 모달이 열릴 때 사유 선택 및 상세 사유 필드를 초기화
                if (cancelReasonCodeSelect) cancelReasonCodeSelect.value = "";
                if (cancelReasonDetailTextarea) cancelReasonDetailTextarea.value = "";
            });
        } else {
            console.error('ERROR: "cancelOrderBtn" 요소를 찾을 수 없습니다. HTML ID를 확인해주세요!');
        }

        // 모달 닫기 버튼 이벤트 ('닫기' 버튼)
        if (closeModalBtn) {
            closeModalBtn.addEventListener('click', function() {
//                 console.log('--- 모달 "닫기" 버튼 클릭됨. 모달 숨김.');
                if (cancelConfirmationModal) {
                    cancelConfirmationModal.style.display = 'none'; // 모달 숨기기
                }
            });
        } else {
            console.error('ERROR: "closeModalBtn" 요소를 찾을 수 없습니다. HTML ID를 확인해주세요!');
        }

        // 모달 외부 클릭 시 닫기
        if (cancelConfirmationModal) {
            cancelConfirmationModal.addEventListener('click', function(event) {
                if (event.target === cancelConfirmationModal) {
//                     console.log('--- 모달 외부 클릭됨. 모달 숨김.');
                    cancelConfirmationModal.style.display = 'none';
                }
            });
        }

     // '취소하기' 버튼 클릭 이벤트 (AJAX 요청 전송)
        if (confirmCancelBtn) {
            confirmCancelBtn.addEventListener('click', function() {
//                 console.log('### "취소하기" 버튼 클릭됨! AJAX 요청 준비.');

                const cancelReasonCode = cancelReasonCodeSelect ? cancelReasonCodeSelect.value : '';
                const cancelReasonDetail = cancelReasonDetailTextarea ? cancelReasonDetailTextarea.value : '';

//                 console.log('  선택된 취소 사유 코드:', cancelReasonCode);
//                 console.log('  입력된 취소 상세 사유:', cancelReasonDetail);

                if (!cancelReasonCode) {
                    Swal.fire({
                    	icon: 'info',
                    	title: '취소 사유를 선택해주세요.',
                    })
                }

                if (currentOrderNo) {
//                     console.log('AJAX 요청 시작. 취소할 주문 번호:', currentOrderNo);

                    // ★★★ 수정됨: 템플릿 리터럴 백슬래시 제거 ★★★
                    const requestUrl = `\${contextPath}/goods/order/cancel/\${currentOrderNo}`; // 최종 URL 구성
//                     console.log('  생성된 최종 요청 URL:', requestUrl); // 이 로그 값을 꼭 확인해주세요!

                    // 백엔드 API 호출 (AJAX)
                    fetch(requestUrl, { // ★★★ 구성된 URL 사용 ★★★
                        method: 'PATCH',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content,
                            'X-CSRF-HEADER': document.querySelector('meta[name="_csrf_header"]').content
                        },
                        body: JSON.stringify({
                            cancelReasonCode: cancelReasonCode,
                            cancelReasonDetail: cancelReasonDetail
                        })
                    })
                    .then(response => {
//                         console.log('Fetch 응답 수신:', response);
                        if (!response.ok) {
                            return response.json().then(errorData => {
                                console.error('서버 에러 응답 (JSON):', errorData);
                                throw new Error(errorData.message || `취소 요청 실패: ${response.status} ${response.statusText}`);
                            }).catch(jsonError => {
                                console.error('서버 응답 JSON 파싱 실패 또는 에러 처리 중 오류:', jsonError);
                                throw new Error(`취소 요청 실패: ${response.status} ${response.statusText} (응답 형식 오류)`);
                            });
                        }
                        return response.json();
                    })
                    .then(data => {
//                         console.log('Fetch 성공 데이터:', data);
                        if (data.status === 'success') {
                        	// ⭐ 주문 취소 성공 시 SweetAlert2 팝업 ⭐
                            Swal.fire({
                                icon: 'success',
                                title: '취소 완료',
                                text: data.message || '주문이 성공적으로 취소되었습니다.',
                                confirmButtonText: '확인'
                        }).then(() => { // <--- 이 부분이 누락된 괄호와 추가된 `.then` 체인입니다.
                            // SweetAlert이 닫힌 후 실행될 콜백 (예: 페이지 새로고침)
                            window.location.reload(); // 페이지 새로고침을 원하시면 이 줄을 사용하세요.
                        	});
                        } else {
                        	Swal.fire({
                                icon: 'error',
                                title: '취소 실패',
                                text: data.message || '주문 취소에 실패했습니다.',
                                confirmButtonText: '확인'
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Fetch Error (catch 블록):', error);
                        Swal.fire({
                            icon: 'error',
                            title: '오류 발생',
                            text: '주문 취소 중 오류가 발생했습니다: ' + error.message,
                            confirmButtonText: '확인'
                        });
                    })
                    .finally(() => {
//                         console.log('AJAX 요청 완료. 모달 숨김.');
                        if (cancelConfirmationModal) {
                            cancelConfirmationModal.style.display = 'none';
                        }
                    });
                } else {
                	Swal.fire({
                        icon: 'warning',
                        title: '경고',
                        text: '취소할 주문 번호를 찾을 수 없습니다.',
                        confirmButtonText: '확인'
                    });
                    console.warn('currentOrderNo가 설정되지 않았습니다. 메인 "주문 취소" 버튼 클릭이 누락되었거나 data-order-no 속성이 없습니다.');
                    if (cancelConfirmationModal) {
                        cancelConfirmationModal.style.display = 'none';
                    }
                }
            });
        } else {
            console.error('ERROR: "confirmCancelBtn" 요소를 찾을 수 없습니다. HTML ID를 확인해주세요!');
        }
        // --- 주문 취소 기능 관련 JavaScript 끝 ---

    });
</script>


</body>
</html>