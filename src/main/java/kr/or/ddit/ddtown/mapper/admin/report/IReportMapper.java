package kr.or.ddit.ddtown.mapper.admin.report;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.report.ReportVO;

@Mapper
public interface IReportMapper {
	//신고 목록페이지
	public List<ReportVO> reportList(PaginationInfoVO<ReportVO> pagingVO);
	//신고 목록 수
	public int selectReportCount(PaginationInfoVO<ReportVO> pagingVO);

	//1-1.신고 상세페이지
	public ReportVO reportDetail1(int reportNo);
	//1-2.신고된 게시글의 총신고 수, 신고자들 조회
	public List<ReportVO> reportDetail2(ReportVO paramVO);
	//1-3. 게시글일경우 파일이미지화면에 가지고 오기
	public List<AttachmentFileDetailVO> reportDetail3(ReportVO paramVO);

	/* 신고 처리하기 버튼 */
	//1.REPORTS테이블 업데이트(게시물에 대해 동일신고 건수가 있을 시 일괄 처리)
	public int reportUpdate(ReportVO reportVO);
	//2.REPORTS_DETAIL 업데이트( 신고날짜를 오늘날짜로 업데이트)
	public int reportUpdate2(ReportVO reportVO);
	//2-1. reportTargetTypeCode : RTTC001 이면서 reportResultCode : RRTC002(콘텐츠 삭제) 해당 게시글 삭제여부 활성화
	public int updatePostDelYn(int targetComuPostNo);
	//2-2. reportTargetTypeCode : RTTC002 이면서 reportResultCode : RRTC002 => 해당 댓글 삭제여부 활성화
	public int updateReplyDelYn(int targetComuPostNo);
	//2-3. reportTargetTypeCode : RTTC003 이면서 reportResultCode : RRTC002 => 해당 채팅메세지 삭제여부 활성화
	public int deleteChat(int targetComuPostNo);
	//3. 그 사람에 대한 총 신고건수가 10건 넘어가면 벤여부 활성화
	public int reportUpdate3(ReportVO reportVO);
	//3-1.신고당한사람이 가장많이 신고 당한 유형 알아내기
//	public String selectManyReportReasonCode(String targetMemUsername);
	//4. BLACKLIST 테이블 삽입(총 신고 건수가 10건이상이된 사람이 있으면 블랙리스트 목록에 비활성화로 자동추가
//	public int reportUpdate4(BlacklistVO blacklistVO);

	//신고상세에서 블랙리스트 추가 누를시 회원 아이디 가지고 오기
//	public String getUsernameReportNo(Integer reportNo);

	//신고 미처리 수
	public int reportCnt();
	//신고 사유 유형별 수
	public List<Map<String, Object>> reportReasonCnt();
	// "총 신고" 수를 위한 파라미터 맵 생성(검색영향X)
	public int totalReportCount(Map<String, Object> totalCountParams);
	/**
	 * 미처리 신고수 가져오기
	 * @return
	 */
	public int getReportCnt();

	//신고 상세 블랙리스트 등록페이지로 가지고 오기
	public ReportVO getUserReportDetail(Integer reportNo);

	//블랙리스트 상세페이지에 신고 목록 불러오기
	public List<ReportVO> userReports(String memId, PaginationInfoVO<ReportVO> pagingVO);
	//블랙리스트 상세페이지의 신고 수
	public int countUserReports(String memId, PaginationInfoVO<ReportVO> pagingVO);





}
