package kr.or.ddit.ddtown.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.user.EmployeeVO;
import kr.or.ddit.vo.user.MemberVO;
import kr.or.ddit.vo.user.PeopleAuthVO;

@Mapper
public interface IUserMapper {

	public int idCheck(String memId);

	public int registerPeople(MemberVO memberVO);
	public int registerMember(MemberVO memberVO);

	public void registerAuth(String username);

	public int emailCheck(String memEmail);

	public int nickCheck(String memNicknm);

	public String findId(MemberVO memberVO);

	public MemberVO findPW(MemberVO memberVO);

	public int updateTempPw(MemberVO memberVO);

	/**
	 * 아티스트 사용자정보 수정
	 * @param memberVO
	 * @return
	 */
	public int updateArtistPeople(MemberVO memberVO);

	/**
	 * 아티스트 회원정보 수정
	 * @param memberVO
	 * @return
	 */
	public int updateArtistMember(MemberVO memberVO);

	/**
	 * 아티스트 사용자정보 등록
	 * @param memberVO
	 * @return
	 */
	public int registArtistPeople(MemberVO memberVO);

	/**
	 * 아티스트 권한 등록
	 * @param paVO
	 */
	public void registArtistAuth(PeopleAuthVO paVO);

	/**
	 * 아티스트 회원정보 등록
	 * @param memberVO
	 * @return
	 */
	public int registArtistMember(MemberVO memberVO);

	/**
	 * 아티스트 회원정보 탈퇴 처리
	 * @param memUsername
	 * @return
	 */
	public int deleteArtistMember(String memUsername);

	/**
	 * 아티스트 사용자정보 탈퇴처리
	 */
	public int deleteArtistPeople(String memUsername);

	/**
	 * 회원 정보 조회용
	 * @param username
	 * @return
	 */
	public MemberVO selectMemberInfo(String username);


	/**
	 * 회원 권한 삭제용
	 * @param username
	 */
	public void deletePeopleAuth(String username);

	/**
	 * 그룹 추가 수정시 해당 그룹을 관리할 관리자 목록을 불러온다.
	 * @return
	 */
	public List<EmployeeVO> getEmployList();


	/**
	 * 소셜로그인 유저 추가 정보 people 테이블 입력하기
	 * @param memberVO
	 * @return
	 */
	public int insertAdditionalInfoPeople(MemberVO memberVO);

	/**
	 * 소셜로그인 유저 추가 정보 member 테이블 입력하기
	 * @param memberVO
	 * @return
	 */
	public int insertAdditionalInfoMember(MemberVO memberVO);

	// 권한 확인
	public PeopleAuthVO getPeopleAuth(String username, String string);

	// 권한 삽입
	public int insertPeopleAuth(PeopleAuthVO peopleAuth);

	// 아티스트 조회
	public List<MemberVO> getArtistsNo(int artGroupNo);
	//차단 아이디 관련
	public MemberVO getUserByLoginId(String memUsername);

}
