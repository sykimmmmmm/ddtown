package kr.or.ddit.vo.order;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class PaymentVO {
	private String cid; //가맹점 번호 -> CID
	private String aid; //거래 승인 번호 -> AID
	private String paymentStatCode; //결제 상태 코드 -> PAYMENT_STAT_CODE
	private int totalAmount; //총 요청 / 결제금액 -> TOTAL_AMOUNT
	private String subSid; //정기 결제 SID -> SUB_SID
	private String requestedAt; //결제 요청 시각 -> REQUESTED_AT (이 필드는 String인데 DB컬럼이 Timestamp라면 변환 필요)
	private Timestamp completedAt; //결제 응답 시각 -> COMPLETED_AT
	private String tid; //결제 번호 -> TID
	private int orderNo; //주문 번호 -> ORDER_NO

	private String paymentStatCodeNm; // ★ 이 필드가 없었다면 추가 ★

	private String paymentStatCodeName; // ★ 이 필드가 없었다면 추가 ★
}
