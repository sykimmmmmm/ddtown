package kr.or.ddit.ddtown.service.goods.wishlist;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ddtown.mapper.goods.IWishlistMapper;
import kr.or.ddit.ddtown.service.goods.main.IGoodsService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.goods.GoodsWishListVO;
import kr.or.ddit.vo.goods.goodsVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class WishlistServiceImpl implements IWishlistService {

	@Autowired
	private IWishlistMapper wishlistMapper;

	@Autowired
	private IGoodsService goodsService;

	/*
	 * 특정 상품이 특정 회원 찜 목록에 있느니
	 * @param username 회원 아이디
	 * @param goodsNo 상품 번호
	 * @return 찜 목록에 있으면 true, 없으면 false
	 */
	@Override
	public boolean isGoodsWished(String username, Integer goodsNo) {
		log.info("isGoodsWished() 서비스 호출!! 회원ID =" + username + ", 상품 번호 =" + goodsNo);

		try {
			return  wishlistMapper.checkWishlist(username, goodsNo) > 0;
		} catch (Exception e) {
			log.error("찜 여부 확인 중 오류 발생: " + e.getMessage(), e);
			//오류 발생 시에 false 반환하여 찜 돼 있지 않다고 처리!
			return false;
		}
	}

	/*
	 * 특정 상품을 회원의 찜 목록에서 제거
	 * @param username 회원 아이디
	 * @param goodsNo 상품 번호
	 * @return 찜 삭제 성공 시 true, 실패 시 false
	 */
	@Transactional
	@Override
	public boolean removeWishlist(String username, Integer goodsNo) {
		log.info("removeWishlist() 서비스 호출!! 회원ID = " + username + ", 상품 번호 = " + goodsNo);

		try {
			wishlistMapper.deleteWishlist(username, goodsNo);
			log.info("찜 삭제 성공!! 회원ID=" + username + ", 상품 번호 = " + goodsNo);
			return true; //삭제 성공
		} catch (Exception e) {
			log.error("찜 삭제 중 오류 발생: " + e.getMessage(), e);
			//오류 발생 시 false 반환
			return false;
		}
	}
	/*
	 * 특정 상품 회원의 찜 목록에 추가
	 * @param username 회원 아이디
	 * @param goodsNo 상품 번호
	 * @return 찜 추가 성공 시 true, 실패 시 false
	 */
	@Transactional
	@Override
	public boolean addWishlist(String username, Integer goodsNo) {
		log.info("addWishlist() 서비스 호출: 회원ID = " + username + ", 상품 번호 = " + goodsNo);

		try {
			// 해당 상품이 이미 찜 돼 있는지 확인 (중복 추가 방지)
			if(wishlistMapper.checkWishlist(username, goodsNo) > 0) {
				log.info("이미 찜된 상품입니다! 추가 작업을 건너 뜀: 회원 ID = " + username + ", 상품 번호 =" + goodsNo);

				return false; //이미 찜 돼 있으면 추가하지 않고 건너 false 반환
			}

			//찜 VO 객체를 생성하고 데이터를 설정!
			GoodsWishListVO wishlist = new GoodsWishListVO();
			wishlist.setMemUsername(username);
			wishlist.setGoodsNo(goodsNo);

			// 찜 정보 삽입
			wishlistMapper.insertWishlist(wishlist);
			log.info("찜 추가 성공!! 회원 ID = " + username + ", 상품 번호 = " + goodsNo);

			return true;

		} catch (Exception e) {
			log.error("찜 추가 중 오류 발생!! " + e.getMessage(), e);
			return false;
		}
	}

	@Override
	public Collection<goodsVO> getWishlistForUser(String username) {
		log.info("getWishlistForUser() 서비스 호출!!! 회원ID = " + username);

		List<goodsVO> wishedGoodsList = new ArrayList<>(); //최종 반환할 상품 상세 정보 리스트!

		try {
			List<GoodsWishListVO> userWishlist = wishlistMapper.getWishlistByUsername(username);

			//2. 찜 목록이 비어있지 않다면! 각 찜 항목의 goodsNo를 사용하여 상품 상세 정보를 가져옴!
			if (userWishlist != null && !userWishlist.isEmpty()) {
				for(GoodsWishListVO wishItem : userWishlist) {
					int goodsNo = wishItem.getGoodsNo();

					goodsVO goodsDetail = goodsService.getGoodsDetail(goodsNo);

					if (goodsDetail != null) {
						wishedGoodsList.add(goodsDetail);
						log.debug("찜 상품 상세 정보 로드 성공!! 상품 정보 {}", goodsNo);
					} else {
						log.warn("찜 목록에서 상품 번호 {}에 해당하는 상세 정보를 찾을 수 없어요!!", goodsNo);
					}
				}
			}

			log.info("찜 목록 조회 완료! 회원ID = " + username + ", 조회된 상품 개수 = " + wishedGoodsList.size());

			return wishedGoodsList;

		} catch (Exception e) {
			log.error("찜 목록 조회 중 오류 발생!!!: " + e.getMessage(), e);
			//오류 발생 시 빈 리스트 반환!
			return new ArrayList<>();

		}
	}

	@Override
	public List<goodsVO> getWishedGoodsPagingListForUser(String username, PaginationInfoVO<goodsVO> pagingVO) {
	    log.info("getWishedGoodsPagingListForUser() 서비스 호출!! 회원ID = " + username);

	    try {
	        // 1. 전체 찜 상품 개수 조회
	        int totalCount = wishlistMapper.selectTotalWishedGoodsCount(username);
	        pagingVO.setTotalRecord(totalCount);

	        pagingVO.setTotalRecord(totalCount);

	        pagingVO.applyWishlistPagination();

	        List<goodsVO> wishedGoodsList;
	        if (totalCount > 0) {
	            wishedGoodsList = wishlistMapper.selectWishedGoodsPagingList(username, pagingVO);
	        } else {
	            wishedGoodsList = new ArrayList<>();
	        }

	        pagingVO.setDataList(wishedGoodsList);

	        log.info("페이징된 찜 목록 조회 완료! 회원ID = {}, 총 상품 개수 = {}, 현재 페이지 상품 개수 = {}",
	                username, totalCount, wishedGoodsList.size());

	        return wishedGoodsList;
	    } catch (Exception e) {
	        log.error("페이징된 찜 목록 조회 중 오류 발생!!!: " + e.getMessage(), e);
	        return new ArrayList<>();
	    }
	}
}
