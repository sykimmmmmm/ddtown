package kr.or.ddit.ddtown.controller.inquiry;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.micrometer.common.util.StringUtils;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.inquiry.InquiryService;
import kr.or.ddit.vo.BaseVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.inquiry.InquiryCodeVO;
import kr.or.ddit.vo.inquiry.InquiryVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/inquiry")
public class InquiryController {

	@Autowired
	private InquiryService inquiryService;

	@GetMapping("/list")
	public ResponseEntity<Map<Object, Object>> inquiryMain(BaseVO baseVO) {

		// 접속중인 사용자 정보 가져오기
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		MemberVO memberVO = getMemberVO(principal);

        PaginationInfoVO<InquiryVO> pagingVO = new PaginationInfoVO<>();
        if(memberVO != null) {
        	pagingVO.setMemUsername(memberVO.getMemUsername());
        }

        int currentPage = baseVO.getPage();
        String searchType = baseVO.getSearchType();
        String searchWord = baseVO.getSearchWord();

        if(StringUtils.isNotBlank(searchWord)) {
        	pagingVO.setSearchWord(searchWord);
        }

        if(StringUtils.isNotBlank(searchType)) {
        	pagingVO.setSearchType(searchType);
        }

        pagingVO.setCurrentPage(currentPage);


		Map<Object, Object> map = inquiryService.getList(pagingVO);

		return new ResponseEntity<>(map,HttpStatus.OK);
	}

	// 상세데이터 가져오기
	@GetMapping("/getData/{inqNo}")
	public ResponseEntity<InquiryVO> inquiryDetail(@PathVariable int inqNo){
		log.info("inqNo : " + inqNo);

		InquiryVO vo = inquiryService.getDetail(inqNo);

		log.info("vo : " + vo);

		return new ResponseEntity<>(vo,HttpStatus.OK);
	}


	// 1:1 문의 등록
	@PostMapping("/insert")
	public Map<String, Object> inquiryInsertData(InquiryVO inquiryVO) {

		log.info("1:1문의 등록 실행");
		log.info("VO : " + inquiryVO);

		// 접속중인 사용자 정보
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberVO memberVO = getMemberVO(principal);

        inquiryVO.setMemUsername(memberVO.getMemUsername());

        ServiceResult result = inquiryService.insertData(inquiryVO);


        Map<String, Object> map = new HashMap<>();
        map.put("status", result);

		return map;
	}

	@GetMapping("/updateData/{inqNo}")
	public ResponseEntity<Map<Object, Object>> updateData(@PathVariable int inqNo) {

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberVO memberVO = getMemberVO(principal);
        String fullName = "";
        if(memberVO != null) {
        	fullName = memberVO.getPeoLastNm() + memberVO.getPeoFirstNm();
        }

		InquiryVO vo = inquiryService.getDetail(inqNo);

		List<InquiryCodeVO> codeList = inquiryService.getCodeList();

		Map<Object, Object> map = new HashMap<>();

		map.put("vo", vo);
		map.put("codeList", codeList);
		map.put("name", fullName);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	@PostMapping("/updateForm")
	public Map<String, Object> updateForm(InquiryVO vo,RedirectAttributes red) {
		ServiceResult result = null;

		log.info("수정요청중...");
		log.info("vo : " + vo);

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberVO memberVO = getMemberVO(principal);

        vo.setMemUsername(memberVO.getMemUsername());

		result = inquiryService.updateData(vo);

		Map<String, Object> map = new HashMap<>();
		map.put("status", result);
		map.put("value", vo.getInqNo());

		return map;
	}

	@PostMapping("/delete/{inqNo}")
	public Map<String, Object> deleteForm(@PathVariable int inqNo){

		ServiceResult result = null;

		result = inquiryService.deleteData(inqNo);

		Map<String, Object> map = new HashMap<>();
		map.put("status", result);

		return map;
	}

	private MemberVO getMemberVO(Object principal) {
		MemberVO memberVO = null;
        if(principal instanceof CustomUser customUser) {
            memberVO = customUser.getMemberVO();
        }else if(principal instanceof CustomOAuth2User auth2User) {
            memberVO = auth2User.getMemberVO();
        }
        return memberVO;
	}
}
