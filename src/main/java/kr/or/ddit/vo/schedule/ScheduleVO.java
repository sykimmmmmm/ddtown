package kr.or.ddit.vo.schedule;

import lombok.Data;

@Data
public class ScheduleVO {

	private int id;						// 스케줄 고유번호
	private String title;				// 스케줄 제목
	private String start;				// 스케줄 시작 날짜
	private String end;					// 스케줄 종료 날짜
	private String textColor;			// 스케줄 글씨 색상
	private String url;					// 스케줄 경로
	private String backgroundColor;		// 스케줄 배경 색상
	private String allDayStatus;		// 데이터베이스 하루 일정 여부
	private boolean allDay;				// 하루 일정 여부

	private String content;
	private String place;
	private int artGroupNo;

	private String category;
	private String curMonthStart;
	private String curMonthEnd;

	private String artSchCatCode;

	private Integer comuNotiNo;
}
