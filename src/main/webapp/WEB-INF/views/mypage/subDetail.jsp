<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" >
    <!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script> -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<title>APT 구독 현황</title>
<style>
	body {
        font-family: 'Source Sans Pro', sans-serif; /* 폰트 일관성 유지 */
        background-color: var(--background-color, #f4f6f9); /* body 배경색을 변수로 관리 */
        color: var(--text-color, #333); /* 기본 텍스트 색상 */
    }
    .mypage-section-header {
        padding: 20px 0;
        border-bottom: 1px solid var(--border-color, #e0e0e0);
        margin-bottom: 25px;
        text-align: center; /* 타이틀 중앙 정렬 */
    }
    .membership-list { margin-bottom: 30px; padding: 0 15px; }
    .membership-card-item { background-color: var(--card-bg, #fff); border: 1px solid var(--border-color, #e0e0e0); border-radius: 10px; padding: 25px; margin-bottom: 25px; box-shadow: var(--card-shadow, 0 4px 10px rgba(0,0,0,0.08)); transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out; }
    .membership-card-item:hover {
        transform: translateY(-3px); /* 살짝 위로 뜨는 효과 */
        box-shadow: var(--card-hover-shadow, 0 6px 15px rgba(0,0,0,0.12));
    }
    .membership-card-item .artist-profile { display: flex; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid var(--border-light, #f0f0f0); }
    .membership-card-item .artist-profile img { width: 55px; height: 55px; border-radius: 50%; margin-right: 15px; object-fit: cover; border: 2px solid var(--primary-light, #e0e0e0); }
    .membership-card-item .artist-profile .artist-name-subscription { font-size: 1.3em; font-weight: 700; color: var(--text-color, #333); display: flex; align-items: center; }
    .membership-card-item .artist-profile .artist-name-subscription .fa-gem {
        margin-right: 10px;
        color: var(--accent-color, #63DEFD); /* 강조 색상 변수화 */
        font-size: 0.9em; /* 아이콘 크기 조정 */
    }
    .membership-details p { margin-bottom: 10px; font-size: 1em; color: var(--text-light, #555); display:flex; align-items: center; }
    .membership-details p strong { color: var(--text-color, #333); min-width: 110px; display: inline-block; font-weight: 600; }
    .membership-details .status-badge { display: inline-flex; align-items: center; justify-content: center; padding: 5px 15px; border-radius: 20px; font-size: 0.88em; font-weight: 600; color: #fff; min-width: 70px; box-shadow: 0 1px 4px rgba(0,0,0,0.15);  }
    .membership-card-actions { margin-top: 25px; padding-top: 20px; border-top: 1px dashed #eee; text-align: right; }
    .membership-card-actions .btn-mypage-primary,
    .membership-card-actions .btn-mypage-danger { margin-left: 10px 20px; border-radius: 6px; font-size: 0.95em; font-weight: 600; cursor: pointer; transition: background-color 0.2s, box-shadow 0.2s; border: none; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .membership-card-actions .btn-mypage-primary {
        background-color: var(--primary-color, #A095C4);
        color: white;
    }
    .membership-card-actions .btn-mypage-primary:hover {
        background-color: var(--primary-hover-color, #8A7EB0);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    .membership-card-actions .btn-mypage-danger {
        background-color: var(--danger-color, #dc3545);
        color: white;
    }
    .membership-card-actions .btn-mypage-danger:hover {
        background-color: var(--danger-hover-color, #c82333);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    .no-membership-history {
        text-align: center;
        padding: 60px 20px; /* 패딩 증가 */
        color: var(--text-light, #777);
        font-size: 1.1em;
        line-height: 1.5;
        background-color: var(--card-bg, #fff);
        border: 1px dashed var(--border-color, #e0e0e0); /* 점선 테두리 */
        border-radius: 10px;
        margin: 20px auto; /* 중앙 정렬 */
        max-width: 600px; /* 최대 너비 */
    }
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.7); /* 배경 오버레이 색상 진하게 */
        z-index: 2000;
        display: flex; /* 항상 flex로 두고 active에서 opacity 조정 */
        justify-content: center;
        align-items: center;
        opacity: 0; /* 초기 투명 */
        transition: opacity 0.3s ease-in-out;
    }
    .modal-overlay.active { /* JavaScript로 active 클래스 추가 시 보이도록 */
        opacity: 1;
    }
    .modal-content.membership-modal { /* artist_A_apt.html의 클래스명 사용 */
        background-color: var(--card-bg, #fff);
        padding: 30px; /* 패딩 증가 */
        border-radius: 12px; /* 더 둥근 모서리 */
        width: 95%; /* 더 넓은 모달 */
        max-width: 655px; /* 모달 최대 너비 증가 */
        box-shadow: 0 8px 25px rgba(0,0,0,0.3); /* 그림자 강화 */
        position: relative;
        max-height: 90vh;
        overflow-y: auto;
        transform: translateY(20px); /* 살짝 아래에서 올라오는 효과 */
        transition: transform 0.3s ease-in-out, opacity 0.3s ease-in-out;
    }
    .modal-overlay.active .modal-content.membership-modal {
        transform: translateY(0); /* 제자리로 이동 */
    }
    .modal-close-btn {
        position: absolute;
        top: 15px;
        right: 15px;
        font-size: 2em; /* 닫기 버튼 크기 증가 */
        color: var(--text-light, #888);
        background: none;
        border: none;
        cursor: pointer;
        line-height: 1;
    }
    .modal-close-btn:hover { color: #333; transition: transform 0.2s ease-in-out;}
    .modal-header { text-align: center; margin-bottom: 20px; border-bottom: 1px solid var(--border-light, #f0f0f0);}
    .modal-artist-logo { width: 80px; height: 80px; border-radius: 50%; margin: 0 auto 15px auto; border: 3px solid #eee; object-fit: cover;}
    .modal-header h2 { font-size: 1.8em; font-weight: 700; color: #333; margin-bottom: 8px; }
    .membership-duration { font-size: 1em; color: #666; }
    .membership-main-image img { width: 100%; border-radius: 8px; margin-bottom: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .modal-body h3 { font-size: 1.25em; margin-top: 25px; margin-bottom: 12px; color: #444; border-bottom: 1px solid #f0f0f0; padding-bottom: 8px; font-weight: 600; }
    .modal-benefits-list, .modal-notes-list { list-style: none; padding-left: 0; font-size: 1em; color: #555; line-height: 1.8;}
    .modal-benefits-list li:before {
        content: "\f00c"; /* FontAwesome 체크마크 아이콘 */
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        margin-right: 10px;
        color: var(--success-color, #28a745); /* 아이콘 색상 */
    }
    .modal-notes-list li:before {
        content: "\f05a"; /* FontAwesome 정보 아이콘 */
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        margin-right: 10px;
        color: var(--info-color, #17a2b8); /* 아이콘 색상 */
    }
    .modal-benefits-list li, .modal-notes-list li {
        margin-bottom: 10px;
    }

    .modal-footer {
        margin-top: 30px; /* 위 간격 증가 */
        text-align: center;
        border-top: 1px solid var(--border-light, #f0f0f0);
        padding-top: 25px;
    }
    .membership-price {
        font-size: 1.8em; /* 가격 폰트 크기 증가 */
        font-weight: bold;
        color: var(--primary-dark, #333);
        margin-bottom: 15px;
    }
    .vat-notice {
        font-size: 0.85em; /* 부가세 안내 폰트 크기 조정 */
        color: var(--text-light, #777);
        margin-bottom: 15px; /* 아래 간격 추가 */
    }
    .btn-modal-purchase {
        background-color: var(--primary-color, #A095C4)
        color: white;
        padding: 14px 40px; /* 버튼 패딩 증가 */
        border: none;
        border-radius: 8px; /* 버튼 모서리 둥글게 */
        font-size: 1.2em; /* 폰트 크기 증가 */
        font-weight: bold;
        cursor: pointer;
        transition: background-color 0.3s, transform 0.2s, box-shadow 0.2s;
        box-shadow: 0 4px 10px rgba(0,0,0,0.15); /* 버튼 그림자 */
    }
    .btn-modal-purchase:hover {
        background-color: var(--primary-hover-color, #8A7EB0);
        transform: translateY(-2px); /* 살짝 뜨는 효과 */
        box-shadow: 0 6px 15px rgba(0,0,0,0.2);
    }
	.status-badge.active {background-color: var(--success-color, #0d6efd); }
	.status-badge.expired {background-color: var(--warning-color, #ffc107); color: var(--warning-text, #333); }
	.status-badge.canceled {background-color: var(--danger-color, #dc3545); }
</style>
</head>
<body>
	<sec:authentication property="principal.memberVO" var="memberVO"/>
	<%@ include file ="../modules/headerPart.jsp" %>

	<form id="searchForm" action="${pageContext.request.contextPath }/mypage/memberships" method="get">
		<input type="hidden" id="currentPage" name="currentPage" value="${pagingVO.currentPage }" />
	</form>

	<section id="membership-content" class="mypage-section active-section">
	    <div class="mypage-section-header">
	        <h3>${pageTitle}</h3>
	    </div>

	    <div class="membership-list">
    		<c:choose>
		    		<c:when test="${not empty pagingVO.dataList }">
			    		<c:forEach var="mySubList" items="${pagingVO.dataList }" varStatus="status">
						    <div class="membership-card-item">
						        <div class="artist-profile">
						            <img src="${mySubList.profileImg }" alt="아티스트 그룹 프로필">
						            <span class="artist-name-subscription"><i class="fa-solid fa-building" style="margin-right: 8px; color: #0d6efd;"></i><c:out value="${mySubList.mbspNm}" /> APT</span>
						            <c:if test="${mySubList.mbspSubStatCode == 'MSSC001' }">
						            	<span class="artist-sub-date" style="margin-left: auto;"><i class="fa-solid fa-heart" style="margin-right: 5px; color: #fe019a;"></i> D-DAY +<c:out value="${mySubList.dDay}" />일</span>
						            </c:if>
						        </div>
						        <div class="membership-details">
						        	<p><strong>상태:</strong>
							        	<c:choose>
				      						<c:when test="${mySubList.mbspSubStatCode eq 'MSSC001' }">
				      							<span class="status-badge active">구독중</span>
				      						</c:when>
				      						<c:when test="${mySubList.mbspSubStatCode eq 'MSSC002' }">
				      							<span class="status-badge expired">만료</span>
				      						</c:when>
				      						<c:when test="${mySubList.mbspSubStatCode eq 'MSSC003' }">
				      							<span class="status-badge canceled">취소</span>
				      						</c:when>
				      						<c:otherwise>${mySubList.mbspSubStatCode }</c:otherwise>
				      					</c:choose>
						            </p>
						            <p><strong>가입일:</strong> <fmt:formatDate value="${mySubList.subStartDate}" pattern="yyyy년 MM월 dd일" /></p>
						            <p style="color: crimson;"><strong>만료일:</strong> <fmt:formatDate value="${mySubList.subEndDate}" pattern="yyyy년 MM월 dd일" /></p>
						            <p><strong>갱신일:</strong> <fmt:formatDate value="${mySubList.subModDate}" pattern="yyyy년 MM월 dd일" /></p>
						            <p><strong>결제 금액:</strong> ₩ <fmt:formatNumber value="${mySubList.mbspPrice }" pattern="##,###"></fmt:formatNumber>원</p>
						        </div>
						        <div class="membership-card-actions">
						        	<c:if test="${mySubList.mbspSubStatCode eq 'MSSC001' }">
					           			<button class="btn-mypage-danger btn-cancel-membership" data-artist-id="${mySubList.mbspNm }" data-mbsp-no="${mySubList.mbspNo }">해지</button>
					           		</c:if>
						        	<c:if test="${mySubList.mbspSubStatCode ne 'MSSC001' }">
							            <button class="btn-mypage-primary btn-extend-membership" data-mbsp-no="${mySubList.mbspNo }" data-mbsp-nm="${mySubList.mbspNm }"
							            	data-membership-goods-no="${mySubList.membershipGoodsNo }" data-mbsp-price="${mySubList.mbspPrice }" id="openMembershipModalBtn"
							            	data-bs-toggle="modal" data-bs-target="#membershipModalOverlay">연장</button>
						            </c:if>
						        </div>
						    </div>
				    	</c:forEach>
				    </c:when>
				    <c:otherwise>
					    <div class="no-membership-history" style="display: none; text-align: center; padding: 50px 0; color: var(--text-light);">
				            <p>구독 중인 APT 멤버십이 없습니다. 멤버십을 구매하여, 특별한 혜택을 누리세요!</p>
				        </div>
				    </c:otherwise>
		    </c:choose>
	    </div>
	</section>

	<div class="pagination-container" id="pagingArea">
		${pagingVO.pagingHTML}
	</div>

	<div class="modal fade" id="membershipModalOverlay" tabindex="-1" aria-labelledby="membershipModalLabel" aria-hidden="true">
        <div class="modal-dialog">
	        <div class="modal-content membership-modal">
	            <button class="modal-close-btn" id="closeMembershipModalBtn" aria-label="Close" data-bs-dismiss="modal">&times;</button>
	            <div class="modal-header">
	                <h2 id="modalMembershipNameHeader"></h2>
	                <p class="membership-duration">이용 기간: 결제일로부터 30일</p>
	            </div>
	            <div class="modal-body">
	                <div class="membership-main-image">
	                </div>
	                <h3>주요 혜택 안내</h3>
	                <ul class="modal-benefits-list">
	                    <li>️💎 멤버십 전용 콘텐츠 이용 가능 (일부 블러 처리된 콘텐츠 즉시 해제!)</li>
	                    <li>🗓️ APT 메인 상단에서 아티스트 구독일 D-Day 확인</li>
	                    <li>🎤 콘서트/팬미팅 선예매 및 특별 이벤트 참여 기회</li>
	                    <li>🎁 한정판 멤버십 키트 제공 (별도 구매 또는 등급에 따라)</li>
	                </ul>

	                <h3>이용 안내 및 유의사항</h3>
	                <ul class="modal-notes-list">
	                    <li>본 멤버십은 비용을 선지불하여 이용하는 유료 서비스입니다.</li>
	                    <li>멤버십은 아티스트(솔로, 그룹)별로 별도 운영되며, 본 멤버십은 [<strong id="modalMembershipNameBody"></strong>] 전용입니다.</li>
	                    <li>그룹 내 솔로 활동 멤버 발생 시, 해당 멤버의 커뮤니티는 별도 생성/운영될 수 있습니다.</li>
	                    <li>자세한 내용은 구매 페이지의 약관을 참고해주세요.</li>
	                </ul>
	            </div>
	            <div class="modal-footer">
	                <div class="membership-price">₩ <span id="modalMembershipPriceDisplay"></span> <span class="vat-notice">(VAT 포함)</span></div>
	                <button class="btn-modal-purchase" id="goToPurchasePageBtn">멤버십 구매하기</button>
	            </div>
	        </div>
        </div>
    </div>
</body>
<script type="text/javascript">
	document.addEventListener('DOMContentLoaded', () => {
	    const membershipListContainer = document.querySelector('.membership-list');
	    const membershipCards = membershipListContainer.querySelectorAll('.membership-card-item');

	    const membershipModalOverlay = document.getElementById('membershipModalOverlay');
	    const goToPurchasePageButton = document.getElementById('goToPurchasePageBtn');

	    // 모달 내부의 동적으로 채워질 요소들
	    const modalMembershipNameHeader = document.getElementById('modalMembershipNameHeader');
	    const modalMembershipNameBody = document.getElementById('modalMembershipNameBody');
	    const modalMembershipPriceDisplay = document.getElementById('modalMembershipPriceDisplay');

	    const csrfMeta = document.querySelector('meta[name="_csrf"]');
		const csrfHeaderMeta = document.querySelector('meta[name="_csrf_header"]');
		let csrfToken = csrfMeta.getAttribute('content');
		let csrfHeaderName = csrfHeaderMeta.getAttribute('content');

		// 페이징 처리
       	const pagingArea = $('#pagingArea');
       	const searchForm = $('#searchForm');
       	const currentPageInput = $('#currentPage');

	    if(pagingArea.length > 0) {
	        pagingArea.on('click', 'a', function(event) {
	            event.preventDefault();	// 기본 링크 이동 방지

	            const page = $(this).data('page'); // data-page 속성에서 클릭된 페이지 번호 가져옴

	            if(currentPageInput.length > 0) {
	            	currentPageInput.val(page);
	            	searchForm.submit();
	            }
	        });
	    }

	 	// 구독 해지 버튼 이벤트
	    document.querySelectorAll('.btn-cancel-membership').forEach(button => {
	        button.addEventListener('click', function() {
	            const artistId = this.dataset.artistId;	// mbspNm
	            const mbspNo = this.dataset.mbspNo;		// mbspNo
	            const membershipCard = this.closest('.membership-card-item');	// 뱃지 업데이트 위해 상위 카드 요소

	            Swal.fire({
					icon: 'warning',
					title: `\${artistId} APT 구독 해지`,
					html: `\${artistId} APT 구독을 정말 해지하시겠습니까?<br><br><p style="font-size:15px;">(해지 시 자동 갱신되지 않으며, 남은 기간 동안은 혜택이 유지됩니다.)</p>`,
					showCancelButton: true,
					confirmButtonText: '해지하기',
					confirmButtonColor: '#8a2be2',
					cancelButtonText: '취소',
					cancelButtonColor: '#6c757d'
				})
				.then((result) => {
					if(result.isConfirmed) {
// 						console.log("APT 구독 해지가 진행됩니다.");

						// 해지 버튼을 취소로 변경하고 비활성화
						button.textContent = '취소';
						button.disabled = true;
						button.classList.remove('btn-mypage-danger');
						button.style.backgroundColor = '#6c757d';
						button.style.cursor = 'not-allowed';

						// 상태 뱃지 취소로 업데이트
						const statusBadge = membershipCard.querySelector('.status-badge');
						if(statusBadge) {
							statusBadge.textContent = '취소';
							statusBadge.classList.remove('active', 'expired');
							statusBadge.classList.add('canceled');
						}

						// 연장 버튼 활성화
						const extendButton = membershipCard.querySelector('.btn-extend-membership');
						if(extendButton) {
							extendButton.style.display = 'inline-block';
							extendButton.disabled = false;
						}

						Swal.fire({
                            icon: 'success',
                            title: '해지 완료',
                            html: `${artistId} APT 멤버십을 해지하였습니다.<br><strong style="color:red">구독은 만료일까지 유지된 후</strong>, 취소됩니다.`,
                            confirmButtonColor: '#0d6efd'
                        });

					} else if(result.isDismissed) {
						console.log("구독 해지가 취소되었습니다.");
					}
				})
	        });
	    });

	 	// 모달이 열릴 때 데이터 설정
        membershipModalOverlay.addEventListener('show.bs.modal', function (event) {
            // 모달을 트리거한 버튼 (여기서는 "연장" 버튼)
            const button = event.relatedTarget;

            // 버튼의 data-* 속성에서 필요한 값 가져오기
            const mbspNo = button.getAttribute('data-mbsp-no');
            const mbspNm = button.getAttribute('data-mbsp-nm');
            const membershipGoodsNo = button.getAttribute('data-membership-goods-no');
            const mbspPrice = button.getAttribute('data-mbsp-price');

            // 모달의 제목과 본문 내용 업데이트
            modalMembershipNameHeader.textContent = `${mbspNm} OFFICIAL MEMBERSHIP`;
            modalMembershipNameBody.textContent = `${mbspNm}`;

            // 가격 포맷팅 및 업데이트
            if (mbspPrice) {
                const formattedPrice = new Intl.NumberFormat('ko-KR').format(parseInt(mbspPrice, 10));
                modalMembershipPriceDisplay.textContent = formattedPrice;
            } else {
                modalMembershipPriceDisplay.textContent = '정보 없음';
            }

            // 결제 버튼 클릭 시 사용할 데이터를 모달 DOM에 직접 저장 (hidden input 대신 data- 속성으로)
            // 이렇게 하면 goToPurchasePageBtn 클릭 리스너에서 직접 이 값들을 가져올 수 있습니다.
            membershipModalOverlay.setAttribute('data-current-mbsp-no', mbspNo);
            membershipModalOverlay.setAttribute('data-current-mbsp-nm', mbspNm);
            membershipModalOverlay.setAttribute('data-current-membership-goods-no', membershipGoodsNo);
            membershipModalOverlay.setAttribute('data-current-mbsp-price', mbspPrice);
        });


	 	// 결제 구현
		goToPurchasePageBtn.addEventListener('click', function() {

			 // 모달에 저장된 현재 멤버십 정보 가져오기
            const mbspNo = membershipModalOverlay.getAttribute('data-current-mbsp-no');
            const mbspNm = membershipModalOverlay.getAttribute('data-current-mbsp-nm');
            const membershipGoodsNo = membershipModalOverlay.getAttribute('data-current-membership-goods-no');
            const mbspPrice = membershipModalOverlay.getAttribute('data-current-mbsp-price'); // 문자열로 가져옴

            // 값이 유효한지 확인
            if (mbspNo && mbspNm && membershipGoodsNo && mbspPrice) {
                requestKakaoPaySubscription(membershipGoodsNo, mbspNo, mbspNm, mbspPrice);
            } else {
                console.error("결제에 필요한 멤버십 정보가 부족합니다.", {mbspNo, mbspNm, membershipGoodsNo, mbspPrice});
                Swal.fire({
                    icon: 'error',
                    title: '결제 오류',
                    text: '필요한 멤버십 정보를 가져올 수 없습니다. 다시 시도해주세요.',
                    confirmButtonColor: '#dc3545'
                });
            }
		});

		function requestKakaoPaySubscription(goodsNo, mbspNo, mbspNm, totalAmount) {
			// 1. 결제할 멤버십 상품 정보 정의
			const orderData = {
					orderItems: [
						{
							goodsNo: goodsNo,
							goodsOptNo: null,
							qty: 1,
							goodsNm: "DDTOWN 아티스트 멤버십",
						}
					],
					singleGoodsName: "DDTOWN 아티스트 멤버십",
					totalAmount: parseInt(totalAmount, 10),
					isFromCart: false,
					orderTypeCode: "OTC001", // 멤버십
					orderPayMethodNm: "카카오페이",
					orderRecipientNm: "${memberVO.peoName}",
		            orderRecipientPhone: "${memberVO.peoPhone}", // 유효하지 않은 전화번호
		            orderZipCode: "${memberVO.memZipCode}", // 더미 우편번호
		            orderAddress1: "${memberVO.memAddress1}", // 더미 주소
		            orderAddress2: "${memberVO.memAddress2}", // 더미 상세 주소
		            orderEmail: "${memberVO.peoEmail}", // 더미 이메일
		            orderMemo: `멤버십 상품 구매 : \${mbspNm}`
			};

// 			console.log("카카오페이 결제 준비 요청 데이터 : ", orderData);

			const headers = {
					'Content-Type':'application/json'
			};

			if (csrfToken && csrfHeaderName) { // null 체크 후 할당
			    headers[csrfHeaderName] = csrfToken;
			}

			// 2. 백엔드 API 호출
			fetch('/goods/order/pay/ready', {
				method: 'POST',
				headers: headers,
				body: JSON.stringify(orderData)
			})
			.then(response => {
				if(!response.ok) {
					return response.text().then(errorMessage => {
						console.error("백엔드 오류 응답: ", errorMessage);
					});
				}
				return response.json();
			})
			.then(data => {
				const nextRedirectUrl = data.next_redirect_pc_url;

				if(nextRedirectUrl) {
// 					console.log("카카오페이 결제 페이지로 리다이렉트: ", nextRedirectUrl);
					window.location.href = nextRedirectUrl;
				} else {
					console.log("카카오페이 리다이렉트 URL을 받지 못했습니다. 데이터: ", data);
				}
			})
			.catch(error => {
				console.log("카카오페이 결제 준비 중 예외 발생: ", error.message);
			})

			// 2. 백엔드 API 호출
			fetch('/goods/order/pay/ready', {
				method: 'POST',
				headers: headers,
				body: JSON.stringify(orderData)
			})
			.then(response => {
				if(!response.ok) {
					return response.text().then(errorMessage => {
						console.error("백엔드 오류 응답: ", errorMessage);
					});
				}
				return response.json();
			})
			.then(data => {
				const nextRedirectUrl = data.next_redirect_pc_url;

				if(nextRedirectUrl) {
// 					console.log("카카오페이 결제 페이지로 리다이렉트: ", nextRedirectUrl);
					window.location.href = nextRedirectUrl;
				} else {
					console.log("카카오페이 리다이렉트 URL을 받지 못했습니다. 데이터: ", data);
					Swal.fire({
	                    icon: 'error',
	                    title: '결제 오류',
	                    text: '결제 페이지로 이동할 수 없습니다. 다시 시도해주세요.',
	                    confirmButtonColor: '#dc3545'
	                });
				}
			})
			.catch(error => {
				console.log("카카오페이 결제 준비 중 예외 발생: ", error.message);
				Swal.fire({
	                icon: 'error',
	                title: '결제 요청 실패',
	                text: '결제 준비 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
	                confirmButtonColor: '#dc3545'
	            });
			})
		};
	});
</script>
</html>