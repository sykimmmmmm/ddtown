package kr.or.ddit.ddtown.service.emp.artist;

import java.util.List;

import kr.or.ddit.vo.artist.AlbumVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;

public interface IArtistGroupService {

	// 목록 불러오기
	public List<ArtistGroupVO> retrieveArtistGroupList(String empUsername);

	// 그룹의 상세 정보 불러오기
	public ArtistGroupVO retrieveArtistGroup(int artGroupNo);

	// 그룹 및 아티스트 정보 수정
	public int updateArtistGroupAndMembersAndAlbums(ArtistGroupVO groupToUpdate) throws Exception;

	// 추가된 getAllAlbums 메소드 선언
    public List<AlbumVO> getAllAlbums();

    // 모든 아티스트 그룹 조회
    public List<ArtistGroupVO> selectAllArtistGroups();

    // 해당 아티스트 그룹의 담당자 조회
	public String getEmpUsernameByArtistGroupNo(int selectedArtGroupNo);

	/**
	 * 직원 아이디로 담당 아티스트 그룹 번호 조회
	 */
	Integer getArtGroupNoByEmpUsername(String empUsername);

}
