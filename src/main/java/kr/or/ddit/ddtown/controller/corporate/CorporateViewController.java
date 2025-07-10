package kr.or.ddit.ddtown.controller.corporate;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.ddtown.service.coporate.ICorporateService;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/corporate")
public class CorporateViewController {

	@Autowired
	private ICorporateService corporateService;

	@GetMapping("/main")
	public String main() {
		return "corporate/main";
	}

	@GetMapping("/about")
	public String about() {
		return "corporate/about";
	}

	@GetMapping("/finance")
	public String finance() {
		return "corporate/finance";
	}

	@GetMapping("/location")
	public String location() {
		return "corporate/location";
	}

	@GetMapping("/artist/profile")
	public String showArtistProfilePage(Model model) {
		log.info("showArtistProfilePage() 실행");
		List<ArtistGroupVO> artistGroupList = corporateService.getGroupList();

		model.addAttribute("artistGroupList", artistGroupList);
		return "corporate/artistProfile";
	}

}
