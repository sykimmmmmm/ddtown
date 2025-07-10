package kr.or.ddit.ddtown.service.alert;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ddtown.mapper.alert.IAlertMapper;
import kr.or.ddit.ddtown.mapper.chat.dm.ChatChannelMapper;
import kr.or.ddit.ddtown.mapper.common.ICommonCodeMapper;
import kr.or.ddit.ddtown.mapper.community.ICommunityMainPageMapper;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.alert.AlertReceiverVO;
import kr.or.ddit.vo.alert.AlertSettingVO;
import kr.or.ddit.vo.alert.AlertVO;
import kr.or.ddit.vo.chat.dm.ChatChannelVO;
import kr.or.ddit.vo.common.CommonCodeDetailVO;
import kr.or.ddit.vo.live.LiveVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AlertServiceImpl implements IAlertService {

	@Autowired
	private IAlertMapper alertMapper;

	@Autowired
	private SimpMessagingTemplate messagingTemplate;

	@Autowired
	private ICommonCodeMapper commonCodeMapper;

	@Autowired
	private ICommunityMainPageMapper communityMainPageMapper;

	@Autowired
	private ChatChannelMapper chatChannelMapper;

	@Value("${server.servlet.context-path:/}")
    private String contextPath;

	@Override
	@Transactional
	public void createAlert(AlertVO alert, List<String> recipientUsernames) throws Exception {
		log.info("createAlert() 실행...! 알림내용: {}, 알림타입: {}", alert.getAlertContent(), alert.getAlertTypeCode());

		// 알림 정보 저장
		if(alert.getAlertCreateDate() == null) {
			alert.setAlertCreateDate(new Timestamp(System.currentTimeMillis()));		// 알림 밀리초로 생성
		}


		int result = alertMapper.insertAlert(alert);

		if(result == 0) {
			log.error("알림 정보 저장 실패!!");
		}

		long generatedAlertNo = alert.getAlertNo();

		if(generatedAlertNo == 0) {
			log.error("알림 생성 실패 -> 알림 ID 못가져옴");
		}

		// 수신자 정보 저장 후 실시간 알림 발송
		for(String username : recipientUsernames) {
			List<AlertSettingVO> userSettings = alertMapper.selectAlertSettings(username);		// 회원의 알림세팅 가져오기
			boolean canSendAlert = userSettings.stream()
					.filter(s -> s.getAlertTypeCode()
					.equals(alert.getAlertTypeCode()))		// 알림유형코드가 일치할때
					.findFirst()
					.map(s -> "Y".equalsIgnoreCase(s.getAlertEnabledYn()))		// 알림설정 Y일때 보내도록 설정
					.orElse(true);		// 해당 타입에 대한 설정이 없으면 기본값 전송

			if(!canSendAlert) {
				log.info("회원 {}는 {}유형 알림 안받습니당", username, alert.getAlertTypeCode());
				continue;		// 다음 수신자로 넘어가기
			}

			AlertReceiverVO receiver = new AlertReceiverVO();
			receiver.setAlertNo(generatedAlertNo);		// 알림 번호 설정
			receiver.setMemUsername(username);			// 회원 아이디 설정
			receiver.setAlertGetDate(null);
			receiver.setAlertReadYn("N");				// 기본값 'N' (안읽음)
			receiver.setAlertDelYn("N");				// 기본값 'N' (삭제안됨)
			int receiverResult = alertMapper.insertAlertReceiver(receiver);

			if(receiverResult == 0) {
				log.warn("회원 {}에 대한 알림 수신자 저장 실패, 알림번호: {}", username, generatedAlertNo);
				continue;
			}


			try {
				// 각 ServiceImpl에서 호출시 url주소 담아보냄
				List<AlertVO> singleAlertList = new ArrayList<>();
				singleAlertList.add(alert);		// 현재 alert 객체 (artGroupNo, profileNo, boardTypeCode 등)
				completeAlertUrls(singleAlertList);
				AlertVO completeAlert = singleAlertList.get(0);		// 완성된 URL 담긴 객체 초기화
				messagingTemplate.convertAndSendToUser(username, "/queue/alerts", completeAlert);		// 완성된 URL 담긴 객체 전송
				log.info("WebSocket 알림 전송 완료: 회원 -{}, 알림 번호 - {}", username, generatedAlertNo);

			} catch (Exception e) {
				log.error("WebSocket 알림 전송 실패: 회원 -{}, 알림 번호 - {}", username, generatedAlertNo);
			}
		}
	}

	@Override
	public List<AlertVO> getAlertsByUsername(PaginationInfoVO<AlertVO> pagingVO) throws Exception {
		log.debug("getAlertsByUsername() 실행...!");

		Map<String, Object> countParams = new HashMap<>();
		countParams.put("memUsername", pagingVO.getMemUsername());
		countParams.put("artGroupNo", pagingVO.getArtGroupNo());



		// 전체 알림 개수 조회
		int totalRecord = alertMapper.getTotalAlertCount(countParams);
		pagingVO.setTotalRecord(totalRecord);		// 전체 레코드 수 설정

		Map<String, Object> params = new HashMap<>();

		params.put("memUsername", pagingVO.getMemUsername());
		params.put("artGroupNo", pagingVO.getArtGroupNo());
		params.put("startRow", pagingVO.getStartRow());			// startRow
		params.put("endRow", pagingVO.getEndRow());				// endRow

		// 알림 목록 조회
		List<AlertVO> alertList = alertMapper.selectAlertsByUsername(params);
		pagingVO.setDataList(alertList);		// 조회된 데이터 리스트 설정
		return alertList;
	}

	private void completeAlertUrls(List<AlertVO> alertList) {
		String profileBaseUrl = "/profile/"; // 프로필 페이지 기본 URL 경로
        String communityBaseUrl = "/community/"; // 커뮤니티 기본 URL 경로
        String membershipBaseUrl = "/mypage/memberships"; // 멤버십 기본 URL 경로

        for(AlertVO alert : alertList) {
        	String finalUrl = "";		// 최종경로 초기화용
        	Long relatedItemNo = alert.getRelatedItemNo();			// 게시물 번호
        	Integer profileNo = alert.getRelatedTargetProfileNo();	// 게시물이 속한 커뮤니티 프로필 번호
        	Integer artGroupNo = alert.getArtGroupNo();				// 게시물이 속한 아티스트 그룹 번호

        	switch (alert.getAlertTypeCode()) {
        		case "ATC001":		// 새 커뮤니티 게시글
        		case "ATC005":		// 좋아요
        			// 커뮤니티 프로필 있을경우
        			if(profileNo != null && artGroupNo != null && relatedItemNo != null && relatedItemNo > 0) {
        				// 해시태그와 함께 관련코드 넘겨서 모달창 바로뜨게 구현
        				finalUrl = communityBaseUrl + artGroupNo + profileBaseUrl + profileNo + "#post-" + relatedItemNo;
        				// finalUrl += "#post-" + relatedItemNo;
        			} else {
        				if(artGroupNo != null) {
        					// 커뮤니티 메인 페이지로 이동할 때 강제 새로고침을 위한 파라미터 추가
        					finalUrl = communityBaseUrl + "gate/" + artGroupNo + "/apt?refresh=" + System.currentTimeMillis();
        				} else {
        					finalUrl = communityBaseUrl + "main";		// 둘다 null이면 커뮤니티 메인페이지로 이동
        				}
        			}
        			break;
        		case "ATC002":		// 새로운 댓글
        			if(profileNo != null && artGroupNo != null && relatedItemNo != null && relatedItemNo > 0) {
        				// community/{artGroupNo}/profile/{profileNo}
        				// 해시태그와함께 관련코드넘겨서 모달창 바로뜨게 구현
        				finalUrl = communityBaseUrl + artGroupNo + profileBaseUrl +profileNo + "#post-" + relatedItemNo;
        			} else {
        				if(artGroupNo != null) {
        					// 커뮤니티 메인 페이지로 이동할 때 강제 새로고침을 위한 파라미터 추가
        					finalUrl = communityBaseUrl + "gate/" + artGroupNo + "/apt?refresh=" + System.currentTimeMillis();
        				} else {
        					finalUrl = communityBaseUrl + "main";
        				}
        			}
        			break;
        		case "ATC003":		// 새로운 채팅
        			if(relatedItemNo != null && relatedItemNo > 0) {
        				// chatChannelNo가 null이면 CHAT_MESSAGE 테이블에서 조회
        				Integer channelNo = alert.getChatChannelNo();
        				if(channelNo == null) {
        					try {
        						// chatChannelNo 조회
        						channelNo = chatChannelMapper.selectChatChannelNoByChatNo(relatedItemNo);
        						if(channelNo != null) {
        							finalUrl = "javascript:openDmModal('" + channelNo + "')";
        							log.debug("CHAT_MESSAGE에서 chatChannelNo 조회 성공: {}", channelNo);
        						} else {
        							log.warn("CHAT_MESSAGE에서 chatChannelNo 조회 실패. chatNo: {}", relatedItemNo);
        							finalUrl = "javascript:openDmModal()";
        						}
        					} catch (Exception e) {
        						log.error("CHAT_MESSAGE에서 chatChannelNo 조회 중 오류: {}", e.getMessage());
        						finalUrl = "javascript:openDmModal()";
        					}
        				} else {
        					finalUrl = "javascript:openDmModal('" + channelNo + "')";
        				}
        			} else {
        				finalUrl = "javascript:openDmModal()";		// 채널 목록으로 이동
        			}
        			break;
        		case "ATC004":		// 라이브 시작
        			if(relatedItemNo != null && relatedItemNo > 0) {
        				// 라이브 탭으로 이동할 때 강제 새로고침을 위한 파라미터 추가
        				finalUrl = "/community/gate/" + artGroupNo + "/apt?refresh=" + System.currentTimeMillis() + "#liveArea";
        			} else {
        				log.warn("라이브 시작 알림에 LIVE_NO가 NULL.. URL 생성 불가");
        				finalUrl = "/community/gate/" + artGroupNo + "/apt?refresh=" + System.currentTimeMillis();
        			}
        			break;
        		case "ATC006":		// 멤버십
        			if(relatedItemNo != null && relatedItemNo > 0) {
        				finalUrl = membershipBaseUrl;
        			} else {
        				log.warn("멤버십 구독 알림 MBSP_NO가 NULL... URL 생성 불가");
        				finalUrl = "/mypage/alerts";
        			}
        			break;
        		case "ATC007":		// 새로운 콘서트 일정
        			if(profileNo != null && artGroupNo != null && relatedItemNo != null && relatedItemNo > 0) {
        				finalUrl = communityBaseUrl + artGroupNo + profileBaseUrl + profileNo + "/concert/" + relatedItemNo;
        			} else {
        				finalUrl = communityBaseUrl + "concert";		// 프로필 정보 없으면 콘서트로 이동
        			}
        			break;
        		default:
        			// 저장된 URL이 없으면 기본 알림내역 페이지로 이동
        			if(alert.getAlertUrl() != null && !alert.getAlertUrl().isEmpty()) {
        				finalUrl = alert.getAlertUrl();
        			} else {
        				finalUrl = "/mypage/alerts";	// 알림내역 페이지
        			}
        			break;
        	}
        	alert.setAlertUrl(finalUrl);
        	log.debug("alertNo: {}, Type: {}, Final URL: {}", alert.getAlertNo(), alert.getAlertTypeCode(), alert.getAlertUrl());
        }
	}

	@Override
	public int getUnreadAlertCnt(String memUsername) throws Exception {
		log.debug("getUnreadAlertCnt() 실행...! 회원: {}", memUsername);
		return alertMapper.cntUnreadAlerts(memUsername);
	}

	@Override
	@Transactional
	public boolean markAsRead(long alertNo, String memUsername) throws Exception {
		log.debug("markAsRead() 실행...! 알림번호: {}, 회원: {}", alertNo, memUsername);

		Map<String, Object> params = new HashMap<>();
		params.put("alertNo", alertNo);
		params.put("memUsername", memUsername);

		int updateRows = alertMapper.markAsRead(alertNo, memUsername);
		if(updateRows > 0) {
			log.debug("알림 상태 업데이트 성공");
			AlertVO alert = alertMapper.selectAlertById(params);
			if(alert != null && "ITC003".equals(alert.getRelatedItemTypeCode())) {
				messagingTemplate.convertAndSendToUser(memUsername, "/queue/alerts", alert);
				Map<String, Object> modalData = new HashMap<>();
				Integer chatChannelNo = alert.getChatChannelNo();

				// chatChannelNo가 null이면 CHAT_MESSAGE 테이블에서 조회
				if(chatChannelNo == null && alert.getRelatedItemNo() > 0) {
					try {
						chatChannelNo = chatChannelMapper.selectChatChannelNoByChatNo(alert.getRelatedItemNo());
						log.debug("markAsRead에서 CHAT_MESSAGE에서 chatChannelNo 조회: {}", chatChannelNo);
					} catch (Exception e) {
						log.error("markAsRead에서 chatChannelNo 조회 중 오류: {}", e.getMessage());
					}
				}

				if(chatChannelNo != null) {
					modalData.put("channelNo", chatChannelNo);
					modalData.put("channelUrl", contextPath + "chat/dm/channel/enter/" + chatChannelNo);
				}
				messagingTemplate.convertAndSendToUser(memUsername, "/queue/chatModal", modalData);
			}
			return true;
		}

		return false;
	}

	@Override
	@Transactional
	public void markAllAsRead(String memUsername) throws Exception {
		log.debug("markAllAsRead() 실행..! 회원: {}", memUsername);
		alertMapper.markAllAsRead(memUsername);
	}

	@Override
	@Transactional
	public boolean markAsDeleted(long alertNo, String memUsername) throws Exception {
		log.debug("markAsDeleted() 실행..! 알림번호: {}, 회원: {}", alertNo, memUsername);
		int updatedRows = alertMapper.markAsDeleted(alertNo, memUsername);
		return updatedRows > 0;
	}

	@Override
	public Optional<List<AlertSettingVO>> getAlertSettings(String memUsername) throws Exception {
		log.debug("getAlertSettings() 실행..! 회원: {}", memUsername);

		List<AlertSettingVO> savedSettings = alertMapper.selectAlertSettings(memUsername);		// 사용자에 저장된 설정 가져오기
		Map<String, AlertSettingVO> savedSettingsMap = savedSettings.stream()
				.collect(Collectors.toMap(AlertSettingVO::getAlertTypeCode, setting -> setting));

		String alertTypeGroupCode = "ALERT_TYPE_CODE";
		List<CommonCodeDetailVO> allAlertTypes = commonCodeMapper.selectCommonCodeDetails(alertTypeGroupCode);		// 모든 알림유형코드 조회

		List<AlertSettingVO> finalSettings = new ArrayList<>();		// 최종 알림설정 저장할 배열 생성
		Timestamp currentTime = new Timestamp(System.currentTimeMillis());		// 수정시간을 담을 변수 생성

		for(CommonCodeDetailVO alertType : allAlertTypes) {
			String typeCode = alertType.getCommCodeDetNo();

			AlertSettingVO finalSetting = savedSettingsMap.get(typeCode);

			if(finalSetting == null) {
				// 저장된 설정이 없으면 기본값 'Y'로 새로운 설정 생성
				finalSetting = new AlertSettingVO();			// 새로운 알림 설정 생성
				finalSetting.setMemUsername(memUsername);		// 설정할 회원아이디
				finalSetting.setAlertTypeCode(typeCode);		// 타입
				finalSetting.setAlertEnabledYn("Y");			// 사용 여부
				finalSetting.setAlertModDate(currentTime);		// 수정 시간
			}

			finalSetting.setAlertDescription(alertType.getDescription());
			finalSettings.add(finalSetting);
		}

		return Optional.of(finalSettings);
	}

	@Override
	@Transactional
	public void saveAlertSettings(List<AlertSettingVO> settings, String memUsername) throws Exception {
		log.debug("saveAlertSettings() 실행..! 알림 설정: {}, 회원: {}", settings, memUsername);
		// 개별 알림 설정
		if(settings == null || settings.isEmpty()) {
			log.warn("저장할 알림 설정이 없습니다.");
			return;
		}
		for(AlertSettingVO setting: settings) {

			setting.setMemUsername(memUsername);

			int updateRows = alertMapper.insertAlertSetting(setting);

			if(updateRows > 0) {
				log.info("알림 설정 저장/업데이트 성공!! , 타입 - {}, 회원 - {}", setting.getAlertTypeCode(), memUsername);
			} else {
				log.warn("알림 설정 저장/업데이트 실패..,  타입 - {}, 회원 - {}", setting.getAlertTypeCode(), memUsername);
			}
		}
		log.info("알림 설정 처리 완료. 총 {} 개 설정 처리 완료.", settings.size());
	}

	@Override
	@Transactional
	public List<AlertSettingVO> createDefalutAlertForUser(String username) throws Exception {
		log.info("createDefalutAlertForUser() 실행...! 회원: {}", username);

		List<AlertSettingVO> settingsToSave = getAlertSettings(username).orElse(Collections.emptyList());		// Optional비어있으면 빈 리스트

		//
		saveAlertSettings(settingsToSave, username);
		return settingsToSave;
	}

	@Override
	public LiveVO getCurrentLiveByArtGroupNo(Integer artGroupNo) {
		log.info("getCurrentLiveByArtGroupNo() 실행...! 아티스트 그룹번호: {}", artGroupNo);
		return communityMainPageMapper.getLiveBroadcastInfo(artGroupNo);
	}

	@Override
	public int getAlertTotalCount(PaginationInfoVO<AlertVO> pagingVO) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("memUsername", pagingVO.getMemUsername());
		params.put("artGroupNo", pagingVO.getArtGroupNo());
		return alertMapper.getTotalAlertCount(params);
	}
}
