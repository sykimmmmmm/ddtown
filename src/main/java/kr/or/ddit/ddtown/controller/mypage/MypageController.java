package kr.or.ddit.ddtown.controller.mypage;

import java.security.Principal;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
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
import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.alert.IAlertService;
import kr.or.ddit.ddtown.service.auth.IUserService;
import kr.or.ddit.ddtown.service.follow.IFollowService;
import kr.or.ddit.ddtown.service.goods.order.IOrderService;
import kr.or.ddit.ddtown.service.member.membership.IMembershipService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.alert.AlertSettingVO;
import kr.or.ddit.vo.alert.AlertVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.member.membership.MembershipSubscriptionsVO;
import kr.or.ddit.vo.order.OrdersVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.EmployeeVO;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mypage")
public class MypageController {

	@Autowired
	private IUserService userService;

	@Autowired
	private IAlertService alertService;

	@Autowired
	private IFollowService followService;

	@Autowired
	private IMembershipService membershipService;

	@Autowired
	private IOrderService orderService;

	/**
	 * 로그인한 회원정보 가져오기
	 * @return
	 */
	private MemberVO getCurrentUser() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberVO memberVO = null;
		if(authentication != null && authentication.isAuthenticated()) {
			Object principal = authentication.getPrincipal();

			if(principal instanceof CustomUser customUser) {
				if (customUser.getMemberVO() != null) {
					memberVO = customUser.getMemberVO();
					log.debug("현재 유저 타입 : MEMBER, 회원 - {}", memberVO.getUsername());
				} else if(customUser.getEmployeeVO() != null) {
					EmployeeVO employeeVO = customUser.getEmployeeVO();
					log.debug("현재 유저 타입 : EMPLOYEE, 직원 - {}", employeeVO.getUsername());

					memberVO = new MemberVO();
					memberVO.setUsername(employeeVO.getUsername());
					memberVO.setMemUsername(employeeVO.getUsername());
					memberVO.setPeoName(employeeVO.getPeoName());
					memberVO.setUserTypeCode(employeeVO.getUserTypeCode());
				}
			} else if(principal instanceof CustomOAuth2User auth2User) {
				memberVO = auth2User.getMemberVO();
			} else if(principal instanceof MemberVO vo) {
				memberVO = vo;
			} else {
				log.error("로그인정보 조회중 오류");
			}
		}
		return memberVO;
	}

	/**
     * 현재 인증된 사용자의 username 반환
     * @return username 아니면 null
     */
    private String getCurrentUsername() {
        MemberVO memberVO = getCurrentUser();
        return (memberVO != null) ? memberVO.getUsername() : null;
    }


	@GetMapping({"", "/info"})
	public String mypageProfileEdit(Model model, RedirectAttributes ra) {
		log.info("mypageProfileEdit() 실행...!");
		MemberVO memberVO = getCurrentUser();

		if(memberVO == null) {
			ra.addFlashAttribute("errorMessage", "로그인 해주세요!!");
			return "redirect:/login";
		}

		try {
			memberVO = userService.getMemberInfo(memberVO.getUsername());
			log.info("memberVO: {}", memberVO);

			if (memberVO == null) {
				model.addAttribute("errorMessage", "회원 정보를 찾을 수 없음!!");
            }

            model.addAttribute("memberVO", memberVO);		//  폼에 바인딩
            model.addAttribute("pageTitle", "개인정보 관리");
            model.addAttribute("currentPage", "profile");
		} catch (Exception e) {
			log.error("프로필 수정 중 오류", e);
			model.addAttribute("errorMessage", "회원 정보를 불러오는 중 오류 발생!!");
		}
		return "mypage/mypageMain";
	}

	@PostMapping("/profile/verifyPassword")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> verifyCurrentPassword(@RequestParam String currentPassword){
		Map<String, Object> resp = new HashMap<>();
		MemberVO memberVO = getCurrentUser();

		if(memberVO == null) {
			resp.put("success", false);
			resp.put("message", "로그인 해주세요!!");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(resp);
		}

		try {
			boolean isValid = userService.verifyCurrentPassword(memberVO.getUsername(), currentPassword);
			resp.put("success", isValid);
			resp.put("message", isValid ? "비밀번호가 확인되었습니다." : "비밀번호가 일치하지 않습니다.");
			return ResponseEntity.ok(resp);
		} catch (Exception e) {
			log.error("현재 비밀번호 확인 중 오류!!");
			resp.put("success", false);
			resp.put("message", "오류 발생!!" + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);
		}
	}

	@PostMapping("/profile/update")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> profileUpdate(@RequestBody MemberVO memberVO) {
		log.info("profileUpdate() 실행...!");

		Map<String, Object> resp = new HashMap<>();
		MemberVO currentLoggedInUser = getCurrentUser();

		if(currentLoggedInUser == null) {
			resp.put("success", false);
			resp.put("message", "로그인 해주세요!!");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(resp);
		}

		memberVO.setUsername(currentLoggedInUser.getUsername());
		memberVO.setMemUsername(currentLoggedInUser.getUsername());

		try {
			ServiceResult result = userService.updateMemberInfo(memberVO);
			if(result == ServiceResult.OK) {
				resp.put("success", true);
				resp.put("message", "개인정보 수정 성공!!");

				MemberVO updatedProfile = userService.getMemberInfo(memberVO.getUsername());
				resp.put("updatedProfile", updatedProfile);
				return ResponseEntity.ok(resp);
			} else {
				resp.put("success", false);
				resp.put("message", "개인정보 수정 실패..");
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);
			}
		} catch (Exception e) {
			log.error("프로필 수정 처리중 오류", e);
			resp.put("success", false);
			resp.put("message", "개인정보 수정중 오류 발생!!" + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);

		}
	}

	@ResponseBody
	@PostMapping("/nickCheck")
	public ResponseEntity<String> nickCheck(@RequestBody Map<String, String> param) {
		log.info("nickCheck 실행!");
		String memNicknm = param.get("memNicknm");

		ServiceResult result = userService.nickCheck(memNicknm);
		return new ResponseEntity<>(result.toString(),HttpStatus.OK);
	}
	@ResponseBody
	@PostMapping("/emailCheck")
	public ResponseEntity<String> emailCheck(@RequestBody Map<String, String> param) {
		log.info("emailCheck 실행!");
		String peoEmail = param.get("peoEmail");

		ServiceResult result = userService.emailCheck(peoEmail);
		return new ResponseEntity<>(result.toString(),HttpStatus.OK);
	}

	@PostMapping("/password/update")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> passwordUpdate(
            @RequestBody Map<String, String> payload, HttpServletRequest request
            ) {

        Map<String, Object> response = new HashMap<>();
        MemberVO memberVO = getCurrentUser();
        if (memberVO == null) {
        	return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        String currentPassword = payload.get("currentPassword");
        String newPassword = payload.get("newPassword");
        String confirmNewPassword = payload.get("confirmNewPassword");

        if (StringUtils.isAnyBlank(currentPassword, newPassword, confirmNewPassword) || !newPassword.equals(confirmNewPassword)) {
            response.put("success", false);
            response.put("message", "입력값을 확인해주세요. 새 비밀번호와 확인 비밀번호가 일치해야 합니다.");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            ServiceResult result = userService.changePassword(memberVO.getUsername(), currentPassword, newPassword);
            if (result == ServiceResult.OK) {
                response.put("success", true);
                response.put("message", "비밀번호가 성공적으로 변경되었습니다. 다음 로그인부터 적용됩니다.");

            } else if (result == ServiceResult.INVALIDPASSWORD) {
                response.put("success", false);
                response.put("message", "현재 비밀번호가 일치하지 않습니다.");
            } else {
                response.put("success", false);
                response.put("message", "비밀번호 변경에 실패했습니다.");
            }
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("비밀번호 변경 처리 중 오류", e);
            response.put("success", false);
            response.put("message", "비밀번호 변경 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

	@PostMapping("/withdraw")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> memberWithdrawal(
            @RequestBody Map<String, String> payload, // JSON 요청으로 변경
            HttpServletRequest request) {
		log.info("memberWithdrawal() 실행...!!");
        Map<String, Object> response = new HashMap<>();
        MemberVO memberVO = getCurrentUser();
        if (memberVO == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다. 다시 로그인해주세요.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        String confirmationText = payload.get("confirmationText");
        if (confirmationText == null || confirmationText.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "문구를 정확히 입력해주세요.");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            ServiceResult result = userService.deleteMember(memberVO.getUsername(), confirmationText);
            if (result == ServiceResult.OK) {
                // 세션 무효화
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                SecurityContextHolder.clearContext();		// 시큐리티 클리어
                response.put("success", true);
                response.put("message", "회원 탈퇴가 성공적으로 처리되었습니다. 이용해주셔서 감사합니다.");
                response.put("redirectUrl", request.getContextPath() + "/"); // 메인 페이지로 리다이렉트할 URL
            } else {
                response.put("success", false);
                response.put("message", "입력하신 확인 문자열이 일치하지 않거나, 탈퇴 처리 중 문제가 발생했습니다.");
            }
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("회원 탈퇴 처리 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "회원 탈퇴 처리 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

	@GetMapping("/alerts")
	public String alertList(
			Model model,
			@RequestParam(name="currentPage", required = false, defaultValue="1") int currentPage,
			@RequestParam(name="artGroupNo", required = false) Integer artGroupNo	// 아티스트 그룹 필터링용
			) {
		log.info("alertList() 실행...!");
		String username = getCurrentUsername();

		PaginationInfoVO<AlertVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setScreenSize(10);
		pagingVO.setMemUsername(username);
		pagingVO.setArtGroupNo(artGroupNo);

		try {
			List<AlertVO> alertList = alertService.getAlertsByUsername(pagingVO);

			pagingVO.setDataList(alertList);

			int unreadCount = alertService.getUnreadAlertCnt(username);

			List<ArtistGroupVO> followedGroups = followService.getFollowedArtistGroups(username);

			model.addAttribute("pagingVO", pagingVO);		// pagingVO 객체전달
			model.addAttribute("unreadCount", unreadCount);		// 안읽은 개수
			model.addAttribute("pageTitle", "알림 내역");		// 페이지명
			model.addAttribute("followedGroups", followedGroups);
			model.addAttribute("selectedArtGroupNo", artGroupNo);
			model.addAttribute("currentPage", "alerts");
		} catch (Exception e) {
			log.error("회원 {}의 알림 내역 조회중 오류발생!!", username, e);
			model.addAttribute("errorMessage", "알림 내역 불러오는중 오류발생!!");
		}
		return "mypage/mypageMain";
	}

	@GetMapping("/alerts/settings")
	public String alertSettingsPage(Model model) {
		log.info("alertSettingsPage() 실행...!");
		String username = getCurrentUsername();

		try {
			List<AlertSettingVO> settings = alertService.getAlertSettings(username)
					.map(list -> (List<AlertSettingVO>)(list != null ? list : Collections.emptyList()))
					.orElse(Collections.emptyList());
			log.debug("alertSettings: {}", settings);
			model.addAttribute("alertSettings", settings);
			model.addAttribute("pageTitle", "알림 설정");
			model.addAttribute("currentPage", "alertSettings");

		} catch (Exception e) {
			log.error("회원 {}의 알림 설정을 불러오는중 오류 발생!!!", username, e.getMessage());
			model.addAttribute("errorMessage", "알림 설정 불러오는중 오류 발생!!");
		}
		return "mypage/mypageMain";
	}


	@PostMapping("/alerts/read")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> markAlertAsRead(@RequestParam long alertNo){
		log.info("markAlertAsRead() 실행...!");
		Map<String, Object> resp = new HashMap<>();
		String username = getCurrentUsername();

		try {
			boolean success = alertService.markAsRead(alertNo, username);
			resp.put("success", success);
			resp.put("message", success ? "알림 읽음 처리 완료!" : "처리할 알림이 없습니다..");
			return ResponseEntity.ok(resp);

		} catch (Exception e) {
			log.error("알림 읽음 처리중 오류발생..");
			resp.put("success", false);
			resp.put("message", "알림 읽음 처리 중 오류 발생..");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);
		}
	}


	@PostMapping("/alerts/readAll")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> markAllAlertAsRead(){
		Map<String, Object> resp = new HashMap<>();
		String username = getCurrentUsername();

		try {
			alertService.markAllAsRead(username);
			resp.put("success", true);
			resp.put("message", "모든 알림을 읽음처리 후 삭제했습니다.");
			return ResponseEntity.ok(resp);

		} catch (Exception e) {
			log.error("모든 알림 읽음 처리 오류 : 회원 - {}", username, e.getMessage());
			resp.put("success", false);
			resp.put("message", "모든 알림 읽음 처리 중 오류 발생!!");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);
		}
	}

	@GetMapping("/alerts/setting")
	@ResponseBody
	public ResponseEntity<List<AlertSettingVO>> getAlertSettings(){
		log.info("getAlertSettings() 실행...!");
		String memUsername = getCurrentUsername();
		if(memUsername == null) {
			memUsername = SecurityContextHolder.getContext().getAuthentication().getName();
		}

		try {
			List<AlertSettingVO> settings = alertService.getAlertSettings(memUsername)
					.map(list -> (List<AlertSettingVO>)(list != null ? list : Collections.emptyList()))
					.orElse(Collections.emptyList());
			log.debug("초기 알림 설정 : {}", settings);
			if(settings.isEmpty()) {
				log.warn("회원 {}의 알림 설정 비어있음", memUsername);
			}
			return ResponseEntity.ok(settings);
		} catch (Exception e) {
			log.error("회원 {}의 알림 설정 조회중 오류 발생!!", memUsername, e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Collections.emptyList());
		}
	}

	@PostMapping("/alerts/setting/save")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> saveAlertSettings(@RequestBody List<AlertSettingVO> settings){
		log.info("saveAlertSettings() 실행..!");
		Map<String, Object> resp = new HashMap<>();

		String memUsername = getCurrentUsername();
		try {
			if(memUsername == null) {
				memUsername = SecurityContextHolder.getContext().getAuthentication().getName();
			}

			log.debug("수신된 알림 설정: {}", settings);

			if(settings == null || settings.isEmpty()) {
				throw new IllegalArgumentException("알림 설정 데이터가 비어있습니다.");
			}

			for(AlertSettingVO setting : settings) {
				if(setting.getMemUsername() == null) {
					setting.setMemUsername(memUsername);
					log.debug("memUsername을 {}으로 설정", memUsername);
				}
				if(setting.getAlertTypeCode() == null) {
					throw new IllegalArgumentException("alertTypeCode가 누락되었습니다: " + setting);
				}
			}

			alertService.saveAlertSettings(settings, memUsername);
			resp.put("success", true);
			resp.put("message", "알림 설정이 저장되었습니다.");
			return ResponseEntity.ok(resp);

		} catch (Exception e) {
			log.error("알림 설정 저장 오류: 회원 - {}", memUsername, e.getMessage());
			resp.put("success", false);
			resp.put("message", "알림 설정 저장 중 오류 발생!!!");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);
		}
	}

	@PostMapping("/alerts/delete")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteAlert(@RequestParam long alertNo){
		log.info("deleteAlert() 실행...!");
		Map<String, Object> resp = new HashMap<>();
		String username = getCurrentUsername();

		try {
			boolean success = alertService.markAsDeleted(alertNo, username);

			resp.put("success", success);
			resp.put("message", success ? "알림 삭제 성공!!" : "삭제할 알림이 없습니다..");
			return ResponseEntity.ok(resp);

		} catch (Exception e) {
			log.error("알림 삭제 실패.. 회원 - {}, 알림번호 - {}", username, alertNo);
			resp.put("success", false);
			resp.put("message", "알림 삭제 처리중 오류발생!!");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);
		}
	}

	@PostMapping("/alerts/readAndDelete")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> readAndDeleteAlert(@RequestParam long alertNo){
		log.info("readAndDeleteAlert() 실행...!");
		Map<String, Object> resp = new HashMap<>();
		String username = getCurrentUsername();

		try {
			// 읽음 처리와 삭제 처리를 순차적으로 실행
			boolean readSuccess = alertService.markAsRead(alertNo, username);
			boolean deleteSuccess = alertService.markAsDeleted(alertNo, username);

			boolean success = readSuccess && deleteSuccess;
			resp.put("success", success);
			resp.put("message", success ? "알림 읽음 처리 및 삭제 완료!" : "처리할 알림이 없습니다..");
			return ResponseEntity.ok(resp);

		} catch (Exception e) {
			log.error("알림 읽음 처리 및 삭제 실패.. 회원 - {}, 알림번호 - {}", username, alertNo);
			resp.put("success", false);
			resp.put("message", "알림 처리 중 오류발생!!");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);
		}
	}

	/**
     * 최신 알림 및 안 읽은 알림 개수를 조회하는 엔드포인트
     */
    @GetMapping("/alerts/latestAndUnreadCnt")
    @ResponseBody // JSON 형태로 데이터를 반환하기 위해 필요
    public ResponseEntity<Map<String, Object>> getLatestAndUnreadAlerts(@RequestParam(required = false) Integer artGroupNo) {
        log.info("getLatestAndUnreadAlerts() 실행...!");
        Map<String, Object> resp = new HashMap<>();
        String username = getCurrentUsername(); // 현재 로그인한 사용자 ID 가져오는 메서드 (MypageController에 있다고 가정)

        if (username == null) {
            resp.put("success", false);
            resp.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(resp);
        }

        try {

        	PaginationInfoVO<AlertVO> pagingVO = new PaginationInfoVO<>();
        	pagingVO.setCurrentPage(1);
        	pagingVO.setScreenSize(5);
        	pagingVO.setMemUsername(username);
        	pagingVO.setArtGroupNo(artGroupNo);


            // 여기에 최신 알림 데이터를 가져오는 로직
            List<AlertVO> latestAlerts = alertService.getAlertsByUsername(pagingVO); // 예시: 최신 5개 알림

            // 안 읽은 알림 개수 가져오기
            int unreadCount = alertService.getUnreadAlertCnt(username);

            resp.put("success", true);
            resp.put("latestAlerts", latestAlerts); // 필요하다면 최신 알림 목록도 추가
            resp.put("unreadCount", unreadCount);
            return ResponseEntity.ok(resp);

        } catch (Exception e) {
            log.error("알림 개수 조회 중 오류 발생: 회원 - {}", username, e); // 예외 전체를 로깅하는 것이 더 좋습니다.
            resp.put("success", false);
            resp.put("message", "알림 정보를 가져오는 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);
        }
    }

    @GetMapping("/memberships")
    public String getMyMembershipList(Model model, Principal principal,
    		@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {
    	log.info("getMyMembershipList 실행 !!");

    	// 현재 로그인한 사용자 조회
    	String username = principal.getName();

    	try {

    		PaginationInfoVO<MembershipSubscriptionsVO> pagingVO = new PaginationInfoVO<>(3, 5);	// 한 페이지 당 3개
    		pagingVO.setCurrentPage(currentPage);
    		pagingVO.setMemUsername(username);

    		int totalRecord = membershipService.getMySubTotalRecord(pagingVO);
    		pagingVO.setTotalRecord(totalRecord);

    		log.info("totalRecord: {}", totalRecord);

    		// 사용자의 멤버십 구독 리스트 조회
    		List<MembershipSubscriptionsVO> myMemberships = membershipService.getMyMembershipList(pagingVO);
    		pagingVO.setDataList(myMemberships);

    		model.addAttribute("pagingVO", pagingVO);
    		model.addAttribute("pageTitle", "APT 구독현황");
    		model.addAttribute("currentPage", "subDetail");

    	} catch (Exception e) {
    		log.error("getMyMembershipList 중 오류 발생", e);
		}
        return "mypage/mypageMain";
    }

    /**
     * 마이페이지 주문 내역을 조회하고 페이징 처리합니다.
     * PaginationInfoVO의 기존 필드를 재활용하며, URL 구성은 JSP의 자바스크립트에서 처리합니다.
     */
    @GetMapping("/orders")
    public String myOrders(
            @AuthenticationPrincipal Object principal,
            @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(name = "searchWord", required = false) String searchWord,           // 주문번호 또는 상품명 검색어
            // ⭐⭐⭐ 이 라인을 제거하거나 주석 처리합니다. ⭐⭐⭐
            // @RequestParam(name = "searchStatType", required = false) String searchStatType,   // 주문 상태 코드 (예: 'ORD01', 'ORD02' 등)
            @RequestParam(name = "orderDateStart", required = false) String orderDateStart,   // 주문일자 시작
            @RequestParam(name = "orderDateEnd", required = false) String orderDateEnd,       // 주문일자 종료
            HttpServletRequest request,
            Model model) {

        String memUsername = getCurrentUsername();

        if (memUsername == null) {
            // 로그인되지 않은 경우 처리
            return "redirect:/login";
        }

        // ⭐⭐⭐ 여기를 수정합니다. ⭐⭐⭐
        // 사용자가 선택하는 것이 아니라, 특정 주문 상태만 보여주고 싶다면 여기에 해당 상태 코드를 직접 설정합니다.
        // 예시: "결제 완료" 상태만 보여주고 싶다면 "ORD02" (실제 상태 코드에 맞게 변경)
        // 모든 주문 상태를 다 보여주고 싶다면 아래 변수를 null 또는 빈 문자열로 둡니다.
        String fixedSearchStatType = null; // 모든 상태를 보여줄 경우
        // String fixedSearchStatType = "ORD02"; // '결제 완료' 상태만 보여줄 경우 (예시)
        // String fixedSearchStatType = "ORD05"; // '배송 완료' 상태만 보여줄 경우 (예시)


        PaginationInfoVO<OrdersVO> pagingVO = new PaginationInfoVO<>();
        pagingVO.setCurrentPage(currentPage);
        pagingVO.setScreenSize(10);
        pagingVO.setMemUsername(memUsername);     // 회원 ID 설정
        pagingVO.setSearchWord(searchWord);       // 검색어 (주문번호/상품명)
        // ⭐⭐⭐ 수정: 요청 파라미터가 아닌, 위에서 설정한 fixedSearchStatType 값을 사용 ⭐⭐⭐
        pagingVO.setSearchStatType(fixedSearchStatType);

        Map<String, Object> searchMap = new HashMap<>();
        searchMap.put("memUsername", memUsername);
        if (searchWord != null && !searchWord.isEmpty()) {
            searchMap.put("searchWord", searchWord);
        }
        // ⭐⭐⭐ 수정: fixedSearchStatType이 null이 아니라면 searchMap에 추가 ⭐⭐⭐
        if (fixedSearchStatType != null && !fixedSearchStatType.isEmpty()) {
            searchMap.put("searchStatType", fixedSearchStatType);
        }
        if (orderDateStart != null && !orderDateStart.isEmpty()) {
            searchMap.put("orderDateStart", orderDateStart);
        }
        if (orderDateEnd != null && !orderDateEnd.isEmpty()) {
            searchMap.put("orderDateEnd", orderDateEnd);
        }
        pagingVO.setSearchMap(searchMap);

        int totalRecord = orderService.selectMyOrderCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        pagingVO.calculatePaging();

        List<OrdersVO> orderList = orderService.selectMyOrderList(pagingVO);
        pagingVO.setDataList(orderList);

        log.info("myOrders.totalRecord: " + pagingVO.getTotalRecord());
        log.info("myOrders.totalscreenSize: " + pagingVO.getScreenSize());

        model.addAttribute("orderPagingVO", pagingVO);
        model.addAttribute("contextPath", request.getContextPath());

        model.addAttribute("currentSearchWord", searchWord);
        model.addAttribute("currentSearchStatType", fixedSearchStatType);
        model.addAttribute("currentOrderDateStart", orderDateStart);
        model.addAttribute("currentOrderDateEnd", orderDateEnd);
        model.addAttribute("currentPage", "orderList");

        model.addAttribute("pagingHTML", pagingVO.getPagingHTML());

        return "mypage/mypageMain";
    }
}
