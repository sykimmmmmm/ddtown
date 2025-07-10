package kr.or.ddit.ddtown.mapper.admin.blacklist;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.blacklist.BlacklistVO;

@Mapper
public interface IBlacklistMapper {

	//목록페이지
	public List<BlacklistVO> blackList(PaginationInfoVO<BlacklistVO> pagingVO);
	//목록 수
	public int selectBlacklistCount(PaginationInfoVO<BlacklistVO> pagingVO);

	//상세페이지
	public BlacklistVO blackDetail(int banNo);

	/* 등록하기 */
	//1.회원인지 아닌지 체크
	public int checkMemberId(String memUsername);
	//2. 이미 활성 블랙리스트에 등록되어 있는지 확인
	public int checkIdBlacklist(String memUsername);
	//3.등록하기
	public int blackSignup(BlacklistVO blacklistVO) throws Exception;
	//4.회원목록에서 해당 회원 상태코드 변경
	public int memListStatUpdate(BlacklistVO blacklistVO);

	//수정하기
	public int blackUpdate(BlacklistVO blacklistVO);

	/* 즉시 해제하기 */
	//1.해제(삭제)하기
	public int blackDelete(BlacklistVO blacklistVO);
	//2.MEMBER 테이블 회원 상태코드 변경(즉시해제)
	public int blackDelete2(String memUsername);

	//뱃지: 블랙리스트 수
	public int blacklistCnt();
	//뱃지: 블랙리스트 사유별 수
	public List<Map<String, Object>> blackReasonCnts();
	//뱃지: "총 차단" 수를 위한 파라미터 맵 생성(검색영향X)
	public int totalBlakcCount(Map<String, Object> totalCountParams);

	/* 자동해제하기 */
	//1.블랙리스트 자동해제(회원 조회)
	public List<String> getAutoReleaseTargetUsernames(LocalDate today);
	//2.블랙리스트 자동 해제(blacklist 테이블 업데이트)
	public int uploadBlackScheduler(LocalDate today);
	//3.MEMBER테이블 회원상태코드 변경
	public int memberStateUpdate(@Param("usernames")List<String> targetUsernames);

}
