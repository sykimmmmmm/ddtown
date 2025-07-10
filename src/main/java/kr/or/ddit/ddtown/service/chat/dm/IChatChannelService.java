package kr.or.ddit.ddtown.service.chat.dm;


import java.util.List;

import kr.or.ddit.vo.chat.dm.ChatChannelVO;
import kr.or.ddit.vo.chat.dm.ChatMessageVO;
import kr.or.ddit.vo.chat.dm.ParticipantsVO;

public interface IChatChannelService {

	// channelList() : 모든 채팅방 조회 (유저별)
	public List<ChatChannelVO> findAllChannels(String currentUser);

	// createChannel() : 새로운 채팅방 생성
	public ChatChannelVO createChatChannel(int comuProfileNo, int artGroupNo, String chatTypeCode);

	// channelDetail() : 채널 상세 정보 조회
	public ChatChannelVO getChatChannelDetail(int chatChannelNo, String username, int meesageLimit);

	// channelInfo() : 채널 기본 정보, 아티스트 정보 조회 (1:1) ?
	public ChatChannelVO findChatChannelWithArtistInfo(int chatChannelNo);

	// 채널 마지막 메세지 일자 업데이트
	public void updateChatLastDate(int chatChannelNo);

	// 현재 로그인한 사용자 커뮤니티 프로필 번호 조회
	public int getComuProfileNoForChatChannel(int chatChannelNo, String currentUser);

	// 채팅방 참여자 전부 조회
	public List<String> getChatParticipants(Integer chatChannelNo);

	// 참여자 권한 조회
	public List<String> getUserRoleCodes(String participantUsername, int chatChannelNo);

	// 과거 메세지 조회
	public List<ChatMessageVO> getMessageHistory(Integer chatChannelNo, int offset, int limit);

	/**
	 * 해당 아티스트 그룹 dm 채널 폐쇄처리
	 * @param artGroupNo
	 * @return
	 */
	public int deleteChannels(int artGroupNo);

	// 마지막으로 읽은 메세지 업데이트
	void updateLastReadChatNo(Integer chatChannelNo, String username, Integer lastMessageNo);

	// 아티스트 그룹번호 조회
	public Integer getArtGroupNoByChatChannelNo(Integer chatChannelNo);

	// 해당 아티스트 채널 번호 가져오기
	public Integer getChatChannelNo(String memUsername);

	// 참가자 삽입
	public void insertParticipant(ParticipantsVO participant);

	// 참여자 조회
	public boolean isParticipant(int artistChannel, String username);

	// 안읽은 총메세지 개수 불러오기
	public int getTotalUnreadMessageCount(String username, boolean isArtist);

}
