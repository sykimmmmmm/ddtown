<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style type="text/css">
.main-headers {
    background: linear-gradient(135deg, #1a1a1a 0%, #2d1b69 100%);
    border-bottom: 1px solid #333;
    box-shadow: 0 4px 20px rgba(138, 43, 226, 0.3);
    position: sticky;
    top: 0;
    z-index: 1000;
    transition: all 0.3s ease;
}

.main-headers.scrolled {
    height: 120px;
    background: rgba(26, 26, 26, 0.95);
    backdrop-filter: blur(10px);
}

.header-nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 100%;
    margin: 0;
    padding: 15px 20px;
}

.home-link {
    font-size: 1.8em;
    font-weight: bold;
    color: #ffff;
    text-decoration: none;
    padding-left: 10px;
    display: flex;
    align-items: center;
    transition: all 0.3s ease;
}

.home-link:hover {
    color: #9d4edd;
    transform: translateY(-2px);
}

.header-logo {
    height: 2em;
    vertical-align: middle;
    padding: 8px;
    filter: drop-shadow(0 0 10px rgba(138, 43, 226, 0.5));
}

.header-right {
    display: flex;
    align-items: center;
    gap: 20px;
    list-style: none;
    padding: 0;
    margin: 0;
}

.icon-btn {
    background: rgba(138, 43, 226, 0.1);
    border: 2px solid transparent;
    cursor: pointer;
    padding: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
    color: #ffff;
    font-size: 1.4em;
    border-radius: 50%;
    transition: all 0.3s ease;
    position: relative;
    width: 50px;
    height: 50px;
}

.icon-btn:hover {
    background: rgba(138, 43, 226, 0.2);
    border-color: #8a2be2;
    color: #9d4edd;
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(138, 43, 226, 0.4);
}

/* 메인 내비게이션 스타일 */
.main-navigation {
    background: linear-gradient(90deg, rgba(138, 43, 226, 0.1) 0%, rgba(75, 0, 130, 0.1) 100%);
}

.main-navigation .menu-list {
    display: flex;
    justify-content: center;
    list-style: none;
    padding: 0;
    margin: 0;
    gap: 40px;
}

.main-navigation .menu-item {
    text-decoration: none;
    color: #e0e0e0;
    font-weight: 500;
    padding: 12px 25px;
    transition: all 0.3s ease;
    position: relative;
    display: block;
    font-size: 25px;
    border-radius: 25px;
}

.main-navigation .menu-item:hover {
    color: #8a2be2;
    background: rgba(138, 43, 226, 0.1);
    transform: translateY(-2px);
}

.main-navigation .menu-item::after {
    content: '';
    position: absolute;
    bottom: -5px;
    left: 50%;
    width: 0;
    height: 2px;
    background: linear-gradient(90deg, #8a2be2, #9d4edd);
    transition: all 0.3s ease;
    transform: translateX(-50%);
}

.main-navigation .menu-item:hover::after {
    width: 80%;
}

/* 서브메뉴 스타일 */
.main-navigation .submenu {
    display: none;
    position: absolute;
    background: linear-gradient(135deg, #1a1a1a 0%, #2d1b69 100%);
    box-shadow: 0 8px 25px rgba(0,0,0,0.3);
    min-width: 150px;
    z-index: 1001;
    list-style: none;
    padding: 15px 0;
    margin: 0;
    border-radius: 15px;
    top: 100%;
    left: 50%;
    transform: translateX(-50%);
    border: 1px solid rgba(138, 43, 226, 0.3);
}

.main-navigation li:hover > .submenu {
    display: block;
    animation: fadeInUp 0.3s ease;
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateX(-50%) translateY(10px);
    }
    to {
        opacity: 1;
        transform: translateX(-50%) translateY(0);
    }
}

.main-navigation .submenu li {
    padding: 0;
}

.main-navigation .submenu .menu-item {
    padding: 10px 20px;
    color: #e0e0e0;
    white-space: nowrap;
    border-radius: 0;
}

.main-navigation .submenu .menu-item:hover {
    background: rgba(138, 43, 226, 0.2);
    color: #8a2be2;
}

/* 언어 선택 드롭다운 */
.language-dropdown {
    position: relative;
    display: inline-block;
}

.language-btn {
    background: rgba(138, 43, 226, 0.1);
    border: 2px solid transparent;
    color: #8a2be2;
    padding: 8px 15px;
    border-radius: 20px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 14px;
}

.language-btn:hover {
    background: rgba(138, 43, 226, 0.2);
    border-color: #8a2be2;
}

.language-menu {
    display: none;
    position: absolute;
    top: 100%;
    right: 0;
    background: linear-gradient(135deg, #1a1a1a 0%, #2d1b69 100%);
    border: 1px solid rgba(138, 43, 226, 0.3);
    border-radius: 10px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.3);
    min-width: 120px;
    z-index: 1002;
    margin-top: 5px;
}

.language-dropdown:hover .language-menu {
    display: block;
}

.language-menu a {
    display: block;
    padding: 10px 15px;
    color: #e0e0e0;
    text-decoration: none;
    transition: all 0.3s ease;
}

.language-menu a:hover {
    background: rgba(138, 43, 226, 0.2);
    color: #8a2be2;
}

/* DM 플로팅 버튼 */
.dm-open-button {
    position: fixed;
    bottom: 30px;
    right: 25px;
    background: linear-gradient(135deg, #e0b0ff 0%, #c18bff 100%);
    color: white;
    padding: 18px;
    border-radius: 50%;
    box-shadow: 0 8px 25px rgba(193, 139, 255, 0.4);
    cursor: pointer;
    font-size: 1.3em;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 55px;
    height: 55px;
    z-index: 1040;
    transition: all 0.3s ease;
    border: none;
}

.dm-open-button:hover {
    transform: translateY(-8px) scale(1.1);
    box-shadow: 0 18px 35px rgba(193, 139, 255, 0.7); /* 호버 시 그림자 더 강화 */
    background: linear-gradient(135deg, #c18bff 0%, #e0b0ff 100%);
}

/* DM 모달 스타일 */
.dm-modal-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.7);
    z-index: 2000;
    justify-content: flex-end;
    align-items: center;
}

.modal-dialog.modal-xl.ms-auto {
    margin-right: 30px;
    max-width: 700px;
}

.dm-modal-content {
    background: linear-gradient(135deg, rgba(230, 179, 255, 0.7) 0%, rgba(200, 150, 255, 0.9) 100%) !important; /* 매우 밝고 투명한 연보라 그라데이션 */
    backdrop-filter: blur(40px); /* 블러 강도 더 높여 글래스모피즘 효과 강조 */
    padding: 0;
    border-radius: 25px; /* 모서리를 좀 더 둥글게 */
    box-shadow: 0 25px 70px rgba(0, 0, 0, 0.4); /* 그림자 강도 약간 조정 */
    width: 100%;
    max-width: 600px; /* 모달 너비 조정 (이전 답변과 통일) */
    height: 700px; /* 모달 높이 조정 (이전 답변과 통일) */
    max-height: 85vh; /* 화면 크기 고려 (이전 답변과 통일) */
    display: flex;
    flex-direction: column;
    position: relative;
    margin-right: 25px; /* 오른쪽 여백 조정 (이전 답변과 통일) */
    /* 테두리 색상을 연보라 투명도 있게 조정 */
    border: 1px solid rgba(230, 179, 255, 0.6);
    overflow: hidden;
}

.dm-modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0;
    border-bottom: 1px solid rgba(138, 43, 226, 0.3);
    padding: 20px 30px;
    background: rgba(138, 43, 226, 0.1);
    border-radius: 20px 20px 0 0;
}

.dm-modal-header h2 {
    margin: 0;
    font-size: 1.9em;
    color: #ffff;
    font-weight: bold;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.dm-modal-close-btn {
    background: none;
    border: none;
    font-size: 2.5em;
    color: #8a2be2;
    padding: 0;
    cursor: pointer;
    transition: all 0.3s ease;
}

.dm-modal-close-btn:hover {
    color: #9d4edd;
    transform: rotate(90deg);
}

.dm-modal-iframe {
    flex-grow: 1;
    border: none;
    width: 100%;
    height: 100%;
    background-color: #0f0f0f;
}

.dm-modal-content .dm-modal-back-btn {
    background: linear-gradient(135deg, #c18bff 0%, #e0b0ff 100%); /* DM 버튼과 유사한 연보라 그라데이션 */
    color: white;
    padding: 15px 25px;
    border: none;
    border-radius: 0 0 25px 25px; /* 모달의 둥근 모서리와 일치하도록 조정 */
    font-size: 1.2em;
    cursor: pointer;
    width: 100%;
    text-align: center;
    transition: all 0.3s ease;
    font-weight: bold;
    box-shadow: 0 -5px 15px rgba(0, 0, 0, 0.2);
}

.dm-modal-back-btn:hover {
    background: linear-gradient(135deg, #e0b0ff 0%, #c18bff 100%); /* 호버 시 그라데이션 방향 변경 */
    color: white; /* 호버 시에도 흰색 유지 */
    transform: translateY(-3px); /* 위로 살짝 올라오는 효과 */
    box-shadow: 0 -10px 25px rgba(0, 0, 0, 0.3);
}

/* 배지 스타일 */
.dm-unread-badge, .item-count-badge {
    position: absolute;
    top: -8px;
    right: -8px;
    background: linear-gradient(135deg, #ff4757 0%, #ff3742 100%);
    color: white;
    font-size: 0.7em;
    font-weight: bold;
    padding: 4px 8px;
    border-radius: 12px;
    min-width: 24px;
    text-align: center;
    line-height: 1;
    box-shadow: 0 2px 8px rgba(255, 71, 87, 0.4);
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
}

.badge-wrapper {
    position: relative;
    display: inline-block;
}

</style>

<header class="main-headers">
	<%@ include file ="headerPart.jsp" %>
    <nav class="header-nav">
        <div class="header-left">
		    <a href="${pageContext.request.contextPath}/community/main" class="home-link">
		        <img src="${pageContext.request.contextPath}/resources/img/1234.png" alt="DD 로고" class="header-logo">
		        DDTOWN SQUARE
		    </a>
		</div>
       <div class="header-right">
       		<li><%@ include file="../modules/translation.jsp" %></li>
            <sec:authorize access="isAuthenticated()">
            <li><%@ include file="../modules/alertDisplay.jsp" %></li>
            <li><a href="<c:url value='/mypage'/>" class="icon-btn active" title="마이페이지"><i class="fas fa-user"></i></a></li>
            </sec:authorize>
            <%-- 장바구니 아이콘 및 뱃지 --%>
            <li>
                <div class="badge-wrapper" style="position: relative; display: inline-block;"> <%-- 뱃지 위치 조정을 위해 badge-wrapper 스타일 추가 --%>
                    <a href="${pageContext.request.contextPath}/goods/cart/list" class="icon-btn" aria-label="장바구니">
                        <i class="fas fa-shopping-cart"></i>
                    </a>
                    <%-- 장바구니 개수 뱃지 (초기 로드는 ControllerAdvice가, 이후 업데이트는 JS가 담당) --%>
                    <span class="item-count-badge" id="headerCartItemCount"
                          <c:if test="${empty cartItemCount || cartItemCount eq 0}">style="display: none;"</c:if>>
                          ${empty cartItemCount ? '0' : cartItemCount}
                    </span>
                </div>
            </li>
            <li><a href="${pageContext.request.contextPath}/inquiry/main" class="icon-btn" title="고객센터"><i class="fas fa-headset"></i>‍</a></li>
            <sec:authorize access="isAuthenticated()">
                <form id="logoutForm" action="<c:url value='/logout'/>" method="post" style="display:inline;">
                    <sec:csrfInput/>
                    <button type="button" onclick="document.getElementById('logoutForm').submit(); return false;" class="auth-link icon-btn" title="로그아웃">
                    	<i class="fas fa-sign-out-alt"></i>
                    </button>
                </form>
            </sec:authorize>
            <sec:authorize access="isAnonymous()">
                 <a href="${pageContext.request.contextPath}/login" class="auth-link icon-btn"><i class="fa-solid fa-right-to-bracket"></i></a>
            </sec:authorize>
        </div>
    </nav>
    <nav class="main-navigation">
        <ul class="menu-list">
        	<li><a href="${pageContext.request.contextPath}/corporate/main" class="menu-item">COMPANY</a></li>
            <li><a href="${pageContext.request.contextPath}/goods/main" class="menu-item">SHOP</a></li>
        	<li><a href="${pageContext.request.contextPath}/community/main" class="menu-item">MAIN</a></li>
            <li><a href="${pageContext.request.contextPath}/concert/main" class="menu-item">CONCERT</a></li>
            <li>
                <a href="${pageContext.request.contextPath}/community/worldcup" class="menu-item">PREFERENCE</a>
                <ul class="submenu">
                    <li><a href="${pageContext.request.contextPath}/community/worldcup" class="menu-item">VOTE</a></li>
                </ul>
            </li>
        </ul>
    </nav>
    <script type="text/javascript" src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
</header>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<sec:authorize access="isAuthenticated()">
<div class="dm-open-button" id="dmOpenBtn" title="DM 열기" data-bs-toggle="modal" data-bs-target="#dmModalOverlay">
	<i class="fa-solid fa-paper-plane"></i>
	<span class="dm-unread-badge" id="dmUnreadCountBadge"></span>
</div>

<div class="modal fade" id="dmModalOverlay" tabindex="-1" aria-labelledby="dmModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-xl ms-auto">
		<div class="dm-modal-content modal-content">
	        <div class="dm-modal-header modal-header">
	            <h2 class="modal-title" id="dmModalLabel">DM</h2><button type="button" class="btn-close dm-modal-close-btn" data-bs-dismiss="modal" aria-label="Close"></button>
	        </div>
	        <iframe id="dmChannelListIframe" class="dm-modal-iframe" src="" frameborder="0"></iframe>
			<button type="button" class="btn dm-modal-back-btn" id="dmBackBtn" style="font-weight:bold;"><i class="fa-solid fa-list"></i> 목록가기</button>
	    </div>
    </div>
</div>
<script>
	document.addEventListener('DOMContentLoaded', function() {
	    const dmModalOverlay = document.getElementById('dmModalOverlay');
	    const dmChannelListIframe = document.getElementById('dmChannelListIframe');
	    const dmBackBtn = document.getElementById('dmBackBtn');
	    const dmUnreadCountBadge = document.getElementById('dmUnreadCountBadge');
	    const dmOpenBtn = document.getElementById('dmOpenBtn');

	    const dmChannelListUrl = '${pageContext.request.contextPath}/chat/dm/channel';
	    const totalUnreadCountUrl = '${pageContext.request.contextPath}/chat/dm/total-unread-count';

        const headerCartItemCountBadge = document.getElementById('headerCartItemCount');
        const cartCountApiUrl = '${pageContext.request.contextPath}/api/cart/count';


	    let isUserArtist = false;
        let isUserMember = false;        // ROLE_MEMBER (일반 멤버)
        let isUserMembership = false;    // ROLE_MEMBERSHIP (멤버십 회원)
        let isAuthenticated = false;

        <sec:authorize access="isAuthenticated()">
	        isAuthenticated = true;
	        <sec:authorize access="hasRole('ARTIST')">
	            isUserArtist = true;
	        </sec:authorize>
	        <sec:authorize access="hasRole('MEMBER')">
	            isUserMember = true;
	        </sec:authorize>
	        <sec:authorize access="hasRole('MEMBERSHIP')">
	            isUserMembership = true;
	        </sec:authorize>
	    </sec:authorize>

	    // --- 총 읽지 않은 메시지 수 업데이트 함수 ---
        function updateDmUnreadCount() {
            fetch(totalUnreadCountUrl)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP 오류! 상태: ' + response.status);
                    }
                    return response.json();
                })
                .then(count => {
                    if (count > 0) {
                        dmUnreadCountBadge.textContent = count;
                        dmUnreadCountBadge.style.display = 'block'; // 메시지가 있으면 표시
                    } else {
                        dmUnreadCountBadge.style.display = 'none'; // 없으면 숨김
                    }
                })
                .catch(error => {
                    console.error("총 읽지 않은 메시지 수를 가져오는 데 실패했습니다:", error);
                    dmUnreadCountBadge.style.display = 'none'; // 오류 발생 시 숨김
                });
        }
        // --- 총 읽지 않은 메시지 수 업데이트 함수 끝 ---

        // ⭐ 장바구니 개수 업데이트 함수 ⭐
        function updateCartItemCount() {
            if (!isAuthenticated) { // 로그인 안 했으면 뱃지 숨기고 종료
                if (headerCartItemCountBadge) {
                    headerCartItemCountBadge.style.display = 'none';
                    headerCartItemCountBadge.textContent = '0';
                }
                return;
            }

            fetch(cartCountApiUrl)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('장바구니 개수를 가져오는 데 실패했습니다: ' + response.status);
                    }
                    return response.json();
                })
                .then(count => {
                    if (headerCartItemCountBadge) {
                        if (count > 0) {
                            headerCartItemCountBadge.textContent = count;
                            headerCartItemCountBadge.style.display = 'block'; // 개수가 0보다 크면 표시
                        } else {
                            headerCartItemCountBadge.style.display = 'none'; // 0이거나 없으면 숨김
                            headerCartItemCountBadge.textContent = '0'; // 내용도 0으로 설정
                        }
                    }
                })
                .catch(error => {
                    console.error("장바구니 개수를 가져오는 중 오류 발생:", error);
                    if (headerCartItemCountBadge) {
                        headerCartItemCountBadge.style.display = 'none'; // 오류 시 숨김
                        headerCartItemCountBadge.textContent = '0';
                    }
                });
        }
        // ⭐ 장바구니 개수 업데이트 함수 끝 ⭐

        if(dmOpenBtn) {
        	dmOpenBtn.removeAttribute('data-bs-toggle');
        	dmOpenBtn.removeAttribute('data-bs-target');

        	dmOpenBtn.addEventListener('click', function() {
        		if(isAuthenticated) {
        			if(isUserArtist || isUserMembership) {
        				window.openDmModal();
        			} else if(isUserMember) {
        				Swal.fire({
        					icon: 'warning',
        					title: 'DM 접근 불가',
        					html: 'DM은 <strong style="font-size:1.1em; color: #8a2be2" >멤버십 회원</strong>만 이용 가능합니다.<br>멤버십에 가입하고 아티스트와 소통해보세요!',
        					confirmButtonTex: '확인',
        					confirmButtonColor: '#8a2be2'
        				});
        			} else {
        				// 예상치 못한 로그인된 역할 (예: 관리자 등)
                        Swal.fire({
                            icon: 'warning',
                            title: 'DM 접근 불가',
                            text: '이용 권한이 없습니다.',
                            confirmButtonText: '확인',
                            confirmButtonColor: '#8a2be2'
                        });
        			}
        		} else {	// 로그인하지 않은 경우
        			Swal.fire({
                        icon: 'info', // 정보성 아이콘으로 변경
                        title: '로그인 필요',
                        text: 'DM 기능을 이용하려면 로그인해야 합니다.',
                        showCancelButton: true,
                        confirmButtonText: '로그인',
                        cancelButtonText: '취소',
                        confirmButtonColor: '#8a2be2',
                        cancelButtonColor: '#cccccc'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = '${pageContext.request.contextPath}/login';
                        }
                    });
        		}
        	});
        }

	    if (dmModalOverlay) {
	    	dmModalOverlay.addEventListener('shown.bs.modal', function() {

	    		updateDmUnreadCount();
	        });

	    	dmModalOverlay.addEventListener('hidden.bs.modal', function() {
	    		dmChannelListIframe.src = "";
	    		updateDmUnreadCount();
	    	});
	    }

	    // 뒤로가기 버튼 클릭 이벤트
	    if(dmBackBtn) {
	    	dmBackBtn.addEventListener('click', function() {
	    		dmChannelListIframe.src = dmChannelListUrl;
	    		updateDmUnreadCount();
	    	});
	    }
	 	// 페이지 로드 시 최초 1회 읽지 않은 메시지 수 업데이트
	    updateDmUnreadCount();
	});
</script>

<!-- 전역 openDmModal 함수 추가 -->
<script>
// 전역 openDmModal 함수 정의
window.openDmModal = function(channelId) {
//     console.log("openDmModal 호출됨, channelId:", channelId);

    // 사용자 권한 확인
    let isUserArtist = false;
    let isUserMember = false;
    let isUserMembership = false;
    let isAuthenticated = false;

    <sec:authorize access="isAuthenticated()">
        isAuthenticated = true;
        <sec:authorize access="hasRole('ARTIST')">
            isUserArtist = true;
        </sec:authorize>
        <sec:authorize access="hasRole('MEMBER')">
            isUserMember = true;
        </sec:authorize>
        <sec:authorize access="hasRole('MEMBERSHIP')">
            isUserMembership = true;
        </sec:authorize>
    </sec:authorize>

    if (!isAuthenticated) {
        Swal.fire({
            icon: 'info',
            title: '로그인 필요',
            text: 'DM 기능을 이용하려면 로그인해야 합니다.',
            showCancelButton: true,
            confirmButtonText: '로그인',
            cancelButtonText: '취소',
            confirmButtonColor: '#8a2be2',
            cancelButtonColor: '#cccccc'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '${pageContext.request.contextPath}/login';
            }
        });
        return;
    }

    if (!isUserArtist && !isUserMembership) {
        Swal.fire({
            icon: 'warning',
            title: 'DM 접근 불가',
            html: 'DM은 <strong style="font-size:1.1em; color: #8a2be2">멤버십 회원</strong>만 이용 가능합니다.<br>멤버십에 가입하고 아티스트와 소통해보세요!',
            confirmButtonText: '확인',
            confirmButtonColor: '#8a2be2'
        });
        return;
    }

    // DM 모달 열기
    const dmModalOverlay = document.getElementById('dmModalOverlay');
    const dmChannelListIframe = document.getElementById('dmChannelListIframe');
    const contextPath = '${pageContext.request.contextPath}';

    if (dmModalOverlay && dmChannelListIframe) {
        const dmModal = new bootstrap.Modal(dmModalOverlay);
        dmModal.show();

        // 채널ID가 있으면 해당 채팅방, 없으면 목록
        if (channelId && channelId !== 'undefined' && channelId !== '') {
            dmChannelListIframe.src = contextPath + '/chat/dm/channel/enter/' + channelId;
        } else {
            dmChannelListIframe.src = contextPath + '/chat/dm/channel';
        }
    } else {
        // 폴백: 전체 채팅방 목록으로 이동
        if (channelId && channelId !== 'undefined' && channelId !== '') {
            window.location.href = contextPath + '/chat/dm/channel/enter/' + channelId;
        } else {
            window.location.href = contextPath + '/chat/dm/channel';
        }
    }
};

// AJAX로 채팅방 내용을 로드하는 함수
function loadChatRoomContent(channelNo) {
    const dmChannelListIframe = document.getElementById('dmChannelListIframe');

    // 로딩 표시
    dmChannelListIframe.style.opacity = '0.5';

    // AJAX로 채팅방 내용 가져오기
    $.ajax({
        url: '${pageContext.request.contextPath}/chat/dm/channel/enter/' + channelNo,
        type: 'GET',
        success: function(response) {
            // iframe 대신 모달 내용을 직접 업데이트
            const modalBody = dmChannelListIframe.parentElement;
            modalBody.innerHTML = response;
            modalBody.style.opacity = '1';

            // 채팅방 관련 스크립트 실행
            initializeChatRoom(channelNo);
        },
        error: function(xhr, status, error) {
            console.error("채팅방 로드 실패:", error);
            // 에러 시 채팅 목록으로 이동
            dmChannelListIframe.src = '${pageContext.request.contextPath}/chat/dm/channel';
            dmChannelListIframe.style.opacity = '1';
        }
    });
}

// 채팅방 초기화 함수
function initializeChatRoom(channelNo) {
    // WebSocket 연결 및 채팅 기능 초기화
//     console.log("채팅방 초기화:", channelNo);
    // 여기에 채팅방 관련 스크립트 추가
}
</script>
</sec:authorize>

