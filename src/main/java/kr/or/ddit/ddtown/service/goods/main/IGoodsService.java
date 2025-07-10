package kr.or.ddit.ddtown.service.goods.main;

import java.util.List;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.goods.goodsOptionVO;
import kr.or.ddit.vo.goods.goodsStockVO;
import kr.or.ddit.vo.goods.goodsVO;

public interface IGoodsService {

	public List<goodsVO> goodsList();

	public goodsVO getGoodsDetail(int goodsNo) throws Exception;

	public List<goodsOptionVO> optionList(int goodsNo);

	public List<goodsVO> getgoodsStatus();

	public List<goodsStockVO> getgoodsTotalStock();

	public void retrieveGoodsList(PaginationInfoVO<goodsVO> pagingVO);

	/**
     * 사용자 굿즈샵을 위한 상품 목록 및 페이지네이션 정보 조회
     * @param pagingVO 페이지네이션 정보를 담은 VO (currentPage, searchWord, searchType 등이 포함될 수 있음)
     */
    public void retrieveUserGoodsList(PaginationInfoVO<goodsVO> pagingVO);

	public List<ArtistGroupVO> getArtistGroups();

	public goodsOptionVO getGoodsOption(int goodsOptNo);

	// 베스트 아이템 가져오는 메서드 - 건우
	public List<goodsVO> getBestSellingGoods(int i);

}
