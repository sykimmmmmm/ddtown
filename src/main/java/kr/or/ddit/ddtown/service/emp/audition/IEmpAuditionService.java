package kr.or.ddit.ddtown.service.emp.audition;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.corporate.audition.AuditionUserVO;
import kr.or.ddit.vo.corporate.audition.AuditionVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;

public interface IEmpAuditionService {
	// 직원 오디션 목록페이지
	public List<AuditionVO> auditionList(PaginationInfoVO<AuditionVO> pagingVO);
	// 오디션 일정 상세보기
	public AuditionVO detailAudition(int audiNo);
	//오디션 일정 등록하기
	public ServiceResult insertAudition(AuditionVO auditionVO) throws Exception;
	//오디션 일정 수정하기
	public ServiceResult updateAudition(AuditionVO auditionVO) throws Exception;
	//오디션 삭제하기
	public ServiceResult deleteAudition(int audiNo);
	//게시글 수
	public int selectAuditionCount(PaginationInfoVO<AuditionVO> pagingVO);
	//파일 다운로드
	public AttachmentFileDetailVO auditionDownload(int attachDetailNo);


//	//오디션지원자 목록
	public List<AuditionUserVO> auditionUserList();
	//오디션지원자 목록의 드롭 리스트
	public List<AuditionVO> auditionDropdownList(String auditionStatusCode);
	//전체/진행/마감된 오디션 드롭 리스트
//	public List<AuditionVO> getAuditionList(String mode);
	//오디션 지원자 검색목록
//	public List<AuditionUserVO> auditionUserLists(int audiNo);
	//지원자 상세정보
	public AuditionUserVO auditionUserDetail(int appNo);
	//지원상태 변환
	public AuditionUserVO stauesUpdate(AuditionUserVO auditionUserVO);
	//지원자목록 수
	public int auditionUserCount(PaginationInfoVO<AuditionUserVO> pagingVO);
	//오디션지원자 목록(페이징)
	public List<AuditionUserVO> auditionUserList(PaginationInfoVO<AuditionUserVO> pagingVO);
	//오디션 진행 현황 수
	public Map<String, Integer> auditionStatCnts();
	//심사결과 유형별 수
	public Map<String, Integer> appStatCodeCnt(PaginationInfoVO<AuditionUserVO> pagingVO);
	//총 지원 수를 위한 파라미터 맵 생성(searchWord 제외(검색영향X))
	public int totalApplicantCount(Map<String, Object> totalCountParams);
	// "총 오디션" 수를 위한 파라미터 맵 생성(검색영향X)
	public int totalReportCount(Map<String, Object> totalCountParams);
	//오디션 일정 자동 변경
	public void uploadAuditionScheduler();

}
