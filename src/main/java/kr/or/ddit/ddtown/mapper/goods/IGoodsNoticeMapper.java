package kr.or.ddit.ddtown.mapper.goods;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.goods.goodsNoticeVO;
import kr.or.ddit.vo.goods.goodsVO;

@Mapper
public interface IGoodsNoticeMapper {

	public List<goodsNoticeVO> noticeList();

	public List<goodsNoticeVO> search(goodsNoticeVO notice);

	public goodsNoticeVO selectMainNotice();

	public goodsVO selectGoodsOne();

	public int selectTotalGoodsNoticeCount(PaginationInfoVO<goodsNoticeVO> pagingVO);

	public List<goodsNoticeVO> selectAllGoodsNotices(PaginationInfoVO<goodsNoticeVO> pagingVO);

	public List<goodsNoticeVO> selectRecentGoodsNotices(int limit);

}
