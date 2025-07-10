package kr.or.ddit.ddtown.service.admin.group;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.admin.artist.IAdminArtistMapper;
import kr.or.ddit.ddtown.mapper.admin.group.IAdminArtistGroupMapper;
import kr.or.ddit.ddtown.mapper.community.CommunityProfileMapper;
import kr.or.ddit.ddtown.mapper.community.ICommunityMapper;
import kr.or.ddit.ddtown.service.admin.artist.IAdminArtistService;
import kr.or.ddit.ddtown.service.chat.dm.IChatChannelService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.AlbumVO;
import kr.or.ddit.vo.artist.ArtistGroupMapVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.artist.ArtistVO;
import kr.or.ddit.vo.community.CommunityProfileVO;
import kr.or.ddit.vo.community.CommunityVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminArtistGroupServiceImpl implements IAdminArtistGroupService {

	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;

	@Autowired
	private IAdminArtistGroupMapper artistGroupMapper;

	@Autowired
	private IAdminArtistMapper artistMapper;

	@Autowired
	private ICommunityMapper communityMapper;

	@Autowired
	private CommunityProfileMapper commProfileMapper;

	@Autowired
	private IChatChannelService chatChannelService;

	@Autowired
	private IAdminArtistService artistService;

	/**
	 * 페이징 처리된 총 레코드 수 가져오기
	 */
	@Override
	public int getTotalRecord(PaginationInfoVO<ArtistGroupVO> pagingVO, String artGroupDelYn) {
		return artistGroupMapper.getTotalRecord(pagingVO,artGroupDelYn);
	}

	/**
	 * 페이징 처리된 그룹 리스트 가져오기
	 */
	@Override
	public List<ArtistGroupVO> getGroupList(PaginationInfoVO<ArtistGroupVO> pagingVO,String artGroupDelYn) {
		List<ArtistGroupVO> groupList = artistGroupMapper.getGroupList(pagingVO,artGroupDelYn);
		for(ArtistGroupVO groupVO : groupList) {
			List<ArtistVO> artistVO = artistService.getArtistListByGroupNo(groupVO.getArtGroupNo());
			groupVO.setArtistList(artistVO);
		}
		if(StringUtils.isNotBlank(pagingVO.getSearchType()) && "member".equals(pagingVO.getSearchType())) {
			groupList = groupList.stream()
						.filter(group -> {
							if(group.getArtistList() == null || group.getArtistList().isEmpty()) {
								return false;
							}
							return group.getArtistList().stream()
									.anyMatch(artist -> Objects.nonNull(artist.getArtNm()) && artist.getArtNm().contains(pagingVO.getSearchWord()));
						})
						.toList();
		}
		return groupList;
	}

	/**
	 *	해당 그룹번호를 통해 그룹 상세정보 가져오기
	 */
	@Override
	public ArtistGroupVO getGroupDetail(int artGroupNo) {
		ArtistGroupVO groupVO = artistGroupMapper.getGroupDetailWithArtist(artGroupNo);
		List<AlbumVO> albumVO = artistGroupMapper.getAlbumList(artGroupNo);
		groupVO.setAlbumList(albumVO);
		return groupVO;
	}

	/**
	 *	그룹 추가 수정시 그룹에 속해있지않은 앨범리스트를 가져온다.
	 */
	@Override
	public List<AlbumVO> getAlbumListAll() {
		return artistGroupMapper.getAlbumListAll();
	}

	/**
	 *	그룹 정보 수정
	 */
	@Transactional
	@Override
	public ServiceResult updateGroup(ArtistGroupVO groupVO) {
		ServiceResult result = null;
		// 프로필 이미지 처리
		MultipartFile img = groupVO.getProfileImage();
		if(img != null && StringUtils.isNotBlank(img.getOriginalFilename())) {
			// 처리전 기존 이미지파일 삭제
			try {
				String savePath = groupVO.getArtGroupProfileImg();
				log.info(savePath);
				if(StringUtils.isNotBlank(savePath)) {
					savePath = savePath.replace("/upload", uploadPath);
					log.info("파일경로 -> :" + savePath);

					File file = new File(savePath);
					if(file.exists()) {
						log.info("파일 존재함");
						file.delete();
					}
				}
				// 새로운 이미지 경로
				String imgUrl = uploadImg(img);
				groupVO.setArtGroupProfileImg(imgUrl);
			} catch (IllegalStateException | IOException e) {
				return ServiceResult.FAILED;
			}
		}
		// 아티스트 멤버 삭제 처리 // artist_group_map 에서 del_yn y처리
		if(groupVO.getRemoveArtists() != null) {
			for(int artNo : groupVO.getRemoveArtists()) {
				int artGroupNo = groupVO.getArtGroupNo();
				ArtistVO artVO = new ArtistVO();
				artVO.setArtNo(artNo);
				artVO.setArtGroupNo(artGroupNo);
				// 아티스트 그룹 맵 del 여부 y 변경
				artistMapper.deleteArtGroup(artVO);
				// 아티스트 커뮤니티 프로필을 찾기 위한 아티스트 아이디 찾기
				String memUsername = artistMapper.selectArtistUsername(artVO);
				artVO.setMemUsername(memUsername);
				// 아티스트 커뮤니티 프로필 찾기
				CommunityProfileVO profileVO = commProfileMapper.selectCommProfileArtist(artVO);
				// 커뮤니티 프로필 del 여부 토글방식으로 변경
				commProfileMapper.updateCommProfileArtistDelYN(profileVO);

			}
		}
		// 앨범 삭제 처리
		if(groupVO.getRemoveAlbums() != null) {
			for(int albumNo : groupVO.getRemoveAlbums()) {
				artistGroupMapper.deleteAlbumGroup(albumNo);
			}
		}
		// 아티스트 추가 처리
		if(groupVO.getAddArtists() != null) {
			for(int artNo : groupVO.getAddArtists()) {
				ArtistVO artVO = new ArtistVO();
				artVO.setArtGroupNo(groupVO.getArtGroupNo());
				artVO.setArtNo(artNo);
				int checkFlag = artistMapper.checkArtGroup(artVO);
				if(checkFlag > 0) {
					// 아티스트 그룹 맵 del N 변경
					artistMapper.updateArtistGroupDelYn(artVO);

				}else {
					// 아티스트 그룹 맵 추가
					artistMapper.insertArtistGroupMap(artVO);
				}
				// 커뮤니티 프로필 추가
				CommunityProfileVO profileVO = new CommunityProfileVO();
				// 아티스트 정보 가져오기
				ArtistVO artistVO = artistMapper.getArtistDetail(artNo);
				// 아티스트 데뷔없으면 데뷔일 추가
				if(StringUtils.isBlank(artistVO.getArtDebutdate())) {
					artistMapper.updateArtistDebut(artistVO);
				}
				profileVO.setArtGroupNo(groupVO.getArtGroupNo());
				profileVO.setComuMemCatCode("CMCC003");
				profileVO.setComuNicknm(artistVO.getArtNm());
				profileVO.setComuProfileImg(artistVO.getArtProfileImg());
				profileVO.setMemUsername(artistVO.getMemUsername());
				// 커뮤니티 프로필 추가
				commProfileMapper.registCommProfileArtist(profileVO);
			}
		}
		// 앨범 추가 처리
		if(groupVO.getAlbumList() != null) {
			for(int albumNo : groupVO.getAddAlbums()) {
				AlbumVO albumVO = new AlbumVO();
				albumVO.setArtGroupNo(groupVO.getArtGroupNo());
				albumVO.setAlbumNo(albumNo);
				int checkFlag = artistGroupMapper.checkAlbumGroupNo(albumVO);
				if(checkFlag <= 0) {
					artistGroupMapper.insertArtistGroupNo(albumVO);
				}
			}
		}

		// 아티스트 그룹 변경
		int status = artistGroupMapper.updateGroup(groupVO);
		result = status > 0 ? ServiceResult.OK : ServiceResult.FAILED;
		return result;
	}

	/**
	 * 아티스트 그룹 추가 서비스
	 */
	@Transactional
	@Override
	public ServiceResult registArtistGroup(ArtistGroupVO groupVO) {
		ServiceResult result = null;
		// 그룹 이미지 처리
		MultipartFile img = groupVO.getProfileImage();
		if(img != null && StringUtils.isNotBlank(img.getOriginalFilename())) {
			// 처리전 기존 이미지파일 삭제
			try {
				// 새로운 이미지 경로
				String imgUrl = uploadImg(img);
				groupVO.setArtGroupProfileImg(imgUrl);
			} catch (IllegalStateException | IOException e) {
				return ServiceResult.FAILED;
			}
		}

		// 아티스트 그룹 테이블 추가
		int status = artistGroupMapper.registArtistGroup(groupVO);
		// 커뮤니티 생성
		if(status > 0) {
			CommunityVO communityVO = new CommunityVO();
			communityVO.setArtGroupNo(groupVO.getArtGroupNo());
			communityVO.setComuContent(groupVO.getArtGroupContent());
			communityVO.setComuNm(groupVO.getArtGroupNm());
			communityVO.setComuActCode("CAC001");
			status = communityMapper.registCommunity(communityVO);
		}
		// 아티스트 그룹 맵에 아티스트 추가 && 아티스트 커뮤니티 프로필 추가
		if(status > 0) {
			int[] addArtistList = groupVO.getAddArtists();
			if(addArtistList != null) {
				for(int artNo : addArtistList) {
					ArtistGroupMapVO agmVO = new ArtistGroupMapVO();
					agmVO.setArtGroupNo(groupVO.getArtGroupNo());
					agmVO.setArtNo(artNo);
					status = artistGroupMapper.registArtistGroupMap(agmVO);

					if(status > 0) {
						// 아티스트 정보 가져오기
						ArtistVO artistVO = artistMapper.getArtistDetail(artNo);
						// 아티스트 데뷔없으면 데뷔일 추가
						if(StringUtils.isBlank(artistVO.getArtDebutdate())) {
							artistVO.setArtDebutdate(groupVO.getArtGroupDebutdate());
							artistMapper.updateArtistDebut(artistVO);
						}
						CommunityProfileVO profileVO = new CommunityProfileVO();
						profileVO.setArtGroupNo(groupVO.getArtGroupNo());
						profileVO.setComuNicknm(artistVO.getArtNm());
						profileVO.setComuMemCatCode("CMCC003");
						profileVO.setComuProfileImg(artistVO.getArtProfileImg());
						profileVO.setMemUsername(artistVO.getMemUsername());
						log.info("profileVO : {}", profileVO);
						// 아티스트 프로필 추가
						status = commProfileMapper.registCommProfileArtist(profileVO);

						// dm 대화 채널에 각 아티스트별 추가
						// dm 참여자테이블에 아티스트 추가
						if(status > 0) {
							chatChannelService.createChatChannel(profileVO.getComuProfileNo(), profileVO.getArtGroupNo(), "CTC001");
						}
					}
				}
			}
		}
		result = status > 0 ? ServiceResult.OK : ServiceResult.FAILED;
		return result;
	}

	/**
	 *	그룹 삭제서비스
	 */
	@Transactional
	@Override
	public ServiceResult deleteArtistGroup(int artGroupNo) {
		ServiceResult result = null;
		// 아티스트 그룹 y 처리
		int status = artistGroupMapper.deleteArtistGroup(artGroupNo);
		// 아티스트 그룹 맵 y 처리
		if(status > 0) {
			status = artistGroupMapper.deleteArtistGroupMap(artGroupNo);
		}
		// 커뮤니티 Y 처리
		if(status > 0) {
			status = communityMapper.deleteCommunity(artGroupNo);
		}
		// DM채널 Y처리
		if(status > 0) {
			status = chatChannelService.deleteChannels(artGroupNo);
		}
		result = status > 0 ? ServiceResult.OK : ServiceResult.FAILED;
		return result;
	}

	/**
	 * 그룹 서머리 가져오기 총, 활동, 해체
	 */
	@Override
	public Map<String, Object> getGroupSummaryMap() {
		return artistGroupMapper.getGroupSummaryMap();
	}

	/**
	 * 아티스트 로그인시 커뮤니티 바로가기위한 그룹번호가져오기
	 */
	@Override
	public int selectArtGroupNoByMemUsername(String username) {
		return artistGroupMapper.selectArtGroupNoByMemUsername(username);
	}
	/**
	 * 이미지 업로드 및 세이브경로 반환
	 * @param img
	 * @return 세이브 경로 반환
	 * @throws IllegalStateException
	 * @throws IOException
	 */
	private String uploadImg(MultipartFile img) throws IllegalStateException, IOException {
		String savePath = uploadPath + "/profile/group";
		File file = new File(savePath);
		if(!file.exists()) {
			file.mkdirs();
		}

		if(StringUtils.isNotBlank(img.getOriginalFilename())) {
			String filename = UUID.randomUUID() + "_" + img.getOriginalFilename();
			savePath += "/" + filename;
			img.transferTo(new File(savePath));
		}
		return savePath.replace("C:", "");

	}
}
