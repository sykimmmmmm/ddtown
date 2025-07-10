package kr.or.ddit.ddtown.service.audition;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.audition.AuditionMapper;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.corporate.audition.AuditionUserVO;
import kr.or.ddit.vo.corporate.audition.AuditionVO;

@Service
public class AuditionServiceImpl implements AuditionService{

	@Autowired
	private AuditionMapper auditionMapper;

	@Autowired
    private IFileService fileService;

	private static final String FILETYPECODE = "FITC002";

	//오디션 목록
	@Override
	public List<AuditionVO> auditionList(PaginationInfoVO<AuditionVO> pagingVO) {
		return auditionMapper.auditionList(pagingVO);
	}
	//오디션 목록 수
	@Override
	public int selectAuditionCount(PaginationInfoVO<AuditionVO> pagingVO) {
		return auditionMapper.selectAuditionCount(pagingVO);
	}

	//오디션 상세보기
	@Override
	public AuditionVO detailAudition(int audiNo) {
		return auditionMapper.detailAudition(audiNo);
	}
	//지원하기 등록
	@Transactional
	@Override
	public ServiceResult signup(AuditionUserVO auditionUserVO) throws Exception {

		// 파일 업로드 처리 및 파일 그룹 번호 생성
        if (auditionUserVO.getAudiMemFiles() != null && auditionUserVO.getAudiMemFiles().length > 0 && !auditionUserVO.getAudiMemFiles()[0].isEmpty()) {
            // 파일 타입 코드 사용
            Integer fileGroupNo = fileService.uploadAndProcessFiles(auditionUserVO.getAudiMemFiles(), FILETYPECODE);
            auditionUserVO.setFileGroupNo(fileGroupNo);
        } else {
        	auditionUserVO.setFileGroupNo(null);
        }

		int status = auditionMapper.signup(auditionUserVO);
		if(status > 0) {
			 return ServiceResult.OK;	//성공
		}else {
			return ServiceResult.FAILED;//실패
		}

	}
}
