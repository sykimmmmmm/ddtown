package kr.or.ddit.ddtown.controller.emp.edms;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.emp.edms.IEdmsService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.edms.ApproverVO;
import kr.or.ddit.vo.edms.EdmsCommVO;
import kr.or.ddit.vo.edms.EdmsFormVO;
import kr.or.ddit.vo.edms.EdmsVO;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/emp/edms")
public class EdmsFormAPIController {

	@Autowired
	private IEdmsService edmsService;


	/**
	 * 결재 양식 불러오기
	 * @param formVO
	 * @return
	 */
	@PostMapping("/form")
	public ResponseEntity<EdmsFormVO> formDetail(@RequestBody EdmsFormVO formVO){
		log.info("formDetail -> formVO : {}", formVO);
		EdmsFormVO edmsFormVO = edmsService.getForm(formVO.getFormNo());

		return new ResponseEntity<>(edmsFormVO,HttpStatus.OK);
	}

	/**
	 * 회사 부서 목록 불러오기
	 * @return
	 */
	@GetMapping("/departList")
	public ResponseEntity<List<EdmsCommVO>> displayDepartList(){
		List<EdmsCommVO> departList = edmsService.getDepartList();

		log.info("departList : {}", departList);
		return new ResponseEntity<>(departList,HttpStatus.OK);
	}

	/**
	 * 해당 부서 직원 목록 불러오기
	 * @param empDepartCode
	 * @return
	 */
	@GetMapping("/empList")
	public ResponseEntity<List<EmployeeVO>> displayEmployeeList(@RequestParam String empDepartCode){
		List<EmployeeVO> empList = edmsService.getEmpList(empDepartCode);

		log.info("empList : {}", empList);
		return new ResponseEntity<>(empList,HttpStatus.OK);
	}

	@GetMapping("/getApprovalList")
	public ResponseEntity<PaginationInfoVO<EdmsVO>> getApprovalList(
			  @RequestParam int currentPage
			, @RequestParam String searchType
			, @RequestParam String searchWord){
		ResponseEntity<PaginationInfoVO<EdmsVO>> entity = null;
		PaginationInfoVO<EdmsVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setCurrentPage(currentPage);

		if(StringUtils.isNotBlank(searchType)) {
			pagingVO.setSearchType(searchType);
		}

		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchWord(searchWord);
		}

		// empVO 가져오기
		EmployeeVO empVO = getEmployeeVO();
		Map<String, Object> map = new HashMap<>();
		map.put("searchWord", searchWord);
		map.put("searchType", searchType);
		if(empVO != null) {
			map.put("empUsername", empVO.getEmpUsername());
		}

		int totalRecord = edmsService.selectTotalRecord(map);
		pagingVO.setTotalRecord(totalRecord);
		map.put("startRow", pagingVO.getStartRow());
		map.put("endRow", pagingVO.getEndRow());
		List<EdmsVO> approvalList = edmsService.selectApprovalBoxList(map);
		pagingVO.setDataList(approvalList);

		entity = new ResponseEntity<>(pagingVO,HttpStatus.OK);

		return entity;

	}

	@PostMapping("/reject")
	public ResponseEntity<Object> rejectEdms(@RequestBody ApproverVO approverVO){
		log.info("approverVO : {}",approverVO);
		ResponseEntity<Object> entity = null;
		ServiceResult result = edmsService.updateAppovalReject(approverVO);

		if(ServiceResult.OK.equals(result)) {
			entity = new ResponseEntity<>(result,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}
	@PostMapping("/approve")
	public ResponseEntity<Object> approveEdms(@RequestBody ApproverVO approverVO){
		log.info("approverVO : {}",approverVO);
		ResponseEntity<Object> entity = null;
		ServiceResult result = edmsService.updateAppovalApprove(approverVO);

		if(ServiceResult.OK.equals(result)) {
			entity = new ResponseEntity<>(result,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}

	@PostMapping("/withdraw")
	public ResponseEntity<Object> withdrawEdms(int edmsNo){
		log.info("edmsNo : {}",edmsNo);
		ResponseEntity<Object> entity = null;
		ServiceResult result = edmsService.withdrawEdms(edmsNo);

		if(ServiceResult.OK.equals(result)) {
			entity = new ResponseEntity<>(result,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}



	/**
	 * 현재 로그인 중인 직원의 EmployeeVO 가져오기
	 * @return EmployeeVO
	 */
	private EmployeeVO getEmployeeVO() {
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		EmployeeVO empVO = null;
		if(principal instanceof CustomUser customUser) {
			empVO = customUser.getEmployeeVO();
		}
		return empVO;
	}
}
