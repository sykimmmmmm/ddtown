package kr.or.ddit.ddtown.service.community.notice;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.community.CommunityNoticeVO;

public interface ICommunityNoticeService {

	/** 커뮤니티 공지사항 등록 */
    public ServiceResult insertNotice(CommunityNoticeVO noticeVO) throws Exception;

    /** 커뮤니티 공지사항 상세 조회 */
    public CommunityNoticeVO selectNotice(int comuNotiNo) throws Exception;

    /** 커뮤니티 공지사항 목록 조회 */
    public List<CommunityNoticeVO> selectNoticeList(PaginationInfoVO<CommunityNoticeVO> pagingVO) throws Exception;

    /** 커뮤니티 공지사항 개수 조회 */
    public int selectNoticeCount(PaginationInfoVO<CommunityNoticeVO> pagingVO) throws Exception;

    /** 커뮤니티 공지사항 수정 */
    public ServiceResult updateNotice(CommunityNoticeVO noticeVO) throws Exception;

    /** 커뮤니티 공지사항 삭제 */
    public ServiceResult deleteNotice(int comuNotiNo) throws Exception;

    /** 사용자 시점 커뮤니티 공지사항 목록 조회 */
	public List<CommunityNoticeVO> clientPointOfViewCommunityNoticeList(PaginationInfoVO<CommunityNoticeVO> pagingVO);

	/** 해당 아티스트 그룹 모든 공지사항 목록 조회 */
	public List<CommunityNoticeVO> allNoticeList(int artGroupNo);


}
