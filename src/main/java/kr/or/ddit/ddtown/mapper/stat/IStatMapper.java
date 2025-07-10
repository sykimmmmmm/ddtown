package kr.or.ddit.ddtown.mapper.stat;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.community.CommunityPostVO;
import kr.or.ddit.vo.concert.ConcertVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.order.OrderCancelVO;

@Mapper
public interface IStatMapper {

	/**
	 * 일간 주간 월간 가입자 수 데이터 가져오기
	 * @param searchType
	 * @return
	 */
	public List<Map<String, Object>> getUserSignupData(String searchType);

	/**
	 * 일간 주간 월간 가장 많이 구매한 사용자
	 * @param searchType
	 * @return
	 */
	public List<Map<String, Object>> getMostBuyUserData(String searchType);

	/**
	 * 전체 굿즈샵 멤버쉽 콘서트 별 구매 통계
	 * @param searchType
	 * @return
	 */
	public List<Map<String, Object>> getRevenueBySector(String searchType);

	/**
	 * 이달의 매출액 주문건수 환불 취소건수
	 * @return
	 */
	public Map<String, Object> getMonthlyGoodsStat();

	/**
	 * 월별 분기별 연별 굿즈상품 판매 통계
	 * @param searchType
	 * @return
	 */
	public List<Map<String, Object>> getSaleRevenue(String searchType);

	/**
	 * 월별 분기별 연별 판매 top 5 굿즈 가져오기
	 * @param searchType
	 * @return
	 */
	public List<Map<String, Object>> getTopSaleGoods(String searchType);

	/**
	 * 환불 및 취소 전체 통계
	 * @return
	 */
	public List<Map<String, Object>> getCancelStat();

	/**
	 * 최근 환불 및 취소내역 5개 가져오기
	 * @return
	 */
	public List<OrderCancelVO> getCancelList();

	/**
	 * 월별 게시글 수 가져오기
	 * @return
	 */
	public List<Map<String, Object>> getCommunityPostsData();

	/**
	 * 멤버쉽 별 회원수
	 * @return
	 */
	public List<Map<String, Object>> getMembershipTotalData();

	/**
	 * 콘서트 예정날짜 가져오기
	 * @return
	 */
	public List<ConcertVO> getConcertDdayData();

	/**
	 * 진행중인 오디션별 지원자 수 가져오기
	 * @return
	 */
	public List<Map<String, Object>> getAuditionData();

	/**
	 * 지난 6개월간 콘서트 가져오기
	 * @return
	 */
	public List<Map<String, Object>> getConcertRevChart();

	/**
	 * 아티스트 상세페이지 가장 많이 팔린 굿즈 top3 가져오기
	 * @param artNo
	 * @return
	 */
	public List<goodsVO> getMemberGoodsStat(int artNo);

	/**
	 * 아티스트 상세페이지 좋아요 많이 받은 인기 게시글 3개 가져오기
	 * @param artNo
	 * @return
	 */
	public List<CommunityPostVO> getMostLikePostSate(int artNo);

	/**
	 * 아티스트 그룹 상세 총 구독현황 이달의 구독 현황가져오기
	 * @param artGroupNo
	 * @return
	 */
	public List<Map<String, Object>> getMembershipStat(int artGroupNo);

	/**
	 * 그룹 상세 가장 많이 팔린 굿즈 가져오기
	 * @param artGroupNo
	 * @return
	 */
	public List<goodsVO> getMemberGoodsStatByGroup(int artGroupNo);

	/**
	 * 이달 가입한 멤버쉽 별 가입자수
	 * @return
	 */
	public List<Map<String, Object>> getMembershipRecentlyData();

	/**
	 * 지난 6개월 간 각 달에 콘서트별 매출 현황
	 * @return
	 */
	public List<Map<String, Object>> getconcertRevSaleData();


}
