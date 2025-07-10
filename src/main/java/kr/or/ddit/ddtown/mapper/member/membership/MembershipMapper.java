package kr.or.ddit.ddtown.mapper.member.membership;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.member.membership.MembershipDescriptionVO;
import kr.or.ddit.vo.member.membership.MembershipSubscriptionsVO;

@Mapper
public interface MembershipMapper {

	// 멤버십 구독 여부 확인
	int hasValidMembershipSubscription(String memUsername, int artGroupNo);

	// 총 레코드 수 조회 ( sub )
	int selectTotalRecord(
			@Param("pagingVO") PaginationInfoVO<MembershipSubscriptionsVO> pagingVO,
			@Param("empUsername") String empUsername,
			@Param("mbspSubStatCode") String mbspSubStatCode);

	// 총 레코드 수 조회 ( des)
	int selectTotalDesRecord(@Param("pagingVO") PaginationInfoVO<MembershipDescriptionVO> pagingVO);

	// 멤버십 구독자 목록 조회 ( sub )
	List<MembershipSubscriptionsVO> selectMembershipSubList(
			@Param("pagingVO") PaginationInfoVO<MembershipSubscriptionsVO> pagingVO,
			@Param("empUsername") String empUsername,
			@Param("mbspSubStatCode") String mbspSubStatCode);


	// 멤버십 구독자 목록 조회 ( des )
	List<MembershipDescriptionVO> selectMembershipDesList(@Param("pagingVO") PaginationInfoVO<MembershipDescriptionVO> pagingVO,
			@Param("empUsername") String empUsername);

	// 아티스트 그룹 목록 조회
	List<ArtistGroupVO> getArtistGroupListAll();

	// 플랜 등록
	int registerMembershipDes(MembershipDescriptionVO desVO);

	// 플랜 수정
	int modifyMembershipDes(MembershipDescriptionVO desVO);

	// 해당 멤버십 플랜 가져오기
	MembershipDescriptionVO getMembershipDescription(int mbspNo);

	// 해당 멤버십 삭제
	int deleteMembershipDes(int mbspNo);

	// 멤버십 생성
	int insertMembershipSub(MembershipSubscriptionsVO subscription);

	// 담당 아티스트 그룹 번호 조회
	int selectArtGroupNo(String empUsername);

	// 멤버십 구독자 건수 조회
	List<Map<String, Object>> selectMembershipSubCounts(Integer artGroupNo);

	// 사용자의 멤버십 구독 리스트 조회
	List<MembershipSubscriptionsVO> getMyMembershipList(PaginationInfoVO<MembershipSubscriptionsVO> pagingVO);

	// 사용자 멤버십 토탈 레코드 수
	int getMySubTotalRecord(PaginationInfoVO<MembershipSubscriptionsVO> pagingVO);

	// 멤버십 구독번호로 아티스트 그룹번호 조회 (알림용)
	Integer selectArtGroupNoByMbspNo(Integer mbspNo);

	int selectMbspNo(int artGroupNo);

	/**
	 * 그룹번호로 구독플랜정보 가져오기
	 * @param artGroupNo
	 * @return
	 */
	MembershipDescriptionVO getMembershipInfo(int artGroupNo);

	/**
	 * 가장 많은 구매를 한 사용자 top3
	 * @return
	 */
	List<MembershipSubscriptionsVO> getTopPayingUsers(int artGroupNo);

	/**
	 * 이번 달 멤버십 가입자 수
	 * @return
	 */
	List<MembershipSubscriptionsVO> getMonthlySignUps();

	/**
	 * 통계용 멤버십 인기 플랜 top3 : 구독자 수
	 * @param artGroupNo
	 * @return
	 */
	List<MembershipDescriptionVO> getTopPopularMemberships();

	/**
	 * 월별 멤버십 플랜 매출
	 * @return
	 */
	List<MembershipDescriptionVO> getMonthlySalesTrendChartData();

}
