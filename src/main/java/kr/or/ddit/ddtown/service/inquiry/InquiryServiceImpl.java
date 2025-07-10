package kr.or.ddit.ddtown.service.inquiry;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import io.micrometer.common.util.StringUtils;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.inquiry.InquiryMapper;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.inquiry.InquiryCodeVO;
import kr.or.ddit.vo.inquiry.InquiryVO;
import kr.or.ddit.vo.user.MemberVO;

@Service
public class InquiryServiceImpl implements InquiryService {

	@Autowired
	private InquiryMapper inquiryMapper;

	@Override
	public Map<Object, Object> getList(PaginationInfoVO<InquiryVO> pagingVO) {

		Map<Object, Object> map = new HashMap<>();

		List<InquiryVO> list = inquiryMapper.getList(pagingVO);

		int totalRecord = inquiryMapper.inqTotal(pagingVO);

		List<InquiryCodeVO> codeList = inquiryMapper.getCodeList();

		MemberVO memberVO = inquiryMapper.getMember(pagingVO.getMemUsername());

		String name = memberVO.getPeoLastNm() + memberVO.getPeoFirstNm();

		pagingVO.setTotalRecord(totalRecord);

		map.put("inqVO", list);
		map.put("codeList", codeList);
		map.put("name", name);
		map.put("pagingVO", pagingVO);

		return map;
	}

	@Override
	public List<InquiryCodeVO> getCodeList() {

		List<InquiryCodeVO> list = null;

		list = inquiryMapper.getCodeList();

		return list;
	}

	@Override
	public ServiceResult insertData(InquiryVO inquiryVO) {
		ServiceResult result = null;

		int status = 0;

		if(inquiryVO.getStatDetailCode() == null || StringUtils.isBlank(inquiryVO.getInqStatCodeDes())) {
			List<InquiryCodeVO> statCode = inquiryMapper.getStatCode();
			String inqStatCode = null;
			for(InquiryCodeVO code : statCode) {
				if(code.getCommCodeDetNo().equals("ISC001")) {
					inqStatCode = code.getCommCodeDetNo();
				}
			}

			inquiryVO.setStatDetailCode(inqStatCode);

			status = inquiryMapper.insertData(inquiryVO);

		}

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public InquiryVO getDetail(int inqNo) {

		return inquiryMapper.getDetail(inqNo);
	}

	@Override
	public ServiceResult updateData(InquiryVO vo) {

		ServiceResult  result = null;

		int status = inquiryMapper.updateData(vo);

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public ServiceResult deleteData(int inqNo) {
		ServiceResult result = null;

		int status = inquiryMapper.deleteData(inqNo);

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

}
