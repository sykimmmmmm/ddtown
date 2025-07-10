package kr.or.ddit.ddtown.service.file;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.ddtown.mapper.file.IAttachmentFileMapper;
import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import kr.or.ddit.vo.file.AttachmentFileGroupVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class FileServiceImpl implements IFileService {

	@Autowired
	private IAttachmentFileMapper fileMapper;

	@Value("${kr.or.ddit.upload.path}")
	private String windowUploadBasePath;

	@Value("${kr.or.ddit.upload.path.mac}")
	private String macUploadBasePath;

	private SimpleDateFormat KST_DATE_FORMAT = new SimpleDateFormat("yyyy/MM/dd");


    /**
     *
     * @param files	업로드할 MultipartFile 배열
     * @param fileTypeCode	파일 타입 구분 코드
     * @param uploaderId	업로더 ID ( 작성자 없는 메소드 사용시 null 존재 할 수 있음)
     * @return	생성된 파일 그룹 번호, 실패시 null또는 예외
     * @throws Exception
     */
    private Integer processFilesInternal(MultipartFile[] files, String fileTypeCode, String uploaderId) throws Exception {
        if (files == null || files.length == 0 || (files.length == 1 && files[0].isEmpty())) {
            return null;
        }

        // 1. 현재 OS에 맞는 기본 업로드 경로 선택
        String os = System.getProperty("os.name").toLowerCase();
        String currentUploadBasePath;

        if(os.contains("mac") || os.contains("darwin")) {
        	currentUploadBasePath = macUploadBasePath;
        } else if(os.contains("win")) {
        	currentUploadBasePath = windowUploadBasePath;
        } else {
        	log.warn("알 수 없는 OS 환경입니다. window 경로를 사용합니다.");
        	currentUploadBasePath = windowUploadBasePath;
        }

        // 파일그룹 생성
        AttachmentFileGroupVO groupVO = new AttachmentFileGroupVO();
        groupVO.setFileTypeCode(fileTypeCode);		// 파일타입코드 세팅
        groupVO.setFileTypeNm(getFileTypeNmFromCode(fileTypeCode));		// 파일 타입명 세팅
        fileMapper.insertFileGroup(groupVO);		// 세팅된값 DB에 저장

        int fileGroupNo = groupVO.getFileGroupNo();

        if (fileGroupNo <= 0) {
            log.error("파일 그룹 생성 실패 (fileGroupNo: {})", fileGroupNo);
            throw new RuntimeException("파일 그룹을 생성할 수 없습니다.");
        }

        String datePath = KST_DATE_FORMAT.format(new Date());	// 폴더 날짜값으로 저장
        File finalUploadDirectory = new File(currentUploadBasePath + File.separator + datePath);	// 기본경로 + 폴더

        if (!finalUploadDirectory.exists()) {
            finalUploadDirectory.mkdirs();		// 폴더생성
        }
        // 그룹에서 개별파일 꺼내기
        for (MultipartFile multipartFile : files) {
            if (multipartFile != null && !multipartFile.isEmpty()) {
                String originalFileName = multipartFile.getOriginalFilename();	// DB -> file_original_nm
                String fileExtension = "";	// 파일 확장자
                if (originalFileName != null && originalFileName.contains(".")) {
                    fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));		// 확장자 분리 . 뒤로 가져옵니당
                }
                String saveFileName = UUID.randomUUID().toString() + fileExtension;		// 파일 저장명
                File saveFile = new File(finalUploadDirectory, saveFileName);		// 파일 절대경로

                try {
                    multipartFile.transferTo(saveFile);		// 저장파일 전송

                    AttachmentFileDetailVO fileDetail = new AttachmentFileDetailVO();	// 파일 상세정보
                    fileDetail.setFileGroupNo(fileGroupNo);		// 파일그룹번호
                    fileDetail.setFileOriginalNm(originalFileName);		// 파일 원본명
                    fileDetail.setFileSaveNm(saveFileName);		// DB -> file_save_nm
                    fileDetail.setFileSavepath(datePath);		// DB -> file_savePath
                    fileDetail.setFileExt(fileExtension.replace(".", ""));	// 파일 확장자
                    fileDetail.setFileMimeType(multipartFile.getContentType());		// 파일 컨텐츠타입 DB -> file_mime_type
                    fileDetail.setFileSize(multipartFile.getSize());		// 파일 크기
                    fileDetail.setFileFancysize(fancySize(multipartFile.getSize()));		// 파일 실제 크기 DB -> file_fancysize

                    fileMapper.insertFileDetail(fileDetail);		// 파일 상세정보 저장
                    log.info("파일 저장 및 DB 삽입 완료: {}, 저장경로: {}, 업로더: {}", saveFileName, datePath, uploaderId != null ? uploaderId : "N/A");

                } catch (IOException e) {
                    log.error("파일 '{}' 저장 실패: {}", originalFileName, e.getMessage());
                    // 트랜잭션 롤백
                    throw new IOException(originalFileName + " 파일 저장 실패", e);
                }
            }
        }
        return fileGroupNo;
    }


    /**
     * uploaderId 기본 메소드 ( 테이블에 작성자 존재할 때 사용하세여 )
     */
    @Override
    @Transactional
    public Integer uploadAndProcessFiles(MultipartFile[] files, String fileTypeCode, String uploaderId) throws Exception {
        log.info("uploadAndProcessFiles (uploaderId 포함) 호출됨. fileTypeCode: {}, uploaderId: {}", fileTypeCode, uploaderId);

        return processFilesInternal(files, fileTypeCode, uploaderId);
    }

	/**
	 *	uploaderId 없는 메소드 ( 테이블에 작성자가 없을때 사용하세여 )
	 */
	@Override
	@Transactional
	public Integer uploadAndProcessFiles(MultipartFile[] files, String fileTypeCode) throws Exception {
		log.info("uploadAndProcessFiles (uploaderId 없는메소드) 호출");

		return processFilesInternal(files, fileTypeCode, null);
	}

	/**
	 *	파일 그룹번호를 통해 첨부파일상세번호 조회
	 */
	@Override
	public List<AttachmentFileDetailVO> getFileDetailsByGroupNo(int fileGroupNo) throws Exception {
		List<AttachmentFileDetailVO> files = fileMapper.selectFileDetailsByGroupNo(fileGroupNo);
		for(AttachmentFileDetailVO file : files) {
			file.setWebPath("/upload/" + file.getFileSavepath().replace(File.separatorChar, '/') + "/" + file.getFileSaveNm());		// 웹경로 설정
		}
		return files;
	}

	/**
	 *	파일 그룹번호를 통해 대표이미지 설정 메소드
	 */
	@Override
	public AttachmentFileDetailVO getRepresentativeFileByGroupNo(int fileGroupNo) throws Exception {
		List<AttachmentFileDetailVO> files = fileMapper.selectFileDetailsByGroupNo(fileGroupNo); // 그룹 내 모든 파일 조회
        if (files != null && !files.isEmpty()) {
            // 이미지 파일을 우선적으로 대표 이미지로 선택
            for (AttachmentFileDetailVO file : files) {
                if (file.getFileMimeType() != null && file.getFileMimeType().startsWith("image")) {
                    file.setWebPath("/upload" + file.getFileSavepath().replace(File.separatorChar, '/') + "/" + file.getFileSaveNm());
                    return file; // 첫 번째 이미지 파일을 대표로 반환
                }
            }
            // 이미지 파일이 없다면, 그냥 첫 번째 파일을 대표로 반환
            AttachmentFileDetailVO firstFile = files.get(0);
            firstFile.setWebPath("/upload" + firstFile.getFileSavepath().replace(File.separatorChar, '/') + "/" + firstFile.getFileSaveNm());
            return firstFile;
        }
        return null; // 파일이 없으면 null 반환
	}

	/**
	 *	파일 그룹번호를 통해 물리파일 삭제
	 */
	@Override
	@Transactional
	public void deleteFilesByGroupNo(int fileGroupNo) throws Exception {
		List<AttachmentFileDetailVO> filesToDelete = fileMapper.selectFileDetailsByGroupNo(fileGroupNo);

		// 1. 현재 OS에 맞는 기본 업로드 경로 선택
        String os = System.getProperty("os.name").toLowerCase();
        String currentUploadBasePath;

        if(os.contains("mac") || os.contains("darwin")) {
        	currentUploadBasePath = macUploadBasePath;
        } else if(os.contains("win")) {
        	currentUploadBasePath = windowUploadBasePath;
        } else {
        	log.warn("알 수 없는 OS 환경입니다. window 경로를 사용합니다.");
        	currentUploadBasePath = windowUploadBasePath;
        }

		for(AttachmentFileDetailVO file : filesToDelete) {
			// separator로 경로구분자로 실제파일 경로구성함
			File physicalFile = new File(currentUploadBasePath + File.separator + file.getFileSavepath() + File.separator + file.getFileSaveNm());

			if(physicalFile.exists()) {
				if(physicalFile.delete()) {
					log.info("물리파일 삭제 성공");
				} else {
					log.warn("물리파일 삭제 실패");
				}
			} else {
				log.warn("삭제할 물리파일 없음");
			}
		}
		fileMapper.deleteFileDetailsByGroupNo(fileGroupNo);		// 파일 상세정보 삭제
		fileMapper.deleteFileGroup(fileGroupNo);				// 파일 그룹번호 삭제
		log.info("파일 그룹 및 상세파일 삭제, 그룹번호: {}", fileGroupNo);
	}

	/**
	 *	개별 물리파일 삭제
	 */
	@Override
	@Transactional
	public void deleteSpecificFiles(List<Integer> attachDetailNos) {
		if(attachDetailNos == null || attachDetailNos.isEmpty()) {
			return;
		}

		// 1. 현재 OS에 맞는 기본 업로드 경로 선택
		String os = System.getProperty("os.name").toLowerCase();
		String currentUploadBasePath;

		if (os.contains("mac") || os.contains("darwin")) {
			currentUploadBasePath = macUploadBasePath;
		} else if (os.contains("win")) {
			currentUploadBasePath = windowUploadBasePath;
		} else {
			log.warn("알 수 없는 OS 환경입니다. window 경로를 사용합니다.");
			currentUploadBasePath = windowUploadBasePath;
		}

		for(Integer attachDetailNo : attachDetailNos) {
			AttachmentFileDetailVO fileDetail = fileMapper.selectFileDetail(attachDetailNo);	// 개별 파일 조회
			if(fileDetail != null) {
				File physicalFile = new File(currentUploadBasePath + File.separator + fileDetail.getFileSavepath()
				+ File.separator + fileDetail.getFileSaveNm());		// 물리파일 주소값 가져옴 기본저장주소 + 저장경로 + 저장명
				if(physicalFile.exists()) {	// 실제 물리파일이 존재할 때
					if(physicalFile.delete()) {
						log.info("물리 파일 삭제 성공");
					} else {
						log.warn("물리 파일 삭제 실패!!");
					}
				} else {
					log.warn("삭제할 물리 파일 없음!!");
			}
				fileMapper.deleteFileDetail(attachDetailNo);	// DB에서 첨부파일 상세번호 삭제
				log.info("DB 첨부파일 상세번호 삭제 완료");
			}
		}
	}


	/**
	 * Bytes, KB, MB등으로 보기쉽게 변환함
	 * @param size
	 * @return
	 */
	private String fancySize(long size) {

		DecimalFormat df = new DecimalFormat("0.00");
		if(size < 1024) {
			return size + " Bytes";
		} else if(size < (1024 * 1024)) {
			return df.format((double) size / 1024) + " KB";
		} else {
			return df.format((double) size / (1024 * 1024)) + " MB";
		}
	}

	/**
	 * 각 번호 양식에 맞는 FITC값 넣어주세용
	 * 각 서비스 구현 클래스에 FILETYPECODE 상수로 사용하고
	 * 각 게시판에맞는 FITC 사용하면 됩니다. (예 : private static final FILETYPECODE = "FITC010";)
	 * @param fileTypeCode
	 * @return
	 */
	private String getFileTypeNmFromCode(String fileTypeCode) {
		if("FITC001".equals(fileTypeCode)) {
			return "기업 공지파일";
		}
		if("FITC002".equals(fileTypeCode)) {
			return "오디션 지원자파일";
		}
		if("FITC003".equals(fileTypeCode)) {
			return "오디션 공고파일";
		}
		if("FITC005".equals(fileTypeCode)) {
			return "DM 채팅 파일";
		}
		if("FITC008".equals(fileTypeCode)) {
			return "커뮤니티 공지파일";
		}
		if("FITC010".equals(fileTypeCode)) {
			return "콘서트 일정파일";
		}
		if("FITC006".equals(fileTypeCode)) {
			return "커뮤니티 게시글 파일";
		}
		if("FITC011".equals(fileTypeCode)) {
			return "전자결재";
		}
		return "기타파일";
	}

	@Override
	public int countFilesInGroup(int currentFileGroupNo) {
		return fileMapper.countFilesInGroup(currentFileGroupNo);
	}

	@Override
	public AttachmentFileDetailVO getFileInfo(int fileDetailNo) {
		return fileMapper.getFileInfo(fileDetailNo);

	}


	@Override
    @Transactional // 트랜잭션 적용
    public Integer addFilesToExistingGroup(MultipartFile[] files, String fileTypeCode, String uploaderId, int existingFileGroupNo) throws Exception {
        log.info("addFilesToExistingGroup 호출됨. 기존 그룹 번호: {}, fileTypeCode: {}, uploaderId: {}",
                 existingFileGroupNo, fileTypeCode, uploaderId);

        	// 1. 현재 OS에 맞는 기본 업로드 경로 선택
     		String os = System.getProperty("os.name").toLowerCase();
     		String currentUploadBasePath;

     		if (os.contains("mac") || os.contains("darwin")) {
     			currentUploadBasePath = macUploadBasePath;
     		} else if (os.contains("win")) {
     			currentUploadBasePath = windowUploadBasePath;
     		} else {
     			log.warn("알 수 없는 OS 환경입니다. window 경로를 사용합니다.");
     			currentUploadBasePath = windowUploadBasePath;
     		}

        // 추가할 파일이 없거나 비어있는 경우, 기존 그룹 번호를 그대로 반환하여 처리할 파일이 없음을 알림
        if (files == null || files.length == 0 || (files.length == 1 && files[0].isEmpty())) {
            log.info("추가할 파일이 없으므로, 기존 그룹 번호 {}를 반환합니다.", existingFileGroupNo);
            return existingFileGroupNo;
        }

        String datePath = KST_DATE_FORMAT.format(new Date()); // 실제 날짜를 통한 폴더 생성
        File finalUploadDirectory = new File(currentUploadBasePath + File.separator + datePath); // 파일 업로드 경로

        if (!finalUploadDirectory.exists()) {
            finalUploadDirectory.mkdirs(); // 디렉토리 생성
        }

        for (MultipartFile multipartFile : files) {
            if (multipartFile != null && !multipartFile.isEmpty()) {
                String originalFileName = multipartFile.getOriginalFilename();
                String fileExtension = "";
                if (originalFileName != null && originalFileName.contains(".")) {
                    fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                }
                String saveFileName = UUID.randomUUID().toString() + fileExtension;
                File saveFile = new File(finalUploadDirectory, saveFileName);

                try {
                    multipartFile.transferTo(saveFile); // 물리 파일 저장

                    AttachmentFileDetailVO fileDetail = new AttachmentFileDetailVO();
                    fileDetail.setFileGroupNo(existingFileGroupNo); // <-- 핵심: 기존 그룹 번호 사용
                    fileDetail.setFileOriginalNm(originalFileName);
                    fileDetail.setFileSaveNm(saveFileName);
                    fileDetail.setFileSavepath(datePath);
                    fileDetail.setFileExt(fileExtension.replace(".", ""));
                    fileDetail.setFileMimeType(multipartFile.getContentType());
                    fileDetail.setFileSize(multipartFile.getSize());
                    fileDetail.setFileFancysize(fancySize(multipartFile.getSize()));

                    fileMapper.insertFileDetail(fileDetail); // 파일 상세 정보만 DB에 삽입
                    log.info("기존 그룹({})에 파일 저장 및 DB 삽입 완료: {}", existingFileGroupNo, saveFileName);

                } catch (IOException e) {
                    log.error("파일 '{}' 저장 실패: {}", originalFileName, e.getMessage());
                    // 파일 저장 실패 시 트랜잭션 롤백을 위해 예외 다시 던짐
                    throw new IOException(originalFileName + " 파일 저장 실패", e);
                }
            }
        }
        return existingFileGroupNo; // 파일이 추가되었으므로 기존 그룹 번호를 그대로 반환
    }


}
