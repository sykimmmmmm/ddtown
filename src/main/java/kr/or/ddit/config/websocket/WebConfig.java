package kr.or.ddit.config.websocket;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer{

	@Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**") // /api/ 로 시작하는 모든 경로에 대해
                .allowedOrigins(
                		"http://localhost:8080",
                		"http://[ip]:8080"
                ) // localhost와 학원 IP에서의 요청을 허용
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS") // GET 요청만 허용
		        .allowedHeaders("*")    // 모든 헤더 허용
		        .allowCredentials(true) // 자격증명(쿠키 등) 허용
		        .maxAge(3600);          // pre-flight 요청 캐시 시간(초)
    }
}
