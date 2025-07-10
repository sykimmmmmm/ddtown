package kr.or.ddit.ddtown.controller.admin.inquiry;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import io.micrometer.common.util.StringUtils;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.admin.faqinquiry.IAdminInquiryService;
import kr.or.ddit.vo.BaseVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.inquiry.InquiryVO;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/inquiry")
public class AdminInquiryController {

	@Autowired
	private IAdminInquiryService adminInquiryService;

	@GetMapping("/list")
	public ResponseEntity<Map<Object, Object>> inquiryList(BaseVO baseVO, String searchCode){

		log.info("리스트 목록 가져오는 중...");

		log.info("baseVO : " + baseVO);

		log.info("searchCode : " + searchCode);

		PaginationInfoVO<InquiryVO> pagingVO = new PaginationInfoVO<>();

		int currentPage = baseVO.getPage();
		String searchWord = baseVO.getSearchWord();
		String searchType = baseVO.getSearchType();

		pagingVO.setCurrentPage(currentPage);
		if(StringUtils.isNotBlank(searchType)) {
			pagingVO.setSearchType(searchType);
		}

		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchWord(searchWord);
		}

		log.info("pagingVO : " + pagingVO);

		Map<Object, Object> map = adminInquiryService.getList(pagingVO, searchCode);

		log.info("list : " + map);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	@GetMapping("/detailData/{inqNo}")
	public ResponseEntity<InquiryVO> inquiryDetail(@PathVariable int inqNo){

		log.info("상세정보 가져오는 중...");

		log.info("inqNo : " + inqNo);

		InquiryVO inqVO = adminInquiryService.getData(inqNo);

		log.info("inqVO 정보 : " + inqVO);

		return new ResponseEntity<>(inqVO, HttpStatus.OK);
	}

	@PostMapping("/insert/{inqNo}")
	public ResponseEntity<ServiceResult> inqUpdate(@PathVariable int inqNo, InquiryVO inqVO) {

		ServiceResult result = null;

		log.info("답변 등록 중...");

		log.info("inqVO : " + inqVO);

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("principal : " + principal);
        EmployeeVO memberVO = null;
        if(principal instanceof CustomUser customUser) {
        	memberVO = customUser.getEmployeeVO();
        }

        log.info("vo" + memberVO);

        inqVO.setEmpUsername(memberVO.getEmpUsername());

        result = adminInquiryService.updateAnswer(inqVO);

		return new ResponseEntity<>(result,HttpStatus.OK);
	}

	@PostMapping("/update/{inqNo}")
	public ResponseEntity<ServiceResult> inqAnsUpdate(@PathVariable int inqNo, InquiryVO inqVO){

		ServiceResult result = null;

		log.info("답변 수정 중...");

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		log.info("principal : " + principal);
        EmployeeVO memberVO = null;
        if(principal instanceof CustomUser customUser) {
        	memberVO = customUser.getEmployeeVO();
        }

        inqVO.setEmpUsername(memberVO.getEmpUsername());

        result = adminInquiryService.updateAnswer(inqVO);

		return new ResponseEntity<>(result, HttpStatus.OK);
	}
}
