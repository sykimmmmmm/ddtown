package kr.or.ddit.ddtown.controller.goods;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.ddtown.service.goods.cart.ICartService;
import kr.or.ddit.ddtown.service.goods.main.IGoodsService;
import kr.or.ddit.ddtown.service.goods.notice.IGoodsNoticeService;
import kr.or.ddit.ddtown.service.goods.wishlist.IWishlistService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.goods.goodsNoticeVO;
import kr.or.ddit.vo.goods.goodsOptionVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/goods")
public class GoodsController {

	@Autowired
	public IGoodsService service;

	@Autowired
	public IGoodsNoticeService noticeservice;

	@Autowired
	public IWishlistService wishlistservice;

	@Autowired
	public ICartService cartService;

	@GetMapping("/main")
    public String goodsShopList(
            Model model,
            @AuthenticationPrincipal Object principal,
            @RequestParam(name="currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(required = false) String searchWord,
            @RequestParam(name="searchType", required = false, defaultValue = "newest") String searchType,
            @RequestParam(name="artGroupNo", required = false) Integer artGroupNo, // 아티스트 필터링용
            HttpServletRequest request
            ) {

        // 1. PaginationInfoVO 객체 생성 및 요청 파라미터 설정
        PaginationInfoVO<goodsVO> pagingVO = new PaginationInfoVO<>();
        pagingVO.setCurrentPage(currentPage);

        // 검색/정렬 타입 및 검색어 설정
        pagingVO.setSearchType(searchType);
        pagingVO.setSearchWord(searchWord);
        // artGroupNo를 명시적으로 PaginationInfoVO에 설정
        pagingVO.setArtGroupNo(artGroupNo);

        log.info("### GoodsController - goodsShopList 호출: currentPage={}, searchWord={}, searchType={}, artGroupNo={}",
                 currentPage, searchWord, searchType, artGroupNo);

        // 2. 서비스 호출: 페이지네이션된 상품 목록을 가져옴
        service.retrieveUserGoodsList(pagingVO);

        log.info("### GoodsController - retrieveUserGoodsList 호출 결과: totalRecord={}, dataList.size={}",
                 pagingVO.getTotalRecord(), pagingVO.getDataList() != null ? pagingVO.getDataList().size() : 0);

        // 3. 로그인 상태 확인 및 MemberVO 추출 로직 (기존과 동일)
        MemberVO authMember = getAuthMember(principal);

        boolean isLoggedIn = (authMember != null && authMember.getMemUsername() != null && !authMember.getMemUsername().isEmpty());
        model.addAttribute("isLoggedIn", isLoggedIn);

        // ⭐ 3.5. 로그인된 사용자의 장바구니 개수 조회 및 모델에 추가 ⭐
        if (isLoggedIn && authMember != null) {
            String memUsername = authMember.getMemUsername();
            int cartItemCount = cartService.getCartItemCount(memUsername);
            model.addAttribute("cartItemCount", cartItemCount);
            log.info("### GoodsController - cartItemCount for {}: {}", memUsername, cartItemCount);
        } else {
            model.addAttribute("cartItemCount", 0); // 비로그인 시 장바구니 개수 0
        }

        // 4. 상품 리스트의 찜 여부 처리 (기존과 동일)
        if (isLoggedIn && pagingVO.getDataList() != null && authMember != null) {
            String username = authMember.getMemUsername();
            List<Integer> wishedGoodsNos = wishlistservice.getWishlistForUser(username)
                                             .stream()
                                             .map(wish -> wish.getGoodsNo())
                                             .toList();

            for (goodsVO goods : pagingVO.getDataList()) {
                goods.setWished(wishedGoodsNos.contains(goods.getGoodsNo()));
            }
        }

        // 5. 모델에 PaginationInfoVO 객체 담기
        model.addAttribute("pagingVO", pagingVO);

        // 6. 굿즈샵 공지사항 (기존과 동일)
        goodsNoticeVO noticeToShow = noticeservice.getMainNotice();
        model.addAttribute("notice", noticeToShow);

        // 7. 아티스트 그룹 목록 (기존과 동일)
        List<ArtistGroupVO> artistList = service.getArtistGroups();
        model.addAttribute("artistList", artistList);

        // 8. JSP에서 현재 정렬/필터 상태를 유지하기 위해 모델에 추가
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);
        model.addAttribute("artGroupNo", artGroupNo); // 아티스트 필터 활성화에 사용

        return "goods/main";
    }

	@GetMapping("/detail")
	public String goodsShopDetail(
			@RequestParam("goodsNo") int goodsNo,
			Model model,
			@AuthenticationPrincipal Object principal
			) throws Exception {

		MemberVO authMember = getAuthMember(principal);
		log.info("### 디버그: 주입된 principal 객체: {}", principal); // Principal 객체 타입 확인

        // authMember가 여전히 null이거나, username이 null인 경우 "비회원"으로 처리됩니다.
        model.addAttribute("memberInfo", authMember);
        log.info("상세 페이지 컨트롤러 호출! 인증된 회원 정보: {}", authMember != null ? authMember.getMemUsername(): "비회원");

        // JSP의 자바스크립트가 로그인 상태를 알 수 있도록 모델에 'isLoggedIn' 값을 추가합니다.
        boolean isLoggedIn = (authMember != null && authMember.getMemUsername() != null && !authMember.getMemUsername().isEmpty());
        model.addAttribute("isLoggedIn", isLoggedIn);

        if (isLoggedIn && authMember != null) {
            String memUsername = authMember.getMemUsername();
            int cartItemCount = cartService.getCartItemCount(memUsername); // 서비스 호출
            model.addAttribute("cartItemCount", cartItemCount); // 모델에 추가
            log.info("### GoodsController - detail cartItemCount for {}: {}", memUsername, cartItemCount);
        } else {
            model.addAttribute("cartItemCount", 0); // 비로그인 시 0으로 설정
        }

		goodsVO goods = service.getGoodsDetail(goodsNo);
		model.addAttribute("goods", goods);
		log.info("서비스에서 반환된 goodsVO: {}", goods);
		log.info("컨트롤러에서 받은 goodsNo: {}", goodsNo);

	    log.info("### DB에서 가져온 goods 객체 전체 내용: {}", goods);

		//굿즈 옵션 가져오기
		List<goodsOptionVO> optionList = service.optionList(goodsNo);
		model.addAttribute("optionList", optionList);
		log.info("옵션 목록: {}", optionList);

		return "goods/detail";
	}

	@PostMapping("/wishlist")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> toggleWishlist (
			@RequestBody Map<String, Integer> payload,
			@AuthenticationPrincipal Object principal
			) {
		Map<String, Object> response = new HashMap<>();
		MemberVO authMember = getAuthMember(principal);
		String username = null;


        // authMember가 null이 아니면 username을 가져옴
        if (authMember != null) {
            username = authMember.getMemUsername();
        }

        // 1. 로그인 여부 확인 (username이 null이면 비로그인)
        if (username == null || username.isEmpty()) { // authMember가 null일 수도 있으므로 username으로 최종 판단
            response.put("status", "error");
            response.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED); // 401 Unauthorized
        }

        Integer goodsNo = payload.get("goodsNo");

        //2. 필수 파라미터 (goodsNo) 누락 여부 확인
        if(goodsNo == null) {
        	response.put("status", "error");
        	response.put("message", "상품 번호가 누락됐습니다!");

        	return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400 에러
        }

        try {
        	//3. 현재 찜 상태 확인 (DB 조회)
			boolean isWished = wishlistservice.isGoodsWished(username, goodsNo);

			if (isWished) {
				//4-1. 이미 찜된 상태 -> 찜 해제 (삭제)
				if (wishlistservice.removeWishlist(username, goodsNo)) {
					response.put("status", "success");
					response.put("message", "찜이 해제됐습니다!");
					response.put("action", "removed");

				} else {
					response.put("status", "error");
					response.put("message", "찜 해제 실패했습니다!");

				}

			} else {
				//4-2. 찜 안 된 상태 -> 찜 추가!!
				if (wishlistservice.addWishlist(username, goodsNo)) {
					response.put("status", "success");
					response.put("message", "찜 목록에 추가됐습니다!");
					response.put("action", "added");

					 log.info(">>>>>> 컨트롤러: addWishlist 서비스 호출 성공! USER: {}, GOODS_NO: {}", username, goodsNo);
				} else {
					response.put("status", "error");
					response.put("message", "찜 추가에 실패했습니다!");
				}
			}

			return new ResponseEntity<>(response, HttpStatus.OK);
		} catch (Exception e) {
			log.error("찜 토글 중 서버 오류 발생!!!" + e.getMessage(), e);
			response.put("status", "error");
			response.put("message", "찜 처리 중 서버 오류가 발생했습니다!!");
			return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@GetMapping("/wishlist")
	public String getWishlistItem(
			Model model,
			@AuthenticationPrincipal Object principal,
			@RequestParam(name="currentPage", required = false, defaultValue = "1") int currentPage, // 페이징 추가
			@RequestParam(name="itemsPerPage", required = false, defaultValue = "10") int itemsPerPage, // 페이지당 아이템 수 (조절 가능)
			RedirectAttributes ra
			) {
		log.info("getWishlistItem() 컨트롤러 호출!!!!");

		MemberVO authMember = getAuthMember(principal);

		// 1. 로그인 여부 확인 및 비로그인 시 처리
		if (authMember == null || authMember.getMemUsername() == null || authMember.getMemUsername().isEmpty()) {
			log.warn("getWishlistPage() - 비로그인 상태 접근 시도!");
			// 로그인 페이지로 리다이렉트하면서 메시지 전달
			ra.addFlashAttribute("message", "로그인이 필요한 페이지입니다.");
			return "redirect:/login.html"; // 로그인 페이지 URL로 변경 (실제 프로젝트 경로 확인)
		}

		String username = authMember.getMemUsername();
		model.addAttribute("isLoggedIn", true); // 로그인 상태임을 JSP에 전달

		// PaginationInfoVO 객체 생성 및 설정
		PaginationInfoVO<goodsVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setScreenSize(itemsPerPage); // 한 페이지에 보여줄 찜 상품 수

		log.info("### WishlistController - getWishlistItem 호출: currentPage={}, itemsPerPage={}", currentPage, itemsPerPage);

		// 2. 찜 목록 데이터 조회 (페이징 적용)
		List<goodsVO> wishedGoodsList = new ArrayList<>(); // Collection -> List로 변경
		try {
			// 이 메서드는 PaginationInfoVO를 업데이트하고 페이징된 리스트를 반환해야 합니다.
			wishedGoodsList = wishlistservice.getWishedGoodsPagingListForUser(username, pagingVO);
			log.info("getWishlistPage() - 회원 {}의 찜 목록 상품 개수: {}", username, wishedGoodsList.size());
		} catch (Exception e) {
			log.error("getWishlistPage() - 찜 목록 조회 중 오류 발생: {}", e.getMessage(), e);
			model.addAttribute("errorMessage", "찜 목록을 불러오는 중 오류가 발생했습니다.");
		}

		// 3. 모델에 데이터 추가
		model.addAttribute("wishedGoodsList", wishedGoodsList); // JSP에서 사용할 찜 상품 목록 (dataList와 동일)
		model.addAttribute("pagingVO", pagingVO); // 페이징 정보 객체 추가

		return "goods/wishlist";
	}

	// '찜 상태 확인' 전용 GET 메소드
	@GetMapping("/wishlist/status")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getWishlistStatus(
	        // ★★★ int -> Integer, required = false 추가 ★★★
	        @RequestParam(required = false) Integer goodsNo,
	        @AuthenticationPrincipal Object principal) {

	    Map<String, Object> response = new HashMap<>();

	    // ★★★ goodsNo가 null일 경우에 대한 처리 추가 ★★★
	    // 상품번호가 아예 안 들어왔다면, 확인할 필요 없이 '찜 안함' 상태로 응답
	    // 비로그인 사용자는 항상 '찜 안함' 상태
	    if ((goodsNo == null) || (principal == null)) {
	        response.put("isWished", false);
	        return new ResponseEntity<>(response, HttpStatus.OK);
	    }

	    MemberVO authMember = getAuthMember(principal);

	    if (authMember == null || authMember.getMemUsername() == null) {
	        response.put("isWished", false);
	        return new ResponseEntity<>(response, HttpStatus.OK);
	    }

	    // 로그인 사용자일 경우, DB에서 실제 찜 상태를 확인
	    String username = authMember.getMemUsername();

	    // ★★★ 이 로그들 추가 ★★★
	    log.info(">>>>>> getWishlistStatus: DB 조회 시작 (username: {}, goodsNo: {})", username, goodsNo);
	    boolean isWished = wishlistservice.isGoodsWished(username, goodsNo);
	    log.info(">>>>>> getWishlistStatus: DB 조회 결과 isWished = {}", isWished);

	    response.put("isWished", isWished);
	    return new ResponseEntity<>(response, HttpStatus.OK);
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
