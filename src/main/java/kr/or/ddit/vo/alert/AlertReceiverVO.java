package kr.or.ddit.vo.alert;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class AlertReceiverVO {		// 수신자 VO

	private long alertNo;				// 알림 번호
	private String memUsername;			// 회원 아이디
	private Timestamp alertGetDate;		// 알림 수신 일시
	private String alertReadYn;			// 알림 읽음 여부
	private String alertDelYn;			// 알림 삭제여부
}
