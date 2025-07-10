package kr.or.ddit.security;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

	private static final String ADMINROLE = "ROLE_ADMIN";
	private static final String EMPROLE = "ROLE_EMPLOYEE";
	private static final String ARTISTROLE = "ROLE_ARTIST";


	@Override
	public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {

		boolean isAdminOrEmployee = false;
		boolean isArtist = false;
		for(GrantedAuthority auth : authentication.getAuthorities()) {
			if(ADMINROLE.equals(auth.getAuthority()) || EMPROLE.equals(auth.getAuthority()) ) {
				isAdminOrEmployee = true;
			}else if(ARTISTROLE.equals(auth.getAuthority())) {
				isArtist = true;
			}
		}
		log.info("isAdminOrEmployee: {}", isAdminOrEmployee);

		if(isAdminOrEmployee || isArtist){
			response.sendRedirect("/login");
		}else {
			response.sendRedirect("/community/main");
		}

	}
}
