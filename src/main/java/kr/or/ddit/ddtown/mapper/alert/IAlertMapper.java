package kr.or.ddit.ddtown.mapper.alert;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.alert.AlertReceiverVO;
import kr.or.ddit.vo.alert.AlertSettingVO;
import kr.or.ddit.vo.alert.AlertVO;

@Mapper
public interface IAlertMapper {

	public List<String> getATCs();

	// 알림 설정 저장
	public void insertSetting(AlertSettingVO alertSettingVO);

	// 알림 설정 저장2
	public int insertAlertSetting(AlertSettingVO alertSettingVO);

	// 알림 저장
	public int insertAlert(AlertVO alert);

	// 알림 수신자 정보 저장
	public int insertAlertReceiver(AlertReceiverVO receiver);

	// 특정 회원의 알림 목록 조회
	public List<AlertVO> selectAlertsByUsername(Map<String, Object> params);

	// 특정 회원의 전체 알림 개수 조회
	public int getTotalAlertCount(Map<String, Object> params);

	// 특정 회원의 안읽은 알림 개수조회 ( 탭바에 넣는용 )
	public int cntUnreadAlerts(@Param("memUsername") String memUsername);

	// 알림 읽음 처리
	public int markAsRead(@Param("alertNo") long alertNo, @Param("memUsername") String memUsername);

	// 특정 회원의 모든 알림 읽음처리용
	public int markAllAsRead(@Param("memUsername") String memUsername);

	// 알림 삭제 처리
	public int markAsDeleted(@Param("alertNo") long alertNo, @Param("memUsername") String memUsername);

	// 사용자 알림 설정 조회
	public List<AlertSettingVO> selectAlertSettings(@Param("memUsername") String memUsername);

	// 회원의 알림 설정 조회용
	public List<String> selectAllAlertTypeCodes(@Param("commCodeGrpNo") String commCodeGrpNo);

	// 특정 알림 조회
	public AlertVO selectAlertById(Map<String, Object> pararms);
}
