<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 전자결재 - 받은 결재/참조 문서함</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/approval_draft_style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
	<style type="text/css">
		body {
		    font-family: 'Noto Sans KR', sans-serif;
		    color: #333;
		    background-color: #f8f8f8; /* 전체 페이지 배경색 */
		    line-height: 1.6;
		}

		a {
		    text-decoration: none;
		    color: inherit; /* 기본 링크 색상 상속 */
		}
		main.emp-content {
		    padding: 25px;
/* 		    max-width: 1300px; /* 메인 컨텐츠의 최대 너비 설정 */ */
		    margin: 0 auto; /* 메인 컨텐츠 중앙 정렬 */
		    box-sizing: border-box; /* 패딩이 너비에 포함되도록 */
		}
		#searchForm {
		    display: flex;
		    gap: 10px;
		    align-items: center;
		    flex-wrap: wrap;
		}
		.approval-search-input {
		    height: 40px;
		    border-radius: 5px;
		    border: 1px solid #ced4da;
		    padding: 0 12px;
		    font-size: 1em;
		    color: #495057;
		    background-color: #fff;
		    transition: all 0.2s ease-in-out;
		    min-width: 78px; /* 입력 필드 최소 너비 보장 */
		    width: 78px;
		}
		.approval-search-input:focus {
		    border-color: #234aad;
		    box-shadow: 0 0 0 0.25rem rgba(35, 74, 173, 0.25);
		    outline: none;
		}
		.approval-list-table-wrap {
		    margin-top: 20px;
		    border-radius: 8px;
		    overflow: hidden; /* 테두리/그림자가 border-radius를 따르도록 */
		    border: 1px solid #e0e0e0; /* 테이블 전체에 대한 외부 테두리 */
		}

		.approval-list-table {
		    width: 100%;
		    border-collapse: collapse; /* 기본 셀 간격 제거 */
		    font-size: 0.95em;
		    table-layout: fixed; /* 고정 열 너비 */
		    min-width: 800px; /* 작은 화면에서 찌그러지지 않도록 최소 너비 설정 */
		}

		.approval-list-table thead th {
		    background-color: #f0f5ff; /* 헤더 배경색 */
		    color: #234aad; /* 헤더 텍스트 색상 */
		    font-weight: 600;
		    padding: 12px 15px;
		    text-align: center; /* 모든 헤더 텍스트 가운데 정렬 */
		    border-bottom: 1px solid #dddddd;
		    white-space: nowrap; /* 헤더 텍스트 줄바꿈 방지 */
		}

		.approval-list-table tbody td {
		    padding: 10px 15px;
		    border-bottom: 1px solid #eeeeee; /* 행 사이의 옅은 테두리 */
		    color: #555555;
		    vertical-align: middle;
		    word-break: break-word; /* 긴 단어 줄바꿈 허용 */
		}

		/* 테이블 행 홀수/짝수 배경색 */
		.approval-list-table tbody tr:nth-child(even) {
		    background-color: #fcfdff; /* 짝수 행을 위한 더 밝은 배경색 */
		}

		/* 테이블 행 호버 효과 */
		.approval-list-table tbody tr:hover {
		    background-color: #e9f7ff; /* 호버 시 연한 파란색 */
		    cursor: pointer;
		}

		.approval-list-table tbody tr:last-child td {
		    border-bottom: none; /* 마지막 행에는 테두리 없음 */
		}

		/* tbody 셀의 특정 열 정렬 */
		.approval-list-table tbody td:nth-child(1) { /* 번호 */
		    width: 8%;
		    text-align: center;
		}
		.approval-list-table tbody td:nth-child(2) { /* 중요 */
		    width: 10%;
		    text-align: center;
		}
		.approval-list-table tbody td:nth-child(3) { /* 결재상태 */
		    width: 12%;
		    text-align: center;
		}
		.approval-list-table tbody td:nth-child(4) { /* 제목 */
		    width: 35%; /* 제목에 더 넓은 공간 할당 */
		    text-align: left; /* 제목 왼쪽 정렬 */
		    font-weight: 500;
		}
		.approval-list-table tbody td:nth-child(5) { /* 기안자 */
		    width: 15%;
		    text-align: center;
		}
		.approval-list-table tbody td:nth-child(6) { /* 기안일 */
		    width: 20%;
		    text-align: center;
		}

		/* 테이블 제목 링크 스타일 */
		.approval-list-table tbody td a {
		    color: #007bff; /* 파란색 링크 색상 */
		    text-decoration: none;
		    transition: color 0.2s ease, text-decoration 0.2s ease;
		}
		.approval-list-table tbody td a:hover {
		    color: #0056b3; /* 호버 시 더 진한 파란색 */
		    text-decoration: underline;
		}

		/* ---------------------------------- */
		/* Approval Status Badges (Table Internal) */
		/* ---------------------------------- */
		.approval-list-table tbody .stat {
		    display: inline-block;
		    padding: 5px 12px; /* 패딩 증가 */
		    border-radius: 20px; /* 더 둥근 모서리 */
		    font-size: 0.85em; /* 뱃지 글꼴 크기 약간 작게 */
		    font-weight: 600;
		    white-space: nowrap;
		    line-height: 1; /* 세로 정렬을 위한 라인 높이 조정 */
		    box-shadow: 0 1px 3px rgba(0,0,0,0.1); /* 미묘한 그림자 효과 */
		    background-color: gold;
		}
		/* 중요도 텍스트 스타일 */
		.approval-list-table tbody .status-urgent {
		    color: #dc3545; /* 긴급 (빨간색) */
		    font-weight: 600;
		}
		.approval-list-table tbody .status-normal {
		    color: #6c757d; /* 일반 (회색, 좀 더 차분하게) */
		    font-weight: 500;
		}
		/* 검색 결과 없음 메시지 */
		.approval-list-table tbody tr td[colspan="6"] {
		    text-align: center;
		    padding: 40px 15px;
		    color: #777;
		    font-style: italic;
		    background-color: #fefefe;
		}

		.edms{
			cursor: pointer;
		}
		.status-badge.total{
			background-color: #007bff;
		}
		.status-badge.approver{
			background-color: #bf309a;
		}
		.status-badge.reference{
			background-color: #c37c11;
		}
		.status-badge.approve{
			background-color: #28a745;
		}
		.status-badge.reject{
			background-color: #dc3545;
		}
		.status-badge.prog{
			background-color: #17a2b8;
		}
		.status-badge.pend{
			background-color: #6c757d;
		}
	</style>
</head>
<body>
	<div class="emp-container">
		<%@ include file="../modules/header.jsp" %>

		<div class="emp-body-wrapper">
			<%@ include file="../modules/aside.jsp" %>

			<main class="emp-content" style="font-size: medium;">
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">전자결재</a></li>
					  <li class="breadcrumb-item active" aria-current="page">받은 결재/참조 문서함</li>
					</ol>
				</nav>
				<section class="ea-section" style="font-size: small;">

					<div class="ea-section-header">
						<div class="d-flex gap-3 align-items-center">
							<h4>결재/참조 문서함</h4>
							<div>
								<span class="status-badge total edms" data-stat-code="all">전체 ${summaryMap.TOTALCNT} 건</span>
								<span class="status-badge approver edms" data-stat-code="approver">결재 ${summaryMap.APPROVERCNT} 건</span>
								<span class="status-badge reference edms" data-stat-code="reference">참조 ${summaryMap.REFERENCECNT} 건</span>
		                        <span class="status-badge approve edms" data-stat-code="ESC003">승인 ${summaryMap.APPROVECNT}  건</span>
		                        <span class="status-badge reject edms" data-stat-code="ESC004">반려 ${summaryMap.REJECTCNT} 건</span>
		                        <span class="status-badge prog edms" data-stat-code="ESC002">진행 ${summaryMap.PROGCNT} 건</span>
		                        <span class="status-badge pend edms" data-stat-code="ESC001">대기 ${summaryMap.PENDCNT} 건</span>
							</div>
						</div>

						<div class="approval-list-search-row ea-header-actions align-items-center" style="display:flex; gap:8px; justify-content: flex-end; align-items: center;">
							<form id="searchForm">
								<input type="hidden" name="edmsStatCode" id="edmsStatCode">
								<input type="hidden" name="currentPage" id="currentPage" value="${pagingVO.currentPage}">
								<select id="searchType" name="searchType" class="approval-search-input" style="height:40px; border-radius:5px; border:1px solid #ccc; font-size:1em;">
									<option value="title" <c:if test="${pagingVO.searchType eq 'title'}">selected</c:if>>제목</option>
									<option value="approval"<c:if test="${pagingVO.searchType eq 'approval'}">selected</c:if>>기안자</option>
								</select>
								<input type="text" id="searchWord" name="searchWord" value="${pagingVO.searchWord}" class="approval-search-input" placeholder="검색 (제목, 작성자...)" style="width:170px; height:40px; border-radius:5px; border:1px solid #ccc; padding:0 12px; font-size:1em;">
								<button type="submit" id="approval-search-btn" class="ea-btn primary" style="height:36px; min-width:70px;"><i class="fas fa-search"></i> 검색</button>
							</form>
						</div>
					</div>

					<div class="approval-list-table-wrap">
						<table class="approval-list-table">
							<thead>
								<tr>
									<th width="10%">번호</th>
									<th width="10%">중요</th>
									<th width="10%">결재상태</th>
									<th>제목</th>
									<th width="10%">기안자</th>
									<th width="10%">기안일</th>
								</tr>
							</thead>
							<tbody id="approval-list-tbody">
								<c:choose>
									<c:when test="${pagingVO.dataList ne null and pagingVO.dataList[0].edmsNo ne 0 }">
										<c:forEach items="${pagingVO.dataList}" var="approval">
											<tr>
												<td>${approval.edmsManageNo}</td>
												<td>
													<c:if test="${approval.edmsUrgenYn eq 'Y'}">
														<span style="color:#dc3545; font-weight: bold;">긴급</span>
													</c:if>
													<c:if test="${approval.edmsUrgenYn eq 'N'}">
														<span style="font-weight: bold;">일반</span>
													</c:if>

												</td>
												<td>
												<c:if test="${approval.edmsStatCode eq 'ESC001'}">
													<span class="stat" style="background:#818681;color:#fff;padding:4px 12px;border-radius:16px;font-size:0.97em;">대기</span>
												</c:if>
												<c:if test="${approval.edmsStatCode eq 'ESC002'}">
													<span class="stat" style="background:#17a2b8;color:#fff;padding:4px 12px;border-radius:16px;font-size:0.97em;">진행</span>
												</c:if>
												<c:if test="${approval.edmsStatCode eq 'ESC003'}">
													<span class="stat" style="background:#28a745;color:#fff;padding:4px 12px;border-radius:16px;font-size:0.97em;">승인</span>
												</c:if>
												<c:if test="${approval.edmsStatCode eq 'ESC004'}">
													<span class="stat" style="background:#b71c1c;color:#fff;padding:4px 12px;border-radius:16px;font-size:0.97em;">반려</span>
												</c:if>
												<c:if test="${approval.edmsStatCode eq 'ESC005'}">
													<span class="stat" style="background:#ec841a;color:#fff;padding:4px 12px;border-radius:16px;font-size:0.97em;">회수</span>
												</c:if>
												</td>
												<td style="text-align: left">
													<a href="" style="color:#007bff; text-decoration: none;" data-edms-stat-code="${approval.edmsStatCode}" data-edms-no="${approval.edmsNo}">
														<c:if test="${approval.approverCnt eq 1}">
															<span style="color :#bf309a;">(결재)</span>
														</c:if>
														<c:if test="${approval.approverCnt eq 0}">
															<span style="color :#c37c11;">(참조)</span>
														</c:if>
													  ${approval.edmsTitle}
												  	</a>
												  </td>
												<td>${approval.empName}</td>
												<td><fmt:formatDate value="${approval.edmsReqDate}" pattern="yy/MM/dd" type="date" /> </td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr><td colspan="6" style="text-align:center;">검색 결과가 없습니다.</td></tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
						<div class="approval-pagination" id="pagingArea">
							${pagingVO.pagingHTML }
						</div>
					</div>
				</section>
			</main>
		</div>
	</div>
</body>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<script>
$(function(){
	const currentPageEl =  $("#currentPage"); // 현재 페이지 번호
	const searchTypeEl = $("#searchType"); // 정렬 실렉트박스
	const searchWordEl = $("#searchWord"); // 검색어

	// 검색결과 유지한채 상세정보 이동
	let approvalListTbody = $("#approval-list-tbody");
	approvalListTbody.on("click","a",function(e){
		e.preventDefault();
		const edmsNo = $(this).data("edmsNo");
		const edmsStatCode = $(this).data("edmsStatCode");
		let searchWord = "${pagingVO.searchWord}";
		let searchType = "${pagingVO.searchType}";
		let currentPage = "${pagingVO.currentPage}";

		sessionStorage.setItem("baseurl",window.location.pathname);
		sessionStorage.setItem("currentPage",currentPage);
		sessionStorage.setItem("searchWord",searchWord);
		sessionStorage.setItem("searchType",searchType);

		if(edmsStatCode == 'ESC005'){
			location.href="${pageContext.request.contextPath}/emp/edms/update?edmsNo="+edmsNo;
		}else{
			location.href="${pageContext.request.contextPath}/emp/edms/detail?edmsNo="+edmsNo;
		}
	})

	// 페이지 a누르면 이동
	const approvalPagination = $("#approval-pagination");
	const searchForm = $("#searchForm");

	approvalPagination.on("click","a",function(){
		const page = $(this).data("page");
		$("#currentPage").val(page);
		$("#searchWord").val("${pagingVO.searchWord}");
		$("#searchType").val("${pagingVO.searchType}");
		searchForm.submit();
	})

	// 검색입력창 클릭시 입력값 초기화
	$("#searchWord").on("click",function(){
		if($("#searchWord").val() != null && $("#searchWord").val() != ""){
			$("#searchWord").val("");
		}
	})


	$(".edms").on("click",function(){
		let edmsStatCode = $(this).data("statCode");
		$("#edmsStatCode").val(edmsStatCode)
		$("#searchWord").val("");
		$("#searchType").val("title")
		searchForm.submit();
	})
})
    </script>
</html>