package kr.or.ddit.security;

import java.io.IOException;
import java.util.Iterator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.ddtown.service.admin.group.IAdminArtistGroupService;
import kr.or.ddit.ddtown.service.auth.IUserService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler{

	private RequestCache requestCache = new HttpSessionRequestCache();

	@Autowired
	private IAdminArtistGroupService artistService;

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		log.info("로그인 인증 성공 핸들러 실행");
		HttpSession session = request.getSession(false);
		if(session != null) {
			session.removeAttribute(CustomLoginFailureHandler.LOGIN_FAILURE_COUNT_SESSION_ATTR);
			session.removeAttribute("showRecaptcha");
			log.info("Login successful. Cleared failure count for session {}", session.getId());
		}

		User user = (User) authentication.getPrincipal();

		// 시큐리티 활성화된 사용자인지 체크
		if(user.isEnabled()) {
			log.info("로그인 핸들러->username : {}", user.getUsername());
			log.info("로그인 핸들러->password : {}", user.getPassword());
			String adminAuth = "";
			String empAuth = "";
			String artistAuth = "";
			Iterator<GrantedAuthority> ite_auth = user.getAuthorities().iterator();
			while(ite_auth.hasNext()) {
				String auth = ite_auth.next().getAuthority();
				log.info("로그인 핸들러-> auth : {}", auth);
				if("ROLE_ADMIN".equals(auth)) {
					adminAuth = auth;
				}else if("ROLE_EMPLOYEE".equals(auth)){
					empAuth = auth;
				}else if("ROLE_ARTIST".equals(auth)) {
					artistAuth = auth;
				}
			}

			clearAuthenticationAttribute(request);

			SavedRequest savedRequest = requestCache.getRequest(request, response);
			String targetUrl = "/community/main";
			if(savedRequest != null) {
				log.info("saveRequest.getRedirectUrl() : {}",savedRequest.getRedirectUrl());
				String url = savedRequest.getRedirectUrl();
				if(!isUndesirableTarget(url)) {
					targetUrl = url;
					requestCache.removeRequest(request, response);
				}else {
					requestCache.removeRequest(request, response);
				}
			}else {
				if("ROLE_EMPLOYEE".equals(empAuth)) {
					targetUrl="/emp/main";
				}

				if("ROLE_ADMIN".equals(adminAuth)) {
					targetUrl="/admin/main";
				}

				if("ROLE_ARTIST".equals(artistAuth)) {
					int artistGroupNo = artistService.selectArtGroupNoByMemUsername(user.getUsername());
					if(artistGroupNo != 0) {
						targetUrl = "/community/gate/"+artistGroupNo+"/apt";
					}
				}
			}

			log.info("로그인 성공시 타겟 URL : {} ", targetUrl);
			response.sendRedirect(targetUrl);
		}

	}

	private boolean isUndesirableTarget(String url) {
		if(url == null) {
			return true;
		}

		return url.contains("/.well-known/") || url.contains("/.favicon.ico") || url.contains("/auth/form") || url.contains("/chat/dm");
	}

	private void clearAuthenticationAttribute(HttpServletRequest request) {
		log.info("session 예외 제거실행!");
		HttpSession session = request.getSession(false);
		if(session == null) {
			return;
		}

		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}
}
