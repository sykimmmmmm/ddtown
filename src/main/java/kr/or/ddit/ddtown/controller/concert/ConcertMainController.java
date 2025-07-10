package kr.or.ddit.ddtown.controller.concert;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;

import kr.or.ddit.ddtown.service.concert.IConcertService;
import kr.or.ddit.vo.concert.ConcertSeatMapVO;
import kr.or.ddit.vo.concert.ConcertVO;
import kr.or.ddit.vo.concert.TicketVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/concert")
public class ConcertMainController {

	@Autowired
	private IConcertService concertService;

	@GetMapping("/main")
	public String concertMainView(Model model) {
		log.info("콘서트 메인 뷰 실행");

		ConcertVO concertVO = new ConcertVO();
		List<ConcertVO> concertList = null;
		try {
			concertList = concertService.getConcertList(concertVO);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMessage", "콘서트 목록을 불러오는 중 오류가 발생했습니다!!");
		}

		model.addAttribute("concertList", concertList);
		return "concert/main";
	}

	@GetMapping("/detail/{concertNo}")
	public String concertMainView(@PathVariable int concertNo, Model model, RedirectAttributes ra) {
		log.info("콘서트 상세보기 요청");

		try {
			// 1. 콘서트 상세 내용 조회
			ConcertVO concertVO = concertService.selectSchedule(concertNo);
			if(concertVO == null) {
				ra.addFlashAttribute("errorMessage", "해당되는 콘서트 정보가 없습니다.");
				return "redirect:/concert/main/list";
			}
			model.addAttribute("concertVO", concertVO);

			// 2. 콘서트 좌석 정보 조회
			List<ConcertSeatMapVO> seatList = concertService.getConcertSeatMap(concertNo);
			model.addAttribute("seatList", seatList);

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMessage", "콘서트 목록을 불러오는 중 오류가 발생했습니다!!");
			return "redirect:/concert/main/list";
		}
		return "concert/detail";
	}

	@GetMapping("/seat/{concertNo}")
	public String selectSeat(@PathVariable int concertNo, Model model) {
		log.info("콘서트 좌석페이지 요청");


		try {
			// 콘서트 정보 조회
			ConcertVO concertVO = concertService.selectSchedule(concertNo);
			model.addAttribute("concertVO", concertVO);

			// 좌석 등급별 가격 정보 조회
			List<ConcertSeatMapVO> seatPriceList = concertService.getConcertSeatMap(concertNo);
			model.addAttribute("seatList", seatPriceList);

			// JSON 문자열 변환
			Gson gson = new Gson();

			// 전체 좌석 정보 조회
			List<TicketVO> allTicketList = concertService.getAllTicketList(concertNo);
			model.addAttribute("allTicketList", gson.toJson(allTicketList));

			// 이미 예매된 좌석 정보만 추출하여 jsp로 전달
			List<String> bookedSeatNo = allTicketList.stream()
					.filter(ticket -> ticket.getMemUsername() != null && ticket.getOrderDetNo() != 0)
					.map(TicketVO::getSeatNo)
					.toList();

			model.addAttribute("bookedSeatNo", gson.toJson(bookedSeatNo));

			// 콘서트 상품 번호 조회하여 전달


		} catch (Exception e) {
			e.printStackTrace();
		}

		return "concert/selectSeat";
	}
}
