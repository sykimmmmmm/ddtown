package kr.or.ddit.ddtown.mapper.orders;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.order.OrderDetailVO;
import kr.or.ddit.vo.order.OrdersVO;
import kr.or.ddit.vo.order.PaymentVO;

@Mapper
public interface IOrderMapper {

	public int insertOrder(OrdersVO order);

	public int insertOrderDetail(OrderDetailVO detail);

	public int insertPaymentReadyInfo(PaymentVO payment);

	public int updateOrderStatus(Map<String, Object> params);

	public int updatePaymentStatus(Map<String, Object> params);

	public OrdersVO selectOrderByOrderNo(int orderNo);

	public PaymentVO selectPaymentReadyInfoByOrderNo(int orderNo);

	public int updateOrder(OrdersVO order);

	public int updatePaymentInfo(PaymentVO payment);

	public List<OrderDetailVO> selectOrderDetailsByOrderNo(int orderNo);
	/**
     * 하나의 쿼리로 주문 기본 정보, 주문 상세(상품 정보 포함), 결제 정보를 가져옵니다.
     * @param orderNo 주문 번호
     * @return OrdersVO 객체
     */
	public OrdersVO getOrderDetailsWithAllInfo(int orderNo);

	/**
     * 공통 상세 코드 번호로 코드 한글명을 조회합니다.
     * @param commCodeDetNo 공통 상세 코드 번호 (예: 'OSC001', 'PSC001')
     * @return 해당 코드의 한글명 (COMM_CODE_DET_NM)
     */
    public String getCommonCodeDetNm(String commCodeDetNo); // ★ 신규 매퍼 메서드 ★

    /**
     * 특정 그룹의 모든 공통 상세 코드를 Map 형태로 가져옵니다.
     * (예: 'ORDER_STAT_CODE' 그룹의 모든 코드)
     * @param commCodeGrpNo 공통 코드 그룹 번호
     * @return Map<String, String> (COMM_CODE_DET_NO -> COMM_CODE_DET_NM)
     */
    public List<Map<String, String>> getCommonCodeDetailsByGroup(String commCodeGrpNo); // ★ 신규 매퍼 메서드 (선택 사항, 대량 조회 시 유용) ★

	public goodsVO getGoodsByGoodsNo(int goodsNo);

	public int selectMyOrderCount(PaginationInfoVO<OrdersVO> pagingVO);

	public List<OrdersVO> selectMyOrderList(PaginationInfoVO<OrdersVO> pagingVO);



	/**
	 * 오더가 콘서트인지 확인하기 위한 체크여부
	 * @param orderNo
	 * @return
	 */
	public int getConcertCheck(int orderNo);

	/**
	 * 오더넘버를 통해 해당 디테일번호를 가져와 굿즈 옵션넘버를 티켓과 조인해서 티켓의 좌석번호와 가격 가져오
	 * @param orderNo
	 * @return
	 */
	public OrdersVO getTicketNameAndPrice(int orderNo);

	public int getTodayOrdersCount();

}
