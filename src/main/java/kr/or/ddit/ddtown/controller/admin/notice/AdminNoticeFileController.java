package kr.or.ddit.ddtown.controller.admin.notice;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AdminNoticeFileController {

	@Autowired
	private IFileService fileService;

	@Value("${kr.or.ddit.upload.path}")
	private String windowUploadBasePath;

	@Value("${kr.or.ddit.upload.path.mac}")
	private String macUploadBasePath;

	@GetMapping("/admin/file/download/{fileDetailNo}")
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
