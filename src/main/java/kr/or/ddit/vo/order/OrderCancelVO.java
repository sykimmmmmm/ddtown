package kr.or.ddit.vo.order;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class OrderCancelVO {
	private Integer cancelNo; //취소 번호
	private Integer orderNo; //주문 번호
	private Integer goodsNo; //상품 번호
	private String cancelType; //취소 유형 코드
	private String cancelReasonCode; //취소 사유 코드
	private String cancelStatCode; //처리 상태 코드
	private String empUsername; //처리한 직원 번호
	private String memUsername; //회원 아이디
	private String cancelReasonDetail; //취소 상세 사유
	private Integer cancelItemQty; //취소 요청 수량
	private Integer cancelReqPrice; //취소 요청 금액
	private Integer cancelResPrice; //취소 최종 처리 금액
	private Date cancelReqDate; //주문 취소 요청일
	private Date cancelResDate; //환불 처리 완료일
	private String cancelAccountNo; //환불 계좌 번호
	private String cancelAccountHol; //환불 계좌 예금주명

	// --- 추가될 필드 ---
    private String goodsNm; // GOODS 테이블에서 조인하여 가져올 상품명
    private String cancelTypeName; // CANCEL_TYPE 코드의 한글명 (COMMON_DETAIL_CODE에서 가져옴)
    private String cancelStatName; // CANCEL_STAT_CODE 코드의 한글명 (COMMON_DETAIL_CODE에서 가져옴)
    private String cancelReasonName; // CANCEL_REASON_CODE 코드의 한글명

    // --- ⭐⭐ 추가해야 할 필드 ⭐⭐ ---
    private int otherGoodsCount; // 대표 상품 외 나머지 상품의 개수

	private List<OrderDetailVO> cancelOrderDetailVO;

    private int cancelRum;

    private Date orderDate; // jsp에서 주문번호 만들기위해 가져올 주문날짜
    private String orderNm; // 주문번호를 이용해서 새로운 주문 번호 만들기

    public String getOrderNm() {
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    	Date date = new Date();
    	if(this.orderDate != null) {
    		date = this.orderDate;
    	}
    	String formattedDate = sdf.format(date);
    	String name = String.format("%05d", this.orderNo);
    	return formattedDate+'-'+name;
    }
}
