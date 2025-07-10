package kr.or.ddit.ddtown.service.admin.blacklist;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.blacklist.BlacklistVO;
import kr.or.ddit.vo.report.ReportVO;

public interface IBlacklistService {

	//블랙리스트 목록페이지
	public List<BlacklistVO> blackList(PaginationInfoVO<BlacklistVO> pagingVO);
	//상세페이지
	public BlacklistVO blackDetail(int banNo);

	//등록하기
	public ServiceResult blackSignup(BlacklistVO blacklistVO) throws Exception;
	//신고상세에서 블랙리스트 추가 누를시 회원 아이디 가지고 오기
//	public String getUsernameReportNo(Integer reportNo);
	//신고상세에서 블랙리스트 추가 누를시 회원 아이디와 해당 신고 상세정보 가지고 오기
	public ReportVO getReportDetail(Integer reportNo);

	//수정하기
	public ServiceResult blackUpdate(BlacklistVO blacklistVO) throws Exception;
	// 해제하기
	public ServiceResult blackDelete(BlacklistVO blacklistVO);
	//블랙리스트 자동 해제
	public void uploadBlackScheduler();

	// 목록 수
	public int selectBlacklistCount(PaginationInfoVO<BlacklistVO> pagingVO);
	//뱃지: 현재 블랙리스트 수
	public int blacklistCnt();
	//뱃지: 사유별 블랙리스트 수
	public Map<String, Integer> blackReasonCnts();
	//목록페이지의 뱃지: "총 차단" 수를 위한 파라미터 맵 생성(검색영향X)
	public int totalBlakcCount(Map<String, Object> totalCountParams);

}
