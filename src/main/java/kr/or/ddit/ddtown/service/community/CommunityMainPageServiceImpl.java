package kr.or.ddit.ddtown.service.community;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.community.ICommunityFollowMapper;
import kr.or.ddit.ddtown.mapper.community.ICommunityMainPageMapper;
import kr.or.ddit.ddtown.mapper.emp.artist.IArtistMapper;
import kr.or.ddit.ddtown.mapper.follow.IFollowMapper;
import kr.or.ddit.ddtown.service.alert.IAlertService;
import kr.or.ddit.ddtown.service.file.FileServiceImpl;
import kr.or.ddit.vo.alert.AlertVO;
import kr.or.ddit.vo.artist.AlbumVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.artist.ArtistVO;
import kr.or.ddit.vo.common.CommonCodeDetailVO;
import kr.or.ddit.vo.community.CommunityLikeVO;
import kr.or.ddit.vo.community.CommunityPostVO;
import kr.or.ddit.vo.community.CommunityProfileVO;
import kr.or.ddit.vo.community.CommunityReplyVO;
import kr.or.ddit.vo.community.CommunityReportVO;
import kr.or.ddit.vo.community.CommunityVO;
import kr.or.ddit.vo.community.WorldcupVO;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.file.AttachmentFileGroupVO;
import kr.or.ddit.vo.goods.goodsVO;
import kr.or.ddit.vo.live.LiveVO;
import kr.or.ddit.vo.report.ReportVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CommunityMainPageServiceImpl implements ICommunityMainPageService{

	@Value("${kr.or.ddit.upload.path}")
	private String windowUploadBasePath;

	@Value("${kr.or.ddit.upload.path.mac}")
	private String macUploadBasePath;

	private SimpleDateFormat KST_DATE_FORMAT = new SimpleDateFormat("yyyy/MM/dd");

	@Autowired
	private ICommunityMainPageMapper communityMainPageMapper;

	@Autowired
	private ICommunityFollowMapper communityFollowMapper;

	@Autowired
	private IAlertService alertService;

	@Autowired
	private FileServiceImpl fileService;

	@Override
	public List<ArtistGroupVO> getGroupLists() {
		return communityMainPageMapper.getGroupLists();
	}

	@Override
	public ArtistGroupVO getGroupInfo(int artGroupNo) {
		return communityMainPageMapper.getGroupInfo(artGroupNo);
	}

	@Override
	public List<AlbumVO> getGroupAlbum(int artGroupNo) {
		return communityMainPageMapper.getGroupAlbum(artGroupNo);
	}

	// 아티스트 탭 게시물 가져오기
	@Override
	public List<CommunityPostVO> getPostList(CommunityVO communityVO) {

		List<CommunityPostVO> postList = communityMainPageMapper.getPostList(communityVO);

		for(CommunityPostVO post : postList) {

			boolean isArtist = communityVO.isArtistTabYn();
			if(isArtist) {
				// 멤버십 전용 게시물 체크
				String mbsYn = post.getComuPostMbspYn();
				if(mbsYn.equals("Y")) {			// 멤버십 전용 게시물 이라면
					post.setMemberShipYn(true);	// 멤버십 여부에 true 셋팅
				}else {		// 멤버십 전용 게시물이 아니라면
					post.setMemberShipYn(false); // 멤버십 여부에 false 셋팅
				}
			}

			// 댓글 사용 여부 체크
			String boardReplyYn = post.getBoardReplyYn();
			if(boardReplyYn.equals("Y")) {
				post.setBoardReplyTf(true);
			}else {
				post.setBoardReplyTf(false);
			}

			// 게시글 파일 가져오기
			if(post.getFileGroupNo() != null) {	// 파일이 존재
				Integer fileGroupNo = post.getFileGroupNo();
				try {
					List<AttachmentFileDetailVO> files = fileService.getFileDetailsByGroupNo(fileGroupNo);
					post.setPostFiles(files);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		return postList;
	}

	// 팬탭 게시물 가져오기
	@Override
	public List<CommunityPostVO> getFanPostList(CommunityVO communityVO) {

		List<CommunityPostVO> postList = communityMainPageMapper.getFanPostList(communityVO);

		for(CommunityPostVO post : postList) {

			if(post.getFileGroupNo() != null) {
				Integer fileGroupNo = post.getFileGroupNo();
				List<AttachmentFileDetailVO> files;
				try {
					files = fileService.getFileDetailsByGroupNo(fileGroupNo);
					post.setPostFiles(files);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}


		return postList;
	}

	@Override
	public ArtistGroupVO getCommunityInfo(int artGroupNo) {

		return communityMainPageMapper.getCommunityInfo(artGroupNo);
	}

	@Override
	public int getPostTotal(CommunityVO communityVO) {

		int totalRecord = 0;

		if(communityVO.isArtistTabYn()) {
			totalRecord = communityMainPageMapper.getArtistPostTotal(communityVO);
		}else {
			totalRecord = communityMainPageMapper.getFanPostTotal(communityVO);
		}

		return totalRecord;
	}

	@Override
	public ServiceResult postInsert(CommunityPostVO postVO) {

		ServiceResult result = null;

		CommunityProfileVO currentUserComu = communityMainPageMapper.currentUserComufollowing(postVO);

		postVO.setComuProfileNo(currentUserComu.getComuProfileNo());

		// writerProfile필드에 작성자 프로필 정보 저장
		postVO.setWriterProfile(currentUserComu);

		boolean flag = false;

		for(MultipartFile file : postVO.getFiles()) {
			if(!file.isEmpty()) {
				flag = true;
			}
			break;
		}

		String boardTypeCode;

		if(postVO.isArtistTabYn()) {	// 등록하려는 게시물이 아티스트이라면
			boardTypeCode = "ARTIST_BOARD";
			postVO.setBoardTypeCode(boardTypeCode);

			String comuMbspYn = mebsYn(postVO);		// 멤버십 여부
			postVO.setComuPostMbspYn(comuMbspYn);

			if(postVO.getFiles() != null && postVO.getFiles().length > 0 && flag) {
				try {
					Integer fileGroupNo = fileService.uploadAndProcessFiles(postVO.getFiles(), "FITC006", postVO.getMemUsername());
					postVO.setFileGroupNo(fileGroupNo);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}else {
			boardTypeCode = "FAN_BOARD";
			postVO.setBoardTypeCode(boardTypeCode);

			if(postVO.getFiles() != null && postVO.getFiles().length > 0 && flag) {
				try {
					Integer fileGroupNo = fileService.uploadAndProcessFiles(postVO.getFiles(), "FITC006", postVO.getMemUsername());
					postVO.setFileGroupNo(fileGroupNo);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		postVO.setComuPostStatCode("CPSC001");

		int status = communityMainPageMapper.postInsert(postVO);

		if(status > 0) {
			result = ServiceResult.OK;

			////////////// 알림 발송 로직 //////////////
			if(postVO.isArtistTabYn()) {
				try {
					String writerMemUsername = postVO.getMemUsername();		// 게시글 작성자정보
					Integer artGroupNo = postVO.getArtGroupNo();			// 아티스트그룹번호 가져옴
					Integer wrtierComuProfileNo = postVO.getComuProfileNo();

					// 해당 아티스트 그룹 팔로우하는 모든 수신자 조회
					List<String> recipientUsernames = communityFollowMapper.selectFollowersByArtGroup(artGroupNo);

					// 게시글 작성자는 알림제외
					if(recipientUsernames != null) {
						recipientUsernames.remove(writerMemUsername);
					}

					if(recipientUsernames != null && !recipientUsernames.isEmpty()) {
						AlertVO alert = new AlertVO();
						alert.setAlertTypeCode("ATC001");
						alert.setRelatedItemTypeCode("ITC001");
						alert.setRelatedItemNo(postVO.getComuPostNo());
						alert.setArtGroupNo(artGroupNo);
						alert.setRelatedTargetProfileNo(wrtierComuProfileNo);
						alert.setBoardTypeCode(boardTypeCode);
						alert.setAlertContent(postVO.getWriterProfile().getComuNicknm() + "님의 새 게시글이 등록됐습니다!!");

						String alertUrl = "/community/" + artGroupNo + "/profile/" + postVO.getComuProfileNo() + "#post-" + postVO.getComuPostNo();
						alert.setAlertUrl(alertUrl);

						alertService.createAlert(alert, recipientUsernames);
						log.info("아티스트 게시글 알림 생성 및 발송 요청 성공!!. 게시글 번호: {}, 수신자 수: {}", postVO.getComuPostNo(), recipientUsernames.size());
					} else {
						log.info("아티스트 게시글 알림을 보낼 팔로워가 없습니다..파이팅..");
					}

				} catch (Exception e) {
					log.error("아티스트 게시글 알림 발송 중 오류발생!!! 게시글 번호: {}", postVO.getComuPostNo(), e);
				}
			} else {
				log.info("팬 게시판 게시글은 알림 보내지않음 게시글 번호 : {}", postVO.getComuPostNo());
			}

		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	private String mebsYn(CommunityPostVO postVO) {

		if(postVO.isMemberShipYn()) {
			return "Y";
		}else {
			return "N";
		}
	}

	@Override
	public ServiceResult postUpdate(CommunityPostVO postVO) {

		ServiceResult result = null;

		try {
			boolean appendFlag = false;
			boolean deleteFlag = false;

			if (postVO.getFiles() != null) {
				for(MultipartFile file : postVO.getFiles()) {
					if(!"".equals(file.getOriginalFilename())) {
						appendFlag = true;
					}
					break;
				}
			}

			if(postVO.getDeleteFiles() != null && !postVO.getDeleteFiles().isEmpty()) {
				deleteFlag = true;
			}

			if(appendFlag || deleteFlag) {
				List<AttachmentFileDetailVO> files = null;
				Integer oldFileGroupNo = postVO.getFileGroupNo();

				if(oldFileGroupNo != null && oldFileGroupNo != 0) {
					// 파일 그룹으로 이전 파일들을 가지고 옴
					files = fileService.getFileDetailsByGroupNo(oldFileGroupNo);
				}

				// 삭제할 파일 번호
				Set<Integer> deleteFileNo;
				if(deleteFlag) {
					deleteFileNo = new HashSet<>(postVO.getDeleteFiles());
				}else {
					deleteFileNo = new HashSet<>();
				}

				// 이전 파일들의 상세번호가 담길 객체
				List<Integer> filesNum = new ArrayList<>();

				// 이전 파일들이 비어있지 않으면 아래를 수행함
				if(files != null && !files.isEmpty()) {

					Iterator<AttachmentFileDetailVO> iter = files.iterator();
					while(iter.hasNext()) {
						AttachmentFileDetailVO file = iter.next();

						filesNum.add(file.getAttachDetailNo());

						if(deleteFileNo.contains(file.getAttachDetailNo())) {
							iter.remove();
						}
					}

				}

				// 수정 폼에서 새롭게 추가한 파일을 newFiles에 담아줌
				MultipartFile[] newFiles = postVO.getFiles();

				// 파일 그룹 번호를 초기화해줌
				Integer fileGroupNo = null;
				String newFileRegDate = KST_DATE_FORMAT.format(new Date());
				// 새롭게 추가된 파일이 비어있지 않으면 아래를 수행함
				if(newFiles != null && !newFiles[0].getOriginalFilename().isBlank() && !newFiles[0].getOriginalFilename().isEmpty() && !"".equals(newFiles[0].getOriginalFilename()) ) {
					// 새롭게 추가된 파일과 타입코드와 수정을 시도한 유저의 아이디를 넣어주고 개별 파일을 등록하고 새로운 파일그룹번호를 반환받음
					fileGroupNo = fileService.uploadAndProcessFiles(newFiles, "FITC006", postVO.getMemUsername());
				}else {
					AttachmentFileGroupVO groupVO = new AttachmentFileGroupVO();
					groupVO.setFileTypeCode("FITC006");
					groupVO.setFileTypeNm("커뮤니티 게시글 파일");
					communityMainPageMapper.insertFileGroup(groupVO);
					fileGroupNo = groupVO.getFileGroupNo();
				}
				// 파일 그룹 번호를 받아온 파라미터 안에 있는 파일 그룹번호를 초기화해줌
				postVO.setFileGroupNo(fileGroupNo);

				// 삭제하고 남은 기존에 있던 파일이 비어있지 않다면 아래를 수행함
				if(files != null && !files.isEmpty()) {

					// 1. 현재 OS에 맞는 기본 업로드 경로 선택
					String os = System.getProperty("os.name").toLowerCase();
					String currentUploadBasePath;

					if(os.contains("mac") || os.contains("darwin")) {
						currentUploadBasePath = macUploadBasePath;
					} else if(os.contains("win")) {
						currentUploadBasePath = windowUploadBasePath;
					} else {
						currentUploadBasePath = windowUploadBasePath;
					}

					List<AttachmentFileDetailVO> dbFiles = fileService.getFileDetailsByGroupNo(fileGroupNo);

					String newFilesDate = null;
					if(!dbFiles.isEmpty() && dbFiles != null) {
						newFilesDate = dbFiles.get(0).getFileSavepath();
					}else {
						newFilesDate = newFileRegDate;
					}

					// 기존에 있던 파일 경로
					String path = currentUploadBasePath + File.separator + files.get(0).getFileSavepath();
					String prePath = path.replace("\\", "/");

					File finalUploadDirectory = new File(currentUploadBasePath + File.separator + newFilesDate);

					if (!finalUploadDirectory.exists()) {
						finalUploadDirectory.mkdirs();		// 폴더생성
					}

					// 기존에 있던 파일을 반복을 통해 하나씩 꺼냄
					for(AttachmentFileDetailVO file : files) {

						Path oldPath = Paths.get(prePath, file.getFileSaveNm());

						Path targetPath = Paths.get(currentUploadBasePath + File.separator + newFilesDate);

						Path targetFile = targetPath.resolve(file.getFileSaveNm());


						File checkFile = new File(targetFile.toString());
						String originalFileName = file.getFileOriginalNm();
						String fileExtension = "";
						String saveFileName = null;
						if(checkFile.exists()) {
							fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
							saveFileName = UUID.randomUUID().toString() + fileExtension;
							log.info("새로운 파일 명 : " + saveFileName);
							targetFile = targetPath.resolve(saveFileName);
						}else {
							saveFileName = file.getFileSaveNm();
						}

						Files.move(oldPath, targetFile,StandardCopyOption.REPLACE_EXISTING);

						file.setFileSavepath(newFilesDate);
						// 기존에 있던 파일의 그룹번호를 변경
						file.setFileGroupNo(fileGroupNo);
						file.setFileSaveNm(saveFileName);
						file.setAttachDetailNo(0);
						// 기존에 있던 파일을 새롭게 추가된 파일들과 같은 그룹번호에 추가하는 작업
						communityMainPageMapper.fileReUpload(file);
					}
				}
				if(!filesNum.isEmpty() && filesNum != null) {
					// 이전에 있던 모든 파일을 삭제함
					fileService.deleteSpecificFiles(filesNum);
				}

				if(oldFileGroupNo != null) {
					// 이전에 있던 파일을 담고 있던 파일 그룹번호를 삭제함
					fileService.deleteFilesByGroupNo(oldFileGroupNo);
				}
			}


			// 게시판 타입 코드가 비어있으면 아래를 수행함
			if(postVO.getBoardTypeCode() == null) {
				// 수정하는 게시판이 아티스트 게시판이라면 아래를 수행함
				if(postVO.isArtistTabYn()) {
					String boardTypeCode = "ARTIST_BOARD";
					postVO.setBoardTypeCode(boardTypeCode);

					if(postVO.isMemberShipYn()) {
						postVO.setComuPostMbspYn("Y");
					}else {
						postVO.setComuPostMbspYn("N");
					}

				}else {	// 수정하는 게시판이 팬 게시판이라면 아래를 수행함
					String boardTypeCode = "FAN_BOARD";
					postVO.setBoardTypeCode(boardTypeCode);
				}
			}

			// 게시판 수정 진행
			int status = communityMainPageMapper.updatePost(postVO);

			// 게시판 수정이 정상적으로 된다면 아래를 수행
			if(status > 0) {
				result = ServiceResult.OK;
			}else {		// 게시판 수정이 되지 않으면 아래를 수행
				result = ServiceResult.FAILED;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 팔로우중인 프로필 VO 가져오기 + 쓴 글 + 댓글 목록
	 */
	@Override
	public CommunityProfileVO currentUserComufollowing(Map<String, Object> currentUser) {

		CommunityProfileVO currentUserComu = communityMainPageMapper.getComuProfile(currentUser);
		if(currentUserComu != null) {
			List<CommunityPostVO> postList = communityMainPageMapper.selectPostList(currentUserComu);
			List<CommunityReplyVO> replyList = communityMainPageMapper.selectReplyList(currentUserComu);
			String memberShipYn = communityMainPageMapper.comuMemberShipYn(currentUser);
			currentUserComu.setMemberShipYn(memberShipYn);
			currentUserComu.setPostList(postList);
			currentUserComu.setReplyList(replyList);
		}

		return currentUserComu;
	}

	@Override
	public CommunityPostVO getPost(CommunityPostVO comuPostVO) {

		CommunityPostVO postVO = communityMainPageMapper.getPost(comuPostVO);

		String boardType = postVO.getBoardTypeCode();

		String memberShipYn = postVO.getComuPostMbspYn();

		if("ARTIST_BOARD".equals(boardType)) {
			if("Y".equals(memberShipYn)) {
				postVO.setMemberShipYn(true);
			}
			postVO.setArtistTabYn(true);
		}else {
			postVO.setArtistTabYn(false);
		}

		if(postVO.getFileGroupNo() != null) {
			try {
				List<AttachmentFileDetailVO> files = fileService.getFileDetailsByGroupNo(postVO.getFileGroupNo());
				postVO.setPostFiles(files);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return postVO;
	}


	/**
	 * comuProfileNo, artGroupNo로 프로필VO 찾은 후 해당 프로필이 작성한 글 목록 및 댓글 목록 가져오기
	 * @param profileVO
	 * @return
	 */
	@Override
	public CommunityProfileVO selectProfile(CommunityProfileVO profileVO) {
		return communityMainPageMapper.selectProfile(profileVO);
	}

	@Override
	public ServiceResult postDelete(CommunityPostVO comuPostVO) {

		ServiceResult result = null;

		CommunityPostVO postVO = communityMainPageMapper.getPost(comuPostVO);

		postVO.setComuPostDelYn("Y");

		int status = communityMainPageMapper.postDeleteUpdate(postVO);

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	// 댓글 영역
	@Transactional
	@Override
	public Map<Object, Object> replyInsert(CommunityReplyVO replyVO, String memUsername) {
		ServiceResult result = null;

		Map<Object, Object> map = new HashMap<>();

		// 댓글 작성자 프로필 정보 및 조회 설정
		CommunityPostVO tempPostForProfile = new CommunityPostVO();
		tempPostForProfile.setMemUsername(memUsername);
		tempPostForProfile.setArtGroupNo(replyVO.getArtGroupNo());

		CommunityProfileVO replyAuthorProfile = communityMainPageMapper.currentUserComufollowing(tempPostForProfile);
		if(replyAuthorProfile == null) {
			log.error("댓글 작성자 프로필 찾기 실패.. artGroupNo: {}, memUsername : {},댓글 삽입 실패..", replyVO.getArtGroupNo(), memUsername);
			map.put("result", ServiceResult.FAILED);
			map.put("message", "댓글 작성자 프로필을 찾을 수 없습니다..");
			return map;
		}

		replyVO.setComuProfileNo(replyAuthorProfile.getComuProfileNo());	// 조회한 프로필 번호 설정

		// 댓글 삽입 -- comuReplyNo 설정 해야댐
		int status = communityMainPageMapper.replyInsert(replyVO);

		if(status > 0) {
			int replyCount = communityMainPageMapper.getReplyCount(replyVO);

			replyVO.setReplyCount(replyCount);

			try {
				// replyAuthorProfile에서 회원아이디랑 닉네임 가져옴
				String replyAuthorUsername = replyAuthorProfile.getMemUsername();
				String replyAuthorNickNm = replyAuthorProfile.getComuNicknm();
				Integer artGroupNo = replyVO.getArtGroupNo();			// 아티스트그룹번호 가져옴

				CommunityPostVO tempPostVO = new CommunityPostVO();
				tempPostVO.setComuPostNo(replyVO.getComuPostNo());
				tempPostVO.setComuProfileNo(replyVO.getComuProfileNo());
				CommunityPostVO post = communityMainPageMapper.selectPostOne(tempPostVO);
				log.info("post객체 : " + post);

				if(post == null) {
					log.warn("댓글 알림 발송 실패.. 원본 게시글 못찾음, 게시글번호 : {}", replyVO.getComuPostNo());
				} else {
					CommunityProfileVO postAuthorProfile = post.getWriterProfile();
					if(postAuthorProfile == null && post.getComuProfileNo() != 0) {
						CommunityProfileVO tempPostProfile = new CommunityProfileVO();
						tempPostProfile.setComuProfileNo(post.getComuProfileNo());
						postAuthorProfile = communityMainPageMapper.selectProfile(tempPostProfile);
					}

					String postAuthorUsername = (postAuthorProfile != null) ? postAuthorProfile.getMemUsername() : null;

					AlertVO alert = new AlertVO();
					alert.setAlertTypeCode("ATC002");
					alert.setRelatedItemTypeCode("ITC002");
					alert.setRelatedItemNo(replyVO.getComuPostNo());		// 관련 게시글 번호
					alert.setArtGroupNo(post.getArtGroupNo());		// 게시글의 아티스트 그룹번호

					if(postAuthorProfile != null) {
						alert.setRelatedTargetProfileNo(postAuthorProfile.getComuProfileNo());	// 게시글 작성자 프로필번호
					}

					alert.setBoardTypeCode(post.getBoardTypeCode());		// 게시글 보드 타입 (ARTIST_BOARD/FAN_BOARD)

					String alertUrl = "/community/" + artGroupNo + "/profile/" + post.getComuProfileNo() + "?refresh=" + System.currentTimeMillis() + "#post-" + post.getComuPostNo();
					alert.setAlertUrl(alertUrl);


					List<String> recipientUsernames = new ArrayList<>();

					String alertMessage	 = null;
					String summaryContent = replyVO.getComuReplyContent();

					if(postAuthorUsername != null && !postAuthorUsername.equals(replyAuthorUsername)) {
						recipientUsernames.add(postAuthorUsername);		// 알림 수신자에 들어갈 게시글 작성자이름 추가
						log.info("게시글 작성자 '{}' 에게 댓글 알림 대상 추가", postAuthorUsername);

						alertMessage = "'" + replyAuthorNickNm + "'님이 회원님의 게시글에 댓글을 남겼습니다 \n " + replyAuthorNickNm
								+ " : " + summaryContent;
						alert.setAlertContent(alertMessage);

						alertService.createAlert(alert, recipientUsernames);	// 알림 및 수신자 설정
						log.info("댓글 알림 생성 및 발송 요청 성공!! 회원 - {}", recipientUsernames);
						// 알림까지 전송했으면 결과값 OK
					} else {
						log.info("댓글 알림을 보낼 대상자가 없습니다..");
					}
					result = ServiceResult.OK;
				}

			} catch (Exception e) {
				log.error("댓글 알림 발송 중 오류 발생!! 게시글 번호 : {}, 작성자 프로필번호 : {}", replyVO.getComuPostNo(), replyVO.getComuProfileNo(), e);

			}
		}else {
			result = ServiceResult.FAILED;
		}

		map.put("result", result);
		map.put("replyVO", replyVO);

		return map;
	}

	/**
	 * 포스트 번호로 해당 포스트 가져오기 및 댓글 정보 가져오기
	 */
	@Override
	public CommunityPostVO selectPost(CommunityPostVO cPostVO) {
		return communityMainPageMapper.selectPostOne(cPostVO);
	}

	@Override
	public ServiceResult replyUpdate(CommunityReplyVO replyVO) {
		ServiceResult result = null;

		int status = communityMainPageMapper.replyUpdate(replyVO);

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public ServiceResult replyDelete(int replyNo) {
		ServiceResult result = null;

		int status = communityMainPageMapper.replyDelete(replyNo);

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public ServiceResult likeUpdate(CommunityLikeVO likeVO) {
		ServiceResult result = null;
		int status = 0;
		int insertDelete = likeVO.getInsertDelete();

		// 등록
		if(insertDelete > 0) {
			status = communityMainPageMapper.likeInsert(likeVO);

			if(status > 0) {
				//////////////////// 알림 로직 추가 ////////////////
				try {
					// 좋아요 눌린 게시글 정보 조회
					CommunityPostVO postVO = new CommunityPostVO();
					postVO.setComuPostNo(likeVO.getComuPostNo());
					postVO.setComuProfileNo(likeVO.getComuProfileNo());
					CommunityPostVO likedPost = communityMainPageMapper.getPost(postVO);

					// 게시글 작성자랑 좋아요 누른사람 동일하면 알림 안보냄 (자추금지)
					if(likedPost != null && likedPost.getComuProfileNo() != likeVO.getComuProfileNo()) {
						// 좋아요를 누른 회원 닉네임 조회
						CommunityProfileVO likerProfile = communityMainPageMapper.getProfileByComuProfileNo(likeVO.getComuProfileNo());
						String likerNicknm = (likerProfile != null) ? likerProfile.getComuNicknm() : "알 수 없는 사용자";
						Integer artGroupNo = likeVO.getArtGroupNo();

						AlertVO alert = new AlertVO();
						alert.setAlertTypeCode("ATC005");		// 좋아요 알림 코드
						alert.setRelatedItemTypeCode("ITC005");		// 좋아요 관련 아이템 타입 코드
						alert.setRelatedItemNo(likeVO.getComuLikeNo());	// 좋아요 눌린 게시글 번호
						alert.setArtGroupNo(likedPost.getArtGroupNo());				// 게시글이 속한 아티스트 그룹번호
						alert.setRelatedTargetProfileNo(likedPost.getComuProfileNo());	// 알림 받을 대상 프로필 번호

						alert.setAlertContent(likerNicknm + "님이 회원님의 게시글에 좋아요를 눌렀습니다.");

						String alertUrl = "/community/" + artGroupNo + "/profile/" + likeVO.getComuProfileNo() + "#post-" + likeVO.getComuPostNo();
						alert.setAlertUrl(alertUrl);

						// 알림 받을 수신자 (게시글 작성자)
						String postWriterUsername = communityMainPageMapper.getMemberUsernameByComuProfileNo(likedPost.getComuProfileNo());

						if(postWriterUsername != null) {
							alertService.createAlert(alert, Collections.singletonList(postWriterUsername));
							log.info("좋아요 알림 발송 성공!! 게시글 번호: {}, 대상: {}", likedPost.getComuProfileNo(), postWriterUsername);
						} else {
							log.warn("좋아요 알림 발송 실패.. 게시글 작성자 아이디 조회 실패");
						}
					}
				} catch (Exception e) {
					log.error("좋아요 알림 발송 중 오류 발생!! 게시글 번호: {}", likeVO.getComuPostNo(), e);
				}
			}
		}else if(insertDelete < 0) {
			CommunityLikeVO deleteLikeVO = communityMainPageMapper.getLikeInfo(likeVO);
			status = communityMainPageMapper.likeDelete(deleteLikeVO);
		}else {
			result = ServiceResult.EXIST;
		}


		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	@Override
	public Map<Object, Object> getCodeDetail() {

		String reasonCodeGroupNo = "REPORT_REASON_CODE";
		String reportTarCodeGroupNo = "REPORT_TAR_TYPE_CODE";
		String reportStatCodeGroupNo = "REPORT_STAT_CODE";

		List<CommonCodeDetailVO> reportReasonCode = communityMainPageMapper.getCodeDetail(reasonCodeGroupNo);
		List<CommonCodeDetailVO> reportTarTypeCode = communityMainPageMapper.getCodeDetail(reportTarCodeGroupNo);
		List<CommonCodeDetailVO> reportStatCode = communityMainPageMapper.getCodeDetail(reportStatCodeGroupNo);

		Map<Object, Object> map = new HashMap<>();
		map.put("reasonCode", reportReasonCode);
		map.put("reportTarCode", reportTarTypeCode);
		map.put("reportStatCode", reportStatCode);

		return map;
	}

	@Transactional
	@Override
	public ServiceResult report(CommunityReportVO comuReportVO) {

		ServiceResult result = null;

		// 동일한 게시글에 신고를 했는 지 확인
		CommunityReportVO vo = communityMainPageMapper.getReprot(comuReportVO);

		if("Y".equals(vo.getReportYn())) {
			return ServiceResult.EXIST;
		}

		CommunityProfileVO tempProfile = new CommunityProfileVO();
		tempProfile.setArtGroupNo(comuReportVO.getArtGroupNo());
		tempProfile.setComuProfileNo(comuReportVO.getTargetComuProfileNo());

		CommunityProfileVO profile = communityMainPageMapper.selectProfile(tempProfile);

		String targetMemUsername = profile.getMemUsername();

		comuReportVO.setTargetMemUsername(targetMemUsername);
		comuReportVO.setReportStatCode("RSC001");
		comuReportVO.setReportResultCode("RRTC001");

		communityMainPageMapper.report(comuReportVO);

		int reportNo = comuReportVO.getReportNo();

		ReportVO reportVO = new ReportVO();
		reportVO.setReportNo(reportNo);

		int status = communityMainPageMapper.reportDetailInsert(reportVO);

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}

		return result;
	}

	/**
	 * 유저네임과 그룹번호로 프로필번호가져오기
	 */
	@Override
	public int getMyComuProfileNo(CommunityProfileVO myProfileVO) {
		return communityMainPageMapper.getMyComuProfileNo(myProfileVO);
	}


	/**
	 * 업데이트할 포스트 정보 가져오기
	 */
	@Override
	public CommunityPostVO getUpdatePost(int comuPostNo) {
		return communityMainPageMapper.getUpdatePost(comuPostNo);
	}


	/**
	 * 글 삭제 여부 Y변경
	 */
	@Override
	public ServiceResult deletPostByComuPostNo(CommunityPostVO postVO) {
		ServiceResult result = null;
		int status = communityMainPageMapper.postDeleteUpdate(postVO);
		result = status>0 ? ServiceResult.OK : ServiceResult.FAILED;
		return result;
	}

	@Override
    public LiveVO getLiveBroadcastInfo(int artGroupNo) {
        return communityMainPageMapper.getLiveBroadcastInfo(artGroupNo);
    }

	@Override
	public Integer getMembershipGoodsNo(int artGroupNo) {
		return communityMainPageMapper.getMembershipGoodsNo(artGroupNo);
	}

	/**
	 * memUsername과 artGroupNo로 해당 커뮤니티 멤버쉽가입여부 확인
	 * @param myProfileVO
	 * @return
	 */
	@Override
	public boolean getMyMemberShipYn(CommunityProfileVO myProfileVO) {
		int status = communityMainPageMapper.getMyMemberShipYn(myProfileVO);
		return status > 0;
	}

	@Override
	public List<LiveVO> getLiveHistory(int artGroupNo) {
		return communityMainPageMapper.getLiveHistory(artGroupNo);
	}

	@Override
	public List<goodsVO> thumbnailInfo(int artGroupNo) {

		List<goodsVO> thumbnailInfo = communityMainPageMapper.thumbnailInfo(artGroupNo);

		if(thumbnailInfo != null && !thumbnailInfo.isEmpty()) {
			for(goodsVO thumbnail : thumbnailInfo) {
				Integer fileGroupNo = thumbnail.getFileGroupNo();
				try {
					AttachmentFileDetailVO thum = fileService.getRepresentativeFileByGroupNo(fileGroupNo);
					thumbnail.setRepresentativeImageFile(thum);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return thumbnailInfo;
	}

	@Override
	public int getFansWithoutDel(int artGroupNo) {
		return communityMainPageMapper.getFansWithoutDel(artGroupNo);
	}

	@Override
	public List<ArtistVO> artistList() {
		return communityMainPageMapper.artistList();
	}

	@Override
	public ServiceResult worldcupWinner(WorldcupVO worldcupVO) {
		ServiceResult result = null;

		int status = communityMainPageMapper.worldcupWinner(worldcupVO);

		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	@Override
	public List<WorldcupVO> winnerList() {
		return communityMainPageMapper.winnerList();
	}

}
