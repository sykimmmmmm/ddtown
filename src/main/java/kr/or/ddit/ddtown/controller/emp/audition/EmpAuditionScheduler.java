package kr.or.ddit.ddtown.controller.emp.audition;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.ddtown.service.emp.audition.IEmpAuditionService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class EmpAuditionScheduler {
//오디션 일정 활성 상태 자동 변경
	@Autowired
	private IEmpAuditionService empAuditionService;

	//매일 정각에 실행
	@Scheduled(cron = "0 0 0 * * *")//"*/30 * * * * *"(30초),"0 0 0 * * *"(하루 정각)
	public void  empAuditionScheduler() {
		log.info("오디션 일정 자동 해제 스케줄러 시작...");
		try {
			empAuditionService.uploadAuditionScheduler();
			log.info("오디션 일정 자동 해제 스케줄러 완료.");
		}catch (Exception e) {
				log.error("오디션일정 만료 해제중 오류발생: {}", e.getMessage(), e);
		}

	}
}
