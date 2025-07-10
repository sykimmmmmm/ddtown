package kr.or.ddit.ddtown.service.kakaopay;

import java.util.Map;

import kr.or.ddit.dto.kakaopay.CancelRequest;
import kr.or.ddit.dto.kakaopay.KakaoPayApproveResponseDTO;
import kr.or.ddit.dto.kakaopay.KakaoPayCancelResponseDTO;

public interface IKakaoPayService {

	//카카오페이 ready API 호출
	public Map<String, String> kakaoPayReady(String goodsName, Integer totalAmount, Integer totalQuantity, String username,
			String valueOf) throws Exception;

	//가맹점 번호 가져오기
	public String getCid();

	public KakaoPayApproveResponseDTO kakaoPayApprove(String tid, String partnerOrderId, String partnerUserId, String pgToken)
			throws Exception;

	/**
     * 카카오페이 결제를 취소합니다.
     * @param tid 카카오페이 거래 고유 번호
     * @param cancelAmount 취소할 금액
     * @return 취소 결과 (성공/실패 여부 및 상세 정보)
     */
	// !!!! 이 부분을 아래와 같이 변경 !!!
    public KakaoPayCancelResponseDTO kakaoPayCancel(CancelRequest cancelRequest); // CancelRequest를 받고 DTO 반환

}
