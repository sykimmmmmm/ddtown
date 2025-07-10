<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 관리자 - 아티스트 계정 관리</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <style>
        .artist-name-link {
            font-weight: 500;
            color: #007bff;
            text-decoration: none;
        }
        .artist-name-link:hover {
            text-decoration: underline;
        }
        #accountAddButton {
		    width: auto;
		    min-width: max-content;
		    white-space: nowrap;
		    writing-mode: horizontal-tb !important;
		    padding-left: 12px;
		    padding-right: 12px;
		}
		.total{
			background-color: #007bff;
		}
		.artist{
			cursor: pointer;
		}
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
            <main class="emp-content">
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">아티스트 관리</li>
					</ol>
				</nav>
                <section class="ea-section" style="font-size: larger;">
                    <div class="ea-section-header" style="font-size: larger;">
                    	<div class="d-flex gap-3 align-items-center">
	                        <h2>아티스트 관리</h2>
	                        <div>
		                        <span class="status-badge total artist" data-del-yn="all">전체 ${summaryMap.TOTALCNT} 명</span>
		                        <span class="status-badge answered artist" data-del-yn="N">활성 ${summaryMap.ACTIVECNT} 명</span>
		                        <span class="status-badge danger artist" data-del-yn="Y">은퇴 ${summaryMap.DEACTIVECNT} 명</span>
	                        </div>
                    	</div>
                        <div class="ea-header-actions">

                        	<form class="input-group input-group-sm" method="get" id="searchForm">
								<input type="hidden" name="artDelYn" id="artDelYn">
                        		<input type="hidden" name="currentPage" value="${pagingVO.currentPage}" id="page">
								<select id="searchType" name="searchType" class="form-select">
									<option value="artist" <c:if test="${pagingVO.searchType eq 'artist'}">selected</c:if>>아티스트</option>
									<option value="group" <c:if test="${pagingVO.searchType eq 'group'}">selected</c:if>>그룹</option>
									<option value="emp" <c:if test="${pagingVO.searchType eq 'emp'}">selected</c:if>>담당자</option>
								</select>
	                            <input type="text" id="searchWord" name="searchWord" value="${pagingVO.searchWord}" class="ea-search-input" placeholder="아티스트명 검색">

	                            <div class="input-group-append">
									<button type="submit" class="ea-btn primary">
										<i class="fas fa-search"></i>검색
									</button>
								</div>
                        	</form>

                        </div>
                    </div>

                    <table class="ea-table" id="artistAccountTable" style="font-size: larger;">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>활동상태</th>
                                <th>아티스트명</th>
                                <th>그룹명</th>
                                <th>담당자</th>
                                <th>데뷔일</th>
                            </tr>
                        </thead>
                        <tbody id="artistAccountTableBody">
	                        <c:choose>
	                        	<c:when test="${empty pagingVO.dataList}">
	                        		<tr>
	                        			<td colspan="6">검색한 결과가 존재하지 않습니다.</td>
	                        		</tr>
	                        	</c:when>
	                        	<c:otherwise>
	                        	<c:forEach items="${pagingVO.dataList }" var="artist">
	                        		<tr>
		                        		<td>${artist.artNo }</td>
		                        		<td>
		                        			<c:if test="${artist.artDelYn eq 'Y'}">
												<span class="status-badge danger">은퇴</span>
											</c:if>
											<c:if test="${artist.artDelYn eq 'N'}">
												<span class="status-badge answered">활동</span>
											</c:if>
		                        		</td>
		                                <td ><a href="#" data-art-no="${artist.artNo}" >${artist.artNm }</a></td>
		                                <td>
		                                	<c:if test="${empty artist.groupList}">
		                                		그룹 없음
		                                	</c:if>
		                                	<c:if test="${not empty artist.groupList}">
				                                ${artist.groupList[0].artGroupNm }
		                                	</c:if>
		                                </td>
		                                <td>
		                                	<c:if test="${empty artist.groupList}">
		                                		그룹 없음
		                                	</c:if>
		                                	<c:if test="${not empty artist.groupList}">
				                                ${artist.groupList[0].empName }
		                                	</c:if>
	                                	</td>
		                                <td>${artist.artDebutdate }</td>
		                            </tr>
	                        	</c:forEach>
	                        	</c:otherwise>
	                        </c:choose>

                        </tbody>
                    </table>
                    <div class="d-flex justify-content-center align-items-center">
	                    <div class="ea-pagination" id="pagingArea" style="margin-left:auto;">
	                    	${pagingVO.pagingHTML }
	                    </div>
	                    <div style="margin-top:18px; margin-left:auto;">
	                    	<a class="ea-btn primary" href="/admin/community/artist/form" id="accountAddButton"><i class="fas fa-plus"></i> 등록 </a>
	                    </div>
                    </div>
                </section>
            </main>
        </div>
    </div>
</body>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<script type="text/javascript">
$(function(){
//페이지네이션 처리 시작
const searchForm = document.getElementById("searchForm");
const pageInput = searchForm.querySelector("input[name='currentPage']"); // hidden input의 name 사용
const paginationControls = document.getElementById("pagingArea");

if (paginationControls) { // paginationControls 요소가 존재할 때만 이벤트 리스너 추가
    paginationControls.addEventListener("click", function(e) {
        e.preventDefault(); // 기본 링크 이동 방지

        // 클릭된 요소가 'page-link' 클래스를 가지고 있고 'A' 또는 'SPAN' 태그인지 확인
        if (e.target.classList.contains("page-link") && (e.target.nodeName === "A")) {
            pageInput.value = e.target.dataset.page; // data-page 속성 값으로 hidden input 업데이트
            searchForm.submit(); // 폼 제출
        }
    });
 }
 // 페이지네이션 처리 끝
	// 검색결과 유지한채 이동
	let artistAccountTableBody = $("#artistAccountTableBody");
	artistAccountTableBody.on("click","a",function(){
		const artNo = $(this).data("artNo");
		let searchType = "${pagingVO.searchType}";
		let searchWord = "${pagingVO.searchWord}";
		let currentPage = "${pagingVO.currentPage}";

		sessionStorage.setItem("currentPage",currentPage);
		sessionStorage.setItem("searchType",searchType);
		sessionStorage.setItem("searchWord",searchWord);

		location.href="/admin/community/artist/detail?artNo="+artNo;
	})

	$("#searchWord").on("click",function(){
		$(this).val("");
	})


	$(".artist").on("click",function(){
		let delYn = $(this).data("delYn");
		console.log(delYn)
		$("#artDelYn").val(delYn)
		$("#searchWord").val("");
		$("#searchType").val("artist")
		searchForm.submit();
	})
})
</script>
</html>