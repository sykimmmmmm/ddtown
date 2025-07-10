package kr.or.ddit.ddtown.controller.community;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.community.ICommunityMainPageService;
import kr.or.ddit.vo.community.CommunityLikeVO;
import kr.or.ddit.vo.community.CommunityProfileVO;
import kr.or.ddit.vo.community.CommunityReplyVO;
import kr.or.ddit.vo.community.CommunityReportVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/community")
public class CommunityReplyController {

	@Autowired
	private ICommunityMainPageService artistMainPageService;

	@PostMapping("/reply/insert")
	public ResponseEntity<Map<Object, Object>> replyInsert(CommunityReplyVO replyVO){

		log.info("reply 등록 요청 : " + replyVO);

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }

	    // 접속중인 사용자가 해당 아티스트 커뮤니티에 팔로우 하고 있는 지 여부
	    int artGroupNo = replyVO.getArtGroupNo();
	    String memUsername = memberVO.getMemUsername();
	    Map<String, Object> currentUser = new HashMap<>();
	    currentUser.put("artGroupNo", artGroupNo);
	    currentUser.put("memUsername", memUsername);

	    CommunityProfileVO currentUserComu = artistMainPageService.currentUserComufollowing(currentUser);

	    replyVO.setComuProfileNo(currentUserComu.getComuProfileNo());

	    Map<Object, Object> map = artistMainPageService.replyInsert(replyVO, memUsername);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	@PostMapping("/reply/update")
	public ResponseEntity<ServiceResult> replyUpdate(CommunityReplyVO replyVO){

		log.info("reply 수정 요청 : " + replyVO);

		ServiceResult result = artistMainPageService.replyUpdate(replyVO);

		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@PostMapping("/reply/delete")
	public ResponseEntity<ServiceResult> replyDelete(int replyNo){

		log.info("reply 삭제 요청 : " + replyNo);

		ServiceResult result = artistMainPageService.replyDelete(replyNo);

		return new ResponseEntity<>(result,HttpStatus.OK);
	}

	@PostMapping("/like/update")
	public ResponseEntity<ServiceResult> likeUpdate(CommunityLikeVO likeVO){

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }

	    int artGroupNo = likeVO.getArtGroupNo();
	    String memUsername = memberVO.getMemUsername();
	    Map<String, Object> currentUser = new HashMap<>();
	    currentUser.put("artGroupNo", artGroupNo);
	    currentUser.put("memUsername", memUsername);

	    CommunityProfileVO currentUserComu = artistMainPageService.currentUserComufollowing(currentUser);

	    likeVO.setComuProfileNo(currentUserComu.getComuProfileNo());

	    ServiceResult result = artistMainPageService.likeUpdate(likeVO);

		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@PostMapping("/send/report")
	public ResponseEntity<ServiceResult> comuReport(CommunityReportVO reportVO){
		log.info("reportVO : {}", reportVO);
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }

	    reportVO.setMemUsername(memberVO.getMemUsername());

	    ServiceResult result = artistMainPageService.report(reportVO);

		return new ResponseEntity<>(result, HttpStatus.OK);
	}
}
