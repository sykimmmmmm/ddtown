package kr.or.ddit.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.or.ddit.security.mapper.ISecMemberMapper;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.EmployeeVO;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CustomUserDetailsService implements UserDetailsService{

	@Autowired
	private ISecMemberMapper memberMapper;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DisabledException {
		log.info("유저디테일서비스파트 유저정보 가져오기 실행");
		log.info("유저 아이디 : {}",username);
		MemberVO member = null;
		EmployeeVO employee = null;


		try {
			member = memberMapper.readByUserInfoMember(username);

			// 차단 유저 로그인 못하게 막기
			if(member != null) {
				log.info("memStatCode : {}",member.getMemStatCode());
				// 회원이면서 차단된상태 확인
				if("MSC003".equals(member.getMemStatCode())) {//회원이고 MSC003면
					log.warn("차단된 계정 로그인 시도 감지. 사용자 ID: {}, 세션 ID: {}",  member.getMemUsername());
					throw new DisabledException("차단 당한 아이디입니다. 042-887-6415로 문의해주세요");
				}
				log.info("회원 사용자 {} 정보 로드 성공 ",username);
				return new CustomUser(member);
			}
			// 차단 유저 로그인 못하게 막기

			employee = memberMapper.readByUserInfoEmployee(username);

			if(employee != null) {
				log.info("직원 사용자 {} 정보 로드 성공",username);
				return new CustomUser(employee);
			}
		} catch (DisabledException e) {
			throw e;
		} catch (Exception e) {
            log.error("사용자 '{}' 정보 로드 중 오류 발생: {}", username, e.getMessage(), e);
            // 데이터베이스 오류 등 시스템 내부 오류인 경우 UsernameNotFoundException으로 변환
            throw new UsernameNotFoundException("인증 서비스 오류입니다. 관리자에게 문의하세요.", e);
        }

		// 어떤 사용자(회원/직원)도 찾지 못했을 때 예외 발생
        log.warn("사용자 '{}'를 찾을 수 없습니다.", username);
        throw new UsernameNotFoundException(username + "을(를) 찾을 수 없습니다.");
	}

}
