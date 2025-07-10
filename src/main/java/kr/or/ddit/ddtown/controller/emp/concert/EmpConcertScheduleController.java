package kr.or.ddit.ddtown.controller.emp.concert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.service.concert.IConcertService;
import kr.or.ddit.ddtown.service.emp.artist.IArtistGroupService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.concert.ConcertVO;
import kr.or.ddit.vo.security.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/emp/concert/schedule")
public class EmpConcertScheduleController {

	@Autowired
	private IConcertService concertService;

	@Autowired
	private IArtistGroupService artistGroupService;

	/**
	 * 현재 로그인한 사용자 (empUsername) 가져오는 메소드
	 */
	private String getCurrentEmpUsername() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if(authentication != null && authentication.getPrincipal() instanceof CustomUser customUser && (customUser.getEmployeeVO() != null)) {
				return customUser.getEmployeeVO().getEmpUsername();

		}
		return null;
	}

	/**
	 * @param concertVO
	 * @param model
	 * @return 콘서트 일정 목록 페이지
	 * @throws Exception
	 */
	@GetMapping("/list")
	public String scheduleList(
			@ModelAttribute("pagingVO") PaginationInfoVO<ConcertVO> pagingVO,
	        @RequestParam(required = false) String statusFilter,
	        @RequestParam(required = false) String searchWord,
	        @RequestParam(required = false) String searchType,
            Model model) throws Exception {
		log.info("scheduleList() 실행...!");


        // currentPage가 넘어오지 않았을 경우 기본값 1을 설정
        if (pagingVO.getCurrentPage() == 0) {
            pagingVO.setCurrentPage(1);
        }

     // 검색 파라미터 설정 (null일 경우 빈 문자열로 초기화)
        if (searchWord != null && !searchWord.trim().isEmpty()) {
            pagingVO.setSearchWord(searchWord);
        } else {
            pagingVO.setSearchWord(""); // 기본값 설정
        }
        if (searchType != null && !searchType.trim().isEmpty()) {
            pagingVO.setSearchType(searchType);
        } else {
            pagingVO.setSearchType(""); // 기본값 설정
        }

        Map<String, Object> params = new HashMap<>();
        params.put("pagingVO", pagingVO);
        params.put("statusFilter", statusFilter);

        // 상태별 건수 조회
        Map<String, Integer> statusCounts = concertService.selectConcertCountsByStatus();
        model.addAttribute("statusCounts", statusCounts);

        // 전체 건수 조회
		int totalCount = concertService.selectConcertCount(pagingVO);
		model.addAttribute("totalCount", totalCount);

        // statusFilter용 데이터조회 리스트
        List<ConcertVO> dataList;
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            dataList = concertService.selectConcertListWithStatusFilter(pagingVO, statusFilter);
        } else {
            dataList = concertService.selectConcertList(pagingVO);
        }

		try {
			log.debug("서비스 호출 전 pagingVO: {}", pagingVO);
			// 현재 페이지 전달 후, start/endRow, start/endPage 설정
			int totalRecord;
			if(statusFilter != null && !statusFilter.trim().isEmpty()) {
				totalRecord = concertService.selectConcertCountWithStatusFilter(pagingVO, statusFilter);
			} else {
				totalRecord = concertService.selectConcertCount(pagingVO);
			}
			pagingVO.setTotalRecord(totalRecord);

			if(dataList == null) {
				dataList = new ArrayList<>();
			}

			pagingVO.setDataList(dataList);

			log.debug("PagingVO 결과: totalRecord={}, totalPage={}, dataList size={}",
	                pagingVO.getTotalRecord(), pagingVO.getTotalPage(), (dataList != null ? dataList.size() : 0));
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMessage", "콘서트 목록을 불러오는 중 오류가 발생했습니다!!");
		}

		model.addAttribute("pagingVO", pagingVO);
		return "emp/concert/schedule/list";
	}

	/**
	 * @param concertNo
	 * @param model
	 * @param ra
	 * @return 콘서트 상세보기 페이지
	 */
	@GetMapping("/detail/{concertNo}")
	public String scheduleDetail(@PathVariable int concertNo, Model model, RedirectAttributes ra,
			@RequestParam(name = "searchType", required = false) String searchType,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage) {
		log.info("scheduleDetail() 실행...! concertNo: {}, searchType: {}, searchWord: {}, page: {}", concertNo, searchType, searchWord, currentPage);

		try {
			ConcertVO concertVO = concertService.selectSchedule(concertNo);
			if(concertVO == null) {
				ra.addFlashAttribute("errorMessage", "해당되는 콘서트 정보 없음");
				addSearchParamsToRedirectAttributes(ra, searchType, searchWord, currentPage);
				return "redirect:/emp/concert/schedule/list";
			}

			Map<String, Object> seatStatus = concertService.getSeatStatus(concertNo);

			model.addAttribute("seatStatus", seatStatus);
			model.addAttribute("concertVO", concertVO);

			model.addAttribute("searchType", searchType);
			model.addAttribute("searchWord", searchWord);
			model.addAttribute("currentPage", currentPage);

		} catch (Exception e) {
			e.printStackTrace();
			ra.addFlashAttribute("errorMessage", "콘서트 일정 정보 불러오는중 오류 발생");
			addSearchParamsToRedirectAttributes(ra, searchType, searchWord, currentPage);
			return "redirect:/emp/concert/schedule/list";
		}
		return "emp/concert/schedule/detail";
	}


	/**
	 * @param model
	 * @return 콘서트 등록 페이지
	 */
	@GetMapping("/form")
	public String scheduleRegisterForm(Model model,
			@RequestParam(name = "searchType", required = false) String searchType,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage) {

		log.info("scheduleRegisterForm() 실행...!");

		List<ArtistGroupVO> artistGroups = artistGroupService.selectAllArtistGroups();
		model.addAttribute("artistGroups", artistGroups);

		model.addAttribute("concertVO", new ConcertVO());

		model.addAttribute("searchType", searchType);
		model.addAttribute("searchWord", searchWord);
		model.addAttribute("currentPage", currentPage);

		return "emp/concert/schedule/form";
	}


	/**
	 * @param concertVO
	 * @param ra
	 * @param model
	 * @return 콘서트 일정 등록 처리
	 */
	@PostMapping("/insert")
	public String scheduleInsert(
			@ModelAttribute ConcertVO concertVO,
			RedirectAttributes ra,
			Model model,
			@RequestParam(name = "searchType", required = false) String searchType,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
			) {

		String currentEmployee = getCurrentEmpUsername();

		log.info("scheduleInsert() 실행...!");
		String goPage = "";
		// 유효성검사
		if(StringUtils.isBlank(concertVO.getConcertNm())) {
			model.addAttribute("errorMessage", "콘서트 제목을 입력해주세요!!");
			model.addAttribute("concertVO", concertVO);
			model.addAttribute("searchType", searchType);
            model.addAttribute("searchWord", searchWord);
            model.addAttribute("currentPage", currentPage);
			return "emp/concert/schedule/form";
		}

		if (concertVO.getArtGroupNo() <= 0) {
            model.addAttribute("errorMessage", "아티스트 그룹을 선택해주세요!!");
            model.addAttribute("concertVO", concertVO);

            List<ArtistGroupVO> artistGroups = artistGroupService.selectAllArtistGroups();
            model.addAttribute("artistGroups", artistGroups);
            return "emp/concert/schedule/form";
        }

		try {
			ServiceResult result = concertService.insertSchedule(concertVO, currentEmployee);

			if(result.equals(ServiceResult.OK) && concertVO.getConcertNo() > 0) {
				ra.addFlashAttribute("successMessage", "콘서트 일정 등록 성공!!");
				addSearchParamsToRedirectAttributes(ra, searchType, searchWord, currentPage);
			    goPage = "redirect:/emp/concert/schedule/detail/" + concertVO.getConcertNo();
			    log.info("등록 후 리다이렉트 URL : {}", goPage);


			} else {
				model.addAttribute("errorMessage", "콘서트 일정 등록 실패!!");
				model.addAttribute("concertVO", concertVO);
				model.addAttribute("searchType", searchType);
				model.addAttribute("searchWord", searchWord);
				model.addAttribute("currentPage", currentPage);
				goPage = "emp/concert/schedule/form";
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMessage", "시스템오류, 콘서트 일정 등록 실패!!");
			model.addAttribute("concertVO", concertVO);
			goPage = "emp/concert/schedule/form";
		}

		return goPage;
	}


	/**
	 * @param concertNo
	 * @param model
	 * @param ra
	 * @return 콘서트 일정 수정 폼
	 */
	@GetMapping("/mod/{concertNo}")
	public String scheduleModForm(@PathVariable int concertNo, Model model, RedirectAttributes ra,
			@RequestParam(name = "searchType", required = false) String searchType,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage) {
		log.info("scheduleModForm() 실행...!");



		try {
			ConcertVO concertVO = concertService.selectSchedule(concertNo);
			if(concertVO == null) {
				ra.addFlashAttribute("errorMessage", "수정할 콘서트 일정 찾을수 없음");
				return "redirect:/emp/concert/schedule/list";
			}

			model.addAttribute("concertVO", concertVO);
			model.addAttribute("searchType", searchType);
            model.addAttribute("searchWord", searchWord);
            model.addAttribute("currentPage", currentPage);

		} catch (Exception e) {
			e.printStackTrace();
			ra.addFlashAttribute("errorMessage", "콘서트 일정 불러오는중 오류발생");
			return "redirect:/emp/concert/schedule/list";
		}

		return "emp/concert/schedule/mod";
	}

	/**
	 * @param concertNo
	 * @param concertVO
	 * @param ra
	 * @param model
	 * @return 콘서트 일정 수정 처리
	 */
	@PostMapping("/mod/{concertNo}")
	public String scheduleMod(
			@PathVariable int concertNo,
			@ModelAttribute ConcertVO concertVO,
			RedirectAttributes ra,
			Model model,
			@RequestParam(name = "searchType", required = false) String searchType,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
			) {
		log.info("scheduleMod() 실행...!");
		String goPage = "";

		concertVO.setConcertNo(concertNo);

		if (concertVO.getArtGroupNo() <= 0) {
	        model.addAttribute("errorMessage", "아티스트 그룹 정보가 유효하지 않습니다. 다시 시도해주세요.");
	        model.addAttribute("concertVO", concertVO); // 기존 데이터 유지를 위해 다시 모델에 추가
	        // artistGroups도 다시 모델에 추가하여 드롭다운 노ㅓ출
	        List<ArtistGroupVO> artistGroups = artistGroupService.selectAllArtistGroups();
	        model.addAttribute("artistGroups", artistGroups);
	        model.addAttribute("searchType", searchType);
	        model.addAttribute("searchWord", searchWord);
	        model.addAttribute("currentPage", currentPage);
	        return "emp/concert/schedule/mod";
	    }

		if(StringUtils.isBlank(concertVO.getConcertNm())) {
			model.addAttribute("errorMessage", "콘서트 제목을 입력해주세요!!");
			model.addAttribute("concertVO", concertVO);
			model.addAttribute("searchType", searchType);
            model.addAttribute("searchWord", searchWord);
            model.addAttribute("currentPage", currentPage);
			return "emp/concert/schedule/mod";
		}


		try {
			ServiceResult result = concertService.updateSchedule(concertVO);
			if(result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("successMessage", "콘서트 일정 수정 성공!!");
				addSearchParamsToRedirectAttributes(ra, searchType, searchWord, currentPage);
				goPage = "redirect:/emp/concert/schedule/detail/" + concertNo;
			} else {
				ra.addFlashAttribute("errorMessage", "콘서트 일정 수정 실패!!");
				model.addAttribute("concertVO", concertVO);
				model.addAttribute("searchType", searchType);
	            model.addAttribute("searchWord", searchWord);
	            model.addAttribute("currentPage", currentPage);
				goPage = "emp/concert/schedule/mod";
			}

		} catch (Exception e) {
			e.printStackTrace();
			ra.addFlashAttribute("errorMessage", "시스템오류, 콘서트 일정 수정 실패!!");
			model.addAttribute("concertVO", concertVO);
			goPage = "emp/concert/schedule/mod";
		}
		return goPage;
	}

	/**
	 * @param concertNo
	 * @param ra
	 * @return 콘서트 일정 삭제 처리 -> 콘서트 일정 목록 페이지
	 */
	@PostMapping("/delete/{concertNo}")
	public String scheduleDelete(@PathVariable int concertNo, RedirectAttributes ra,
			@RequestParam(name = "searchType", required = false) String searchType,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage) {
		log.info("scheduleDelete() 실행...!");

		try {
			ServiceResult result = concertService.deleteSchedule(concertNo);
			if(result.equals(ServiceResult.OK)) {
				ra.addFlashAttribute("successMessage", "콘서트 일정 삭제 성공!!");
			} else {
				ra.addFlashAttribute("errorMessage", "콘서트 일정 삭제 실패!!");
			}

		} catch (Exception e) {
			e.printStackTrace();
			ra.addFlashAttribute("errorMessage", "시스템오류, 콘서트 일정 삭제 실패!!");
		}
		addSearchParamsToRedirectAttributes(ra, searchType, searchWord, currentPage);
		return "redirect:/emp/concert/schedule/list";
	}

	@ResponseBody
	@GetMapping("/status/{concertNo}")
	public Map<String, Object> getConcertStatus(@PathVariable int concertNo){
		log.info("getConcertStatus() 실행...! 콘서트 번호: {}", concertNo);

		return concertService.getSeatStatus(concertNo);
	}

	@GetMapping("/dailyStatus/{concertNo}")
	@ResponseBody
	public List<Map<String, Object>> getDailyStatus(
		@PathVariable int concertNo,
		@RequestParam(required = false) String startDate,
		@RequestParam(required = false) String endDate
	) {
		log.info("getDailyStatus() 실행...! 콘서트 번호: {}, startDate: {}, endDate: {}", concertNo, startDate, endDate);

		// startDate, endDate는 없으면 콘서트 기간으로 자동 세팅
		if (startDate == null || endDate == null) {
			try {
				ConcertVO concert = concertService.selectSchedule(concertNo);
				if (concert != null) {
					// Date를 LocalDate로 변환하여 날짜만 추출
					java.time.LocalDate startLocalDate = concert.getConcertStartDate().toInstant()
						.atZone(java.time.ZoneId.systemDefault()).toLocalDate();
					java.time.LocalDate endLocalDate = concert.getConcertEndDate().toInstant()
						.atZone(java.time.ZoneId.systemDefault()).toLocalDate();

					startDate = startLocalDate.toString();
					endDate = endLocalDate.toString();

					log.info("콘서트 기간으로 설정: {} ~ {}", startDate, endDate);
				} else {
					log.warn("콘서트 정보를 찾을 수 없음: {}", concertNo);
					// 기본값 설정
					startDate = java.time.LocalDate.now().minusDays(30).toString();
					endDate = java.time.LocalDate.now().toString();
					log.info("기본 기간으로 설정: {} ~ {}", startDate, endDate);
				}
			} catch (Exception e) {
				log.error("콘서트 정보 조회 중 오류 발생: {}", e.getMessage());
				// 기본값 설정
				startDate = java.time.LocalDate.now().minusDays(30).toString();
				endDate = java.time.LocalDate.now().toString();
				log.info("오류로 인한 기본 기간 설정: {} ~ {}", startDate, endDate);
			}
		}

		List<Map<String, Object>> result = concertService.getDailyTicketStats(concertNo, startDate, endDate);
		log.info("조회 결과: {}건", result != null ? result.size() : 0);
		return result;
	}

	// 등급/구역별 확장
	@GetMapping("/dailyStatusByGradeSection/{concertNo}")
	@ResponseBody
	public List<Map<String, Object>> getDailyStatusByGradeSection(
		@PathVariable int concertNo,
		@RequestParam(required = false) String startDate,
		@RequestParam(required = false) String endDate
	) {
		if (startDate == null || endDate == null) {
			try {
				ConcertVO concert = concertService.selectSchedule(concertNo);
				if (concert != null) {
					// Date를 LocalDate로 변환하여 날짜만 추출
					java.time.LocalDate startLocalDate = concert.getConcertStartDate().toInstant()
						.atZone(java.time.ZoneId.systemDefault()).toLocalDate();
					java.time.LocalDate endLocalDate = concert.getConcertEndDate().toInstant()
						.atZone(java.time.ZoneId.systemDefault()).toLocalDate();

					startDate = startLocalDate.toString();
					endDate = endLocalDate.toString();
				}
			} catch (Exception e) {
				log.error("콘서트 정보 조회 중 오류 발생: {}", e.getMessage());
				// 기본값 설정
				startDate = java.time.LocalDate.now().minusDays(30).toString();
				endDate = java.time.LocalDate.now().toString();
			}
		}
		return concertService.getDailyTicketStatsByGradeSection(concertNo, startDate, endDate);
	}

	@GetMapping("/dailySeatStatus/{concertNo}")
	@ResponseBody
	public List<Map<String, Object>> getDailySeatStatus(@PathVariable int concertNo) throws Exception {
		ConcertVO concert = concertService.selectSchedule(concertNo);
		if (concert == null) {
			return new ArrayList<>();
		}
		java.time.LocalDate startDate = concert.getConcertStartDate().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate();
		java.time.LocalDate endDate = concert.getConcertEndDate().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate();
		int totalSeats = concertService.getSeatStatus(concertNo).get("totalSeats") != null ? (int)concertService.getSeatStatus(concertNo).get("totalSeats") : 0;
		List<Map<String, Object>> dailyList = concertService.getDailyReservedSeats(concertNo, startDate.toString(), endDate.toString());
		List<Map<String, Object>> salesList = concertService.getDailyTicketStats(concertNo, startDate.toString(), endDate.toString());
		Map<String, Integer> salesMap = new HashMap<>();
		for (Map<String, Object> s : salesList) {
			salesMap.put((String)s.get("DAY"), ((Number)s.get("TOTAL_SALES")).intValue());
		}
		List<Map<String, Object>> result = new ArrayList<>();
		int lastReserved = 0;
		for (java.time.LocalDate d = startDate; !d.isAfter(endDate); d = d.plusDays(1)) {
			String dayStr = d.toString();
			Map<String, Object> found = dailyList.stream().filter(m -> dayStr.equals(m.get("DAY"))).findFirst().orElse(null);
			int reserved = found != null ? ((Number)found.get("RESERVED_SEATS")).intValue() : lastReserved;
			int todayReserved = reserved - lastReserved;
			int todaySales = salesMap.getOrDefault(dayStr, 0);
			Map<String, Object> row = new HashMap<>();
			row.put("day", dayStr);
			row.put("reservedSeats", reserved);
			row.put("todayReserved", todayReserved < 0 ? 0 : todayReserved);
			row.put("remainSeats", totalSeats - reserved);
			row.put("totalSeats", totalSeats);
			row.put("todaySales", todaySales);
			result.add(row);
			lastReserved = reserved;
		}
		return result;
	}

	private void addSearchParamsToRedirectAttributes(RedirectAttributes ra, String searchType, String searchWord,
			int currentPage) {
		if (StringUtils.isNotBlank(searchType)) {
            ra.addAttribute("searchType", searchType);
        }
        if (StringUtils.isNotBlank(searchWord)) {
            ra.addAttribute("searchWord", searchWord);
        }
        if (currentPage > 1) { // 1페이지는 기본값이므로 굳이 안넘겨도 됨
            ra.addAttribute("currentPage", currentPage);
        }

	}
}
