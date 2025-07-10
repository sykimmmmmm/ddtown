package kr.or.ddit.ddtown.controller.admin.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ddtown.service.admin.notice.AdminNoticeService;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.corporate.notice.NoticeVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/notice")
public class AdminNoticeController {

	@Autowired
	private AdminNoticeService noticeService;

	@Autowired
	private IFileService fileService;

	@GetMapping("/list")
	public String noticeList(
			@RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(name = "searchWord", required = false) String searchWord,
			Model model) {
		log.info("관리자 공지사항 목록 요청");

		PaginationInfoVO<NoticeVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setCurrentPage(currentPage);
		pagingVO.setSearchWord(searchWord);

		try {
			int totalRecord = noticeService.selectTotalRecord(pagingVO);
			pagingVO.setTotalRecord(totalRecord);
			List<NoticeVO> list = noticeService.selectNoticeList(pagingVO);
			pagingVO.setDataList(list);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMessage", "공지사항 목록을 불러오는 중 오류가 발생했습니다!!");
		}
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("totalNoticeCnt", noticeService.getTotalNoticeCnt());
		model.addAttribute("gongjiCnt", noticeService.getGongjiPrefixCnt());
		model.addAttribute("annaeCnt", noticeService.getAnnaePrefixCnt());
		return "admin/notice/noticeList";
	}

	@GetMapping("/detail")
	public String noticeDetail(@RequestParam int id, Model model,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
			) {
		log.info("관리자 공지사항 상세 조회");

		NoticeVO noticeVO = null;
		noticeVO = noticeService.getDetail(id);

		if (noticeVO != null && noticeVO.getFileGroupNo() != null) {
			if(noticeVO.getFileGroupNo() != 0) {
				List<AttachmentFileDetailVO> fileList;
				try {
					fileList = fileService.getFileDetailsByGroupNo(noticeVO.getFileGroupNo());
					noticeVO.setAttachmentList(fileList);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		log.info("searchWord" + searchWord);
		log.info("currentPage" + currentPage);

		model.addAttribute("noticeVO", noticeVO);
		model.addAttribute("searchWord", searchWord);
		model.addAttribute("currentPage", currentPage);

		return "admin/notice/noticeDetail";
	}

	@GetMapping("/register")
	public String noticeRegisterForm(Model model) {
		log.info("관리자 공지사항 등록 폼 요청");
		model.addAttribute("noticeVO", new NoticeVO());
		model.addAttribute("mode", "new");

		return "admin/notice/noticeForm";
	}

	@GetMapping("/form")
	public String noticeUpdateForm(@RequestParam int id, Model model) {
		log.info("관리자 공지사항 수정 폼 요청");

		NoticeVO noticeVO = noticeService.getDetail(id);
		log.info("수정 폼 noticeVO : {}", noticeVO);
		model.addAttribute("noticeVO", noticeVO);
		model.addAttribute("mode", "edit");

		return "admin/notice/noticeForm";
	}

	/*
	 * 게시글 저장 ( 신규, 수정 ) NoviceVO의 entNotiNo 값 0이면 등록, 아니면 수정
	 */
	@PostMapping("/save")
	public String noticeSave(NoticeVO noticeVO, RedirectAttributes ra) throws Exception {
		String empUsername = SecurityContextHolder.getContext().getAuthentication().getName();
		noticeVO.setEmpUsername(empUsername);

		boolean isNew = (noticeVO.getEntNotiNo() == 0);
		String sucessRedirectUrl;

		if (isNew) {
			log.info("새 공지 등록 요청..!");
			noticeService.createNotice(noticeVO);
			ra.addFlashAttribute("msg", "등록이 완료되었습니다!");
			sucessRedirectUrl = "redirect:/admin/notice/list";
		} else {
			log.info("공지 수정 요청..! (ID: {})", noticeVO.getEntNotiNo());
			noticeService.modifyNotice(noticeVO, noticeVO.getDeleteFileNos());
			ra.addFlashAttribute("msg", "수정이 완료되었습니다!");
			sucessRedirectUrl = "redirect:/admin/notice/detail?id=" + noticeVO.getEntNotiNo();
		}

		return sucessRedirectUrl;
	}

	@PostMapping("/noticeDelete")
	public String noticeDelete(@RequestParam int id, RedirectAttributes ra) {
		log.info("공지사항 삭제 요청 - ID: {}", id);
		String redirectUrl = "redirect:/admin/notice/list";

		try {
			boolean success = noticeService.deleteNotice(id);

			if (success) {
				ra.addFlashAttribute("msg", "삭제가 완료되었습니다!");
			} else {
				ra.addFlashAttribute("msg", "삭제에 실패했습니다. 다시 시도해주세요.");
			}
		} catch (Exception e) {
			log.error("공지사항 ID {} 삭제 중 오류 발생: {}", id, e.getMessage(), e);
		}
		return redirectUrl;
	}
}
