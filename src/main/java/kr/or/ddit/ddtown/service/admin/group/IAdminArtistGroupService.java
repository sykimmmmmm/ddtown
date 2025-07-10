package kr.or.ddit.ddtown.service.admin.group;

import java.util.List;
import java.util.Map;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.AlbumVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;

public interface IAdminArtistGroupService {

	/**
	 * 페이징 처리된 총 레코드 수 가져오기
	 * @param pagingVO
	 * @param artGroupDelYn
	 * @return
	 */
	public int getTotalRecord(PaginationInfoVO<ArtistGroupVO> pagingVO, String artGroupDelYn);

	/**
	 * 페이징 처리된 그룹 리스트 가져오기
	 * @param pagingVO
	 * @return
	 */
	public List<ArtistGroupVO> getGroupList(PaginationInfoVO<ArtistGroupVO> pagingVO, String artGroupDelYn);

	/**
	 * 그룹 상세 정보 가져오기
	 * @param artGroupNo
	 * @return
	 */
	public ArtistGroupVO getGroupDetail(int artGroupNo);

	/**
	 * 그룹 추가 수정시 그룹에 속해있지않은 앨범리스트를 가져온다.
	 * @return
	 */
	public List<AlbumVO> getAlbumListAll();

	/**
	 * 그룹 수정 서비스
	 * @param groupVO
	 * @return
	 */
	public ServiceResult updateGroup(ArtistGroupVO groupVO);

	/**
	 * 그룹 추가 서비스
	 * @param groupVO
	 * @return
	 */
	public ServiceResult registArtistGroup(ArtistGroupVO groupVO);

	/**
	 * 그룹 삭제 서비스
	 * @param artGroupNo
	 * @return
	 */
	public ServiceResult deleteArtistGroup(int artGroupNo);

	/**
	 * 그룹관리 서머리 가져오기 총, 활동, 해체
	 * @return
	 */
	public Map<String, Object> getGroupSummaryMap();

	/**
	 * 아티스트 로그인시 아파트 바로가기위한 그룹넘버가져오기
	 * @param username
	 * @return
	 */
	public int selectArtGroupNoByMemUsername(String username);

}
