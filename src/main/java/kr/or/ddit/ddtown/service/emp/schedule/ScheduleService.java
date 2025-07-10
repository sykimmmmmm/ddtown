package kr.or.ddit.ddtown.service.emp.schedule;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.emp.schedule.IScheduleMapper;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.concert.ConcertNoticeVO;
import kr.or.ddit.vo.concert.ConcertVO;
import kr.or.ddit.vo.schedule.ScheduleDetailVO;
import kr.or.ddit.vo.schedule.ScheduleVO;

@Service
public class ScheduleService implements IScheduleService {

	@Autowired
	private IScheduleMapper scheduleMapper;

	@Override
	public ArtistGroupVO getList(String empUsername) {

		ArtistGroupVO groupVO = scheduleMapper.getList(empUsername);

		if(groupVO != null) {
			changeAllDay(groupVO.getSchedule());
		}

		return groupVO;
	}

	private void changeAllDay(List<ScheduleVO> list) {
		for (ScheduleVO vo : list) {
			String status = vo.getAllDayStatus();
			if(status.equals("Y")) {
				vo.setAllDay(true);
				continue;
			}

			vo.setAllDay(false);
		}
	}

	@Override
	public ScheduleDetailVO getDes(int id) {
		ScheduleDetailVO vo = scheduleMapper.getDes(id);

		return vo;
	}

	@Override
	public ServiceResult dateUpdate(ScheduleVO scheduleVO) {

		ServiceResult result = null;

		String allDay = scheduleVO.getAllDayStatus();

		if(allDay.equals("Y")) {
			String endDate = scheduleVO.getEnd();
			LocalDateTime date = LocalDateTime.parse(endDate);
			String newEndDate = date.plusDays(1).toString();
			scheduleVO.setEnd(newEndDate);
		}

		int status = scheduleMapper.dateUpdate(scheduleVO);

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public ServiceResult dateMove(ScheduleVO scheduleVO) {
		ServiceResult result = null;

		int status = scheduleMapper.dateMove(scheduleVO);

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public ServiceResult dateInsert(ScheduleVO scheduleVO) {

		ServiceResult result = null;

		String allDay = scheduleVO.getAllDayStatus();

		if(allDay.equals("Y")) {
			String endDate = scheduleVO.getEnd();
			LocalDateTime date = LocalDateTime.parse(endDate);
			String newEndDate = date.plusDays(1).toString();
			scheduleVO.setEnd(newEndDate);
		}

		int status = scheduleMapper.dateInsert(scheduleVO);

		if(status > 0) {
			// 매핑 정보 저장
			if(scheduleVO.getComuNotiNo() != null) {
				// 공지사항 매핑 저장
				scheduleMapper.insertConcertNoticeMap(scheduleVO.getId(), scheduleVO.getComuNotiNo());
			}
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public ServiceResult dateDelete(int id) {
		ServiceResult result = null;

		int status = scheduleMapper.dateDelete(id);

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public List<ConcertVO> concertNoticeList(ScheduleVO scheduleVO) {

		String category = scheduleVO.getCategory();
		if(category.equals("concert")) {
			scheduleVO.setArtSchCatCode("ASCC002");
		}

		return scheduleMapper.concertNoticeList(scheduleVO);
	}

	@Override
	public ConcertVO selectConcertData(ConcertVO concertVO) {
		return scheduleMapper.selectConcertData(concertVO);
	}

	@Override
	public List<ConcertNoticeVO> noticeList(ScheduleVO scheduleVO) {

		return scheduleMapper.noticeList(scheduleVO);
	}

	@Override
	public ConcertNoticeVO selectNoticeData(ConcertNoticeVO noticeVO) {
		return scheduleMapper.selectNoticeData(noticeVO);
	}

}
