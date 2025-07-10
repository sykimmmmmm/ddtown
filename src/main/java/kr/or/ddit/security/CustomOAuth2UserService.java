package kr.or.ddit.security;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ddtown.mapper.alert.IAlertMapper;
import kr.or.ddit.security.mapper.ISecMemberMapper;
import kr.or.ddit.vo.alert.AlertSettingVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.user.MemberVO;
import kr.or.ddit.vo.user.PeopleAuthVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

	@Autowired
	private ISecMemberMapper memberMapper;

	@Autowired
	private IAlertMapper alertMapper;

	@Transactional
	@Override
	public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
		DefaultOAuth2UserService dOauth2 = new DefaultOAuth2UserService();
		OAuth2User oAuth2User = dOauth2.loadUser(userRequest);
		String registrationId = userRequest.getClientRegistration().getRegistrationId();

		Map<String, Object> map = oAuth2User.getAttributes();
		Set<String> keySet = map.keySet();
		for (String key : keySet) {
			log.info("key : {} , value : {}",key,map.get(key));
		}


		MemberVO memberVO = new MemberVO();
		PeopleAuthVO memberAuthVO = new PeopleAuthVO();
		List<PeopleAuthVO> memberAuthList = new ArrayList<>();
		memberAuthList.add(memberAuthVO);
		memberAuthVO.setAuth("ROLE_MEMBER");
		memberVO.setAuthList(memberAuthList);

		String username = null;
		String nickname = null;

		if("google".equals(registrationId)) {
			username = map.get("sub").toString();
			nickname = map.get("name").toString();
			memberVO.setMemRegPath("MRP001");

		}
		else if("kakao".equals(registrationId)) {
			Map<String, Object> kakaoAccount = (Map<String, Object>) map.get("kakao_account");
			Map<String, Object> kakaoProfile = (Map<String, Object>) kakaoAccount.get("profile");
			username = map.get("id").toString();
			nickname = kakaoProfile.get("nickname").toString();
			memberVO.setMemRegPath("MRP002");
		}

		memberVO.setUsername(System.currentTimeMillis() + "_" + username); //탈퇴후 재가입하기위한 숫자_고유id
		log.info("username : {}",memberVO.getUsername());
		memberVO.setOriginUsername(username);// db에 검색하기위한 실제 고유id
		memberVO.setMemNicknm(nickname);

		MemberVO existingUser = memberMapper.selectByMemUsernameOAuth2(memberVO);
		boolean needAdditionalInfo = false;
		if(existingUser == null) {
			needAdditionalInfo = true;
			memberMapper.insertPeopleByOAuth2(memberVO);
			memberVO.setMemUsername(username);
			memberMapper.insertMemberByOAuth2(memberVO);
			memberAuthVO.setUsername(memberVO.getUsername());
			memberMapper.insertAuthByOAuth2(memberAuthVO);

			List<String> alertTypeCodes = alertMapper.getATCs();
			AlertSettingVO alertSettingVO = new AlertSettingVO();
			alertSettingVO.setMemUsername(memberVO.getUsername());
			for(String atc : alertTypeCodes) {
				alertSettingVO.setAlertTypeCode(atc);
				alertMapper.insertSetting(alertSettingVO);
			}
		}else {
			memberVO = existingUser;

			needAdditionalInfo = "Y".equals(memberVO.getMemEtcYn());
		}

		return memberVO == null ? null : new CustomOAuth2User(memberVO,needAdditionalInfo);

	}
}
