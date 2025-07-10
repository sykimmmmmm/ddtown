package kr.or.ddit.ddtown.mapper.emp.schedule;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.concert.ConcertNoticeVO;
import kr.or.ddit.vo.concert.ConcertVO;
import kr.or.ddit.vo.schedule.ScheduleDetailVO;
import kr.or.ddit.vo.schedule.ScheduleVO;

@Mapper
public interface IScheduleMapper {

	public ArtistGroupVO getList(String empUsername);

	public ScheduleDetailVO getDes(int id);

	public int dateUpdate(ScheduleVO scheduleVO);

	public int dateMove(ScheduleVO scheduleVO);

	public int dateInsert(ScheduleVO scheduleVO);

	public int dateDelete(int id);

	public List<ConcertVO> concertNoticeList(ScheduleVO scheduleVO);

	public ConcertVO selectConcertData(ConcertVO concertVO);

	public List<ConcertNoticeVO> noticeList(ScheduleVO scheduleVO);

	public ConcertNoticeVO selectNoticeData(ConcertNoticeVO noticeVO);

	public int insertConcertNoticeMap(int artScheduleNo, Integer comuNotiNo);

}
