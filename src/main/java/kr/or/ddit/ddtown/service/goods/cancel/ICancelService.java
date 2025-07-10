package kr.or.ddit.ddtown.service.goods.cancel;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.order.OrderCancelVO;
import kr.or.ddit.vo.order.OrdersVO;

public interface ICancelService {

	/**
     * 관리자가 직접 주문을 취소하는 로직을 처리합니다.
     * 주문 상태 변경, 재고 복구, CANCEL 테이블 기록, PG사 연동(TODO)을 포함합니다.
     * @param order 취소할 주문의 상세 정보가 담긴 OrdersVO 객체
     * @return ServiceResult.OK 또는 ServiceResult.FAILED
     */
    public ServiceResult processAdminOrderCancel(OrdersVO order, String empUsername);

    // ★★★ 기존 메서드 시그니처 변경 ★★★
    /**
     * 검색 조건과 페이지 정보를 받아 필터링된 취소/환불 목록을 조회합니다.
     * @param pagingVO 페이지 정보와 검색 조건을 포함하는 PaginationInfoVO 객체
     * @return 해당 페이지의 OrderCancelVO 목록
     */
    public List<OrderCancelVO> getFilteredCancelRefunds(PaginationInfoVO<OrderCancelVO> pagingVO);

    // ★★★ 새로 추가하는 메서드 ★★★
    /**
     * 검색 조건에 맞는 전체 취소/환불 건의 수를 조회합니다.
     * @param pagingVO 검색 조건을 포함하는 PaginationInfoVO 객체
     * @return 전체 취소/환불 건수
     */
    public int getTotalCancelRefundCount(PaginationInfoVO<OrderCancelVO> pagingVO);


    /**
     * 특정 취소/환불 건의 상세 정보를 조회합니다.
     * @param cancelNo 조회할 취소 번호
     * @return 조회된 OrderCancelVO 객체 (없으면 null)
     */
    public OrderCancelVO selectCancelDetail(int cancelNo);

    /**
     * 취소/환불 상세 정보를 업데이트합니다.
     * @param orderCancelVO 업데이트할 정보가 담긴 OrderCancelVO 객체
     * @return 업데이트된 레코드 수
     */
	public int updateCancelRefund(OrderCancelVO orderCancelVO);

	public Map<String, Integer> getCancelRefundStatusCounts(Map<String, Object> searchMap);

	public int getTotalCancelRefundCountIgnoreFilter();

	public Map<String, Long> getCancelReasonCounts();

	public Map<String, Long> getDailyCancelCounts(Map<String, Object> searchMap);

}
