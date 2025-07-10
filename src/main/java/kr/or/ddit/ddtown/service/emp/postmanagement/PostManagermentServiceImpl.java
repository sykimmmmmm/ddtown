package kr.or.ddit.ddtown.service.emp.postmanagement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.ddtown.mapper.emp.postManagement.IPostManagementMapper;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.ArtistVO;
import kr.or.ddit.vo.community.CommunityPostVO;
import kr.or.ddit.vo.community.CommunityReplyVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;

@Service
public class PostManagermentServiceImpl implements IPostManagementService{

	@Autowired
	private IPostManagementMapper postManagementMapper;

	@Autowired
	private IFileService fileService;

	@Override
	public List<CommunityPostVO> getPost(PaginationInfoVO<CommunityPostVO> pagingVO) {

		return postManagementMapper.getPost(pagingVO);
	}

	@Override
	public int totalRecord(String empUsername) {

		return postManagementMapper.totalRecord(empUsername);
	}

	@Override
	public List<ArtistVO> empArtistList(String empUsername) {

		return postManagementMapper.empArtistList(empUsername);
	}

	@Override
	public CommunityPostVO selectPost(int comuPostNo) {

		CommunityPostVO postVO = postManagementMapper.selectPost(comuPostNo);

		if(postVO.getFileGroupNo() != null) {
			try {
				List<AttachmentFileDetailVO> fileList = fileService.getFileDetailsByGroupNo(postVO.getFileGroupNo());
				postVO.setPostFiles(fileList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return postVO;
	}

	@Override
	public List<CommunityReplyVO> postReplyList(PaginationInfoVO<CommunityReplyVO> pagingVO) {

		return postManagementMapper.postReplyList(pagingVO);
	}

	@Override
	public int replyTotalRecord(PaginationInfoVO<CommunityReplyVO> pagingVO) {
		return postManagementMapper.replyTotalRecord(pagingVO);
	}

}
