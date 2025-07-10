package kr.or.ddit.ddtown.service.admin.blacklist;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.admin.blacklist.IBlacklistMapper;
import kr.or.ddit.ddtown.mapper.admin.report.IReportMapper;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.blacklist.BlacklistVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.report.ReportVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BlacklistSerivceImpl implements IBlacklistService{

	@Autowired
	public IBlacklistMapper blacklistMapper;

	@Autowired
    private IReportMapper reportMapper;

	@Autowired
	private IFileService fileService;

	//목록페이지
	@Override
	public List<BlacklistVO> blackList(PaginationInfoVO<BlacklistVO> pagingVO) {
		return blacklistMapper.blackList(pagingVO);
	}
	//블랙리스트 목록 수(비활성화 상태도 포함)
	@Override
	public int selectBlacklistCount(PaginationInfoVO<BlacklistVO> pagingVO) {
		return blacklistMapper.selectBlacklistCount(pagingVO);
	}

	//상세페이지
	@Override
	public BlacklistVO blackDetail(int banNo) {
		return blacklistMapper.blackDetail(banNo);
	}
	//등록하기
	@Override
	public ServiceResult blackSignup(BlacklistVO blacklistVO) throws Exception {
		//1.회원인지 아닌지 체크
		int checkMemberId = blacklistMapper.checkMemberId(blacklistVO.getMemUsername());

		if(checkMemberId == 0) {	//회원아이디가 존재하지 않을 때 NOTEXIST 반환
			log.info("$$$$$$$$$$$$$$$$$$$$$$$$$$$$checkMemberId$$$$$$$$$$$$$$$$$$$$$$$$$$ :{}", checkMemberId);
			return ServiceResult.NOTEXIST;
		}
		//2. 이미 활성 블랙리스트에 등록되어 있는지 확인
		int checkIdBlacklist = blacklistMapper.checkIdBlacklist(blacklistVO.getMemUsername());
		if (checkIdBlacklist > 0) {		// 이미 블랙리스트에 등록되었을 때 EXIST 반환
            return ServiceResult.EXIST;
        }
		// 3. 블랙리스트 등록
		int status = blacklistMapper.blackSignup(blacklistVO);
		if(status == 0){
			return ServiceResult.FAILED;//실패
		}
		// 4.멤버 테이블에 회원 상태 코드를 블랙리스트로 변경
		int memStatus = blacklistMapper.memListStatUpdate(blacklistVO);
		if(memStatus == 0){				//실패
			return ServiceResult.FAILED;
		}
		return ServiceResult.OK;	//모두성공
	}

	//수정하기
	@Override
	public ServiceResult blackUpdate(BlacklistVO blacklistVO) throws Exception {
		int status = blacklistMapper.blackUpdate(blacklistVO);
		if(status > 0) {
			return ServiceResult.OK;	//성공
		}else {
			return ServiceResult.FAILED;	//실패
		}

	}

	//즉시 해제하기
	@Override
	public ServiceResult blackDelete(BlacklistVO blacklistVO) {
		try {
			int blacklistUpdateStatus  = blacklistMapper.blackDelete(blacklistVO);
			//1. 블랙리스트 테이블 업데이트
			if (blacklistUpdateStatus  == 0) { // 업데이트된 행이 없으면 실패
                log.error("blackDelete 실패: BLACKLIST 테이블 업데이트 실패. banNo: {}", blacklistVO.getBanNo());
                throw new RuntimeException("블랙리스트 상태 업데이트 실패.");
            }
			//2.MEMBER 테이블 업데이트
			int memberUpdatestat = blacklistMapper.blackDelete2(blacklistVO.getMemUsername());
			if(memberUpdatestat == 0) {
				log.error("blackDelete2 실패: member 테이블 계정 활성화 실패. memUsername: {}", blacklistVO.getMemUsername());
				throw new RuntimeException("회원 상태코드 변경 실패.");
			}
            return ServiceResult.OK;	//전부 성공시
		}catch (Exception e) {
            log.error("블랙리스트 해제 트랜잭션 중 오류 발생 (BlacklistVO: {}): {}", blacklistVO, e.getMessage());
            return ServiceResult.FAILED;
        }
	}

	//블랙리스트 자동 해제
	@Override
	public void uploadBlackScheduler() {
		try {
            LocalDate today = LocalDate.now();	//현재 날짜

            // 1. 자동 해제 대상 회원 조회
            List<String> targetUsernames = blacklistMapper.getAutoReleaseTargetUsernames(today);

            if (targetUsernames.isEmpty()) {		// 조회 대상이 없을 경우 종료
            	log.info("블랙리스트 자동 해제 대상 회원이 없습니다. (날짜: {})", today);
                return;
            }

            log.info("블랙리스트 자동 해제 대상 회원 {}명 발견. (날짜: {})", targetUsernames.size(), today);

            // 2. BLACKLIST 테이블 업데이트
            int blacklistUpdateCount = blacklistMapper.uploadBlackScheduler(today);
            //3. 멤버 테이블에 회원 상태 코드 변경
            blacklistMapper.memberStateUpdate(targetUsernames);

            log.info("블랙리스트 자동 해제 성공! BLACKLIST {}건 처리됨.", blacklistUpdateCount);

        } catch (Exception e) {
            log.error("블랙리스트 자동 해제 및 계정 활성화 중 오류 발생: {}", e.getMessage(), e);
            throw new RuntimeException("블랙리스트 자동 해제 및 계정 활성화 실패", e);
        }
	}

	//뱃지: 현재 블랙리스트 수
	@Override
	public int blacklistCnt() {
		return blacklistMapper.blacklistCnt();
	}
	//뱃지: 현재 블랙리스트 사유 유형별 수
	@Override
	public Map<String, Integer> blackReasonCnts() {
		Map<String, Integer> reasonCnts = new HashMap<>();
		//사유별 수가 없을 시 기본 0으로 표기
		reasonCnts.put("BRC001", 0);
		reasonCnts.put("BRC002", 0);
		reasonCnts.put("BRC003", 0);
		reasonCnts.put("BRC004", 0);

		List<Map<String, Object>> blackReasonCnts = blacklistMapper.blackReasonCnts();
		log.info("매퍼 결과 (blackReasonCnts): {}", blackReasonCnts);
		// 가져온 결과 리스트를 반복하면서 Map에 값을 업데이트
		for (Map<String, Object> entry  : blackReasonCnts) {
			log.info("처리 중인 entry: {}", entry);
			String reasonCode = (String) entry.get("REASONCODE"); // DB에서 넘어온 사유 코드
			Integer count = ((Number) entry.get("COUNT")).intValue();	//카운트 값을 Integer로 변환
			reasonCnts.put(reasonCode, count);
		}
		return reasonCnts;
	}
	// "총 차단" 수를 위한 파라미터 맵 생성(검색영향X)
	@Override
	public int totalBlakcCount(Map<String, Object> totalCountParams) {
		return blacklistMapper.totalBlakcCount(totalCountParams);
	}

	//신고상세에서 블랙리스트 추가 누를시 회원 아이디와 해당 신고 상세정보 가지고 오기
	@Override
	public ReportVO getReportDetail(Integer reportNo) {
		//해당 신고의 상세정보 가져오기
		ReportVO getUserReportDetail = reportMapper.getUserReportDetail(reportNo);
		//상세내용이 null아니고, 타입이 게시글("RTTC001")일 경우
		if (getUserReportDetail != null && "RTTC001".equals(getUserReportDetail.getReportTargetTypeCode())) {
			// 신고 상세내용에 해당하는 파일정보 가져오기
            List<AttachmentFileDetailVO> fileList = reportMapper.reportDetail3(getUserReportDetail);
            try {
				List<AttachmentFileDetailVO> files = fileService.getFileDetailsByGroupNo(fileList.get(0).getFileGroupNo());
				getUserReportDetail.setFileList(files);
			} catch (Exception e) {
				e.printStackTrace();
			}
        }

		return getUserReportDetail;
	}

}
