package kr.or.ddit.vo.report;

import java.util.List;

import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.Data;

@Data
public class ReportVO {
	private int reportNo;				//신고번호
	private int artGroupNo;				//아티스트그룹 번호		//필요 없을지도?
	private String memUsername;			//신고자
	private String targetMemUsername;	//신고 대상 사용자(신고먹은 사람)
	private String reportReasonCode;	//신고 사유(음란물, 불법, 용설 ,스팸 등등)
	private String reportTargetTypeCode;//신고대상 유형코드(게시글,댓글,채팅)
	private String reportStatCode;		//신고처리 상태코드(접수, 처리완료)
	private String reportResultCode;	//신고처리 결과코드(블랙리스트, 숨김처리, 조치 없음, 게시물 삭제)
	private String targetBoardTypeCode;		//게시판 유형코드(팬, 아티스트 게시글)	//필요 없을지도?
	private int targetComuPostNo;	//대상 게시글번호(해당 게시글 번호)
	private int targetComuReplyNo;		//대상 댓글 번호(해당 댓글 번호)
	private int targetChatNo;			//대상메세지 번호(해당 메세지 번호)

	private int reportCnt;	//신고번호(reportNo)와 관계된 targetMemUsername 사람의 누적된 신고 건수

	//신고 상세 관련VO
	private int reportDetNo;		//신고상세번호
	private String reportRegDate;	//신고일시
	private String reportResDate;	//신고처리일시
	private String reportBanYn;		//벤여부

	//커뮤니티 관련 값가져오기
	private String reportedContent;	//신고된 내용
	private List<AttachmentFileDetailVO> fileList;// 파일
	private int aptGroupNo;// 아티스트 그룹 번호


	private int reportedCount; // 해당 게시글/댓글/채팅에 대한 총 신고 수

	private String empUsername; // 로그인한 담당자 ID

	//상세페이지 관련
	private String reporterUsernames;// 해당 대상을 신고한 사용자 아이디 목록
	private List<ReportVO> individualReportList;	// 개별신고목록

	//목록페이지 관련
	private String peoFirstNm;	//이름
	private String peoLastNm;	//성



}
