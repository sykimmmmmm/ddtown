package kr.or.ddit.ddtown.controller.admin.goods;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.ddtown.service.goods.cancel.ICancelService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.order.OrderCancelVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/goods/cancelRefund")
public class AdminGoodsCancelRefundController {

	@Autowired
	private ICancelService cancelService;

    private final ObjectMapper objectMapper = new ObjectMapper();

	@GetMapping("/list")
    public String goodsCancelRefundList(
            @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(name = "searchKeyword", required = false, defaultValue = "") String searchKeyword,
            @RequestParam(name = "statusCode", required = false, defaultValue = "") String statusCode,
            // ⭐⭐⭐ 날짜 검색 필터 추가를 고려하여 파라미터 추가 ⭐⭐⭐
            @RequestParam(name = "orderDateStart", required = false) String orderDateStart,
            @RequestParam(name = "orderDateEnd", required = false) String orderDateEnd,
            Model model) {

        log.info("### AdminGoodsCancelRefundController - goodsCancelRefundList 호출");
        log.info("페이지네이션 요청: currentPage={}, searchKeyword={}, statusCode={}, orderDateStart={}, orderDateEnd={}",
                 currentPage, searchKeyword, statusCode, orderDateStart, orderDateEnd);

        PaginationInfoVO<OrderCancelVO> pagingVO = new PaginationInfoVO<>();
        pagingVO.setCurrentPage(currentPage);

        Map<String, Object> searchMap = new HashMap<>(); // 목록 조회 및 총 레코드 수 조회용

        if (!searchKeyword.isEmpty()) {
            searchMap.put("searchKeyword", searchKeyword);
            statusCode = ""; // JSP에서 뱃지를 해제하기 위함
        } else if (!statusCode.isEmpty()) {
            searchMap.put("statusCode", statusCode);
            searchKeyword = ""; // JSP에서 검색어 필드를 비우기 위함
        }
        // 둘 다 비어있으면 searchMap은 비어있음 (전체 조회)

        if (orderDateStart != null && !orderDateStart.isEmpty()) {
            searchMap.put("orderDateStart", orderDateStart);
        }
        if (orderDateEnd != null && !orderDateEnd.isEmpty()) {
            searchMap.put("orderDateEnd", orderDateEnd);
        }

        pagingVO.setSearchMap(searchMap);

        log.info("### AdminGoodsCancelRefundController - 최종 목록/총 레코드 조회 searchMap: {}", searchMap);

        int totalRecord = cancelService.getTotalCancelRefundCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        List<OrderCancelVO> cancelList = cancelService.getFilteredCancelRefunds(pagingVO);
        pagingVO.setDataList(cancelList);

        Map<String, Object> emptySearchMapForCounts = new HashMap<>();
        Map<String, Integer> cancelStatusCounts = cancelService.getCancelRefundStatusCounts(emptySearchMapForCounts);
        model.addAttribute("cancelStatusCounts", cancelStatusCounts);

        String cancelStatusCountsJson = "";
        try {
            cancelStatusCountsJson = objectMapper.writeValueAsString(cancelStatusCounts);
        } catch (JsonProcessingException e) {
            log.error("cancelStatusCounts를 JSON으로 변환 중 오류 발생: {}", e.getMessage());
            cancelStatusCountsJson = "{}";
        }
        model.addAttribute("cancelStatusCountsJson", cancelStatusCountsJson);

        int totalAllCancelRefundCount = cancelService.getTotalCancelRefundCountIgnoreFilter();
        model.addAttribute("totalAllCancelRefundCount", totalAllCancelRefundCount);

        Map<String, Long> cancelReasonCounts = null;
        String cancelReasonCountsJson = "{}";
        try {
            cancelReasonCounts = cancelService.getCancelReasonCounts(); // 서비스 호출
            cancelReasonCountsJson = objectMapper.writeValueAsString(cancelReasonCounts);
        } catch (Exception e) {
            log.error("cancelReasonCounts를 가져오거나 JSON 변환 중 오류 발생: {}", e.getMessage());
        }
        model.addAttribute("cancelReasonCountsJson", cancelReasonCountsJson);
        log.info("### Controller - cancelReasonCountsJson: {}", cancelReasonCountsJson);

        Map<String, Long> dailyCancelCounts = null;
        String dailyCancelCountsJson = "{}";
        try {
            dailyCancelCounts = cancelService.getDailyCancelCounts(searchMap);
            dailyCancelCountsJson = objectMapper.writeValueAsString(dailyCancelCounts);
        } catch (Exception e) {
            log.error("dailyCancelCounts를 가져오거나 JSON 변환 중 오류 발생: {}", e.getMessage());
        }
        model.addAttribute("dailyCancelCountsJson", dailyCancelCountsJson);
        log.info("### Controller - dailyCancelCountsJson: {}", dailyCancelCountsJson);

	    model.addAttribute("pagingVO", pagingVO);
	    model.addAttribute("searchKeyword", searchKeyword);
	    model.addAttribute("statusCode", statusCode);
        model.addAttribute("orderDateStart", orderDateStart);
        model.addAttribute("orderDateEnd", orderDateEnd);


	    return "admin/goods/cancelRefund/cancel_refund_list";
	}


	 // 취소/환불 상세 페이지 (뷰를 반환)
    @GetMapping("/detail")
    public String cancelRefundDetailView(@RequestParam("cancelNo") int cancelNo, Model model) {
        log.info("취소/환불 상세 페이지 요청 - 취소번호: {}", cancelNo);

        return "admin/goods/cancelRefund/cancel_refund_detail";
    }

    @GetMapping("/detailData")
    @ResponseBody
    public OrderCancelVO getCancelRefundDetailData(@RequestParam("cancelNo") int cancelNo) {
    	 log.info("### AJAX detailData 요청 시작 - 취소번호: {}", cancelNo);
        OrderCancelVO detail = cancelService.selectCancelDetail(cancelNo);
        if (detail == null) {
            log.warn("취소번호 {} 에 해당하는 상세 데이터를 찾을 수 없습니다.", cancelNo);
        }
        log.info("### AJAX detailData 서비스 응답: {}", detail);
        return detail;
    }

    /**
     * 취소/환불 상세 정보를 업데이트합니다. (상태, 상세 사유 등)
     * @param orderCancelVO 업데이트할 정보가 담긴 OrderCancelVO 객체 (JSON 형태로 전달)
     * @return 성공 여부를 담은 JSON 응답
     */
    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> updateCancelRefund(
            @RequestBody OrderCancelVO orderCancelVO,
            @AuthenticationPrincipal Object principal // 현재 로그인 사용자 정보를 주입받습니다.
            ) {
        log.info("취소/환불 정보 업데이트 요청: {}", orderCancelVO);

        Map<String, Object> response = new HashMap<>();
        String empUsername = null; // 로그인한 관리자 ID를 저장할 변수

        // 로그인한 사용자 정보에서 empUsername 추출 로직 (cancelOrder 메서드 참고)
        if (principal instanceof CustomUser customUser) {
            if (customUser.getEmployeeVO() != null) {
                empUsername = customUser.getEmployeeVO().getEmpUsername();
                log.info("로그인한 관리자 ID (Employee): {}", empUsername);
            } else {
                // 직원이 아닌 경우 (예: 일반 회원)
                log.warn("직원 계정이 아닌 Principal이 관리자 기능을 시도했습니다: {}", customUser.getUsername());
                response.put("success", false);
                response.put("message", "관리자 권한이 없습니다.");
                return response;
            }
        } else if (principal instanceof CustomOAuth2User customOAuth2User) {
            // OAuth2 사용자는 보통 직원 계정이 아니므로, 여기서 차단
            log.warn("OAuth2 사용자가 관리자 기능을 시도했습니다: {}", customOAuth2User.getName());
            response.put("success", false);
            response.put("message", "관리자 권한이 없습니다.");
            return response;
        } else {
            // 그 외 알 수 없는 Principal 타입이거나 로그인되지 않은 경우
            log.error("로그인 정보를 가져올 수 없거나 유효하지 않은 Principal 타입입니다.");
            response.put("success", false);
            response.put("message", "로그인 정보가 유효하지 않습니다. 다시 로그인 해주세요.");
            return response;
        }

        // empUsername이 null이면 위에서 이미 return 되었을 것이지만, 방어 코드 추가
        if (empUsername == null || empUsername.isEmpty()) {
            log.error("관리자 ID를 가져오는 데 실패했습니다.");
            response.put("success", false);
            response.put("message", "로그인 정보를 확인해주세요.");
            return response;
        }

        // OrderCancelVO에 empUsername 설정 (DB에 저장하기 위함)
        orderCancelVO.setEmpUsername(empUsername);

        try {
            // 비즈니스 로직: 상태가 'DONE' (환불완료)으로 변경될 때 처리일 자동 설정
            if ("DONE".equals(orderCancelVO.getCancelStatCode())) {
                orderCancelVO.setCancelResDate(new Date());
                log.info("환불완료 상태로 변경되어 처리일이 {}로 설정됩니다.", orderCancelVO.getCancelResDate());
            } else if ("REJ".equals(orderCancelVO.getCancelStatCode()) &&
                       (orderCancelVO.getCancelReasonDetail() == null || orderCancelVO.getCancelReasonDetail().trim().isEmpty())) {
                // "요청거부" 시 상세 사유가 비어있으면 오류
                response.put("success", false);
                response.put("message", "요청 거부 시 상세 사유는 필수입니다.");
                return response;
            }

            int result = cancelService.updateCancelRefund(orderCancelVO); // 서비스 호출

            if (result > 0) {
                response.put("success", true);
                response.put("message", "성공적으로 업데이트되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "업데이트에 실패했습니다. 데이터를 찾을 수 없거나 변경 사항이 없습니다.");
            }
        } catch (Exception e) {
            log.error("취소/환불 정보 업데이트 중 오류 발생: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "서버 오류가 발생했습니다.");
            response.put("error", e.getMessage());
        }
        return response;
    }
}
