package kr.or.ddit.ddtown.controller.admin.report;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.admin.report.IReportService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.report.ReportVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/community/report")
public class AdminReportController {

	@Autowired
	private IReportService reportService;

	//목록 이동
	@GetMapping("/list")
	public String reportMain(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(name = "searchType", required = false, defaultValue = "all") String searchType,			//검색 유형
	        @RequestParam(name = "searchWord", required = false, defaultValue = "") String searchWord,				//검색
	        @RequestParam(name = "badgeSearchType", required = false, defaultValue = "") String badgeSearchType,	//뱃지
			Model model) {
		log.info("currentPage: {}, searchType: {}, searchWord: {}", currentPage, searchType, searchWord);

		PaginationInfoVO<ReportVO> pagingVO = new PaginationInfoVO<>();

		pagingVO.setSearchType(searchType);
		pagingVO.setSearchWord(searchWord);
		pagingVO.setBadgeSearchType(badgeSearchType);

		pagingVO.setCurrentPage(currentPage);

		// 뱃지: "총 신고" 수를 위한 파라미터 맵 생성(검색영향X)
		 Map<String, Object> totalCountParams = new HashMap<>();
		 int totalReportCount = reportService.totalReportCount(totalCountParams);

		int totalRecord = reportService.selectReportCount(pagingVO);	//총 신고 목록수
		pagingVO.setTotalRecord(totalRecord); //총 게시글 수 전달 후, 총 페이지 수 설정

		int fixedScreenSize = 10;

		int startRow = (currentPage - 1) * fixedScreenSize + 1;
	    int endRow = currentPage * fixedScreenSize;
		pagingVO.setStartRow(startRow); // 계산된 startRow 설정
	    pagingVO.setEndRow(endRow);     // 계산된 endRow 설정

		//뱃지: 미처리 수
		int reportCnt = reportService.reportCnt();
		//뱃지: 신고 사유 유형별 수
		Map<String, Integer> reportReasonCnt = reportService.reportReasonCnt();

		log.info("report() 실행...!");
		List<ReportVO> reportList = reportService.reportList(pagingVO);
		pagingVO.setDataList(reportList);


		log.info("가져온 신고 리스트: {}", reportList);
		model.addAttribute("reportList", reportList);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);
        model.addAttribute("badgeSearchType", badgeSearchType);
        model.addAttribute("totalRecord", totalRecord);
		model.addAttribute("reportCnt", reportCnt);
		model.addAttribute("reportReasonCnt", reportReasonCnt);
		model.addAttribute("totalReportCount", totalReportCount);

		return "admin/report/reportList";
	}
	//상세보기 페이지
	@GetMapping("/detail")
	public String reportDetail(int reportNo, Model model) {
		ReportVO reportVO = reportService.reportDetail(reportNo);
		log.info("ReportResultCode from DB: " + reportVO.getReportResultCode());
		model.addAttribute("report", reportVO);
	return "admin/report/reportDetail";
	}
	//신고처리
	@ResponseBody
	@PostMapping("/update")
	public ResponseEntity<ServiceResult> reportUpdate(@RequestBody ReportVO reportVO, Principal principal){
		log.info("신고번호->reportNo : " + reportVO.getReportNo());
		log.info("신고처리상태->reportResultCode : " + reportVO.getReportResultCode());
		log.info("게시글유형->reportTargetTypeCode : " + reportVO.getReportTargetTypeCode());
		log.info("처리코드->reportResultCode : " + reportVO.getReportResultCode());
		log.info("게시글 번호->targetComuPostNo : " + reportVO.getTargetComuPostNo());
		log.info("댓글번호->targetComuReplyNo : " + reportVO.getTargetComuReplyNo());
		// 관리자 아이디
		String empUsername = principal.getName();
		log.info("auditionInsert->empUsername : {}", empUsername);
		reportVO.setEmpUsername(empUsername);

		ServiceResult result = reportService.reportUpdate(reportVO);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
}
