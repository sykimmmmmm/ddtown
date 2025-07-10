package kr.or.ddit.ddtown.service.goods.wishlist;

import java.util.Collection;
import java.util.List;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.goods.goodsVO;

public interface IWishlistService {

	//위시리스트에 있는지 확인하기!
	public boolean isGoodsWished(String username, Integer goodsNo);

	//위시리스트 해제하기!
	public boolean removeWishlist(String username, Integer goodsNo);

	//위시리스트 추가하기!
	public boolean addWishlist(String username, Integer goodsNo);

	//사용자별 위시리스트 가져오기!
	public Collection<goodsVO> getWishlistForUser(String username);

	public List<goodsVO> getWishedGoodsPagingListForUser(String username, PaginationInfoVO<goodsVO> pagingVO);

}
