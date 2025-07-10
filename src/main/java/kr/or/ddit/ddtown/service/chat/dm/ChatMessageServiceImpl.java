package kr.or.ddit.ddtown.service.chat.dm;


import java.security.Principal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ddtown.mapper.chat.dm.ChatChannelMapper;
import kr.or.ddit.ddtown.mapper.chat.dm.ChatMessageMapper;
import kr.or.ddit.ddtown.service.alert.IAlertService;
import kr.or.ddit.ddtown.service.community.ICommunityProfileService;
import kr.or.ddit.vo.alert.AlertVO;
import kr.or.ddit.vo.chat.dm.ChatChannelVO;
import kr.or.ddit.vo.chat.dm.ChatMessageVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatMessageServiceImpl implements IChatMessageService {

	private final ChatMessageMapper chatMessageMapper;
	private final IChatChannelService chatChannelService;
	private final ICommunityProfileService communityService;
	private final SimpMessageSendingOperations messagingTemplate;
	private final IAlertService alertService;
	private final ChatChannelMapper chatChannelMapper;
	@Value("${server.servlet.context-path:/}")
    private String contextPath;

	private static final Pattern BAD_WORD_PATTERN = Pattern.compile(
			"(?:" +
		    "ㅗ|씨발|시발|쉬발|씹새|좆까|좆만|좆밥|지랄|앰창|애미|애비|병신|개새끼|개새꺄|새끼|새꺄|썅년|쌍년|갈보|창녀|걸레|찐따|육시럴|염병|꺼져|좆같|잣같|미친|존나게|졸라|존나|닥쳐|새키|썅|개같|더럽|추잡|버러지|구데기|쓰레기|고자|호구|븅신|등신|엠창|육시럴|즐|쉣|씨발럼|시발럼|씹새끼|죽어라|" + // 핵심 욕설 및 그 변형

		    // 2. 단어 경계 없이 패턴 자체로 감지하는 초성체 및 숫자/특수문자 변형
		    "([ㅆㅅㅈ][1ㅣ]?\\s*[ㅂㅂ])|" + // ㅅㅂ, ㅆㅂ, ㅈㅂ, ㅅ ㅂ, ㅅ1ㅂ 등 (띄어쓰기, 숫자, 'ㅣ' 허용)
		    "(ㅈ\\s*ㄴ)|" + // ㅈㄴ, ㅈ ㄴ
		    "(ㅅ\\s*ㅂ)|" + // ㅅㅂ, ㅅ ㅂ
		    "(ㅆ\\s*ㅂ)|" + // ㅆㅂ, ㅆ ㅂ
		    "(ㅂ\\s*ㅅ)|" + // ㅂㅅ, ㅂ ㅅ
		    "(ㅅㅣㅂㅏㄹ?)|" + // 시바, 시발 (띄어쓰기 없이 붙는 형태)
		    "(ㅂ[0-9]ㅅ)|" + // ㅂ1ㅅ, ㅂ2ㅅ (숫자 변형)
		    "(ㅈ[0-9]까)" + // ㅈ1까, ㅈ2까 (숫자 변형)
		    "(ㅗ[0-9])" +
		    ")",
			Pattern.CASE_INSENSITIVE
	);

	// 채팅방 메세지 저장
	@Override
	@Transactional
	public ChatMessageVO saveAndProcessChatMessage(ChatMessageVO message, Principal principal) {

		// 1. 현재 로그인한 사용자 정보 가져오기
		String currentUser = principal.getName();
		log.info("name : {}", currentUser);

		// 2. 발신자 프로필 번호 가져오기
		int comuProfileNo = chatChannelService.getComuProfileNoForChatChannel(message.getChatChannelNo(), currentUser);

		if(comuProfileNo == -1) {
			log.warn("Invalid comuProfileNo for user {}", comuProfileNo);
			return null;
		}

		// 3. 커뮤니티 닉네임, 프로필 이미지 가져오기
		Integer artGroupNo = chatChannelService.getArtGroupNoByChatChannelNo(message.getChatChannelNo());
		String comuNicknm = communityService.getComuNicknmByUsername(currentUser, artGroupNo);
		String userProfileImgPath = communityService.getComuProfileImgPath(currentUser, artGroupNo);

		//////////////// 알림용 alertUrl ////////////////////
		String alertUrl = "";
		try {
			ChatChannelVO chatChannel = chatChannelMapper.selectChatChannelDetailByChannelNo(message.getChatChannelNo());
			if(chatChannel != null && chatChannel.getChatChannelNo() != null) {
				alertUrl = "javascript:openDmModal('" + chatChannel.getChatChannelNo() + "')";
				log.debug("알림 URL 생성 성공!! URL : {}", alertUrl);
			} else {
				log.warn("알림 URL 생성 실패.. 채널 VO / 아티스트 정보가 없습니다. 채널번호 : {}", message.getChatChannelNo());
				alertUrl = "javascript:openDmModal()";
			}

		} catch (Exception e) {
			log.error("알림 URL 생성중 오류 발생...", e);
			alertUrl = "javascript:openDmModal()";
		}

		//////////////// URL 생성 끝 /////////////////////////

		// 4. 메세지 전송 시각 및 발신자 설정
		message.setUsername(currentUser);
		message.setComuProfileNo(comuProfileNo);
		message.setComuNicknm(comuNicknm);
		message.setUserProfileImgPath(userProfileImgPath);

		if(message.getChatSendDate() == null) {
			message.setChatSendDate(new Date());
		}

		// 5. 메세지 타입 코드 설정
		String originalContent = message.getChatContent();

		if(ChatMessageVO.MessageType.TALK.equals(message.getType())) {
			message.setChatMsgTypeCode("CMTC001");	// 일반 메세지 타입
		} else if(ChatMessageVO.MessageType.FILE.equals(message.getType())) {
			message.setChatMsgTypeCode("CMTC002");	// 첨부 파일 타입
		} else if(originalContent != null && originalContent.contains("@everyone")) {
			message.setType(ChatMessageVO.MessageType.MENTION_ALL);
			message.setChatMsgTypeCode("CMTC001");
		} else {
			message.setType(ChatMessageVO.MessageType.TALK);
			message.setChatMsgTypeCode("CMTC001");	// 기본 값
		}

		try {
			// 6. 비속어 필터링 로직
			Matcher matcher = BAD_WORD_PATTERN.matcher(message.getChatContent());
			if(matcher.find()) {
				sendSystemWarningMessageToUser(currentUser, "🚫 부적절한 단어가 포함되어 메시지가 필터링되었습니다. 🚫");
				return null;
			}

			// 7. DB 저장 (매퍼 호출)
			chatMessageMapper.insertMessage(message);

			// 8. 채팅 채널 마지막 메세지 날짜 업데이트
			chatChannelService.updateChatLastDate(message.getChatChannelNo());


			// 9. 권한 정보 가져오기
			Authentication authentication = (Authentication) principal;

			// 10. 모든 참여자에게 메세지 전송
			List<String> participantUsernames = chatChannelService.getChatParticipants(message.getChatChannelNo());

			// 발신자가 아티스트인지 확인용
			boolean isSenderArtist = authentication.getAuthorities().stream()
					.anyMatch(a -> a.getAuthority().equals("ROLE_ARTIST"));

			// 알림 수신자 목록에서 아티스트 제외
			List<String> alertRecipientUsernames = new ArrayList<>();

			if(isSenderArtist) {		// 아티스트가 보냈을 때
				for(String participantUsername : participantUsernames) {
					List<String> participantRoleCodes = chatChannelService.getUserRoleCodes(participantUsername, message.getChatChannelNo());
					boolean isRecipientArtist = participantRoleCodes.contains("PRC001");
					if(!isRecipientArtist && !participantUsername.equals(currentUser)) {		// 아티스트와 본인 제외 하고 알림보냄
						alertRecipientUsernames.add(participantUsername);		// 수신자 목록 추가
					}
				}
			}

			/////////////// 알림 생성 ///////////////////
			if(isSenderArtist && !alertRecipientUsernames.isEmpty()) {
				for(String recipientUsername : alertRecipientUsernames) {
					String recipientNick = communityService.getComuNicknmByUsername(recipientUsername, artGroupNo);
					String replacedContent = message.getChatContent();
					if (recipientNick != null && !recipientNick.isEmpty()) {
						replacedContent = replacedContent.replaceAll("@everyone", recipientNick);
					}
					AlertVO alert = new AlertVO();
					alert.setAlertTypeCode("ATC003");                    // 알림 타입코드 설정 (NEW_CHAT)
					alert.setRelatedItemTypeCode("ITC003");               // 관련 알림 공통상세코드 설정 (CHAT)
					alert.setRelatedItemNo(message.getChatNo());           // 관련 알림번호 설정 (채팅메시지번호)
					alert.setChatChannelNo(message.getChatChannelNo());    // 채널번호 추가
					alert.setAlertContent(message.getComuNicknm() + "님이 새로운 메시지를 보냈습니다.\n"
						+ message.getComuNicknm() + " : " + replacedContent); // 알림 내용 설정
					alert.setAlertCreateDate(new Timestamp(new Date().getTime())); // 현재시간 설정
					alert.setAlertReadYn("N");
					if(artGroupNo != null) {
						alert.setArtGroupNo(artGroupNo); // 아티스트번호 설정
					}
					if(alertUrl != null && !alertUrl.isEmpty()) {
						alert.setAlertUrl(alertUrl); // 알림 이동용 URL 설정
						log.debug("alertUrl: {}", alert.getAlertUrl());
					} else {
						log.warn("alertURl 비어있음.");
						alert.setAlertUrl("javascript:openDmModal()");
					}
					// 한 명씩 알림 생성
					alertService.createAlert(alert, java.util.Collections.singletonList(recipientUsername));
				}
			}


			// 11. 메세지 전송 로직
			for(String participantUsername : participantUsernames) {

				// 본인 메세지 자신에게 보여야 함
				if(message.getUsername().equals(participantUsername)) {
					messagingTemplate.convertAndSendToUser(participantUsername, "/queue/messages", message);
					continue;
				}

				// 상대방 메세지 처리
				List<String> participantRoleCodes = chatChannelService.getUserRoleCodes(participantUsername, message.getChatChannelNo());

				boolean isRecipientArtist = participantRoleCodes.contains("PRC001");
				boolean isRecipientMembership =participantRoleCodes.contains("PRC002");

				// 아티스트의 경우 모든 메세지 조회 가능
				if(isRecipientArtist) {
					messagingTemplate.convertAndSendToUser(participantUsername, "/queue/messages", message);
					log.debug("메시지 '{}' 아티스트 ({})에게 전송", message.getChatContent(), participantUsername);

				// 멤버십 회원은 아티스트가 보낸 메세지만 볼 수 있음
		        } else if(isRecipientMembership) {
		        	if(isSenderArtist) {
		        		messagingTemplate.convertAndSendToUser(participantUsername, "/queue/messages", message);
		        		log.debug("메시지 '{}' 멤버십 회원 ({})에게 전송", message.getChatContent(), participantUsername);
		        	}
		        }
			}
			return message;
		}catch (Exception e) {
			log.error("메세지 처리 중 오류 발생 : {}", e.getMessage(), e);
			sendSystemErrorMessageToUser(currentUser, "🚫 메시지 전송 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요. 🚫");
			throw new RuntimeException("채팅 메세지 처리 실패", e);
		}
	}

	// 필터링 경고 메세지
	private void sendSystemWarningMessageToUser(String currentUser, String message) {
		ChatMessageVO warnMsg = new ChatMessageVO();
        warnMsg.setUsername("SYSTEM");
        warnMsg.setComuNicknm("시스템");
        warnMsg.setChatContent(message);
        warnMsg.setChatSendDate(new Date());
        warnMsg.setChatMsgTypeCode("CMTC001");
        warnMsg.setType(ChatMessageVO.MessageType.TALK);
        messagingTemplate.convertAndSendToUser(currentUser, "/queue/messages", warnMsg);

	}

	// 시스템 메세지
	private void sendSystemErrorMessageToUser(String currentUser, String message) {
		ChatMessageVO errorMsg = new ChatMessageVO();
		errorMsg.setUsername("SYSTEM");
        errorMsg.setComuNicknm("시스템");
        errorMsg.setChatContent(message);
        errorMsg.setChatSendDate(new Date());
        errorMsg.setChatMsgTypeCode("CMTC001");
        errorMsg.setType(ChatMessageVO.MessageType.TALK);
        messagingTemplate.convertAndSendToUser(currentUser,"/queue/messages",errorMsg);

	}

	// 파일 첨부 상세 추가
	@Override
	@Transactional
	public void insertAttachFileDetail(AttachmentFileDetailVO fileDetailVO) {
		chatMessageMapper.insertAttachFileDetail(fileDetailVO);
	}

	// 마지막 메세지 번호 조회
	@Override
	public Integer selectLastMessageNo(int chatChannelNo) {
		return chatMessageMapper.selectLastMessageNo(chatChannelNo);
	}

	// 더보기 : 페이지네이션
	@Override
	public List<ChatMessageVO> getChatMessagesByChannelPaged(int chatChannelNo, int offset, int limit) {
		List<ChatMessageVO> messages = chatMessageMapper.selectChatMessagesByChannelPaged(chatChannelNo, offset, limit);

		Integer artGroupNo = chatChannelService.getArtGroupNoByChatChannelNo(chatChannelNo);

		for(ChatMessageVO msg : messages) {
			String userProfileImgPath = communityService.getComuProfileImgPath(msg.getUsername(), artGroupNo);

			// 프로필 이미지 경로가 유효하지 않으면 null로 설정하여 클라이언트에서 기본 이미지 처리
            if (userProfileImgPath != null && !userProfileImgPath.isEmpty() && !userProfileImgPath.contains("/upload/profile")) {
                userProfileImgPath = null;
            }
			msg.setUserProfileImgPath(userProfileImgPath);
		}
		return messages;

	}

}
