package kr.or.ddit.ddtown.controller.emp.concert;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.concert.ISeatService;
import kr.or.ddit.vo.concert.ConcertSeatMapVO;
import kr.or.ddit.vo.concert.SeatVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/emp/concert")
public class EmpConcertSeatAPIController {

	@Autowired
	private ISeatService seatService;

	@PostMapping("/insertseat")
	public ResponseEntity<Object> insertSeat(@RequestBody SeatVO seatVO){
		log.info("seatVO : {}", seatVO);
		seatService.insertSeat(seatVO);
		return new ResponseEntity<>(HttpStatus.OK);
	}

	@GetMapping("/getseatinfo")
	public ResponseEntity<Object> getSeatInfo(int concertNo){
		List<ConcertSeatMapVO> seatGradeList = seatService.getSeatGradeInfo(concertNo);
		Map<String, Object> data = new HashMap<>();
		data.put("seatGradeList", seatGradeList);
		return new ResponseEntity<>(data,HttpStatus.OK);
	}

	@PostMapping("/seat/update")
	public ResponseEntity<Object> seatGradeUpdate(@RequestBody ConcertSeatMapVO csmVO){
		log.info("csmVO : {}", csmVO);
		ResponseEntity<Object> entity = null;
		ServiceResult result = seatService.updateConcertSeatMap(csmVO);

		if(ServiceResult.OK.equals(result)) {
			Map<String, Object> map = new HashMap<>();
			map.put("result", result);
			map.put("concertNo", csmVO.getConcertNo());
			entity = new ResponseEntity<>(map,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}
}
