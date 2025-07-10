package kr.or.ddit.ddtown.controller.community;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.community.ICommunityMainPageService;
import kr.or.ddit.ddtown.service.community.ICommunityProfileService;
import kr.or.ddit.vo.community.CommunityLikeVO;
import kr.or.ddit.vo.community.CommunityPostVO;
import kr.or.ddit.vo.community.CommunityProfileVO;
import kr.or.ddit.vo.community.CommunityReplyVO;
import kr.or.ddit.vo.community.CommunityReportVO;
import kr.or.ddit.vo.live.LiveVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/community")
public class CommunityAPIController {

	@Autowired
	private ICommunityProfileService profileService;

	@Autowired
	private ICommunityMainPageService postService;


	@PostMapping("/joinapt")
	public ResponseEntity<Object> joinApt(CommunityProfileVO profileVO){
		log.info("profileVO : {}", profileVO);
		int status = 0;
		ResponseEntity<Object> entity = null;
		//팔로우 테이블 추가
		status = profileService.insertCommuProfile(profileVO);
		if(status > 0) {
			entity = new ResponseEntity<>(HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		// 커뮤니티 프로필 추가
		return entity;
	}

	@PostMapping("/removeapt")
	public ResponseEntity<Object> removeApt(@RequestBody CommunityProfileVO profileVO){
		log.info("profileVO : {}", profileVO);
		ResponseEntity<Object> entity = null;
		// 프로필 del 처리
		int status = profileService.deleteCommuProfile(profileVO);
		if(status > 0) {
			entity = new ResponseEntity<>(HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}

	@GetMapping("/getPost")
	public ResponseEntity<CommunityPostVO> getPost(CommunityPostVO cPostVO){
		log.info("postVO : {}",cPostVO);
		ResponseEntity<CommunityPostVO> entity = null;
		CommunityPostVO postVO = postService.selectPost(cPostVO);
		log.info("postVO : {}", postVO);
		if(postVO != null) {
			entity = new ResponseEntity<>(postVO,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}

	@PostMapping("/reply/insert")
	public ResponseEntity<Object> insertReply(@RequestBody CommunityReplyVO replyVO){
		log.info("replyVO : {}", replyVO);

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		MemberVO memberVO = null;

		if(principal instanceof CustomUser customUser) {
			memberVO = customUser.getMemberVO();
		} else if(principal instanceof CustomOAuth2User auth2User){
			memberVO = auth2User.getMemberVO();
		}

		String memUsername = memberVO.getMemUsername();

		Map<Object, Object> map = postService.replyInsert(replyVO, memUsername);
		ResponseEntity<Object> entity = null;
		if(ServiceResult.OK.equals(map.get("result"))) {
			entity = new ResponseEntity<>(map,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		return entity;
	}

	@PostMapping("/reply/delete")
	public ResponseEntity<Object> deleteReply(int comuReplyNo){
		log.info("comuReplyNo : {}", comuReplyNo);
		ResponseEntity<Object> entity = null;
		ServiceResult result = postService.replyDelete(comuReplyNo);
		if(ServiceResult.OK.equals(result)) {
			entity = new ResponseEntity<>(result,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		return entity;
	}

	@GetMapping("/getUpdatePost")
	public ResponseEntity<Object> getUpdatePost(int comuPostNo){
		log.info("comuPostNo : {}", comuPostNo);
		ResponseEntity<Object> entity = null;
		CommunityPostVO postVO = postService.getUpdatePost(comuPostNo);
		if(postVO != null) {
			entity = new ResponseEntity<>(postVO,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		return entity;
	}

	@PostMapping("/post/update")
	public ResponseEntity<Object> postUpdate(CommunityPostVO postVO){
		log.info("postVO : {}",postVO);
		ResponseEntity<Object> entity = null;
		ServiceResult result = postService.postUpdate(postVO);
		if(ServiceResult.OK.equals(result)) {
			entity = new ResponseEntity<>(result,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		return entity;
	}

	@PostMapping("/post/likeUpdate")
	public ResponseEntity<Object> postLikeUpdate(@RequestBody CommunityLikeVO likeVO){
		log.info("likeVO : {}", likeVO);
		ResponseEntity<Object> entity = null;
		ServiceResult result = postService.likeUpdate(likeVO);
		if(ServiceResult.OK.equals(result)) {
			entity = new ResponseEntity<>(result,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		return entity;

	}

	@PostMapping("/post/delete")
	public ResponseEntity<Object> postDelete(CommunityPostVO postVO){
		log.info("postVO : {}", postVO);
		ResponseEntity<Object> entity = null;
		postVO.setComuPostDelYn("Y");
		ServiceResult result = postService.deletPostByComuPostNo(postVO);
		if(ServiceResult.OK.equals(result)) {
			entity = new ResponseEntity<>(result,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		return entity;

	}

	@PostMapping("/send/report")
	public ResponseEntity<Object> reportPostReply(CommunityReportVO reportVO){
		log.info("reportVO : {}", reportVO);
		ResponseEntity<Object> entity = null;
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }

	    reportVO.setMemUsername(memberVO.getMemUsername());

	    ServiceResult result = postService.report(reportVO);

	    if(ServiceResult.OK.equals(result)||ServiceResult.EXIST.equals(result)) {
	    	entity = new ResponseEntity<>(result,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		return entity;
	}

	@PostMapping("/updateProfile")
	public ResponseEntity<Object> updateProfile(CommunityProfileVO profileVO){
		log.info("profileVO : {}", profileVO);
		ResponseEntity<Object> entity = null;
		ServiceResult result = profileService.updateProfile(profileVO);
		if(ServiceResult.OK.equals(result)) {
			entity = new ResponseEntity<>(result,HttpStatus.OK);
		}else {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		return entity;
	}

	@GetMapping("/live/current/{artGroupNo}")
	public ResponseEntity<LiveVO> getCurrentLiveInfo(@PathVariable int artGroupNo){
		log.info("API 요청 : 현재 라이브 정보. artGroupNo: {}", artGroupNo);
		LiveVO liveInfo = postService.getLiveBroadcastInfo(artGroupNo);
		if(liveInfo != null) {
			return new ResponseEntity<>(liveInfo, HttpStatus.OK);
		}else {
			return new ResponseEntity<>(HttpStatus.NO_CONTENT);
		}
	}
}





