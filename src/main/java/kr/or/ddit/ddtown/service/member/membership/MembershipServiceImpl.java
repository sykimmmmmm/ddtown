package kr.or.ddit.ddtown.service.member.membership;

import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.emp.artist.ArtistGroupMapper;
import kr.or.ddit.ddtown.mapper.member.membership.MembershipMapper;
import kr.or.ddit.ddtown.service.admin.goods.items.IAdminGoodsService;
import kr.or.ddit.ddtown.service.alert.IAlertService;
import kr.or.ddit.ddtown.service.community.ICommunityProfileService;
import kr.or.ddit.ddtown.service.emp.artist.IArtistGroupService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.alert.AlertVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.member.membership.MembershipDescriptionVO;
import kr.or.ddit.vo.member.membership.MembershipSubscriptionsVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MembershipServiceImpl implements IMembershipService {

	private final MembershipMapper membershipMapper;

	@Autowired
	private IArtistGroupService artistGroupService;

	@Autowired
	private IAlertService alertService;

	@Autowired
	private ArtistGroupMapper artistGroupMapper;

	@Autowired
	private IAdminGoodsService goodsService;

	@Autowired
	private ICommunityProfileService communityProfileService;

	// 멤버십 구독 여부 확인
	@Override
	public boolean hasValidMembershipSubscription(String memUsername, int artGroupNo) {
		int count = membershipMapper.hasValidMembershipSubscription(memUsername, artGroupNo);
		return count > 0;
	}

	// 총 레코드 수 조회 ( sub )
	@Override
	public int selectTotalRecord(PaginationInfoVO<MembershipSubscriptionsVO> pagingVO, String empUsername, String mbspSubStatCode) {
		return membershipMapper.selectTotalRecord(pagingVO, empUsername, mbspSubStatCode);
	}

	// 총 레코드 수 조회 ( des )
	@Override
	public int selectTotalDesRecord(PaginationInfoVO<MembershipDescriptionVO> pagingVO) {
		return membershipMapper.selectTotalDesRecord(pagingVO);
	}


	// 멤버십 구독자 목록 조회 ( sub )
	@Override
	public List<MembershipSubscriptionsVO> selectMembershipSubList(
			PaginationInfoVO<MembershipSubscriptionsVO> pagingVO, String empUsername, String mbspSubStatCode) {
		return membershipMapper.selectMembershipSubList(pagingVO, empUsername, mbspSubStatCode);
	}

	// 멤버십 구독자 목록 조회 ( des )
	@Override
	public List<MembershipDescriptionVO> selectMembershipDesList(
			PaginationInfoVO<MembershipDescriptionVO> pagingVO, String empUsername) {
		return membershipMapper.selectMembershipDesList(pagingVO, empUsername);
	}

	// 아티스트 그룹 목록 조회
	@Override
	public List<ArtistGroupVO> getArtistGroupListAll() {
		return artistGroupMapper.getArtistGroupListAll();
	}

	// 플랜 생성
	@Override
	public Map<String, Object> registerMembershipDes(MembershipDescriptionVO desVO, String logEmpUsername) {
		Map<String, Object> result = new HashMap<>();

		try {

			// 선택된 아티스트 그룹 번호의 실제 담당자 ID 조회
			int selectedArtGroupNo = desVO.getArtGroupNo();
            if (selectedArtGroupNo < 0) {
                result.put("success", false);
                result.put("message", "아티스트 그룹이 선택되지 않았습니다.");
                return result; // 유효성 검사 실패
            }

			// DB에서 해당 아티스트 그룹의 실제 담당자 ID를 조회
            String actualArtGroupEmpUsername = artistGroupService.getEmpUsernameByArtistGroupNo(selectedArtGroupNo);

            if (actualArtGroupEmpUsername == null || !actualArtGroupEmpUsername.equals(logEmpUsername)) {
                result.put("success", false);
                result.put("message", "선택하신 아티스트 그룹의 담당자가 아닙니다. 멤버십 플랜 등록 권한이 없습니다.");
                return result; // 권한 검사 실패
            }

            // 4. 모든 비즈니스 로직 검증 통과 시 DB 삽입 매퍼 호출
            int res = membershipMapper.registerMembershipDes(desVO);

            if (res > 0) {
            	// 멤버쉽 플랜 등록시 상품자동추가
            	// 굿즈넘버 굿즈이름 가격 재고
            	goodsVO goodsVO = new goodsVO();
            	goodsVO.setArtGroupNo(desVO.getArtGroupNo());
            	goodsVO.setGoodsNm(desVO.getMbspNm() + " 멤버십");
            	goodsVO.setStatusEngKey("IN_STOCK");
            	goodsVO.setGoodsPrice(desVO.getMbspPrice());
            	goodsVO.setStockRemainQty(99999);
            	goodsVO.setGoodsDivCode("GDC002");

            	goodsService.itemsRegister(goodsVO);

                result.put("success", true);
                result.put("message", "멤버십 플랜이 성공적으로 등록되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "멤버십 플랜 등록에 실패했습니다.");
            }

		} catch (Exception e) {
            log.error("멤버십 플랜 등록 서비스 로직 중 오류 발생: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "서버 오류로 인해 멤버십 플랜 등록에 실패했습니다.");
        }
        return result;
	}

	// 플랜 수정
	@Override
	public Map<String, Object> modifyMembershipDes(MembershipDescriptionVO desVO, String logEmpUsername) {
		Map<String, Object> result = new HashMap<>();

		try {

			// 선택된 아티스트 그룹 번호의 실제 담당자 ID 조회
			int selectedArtGroupNo = desVO.getArtGroupNo();
            if (selectedArtGroupNo < 0) {
                result.put("success", false);
                result.put("message", "아티스트 그룹이 선택되지 않았습니다.");
                return result; // 유효성 검사 실패
            }

			// DB에서 해당 아티스트 그룹의 실제 담당자 ID를 조회
            String actualArtGroupEmpUsername = artistGroupService.getEmpUsernameByArtistGroupNo(selectedArtGroupNo);

            if (actualArtGroupEmpUsername == null || !actualArtGroupEmpUsername.equals(logEmpUsername)) {
                result.put("success", false);
                result.put("message", "선택하신 아티스트 그룹의 담당자가 아닙니다. 멤버십 플랜 등록 권한이 없습니다.");
                return result; // 권한 검사 실패
            }

            // 4. 모든 비즈니스 로직 검증 통과 시 DB 삽입 매퍼 호출
            int res = membershipMapper.modifyMembershipDes(desVO);

            if (res > 0) {
                result.put("success", true);
                result.put("message", "멤버십 플랜이 성공적으로 수정되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "멤버십 플랜 수정에 실패했습니다.");
            }

		} catch (Exception e) {
            log.error("멤버십 플랜 등록 서비스 로직 중 오류 발생: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "서버 오류로 인해 멤버십 플랜 수정에 실패했습니다.");
        }
        return result;
	}

	// 플랜 삭제
	@Override
	public ServiceResult deleteMembershipDes(int mbspNo, String currentEmpUsername) {

		// 단일 플랜 정보 가져오기
		MembershipDescriptionVO membership = membershipMapper.getMembershipDescription(mbspNo);

		if(membership == null) {
			return ServiceResult.FAILED;
		}

		// 권한 확인
		if(!membership.getEmpUsername().equals(currentEmpUsername)) {
			return ServiceResult.NOTEXIST;
		}

		// 삭제 진행
		try {
			int res = membershipMapper.deleteMembershipDes(mbspNo);

			if(res > 0) {
				return ServiceResult.OK;
			} else {
				return ServiceResult.FAILED;
			}
		}catch (Exception e) {
			log.error("멤버십 플랜 삭제 중 DB 오류 : " + e.getMessage());
			return ServiceResult.FAILED;
		}
	}

	// 멤버십 생성
	@Override
	@Transactional
	public void insertMembershipSub(MembershipSubscriptionsVO subscription) {
		log.info("insertMembershipSub() 호출. 삽입될 멤버십 구독 정보: {}", subscription);
		int result = membershipMapper.insertMembershipSub(subscription);


		if(result > 0) {
			log.info("멤버십 구독 정보 삽입 성공! {}", result);
			//////////////// 알림 로직 시작 /////////////////
			try {
				// 알림 메시지 생성
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일");
				String startDate = subscription.getMbspSubStartDate().format(formatter);		// 시작일 포맷팅
				String endDate = subscription.getMbspSubEndDate().format(formatter);			// 만료일 포맷팅
				MembershipDescriptionVO sub = membershipMapper.getMembershipDescription(subscription.getMbspNo());
				String message = String.format("@everyone! '%s' 멤버십 구독해줘서 고마워!! \n 시작일: %s, 만료일: %s \n 앞으로 잘부탁해!",
						sub.getArtGroupNm(), startDate, endDate);

				// ALERT 객체 데이터 삽입
				List<String> recipientUsernames = Collections.singletonList(subscription.getMemUsername());
				String recipientNick = communityProfileService.getComuNicknmByUsername(subscription.getMemUsername(), sub.getArtGroupNo());
				String replacedContent = message.replaceAll("@everyone", recipientNick);
				AlertVO alert = new AlertVO();
				alert.setAlertTypeCode("ATC006");
				alert.setRelatedItemTypeCode("ITC006");
				alert.setAlertUrl("/mypage/memberships");
				alert.setRelatedItemNo(subscription.getMbspNo());
				alert.setRelatedItemChar(subscription.getMbspNm());
				alert.setArtGroupNo(sub.getMbspNo());
				alert.setArtGroupNm(sub.getArtGroupNm());
				alert.setAlertContent(replacedContent);
				alertService.createAlert(alert, recipientUsernames);
				log.info("멤버십 구독 알림 전송 완료: 수신자 - {}", subscription.getMemUsername());
			} catch (Exception e) {
				log.error("멤버십 구독 알림 전송 실패..", e);
			}
		} else {
			log.warn("멤버십 구독 정보 삽입 실패: 영향을 받은 행 없음. subscription: {}", subscription);
		}
	}

	// 담당 아티스트 그룹 번호 조회
	@Override
	public int selectArtGroupNo(String empUsername) {
		return membershipMapper.selectArtGroupNo(empUsername);
	}

	// 멤버십 구독자 건수 조회
	@Override
	public Map<String, Integer> selectMembershipSubCounts(Integer artGroupNo) {
		log.info("멤버십 구독자 건수 조회 요청!!");

		List<Map<String, Object>> rawCounts = membershipMapper.selectMembershipSubCounts(artGroupNo);

		Map<String, Integer> counts = new HashMap<>();
		int total = 0;

		for(Map<String, Object> row : rawCounts) {

			Set<String> key = row.keySet();
			for (String i : key) {
				log.info("i : {}", i);
			}

			String status = (String) row.get("MBSPSUBSTATCODE");

			log.info("status: {}", status);

			Object countObj =  row.get("COUNT");
			Integer count = 0;

			if(countObj instanceof Number countNumber) {
				count = countNumber.intValue();
			} else if(countObj != null) {
				try {
					count = Integer.parseInt(countObj.toString());
					log.info("count: {}", count);

				} catch (NumberFormatException e) {
	                log.error("Failed to parse count value: {}", countObj, e);
	            }
			}

			counts.put(status, count);
			total += count;
		}

		counts.put("TOTAL", total);

		log.info("subCounts map: {}", counts);

		return counts;
	}

	// 사용자의 멤버십 구독 리스트 조회
	@Override
	public List<MembershipSubscriptionsVO> getMyMembershipList(PaginationInfoVO<MembershipSubscriptionsVO> pagingVO) {
		log.info("사용자 멤버십 구독 리스트 조회 요청!");

		return membershipMapper.getMyMembershipList(pagingVO);
	}

	// 사용자 멤버십 토탈 레코드 수
	@Override
	public int getMySubTotalRecord(PaginationInfoVO<MembershipSubscriptionsVO> pagingVO) {
		return membershipMapper.getMySubTotalRecord(pagingVO);
	}

	@Override
	public int getMbspNo(int artGroupNo) {
		return membershipMapper.selectMbspNo(artGroupNo);
	}

	/**
	 * 그룹번호로 구독정보 가져오기
	 */
	@Override
	public MembershipDescriptionVO getMembershipInfo(int artGroupNo) {
		return membershipMapper.getMembershipInfo(artGroupNo);
	}

	/**
	 * 가장 많은 구매를 한 사용자 top3
	 */
	@Override
	public List<MembershipSubscriptionsVO> getTopPayingUsers(int artGroupNo) {
		return membershipMapper.getTopPayingUsers(artGroupNo);
	}

	/**
	 * 이번 달 멤버십 가입자 수
	 */
	@Override
	public List<MembershipSubscriptionsVO> getMonthlySignups() {
		return membershipMapper.getMonthlySignUps();
	}

	/**
	 * 통계용 멤버십 인기 플랜 top3 : 구독자 수
	 */
	@Override
	public List<MembershipDescriptionVO> getTopPopularMemberships() {
		return membershipMapper.getTopPopularMemberships();
	}

	/**
	 * 월별 멤버십 플랜 매출
	 */
	@Override
	public List<MembershipDescriptionVO> getMonthlySalesTrendChartData() {
		return membershipMapper.getMonthlySalesTrendChartData();
	}
}
