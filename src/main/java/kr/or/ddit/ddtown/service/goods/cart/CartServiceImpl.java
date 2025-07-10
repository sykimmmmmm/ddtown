package kr.or.ddit.ddtown.service.goods.cart;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ddtown.mapper.goods.IGoodsCartMapper;
import kr.or.ddit.ddtown.mapper.goods.IGoodsMapper;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.goods.GoodsCartVO;
import kr.or.ddit.vo.goods.goodsOptionVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.order.OrderDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CartServiceImpl implements ICartService {

	@Autowired
	private IGoodsMapper goodsMapper;

	@Autowired
	private IGoodsCartMapper cartMapper;

	@Autowired
	private IFileService fileService;

	@Override
	public List<GoodsCartVO> getCartItemsUsername(String userId) {
		log.info("서비스 계층!!!! getCartItemsUsername 호출 - userId: {}", userId);

		List<GoodsCartVO> cartItems = cartMapper.selectCartItemsUsername(userId);

		if(cartItems != null && !cartItems.isEmpty()) {
			for (GoodsCartVO items: cartItems) {
				goodsVO goods = goodsMapper.getGoodsDetail(items.getGoodsNo());

				if(goods != null) {
					items.setGoodsNm(goods.getGoodsNm());
					items.setGoodsPrice(goods.getGoodsPrice());

	                // 1. 대표 이미지 정보 설정
	                // goodsVO에서 fileGroupNo를 가져오므로, cartItem이 아닌 goods에서 fileGroupNo를 사용
					  if (goods.getFileGroupNo() != null && goods.getFileGroupNo() > 0) {
	                    try {
	                        AttachmentFileDetailVO representativeFile = fileService.getRepresentativeFileByGroupNo(goods.getFileGroupNo());

	                        if (representativeFile != null && representativeFile.getWebPath() != null && !representativeFile.getWebPath().isEmpty()) {
	                            items.setRepresentativeImageUrl(representativeFile.getWebPath());
	                            log.debug("장바구니 - 상품 번호 {} 대표 이미지 경로: {}", items.getGoodsNo(), representativeFile.getWebPath());
	                        } else {
	                            // 대표 이미지를 못 찾았거나 웹 경로가 없는 경우
	                            items.setRepresentativeImageUrl(null);
	                            log.warn("장바구니 - 상품 번호 {} (fileGroupNo: {})에 대한 대표 이미지를 찾을 수 없거나 웹 경로가 없습니다.", items.getGoodsNo(), goods.getFileGroupNo());
	                        }
	                    } catch (Exception e) {
	                        log.error("장바구니 - 상품 번호 {}의 대표 이미지 조회 중 오류발생!: {}", items.getGoodsNo(), e.getMessage());
	                        items.setRepresentativeImageUrl(null);
	                    }
	                } else {
	                    // fileGroupNo가 없거나 유효하지 않은 경우
	                    items.setRepresentativeImageUrl(null);
	                    log.info("장바구니 - 상품 번호 {}에는 유효한 파일 그룹 번호가 없습니다.", items.getGoodsNo());
	                }

	                String currentDbGoodsStatCode = null;
	                if (goods.getGoodsStatCode() != null) {
	                    currentDbGoodsStatCode = goods.getGoodsStatCode();
	                }

	                if (currentDbGoodsStatCode != null) {
	                    if ("GSC001".equalsIgnoreCase(currentDbGoodsStatCode)) { // DB 'GSC001'은 'IN_STOCK'에 해당
	                        items.setGoodsStatCode("IN_STOCK");
	                    } else if ("GSC002".equalsIgnoreCase(currentDbGoodsStatCode)) { // DB 'GSC002'는 'SOLD_OUT'에 해당
	                        items.setGoodsStatCode("SOLD_OUT");
	                    } else {
	                        // 정의되지 않은 상태 코드에 대한 처리
	                        items.setGoodsStatCode("UNKNOWN"); // 또는 기본값 설정
	                    }
	                } else {
	                    // goods.getGoodsStatCode() 자체가 null인 경우
	                    items.setGoodsStatCode("UNKNOWN"); // 또는 "IN_STOCK" 등 기본값
	                }
	                log.info("장바구니 항목 - 상품 번호 {}: DB 상태 코드 '{}' -> GoodsCartVO.goodsStatCode '{}'",
	                         items.getGoodsNo(), currentDbGoodsStatCode, items.getGoodsStatCode());
	            } else {
	                items.setGoodsStatCode("UNAVAILABLE");
	                log.warn("장바구니 상품 번호 {}에 해당하는 상품 정보를 찾을 수 없습니다. 상태를 'UNAVAILABLE'로 설정합니다.", items.getGoodsNo());
	            }


				//상품 옵션 정보 조회
				if(items.getGoodsOptNo() > 0) {
					//옵션이 선택된 경우에만
					goodsOptionVO option = goodsMapper.getOptionDetail(items.getGoodsOptNo());

					if (option != null) {
						items.setGoodsOptNm(option.getGoodsOptNm());
						items.setGoodsOptPrice(option.getGoodsOptPrice());
					}
				}

				//총 상품 금액 계산 (개별 상품 기준)
				int unitPrice = (goods != null ? goods.getGoodsPrice(): 0);
				items.setCartTotalAmount(unitPrice * items.getCartQty()); //총 금액
			}
		} else {
			log.warn("사용자 {}의 장바구니에 상품이 없습니다!!", userId);
			return new ArrayList<>();
		}
		return cartItems;
	}

	@Override
	public void addOrUpdateCartItem(GoodsCartVO cart) {
		log.info("서비스 계층 addOrUpdateCartItem 호출!!! - cart: {}", cart);

		GoodsCartVO existingCartItem = cartMapper.selectCartItem(cart);

		//상품의 단가 미리 계산!
		goodsVO goods = goodsMapper.getGoodsDetail(cart.getGoodsNo());
		int goodsPrice = (goods != null) ? goods.getGoodsPrice(): 0;

		//총 금액
		int unitPrice = goodsPrice;

		if(existingCartItem != null) {
			//이미 존재하는 경우: 수량 및 총 금액 업데이트
			int newQty = existingCartItem.getCartQty() + cart.getCartQty();
			existingCartItem.setCartQty(newQty);
			existingCartItem.setCartTotalAmount(unitPrice * newQty);

			cartMapper.updateCartItemQuantity(existingCartItem);
			log.info("장바구니 상품 수량 업뎃 완료!!: {}", existingCartItem);
		} else {
			//3.존재하지 않는 경우: 새로운 항목으로 추가!
			cart.setCartTotalAmount(unitPrice * cart.getCartQty()); //새로 추가하는 상품 총 금액
			cartMapper.insertCartItem(cart);
			log.info("장바구니에 새로운 상품 추가 완료!!: {}", cart);
		}

	}

	@Transactional
	@Override
	public int deleteCartItem(int cartNo) {
		log.info("서비스 계층 - 장바구니 항목 삭제 시도: cartNo={}", cartNo);

		try {
			int deletedRows = cartMapper.deleteCartItem(cartNo);

			if (deletedRows > 0) {
				log.info("장바구니 항목 (cartNo:{}) 삭제 성공!!! 삭제된 행 수: {}", cartNo, deletedRows);
			} else {
				log.warn("장바구니 항목 (cartNo:{}) 삭제 실패!!! 해당 항목을 찾을 수 없거나 이미 삭제 됐습니다!!", cartNo);
			}

			return deletedRows;
		} catch (Exception e) {
			log.error("장바구니 항목 (cartNo: {}) 삭제 중 예외 발생!!: {}", cartNo, e.getMessage(), e);

			throw new RuntimeException("장바구니 항목 삭제 중 오류 발생!!" + e.getMessage(), e);
		}
	}

	@Override
	@Transactional
	public int deleteSelectedCartItems(List<Integer> cartNoList) {
		log.info("서비스 계층 - 선택된 장바구니 항목 삭제 시도!! cartNoList={}", cartNoList);

		if (cartNoList == null || cartNoList.isEmpty()) {
			return 0;
		}

		int totalDeletedRows = 0;

		try {
			totalDeletedRows = cartMapper.deleteSelectedCartItems(cartNoList);
			log.info("선택된 장바구니 항목 삭제 성공! 삭제된 행 수: {}", totalDeletedRows);

			return totalDeletedRows;

		} catch (Exception e) {
			log.error("선택된 장바구니 항목 삭제 중 예외 발생!!: {}", e.getMessage(), e);

			//RuntimeException으로 래핑하여 상위 계층으로 예외를 전파하고 트랜잭션 롤백
			throw new RuntimeException("선택된 장바구니 항목 삭제 중 오류 발생: " + e.getMessage(), e);
		}
	}

	@Override
	public int updateCartQuantity(GoodsCartVO cart) {
		log.info("서비스 계층 - 장바구니 항목 수량 업뎃 시도!!! cartNo={}, cartQty={}", cart.getCartNo(), cart.getCartQty());
		try {
			int updatedRows = cartMapper.updateCartQuantity(cart);

			if (updatedRows > 0) {
				log.info("장바구니 항목 (cartNo:{}) 수량 업뎃 성공!!! 업뎃된 행의 수: {}", cart.getCartNo(), updatedRows);
			} else {
				log.info("장바구니 항목 (cartNo:{}) 수량 업뎃 실패!!! 해당 항목을 찾을 수 없거나 변경 사항이 없습니다!!", cart.getCartNo());
			}
			return updatedRows;
		} catch (Exception e) {
			log.error("장바구니 항목 (cartNo: {}) 수량 업뎃 중 예외 발생!!!! {}", cart.getCartNo(), e.getMessage(), e);
			throw new RuntimeException("장바구니 항목 수량 업뎃 중 오류 발생!!!" + e.getMessage(), e);
		}
	}

	 @Override
	    public void clearCart(String username) {
	        log.info("clearCart() 호출 - 사용자 {}의 장바구니 비우기 시작.", username);
	        try {
	            int result = cartMapper.deleteCartByUsername(username);
	            log.info("사용자 {}의 장바구니 {}건 삭제 완료.", username, result);
	        } catch (Exception e) {
	            log.error("clearCart() 장바구니 비우기 중 오류 발생: {}", e.getMessage(), e);
	            throw new RuntimeException("장바구니 비우기 실패", e);
	        }
	    }

	 @Override
	 public List<GoodsCartVO> getCartItemsByCartNos(List<Integer> cartNoList, String username) throws Exception {
	     if (cartNoList == null || cartNoList.isEmpty()) {
	         return new ArrayList<>();
	     }
	     Map<String, Object> params = new HashMap<>();
	     params.put("cartNoList", cartNoList);
	     params.put("username", username);

	     // fileGroupNo를 포함한 기본 장바구니 항목들 조회
	     List<GoodsCartVO> orderItems = cartMapper.getCartItemsByCartNosAndUser(params);

	     // 각 항목에 대해 이미지 URL 및 상품 상태 코드 처리
	     if (orderItems != null && !orderItems.isEmpty()) {
	         for (GoodsCartVO item : orderItems) {
	             // 이미지 로직
	             if (item.getFileGroupNo() != null && item.getFileGroupNo() > 0) {
	                 try {
	                     AttachmentFileDetailVO representativeFile = fileService.getRepresentativeFileByGroupNo(item.getFileGroupNo());
	                     if (representativeFile != null && representativeFile.getWebPath() != null && !representativeFile.getWebPath().isEmpty()) {
	                         item.setRepresentativeImageUrl(representativeFile.getWebPath());
	                         log.debug("주문 페이지 - 상품 번호 {} 대표 이미지 경로: {}", item.getGoodsNo(), representativeFile.getWebPath());
	                     } else {
	                         item.setRepresentativeImageUrl(null); // 또는 기본 이미지 URL 설정
	                         log.warn("주문 페이지 - 상품 번호 {} (fileGroupNo: {})에 대한 대표 이미지를 찾을 수 없거나 웹 경로가 없습니다.", item.getGoodsNo(), item.getFileGroupNo());
	                     }
	                 } catch (Exception e) {
	                     log.error("주문 페이지 - 상품 번호 {}의 대표 이미지 조회 중 오류발생!: {}", item.getGoodsNo(), e.getMessage());
	                     item.setRepresentativeImageUrl(null);
	                 }
	             } else {
	                 item.setRepresentativeImageUrl(null); // fileGroupNo가 없으면 이미지 없음
	                 log.info("주문 페이지 - 상품 번호 {}에는 유효한 파일 그룹 번호가 없습니다.", item.getGoodsNo());
	             }

	             String currentDbGoodsStatCode = item.getGoodsStatCode(); // 쿼리에서 이미 가져온 값 사용
	             if (currentDbGoodsStatCode != null) {
	                 if ("GSC001".equalsIgnoreCase(currentDbGoodsStatCode)) {
	                     item.setGoodsStatCode("IN_STOCK");
	                 } else if ("GSC002".equalsIgnoreCase(currentDbGoodsStatCode)) {
	                     item.setGoodsStatCode("SOLD_OUT");
	                 } else {
	                     item.setGoodsStatCode("UNKNOWN");
	                 }
	             } else {
	                 item.setGoodsStatCode("UNKNOWN");
	             }
	             log.info("주문 페이지 - 상품 번호 {}: DB 상태 코드 '{}' -> GoodsCartVO.goodsStatCode '{}'",
	                      item.getGoodsNo(), currentDbGoodsStatCode, item.getGoodsStatCode());
	         }
	     } else {
	         log.warn("선택된 장바구니 번호에 해당하는 상품이 없습니다.");
	     }
	     return orderItems;
	 }

	 @Override
	    @Transactional
	    public void processCartAfterPayment(String username, List<OrderDetailVO> paidOrderDetails, boolean isFromCart) {
	        log.info("processCartAfterPayment() 호출 - 사용자: {}, 결제된 주문 상세 수: {}, 장바구니를 통한 결제 여부: {}", username, paidOrderDetails.size(), isFromCart);

	        if (isFromCart) {
	            log.info("장바구니를 통한 결제이므로 장바구니 후처리 로직을 시작합니다.");

	            if (paidOrderDetails == null || paidOrderDetails.isEmpty()) {
	                log.warn("processCartAfterPayment: 결제된 주문 상세 정보가 없어 처리할 장바구니 항목이 없습니다.");
	                return;
	            }

	            int processedCount = 0; // 실제로 처리된 장바구니 항목 수

	            for (OrderDetailVO detail : paidOrderDetails) {
	                // 장바구니 항목을 조회할 때 필요한 정보: 사용자, 상품번호, 옵션번호
	                Map<String, Object> selectParams = new HashMap<>();
	                selectParams.put("memUsername", username);
	                selectParams.put("goodsNo", detail.getGoodsNo());
	                selectParams.put("goodsOptNo", detail.getGoodsOptNo()); // null일 수 있음

	                // 1. 해당 상품의 현재 장바구니 수량과 cartNo를 조회
	                GoodsCartVO currentCartItem = cartMapper.selectCartItemByGoodsInfo(selectParams);

	                if (currentCartItem != null && currentCartItem.getCartQty() > 0) {
	                    int remainingQty = currentCartItem.getCartQty() - detail.getOrderDetQty();

	                    if (remainingQty <= 0) {
	                        // 2. 남은 수량이 0 이하면 장바구니에서 해당 항목 삭제
	                        log.info("장바구니 항목 삭제 (수량 0 이하): cartNo={}, 상품No={}, 옵션No={}",
	                                 currentCartItem.getCartNo(), detail.getGoodsNo(), detail.getGoodsOptNo());
	                        processedCount += cartMapper.deleteCartItem(currentCartItem.getCartNo()); // cartNo로 삭제
	                    } else {
	                        // 3. 남은 수량이 0보다 크면 장바구니 수량 업데이트
	                        log.info("장바구니 항목 수량 업데이트: cartNo={}, 이전수량={}, 결제수량={}, 남은수량={}",
	                                 currentCartItem.getCartNo(), currentCartItem.getCartQty(), detail.getOrderDetQty(), remainingQty);

	                        GoodsCartVO updateCart = new GoodsCartVO();
	                        updateCart.setCartNo(currentCartItem.getCartNo()); // 해당 cartNo 사용
	                        updateCart.setCartQty(remainingQty); // 새 수량 설정
	                        processedCount += cartMapper.updateCartQuantity(updateCart); // 기존 updateCartQuantity 재사용
	                    }
	                } else {
	                    log.warn("사용자 {}의 장바구니에 결제된 상품 [goodsNo:{}, goodsOptNo:{}]이 없거나 수량이 이미 0입니다. 스킵합니다.",
	                             username, detail.getGoodsNo(), detail.getGoodsOptNo());
	                }
	            }
	            log.info("총 {}개의 장바구니 항목이 처리되었습니다.", processedCount);
	        } else {
	            // 바로구매인 경우 장바구니 처리 로직을 건너뜜
	            log.info("바로구매이므로 장바구니 후처리 로직을 건너뜀.");
	        }

	    }

	 @Override
	    public int getCartItemCount(String memUsername) {
	        return cartMapper.getCartItemCount(memUsername);
	 }

}
