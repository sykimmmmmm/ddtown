package kr.or.ddit.ddtown.controller.community;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.ddtown.service.community.ICommunityMainPageService;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.community.CommunityProfileVO;
import kr.or.ddit.vo.community.CommunityVO;
import lombok.extern.slf4j.Slf4j;

/**
 * 커뮤니티의 라이브 관련 요청을 전담하는 컨트롤러
 */
@Slf4j
@Controller
@RequestMapping("/community")
public class CommunityLiveController {

    @Autowired
    private ICommunityMainPageService communityMainService;

    @Value("${media.server.url}")
    private String mediaServerUrl;

    /**
     * 커뮤니티의 '라이브' 탭을 동기 방식으로 처리하는 메소드.
     * DB에서 직접 방송 상태를 조회하여 모델에 담아 뷰로 전달합니다.
     * @param artGroupNo 현재 보고 있는 아티스트 그룹 번호
     * @param model 뷰에 데이터를 전달하기 위한 모델 객체
     * @param principal 현재 로그인한 사용자 정보
     * @return 렌더링할 뷰의 이름
     */
    @GetMapping("/live/{artGroupNo}")
    public String communityLiveTab(
            @PathVariable int artGroupNo,
            Model model,
            Principal principal
        ) {

        log.info("라이브 탭 페이지 요청. artGroupNo: {}", artGroupNo);

        Map<Object, Object> codeListMap = communityMainService.getCodeDetail();
		ObjectMapper objectMapper = new ObjectMapper();
		String codeMap = null;
		try {
			codeMap = objectMapper.writeValueAsString(codeListMap);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		model.addAttribute("codeMap", codeMap);

        // 1. 페이지 표시에 필요한 기본 정보 조회 로직 (이전과 동일)
        ArtistGroupVO artistGroupVO = communityMainService.getCommunityInfo(artGroupNo);
        model.addAttribute("artistGroupVO", artistGroupVO);

        String memUsername = (principal != null) ? principal.getName() : "";
        model.addAttribute("currentUserId", memUsername);

        if (!memUsername.isEmpty()) {
            Map<String, Object> currentUserMap = new HashMap<>();
            currentUserMap.put("artGroupNo", artGroupNo);
            currentUserMap.put("memUsername", memUsername);
            CommunityProfileVO currentUserProfile = communityMainService.currentUserComufollowing(currentUserMap);

            if(currentUserProfile == null) {
                model.addAttribute("followFlag", "N");
            } else {
                model.addAttribute("followFlag", "Y");
                model.addAttribute("userProfile", currentUserProfile);
            }
        } else {
            model.addAttribute("followFlag", "N");
        }

        model.addAttribute("mediaServerUrl", mediaServerUrl);

        CommunityVO communityVO = new CommunityVO();
        communityVO.setArtGroupNo(artGroupNo);
        model.addAttribute("communityVO", communityVO);

//        LiveVO liveInfo = communityMainService.getLiveBroadcastInfo(artGroupNo);

        // 3. 모델에 liveInfo 객체를 담아 JSP로 전달합니다.
        // ## 06.20 비동기로 바꾸면서 주석처리
//        model.addAttribute("liveInfo", liveInfo);
//        log.info("DB 조회 결과 - artGroupNo: {}의 라이브 정보: {}", artGroupNo, liveInfo);

        return "community/apt/main";
    }
}
