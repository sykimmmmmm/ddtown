package kr.or.ddit.ddtown.controller.goods;

import java.util.Collections;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ddtown.service.goods.cart.ICartService;
import kr.or.ddit.vo.goods.GoodsCartVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;



@Controller
@Slf4j
@RequestMapping("/goods/cart")
public class GoodsCartController {

	@Autowired
	private ICartService cartService;

	private MemberVO extractMemberVO(Object principal) {
	    if (principal instanceof CustomUser customUser) {
	        return customUser.getMemberVO();
	    } else if (principal instanceof CustomOAuth2User auth2User) {
	        return auth2User.getMemberVO();
	    }
	    return null;
	}

	@GetMapping("/list")
	public String cartList(
			Model model,
			@AuthenticationPrincipal Object principal,
			RedirectAttributes ra
			) {
		MemberVO authMember = null; //인증된 회원 정보를 담을 변수
		log.info("### 장바구니 목록 컨트롤러: 주입된 principal 객체: {}", principal);

		// principal 객체 타입에 따라 MemberVO 추출 (기존 로직과 동일)
	    if (principal instanceof CustomUser customUser) {
	        authMember = customUser.getMemberVO();
	        log.info("### 장바구니 컨트롤러: (다중 옵션) CustomUser에서 MemberVO 추출: {}", authMember);
	    } else if (principal instanceof CustomOAuth2User customOAuth2User) {
	        authMember = customOAuth2User.getMemberVO();
	        log.info("### 장바구니 컨트롤러: (다중 옵션) CustomOAuth2User에서 MemberVO 추출: {}", authMember);
	    } else {
	        log.warn("### 장바구니 컨트롤러: (다중 옵션) 알 수 없는 Principal 타입이거나 로그인되지 않음: {}", principal != null ? principal.getClass().getName() : "null");
	    }

	    // 비회원 체크
	    if (authMember == null) {
	        log.warn("비회원이 다중 옵션 장바구니 페이지 접근 시도!!!");
	        ra.addFlashAttribute("message", "로그인 후 장바구니를 이용할 수 있습니다!!!");
	        return "redirect:/login";
	    }

	    String userId = authMember.getMemUsername(); // 로그인된 회원 고유 아이디
		model.addAttribute("memberInfo", authMember); //회원 정보

		try {
			List<GoodsCartVO> cartList = cartService.getCartItemsUsername(userId); //장바구니 목록 조회
			model.addAttribute("cartItems", cartList); //모델에 장바구니 아이템 리스트 담기
		} catch (Exception e) {
			log.error("장바구니 목록을 불러오는 중 오류 발생: {}", e.getMessage());
			ra.addFlashAttribute("errorMessage", "장바구니를 불러오는데 실패했습니다!!");
			return "redirect:/goods/list"; //리스트 목록으로 redirect
		}

		return "goods/cart";
	}

	@PostMapping("/addMultiple") // 새로운 엔드포인트
	@ResponseBody
	public ResponseEntity<Map<String, Object>> addMultipleCartItems( // 반환 타입을 Map<String, Object>로 변경
	        @RequestBody List<GoodsCartVO> cartList,
	        @AuthenticationPrincipal Object principal
	) {
	    MemberVO authMember = extractMemberVO(principal); // 헬퍼 메서드 사용
	    log.info("### 장바구니 컨트롤러: (다중 옵션) 주입된 principal 객체: {}", principal);

	    if (authMember == null) {
	        log.warn("비회원이 다중 옵션 장바구니 담기 기능 시도!!!");
	        Map<String, Object> response = new HashMap<>();
	        response.put("success", false);
	        response.put("message", "로그인 후 장바구니에 상품을 담을 수 있습니다.");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
	    }

	    String userId = authMember.getMemUsername();

	    try {
	        for (GoodsCartVO cartItem : cartList) {
	            cartItem.setMemUsername(userId);
	            cartService.addOrUpdateCartItem(cartItem);
	        }

	        int newCartCount = cartService.getCartItemCount(userId); // 업데이트된 장바구니 개수 조회

	        Map<String, Object> response = new HashMap<>(); // 응답 맵 생성
	        response.put("success", true);
	        response.put("message", "상품들이 장바구니에 추가되었습니다.");
	        response.put("newCartCount", newCartCount); // ⭐ 새로운 장바구니 개수 추가 ⭐
	        return ResponseEntity.ok(response);
	    } catch (Exception e) {
	        log.error("장바구니에 상품을 추가 / 업데이트 하는 중 오류 발생!!: {}", e.getMessage(), e);
	        Map<String, Object> response = new HashMap<>();
	        response.put("success", false);
	        response.put("message", "장바구니 담기 중 오류가 발생했습니다.");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

	//단일 삭제!
	@PostMapping("/delete")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteCartItem(@RequestBody GoodsCartVO cart, @AuthenticationPrincipal Object principal) { // 반환 타입을 Map<String, Object>로 변경, principal 추가
	    log.info(">>>>>>컨트롤러 deleteCartItem 진입!!! cartNo: {} <<<<<<<<<<<", cart.getCartNo());

	    MemberVO authMember = extractMemberVO(principal); // 헬퍼 메서드 사용
	    if (authMember == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Collections.singletonMap("message", "로그인이 필요합니다."));
	    }
	    String userId = authMember.getMemUsername();

	    if(cart.getCartNo() <= 0) {
	        log.warn("유효하지 않은 cartNo({})로 삭제 요청이 들어왔습니다!!", cart.getCartNo());
	        return ResponseEntity.badRequest().body(Collections.singletonMap("message", "잘못된 장바구니 번호입니다!!!"));
	    }

	    try {
	        int res = cartService.deleteCartItem(cart.getCartNo());
	        Map<String, Object> response = new HashMap<>();

	        if (res > 0) {
	            log.info("장바구니 항목 삭제 성공: Cart No - {}", cart.getCartNo());
	            int newCartCount = cartService.getCartItemCount(userId); // 업데이트된 장바구니 개수 조회
	            response.put("message", "상품이 장바구니에서 삭제되었습니다!!!");
	            response.put("status", "success");
	            response.put("newCartCount", newCartCount); // ⭐ 새로운 장바구니 개수 추가 ⭐
	            return ResponseEntity.ok(response);
	        } else {
	            log.warn("장바구니 항목 삭제 실패: Cart No - {}", cart.getCartNo());
	            response.put("message", "상품 삭제에 실패했습니다!!");
	            response.put("status", "fail");
	            response.put("newCartCount", cartService.getCartItemCount(userId)); // 실패 시에도 현재 개수를 보내는 것이 안전
	            return ResponseEntity.ok(response);
	        }
	    } catch (Exception e) {
	        log.error("장바구니 항목 삭제 중 오류 발생: {}", e.getMessage(), e);
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                             .body(Collections.singletonMap("message", "서버 오류가 발생했습니다!!"));
	    }
	}

	//선택한 상품들 삭제!
	@PostMapping("/deleteSelected")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteSelectedCartItems(@RequestBody Map<String, List<Integer>> requestBody, @AuthenticationPrincipal Object principal) { // 반환 타입을 Map<String, Object>로 변경, principal 추가
	    List<Integer> cartNoList = requestBody.get("cartNoList");
	    log.info(">>>>>>>>>>>> 컨트롤러 deleteSelectedCartItems 진입!! cartNoList: {} <<<<<<<<<<<", cartNoList);

	    MemberVO authMember = extractMemberVO(principal); // 헬퍼 메서드 사용
	    if (authMember == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Collections.singletonMap("message", "로그인이 필요합니다."));
	    }
	    String userId = authMember.getMemUsername();

	    if (cartNoList == null || cartNoList.isEmpty()) {
	        log.warn("선택된 장바구니 항목이 없습니다!!!");
	        return ResponseEntity.badRequest().body(Collections.singletonMap("message","삭제할 상품을 선택해주세요!!"));
	    }

	    Map<String, Object> response = new HashMap<>();

	    try {
	        int deletedCount = cartService.deleteSelectedCartItems(cartNoList);
	        int newCartCount = cartService.getCartItemCount(userId); // 업데이트된 장바구니 개수 조회

	        if (deletedCount == cartNoList.size()) {
	            log.info("선택된 장바구니 항목 {}개 모두 삭제 성공!", deletedCount);
	            response.put("message", deletedCount + "개의 상품이 장바구니에서 삭제되었습니다.");
	            response.put("status", "success");
	            response.put("newCartCount", newCartCount); // ⭐ 새로운 장바구니 개수 추가 ⭐
	            return ResponseEntity.ok(response);
	        } else if (deletedCount > 0) {
	            log.warn("선택된 장바구니 항목 중 일부만 삭제 성공. 요청 {}개 중 {}개 삭제됨.", cartNoList.size(), deletedCount);
	            response.put("message", "선택된 상품 중 " + deletedCount + "개가 장바구니에서 삭제되었습니다. (일부 실패)");
	            response.put("status", "partial_success");
	            response.put("newCartCount", newCartCount); // ⭐ 새로운 장바구니 개수 추가 ⭐
	            return ResponseEntity.ok(response);
	        } else {
	            log.warn("선택된 장바구니 항목 {}개 모두 삭제 실패! (DB에 해당 항목 없음)", cartNoList.size());
	            response.put("message", "선택된 상품 삭제에 실패했습니다. (이미 삭제되었거나 존재하지 않음)");
	            response.put("status", "fail");
	            response.put("newCartCount", newCartCount); // 실패 시에도 현재 개수를 보내는 것이 안전
	            return ResponseEntity.ok(response);
	        }
	    } catch (Exception e) {
	        log.error("선택된 장바구니 항목 삭제 중 예상치 못한 오류 발생: {}", e.getMessage(), e);
	        response.put("message", "선택 상품 삭제 중 서버 오류가 발생했습니다.");
	        response.put("status", "error");
	        // 오류 발생 시 0 또는 현재 개수 반환
	        response.put("newCartCount", cartService.getCartItemCount(userId));
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

	//장바구니 상품 수량 업데이트
	@PostMapping("/updateQuantity")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateCartQuantity(@RequestBody GoodsCartVO cart,
	        @AuthenticationPrincipal Object principal) { // 반환 타입을 Map<String, Object>로 변경
	    log.info(">>>>>>컨트롤러 updateCartQuantity 진입!!! cartNo: {}, cartQty: {} <<<<<<<<<<<", cart.getCartNo(), cart.getCartQty());

	    MemberVO authMember = extractMemberVO(principal); // 헬퍼 메서드 사용
	    if (authMember == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Collections.singletonMap("message", "로그인이 필요합니다."));
	    }
	    String userId = authMember.getMemUsername();

	    if (cart.getCartNo() <= 0 || cart.getCartQty() <= 0) {
	        log.warn("유효하지 않은 cartNo({}) 또는 cartQty({})로 수량 업데이트 요청이 들어왔습니다!!", cart.getCartNo(), cart.getCartQty());
	        return ResponseEntity.badRequest().body(Collections.singletonMap("message", "잘못된 장바구니 번호 또는 수량입니다!!"));
	    }

	    try {
	        int res = cartService.updateCartQuantity(cart);
	        Map<String, Object> response = new HashMap<>();
	        int newCartCount = cartService.getCartItemCount(userId); // 업데이트된 장바구니 개수 조회

	        if (res > 0) {
	            log.info("장바구니 항목 수량 업데이트 성공: Cart No - {}, New Qty - {}", cart.getCartNo(), cart.getCartQty());
	            response.put("message", "수량이 성공적으로 업데이트되었습니다.");
	            response.put("status", "success");
	            response.put("newCartCount", newCartCount); // ⭐ 새로운 장바구니 개수 추가 ⭐
	            return ResponseEntity.ok(response);
	        } else {
	            log.warn("장바구니 항목 수량 업데이트 실패: Cart No - {}", cart.getCartNo());
	            response.put("message", "수량 업데이트에 실패했습니다. 항목을 찾을 수 없거나 변경 사항이 없습니다.");
	            response.put("status", "fail");
	            response.put("newCartCount", newCartCount); // 실패 시에도 현재 개수를 보내는 것이 안전
	            return ResponseEntity.ok(response);
	        }
	    } catch (Exception e) {
	        log.error("장바구니 항목 수량 업데이트 중 오류 발생: {}", e.getMessage(), e);
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                             .body(Collections.singletonMap("message", "서버 오류가 발생했습니다."));
	    }
	}

}
