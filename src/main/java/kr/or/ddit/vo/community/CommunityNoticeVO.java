package kr.or.ddit.vo.community;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class CommunityNoticeVO {

	private String comuNotiTitle;		// 커뮤니티 공지 제목
	private String comuNotiCatCode;		// 커뮤니티 공지 분류 코드
	private int comuNotiNo;				// 커뮤니티 공지 번호
	private String empUsername;			// 작성 직원아이디
	private Integer fileGroupNo;		// 파일 그룹번호
	private int artGroupNo;				// 아티스트 그룹번호
	private String comuNotiContent;		// 커뮤니티 공지 내용
	private Date comuNotiRegDate;		// 커뮤니티 공지 작성일시
	private Date comuNotiModDate;		// 커뮤니티 공지 수정일시

	///////////////////////////////////////////////////////////////////////////////////

	// 첨부파일
	private MultipartFile[] comuNotiFiles;						// 업로드 파일들
	private List<AttachmentFileDetailVO> attachmentFileList;	// 상세보기 전체파일 목록

	private List<Integer> deleteFileNos;						// 삭제할 파일번호

	///////////////////////////////////////////////////////////////////////////////////

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date concertDate;						// 공연 일자
	@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	private Date concertStartDate;					// 예매 시작일
	@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	private Date concertEndDate;					// 예매 종료일

	private String artGroupNm;					// 아티스트 그룹명
	private String concertHallName;					// 공연장 명

	private String codeDescription;		// 공지사항 분류 코드에 따른 분류명
}
