package kr.or.ddit.vo.goods;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.file.AttachmentFileDetailVO;
import lombok.Data;

@Data
public class goodsVO {
	private int goodsNo; //상품 번호

	private int artGroupNo; //아티스트 그룹 번호
	private String artGroupName;

	private String goodsStatCode; //상품 상태코드
	private String goodsNm; //상품명
	private int goodsPrice; //상품 단가
	private String goodsContent; //상품 설명
	private Date goodsRegDate; //상품 등록 일시
	private Date goodsModDate; //상품 수정 일시
	private String goodsCode; //상품 코드
	private String goodsMultiOptYn; //다중 옵션 여부
	private String goodsDivCode;	// 굿즈 구분 코드 "GOODS", "MEMBERSHIP", "TICKET"

	private String statusEngKey; //상품 상태 영어
	private String statusKorName; //상품 상태 한국어

	private boolean useOption; //itemForm.jsp의 <input type="checkbox" name="useOptions"> 와 매핑
	private Integer stockRemainQty; // 현재 남아있는 재고 수량

	private List<goodsOptionVO> options; //사용자가 입력한 옵션 목록

	private MultipartFile[] goodsFiles;				// 업로드 파일들
	private String representativeImageUrl;				// 대표이미지
	private AttachmentFileDetailVO representativeImageFile; // ★ 대표 이미지 객체를 담을 필드

	private Integer fileGroupNo;						// 파일 그룹번호
	private List<AttachmentFileDetailVO> attachmentFileList;	// 상세보기 전체파일 목록

	private List<Integer> deleteAttachDetailNos; // 삭제할 첨부파일 상세 번호(attachDetailNo) 목록을 위한 필드!
	private List<Integer> deleteOptionNos; //삭제할 옵션 번호(goodsOptNo) 목록을 위한 필드!

	private Integer defaultOptionNo; // 상품의 기본(대표) 옵션 번호

	private int totalSalesAmount; // 굿즈 판매 갯수

	private boolean isWished; //찜 확인

	public boolean isWished() {
		return this.isWished;
	}

}
