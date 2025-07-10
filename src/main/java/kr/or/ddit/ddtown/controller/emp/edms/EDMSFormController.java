package kr.or.ddit.ddtown.controller.emp.edms;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.emp.edms.IEdmsService;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.edms.EdmsFormVO;
import kr.or.ddit.vo.edms.EdmsVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/emp/edms")
public class EDMSFormController {

	@Autowired
	private IEdmsService edmsService;

	@Autowired
	private IFileService fileService;

	@Value("${kr.or.ddit.upload.path}")
	private String windowUploadBasePath;

	@Value("${kr.or.ddit.upload.path.mac}")
	private String macUploadBasePath;


	@GetMapping("/createform")
	public String edmsFormCreate(Model model) {
		List<EdmsFormVO> formList = edmsService.getFormList();
		log.info("formList : {}",formList);
		model.addAttribute("formList", formList);
		return "emp/edms/formTemplate";
	}


	@PostMapping("/createform")
	public String edmsFormUpdate(EdmsFormVO formVO) {
		log.info("formVO : {}",formVO);
		String path = "";
		ServiceResult result = edmsService.updateForm(formVO);
		if(ServiceResult.OK.equals(result)) {
			path = "redirect:/edms/form";
		}else {
			path = "redirect:/edms/createform";
		}
		return path;
	}

	@GetMapping("/approvalDraft")
	public String edmsForm(Model model) {
		List<EdmsFormVO> formList = edmsService.getFormList();
		log.info("formList : {}",formList);
		model.addAttribute("formList", formList);
		return "emp/edms/approvalForm";
	}

	@PostMapping("/form")
	public String edmsFormProcess(EdmsVO edmsVO) {
		log.info("edmsVO : {}", edmsVO);
		return "";
	}

	@GetMapping("/requestList")
	public String requestList(
			@RequestParam(defaultValue = "1", required = true) int currentPage,
			@RequestParam(defaultValue = "title", required = false) String searchType,
			@RequestParam(required = false) String searchWord,
			@RequestParam(required = false, defaultValue="all") String edmsStatCode,
			Model model) {

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
		map.put("empUsername", empVO.getEmpUsername());
		map.put("location", "request");
		map.put("edmsStatCode", edmsStatCode);
		int totalRecord = edmsService.selectTotalRecord(map);
		pagingVO.setTotalRecord(totalRecord);
		log.info("totalRecord : {}", totalRecord);

		Map<String, Object> summaryMap = edmsService.selectSummaryMapRequest(empVO.getEmpUsername());
		Set<String> keySet = summaryMap.keySet();
		for (String key : keySet) {
			log.info("key : {}, value : {}",key, summaryMap.get(key));
		}



		map.put("startRow", pagingVO.getStartRow());
		map.put("endRow", pagingVO.getEndRow());
		map.put("edmsStatCode", edmsStatCode);
		map.put("empUsername", empVO.getEmpUsername());
		List<EdmsVO> approvalList = edmsService.selectApprovalRequestList(map);
		pagingVO.setDataList(approvalList);
		log.info("approvalList : {}", approvalList.size());
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("summaryMap", summaryMap);
		return "emp/edms/requestList";
	}

	@GetMapping("/detail")
	public String requestDetail(int edmsNo, Model model) {
		EdmsVO edmsVO = edmsService.selectApproval(edmsNo);
		log.info("edmsVO : {}", edmsVO);
		model.addAttribute("edmsVO", edmsVO);
		return "emp/edms/approvalDetail";
	}

	@GetMapping("/approvalBox")
	public String approvalBox(
			@RequestParam(defaultValue = "1", required = true) int currentPage,
			@RequestParam(defaultValue = "title", required = false) String searchType,
			@RequestParam(required = false) String searchWord,
			@RequestParam(required = false, defaultValue="all") String edmsStatCode,
			Model model) {

		PaginationInfoVO<EdmsVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setSearchType(searchType);

		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchWord(searchWord);
		}

		EmployeeVO empVO = getEmployeeVO();
		Map<String, Object> map = new HashMap<>();
		map.put("searchWord", searchWord);
		map.put("searchType", searchType);
		map.put("empUsername", empVO.getEmpUsername());
		map.put("location", "approval");
		map.put("edmsStatCode", edmsStatCode);

		Map<String, Object> summaryMap = edmsService.selectSummaryMap(empVO.getEmpUsername());
		Set<String> keySet = summaryMap.keySet();
		for (String key : keySet) {
			log.info("key : {}, value : {}",key, summaryMap.get(key));
		}

		int totalRecord = edmsService.selectTotalRecord(map);
		log.info("totalRecord : {}",totalRecord);
		pagingVO.setTotalRecord(totalRecord);
		// empVO 가져오기
		map.put("startRow", pagingVO.getStartRow());
		map.put("endRow", pagingVO.getEndRow());
		map.put("edmsStatCode", edmsStatCode);
		List<EdmsVO> approvalList = edmsService.selectApprovalBoxList(map);

		pagingVO.setDataList(approvalList);
		log.info("approvalList : {}", approvalList.size());
		model.addAttribute("summaryMap", summaryMap);
		model.addAttribute("pagingVO", pagingVO);
		return "emp/edms/approvalBox";
	}

	@GetMapping("/update")
	public String edmsUpdateForm(int edmsNo, Model model) throws Exception {
		EdmsVO edmsVO = edmsService.selectApproval(edmsNo);
		int fileGroupNo = edmsVO.getFileGroupNo();
		if(fileGroupNo != 0) {
			List<AttachmentFileDetailVO> fileList = fileService.getFileDetailsByGroupNo(fileGroupNo);
			edmsVO.setFileList(fileList);
		}
		log.info("edmsVO : {}", edmsVO);
		model.addAttribute("edmsVO", edmsVO);
		return "emp/edms/approvalUpdateForm";
	}

	@PostMapping("/update")
	public String edmsUpdate(EdmsVO edmsVO) throws Exception{
		log.info("edmsVO : {} ", edmsVO);
		String path = "";
		ServiceResult result = edmsService.updateApproval(edmsVO);
		if(ServiceResult.OK.equals(result)) {
			path = "redirect:/emp/edms/approvalBox";
		}else {
			path = "redirect:/emp/edms/update?edmsNo="+edmsVO.getEdmsNo();
		}

		return path;
	}

	@PostMapping("/registApproval")
	public String edmsRegister(EdmsVO edmsVO) {
		log.info("edmsVO : {} ", edmsVO);
		String path = "";
		ServiceResult result = edmsService.insertApproval(edmsVO);
		if(ServiceResult.OK.equals(result)) {
			path = "redirect:/emp/edms/detail?edmsNo="+edmsVO.getEdmsNo();
		}else {
			path = "redirect:/emp/edms/approvalDraft";
		}

		return path;
	}

	@GetMapping("/file/download/{fileDetailNo}")
	public ResponseEntity<byte[]> download(@PathVariable int fileDetailNo) {
		log.info("공지 download 요청..! fileDetailNO: {}", fileDetailNo);

		InputStream in = null;
		ResponseEntity<byte[]> entity = null;

		try {
			AttachmentFileDetailVO detailVO = fileService.getFileInfo(fileDetailNo);

			if (detailVO == null) {
				log.warn("파일 정보를 찾을 수 없습니다. fileDetailNo: {}", fileDetailNo);
				return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			}

			String filePath = detailVO.getFileSavepath();
			String fileSaveNameWithExt = detailVO.getFileSaveNm();
			String fileOriginalName = detailVO.getFileOriginalNm();

			// 1. 현재 OS에 맞는 기본 업로드 경로 선택
	        String os = System.getProperty("os.name").toLowerCase();
	        String currentUploadBasePath;

	        if(os.contains("mac") || os.contains("darwin")) {
	        	currentUploadBasePath = macUploadBasePath;
	        } else if(os.contains("win")) {
	        	currentUploadBasePath = windowUploadBasePath;
	        } else {
	        	log.warn("알 수 없는 OS 환경입니다. window 경로를 사용합니다.");
	        	currentUploadBasePath = windowUploadBasePath;
	        }

			// 최종 파일 경로
			Path fullSavePath = Paths.get(currentUploadBasePath, filePath, fileSaveNameWithExt);
			log.info("fullSavePath : {}",fullSavePath);
			File file = fullSavePath.toFile();

			// 파일 확장자 (getMediaType 메서드에 전달하기 위해 fileSaveNameWithExt에서 추출)
            String formatName = "";
            int dotIndex = fileSaveNameWithExt.lastIndexOf(".");
            if (dotIndex > 0 && dotIndex < fileSaveNameWithExt.length() - 1) {
                formatName = fileSaveNameWithExt.substring(dotIndex + 1).toLowerCase();
            } else {
                if (detailVO.getFileExt() != null && detailVO.getFileExt().startsWith(".")) {
                    formatName = detailVO.getFileExt().substring(1).toLowerCase();
                } else if (detailVO.getFileExt() != null) { // 점이 없는 'jpeg'와 같은 경우
                    formatName = detailVO.getFileExt().toLowerCase();
                }
            }

			MediaType mType = getMediaType(formatName);
			HttpHeaders headers = new HttpHeaders();

			in = new FileInputStream(file);

			if(mType != null) {
				headers.setContentType(mType);
			} else {
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			}

            String encodedFileName = URLEncoder.encode(fileOriginalName, StandardCharsets.UTF_8.toString()).replaceAll("\\+", "%20");
            headers.add("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

            headers.setContentLength(file.length());

			entity = new ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.OK);

		} catch (Exception e) {
			log.error("파일 다운로드 중 알 수 없는 오류 발생 (General Exception): {}", e.getMessage(), e);
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		} finally {
			if(in != null) {
				try {
					in.close();
				} catch (IOException e) {
					log.error("InputStream 닫기 실패: {}", e.getMessage());
				}
			}
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

	private MediaType getMediaType(String formatName) {
		if(formatName != null && !formatName.isEmpty()) {
			formatName = formatName.toLowerCase();
			switch (formatName) {
				case "jpg","jpeg": return MediaType.IMAGE_JPEG;
				case "png":  return MediaType.IMAGE_PNG;
				case "gif":  return MediaType.IMAGE_GIF;
				case "pdf":  return MediaType.APPLICATION_PDF;
				case "doc","docx": return MediaType.valueOf("application/msword"); // MS Word
				case "xls","xlsx": return MediaType.valueOf("application/vnd.ms-excel"); // MS Excel
				case "ppt","pptx": return MediaType.valueOf("application/vnd.ms-powerpoint"); // MS PowerPoint
				case "zip":  return MediaType.valueOf("application/zip"); // ZIP 압축 파일
				case "txt":  return MediaType.valueOf("text/plain"); // 텍스트 파일
				default : return null;
			}
		}
		return null;
	}
}
