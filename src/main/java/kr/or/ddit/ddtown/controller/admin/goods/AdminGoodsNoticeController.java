package kr.or.ddit.ddtown.controller.admin.goods;

import java.util.List;

// import org.apache.tomcat.util.net.openssl.ciphers.Authentication; // 사용되지 않는 임포트 제거
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.ddtown.service.admin.goods.notice.IAdminGoodsNoticeService;
// import kr.or.ddit.ddtown.service.goods.main.IGoodsService; // IGoodsService 임포트 제거 (더 이상 필요 없음)
import kr.or.ddit.vo.PaginationInfoVO; // PaginationInfoVO 경로 확인
// import kr.or.ddit.vo.artist.ArtistGroupVO; // ArtistGroupVO 임포트 제거 (더 이상 필요 없음)
import kr.or.ddit.vo.goods.goodsNoticeVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import lombok.extern.slf4j.Slf4j; // Slf4j 임포트

@Slf4j
@Controller
@RequestMapping("/admin/goods/notice")
public class AdminGoodsNoticeController {

	@Autowired
    private final IAdminGoodsNoticeService adminGoodsNoticeService;

    public AdminGoodsNoticeController(IAdminGoodsNoticeService adminGoodsNoticeService) {
        this.adminGoodsNoticeService = adminGoodsNoticeService;
    }

    @GetMapping("/list")
    public String goodsNoticeList(
            @RequestParam(name="currentPage", required=false, defaultValue="1") int currentPage,
            @RequestParam(name="searchType", required=false) String searchType,
            @RequestParam(name="searchWord", required=false) String searchWord,
            HttpServletResponse response,
            Model model) {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0); // 프록시 서버 캐시 방지

        PaginationInfoVO<goodsNoticeVO> pagingVO = new PaginationInfoVO<>();

        if (searchType != null && !searchType.isEmpty()) {
            pagingVO.setSearchType(searchType);
        }
        if (searchWord != null && !searchWord.isEmpty()) {
            pagingVO.setSearchWord(searchWord);
        }

        pagingVO.setCurrentPage(currentPage);

        log.info("### AdminGoodsNoticeController - goodsNoticeList 호출: currentPage={}, searchWord={}, searchType={}",
		pagingVO.getCurrentPage(), pagingVO.getSearchWord(), pagingVO.getSearchType());

        int totalRecord = adminGoodsNoticeService.getTotalGoodsNoticeCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        List<goodsNoticeVO> noticeList = adminGoodsNoticeService.getAllGoodsNotices(pagingVO);
        pagingVO.setDataList(noticeList);

        model.addAttribute("pagingVO", pagingVO);

        return "admin/goods/notice/goods_notice_list";
    }

    // --- 공지사항 등록/수정 폼 통합 (GET 요청) ---
    @GetMapping("/form")
    public String goodsNoticeForm(@RequestParam(name = "id", required = false) Integer goodsNotiNo, Model model) {
        log.info("### AdminGoodsNoticeController - goodsNoticeForm 호출: goodsNotiNo={}", goodsNotiNo);

        if (goodsNotiNo != null) {
            goodsNoticeVO notice = adminGoodsNoticeService.getGoodsNotice(goodsNotiNo);
            model.addAttribute("notice", notice);
            model.addAttribute("mode", "edit");
            log.info(">>>>> 수정 모드: 기존 공지사항 데이터 로드 완료. 제목: {}", notice != null ? notice.getGoodsNotiTitle() : "없음");
        } else {
            model.addAttribute("notice", new goodsNoticeVO());
            model.addAttribute("mode", "register");
            log.info(">>>>> 등록 모드: 새로운 공지사항 작성 시작");
        }
        return "admin/goods/notice/goods_notice_form";
    }

    // --- 공지사항 등록 처리 (POST 요청) ---
    @PostMapping("/register")
    public String registerGoodsNotice(
            @ModelAttribute goodsNoticeVO noticeVO,
            @RequestParam(name = "uploadFile", required = false) MultipartFile[] uploadFile,
            RedirectAttributes ra,
            @AuthenticationPrincipal Object principal) {

        log.info("### AdminGoodsNoticeController - registerGoodsNotice 호출: title={}", noticeVO.getGoodsNotiTitle());
        log.info("첨부파일 수: {}", (uploadFile != null ? uploadFile.length : 0));

        String empUsername = null;
        if (principal instanceof CustomUser customUser) {
            empUsername = customUser.getUsername();
        } else if (principal instanceof CustomOAuth2User auth2User) {
            empUsername = auth2User.getUsername();
        }

        if (empUsername != null) {
            noticeVO.setEmpUsername(empUsername);
            log.info("공지사항 작성자 EMP_USERNAME 설정: {}", empUsername);
        } else {
            log.warn("로그인한 사용자 정보를 찾을 수 없거나 EMP_USERNAME을 가져올 수 없습니다.");
            ra.addFlashAttribute("errorMessage", "작성자 정보를 가져오는 데 실패했습니다. 다시 로그인해주세요.");
            return "redirect:/admin/goods/notice/form";
        }

        try {
            int result = adminGoodsNoticeService.createGoodsNotice(noticeVO, uploadFile);

            if (result > 0) {
                ra.addFlashAttribute("message", "새 공지사항이 성공적으로 등록되었습니다.");
                return "redirect:/admin/goods/notice/list";
            } else {
                ra.addFlashAttribute("errorMessage", "공지사항 등록에 실패했습니다.");
                return "redirect:/admin/goods/notice/form";
            }
        } catch (Exception e) {
            log.error("공지사항 등록 중 오류 발생: {}", e.getMessage(), e);
            ra.addFlashAttribute("errorMessage", "공지사항 등록 중 예상치 못한 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/admin/goods/notice/form";
        }
    }

    @GetMapping("/detail")
    public String goodsNoticeDetail(
    		@RequestParam("id") int goodsNotiNo,
            @RequestParam(name="currentPage", required=false, defaultValue="1") int currentPage,
            @RequestParam(name="searchType", required=false, defaultValue="title") String searchType,
            @RequestParam(name="searchWord", required=false) String searchWord,
            Model model) {

        log.info("### AdminGoodsNoticeController - goodsNoticeDetail 호출: goodsNotiNo={}", goodsNotiNo);
        goodsNoticeVO notice = adminGoodsNoticeService.getGoodsNotice(goodsNotiNo);

        if (notice == null) {
            log.warn("goodsNotiNo={} 에 해당하는 공지사항을 찾을 수 없습니다. 404 페이지로 리다이렉트.", goodsNotiNo);
            return "redirect:/admin/goods/notice/list";
        }

        model.addAttribute("currentPage", currentPage);
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchWord", searchWord);

        model.addAttribute("notice", notice);
        log.info("상세 페이지 데이터 로드 완료. 제목: {}", notice.getGoodsNotiTitle());
        return "admin/goods/notice/goods_notice_detail";
    }

    // --- 공지사항 수정 처리 (POST 요청) ---
    @PostMapping("/update")
    public String updateGoodsNotice(
            @ModelAttribute goodsNoticeVO noticeVO,
            @RequestParam(name = "uploadFile", required = false) MultipartFile[] uploadFile,
            RedirectAttributes ra) {

        log.info("### AdminGoodsNoticeController - updateGoodsNotice 호출: goodsNotiNo={}, title={}",
                 noticeVO.getGoodsNotiNo(), noticeVO.getGoodsNotiTitle());
        log.info("첨부파일 수: {}", (uploadFile != null ? uploadFile.length : 0));

        try {
            int result = adminGoodsNoticeService.updateGoodsNotice(noticeVO, uploadFile);

            if (result > 0) {
                ra.addFlashAttribute("message", "공지사항이 성공적으로 수정되었습니다.");
                return "redirect:/admin/goods/notice/detail?id=" + noticeVO.getGoodsNotiNo();
            } else {
                ra.addFlashAttribute("errorMessage", "공지사항 수정에 실패했습니다.");
                return "redirect:/admin/goods/notice/form?goodsNotiNo=" + noticeVO.getGoodsNotiNo();
            }
        } catch (Exception e) {
            log.error("공지사항 수정 중 오류 발생: {}", e.getMessage(), e);
            ra.addFlashAttribute("errorMessage", "공지사항 수정 중 예상치 못한 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/admin/goods/notice/form?goodsNotiNo=" + noticeVO.getGoodsNotiNo();
        }
    }

    // --- 삭제 (POST MAPPING) ---
    @PostMapping("/delete")
    public String deleteGoodsNotice(@RequestParam("id") int goodsNotiNo, RedirectAttributes ra) {
        log.info(">>>>>> AdminGoodsNoticeController deleteGoodsNotice 진입! goodsNotiNo: {} <<<<<<", goodsNotiNo);
        try {
            boolean success = adminGoodsNoticeService.deleteGoodsNotice(goodsNotiNo);

            if (success) {
                ra.addFlashAttribute("message", "공지사항이 성공적으로 삭제되었습니다.");
                log.info("공지사항(goodsNotiNo:{}) 삭제 성공!! 목록으로 리다이렉트!", goodsNotiNo);
                return "redirect:/admin/goods/notice/list";
            } else {
                ra.addFlashAttribute("errorMessage", "공지사항 삭제에 실패했습니다!!!");
                log.warn("공지사항(goodsNotiNo:{}) 삭제 실패!! 서비스 결과: {}", goodsNotiNo, success);
                return "redirect:/admin/goods/notice/detail?id=" + goodsNotiNo;
            }
        } catch (Exception e) {
            log.error("공지사항(goodsNotiNo:{}) 삭제 중 예상치 못한 오류 발생: {}", goodsNotiNo, e.getMessage(), e);
            ra.addFlashAttribute("errorMessage", "공지사항 삭제 중 예상치 못한 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/admin/goods/notice/detail?id=" + goodsNotiNo;
        }
    }
}