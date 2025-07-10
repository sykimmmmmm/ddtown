<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<sec:authentication property="principal.username" var="currentUsername"/>
<c:set var="isUserLoggedIn" value="${not empty currentUsername && currentUsername ne 'anonymousUser'}"/>

<style>
	/* alertDisplay.jsp의 <style> 태그 내용 또는 공통 CSS 파일에 추가 */

	/* 우측 상단 유틸리티 메뉴 정렬 */
	.utility-nav {
	    display: flex; /* 자식 요소들을 가로로 정렬 */
	    align-items: center; /* 세로 중앙 정렬 */
	}
	.utility-nav > ul {
	    display: flex; /* li 요소들을 가로로 정렬 */
	    align-items: center; /* 세로 중앙 정렬 */
	    list-style: none; /* 리스트 기본 스타일 제거 */
	    margin: 0;
	    padding: 0;
	}
	.utility-nav > ul > li {
	    margin-left: 15px; /* 각 메뉴 항목 사이의 간격 */
	}
	.utility-nav a.icon-btn {
	    font-size: 1.5rem; /* 아이콘 크기를 키움 (기존 1.5em과 유사) */
	    color: #4f5962; /* 아이콘 색상 (AdminLTE 테마와 유사하게) */
	    text-decoration: none;
	}
	.utility-nav a.auth-link {
	    font-size: 1rem;
	    color: #4f5962;
	    text-decoration: none;
	}
	.utility-nav a:hover {
	    color: #007bff; /* 마우스 오버 시 색상 변경 */
	}


	/* 알림 아이콘 컨테이너 스타일 */
	.alert-icon-container {
	    position: relative;
	    display: flex; /* 내부 요소 정렬을 위해 flex로 설정 */
	    align-items: center;
	    justify-content: center;
	}

	/* 알림 종 아이콘 스타일 */
	.alert-bell {
	    cursor: pointer;
	    line-height: 1; /* 아이콘의 수직 정렬을 위해 추가 */
	    cursor: pointer;
	    padding: 5px;
	    display: flex; /* 내부 요소 (이모지) 정렬을 위해 flex 사용 */
	    align-items: center;
	    justify-content: center;
	    text-decoration: none; /* 링크 버튼에 밑줄 제거 */
	}

	/* 알림 배지(숫자) 스타일 - 아이콘을 가리지 않도록 위치 조정 */
	.alert-badge {
	    position: absolute;
	    top: -8px;
	    right: -8px;
	    background: linear-gradient(135deg, #ff4757 0%, #ff3742 100%);
	    color: white;
	    font-size: 0.75em;
	    font-weight: bold;
	    padding: 4px 8px;
	    border-radius: 12px;
	    min-width: 24px;
	    text-align: center;
	    line-height: 1;
	    box-shadow: 0 2px 8px rgba(255, 71, 87, 0.4);
	    animation: pulse 2s infinite;
	}

	/* 알림 드롭다운 메뉴 스타일 */
	.alert-dropdown {
	    display: none;
	    background: rgba(255,255,255,0.25);
	    backdrop-filter: blur(18px);
	    border-radius: 18px;
	    box-shadow: 0 8px 32px rgba(138,43,226,0.18);
	    border: 1.5px solid rgba(138,43,226,0.15);
	    width: 420px;
	    max-height: 500px;
	    overflow-y: auto;
	    z-index: 1000;
	    right: 0;
	    top: calc(100% + 12px);
	    position: absolute;
	    padding-bottom: 10px;
	}

	.alert-dropdown-header {
	    padding: 18px 20px 10px 20px;
	    font-weight: bold;
	    border-bottom: 1px solid #eee;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    background: rgba(255,255,255,0.18);
	    border-radius: 18px 18px 0 0;
	}
	.alert-dropdown-header span {
	    font-size : 1.1em;
	}
	.alert-dropdown-header .header-actions a {
	    font-size: 1.1em;
	    color: #333;
	    font-weight: 600;
	    margin-left: 18px;
	    text-decoration: none;
	    transition: color 0.2s;
	}
	.alert-dropdown-header .header-actions a:hover {
	    color: #1fe58b;
	    text-decoration: underline;
	}
	.alert-item {
	    background: rgba(255,255,255,0.95);
	    border-radius: 12px;
	    margin: 12px 16px 0 16px;
	    box-shadow: 0 2px 8px rgba(138,43,226,0.08);
	    padding: 14px 18px 10px 18px;
	    transition: background 0.2s, box-shadow 0.2s;
	    cursor: pointer;
	    border-left: 6px solid transparent;
	    position: relative;
	}
	.alert-item.unread { border-left: 6px solid #8a2be2; background: rgba(255,255,255,0.98); }
	.alert-item.read   { opacity: 0.7; }
	.alert-item:hover  { background: rgba(240,240,240,0.95); box-shadow: 0 4px 16px #8a2be233; }
	.alert-item .message {
	    font-size: 1.05em;
	    color: #2d1b69;
	    font-weight: 500;
	    margin-bottom: 4px;
	    display: block;
	}
	.alert-item .timestamp {
	    font-size: 0.85em;
	    color: #8a2be2;
	    font-weight: 400;
	}
	.no-alerts {
	    padding: 30px 0;
	    text-align: center;
	    color: #888;
	    font-size: 1.1em;
	}
	.alert-bell {
	    cursor: pointer;
	    line-height: 1; /* 아이콘의 수직 정렬을 위해 추가 */
	    cursor: pointer;
	    padding: 5px;
	    display: flex; /* 내부 요소 (이모지) 정렬을 위해 flex 사용 */
	    align-items: center;
	    justify-content: center;
	    text-decoration: none;
	}
	.alert-bell:hover { color: #9d4edd; background: rgba(138,43,226,0.12); }
	.alert-badge {
	    position: absolute;
	    top: -8px;
	    right: -8px;
	    background: linear-gradient(135deg, #ff4757 0%, #ff3742 100%);
	    color: white;
	    font-size: 0.75em;
	    font-weight: bold;
	    padding: 4px 8px;
	    border-radius: 12px;
	    min-width: 24px;
	    text-align: center;
	    line-height: 1;
	    box-shadow: 0 2px 8px rgba(255, 71, 87, 0.4);
	    animation: pulse 2s infinite;
	}
	::-webkit-scrollbar {
	    width: 8px;
	    background: rgba(138,43,226,0.08);
	    border-radius: 8px;
	}
	::-webkit-scrollbar-thumb {
	    background: linear-gradient(135deg,#8a2be2,#9d4edd);
	    border-radius: 8px;
	}
</style>

<!--로그인 했을때만 알림 아이콘 영역 표시-->
<c:if test="${isUserLoggedIn}">
    <div class="alert-icon-container">
        <span class="alert-bell icon-btn" id="alertBellIcon"><i class="fas fa-bell"></i></span>
        <span class="alert-badge" id="alertBadge">0</span>	<!--안읽은 알림 개수 표시-->
        <div class="alert-dropdown" id="alertDropdownList">
            <div class="alert-dropdown-header">
                <span>알림</span>
                <div class="header-actions">
                	<a href="#" id="markAllAsReadLink">모두 읽음</a>
	                <a href="<c:url value='/mypage/alerts'/>" id="viewAllAlertsLink">알림 내역 이동</a>
                </div>
            </div>
            <div id="alertItemsContainer">
                <div class="no-alerts">새로운 알림이 없습니다.</div>		<!--초기값-->
            </div>
        </div>
    </div>
</c:if>


<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script type="text/javascript">
$(document).ready(function() {		// 페이지 HTML 코드 모두 실행 후 스크립트 실행
    const csrfToken = $("meta[name='_csrf']").attr("content");
    const csrfHeader = $("meta[name='_csrf_header']").attr("content");

    const alertBellIcon = $('#alertBellIcon');
    const alertBadge = $('#alertBadge');
    const alertDropdownList = $('#alertDropdownList');
    const alertItemsContainer = $('#alertItemsContainer');
    const markAllAsReadLink = $('#markAllAsReadLink');

    const currentUsername = "<c:out value='${currentUsername}'/>";
    const isUserLoggedIn = <c:out value='${isUserLoggedIn}' default='false'/>;

    if (!isUserLoggedIn || !currentUsername) {
//         console.log("사용자가 로그인하지 않았거나 사용자 ID를 가져올 수 없어 알림 기능을 초기화하지 않습니다.");
        return;
    }

    let stompClient = null;		// STOMP 클라리언트 객체 저장용 변수
    let unreadAlertCount = 0;		// 안읽은 알림 개수 변수

    function loadInitialAlerts() { 		// 페이지 로드 시 최근 알림목록, 안읽은 알림 개수 가져오기
        $.ajax({
            url: '<c:url value="/mypage/alerts/latestAndUnreadCnt"/>',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
//                 console.log("loadInitialAlerts 응답:", response); // 디버깅용 로그 추가
                if (response.success) {
                    unreadAlertCount = response.unreadCount || 0;
                    updateAlertBadge(unreadAlertCount);

                    if (response.latestAlerts && response.latestAlerts.length > 0) {
//                         console.log("최신 알림 개수:", response.latestAlerts.length); // 디버깅용 로그 추가
                        alertItemsContainer.empty();		// no-alerts 알림 메시지 제거

                        // 중복 제거: alertNo 기준으로 중복 알림 제거
                        const uniqueAlerts = [];
                        const alertNoSet = new Set();
                        response.latestAlerts.forEach(function(alertData) {
                            if (!alertNoSet.has(alertData.alertNo)) {
                                uniqueAlerts.push(alertData);
                                alertNoSet.add(alertData.alertNo);
                            }
                        });

//                         console.log("중복 제거 후 알림 개수:", uniqueAlerts.length); // 디버깅용 로그 추가
                        uniqueAlerts.forEach(function(alertData) {
//                             console.log("개별 알림 데이터:", alertData); // 디버깅용 로그 추가
                            prependAlertToList(alertData); 		// 각 알림 목록에 추가
                        });
                    } else {
//                         console.log("최신 알림이 없습니다."); // 디버깅용 로그 추가
                        alertItemsContainer.html('<div class="no-alerts">새로운 알림이 없습니다.</div>');
                    }
                } else {
                    Swal.fire({
                    	icon: 'error',
                    	title: '알림 로드 실패',
                    	text: response.message || '초기 알림을 불러오는데 실패했습니다..'
                    });
                }
            },
            error: function(xhr) {
                console.error("초기 알림 로드 중 오류 발생:", xhr.responseText);
            }
        });
    }

    function updateAlertBadge(count) {		// 안읽은 알림 개수 받아서 UI 업데이트
        unreadAlertCount = count;
        if (unreadAlertCount > 0) {
            alertBadge.text(unreadAlertCount > 99 ? "99+" : unreadAlertCount).show();
        } else {
            alertBadge.hide();
        }
    }

    function prependAlertToList(alertData) { // 단일 알림 데이터 -> HTML 요소 추가 후 목록 상단에 추가, alertData - 서버로부터 반환받은 알림 객체 (AlertVO)
//         console.log("prependAlertToList 호출됨:", alertData); // 디버깅용 로그 추가

        // 중복 알림 체크: 이미 같은 alertNo가 있는지 확인
        const existingAlert = alertItemsContainer.find(`[data-alert-no="${alertData.alertNo}"]`);
        if (existingAlert.length > 0) {
//             console.log("중복 알림 감지, 추가하지 않음:", alertData.alertNo);
            return;
        }

        if (alertItemsContainer.find('.no-alerts').length > 0) {
            alertItemsContainer.empty();
        }

        // WebSocket으로 오는 새 알림은 기본값 안읽음 'N' , alertData(AlerVO)에서 readYn값 꺼냄
        const isUnread = alertData.alertReadYn === 'N' || alertData.alertReadYn === false || typeof alertData.alertReadYn === 'undefined';

        // alertContent가 null이나 undefined인 경우 기본값 설정
        let alertContent = '새로운 알림';
        if (alertData.alertContent && alertData.alertContent.trim() !== '') {
            alertContent = alertData.alertContent;
        }
//         console.log("알림 내용:", alertContent); // 디버깅용 로그 추가

        const itemHtml = `
            <div class="alert-item \${isUnread ? 'unread' : 'read'}" data-alert-no="\${alertData.alertNo}" data-alert-url="\${alertData.alertUrl || ''}">
                <div class="alert-content">
                    <span class="message">\${alertContent.replaceAll("\n", "<br>")}</span>
                    <span class="timestamp">\${formatAlertTimestamp(alertData.alertCreateDate)}</span>
                </div>
            </div>
        `;
        const newItem = $(itemHtml);

        newItem.on('click', function(){		// 알림 아이템 클릭시 읽음처리 후 URL 이동처리
        	markAlertAsRead(alertData.alertNo, newItem);
        });
        alertItemsContainer.append(newItem);
    }

    function formatAlertTimestamp(timestamp) { 		// TIMESTAMP 이용해서 방금전, N분전 동작, timestamp - Date 객체로 변환
        if (!timestamp) return "";
        const date = new Date(timestamp);
        const now = new Date();
        const diffMs = now - date;
        const diffSeconds = Math.round(diffMs / 1000);
        const diffMinutes = Math.round(diffSeconds / 60);
        const diffHours = Math.round(diffMinutes / 60);
        const diffDays = Math.round(diffHours / 24);

        if (diffSeconds < 60) return "방금 전";
        if (diffMinutes < 60) return `\${diffMinutes}분 전`;
        if (diffHours < 24) return `\${diffHours}시간 전`;
        if (diffDays < 7) return `\${diffDays}일 전`;
        return `\${date.getFullYear()}-\${String(date.getMonth() + 1).padStart(2, '0')}-\${String(date.getDate()).padStart(2, '0')}`;
    }

    function markAlertAsRead(alertNo, itemElement) { 		// 특정 알림 읽음처리 (개별) , alertNo - 읽음처리할 알림번호, itemElement - 화면에서 상태 변경할 알림 요소
        if (!itemElement) return;		// 이미 읽은건 요청 안보냄

        const alertUrl = itemElement.data('alert-url');
//         console.log("알림 URL:", alertUrl);

        $.ajax({
            url: '<c:url value="/mypage/alerts/readAndDelete"/>',
            type: 'POST',
            data: { alertNo: alertNo },
            headers: csrfHeader && csrfToken ? { [csrfHeader]: csrfToken } : {},
            success: function(response) {
                if (response.success) {
                    itemElement.removeClass('unread').addClass('read');
                    unreadAlertCount = Math.max(0, unreadAlertCount - 1);
                    updateAlertBadge(unreadAlertCount); // 개별 알림 읽음처리 이후에 안읽은 개수 1 감소

                    itemElement.remove();

                    // 2. URL 이동/모달 오픈
                    if (alertUrl && alertUrl.trim() !== '') {
                        if (alertUrl.includes('/chat/dm/channel/enter/')) {
                            window.location.href = alertUrl;
                        } else if (alertUrl.startsWith('javascript:')) {
                            // openDmModal 등 JS 함수 호출
                            const jsCode = alertUrl.substring(11);
                            if (jsCode.includes('openDmModal')) {
                                if (typeof window.openDmModal === 'function') {
                                    const match = jsCode.match(/openDmModal\(['"]?(\d+)['"]?\)/);
                                    if (match && match[1]) {
                                        window.openDmModal(match[1]);
                                    } else {
                                        window.openDmModal();
                                    }
                                } else {
                                    // window.openDmModal이 없으면 부모 window에 시도
                                    if (window.parent && typeof window.parent.openDmModal === 'function') {
                                        const match = jsCode.match(/openDmModal\(['"]?(\d+)['"]?\)/);
                                        if (match && match[1]) {
                                            window.parent.openDmModal(match[1]);
                                        } else {
                                            window.parent.openDmModal();
                                        }
                                    } else {
                                        window.location.href = '<c:url value="/chat/dm/channel"/>';
                                    }
                                }
                            } else {
                                eval(jsCode);
                            }
                        } else if(alertUrl !== '#') {
                            // contextPath가 빠진 상대경로라면 contextPath 붙이기
                            let finalUrl = alertUrl;
                            if (!alertUrl.startsWith('http') && !alertUrl.startsWith('/')) {
                                finalUrl = '<c:url value="/"/>' + alertUrl;
                            }
                            window.location.href = finalUrl;
                        }
                    }
                } else {
                    Swal.fire({
                        icon: 'warning',
                        title: '알림 처리 실패',
                        text: response.message || '알림 읽음 처리 중 문제가 발생했습니다.'
                    });
                }
            },
            error: function(xhr) {
                console.error("알림 읽음 처리 중 오류:", xhr.responseText);
            }
        });
    }
    function markAllAlertsAsRead(){
    	if(unreadAlertCount === 0){
    		Swal.fire({
                icon: 'info',
                title: '알림 없음',
                text: '읽지 않은 알림이 없습니다.',
                showConfirmButton: false
    		});
    		return;
    	}

    	Swal.fire({
            title: '모든 알림 읽음 처리',
            text: '모든 알림을 읽음처리 후 삭제하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: '확인',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '<c:url value="/mypage/alerts/readAll"/>',
                    type: 'POST',
                    headers: csrfHeader && csrfToken ? { [csrfHeader]: csrfToken} : {},
                    success: function(response){
                        if(response.success){
                            // 모든 알림 아이템을 읽음 처리하고 UI에서 제거
                            alertItemsContainer.find('.alert-item').each(function() {
                                $(this).removeClass('unread').addClass('read');
                            });

                            // 모든 알림 제거 후 "새로운 알림이 없습니다" 메시지 표시
                            alertItemsContainer.empty();
                            alertItemsContainer.html('<div class="no-alerts">새로운 알림이 없습니다.</div>');
                            updateAlertBadge(0);

                            Swal.fire({
                                icon: 'success',
                                title: '완료!',
                                text: '모든 알림이 성공적으로 읽음 처리 후 삭제되었습니다.',
                                showConfirmButton: false, // 자동 닫힘
                                timer: 1500 // 1.5초 후 자동 닫힘
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: '처리 실패',
                                text: response.message || '모든 알림 읽음 처리 중 문제가 발생했습니다.',
                            });
                             console.log("모든 알림 읽음 처리 실패!!", response.message);
                        }
                    },
                    error: function(xhr){
                        Swal.fire({
                            icon: 'error',
                            title: '오류 발생',
                            text: '모든 알림 읽음 처리 중 네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
                        });
                        console.log("모든 알림 읽음 처리 중 오류 발생...", xhr.responseText);
                    }
                });
            }
        });
    }

    function connectWebSocket() {		// WebSocket 서버 연결
        const socket = new SockJS('<c:url value="/ws-stomp"/>');		// WebSocketConfig 엔드포인트
        stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
//             console.log('STOMP Connected: ' + frame);
            stompClient.subscribe('/user/' + currentUsername + '/queue/alerts', function (alertMessage) { 	// /user/{username}/queue/alerts 경로로 자신에게 오는 알림만 받음
                try {
                    const newAlert = JSON.parse(alertMessage.body);
//                     console.log("새 알림 수신:", newAlert);
                    prependAlertToList(newAlert);
                    updateAlertBadge(++unreadAlertCount);
                    if (Notification && Notification.permission === "granted") { // 브라우저 알림 API 사용 시 알림 객체 확인
                        new Notification("새 알림 from DDTOWN", { body: newAlert.alertContent });
                    }
                } catch (e) {
                    console.error("알림 메시지 파싱 오류:", e, alertMessage.body);
                }
            });
        }, function(error) {
            console.error('STOMP 연결 오류: ' + error);
            setTimeout(connectWebSocket, 5000);		// 에러 시 5초후 재연결 시도
        });
    }

    alertBellIcon.on('click', function(event) {		// 알림 아이콘 클릭하면 드롭다운 메뉴 노출용 핸들러
        event.stopPropagation();		// 이벤트 버블링 방지 (event.preventDefault())
        alertDropdownList.toggle();
    });

    $(document).on('click', function(event) {		// 드롭다운 외부 영역 클릭하면 메뉴ㅗ 숨기기
        if (!alertBellIcon.is(event.target) && alertDropdownList.has(event.target).length === 0) {
            alertDropdownList.hide();
        }
    });


    markAllAsReadLink.on('click', function(event){		// 모든 알림 읽음처리 이벤트리스너
    	event.preventDefault();
    	markAllAlertsAsRead();
    });

    function requestBrowserNotificationPermission() { 	// 브라우저에서 알림 권한 요청
        if (typeof Notification !== 'undefined' && Notification.permission !== "granted" && Notification.permission !== "denied") {
            Notification.requestPermission().then(function (permission) {
                if (permission === "granted") {
                    console.log("브라우저 알림 권한 허용됨");
                } else {
                    console.log("브라우저 알림 권한 거부됨");
                }
            });
        }
    }

    function pollUnreadAlertCount() {
        $.ajax({
            url: '<c:url value="/mypage/alerts/latestAndUnreadCnt"/>',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // 뱃지 업데이트
                    if (typeof response.unreadCount !== 'undefined' && unreadAlertCount !== response.unreadCount) {
                        unreadAlertCount = response.unreadCount;
                        updateAlertBadge(unreadAlertCount);
                    }
                    
                    // 알림 목록 업데이트 (새로운 알림이 있는 경우)
                    if (response.latestAlerts) {
                        updateAlertList(response.latestAlerts);
                    }
                }
            },
            error: function(xhr) {
                // 네트워크 오류 등은 무시
            }
        });
    }
    
    function updateAlertList(newAlerts) {
        alertItemsContainer.empty(); // 기존 알림 모두 삭제

        if (newAlerts.length === 0) {
            alertItemsContainer.html('<div class="no-alerts">새로운 알림이 없습니다.</div>');
            return;
        }

        newAlerts.forEach(function(alertData) {
            prependAlertToList(alertData);
        });
    }

    if (isUserLoggedIn) {		// 페이지 로드 시 로그인 상태면 알림기능 초기화 실행
        requestBrowserNotificationPermission();
        loadInitialAlerts();
        connectWebSocket();

        // 3초마다 안읽은 알림 개수 폴링
        setInterval(pollUnreadAlertCount, 3000);
    }
});
</script>