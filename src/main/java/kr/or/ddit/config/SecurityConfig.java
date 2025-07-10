package kr.or.ddit.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.security.servlet.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.HeadersConfigurer.FrameOptionsConfig;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import jakarta.servlet.DispatcherType;
import kr.or.ddit.filter.RecaptchaAuthenticationFilter;
import kr.or.ddit.security.CustomLoginFailureHandler;
import kr.or.ddit.security.CustomLoginSuccessHandler;
import kr.or.ddit.security.CustomLogoutSuccessHandler;
import kr.or.ddit.security.CustomOAuth2LoginFailureHandler;
import kr.or.ddit.security.CustomOAuth2LoginSuccessHandler;
import kr.or.ddit.security.CustomOAuth2UserService;
import kr.or.ddit.security.CustomUserDetailsService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
@EnableWebSecurity
public class SecurityConfig {

	@Autowired
	private CustomUserDetailsService customUserDetailsService;

	@Autowired
	private CustomOAuth2UserService oAuth2UserService;

	@Value("${rechaptcha.site-key}")
	private String recaptchaSiteKey;
	@Value("${rechaptcha.verify-url}")
	private String recaptchaVerifyUrl;

	@Bean
	protected WebSecurityCustomizer configure() {
		return web -> web.ignoring()
				.requestMatchers(new AntPathRequestMatcher("/resources/**"))
				.requestMatchers("/upload/**");
	}

	@Bean
	protected SecurityFilterChain filterChain(HttpSecurity http,AuthenticationSuccessHandler customLoginSuccessHandler) throws Exception {
		// 시큐리티 csrf 토큰 키는 '${_csrf.headerName}', 토큰 값은 '${_csrf.token}'으로 설정
		AuthenticationFailureHandler failureHandler = new CustomLoginFailureHandler();
		http.httpBasic(basic-> basic.disable());

		http.authorizeHttpRequests(authorize->
			authorize.dispatcherTypeMatchers(DispatcherType.FORWARD,DispatcherType.ASYNC).permitAll()
			.requestMatchers(PathRequest.toStaticResources().atCommonLocations()).permitAll()
			.requestMatchers("/resources/**","/error", "/WEB-INF/views/error/**","/favicon.ico","/.well-known/**").permitAll()
			.requestMatchers("/admin/**").hasRole("ADMIN")
			.requestMatchers("/emp/**").hasAnyRole("EMPLOYEE","ADMIN")
			.requestMatchers("/","/login","/auth/**","/corporate/**","/emplogin","/community/main","/WEB-INF/views/community/communityMainPage.jsp").permitAll()
			.requestMatchers("/ws/chat", "/ws-stomp/**").permitAll()
			.requestMatchers("/chat/dm/channel/**","/chat/dm/channel").hasAnyRole("ARTIST", "MEMBERSHIP", "EMPLOYEE", "ADMIN")
			.requestMatchers("/chat/dm/channel/enter/**").hasAnyRole("ARTIST", "MEMBERSHIP", "EMPLOYEE", "ADMIN")
			.requestMatchers(HttpMethod.POST, "/mypage/withdraw").hasAnyRole("MEMBER", "MEMBERSHIP")
			.requestMatchers("/mypage/**").hasAnyRole("MEMBER", "MEMBERSHIP")
			.requestMatchers("/api/alert/**").permitAll()
			.anyRequest().authenticated()
		);

		http.addFilterBefore(new RecaptchaAuthenticationFilter(failureHandler,recaptchaSiteKey,recaptchaVerifyUrl), UsernamePasswordAuthenticationFilter.class);
		http.formLogin(login -> login.loginPage("/login")
				.successHandler(customLoginSuccessHandler)
				.failureHandler(new CustomLoginFailureHandler())
		);

		http.oauth2Login(oauth2 -> oauth2
							.userInfoEndpoint(endPoint -> endPoint.userService(oAuth2UserService))
							.loginPage("/login")
							.successHandler(new CustomOAuth2LoginSuccessHandler())
							.failureHandler(new CustomOAuth2LoginFailureHandler())
		);

		// CSRF 보호 설정 (dm)
		http.csrf(csrf -> csrf
				.ignoringRequestMatchers("/ws-stomp/**", "/ws/chat/**", "/api/alert/**")
		);


		http.logout(logout -> logout.logoutUrl("/logout")
									.invalidateHttpSession(true)
									.logoutSuccessHandler(new CustomLogoutSuccessHandler())
		);

		// iframe : X-Frame-Options 헤더 SAMEORIGIN으로 설정 > 동일한 도메인에서 오는 프레임 콘텐츠 허용
		http.headers(headers -> headers
				.frameOptions(FrameOptionsConfig::sameOrigin)
		);

		return http.build();
	}

	@Bean
	protected BCryptPasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	protected AuthenticationSuccessHandler customAuthenticationSuccessHandler() {
		return new CustomLoginSuccessHandler();
	}

	@Bean
	protected AuthenticationManager authenticationManger(HttpSecurity http, BCryptPasswordEncoder bCryptPasswordEncoder,
			UserDetailsService userDetailsService ) {
		DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
		authProvider.setUserDetailsService(customUserDetailsService);
		authProvider.setPasswordEncoder(bCryptPasswordEncoder);
		return new ProviderManager(authProvider);
	}

}
