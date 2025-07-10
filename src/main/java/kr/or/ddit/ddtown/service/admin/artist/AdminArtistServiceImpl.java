package kr.or.ddit.ddtown.service.admin.artist;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.IUserMapper;
import kr.or.ddit.ddtown.mapper.admin.artist.IAdminArtistMapper;
import kr.or.ddit.ddtown.service.community.ICommunityProfileService;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.ArtistVO;
import kr.or.ddit.vo.user.PeopleAuthVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminArtistServiceImpl implements IAdminArtistService {

	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	private static final String BASEIMG = "/upload/profile/base/defaultImg.png";

	@Autowired
	private BCryptPasswordEncoder pe;

	@Autowired
	private IAdminArtistMapper artistMapper;

	@Autowired
	private IUserMapper userMapper;

	@Autowired
	private ICommunityProfileService profileService;

	/**
	 *	페이징 처리된 아티스트 목록 불러오기
	 */
	@Override
	public List<ArtistVO> getArtistList(PaginationInfoVO<ArtistVO> pagingVO, String artDelYn) {
		return artistMapper.getArtistList(pagingVO, artDelYn);
	}

	/**
	 * 페이징 처리된 총 레코드 수 가져오기
	 */
	@Override
	public int getTotalRecord(PaginationInfoVO<ArtistVO> pagingVO, String artDelYn) {
		return artistMapper.getTotalRecord(pagingVO, artDelYn);
	}

	/**
	 * 특정 번호를 통해 아티스트 정보 가져오기
	 */
	@Override
	public ArtistVO getArtistDetail(int artNo) {
		return artistMapper.getArtistDetail(artNo);
	}

	// 아티스트 수정
	/**
	 *	아티스트 수정 기능
	 * 성공시 OK 실패시 FAILED 반환
	 */
	@Transactional
	@Override
	public ServiceResult updateArtist(ArtistVO artistVO) {
		log.info("artistVO : {}", artistVO);
		ServiceResult result = null;

		// 이미지 처리
		MultipartFile img = artistVO.getProfileImg();
		if(img != null && StringUtils.isNotBlank(img.getOriginalFilename())) {
			try {
				// 새로운 이미지 경로
				String imgUrl = uploadImg(img);
				artistVO.setArtProfileImg(imgUrl);
				profileService.updateArtistProfileImg(imgUrl,artistVO.getMemUsername());
			} catch (IllegalStateException | IOException e) {
				return ServiceResult.FAILED;
			}
		}

		// 아티스트 테이블 수정
		int status = artistMapper.updateArtist(artistVO);
		if(status > 0) {
			// 아티스트 people 테이블 수정
			if(StringUtils.isNotBlank(artistVO.getMemberVO().getPassword())) {
				String encodedPw = pe.encode(artistVO.getMemberVO().getPassword());
				artistVO.getMemberVO().setPassword(encodedPw);
			}
			status = userMapper.updateArtistPeople(artistVO.getMemberVO());
			if(status > 0) {
				// 아티스트 member 테이블 수정
				artistVO.getMemberVO().setMemNicknm(artistVO.getArtNm());
				status = userMapper.updateArtistMember(artistVO.getMemberVO());
				result = status > 0 ? ServiceResult.OK : ServiceResult.FAILED;
			}
		}
		return result;
	}

	/**
	 * 아티스트 등록 기능
	 */
	@Transactional
	@Override
	public ServiceResult registArtist(ArtistVO artistVO) {
		log.info("artistVO : {}", artistVO);
		ServiceResult result = null;
		// people 테이블 데이터 추가
		String encodedPw = pe.encode(artistVO.getMemberVO().getPassword());
		artistVO.getMemberVO().setPassword(encodedPw);
		int status = userMapper.registArtistPeople(artistVO.getMemberVO());
		if(status > 0) {
			// auth 추가
			PeopleAuthVO paVO = new PeopleAuthVO();
			paVO.setUsername(artistVO.getMemberVO().getUsername());
			paVO.setAuth("ROLE_MEMBER");
			userMapper.registArtistAuth(paVO);
			paVO.setAuth("ROLE_ARTIST");
			userMapper.registArtistAuth(paVO);
			// member 테이블 데이터 추가
			artistVO.getMemberVO().setMemNicknm(artistVO.getArtNm());
			status = userMapper.registArtistMember(artistVO.getMemberVO());
			if(status > 0) {
				// img 업로드
				MultipartFile img = artistVO.getProfileImg();
				if(img != null && StringUtils.isNotBlank(img.getOriginalFilename())) {
					String savePath;
					try {
						savePath = uploadImg(img);
						artistVO.setArtProfileImg(savePath);
					} catch (IllegalStateException | IOException e) {
						return ServiceResult.FAILED;
					}
				}else {
					artistVO.setArtProfileImg(BASEIMG);
				}
				// artist테이블 추가
				artistVO.setMemUsername(artistVO.getMemberVO().getUsername());
				status = artistMapper.registArtist(artistVO);
				result = status > 0 ? ServiceResult.OK : ServiceResult.FAILED;
			}
		}

		return result;
	}

	/**
	 * 아티스트 은퇴 처리
	 */
	@Transactional
	@Override
	public ServiceResult deleteArtist(ArtistVO artistVO) {
		ServiceResult result = null;
		// 아티스트 그룹 맵 탈퇴여부 y 변경
		int status = artistMapper.deleteArtistGroupMap(artistVO);
		// 아티스트 은퇴여부 y 변경
		if(status > 0) {
			status = artistMapper.deleteArtist(artistVO);
		}else {
			result = ServiceResult.FAILED;
		}
		// 멤버 코드 'MSC002' 변경
		if(status > 0) {
			status = userMapper.deleteArtistMember(artistVO.getMemUsername());
		}else {
			result = ServiceResult.FAILED;
		}
		// 사용자 탈퇴 여부 'y' 변경
		if(status > 0) {
			status = userMapper.deleteArtistPeople(artistVO.getMemUsername());
			result = status > 0 ? ServiceResult.OK : ServiceResult.FAILED;
		}
		return result;
	}

	/**
	 * 그룹번호를 가지고있는 아티스트 목록 가져오기
	 */
	@Override
	public List<ArtistVO> getArtistListByGroupNo(int artGroupNo) {
		return artistMapper.getArtistListByGroupNo(artGroupNo);
	}

	/**
	 * 그룹 수정시 해당 그룹에 추가할 은퇴를 제외한 아티스트 목록을 가져온다
	 */
	@Override
	public List<ArtistVO> getArtistListAll() {
		return artistMapper.getArtistListAll();
	}


	/**
	 * 아티스트 관리 요약본 (총 인원수 , 활동 인원수, 은퇴 인원수)
	 * @return
	 */
	@Override
	public Map<String, Object> selectSummaryMap() {
		return artistMapper.selecSummaryMap();
	}

	private String uploadImg(MultipartFile img) throws IllegalStateException, IOException {
		String savePath = uploadPath + "/profile/artist";
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
