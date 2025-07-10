package kr.or.ddit.ddtown.service.community;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.artist.AlbumVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.artist.ArtistVO;
import kr.or.ddit.vo.community.CommunityLikeVO;
import kr.or.ddit.vo.community.CommunityPostVO;
import kr.or.ddit.vo.community.CommunityProfileVO;
import kr.or.ddit.vo.community.CommunityReplyVO;
import kr.or.ddit.vo.community.CommunityReportVO;
import kr.or.ddit.vo.community.CommunityVO;
import kr.or.ddit.vo.community.WorldcupVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.live.LiveVO;

public interface ICommunityMainPageService {

	public List<ArtistGroupVO> getGroupLists();

	public ArtistGroupVO getGroupInfo(int artGroupNo);

	public List<AlbumVO> getGroupAlbum(int artGroupNo);

	public ArtistGroupVO getCommunityInfo(int artGroupNo);

	public List<CommunityPostVO> getPostList(CommunityVO communityVO);

	public List<CommunityPostVO> getFanPostList(CommunityVO communityVO);

	public int getPostTotal(CommunityVO communityVO);

	public CommunityProfileVO currentUserComufollowing(Map<String, Object> currentUser);

	public ServiceResult postInsert(CommunityPostVO postVO);

	public ServiceResult postUpdate(CommunityPostVO postVO);

	public CommunityPostVO getPost(CommunityPostVO comuPostVO);

	/**
	 * comuProfileNo, artGroupNo로 프로필VO 찾은 후 해당 프로필이 작성한 글 목록 및 댓글 목록 가져오기
	 * @param profileVO
	 * @param myComuProfileNo
	 * @return
	 */
	public CommunityProfileVO selectProfile(CommunityProfileVO profileVO);

	public ServiceResult postDelete(CommunityPostVO comuPostVO);

	public Map<Object, Object> replyInsert(CommunityReplyVO replyVO, String memUsername);

	/**
	 * 포스트 번호로 해당 포스트 정보 및 댓글 가져오기
	 * @param cPostVO
	 * @return
	 */
	public CommunityPostVO selectPost(CommunityPostVO cPostVO);

	public ServiceResult replyUpdate(CommunityReplyVO replyVO);

	public ServiceResult replyDelete(int replyNo);

	public ServiceResult likeUpdate(CommunityLikeVO likeVO);

	public Map<Object, Object> getCodeDetail();

	public ServiceResult report(CommunityReportVO reportVO);

	/**
	 * 유저네임과 아티스트 그룹번호로 프로필번호가져오기
	 * @param myProfileVO
	 * @return
	 */
	public int getMyComuProfileNo(CommunityProfileVO myProfileVO);

	/**
	 * 업데이트 할 포스트 가져오기
	 * @param comuPostNo
	 * @return
	 */
	public CommunityPostVO getUpdatePost(int comuPostNo);

	/**
	 * 글 번호로 글 삭제 여부 y 변경
	 * @param postVO
	 * @return
	 */
	public ServiceResult deletPostByComuPostNo(CommunityPostVO postVO);

	/**
	 * 특정 아티스트 그룹의 현재 라이브 방송 정보를 가져옵니다.
	 * @param artGroupNo
	 * @return 방송 중이면 Broadcast(Live) 객체, 아니면 null
	 */
	public LiveVO getLiveBroadcastInfo(int artGroupNo);

	// 메인페이지 해당 아티스트 멤버십 굿즈번호 가져오기
	public Integer getMembershipGoodsNo(int artGroupNo);

	/**
	 * memUsername과 artGroupNo로 해당 커뮤니티 멤버쉽가입여부 확인
	 * @param myProfileVO
	 * @return
	 */
	public boolean getMyMemberShipYn(CommunityProfileVO myProfileVO);

	public List<LiveVO> getLiveHistory(int artGroupNo);

	// 상품 이미지 가져오기
	public List<goodsVO> thumbnailInfo(int artGroupNo);

	// 아티스트 제외, 커뮤 탈퇴 제외 활성화된 팬만 가져오는 메서드
	public int getFansWithoutDel(int artGroupNo);

	// 전체 아티스트 가져오기
	public List<ArtistVO> artistList();

	// 월드컵 승리 추가
	public ServiceResult worldcupWinner(WorldcupVO worldcupVO);

	// 역대 순위 가져오기
	public List<WorldcupVO> winnerList();

}
