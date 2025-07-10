package kr.or.ddit.ddtown.mapper.community;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.common.CommonCodeDetailVO;
import kr.or.ddit.vo.schedule.ScheduleVO;

@Mapper
public interface ICommunityLSNMapper {

	public List<ScheduleVO> scheduleList(int artGroupNo);

	public List<CommonCodeDetailVO> getCodeList();

}
