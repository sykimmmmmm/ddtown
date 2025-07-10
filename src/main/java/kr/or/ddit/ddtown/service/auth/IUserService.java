package kr.or.ddit.ddtown.service.auth;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.user.EmployeeVO;
import kr.or.ddit.vo.user.MemberVO;
import kr.or.ddit.vo.user.PeopleAuthVO;

public interface IUserService {

	public ServiceResult idCheck(String memId);

	public ServiceResult register(MemberVO memberVO);

	public ServiceResult nickCheck(String memNicknm);

	public ServiceResult emailCheck(String memEmail);

	public String findId(MemberVO memberVO);

	public MemberVO findPw(MemberVO memberVO);

	public ServiceResult updateTempPw(MemberVO memberVO);

	// 마이페이지

	public MemberVO getMemberInfo(String memUsername);	// 현재 로그인한 회원 정보 조회용

	public ServiceResult updateMemberInfo(MemberVO memberVO);		// 회원 정보 수정

	public ServiceResult changePassword(String username, String currentPassword, String newPassword);	// 비밀번호 변경

	public ServiceResult deleteMember(String username, String confirmText);		// 회원 탈퇴 처리

	public boolean verifyCurrentPassword(String username, String currentPassword);		// 현재 비밀번호 확인용

	/**
	 * 그룹 추가 수정시 해당 그룹을 관리할 관리자 목록을 불러온다.
	 * @return
	 */
	public List<EmployeeVO> getEmployList();

	/**
	 * 소셜로그인 유저 추가 정보 입력하기
	 * @param memberVO
	 * @return
	 */
	public ServiceResult insertAdditionalInfo(MemberVO memberVO);

	// 권한 확인
	public PeopleAuthVO getPeopleAuth(String username, String string);

	// 권한 삽입
	public void insertPeopleAuth(PeopleAuthVO peopleAuth);

	// 아티스트 그룹에 속한 아티스트 조회
	public List<MemberVO> getArtistsNo(int artGroupNo);

	//차단관련(아이디 조회)
	public MemberVO getUserByLoginId(String username);
}
