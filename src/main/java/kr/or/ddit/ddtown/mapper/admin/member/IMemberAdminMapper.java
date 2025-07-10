package kr.or.ddit.ddtown.mapper.admin.member;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.member.MemCodeListVO;
import kr.or.ddit.vo.member.MemberAdminVO;
import kr.or.ddit.vo.member.PeopleAdminVO;
import kr.or.ddit.vo.member.membership.MembershipSubscriptionsVO;
import kr.or.ddit.vo.order.OrderCancelVO;
import kr.or.ddit.vo.order.OrdersVO;

@Mapper
public interface IMemberAdminMapper {

	public List<MemberAdminVO> getMemberList();

	public MemberAdminVO getMember(String memUsername);

	public List<MemCodeListVO> getCodeList();

	public int updateMember(MemberAdminVO memberVO);

	public int updatePeople(PeopleAdminVO peopleVO);

	public int deleteMember(String memUsername);

	public int deletePeople(String memUsername);

	public int getTotalRecord(@Param("paging") PaginationInfoVO<MemberAdminVO> pagingVO,@Param("searchCode") String searchCode);

	public List<MemberAdminVO> getDataList(@Param("paging") PaginationInfoVO<MemberAdminVO> pagingVO,@Param("searchCode") String searchCode);

	/**
	 * 신규 가입자 수 구하기
	 * @return
	 */
	public int getTodayRegisterUser();

	// 전체 회원 수 가져오기
	public int getTotalMemCnt();

	// 정상 회원 수 가져오기
	public int getGeneralMemCnt();

	// 탈퇴 회원 수 가져오기
	public int getOutMemCnt();

	// 블랙리스트 회원 수 가져오기
	public int getBlackMemCnt();

	// 팔로우 중인 커뮤니티 정보 가져오기
	public List<MemberAdminVO> joinComuList(String memUsername);

	// 해당 회원의 게시물 개수 가져오기
	public List<Integer> postCntList(@Param("vo") MemberAdminVO memberAdminVO);

	// 해당 회원의 댓글 개수 가져오기
	public List<Integer> replyCntList(@Param("vo") MemberAdminVO memberAdminVO);

	// 회원이 가입함 멤버십 목록 가져오기
	public List<MembershipSubscriptionsVO> membershipList(String memUsername);

	// 해당 멤버십에 대한 이전 기록 가져오기
	public List<MembershipSubscriptionsVO> subMembershipList(@Param("memUsername") String mainMemUsername, @Param("mbspNo") int mainMbspNo);

	// 주문 목록 가져오기
	public List<OrdersVO> ordersVOList(String memUsername);

	// 월별 취소 금액
	public List<Integer> cancelCnt(String memUsername);

	// 월별 판매 금액
	public List<Integer> sellCnt(String memUsername);

	// 누적 판매 금액
	public List<Integer> totalSellCnt(String memUsername);

	// 판매금액에 따른 주문내역 리스트
	public List<OrdersVO> sellOrderList(PaginationInfoVO<OrdersVO> pagingVO);

	// 취소금액에 따른 주문내역 리스트
	public List<OrderCancelVO> cancelOrderList(PaginationInfoVO<OrdersVO> pagingVO);

	// 판매금액에 따른 주문내역 리스트의 총 개수
	public int sellOrderTotal(PaginationInfoVO<OrdersVO> pagingVO);

	// 취소금액에 따른 주문내역 리스트의 총 개수
	public int cancelListTotalRecord(PaginationInfoVO<OrdersVO> pagingVO);
}
