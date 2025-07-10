package kr.or.ddit.ddtown.service.stat;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.ddtown.mapper.stat.IStatMapper;
import kr.or.ddit.vo.community.CommunityPostVO;
import kr.or.ddit.vo.concert.ConcertVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.order.OrderCancelVO;

@Service
public class StatServiceImpl implements IStatService {

	@Autowired
	private IStatMapper statMapper;

	/**
	 * 일간 주간 월별 가입자 수 가져오기
	 */
	@Override
	public List<Map<String, Object>> getUserSignupData(String searchType) {
		return statMapper.getUserSignupData(searchType);
	}

	/**
	 *	일간 주간 월별 가장 많이 구매한 사람
	 */
	@Override
	public List<Map<String, Object>> getMostBuyUserData(String searchType) {
		return statMapper.getMostBuyUserData(searchType);
	}

	/**
	 * 전체 굿즈샵 멤버쉽 콘서트 별 수익 통계
	 *
	 */
	@Override
	public List<Map<String, Object>> getRevenueBySector(String searchType) {
		return statMapper.getRevenueBySector(searchType);
	}

	/**
	 * 이달의 매출액 주문건수 환불 취소 건수
	 */
	@Override
	public Map<String, Object> getMonthlyGoodsStat() {
		return statMapper.getMonthlyGoodsStat();
	}

	/**
	 * 월별 분기별 연별 굿즈상품 판매 통계
	 */
	@Override
	public List<Map<String, Object>> getSaleRevenue(String searchType) {
		return statMapper.getSaleRevenue(searchType);
	}

	/**
	 * 월별 분기별 연별 판매 top 5 굿즈 가져오기
	 */
	@Override
	public List<Map<String, Object>> getTopSaleGoods(String searchType) {
		return statMapper.getTopSaleGoods(searchType);
	}

	/**
	 * 환불 취소 전체 통계
	 */
	@Override
	public List<Map<String, Object>> getCancelStat() {
		return statMapper.getCancelStat();
	}

	/**
	 * 최근 환불 및 취소 내역 5개 가져오기
	 */
	@Override
	public List<OrderCancelVO> getCancelList() {
		return statMapper.getCancelList();
	}

	/**
	 * 월별 게시글 수 가져오기
	 */
	@Override
	public List<Map<String, Object>> getCommunityPostsData() {
		return statMapper.getCommunityPostsData();
	}

	/**
	 * 멤버쉽 별 회원 수
	 */
	@Override
	public List<Map<String, Object>> getMembershipTotalData() {
		return statMapper.getMembershipTotalData();
	}

	/**
	 * 콘서트 예정 날짜 가져오기
	 */
	@Override
	public List<ConcertVO> getConcertDdayData() {
		return statMapper.getConcertDdayData();
	}

	/**
	 * 진행중인 오디션 별 지원자 수 가져오기
	 */
	@Override
	public List<Map<String, Object>> getAuditionData() {
		return statMapper.getAuditionData();
	}

	/**
	 * 지난 6개월간 콘서트 매출 가져오기
	 */
	@Override
	public List<Map<String, Object>> getConcertRevChart() {
		return statMapper.getConcertRevChart();
	}

	/**
	 * 아티스트 상세 페이지 가장 많이 팔린 굿즈 top 3 가져오기
	 */
	@Override
	public List<goodsVO> getMemberGoodsStat(int artNo) {
		return statMapper.getMemberGoodsStat(artNo);
	}

	/**
	 * 아티스트 상세페이지 좋아요 많이 받은 인기 게시글 3개 가져오기
	 */
	@Override
	public List<CommunityPostVO> getMostLikePostStat(int artNo) {
		return statMapper.getMostLikePostSate(artNo);
	}

	/**
	 * 아티스트 그룹 상세 총구독 및 이달의 구독 현황 가져오기
	 */
	@Override
	public List<Map<String, Object>> getMembershipStat(int artGroupNo) {
		return statMapper.getMembershipStat(artGroupNo);
	}

	/**
	 * 그룹 상세페이지 가장 많이 팔린 굿즈
	 */
	@Override
	public List<goodsVO> getMemberGoodsStatByGroup(int artGroupNo) {
		return statMapper.getMemberGoodsStatByGroup(artGroupNo);
	}

	/**
	 * 이달 가입한 멤버쉽 별 회원 수
	 */
	@Override
	public List<Map<String, Object>> getMembershipRecentlyData() {
		return statMapper.getMembershipRecentlyData();
	}

	/**
	 * 각 달에 콘서트 별 매출 현황
	 */
	@Override
	public List<Map<String, Object>> getconcertRevSaleData() {
		return statMapper.getconcertRevSaleData();
	}
}
