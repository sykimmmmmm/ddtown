package kr.or.ddit.ddtown.controller.community;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.micrometer.common.util.StringUtils;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.community.ICommunityMainPageService;
import kr.or.ddit.ddtown.service.community.notice.ICommunityNoticeService;
import kr.or.ddit.ddtown.service.follow.IFollowService;
import kr.or.ddit.ddtown.service.goods.main.IGoodsService;
import kr.or.ddit.ddtown.service.member.membership.IMembershipService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.AlbumVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.artist.ArtistVO;
import kr.or.ddit.vo.community.CommunityNoticeVO;
import kr.or.ddit.vo.community.CommunityPostVO;
import kr.or.ddit.vo.community.CommunityProfileVO;
import kr.or.ddit.vo.community.CommunityVO;
import kr.or.ddit.vo.community.WorldcupVO;
import kr.or.ddit.vo.follow.FollowVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.member.membership.MembershipDescriptionVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/community")
public class CommunityMainPageController {

	@Autowired
	private ICommunityMainPageService artistMainPageService;

	@Autowired
	private IGoodsService goodsService;

	@Autowired
	private IFollowService followService;

	@Autowired
	private IMembershipService membershipService;

	@Autowired
	private ICommunityNoticeService noticeService;

	@Value("${media.server.url}")
	private String mediaServerUrl;


	@GetMapping("/main")
	public String communityMainPage(ArtistGroupVO groups, Model model, Principal principal) {
		log.info("CommunityMainPage() 실행");

		// 서비스 호출 - 그룹 리스트
		List<ArtistGroupVO> groupList = artistMainPageService.getGroupLists();

		log.info("커뮤니티 메인 팔로우 목록 요청");

		if(principal != null) {
			// 사용자 정보 조회
			String username = principal.getName();
			List<FollowVO> list = followService.getFollowList(username);

			log.info("followList : {}", list);

			model.addAttribute("following", list);
		}
		model.addAttribute("groups", groupList);

        List<goodsVO> bestItems = goodsService.getBestSellingGoods(4);
        log.info("### goodsController - bestItems retrieved: {}", bestItems); // 이 로그 확인!
        model.addAttribute("bestItems", bestItems);

		return "community/communityMainPage";
	}

	@GetMapping("/gate/{artGroupNo}")
	public String artistGatePage(Model model, @PathVariable int artGroupNo) {
		log.info("artistGatePage() 실행");

		ArtistGroupVO artistGroupVO = artistMainPageService.getGroupInfo(artGroupNo);
		List<AlbumVO> albumList = artistMainPageService.getGroupAlbum(artGroupNo);

		artistGroupVO.setAlbumList(albumList);
		model.addAttribute("group", artistGroupVO);

		// 공지사항 가져오기
		PaginationInfoVO<CommunityNoticeVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setArtGroupNo(artGroupNo);
		pagingVO.setCurrentPage(1); // 첫 페이지로 설정
		pagingVO.setScreenSize(2); // 페이지당 나오는 게시글 수

		List<CommunityNoticeVO> noticeList = null;

		try {
			noticeList = noticeService.clientPointOfViewCommunityNoticeList(pagingVO);

			// 2개보다 많이 가져왔을 경우, 첫 2개만 사요
			if(noticeList != null && noticeList.size() > 2) {
				noticeList = noticeList.subList(0, 2);
			}

		} catch (Exception e) {
			log.error("최신 공지사항을 가져오는 중 오류 발생: {}", e.getMessage());
		}
		model.addAttribute("noticeList", noticeList);

		return "community/communityGate";
	}

	@GetMapping("/gate/{artGroupNo}/apt")
	public String aptMain(CommunityVO communityVO,Model model) {

		log.info("아티스트 그룹 번호 & 페이징네이션 : " + communityVO);

		// 접속중인 사용자 정보 가져오기
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }

	    // 접속중인 사용자가 해당 아티스트 커뮤니티에 팔로우 하고 있는 지 여부
	    int artGroupNo = communityVO.getArtGroupNo();
	    String memUsername = "";
	    if(memberVO != null) {
	    	memUsername = memberVO.getMemUsername();
	    }
	    Map<String, Object> currentUser = new HashMap<>();
	    currentUser.put("artGroupNo", artGroupNo);
	    currentUser.put("memUsername", memUsername);

	    CommunityProfileVO currentUserComu = artistMainPageService.currentUserComufollowing(currentUser);

	    // 해당 커뮤니티에 팔로우가 되어 있지 않다면
	    if(currentUserComu == null) {
	    	model.addAttribute("followFlag", "N");
	    	communityVO.setMyComuProfileNo(0);
	    }else {
	    	model.addAttribute("followFlag", "Y");
	    	model.addAttribute("userProfile", currentUserComu);
	    	communityVO.setMyComuProfileNo(currentUserComu.getComuProfileNo());
	    }

	    // 멤버십 권한 확인 로직 추가
	    boolean hasMembership = false;
	    if(memUsername != null && !memUsername.isEmpty()) {
	    	try {
	    		hasMembership = membershipService.hasValidMembershipSubscription(memUsername, artGroupNo);
	    		log.info("사용자 {}의 아티스트 그룹 {} 멤버십 여부: {}", memUsername, artGroupNo, hasMembership);
	    	}catch (Exception e) {
				log.error("멤버십 구독 여부 확인 중 오류 발생: {}", e.getMessage());
				hasMembership = false;
			}
	    }
	    MembershipDescriptionVO mdVO = membershipService.getMembershipInfo(artGroupNo);
	    log.info("mdVO : {}",mdVO);
	    model.addAttribute("membershipInfo", mdVO);
	    model.addAttribute("hasMembership", hasMembership);

		PaginationInfoVO<CommunityVO> pagingVO = new PaginationInfoVO<>();

		int page = communityVO.getPage();
		String searchWord = communityVO.getSearchWord();
		String searchType = communityVO.getSearchType();

		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchWord(searchWord);
		}
		if(StringUtils.isNotBlank(searchType)) {
			pagingVO.setSearchType(searchType);
		}

		pagingVO.setCurrentPage(page);
		communityVO.setStartRow(pagingVO.getStartRow());
		communityVO.setEndRow(pagingVO.getEndRow());

		List<CommunityPostVO> postVO = null;
		int totalRecord = 0;
		String currentPost = "";

		if(communityVO.isArtistTabYn()) {
			communityVO.setBoardTypeCode("ARTIST_BOARD");
			postVO = artistMainPageService.getPostList(communityVO);
			totalRecord = artistMainPageService.getPostTotal(communityVO);
			model.addAttribute("artistPostVO", postVO);
			model.addAttribute("fanPostVO", new CommunityVO());
			currentPost = "artist";
			log.info("현재 탭 : " + currentPost);
			log.info("게시물 정보 : " + postVO);
		}else {
			communityVO.setBoardTypeCode("FAN_BOARD");
			postVO = artistMainPageService.getPostList(communityVO);
			totalRecord = artistMainPageService.getPostTotal(communityVO);
			model.addAttribute("fanPostVO", postVO);
			model.addAttribute("artistPostVO", new CommunityVO());
			currentPost = "fan";
			log.info("현재 탭 : " + currentPost);
			log.info("게시물 정보 : " + postVO);
		}

		if(postVO != null && totalRecord > 0) {
			pagingVO.setTotalRecord(totalRecord);
		}else {
			pagingVO.setTotalRecord(0);
		}


		ArtistGroupVO artistGroupVO = artistMainPageService.getCommunityInfo(communityVO.getArtGroupNo());

		Integer membershipGoodsNo = artistMainPageService.getMembershipGoodsNo(artGroupNo);
		artistGroupVO.setMembershipGoodsNo(membershipGoodsNo);

		log.info("communityVO : " + artistGroupVO);

		Map<Object, Object> codeListMap = artistMainPageService.getCodeDetail();
		ObjectMapper objectMapper = new ObjectMapper();
		String codeMap = null;
		try {
			codeMap = objectMapper.writeValueAsString(codeListMap);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}

		List<goodsVO> thumbnail = artistMainPageService.thumbnailInfo(artGroupNo);

		log.info("------------------thumbnail : " + thumbnail);
		model.addAttribute("thumnailImages", thumbnail);

		int fansWithoutDel = artistMainPageService.getFansWithoutDel(artGroupNo);
		model.addAttribute("fansWithoutDel", fansWithoutDel);

		// ✅ Model에 미디어 서버 주소를 담기
        model.addAttribute("mediaServerUrl", mediaServerUrl);

		model.addAttribute("artistGroupVO", artistGroupVO);
		model.addAttribute("pagingVO", pagingVO);
		// 요청 파라미터 다시 보내주기
		model.addAttribute("communityVO", communityVO);
		model.addAttribute("codeMap", codeMap);
		return "community/apt/main";
	}


	@PostMapping("/insert/post")
	public ResponseEntity<ServiceResult> postInsert(CommunityPostVO postVO){

		ServiceResult result = null;

		// 접속중인 사용자 정보 가져오기
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }

	    String memUsername = memberVO.getMemUsername();
	    postVO.setMemUsername(memUsername);

		log.info("insertPostVO : " + postVO);

		result = artistMainPageService.postInsert(postVO);


		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@GetMapping("/post/get/{comuPostNo}")
	public ResponseEntity<CommunityPostVO> getPost(CommunityPostVO comuPostVO){

		CommunityPostVO postVO = artistMainPageService.getPost(comuPostVO);

		return new ResponseEntity<>(postVO,HttpStatus.OK);
	}


	@PostMapping("/update/post")
	public ResponseEntity<ServiceResult> postUpdate(CommunityPostVO postVO){

		log.info("업데이트 요청한 postVO : " + postVO);

		if(postVO.getMemUsername() == null) {
			// 접속중인 사용자 정보 가져오기
			Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			MemberVO memberVO = null;
			if(principal instanceof CustomUser customUser) {
				memberVO = customUser.getMemberVO();
			}else if(principal instanceof CustomOAuth2User auth2User) {
				memberVO = auth2User.getMemberVO();
			}

			String memUsername = memberVO.getMemUsername();
			postVO.setMemUsername(memUsername);
		}

		ServiceResult result = artistMainPageService.postUpdate(postVO);

		return new ResponseEntity<>(result,HttpStatus.OK);
	}

	@GetMapping("{artGroupNo}/profile/{comuProfileNo}")
	public String aptProfileDetail(
			  @PathVariable int artGroupNo
			, @PathVariable int comuProfileNo
			, @RequestParam(required = false) Integer targetPostNo		// 게시글번호
			, Model model
			) {
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		CommunityProfileVO myProfileVO = new CommunityProfileVO();
		myProfileVO.setMemUsername(username);
		myProfileVO.setArtGroupNo(artGroupNo);
		int myComuProfileNo = artistMainPageService.getMyComuProfileNo(myProfileVO);
		boolean membershipFlag = artistMainPageService.getMyMemberShipYn(myProfileVO);
		CommunityProfileVO profileVO = new CommunityProfileVO();
		profileVO.setArtGroupNo(artGroupNo);
		profileVO.setComuProfileNo(comuProfileNo);
		profileVO.setMyComuProfileNo(myComuProfileNo);
		profileVO = artistMainPageService.selectProfile(profileVO);

		Map<Object, Object> codeListMap = artistMainPageService.getCodeDetail();
		ObjectMapper objectMapper = new ObjectMapper();
		String codeMap = null;
		try {
			codeMap = objectMapper.writeValueAsString(codeListMap);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		// 멤버쉽 관련 시작
		ArtistGroupVO artistGroupVO = artistMainPageService.getCommunityInfo(artGroupNo);
		Integer membershipGoodsNo = artistMainPageService.getMembershipGoodsNo(artGroupNo);
		artistGroupVO.setMembershipGoodsNo(membershipGoodsNo);
		log.info("membershipGoodsNo : {} ",membershipGoodsNo);
		// 접속중인 사용자 정보 가져오기
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }
	    String memUsername = "";
	    if(memberVO != null) {
	    	memUsername = memberVO.getMemUsername();
	    }
		// 멤버십 권한 확인 로직 추가
	    boolean hasMembership = false;
	    if(memUsername != null && !memUsername.isEmpty()) {
	    	try {
	    		hasMembership = membershipService.hasValidMembershipSubscription(memUsername, artGroupNo);
	    		log.info("사용자 {}의 아티스트 그룹 {} 멤버십 여부: {}", memUsername, artGroupNo, hasMembership);
	    	}catch (Exception e) {
				log.error("멤버십 구독 여부 확인 중 오류 발생: {}", e.getMessage());
				hasMembership = false;
			}
	    }
	    MembershipDescriptionVO mdVO = membershipService.getMembershipInfo(artGroupNo);
	    log.info("mdVO : {}",mdVO);
	    model.addAttribute("membershipInfo", mdVO);
	    model.addAttribute("hasMembership", hasMembership);
	    model.addAttribute("artistGroupVO", artistGroupVO);
	    // 멤버쉽 관련 끝
		model.addAttribute("membershipFlag", membershipFlag);
		model.addAttribute("myComuProfileNo",myComuProfileNo);
		model.addAttribute("profileVO", profileVO);
		model.addAttribute("artGroupNo", artGroupNo);
		model.addAttribute("mediaServerUrl", mediaServerUrl);

		if(targetPostNo != null) {
			model.addAttribute("targetPostNo", targetPostNo);
		}

		List<goodsVO> thumbnail = artistMainPageService.thumbnailInfo(artGroupNo);

		log.info("------------------thumbnail : " + thumbnail);
		model.addAttribute("thumnailImages", thumbnail);

		model.addAttribute("codeMap", codeMap);
		return "community/apt/profileDetail";
	}

	@PostMapping("/delete/post/{postNum}")
	public ResponseEntity<ServiceResult> postDelete(CommunityPostVO comuPostVO){

		// 접속중인 사용자 정보 가져오기
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }

	    // 접속중인 사용자가 해당 아티스트 커뮤니티에 팔로우 하고 있는 지 여부
	    int artGroupNo = comuPostVO.getArtGroupNo();
	    String memUsername = "";

	    if(memberVO != null) {
	    	memUsername = memberVO.getMemUsername();
	    }

	    Map<String, Object> currentUser = new HashMap<>();
	    currentUser.put("artGroupNo", artGroupNo);
	    currentUser.put("memUsername", memUsername);

	    CommunityProfileVO currentUserComu = artistMainPageService.currentUserComufollowing(currentUser);

	    comuPostVO.setComuProfileNo(currentUserComu.getComuProfileNo());

		ServiceResult result = artistMainPageService.postDelete(comuPostVO);

		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@GetMapping("/post/detail/{comuPostNo}")
	public ResponseEntity<CommunityPostVO> getPostDetail(CommunityPostVO comuPostVO){

		log.info("게시판 상세 요청 : " + comuPostVO);

		// 접속중인 사용자 정보 가져오기
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }

	    // 접속중인 사용자가 해당 아티스트 커뮤니티에 팔로우 하고 있는 지 여부
	    int artGroupNo = comuPostVO.getArtGroupNo();
	    String memUsername = "";

	    if(memberVO != null) {
	    	memUsername = memberVO.getMemUsername();
	    }

	    Map<String, Object> currentUser = new HashMap<>();
	    currentUser.put("artGroupNo", artGroupNo);
	    currentUser.put("memUsername", memUsername);

	    CommunityProfileVO currentUserComu = artistMainPageService.currentUserComufollowing(currentUser);
	    if(currentUserComu != null) {
	    	comuPostVO.setComuProfileNo(currentUserComu.getComuProfileNo());
	    }

		CommunityPostVO postVO = artistMainPageService.getPost(comuPostVO);

		return new ResponseEntity<>(postVO,HttpStatus.OK);
	}

	@GetMapping("/gate/{artGroupNo}/apt/api")
	public ResponseEntity<Map<Object, Object>> aptMain(CommunityVO communityVO) {

		Map<Object, Object> map = new HashMap<>();

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }

	    // 접속중인 사용자가 해당 아티스트 커뮤니티에 팔로우 하고 있는 지 여부
	    int artGroupNo = communityVO.getArtGroupNo();
	    String memUsername = "";
	    if(memberVO != null) {
	    	memUsername = memberVO.getMemUsername();
	    }
	    Map<String, Object> currentUser = new HashMap<>();
	    currentUser.put("artGroupNo", artGroupNo);
	    currentUser.put("memUsername", memUsername);

	    CommunityProfileVO currentUserComu = artistMainPageService.currentUserComufollowing(currentUser);


	    // 해당 커뮤니티에 팔로우가 되어 있지 않다면
	    if(currentUserComu == null) {
	    	map.put("followFlag", "N");
	    	communityVO.setMyComuProfileNo(0);
	    }else {
	    	if (currentUserComu.getComuMemCatCode().equals("CMCC003")) {

				currentUserComu.setMemberShipYn("Y");
			}
	    	map.put("followFlag", "Y");
	    	map.put("userProfile", currentUserComu);
	    	communityVO.setMyComuProfileNo(currentUserComu.getComuProfileNo());
	    }

		PaginationInfoVO<CommunityVO> pagingVO = new PaginationInfoVO<>();
		int page = communityVO.getPage();

		if(StringUtils.isNotBlank(communityVO.getSearchWord())) {
			pagingVO.setSearchWord(communityVO.getSearchWord());
		}
		if(StringUtils.isNotBlank(communityVO.getSearchType())) {
			pagingVO.setSearchType(communityVO.getSearchType());
		}

		pagingVO.setCurrentPage(page);
		communityVO.setStartRow(pagingVO.getStartRow());
		communityVO.setEndRow(pagingVO.getEndRow());

		List<CommunityPostVO> postVO = null;
		int totalRecord = 0;
		String currentPost = "";

		if(communityVO.isArtistTabYn()) {
			communityVO.setBoardTypeCode("ARTIST_BOARD");
			postVO = artistMainPageService.getPostList(communityVO);
			totalRecord = artistMainPageService.getPostTotal(communityVO);
			map.put("artistPostVO", postVO);
			map.put("fanPostVO", new CommunityVO());
			currentPost = "artist";
			log.info("현재 탭 : " + currentPost);
			log.info("게시물 정보 : " + postVO);
		}else {
			communityVO.setBoardTypeCode("FAN_BOARD");
			postVO = artistMainPageService.getPostList(communityVO);
			totalRecord = artistMainPageService.getPostTotal(communityVO);
			map.put("fanPostVO", postVO);
			map.put("artistPostVO", new CommunityVO());
			currentPost = "fan";
			log.info("현재 탭 : " + currentPost);
			log.info("게시물 정보 : " + postVO);
		}

		if(postVO != null && totalRecord > 0) {
			pagingVO.setTotalRecord(totalRecord);
		}else {
			pagingVO.setTotalRecord(0);
		}

		ArtistGroupVO artistGroupVO = artistMainPageService.getCommunityInfo(communityVO.getArtGroupNo());

		map.put("pagingVO", pagingVO);

		map.put("tab", communityVO.isArtistTabYn());

		map.put("artistGroupVO", artistGroupVO);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}


	@GetMapping("/worldcup")
	public String favoritWorldcup() {
		return "community/worldcup";
	}

	@GetMapping("/worldcup/artist/list")
	public ResponseEntity<List<ArtistVO>> artistList(){

		List<ArtistVO> artistList = artistMainPageService.artistList();

		return new ResponseEntity<>(artistList, HttpStatus.OK);
	}

	@PostMapping("/worldcup/insert")
	public ResponseEntity<Map<Object, Object>> worldCupWinner(WorldcupVO worldcupVO){

		log.info("artNo : " + worldcupVO.getArtNo());

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    MemberVO memberVO = null;
	    if(principal instanceof CustomUser customUser) {
	        memberVO = customUser.getMemberVO();
	    }else if(principal instanceof CustomOAuth2User auth2User) {
	        memberVO = auth2User.getMemberVO();
	    }

	    worldcupVO.setMemUsername(memberVO.getMemUsername());

	    ServiceResult result = artistMainPageService.worldcupWinner(worldcupVO);

	    List<WorldcupVO> winnerList = artistMainPageService.winnerList();

		Map<Object, Object> map = new HashMap<>();

		map.put("result", result);
		map.put("winnerList", winnerList);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
