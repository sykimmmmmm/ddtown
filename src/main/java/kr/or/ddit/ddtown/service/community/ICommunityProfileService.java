package kr.or.ddit.ddtown.service.community;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.community.CommunityProfileVO;

public interface ICommunityProfileService {

	// 커뮤니티 닉네임 조회
	public String getComuNicknmByUsername(String currentUser, Integer artGroupNo);

	// 커뮤니티 이미지 경로 조회
	public String getComuProfileImgPath(String currentUser, Integer artGroupNo);

	/**
	 * 이미지 처리 후 팔로우 등록 후 프로필 추가
	 * @param profileVO
	 * @return
	 */
	public int insertCommuProfile(CommunityProfileVO profileVO);

	/**
	 * 커뮤니티 프로필 del Y 처리 후 팔로우 물리적 삭제
	 * @param profileVO
	 * @return
	 */
	public int deleteCommuProfile(CommunityProfileVO profileVO);

	// 커뮤니티 프로필 조회
	public CommunityProfileVO getCommunityProfile(String username, int artGroupNo);

	// 커뮤니티 프로필 cat코드 업데이트
	public void updateCommunityProfile(CommunityProfileVO existingComuProfile);

	/**
	 * 이미지 처리 후 프로필 변경
	 * @param profileVO
	 * @return
	 */
	public ServiceResult updateProfile(CommunityProfileVO profileVO);

	/**
	 * 아티스트관리에서 프로필 이미지 변경시 커뮤니티 프로필 이미지 변경
	 * @param imgUrl
	 * @param memUsername
	 */
	public void updateArtistProfileImg(String imgUrl, String memUsername);

	/**
	 * 회원아이디로 아티스트 번호 조회
	 * @param username
	 * @return artNo
	 */
	public Integer getArtNoByUsername(String username);
}
