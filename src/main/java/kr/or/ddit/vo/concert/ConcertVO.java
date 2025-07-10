package kr.or.ddit.vo.concert;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.common.CommonCodeDetailVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ConcertVO{

	 private int concertNo;							// 콘서트 번호
	 private int artGroupNo;						// 아티스트 그룹번호
	 private int concertHallNo;						// 콘서트장 번호
	 private String concertCatCode;					// 공연 분류 코드
	 private String concertReservationStatCode;		// 예매 상태 코드
	 private String concertStatCode;				// 공연 상태 코드
	 private String concertImg;						// 포스터 이미지
	 private String concertOnlineYn;				// 온라인 여부
	 private String concertNm;						// 공연 이름
	 private String concertAddress;					// 공연 장소
	 private int concertRunningTime;				// 공연시간
	 private String concertGuide;					// 공연 안내사항

	 // 첨부파일
	 private MultipartFile[] concertFiles;
	 private Integer fileGroupNo;
	 private String representativeImageUrl;					// 대표 이미지 웹 경로
	 private List<AttachmentFileDetailVO> attachmentFileList;	// 상세보기 전체파일 목록

	 private List<Integer> deleteFileNos;			// 삭제할 파일번호

	 @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	 private Date concertDate;						// 공연 일자
	 @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	 private Date concertStartDate;					// 예매 시작일
	 @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	 private Date concertEndDate;					// 예매 종료일

	 private String artGroupName;					// 아티스트 그룹명
	 private String concertHallName;				// 공연장 명
	 private Integer totalSeats;					// 총 좌석수

	 private CommonCodeDetailVO commCodeDetVO;		// 스케줄에 사용하기 위한 공연 분류 코드 담을 객체
	 private ConcertHallVO	concertHallVO;			// 스캐줄에 사용하기 위한 콘서트 장 담을 객체
}
