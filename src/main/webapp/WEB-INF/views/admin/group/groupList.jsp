<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 관리자 - 그룹 계정 관리</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <style>
        /* 아티스트명 링크 스타일 */
        .artist-name-link {
            font-weight: 500;
            color: #007bff; /* 기본 링크 색상 */
            text-decoration: none;
        }
        .artist-name-link:hover {
            text-decoration: underline;
        }
        #accountAddButton {
		    width: auto; /* 내용에 맞게 너비 자동 조절 */
		    min-width: max-content; /* 최소 너비를 내용만큼 확보 (예: "검색" 두 글자) */
		    white-space: nowrap; /* 글자가 두 줄로 나뉘는 것을 방지 */
		    writing-mode: horizontal-tb !important; /* 혹시라도 writing-mode가 세로로 설정된 경우 강제 변경 */
		    padding-left: 12px; /* 버튼 내부 여백 (기존 .ea-btn 스타일에 따라 조절) */
		    padding-right: 12px; /* 버튼 내부 여백 (기존 .ea-btn 스타일에 따라 조절) */
		}
		.total{
			background-color: #007bff;
		}
		.group{
			cursor: pointer;
		}
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>

            <main class="emp-content" style="font-size: large;">
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">그룹 관리</li>
					</ol>
				</nav>
                <section class="ea-section" style="font-size: larger;">
                   	<div class="ea-section-header">
                   		<div class="d-flex gap-3 align-items-center">
	                    	<h2>그룹 관리</h2>
	                    	<div>
		                    	<span class="status-badge total group" data-del-yn="all">전체 ${groupSummaryMap.TOTALCNT} 명</span>
		                        <span class="status-badge answered group" data-del-yn="N">활성 ${groupSummaryMap.ACTIVECNT} 명</span>
		                        <span class="status-badge danger group" data-del-yn="Y">은퇴 ${groupSummaryMap.DEACTIVECNT} 명</span>
	                    	</div>
                   		</div>
                    	<div class="ea-header-actions">
	                        <form class="input-group input-group-sm" method="get" id="searchForm" style="flex-wrap: nowrap;">
	                        	<input type="hidden" name="artGroupDelYn" id="artGroupDelYn">
	                       		<input type="hidden" name="currentPage" value="1" id="page">
	                       		<select id="searchType" name="searchType" class="ea-filter-select" style="margin-right: 10px; width:30%;">
	                                <option value="group">그룹</option>
	                                <option value="member" <c:if test="${pagingVO.searchType eq 'member'}">selected</c:if>>멤버</option>
	                            </select>
	                            <input type="text" name="searchWord" value="${pagingVO.searchWord }" class="ea-search-input" placeholder="그룹명 검색">
	                            <div class="input-group-append">
									<button type="submit" class="ea-btn primary">
										<i class="fas fa-search"></i>검색
									</button>
								</div>
	                       	</form>
                       	</div>
                    </div>

                    <table class="ea-table" id="groupTable">
                        <thead>
                            <tr>
                                <th width="10%">번호</th>
                                <th>활동 여부</th>
                                <th>그룹명</th>
                                <th>멤버수</th>
                                <th>멤버</th>
                                <th>담당자</th>
                                <th>데뷔일</th>
                            </tr>
                        </thead>
                        <tbody id="groupTableBody">
                        	<c:forEach items="${pagingVO.dataList }" var="group">
								<tr>
									<td>${group.artGroupNo }</td>
									<td>
										<c:if test="${group.artGroupDelYn eq 'Y'}">
											<span class="status-badge danger">해체</span>
										</c:if>
										<c:if test="${group.artGroupDelYn eq 'N'}">
											<span class="status-badge answered">활동</span>
										</c:if>
									</td>
									<td style="text-align: left;"><a href="#" data-art-group-no="${group.artGroupNo}" >${group.artGroupNm }</a></td>
									<td>${fn:length(group.artistList) }</td>
									<td style="text-align: left;"><c:forEach items="${group.artistList}" var="artist" varStatus="vs">${artist.artNm}<c:if test="${not vs.last}">, </c:if> </c:forEach> </td>
									<td>${group.empName}</td>
									<td>${group.artGroupDebutdate }</td>
								</tr>
                        	</c:forEach>
                        </tbody>
                    </table>
                    <div class="d-flex justify-content-center align-items-center">
	                    <div class="ea-pagination" id="pagingArea" style="margin-left:auto;">
	                    	${pagingVO.pagingHTML }
	                    </div>
	                    <div style="margin-top:18px; margin-left:auto;">
		                    <a class="ea-btn primary" href="/admin/community/group/form" id="accountAddButton"><i class="fas fa-plus"></i>등록</a>
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
document.addEventListener('DOMContentLoaded', function() {

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
})


$(function(){
	// 검색결과 유지한채 상세페이지 이동
	const groupTableBody = $("#groupTableBody");
	groupTableBody.on("click","a",function(){
		let searchWord = "${pagingVO.searchWord}";
		let currentPage = "${pagingVO.currentPage}";
		let artGroupNo = $(this).data("artGroupNo");

		sessionStorage.setItem("searchWord",searchWord);
		sessionStorage.setItem("currentPage",currentPage);

		location.href="/admin/community/group/detail?artGroupNo="+artGroupNo;
	})

	$(".group").on("click",function(){
		let delYn = $(this).data("delYn");
		$("#artGroupDelYn").val(delYn);
		$("#searchType").val("group");
		$("#searchWord").val("");
		searchForm.submit()
	})
});
</script>
</html>