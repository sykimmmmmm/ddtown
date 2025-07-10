package kr.or.ddit.vo.artist;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.community.CommunityVO;
import kr.or.ddit.vo.schedule.ScheduleVO;
import lombok.Data;

@Data
public class ArtistGroupVO {
	private Date artGroupRegDate;
	private String artGroupDelYn;
	private String artGroupProfileImg;
	private Date artGroupModDate;
	private int artGroupNo;
	private String artGroupTypeCode;
	private String empUsername;
	private String artGroupDebutdate;
	private String artGroupNm;
	private String artGroupContent;
	private String empName;
	private String delYn; // 그룹탈퇴여부
	List<ArtistVO> artistList; // 소속 아티스트 목록

	private MultipartFile profileImage;	// 그룹 프로필이미지 파일
	private int[] addArtists;	// 아티스트 추가 목록
	private int[] addAlbums;		// 앨범 추가 목록
	private int[] removeArtists;	// 아티스트 제거 목록
	private int[] removeAlbums;	// 아티스트 제거 목록

	private CommunityVO communityVO; // 커뮤니티 총 팬 수, 아티스트 수 구하기 위함

	// 수정 시 수정할 데이터를 담을 필드
	private String memberArtNos;

	// 수정 시 수정할 앨범 데이터를 담을 필드 (추가)
    private String selectedAlbumNos;

    private List<ScheduleVO> schedule;	// 아티스트 스케줄

	// 해당 그룹의 모든 앨범 정보
    private List<AlbumVO> albumList;

    // 멤버십 굿즈 번호
    private Integer membershipGoodsNo;

//    //데뷔 앨범을 찾아 반환
//    public String getDebutAlbum() {
//    	if(albumList == null || albumList.isEmpty()) {
//    		return null;
//    	}
//    	// 데뷔 앨범 식별 로직(발매일이 가장 빠른 앨범의 명)
//    	AlbumVO albumVO = albumList.stream()
//					 	.min((a1, a2) -> {
//		                    // albumRegDate가 null인 경우를 처리
//		                    Date date1 = a1.getAlbumRegDate();
//		                    Date date2 = a2.getAlbumRegDate();
//
//		                    // 둘 다 null인 경우 동일하다고 간주
//		                    if (date1 == null && date2 == null) {
//		                        return 0;
//		                    }
//		                    // date1만 null인 경우 date2가 더 빠르다고 간주 (null을 가장 늦은 날짜로 처리)
//		                    if (date1 == null) {
//		                        return 1;
//		                    }
//		                    // date2만 null인 경우 date1이 더 빠르다고 간주
//		                    if (date2 == null) {
//		                        return -1;
//		                    }
//		                    // 둘 다 null이 아닌 경우 정상적으로 비교
//		                    return date1.compareTo(date2);
//		                })
//					 	.orElse(null);
//		String albumName = "";
//		if(albumVO != null){
//			albumName = albumVO.getAlbumNm();
//		}
//		return albumName;
//    }
    public String getDebutAlbum() {
        if (albumList == null || albumList.isEmpty()) {
            return null;
        }
        // 첫 번째 앨범을 가져옵니다.
        AlbumVO albumVO = albumList.get(0);

        String albumName = "";
        if (albumVO != null) { // get(0)이 null을 반환할 일은 없지만, 안전을 위해
            albumName = albumVO.getAlbumNm();
        }
        return albumName;
    }
}
