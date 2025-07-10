package kr.or.ddit.ddtown.controller.goods;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.ddtown.service.admin.goods.notice.IAdminGoodsNoticeService;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.ddtown.service.goods.notice.IGoodsNoticeService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.goods.goodsNoticeVO;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/goods/notice")
public class GoodsNoticeListController {

	@Autowired
	private IGoodsNoticeService noticeService;

	@Autowired
	private IAdminGoodsNoticeService adminnoticeService;

	@Autowired
	private IFileService fileService;

    // application.properties나 application.yml에 정의된 업로드 경로를 가져옵니다.
    @Value("${kr.or.ddit.upload.path}")
    private String windowUploadBasePath;

    @Value("${kr.or.ddit.upload.path.mac}")
    private String macUploadBasePath;

    @GetMapping("/list")
    public String noticeList(
            @RequestParam(name="currentPage", required=false, defaultValue="1") int currentPage,
            @RequestParam(name="searchType", required=false, defaultValue="title") String searchType,
            @RequestParam(name="searchWord", required=false) String searchWord,
            // ⭐ NEW: 공지사항 관련 추가 검색 파라미터를 @RequestParam으로 받습니다.
            // 당신의 VO에 있는 searchCategoryCode, empUsername 등이 있다면 추가합니다.
            @RequestParam(name="searchCategoryCode", required=false) String searchCategoryCode,
            @RequestParam(name="empUsername", required=false) String empUsername,
            Model model) {

        log.info("### 공지사항 목록/검색 페이지 요청");
        log.info("currentPage: {}, searchType: {}, searchWord: {}", currentPage, searchType, searchWord);
        log.info("searchCategoryCode: {}, empUsername: {}", searchCategoryCode, empUsername); // 추가된 파라미터 로깅

        PaginationInfoVO<goodsNoticeVO> pagingVO = new PaginationInfoVO<>();

        // ⭐ NEW: PaginationInfoVO의 기본 설정 (screenSize, blockSize)
        // VO의 기본값이 이미 10과 5라면 생략 가능하지만, 명시적으로 설정하는 것이 좋습니다.
        pagingVO.setScreenSize(10); // 한 페이지당 10개 게시글
        pagingVO.setBlockSize(5);   // 한 블록당 5개 페이지 번호

        // 1. 검색 조건 설정 - @RequestParam으로 받은 값들을 pagingVO에 채웁니다.
        if (searchWord != null && !searchWord.trim().isEmpty()) {
            pagingVO.setSearchType(searchType);
            pagingVO.setSearchWord(searchWord);
            log.info("검색 조건 적용: searchType={}, searchWord={}", searchType, searchWord);
        }

        // ⭐ NEW: 추가된 검색 조건들을 pagingVO에 설정합니다.
        if (searchCategoryCode != null && !searchCategoryCode.trim().isEmpty()) {
            pagingVO.setSearchCategoryCode(searchCategoryCode);
            log.info("카테고리 검색 조건 적용: searchCategoryCode={}", searchCategoryCode);
        }
        if (empUsername != null && !empUsername.trim().isEmpty()) {
            pagingVO.setEmpUsername(empUsername);
            log.info("직원 사용자명 검색 조건 적용: empUsername={}", empUsername);
        }

        // 2. 현재 페이지 설정 (VO 내부에서 startRow, endRow, startPage, endPage 계산)
        // 이 메서드 호출 시, totalRecord가 아직 설정되지 않았더라도 startPage와 endPage의 초기 계산은 됩니다.
        pagingVO.setCurrentPage(currentPage);

        // 3. 전체 게시글 수 조회 (위에서 설정된 검색 조건을 포함하여 정확한 총 개수를 가져옵니다.)
        int totalCount = noticeService.getTotalGoodsNoticeCount(pagingVO);

        // 4. 전체 게시글 수 설정 (totalPage 계산 및 최종 페이지 보정)
        // ⭐ IMPORTANT: 이 호출에서 totalPage, endPage, currentPage의 최종 보정이 이루어지므로,
        // 이전에 setCurrentPage를 호출한 후에 반드시 호출되어야 합니다.
        pagingVO.setTotalRecord(totalCount);

        // 5. 페이징 처리된 목록 조회
        List<goodsNoticeVO> noticeList = noticeService.getAllGoodsNotices(pagingVO);
        pagingVO.setDataList(noticeList); // 조회된 데이터 목록 설정

        // 6. JSP로 PaginationInfoVO 객체 및 검색 조건들을 전달합니다.
        model.addAttribute("pagingVO", pagingVO);

        // 검색 폼에 값을 유지하기 위해 모델에 다시 담아줍니다.
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);
        // ⭐ NEW: 추가된 검색 조건들도 모델에 담아 JSP 폼에 유지되도록 합니다.
        model.addAttribute("searchCategoryCode", searchCategoryCode);
        model.addAttribute("empUsername", empUsername);

        log.info("### 공지사항 목록 로드 완료. 총 {}개, 현재 페이지: {}, 총 페이지: {}",
                 totalCount, pagingVO.getCurrentPage(), pagingVO.getTotalPage());

        // JSP 파일 경로
        return "goods/noticeList";
    }

    // **사용자 측 공지사항 상세 페이지**
    @GetMapping("/detail/{goodsNotiNo}") // PathVariable 사용으로 URL 구조를 깔끔하게
    public String noticeDetail(
            @PathVariable("goodsNotiNo") int goodsNotiNo, // URL에서 직접 공지번호를 받습니다.
            @RequestParam(name="currentPage", required=false, defaultValue="1") int currentPage,
            @RequestParam(name="searchType", required=false, defaultValue="title") String searchType,
            @RequestParam(name="searchWord", required=false) String searchWord,
            Model model) {

        log.info("### GoodsNoticeController - noticeDetail 호출: goodsNotiNo={}", goodsNotiNo);

        // 사용자 측 서비스인 goodsNoticeService를 사용합니다.
        goodsNoticeVO notice = adminnoticeService.getGoodsNotice(goodsNotiNo);

        if (notice == null) {
            log.warn("goodsNotiNo={} 에 해당하는 공지사항을 찾을 수 없습니다. 목록 페이지로 리다이렉트.", goodsNotiNo);
            // 사용자에게는 보통 에러 메시지를 포함하여 목록으로 돌려보내는 경우가 많습니다.
            model.addAttribute("message", "존재하지 않는 공지사항입니다.");
            return "redirect:/goods/notice/list"; // 사용자 측 공지사항 목록 URL로 변경
        }

        // JSP에서 '목록' 버튼 클릭 시 현재 페이지 및 검색 조건을 유지하여 돌아가도록 파라미터 전달
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);

        model.addAttribute("notice", notice);
        log.info("상세 페이지 데이터 로드 완료. 제목: {}", notice.getGoodsNotiTitle());
        return "goods/noticeDetail"; // 사용자 측 상세 JSP 경로
    }

    // 파일 다운로드 메서드 추가
    @GetMapping("/download/{fileDetailNo}") // JSP의 ${pageContext.request.contextPath}/file/download/ 에 맞게 경로를 조정했습니다.
    @ResponseBody // HTTP 응답 본문에 데이터를 직접 쓰도록 지시
    public void fileDownload(
            @PathVariable("fileDetailNo") int fileDetailNo,
            HttpServletResponse response) {

        log.info("### 파일 다운로드 요청: fileDetailNo={}", fileDetailNo);

        try {
            // 1. DB에서 파일 정보 조회 (IFileService의 getFileInfo 메소드 사용)
            AttachmentFileDetailVO fileVO = fileService.getFileInfo(fileDetailNo);

            if (fileVO == null) {
                log.warn("fileDetailNo={} 에 해당하는 파일을 찾을 수 없습니다.", fileDetailNo);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "파일을 찾을 수 없습니다.");
                return;
            }

            // 2. 현재 OS에 맞는 기본 업로드 경로 선택 (FileServiceImpl과 동일한 로직)
            String os = System.getProperty("os.name").toLowerCase();
            String currentUploadBasePath;

            if (os.contains("mac") || os.contains("darwin")) {
                currentUploadBasePath = macUploadBasePath;
            } else if (os.contains("win")) {
                currentUploadBasePath = windowUploadBasePath;
            } else {
                log.warn("알 수 없는 OS 환경입니다. window 경로를 사용합니다.");
                currentUploadBasePath = windowUploadBasePath;
            }

            // 3. 실제 파일 경로 생성
            // FileServiceImpl의 processFilesInternal에서 fileSavepath가 "yyyy/MM/dd" 형식으로 저장됩니다.
            // File.separator를 사용하여 OS에 맞는 경로 구분자를 사용합니다.
            File file = new File(currentUploadBasePath + File.separator + fileVO.getFileSavepath() + File.separator + fileVO.getFileSaveNm());

            if (!file.exists()) {
                log.warn("실제 파일이 서버 경로에 존재하지 않습니다: {}", file.getAbsolutePath());
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "실제 파일이 존재하지 않습니다.");
                return;
            }

            // 4. HTTP 응답 헤더 설정
            String originalFileName = URLEncoder.encode(fileVO.getFileOriginalNm(), "UTF-8").replaceAll("\\+", "%20");
            response.setContentType(fileVO.getFileMimeType() != null ? fileVO.getFileMimeType() : "application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + originalFileName + "\"");
            response.setContentLengthLong(file.length());

            // 5. 파일 데이터 전송
            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream outputStream = response.getOutputStream()) {

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
                outputStream.flush();
                log.info("파일 다운로드 성공: {}", file.getName());
            }

        } catch (Exception e) {
            log.error("파일 다운로드 중 오류 발생 (fileDetailNo={}): {}", fileDetailNo, e.getMessage(), e);
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "파일 다운로드 중 오류가 발생했습니다.");
            } catch (Exception se) {
                log.error("에러 응답 전송 중 추가 오류 발생", se);
            }
        }
    }
}
