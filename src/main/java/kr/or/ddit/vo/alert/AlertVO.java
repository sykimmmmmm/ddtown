package kr.or.ddit.vo.alert;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class AlertVO {		// 알림VO

	private long alertNo;				// 알림 번호
	private String alertTypeCode;		// 알림 유형 코드 ( ATC001, ATC002 등)
	private String relatedItemTypeCode; // 관련 항목 유형코드 ( POST, REPLY, CHAT_MESSAGE, MEMBERSHIP 등)
	private String alertContent;		// 알림 내용
	private String alertUrl;			// 이동 URL
	private Timestamp alertCreateDate;	// 알림 발생 일시
	private long relatedItemNo;			// 알림대상의 번호
	private String relatedItemChar;		// 알림대상의 문자열

	private String alertReadYn;			// 알림 읽음 여부

	private Integer artGroupNo;			// 아티스트 그룹번호
	private String artGroupNm;			// 아티스트 그룹 명
	private Integer artNo;				// 아티스트 번호
	private String artNm;				// 아티스트 명

	private String memUsername;			// 회원 명

	// 프로필 페이지 이동용 프로필 번호
	private Integer relatedTargetProfileNo;		// 게시글 작성자 프로필 이동용
	private String boardTypeCode;				// 커뮤니티 게시글 보드타입 ( 팬, 아티스트 구별용 )
	private Integer chatChannelNo;		// 채팅 채널 번호
}
