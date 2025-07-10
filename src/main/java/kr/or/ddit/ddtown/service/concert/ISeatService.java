package kr.or.ddit.ddtown.service.concert;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.common.CommonCodeDetailVO;
import kr.or.ddit.vo.concert.ConcertSeatMapVO;
import kr.or.ddit.vo.concert.ConcertVO;
import kr.or.ddit.vo.concert.SeatVO;
import kr.or.ddit.vo.concert.TicketVO;

public interface ISeatService {

	/**
	 * 콘서트 예정 목록 불러오기
	 * @return
	 */
	public List<ConcertVO> selectConcertList();

	/**
	 * 좌석추가 모든 정보 다들어있어야함
	 * @param seatVO
	 */
	public void insertSeat(SeatVO seatVO);

	/**
	 * 좌석 등급관리를 위한 티켓정보 가져오기
	 * @param concertNo
	 * @return
	 */
	public List<TicketVO> getTicketInfo(int concertNo);

	/**
	 * 좌석 등급을 가져오기
	 * @param concertNo
	 * @return
	 */
	public List<ConcertSeatMapVO> getSeatGradeInfo(int concertNo);

	/**
	 * 콘서트 생성시 티켓정보 생성하기
	 * @param concertVO
	 * @param goodsNo
	 * @return
	 */
	public ServiceResult insertTicket(ConcertVO concertVO, int goodsNo);

	/**
	 * 공통코드 테이블에서 좌석 등급 코드 가져오기
	 * @return
	 */
	public List<CommonCodeDetailVO> selectGradeList();

	/**
	 * concert_seat_map 좌석등급및 가격정보 수정 및
	 * ticket 가격 정보 수정
	 * @param csmVO
	 * @return
	 */
	public ServiceResult updateConcertSeatMap(ConcertSeatMapVO csmVO);



}
