package kr.or.ddit.ddtown.service.emp.edms;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.emp.edms.IEdmsMapper;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.edms.ApproverVO;
import kr.or.ddit.vo.edms.EdmsCommVO;
import kr.or.ddit.vo.edms.EdmsFormVO;
import kr.or.ddit.vo.edms.EdmsVO;
import kr.or.ddit.vo.edms.ReferenceVO;
import kr.or.ddit.vo.user.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EdmsServiceImpl implements IEdmsService {

	@Autowired
	private IEdmsMapper edmsMapper;

	@Autowired
	private IFileService fileService;

	/**
	 * 양식 목록 가져오기
	 */
	@Override
	public List<EdmsFormVO> getFormList() {
		return edmsMapper.getFormList();
	}

	/**
	 *	해당 양식 가져오기
	 */
	@Override
	public EdmsFormVO getForm(int formNo) {
		return edmsMapper.getForm(formNo);
	}

	/**
	 *	문서양식 업데이트하기
	 */
	@Transactional
	@Override
	public ServiceResult updateForm(EdmsFormVO formVO) {
		ServiceResult result = null;
		int status = edmsMapper.updateForm(formVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	/**
	 * 부서 목록 가져오기
	 */
	@Override
	public List<EdmsCommVO> getDepartList() {
		return edmsMapper.getDepartList();
	}

	/**
	 * 해당 부서 직원들 불러오기
	 */
	@Override
	public List<EmployeeVO> getEmpList(String empDepartCode) {
		return edmsMapper.getEmpList(empDepartCode);
	}

	/**
	 * 자신이 기안한 결재문서 가져오기
	 */
	@Override
	public List<EdmsVO> selectApprovalBoxList(Map<String, Object> map) {
		return edmsMapper.selectApprovalBoxList(map);
	}

	/**
	 *	페이징 처리된 토탈레코드 수 가져오기
	 */
	@Override
	public int selectTotalRecord(Map<String, Object> map) {
		return edmsMapper.selectTotalRecord(map);
	}

	/**
	 * 해당 결재문서 가져오기
	 */
	@Override
	public EdmsVO selectApproval(int edmsNo) {
		return edmsMapper.selectApproval(edmsNo);
	}

	@Transactional
	@Override
	public ServiceResult updateApproval(EdmsVO edmsVO) {
		ServiceResult result = null;

		int fileGroupNo = edmsVO.getFileGroupNo();
		MultipartFile[] addFileList = edmsVO.getAddFileList();
		try {
			if(addFileList != null && addFileList.length > 0) {
				// 파일그룹번호가 있을시
				if(fileGroupNo != 0) {
					List<Integer> deleteList = edmsVO.getDeleteFileList();
					if(deleteList != null && !deleteList.isEmpty()) {
						fileService.deleteSpecificFiles(deleteList);
					}else {
						fileService.addFilesToExistingGroup(addFileList, "FITC011", null, fileGroupNo);
					}
				}else {
					// 파일 처리
					int fileGNo =fileService.uploadAndProcessFiles(addFileList, "FITC011");
					edmsVO.setFileGroupNo(fileGNo);
				}
			}
			// 결재자 변경시 결재자 수정용 리스트
			List<ApproverVO> approverList = edmsVO.getAddApproverList();
			// 참조자 변경시 참조자 수정용 리스트
			List<ReferenceVO> referenceList = edmsVO.getAddReferenceList();

			// edms 테이블 수정
			int status = edmsMapper.updateApproval(edmsVO);
			if(status > 0 ) {
				// 결재자 삭제
				status = edmsMapper.removeApprover(edmsVO.getEdmsNo());
				if(status > 0) {
					// 결재자 추가
					approverList.sort((o1, o2) -> {
						String approver1 = o1.getEmpPositionCode();
						String approver2 = o2.getEmpPositionCode();

						int postionNum1 = Integer.parseInt(approver1.substring(3));
						int postionNum2 = Integer.parseInt(approver2.substring(3));

						return Integer.compare(postionNum1, postionNum2);
					});
					int apvSec = 1;
					for(ApproverVO approver : approverList) {
						approver.setApvSec(apvSec);
						apvSec++;
						status = edmsMapper.addApprover(approver);
					}
					if(status > 0) {
						// 참조자 삭제
						status = edmsMapper.removeReference(edmsVO.getEdmsNo());
						if(status > 0) {
							// 참조자 추가
							for(ReferenceVO reference : referenceList) {
								status = edmsMapper.addReference(reference);
							}
							if(status > 0) {
								result = ServiceResult.OK;
							}else {
								result = ServiceResult.FAILED;
							}
						}else {
							result = ServiceResult.FAILED;
						}
					}else {
						result = ServiceResult.FAILED;
					}
				}else {
					result = ServiceResult.FAILED;
				}
			}else {
				result = ServiceResult.FAILED;
			}

		} catch (Exception e) {
			log.error("에러 발생 : {}", e.getMessage());
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Transactional
	@Override
	public ServiceResult insertApproval(EdmsVO edmsVO) {
		ServiceResult result = null;

		try {
			// 파일 처리
			MultipartFile[] addFileList = edmsVO.getAddFileList();
			if(addFileList != null && addFileList.length > 0 && StringUtils.isNotBlank(addFileList[0].getOriginalFilename())) {
				int fileGroupNo = fileService.uploadAndProcessFiles(addFileList, "FITC011");
				edmsVO.setFileGroupNo(fileGroupNo);
			}
			// 결재자 리스트
			List<ApproverVO> approverList = edmsVO.getAddApproverList();
			// 참조자 리스트
			List<ReferenceVO> referenceList = edmsVO.getAddReferenceList();
			// edms 데이터 추가
			int status = edmsMapper.insertApproval(edmsVO);
			if(status > 0) {
				// 결재자 추가
				// 결재자 추가
				approverList.sort((o1, o2) -> {
					String approver1 = o1.getEmpPositionCode();
					String approver2 = o2.getEmpPositionCode();

					int postionNum1 = Integer.parseInt(approver1.substring(3));
					int postionNum2 = Integer.parseInt(approver2.substring(3));

					return Integer.compare(postionNum1, postionNum2);
				});
				int apvSec = 1;
				for(ApproverVO approver : approverList) {
					approver.setEdmsNo(edmsVO.getEdmsNo());
					approver.setApvSec(apvSec);
					apvSec++;
					status = edmsMapper.addApprover(approver);
				}
				if(status > 0) {
					// 참조자 추가
					for(ReferenceVO reference : referenceList) {
						reference.setEdmsNo(edmsVO.getEdmsNo());
						status = edmsMapper.addReference(reference);
					}
					if(status > 0) {
						result = ServiceResult.OK;
					}else {
						result = ServiceResult.FAILED;
					}
				}else {
					result = ServiceResult.FAILED;
				}
			}else {
				result = ServiceResult.FAILED;
			}
		} catch (Exception e) {
			log.error("파일 추가 도중 에러 발생 : {}",e.getMessage());
			result = ServiceResult.FAILED;
		}
		return result;
	}



	@Override
	public List<EdmsVO> selectApprovalRequestList(Map<String, Object> map) {
		return edmsMapper.selectApprovalRequestList(map);
	}

	@Transactional
	@Override
	public ServiceResult updateAppovalReject(ApproverVO approverVO) {
		ServiceResult result = null;
		// edms 해당 문서 상태코드 반려로 변경
		int status = edmsMapper.updateApprovalReject(approverVO);

		if(status > 0) {
			// approver 자기꺼 반려사유 및 상태코드 , 반려 일자 추가
			status = edmsMapper.updateAPProverReject(approverVO);
			if(status > 0) {
				result = ServiceResult.OK;
			}else {
				result = ServiceResult.FAILED;
			}
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Transactional
	@Override
	public ServiceResult updateAppovalApprove(ApproverVO approverVO) {
		ServiceResult result = null;
		// edms 해당 문서 상태코드 esc001이면 esc002로 변경 esc002이면 esc003으로
		int status = edmsMapper.updateApprovalApprove(approverVO);

		if(status > 0) {
			// approver 자기꺼 상태코드 승인으로 변경
			status = edmsMapper.updateAPProverApprove(approverVO);
			if(status > 0) {
				result = ServiceResult.OK;
			}else {
				result = ServiceResult.FAILED;
			}
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Transactional
	@Override
	public ServiceResult withdrawEdms(int edmsNo) {
		ServiceResult result = null;
		int status = edmsMapper.withdrawEdms(edmsNo);
		if(status > 0) {
			status = edmsMapper.withdrawEdmsApproval(edmsNo);
			if(status > 0) {
				result = ServiceResult.OK;
			}else {
				result = ServiceResult.FAILED;
			}
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	/**
	 * 상신 문서함 서머리 가져오기
	 */
	@Override
	public Map<String, Object> selectSummaryMap(String empUsername) {
		return edmsMapper.selectSummaryMap(empUsername);
	}

	/**
	 * 결재/참조 리스트함 서머리 가져오기
	 */
	@Override
	public Map<String, Object> selectSummaryMapRequest(String empUsername) {
		return edmsMapper.selectSummaryMapRequest(empUsername);
	}

}
