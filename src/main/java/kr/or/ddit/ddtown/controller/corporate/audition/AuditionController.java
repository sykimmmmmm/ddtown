package kr.or.ddit.ddtown.controller.corporate.audition;

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
import kr.or.ddit.ddtown.service.audition.AuditionService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.corporate.audition.AuditionUserVO;
import kr.or.ddit.vo.corporate.audition.AuditionVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/corporate/audition")
public class AuditionController {

	@Autowired
	private AuditionService auditionService;

	//목록 이동
	@GetMapping("/schedule")
	public String auditionList(
			@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(name = "searchType", required = false, defaultValue = "all") String searchType,
	        @RequestParam(name = "searchWord", required = false, defaultValue = "") String searchWord,
			Model model) {

		PaginationInfoVO<AuditionVO> pagingVO = new PaginationInfoVO<>();

		pagingVO.setSearchType(searchType);
		pagingVO.setSearchWord(searchWord);

		pagingVO.setCurrentPage(currentPage);
		int totalRecord =  auditionService.selectAuditionCount(pagingVO);	//오디션 게시물 수
		pagingVO.setTotalRecord(totalRecord);

		int fixedScreenSize = 9;

		 int startRow = (currentPage - 1) * fixedScreenSize + 1;
	     int endRow = currentPage * fixedScreenSize;
		 pagingVO.setStartRow(startRow); // 계산된 startRow 설정
	     pagingVO.setEndRow(endRow);     // 계산된 endRow 설정

		log.info("audition() 실행...!");
		List<AuditionVO> auditionList = auditionService.auditionList(pagingVO);
		pagingVO.setDataList(auditionList);

		log.info("가져온 오디션 리스트: {}", auditionList);
		model.addAttribute("auditionList", auditionList);
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);
		return "audition/list";
	}
	//상세보기 이동
	@GetMapping("/detail.do")
	public String auditionDetail(int audiNo, Model model) {
		AuditionVO auditionVO = auditionService.detailAudition(audiNo);
		model.addAttribute("audition",auditionVO);
		return "audition/detail";
	}

	//지원 폼 이동
	@GetMapping("/supportForm.do")
	public String auditionSupportForm(int audiNo, Model model) {
		AuditionVO auditionVO = auditionService.detailAudition(audiNo);
		model.addAttribute("audition",auditionVO);
		return "audition/support";
	}

	//지원하기 등록
	@PostMapping("/signup.do")
	public String auditionInsert(AuditionUserVO auditionUserVO, Model model, RedirectAttributes ra) {
		log.info("register->auditionUserVO : {}",auditionUserVO);
		String goPage = "";		// 이동할 페이지 정보

		Map<String, String> errors = new HashMap<>();
		if(StringUtils.isBlank(auditionUserVO.getApplicantNm())) {
			errors.put("ApplicantNm", "이름을 입력해주세요!");
		}
		if(StringUtils.isBlank(auditionUserVO.getApplicantEmail())) {
			errors.put("ApplicantEmail", "이메일을 입력해주세요!");
		}
		if(StringUtils.isBlank(auditionUserVO.getApplicantPhone())) {
			errors.put("ApplicantPhone", "전화번호를 입력해주세요!");
		}
		if(StringUtils.isBlank(auditionUserVO.getAppCoverLetter())) {
			errors.put("AppCoverLetter", "소개를 입력해주세요!");
		}

		if(errors.size() > 0) {			//전달받은 데이터가 이상 있을때
			model.addAttribute("bodyText", "register-page");
			model.addAttribute("errors", errors);
			model.addAttribute("auditionUser", auditionUserVO);
			goPage = "redirect:/corporate/audition/supportForm.do";
		}else {						//정상적인 데이터 넘어옴
			ServiceResult result;
			try {
				result = auditionService.signup(auditionUserVO);
				log.info("지원하기코드================================: {}", result);
				if(result.equals(ServiceResult.OK)) {	//지원하기 성공
					//지원 완료 시, 메신저 알림보내기
					ra.addFlashAttribute("message", "지원이 완료되었습니다!");
					goPage = "redirect:/corporate/audition/detail.do?audiNo="+auditionUserVO.getAudiNo();
				}else {
					model.addAttribute("bodyText", "register-page");
					model.addAttribute("message", "서버에러, 다시 시도해주세요!");
					model.addAttribute("auditionUserVO", auditionUserVO);
					goPage = "redirect:/corporate/audition/supportForm.do";
				}
			} catch (Exception e) {
				e.printStackTrace();
				model.addAttribute("Message",  "데이터 처리 중 서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요!");
				model.addAttribute("auditionUser", auditionUserVO);
                goPage = "redirect:/corporate/audition/supportForm.do"; // 지원 페이지로 이동
			}

		}

		return goPage;
	}

}
