package kr.or.ddit.ddtown.service.follow;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.follow.FollowVO;

public interface IFollowService {

	/**
	 * 특정 회원이 팔로우하는 아티스트 그룹 목록 조회
	 * @param username	회원 아이디
	 * @return 회원이 팔로우한 아티스트 그룹 리스트
	 */
	public List<ArtistGroupVO> getFollowedArtistGroups(String username) throws Exception;

	/**
	 * 회원이 특정 아티스트 그룹 팔로우
	 * @param followerUsername	팔로우 하는 회원 아이디
	 * @param artGroupNo	팔로우 대상 아티스트 그룹 번호
	 * @return ServiceResult
	 */
	public ServiceResult follow(String followerUsername, int artGroupNo) throws Exception;

	/**
	 * 회원이 특정 아티스트 그룹 팔로우 하고있는지 여부
	 * @param followerUsername	팔로우 하는 회원 아이디
	 * @param artGroupNo	대상 아티스트 그룹번호
	 * @return true/false
	 */
	public boolean isFollowing(String followerUsername, int artGroupNo) throws Exception;

	/**
	 * 특정 아티스트 그룹의 팔로워 수 조회
	 * @param artGroupNo	아티스트 그룹번호
	 * @return	팔로워 수
	 */
	public int getFollowerCnt(int artGroupNo) throws Exception;

	/**
	 * 특정 회원이 팔로우하고있는 그룹 수
	 * @param username	회원 아이디
	 * @return 팔로잉 수
	 * @throws Exception
	 */
	public int getFollowingCnt(String username) throws Exception;

	/**
	 * 특정 회원의 팔로우 목록 조회
	 * @param username
	 * @return
	 */
	public List<FollowVO> getFollowList(String username);

	/**
	 * 특정 아티스트 그룹을 팔로우하는 회원 목록 조회
	 * @param artGroupNo	아티스트 그룹번호
	 * @return 팔로우 하는 사용자 목록 리스트
	 */
	public List<String> getFollowerUsernamesForAlert(int artGroupNo);
}
