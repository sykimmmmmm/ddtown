package kr.or.ddit.ddtown.service.community;

import java.util.List;

import kr.or.ddit.vo.common.CommonCodeDetailVO;
import kr.or.ddit.vo.concert.ConcertNoticeVO;
import kr.or.ddit.vo.schedule.ScheduleVO;

public interface ICommunityLSNService {

	public List<ScheduleVO> scheduleList(int artGroupNo);

	public List<ConcertNoticeVO> noticeList(int artGroupNo);

	public List<CommonCodeDetailVO> getCodeList();

}
