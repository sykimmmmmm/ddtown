package kr.or.ddit.vo.concert;

import lombok.Data;

@Data
public class ConcertSeatMapVO {
	private int concertNo;
	private String seatSection;
	private String seatGradeCode;
	private int seatPrice;
	private String seatGradeNm;
	private int sectionCount;
}
