package kr.or.ddit.ddtown.mapper.goods;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.goods.goodsOptionVO;
import kr.or.ddit.vo.goods.goodsStockVO;
import kr.or.ddit.vo.goods.goodsVO;

@Mapper
public interface IGoodsMapper {

	//굿즈 목록 불러오기
	public List<goodsVO> goodsList();

	//굿즈 개별 상세 정보 가져오기
	public goodsVO getGoodsDetail(int goodsNo);

	//굿즈 옵션 목록 불러오기
	public List<goodsOptionVO> optionList(int goodsNo);

	//굿즈 판매 상태 가져오기
	public List<goodsVO> getgoodsStatus();

	//굿즈 총 수량 목록 가져오기
	public List<goodsStockVO> getgoodsTotalStock();

	//굿즈 상품 등록하기
	public int itemsRegister(goodsVO goodsVO);

	//굿즈 옵션 등록하기
	public int insertGoodsOption(goodsOptionVO option);

	//굿즈 옵션 재고 수량 넣기
	public int insertGoodsStock(goodsStockVO stock);

	//굿즈 상품 등록 시에 필요한 아티스트 그룹 가져오기
	public List<ArtistGroupVO> selectAllArtistGroups();

	//시퀀스로 다음 굿즈 넘버 가져오기
	public int selectNextGoodsNo();

	//굿즈 개별 총 수량 가져오기
	public Integer selectTotalStockForGoods(int goodsNo);

	//------------------수정 관련 메소드 시작-----------------------------
	//굿즈 상품 수정하기
	public int updateGoodsItem(goodsVO goodsVO);

	//상품 옵션 해당 재고 먼저 삭제하기
	public void deleteStockForOption(Integer goodsOptNoToDelete);

	//상품 옵션 삭제하기
	public void deleteGoodsOption(Integer goodsOptNoToDelete);

	//상품 옵션 수정하기
	public void updateGoodsOption(goodsOptionVO option);

	//새롭게 추가할 기본 상품 재고 삭제 (상품 번호와 goods_opt_no=0 기준으로 삭제)
	public void deleteBaseStockForGoods(@Param("goodsNo") Integer goodsNo, @Param("goodsOptNo") Integer goodsOptNo);

	//특정 상품 모든 옵션 재고 삭제
	public void deleteAllOptionsStockForGoods(int goodsNo);

	//특정 상품 모든 옵션 삭제
	public void deleteAllOptionsForGoods(int goodsNo);

	//------------------수정 관련 메소드 끝-----------------------------

	//상품 삭제
	public int deleteGoodsItem(int goodsNo);

	//상품 개별 옵션 가져오기!!
	public goodsOptionVO getOptionDetail(int goodsOptNo);

	//마지막 상품 재고 확인 후 새롭게 변경 상태 코드 저장!
	public void updateGoodsStatus(int goodsNo, String newStatus);

	//상품의 마지막 상태 가져오기!
	public goodsVO getGoodsStatusOnly(int goodsNo);

	/**
     * 특정 상품의 재고 수량을 증가시킵니다.
     * @param goodsNo 상품 번호
     * @param goodsOptNo 상품 옵션 번호 (옵션이 없는 경우 0 또는 특정 기본값)
     * @param orderQty 증가시킬 수량 (취소된 상품 수량)
     * @return 업데이트된 행의 수 (보통 1)
     */
    public int increaseGoodsStock(
        @Param("goodsNo") int goodsNo,
        @Param("goodsOptNo") Integer goodsOptNo,
        @Param("orderQty") int orderQty
    );

    // 베스트 아이템 가져오기 - 건우
	public List<goodsVO> getBestSellingGoods(int i);

}
