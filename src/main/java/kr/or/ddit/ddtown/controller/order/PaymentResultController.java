package kr.or.ddit.ddtown.controller.order; // 패키지명 변경 고려

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.security.web.authentication.preauth.PreAuthenticatedAuthenticationToken;
import org.springframework.stereotype.Controller; // ★★★ @Controller 사용! ★★★
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model; // Model 객체를 사용하여 JSP로 데이터 전달
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.ddtown.service.auth.IUserService;
import kr.or.ddit.ddtown.service.chat.dm.IChatChannelService;
import kr.or.ddit.ddtown.service.community.ICommunityProfileService;
import kr.or.ddit.ddtown.service.concert.IConcertService;
import kr.or.ddit.ddtown.service.goods.cart.ICartService;
import kr.or.ddit.ddtown.service.goods.order.IOrderService;
import kr.or.ddit.ddtown.service.kakaopay.IKakaoPayService;
import kr.or.ddit.ddtown.service.member.membership.IMembershipService;
import kr.or.ddit.dto.kakaopay.KakaoPayApproveResponseDTO;
import kr.or.ddit.vo.chat.dm.ParticipantsVO;
import kr.or.ddit.vo.community.CommunityProfileVO;
import kr.or.ddit.vo.concert.TicketVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.member.membership.MembershipSubscriptionsVO;
import kr.or.ddit.vo.order.OrderDetailVO;
import kr.or.ddit.vo.order.OrdersVO;
import kr.or.ddit.vo.order.PaymentVO;
import kr.or.ddit.vo.security.CustomOAuth2User;
import kr.or.ddit.vo.security.CustomUser;
import kr.or.ddit.vo.user.MemberVO;
import kr.or.ddit.vo.user.PeopleAuthVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/goods/order")
public class PaymentResultController {

    @Autowired
    private IKakaoPayService kakaoPayService;

    @Autowired
    private IOrderService orderService;

    @Autowired
    private ICartService cartService;

    @Autowired
    private IMembershipService membershipService;

    @Autowired
    private IUserService userService;

    @Autowired
    private IChatChannelService channelService;

    @Autowired
    private ICommunityProfileService profileService;

    @Autowired
    private IConcertService concertService;

    /**
     * 카카오페이 결제 성공 후 호출되는 콜백 URL을 처리합니다.
     * (카카오페이에서 GET 요청으로 리다이렉트)
     */
    @GetMapping("/kakaoPaySuccess")
    @Transactional
    public String kakaoPaySuccess(
            @RequestParam("pg_token") String pgToken,
            @RequestParam("orderNo") int orderNo,
            @AuthenticationPrincipal Object principal,
            Model model // JSP로 데이터를 전달하기 위해 Model 추가
            ) {
        log.info("kakaoPaySuccess() 호출! pg_token: {}, orderNo: {}", pgToken, orderNo);

        MemberVO authMember = getAuthMember(principal);

        String username = null;

        if (authMember == null || authMember.getMemUsername() == null || authMember.getMemUsername().isEmpty()) {
            return "redirect:/login?error=auth_required";
        }
        username = authMember.getMemUsername();

        OrdersVO order = null;
        PaymentVO paymentReadyInfo = null;
        List<OrderDetailVO> orderDetails = null;

        try {
            order = orderService.getOrderByOrderNo(orderNo);
            paymentReadyInfo = orderService.getPaymentReadyInfoByOrderNo(orderNo);

            if (order == null || paymentReadyInfo == null || paymentReadyInfo.getTid() == null) {
                log.error("유효하지 않은 주문 또는 결제 준비 정보. orderNo: {}", orderNo);
                return "redirect:/goods/paymentFail?reason=invalid_order_info";
            }

            if (!username.equals(order.getMemUsername())) {
                log.warn("결제 승인 시도 유저 불일치. Current: {}, Order: {}", username, order.getMemUsername());
                return "redirect:/goods/paymentFail?reason=user_mismatch";
            }

            // 멤버십 구독 확인 로직 추가
            if("OTC001".equals(order.getOrderTypeCode())) {
            	OrderDetailVO membershipOrderDetail = null;
            	if(orderDetails == null || orderDetails.isEmpty()) {
            		orderDetails = orderService.getOrderDetailsByOrderNo(orderNo);
            	}
            	if(orderDetails != null && !orderDetails.isEmpty()) {
            		membershipOrderDetail = orderDetails.get(0);
            	}
            	if(membershipOrderDetail != null) {
            		goodsVO membershipGoods = orderService.getGoodsByGoodsNo(membershipOrderDetail.getGoodsNo());
            		if(membershipGoods != null) {
            			boolean existingMembership =
            					membershipService.hasValidMembershipSubscription(username, membershipGoods.getArtGroupNo());

            			if(existingMembership) {
            				log.warn("사용자 {}는 이미 아티스트 그룹 {}에 대한 멤버을 가지고 있습니다. 추가 결제를 중단합니다.", username, membershipGoods.getArtGroupNo());
            				return "redirect:/goods/order/paymentFail?orderNo=" + orderNo + "&reason=already_subscribed";
            			}
            		}
            	}
            }

            String tid = paymentReadyInfo.getTid();
            String partnerOrderId = String.valueOf(order.getOrderNo());
            String partnerUserId = order.getMemUsername();

            KakaoPayApproveResponseDTO approveResponse = kakaoPayService.kakaoPayApprove(
                    tid,
                    partnerOrderId,
                    partnerUserId,
                    pgToken
            );

            order.setOrderStatCode("OSC001");

            String approvedAtString = approveResponse.getApproved_at();
            if (approvedAtString != null && !approvedAtString.isEmpty()) {
                try {
                    DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
                    LocalDateTime localDateTime = LocalDateTime.parse(approvedAtString, formatter);

                    order.setOrderPayDt(java.util.Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant()));
                    paymentReadyInfo.setCompletedAt(java.sql.Timestamp.valueOf(localDateTime));

                } catch (DateTimeParseException e) {
                    log.error("approved_at 날짜 파싱 오류: {} - {}", approvedAtString, e.getMessage());
                    throw new RuntimeException("결제 승인 시각 파싱 오류", e);
                }
            }
            orderService.updateOrder(order);

            paymentReadyInfo.setPaymentStatCode("PSC001");

            if (approveResponse.getAmount() != null) {
                paymentReadyInfo.setTotalAmount(approveResponse.getAmount().getTotal());
            } else {
                log.warn("카카오페이 Approve 응답에 Amount 정보가 없습니다. orderNo: {}", orderNo);
                paymentReadyInfo.setTotalAmount(0);
            }

            paymentReadyInfo.setAid(approveResponse.getAid());
            orderService.updatePaymentInfo(paymentReadyInfo);

            orderDetails = orderService.getOrderDetailsByOrderNo(orderNo);

            if (orderDetails == null || orderDetails.isEmpty()) {
                log.error("kakaoPaySuccess() - orderNo {}에 대한 주문 상세 정보를 찾을 수 없어 장바구니 후처리 불가.", orderNo);
                throw new RuntimeException("결제된 상품의 상세 정보 조회에 실패했습니다.");
            }

            boolean isFromCart = "Y".equals(order.getOrderFromCart());
            log.info("kakaoPaySuccess - isFromCart (DB에서 조회): {}", isFromCart);

            cartService.processCartAfterPayment(username, orderDetails, isFromCart);

            // *** 콘서트 티켓 결제 후 처리 로직 시작 ***
            if("OTC003".equals(order.getOrderTypeCode())) {
            	log.info("콘서트 티켓 결제 감지. 티켓 상태 업데이트 시작");
            	for(OrderDetailVO detail : orderDetails) {
            		int ticketNo = detail.getGoodsOptNo();

            		if(ticketNo == 0) {
            			log.error("OrderDetail에서 ticketNo를 찾을 수 없습니다.");
            			throw new RuntimeException("티켓 번호를 찾을 수 없어 콘서트 티켓 처리에 실패했습니다.");
            		}

            		TicketVO ticketToUpdate = new TicketVO();
            		ticketToUpdate.setTicketNo(ticketNo);
            		ticketToUpdate.setMemUsername(username);
            		ticketToUpdate.setOrderDetNo(detail.getOrderDetNo());

            		concertService.updateTicketReservation(ticketToUpdate);

            		log.info("콘서트 티켓 {}의 예매가 완료되었습니다. 예매자: {}, 주문상세번호: {}", ticketNo, username, detail.getOrderDetNo());
            	}
            	log.info("콘서트 티켓 상태 업데이트 완료");
            }

            // --- *** 멤버십 구독 정보 저장 로직 *** ---
            if("OTC001".equals(order.getOrderTypeCode())) {
            	log.info("멤버십 상품 결제 감지. 멤버십 구독 정보 생성 및 권한/채팅 참가자 추가 시작.");

            	OrderDetailVO memberhsipOrderDetail = null;
            	if(orderDetails != null && !orderDetails.isEmpty()) {
            		memberhsipOrderDetail = orderDetails.get(0);
            	}

            	// 멤버십 구독 정보 저장
            	if(memberhsipOrderDetail != null) {
            		goodsVO membershipGoods = orderService.getGoodsByGoodsNo(memberhsipOrderDetail.getGoodsNo());

            		// "CMCC002"로 변경
            		if(membershipGoods != null) {
            			CommunityProfileVO existingComuProfile = profileService.getCommunityProfile(username, membershipGoods.getArtGroupNo());

            			if(existingComuProfile == null) {
            				log.warn("경고: 사용자 {}의 ART_GROUP_NO {} 커뮤니티 프로필이 존재하지 않습니다.",
                                    username, membershipGoods.getArtGroupNo());
            			} else if(!"CMCC002".equals(existingComuProfile.getComuMemCatCode())) {
            				existingComuProfile.setComuMemCatCode("CMCC002");
            				profileService.updateCommunityProfile(existingComuProfile);
            				log.info("사용자 {}의 ART_GROUP_NO {} 커뮤니티 프로필이 멤버십 회원으로 업데이트 되었습니다."
            						, username, membershipGoods.getArtGroupNo());
            			} else {
            				log.info("사용자는 이미 멤버십 커뮤니티 프로필을 가지고 있습니다.");
            			}
            		}
            		MembershipSubscriptionsVO subscription = new MembershipSubscriptionsVO();
            		int sub = membershipService.getMbspNo(membershipGoods.getArtGroupNo());
            		subscription.setMemUsername(username);
            		subscription.setMbspNo(sub);
            		subscription.setOrderDetNo(memberhsipOrderDetail.getOrderDetNo());
            		subscription.setMbspSubStatCode("MSSC001");	// 활성 상태

            		LocalDateTime now = LocalDateTime.now();
            		subscription.setMbspSubStartDate(now);
            		subscription.setMbspSubEndDate(now.plusMonths(1));	// 1개월 구독 가정
            		subscription.setMbspSubModDate(now);

            		subscription.setMbspCid(paymentReadyInfo.getCid());
            		membershipService.insertMembershipSub(subscription);

            		// 멤버십 권한 추가
            		PeopleAuthVO existingAuth = userService.getPeopleAuth(username, "ROLE_MEMBERSHIP");
            		if(existingAuth == null) {
            			PeopleAuthVO peopleAuth = new PeopleAuthVO();
            			peopleAuth.setUsername(username);
            			peopleAuth.setAuth("ROLE_MEMBERSHIP");
            			userService.insertPeopleAuth(peopleAuth);

            			// 추가된 권한 세션에 갱신
            			Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            			Set<GrantedAuthority> authorities = new HashSet<>(authentication.getAuthorities());
            			authorities.add(new SimpleGrantedAuthority("ROLE_MEMBERSHIP"));
            			Authentication newAuthentication = new PreAuthenticatedAuthenticationToken(
            					authentication.getPrincipal()
            					, authentication.getCredentials()
            					, authorities);
            			if(authentication.getDetails() instanceof WebAuthenticationDetails authenticationDetails) {
            				WebAuthenticationDetails details = authenticationDetails;
            				((PreAuthenticatedAuthenticationToken)newAuthentication).setDetails(details);
            			}
            			SecurityContextHolder.getContext().setAuthentication(newAuthentication);
            			// 갱신 끝
            			log.info("사용자 {}에게 멤버십 권한이 성공적으로 부여되었습니다.", username);
            		} else {
            			log.info("사용자 {}는 이미 멤버십 권한을 가지고 있습니다.", username);
            		}

            		// 참가자 정보 추가
            		// 아티스트 그룹에 있는 아티스트 조회
            		List<MemberVO> artistsInGroup = userService.getArtistsNo(membershipGoods.getArtGroupNo());
            		if(artistsInGroup != null && !artistsInGroup.isEmpty()) {
            			for(MemberVO artist : artistsInGroup) {
            				// 아티스트 해당 채널 번호 가져오기
            				int artistChannel = channelService.getChatChannelNo(artist.getMemUsername());
            				if(artistChannel != 0) {
            					if(!channelService.isParticipant(artistChannel, username)) {
            						ParticipantsVO participant = new ParticipantsVO();
            						participant.setChatChannelNo(artistChannel);
            						participant.setMemUsername(username);
            						participant.setPaciRoleCode("PRC002");
            						participant.setPaciJoinDate(new Date());

            						channelService.insertParticipant(participant);

            						log.info("사용자 {}가 아티스트 {}와의 채팅방 {}에 참가자로 추가되었습니다.", username, artist.getMemUsername(), artistChannel);
            					} else {
            						log.info("사용자 {}는 채팅방 {}에 참가자로 등록되어 있습니다.", username, artistChannel);
            					}
            				} else {
            					log.warn("아티스트 {}의 채팅 채널을 찾을 수 없습니다.", artist);
            				}
            			}
            		}

            		log.info("멤버십 구독 정보가 성공적으로 저장되었습니다.");
            	} else {
            		log.warn("멤버십 상품에 대한 주문 상세 정보를 찾을 수 없습니다. orderNo: {}", orderNo);
            	}
            }

            String orderNm = order.getOrderNm();
            log.info("orderNm : {}", orderNm);
            // 최종적으로 JSP로 전달할 데이터를 Model에 담습니다.
            model.addAttribute("orderNo", orderNo);
            model.addAttribute("orderNm", orderNm);
            model.addAttribute("amount", approveResponse.getAmount().getTotal());

            // 멤버십 결제 시, 추가 메세지 및 구독 만료일 정보 전달
            if ("OTC001".equals(order.getOrderTypeCode())) {
                model.addAttribute("membershipMessage", "DDTOWN 아티스트 멤버십 구독이 완료되었습니다!");
                // 구독 만료일을 'YYYY년 MM월 DD일' 형식으로 포맷하여 전달
                model.addAttribute("subscriptionEndDate", LocalDateTime.now().plusMonths(1).format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일")));
            }


            // JSP 파일의 직접 경로를 반환합니다. ViewResolver가 처리합니다.
            return "goods/payment/paymentSuccess"; // ★★★ 리다이렉트 대신 JSP 경로 직접 반환 ★★★

        } catch (Exception e) {
            log.error("카카오페이 결제 승인 중 오류 발생: {}", e.getMessage(), e);
            try {
                orderService.updateOrderStatus(orderNo, "OSC002");

                if (paymentReadyInfo != null) {
                    paymentReadyInfo.setPaymentStatCode("PSC002");
                    orderService.updatePaymentStatus(orderNo, paymentReadyInfo.getPaymentStatCode());
                } else {
                    PaymentVO failedPaymentInfo = orderService.getPaymentReadyInfoByOrderNo(orderNo);
                    if(failedPaymentInfo != null) {
                        failedPaymentInfo.setPaymentStatCode("PSC002");
                        orderService.updatePaymentStatus(orderNo, failedPaymentInfo.getPaymentStatCode());
                    } else {
                        log.warn("결제 실패 시 paymentReadyInfo 조회 실패. orderNo: {}", orderNo);
                    }
                }
            } catch (Exception rollbackE) {
                log.error("결제 실패 후 주문/결제 상태 업데이트 중 롤백 오류 발생: {}", orderNo, rollbackE.getMessage());
            }
            return "redirect:/goods/order/paymentFail?reason=payment_error";
        }
    }

    @GetMapping("/kakaoPayCancel")
    public String kakaoPayCancel(
            @RequestParam("orderNo") int orderNo,
            @AuthenticationPrincipal Object principal
            ) {
        log.info("kakaoPayCancel() 호출! 사용자가 결제를 취소했습니다. orderNo: {}", orderNo);

        try {
            orderService.updateOrderStatus(orderNo, "OSC008");
            orderService.updatePaymentStatus(orderNo, "PSC003");
        } catch (Exception e) {
            log.error("주문 {} 상태 업데이트 중 롤백 오류 발생: {}", orderNo, e.getMessage());
        }
        return "redirect:/goods/payment/paymentCancel?orderNo=" + orderNo;
    }

    @GetMapping("/kakaoPayFail")
    public String kakaoPayFail(
            @RequestParam("orderNo") int orderNo,
            @AuthenticationPrincipal Object principal
            ) {
        log.info("kakaoPayFail() 호출! 결제에 실패했습니다. orderNo: {}", orderNo);

        try {
            orderService.updateOrderStatus(orderNo, "OSC002");
            orderService.updatePaymentStatus(orderNo, "PSC002");
        } catch (Exception e) {
            log.error("주문 {} 상태 업데이트 중 롤백 오류 발생: {}", orderNo, e.getMessage());
        }
        return "redirect:/goods/payment/paymentFail?orderNo=" + orderNo;
    }

    @GetMapping("/paymentFail")
    public String renderPaymentFailPage(
            @RequestParam(value = "orderNo", required = false) Integer orderNo, // orderNo는 없어도 되도록 required = false
            @RequestParam(value = "reason", required = false) String reason,   // reason은 없어도 되도록 required = false
            Model model
            ) {
        log.info("renderPaymentFailPage() 호출됨! reason: {}, orderNo: {}", reason, orderNo);

        // JSP로 전달할 데이터를 Model에 담습니다.
        model.addAttribute("reason", reason);
        if (orderNo != null) {
            model.addAttribute("orderNo", orderNo);
        }

        return "goods/payment/paymentFail";
    }

    private MemberVO getAuthMember(Object principal) {
    	MemberVO authMember = null;
    	if (principal instanceof CustomUser customUser) {
            authMember = customUser.getMemberVO();
        } else if (principal instanceof CustomOAuth2User auth2User) {
            authMember = auth2User.getMemberVO();
        }
    	return authMember;
    }
}