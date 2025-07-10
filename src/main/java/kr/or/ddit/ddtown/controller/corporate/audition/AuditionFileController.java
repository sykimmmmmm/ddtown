package kr.or.ddit.ddtown.controller.corporate.audition;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.View;

import kr.or.ddit.ddtown.service.emp.audition.IEmpAuditionService;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;

@Controller
public class AuditionFileController {

	@Autowired
	private IEmpAuditionService empAuditionService;

	//파일 다운로드 요청
		@GetMapping("/corporate/Audition/download.do")
		public View auditionDownload(int attachDetailNo, ModelMap model) {

			AttachmentFileDetailVO attachmentFileDetailVO = empAuditionService.auditionDownload(attachDetailNo);

			Map<String, Object> auditionFileMap = new HashMap<>();
			auditionFileMap.put("fileOriginalName", attachmentFileDetailVO.getFileOriginalNm());
			auditionFileMap.put("fileSaveName", attachmentFileDetailVO.getFileSaveNm());
			auditionFileMap.put("fileSize", attachmentFileDetailVO.getFileSize());
			auditionFileMap.put("fileSavepath", attachmentFileDetailVO.getFileSavepath());
			model.addAttribute("auditionFileMap", auditionFileMap);

			return new AuditionDownloadView();
		}


}
