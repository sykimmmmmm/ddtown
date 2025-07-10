package kr.or.ddit.ddtown.controller.emp.membership;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.member.membership.IMembershipService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.member.membership.MembershipDescriptionVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/emp/membership/des")
public class MembershipDesController {

	@Autowired
	private IMembershipService membershipService;

	// 멤버십 플랜 리스트 화면 조회
	@GetMapping("/list")
	public String membershipDesList(
			@RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(name = "searchWord", required = false) String searchWord,
			Principal principal,
			Model model
			) {
		log.info("직원 멤버십 플랜 목록 요청");

		PaginationInfoVO<MembershipDescriptionVO> pagingVO = new PaginationInfoVO<>(9, 5);
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setSearchWord(searchWord);

		// 현재 로그인한 직원 아이디 조회
		String empUsername = principal.getName();
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		boolean isAdmin = authentication.getAuthorities().stream()
										.anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
		log.info("로그인한 직원 ID: {}",empUsername);
		log.info("현재 사용자는 관리자입니다 (isAdmin): {}", isAdmin);

		try {
			int totalRecord = membershipService.selectTotalDesRecord(pagingVO);
			pagingVO.setTotalRecord(totalRecord);

			log.info("totalRecord : {}", totalRecord);

			List<MembershipDescriptionVO> list = membershipService.selectMembershipDesList(pagingVO, empUsername);
			pagingVO.setDataList(list);

			model.addAttribute("pagingVO", pagingVO);
			model.addAttribute("empUsername", empUsername);
			model.addAttribute("isAdmin", isAdmin);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "emp/membership/des/list";
	}

	// 플랜 생성 시, 아티스트 그룹 목록 JSON으로 변환하는 API 엔드포인트 추가
	@GetMapping("/api/artist-groups/all")
	@ResponseBody
	@Transactional
	public ResponseEntity<List<ArtistGroupVO>> getAlltArtistGroupForModal() {
		log.info("아티스트 그룹 목록 API 요청 (모달용)");
		try {
			List<ArtistGroupVO> artistGroups = membershipService.getArtistGroupListAll();

			if(artistGroups != null && !artistGroups.isEmpty()) {
				return ResponseEntity.ok(artistGroups);				// 성공
			} else {
				return ResponseEntity.noContent().build();			// 204 또는 빈 리스트 반환
			}
		} catch (Exception e) {
			log.error("아티스트 그룹 목록 조회 중 오류 발생: {}", e.getMessage());
			e.printStackTrace();
			return ResponseEntity.internalServerError().build();	// 500 error 반환
		}
	}

	// 플랜 등록
	@PostMapping("/register")
	@ResponseBody
	@Transactional
	public ResponseEntity<Map<String, Object>> registerMembershipDes(
			@RequestBody MembershipDescriptionVO desVO, Principal principal
			) {
		log.info("직원 멤버십 플랜 등록 요청");

		String logEmpUsername = null;

		if(principal != null) {
			logEmpUsername = principal.getName();
		}

		Map<String, Object> serviceResult = membershipService.registerMembershipDes(desVO, logEmpUsername);

		if((boolean) serviceResult.get("success")) {
			return ResponseEntity.ok(serviceResult);
		} else {
			String message = (String) serviceResult.get("message");
			if (message.contains("권한이 없습니다")) { // 예시: 메시지 내용으로 권한 에러 판단
                return ResponseEntity.status(403).body(serviceResult);
            } else if (message.contains("선택되지 않았습니다")) { // 예시: 메시지 내용으로 Bad Request 판단
                return ResponseEntity.status(400).body(serviceResult);
            } else {
                return ResponseEntity.internalServerError().body(serviceResult);
            }
		}
	}

	// 플랜 수정
	@PostMapping("/update")
	@ResponseBody
	@Transactional
	public ResponseEntity<Map<String, Object>> modifyMembershipDes(
			@RequestBody MembershipDescriptionVO desVO, Principal principal
			) {
		log.info("직원 멤버십 플랜 수정 요청");

		String logEmpUsername = null;

		if(principal != null) {
			logEmpUsername = principal.getName();
		}

		Map<String, Object> serviceResult = membershipService.modifyMembershipDes(desVO, logEmpUsername);

		if((boolean) serviceResult.get("success")) {
			return ResponseEntity.ok(serviceResult);
		} else {
			String message = (String) serviceResult.get("message");
			if (message.contains("권한이 없습니다")) { // 예시: 메시지 내용으로 권한 에러 판단
                return ResponseEntity.status(403).body(serviceResult);
            } else if (message.contains("선택되지 않았습니다")) { // 예시: 메시지 내용으로 Bad Request 판단
                return ResponseEntity.status(400).body(serviceResult);
            } else {
                return ResponseEntity.internalServerError().body(serviceResult);
            }
		}
	}

	// 플랜 삭제
	@PostMapping("/delete/{mbspNo}")
	@ResponseBody
	@Transactional
	public ResponseEntity<Map<String, Object>> deleteMembershipDes(
			@PathVariable("mbspNo") int mbspNo,
			Principal principal
			) {
		Map<String, Object> response = new HashMap<>();
		String currentEmpUsername = principal.getName();

		try {
			ServiceResult result = membershipService.deleteMembershipDes(mbspNo, currentEmpUsername);

			if (result == ServiceResult.OK) { // 삭제 성공
                response.put("success", true);
                response.put("message", "멤버십 플랜이 성공적으로 삭제되었습니다.");
                return ResponseEntity.ok(response);
            } else if (result == ServiceResult.FAILED) { // 삭제 실패 (DB 처리 문제 등)
                response.put("success", false);
                response.put("message", "멤버십 플랜 삭제에 실패했습니다.");
                return ResponseEntity.status(400).body(response); // Bad Request
            } else if (result == ServiceResult.NOTEXIST) { // 권한 없음
                response.put("success", false);
                response.put("message", "이 멤버십 플랜의 담당자가 아니므로 삭제할 권한이 없습니다.");
                return ResponseEntity.status(403).body(response); // NOTEXIST
            } else { // 기타 알 수 없는 결과
                response.put("success", false);
                response.put("message", "알 수 없는 오류로 인해 삭제에 실패했습니다.");
                return ResponseEntity.status(500).body(response);
            }
		}catch (Exception e) {
			response.put("success", false);
			response.put("message", "서버 오류로 인해 멤버십 플랜 삭제에 실패했습니다.");
			return ResponseEntity.status(500).body(response);
		}
	}



	/**
	 * 통계용 멤버십 인기 플랜 top3 : 구독자 수
	 * @param param
	 * @return
	 */
	@GetMapping(value = "/chartData/topPopularMemberships", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public List<MembershipDescriptionVO> getTopPopularMembershipsChartData() {
		return membershipService.getTopPopularMemberships();
	}

	/**
	 * 월별 멤버십 플랜 매출
	 * @return
	 */
	@GetMapping(value = "/chartData/monthlySalesTrend", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public List<MembershipDescriptionVO> getMonthlySalesTrendChartData() {
		return membershipService.getMonthlySalesTrendChartData();
	}

}


































