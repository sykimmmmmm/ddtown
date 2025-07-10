package kr.or.ddit.ddtown.controller.admin.group;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.admin.artist.IAdminArtistService;
import kr.or.ddit.ddtown.service.admin.group.IAdminArtistGroupService;
import kr.or.ddit.ddtown.service.auth.IUserService;
import kr.or.ddit.ddtown.service.stat.IStatService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.AlbumVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.artist.ArtistVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.user.EmployeeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/community/group")
public class AdminArtistGroupController {

	@Autowired
	private IUserService userService;

	@Autowired
	private IAdminArtistGroupService artistGroupService;

	@Autowired
	private IAdminArtistService artistService;

	@Autowired
	private IStatService statService;

	@GetMapping("/list")
	public String artistGroupList(
			@RequestParam(defaultValue = "1", required = true) int currentPage
			,@RequestParam(required = false, defaultValue = "group") String searchType
			,@RequestParam(required = false) String searchWord
			,@RequestParam(required = false, defaultValue = "all") String artGroupDelYn
			,Model model) {

		PaginationInfoVO<ArtistGroupVO> pagingVO = new PaginationInfoVO<>();
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchWord(searchWord);
			pagingVO.setSearchType(searchType);
		}

		pagingVO.setCurrentPage(currentPage);
		int totalRecord = artistGroupService.getTotalRecord(pagingVO,artGroupDelYn);
		pagingVO.setTotalRecord(totalRecord);
		List<ArtistGroupVO> groupList = artistGroupService.getGroupList(pagingVO,artGroupDelYn);
		pagingVO.setDataList(groupList);

		// 그룹관리 서머리 가져오기 총 그룹 활동 해체
		Map<String, Object> groupSummaryMap = artistGroupService.getGroupSummaryMap();
		model.addAttribute("groupSummaryMap", groupSummaryMap);
		model.addAttribute("pagingVO", pagingVO);

		return "admin/group/groupList";
	}

	@GetMapping("/detail")
	public String artistGroupDetail(@RequestParam int artGroupNo, Model model) {
		Gson gson = new Gson();
		// 그룹 VO 정보 아티스트VO 정보 앨범리스트
		ArtistGroupVO artistGroupVO = artistGroupService.getGroupDetail(artGroupNo);

		// 멤버쉽 현황 가져오기
		List<Map<String, Object>> membershipStat = statService.getMembershipStat(artGroupNo);
		String membershipJsonData = gson.toJson(membershipStat);
		log.info("membershipJsonData : {}", membershipStat);
		if(((BigDecimal)membershipStat.getFirst().get("CT")).intValue() == 0) {
			model.addAttribute("membershipYn", "N");
		}else {
			model.addAttribute("membershipYn", "Y");
		}

		// 가장 많이 팔린 굿즈
		List<goodsVO> groupGoodsStat = statService.getMemberGoodsStatByGroup(artGroupNo);
		log.info("memberGoodsStat : {}", groupGoodsStat);

		model.addAttribute("groupGoods", groupGoodsStat);
		model.addAttribute("membershipJsonData", membershipJsonData);
		model.addAttribute("artistGroupVO", artistGroupVO);
		return "admin/group/groupDetail";
	}

	@GetMapping("/update")
	public String artistGroupUpdateForm(@RequestParam int artGroupNo, Model model) {
		ArtistGroupVO artistGroupVO = artistGroupService.getGroupDetail(artGroupNo);
		List<ArtistVO> artistList = artistService.getArtistListAll();
		List<AlbumVO> albumList = artistGroupService.getAlbumListAll();
		List<EmployeeVO> empList = userService.getEmployList();
		model.addAttribute("status", "U");
		model.addAttribute("artistGroupVO", artistGroupVO);
		model.addAttribute("artistList", artistList);
		model.addAttribute("albumList", albumList);
		model.addAttribute("empList", empList);
		return "admin/group/groupForm";
	}

	@PostMapping("/update")
	public String artistGroupUpdate(ArtistGroupVO groupVO, RedirectAttributes ra) {
		log.info("groupVO : {}", groupVO);
		String path = "";

		ServiceResult result = artistGroupService.updateGroup(groupVO);
		if(ServiceResult.OK.equals(result)) {
			path = "redirect:/admin/community/group/detail?artGroupNo="+groupVO.getArtGroupNo();
		}else {
			ra.addFlashAttribute("msg", "아티스트 업데이트를 하는 도중 오류가 발생했습니다. 다시 시도해주세요");
			path = "redirect:/admin/community/group/update?artGroupNo="+groupVO.getArtGroupNo();
		}


		return path;
	}

	@GetMapping("/form")
	public String artistGroupForm(Model model) {
		List<ArtistVO> artistList = artistService.getArtistListAll();
		List<AlbumVO> albumList = artistGroupService.getAlbumListAll();
		List<EmployeeVO> empList = userService.getEmployList();
		model.addAttribute("artistList", artistList);
		model.addAttribute("albumList", albumList);
		model.addAttribute("empList", empList);
		return "admin/group/groupForm";
	}

	@PostMapping("/regist")
	public String artistGroupRegist(ArtistGroupVO groupVO){
		log.info("groupVO : {}", groupVO);
		String path = "";
		ServiceResult result = artistGroupService.registArtistGroup(groupVO);
		if(ServiceResult.OK.equals(result)) {
			path = "redirect:/admin/community/group/detail?artGroupNo="+groupVO.getArtGroupNo();
		}else {
			path = "redirect:/admin/community/group/form";
		}
		return path;
	}

	@PostMapping("/delete")
	public String artistGroupDelete(int artGroupNo) {
		log.info("artGroupNo : {}", artGroupNo);
		String path = "";
		ServiceResult result = artistGroupService.deleteArtistGroup(artGroupNo);
		if(ServiceResult.OK.equals(result)) {
			path = "redirect:/admin/community/group/list";
		}else {
			path = "redirect:/admin/community/group/detail?artGroupNo="+artGroupNo;
		}
		return path;
	}
}
