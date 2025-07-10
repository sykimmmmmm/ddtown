package kr.or.ddit.ddtown.service.auth;

import java.util.List;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.IUserMapper;
import kr.or.ddit.ddtown.mapper.alert.IAlertMapper;
import kr.or.ddit.vo.alert.AlertSettingVO;
import kr.or.ddit.vo.user.EmployeeVO;
import kr.or.ddit.vo.user.MemberVO;
import kr.or.ddit.vo.user.PeopleAuthVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserServiceImpl implements IUserService {

	@Autowired
	private IUserMapper userMapper;

	@Autowired
	private IAlertMapper alertMapper;

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;

	@Override
	public ServiceResult idCheck(String memId) {
		ServiceResult result = null;
		int status = userMapper.idCheck(memId);
		if(status > 0) {
			result = ServiceResult.EXIST;
		}else {
			result = ServiceResult.NOTEXIST;
		}

		return result;
	}

	@Transactional
	@Override
	public ServiceResult register(MemberVO memberVO) {
		ServiceResult result = null;
		MemberVO newMemberVO = new MemberVO();
		BeanUtils.copyProperties(memberVO, newMemberVO);
		String encodedPw = passwordEncoder.encode(memberVO.getPassword());
		newMemberVO.setPassword(encodedPw);
		newMemberVO.setMemRegPath("MRP003");
		int status = userMapper.registerPeople(newMemberVO);
		if(status > 0) {
			status = userMapper.registerMember(newMemberVO);
			if(status > 0) {
				userMapper.registerAuth(newMemberVO.getUsername());

				List<String> alertTypeCodes = alertMapper.getATCs();
				AlertSettingVO alertSettingVO = new AlertSettingVO();
				alertSettingVO.setMemUsername(newMemberVO.getUsername());
				for(String atc : alertTypeCodes) {
					alertSettingVO.setAlertTypeCode(atc);
					alertMapper.insertSetting(alertSettingVO);
				}

				result = ServiceResult.OK;
			}else {
				result = ServiceResult.FAILED;
			}
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public ServiceResult nickCheck(String memNicknm) {
		ServiceResult result = null;
		int status = userMapper.nickCheck(memNicknm);
		if(status > 0) {
			result = ServiceResult.EXIST;
		}else {
			result = ServiceResult.NOTEXIST;
		}

		return result;
	}

	@Override
	public ServiceResult emailCheck(String memEmail) {
		ServiceResult result = null;
		int status = userMapper.emailCheck(memEmail);
		if(status > 0) {
			result = ServiceResult.EXIST;
		}else {
			result = ServiceResult.NOTEXIST;
		}

		return result;
	}

	@Override
	public String findId(MemberVO memberVO) {
		return userMapper.findId(memberVO);
	}

	@Override
	public MemberVO findPw(MemberVO memberVO) {
		return userMapper.findPW(memberVO);
	}

	@Transactional
	@Override
	public ServiceResult updateTempPw(MemberVO memberVO) {
		ServiceResult result = null;
		String tempPw = passwordEncoder.encode(memberVO.getPassword());
		memberVO.setPassword(tempPw);
		int status = userMapper.updateTempPw(memberVO);
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public MemberVO getMemberInfo(String memUsername) {
		MemberVO memberVO = userMapper.selectMemberInfo(memUsername);
		if(memberVO != null ) {
			memberVO.setPassword(null);
		}
		return memberVO;
	}

	@Transactional
	@Override
	public ServiceResult updateMemberInfo(MemberVO memberVO) {
		int peopleUpdate = userMapper.updateArtistPeople(memberVO);
		int memberUpdate = userMapper.updateArtistMember(memberVO);

		if(peopleUpdate >= 0 && memberUpdate >= 0) {
			return ServiceResult.OK;
		}
		return ServiceResult.FAILED;
	}

	@Transactional
	@Override
	public ServiceResult deleteMember(String username, String confirmText) {
		final String REQUIRED_CONFIRM_TEXT = "회원탈퇴에 동의합니다";
		log.info("deleteMember() 실행...!");

		MemberVO member = userMapper.selectMemberInfo(username);
		if(member == null) {
			return ServiceResult.NOTEXIST;
		}

		log.info("회원 조회 완료 후 삭제 실행..!");

		if(!REQUIRED_CONFIRM_TEXT.equals(confirmText)) {		// 문자열 일치하지 않을 때 fail
			return ServiceResult.FAILED;
		}

		int memberStatusUpdate = userMapper.deleteArtistMember(username);		// 회원 상태코드	(mem_stat_code)

		log.info("회원 상태코드 변경 실행!!");

		int peopleStatusUpdate = userMapper.deleteArtistPeople(username);		// 사용자 상태코드 (peo_enabled)

		log.info("사용자 상태코드 변경 실행!!");

		userMapper.deletePeopleAuth(username);		// 회원 권한 삭제

		log.info("회원 권한 삭제 실행!!");

		if(memberStatusUpdate >= 0 && peopleStatusUpdate >= 0) {
			return ServiceResult.OK;
		}

		return ServiceResult.FAILED;
	}

	@Transactional
	@Override
	public ServiceResult changePassword(String username, String currentPassword, String newPassword) {
		MemberVO memberVO = userMapper.selectMemberInfo(username);
		if(memberVO == null || memberVO.getPassword() == null) {
			return ServiceResult.NOTEXIST;
		}

		if(passwordEncoder.matches(currentPassword, memberVO.getPassword())) {
			MemberVO pwUpdate = new MemberVO();
			pwUpdate.setUsername(username);
			pwUpdate.setPassword(passwordEncoder.encode(newPassword));

			int status = userMapper.updateTempPw(pwUpdate);

			if(status > 0) {
				return ServiceResult.OK;
			} else {
				return ServiceResult.FAILED;
			}
		} else {
			return ServiceResult.INVALIDPASSWORD;
		}
	}

	@Override
	public boolean verifyCurrentPassword(String username, String currentPassword) {
		MemberVO member = userMapper.selectMemberInfo(username); // username 정보 조회 후 password 가져오기
        if (member != null && member.getPassword() != null) {
            return passwordEncoder.matches(currentPassword, member.getPassword());
        }
        return false;
	}

	/**
	 * 그룹 추가 수정시 해당 그룹을 관리할 관리자 목록을 불러온다.
	 */
	@Override
	public List<EmployeeVO> getEmployList() {
		return userMapper.getEmployList();
	}

	/**
	 * 소셜로그인 유저 추가 정보 입력하기
	 * @param memberVO
	 * @return ServiceResult
	 */
	@Transactional
	@Override
	public ServiceResult insertAdditionalInfo(MemberVO memberVO) {
		ServiceResult result = null;
		// people 테이블 정보 업데이트
		int status = userMapper.insertAdditionalInfoPeople(memberVO);
		if(status > 0) {
			// member 테이블 정보 업데이트
			status = userMapper.insertAdditionalInfoMember(memberVO);
			if(status > 0) {
				result = ServiceResult.OK;
			}else {
				result = ServiceResult.FAILED;
			}
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public PeopleAuthVO getPeopleAuth(String username, String string) {
		return userMapper.getPeopleAuth(username, string);
	}

	@Override
	public void insertPeopleAuth(PeopleAuthVO peopleAuth) {
		int result = userMapper.insertPeopleAuth(peopleAuth);
		if(result > 0) {
			log.info("PeopleAuth insert 성공: {}", peopleAuth);
		} else {
			log.info("PeopleAuth insert 실패: {}", peopleAuth);
			throw new RuntimeException("권한 삽입에 실패했습니다.");
		}
	}

	// 아티스트 조회
	@Override
	public List<MemberVO> getArtistsNo(int artGroupNo) {
		return userMapper.getArtistsNo(artGroupNo);
	}
	//차단당한 아이디 관련
	@Override
	public MemberVO getUserByLoginId(String memUsername) {
		log.info("UserServiceImpl - getMemberInfo 실행. 조회할 아이디: {}", memUsername);
		return userMapper.getUserByLoginId(memUsername);
	}
}
