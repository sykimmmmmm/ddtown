package kr.or.ddit.ddtown.mapper.admin.group;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.AlbumVO;
import kr.or.ddit.vo.artist.ArtistGroupMapVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;

@Mapper
public interface IAdminArtistGroupMapper {

	/**
	 * 페이징 처리를 위한 토탈 레코드 수 반환
	 * @param pagingVO
	 * @param artGroupDelYn
	 * @return
	 */
	public int getTotalRecord(@Param("pagingVO") PaginationInfoVO<ArtistGroupVO> pagingVO,@Param("artGroupDelYn") String artGroupDelYn);

	/**
	 * 페이징 처리를 통한 해당 그룹 목록 불러오기
	 * @param pagingVO
	 * @param artGroupDelYn
	 * @return
	 */
	public List<ArtistGroupVO> getGroupList(@Param("pagingVO") PaginationInfoVO<ArtistGroupVO> pagingVO,@Param("artGroupDelYn") String artGroupDelYn);

	/**
	 * 특정 그룹에 해당하는 그룹정보를 가져온다
	 * 가져올때 그룹에 속한 아티스트를 모두 컬렉션을 통해 가져온다
	 * @param artGroupNo
	 * @return
	 */
	public ArtistGroupVO getGroupDetailWithArtist(int artGroupNo);
	/**
	 * 해당 아티스트 그룹이 발매한 모든 앨범리스트를 가져온다
	 * @param artGroupNo
	 * @return
	 */
	public List<AlbumVO> getAlbumList(int artGroupNo);
	/**
	 * 그룹 추가 수정시 그룹에 속해있지않은 앨범리스트를 가져온다.
	 * @return
	 */
	public List<AlbumVO> getAlbumListAll();

	/**
	 * 그룹 수정시 그룹이 가지고있던 앨범 정보를 변경해서 연결을 끊는다
	 * @param albumNo
	 */
	public void deleteAlbumGroup(int albumNo);

	/**
	 * 특정 그룹에 특정 앨범이 있는지 조회한다.
	 * @param albumVO
	 * @return count(*)
	 */
	public int checkAlbumGroupNo(AlbumVO albumVO);

	/**
	 * 특정 앨범에 특정 그룹번호를 추가해서 연결시킨다.
	 * @param albumVO
	 */
	public void insertArtistGroupNo(AlbumVO albumVO);

	/**
	 * 아티스트 그룹 정보를 수정한다.
	 * @param groupVO
	 * @return
	 */
	public int updateGroup(ArtistGroupVO groupVO);

	/**
	 * 아티스트 그룹 정보를 추가한다.
	 * @param groupVO
	 * @return
	 */
	public int registArtistGroup(ArtistGroupVO groupVO);

	/**
	 * 아티스트 그룹 맵에 데이터 추가
	 * @param agmVO
	 * @return
	 */
	public int registArtistGroupMap(ArtistGroupMapVO agmVO);

	/**
	 * 아티스트 그룹 del Y 변경
	 * @param artGroupNo
	 * @return
	 */
	public int deleteArtistGroup(int artGroupNo);

	/**
	 * 아티스트 그룹 맵 del Y 변경
	 * @param artGroupNo
	 * @return
	 */
	public int deleteArtistGroupMap(int artGroupNo);

	/**
	 * 서머리 가져오기 총, 활동, 해체
	 * @return
	 */
	public Map<String, Object> getGroupSummaryMap();

	/**
	 * 아티스트 로그인시 아파트 바로가기위한 그룹번호 가져오기
	 * @param username
	 * @return
	 */
	public int selectArtGroupNoByMemUsername(String username);


}
