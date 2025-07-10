package kr.or.ddit.ddtown.controller.emp.schedule;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.emp.schedule.IScheduleService;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.concert.ConcertNoticeVO;
import kr.or.ddit.vo.concert.ConcertVO;
import kr.or.ddit.vo.schedule.ScheduleDetailVO;
import kr.or.ddit.vo.schedule.ScheduleVO;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/emp/schedule")
public class EmpScheduleController {

	@Autowired
	private IScheduleService scheduleService;

	@GetMapping("/main")
	public String scheduleMain() {

		log.info("직원용 일정관리 페이지 요청 중...");

		return "emp/schedule/main";
	}

	@GetMapping("/list")
	public ResponseEntity<ArtistGroupVO> getSchedule(){

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        EmployeeVO memberVO = null;
        if(principal instanceof CustomUser customUser) {
        	memberVO = customUser.getEmployeeVO();
        }
        if(memberVO != null) {
        	String empUsername = memberVO.getEmpUsername();

        	ArtistGroupVO groupVO = scheduleService.getList(empUsername);


        	log.info("list : " + groupVO);

        	return new ResponseEntity<>(groupVO, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}

	@GetMapping("/des/{id}")
	public ResponseEntity<ScheduleDetailVO> getDes(@PathVariable int id){

		ScheduleDetailVO vo = scheduleService.getDes(id);

		log.info("vo : " + vo);

		return new ResponseEntity<>(vo, HttpStatus.OK);
	}

	@PostMapping("/dateUpdate/{id}")
	public ResponseEntity<ServiceResult> dateUpdate(@PathVariable int id, ScheduleVO scheduleVO){

		log.info("scheduleVO : " + scheduleVO);

		ServiceResult result = scheduleService.dateUpdate(scheduleVO);


		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@PostMapping("/dateMove/{id}")
	public ResponseEntity<ServiceResult> dateMove(@PathVariable int id, ScheduleVO scheduleVO){

		log.info("scheduleVO : " + scheduleVO);

		ServiceResult result = scheduleService.dateMove(scheduleVO);


		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@PostMapping("/insert")
	public ResponseEntity<ServiceResult> insertDate(ScheduleVO scheduleVO){

		log.info("일정 등록 요청 중...");
		log.info("scheduleVO : " + scheduleVO);

		ServiceResult result = scheduleService.dateInsert(scheduleVO);

		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@PostMapping("/delete/{id}")
	public ResponseEntity<ServiceResult> deleteDate(@PathVariable int id){

		ServiceResult result = scheduleService.dateDelete(id);

		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@GetMapping("/concert/list")
	public ResponseEntity<List<ConcertVO>> concertNoticeList(ScheduleVO scheduleVO){

		log.info("scheduleVO : " + scheduleVO);

		List<ConcertVO> list = scheduleService.concertNoticeList(scheduleVO);

		log.info("list : " + list);

		return new ResponseEntity<>(list, HttpStatus.OK);
	}

	@GetMapping("/concert/data")
	public ResponseEntity<ConcertVO> concertData(ConcertVO concertVO){

		ConcertVO concertData = scheduleService.selectConcertData(concertVO);

		return new ResponseEntity<>(concertData, HttpStatus.OK);
	}

	@GetMapping("/notice/list")
	public ResponseEntity<List<ConcertNoticeVO>> noticeList(ScheduleVO scheduleVO){

		log.info("공지사항 목록 조회 요청...");
		log.info("scheduleVO : " + scheduleVO);

		List<ConcertNoticeVO> list = scheduleService.noticeList(scheduleVO);

		log.info("공지사항 목록 : " + list);

		return new ResponseEntity<>(list, HttpStatus.OK);
	}

	@GetMapping("/notice/data")
	public ResponseEntity<ConcertNoticeVO> noticeData(ConcertNoticeVO noticeVO){

		log.info("공지사항 상세 조회 요청...");
		log.info("noticeVO : " + noticeVO);

		ConcertNoticeVO noticeData = scheduleService.selectNoticeData(noticeVO);

		return new ResponseEntity<>(noticeData, HttpStatus.OK);
	}
}
