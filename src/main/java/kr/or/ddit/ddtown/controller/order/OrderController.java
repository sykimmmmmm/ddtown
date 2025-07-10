package kr.or.ddit.ddtown.controller.order;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.ddtown.service.goods.cart.ICartService;
import kr.or.ddit.ddtown.service.goods.main.IGoodsService;
import kr.or.ddit.ddtown.service.goods.order.IOrderService;
import kr.or.ddit.dto.cart.CartNoListRequest;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.goods.GoodsCartVO;
import kr.or.ddit.vo.goods.goodsOptionVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.order.OrderDetailVO;
import kr.or.ddit.vo.order.OrdersVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/goods/order")
public class OrderController {

	@Autowired
	private IOrderService orderService;

	@Autowired
	private ICartService cartService;

	@Autowired
	private IGoodsService goodsService;

    @Autowired
    private IFileService fileService; // 파일 서비스 주입

	@PostMapping("/prepare")
    @ResponseBody
    public ResponseEntity<Map<String, String>> prepareOrder(
        @RequestBody CartNoListRequest request,
        @AuthenticationPrincipal Object principal,
        HttpSession session
    ) {
        log.info("prepareOrder() 컨트롤러 호출! 선택된 장바구니 아이템으로 주문 페이지 준비!");
        log.info("수신된 cartNoList: {}", request.getCartNoList());

        MemberVO authMember = getAuthMember(principal);
        String username = null;

        if (authMember != null) {
            username = authMember.getMemUsername();
            log.debug("prepareOrder() - 추출된 사용자명: {}", username);
        }

        // 비로그인 상태일 경우 오류 응답
        if (username == null || username.isEmpty()) {
            log.warn("prepareOrder() - 비로그인 상태 접근 시도! (사용자명 없음)");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                 .body(Map.of("status", "error", "message", "로그인 후 주문할 수 있습니다."));
        }

        List<Integer> selectedCartNos = request.getCartNoList();

        // 선택된 상품이 없을 경우 오류 응답
        if (selectedCartNos == null || selectedCartNos.isEmpty()) {
            log.warn("선택된 장바구니 상품이 없습니다.");
            return ResponseEntity.badRequest()
                                 .body(Map.of("status", "error", "message", "주문할 상품을 선택해주세요."));
        }

        List<GoodsCartVO> cartItemsFromDB = new ArrayList<>(); // DB에서 조회된 GoodsCartVO 리스트

        try {
            // cartNoList와 사용자 이름을 기반으로 장바구니 상품 정보 조회
            cartItemsFromDB = cartService.getCartItemsByCartNos(selectedCartNos, username);

            if (cartItemsFromDB == null || cartItemsFromDB.isEmpty()) {
                log.warn("선택된 cartNo에 해당하는 상품 정보를 찾을 수 없거나, 사용자 {}의 장바구니 상품이 아닙니다.", username);
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                                      .body(Map.of("status", "error", "message", "선택된 상품 정보를 불러오는 데 실패했습니다."));
            }

            // 품절/단종 상품은 주문에서 제외하고 로그 남기기
            List<GoodsCartVO> validCartItems = cartItemsFromDB.stream()
                .filter(item -> item.getGoodsStatCode() != null &&
                                !(item.getGoodsStatCode().equals("SOLD_OUT") || item.getGoodsStatCode().equals("UNAVAILABLE")))
                .toList();

            // 유효한 주문 가능 상품이 없을 경우
            if (validCartItems.isEmpty()) {
                log.warn("선택된 상품 중 유효한 주문 가능 상품이 없습니다. 사용자: {}", username);
                return ResponseEntity.ok(Map.of("status", "error", "message", "선택된 상품 중 주문 가능한 상품이 없습니다."));
            }

            // ★★★ 세션에 저장할 OrderDetailVO 리스트와 총 금액 계산 ★★★
            List<OrderDetailVO> preparedOrderDetails = new ArrayList<>();
            long totalAmount = 0;

            for (GoodsCartVO cartItem : validCartItems) {
                OrderDetailVO orderDetail = new OrderDetailVO();
                orderDetail.setGoodsNo(cartItem.getGoodsNo());
                orderDetail.setOrderDetQty(cartItem.getCartQty());
                orderDetail.setGoodsNm(cartItem.getGoodsNm());
                orderDetail.setGoodsPrice(cartItem.getGoodsPrice()); // 기본 상품 가격

                // 옵션 정보 설정 (cartItem에 옵션 정보가 있다면)
                if (cartItem.getGoodsOptNo() != 0 && cartItem.getGoodsOptNo() > 0) {
                    orderDetail.setGoodsOptNo(cartItem.getGoodsOptNo());
                    orderDetail.setGoodsOptNm(cartItem.getGoodsOptNm());
                    orderDetail.setGoodsOptPrice(cartItem.getGoodsOptPrice());
                } else {
                    orderDetail.setGoodsOptNo(0);
                    orderDetail.setGoodsOptNm("옵션 없음");
                    orderDetail.setGoodsOptPrice(0);
                }

                // 이미지 정보 설정 (대표 이미지만 가져옴)
                if (cartItem.getFileGroupNo() != null && cartItem.getFileGroupNo() > 0) {
                    AttachmentFileDetailVO representativeFile = fileService.getRepresentativeFileByGroupNo(cartItem.getFileGroupNo());
                    if (representativeFile != null && representativeFile.getWebPath() != null && !representativeFile.getWebPath().isEmpty()) {
                        orderDetail.setRepresentativeImageUrl(representativeFile.getWebPath());
                    } else {
                        log.warn("주문 준비(장바구니) - 상품 번호 {} (fileGroupNo: {})에 대한 대표 이미지를 찾을 수 없거나 웹 경로가 없습니다.", cartItem.getGoodsNo(), cartItem.getFileGroupNo());
                    }
                } else {
                    log.info("주문 준비(장바구니) - 상품 번호 {}에는 유효한 파일 그룹 번호가 없습니다.", cartItem.getGoodsNo());
                }

                orderDetail.setGoodsStatusCode(cartItem.getGoodsStatCode());

                // 개별 상품(옵션 포함)의 총 금액 계산
                // cartTotalAmount는 이미 굿즈가격+옵션가격 * 수량으로 계산되어 있는 것 같으니 그대로 사용합니다.
                totalAmount += cartItem.getCartTotalAmount();

                preparedOrderDetails.add(orderDetail);
            }

            // ★★★ 세션에 통일된 이름으로 주문 정보 저장 ★★★
            session.setAttribute("preparedOrderDetails", preparedOrderDetails);
            session.setAttribute("preparedTotalAmount", totalAmount);
            session.setAttribute("preparedOrderSource", "CART"); // 장바구니에서 왔음을 명시

            // ★★★ isFromCart 플래그를 세션에 저장 ★★★
            session.setAttribute("isFromCart", true);

            log.info("세션에 preparedOrderDetails 및 관련 정보 저장 완료. 개수: {}", preparedOrderDetails.size());

            return ResponseEntity.ok(Map.of("status", "success", "message", "주문 상품 준비 완료."));

        } catch (Exception e) {
            log.error("주문 상품 목록 조회 또는 처리 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body(Map.of("status", "error", "message", "주문 상품 준비 중 서버 오류가 발생했습니다."));
        }
    }


	@PostMapping("/prepareFromDetail")
    public ResponseEntity<Map<String, Object>> prepareOrderFromDetail(
            @RequestBody Map<String, Object> payload,
            @AuthenticationPrincipal Object principal,
            HttpServletRequest request // HttpSession 대신 HttpServletRequest를 사용해도 됩니다.
    ) {
        MemberVO authMember = getAuthMember(principal);
        String username = null;

        if (authMember != null) {
            username = authMember.getMemUsername();
            log.debug("prepareOrderFromDetail() - 추출된 사용자명: {}", username);
        } else {
            log.warn("prepareOrderFromDetail() - 비로그인 상태 접근 시도!");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                 .body(Map.of("status", "error", "message", "로그인 후 주문할 수 있습니다."));
        }

        List<Map<String, Object>> clientOrderItems = (List<Map<String, Object>>) payload.get("orderItems");
        Integer clientTotalAmount = (Integer) payload.get("totalAmount");

        if (clientOrderItems == null || clientOrderItems.isEmpty() || clientTotalAmount == null || clientTotalAmount <= 0) {
            log.warn("prepareOrderFromDetail() - 유효하지 않은 요청 페이로드: {}", payload);
            return ResponseEntity.badRequest()
                                 .body(Map.of("status", "error", "message", "주문할 상품 정보가 유효하지 않습니다."));
        }

        long serverCalculatedTotal = 0;
        List<OrderDetailVO> preparedOrderDetails = new ArrayList<>();

        try {
            for (Map<String, Object> currentItem : clientOrderItems) {
                Integer goodsNo = (Integer) currentItem.get("goodsNo");
                Integer goodsOptNo = (Integer) currentItem.get("goodsOptNo");
                Integer qty = (Integer) currentItem.get("qty");

                if (goodsNo == null || qty == null || qty <= 0) {
                    log.warn("prepareOrderFromDetail() - 필수 상품 정보(goodsNo, qty) 누락 또는 수량 유효하지 않음: {}", currentItem);
                    return ResponseEntity.badRequest()
                                         .body(Map.of("status", "error", "message", "상품 번호 또는 수량이 유효하지 않습니다."));
                }

                goodsVO goods = goodsService.getGoodsDetail(goodsNo);

                if (goods == null) {
                    log.warn("prepareOrderFromDetail() - goodsNo {}에 해당하는 상품 정보를 찾을 수 없음.", goodsNo);
                    return ResponseEntity.status(HttpStatus.NOT_FOUND)
                                         .body(Map.of("status", "error", "message", "상품 정보를 찾을 수 없습니다."));
                }

                String currentDbGoodsStatCode = goods.getGoodsStatCode();
                if (currentDbGoodsStatCode == null || "GSC002".equalsIgnoreCase(currentDbGoodsStatCode) || "UNAVAILABLE".equalsIgnoreCase(currentDbGoodsStatCode)) {
                    log.warn("prepareOrderFromDetail() - 주문 불가능한 상품: {} (상태: {})", goods.getGoodsNm(), currentDbGoodsStatCode);
                    String message = goods.getGoodsNm() + " 상품은 현재 " +
                                       ("GSC002".equalsIgnoreCase(currentDbGoodsStatCode) ? "품절" :
                                        "UNAVAILABLE".equalsIgnoreCase(currentDbGoodsStatCode) ? "단종" : "주문 불가능") +
                                       " 상태입니다.";
                    return ResponseEntity.badRequest().body(Map.of("status", "error", "message", message));
                }

                if (goods.getStockRemainQty() != null && goods.getStockRemainQty() < qty) {
                    log.warn("prepareOrderFromDetail() - 재고 부족: 상품명 {}, 요청 수량 {}, 현재 재고 {}", goods.getGoodsNm(), qty, goods.getStockRemainQty());
                    return ResponseEntity.badRequest()
                                         .body(Map.of("status", "error", "message", goods.getGoodsNm() + " 상품의 재고가 부족합니다."));
                }

                OrderDetailVO orderDetail = new OrderDetailVO();
                orderDetail.setGoodsNo(goodsNo);
                orderDetail.setOrderDetQty(qty);

                orderDetail.setGoodsNm(goods.getGoodsNm());
                orderDetail.setGoodsPrice(goods.getGoodsPrice());

                goodsOptionVO selectedOption = null;
                if (goodsOptNo != null && goodsOptNo > 0) {
                    selectedOption = goodsService.getGoodsOption(goodsOptNo);

                    if (selectedOption == null || selectedOption.getGoodsNo() != goodsNo) {
                        log.warn("prepareOrderFromDetail() - goodsNo {}에 대한 유효하지 않은 옵션 번호 {} 전달됨.", goodsNo, goodsOptNo);
                        return ResponseEntity.badRequest()
                                             .body(Map.of("status", "error", "message", "선택하신 상품 옵션을 찾을 수 없습니다."));
                    }
                    orderDetail.setGoodsOptNo(selectedOption.getGoodsOptNo());
                    orderDetail.setGoodsOptNm(selectedOption.getGoodsOptNm());
                    orderDetail.setGoodsOptPrice(selectedOption.getGoodsOptPrice());
                } else {
                    orderDetail.setGoodsOptNo(0);
                    orderDetail.setGoodsOptNm("옵션 없음");
                    orderDetail.setGoodsOptPrice(0);
                }

                if (goods.getFileGroupNo() != null && goods.getFileGroupNo() > 0) {
                    AttachmentFileDetailVO representativeFile = fileService.getRepresentativeFileByGroupNo(goods.getFileGroupNo());
                    if (representativeFile != null && representativeFile.getWebPath() != null && !representativeFile.getWebPath().isEmpty()) {
                        orderDetail.setRepresentativeImageUrl(representativeFile.getWebPath());
                        log.debug("주문 준비 - 상품 번호 {} 대표 이미지 경로: {}", goodsNo, representativeFile.getWebPath());
                    } else {
                        orderDetail.setRepresentativeImageUrl(null);
                        log.warn("주문 준비 - 상품 번호 {} (fileGroupNo: {})에 대한 대표 이미지를 찾을 수 없거나 웹 경로가 없습니다.", goodsNo, goods.getFileGroupNo());
                    }
                } else {
                    orderDetail.setRepresentativeImageUrl(null);
                    log.info("주문 준비 - 상품 번호 {}에는 유효한 파일 그룹 번호가 없습니다.", goodsNo);
                }

                orderDetail.setGoodsStatusCode(goods.getGoodsStatCode());

                long itemPriceForCalculation;
                if (goodsOptNo != null && goodsOptNo > 0 && selectedOption != null) {
                    itemPriceForCalculation = selectedOption.getGoodsOptPrice();
                } else {
                    itemPriceForCalculation = goods.getGoodsPrice();
                }
                long currentItemTotal = itemPriceForCalculation * orderDetail.getOrderDetQty();

                log.debug("디버깅 확인: goodsNo={}, goodsNm={}, goodsPrice(VO)={}, goodsOptNo={}, goodsOptNm={}, goodsOptPrice(VO)={}, qty={}, itemPriceForCalculation={}, currentItemTotal={}",
                        goodsNo, orderDetail.getGoodsNm(), orderDetail.getGoodsPrice(), goodsOptNo, orderDetail.getGoodsOptNm(), orderDetail.getGoodsOptPrice(), orderDetail.getOrderDetQty(), itemPriceForCalculation, currentItemTotal);

                serverCalculatedTotal += currentItemTotal;

                preparedOrderDetails.add(orderDetail);
            }

            if (serverCalculatedTotal != clientTotalAmount.longValue()) {
                log.warn("prepareOrderFromDetail() - 클라이언트와 서버의 총 금액 불일치! 클라이언트: {}, 서버: {}", clientTotalAmount, serverCalculatedTotal);
                return ResponseEntity.badRequest()
                                      .body(Map.of("status", "error", "message", "상품 금액 정보가 일치하지 않습니다. 주문을 다시 시도해주세요."));
            }

            // ★★★ 세션에 통일된 이름으로 주문 준비 데이터 저장 ★★★
            HttpSession session = request.getSession();
            session.setAttribute("preparedOrderDetails", preparedOrderDetails);
            session.setAttribute("preparedTotalAmount", serverCalculatedTotal);
            session.setAttribute("preparedOrderSource", "DETAIL"); // 상품 상세에서 왔음을 명시

            // ★★★ isFromCart 플래그를 세션에 저장 ★★★
            session.setAttribute("isFromCart", false);


            log.info("prepareOrderFromDetail() - 주문 준비 완료. 총 {}개의 상품, 총액: {}", preparedOrderDetails.size(), serverCalculatedTotal);
            return ResponseEntity.ok(Map.of("status", "success", "message", "주문 준비 완료."));

        } catch (Exception e) {
            log.error("prepareOrderFromDetail() - 상품 디테일 주문 준비 중 서버 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body(Map.of("status", "error", "message", "주문 준비 중 서버 오류가 발생했습니다: " + e.getMessage()));
        }
	}

	@GetMapping
    public String showOrderPage(
        Model model,
        @AuthenticationPrincipal Object principal,
        RedirectAttributes ra,
        HttpSession session
    ) {
        log.info("showOrderPage() 컨트롤러 호출! (세션 기반) 주문 페이지 렌더링.");

        MemberVO authMember = getAuthMember(principal);
        String tempUsername = null;

        if (authMember != null) {
            tempUsername = authMember.getMemUsername();
            log.debug("showOrderPage() - 추출된 사용자명: {}", tempUsername);
        }

        // 비로그인 상태일 경우 로그인 페이지로 리다이렉트
        if (tempUsername == null || tempUsername.isEmpty()) {
            log.warn("showOrderPage() - 비로그인 상태 접근 시도! (사용자명 없음)");
            ra.addFlashAttribute("message", "로그인 후 주문할 수 있습니다.");
            return "redirect:/login";
        }

        model.addAttribute("isLoggedIn", true);
        model.addAttribute("memberInfo", authMember);

     // 세션에서 통일된 이름으로 주문 준비 데이터 가져오기
        List<OrderDetailVO> orderItems = (List<OrderDetailVO>) session.getAttribute("preparedOrderDetails");
        Long totalAmount = (Long) session.getAttribute("preparedTotalAmount");
        String orderSource = (String) session.getAttribute("preparedOrderSource");
        // isFromCart 값도 세션에서 가져와 모델에 추가
        Boolean isFromCart = (Boolean) session.getAttribute("isFromCart");

        log.debug("showOrderPage() - 세션에서 preparedOrderDetails 가져옴: {}", orderItems != null ? orderItems.size() + "개 항목" : "null");
        log.debug("showOrderPage() - 세션에서 preparedTotalAmount 가져옴: {}", totalAmount);
        log.debug("showOrderPage() - 세션에서 preparedOrderSource 가져옴: {}", orderSource);
        log.debug("showOrderPage() - 세션에서 isFromCart 가져옴: {}", isFromCart); // 새로 추가

        if (orderItems == null || orderItems.isEmpty() || totalAmount == null) {
            log.warn("showOrderPage() - 세션에 주문할 상품 정보(preparedOrderDetails)가 없거나 총액이 없어 장바구니로 리다이렉트.");
            ra.addFlashAttribute("errorMessage", "주문할 상품 정보가 없습니다. 다시 시도해주세요.");
            return "redirect:/goods/cart/list";
        }

        // Model에 주문 상품 정보와 총액, 그리고 isFromCart 전달
        model.addAttribute("orderItems", orderItems);
        model.addAttribute("totalProductAmount", totalAmount);
        model.addAttribute("orderSource", orderSource);
        model.addAttribute("isFromCart", isFromCart != null ? isFromCart : false); // isFromCart 값 전달 (null일 경우 false)

        // 세션 데이터는 한 번 사용 후 제거 (중복 주문 방지 및 보안)
        session.removeAttribute("preparedOrderDetails");
        session.removeAttribute("preparedTotalAmount");
        session.removeAttribute("preparedOrderSource");
        session.removeAttribute("isFromCart");
        log.info("세션에서 preparedOrderDetails 및 관련 정보 제거 완료.");

        return "goods/order";
    }

	/**
     * 주문 상세 페이지를 표시합니다.
     * @param orderNo 조회할 주문 번호
     * @param principal 현재 로그인 사용자 정보
     * @param model JSP로 데이터를 전달할 Model 객체
     * @return 주문 상세 JSP 경로
     */
    @GetMapping("/detail")
    public String orderDetail(
            @RequestParam("orderNo") int orderNo,
            @AuthenticationPrincipal Object principal,
            Model model) {

        MemberVO authMember = getAuthMember(principal);
        String username = null;

        if (authMember == null || authMember.getMemUsername() == null || authMember.getMemUsername().isEmpty()) {
            log.warn("orderDetail() - 비로그인 상태 접근 시도! 로그인 페이지로 리다이렉트."); // 추가
            // 로그인되어 있지 않으면 로그인 페이지로 리다이렉트
            return "redirect:/login?error=auth_required";
        }
        username = authMember.getMemUsername();
        log.info("orderDetail() - 사용자 {} 가 주문 번호 {} 상세 조회 시도", username, orderNo); // 추가

        try {
            OrdersVO order = orderService.retrieveOrderDetail(orderNo);
            log.info("orderDetail() - retrieveOrderDetail 결과: {}", order != null ? "OrdersVO 객체 받음" : "null"); // 추가

            // --- OrdersVO 객체 상세 정보 로깅 시작 ---
            if (order != null) {
                log.debug("OrdersVO 필드: orderNo={}, memUsername={}, orderDate={}, orderTotalPrice={}, orderStatCode={}",
                        order.getOrderNo(), order.getMemUsername(), order.getOrderDate(), order.getOrderTotalPrice(), order.getOrderStatCode());
                log.debug("OrdersVO 파생 필드: orderStatName={}", order.getOrderStatName()); // Service에서 채워지는 값 확인

                // PaymentVO 확인
                if (order.getPaymentVO() != null) {
                    log.debug("PaymentVO 필드: tid={}, totalAmount={}, paymentStatCode={}, completedAt={}",
                            order.getPaymentVO().getTid(), order.getPaymentVO().getTotalAmount(),
                            order.getPaymentVO().getPaymentStatCode(), order.getPaymentVO().getCompletedAt());
                    log.debug("PaymentVO 파생 필드: paymentStatCodeNm={}", order.getPaymentVO().getPaymentStatCodeNm()); // Service에서 채워지는 값 확인
                } else {
                    log.warn("PaymentVO는 null입니다. (orderNo: {})", orderNo);
                }

                // OrderDetailList 확인
                if (order.getOrderDetailList() != null && !order.getOrderDetailList().isEmpty()) {
                    log.debug("OrderDetailList 항목 수: {}", order.getOrderDetailList().size());
                    for (int i = 0; i < order.getOrderDetailList().size(); i++) {
                        OrderDetailVO detail = order.getOrderDetailList().get(i);
                        log.debug("  OrderDetailVO [{}]: orderDetNo={}, goodsNo={}, orderDetQty={}, goodsNm={}, goodsPrice={}, goodsOptNo={}, goodsOptNm={}, representativeImageUrl={}",
                                i, detail.getOrderDetNo(), detail.getGoodsNo(), detail.getOrderDetQty(),
                                detail.getGoodsNm(), detail.getGoodsPrice(), detail.getGoodsOptNo(), detail.getGoodsOptNm(), detail.getRepresentativeImageUrl());
                    }
                } else {
                    log.warn("OrderDetailList는 null이거나 비어있습니다. (orderNo: {})", orderNo);
                }
            }
            // --- OrdersVO 객체 상세 정보 로깅 끝 ---

            if (order == null) {
                log.warn("Order not found for orderNo: {}", orderNo);
                model.addAttribute("message", "주문 정보를 찾을 수 없습니다.");
                return "error/404";
            }

            // 보안: 다른 사용자의 주문을 조회하는 것을 방지
            if (!username.equals(order.getMemUsername())) {
                log.warn("Unauthorized access attempt to order detail. User: {}, Order Owner: {}, OrderNo: {}",
                         username, order.getMemUsername(), orderNo);
                model.addAttribute("message", "해당 주문을 조회할 권한이 없습니다.");
                return "error/error";
            }

            model.addAttribute("order", order); // JSP에서 'order'라는 이름으로 OrdersVO 객체에 접근
            log.info("orderDetail() - Model에 OrdersVO 객체 추가 완료. JSP 렌더링 시작."); // 추가
            return "goods/orderDetail"; // JSP 파일의 논리적 경로

        } catch (Exception e) {
            log.error("Error fetching order details for orderNo {}: {}", orderNo, e.getMessage(), e);
            model.addAttribute("message", "주문 정보를 가져오는 중 오류가 발생했습니다.");
            return "error/errorPage"; // 일반적인 에러 페이지
        }
    }


    private MemberVO getAuthMember(Object principal) {
    	MemberVO authMember = null;
    	 // 1. 로그인 여부 확인 및 사용자 정보 추출
        if (principal instanceof CustomUser customUser) {
            authMember = customUser.getMemberVO();
        } else if (principal instanceof CustomOAuth2User customOAuth2User) {
            authMember = customOAuth2User.getMemberVO();
        }
        return authMember;
    }
}