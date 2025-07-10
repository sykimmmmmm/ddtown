package kr.or.ddit.ddtown.mapper.chat.dm;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.chat.dm.ChatChannelVO;
import kr.or.ddit.vo.chat.dm.ParticipantsVO;

@Mapper
public interface ChatChannelMapper {

	// 모든 채팅방 조회 (사용자별)
	List<ChatChannelVO> findAllChannels(String username);

	// 새로운 채팅방 저장
	int insertChatChannel(ChatChannelVO chatRoom);

	// 참여자 저장
	void insertParticipant(ParticipantsVO artistParticipant);

	// 채널 상세 정보 가져오기 ( + 아티스트 정보 )
	ChatChannelVO selectChatChannelDetailByChannelNo(Integer chatChannelNo);

	// 마지막 일자 업데이트 (채팅 메세지 전송 시 사용)
	int updateChatLastDate(@Param("chatChannelNo") int chatChannelNo,
			@Param("chatLastDate") Date chatLastDate);

	// 채널 기본 정보 가져오기
	ChatChannelVO selectChatChannelInfoByChannelNo(Integer chatChannelNo);

	// 로그인한 사용자(아티스트)의 해당 채널 닉네임 가져오기
	String selectMyNicknmForChannel(String username, int chatChannelNo);

	// 참여자 권한 조회
	List<String> selectChatParticipants(Integer chatChannelNo);

	// 채널 삭제
	public int deleteChannels(int artGroupNo);

	// 참여자 권한 코드 가져오기
	List<String> selectUserRoleCodesByUsername(String participantUsername, int chatChannelNo);

	// 마지막으로 읽은 메세지 번호 업데이트
	void updateLastReadChatNo(Integer chatChannelNo, String username, Integer lastReadChatNo);

	// 마지막으로 읽은 메세지 번호 조회
	Integer selectLastMessageNo(int chatChannelNo);

	// 해당 아티스트 채널 번호 조회
	Integer getChatChannelNo(String memUsername);

	// 안읽은 총메세지 개수 불러오기
	int getTotalUnreadMessageCount(Map<String, Object> params);

	// chatNo로 chatChannelNo 조회
	Integer selectChatChannelNoByChatNo(Long chatNo);
}
