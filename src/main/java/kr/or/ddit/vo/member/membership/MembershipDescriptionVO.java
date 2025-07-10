package kr.or.ddit.vo.member.membership;

import java.util.Date;

import kr.or.ddit.vo.artist.ArtistGroupVO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MembershipDescriptionVO {

	private int mbspNo;				// 멤버십 번호
	private int artGroupNo;			// 아티스트 그룹 번호
	private String mbspNm;			// 멤버십 플랜 명
	private int mbspPrice;			// 가격
	private int mbspDuration;		// 멤버십 기간
	private Date mbspRegDate;		// 멤버십 플랜 생성일자
	private Date mbspModDate;		// 멤버십 플랜 수정일자

	private String empUsername;		// 멤버십 담당자
	private String artGroupNm;		// 아티스트 그룹 이름

	private ArtistGroupVO artistGroupVO;	// 멤버십에 속한 아티스트 그룹정보

	// -- 통계용 --
	private int totalSalesCount;	// 해당 멤버십 플랜 총 판매량

	private String saleMonth;
	private Long monthlySalesAmount;


}
