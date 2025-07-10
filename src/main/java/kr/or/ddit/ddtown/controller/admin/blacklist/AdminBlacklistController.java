package kr.or.ddit.ddtown.controller.admin.blacklist;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.admin.blacklist.IBlacklistService;
import kr.or.ddit.ddtown.service.admin.report.IReportService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.blacklist.BlacklistVO;
import kr.or.ddit.vo.report.ReportVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/community/blacklist")

public class AdminBlacklistController {

	@Autowired
	private IBlacklistService blacklistService;

	@Autowired
	private IReportService reportService;

	//목록페이지 이동
	@GetMapping("/list")
	public String blackListMain(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(name = "searchCode", required = false, defaultValue = "all") String searchCode,
	        @RequestParam(name = "searchWord", required = false, defaultValue = "") String searchWord,				//검색어
	        @RequestParam(name = "badgeSearchType", required = false, defaultValue = "") String badgeSearchType,	//뱃지
			Model model) {
		log.info("currentPage: {}, searchCode: {}, searchWord: {}", currentPage, searchCode, searchWord);

		PaginationInfoVO<BlacklistVO> pagingVO = new PaginationInfoVO<>();

		pagingVO.setSearchCode(searchCode);
		pagingVO.setSearchWord(searchWord);
		pagingVO.setBadgeSearchType(badgeSearchType);

		pagingVO.setCurrentPage(currentPage);

		int totalRecord = blacklistService.selectBlacklistCount(pagingVO);	// 블랙리스트 목록 수(리스트)
		pagingVO.setTotalRecord(totalRecord); //총 게시글 수 전달 후, 총 페이지 수 설정

		int fixedScreenSize = 10;

		int startRow = (currentPage - 1) * fixedScreenSize + 1;
	    int endRow = currentPage * fixedScreenSize;
		pagingVO.setStartRow(startRow); // 계산된 startRow 설정
	    pagingVO.setEndRow(endRow);     // 계산된 endRow 설정

	    // 1. "총 차단" 수를 위한 파라미터 맵 생성(검색영향X)
	    Map<String, Object> totalCountParams = new HashMap<>();
	    int totalBlakcCount = blacklistService.totalBlakcCount(totalCountParams);

		// 2. 현재 블랙리스트 수
		int blacklistCnt = blacklistService.blacklistCnt();
		// 3. 블랙리스트 사유별 수(뱃지)
		 Map<String, Integer> blackReasonCnts = blacklistService.blackReasonCnts();

		log.info("blacklist() 실행...!");
		//리스트목록 불러오기
		List<BlacklistVO> blackList = blacklistService.blackList(pagingVO);
		log.info("컨트롤러에서 Model에 추가할 blacklistReasonCounts: {}", blackReasonCnts);
		pagingVO.setDataList(blackList);

		log.info("가져온 신고 리스트: {}", blackList);
		model.addAttribute("blackList", blackList);
		model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchCode", searchCode);
        model.addAttribute("searchWord", searchWord);
        model.addAttribute("totalBlackCount", totalRecord);
		model.addAttribute("blacklistCnt", blacklistCnt);
		model.addAttribute("blackReasonCnts", blackReasonCnts);
		model.addAttribute("badgeSearchType", badgeSearchType);
		model.addAttribute("totalBlakcCount", totalBlakcCount);

		return "admin/blacklist/blacklistList";
	}
	//상세페이지
	@GetMapping("/detail")
	public String blackListDetail(int banNo,
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,	//상세 페이지의 신고내역 페이징
			Model model) {
		//블랙리스트 유저 상세내용
		BlacklistVO blacklistVO = blacklistService.blackDetail(banNo);
		log.info("가져온 신고자-----------------------: {}", blacklistVO);
		//신고 리스트 담기위한
		List<ReportVO> userReports = null;
		//블랙 유저 정보가 null이 아니면
		if(blacklistVO != null) {
			//블랙 유저의 이름 불러오기
			String memId = blacklistVO.getMemUsername();
			//페이징 적용
			PaginationInfoVO<ReportVO> pagingVO = new PaginationInfoVO<>();
			pagingVO.setCurrentPage(currentPage);
			//유저 이름과 페이징 정보 넘겨 유저의 신고 당한 목록 수 가지고 오기
			int totalCount = reportService.countUserReports(memId, pagingVO);
			pagingVO.setTotalRecord(totalCount);
			model.addAttribute("totalReportCount", totalCount);
			//페이징 관련 내용
			int fixedScreenSize = 10;

			int startRow = (currentPage - 1) * fixedScreenSize + 1;
		    int endRow = currentPage * fixedScreenSize;
			pagingVO.setStartRow(startRow); // 계산된 startRow 설정
		    pagingVO.setEndRow(endRow);     // 계산된 endRow 설정
			//유저의 신고당한 목록 정보 불러오기
			userReports = reportService.userReports(memId, pagingVO);
			model.addAttribute("pagingVO", pagingVO);
		}

		model.addAttribute("blacklist", blacklistVO);
		model.addAttribute("userReports", userReports);
		return "admin/blacklist/blacklistDetail";
	}
	//등록페이지
	@GetMapping("/form")
	public String blackListForm(@RequestParam(value = "reportNo", required = false) Integer reportNo, Model model) {
		//신고 상세페이지에서 블랙리스트 추가 버튼 클릭시 신고 회원 아이디와 정보가 같이 넘어오기 위함
		if(reportNo != null) {		//신고 번호가 있을 경우
			//해당 신고번호의 상세정보 가지고 오기
			ReportVO report = blacklistService.getReportDetail(reportNo);
			//신고 정보가 존재하면
			if(report != null) {
				//모델에 추가하여 View로 전달
				model.addAttribute("report", report);
			}else {		//신고 정보가 없을 경우 해당 메시지 전달
				 model.addAttribute("errorMessage", "해당 신고에 대한 회원 정보를 찾을 수 없습니다.");
			}
		}
		return "admin/blacklist/blacklistForm";
	}

	//등록하기
	@PostMapping("/signup")
	public String blackListInsert(BlacklistVO blacklistVO, Model model, RedirectAttributes ra, Principal principal) {
		// 이동할 페이지 경로를 저장할 변수
		String goPage = "";
		//관리자 아이디 가져오기
		String empUsername = principal.getName();
		log.info("auditionInsert->empUsername : {}", empUsername);
		//관리자 아이디 blacklistVO에 넣기
		blacklistVO.setEmpUsername(empUsername);

		log.info("register->auditionVO : {}", blacklistVO);
		//유효성 검사를 위한 에러맵 생성
		Map<String, String> errors = new HashMap<>();

		if(StringUtils.isBlank(blacklistVO.getMemUsername())) {
			errors.put("MemUsername", "신고아이디를 입력해주세요!");
		}
		if(StringUtils.isBlank(blacklistVO.getBanReasonDetail())) {
			errors.put("BanReasonDetail", "상세내용을 입력해주세요!");
		}
		//유효성 검사에서 에러가 있다면 실행
		if(errors.size() > 0 ) {
			model.addAttribute("bodyText", "register-page");
			model.addAttribute("errors", errors);
			model.addAttribute("blacklistVO", blacklistVO);
			goPage = "redirect:/admin/community/blacklist/form";
		}else {		//에러가 없다면
			ServiceResult result;
			try {
				result = blacklistService.blackSignup(blacklistVO);		//등록 실행

				log.info("=====================================================1 :{}", result);
				if(result.equals(ServiceResult.OK)) {						//등록하기 성공 시
					log.info("=====================================================2 ");
					ra.addFlashAttribute("message", "등록이 완료되었습니다!");
					goPage = "redirect:/admin/community/blacklist/detail?banNo="+blacklistVO.getBanNo();

				}else if(result.equals(ServiceResult.NOTEXIST)){			//회원아이디 존재하지 않을 때
					log.info("=====================================================3 ");
					ra.addFlashAttribute("message", "회원아이디가 존재하지 않습니다.");
					goPage = "redirect:/admin/community/blacklist/form";

				}else if(result.equals(ServiceResult.EXIST)){				// 이미 블랙리스트로 등록이 되어있을 때
					log.info("=====================================================4 ");
					ra.addFlashAttribute("message", "등록 실패: 이미 블랙리스트에 등록되어 있는 사용자입니다.");
					goPage = "redirect:/admin/community/blacklist/form";

				}else {	//기타 등록 실패 시
					log.info("=====================================================5 ");
					ra.addFlashAttribute("message", "등록 실패: 데이터 처리 중 오류가 발생했습니다. 다시 시도해주세요.");
                    goPage = "redirect:/admin/community/blacklist/form";

				}
			}catch(Exception e) {
				log.info("=====================================================6 ");
				e.printStackTrace();
				model.addAttribute("message",  "데이터 처리 중 서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요!");
				model.addAttribute("blacklistVO", blacklistVO);
				goPage = "redirect:/admin/community/blacklist/form";
			}
		}
		log.info("=====================================================7{} ",goPage);
		return goPage;
	}

	//수정페이지 이동
	@GetMapping("/modForm")
	public String blackListModForm(int banNo, Model model) {
		BlacklistVO blacklistVO = blacklistService.blackDetail(banNo);

		log.info("가져온 블랙 리스트: {}", blacklistVO);
		model.addAttribute("blacklist", blacklistVO);
		model.addAttribute("status", "u");
		return "admin/blacklist/blacklistMod";
	}
	//수정하기
	@PostMapping("/update")
	public String blackListUpdate(BlacklistVO blacklistVO, Model model, RedirectAttributes ra, Principal principal) throws Exception{

		String goPage = "";
		//관리자 아이디 불러오기
		String empUsername = principal.getName();
		log.info("auditionInsert->empUsername : {}", empUsername);
		//관리자 아이디 blacklistVO에 넣기
		blacklistVO.setEmpUsername(empUsername);
		ServiceResult result = blacklistService.blackUpdate(blacklistVO);
		if(result.equals(ServiceResult.OK)) {				//성공시
			ra.addFlashAttribute("message", " 수정이 완료 되었습니다!");
			goPage = "redirect:/admin/community/blacklist/detail?banNo="+blacklistVO.getBanNo();
		}else {												//실패시
			model.addAttribute("message", "수정에 실패하였습니다! 다시 시도해주세요...!");
			model.addAttribute("auditionVO", blacklistVO);
			goPage = "redirect:/admin/community/blacklist/modForm?banNo="+blacklistVO.getBanNo();
		}
		return goPage;
	}
	//해제하기
	@PostMapping("delete")
	public String blackListDelete(BlacklistVO blacklistVO, Model model, RedirectAttributes ra) {
		String goPage = "";
		ServiceResult result = blacklistService.blackDelete(blacklistVO);
		if(result.equals(ServiceResult.OK)) {			//성공시
			ra.addFlashAttribute("message", "해제되었습니다!");
			goPage = "redirect:/admin/community/blacklist/list";
		}else {											//실패시
			ra.addAttribute("message", "서버오류, 다시 시도해주세요!");
			goPage = "redirect:/admin/community/blacklist/detail?banNo=" + blacklistVO.getBanNo();
		}
		return goPage;
	}


}
