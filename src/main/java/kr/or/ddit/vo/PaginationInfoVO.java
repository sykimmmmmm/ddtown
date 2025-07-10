package kr.or.ddit.vo;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Data
public class PaginationInfoVO<T> {

	private int totalRecord;		// 총 게시글 수
	private int totalPage;			// 총 페이지 수
	private int currentPage;	// 현재 페이지
	private int screenSize = 10;	// 페이지 당 게시글 수
	private int blockSize = 5;		// 페이지 블록 수
	private int startRow;			// 시작 row
	private int endRow;				// 끝 row
	private int startPage;			// 시작 페이지
	private int endPage;			// 끝 페이지
	private List<T> dataList;		// 결과를 넣을 데이터 리스트
	private String searchType;		// 검색 타입
	private String searchWord;		// 검색 단어
	private String searchCode;		// 검색 단어2


	private String searchStatType;	// 1대1 문의 상태 코드 검색
	private String searchCategoryCode;		// 커뮤니티 공지사항 카테고리 검색

	private Integer artGroupNo;		// 공지사항 아티스트 구별용

	private String empUsername;		// 직원 아이디를 넣기 위함

	private String memUsername;

	private int comuPostNo; 		// 커뮤니티 게시글 상세 댓글(직원)

	private Map<String, Object> searchMap; //관리자 주문 관리 검색 맵

	private String badgeSearchType; // 뱃지 상태
	private String auditionStatusCode; //오디션 진행 상태

	private String startDate; 	// 주문내역 차트에서 클릭 시 해당 차트의 시작 월
    private String endDate; 	// 주문내역 차트에서 클릭 시 해당 차트의 종료 월
    private String label;		// 클릭한 해당 차트 구분 명

	public PaginationInfoVO() {}

	public PaginationInfoVO(int screenSize, int blockSize) {
		super();
		this.screenSize = screenSize;
		this.blockSize = blockSize;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;			// 현재 페이지
		this.endRow = currentPage * screenSize;	// 끝 row
		this.startRow = endRow - (screenSize - 1);
		// 마지막 페이지
		this.endPage = (currentPage + (blockSize - 1)) / blockSize * blockSize;
		// 시작 페이지
		this.startPage = endPage - (blockSize - 1);
	}

	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
		this.totalPage = (int) Math.ceil(this.totalRecord / (double) screenSize);
	}

	public void calculatePaging() {
        // totalRecord가 0인 경우 처리
        if (this.totalRecord == 0) {
            this.totalPage = 0;
            this.currentPage = 0;
            this.startRow = 0;
            this.endRow = 0;
            this.startPage = 0;
            this.endPage = 0;
            return;
        }

        // 1. 총 페이지 수 계산
        this.totalPage = (int) Math.ceil((double) this.totalRecord / this.screenSize);

        // 2. 현재 페이지가 유효한 범위 내에 있는지 확인 및 보정
        if (this.currentPage < 1) {
            this.currentPage = 1;
        }
        if (this.currentPage > this.totalPage) {
            this.currentPage = this.totalPage;
        }

        // 3. 시작 행 번호, 끝 행 번호 계산 (MyBatis 쿼리에서 사용할 값)
        // Oracle ROWNUM에 맞추어 1-based 인덱스로 설정
        this.startRow = (this.currentPage - 1) * this.screenSize + 1;
        this.endRow = this.currentPage * this.screenSize;

        // 4. 페이지 블록의 시작 페이지 번호 계산
        this.startPage = ((this.currentPage - 1) / this.blockSize) * this.blockSize + 1;

        // 5. 페이지 블록의 끝 페이지 번호 계산
        this.endPage = this.startPage + this.blockSize - 1;

        // 6. 끝 페이지 번호가 전체 페이지를 초과하지 않도록 제한
        if (this.endPage > this.totalPage) {
            this.endPage = this.totalPage;
        }
    }

	public String getPagingHTML() {
		StringBuffer html = new StringBuffer();
		 html.append("<ul class='pagination pagination-sm m-0 justify-content-center'>");

		// 이전 1 2 3 4 5 다음
		// css양식 정해지면 양식쪽에 이름정해서 삽입
		 if (startPage > 1) {
		        html.append("<li class='page-item'>"); // Bootstrap 5 클래스
		        html.append("<a class='page-link' href='#' data-page='").append(startPage - blockSize).append("'>이전</a>");
		        html.append("</li>");
		    } else {
		        // 비활성화된 "이전" 버튼 (선택적)
		        html.append("<li class='page-item disabled'><span class='page-link'>이전</span></li>");
		    }

		    for (int i = startPage; i <= (endPage < totalPage ? endPage : totalPage); i++) {
		        if (i == currentPage) {
		            // 현재 페이지: admin_portal.css의 a.active 스타일을 위해 a 태그 사용 및 active 클래스 추가
		            html.append("<li class='page-item active'>"); // Bootstrap 5 클래스
		            html.append("<span class='page-link' href='#' data-page='").append(i).append("'>").append(i).append("</span>");
		            html.append("</li>");
		        } else {
		            html.append("<li class='page-item'>");
		            html.append("<a class='page-link' href='' data-page='").append(i).append("'>").append(i).append("</a>");
		            html.append("</li>");
		        }
		    }

		    // "다음" 버튼
		    if (endPage < totalPage) {
		        html.append("<li class='page-item'>");
		        html.append("<a class='page-link' href='' data-page='").append(endPage + 1).append("'>다음</a>");
		        html.append("</li>");
		    } else {
		        // 비활성화된 "다음" 버튼 (선택적)
		        html.append("<li class='page-item disabled'><span class='page-link'>다음</span></li>");
		    }

		    html.append("</ul>");
		    return html.toString();
	}


    // ★★★ 굿즈샵 전용 getGoodsPagingHTML() 메서드 추가 ★★★
    public String getGoodsPagingHTML(String contextPath) {
        StringBuffer html = new StringBuffer();
        html.append("<ul class='pagination pagination-sm m-0 justify-content-center'>");

        // 굿즈샵 메인 페이지의 기본 URL
        String baseUrl = contextPath + "/goods/main";

        // 이전 버튼
        if (startPage > 1) {
            html.append("<li class='page-item'>");
            html.append("<a class='page-link' href='").append(baseUrl)
                .append("?currentPage=").append(startPage - blockSize)
                .append(getGoodsSearchQueryParams()) // 굿즈샵 전용 검색 쿼리 파라미터 사용
                .append("'>이전</a>");
            html.append("</li>");
        } else {
            html.append("<li class='page-item disabled'><span class='page-link'>이전</span></li>");
        }

        // 페이지 번호
        for (int i = startPage; i <= (endPage < totalPage ? endPage : totalPage); i++) {
            if (i == currentPage) {
                html.append("<li class='page-item active'>");
                html.append("<span class='page-link'>").append(i).append("</span>");
                html.append("</li>");
            } else {
                html.append("<li class='page-item'>");
                html.append("<a class='page-link' href='").append(baseUrl)
                    .append("?currentPage=").append(i)
                    .append(getGoodsSearchQueryParams()) // 굿즈샵 전용 검색 쿼리 파라미터 사용
                    .append("'>").append(i).append("</a>");
                html.append("</li>");
            }
        }

        // 다음 버튼
        if (endPage < totalPage) {
            html.append("<li class='page-item'>");
            html.append("<a class='page-link' href='").append(baseUrl)
                .append("?currentPage=").append(endPage + 1)
                .append(getGoodsSearchQueryParams()) // 굿즈샵 전용 검색 쿼리 파라미터 사용
                .append("'>다음</a>");
            html.append("</li>");
        } else {
            html.append("<li class='page-item disabled'><span class='page-link'>다음</span></li>");
        }

        html.append("</ul>");
        return html.toString();
    }

    // ★★★ 굿즈샵 전용 검색 쿼리 파라미터 생성 메서드 추가 ★★★
    public String getGoodsSearchQueryParams() {
        StringBuilder sb = new StringBuilder();
        try {
            // searchType (정렬 기준 또는 'goodsNm' 검색 타입)
            if (this.searchType != null && !this.searchType.isEmpty()) {
                sb.append("&searchType=").append(URLEncoder.encode(this.searchType, StandardCharsets.UTF_8.toString()));
            }
            // searchWord (상품명 검색어)
            if (this.searchWord != null && !this.searchWord.isEmpty()) {
                sb.append("&searchWord=").append(URLEncoder.encode(this.searchWord, StandardCharsets.UTF_8.toString()));
            }
            // artGroupNo (아티스트 필터링용)
            // artGroupNo가 0인 경우는 '전체'를 의미할 수 있으므로, URL에 추가하지 않는 것이 좋습니다.
            // 컨트롤러에서 artGroupNo가 'all'일 때 null 또는 0으로 설정하도록 합니다.
            if (this.artGroupNo != null && this.artGroupNo != 0) {
                sb.append("&artGroupNo=").append(this.artGroupNo);
            }
            // 기타 공통 VO에서 사용하는 검색 조건들도 필요하다면 여기에 추가
            if (this.searchStatType != null && !this.searchStatType.isEmpty()) {
                sb.append("&searchStatType=").append(URLEncoder.encode(this.searchStatType, StandardCharsets.UTF_8.toString()));
            }
            if (this.searchCategoryCode != null && !this.searchCategoryCode.isEmpty()) {
                sb.append("&searchCategoryCode=").append(URLEncoder.encode(this.searchCategoryCode, StandardCharsets.UTF_8.toString()));
            }
            if (this.searchCode != null && !this.searchCode.isEmpty()) {
                sb.append("&searchCode=").append(URLEncoder.encode(this.searchCode, StandardCharsets.UTF_8.toString()));
            }

        } catch (Exception e) {
            System.err.println("URL 인코딩 중 오류 발생: " + e.getMessage());
        }
        return sb.toString();
    }

 // ★★★ 찜목록 전용 getWishlistPagingHTML() 메서드 추가 ★★★
    public String getWishlistPagingHTML(String contextPath) {
        StringBuffer html = new StringBuffer();
        html.append("<ul class='pagination pagination-sm m-0 justify-content-center'>");

        // 찜목록 페이지의 기본 URL
        String baseUrl = contextPath + "/goods/wishlist";

        // 이전 버튼
        if (startPage > 1) {
            html.append("<li class='page-item'>");
            html.append("<a class='page-link' href='").append(baseUrl)
                .append("?currentPage=").append(startPage - blockSize) // blockSize 대신 pageSize 사용 (PaginationInfoVO 필드명에 따라)
                .append("'>이전</a>");
            html.append("</li>");
        } else {
            html.append("<li class='page-item disabled'><span class='page-link'>이전</span></li>");
        }

        // 페이지 번호
        for (int i = startPage; i <= (endPage < totalPage ? endPage : totalPage); i++) {
            if (i == currentPage) {
                html.append("<li class='page-item active'>");
                html.append("<span class='page-link'>").append(i).append("</span>");
                html.append("</li>");
            } else {
                html.append("<li class='page-item'>");
                html.append("<a class='page-link' href='").append(baseUrl)
                    .append("?currentPage=").append(i)
                    .append("'>").append(i).append("</a>"); // 찜목록은 추가 검색 파라미터 없음
                html.append("</li>");
            }
        }

        // 다음 버튼
        if (endPage < totalPage) {
            html.append("<li class='page-item'>");
            html.append("<a class='page-link' href='").append(baseUrl)
                .append("?currentPage=").append(endPage + 1)
                .append("'>다음</a>"); // 찜목록은 추가 검색 파라미터 없음
            html.append("</li>");
        } else {
            html.append("<li class='page-item disabled'><span class='page-link'>다음</span></li>");
        }

        html.append("</ul>");
        return html.toString();
    }

	 // ⭐⭐ 찜 목록 전용 페이지 보정 메서드 ⭐⭐
	 // 이 메서드는 totalRecord가 설정된 후에 호출되어야 합니다.
	 public void applyWishlistPagination() {
	     // totalRecord가 0인 경우 처리
	     if (this.totalRecord == 0) {
	         this.totalPage = 0;
	         this.currentPage = 0;
	         this.startRow = 0;
	         this.endRow = 0;
	         this.startPage = 0;
	         this.endPage = 0;
	         return;
	     }

	     // 1. 총 페이지 수 다시 계산 (totalRecord가 setTotalRecord로 이미 설정되었다고 가정)
	     // Math.ceil을 사용하여 소수점 이하가 있으면 올림 처리 (예: 10.1개 -> 11페이지)
	     this.totalPage = (int) Math.ceil((double) this.totalRecord / this.screenSize);

	     // 2. 현재 페이지가 유효한 범위 내에 있는지 확인 및 보정
	     if (this.currentPage < 1) {
	         this.currentPage = 1;
	     }
	     if (this.currentPage > this.totalPage) {
	         this.currentPage = this.totalPage;
	     }

	     // 3. 시작 행 번호, 끝 행 번호 계산 (Oracle ROWNUM에 맞추어 1-based 인덱스로 설정)
	     // startRow는 조회할 레코드의 시작 번호 (1부터 시작)
	     this.startRow = (this.currentPage - 1) * this.screenSize + 1; // ⭐⭐ 여기에 '+ 1'을 추가합니다. ⭐⭐

	     // endRow는 조회할 레코드의 마지막 번호
	     this.endRow = this.currentPage * this.screenSize;

	     // 4. 페이지 블록의 시작 페이지 번호 계산
	     // 예: blockSize=5, currentPage=7 -> (7-1)/5 = 1.2 -> 1 * 5 + 1 = 6 (startPage)
	     this.startPage = ((this.currentPage - 1) / this.blockSize) * this.blockSize + 1;

	     // 5. 페이지 블록의 끝 페이지 번호 계산
	     this.endPage = this.startPage + this.blockSize - 1;

	     // 6. 끝 페이지 번호가 전체 페이지를 초과하지 않도록 제한 (핵심 로직)
	     if (this.endPage > this.totalPage) {
	         this.endPage = this.totalPage;
	     }
	 }

	 // ⭐⭐ 새로 추가할: 공지사항 전용 검색 쿼리 파라미터 생성 메서드 ⭐⭐
	    private String getNoticeSearchQueryParams() {
	        StringBuilder sb = new StringBuilder();
	        try {
	            if (this.searchType != null && !this.searchType.isEmpty()) {
	                sb.append("&searchType=").append(URLEncoder.encode(this.searchType, StandardCharsets.UTF_8.toString()));
	            }
	            if (this.searchWord != null && !this.searchWord.isEmpty()) {
	                sb.append("&searchWord=").append(URLEncoder.encode(this.searchWord, StandardCharsets.UTF_8.toString()));
	            }
	            // 공지사항 고유 검색 조건
	            if (this.searchCategoryCode != null && !this.searchCategoryCode.isEmpty()) {
	                sb.append("&searchCategoryCode=").append(URLEncoder.encode(this.searchCategoryCode, StandardCharsets.UTF_8.toString()));
	            }
	            if (this.empUsername != null && !this.empUsername.isEmpty()) {
	                sb.append("&empUsername=").append(URLEncoder.encode(this.empUsername, StandardCharsets.UTF_8.toString()));
	            }
	            // 필요한 경우 artGroupNo도 공지사항 검색 조건에 추가
	            if (this.artGroupNo != null && this.artGroupNo != 0) {
	                sb.append("&artGroupNo=").append(this.artGroupNo);
	            }
	        } catch (Exception e) {
	            log.error("Notice search query params encoding error: {}", e.getMessage(), e);
	        }
	        return sb.toString();
	    }

	    // ⭐⭐ 새로 추가할: 공지사항 전용 getNoticePagingHTML() 메서드 ⭐⭐
	    public String getNoticePagingHTML(String contextPath) { // customBaseUrl 대신 contextPath만 받음
	        StringBuffer html = new StringBuffer();
	        html.append("<ul class='pagination pagination-sm m-0 justify-content-center'>");

	        // 공지사항 페이지의 기본 URL
	        String baseUrl = contextPath + "/goods/notice/list";

	        // 공통적인 검색 쿼리 파라미터 생성
	        String commonQueryParams = getNoticeSearchQueryParams();

	        // ◀ 이전 버튼
	        if (startPage > 1) {
	            html.append("<li class='page-item'>");
	            html.append("<a class='page-link' href='").append(baseUrl)
	                .append("?currentPage=").append(startPage - blockSize)
	                .append(commonQueryParams)
	                .append("'>이전</a>");
	            html.append("</li>");
	        } else {
	            html.append("<li class='page-item disabled'><span class='page-link'>이전</span></li>");
	        }

	        // 페이지 번호
	        for (int i = startPage; i <= (endPage < totalPage ? endPage : totalPage); i++) {
	            if (i == currentPage) {
	                html.append("<li class='page-item active'>");
	                html.append("<span class='page-link'>").append(i).append("</span>");
	                html.append("</li>");
	            } else {
	                html.append("<li class='page-item'>");
	                html.append("<a class='page-link' href='").append(baseUrl)
	                    .append("?currentPage=").append(i)
	                    .append(commonQueryParams)
	                    .append("'>").append(i).append("</a>");
	                html.append("</li>");
	            }
	        }

	        // ▶ 다음 버튼
	        if (endPage < totalPage) {
	            html.append("<li class='page-item'>");
	            html.append("<a class='page-link' href='").append(baseUrl)
	                .append("?currentPage=").append(endPage + 1)
	                .append(commonQueryParams)
	                .append("'>다음</a>");
	            html.append("</li>");
	        } else {
	            html.append("<li class='page-item disabled'><span class='page-link'>다음</span></li>");
	        }

	        html.append("</ul>");
	        return html.toString();
	    }
}

