package kr.or.ddit.ddtown.controller.admin;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.gson.Gson;

import kr.or.ddit.ddtown.service.admin.faqinquiry.IAdminInquiryService;
import kr.or.ddit.ddtown.service.admin.member.IMemberAdminService;
import kr.or.ddit.ddtown.service.admin.notice.AdminNoticeService;
import kr.or.ddit.ddtown.service.admin.report.IReportService;
import kr.or.ddit.ddtown.service.goods.notice.IGoodsNoticeService;
import kr.or.ddit.ddtown.service.goods.order.IOrderService;
import kr.or.ddit.ddtown.service.stat.IStatService;
import kr.or.ddit.vo.corporate.notice.NoticeVO;
import kr.or.ddit.vo.goods.goodsNoticeVO;
import kr.or.ddit.vo.order.OrderCancelVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin")
public class AdminViewController {

	@Autowired
	private IMemberAdminService memberService;

	@Autowired
	private AdminNoticeService noticeService;

	@Autowired
	private IAdminInquiryService adminInquiryService;

	@Autowired
	private IOrderService orderService;

	@Autowired
	private IGoodsNoticeService goodsNoticeService;

	@Autowired
	private IStatService statService;

	@Autowired
	private IReportService reportService;



	@GetMapping("/main")
	public String main(Model model) {
		Gson gson = new Gson();
		// 오늘 신규 가입 회원 수 가져오기
		int registerCnt = memberService.getTodayRegisterUser();
		model.addAttribute("registerCnt", registerCnt);

		// 미처리 신고
		int reportCnt = reportService.getReportCnt();
		model.addAttribute("reportCnt", reportCnt);

		// 미처리 문의
		int inquiryCnt = adminInquiryService.getUnansweredInquiryCnt();
		model.addAttribute("inquiryCnt", inquiryCnt);

		// 최근 기업 공지사항 불러오기
		List<NoticeVO> noticeList = noticeService.selectRecentList();
		model.addAttribute("noticeList", noticeList);

		// 굿즈샵 오늘 주문한 상품 건수
		int orderCnt = orderService.getTodayOrders();
		model.addAttribute("orderCnt", orderCnt);

		//굿즈샵 공지사항 불러오기
		List<goodsNoticeVO> recentGoodsNotices = goodsNoticeService.getrecentGoodsNotices(3);
		model.addAttribute("recentGoodsNotices", recentGoodsNotices);

		// 굿즈샵 통계 쪽 이달의 매출액 주문 건수 환불/취소 건수 가져오기
		Map<String, Object> monthlyGoodsStat = statService.getMonthlyGoodsStat();
		model.addAttribute("goodsStat", monthlyGoodsStat);
		// 환불 / 취소 전체 통계 가져오기
		List<Map<String, Object>> cancelStat = statService.getCancelStat();
		log.info("cancelStat : {}",cancelStat);
		String cancelJsonStat = gson.toJson(cancelStat);
		model.addAttribute("cancelStatJson", cancelJsonStat);
		// 최근 환불/ 취소 내역 가져오기
		List<OrderCancelVO> cancelList = statService.getCancelList();
		log.info("cancelList : {}", cancelList);
		model.addAttribute("cancelList", cancelList);

		return "admin/main";
	}

	@GetMapping("/inquiry/main")
	public String adminInquiryListMain(Model model) {

		log.info("관리자 1:1문의 리스트 요청중...");

		return "admin/faq_inquiry/inquiryMain";
	}

	@GetMapping("/faq/main")
	public String adminFaqMain() {

		log.info("FAQ 메인페이지 요청중...");

		return "admin/faq_inquiry/faqMain";

	}


}
