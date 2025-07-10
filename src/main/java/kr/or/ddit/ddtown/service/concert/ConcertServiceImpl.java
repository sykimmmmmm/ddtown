package kr.or.ddit.ddtown.service.concert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.community.ICommunityFollowMapper;
import kr.or.ddit.ddtown.mapper.concert.schedule.IConcertScheduleMapper;
import kr.or.ddit.ddtown.service.admin.goods.items.IAdminGoodsService;
import kr.or.ddit.ddtown.service.alert.IAlertService;
import kr.or.ddit.ddtown.service.file.IFileService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.alert.AlertVO;
import kr.or.ddit.vo.concert.ConcertSeatMapVO;
import kr.or.ddit.vo.concert.ConcertVO;
import kr.or.ddit.vo.concert.TicketVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.goods.goodsVO;
import lombok.extern.slf4j.Slf4j;

/**
 *
 */
@Slf4j
@Service
public class ConcertServiceImpl implements IConcertService {

    @Autowired
    private IConcertScheduleMapper concertMapper;

    @Autowired
    private ICommunityFollowMapper followMapper;

    @Autowired
    private IFileService fileService;

    @Autowired
    private IAlertService alertService;

    @Autowired
    private ISeatService seatService;

    @Autowired
    private IAdminGoodsService goodsService;

    private static final String FILETYPECODE = "FITC010";


    @Override
    public List<ConcertVO> selectConcertList(PaginationInfoVO<ConcertVO> pagingVO) throws Exception {
        log.info("selectConcertList() 실행...!");
        List<ConcertVO> list = concertMapper.selectConcertList(pagingVO);
        if (list != null) {
            for (ConcertVO item : list) {
                item.setRepresentativeImageUrl(null); // 반복문 시작 시 null 초기화
                if (item.getFileGroupNo() != null && item.getFileGroupNo() > 0) {
                    try {
                        log.debug("콘서트 ID {}의 파일 그룹 {} 대표 이미지 조회", item.getConcertNo(), item.getFileGroupNo());
                        AttachmentFileDetailVO repFile = fileService.getRepresentativeFileByGroupNo(item.getFileGroupNo());
                        if (repFile != null && repFile.getWebPath() != null && !repFile.getWebPath().isEmpty()) {
                            // VO에 대표 이미지 URL 설정
                            item.setRepresentativeImageUrl(repFile.getWebPath());
                            log.info("목록 - 콘서트 ID {}: 설정된 대표 이미지 URL: [{}]", item.getConcertNo(), item.getRepresentativeImageUrl());
                        } else {
                            log.warn("목록 - 콘서트 ID {}: 대표 이미지 파일 정보를 찾지 못함. FileGroupNo: {}", item.getConcertNo(), item.getFileGroupNo());
                        }
                    } catch (Exception e) {
                        log.error("목록 - 콘서트 ID {}의 대표 이미지 조회 중 오류 발생: {}", item.getConcertNo(), e.getMessage());
                        // 개별 항목 오류 시 전체 목록 조회를 막지 않도록 해놈
                    }
                } else {
                    // 파일 그룹 번호가 없는 경우
                    log.debug("목록 - 콘서트 ID {}: 파일 그룹 번호가 없음", item.getConcertNo());
                }
            }
        }
        return list;
    }

    @Override
    public int selectConcertCount(PaginationInfoVO<ConcertVO> pagingVO) throws Exception {
    	log.info("selectConcertCount() 실행...!");
        return concertMapper.selectConcertCount(pagingVO);
    }

    @Override
    public ConcertVO selectSchedule(int concertNo) throws Exception {

    	log.info("selectSchedule() 실행...!");
    	ConcertVO concertVO = concertMapper.selectSchedule(concertNo);
        if (concertVO != null && concertVO.getFileGroupNo() != null && concertVO.getFileGroupNo() > 0) {	// 일정정보가 비어있지 않을때
            // VO에 전체 첨부파일 목록 설정
            List<AttachmentFileDetailVO> files = fileService.getFileDetailsByGroupNo(concertVO.getFileGroupNo());
            AttachmentFileDetailVO repFile = fileService.getRepresentativeFileByGroupNo(concertVO.getFileGroupNo());
            concertVO.setRepresentativeImageUrl(repFile.getWebPath());
            concertVO.setAttachmentFileList(files);
            log.debug("콘서트 번호 {}: 파일 그룹 {}의 파일 {}개 로드", concertNo, concertVO.getFileGroupNo(), (files != null ? files.size() : 0));
        }
        return concertVO;
    }

    @Transactional
    @Override
    public ServiceResult insertSchedule(ConcertVO concertVO, String regiUsername) throws Exception {
    	log.info("insertSchedule() 실행...!");

    	// 파일 업로드 처리 및 파일 그룹 번호 생성
        if (concertVO.getConcertFiles() != null && concertVO.getConcertFiles().length > 0 && !concertVO.getConcertFiles()[0].isEmpty()) {

            Integer fileGroupNo = fileService.uploadAndProcessFiles(concertVO.getConcertFiles(), FILETYPECODE);
            concertVO.setFileGroupNo(fileGroupNo); // 생성된 파일 그룹 번호를 ConcertVO에 설정
        } else {
            concertVO.setFileGroupNo(null);
        }

        // 콘서트 일정 정보 DB에 삽입
        int row = concertMapper.insertSchedule(concertVO); // 이 때 fileGroupNo도 함께 저장됨

        if (row > 0) {
            log.info("콘서트 일정 DB 등록 성공: {}", concertVO.getConcertNm());

            // 콘서트 시트 매핑 정보 및 티켓정보 추가
            if("N".equals(concertVO.getConcertOnlineYn())) {
            	// 티켓정보 넣기전에 상품등록 후 상품번호를 티켓정보에 같이 저장하는 로직이 추가되면 괜찮아질듯
            	goodsVO goodsVO = new goodsVO();
            	goodsVO.setArtGroupNo(concertVO.getArtGroupNo());
            	goodsVO.setGoodsNm(concertVO.getConcertNm());
            	goodsVO.setStatusEngKey("IN_STOCK");
            	goodsVO.setGoodsPrice(110000);
            	goodsVO.setStockRemainQty(1000);
            	goodsVO.setGoodsDivCode("GDC001");
            	goodsService.itemsRegister(goodsVO);

            	seatService.insertTicket(concertVO,goodsVO.getGoodsNo());
            }

            try {
				AlertVO alert = new AlertVO();
				alert.setAlertTypeCode("ATC007");		// 공통코드
				alert.setRelatedItemTypeCode("ITC007");		// 관련 항목 코드

				String artGroupName = concertVO.getArtGroupName();
				if(artGroupName == null || artGroupName.isEmpty()) {
					artGroupName = followMapper.selectArtistGroupName(concertVO.getArtGroupNo());
				}

				String alertMessage = "팔로우하신 아티스트 '" + artGroupName + "'의 새로운 콘서트 \n [" + concertVO.getConcertNm() + "] 이 등록되었습니다!!";
				alert.setAlertContent(alertMessage);

				alert.setAlertUrl("/emp/concert/schedule/detail/" + concertVO.getConcertNo());
				alert.setRelatedItemNo(concertVO.getConcertNo());		// 알림과 관련된 콘서트 번호 저장

				// 알림 수신 대상자 설정
				List<String> recipientUsernames = followMapper.selectFollowersByArtGroup(concertVO.getArtGroupNo());

				if(regiUsername != null) {
					recipientUsernames.remove(regiUsername);
				}

				if(recipientUsernames != null && !recipientUsernames.isEmpty()) {
					alertService.createAlert(alert, recipientUsernames);
					log.info("새로운 콘서트 일정 알림 생성 및 발송 요청 성공!! 대상 사용자 : {}", recipientUsernames);
				} else {
					log.info("콘서트 {}의 팔로워가 없습니다.", concertVO.getConcertNm());
				}
			} catch (Exception e) {
				log.error("콘서트 일정 성공 후 알림 발송중 오류 발생..");
			}
            return ServiceResult.OK;
        } else {
        	log.warn("콘서트 일정 DB 등록 실패: {}", concertVO.getConcertNm());
        	return ServiceResult.FAILED;
        }
    }

    @Transactional
    @Override
    public ServiceResult updateSchedule(ConcertVO concertVO) throws Exception {
    	log.info("updateSchedule() 실행...!");

    	// 선택한 게시물의 기존 파일 그룹 번호 조회
        ConcertVO originalConcert = concertMapper.selectSchedule(concertVO.getConcertNo());
        Integer existingFileGroupNo = (originalConcert != null) ? originalConcert.getFileGroupNo() : null;
        log.info("기존 파일 그룹 번호: {}", existingFileGroupNo);

        boolean hasNewFiles = concertVO.getConcertFiles() != null &&
                              concertVO.getConcertFiles().length > 0 &&
                              !concertVO.getConcertFiles()[0].isEmpty();

        Integer finalFileGroupNo = existingFileGroupNo;		// DB에 들어갈 최종 파일그룹번호

        // 개별 파일 삭제 처리
        // FileServiceImpl의 deleteSpecificFiles 호출
        // existingFileGroupNo가 null 될 수 있음 (그룹 내 모든 파일 삭제 시)
        if (concertVO.getDeleteFileNos() != null && !concertVO.getDeleteFileNos().isEmpty()) {
            if (existingFileGroupNo != null) {
                fileService.deleteSpecificFiles(concertVO.getDeleteFileNos()); // 이 메소드는 그룹은 삭제 안함
                // 삭제 후 남은 파일 확인
                List<AttachmentFileDetailVO> remainingFiles = fileService.getFileDetailsByGroupNo(existingFileGroupNo);
                if (remainingFiles == null || remainingFiles.isEmpty()) {
                    log.info("개별 파일 삭제 결과, 파일 그룹 {}가 비었음. 이 그룹은 새 파일이 없으면 삭제", existingFileGroupNo);
                    // finalFileGroupNo는 아래 로직에서 새 파일이 없으면 null로 설정 후 그룹 삭제.
                    // 새 파일이 있으면 기존 그룹은 어차피 삭제됨.
                }
            }
        }

        // 새로 첨부된 파일 처리
        if (hasNewFiles) {
            // 새 파일이 있으면, 새로운 파일 그룹을 생성
            Integer newFileGroupNo = fileService.uploadAndProcessFiles(concertVO.getConcertFiles(), FILETYPECODE);
            finalFileGroupNo = newFileGroupNo; // 최종 파일 그룹 번호를 새 것으로 설정
            log.info("새 파일 업로드 완료. 새 파일 그룹 번호: {}", finalFileGroupNo);
        } else {
            // 새 파일이 없고, 기존 파일들 중 일부 또는 전부가 삭제되어 그룹이 비었는지 확인
            if (existingFileGroupNo != null && (concertVO.getDeleteFileNos() != null && !concertVO.getDeleteFileNos().isEmpty())) {
                 List<AttachmentFileDetailVO> remainingFiles = fileService.getFileDetailsByGroupNo(existingFileGroupNo);
                 if (remainingFiles == null || remainingFiles.isEmpty()) {
                     finalFileGroupNo = null; // 그룹이 비었으면 게시물에서 파일 그룹 연결 해제
                 }
            }
        }
        concertVO.setFileGroupNo(finalFileGroupNo); // 생성된 새 파일 그룹 번호로 ConcertVO 업데이트

        // 콘서트 일정 정보 DB 업뎃
        int row = concertMapper.updateSchedule(concertVO);
        if (row > 0) {
            log.info("콘서트 일정 DB 업데이트 성공 (번호: {}). 최종 fileGroupNo: {}", concertVO.getConcertNo(), finalFileGroupNo);
            // 게시물 업데이트 성공 후, 기존 파일 그룹 삭제
            if (existingFileGroupNo != null && (finalFileGroupNo == null || !existingFileGroupNo.equals(finalFileGroupNo))) {
                log.info("게시물 업데이트 후, 이전 파일 그룹 {} 및 관련 파일들을 삭제", existingFileGroupNo);
                fileService.deleteFilesByGroupNo(existingFileGroupNo);
            }
            return ServiceResult.OK;
        }
        if (hasNewFiles && finalFileGroupNo != null && (existingFileGroupNo == null || !existingFileGroupNo.equals(finalFileGroupNo))) {
            try {
                fileService.deleteFilesByGroupNo(finalFileGroupNo);
                log.info("업데이트 실패로 인해 새로 생성된 파일 그룹 {} 삭제 시도", finalFileGroupNo);
            } catch (Exception e_file) {
                log.error("업데이트 실패 후 새 파일 그룹 {} 삭제 중 오류: {}", finalFileGroupNo, e_file.getMessage());
            }
        }
        return ServiceResult.FAILED;
    }

    @Transactional
    @Override
    public ServiceResult deleteSchedule(int concertNo) throws Exception {
    	log.info("deleteSchedule() 실행...!");

    	ConcertVO concertToDelete = concertMapper.selectSchedule(concertNo); // 파일 그룹 번호 확인을 위해 조회
    	Integer fileGroupNoToDelete = null;

    	if (concertToDelete != null) {
            fileGroupNoToDelete = concertToDelete.getFileGroupNo();
        }

        // === 자식 테이블 먼저 삭제 (무결성 제약조건 위배 방지) ===
        try {
            // 1. TICKET 테이블에서 해당 콘서트의 티켓들 삭제
            int deletedTickets = concertMapper.deleteTicketsByConcertNo(concertNo);
            log.info("콘서트 {}의 티켓 {}건 삭제 완료", concertNo, deletedTickets);

            // 2. CONCERT_SEAT_MAP 테이블에서 해당 콘서트의 좌석 맵 삭제
            int deletedSeatMaps = concertMapper.deleteConcertSeatMapByConcertNo(concertNo);
            log.info("콘서트 {}의 좌석 맵 {}건 삭제 완료", concertNo, deletedSeatMaps);

        } catch (Exception e) {
            log.error("자식 테이블 삭제 중 오류 발생: {}", e.getMessage(), e);
            throw e;
        }

        // 3. 부모 테이블(CONCERT) 삭제
        int row = concertMapper.deleteSchedule(concertNo);

        if (row > 0) {
        	log.info("콘서트 일정 삭제 성공");

        	// 4. 첨부파일 삭제 (파일 그룹이 있는 경우)
        	if(fileGroupNoToDelete != null && fileGroupNoToDelete > 0) {
        		try {
        			fileService.deleteFilesByGroupNo(fileGroupNoToDelete);
					log.info("연결된 파일 그룹 {} 및 관련 파일 모두 삭제 완료", fileGroupNoToDelete);

				} catch (Exception e) {
					log.error("게시물 삭제 후 파일 그룹 삭제 중 오류 발생: {}", e.getMessage(), e);
					// 파일 삭제 실패는 콘서트 삭제 성공에 영향을 주지 않도록 함
				}
        	}
            return ServiceResult.OK;
        } else {
        	log.info("콘서트 일정 삭제 실패!!");
        	return ServiceResult.FAILED;
        }
    }

    // 콘서트 일정 불러오기 ( 예정 빼고 ) : 유정
	@Override
	public List<ConcertVO> getConcertList(ConcertVO concertVO) {
		List<ConcertVO> list = concertMapper.getConcertList(concertVO);
        if (list != null) {
            for (ConcertVO item : list) {
                item.setRepresentativeImageUrl(null); // 반복문 시작 시 null 초기화
                if (item.getFileGroupNo() != null && item.getFileGroupNo() > 0) {
                    try {
                        log.debug("콘서트 ID {}의 파일 그룹 {} 대표 이미지 조회", item.getConcertNo(), item.getFileGroupNo());
                        AttachmentFileDetailVO repFile = fileService.getRepresentativeFileByGroupNo(item.getFileGroupNo());
                        if (repFile != null && repFile.getWebPath() != null && !repFile.getWebPath().isEmpty()) {
                            // VO에 대표 이미지 URL 설정
                            item.setRepresentativeImageUrl(repFile.getWebPath());
                            log.info("목록 - 콘서트 ID {}: 설정된 대표 이미지 URL: [{}]", item.getConcertNo(), item.getRepresentativeImageUrl());
                        } else {
                            log.warn("목록 - 콘서트 ID {}: 대표 이미지 파일 정보를 찾지 못함. FileGroupNo: {}", item.getConcertNo(), item.getFileGroupNo());
                        }
                    } catch (Exception e) {
                        log.error("목록 - 콘서트 ID {}의 대표 이미지 조회 중 오류 발생: {}", item.getConcertNo(), e.getMessage());
                        // 개별 항목 오류 시 전체 목록 조회를 막지 않도록 해놈
                    }
                } else {
                    // 파일 그룹 번호가 없는 경우
                    log.debug("목록 - 콘서트 ID {}: 파일 그룹 번호가 없음", item.getConcertNo());
                }
            }

        }
        return list;
	}

	// 해당 콘서트 좌석 정보 조회
	@Override
	public List<ConcertSeatMapVO> getConcertSeatMap(int concertNo) {
		return concertMapper.getConcertSeatMap(concertNo);
	}

	// 해당 콘서트 전체 좌석 조회
	@Override
	public List<TicketVO> getAllTicketList(int concertNo) {
		return concertMapper.getAllTicketList(concertNo);
	}


	/**
	 * 티켓 정보 업데이트 : 예매완료
	 */
	@Override
	public void updateTicketReservation(TicketVO ticketToUpdate) {
		concertMapper.updateTicketReservation(ticketToUpdate);
	}

	@Override
	public List<ConcertVO> selectConcertListWithStatusFilter(PaginationInfoVO<ConcertVO> pagingVO, String statusFilter)
			throws Exception {
		log.info("selectConcertListWithStatusFilter() 실행...! statusFilter: {}", statusFilter);
        // Map으로 파라미터 변환
        Map<String, Object> params = new HashMap<>();
        params.put("pagingVO", pagingVO);
        params.put("statusFilter", statusFilter);
        List<ConcertVO> list = concertMapper.selectConcertListWithStatusFilter(params);
        if (list == null) {
            list = new ArrayList<>(); // null 방지
        }
        if (list != null) {
            for (ConcertVO item : list) {
                item.setRepresentativeImageUrl(null); // 반복문 시작 시 null 초기화
                if (item.getFileGroupNo() != null && item.getFileGroupNo() > 0) {
                    try {
                        log.debug("콘서트 ID {}의 파일 그룹 {} 대표 이미지 조회", item.getConcertNo(), item.getFileGroupNo());
                        AttachmentFileDetailVO repFile = fileService.getRepresentativeFileByGroupNo(item.getFileGroupNo());
                        if (repFile != null && repFile.getWebPath() != null && !repFile.getWebPath().isEmpty()) {
                            item.setRepresentativeImageUrl(repFile.getWebPath());
                            log.info("목록 - 콘서트 ID {}: 설정된 대표 이미지 URL: [{}]", item.getConcertNo(), item.getRepresentativeImageUrl());
                        } else {
                            log.warn("목록 - 콘서트 ID {}: 대표 이미지 파일 정보를 찾지 못함. FileGroupNo: {}", item.getConcertNo(), item.getFileGroupNo());
                        }
                    } catch (Exception e) {
                        log.error("목록 - 콘서트 ID {}의 대표 이미지 조회 중 오류 발생: {}", item.getConcertNo(), e.getMessage());
                    }
                } else {
                    log.debug("목록 - 콘서트 ID {}: 파일 그룹 번호가 없음", item.getConcertNo());
                }
            }
        }
        return list;
	}

	@Override
	public int selectConcertCountWithStatusFilter(PaginationInfoVO<ConcertVO> pagingVO, String statusFilter)
			throws Exception {
		log.info("selectConcertCountWithStatusFilter() 실행...! statusFilter: {}", statusFilter);
        // Map으로 파라미터 변환
        Map<String, Object> params = new HashMap<>();
        params.put("pagingVO", pagingVO);
        params.put("statusFilter", statusFilter);
        return concertMapper.selectConcertCountWithStatusFilter(params);
	}

	@Override
	public Map<String, Integer> selectConcertCountsByStatus() throws Exception {
	    log.info("selectConcertCountsByStatus() 실행...!");
	    List<Map<String, Object>> countList = concertMapper.selectConcertCountsByStatus();
	    Map<String, Integer> statusCounts = new HashMap<>();
	    log.debug("countList size: {}, content: {}", countList.size(), countList); // 전체 결과 확인
	    for (Map<String, Object> map : countList) {
	        String status = (String) map.get("STATUS");
	        Object countObj = map.get("COUNT");

	        Integer count = (countObj instanceof Number) ? ((Number) countObj).intValue() : 0;

	        statusCounts.put(status != null ? status : "", count);
	    }
	    log.debug("Final statusCounts: {}", statusCounts); // 최종 맵 확인
	    return statusCounts;
	}

	@Override
	public Map<String, Object> getSeatStatus(int concertNo) {
		Map<String, Object> seatStatus = new HashMap<>();
        try {
            // 총 좌석 수 조회 (해당 콘서트 홀의 모든 좌석)
            Integer totalSeats = concertMapper.selectTotalSeatsByConcertNo(concertNo);
            totalSeats = totalSeats != null ? totalSeats : 0;

            // 예매된 티켓 목록 조회 (mem_username과 order_det_no가 있는 것만)
            List<Map<String, Object>> purchasedTickets = concertMapper.selectTicketsByConcertNo(concertNo);
            int purchasedSeats = purchasedTickets != null ? purchasedTickets.size() : 0;

            // 남은 좌석 수 계산
            int remainingSeats = Math.max(0, totalSeats - purchasedSeats);

            // 총 판매금액 조회 (예매된 티켓의 가격 합계)
            Integer totalSales = concertMapper.selectTotalSalesByConcertNo(concertNo);
            totalSales = totalSales != null ? totalSales : 0;

            seatStatus.put("totalSeats", totalSeats);
            seatStatus.put("purchasedSeats", purchasedSeats);
            seatStatus.put("remainingSeats", remainingSeats);
            seatStatus.put("totalSales", totalSales);

            log.debug("getSeatStatus - concertNo: {}, totalSeats: {}, purchasedSeats: {}, remainingSeats: {}, totalSales: {}",
                    concertNo, totalSeats, purchasedSeats, remainingSeats, totalSales);
        } catch (Exception e) {
            log.error("getSeatStatus 오류 발생 - concertNo: {}, 메시지: {}", concertNo, e.getMessage());
            seatStatus.put("totalSeats", 0);
            seatStatus.put("purchasedSeats", 0);
            seatStatus.put("remainingSeats", 0);
            seatStatus.put("totalSales", 0);
        }
        return seatStatus;
	}

    @Override
    public List<Map<String, Object>> getDailyTicketStats(int concertNo, String startDate, String endDate) {
        log.info("getDailyTicketStats() 실행...! concertNo: {}, startDate: {}, endDate: {}", concertNo, startDate, endDate);

        try {
            List<Map<String, Object>> result = concertMapper.selectDailyTicketStats(concertNo, startDate, endDate);
            log.info("getDailyTicketStats 결과: {}건", result != null ? result.size() : 0);
            if (result != null && !result.isEmpty()) {
                log.debug("첫 번째 결과: {}", result.get(0));
            }
            return result != null ? result : new ArrayList<>();
        } catch (Exception e) {
            log.error("getDailyTicketStats 오류 발생: {}", e.getMessage(), e);
            return new ArrayList<>();
        }
    }

    @Override
    public List<Map<String, Object>> getDailyTicketStatsByGradeSection(int concertNo, String startDate, String endDate) {
        return concertMapper.selectDailyTicketStatsByGradeSection(concertNo, startDate, endDate);
    }

    @Override
    public List<Map<String, Object>> getDailyReservedSeats(int concertNo, String startDate, String endDate) {
        return concertMapper.selectDailyReservedSeats(concertNo, startDate, endDate);
    }

    /**
     * 스케쥴등 어노테이션을 활용하여 일정 시간 마다 콘서트 상태 변경
     */
    @Scheduled(cron = "0 0/10 * * * ?")
    @Transactional
    @Override
    public void updateConcertStatCode() {
    	// 콘서트 상태 코드 변경 시작일전까지 예정 공연 시작시 진행 공연 끝난 후 종료
    	// 예정 -> 진행
    	concertMapper.updateConcertStatCodeLiving();
    	// 진행 -> 종료
    	concertMapper.updateConcertStatCodeEnd();

    	// 예정 -> 선예매
    	concertMapper.updateConcertRvStatCodePreSale();
    	// 선예매 -> 예매
    	concertMapper.updateConcertRvStatCodeOnSale();
    	// 예매 -> 종료
    	concertMapper.updateConcertRvStatCodeEnd();
    }

    /**
     * 티켓에있는 콘서트 번호를 가져와서 해당 콘서트가 매진되었는지 판단 후 상태값 변경
     */
    @Scheduled(cron = "0 0/10 * * * ?")
    @Transactional
    @Override
    public void checkAndUpdateConcertStatCodeAllSaled() {
    	List<Integer> concertNoList = concertMapper.selectConcertNo();
    	if(concertNoList == null) {
    		log.info("업데이트할 콘서트 리스트 없음");
    		return;
    	}
    	for(int concertNo : concertNoList) {
    		concertMapper.updateRvStatCodeAllSale(concertNo);
    	}
    }

}