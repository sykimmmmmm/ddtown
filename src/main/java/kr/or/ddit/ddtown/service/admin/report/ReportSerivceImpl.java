package kr.or.ddit.ddtown.service.admin.report;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.admin.report.IReportMapper;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.report.ReportVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ReportSerivceImpl implements IReportService {

	@Autowired
	private IReportMapper reportMapper;

	@Autowired
	private IFileService fileService;

	//신고 목록페이지
	@Override
	public List<ReportVO> reportList(PaginationInfoVO<ReportVO> pagingVO) {
		return reportMapper.reportList(pagingVO);
	}
	//총 신고 목록 수
	@Override
	public int selectReportCount(PaginationInfoVO<ReportVO> pagingVO) {
		return reportMapper.selectReportCount(pagingVO);
	}

	//신고상세페이지
	@Override
	public ReportVO reportDetail(int reportNo) {
		//상세 기본정보 조회
		ReportVO reportDetail = reportMapper.reportDetail1(reportNo);

		//해당게시글 총 신고 횟수, 신고자ID 목록 및 신고 사유
		 if (reportDetail != null) {
			 ReportVO paramVO = new ReportVO();
			 paramVO.setReportTargetTypeCode(reportDetail.getReportTargetTypeCode());

			 String targetTypeCode = reportDetail.getReportTargetTypeCode();
	            if ("RTTC001".equals(targetTypeCode)) {			// 게시글 신고인 경우
	                paramVO.setTargetComuPostNo(reportDetail.getTargetComuPostNo());
	            } else if ("RTTC002".equals(targetTypeCode)) {		// 댓글 신고인 경우
	                paramVO.setTargetComuReplyNo(reportDetail.getTargetComuReplyNo());
	            } else if ("RTTC003".equals(targetTypeCode)) {
	                paramVO.setTargetChatNo(reportDetail.getTargetChatNo());
	            }
	            // 해당 게시글/댓글/채팅에 대한 모든 개별 신고(신고자 ID, 신고 사유 등) 목록을 조회
	            List<ReportVO> individualReports  = reportMapper.reportDetail2(paramVO);

	            reportDetail.setReportedCount(individualReports.size());

	            reportDetail.setIndividualReportList(individualReports);
	            //파일 정보 가지고 오기(게시글인 경우만 해당)
	            if ("RTTC001".equals(targetTypeCode)) {
	                List<AttachmentFileDetailVO> fileList = reportMapper.reportDetail3(paramVO);
	                try {
						List<AttachmentFileDetailVO> files = fileService.getFileDetailsByGroupNo(fileList.get(0).getFileGroupNo());
						reportDetail.setFileList(files);
					} catch (Exception e) {
						e.printStackTrace();
					}
	            }
		 }
		return reportDetail;
	}

	//신고처리
	@Transactional
	@Override
	public ServiceResult reportUpdate(ReportVO reportVO) {
		ServiceResult result = null;
		//1.REPORTS테이블 업데이트(게시물에 대해 동일신고 건수가 있을 시 일괄 처리)
		int report = reportMapper.reportUpdate(reportVO);
		log.info("reportUpdate->report1 : " + report);

		if(report > 0) {
			//2.REPORTS_DETAIL 업데이트( 신고날짜를 오늘날짜로 업데이트)
			report += this.reportMapper.reportUpdate2(reportVO);
			log.info("reportUpdate->report2 : " + report);

			//2-1. reportTargetTypeCode : RTTC001 이면서 reportResultCode : RRTC002(콘텐츠 삭제) 해당 게시글 삭제여부 활성화
			if(reportVO.getReportTargetTypeCode().equals("RTTC001")&&reportVO.getReportResultCode().equals("RRTC002")) {
				report += this.reportMapper.updatePostDelYn(reportVO.getTargetComuPostNo());
				log.info("reportUpdate->report2-1 : " + report);
			}

			//2-2. reportTargetTypeCode : RTTC002 이면서 reportResultCode : RRTC002 => 해당 댓글 삭제여부 활성화
			if(reportVO.getReportTargetTypeCode().equals("RTTC002")&&reportVO.getReportResultCode().equals("RRTC002")) {
				report += this.reportMapper.updateReplyDelYn(reportVO.getTargetComuPostNo());
				log.info("reportUpdate->report2-2 : " + report);
			}

			//2-3. reportTargetTypeCode : RTTC003 이면서 reportResultCode : RRTC002 => 해당 채팅메세지 삭제여부 활성화
			if(reportVO.getReportTargetTypeCode().equals("RTTC003")&&reportVO.getReportResultCode().equals("RRTC002")) {
				report += this.reportMapper.deleteChat(reportVO.getTargetComuPostNo());
				log.info("reportUpdate->report2-3 : " + report);
			}

			//3. 그 사람에 대한 총 신고건수가 10건 넘어가면 벤여부 활성화
			this.reportMapper.reportUpdate3(reportVO);

			result = ServiceResult.EXIST;
		}else {
			result = ServiceResult.NOTEXIST;
		}
		return result;
	}

	//신고 미처리 수
	@Override
	public int reportCnt() {
		return reportMapper.reportCnt();
	}

	//신고 사유 유형별 수
	@Override
	public Map<String, Integer> reportReasonCnt() {
		Map<String, Integer> reasonCnts = new HashMap<>();
		// 신고 사유가 없을 때 기본 0으로 표기
		reasonCnts.put("RRC001", 0);
		reasonCnts.put("RRC002", 0);
		reasonCnts.put("RRC003", 0);
		reasonCnts.put("RRC004", 0);

		List<Map<String, Object>> reportReasonCnt = reportMapper.reportReasonCnt();
		log.info("매퍼 결과 (reportReasonCnt): {}", reportReasonCnt);
		// 가져온 결과 리스트를 반복하면서 Map에 값을 업데이트
		for (Map<String, Object> entry  : reportReasonCnt) {
			log.info("처리 중인 entry: {}", entry);
            String reasonCode = (String) entry.get("REASONCODE"); // DB에서 넘어온 사유 코드
            Integer count = ((Number) entry.get("COUNT")).intValue();	//카운트 값을 Integer로 변환
            reasonCnts.put(reasonCode, count);

        }
        return reasonCnts;
	}
	// "총 신고" 수를 위한 파라미터 맵 생성(검색영향X)
	@Override
	public int totalReportCount(Map<String, Object> totalCountParams) {
		return reportMapper.totalReportCount(totalCountParams);
	}


	/**
	 * 미처리 신고 가져오기
	 */
	@Override
	public int getReportCnt() {
		return reportMapper.getReportCnt();
	}

	//블랙리스트 상세페이지에 신고 목록 불러오기
	@Override
	public List<ReportVO> userReports(String memId, PaginationInfoVO<ReportVO> pagingVO) {
		return reportMapper.userReports(memId, pagingVO);
	}
	//블랙리스트 상세페이지의 신고 수
	@Override
	public int countUserReports(String memId, PaginationInfoVO<ReportVO> pagingVO) {
		return reportMapper.countUserReports(memId, pagingVO);
	}
}
