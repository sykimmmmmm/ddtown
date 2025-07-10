package kr.or.ddit.ddtown.controller.admin.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.admin.member.IMemberAdminService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.member.MemCodeListVO;
import kr.or.ddit.vo.member.MemberAdminVO;
import kr.or.ddit.vo.order.OrderCancelVO;
import kr.or.ddit.vo.order.OrdersVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/community/member")
public class AdminMemberController {

	@Autowired
	private IMemberAdminService memberAdminService;

	@GetMapping("/main")
	public String memberList(
			@RequestParam(defaultValue = "1", required = true) int currentPage,
			@RequestParam(required = false) String searchType,
			@RequestParam(required = false) String searchWord,
			@RequestParam(required = false) String searchCode,
			Model model){

		log.info("목록 요청 중...");
		log.info("searchCode : " + searchCode);
		PaginationInfoVO<MemberAdminVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setCurrentPage(currentPage);

		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchWord(searchWord);
		}

		if(StringUtils.isNotBlank(searchType)) {
			pagingVO.setSearchType(searchType);
		}

		log.info("pagingVO : {}",pagingVO);

		int totalRecord = memberAdminService.getTotalRecord(pagingVO, searchCode);

		pagingVO.setTotalRecord(totalRecord);

		List<MemberAdminVO> dataList = memberAdminService.getDataList(pagingVO, searchCode);

		pagingVO.setDataList(dataList);

		log.info("최종 pagingVO : " + pagingVO);

		Map<String, Object> map = new HashMap<>();

		int totalMemCnt = 0;
		int generalMemCnt = 0;
		int outMemCnt = 0;
		int blackMemCnt = 0;

		totalMemCnt = memberAdminService.getTotalMemCnt();
		generalMemCnt = memberAdminService.getGeneralMemCnt();
		outMemCnt = memberAdminService.getOutMemCnt();
		blackMemCnt = memberAdminService.getBlackMemCnt();

		map.put("totalMemCnt", totalMemCnt);
		map.put("generalMemCnt", generalMemCnt);
		map.put("outMemCnt",outMemCnt);
		map.put("blackMemCnt",blackMemCnt);

		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("cntMap", map);
		model.addAttribute("searchCode", searchCode);

		return "admin/member/main";
	}

	@GetMapping("/detail/{memUsername}")
	public String detailMember(@PathVariable String memUsername, Model model) {

		log.info("회원 상세페이지 요청 중...");

		MemberAdminVO memberVO = memberAdminService.getMember(memUsername);

		List<MemCodeListVO> codeList = memberAdminService.getCodeList();

		List<MemberAdminVO> joinComu = memberAdminService.joinComuList(memUsername);

		List<Map<Object, Object>> membershipList = memberAdminService.membershipList(memUsername);

		List<OrdersVO> orderVOList = memberAdminService.orderVOList(memUsername);



		model.addAttribute("memberVO", memberVO);
		model.addAttribute("codeList", codeList);
		model.addAttribute("joinComuList", joinComu);
		model.addAttribute("membershipList", membershipList);
		model.addAttribute("orderVOList", orderVOList);

		log.info("memberVO : " + memberVO);
		log.info("joinComu : " + joinComu);
		log.info("membershipList : " + membershipList);
		log.info("orderVOList : " + orderVOList);

		return "admin/member/detail";
	}

	@PostMapping("/update/{memUsername}")
	public ResponseEntity<ServiceResult> updateMember(@PathVariable String memUsername, MemberAdminVO memberVO) {

		ServiceResult result = null;

		log.info("회원 업데이트 요청중...");

		log.info("memberVO : " + memberVO);

		result = memberAdminService.updateMember(memberVO);

		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@PostMapping("/delete/{memUsername}")
	public ResponseEntity<ServiceResult> deleteMemeber(@PathVariable String memUsername){

		ServiceResult result = null;

		result = memberAdminService.deleteMember(memUsername);

		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@GetMapping("/cntData/{artGroupNo}")
	public ResponseEntity<List<Map<Object, Object>>> cntChartData(MemberAdminVO memberAdminVO){

		List<Map<Object, Object>> data = memberAdminService.cntChartData(memberAdminVO);

		return new ResponseEntity<>(data,HttpStatus.OK);
	}

	@GetMapping("/orderData/{memUsername}")
	public ResponseEntity<List<Map<Object, Object>>> orderChartData(@PathVariable String memUsername){

		log.info("memUsername : " + memUsername);

		List<Map<Object, Object>> orderCntList = memberAdminService.orderCntList(memUsername);

		log.info("orderCntList : " + orderCntList);

		return new ResponseEntity<>(orderCntList,HttpStatus.OK);
	}

	@GetMapping("/orderDataForGrid/{memUsername}")
	public ResponseEntity<Map<Object, Object>> orderDataForGrid(PaginationInfoVO<OrdersVO> pagingVO){
		Map<Object, Object> result = new HashMap<>();
		Map<String, Object> data = new HashMap<>();

		log.info("----------pagingVO : " + pagingVO);
		String label = pagingVO.getLabel();
		log.info("----------label : " + label);
		if("판매금액".equals(label)) {
			List<OrdersVO> selectOrderList = memberAdminService.selectOrderList(pagingVO);

			int totalRecord = memberAdminService.orderListTotalRecord(pagingVO);

			pagingVO.setTotalRecord(totalRecord);

			log.info("order : " + selectOrderList);

			data.put("content", selectOrderList);

			result.put("data", data);
		}else {
			List<OrderCancelVO> cancelOrderList = memberAdminService.cancelOrderList(pagingVO);

			int cancelListTotalRecord = memberAdminService.cancelListTotalRecord(pagingVO);

			pagingVO.setTotalRecord(cancelListTotalRecord);

			data.put("content", cancelOrderList);

			result.put("data", data);
		}


		result.put("label", pagingVO.getLabel());
		result.put("pagingVO", pagingVO);




		return new ResponseEntity<>(result, HttpStatus.OK);
	}
}
