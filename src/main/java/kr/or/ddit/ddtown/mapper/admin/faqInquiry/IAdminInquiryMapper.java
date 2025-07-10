package kr.or.ddit.ddtown.mapper.admin.faqInquiry;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.common.CommonCodeDetailVO;
import kr.or.ddit.vo.inquiry.InquiryCodeVO;
import kr.or.ddit.vo.inquiry.InquiryVO;


@Mapper
public interface IAdminInquiryMapper {

	public List<InquiryVO> getList(@Param("pagingVO") PaginationInfoVO<InquiryVO> pagingVO, @Param("searchCode") String searchCode);

	public InquiryVO getData(int inqNo);

	public int updateAnswer(InquiryVO inqVO);

	public List<InquiryCodeVO> getTypeCodeList();

	public List<InquiryCodeVO> getStatCodeList();

	public int getCnt(@Param("pagingVO") PaginationInfoVO<InquiryVO> pagingVO,@Param("searchCode") String searchCode );

	public int getTotalInq();

	public List<CommonCodeDetailVO> getTotalState();

	/**
	 * 미처리 문의건수 가져오기
	 * @return
	 */
	public int getUnansweredInquiryCnt();

}
