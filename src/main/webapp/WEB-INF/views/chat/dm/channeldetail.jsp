<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${artistComuNicknm} - 공식 팬클럽 방</title>
    <meta name="_csrf" content="${_csrf.token }">
    <meta name="_csrf_header" content="${_csrf.headerName }">
    <style>
    	html, body {
		    height: 100%; /* HTML, BODY가 부모 요소 (iframe)의 100%를 차지하도록 */
		    margin: 0;
		    padding: 0;
		    overflow: hidden; /* body 자체에는 스크롤바가 생기지 않도록. chatDisplay에서 스크롤 관리 */
		}
        body { font-family: 'Noto Sans KR', sans-serif; min-height: 100%; padding: 15px; margin: 0; display: flex; flex-direction: column; box-sizing: border-box; background-color: #e9eef2;}
        #chatDisplay {
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            height: 80vh;
            overflow-x: hidden;
            overflow-y: auto;
            padding: 15px;
            margin-bottom: 0;
            background-color: #f7f9fb;
            display: flex;
            flex-direction: column;
           	flex-grow: 1;
           	min-height: 200px;
           	overflow-y: auto;
        }
         #chatDisplay::-webkit-scrollbar-thumb {
            background-color: #c9d7e3; /* 스크롤바 색상 */
            border-radius: 10px;
        }
        #chatDisplay::-webkit-scrollbar-track {
            background-color: #f1f1f1; /* 스크롤바 트랙 색상 */
        }
        
        #messageInput {
            width: calc(100% - 85px);
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box; 
        }
        #attachFileBtn {
        	width: 70px;
            padding: 8px;
            border: none;
            background-color: #6c757d;
            color: white;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 5px;
        }
        #attachFileBtn:hover {
            background-color: #5a6268;
        }
        #sendMessageBtn {
            width: 70px;
            padding: 8px;
            border: none;
            background-color: #007bff;
            color: white;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 5px;
        }
        #sendMessageBtn:hover {
            background-color: #0056b3;
        }
        
        .chat-message {
        margin-bottom: 8px;
        border-radius: 3px;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
	    }
	    .my-message {
	        text-align: right;
	        align-items: flex-end;
	    }
	    .other-message {
	        text-align: left;
	        align-items: flex-start;
	    }
	    .chat-sender {
	        font-weight: bold;
	        margin-bottom: 2px;
	        font-size: 0.95em;
	        color: #333;
	    }
	    .chat-content-wrapper {
	        display: flex;
	        align-items: flex-end;
	        gap: 8px;
	    }
	    .my-message .chat-content-wrapper {
	        flex-direction: row-reverse;
	    }
	    .other-message .chat-content-wrapper {
	        flex-direction: row;
	    }
	    .chat-content {
	        white-space: pre-wrap;
	        word-break: break-all;
	        padding: 10px 14px;
	        border-radius: 20px;
	       	min-width: 60px;
	        max-width: 80%;
	        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
	        line-height: 1.5;
	        word-wrap: break-word;
	    }
	    .my-message .chat-content {
	        background-color: #d1ecf1;
	        color: #333;
	    }
	    .other-message .chat-content {
	        background-color: #ffffff;
	        color: #333;
	    }
	    .chat-time {
	        font-size: 0.7em;
	        color: #888;
	        white-space: nowrap;
	        align-self: flex-end;
	        maring: 0 4px;
	    }
	    .chat-date-header {
	        text-align: center;
	        margin: 20px 0;
	        color: #666;
	        font-size: 0.8em;
	        font-weight: bold;
	        padding: 6px 12px;
	        background-color: #e6e6e6;
	        border-radius: 15px;
	        align-self: center;
	        max-width: fit-content;
	        margin-left: auto;
	        margin-right: auto;
	    }
	    .chat-sender-info {
	    	display: flex;
	    	align-items: center;
	    	margin-bottom: 5px;
	    	gap: 8px;
	    }
	    .chat-profile-img {
	    	width: 35px;
	    	height: 35px;
	    	border-radius: 50%;
	    	object-fit: cover;
	    	border: 2px solid #ddd;
	    	flex-shrink: 0;
	    }
	    .chat-profile-initial {
	    	width: 35px;
	    	height: 35px;
	    	border-radius: 50%;
	    	background-color: #8a2be2;
	    	color: white;
	    	display: flex;
	    	justify-content: center;
	    	align-items: center;
	    	font-weight: bold;
	    	font-size: 1em;
	    	border: 2px solid #6a1aab;
	    	flex-shrink: 0;
	    	box-shadow: 0 1px 3px rgba(0,0,0,0.1);
	    }
	    .my-message .chat-sender-info {
	    	flex-direction: row-reverse;
	    	justify-content: flex-end;
	    }
	    .other-message .chat-sender-info {
	    	flex-direction: row;
	    	justify-content: flex-start;
	    }
	    .chat-image {
	    	max-width: 250px;
	    	max-height: 230px;
	    	object-fit: cover;
            border-radius: 12px;
            margin-top: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.25);
            cursor: pointer;
        }
        .chat-content.image-only {
        	padding: 0;
        	background-color: transparent;
        	box-shadow: none;
        }
        .chat-message.system-message {
	        text-align: center;
	        margin: 15px 0;
        	font-size: 0.8em;
        	align-items: center;
        }
        .chat-message.system-message .chat-content {
        	background-color: #e0e0e0;
        	padding: 8px 15px;
        	border-radius: 15px;
        	display: inline-block;
        	color: #555;
        	font-weight: normal;
        }
        .mention-highlight {
        	background-color: #ffeb3b;
        	padding: 2px 4px;
        	border-radius: 4px;
        	font-weight: bold;
        }
        #loadMoreBtn {
        	display: block;
        	margin: 15px auto 10px;
        	padding: 12px 25px;
        	background-color: #17a2b8;
        	color: white;
        	border: none;
        	border-radius: 25px;
        	cursor: pointer;
        	font-size: 0.9em;
        	box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: background-color 0.2s ease, transform 0.1s ease, box-shadow 0.2s ease;
        }
        #loadMoreBtn:hover {
        	background-color: #138496;
        	transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        #loadMoreBtn:disabled {
        	background-color: #cccccc;
        	cursor: not-allowed;
        	transform: none;
            box-shadow: none;
        }
        .loading-indicator, .no-more-messages-indicator { 
        	text-align: center;
        	padding: 15px;
        	color: #888;
        	font-style: italic;
        	display: none; /* 초기에는 숨김 */
        	font-size: 0.9em;
        }
        .no-more-messages-indicator { 
        	font-size: 0.85em;
        	border-top: 1px dashed #e0e0e0;
        	margin-top: 15px;
        	padding-top: 15px;
        }
        .chat-input-area {
        	display: flex; /* 내부 요소들을 가로로 정렬 */
		    align-items: center; /* 세로 중앙 정렬 */
		    gap: 10px; /* 입력 필드와 버튼 그룹 사이 간격 */
		    margin-top: auto; /* 채팅 디스플레이와의 상단 간격 */
		    padding: 15px 20px; /* 내부 여백 */
		    background-color: #ffffff; /* 배경색 */
		    border-top: 1px solid #e0e0e0; /* 상단 구분선 */
		    border-radius: 0 0 12px 12px; /* 하단 둥근 모서리 */
		    box-shadow: 0 -3px 10px rgba(0,0,0,0.08); /* 상단 그림자 */
		    position: sticky;
		    bottom: 0;
		    z-index: 100;
		    flex-shrink: 0;
        }
        
        /* 메시지 입력 필드 */
		.chat-input-field {
		    flex-grow: 1; /* 남은 공간을 모두 차지하여 너비 확장 */
		    padding: 12px 18px; /* 패딩 증가 */
		    border: 1px solid #ddd; /* 테두리 색상 */
		    border-radius: 28px; /* 더 둥근 모서리 */
		    font-size: 1.05em; /* 폰트 크기 */
		    outline: none; /* 포커스 시 외곽선 제거 */
		    transition: border-color 0.2s ease, box-shadow 0.2s ease;
		    box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
		}
		
		.chat-input-field:focus {
		    border-color: #8a2be2; /* 포커스 시 보라색 테두리 */
		    box-shadow: 0 0 0 3px rgba(138, 43, 226, 0.2);
		}
		
		/* 버튼 그룹 컨테이너 */
		.chat-buttons {
		    display: flex;
		    gap: 10px; /* 버튼들 사이의 간격 */
		}
		
		/* 공통 버튼 스타일 */
		.chat-button {
		    padding: 12px 18px; /* 패딩 조정 */
		    border: none;
		    border-radius: 28px; /* 둥근 모서리 */
		    cursor: pointer;
		    font-size: 1em;
		    font-weight: bold;
		    color: white;
		    transition: background-color 0.2s ease, transform 0.1s ease;
		    min-width: 65px; /* 버튼 최소 너비 설정 */
		    display: flex; /* 아이콘과 텍스트 중앙 정렬 */
		    align-items: center;
		    justify-content: center;
		    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		}
		
		.chat-button:hover {
		    transform: translateY(-1px); /* 호버 시 약간 위로 */
		}
		
		/* 전송 버튼 스타일 */
		.send-button {
		    background-color: #8a2be2; /* 보라색 */
		}
		
		.send-button:hover {
		    background-color: #6a1aab; /* 더 진한 보라색 */
		}
		
		/* 첨부 파일 버튼 스타일 */
		.attach-button {
		    background-color: #6c757d; /* 회색 */
		    min-width: 50px; /* 아이콘 버튼은 너비를 더 줄일 수 있음 */
		    padding: 12px; /* 아이콘 버튼은 패딩을 균등하게 */
		}
		
		.attach-button:hover {
		    background-color: #5a6268; /* 더 진한 회색 */
		}
		
		/* 파일 아이콘 크기 조정 (font-awesome 사용 시) */
		.attach-button i {
		    font-size: 1.3em;
		}
		.mention-highlight {
        	background-color: #fffb00; /* 더 밝은 노란색 */
        	padding: 2px 5px;
        	border-radius: 5px;
        	font-weight: bold;
        	box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .artist-badge { /* 새로 추가 */
        background-image: linear-gradient(to right, #8a2be2, #da70d6); /* 아티스트 테마 그라데이션 */
        color: white;
        font-size: 0.7em;
        font-weight: bold;
        padding: 2px 6px;
        border-radius: 4px;
        margin-right: 4px; /* 닉네임과의 간격 */
        white-space: nowrap;
        display: inline-flex; /* 뱃지 텍스트 정렬 */
        align-items: center;
        justify-content: center;
        height: 18px; /* 뱃지 높이 조정 */
        line-height: 1; /* 텍스트 세로 정렬 */
    }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script> <%-- jQuery CDN 추가 --%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment-with-locales.min.js"></script> <%-- 날짜 포맷팅을 위한 Moment.js 추가 --%>
</head>
<body>
    <sec:authentication property='name' var="username"/>
    <div id="chatDisplay">
        <button id="loadMoreBtn">이전 메시지 더 보기</button>
        <div class="loading-indicator" id="loadingIndicator">이전 메시지를 불러오는 중...</div>
        <div class="no-more-messages-indicator" id="noMoreMessagesIndicator">더 이상 이전 메시지가 없습니다.</div>
    </div>
    <div class="chat-input-area">
	    <input type="text" id="messageInput" placeholder="메시지를 입력해주세요." class="chat-input-field">
	    <div class="chat-buttons">
		    <c:if test="${!isHasMembership}">
		    	<label for="fileInput" id="attachFileLabel" class="chat-button attach-button">
		    		<i class="fa-solid fa-paperclip"></i> </label>
		    	<input type="file" id="fileInput" style="display: none;" accept="image/*, application/pdf">
		    </c:if>
		    <button id="sendMessageBtn" class="chat-button send-button">전송</button>
	    </div>
    </div>
    <script>
    	let stompClient = null;
    	let isConnected = false;
    	
        document.addEventListener('DOMContentLoaded', function() {
        	// Moment.js 한국어 로케일 설정
        	moment.locale('ko');	
        	
        	// CSRF 토큰 정보 가져오기
        	const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
        	const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
        	
        	// 사용자 정보 가져오기
            const chatChannelNo = ${chatChannelNo};
            const username = "${username}";
            const artistUsername = "${artistUsername}";
            const artistComuNicknm = "${artistComuNicknm}";
			const myComuNicknm = "${myComuNicknm}";
			const isCurrentUserArtist = ${isArtist};
			const isCurrentUserMembership = ${isHasMembership};
            
			// 요소 정보 가져오기
            const chatDisplay = document.getElementById('chatDisplay');
            const messageInput = document.getElementById('messageInput');
            const sendButton = document.getElementById('sendMessageBtn');
            
            // 파일 정보 가져오기
            const fileInput = document.getElementById('fileInput');
            const attachFileLabel = document.getElementById('attachFileLabel');
            
            // 더 보기 버튼 요소
            const loadMoreBtn = document.getElementById('loadMoreBtn');
            const loadingIndicator = document.getElementById('loadingIndicator');
            const noMoreMessagesIndicator = document.getElementById('noMoreMessagesIndicator');
           	let currentOffset = ${messageOffset};	// 초기 offset
           	const messageLimit = 50;
           	let isLoading = false;					// 중복 호출 방지 플래그
           	let allMessagesLoaded = false;			// 모든 메세지가 로드되었는지 확인
            
            // 로컬 스토리지에 저장
            localStorage.setItem('wschat.username', username);
            localStorage.setItem('wschat.chatChannelNo', chatChannelNo);
            localStorage.setItem('wschat.nickname', myComuNicknm);

         	// 최근 메세지 날짜 추적하기 위한 변수
            let lastDisplayedDate = null;
         	let oldestDisplayedDate = null;
            
          	// 메시지를 채팅창에 표시하는 함수
           function displayMessage(message, prepend = false) {
         		// 메세지 중복 방지
         		if(message.chatNo && document.getElementById(`message-\${message.chatNo}`)) {
         			return;
         		}
         		
         		// **** 메세지 필터링 ****
         		if(!isCurrentUserArtist && message.username !== username && message.username !== artistUsername && message.username !== "SYSTEM") {
         			console.log(`메시지 숨김: \${message.username} (아티스트 아님, 내 메시지 아님, 아티스트 메시지 아님)`);
					return;
         		}
         		// ********************
         		
         		// 1. 메세지 엘리먼트 생성 및 클래스 추가
               const messageElement = document.createElement('div');
               messageElement.classList.add('chat-message');
               
               if(message.chatNo) {
            	   messageElement.id = `message-\${message.chatNo}`;
               }
               
               // 시스템 메세지 처리
               if(message.username === "SYSTEM") {
            	   messageElement.classList.add('system-message');
            	   const systemContent = document.createElement('span');
            	   systemContent.classList.add('chat-content');
            	   systemContent.textContent = `시스템: \${message.chatContent}`;
            	   messageElement.appendChild(systemContent);
            	   
            	   if(prepend) {
            		   chatDisplay.insertBefore(messageElement, loadingIndicator.nextSibling);
            	   } else {
	            	   chatDisplay.appendChild(messageElement);
            	   }
            	   return;
            	
            	// 시스템 메세지가 아닌 경우
               } else { 
            	   // 2. 사용자 메시지 (내 메시지 / 상대방 메시지)
                   const isMyMessage = (message.username === username);
               	   const isMessageFromArtist = (message.username === artistUsername);
               	   
                   messageElement.classList.add(isMyMessage ? 'my-message' : 'other-message');

                   // 날짜 헤더 표시 로직
                   // 서버에서 넘어오는 chatSendDate Moment.js로 변환
                   const messageMoment = moment(message.chatSendDate);
                   const messageDateFormatted = messageMoment.format('YYYY년 M월 D일');
                   const messageDateKey = messageMoment.format('YYYY-MM-DD');	// 날짜 비교 위해

                   let dateHeaderElement = null;
                   let existingDateHeader = chatDisplay.querySelector(`.chat-date-header[data-date="\${messageDateKey}"]`);
                   
                   // 날짜 헤더 생성 조건
                   if (prepend) { // 이전 메시지 로드 (상단에 추가될 메시지)
                   		// 이전에 표시된 가장 오래된 날짜보다 더 오래된 날짜일 경우에만 날짜 헤더 추가
                       if (!existingDateHeader) {
                           dateHeaderElement = document.createElement('div');
                           dateHeaderElement.classList.add('chat-date-header');
                           dateHeaderElement.textContent = messageDateFormatted;
                           dateHeaderElement.setAttribute('data-date', messageDateKey);
                           
                           // 날짜 헤더를 noMoreMessagesIndicator 바로 다음에 삽입
                           let dateHeaderInsertTarget = noMoreMessagesIndicator.nextSibling || loadingIndicator.nextSibling || loadMoreBtn.nextSibling;
                           chatDisplay.insertBefore(dateHeaderElement, dateHeaderInsertTarget);
                           existingDateHeader = dateHeaderElement;
                       }
                   
                   	   // 메세지 삽입 위치 : 해당 날짜 헤더 바로 다음
                       let messageInsertTarget = existingDateHeader ? existingDateHeader.nextSibling : (noMoreMessagesIndicator.nextSibling || loadingIndicator.nextSibling || loadMoreBtn.nextSibling);
                       chatDisplay.insertBefore(messageElement, messageInsertTarget);
                   
                       // oldestDisplayedDate 업데이트: 현재 메시지 날짜가 기존 가장 오래된 날짜보다 더 오래되면 갱신
                       if (oldestDisplayedDate === null || messageMoment.isBefore(moment(oldestDisplayedDate), 'day')) {
                           oldestDisplayedDate = messageDateKey;
                       }
                   } else { // 새 메시지 또는 초기 메시지 로드 (하단에 추가될 메시지)
                	   if (!existingDateHeader) { // 해당 날짜의 헤더가 없는 경우에만 새로 추가
                           dateHeaderElement = document.createElement('div');
                           dateHeaderElement.classList.add('chat-date-header');
                           dateHeaderElement.textContent = messageDateFormatted;
                           dateHeaderElement.setAttribute('data-date', messageDateKey);
                           chatDisplay.appendChild(dateHeaderElement);
                       }
                       chatDisplay.appendChild(messageElement);

                       // lastDisplayedDate 업데이트: 현재 메시지 날짜가 기존 가장 최신 날짜보다 더 새로우면 갱신
                       if (lastDisplayedDate === null || messageMoment.isAfter(moment(lastDisplayedDate), 'day')) {
                           lastDisplayedDate = messageDateKey;
                       }
                   }

                   // 3. 프로필 이미지 및 닉네임
                   const senderInfoContainer = document.createElement('div');
                   senderInfoContainer.classList.add('chat-sender-info');
                   
                   let profileDisplayElement;
                   if(message.userProfileImgPath && message.userProfileImgPath !== 'null' && message.userProfileImgPath.trim() !== '') {
                       profileDisplayElement = document.createElement('img');
                       profileDisplayElement.classList.add('chat-profile-img');
                       profileDisplayElement.src = message.userProfileImgPath;
                       profileDisplayElement.alt = (message.comuNicknm || message.username) + " 프로필";
                   } else {
                       profileDisplayElement = document.createElement('div');
                       profileDisplayElement.classList.add('chat-profile-initial');
                       const initial = (message.comuNicknm && message.comuNicknm.length > 0) ? 
                               message.comuNicknm.charAt(0).toUpperCase() : '?';
                       profileDisplayElement.textContent = initial;
                   }
                   
                   const senderElement = document.createElement('span');
                   senderElement.classList.add('chat-sender');
                   senderElement.textContent = message.comuNicknm || message.username;
                   
                	// 아티스트 메시지일 경우 뱃지 추가 (닉네임 앞에)
                   if(isMessageFromArtist) {
                       const artistBadge = document.createElement('span');
                       artistBadge.classList.add('artist-badge');
                       artistBadge.textContent = 'ARTIST';
                       
                       // 뱃지와 닉네임을 담을 새로운 span
                       const nameWithBadge = document.createElement('span');
                       nameWithBadge.appendChild(artistBadge);
                       nameWithBadge.appendChild(senderElement); // 닉네임 스팬 추가
                       
                       senderInfoContainer.appendChild(profileDisplayElement);
                       senderInfoContainer.appendChild(nameWithBadge);
                   } else {
	                   if(isMyMessage) {	// 내 메세지인 경우
	                       senderInfoContainer.appendChild(senderElement);
	                       senderInfoContainer.appendChild(profileDisplayElement);
	                   } else {				// 상대방 메세지
	                       senderInfoContainer.appendChild(profileDisplayElement);
	                       senderInfoContainer.appendChild(senderElement);
	                   }
                   }

                   // 4. 메시지 내용 및 시간
                   const contentWrapper = document.createElement('div');
                   contentWrapper.classList.add('chat-content-wrapper');
                   
                   const contentElement = document.createElement('span');
                   contentElement.classList.add('chat-content');
                   
                   if(message.type === 'FILE' && message.fileUrl) {
                       const fileUrl = message.fileUrl;
                       if(fileUrl) {
                           if(fileUrl.match(/\.(jpeg|jpg|gif|png)$/i)) { // 이미지 확장자 확인
                               const imgElement = document.createElement('img');
                               imgElement.classList.add('chat-image');
                               imgElement.src = fileUrl;
                               imgElement.alt = message.chatContent || '이미지';
                               imgElement.onclick = () => window.open(fileUrl, '_blank');
                               contentElement.appendChild(imgElement);
                               contentElement.classList.add('image-only');
                           } else {
                               const fileLink = document.createElement('a');
                               fileLink.href = fileUrl;
                               fileLink.target = '_blank';
                               fileLink.textContent = `[파일] ${message.chatContent}`;
                               contentElement.appendChild(fileLink);
                           }
                       } else {
                           contentElement.textContent = "파일 불러오는 중...";
                       }
                   } else { // 일반 텍스트 메시지
                       let processedContent = message.chatContent;	// 서버에서 넘어온 값
                       
                       // @everyone 멘션 처리 로직
                       if(processedContent.includes('@everyone')) {
                    	   if(isMessageFromArtist) {
                    		   if(isCurrentUserArtist) {
		                           const highlightedMention = `<span class="mention-highlight">@everyone</span>`;
		                           processedContent = processedContent.replaceAll('@everyone', highlightedMention);
		                           contentElement.innerHTML = processedContent;
	                    	   } else if(isCurrentUserMembership) {
	                    		   const replacedMention = `@\${myComuNicknm}`;
	                    		   const highlightedMention = `<span class="mention-highlight">\${replacedMention}</span>`;
	                    		   processedContent = processedContent.replaceAll('@everyone', highlightedMention);
	                    		   contentElement.innerHTML = processedContent;
                    		   }
                    	   }
                       } else {
                    	   // @everyone이 없는 일반 텍스트 메세지
                    	   contentElement.innerHTML = processedContent;
                       }
                   }
                   
                   const timeElement = document.createElement('span');
                   timeElement.classList.add('chat-time');
                   timeElement.textContent = messageMoment.format('A h:mm');
                   
                   contentWrapper.appendChild(contentElement);
                   contentWrapper.appendChild(timeElement);

                   messageElement.appendChild(senderInfoContainer);
                   messageElement.appendChild(contentWrapper);
               }
           }

           // 초기 메시지 로드 (JSP에서 JSON 형태로 가져온 것을 JavaScript로 파싱)
           const initialMessageJson = '<c:out value="${initialMessageJson}" escapeXml="false" />';
           let initialMessages = [];
           
           try {
        	   // JSON 문자열이 비어있는 경우를 대비
        	   if(initialMessageJson.trim() === '') {
        		   initialMessages = [];
        	   } else {
        		   initialMessages = JSON.parse(initialMessageJson);
        	   }
           } catch(e) {
        	   console.error("초기 메세지 JSON 파싱 오류 : ", e);
        	   console.error("문제의 JSON 문자열 : ", initialMessageJson);
        	   initialMessages = [];	// 파싱 오류 발생 시 초기 메시지를 빈 배열로 설정하여 앱 크래시 방지
        	   displayMessage({ username: "SYSTEM", chatContent: "초기 메시지를 불러오는 중 오류가 발생했습니다. (JSON 파싱 실패)" }, false);
           }
           
           console.log("초기 메시지 로드 결과:", initialMessages);
           
           if(initialMessages.length === 0) {
        	   displayMessage({ username: "SYSTEM", chatContent: "아직 메세지가 없습니다. 새로운 대화를 시작해보세요!" }, false);
        	   allMessagesLoaded = true;
        	   loadMoreBtn.style.display = 'none';
        	   noMoreMessagesIndicator.style.display = 'block';
           } else {
        	   // 초기 로딩 메세지 : 최신 순으로 오기 때문에 뒤집어야 함.(날짜, 채팅 번호 둘다).
        	   initialMessages.reverse();
        	   
        	   // 초기 메세지 렌더링
	           for(let i = 0; i < initialMessages.length; i++) {
	        	   displayMessage(initialMessages[i], false);	// 오래된 것부터 순차적으로 추가
	           }
        	   currentOffset = initialMessages.length;
        	   
        	   if(initialMessages.length > 0) {
	        	   oldestDisplayedDate = moment(initialMessages[0].chatSendDate).format('YYYY-MM-DD');
	        	   lastDisplayedDate = moment(initialMessages[initialMessages.length -1].chatSendDate).format('YYYY-MM-DD');
        	   }
           }
           // 초기 로드 후 스크롤을 맨 아래로 이동
           chatDisplay.scrollTop = chatDisplay.scrollHeight;
           
           // "더 보기" 버튼 클릭 이벤트 리스너
           loadMoreBtn.addEventListener('click', function() {
               if (isLoading || allMessagesLoaded) {
                   return;
               }
               
               loadingIndicator.style.display = 'block';
               loadMoreBtn.disabled = true;
               isLoading = true;

               const oldScrollHeight = chatDisplay.scrollHeight; // 스크롤 위치 유지를 위해 현재 높이 저장

               fetch(`/chat/dm/channel/\${chatChannelNo}/more-messages?offset=\${currentOffset}&limit=\${messageLimit}`, {
                   headers: { [csrfHeader]: csrfToken }
               })
               .then(response => {
                   if (!response.ok) {
                       throw new Error('HTTP 오류! 상태: ' + response.status);
                   }
                   return response.json();
               })
               .then(messages => {
                   loadingIndicator.style.display = 'none';
                   loadMoreBtn.disabled = false;
                   isLoading = false;
                   console.log("더보기 메세지 : ",  messages);

                   if (messages.length > 0) {
                       // 더 보기 메세지 렌더링은 displayMessage 함수 사용
                       for(let i = 0; i < messages.length; i++) {
                    	   displayMessage(messages[i], true);		// prepend = true
                       }
                       currentOffset += messages.length;	// offset 업데이트

                       // 스크롤 위치 유지
                       const newScrollHeight = chatDisplay.scrollHeight;
                       chatDisplay.scrollTop = newScrollHeight - oldScrollHeight;
                   } else {
                       allMessagesLoaded = true;
                       loadMoreBtn.style.display = 'none';
                       noMoreMessagesIndicator.style.display = 'block';
                   }
               })
               .catch(error => {
                   console.error("이전 메시지를 가져오는 데 실패했습니다:", error);
                   loadingIndicator.style.display = 'none';
                   loadMoreBtn.disabled = false;
                   isLoading = false;
                   displayMessage({ username: "SYSTEM", chatContent: "이전 메시지를 로드하는 중 오류가 발생했습니다." }, false);
               });
           });

           // 웹소켓 연결 함수
           function connect() {
           	if(isConnected && stompClient !== null && stompClient.connected) {
           		console.warn("STOMP 클라이언트가 이미 연결되어 있습니다. 중복 연결 시도 차단.");
           		return;
           	}
           	
               const socket = new SockJS('/ws-stomp');
               stompClient = Stomp.over(socket);
               
               stompClient.connect({
               	[csrfHeader]: csrfToken
               }, function(frame) {
               	console.log('Connected: ' + frame);
               	isConnected = true;
           
                   stompClient.subscribe(`/user/queue/messages`, function(messageOutput) {
                   	console.log("private message received : ", messageOutput.body);
                       displayMessage(JSON.parse(messageOutput.body), false); // 새 메시지는 하단에 추가
                       chatDisplay.scrollTop = chatDisplay.scrollHeight; // 새 메시지 수신 시 스크롤 맨 아래로
                   }, {id: 'chatSubscription'});
               }, function(error) {
                   console.error('STOMP 연결 오류:', error);
               	isConnected = false;
               	stompClient = null;
               	displayMessage({ username: "SYSTEM", chatContent: "채팅방 연결에 실패했습니다. 페이지를 새로고침 해주세요." }, false);
               });
           }
           
        	// 텍스트 메시지 전송 함수
           function sendMessage() {
               const messageContent = messageInput.value.trim();
               console.log("sendMessage->messageContent : ", messageContent);
               console.log("sendMessage->stompClient : ", stompClient);
               console.log("sendMessage->stompClient.connected : ", stompClient.connected);
               if (messageContent && stompClient && stompClient.connected) {
                   const chatMessage = {
                       username: username,
                       chatChannelNo: chatChannelNo,
                       chatContent: messageContent,
                       comuNicknm: myComuNicknm,
                       type: 'TALK'
                   };
                   stompClient.send(`/pub/chat/dm/message`, {
               		[csrfHeader]: csrfToken
               	}, JSON.stringify(chatMessage));
               	messageInput.value = '';
               } else if(!stompClient || !stompClient.connected) {
            	   displayMessage({ username: "SYSTEM", chatContent: "채팅 서버에 연결되지 않았습니다. 메세지를 보낼 수 없습니다." }, false);
               }
           }
                   
           // 파일 전송 함수
           async function sendFileMessage(file) {
           	if(!file || !stompClient || !stompClient.connected) return;
           	
           	const MAX_FILE_SIZE = 10 * 1024 * 1024;	// 10MB
           	const ALLOWED_TYPES = ['image/jpeg', 'image/webp', 'image/png', 'image/gif', 'application/pdf']; // PDF 허용
           	
           	if(file.size > MAX_FILE_SIZE) {
           		alert('파일 크기가 너무 큽니다. 10MB 이하의 파일만 업로드 할 수 있습니다.');
           		fileInput.value = '';
           		return;
           	}
           	
           	if(!ALLOWED_TYPES.includes(file.type)) {
           		alert("허용되지 않는 파일 형식입니다. 이미지(JPG, PNG, GIF) 또는 PDF만 업로드 할 수 있습니다.");
           		fileInput.value = '';
           		return;
           	}
           	
           	const formData = new FormData();
           	formData.append('file', file);
           	formData.append('chatChannelNo', chatChannelNo);
           	
           	try {
           		const response = await fetch('/chat/dm/uploadImage', {
           			method: 'POST',
           			headers: {
           				[csrfHeader]: csrfToken
           			},
           			body: formData
           		});
           		
           		if(response.ok) {
           			console.log("파일 업로드 성공. 메세지 처리는 서버에서 진행됩니다.");
           			fileInput.value = '';
           		} else {
           			const errorText = await response.text();
           			console.error("파일 업로드 실패 : ", response.status, errorText);
           			alert("파일 업로드에 실패했습니다. 관리자에게 문의하세요.");
           		}
           	} catch(e) {
           		console.error("파일 업로드 중 오류 발생 : " , e);
           		alert("파일 업로드 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
           	}
           }

           // 이벤트 리스너 설정
           sendButton.addEventListener('click', sendMessage);
           messageInput.addEventListener('keyup', function(event) {
               if (event.key === 'Enter') {
                   sendMessage();
               }
           });
           
        	// 파일 버튼 클릭 이벤트
           if(attachFileLabel != null) {
        	   attachFileLabel.addEventListener('click', function() {
	           	fileInput.click();
	           });
           }
        	
           if(fileInput != null) {
	           fileInput.addEventListener('change', function() {
	           	if(this.files && this.files.length > 0) {
	           		const fileToUpload = this.files.item(0);
	           		if(fileToUpload) {
	           			sendFileMessage(fileToUpload);
	           		}
	           	}
	           });
           }

           // 페이지 로드 시 웹소켓 연결
      		console.log("DOMContentLoaded 끝: connect() 호출 시도");
          	connect();
       });
       
       function disconnect() {
       	if(stompClient !== null && stompClient.connected) {
       		console.log("STOMP 연결 해제 요청...");
       		stompClient.disconnect(function() {
       			console.log("STOMP Disconnected callback");
       			isConnected = false;
       			stompClient = null;
       		});
       	} else {
       		console.log("STOMP 클라이언트가 연결되어 있지 않아 해제할 수 없습니다.");
       	}
       }
           
      	$(window).on('beforeunload', function() {
      		console.log("Window beforeunload: disconnect() 호출");
      		if(typeof disconnect === 'function') {
           	disconnect();
      		}
       });
   </script>
</body>
</html>