package kr.or.ddit.ddtown.service.community.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.community.ICommunityNoticeMapper;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.community.CommunityNoticeVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CommunityNoticeServiceImpl implements ICommunityNoticeService {

    @Autowired
    private ICommunityNoticeMapper noticeMapper;

    @Autowired
    private IFileService fileService;

    private static final String FILETYPECODE = "FITC008";

    @Override
    public List<CommunityNoticeVO> selectNoticeList(PaginationInfoVO<CommunityNoticeVO> pagingVO) throws Exception {
        log.info("selectNoticeList() 실행...!");
        List<CommunityNoticeVO> list = noticeMapper.selectNoticeList(pagingVO);

        if (list == null) {
            log.warn("list가 null임!!!");
        } else {
            log.info("조회된 공지사항 목록 수: {}", list.size());
        }
        return list;
    }

    @Override
    public int selectNoticeCount(PaginationInfoVO<CommunityNoticeVO> pagingVO) throws Exception {
    	log.info("selectNoticeCount() 실행...!");
        return noticeMapper.selectNoticeCount(pagingVO);
    }

    @Override
    public CommunityNoticeVO selectNotice(int comuNotiNo) throws Exception {
    	log.info("selectNotice() 실행...!");
    	CommunityNoticeVO noticeVO = noticeMapper.selectNotice(comuNotiNo);
    	if(noticeVO != null && noticeVO.getFileGroupNo() != null && noticeVO.getFileGroupNo() > 0) {
    		List<AttachmentFileDetailVO> files = fileService.getFileDetailsByGroupNo(noticeVO.getFileGroupNo());
    		noticeVO.setAttachmentFileList(files);
    		log.debug("상세 - 공지 번호 {}: 파일 그룹 {}의 파일 {}개 로드", comuNotiNo, noticeVO.getFileGroupNo(), (files != null ? files.size() : 0));
    	}
        return noticeVO;
    }

    @Transactional
    @Override
    public ServiceResult insertNotice(CommunityNoticeVO noticeVO) throws Exception {
    	log.info("insertNotice() 실행...!");

    	// 파일 업로드 처리 및 파일 그룹 번호 생성
        if (noticeVO.getComuNotiFiles() != null && noticeVO.getComuNotiFiles().length > 0 && !noticeVO.getComuNotiFiles()[0].isEmpty()) {
            // 공지사항 파일 타입 코드 사용
            Integer fileGroupNo = fileService.uploadAndProcessFiles(noticeVO.getComuNotiFiles(), FILETYPECODE, noticeVO.getEmpUsername());
            noticeVO.setFileGroupNo(fileGroupNo);
        } else {
            noticeVO.setFileGroupNo(null);
        }

        // 공지사항 정보 DB에 삽입
        int row = noticeMapper.insertNotice(noticeVO); // 이 때 fileGroupNo도 함께 저장됨

        if (row > 0) {
            log.info("콘서트 공지사항 DB 등록 성공: {}", noticeVO.getComuNotiTitle());
            return ServiceResult.OK;
        } else {
        	log.warn("콘서트 공지사항 DB 등록 실패: {}", noticeVO.getComuNotiTitle());
        	return ServiceResult.FAILED;
        }
    }

    @Transactional
    @Override
    public ServiceResult updateNotice(CommunityNoticeVO noticeVO) throws Exception {
    	log.info("updateNotice() 실행...!");

    	// 선택한 게시물의 기존 파일 그룹 번호 조회
    	CommunityNoticeVO originalNotice = noticeMapper.selectNotice(noticeVO.getComuNotiNo());
    	Integer existingFileGroupNo = (originalNotice != null) ? originalNotice.getFileGroupNo() : null;
    	log.info("기존 파일 그룹 번호 : {}", existingFileGroupNo);

    	boolean hasNewFiles = noticeVO.getComuNotiFiles() != null &&
    						  noticeVO.getComuNotiFiles().length > 0 &&
    						  !noticeVO.getComuNotiFiles()[0].isEmpty();

    	Integer finalFileGroupNo = existingFileGroupNo;		// DB에 들어갈 최종 파일그룹번호

    	// 개별 파일 삭제처리
    	if(noticeVO.getDeleteFileNos() != null && !noticeVO.getDeleteFileNos().isEmpty()) {
    		log.info("개별 파일 삭제 요청 목록 : {}", noticeVO.getDeleteFileNos());
    		if(existingFileGroupNo != null) {
    			fileService.deleteSpecificFiles(noticeVO.getDeleteFileNos());		// 상세정보 삭제
    			// 삭제 후 남은 파일 확인
    			List<AttachmentFileDetailVO> remainingFiles = fileService.getFileDetailsByGroupNo(existingFileGroupNo);
    			if(remainingFiles == null || remainingFiles.isEmpty()) {
    				log.info("모든 개별파일 삭제 후 파일그룹 {}도 삭제 : ", existingFileGroupNo);
    				if(!hasNewFiles) {
    					finalFileGroupNo = null;
    				}
    			}
    		}
    	}


    	// 새로 첨부된 파일 처리
    	if(hasNewFiles) {
    		// 새 파일들로 파일그룹 생성
    		Integer newFileGroupNo = fileService.uploadAndProcessFiles(noticeVO.getComuNotiFiles(), FILETYPECODE,
    				noticeVO.getEmpUsername());
    		finalFileGroupNo = newFileGroupNo;
    		log.info("새 파일 업로드오나료. 새 파일 그룹번호 : {}", newFileGroupNo);
    	}

    	// noticeVO의 fileGroupNo 상태 반영
    	noticeVO.setFileGroupNo(finalFileGroupNo);

    	// 콘서트 공지사항 정보 DB업뎃
        int row = noticeMapper.updateNotice(noticeVO);
        if (row > 0) {
	        log.info("콘서트 공지사항 수정 성공 (번호: {})", noticeVO.getComuNotiNo());
	        if(existingFileGroupNo != null && !existingFileGroupNo.equals(finalFileGroupNo)) {
	        	try {
	        		fileService.deleteFilesByGroupNo(existingFileGroupNo);
	        		log.info("이전 파일그룹 {} 삭제 완료", existingFileGroupNo);
				} catch (Exception e) {
					log.error("이전 파일 그룹 {} 삭제 중 오류 발생!!!, {}", existingFileGroupNo);
				}
	        }
	        return ServiceResult.OK;
        } else {
	        if(hasNewFiles && finalFileGroupNo != null && !finalFileGroupNo.equals(existingFileGroupNo)) {
	        	try {
					fileService.deleteFilesByGroupNo(finalFileGroupNo);
					log.info("업데이트 실패로 파일그룹 {} 삭제시도", finalFileGroupNo);
				} catch (Exception e) {
					log.error("업데이트 실패 후 새 파일그룹 {} 삭제 중 오류: ", finalFileGroupNo);
				}
	        }
	        log.warn("콘서트 공지사항 수정 실패 (번호: {}): {}", noticeVO.getComuNotiNo());
	        return ServiceResult.FAILED;
        }
    }

    @Transactional
    @Override
    public ServiceResult deleteNotice(int comuNotiNo) throws Exception {
    	log.info("deleteNotice() 실행...!");

    	CommunityNoticeVO noticeToDelete = noticeMapper.selectNotice(comuNotiNo);		// 파일 그룹번호 확인을 위해 조회
    	Integer fileGroupNoToDelete = null;

    	if(noticeToDelete != null) {
    		fileGroupNoToDelete = noticeToDelete.getFileGroupNo();
    	}

        int row = noticeMapper.deleteNotice(comuNotiNo);

        if (row > 0) {
        	if(fileGroupNoToDelete != null && fileGroupNoToDelete > 0) {
        		try {
					fileService.deleteFilesByGroupNo(fileGroupNoToDelete);
					log.info("연결된 파일 그룹 {} 및 관련 파일 모두 삭제");
				} catch (Exception e) {
					log.error("게시물 삭제 후 파일 그룹 삭제중 오류 발생");
				}
        	}
            return ServiceResult.OK;
        } else {
        	log.info("콘서트 공지사항 삭제 실패");
        	return ServiceResult.FAILED;
        }
    }

    /**
     *  @author 철순
     *
     *  @param pagingVO 아티스트 그룹에 해당하는 공지사항을 가져오기 위한 페이징 정보가 담긴 VO
     *  @return noticeList 파라미터로 받은 아티스트 그룹에 해당하는 공지사항 목록을 반환
     *
     *  사용자 시점 공지사항 목록을 조회
     */
	@Override
	public List<CommunityNoticeVO> clientPointOfViewCommunityNoticeList(PaginationInfoVO<CommunityNoticeVO> pagingVO) {

		List<CommunityNoticeVO> noticeList = noticeMapper.clientPointOfViewCommunityNoticeList(pagingVO);

		if(noticeList != null) {
			log.info("아티스트 그룹 번호 " + pagingVO.getArtGroupNo() + " 의 리스트 목록 : " + noticeList);
		}else {
			log.warn("list가 null임!!!");
		}

		return noticeList;
	}

	@Override
	public List<CommunityNoticeVO> allNoticeList(int artGroupNo) {
		return noticeMapper.allNoticeList(artGroupNo);
	}
}