package kr.or.ddit.ddtown.service.admin.goods.orders;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.admin.goods.order.IAdminOrdersMapper;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.ddtown.service.goods.cancel.ICancelService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.order.OrderDetailVO;
import kr.or.ddit.vo.order.OrdersVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminOrdersServiceImpl implements IAdminOrdersService {

	@Autowired
	private IAdminOrdersMapper adminOrdersMapper;

	@Autowired
	private IFileService fileService;

	@Autowired
	private ICancelService cancelService;

	@Override
	public int getTotalOrdersCount(PaginationInfoVO<OrdersVO> pagingVO) {

		return adminOrdersMapper.getTotalOrdersCount(pagingVO);
	}

	 @Override
	    public List<OrdersVO> getAllOrders(PaginationInfoVO<OrdersVO> pagingVO) {
	        int totalRecord = adminOrdersMapper.getTotalOrdersCount(pagingVO);
	        pagingVO.setTotalRecord(totalRecord);

	        List<OrdersVO> orderList = adminOrdersMapper.getOrdersWithDetailsForList(pagingVO);

	        log.info("### getAllOrders (Service) - orderList size: {}", orderList.size());
	        for (OrdersVO order : orderList) {
	            log.info("Order No: {}, Order Date: {}, Customer: {} ({})",
	                     order.getOrderNo(), order.getOrderDate(), order.getCustomerName(), order.getCustomerId());
	            if (order.getOrderDetailList() != null && !order.getOrderDetailList().isEmpty()) {
	                log.info("  Order Details for Order {}:", order.getOrderNo());
	                for (OrderDetailVO detail : order.getOrderDetailList()) {
	                    log.info("    - Goods: {} ({}), Qty: {}",
	                             detail.getGoodsNm(), detail.getGoodsOptNm(), detail.getOrderDetQty());
	                }
	            } else {
	                log.info("  Order {} has no order details.", order.getOrderNo());
	            }
	        }

	        pagingVO.setDataList(orderList);

	        return orderList;
	    }


	@Override
    public OrdersVO getOrderDetail(int orderNo) {
        log.info("### AdminOrdersServiceImpl - getOrderDetail 호출: orderNo={}", orderNo);
        OrdersVO order = adminOrdersMapper.getOrderDetail(orderNo);

        if (order != null && order.getOrderDetailList() != null && !order.getOrderDetailList().isEmpty()) {
            for (OrderDetailVO detail : order.getOrderDetailList()) {
                if (detail.getGoodsFileGroupNo() > 0) {
                    log.debug("상품 번호 {}의 파일 그룹 번호: {}", detail.getGoodsNo(), detail.getGoodsFileGroupNo());

                    try {
                        AttachmentFileDetailVO representativeFile = fileService.getRepresentativeFileByGroupNo(detail.getGoodsFileGroupNo());
                        if (representativeFile != null) {
                            detail.setRepresentativeImageUrl(representativeFile.getWebPath());
                            log.debug("생성된 이미지 URL: {}", representativeFile.getWebPath());
                        } else {
                            log.warn("파일 그룹 번호 {}에 해당하는 대표 파일이 없습니다.", detail.getGoodsFileGroupNo());
                            detail.setRepresentativeImageUrl("/resources/images/no_image.png");
                        }
                    } catch (Exception e) {
                        log.error("파일 그룹 번호 {}의 대표 파일 조회 중 오류 발생: {}", detail.getGoodsFileGroupNo(), e.getMessage(), e);
                        detail.setRepresentativeImageUrl("/resources/images/error_image.png");
                    }
                } else {
                    log.info("상품 번호 {}에 연결된 파일 그룹 번호가 없습니다.", detail.getGoodsNo());
                    detail.setRepresentativeImageUrl("/resources/images/no_image.png");
                }
            }
        }
        return order;
    }

	@Override
    @Transactional
    public ServiceResult cancelOrder(int orderNo, String empUsername) {
        log.info("### AdminOrdersServiceImpl - cancelOrder 호출: orderNo={}", orderNo);

        try {
            // 1. 주문 상세 정보 조회 (재고 복구, 취소 기록 생성을 위해)
            OrdersVO order = adminOrdersMapper.getOrderDetail(orderNo);
            if (order == null) {
                log.warn("취소할 주문을 찾을 수 없습니다. orderId={}", orderNo);
                return ServiceResult.FAILED;
            }

            // 2. 주문 상태 변경, 재고 복구, CANCEL 테이블 기록 로직을 cancelService로 위임
            ServiceResult cancelProcessResult = cancelService.processAdminOrderCancel(order, empUsername);

            if (cancelProcessResult == ServiceResult.OK) {
                log.info("주문(orderNo={}) 취소 처리가 성공적으로 위임 및 완료되었습니다.", orderNo);
                return ServiceResult.OK;
            } else {
                log.error("주문(orderNo={}) 취소 처리 위임 실패. cancelProcessResult={}", orderNo, cancelProcessResult);
                throw new RuntimeException("주문 취소 처리 중 오류 발생 (CancelService)");
            }

        } catch (Exception e) {
            log.error("AdminOrdersServiceImpl에서 주문 취소 중 예외 발생: {}", e.getMessage(), e);
            throw new RuntimeException("주문 취소 처리 중 오류 발생", e);
        }
    }

	/**
     * 주문 상태 코드 및 관리자 메모를 업데이트합니다.
     * @param orderVO 업데이트할 주문 정보를 담은 OrdersVO 객체 (orderNo, orderStatCode, orderMemo 필드 사용)
     * @return 업데이트된 레코드 수
     */
    @Override
    @Transactional
    public int updateOrderStatusAndMemo(OrdersVO orderVO) {

        return adminOrdersMapper.updateOrder(orderVO);
    }

    @Override
    public Map<String, Object> getOrderStatusCounts(Map<String, Object> searchMap) {
        Map<String, Object> rawCounts = adminOrdersMapper.selectOrderStatusCounts(searchMap);
        Map<String, Object> finalCounts = new HashMap<>();

        for (Map.Entry<String, Object> entry : rawCounts.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();
            if (value instanceof Number number) {
                if ("ALL_COUNT".equals(key) || "ALLCOUNT".equals(key)) {
                    finalCounts.put("ALL", number.intValue());
                } else {
                    finalCounts.put(key, number.intValue());
                }
            } else {
                // 숫자가 아닌 다른 타입의 데이터가 넘어올 경우 처리 (없다면 이 else 블록은 불필요)
                log.warn("getOrderStatusCounts: Unexpected value type for key {}: {}", key, value.getClass().getName());
                finalCounts.put(key, 0); // 기본값 0으로 처리하거나 다른 로직
            }
        }

        String[] expectedKeys = {"OSC001", "OSC002", "OSC003", "OSC004", "OSC005", "OSC006", "OSC007", "OSC008", "OSC009", "ALL"};
        for (String key : expectedKeys) {
            finalCounts.putIfAbsent(key, 0);
        }

        log.debug("getOrderStatusCounts 반환 Map: {}", finalCounts);
        return finalCounts;
    }


    /**
     * 일별 매출액 조회
     * searchMap에 orderDateStart, orderDateEnd가 있으면 해당 기간, 없으면 최근 7일 조회
     * @param searchMap 날짜 필터 (orderDateStart, orderDateEnd) 포함
     * @return 날짜(MM-dd)를 키로, 매출액(Long)을 값으로 하는 Map
     */
    @Override
	public Map<String, Long> getDailySales(Map<String, Object> searchMap) {
        List<Map<String, Object>> rawData = adminOrdersMapper.selectDailySales(searchMap);

        Map<String, Long> dailySales = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM-dd");

        // 날짜 범위 설정: 검색 조건에 날짜가 있으면 그 날짜, 없으면 최근 7일
        LocalDate startDate;
        LocalDate endDate = LocalDate.now();

        if (searchMap.containsKey("orderDateStart") && searchMap.get("orderDateStart") != null && !((String)searchMap.get("orderDateStart")).isEmpty()) {
            startDate = LocalDate.parse((String) searchMap.get("orderDateStart"));
        } else {
            startDate = endDate.minusDays(6);
        }

        if (searchMap.containsKey("orderDateEnd") && searchMap.get("orderDateEnd") != null && !((String)searchMap.get("orderDateEnd")).isEmpty()) {
            endDate = LocalDate.parse((String) searchMap.get("orderDateEnd"));
        }

        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            dailySales.put(date.format(formatter), 0L);
        }

        for (Map<String, Object> row : rawData) {
            Object dateObj = row.get("ORDERDATE");
            String dateStr = null;

            if (dateObj != null) {
                dateStr = dateObj.toString();
            }

            if (dateStr == null || dateStr.isEmpty()) {
                log.error("Warning: orderDate from DB is null or empty. Skipping this row. Row data: " + row);
                continue;
            }

            Object totalSalesObj = row.get("TOTALSALES");
            Long totalSales = 0L;

            if (totalSalesObj instanceof Number totalSalesNumber) {
                totalSales = totalSalesNumber.longValue();
            } else if (totalSalesObj != null) {
                // String 등으로 왔을 경우의 처리 (DB 설정에 따라)
                try {
                    totalSales = Long.parseLong(totalSalesObj.toString());
                } catch (NumberFormatException e) {
                    // 숫자로 변환할 수 없는 경우, 0으로 유지하거나 로깅
                    log.error("Warning: totalSales value is not a valid number: " + totalSalesObj);
                }
            }
            dailySales.put(LocalDate.parse(dateStr).format(formatter), totalSales);
        }

        return dailySales;
    }


    /**
     * 인기 상품 TOP N 조회
     * @param limit 조회할 상품 개수
     * @param searchMap 날짜 필터 (orderDateStart, orderDateEnd) 포함
     * @return 상품명과 판매 수량을 담은 List<Map<String, Object>>
     */
    @Override
	public List<Map<String, Object>> getTopSellingGoods(int limit, Map<String, Object> searchMap) {
        searchMap.put("limit", limit);
        return adminOrdersMapper.selectTopSellingGoods(searchMap);
    }

}
