package kr.or.ddit.ddtown.mapper.emp.audition;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.corporate.audition.AuditionUserVO;
import kr.or.ddit.vo.corporate.audition.AuditionVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;

@Mapper
public interface IEmpAuditionMapper {
	//오디션 목록
	public List<AuditionVO> auditionList(PaginationInfoVO<AuditionVO> pagingVO);
	//오디션 일정 상세보기
	public AuditionVO detailAudition(int audiNo);
	//오디션 일정 등록하기
	public int insertAudition(AuditionVO auditionVO);
	//오디션 일정 삭제하기
	public int deleteAudition(int audiNo);
	// 오디션 지원자 삭제
	public int deleteApplicantsByAuditionNo(int audiNo);
	// 오디션 일정 수정하기
	public int updateAudition(AuditionVO auditionVO);
	//기존 파일그룹번호를 가진 ATTACHMENT_FILE_DETAIL 테이블의 FILE_GROUP_NO를 새로운 번호로 업데이트
	public int updateAttachmentFileDetailFileGroupNo(Map<String, Object> map);
	// 게시글 수
	public int selectAuditionCount(PaginationInfoVO<AuditionVO> pagingVO);
	//다운로드
	public AttachmentFileDetailVO auditionDownload(int attachDetailNo);

	//오디션 지원자 목록
	public List<AuditionUserVO> auditionUserList();
	//오디션지원자 목록의 드롭 리스트
	public List<AuditionVO> auditionDropdownList(String auditionStatusCode);
	//오디션 지원자 검색 목록
//	public List<AuditionUserVO> auditionUserLists(int audiNo);
	//지원자 상세보기
	public AuditionUserVO auditionUserDetail(int appNo);
	//지원 상태 변환
	public int stauesUpdate(AuditionUserVO auditionUserVO);
	//지원자 목록 수
	public int auditionUserCount(PaginationInfoVO<AuditionUserVO> pagingVO);
	//지원자 목록
	public List<AuditionUserVO> auditionUserList(PaginationInfoVO<AuditionUserVO> pagingVO);
	//오디션 진행 현황 수
	public List<Map<String, Object>> auditionStatCnts();
	//전체/진행/마감된 오디션 드롭 리스트
//	public List<AuditionVO> getAuditionList(String mode);
	//심사결과 유형별 수
	public List<Map<String, Object>> appStatCodeCnt(PaginationInfoVO<AuditionUserVO> pagingVO);
	//총 지원 수를 위한 파라미터 맵 생성(searchWord 제외(검색영향X))
	public int totalApplicantCount(Map<String, Object> totalCountParams);
	// 1. "총 오디션" 수를 위한 파라미터 맵 생성(검색영향X)
	public int totalReportCount(Map<String, Object> totalCountParams);

	// 1-1. AUDITION 테이블 업데이트(오디션 진행중으로 변경)
	public int statSchedulerCount(LocalDate today);
	// 1-2. AUDITION 테이블 업데이트(오디션 마감으로 변경)
	public int endSchedulerCount(LocalDate today);




}
