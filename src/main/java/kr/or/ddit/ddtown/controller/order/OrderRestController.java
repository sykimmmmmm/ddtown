package kr.or.ddit.ddtown.controller.order;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.ddtown.service.goods.order.IOrderService;
import kr.or.ddit.ddtown.service.kakaopay.IKakaoPayService;
import kr.or.ddit.dto.kakaopay.CancelRequest;
import kr.or.ddit.dto.kakaopay.KakaoPayCancelResponseDTO;
import kr.or.ddit.vo.order.OrderCancelVO;
import kr.or.ddit.vo.order.OrderDetailVO;
import kr.or.ddit.vo.order.OrdersVO;
import kr.or.ddit.vo.order.PaymentVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/goods/order")
public class OrderRestController {

	@Autowired
	private IKakaoPayService kakaoPayService;

	@Autowired
	private IOrderService orderService;

	 /**
     * 카카오페이 결제 준비 요청을 처리합니다.
     * 클라이언트(JSP의 JS)에서 Ajax POST 요청으로 호출됩니다.
     */
    @PostMapping("/pay/ready")
    public ResponseEntity<Map<String, Object>> kakaoPayReady(
            @RequestBody Map<String, Object> payload, // 클라이언트로부터 받는 데이터
            @AuthenticationPrincipal Object principal) {

        Map<String, Object> response = new HashMap<>();
        MemberVO authMember = getAuthMember(principal);
        String username = null;
        int createdOrderNo = 0; // 예외 발생 시 롤백을 위해 생성된 주문 번호 저장

        if (authMember != null) {
            username = authMember.getMemUsername();
        }

        if (username == null || username.isEmpty()) {
            response.put("status", "error");
            response.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        }
        log.info("payload : {}", payload);
        // --- 2. 클라이언트에서 받은 결제 정보 추출 및 서버 유효성 검사 (중요!) ---
        List<Map<String, Object>> clientOrderItems = (List<Map<String, Object>>) payload.get("orderItems");
        Integer totalAmount = 0;
        if(payload.get("totalAmount") instanceof Integer tAmt) {
        	totalAmount = tAmt; // 클라이언트에서 받은 총 금액
        }else {
        	totalAmount = Integer.parseInt((String) payload.get("totalAmount"));
        }
        String singleGoodsName = (String) payload.get("singleGoodsName"); // 단품 주문 시 상품명

        boolean isFromCart = (Boolean) payload.getOrDefault("isFromCart", false); // ★★★ payload에서 isFromCart 받기 ★★★


        String goodsName = "";
        int totalQuantity = 0;

        if (clientOrderItems == null || clientOrderItems.isEmpty()) {
            response.put("status", "error");
            response.put("message", "주문할 상품 정보가 없습니다.");
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }
        // 임시 상품명 및 수량 계산 (서버 검증 로직으로 대체 예정)
        for (Map<String, Object> item : clientOrderItems) {
            totalQuantity += (Integer) item.getOrDefault("qty", 1);
        }
        if (clientOrderItems.size() > 1) {
            goodsName = ((String) clientOrderItems.get(0).get("goodsNm")) + " 외 " + (clientOrderItems.size() - 1) + "건";
        } else if (singleGoodsName != null && !singleGoodsName.isEmpty()) {
            goodsName = singleGoodsName;
        } else {
            goodsName = (String) clientOrderItems.get(0).get("goodsNm");
        }

        if (totalAmount == null || totalAmount <= 0 || totalQuantity <= 0) {
            response.put("status", "error");
            response.put("message", "결제 금액 또는 수량이 유효하지 않습니다.");
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }

        // --- 3. 카카오페이 결제 준비 요청 및 주문/결제 정보 저장 ---
        try {
            OrdersVO order = new OrdersVO();

            order.setMemUsername(username);
            order.setOrderTotalPrice(totalAmount);
            // 수정 부분 1: 주문 초기 상태를 OSC009 (결제 요청)으로 설정
            order.setOrderStatCode("OSC009");

            order.setOrderRecipientNm((String) payload.get("orderRecipientNm"));
            order.setOrderRecipientPhone((String) payload.get("orderRecipientPhone"));
            order.setOrderZipCode((String) payload.get("orderZipCode"));
            order.setOrderAddress1((String) payload.get("orderAddress1"));
            order.setOrderAddress2((String) payload.get("orderAddress2"));
            order.setOrderEmail((String) payload.get("orderEmail"));
            order.setOrderMemo((String) payload.get("orderMemo"));

            order.setOrderTypeCode((String) payload.getOrDefault("orderTypeCode", "UNKNOWN"));
            order.setOrderPayMethodNm("카카오페이");

            // ★★★ 여기 추가: orderFromCart 필드 설정 ★★★
            order.setOrderFromCart(isFromCart ? "Y" : "N"); // ★★★ isFromCart 값 OrdersVO에 설정 ★★★
            log.info("### OrderVO에 설정된 orderFromCart 값: {}", order.getOrderFromCart()); // ★★★ 이 로그도 추가해주세요! ★★★
            log.info("### OrderVO에 설정된 orderTypeCode 값: {}", order.getOrderTypeCode());

            List<OrderDetailVO> orderDetails = new ArrayList<>();
            for (Map<String, Object> itemMap : clientOrderItems) {
                OrderDetailVO detail = new OrderDetailVO();

                detail.setGoodsNo((Integer) itemMap.get("goodsNo"));
                detail.setGoodsOptNo((Integer) itemMap.get("goodsOptNo"));
                detail.setOrderDetQty((Integer) itemMap.get("qty"));

                orderDetails.add(detail);
            }

            orderService.createOrder(order, orderDetails);
            createdOrderNo = order.getOrderNo();
            log.info("kakaoPayReady - createOrder 호출 후, 생성된 orderNo: {}", createdOrderNo); // 이 값이 고유한지 확인

            Map<String, String> kakaoReadyResult = kakaoPayService.kakaoPayReady(
                    goodsName,
                    totalAmount,
                    totalQuantity,
                    username,
                    String.valueOf(createdOrderNo)
            );

            if (kakaoReadyResult != null && kakaoReadyResult.containsKey("next_redirect_pc_url")) {
                String tid = kakaoReadyResult.get("tid");
                String nextRedirectPcUrl = kakaoReadyResult.get("next_redirect_pc_url");

                PaymentVO payment = new PaymentVO();
                payment.setTid(tid);
                payment.setOrderNo(createdOrderNo);
                payment.setCid(kakaoPayService.getCid());
                payment.setTotalAmount(totalAmount);
                // 수정 부분 2: 결제 초기 상태를 PSC004 (결제 요청)으로 설정
                payment.setPaymentStatCode("PSC004");

                orderService.savePaymentReadyInfo(payment);

                response.put("status", "success");
                response.put("message", "카카오페이 결제 준비가 완료되었습니다.");
                response.put("next_redirect_pc_url", nextRedirectPcUrl);
                return new ResponseEntity<>(response, HttpStatus.OK);

            } else {
                log.error("카카오페이 결제 준비 응답에 필수 정보 누락: {}", kakaoReadyResult);
                orderService.updateOrderStatus(createdOrderNo, "OSC002"); // ORDERS.ORDER_STAT_CODE: PAYMENT_FAILED
                response.put("status", "error");
                response.put("message", "카카오페이 결제 준비 중 오류가 발생했습니다.");
                return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            log.error("카카오페이 결제 준비 중 서버 오류 발생: {}", e.getMessage(), e);
            if (createdOrderNo > 0) {
                try {
                    orderService.updateOrderStatus(createdOrderNo, "OSC002"); // ORDERS.ORDER_STAT_CODE: PAYMENT_FAILED
                } catch (Exception rollbackE) {
                    log.error("주문 {} 상태 업데이트 중 롤백 오류 발생: {}", createdOrderNo, rollbackE.getMessage());
                }
            }
            response.put("status", "error");
            response.put("message", "결제 시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    /**
     * 주문 취소 요청을 처리합니다.
     * 프론트엔드에서 PATCH 요청으로 호출됩니다.
     * URL: /goods/order/cancel/{orderNo}
     * @param orderNo 취소할 주문 번호
     * @param orderCancelVO 취소 사유 등의 정보 (orderNo, cancelReasonCode, cancelReasonDetail 포함)
     * @param principal 인증된 사용자 정보
     * @return 처리 결과 (성공/실패 메시지)
     */
    @PatchMapping("/cancel/{orderNo}")
    public ResponseEntity<Map<String, Object>> cancelOrder(
            @PathVariable int orderNo,
            @RequestBody OrderCancelVO orderCancelVO, // 클라이언트에서 보낸 취소 정보 DTO
            @AuthenticationPrincipal Object principal) {

        Map<String, Object> response = new HashMap<>();
        MemberVO authMember = getAuthMember(principal);
        String username = null;

        if (authMember != null) {
            username = authMember.getMemUsername();
        }

        if (username == null || username.isEmpty()) {
            response.put("status", "error");
            response.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        }

        log.info("cancelOrder 요청 받음 - orderNo: {}, cancelReasonCode: {}, cancelReasonDetail: {}",
                orderNo, orderCancelVO.getCancelReasonCode(), orderCancelVO.getCancelReasonDetail());

        try {
            // 2. 주문 정보 조회 (OrderNo와 사용자 ID로 본인 주문인지 확인)
            OrdersVO order = orderService.retrieveOrderDetail(orderNo);
            if (order == null) {
                response.put("status", "error");
                response.put("message", "존재하지 않는 주문입니다.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }
            if (!order.getMemUsername().equals(username)) {
                response.put("status", "error");
                response.put("message", "본인의 주문만 취소할 수 있습니다.");
                return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
            }

            // ★★★ 추가된 로그 시작 ★★★
            log.info("주문 번호 {}: order.getOrderTotalPrice(): {}", orderNo, order.getOrderTotalPrice());
            if (order.getPaymentVO() != null) {
                log.info("주문 번호 {}: order.getPaymentVO().getTotalAmount(): {}", orderNo, order.getPaymentVO().getTotalAmount());
            } else {
                log.warn("주문 번호 {}: PaymentVO가 null입니다. 결제 정보가 존재하지 않을 수 있습니다.", orderNo);
            }
            // ★★★ 추가된 로그 끝 ★★★

            // 3. 주문 상태 확인 (취소 가능한 상태인지)
            String orderStatCode = order.getOrderStatCode();
            String paymentStatCode = null;
            if (order.getPaymentVO() != null) {
                paymentStatCode = order.getPaymentVO().getPaymentStatCode();
            }

            if (!("OSC001".equals(orderStatCode) || "OSC009".equals(orderStatCode) || "PSC001".equals(paymentStatCode))) {
                response.put("status", "error");
                response.put("message", "현재 주문 상태에서는 취소할 수 없습니다. (현재 상태: " + order.getOrderStatName() + ")");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            // 4. 카카오페이 결제 취소 처리
            if ("PSC001".equals(paymentStatCode)) {
                String tid = order.getPaymentVO().getTid();
                if (tid == null || tid.isEmpty()) {
                    log.error("카카오페이 결제 취소 진행 불가: TID가 없습니다. 주문번호: {}", orderNo);
                    response.put("status", "error");
                    response.put("message", "결제 정보가 불완전하여 취소할 수 없습니다.");
                    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
                }

                log.info("카카오페이 결제 취소 진행 - TID: {}, 요청 취소 금액: {}", tid, order.getOrderTotalPrice());
                CancelRequest cancelRequest = new CancelRequest();
                cancelRequest.setCid(kakaoPayService.getCid());
                cancelRequest.setTid(tid);
                // order.getOrderTotalPrice() 대신 PaymentVO의 totalAmount 사용 권장 (카카오페이 결제 기준)
                Integer amountToCancel = order.getPaymentVO() != null ? order.getPaymentVO().getTotalAmount() : order.getOrderTotalPrice();
                cancelRequest.setCancelAmount(amountToCancel); // ★★★ PaymentVO의 총 결제 금액 또는 OrdersVO의 총 금액 사용 ★★★
                cancelRequest.setCancelTaxFreeAmount(0); // 비과세 금액 (보통 0)

                KakaoPayCancelResponseDTO cancelResponse = kakaoPayService.kakaoPayCancel(cancelRequest);

                if (cancelResponse == null || (!"CANCELED".equals(cancelResponse.getStatus()) && !"CANCEL_PAYMENT".equals(cancelResponse.getStatus()))) { // ★★★ 수정된 조건 ★★★
                    log.error("카카오페이 결제 취소 실패 또는 부분 취소: {}", cancelResponse != null ? cancelResponse.getStatus() : "응답 없음");
                    response.put("status", "error");
                    response.put("message", "결제 시스템 취소에 실패했습니다. 관리자에게 문의해주세요.");
                    return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
                } else { // ★★★ 추가된 else 블록 ★★★
                    log.info("카카오페이 결제 취소 성공. TID: {}, Status: {}", cancelResponse.getTid(), cancelResponse.getStatus());
                }
            } else {
                log.info("카카오페이 결제가 완료되지 않아 API 취소는 건너뜀. 현재 결제 상태: {}", paymentStatCode);
            }

            // 5. DB 주문 상태 및 취소 정보 업데이트
            orderCancelVO.setOrderNo(orderNo);
            orderCancelVO.setMemUsername(username);
            orderCancelVO.setCancelType("CT001");
            orderCancelVO.setCancelStatCode("CSC003");
            // 취소 요청 금액도 PaymentVO의 총 금액을 기준으로 설정하는 것이 정확합니다.
            orderCancelVO.setCancelReqPrice(order.getPaymentVO() != null ? order.getPaymentVO().getTotalAmount() : order.getOrderTotalPrice());

            if (order.getOrderDetailList() != null && !order.getOrderDetailList().isEmpty()) {
                // 첫 번째 상품의 GOODS_NO를 가져와 설정 (단품 주문 시 유효)
                orderCancelVO.setGoodsNo(order.getOrderDetailList().get(0).getGoodsNo());
            } else {
                // 주문 상세 정보가 없는 경우에 대한 처리 (필요에 따라 에러 처리 또는 기본값 설정)
                log.warn("주문 번호 {}에 주문 상세 정보가 없습니다. GOODS_NO를 설정할 수 없습니다.", orderNo);
            }

            if (order.getOrderDetailList() != null) {
                orderCancelVO.setCancelItemQty(order.getOrderDetailList().stream().mapToInt(OrderDetailVO::getOrderDetQty).sum());
            } else {
                orderCancelVO.setCancelItemQty(0);
            }

            orderService.updateOrderStatus(orderNo, "OSC008");
            orderService.insertOrderCancel(orderCancelVO);

            if (order.getPaymentVO() != null) {
                orderService.updatePaymentStatus(orderNo, "PSC003");
            }

            response.put("status", "success");
            response.put("message", "주문이 성공적으로 취소되었습니다.");
            return new ResponseEntity<>(response, HttpStatus.OK);

        } catch (Exception e) {
            log.error("주문 취소 중 서버 오류 발생: {}", e.getMessage(), e);
            response.put("status", "error");
            response.put("message", "주문 취소 중 예상치 못한 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    private MemberVO getAuthMember(Object principal) {
    	MemberVO authMember = null;
    	if (principal instanceof CustomUser customUser) {
            authMember = customUser.getMemberVO();
        } else if (principal instanceof CustomOAuth2User auth2User) {
            authMember = auth2User.getMemberVO();
        }
    	return authMember;
    }
}