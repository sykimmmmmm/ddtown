package kr.or.ddit.ddtown.service.emp.edms;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.edms.ApproverVO;
import kr.or.ddit.vo.edms.EdmsCommVO;
import kr.or.ddit.vo.edms.EdmsFormVO;
import kr.or.ddit.vo.edms.EdmsVO;
import kr.or.ddit.vo.user.EmployeeVO;

public interface IEdmsService {

	/**
	 * 문서 양식 가져오기
	 * @return
	 */
	public List<EdmsFormVO> getFormList();

	/**
	 * 해당 양식 가져오기
	 * @param formNo
	 * @return
	 */
	public EdmsFormVO getForm(int formNo);

	/**
	 * 문서 양식 업데이트
	 * @param formVO
	 * @return
	 */
	public ServiceResult updateForm(EdmsFormVO formVO);

	/**
	 * 부서 목록 가져오기
	 * @return
	 */
	public List<EdmsCommVO> getDepartList();

	/**
	 * 해당 부서코드를 가진 직원들 가져오기
	 * @param empDepartCode
	 * @return
	 */
	public List<EmployeeVO> getEmpList(String empDepartCode);

	/**
	 * 페이징 처리된 자신이 기안한 결재문서들 가져오기
	 * @param map
	 * @return
	 */
	public List<EdmsVO> selectApprovalBoxList(Map<String, Object> map);

	/**
	 * 페이징 처리된 토탈레코드 가져오기
	 * @param map
	 * @return 토탈레코드 수
	 */
	public int selectTotalRecord(Map<String, Object> map);

	/**
	 * 해당 결재문서 가져오기
	 * @param edmsNo
	 * @return
	 */
	public EdmsVO selectApproval(int edmsNo);

	/**
	 * 결재문서 변경사항 업데이트
	 * @param edmsVO
	 * @return
	 */
	public ServiceResult updateApproval(EdmsVO edmsVO);

	/**
	 * 결재문서 상신
	 * @param edmsVO
	 * @return
	 */
	public ServiceResult insertApproval(EdmsVO edmsVO);

	/**
	 * 결재할 문서 가져오기
	 * @param map
	 * @return
	 */
	public List<EdmsVO> selectApprovalRequestList(Map<String, Object> map);

	/**
	 * 결재문서 반려
	 * @param approverVO
	 * @return
	 */
	public ServiceResult updateAppovalReject(ApproverVO approverVO);

	/**
	 * 결재문서 승인
	 * @param approverVO
	 * @return
	 */
	public ServiceResult updateAppovalApprove(ApproverVO approverVO);

	/**
	 * 결재문서 회수
	 * @param edmsNo
	 * @return
	 */
	public ServiceResult withdrawEdms(int edmsNo);

	/**
	 * 요약 서머리 카운트 가져오기 (상신문서함 + 결재자인것 + 참조자인것)
	 * @param empUsername
	 * @return
	 */
	public Map<String, Object> selectSummaryMap(String empUsername);

	/**
	 * 요약 서머리 카운트 가져오기 ( 요청 + 결재자 + 참조자)
	 * @param empUsername
	 * @return
	 */
	public Map<String, Object> selectSummaryMapRequest(String empUsername);

}
