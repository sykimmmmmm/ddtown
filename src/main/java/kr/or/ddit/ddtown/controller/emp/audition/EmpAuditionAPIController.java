package kr.or.ddit.ddtown.controller.emp.audition;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.ddtown.service.EmailService;
import kr.or.ddit.ddtown.service.emp.audition.IEmpAuditionService;
import kr.or.ddit.vo.corporate.audition.AuditionUserVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/emp/audition")
public class EmpAuditionAPIController {

	@Autowired
	private IEmpAuditionService empAuditionService;

	@Autowired
	private EmailService mailService;

	@GetMapping("/applicant/detail")
	// 지원자 상세정보
	public ResponseEntity<AuditionUserVO> getApplicantsDetail(@RequestParam int appNo) {
		AuditionUserVO auditionUserDetail = empAuditionService.auditionUserDetail(appNo);
		log.info("지원자 상세 정보: (appNo: {}), audiTypeCode: {}", auditionUserDetail.getAppNo(),
				auditionUserDetail.getAudiTypeCode());
		if (auditionUserDetail.getAudition() != null && auditionUserDetail.getAudition().getFileList() != null) {
	        for (AttachmentFileDetailVO file : auditionUserDetail.getAudition().getFileList()) {
	            log.info("파일 원본 이름: {}", file.getFileOriginalNm());
	            log.info("파일 저장 경로: {}", file.getFileSavepath());
	            // 필요한 파일 처리 로직 수행
	        }
	    }
		return new ResponseEntity<>(auditionUserDetail, HttpStatus.OK);
	}


	  //합격시 처리
	  @Transactional
	  @ResponseBody
	  @PostMapping("/StauesUpdate")
	  public ResponseEntity<Map<String, String>>stauesPassed(@RequestBody AuditionUserVO auditionUserVO){
		  log.info("StauesUpdate -> StauesPassed : {}", auditionUserVO);
		  Map<String, String>map = new HashMap<>();
		  log.info("StauesPassed : {}", auditionUserVO);
		  if(auditionUserVO == null ) {
			  map.put("Status", "FAILED");
		  }else {
			  Map<String, Object> modelData = new HashMap<>();
			  modelData.put("applicantName", auditionUserVO.getApplicantNm());
			  modelData.put("isApproved", true);
			  modelData.put("isApproved2", false);
			  modelData.put("companyName", "DDTOWN");

			  mailService.sendEmailWithThymleafTemplete(auditionUserVO.getApplicantEmail(),"[DDTOWN] 오디션 결과 안내", "audiMailTemplate", modelData);
			  map.put("Status", "SUCCESS" );
		  }
		  return new ResponseEntity<>(map,HttpStatus.OK);

	  }

   //불합격시 처리

	  @Transactional
	  @ResponseBody
	  @PostMapping("/StauesUpdate2")
	  public ResponseEntity<Map<String, String>>stauesFAILED(@RequestBody AuditionUserVO auditionUserVO){
		  log.info("StauesUpdate -> StauesFailed : {}", auditionUserVO);
		  Map<String, String>map = new HashMap<>();
		  log.info("StauesPassed : {}", auditionUserVO);
		  if(auditionUserVO == null ) {
			  map.put("Status", "FAILED");
		  }else {
			  Map<String, Object> modelData = new HashMap<>();
			  modelData.put("applicantName", auditionUserVO.getApplicantNm());
			  modelData.put("isApproved", false);
			  modelData.put("isApproved2", true);
			  modelData.put("companyName", "DDTOWN");

			  mailService.sendEmailWithThymleafTemplete(auditionUserVO.getApplicantEmail(),"[DDTOWN] 오디션 결과 안내", "audiMailTemplate", modelData);
			  map.put("Status", "SUCCESS" );
		  }
		  return new ResponseEntity<>(map,HttpStatus.OK);

	  }


}
