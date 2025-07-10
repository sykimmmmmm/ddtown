package kr.or.ddit.vo.community;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.common.CommonCodeDetailVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@ToString(callSuper = true)
public class CommunityPostVO extends BoardTypeVO{

	private int comuPostNo;				// 게시글 번호
	private String boardTypeCode;		// 게시판 유형코드
	private int comuProfileNo;			// 커뮤니티 프로필 번호
	private int artGroupNo;				// 아티스트 그룹번호
	private Integer fileGroupNo;		// 게시판 첨부파일번호
	private String comuPostStatCode;	// 게시글 상태코드
	private String comuPostContent;		// 게시글 내용
	private Date comuPostRegDate;		// 게시글 등록 일자
	private Date comuPostModDate;		// 게시글 수정 일자
	private String comuPostMbspYn;		// 멤버십 전용 여부
	private String comuPostDelYn;		// 게시글 삭제여부

	private String likeYn;				// 게시글 좋아요 여부
	private int myComuProfileNo;		// 좋아요 여부 판단을 위한 내 커뮤니티 번호
	private String memUsername;

	private String empUsername;			// 직원이 조회할 떄

	private boolean memberShipYn;		// 멤버십 여부 true / false

	private int comuPostLike;			// 게시글 좋아요 수

	private int comuPostReplyCount;		// 게시물 댓글 수

	private CommunityProfileVO writerProfile;	// 작성자 상세정보

	private List<CommunityReplyVO> comuPostReplyList;  // 게시글 댓글 목록

	private List<AttachmentFileDetailVO> postFiles;		// 게시글 파일 목록

	private MultipartFile[] files;

	// 해당 VO가 artist쪽인지 아닌지 true : 아티스트 관련 게시물 / false : 팬 관련 게시물
	private boolean artistTabYn = true;

	private List<Integer> deleteFiles;

	private int rnum; // 게시글 순서

	private CommonCodeDetailVO commCodeDetailVO;	// 공통 코드 VO
}
