package kr.or.ddit.ddtown.mapper.community;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.artist.ArtistVO;
import kr.or.ddit.vo.community.CommunityProfileVO;

@Mapper
public interface CommunityProfileMapper {

	// 아티스트 회원 아이디 조회
	String getMemUsernameByComuProfile(int comuProfileNo);

	// 프로필 번호 이용해 아티스트 그룹 번호 조회
	Integer selectArtistGroupNoByComuProfileNo(Integer comuProfileNo);

	// 사용자 커뮤니티 프로필 번호 조회
	Integer selectComuprofileNoByMember(String memUsername, Integer artGroupNo);

	// 로그인한 유저의 커뮤니티 이름
	String getComuNicknmByUsername(String currentUser, Integer artGroupNo);

	// 프로필 이미지 URL 가져오기
	String selectProfileImgPathByUsername(String msgUsername, Integer artGroupNo);

	/**
	 * 아티스트 커뮤니티프로필 만들기
	 * @param profileVO
	 * @return
	 */
	public int registCommProfileArtist(CommunityProfileVO profileVO);

	/**
	 * // 아티스트 커뮤니티 프로필을 찾기 위한 아티스트 아이디 찾기
	 * @param artVO(artGroupNo, memUsername)
	 * @return CommunityProfileVO
	 */
	public CommunityProfileVO selectCommProfileArtist(ArtistVO artVO);

	/**
	 * 커뮤니티 프로필 del 여부 토글방식으로 변경
	 * @param profileVO
	 */
	public void updateCommProfileArtistDelYN(CommunityProfileVO profileVO);

	/**
	 * 커뮤니티 프로필 등록
	 * @param profileVO
	 * @return
	 */
	public int insertCommuProfile(CommunityProfileVO profileVO);

	/**
	 * 커뮤니티 프로필 del Y 처리
	 * @param profileVO (comuProfileNo)
	 * @return
	 */
	public int deleteCommuProfile(CommunityProfileVO profileVO);

	// 커뮤니티 프로필 번호 조회
	CommunityProfileVO getCommunityProfile(String username, int artGroupNo);

	// 커뮤니티 프로필 cat코드 업데이트
	void updateCommunityProfile(CommunityProfileVO existingComuProfile);

	/**
	 * 커뮤니티 프로필 닉네임 프로필이미지경로 수정
	 * @param profileVO
	 * @return
	 */
	public int updateProfile(CommunityProfileVO profileVO);

	/**
	 * 아티스트 관리에서 프로필 이미지 수정시 각 아티스트커뮤니티 프로필사진 변경
	 * @param imgUrl
	 * @param memUsername
	 */
	public void updateArtistProfileImg(@Param("comuProfileImg") String imgUrl,@Param("memUsername") String memUsername);

	/**
	 * 회원아이디로 아티스트번호 조회
	 * @param username
	 * @return artNo
	 */
	public Integer selectArtNoByUsername(String username);

}
