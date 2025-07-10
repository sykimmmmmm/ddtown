package kr.or.ddit.ddtown.mapper.admin.artist;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.artist.ArtistVO;

@Mapper
public interface IAdminArtistMapper {

	/**
	 * 페이징 처리를 통해 처리된 아티스트 목록 불러오기
	 * @param pagingVO
	 * @param artDelYn
	 * @return
	 */
	public List<ArtistVO> getArtistList(@Param("pagingVO") PaginationInfoVO<ArtistVO> pagingVO,@Param("artDelYn") String artDelYn);

	/**
	 * 페이징 처리를 통해 처리된 총 토탈 레코드 수 가져오기
	 * @param pagingVO
	 * @param artDelYn
	 * @return
	 */
	public int getTotalRecord(@Param("pagingVO") PaginationInfoVO<ArtistVO> pagingVO, @Param("artDelYn") String artDelYn);

	/**
	 * 아티스트 번호를 통해 해당 아티스트의 정보를 가져오기
	 * @param artNo
	 * @return
	 */
	public ArtistVO getArtistDetail(int artNo);

	/**
	 * 아티스트 테이블 수정
	 * @param artistVO
	 * @return
	 */
	public int updateArtist(ArtistVO artistVO);

	/**
	 * 아티스트 추가
	 * @param artistVO
	 * @return
	 */
	public int registArtist(ArtistVO artistVO);

	/**
	 * 아티스트 은퇴 처리
	 * @param artistVO
	 * @return
	 */
	public int deleteArtist(ArtistVO artistVO);

	/**
	 * 그룹 번호를 가지고있는 아티스트 목록 가져오기
	 * @param artGroupNo
	 * @return
	 */
	public List<ArtistVO> getArtistListByGroupNo(int artGroupNo);

	/**
	 * 그룹 수정시 해당 그룹에 추가할 은퇴를 제외한 아티스트 목록을 가져온다
	 * @return
	 */
	public List<ArtistVO> getArtistListAll();

	/**
	 * 아티스트 그룹 맵에 해당 아티스트 탈퇴 처리
	 * @param artVO
	 */
	public void deleteArtGroup(ArtistVO artVO);

	/**
	 * 아티스트 그룹 맵에 해당 컬럼있는지 확인
	 * @param artVO
	 * @return
	 */
	public int checkArtGroup(ArtistVO artVO);

	/**
	 * 아티스트 그룹 맵에 컬럼 추가
	 * @param artVO
	 */
	public void insertArtistGroupMap(ArtistVO artVO);

	/**
	 * 특정 아티스트가 속해있는 그룹리스트 가져오기
	 * @param map
	 * @return
	 */
	public List<ArtistGroupVO> getArtistGroupList(Map<String, Object> map);

	/**
	 * 아티스트 전 그룹 은퇴 처리
	 * @param artistVO
	 * @return
	 */
	public int deleteArtistGroupMap(ArtistVO artistVO);

	/**
	 * 기존에 artist_group_map에 컬럼이있을시 del여부 'N'으로 다시 활성화
	 * @param artVO
	 */
	public void updateArtistGroupDelYn(ArtistVO artVO);

	/**
	 * 아티스트 커뮤니티 프로필을 찾기 위한 아티스트 아이디 찾기
	 * @param artVO artNo
	 * @return memUsername
	 */
	public String selectArtistUsername(ArtistVO artVO);

	/**
	 * 데뷔일 없으면 데뷔일 추가
	 * @param artistVO
	 */
	public void updateArtistDebut(ArtistVO artistVO);

	/**
	 * 아티스트 관리 요약본 (총 인원수 , 활동 인원수, 은퇴 인원수)
	 * @return
	 */
	public Map<String, Object> selecSummaryMap();
}
