package kr.or.ddit.vo.inquiry;

import java.util.Date;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class InquiryVO extends InqBaseVO{

	private int inqNo;				// 문의번호
	private String empUsername;		// 답변직원
	private String memUsername;		// 문의한 사용자
	private String inqTypeCodeDes;		// 문의유형코드명
	private String inqStatCodeDes;		// 처리상태코드명
	private String inqTitle;		// 문의제목
	private String inqContent;		// 문의내용
	private Date inqRegDate;		// 문의등록일시
	private String inqAnsContent;	// 답변내용
	private Date inqAnsRegDate;		// 답변등록일시

	private int rownum;
	private int totalRecord;

	private String typeDetailCode;
	private String statDetailCode;

	private String userEmail;
	private String phone;

	private String cntCode;
	private int cnt;


	private InquiryVO(int page, String searchType, String searchWord, String searchStatType) {
		super(page, searchType, searchWord, searchStatType);
	}

}
