package kr.or.ddit.ddtown.service.chat.dm;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ddtown.mapper.chat.dm.ChatChannelMapper;
import kr.or.ddit.ddtown.mapper.chat.dm.ChatMessageMapper;
import kr.or.ddit.ddtown.mapper.community.CommunityProfileMapper;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.ddtown.service.member.membership.IMembershipService;
import kr.or.ddit.vo.chat.dm.ChatChannelVO;
import kr.or.ddit.vo.chat.dm.ChatMessageVO;
import kr.or.ddit.vo.chat.dm.ParticipantsVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatChannelServiceImpl implements IChatChannelService {

	private final ChatChannelMapper chatChannelMapper;

	private final CommunityProfileMapper communityProfileMapper;

	private final ChatMessageMapper chatMessageMapper;

	private final IMembershipService membershipService;

	private final IFileService fileService;


	// 모든 채팅방 조회
	@Override
	public List<ChatChannelVO> findAllChannels(String currentUser) {
		List<ChatChannelVO> channels = chatChannelMapper.findAllChannels(currentUser);

		Authentication currentUserAuth = SecurityContextHolder.getContext().getAuthentication();
		boolean isArtist = currentUserAuth.getAuthorities().stream()
				.anyMatch(a -> a.getAuthority().equals("ROLE_ARTIST"));

		for(ChatChannelVO channel : channels) {
			int unreadCount = chatMessageMapper.selectUnreadMessageCount(channel.getChatChannelNo(),
					currentUser, isArtist);
			channel.setUnreadMessageCount(unreadCount);

			ChatMessageVO lastMessage = chatMessageMapper.selectLastChatMessage(channel.getChatChannelNo(),
					currentUser, isArtist);

			if(lastMessage != null) {
				if("CMTC002".equals(lastMessage.getChatMsgTypeCode())) {
					channel.setLastMessageContent("[파일] " + (lastMessage.getChatContent() != null ? lastMessage.getChatContent() : ""));
				} else {
					channel.setLastMessageContent(lastMessage.getChatContent());
				}
				channel.setLastMessageSendDate(lastMessage.getChatSendDate());
				channel.setLastMessageSender(lastMessage.getComuNicknm());
				lastMessage.setUserProfileImgPath(currentUser);
			} else {
				channel.setLastMessageContent("");
				channel.setLastMessageSendDate(null);
				channel.setLastMessageSender(null);
			}
		}
		return channels;
	}

	@Override
	@Transactional
	public void updateLastReadChatNo(Integer chatChannelNo, String username, Integer lastMessageNo) {
		if(lastMessageNo != null) {
			chatChannelMapper.updateLastReadChatNo(chatChannelNo, username, lastMessageNo);
		} else {
			chatChannelMapper.updateLastReadChatNo(chatChannelNo, username, 0);
		}
	}

	// 새로운 채팅방 생성
	@Override
	@Transactional
	public ChatChannelVO createChatChannel(int comuProfileNo, int artGroupNo, String chatTypeCode) {
		// 1. chatChannel 객체를 빌더를 사용하여 생성하고, 매퍼를 통해 저장
		ChatChannelVO chatChannel = ChatChannelVO.builder()
                .comuProfileNo(comuProfileNo)
                .artGroupNo(artGroupNo)
                .chatTypeCode(chatTypeCode)
                .build();

		chatChannelMapper.insertChatChannel(chatChannel);

		// 2. artistParticipant 객체를 빌더를 사용하여 생성하고, 매퍼를 통해 저장
		String artistUsername = communityProfileMapper.getMemUsernameByComuProfile(comuProfileNo);
		ParticipantsVO artistParticipant = ParticipantsVO.builder()
				.memUsername(artistUsername)
				.chatChannelNo(chatChannel.getChatChannelNo())
				.paciRoleCode("PRC001")
				.lastReadChatNo(0)
				.build();

		chatChannelMapper.insertParticipant(artistParticipant);

		return chatChannel;
	}

	// 채널 상세 정보 조회
	@Override
	public ChatChannelVO getChatChannelDetail(int chatChannelNo, String username, int messageLimit) {
		// 1. 채널 및 아티스트 정보 조회
		ChatChannelVO chatChannelVO = chatChannelMapper.selectChatChannelDetailByChannelNo(chatChannelNo);

		if(chatChannelVO == null || !"CTC001".equals(chatChannelVO.getChatTypeCode())) {
			log.warn("유효하지 않거나 DM 채널이 아닌 접근 시도: ChannelNo={}, Username={}", chatChannelNo, username);
			return null;
		}

		// 2. 현재 사용자 정보 및 권한 설정
		String myComuNicknm = chatChannelMapper.selectMyNicknmForChannel(username, chatChannelNo);
		chatChannelVO.setMyComuNicknm(myComuNicknm);

		chatChannelVO.setCurrentUsername(username);
		chatChannelVO.setArtist(username.equals(chatChannelVO.getArtistUsername()));

		final boolean hasMembership;
		if(chatChannelVO.getArtGroupNo() != null) {
			hasMembership = membershipService.hasValidMembershipSubscription(username, chatChannelVO.getArtGroupNo());
			chatChannelVO.setHasMembership(hasMembership);
		} else {
			chatChannelVO.setHasMembership(false);
		}

		// 3. 초기 메세지 목록 로드
		List<ChatMessageVO> initialMessages = this.getMessageHistory(chatChannelNo, 0, messageLimit);

		// 메세지가 파일인 경우, fileUrl 채워주기
		for(ChatMessageVO message : initialMessages) {
			if(message.getType() == ChatMessageVO.MessageType.FILE && message.getAttachDetailNo() != null) {
				try {
					AttachmentFileDetailVO fileDetail = fileService.getFileInfo(message.getAttachDetailNo());
					if(fileDetail != null && fileDetail.getFileSavepath() != null && fileDetail.getFileSaveNm() != null) {
						String webPath = "/upload/" + fileDetail.getFileSavepath() + "/" + fileDetail.getFileSaveNm();
						message.setFileUrl(webPath);
					} else {
						message.setFileUrl(null);
					}
				} catch (Exception e) {
					log.error("Failed file URL for chat message {}", message.getChatNo());
				}
			} else {
				message.setFileUrl(null);
			}
		}

		Authentication currentUserAuth = SecurityContextHolder.getContext().getAuthentication();
		boolean isCurrentUserArtist = currentUserAuth.getAuthorities().stream()
				.anyMatch(a -> a.getAuthority().equals("ROLE_ARTIST"));

		String artistUsername = chatChannelVO.getArtistUsername();

		log.info("아티스트 이름 : {}", artistUsername);

		// 4. 초기 메세지 목록 필터링
		List<ChatMessageVO> filterMessages = initialMessages.stream()
				.filter(message -> {
					String msgSenderUser = message.getUsername();

					if(isCurrentUserArtist) {	// 현재 접속자가 아티스트인 경우
						return true;
					} else if(chatChannelVO.isHasMembership()) {	// 멤버십 구독자인 경우
						return msgSenderUser.equals(username) || msgSenderUser.equals(artistUsername);
					}
					return false;	// 아티스트, 멤버십도 아닌 경우
				})
				.toList();

		// 5. 프로필 이미지 경로 설정
		for(ChatMessageVO message : filterMessages) {
			String msgUsername = message.getUsername();
			String profileImgPath = communityProfileMapper.selectProfileImgPathByUsername(msgUsername, chatChannelVO.getArtGroupNo());

			if(profileImgPath != null && !profileImgPath.isEmpty()) {
				message.setUserProfileImgPath(profileImgPath);
			} else {
				message.setUserProfileImgPath(null);
			}
		}
		chatChannelVO.setInitialMessages(filterMessages);

		return chatChannelVO;
	}

	// 채널 기본 정보, 아티스트 정보 조회
	@Override
	public ChatChannelVO findChatChannelWithArtistInfo(int chatChannelNo) {
		return chatChannelMapper.selectChatChannelDetailByChannelNo(chatChannelNo);
	}

	// 마지막 메세지 일자 업데이트
	@Override
	public void updateChatLastDate(int chatChannelNo) {
		chatChannelMapper.updateChatLastDate(chatChannelNo, new Date());	// 현재 시간으로 업데이트
	}

	// 현재 로그인한 사용자 커뮤니티 프로필 번호 조회
	@Override
	public int getComuProfileNoForChatChannel(int chatChannelNo, String currentUser) {
		ChatChannelVO chatChannel = chatChannelMapper.selectChatChannelInfoByChannelNo(chatChannelNo);

		if(chatChannel == null || chatChannel.getComuProfileNo() == null) {
			log.warn("getComuProfileNoForChatChannel: Channel info or artist comuProfileNo not found for channel {}", chatChannelNo);
			return -1;
		}
		Integer artistComuProfileNo = chatChannel.getComuProfileNo();

		// 프로필 번호 이용해 아티스트 그룹 번호 조회
		Integer artGroupNo = communityProfileMapper.selectArtistGroupNoByComuProfileNo(artistComuProfileNo);

		if(artGroupNo == null) {
			log.warn("getComuProfileNoForChatChannel: Artist group not found for comuProfileNo {}", artistComuProfileNo);
			return -1;
		}

		// 사용자 커뮤니티 프로필 번호 조회
		Integer userComuProfileNo = communityProfileMapper.selectComuprofileNoByMember(currentUser, artGroupNo);

		if (userComuProfileNo == null) {
            log.warn("getComuProfileNoForChatChannel: User's comuProfileNo not found for user {} in artGroup {}", currentUser, artGroupNo);
            return -1;
        }

		return userComuProfileNo;
	}

	// 채팅방 참여자 조회
	@Override
	public List<String> getChatParticipants(Integer chatChannelNo) {
		if(chatChannelNo == null) {
			return List.of();	// 빈 리스트 반환
		}
		return chatChannelMapper.selectChatParticipants(chatChannelNo);
	}

	// 참여자 권한 조회
	@Override
	public List<String> getUserRoleCodes(String participantUsername, int chatChannelNo) {
		if(participantUsername == null) {
			return List.of();	// 빈 리스트 반환
		}
		return chatChannelMapper.selectUserRoleCodesByUsername(participantUsername, chatChannelNo);
	}

	// 과거 메세지 기록 조회
	@Override
	public List<ChatMessageVO> getMessageHistory(Integer chatChannelNo, int offset, int limit) {
		return chatMessageMapper.selectChatMessageByChannelNo(chatChannelNo, offset, limit);
	}

	/**
	 * 해당 아티스트 그룹 dm 채널 폐쇄 처리
	 */
	@Override
	public int deleteChannels(int artGroupNo) {
		return chatChannelMapper.deleteChannels(artGroupNo);
	}

	// 아티스트 그룹번호 조회
	@Override
	public Integer getArtGroupNoByChatChannelNo(Integer chatChannelNo) {
		ChatChannelVO channel = chatChannelMapper.selectChatChannelInfoByChannelNo(chatChannelNo);
		return channel.getArtGroupNo();
	}

	// 해당 아티스트 채널 번호 조회
	@Override
	public Integer getChatChannelNo(String memUsername) {
		return chatChannelMapper.getChatChannelNo(memUsername);
	}

	// 참여자 삽입
	@Override
	public void insertParticipant(ParticipantsVO participant) {
		chatChannelMapper.insertParticipant(participant);
	}

	// 채팅방 참여자 조회
	@Override
	public boolean isParticipant(int artistChannel, String username) {
		// 해당 채널 참가자 목록 조회
		List<String> participants = getChatParticipants(artistChannel);
		boolean flag = false;

		if(participants != null && participants.contains(username)) {
			flag = true;	// 이미 참가자
		}
		return flag;		// 참가자가 아님
	}

	// 안읽은 총메세지 개수 불러오기
	@Override
	public int getTotalUnreadMessageCount(String username, boolean isArtist) {
		Map<String, Object> params = new HashMap<>();
		params.put("username", username);
		params.put("isArtist", isArtist);
		return chatChannelMapper.getTotalUnreadMessageCount(params);
	}

}



