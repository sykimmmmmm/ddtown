package kr.or.ddit.ddtown.service.goods.order;

import java.util.List;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.order.OrderCancelVO;
import kr.or.ddit.vo.order.OrderDetailVO;
import kr.or.ddit.vo.order.OrdersVO;
import kr.or.ddit.vo.order.PaymentVO;

public interface IOrderService {

	//결제 바탕으로 주문 생성
	public int createOrder(OrdersVO order, List<OrderDetailVO> orderDetails);

	//PaymentVO를 DB에 저장
	public void savePaymentReadyInfo(PaymentVO payment);

	//주문 상태 업데이트
	public void updateOrderStatus(int createdOrderNo, String string);

	public void updateOrder(OrdersVO order);

	public void updatePaymentInfo(PaymentVO paymentReadyInfo);

	public void updatePaymentStatus(int orderNo, String string);

	public OrdersVO getOrderByOrderNo(int orderNo);

	public PaymentVO getPaymentReadyInfoByOrderNo(int orderNo);

	public List<OrderDetailVO> getOrderDetailsByOrderNo(int orderNo);

	/**
     * 특정 주문 번호에 해당하는 모든 주문 상세 정보를 가져옵니다.
     * (주문 기본 정보, 상세 상품 목록, 결제 정보 등 포함)
     * @param orderNo 조회할 주문 번호
     * @return OrdersVO 객체 (내부에 OrderDetailVO 리스트와 PaymentVO 포함)
     */
    public OrdersVO retrieveOrderDetail(int orderNo); // ★ 신규 메서드 ★

	public void insertOrderCancel(OrderCancelVO orderCancelVO);

	// 굿즈 번호를 통해 아티스트 그룹번호 가져오기
	public goodsVO getGoodsByGoodsNo(int goodsNo);

	public int selectMyOrderCount(PaginationInfoVO<OrdersVO> pagingVO);

	public List<OrdersVO> selectMyOrderList(PaginationInfoVO<OrdersVO> pagingVO);

	public int getTodayOrders();

}
