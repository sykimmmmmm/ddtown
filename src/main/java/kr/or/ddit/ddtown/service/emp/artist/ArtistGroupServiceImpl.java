package kr.or.ddit.ddtown.service.emp.artist;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ddtown.mapper.emp.artist.ArtistGroupMapper;
import kr.or.ddit.vo.artist.AlbumVO;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ArtistGroupServiceImpl implements IArtistGroupService{

	@Autowired
	private ArtistGroupMapper artistGroupMapper;

	@Value("${kr.or.ddit.upload.path}")
	private String generalUploadPath;

	private static final String groupProfileSubFolder = "profile/group";

	@Override
	public List<ArtistGroupVO> retrieveArtistGroupList(String empUsername) {
		log.info("retrieveArtistGroupList() 메소드 실행. 담장자 : {}", empUsername);

		List<ArtistGroupVO> groupList = artistGroupMapper.retrieveArtistGroupList(empUsername);
        if (groupList != null) {
            for (ArtistGroupVO group : groupList) {
                if (group != null) { // 각 group 객체에 대한 null 체크
                    List<AlbumVO> albumList = artistGroupMapper.getGroupAlbum(group.getArtGroupNo());
                    group.setAlbumList(albumList);
                }
            }
        }

		if (groupList == null || groupList.isEmpty()) {
            log.info("조회된 아티스트 그룹 목록이 없습니다.");
        } else {
            log.info("조회된 아티스트 그룹 수: {}", groupList.size());
        }
        return groupList;
	}


	@Override
	public ArtistGroupVO retrieveArtistGroup(int artGroupNo) {
		return artistGroupMapper.retrieveArtistGroup(artGroupNo);
	}

	@Transactional
    @Override
    public int updateArtistGroupAndMembersAndAlbums(ArtistGroupVO groupToUpdate) throws Exception {
		log.info("updateArtistGroupAndMembersAndAlbums 서비스 실행. 대상 그룹: {}", groupToUpdate.getArtGroupNo());

		MultipartFile profileFile = groupToUpdate.getProfileImage();

		if (profileFile != null && !profileFile.isEmpty()) {
            log.info("새로운 그룹 프로필 이미지 파일 감지: {}", profileFile.getOriginalFilename());
            try {
                String newRelativePath = uploadGroupProfileImageDirectly(profileFile);
                groupToUpdate.setArtGroupProfileImg(newRelativePath);
                log.info("그룹 프로필 이미지 저장 성공. 새 경로: {}", newRelativePath);
            } catch (IOException e) {
                log.error("그룹 프로필 이미지 파일 업로드(저장) 중 오류 발생. 그룹번호: {}", groupToUpdate.getArtGroupNo(), e);
                throw new RuntimeException("그룹 프로필 이미지 저장에 실패했습니다: " + e.getMessage(), e);
            }
        } else {
            log.info("새로운 그룹 프로필 이미지 파일이 첨부되지 않았습니다. 기존 이미지 경로 유지: {}", groupToUpdate.getArtGroupProfileImg());
            // groupToUpdate.getArtGroupProfileImg()에는 컨트롤러에서 설정한 existingArtGroupProfileImg 값이 들어있음
        }

        // 1. 기본 그룹 정보 업데이트
		int groupUpdateCount = artistGroupMapper.updateArtistGroup(groupToUpdate);
        if (groupUpdateCount == 0) {
        	log.warn("그룹 기본 정보 업데이트 영향 받은 행 없음 (또는 실패). 그룹번호: {}", groupToUpdate.getArtGroupNo());
            throw new RuntimeException("그룹 기본 정보 업데이트에 실패했습니다. 대상 그룹을 찾을 수 없거나 변경된 내용이 없습니다.");
        }else {
            log.info("그룹 기본 정보 업데이트 완료. 그룹번호: {}, 업데이트된 행 수: {}", groupToUpdate.getArtGroupNo(), groupUpdateCount);
        }

        // 2. 기존 멤버들의 그룹 연결 해제 (artGroupNo를 NULL로 설정)
        int membersUnassignedCount = artistGroupMapper.unassignArtistsFromGroup(groupToUpdate.getArtGroupNo());
        log.info("기존 멤버 전체 연결 해제(논리적 삭제) 시도 완료. 그룹번호: {}, 처리된 매핑 수: {}", groupToUpdate.getArtGroupNo(), membersUnassignedCount);

        // 3. 새로운 멤버 리스트 파싱 및 그룹에 배정
        String memberArtNosStr = groupToUpdate.getMemberArtNos();
        log.info("UI로부터 전달받은 최종 멤버 ID 문자열 (memberArtNosStr): '{}'", memberArtNosStr);

        List<Integer> newMemberArtNoList = Collections.emptyList(); // 파싱 전 빈 리스트로 초기화
        if (memberArtNosStr != null && !memberArtNosStr.trim().isEmpty()) {
            try {
                newMemberArtNoList = Arrays.stream(memberArtNosStr.split(","))
                                           .map(String::trim)
                                           .filter(s -> !s.isEmpty()) // 빈 문자열 제거
                                           .map(Integer::parseInt)    // 정수로 변환
                                           .toList();
            } catch (NumberFormatException e) {
                log.error("멤버 ID 문자열 파싱 중 NumberFormatException 발생: '{}'. 그룹번호: {}", memberArtNosStr, groupToUpdate.getArtGroupNo(), e);
                throw new IllegalArgumentException("제출된 멤버 ID 목록의 숫자 형식이 잘못되었습니다: " + memberArtNosStr, e); // 예외를 다시 던져 트랜잭션 롤백 유도
            }
        }
        // 파싱된 최종 멤버 ID 리스트를 로그로 확인합니다.
        log.info("파싱된 최종 새 멤버 ID 목록 (newMemberArtNoList): {}. 그룹번호: {}", newMemberArtNoList, groupToUpdate.getArtGroupNo());

        // 최종 멤버 목록이 있을 경우에만 배정 로직 실행
        if (!newMemberArtNoList.isEmpty()) {
            int membersAssignedCount = artistGroupMapper.assignArtistsToGroup(groupToUpdate.getArtGroupNo(), newMemberArtNoList);
            log.info("최종 멤버 목록 그룹에 배정(활성화/추가) 시도 완료. 그룹번호: {}, 배정 요청 멤버 수: {}, 실제 처리된 매핑 수: {}",
                     groupToUpdate.getArtGroupNo(), newMemberArtNoList.size(), membersAssignedCount);
        } else {
            log.info("그룹에 배정할 최종 멤버가 없습니다 (UI 목록이 비었거나, 파싱 후 목록이 비어있음). 그룹번호: {}", groupToUpdate.getArtGroupNo());
        }

        // --- 4. 기존 앨범 연결 전체 해제 ---
        // ARTIST_ALBUM 테이블에서 해당 그룹의 ART_GROUP_NO를 NULL로 설정합니다.
        int albumsUnassignedCount = artistGroupMapper.unassignAlbumsFromGroup(groupToUpdate.getArtGroupNo());
        log.info("기존 앨범 연결 전체 해제 시도 완료. 그룹번호: {}, 처리된 앨범 수: {}", groupToUpdate.getArtGroupNo(), albumsUnassignedCount);

        // --- 5. 새로운 앨범 리스트 파싱 및 그룹에 재배정 ---
        String selectedAlbumNosStr = groupToUpdate.getSelectedAlbumNos();
        log.info("UI로부터 전달받은 최종 앨범 ID 문자열 (selectedAlbumNosStr): '{}'", selectedAlbumNosStr);

        List<Integer> newAlbumIdList = Collections.emptyList(); // 파싱 전 빈 리스트로 초기화
        if (selectedAlbumNosStr != null && !selectedAlbumNosStr.trim().isEmpty()) {
            try {
                newAlbumIdList = Arrays.stream(selectedAlbumNosStr.split(","))
                                       .map(String::trim)
                                       .filter(s -> !s.isEmpty())
                                       .map(Integer::parseInt)
                                       .toList();
            } catch (NumberFormatException e) {
                log.error("앨범 ID 문자열 파싱 중 NumberFormatException 발생: '{}'. 그룹번호: {}", selectedAlbumNosStr, groupToUpdate.getArtGroupNo(), e);
                throw new IllegalArgumentException("제출된 앨범 ID 목록의 숫자 형식이 잘못되었습니다: " + selectedAlbumNosStr, e);
            }
        }
        log.info("파싱된 최종 새 앨범 ID 목록 (newAlbumIdList): {}. 그룹번호: {}", newAlbumIdList, groupToUpdate.getArtGroupNo());

        if (!newAlbumIdList.isEmpty()) {
            // ARTIST_ALBUM 테이블의 ART_GROUP_NO를 업데이트합니다.
            int albumsAssignedCount = artistGroupMapper.assignAlbumsToGroup(groupToUpdate.getArtGroupNo(), newAlbumIdList);
            log.info("최종 앨범 목록 그룹에 배정 시도 완료. 그룹번호: {}, 배정 요청 앨범 수: {}, 실제 처리된 앨범 수: {}",
                     groupToUpdate.getArtGroupNo(), newAlbumIdList.size(), albumsAssignedCount);
            if (albumsAssignedCount != newAlbumIdList.size()) {
                log.warn("앨범 배정 시 요청된 수({})와 실제 처리된 수({})가 다릅니다. 그룹번호: {}", newAlbumIdList.size(), albumsAssignedCount, groupToUpdate.getArtGroupNo());
            }
        } else {
            log.info("그룹에 배정할 최종 앨범이 없습니다. 그룹번호: {}", groupToUpdate.getArtGroupNo());
        }

        log.info("updateArtistGroupAndMembersAndAlbums 서비스 실행 완료. 그룹번호: {}", groupToUpdate.getArtGroupNo());
        return groupUpdateCount;
    }
	/**
     * 그룹 프로필 이미지를 직접 서버에 저장하고, DB에 저장할 상대 경로를 반환하는 private 메소드.
     * @param multipartFile 업로드할 파일
     * @return DB에 저장될 상대 경로 (예: /upload/profile/group/uuid_filename.jpg)
     * @throws IOException 파일 저장 실패 시
     */
    private String uploadGroupProfileImageDirectly(MultipartFile multipartFile) throws IOException {
        // 최종 저장될 디렉토리 경로 (예: C:/upload/profile/group)
        File targetDirectory = new File(generalUploadPath, groupProfileSubFolder);
        if (!targetDirectory.exists()) {
            targetDirectory.mkdirs(); // 폴더가 없으면 생성
            log.info("그룹 프로필 이미지 디렉토리 생성됨: {}", targetDirectory.getAbsolutePath());
        }

        String originalFilename = multipartFile.getOriginalFilename();
        String saveFileName = UUID.randomUUID().toString() + "_" + originalFilename;

        File saveFile = new File(targetDirectory, saveFileName); // 최종 저장될 파일 객체

        try {
            multipartFile.transferTo(saveFile); // 파일 저장
            log.info("그룹 프로필 이미지 파일 저장 성공: {}", saveFile.getAbsolutePath());
        } catch (IllegalStateException | IOException e) {
            log.error("그룹 프로필 이미지 파일 저장 실패: {}, 원인: {}", saveFile.getAbsolutePath(), e.getMessage());
            throw e;
        }
        return "/upload/" + groupProfileSubFolder.replace(File.separatorChar, '/') + "/" + saveFileName;
    }

	@Override
	public List<AlbumVO> getAllAlbums() {
		return artistGroupMapper.getAllAlbums();
	}

	@Override
	public List<ArtistGroupVO> selectAllArtistGroups(){
		log.info("selectAllArtistGroups() 실행...!");
		return artistGroupMapper.selectAllArtistGroups();
	}


	// 해당 아티스트 그룹의 담당자 조회
	@Override
	public String getEmpUsernameByArtistGroupNo(int selectedArtGroupNo) {
		return artistGroupMapper.getEmpUsernameByArtistGroupNo(selectedArtGroupNo);
	}

    @Override
    public Integer getArtGroupNoByEmpUsername(String empUsername) {
        if (empUsername == null) {
			return null;
		}
        // artistGroupMapper에서 empUsername으로 그룹 리스트 조회 후 첫 번째 그룹의 번호 반환
        List<ArtistGroupVO> groupList = artistGroupMapper.selectArtistGroupsByEmpUsername(empUsername);
        if (groupList != null && !groupList.isEmpty()) {
            return groupList.get(0).getArtGroupNo();
        }
        return null;
    }
}
