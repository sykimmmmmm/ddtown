package kr.or.ddit.ddtown.controller.faq;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import io.micrometer.common.util.StringUtils;
import kr.or.ddit.ddtown.service.faq.IFaqService;
import kr.or.ddit.vo.BaseVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.faq.FaqVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/faq")
public class FaqController {

	@Autowired
	private IFaqService faqService;

	@RequestMapping("/main")
	public ResponseEntity<Map<Object, Object>> faqMainPage(BaseVO baseVO) {

		log.info("FAQ 메인페이지 요청됨...");

		PaginationInfoVO<FaqVO> pagingVO = new PaginationInfoVO<>();

		int currentPage = baseVO.getPage();

		if(StringUtils.isNotBlank(baseVO.getSearchWord())) {
			pagingVO.setSearchWord(baseVO.getSearchWord());
		}

		if(StringUtils.isNotBlank(baseVO.getSearchType())) {
			pagingVO.setSearchType(baseVO.getSearchType());
		}

		pagingVO.setCurrentPage(currentPage);
		Map<Object, Object> map = faqService.getList(pagingVO);

		log.info("map : " + map);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

}
