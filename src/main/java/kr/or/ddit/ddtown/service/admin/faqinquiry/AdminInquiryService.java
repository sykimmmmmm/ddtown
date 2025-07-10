package kr.or.ddit.ddtown.service.admin.faqinquiry;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.admin.faqInquiry.IAdminInquiryMapper;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.common.CommonCodeDetailVO;
import kr.or.ddit.vo.inquiry.InquiryCodeVO;
import kr.or.ddit.vo.inquiry.InquiryVO;

@Service
public class AdminInquiryService implements IAdminInquiryService {

	@Autowired
	private IAdminInquiryMapper adminInquiryMapper;

	@Override
	public Map<Object, Object> getList(PaginationInfoVO<InquiryVO> pagingVO, String searchCode) {

		Map<Object, Object> map = new HashMap<>();

		List<InquiryVO> list = adminInquiryMapper.getList(pagingVO, searchCode);

		List<InquiryCodeVO> typeCodeList = adminInquiryMapper.getTypeCodeList();

		List<InquiryCodeVO> statCodeList = adminInquiryMapper.getStatCodeList();

		List<CommonCodeDetailVO> cntList = adminInquiryMapper.getTotalState();

		int totalInq = adminInquiryMapper.getTotalInq();

		int cnt = adminInquiryMapper.getCnt(pagingVO, searchCode);

		if (!list.isEmpty()) {
			pagingVO.setTotalRecord(cnt);
		}

		map.put("inqVOList", list);
		map.put("pagingVO", pagingVO);
		map.put("typeCodeList", typeCodeList);
		map.put("statCodeList", statCodeList);
		map.put("cntList", cntList);
		map.put("searchCode", searchCode);

		map.put("totalInq", totalInq);

		return map;
	}

	@Override
	public InquiryVO getData(int inqNo) {

		return adminInquiryMapper.getData(inqNo);
	}

	@Override
	public ServiceResult updateAnswer(InquiryVO inqVO) {

		ServiceResult result = null;


		if("ISC001".equals(inqVO.getStatDetailCode())) {
		inqVO.setStatDetailCode("ISC002"); }


		int status = adminInquiryMapper.updateAnswer(inqVO);

		if (status > 0) {
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public int getUnansweredInquiryCnt() {
		return adminInquiryMapper.getUnansweredInquiryCnt();
	}


}
