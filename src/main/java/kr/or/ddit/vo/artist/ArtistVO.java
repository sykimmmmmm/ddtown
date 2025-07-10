package kr.or.ddit.vo.artist;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.BaseVO;
import kr.or.ddit.vo.community.CommunityProfileVO;
import kr.or.ddit.vo.user.MemberVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@NoArgsConstructor
public class ArtistVO extends BaseVO{

	private int artNo;
	private Integer artGroupNo;
	private String memUsername;
	private String artNm;
	private String artContent;
	private Date artRegDate;	// 등록일
	private Date artModDate;	// 수정일
	private String artProfileImg;
	private String artGroupNm;	// 그룹 이름
	private String empUsername;	// 담당자 아이디
	private String artGroupDebutdate;
	private String artDebutdate;
	private String empName; // 담당자 이름
	private List<ArtistGroupVO> groupList; // 소속 그룹 리스트
	private MultipartFile profileImg;
	private String artDelYn;

	private CommunityProfileVO communityProfileVO;		// 아티스트 커뮤니티 프로필 VO

	// 아티스트 계정정보
	private MemberVO memberVO;

	private ArtistGroupVO groupVO;		// 아티스트가 속한 그룹

	public ArtistVO(int page, String searchType, String searchWord) {
		super(page, searchType, searchWord);
	}

}
