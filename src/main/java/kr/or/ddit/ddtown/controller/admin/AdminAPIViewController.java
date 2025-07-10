package kr.or.ddit.ddtown.controller.admin;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

import kr.or.ddit.ddtown.service.stat.IStatService;
import kr.or.ddit.vo.concert.ConcertVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/stat")
public class AdminAPIViewController {

	@Autowired
	private IStatService statService;

	/**
	 * 일간 주간 월별 신규 가입자 및 가장 많이 구매한 사용자 데이터 가져오기
	 * @param searchType
	 * @return
	 */
	@GetMapping("/getUserStatData")
	public ResponseEntity<Map<String, Object>> getUserStatData(@RequestParam String searchType){
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> jsonMap =  new HashMap<>();
		Gson gson = new Gson();
		String signupJsonData;
		String mostBuyJsonData;
		try {
			List<Map<String, Object>> signUpData = statService.getUserSignupData(searchType);
			signupJsonData = gson.toJson(signUpData);

			List<Map<String, Object>> mostBuyUserData = statService.getMostBuyUserData(searchType);
			mostBuyJsonData = gson.toJson(mostBuyUserData);

			jsonMap.put("signup", signupJsonData);
			jsonMap.put("mostBuy", mostBuyJsonData);

			entity = new ResponseEntity<>(jsonMap,HttpStatus.OK);
		} catch (Exception e) {
			log.error(e.getMessage());
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}

	@GetMapping("/getRevenueBySector")
	public ResponseEntity<Map<String, Object>> getRevenueBySector(@RequestParam String searchType){
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> jsonMap =  new HashMap<>();
		Gson gson = new Gson();
		String revenueJsonData;
		try {
			List<Map<String, Object>> revenueData = statService.getRevenueBySector(searchType);
			revenueJsonData = gson.toJson(revenueData);


			jsonMap.put("revenue", revenueJsonData);

			entity = new ResponseEntity<>(jsonMap,HttpStatus.OK);
		} catch (Exception e) {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}

	@GetMapping("/getSaleRevenue")
	public ResponseEntity<Map<String, Object>> getSaleRevenue(@RequestParam String searchType){
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> jsonMap =  new HashMap<>();
		Gson gson = new Gson();
		String revenueJsonData;
		String saleJsonData;
		try {
			List<Map<String, Object>> revenueData = statService.getSaleRevenue(searchType);
			revenueJsonData = gson.toJson(revenueData);

			List<Map<String, Object>> topSaleGoods = statService.getTopSaleGoods(searchType);
			saleJsonData = gson.toJson(topSaleGoods);

			jsonMap.put("saleJson", saleJsonData);
			jsonMap.put("revenueJson", revenueJsonData);

			entity = new ResponseEntity<>(jsonMap,HttpStatus.OK);
		} catch (Exception e) {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}

	@GetMapping("/getCommunityPostsChart")
	public ResponseEntity<Map<String, Object>> getCommunityPostsChart(){
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> jsonMap =  new HashMap<>();
		Gson gson = new Gson();
		String communityJsonData;
		try {
			List<Map<String, Object>> communityData = statService.getCommunityPostsData();
			Map<String, Object> lastestData = communityData.get(communityData.size()-1);
			Map<String, Object> oneMonthagoData = communityData.get(communityData.size()-2);

			log.info("lastestData : {}", lastestData);
			log.info("oneMonthagoData : {}", oneMonthagoData);
			BigDecimal thisMonthCount = (BigDecimal) lastestData.get("COUNT");
			BigDecimal oneMonthagoCount = (BigDecimal) oneMonthagoData.get("COUNT");
			log.info("thisMonthCount : {}", thisMonthCount);
			log.info("oneMonthagoCount : {}", oneMonthagoCount);

			String upPercent = "";
			if(thisMonthCount.intValue() > oneMonthagoCount.intValue()) {
				upPercent = "▲" + (int)(Math.abs(Math.round((thisMonthCount.intValue() - oneMonthagoCount.intValue()) / oneMonthagoCount.doubleValue() * 100))) + "%";
			}else {
				upPercent = "▼" + (int)(Math.abs(Math.round((thisMonthCount.intValue() - oneMonthagoCount.intValue()) / oneMonthagoCount.doubleValue() * 100))) + "%";
			}
			log.info("upPercent : {}", upPercent);

			communityJsonData = gson.toJson(communityData);
			jsonMap.put("thisMonthCount", thisMonthCount);
			jsonMap.put("upPercent", upPercent);
			jsonMap.put("postJsonData", communityJsonData);

			entity = new ResponseEntity<>(jsonMap,HttpStatus.OK);
		} catch (Exception e) {
			log.error(e.getMessage());
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;

	}

	@GetMapping("/membershipTotalData")
	public ResponseEntity<Map<String, Object>> membershipTotalData(){
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> jsonMap =  new HashMap<>();
		Gson gson = new Gson();
		String membershipJsonData;
		String recentlyMembershipJsonData;
		try {
			List<Map<String, Object>> membershipData = statService.getMembershipTotalData();
			membershipJsonData = gson.toJson(membershipData);
			List<Map<String, Object>> recentlyMembershipData = statService.getMembershipRecentlyData();
			recentlyMembershipJsonData = gson.toJson(recentlyMembershipData);

			jsonMap.put("recentlyMembershipJsonData", recentlyMembershipJsonData);
			jsonMap.put("membershipJsonData", membershipJsonData);

			entity = new ResponseEntity<>(jsonMap,HttpStatus.OK);
		} catch (Exception e) {
			log.error(e.getMessage());
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}

	@GetMapping("/getConcertDdayChart")
	public ResponseEntity<Map<String, Object>> getConcertDdayChart(){
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> jsonMap =  new HashMap<>();
		Gson gson = new Gson();
		String concertJsonData;
		try {
			List<ConcertVO> concertData = statService.getConcertDdayData();
			concertJsonData = gson.toJson(concertData);

			jsonMap.put("concertJsonData", concertJsonData);

			entity = new ResponseEntity<>(jsonMap,HttpStatus.OK);
		} catch (Exception e) {
			log.error(e.getMessage());
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}

	@GetMapping("/getAuditionChart")
	public ResponseEntity<Map<String, Object>> getAuditionChart(){
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> jsonMap =  new HashMap<>();
		Gson gson = new Gson();
		String auditionJsonData;
		try {
			List<Map<String, Object>> auditionData = statService.getAuditionData();
			auditionJsonData = gson.toJson(auditionData);

			jsonMap.put("auditionJsonData", auditionJsonData);

			entity = new ResponseEntity<>(jsonMap,HttpStatus.OK);
		} catch (Exception e) {
			log.error(e.getMessage());
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}

	@GetMapping("/getConcertRevChart")
	public ResponseEntity<Map<String, Object>> getConcertRevChart(){
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> jsonMap =  new HashMap<>();
		Gson gson = new Gson();
		String concertRevJsonData;
		String concertRevSaleJsonData;
		try {
			List<Map<String, Object>> concertRevData = statService.getConcertRevChart();
			concertRevJsonData = gson.toJson(concertRevData);
			List<Map<String, Object>> concertRevSaleData = statService.getconcertRevSaleData();
			concertRevSaleJsonData = gson.toJson(concertRevSaleData);
			log.info("concertRevSaleJsonData : {}", concertRevSaleJsonData);
			jsonMap.put("concertRevJsonData", concertRevJsonData);
			jsonMap.put("concertRevSaleJsonData", concertRevSaleJsonData);

			entity = new ResponseEntity<>(jsonMap,HttpStatus.OK);
		} catch (Exception e) {
			log.error(e.getMessage());
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return entity;
	}
}
