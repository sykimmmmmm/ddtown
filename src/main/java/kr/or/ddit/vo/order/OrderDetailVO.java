package kr.or.ddit.vo.order;

import java.util.List;

import kr.or.ddit.vo.goods.goodsVO;
import lombok.Data;

@Data
public class OrderDetailVO {
	private int orderDetNo; //주문 상세 번호
	private int orderNo; //주문 번호
	private int goodsNo; //상품 번호
	private Integer goodsOptNo; //상품 옵션 번호
	private Integer orderDetQty; //주문 수량

	// GOODS 테이블에서 가져올 정보
    private String goodsNm;         // 상품명 (GOODS.GOODS_NM)
    private int goodsPrice;         // 상품 단가 (GOODS.GOODS_PRICE)
    private String representativeImageUrl; // 대표 이미지 URL (GOODS.REPRESENTATIVE_IMAGE_URL - 만약 있다면)

    // GOODS_OPTION 테이블에서 가져올 정보 (만약 옵션명이 필요하다면)
    private String goodsOptNm;      // 상품 옵션명 (GOODS_OPTION.GOODS_OPT_NM)
    private int goodsOptPrice;      // 상품 옵션 추가 가격 (GOODS_OPTION.GOODS_OPT_PRICE)

    private int goodsFileGroupNo; // 상품 이미지 그룹 번호를 담을 필드

	private String goodsStatusCode; //상품 상태코드

	private String goodsStatusKorName; //상품 상태 한국어
	private String goodsStatusEngKey; //상품 상태 영어

	private goodsVO goodsVO;		// 주문한 상품 정보

	private List<OrderCancelVO> orderCancelList;		// 주문 취소 리스트

	// 콘서트 용
	private int ticketNo;		// 티켓 번호

	public int getCartQty() {
        return this.orderDetQty; // orderDetQty의 값을 반환합니다.
    }

	public long getCartTotalAmount() {
        return (this.goodsPrice + this.goodsOptPrice) * this.orderDetQty;
    }

	private String orderStatCode;
}
