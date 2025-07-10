package kr.or.ddit.ddtown.service.kakaopay;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import kr.or.ddit.dto.kakaopay.ApproveRequest;
import kr.or.ddit.dto.kakaopay.CancelRequest;
import kr.or.ddit.dto.kakaopay.KakaoPayApproveResponseDTO;
import kr.or.ddit.dto.kakaopay.KakaoPayCancelResponseDTO;
import kr.or.ddit.dto.kakaopay.KakaoPayReadyResponseDTO;
import kr.or.ddit.dto.kakaopay.ReadyRequest;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class KakaoPayServiceImpl implements IKakaoPayService {

	@Value("${cid}") // cid는 샘플에서 그대로 사용하므로 이렇게 주입
	private String cid;
	@Value("${kakaopay.api.secret.key}") // application.properties에서 변경된 키 이름
	private String kakaopaySecretKey; // 샘플과 동일한 변수명 사용

	@Value("${kakaopay.ready_url}")
	private String readyApiUrl;
	@Value("${kakaopay.approve_url}")
	private String approveApiUrl;

	@Value("${kakaopay.sample.host}") // 콜백 URL에 사용할 호스트 정보
	private String sampleHost;

	@Value("${kakaopay.cancel_url}")
	private String cancelApiUrl;

    @Value("${kakaopay.inquiry-api-url}")
    private String inquiryApiUrl;

	@Override
	public Map<String, String> kakaoPayReady(
			String goodsName,
			Integer totalAmount,
			Integer totalQuantity,
			String username,
			String partnerOrderId
			) throws Exception {
		log.info("kakaoPayReady() 호출 - goodsName: {}, totalAmount: {}, username: {}, partnerOrderId: {}", goodsName,
				totalAmount, username, partnerOrderId);

	    log.info("### KAKAOPAY SECRET KEY: [{}]", kakaopaySecretKey);
	    log.info("### KAKAOPAY SECRET KEY Length: {}", kakaopaySecretKey.length());

	    try {
			RestTemplate restTemplate = new RestTemplate();

			HttpHeaders headers = new HttpHeaders();
			headers.add("Authorization", "DEV_SECRET_KEY " + kakaopaySecretKey.trim());
			headers.setContentType(MediaType.APPLICATION_JSON);

            Integer vatAmountForRequest = 0;

            ReadyRequest readyRequest = ReadyRequest.builder()
                .cid(cid)
                .partnerOrderId(partnerOrderId)
                .partnerUserId(username)
                .itemName(goodsName)
                .quantity(totalQuantity)
                .totalAmount(totalAmount)
                .taxFreeAmount(0) // 0으로 고정
                .vatAmount(vatAmountForRequest) // 계산된 vatAmount 사용
                .approvalUrl(String.format(sampleHost + "/goods/order/kakaoPaySuccess?orderNo=%s", partnerOrderId))
                .cancelUrl(String.format(sampleHost + "/goods/order/kakaoPayCancel?orderNo=%s", partnerOrderId))
                .failUrl(String.format(sampleHost + "/goods/order/kakaoPayFail?orderNo=%s", partnerOrderId))
                .build();

			// *** HttpEntity에 ReadyRequest 객체를 담아 보냅니다. ***
			HttpEntity<ReadyRequest> requestEntity = new HttpEntity<>(readyRequest, headers);

			ResponseEntity<KakaoPayReadyResponseDTO> response = restTemplate.postForEntity(readyApiUrl, requestEntity,
					KakaoPayReadyResponseDTO.class);

			if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
				KakaoPayReadyResponseDTO readyResponse = response.getBody();
				log.info("카카오페이 Ready API 호출 성공: {}", readyResponse);

				Map<String, String> resultMap = new HashMap<>();
				resultMap.put("tid", readyResponse.getTid());
				resultMap.put("next_redirect_pc_url", readyResponse.getNext_redirect_pc_url());

				return resultMap;
			} else {
				log.error("카카오페이 Ready API 호출 실패. 상태 코드: {}", response.getStatusCode());
				throw new RuntimeException("카카오페이 결제 준비 실패: API 응답 오류");
			}

		} catch (HttpClientErrorException e) {
			log.error("카카오페이 Ready API HTTP 오류: {} - {}", e.getStatusCode(), e.getResponseBodyAsString(), e);
			// 서버에서 반환한 오류 본문이 있다면 여기서 출력하여 확인 (e.getResponseBodyAsString())
			throw new RuntimeException("카카오페이 결제 준비 실패 (HTTP 에러): " + e.getResponseBodyAsString());
		} catch (Exception e) {
			log.error("카카오페이 Ready API 호출 중 예외 발생: {}", e.getMessage(), e);
			throw e;
		}
	}

    @Override
    public String getCid() {
        return this.cid;
    }

    @Override
    public KakaoPayApproveResponseDTO kakaoPayApprove(
            String tid,
            String partnerOrderId,
            String partnerUserId,
            String pgToken
            ) throws Exception {
        log.info("kakaoPayApprove() 호출 - tid: {}, partnerOrderId: {}, partnerUserId: {}, pgToken: {}", tid,
                partnerOrderId, partnerUserId, pgToken);

        try {
            RestTemplate restTemplate = new RestTemplate();

            HttpHeaders headers = new HttpHeaders();
            headers.add("Authorization", "SECRET_KEY " + kakaopaySecretKey.trim());
            headers.setContentType(MediaType.APPLICATION_JSON);

            ApproveRequest approveRequest = ApproveRequest.builder()
                .cid(cid)
                .tid(tid)
                .partnerOrderId(partnerOrderId)
                .partnerUserId(partnerUserId)
                .pgToken(pgToken)
                .build();

            HttpEntity<ApproveRequest> requestEntity = new HttpEntity<>(approveRequest, headers);

			ResponseEntity<KakaoPayApproveResponseDTO> response = restTemplate.postForEntity(approveApiUrl,
					requestEntity, KakaoPayApproveResponseDTO.class
			);

			if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
				KakaoPayApproveResponseDTO approveResponse = response.getBody();
				log.info("카카오페이 Approve API 호출 성공: {}", approveResponse);
				return approveResponse;
			} else {
				log.error("카카오페이 Approve API 호출 실패. 상태 코드: {}", response.getStatusCode());
				throw new RuntimeException("카카오페이 결제 승인 실패: API 응답 오류");
			}

		} catch (HttpClientErrorException e) {
			log.error("카카오페이 Approve API HTTP 오류: {} - {}", e.getStatusCode(), e.getResponseBodyAsString(), e);
			throw new RuntimeException("카카오페이 결제 승인 실패 (HTTP 에러): " + e.getResponseBodyAsString());
		} catch (Exception e) {
			log.error("카카오페이 Approve API 호출 중 예외 발생: {}", e.getMessage(), e);
			throw e;
		}
    }

    @Override
    public KakaoPayCancelResponseDTO kakaoPayCancel(CancelRequest cancelRequest) {
        log.info("kakaoPayCancel() 호출 - CancelRequest: {}", cancelRequest);

        try {
            RestTemplate restTemplate = new RestTemplate();

            HttpHeaders headers = new HttpHeaders();
            headers.add("Authorization", "SECRET_KEY " + kakaopaySecretKey.trim());
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<CancelRequest> requestEntity = new HttpEntity<>(cancelRequest, headers);

            ResponseEntity<KakaoPayCancelResponseDTO> response = restTemplate.postForEntity(
                cancelApiUrl,
                requestEntity,
                KakaoPayCancelResponseDTO.class
            );

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                KakaoPayCancelResponseDTO cancelResponse = response.getBody();
                log.info("카카오페이 Cancel API 호출 성공: {}", cancelResponse);
                return cancelResponse;
            } else {
                log.error("카카오페이 Cancel API 호출 실패. 상태 코드: {}", response.getStatusCode());
                throw new RuntimeException("카카오페이 결제 취소 실패: API 응답 오류. 상태 코드: " + response.getStatusCode());
            }

        } catch (HttpClientErrorException e) {
            log.error("카카오페이 Cancel API HTTP 오류: {} - {}", e.getStatusCode(), e.getResponseBodyAsString(), e);
            throw new RuntimeException("카카오페이 결제 취소 실패 (HTTP 에러): " + e.getResponseBodyAsString(), e);
        } catch (Exception e) {
            log.error("카카오페이 Cancel API 호출 중 예외 발생: {}", e.getMessage(), e);
            throw new RuntimeException("카카오페이 취소 서비스 오류 발생", e);
        }
    }

}