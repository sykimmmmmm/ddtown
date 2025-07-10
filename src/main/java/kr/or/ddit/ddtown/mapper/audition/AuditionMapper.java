package kr.or.ddit.ddtown.mapper.audition;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.corporate.audition.AuditionUserVO;
import kr.or.ddit.vo.corporate.audition.AuditionVO;


@Mapper
public interface AuditionMapper {
	// 오디션 목록
	public List<AuditionVO> auditionList(PaginationInfoVO<AuditionVO> pagingVO);
	//목록 수
	public int selectAuditionCount(PaginationInfoVO<AuditionVO> pagingVO);
	//오디션 상세보기
	public AuditionVO detailAudition(int audiNo);
	//지원하기
	public int signup(AuditionUserVO auditionUserVO);

}
