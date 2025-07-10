package kr.or.ddit.vo.concert;

import java.util.Date;
import java.util.List;

import kr.or.ddit.vo.common.CommonCodeDetailVO;
import lombok.Data;

@Data
public class TicketVO {
	private int ticketNo;
	private int concertNo;
	private String seatNo;
	private int concertHallNo;
	private String memUsername;
	private String seatGradeCode;
	private int orderDetNo;
	private int ticketPrice;
	private Date ticketReservationDate;
	private String ticketOnlineYn;
	private int goodsNo;

	//좌석 등급 리스트
	private List<CommonCodeDetailVO> seatGradeList;



}
