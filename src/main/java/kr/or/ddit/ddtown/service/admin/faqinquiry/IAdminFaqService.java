package kr.or.ddit.ddtown.service.admin.faqinquiry;

import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.faq.FaqVO;

public interface IAdminFaqService {

	public Map<Object, Object> faqAdminMain(PaginationInfoVO<FaqVO> pagingVO, String searchCode);

	public FaqVO getFaqDetail(int faqNo);

	public ServiceResult updateData(FaqVO faqVO);

	public ServiceResult faqInsert(FaqVO faqVO);

	public ServiceResult deleteData(int faqNo);


}
