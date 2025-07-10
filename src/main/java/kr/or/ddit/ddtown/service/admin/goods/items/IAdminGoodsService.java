package kr.or.ddit.ddtown.service.admin.goods.items;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.goods.goodsVO;


public interface IAdminGoodsService {

	public ServiceResult itemsRegister(goodsVO goodsVO) throws Exception;

	public List<ArtistGroupVO> getArtistGroupsForForm();

	public ServiceResult updateGoodsItem(goodsVO goods) throws Exception;

	public ServiceResult deleteGoodsItems(int goodsNo);

	public void retrieveGoodsList(PaginationInfoVO<goodsVO> PaginationInfoVO);

	public List<Map<String, Object>> getGoodsStatusCounts();

	public int getTotalGoodsCount();

	public List<Map<String, Object>> getGoodsStockCounts();

}
