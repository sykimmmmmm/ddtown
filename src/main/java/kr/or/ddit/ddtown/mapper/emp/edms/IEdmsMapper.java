package kr.or.ddit.ddtown.mapper.emp.edms;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.edms.ApproverVO;
import kr.or.ddit.vo.edms.EdmsCommVO;
import kr.or.ddit.vo.edms.EdmsFormVO;
import kr.or.ddit.vo.edms.EdmsVO;
import kr.or.ddit.vo.edms.ReferenceVO;
import kr.or.ddit.vo.user.EmployeeVO;

@Mapper
public interface IEdmsMapper {

	/**
	 * 양식 불러오기
	 * @return
	 */
	public List<EdmsFormVO> getFormList();

	/**
	 * 해당 폼양식 불러오기
	 * @param formNo
	 * @return
	 */
	public EdmsFormVO getForm(int formNo);

	/**
	 * 폼 양식 수정
	 * @param formVO
	 * @return
	 */
	public int updateForm(EdmsFormVO formVO);

	/**
	 * 부서 목록 불러오기
	 * @return
	 */
	public List<EdmsCommVO> getDepartList();

	/**
	 * 해당 부서 직원 목록 불러오기
	 * @param empDepartCode
	 * @return
	 */
	public List<EmployeeVO> getEmpList(String empDepartCode);

	/**
	 * 자신이 기안한 결재 문서 가져오기
	 * @param map
	 * @return
	 */
	public List<EdmsVO> selectApprovalBoxList(Map<String, Object> map);

	/**
	 * 페이징처리된 토탈레코드 구하기
	 * @param map
	 * @return
	 */
	public int selectTotalRecord(Map<String, Object> map);

	/**
	 * 해당 결재문서 가져오기
	 * @param edmsNo
	 * @return
	 */
	public EdmsVO selectApproval(int edmsNo);

	/**
	 * 결재문서 업데이트
	 * @param edmsVO
	 * @return
	 */
	public int updateApproval(EdmsVO edmsVO);

	/**
	 * 해당 결제문서 기안자 정보 삭제
	 * @param edmsNo
	 * @return
	 */
	public int removeApprover(int edmsNo);

	/**
	 * 해당 결재문서 기안자 정보 추가
	 * @param approver
	 * @return
	 */
	public int addApprover(ApproverVO approver);

	/**
	 * 해당 결재문서 참조자 정보 삭제
	 * @param edmsNo
	 * @return
	 */
	public int removeReference(int edmsNo);

	/**
	 * 해당 결재문서 참조자 정보 추가
	 * @param reference
	 * @return
	 */
	public int addReference(ReferenceVO reference);

	/**
	 * 결재문서 추가
	 * @param edmsVO
	 * @return
	 */
	public int insertApproval(EdmsVO edmsVO);

	/**
	 * 결재할 문서 가져오기
	 * @param map
	 * @return
	 */
	public List<EdmsVO> selectApprovalRequestList(Map<String, Object> map);

	/**
	 * 결재자 테이블 정보 수정
	 * @param approverVO
	 * @return
	 */
	public int updateAPProverReject(ApproverVO approverVO);

	/**
	 * 결재문서 정보 수정
	 * @param approverVO
	 * @return
	 */
	public int updateApprovalReject(ApproverVO approverVO);

	/**
	 * 결재문서 정보 승인관련으로 수정
	 * @param approverVO
	 * @return
	 */
	public int updateApprovalApprove(ApproverVO approverVO);

	/**
	 * 결재자 정보 수정
	 * @param approverVO
	 * @return
	 */
	public int updateAPProverApprove(ApproverVO approverVO);

	/**
	 * 결재 문서 회수 처리
	 * @param edmsNo
	 * @return
	 */
	public int withdrawEdms(int edmsNo);

	/**
	 * 결재자 쪽 회수상태로 변경
	 * @param edmsNo
	 * @return
	 */
	public int withdrawEdmsApproval(int edmsNo);

	/**
	 * 요약 카운트 가져오기
	 * @param empUsername
	 * @return
	 */
	public Map<String, Object> selectSummaryMap(String empUsername);

	/**
	 * 결재/참조 문서함 카운트 가져오기
	 * @param empUsername
	 * @return
	 */
	public Map<String, Object> selectSummaryMapRequest(String empUsername);

}
