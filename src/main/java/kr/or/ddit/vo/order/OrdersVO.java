package kr.or.ddit.vo.order;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import lombok.Data;

/*
 *이메일, 배송 메모만 NULL 허용
 */
@Data
public class OrdersVO {
	private int orderNo; //주문 번호
	private String memUsername; //회원 아이디
	private String orderTypeCode; //주문 유형 코드 (공통 상세 코드: 굿즈, 온 / 오프라인 콘서트)
	private String orderStatCode; //주문 상태 코드 (공통 상세 코드: 주문 완료, 결제 요청, 배송 준비)
	private String orderPayMethodNm; //결제 방법 명
	private Date orderDate; //주문 일시
	private int orderTotalPrice; //총 주문 금액
	private String orderRecipientNm; //수령인 이름
	private String orderRecipientPhone; //수령인 전화번호
	private String orderZipCode; //우편 번호
	private String orderAddress1; //배송 기본 주소
	private String orderAddress2; //배송 상세 주소
	private String orderEmail; //이메일
	private String orderMemo; //배송 메모

	// --- 카카오페이 결제 승인 시각을 위한 필드 추가 ---
	private Date orderPayDt; // 결제 승인 시각 (YYYY-MM-DD HH:MM:SS)

	// --- MEMBER 테이블에서 가져올 정보 (추가해야 할 필드) ---
    private String customerId;      // 회원 아이디 (M.MEM_USERNAME)
    private String customerName;    // 회원 닉네임 (M.MEM_NICKNM)
    private String customerBirth;   // 회원 생년월일 (M.MEM_BIRTH)

    // --- 주문 상세 정보를 담을 리스트 (추가해야 할 필드) ---
    private List<OrderDetailVO> orderDetailList; // 주문 상세 상품 목록

    // --- 추가: 주문 상태 한글명 ---
    private String orderStatName; // 주문 상태 한글명 (COMMON_DETAIL_CODE.COMM_CODE_DET_NM)
    private String orderTypeName; // 주문 유형 한글명

    private PaymentVO paymentVO;

    private int refundedAmount;     // 총 환불 금액 (ORDER_CANCEL 테이블에서 가져옴)
    private int totalGoodsPrice;    // 총 상품 금액 (배송비 제외)
    private int actualShippingFee;  // 실제 부과된 배송비 (3만원 이상 면제 로직 적용)

    // 장바구니를 통해 주문되었는지 여부 ('Y' 또는 'N'으로 DB에 저장될 예정)
    private String orderFromCart;

    private String orderStatus;

    private int orderRownum;	// 주문 순번

    private String orderNm; // 주문날짜를 이용해서 jsp에서 보여줄 주문번호

    public String getOrderNm() {
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    	String formattedDate = sdf.format(this.orderDate);
    	String name = String.format("%05d", this.orderNo);
    	return formattedDate+'-'+name;
    }


}
