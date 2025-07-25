package kr.or.ddit.vo.security;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;

import kr.or.ddit.vo.user.MemberVO;
import lombok.Getter;

@Getter
public class CustomOAuth2User extends DefaultOAuth2User{

	private MemberVO memberVO;
	private boolean needAdditionalInfo;

	public CustomOAuth2User(Collection<? extends GrantedAuthority> authorities, Map<String, Object> attributes,
			String nameAttributeKey) {
		super(authorities, attributes, nameAttributeKey);
	}

	public CustomOAuth2User(MemberVO memberVO, boolean needAdditionalInfo) {
		super(memberVO.getAuthList().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList())
				,createAttributes(memberVO)
				,"username");
		this.memberVO = memberVO;
		this.needAdditionalInfo = needAdditionalInfo;
	}

	private static Map<String, Object> createAttributes(MemberVO memberVO) {
		Map<String, Object> attributes = new HashMap<>();
		attributes.put("username", memberVO.getUsername());
		attributes.put("userNicknm", memberVO.getMemNicknm());

		return attributes;
	}

	public String getUsername() {
		return getName();
	}

	public boolean getNeedAdditionalInfo() {
		return this.needAdditionalInfo;
	}
}
