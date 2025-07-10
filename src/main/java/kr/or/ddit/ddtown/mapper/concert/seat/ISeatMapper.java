package kr.or.ddit.ddtown.mapper.concert.seat;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.common.CommonCodeDetailVO;
import kr.or.ddit.vo.concert.ConcertSeatMapVO;
import kr.or.ddit.vo.concert.ConcertVO;
import kr.or.ddit.vo.concert.SeatVO;
import kr.or.ddit.vo.concert.TicketVO;

@Mapper
public interface ISeatMapper {

	/**
	 * 콘서트 예정 목록 불러오기
	 * @return
	 */
	public List<ConcertVO> selectConcertList();

	/**
	 * 모든 정보가 들어있는 좌석 인서트
	 * @param seatVO
	 */
	public void insertSeat(SeatVO seatVO);

	/**
	 * 좌석 등급 정보를 가져오기위한 티켓정보 가져오기
	 * @param concertNo
	 * @return
	 */
	public List<TicketVO> getTicketInfo(int concertNo);

	/**
	 * 좌석 등급을 가져오기위한 공통상세가져오기
	 * @param concertNo
	 * @return
	 */
	public List<ConcertSeatMapVO> getSeatGradeInfo(int concertNo);

	/**
	 * 티켓정보를 추가하기위한 좌석정보 가져오기
	 * @param concertHallNo
	 * @return
	 */
	public List<SeatVO> getSeatInfo(int concertHallNo);

	/**
	 * 콘서트 좌석 등급 매핑데이터 추가를 위한 시트 섹션정보 가져오기
	 * @param concertHallNo
	 * @return
	 */
	public List<String> selectSeatSection(int concertHallNo);

	/**
	 * 콘서트 좌석 등급 매핑 테이블 추가
	 * @param csmVO
	 * @return
	 */
	public int insertConcertSeatMap(ConcertSeatMapVO csmVO);

	/**
	 * 티켓 정보 추가
	 * @param ticketVO
	 * @return
	 */
	public int insertTikcet(TicketVO ticketVO);

	/**
	 * 공통코드 테이블에서 좌석등급정보 가져오기
	 * @return
	 */
	public List<CommonCodeDetailVO> selectGradeList();

	/**
	 * concert_seat_map 정보 변경
	 * @param csmVO
	 * @return
	 */
	public int updateConcertSeatMap(ConcertSeatMapVO csmVO);

	/**
	 * ticket 정보 수정
	 * @param csmVO
	 * @return
	 */
	public int updateTicket(ConcertSeatMapVO csmVO);

}
