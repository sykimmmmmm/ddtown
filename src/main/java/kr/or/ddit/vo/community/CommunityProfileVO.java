package kr.or.ddit.vo.community;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.artist.ArtistVO;
import lombok.Data;

// 커뮤티니 작성자 VO
@Data
public class CommunityProfileVO {
	private int comuProfileNo;		// 작성자 프로필 번호

	private int artGroupNo;		// 작성자가 속한 아티스트 그룹 번호

	private String memUsername;	// 작성자 아이디

	private String comuMemCatCode;	// 작성자 유형코드

	private String comuProfileImg;	// 작성자 프로필 이미지

	private String comuNicknm;		// 작성자 닉네임

	private Date comuRegDate;		// 작성자 커뮤니티 가입 날짜

	private String comuDelYn;		// 작성자 커뮤니티 탈퇴 여부

	private MultipartFile imgFile; // 프로필 등록시 필요한 imgFile;

	private List<CommunityPostVO> postList; // 자신이 작성한 글 목록

	private List<CommunityReplyVO> replyList; // 자신이 작성한 댓글 목록

	private int myComuProfileNo; // 작성자 디테일쪽에서 likeYn여부 판단을 위한 필드 추가

	private ArtistVO artistVO;	// 아티스트 상세정보]

	private String memberShipYn; // 해당 커뮤니티 멤버십 가입 여부

}
