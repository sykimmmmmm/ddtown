package kr.or.ddit.ddtown.service.admin.goods.items;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.goods.IGoodsMapper;
import kr.or.ddit.ddtown.mapper.goods.IGoodsSearchMapper;
import kr.or.ddit.ddtown.mapper.goods.IWishlistMapper;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.goods.goodsOptionVO;
import kr.or.ddit.vo.goods.goodsStockVO;
import kr.or.ddit.vo.goods.goodsVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminGoodsServiceImpl implements IAdminGoodsService {

	@Autowired
	private IFileService fileService;

	@Autowired
	private IGoodsMapper goodsMapper;

	@Autowired
	private IWishlistMapper wishlistMapper;

	@Autowired
	private IGoodsSearchMapper goodsSearchMapper;

    private static final String FILETYPECODE = "FITC004";


	//상품 등록
	@Transactional
	@Override
	public ServiceResult itemsRegister(goodsVO goodsVO) throws Exception {
		// Service
		log.warn("<<<<< SERVICE itemsRegister 진입! Thread: {}, GoodsNm: {} >>>>>", Thread.currentThread().getName(), goodsVO.getGoodsNm());
		log.info("itemsRegister() 실행 시작..!");

		//---------------------------상품 코드 만드는 로직 시작------------------------------
		//1. 새로운 상품 번호 (goodsNo)를 시퀀스에서 미리 가져오기
		int newGoodsNo = goodsMapper.selectNextGoodsNo();
		goodsVO.setGoodsNo(newGoodsNo); //가져온 번호를 VO에 설정
		log.info("새로운 goodsNo 채번: {}", newGoodsNo);


		//2.상품 코드 (goodsCode)생성: "아티스트 그룹 번호 art_group_no + 상품 번호 goods_no"
		String artGroupNoForCode = ""; //초기화

		if(goodsVO.getArtGroupNo() > 0) { //유효한 그룹 번호인지 확인
			artGroupNoForCode = String.valueOf(goodsVO.getArtGroupNo());

		} else {
			log.info("유효한 artGroupNo가 전달되지 않았습니다. 상품 코드 생성 규칙 확인 필요 artGroupNo:{}", goodsVO.getArtGroupNo());

			throw new IllegalArgumentException("아티스트 그룹은 반드시 선택돼야 합니다.");
		}

		//최종 상품 코드 생성
		String goodsNoForCode = String.valueOf(newGoodsNo);
		String generatedGoodsCode = "G" + artGroupNoForCode + "P" + goodsNoForCode;
		goodsVO.setGoodsCode(generatedGoodsCode);
		log.info("생성된 goodsCode(G + 그룹 번호 + P + 상품 번호 형식): {}", generatedGoodsCode);
		//---------------------------상품 코드 만드는 로직 끝------------------------------

		//3. 상품 상태 코드 (goodsStatCode) 설정
		String statusEngKeyFromForm = goodsVO.getStatusEngKey();
		String dbGoodsStatCode = null; //초기화
		if("IN_STOCK".equalsIgnoreCase(statusEngKeyFromForm)) {
			dbGoodsStatCode = "GSC001"; //판매중
		} else if ("SOLD_OUT".equalsIgnoreCase(statusEngKeyFromForm)){
			dbGoodsStatCode = "GSC002"; //품절
		}

		goodsVO.setGoodsStatCode(dbGoodsStatCode);
		log.info("설정된 goodsStatCode: {}", goodsVO.getGoodsStatCode());

		//4. 파일 업로드 처리 및 파일 그룹 번호 생성
		log.info("파일 처리 시작. goodsVO.getGoodsFiles() is null: {}", (goodsVO.getFileGroupNo() == null));

		//--------------------파일이 잘 들어가고 있는지 배열에 값 확인하기..----------------
		if(goodsVO.getGoodsFiles() != null) { //파일 배열 확인
			log.info("goodsVO.getGoodsFiles().length:{}", goodsVO.getGoodsFiles().length);

			if(goodsVO.getGoodsFiles().length > 0) {
				log.info("첫번째 파일 isEmpty(): {}, OriginFilename:{}", goodsVO.getGoodsFiles()[0].isEmpty(),
						goodsVO.getGoodsFiles()[0].getOriginalFilename());
			}
		}

		if (goodsVO.getGoodsFiles() != null && goodsVO.getGoodsFiles().length > 0 && !goodsVO.getGoodsFiles()[0].isEmpty()) {
			//굿즈 파일 타입 코드 사용
			log.info("fileService.uploadAndProcessFiles 호출. FILECODE: {}", FILETYPECODE); //FILETYPECODE 값 확인
			Integer fileGroupResult = fileService.uploadAndProcessFiles(goodsVO.getGoodsFiles(), FILETYPECODE);
			log.info("fileService.uploadAndProcessFiles 반환 값 (fileGroupResult): {}", fileGroupResult); //파일 들어갔는지 확인 결과
			goodsVO.setFileGroupNo(fileGroupResult);
		} else {
			log.info("업로드할 파일이 없거나 비어있어 fileGroupNo를 null로 설정합니다!!");
			goodsVO.setFileGroupNo(null);
		}
		log.info("설정된 fileGroupNo: {}", goodsVO.getFileGroupNo());


		//------------------------goodsMultiOptYn 설정 로직--------------------------
		List<goodsOptionVO> options = goodsVO.getOptions();

		if (options != null && !options.isEmpty()) {
			goodsVO.setGoodsMultiOptYn("Y"); // 옵션이 있으면 'Y'
			log.info("옵션이 존재하므로 goodsMultiOptYn을 'Y'로 설정");
		} else {
			goodsVO.setGoodsMultiOptYn("N"); // 옵션이 없으면 'N'
			log.info("옵션이 없으므로 goodsMultiOptYn을 'N'으로 설정");
		}
		log.info("DB INSERT 직전 goodsMultiOptYn: {}", goodsVO.getGoodsMultiOptYn());
		//------------------------goodsMultiOptYn 설정 로직 끝--------------------------


		//5. 상품 정보 DB에 삽입 (goodsNo, goodsCode, goodsStatCode, fileGroupNo, goodsDivCode)
		int goodsInsertRowCount = goodsMapper.itemsRegister(goodsVO);

		if(goodsInsertRowCount <= 0) {
			log.warn("상품 기본 정보 DB 등록 실패: {}", goodsVO.getGoodsNm());
			return ServiceResult.FAILED; //상품 정보 등록 실패 시 종료
		}
		log.info("상품 기본 정보 DB 등록 성공: goodsNo={}, goodsNm={}", goodsVO.getGoodsNo(), goodsVO.getGoodsNm());


		//6. 옵션 및 옵션 별 재고 등록 (goodsNo 생성 이후)
		if(options != null && !options.isEmpty()) {
				//✔️✔️✔️✔️✔️✔️✔️✔️옵션이 있는 경우✔️✔️✔️✔️✔️✔️✔️✔️
				log.info("옵션 사용됨. 옵션 개수: {}", options.size());

				int currentOptionSequence = 0; // ★ 루프 시작 전에 0으로 초기화

				for(goodsOptionVO option : options) {
					option.setGoodsNo(goodsVO.getGoodsNo()); //현재 상품의 goodsNo를 각 옵션에 설정

					// ★★★ 사용자가 입력한 goodsOptEtc 값 처리 ★★★
			        String etcFromForm = option.getGoodsOptEtc(); // JSP 폼에서 바인딩된 값
			        if (etcFromForm == null || etcFromForm.trim().isEmpty()) {
			            // 사용자가 비고를 입력하지 않았거나 공백만 입력한 경우
			            // Oracle에서 ''는 NULL이므로, NOT NULL 컬럼을 위해 실제 문자를 넣어줍니다.
			            option.setGoodsOptEtc(" "); // 또는 "-" 등, "비고 없음"을 나타내는 기본 문자열
			            log.info("옵션 '{}'의 goodsOptEtc가 비어있어 기본값(' ')으로 설정합니다.", option.getGoodsOptNm());
			        }
			        // ★★★ 여기까지 ★★★

			        // ★ 현재 옵션의 순서(goodsOptSec) 설정: 1부터 시작
			        option.setGoodsOptSec(++currentOptionSequence);
					option.setGoodsOptPrice(goodsVO.getGoodsPrice());
					//6-1. 옵션 정보 INSERT (GOODS_OPTION 테이블)
					//이 호출 후 option.goodsOptNo 필드에 <selectKey>로 생성된 pk가 채워짐.
					int optionInsertCount = goodsMapper.insertGoodsOption(option);

					if(optionInsertCount <= 0) {
						log.info("상품 옵션 정보 등록 실패! 옵션명: {}", option.getGoodsOptNm());
						throw new RuntimeException("상품 옵션 정보 등록에 실패했습니다! 옵션명:{}"+option.getGoodsOptNm());
					}

					log.info("상품 옵션 정보 DB 등록 성공! goodsOptNo: {}", option.getGoodsOptNo());

					//6-2. 옵션별 초기 재고 INSERT (GOODS_STOCK 테이블)
					if (option.getInitialStockQty() != null && option.getInitialStockQty() >= 0) {
						goodsStockVO stock = new goodsStockVO();
						stock.setStockTypeCode("STC001"); // "정상 재고" 또는 "초기 입고" 코드
						stock.setGoodsNo(option.getGoodsNo());
						stock.setGoodsOptNo(option.getGoodsOptNo()); //방금 insertGoodsOption으로 생성된 goodsOptNo 사용
						stock.setStockRemainQty(option.getInitialStockQty()); //폼에서 온 초기 재고량
						stock.setStockNewQty(option.getInitialStockQty()); //초기 입고 시 신규 = 남은 재고
						stock.setStockSafeQty(0); //기본 안전 재고
						stock.setStockUnitCost(0); //기본 단위 원가

						//goodsOptionVO를 파라미터로 사용하여 재고 등록
						int stockInsertCount = goodsMapper.insertGoodsStock(stock);

						if(stockInsertCount <= 0) {
							log.error("옵션 재고 정보 등록 실패! 옵션명: {}", option.getGoodsOptNm());
							throw new RuntimeException("옵션 재고 정보 등록에 실패! 옵션명: {}" + option.getGoodsOptNm());
						}

						log.info("옵션 재고 정보 DB 등록 성공! goodsOptNo: {}, 재고: {}	", option.getGoodsOptNo(), option.getInitialStockQty());
					} else {
						log.warn("옵션 '{}'에 대한 초기 재고 수량이 없거나 유효하지 않아 등록을 못합니다!", option.getGoodsOptNm());
					}
				}

		} else { //✔️✔️✔️✔️✔️✔️✔️✔️옵션이 없는 경우✔️✔️✔️✔️✔️✔️✔️✔️
			log.info("등록된 상품에 옵션이 없습니다! goodsNo: {}", goodsVO.getGoodsNo());

			if(goodsVO.getStockRemainQty() != null && goodsVO.getStockRemainQty() >= 0) {
				//옵션 없는 상품에 기본 옵션 정보를 넣기 위해❗❗❗❗❗
				//옵션이 없다고 옵션 정보를 비울 수 없어서...
				//6-3. 기본 옵션 정보를 goods_option 테이블에 삽입
				goodsOptionVO defaultOption = new goodsOptionVO();
				defaultOption.setGoodsNo(goodsVO.getGoodsNo());
				defaultOption.setGoodsOptNm(goodsVO.getGoodsNm());
				//defaultOption.setGoodsOptNo(0);
				defaultOption.setGoodsOptPrice(goodsVO.getGoodsPrice());
				defaultOption.setGoodsOptFixYn("N");
				defaultOption.setGoodsOptEtc("-");
				defaultOption.setGoodsOptSec(0);

				int defaultOptionInsertCount = goodsMapper.insertGoodsOption(defaultOption); //기본 옵션 저장

				if(defaultOptionInsertCount <= 0 || defaultOption.getGoodsOptNo() <= 0) {
					log.error("기본 상품 옵션 생성 실패!! goodsNo: {}", goodsVO.getGoodsNo());
					throw new RuntimeException("기본 상품 옵션 정보 등록에 실패했습니다!!");
				}
				log.info("기본 상품 옵션 DB 등록 성공! new goodsOptNo: {}", defaultOption.getGoodsOptNo());

				//6-4. 위에서 생성된 defaultOption의 goodsOptNo를 사용해서 goods_stock 테이블에 재고 등록!
				//goodsStockVO 객체 생성하고 값 생성
				goodsStockVO stockDataForBaseProduct = new goodsStockVO();
				stockDataForBaseProduct.setGoodsNo(goodsVO.getGoodsNo());
				stockDataForBaseProduct.setGoodsOptNo(defaultOption.getGoodsOptNo()); //옵션 없는 기본 상품 재고

				stockDataForBaseProduct.setStockRemainQty(goodsVO.getStockRemainQty()); //메인 상품의 재고
				stockDataForBaseProduct.setStockNewQty(goodsVO.getStockRemainQty()); //초기 입고 시 신규 = 남은 재고

				stockDataForBaseProduct.setStockTypeCode("STC001");
				stockDataForBaseProduct.setStockSafeQty(0); //기본 안전 재고
				stockDataForBaseProduct.setStockUnitCost(0); //기본 단위 원가

				log.info("기본 상품 재고 등록 시도! goodsStockVo: {}", stockDataForBaseProduct);
				int stockInsertCount = goodsMapper.insertGoodsStock(stockDataForBaseProduct); //goodsStockVO 객체 전달

				if(stockInsertCount <= 0) {
					log.error("기본 상품 재고 정보 등록 실패! goodsNo: {}", goodsVO.getGoodsNo());
					throw new RuntimeException("기본 상품 재고 정보 등록 실패!");
				}

				log.info("기본 상품 재고 정보 DB 등록 성공! goodsNo:{}, 재고: {}", goodsVO.getGoodsNo(), goodsVO.getStockRemainQty());
			} else {
				log.warn("옵션 미사용 상태, 재고도 입력되지 않았음! goodsNo:{}", goodsVO.getGoodsNo());
			}
		}

		// ★★★ 마지막에 상태 동기화 메소드 호출 ★★★
        this.synchronizeGoodsStatusWithStock(goodsVO.getGoodsNo());

		return ServiceResult.OK;

	}

	//아티스트 그룹 조회
	@Override
	public List<ArtistGroupVO> getArtistGroupsForForm() {
		log.info("AdminGoodsService: 모든 아티스트 그룹 목록 조회 요청");

		return goodsMapper.selectAllArtistGroups();
	}

	//상품 수정
	@Transactional
	@Override
	public ServiceResult updateGoodsItem(goodsVO goodsVO) throws Exception {
	    log.warn("<<<<< SERVICE updateGoodsItem 진입! Thread: {}, GoodsNm: {} >>>>>",
	            Thread.currentThread().getName(),
	            goodsVO.getGoodsNm());

	    // 0. 수정 대상 상품 존재 여부 확인
	    goodsVO existingGoods = goodsMapper.getGoodsDetail(goodsVO.getGoodsNo());
	    if (existingGoods == null) {
	        log.error("수정할 상품을 찾을 수 없습니다. goodsNo: {}", goodsVO.getGoodsNo());
	        throw new RuntimeException("수정할 상품 정보가 없습니다.");
	    }

	    // 기존 파일 그룹 번호 저장 (이 값은 GOODS 테이블 업데이트 후 삭제 여부를 판단하는 데 사용)
	    Integer oldFileGroupNo = existingGoods.getFileGroupNo();
	    // goodsVO에 최종적으로 설정될 파일 그룹 번호. 기본값은 기존 그룹 번호로 시작
	    Integer currentWorkingFileGroupNo = oldFileGroupNo;

	    // --- ★★★ 이 부분 수정 필요 (1/3): hasNewFiles 변수 선언 및 초기 로깅 ★★★ ---
	    // goodsVO.getGoodsFiles() 배열의 첫 번째 파일이 비어있는지 확인 (메서드 초반에 위치)
	    boolean hasNewFiles = (goodsVO.getGoodsFiles() != null && goodsVO.getGoodsFiles().length > 0 && goodsVO.getGoodsFiles()[0].getSize() > 0);
	    log.info("수정 요청 시 새 파일 첨부 여부: {}", hasNewFiles);
	    log.info("기존 상품의 fileGroupNo: {}", existingGoods.getFileGroupNo());
	    log.info("폼에서 넘어온 삭제할 파일 상세 번호: {}", goodsVO.getDeleteAttachDetailNos());

	    // --- ★★★ 여기에 추가! ★★★
	    if (goodsVO.getGoodsFiles() != null && goodsVO.getGoodsFiles().length > 0) {
	        MultipartFile firstFile = goodsVO.getGoodsFiles()[0];
	        log.info("첫 번째 파일 정보: OriginalFilename='{}', Size={}, isEmpty()={}, ContentType='{}'",
	                 firstFile.getOriginalFilename(), firstFile.getSize(), firstFile.isEmpty(), firstFile.getContentType());
	    } else {
	        log.info("goodsVO.getGoodsFiles()가 null이거나 비어있습니다.");
	    }

	    // 1. 삭제하도록 표시된 기존 첨부파일 처리 (file_detail_no 기준)
	    if (goodsVO.getDeleteAttachDetailNos() != null && !goodsVO.getDeleteAttachDetailNos().isEmpty()) {
	        log.info("삭제할 첨부파일 ID 목록: {}", goodsVO.getDeleteAttachDetailNos());
	        fileService.deleteSpecificFiles(goodsVO.getDeleteAttachDetailNos());

	        // 특정 파일 삭제 후, 현재 작업 중인 파일 그룹(currentWorkingFileGroupNo)에 남아있는 파일이 있는지 확인
	        // 만약 모든 파일이 삭제되어 그룹이 비었다면, 해당 그룹 번호를 null로 변경
	        if (currentWorkingFileGroupNo != null && currentWorkingFileGroupNo > 0) {
	            int remainingFiles = fileService.countFilesInGroup(currentWorkingFileGroupNo);
	            if (remainingFiles == 0) {
	                currentWorkingFileGroupNo = null; // 기존 그룹이 비었음을 표시
	                log.info("기존 파일 그룹 {}의 특정 파일 삭제 후, 그룹에 파일이 없어 null로 설정", oldFileGroupNo);
	            }
	        }
	    }

	    // 2. 새로 추가된 파일 처리 및 최종 파일 그룹 번호 결정
	    if (hasNewFiles) { // 새 파일이 있다면
	        log.info("fileService.uploadAndProcessFiles 호출 전. 업로드할 파일 수: {}", goodsVO.getGoodsFiles().length);
	        Integer uploadedFileGroupNo = fileService.uploadAndProcessFiles(goodsVO.getGoodsFiles(), FILETYPECODE /*, uploaderId */);
	        log.info("fileService.uploadAndProcessFiles 호출 후 반환된 그룹 번호: {}", uploadedFileGroupNo);

	        if (uploadedFileGroupNo != null && uploadedFileGroupNo > 0) {
	            currentWorkingFileGroupNo = uploadedFileGroupNo; // 새 파일 그룹 번호로 갱신
	            log.info("새 파일이 업로드되어 최종 파일 그룹 번호가 {}로 변경됨", currentWorkingFileGroupNo);
	        } else {
	            // 새 파일을 업로드하려 했으나 실패했거나 (e.g., 빈 파일만 올라온 경우),
	            // uploadAndProcessFiles가 null을 반환한 경우 (정책에 따라)
	            log.warn("새 파일 업로드 처리 실패 또는 반환된 그룹 번호가 유효하지 않음. 기존 파일 그룹 번호 {} 유지 (혹은 null)", currentWorkingFileGroupNo);
	            // 이 경우 currentWorkingFileGroupNo는 1단계에서 결정된 값(oldFileGroupNo 또는 null)을 유지합니다.
	        }
	    }
	    // else 문은 이제 필요 없습니다. (삭제)
	    // 1단계와 2단계 초반에서 currentWorkingFileGroupNo가 이미 적절히 결정됩니다.

	    // goodsVO에 최종 결정된 파일 그룹 번호 설정
	    goodsVO.setFileGroupNo(currentWorkingFileGroupNo);
	    log.info("goodsVO에 최종 설정된 fileGroupNo: {}", goodsVO.getFileGroupNo());


	    // 3. 상품 상태 코드(goodsStatCode) 설정
	    String statusEngKeyFromForm = goodsVO.getStatusEngKey();
	    String dbGoodsStatCode;
	    if ("IN_STOCK".equalsIgnoreCase(statusEngKeyFromForm)) {
	        dbGoodsStatCode = "GSC001";
	    } else if ("SOLD_OUT".equalsIgnoreCase(statusEngKeyFromForm)) {
	        dbGoodsStatCode = "GSC002";
	    } else {
	        log.warn("알 수 없거나 유효하지 않은 statusEngKey: '{}'. 기존 상태 유지 또는 기본값으로 설정 필요.", statusEngKeyFromForm);
	        dbGoodsStatCode = existingGoods.getGoodsStatCode();
	    }
	    goodsVO.setGoodsStatCode(dbGoodsStatCode);


	    // 4. 삭제하도록 표시된 기존 옵션 처리
	    if (goodsVO.getDeleteOptionNos() != null && !goodsVO.getDeleteOptionNos().isEmpty()) {
	        for (Integer goodsOptNoToDelete : goodsVO.getDeleteOptionNos()) {
	            if (goodsOptNoToDelete != null && goodsOptNoToDelete > 0) {
	                goodsMapper.deleteStockForOption(goodsOptNoToDelete);
	                goodsMapper.deleteGoodsOption(goodsOptNoToDelete);
	                log.info("기존 옵션 삭제 성공: goodsOptNo={}", goodsOptNoToDelete);
	            }
	        }
	    }

	    // 5. 폼에서 넘어온 옵션 목록 처리 (신규 추가 또는 기존 옵션 업데이트)
	    int currentOptionSequence = 0;
	    if (goodsVO.getOptions() != null && !goodsVO.getOptions().isEmpty()) {
	        log.info("처리할 옵션 개수 (수정/추가): {}", goodsVO.getOptions().size());
	        for (goodsOptionVO option : goodsVO.getOptions()) {
	            option.setGoodsNo(goodsVO.getGoodsNo());

	            String etcFromForm = option.getGoodsOptEtc();
	            if (etcFromForm == null || etcFromForm.trim().isEmpty()) {
	                option.setGoodsOptEtc(" ");
	            }
	            if (option.getGoodsOptFixYn() == null || option.getGoodsOptFixYn().isEmpty()) {
	                option.setGoodsOptFixYn("N");
	            }
	            option.setGoodsOptSec(++currentOptionSequence);

	            if (option.getGoodsOptNo() > 0) { // 기존 옵션 -> 업데이트
	                goodsMapper.updateGoodsOption(option);
	                log.info("기존 옵션 정보 DB 업데이트 성공! goodsOptNo: {}", option.getGoodsOptNo());
	                goodsMapper.deleteStockForOption(option.getGoodsOptNo()); // 기존 재고 삭제 후 새로 삽입
	            } else { // 새 옵션 -> 삽입
	                goodsMapper.insertGoodsOption(option); // option.goodsOptNo가 여기서 채워짐
	                log.info("새 옵션 정보 DB 등록 성공! new goodsOptNo: {}", option.getGoodsOptNo());
	            }

	            // 옵션별 재고 INSERT
	            if (option.getInitialStockQty() != null && option.getInitialStockQty() >= 0) {
	                goodsStockVO stockVO = new goodsStockVO();
	                stockVO.setGoodsNo(option.getGoodsNo());
	                stockVO.setGoodsOptNo(option.getGoodsOptNo());
	                stockVO.setStockRemainQty(option.getInitialStockQty());
	                stockVO.setStockNewQty(option.getInitialStockQty());
	                stockVO.setStockTypeCode("STC001");
	                stockVO.setStockSafeQty(0);
	                stockVO.setStockUnitCost(0);

	                goodsMapper.insertGoodsStock(stockVO);
	                log.info("옵션 재고 정보 DB 처리 성공! goodsOptNo: {}, 재고: {}", option.getGoodsOptNo(), option.getInitialStockQty());
	            }
	        }
	    }

	    // 6. 옵션 유무에 따른 goodsMultiOptYn 최종 결정
	    List<goodsOptionVO> finalOptionsInDb = goodsMapper.optionList(goodsVO.getGoodsNo());
	    if (finalOptionsInDb != null && !finalOptionsInDb.isEmpty()) {
	        goodsVO.setGoodsMultiOptYn("Y");
	    } else {
	        goodsVO.setGoodsMultiOptYn("N");
	    }
	    log.info("옵션 처리 완료 후 최종 결정된 goodsMultiOptYn: {}", goodsVO.getGoodsMultiOptYn());


	    // 7. 옵션 없는 상품의 경우 기본 재고 처리
	    if ("N".equals(goodsVO.getGoodsMultiOptYn())) {
	        goodsMapper.deleteAllOptionsStockForGoods(goodsVO.getGoodsNo());
	        goodsMapper.deleteAllOptionsForGoods(goodsVO.getGoodsNo());

	        //기본 재고 삽입 / 수정
	        if (goodsVO.getStockRemainQty() != null && goodsVO.getStockRemainQty() >= 0) {
	            goodsStockVO stockDataForBaseProduct = new goodsStockVO();
	            stockDataForBaseProduct.setGoodsNo(goodsVO.getGoodsNo());
	            stockDataForBaseProduct.setGoodsOptNo(0);
	            stockDataForBaseProduct.setStockRemainQty(goodsVO.getStockRemainQty());
	            stockDataForBaseProduct.setStockNewQty(goodsVO.getStockRemainQty());
	            stockDataForBaseProduct.setStockTypeCode("STC001");
	            stockDataForBaseProduct.setStockSafeQty(0);
	            stockDataForBaseProduct.setStockUnitCost(0);

	            goodsMapper.deleteBaseStockForGoods(goodsVO.getGoodsNo(), 0);
	            goodsMapper.insertGoodsStock(stockDataForBaseProduct);
	            log.info("옵션 미사용으로 전환, 기본 상품 재고 정보 DB 등록/수정 성공!");
	        }
	    } else {
	        goodsMapper.deleteBaseStockForGoods(goodsVO.getGoodsNo(), 0);
	        log.info("옵션 사용 상품으로 전환됨에 따라 기본 상품 재고 (goods_opt_no=0) 삭제.");
	    }


	    // 8. 상품 기본 정보 최종 업데이트 (GOODS 테이블)
	    goodsVO.setGoodsCode(existingGoods.getGoodsCode()); // 기존 상품 코드 유지

	    int finalUpdateGoodsCount = goodsMapper.updateGoodsItem(goodsVO);
	    if (finalUpdateGoodsCount <= 0) {
	        log.warn("상품 기본 정보 DB 최종 업데이트 실패: {}", goodsVO.getGoodsNm());
	        return ServiceResult.FAILED;
	    }
	    log.info("상품 기본 정보 DB 최종 업데이트 성공: goodsNo={}, goodsNm={}", goodsVO.getGoodsNo(), goodsVO.getGoodsNm());


	    // 9. 파일 그룹 삭제 (GOODS 테이블 업데이트 후 안전하게 진행)
	    // oldFileGroupNo가 있었고, 현재 goodsVO의 fileGroupNo와 달라졌다면 (null이 되었거나 새 그룹 번호로 변경)
	    if(oldFileGroupNo != null && oldFileGroupNo > 0 && !oldFileGroupNo.equals(goodsVO.getFileGroupNo())) {
	        fileService.deleteFilesByGroupNo(oldFileGroupNo);
	        log.info("GOODS 테이블에서 참조가 끊긴 기존 파일 그룹 {} 삭제 완료!", oldFileGroupNo);
	    }
	    // 새롭게 생성되었으나 최종적으로 비어있게 된 파일 그룹에 대한 처리는
	    // fileService.uploadAndProcessFiles 구현에 따라 달라집니다.
	    // 만약 uploadAndProcessFiles가 파일이 없는 경우 null을 반환한다면, 이 로직은 필요 없습니다.
	    // ★★★ 마지막에 상태 동기화 메소드 호출 ★★★
		this.synchronizeGoodsStatusWithStock(goodsVO.getGoodsNo());

	    return ServiceResult.OK;
	}

	//상품 삭제
	@Override
	@Transactional
	public ServiceResult deleteGoodsItems(int goodsNo) {
	    ServiceResult result = ServiceResult.FAILED;
	    log.warn("<<<<<Service deleteGoodsItems 진입!!!! goodsNo: {} >>>>>", goodsNo);

	    // ⭐ 1. 파일 그룹 번호는 상품 삭제 전에 미리 가져와야 합니다. ⭐
	    Integer fileGroupNoToDelete = null;
	    try {
	        goodsVO goods = goodsMapper.getGoodsDetail(goodsNo); // 상품 상세 정보 조회
	        if (goods != null) {
	            fileGroupNoToDelete = goods.getFileGroupNo();
	            log.info("상품(goodsNo:{})에 연결된 파일 그룹(fileGroupNo:{}) 미리 확보", goodsNo, fileGroupNoToDelete);
	        } else {
	            log.warn("상품(goodsNo:{})이 존재하지 않아 삭제를 진행할 수 없습니다.", goodsNo);
	            return ServiceResult.FAILED; // 상품이 없으면 바로 실패 반환
	        }

	        // 2. 상품에 연결된 찜(Wishlist) 정보 삭제 (이전 순서 유지)
	        log.info("상품(goodsNo:{})에 연결된 찜 목록 데이터 삭제 시도", goodsNo);
	        wishlistMapper.deleteWishlistByGoodsNo(goodsNo);

	        // 3. 상품 옵션 및 관련 재고 삭제 (이전 순서 유지)
	        log.info("상품(goodsNo:{})의 모든 옵션 재고 삭제 시도", goodsNo);
	        goodsMapper.deleteAllOptionsStockForGoods(goodsNo);
	        log.info("상품(goodsNo:{})의 모든 옵션 삭제 시도", goodsNo);
	        goodsMapper.deleteAllOptionsForGoods(goodsNo);

	        // 4. 기본 상품 재고 삭제 (goods_opt_no = 0) (이전 순서 유지)
	        log.info("상품(goodsNo:{})의 기본 재고(goods_opt_no=0) 삭제 시도", goodsNo);
	        goodsMapper.deleteBaseStockForGoods(goodsNo, 0);

	        // ⭐ 5. 상품 자체 삭제 (가장 마지막) ⭐
	        // 이제 GOODS 테이블에서 ATTACHMENT_FILE의 FILE_GROUP_NO에 대한 참조가 제거됩니다.
	        log.info("상품(goodsNo:{}) 데이터 삭제 시도", goodsNo);
	        int goodsDeleteStatus = goodsMapper.deleteGoodsItem(goodsNo);

	        if (goodsDeleteStatus > 0) {
	            // ⭐ 6. 상품 삭제 성공 시, 미리 확보한 fileGroupNo로 파일 그룹 삭제 ⭐
	            if (fileGroupNoToDelete != null) {
	                log.info("상품 삭제 완료 후, 연결된 파일 그룹(fileGroupNo:{}) 삭제 시도", fileGroupNoToDelete);
	                fileService.deleteFilesByGroupNo(fileGroupNoToDelete); // 파일 그룹 및 실제 파일 삭제
	            } else {
	                log.info("상품(goodsNo:{})에 연결된 파일 그룹이 없어 삭제하지 않습니다.", goodsNo);
	            }

	            result = ServiceResult.OK;
	            log.info("상품(goodsNo:{}) 및 관련 데이터 성공적으로 삭제 완료.", goodsNo);
	        } else {
	            result = ServiceResult.FAILED;
	            log.warn("상품(goodsNo:{}) 삭제 실패 또는 해당 상품이 존재하지 않아 삭제할 수 없습니다.", goodsNo);
	        }
	    } catch (Exception e) {
	        log.error("상품(goodsNo:{}) 삭제 중 예외 발생: {}", goodsNo, e.getMessage(), e);
	        // 트랜잭션 롤백을 위해 예외를 다시 던집니다.
	        throw new RuntimeException("상품 삭제 중 오류 발생: " + e.getMessage(), e);
	    }
	    return result;
	}

	/**
	 * 특정 상품의 총 재고를 기반으로 판매 상태를 동기화하는 private 메소드
	 * @param goodsNo 동기화할 상품 번호
	 */
	private void synchronizeGoodsStatusWithStock(int goodsNo) {
	    // 1. 해당 상품의 '전체' 재고를 다시 계산합니다.
	    int totalStock = goodsMapper.selectTotalStockForGoods(goodsNo);
	    log.info("상품(goodsNo:{})의 상태 동기화 시작. 계산된 총 재고: {}", goodsNo, totalStock);

	    // 2. 현재 상품의 상태 코드를 가져옵니다.
	    goodsVO currentGoods = goodsMapper.getGoodsStatusOnly(goodsNo);
	    if (currentGoods == null) {
	        log.warn("상태 동기화 중 상품(goodsNo:{}) 정보를 찾을 수 없어 중단합니다.", goodsNo);
	        return;
	    }
	    String currentStatus = currentGoods.getGoodsStatCode();

	    // 3. 재고에 따라 상태를 결정하고, 필요시에만 DB를 업데이트합니다.
	    // 'GSC002'가 '품절' 코드, 'GSC001'이 '판매중' 코드라고 가정합니다.
	    String newStatus = null;
	    if (totalStock <= 0 && !"GSC002".equals(currentStatus)) {
	        // 재고가 0 이하인데, 상태가 '품절'이 아니면 -> '품절'로 변경
	        newStatus = "GSC002";
	        log.info("재고가 0 이하이므로 상품(goodsNo:{}) 상태를 '품절({})'로 변경합니다.", goodsNo, newStatus);
	    } else if (totalStock > 0 && !"GSC001".equals(currentStatus)) {
	        // 재고가 생겼는데, 상태가 '판매중'이 아니면 -> '판매중'으로 변경
	        newStatus = "GSC001";
	        log.info("재고가 0보다 많으므로 상품(goodsNo:{}) 상태를 '판매중({})'으로 변경합니다.", goodsNo, newStatus);
	    }

	    // 4. 변경이 필요한 경우에만 DB 업데이트 실행
	    if (newStatus != null) {
	        goodsMapper.updateGoodsStatus(goodsNo, newStatus);
	        log.info("상품(goodsNo:{}) 상태 DB 업데이트 완료.", goodsNo);
	    } else {
	        log.info("상품(goodsNo:{})의 현재 상태가 재고와 일치하여 변경하지 않습니다.", goodsNo);
	    }
	}

	@Override
    public void retrieveGoodsList(PaginationInfoVO<goodsVO> pagingVO) {
        // 1. 검색 조건에 맞는 전체 상품 수를 조회해서 PagingVO에 설정
        // 이 메소드를 호출하면 pagingVO의 totalPage 등 관련 값들이 모두 계산됩니다.
        int totalRecord = goodsSearchMapper.selectGoodsCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        // 2. 페이지네이션이 적용된 상품 목록을 조회
        List<goodsVO> dataList = goodsSearchMapper.selectGoodsList(pagingVO);
        pagingVO.setDataList(dataList);
    }

	@Override
	public List<Map<String, Object>> getGoodsStatusCounts() {
	    return goodsSearchMapper.selectGoodsStatusCounts();
	}

	// ⭐⭐ 구현: 필터 적용 전의 순수한 전체 상품 개수를 가져오는 메서드 ⭐⭐
    @Override
    public int getTotalGoodsCount() {
        return goodsSearchMapper.getTotalGoodsCount();
    }

	@Override
	public List<Map<String, Object>> getGoodsStockCounts() {
	    return goodsSearchMapper.selectGoodsStockCounts();
	}
}
