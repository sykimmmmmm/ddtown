<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 전자결재 - 상신 문서함</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/approval_draft_style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
	<style type="text/css">
		body {
		    font-family: 'Noto Sans KR', sans-serif;
		    color: #333;
		    background-color: #f8f9fa; /* 전체 페이지 배경색 */
		}

		a {
		    text-decoration: none;
		    color: inherit; /* 기본 링크 색상 상속 */
		}
		main.emp-content {
		    padding: 25px;
		    box-sizing: border-box;
		}
		.ea-section {
		    background-color: #ffffff;
		    padding: 30px;
		    border-radius: 8px;
		    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
		    border: 1px solid #e0e0e0;
		    overflow-x: auto; /* Enable horizontal scrolling for narrow screens */
		    font-size: medium;
		}

		.ea-section-header {
		    margin-bottom: 25px;
		    padding-bottom: 15px;
		    border-bottom: 1px solid #eee;
		    display: flex;
		    justify-content: space-between; /* Space out title and search bar */
		    align-items: center;
		    flex-wrap: wrap; /* Allow wrapping on smaller screens */
		    gap: 15px; /* Gap between header elements */
		}

		.ea-section-header h2 {
		    font-size: 1.8em;
		    font-weight: 700;
		    color: #234aad; /* Main title color */
		    margin-bottom: 0;
		    padding-bottom: 5px;
		    display: inline-block;
		}
		.ea-header-actions {
		    display: flex;
		    gap: 10px; /* Gap between search elements */
		    justify-content: flex-end; /* Align to the right */
		    align-items: center;
		    flex-wrap: wrap; /* Allow wrapping of search elements */
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
		    min-width: 78px; /* Ensure inputs have a minimum width */
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
		    overflow: hidden; /* Ensures borders/shadows respect radius */
		}

		.approval-list-table {
		    width: 100%;
		    border-collapse: collapse; /* Remove default cell spacing */
		    font-size: 0.95em;
		    table-layout: fixed; /* Fixed column width */
		    min-width: 700px; /* Minimum width to prevent squishing on small screens */
		}

		.approval-list-table thead th {
		    background-color: #f0f5ff; /* Header background color */
		    color: #234aad; /* Header text color */
		    font-weight: 600;
		    padding: 12px 15px;
		    text-align: center; /* Center align all header text */
		    border-bottom: 1px solid #dddddd;
		    white-space: nowrap; /* Prevent header text from wrapping */
		}

		.approval-list-table tbody td {
		    padding: 10px 15px;
		    border-bottom: 1px solid #eeeeee; /* Light border between rows */
		    color: #555555;
		    vertical-align: middle;
		    word-break: break-word; /* Allow long words to break */
		}

		/* Zebra striping for table rows */
		.approval-list-table tbody tr:nth-child(even) {
		    background-color: #fcfdff; /* Lighter background for even rows */
		}

		/* Hover effect for table rows */
		.approval-list-table tbody tr:hover {
		    background-color: #e9f7ff; /* Light blue on hover */
		    cursor: pointer;
		}

		.approval-list-table tbody tr:last-child td {
		    border-bottom: none; /* No border for the last row */
		}

		/* Specific Column Alignments for tbody cells */
		.approval-list-table tbody td:nth-child(1) { /* 번호 (Number) */
		    width: 8%; /* Adjust width as needed */
		    text-align: center;
		}
		.approval-list-table tbody td:nth-child(2) { /* 제목 (Title) */
		    width: 40%; /* More width for title */
		    text-align: left; /* Left align for titles */
		    font-weight: 500;
		}
		.approval-list-table tbody td:nth-child(3) { /* 기안자 (Drafter) */
		    width: 15%;
		    text-align: center;
		}
		.approval-list-table tbody td:nth-child(4) { /* 기안일 (Draft Date) */
		    width: 17%;
		    text-align: center;
		}
		.approval-list-table tbody td:nth-child(5) { /* 결재상태 (Approval Status) */
		    width: 20%;
		    text-align: center;
		}

		/* Table Title Link Style */
		.approval-list-table tbody td a {
		    color: #007bff; /* Blue link color */
		    text-decoration: none;
		    transition: color 0.2s ease, text-decoration 0.2s ease;
		}
		.approval-list-table tbody td a:hover {
		    color: #0056b3; /* Darker blue on hover */
		    text-decoration: underline;
		}

		/* ---------------------------------- */
		/* Approval Status Badges (Table Internal) */
		/* ---------------------------------- */
		.approval-list-table tbody span {
		    display: inline-block;
		    padding: 5px 12px; /* Increased padding */
		    border-radius: 20px; /* More rounded corners */
		    font-size: 0.85em; /* Slightly smaller font for badges */
		    font-weight: 600;
		    color: #fff;
		    white-space: nowrap;
		    line-height: 1; /* Adjust line height for better vertical alignment */
		    box-shadow: 0 1px 3px rgba(0,0,0,0.1); /* Subtle shadow for depth */
		}

		/* Fallback for empty table */
		.approval-list-table tbody tr td[colspan="6"] {
		    text-align: center;
		    padding: 40px 15px;
		    color: #777;
		    font-style: italic;
		    background-color: #fefefe;
		}
		.edms{
			cursor : pointer;
		}
		.status-badge.total{
			background-color: #007bff;
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
		.status-badge.withdraw{
			background-color: #ffc107;
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
					  <li class="breadcrumb-item"><a href="#" style="color:black;">전자결재</a></li>
					  <li class="breadcrumb-item active" aria-current="page">상신 문서함</li>
					</ol>
				</nav>
				<section class="ea-section">

					<div class="ea-section-header">
						<div class="d-flex gap-3 align-items-center">
							<h2>상신 문서함</h2>
							<div>
								<span class="status-badge total edms" data-stat-code="all">전체 ${summaryMap.TOTALCNT} 건</span>
		                        <span class="status-badge approve edms" data-stat-code="ESC003">승인 ${summaryMap.APPROVECNT}  건</span>
		                        <span class="status-badge reject edms" data-stat-code="ESC004">반려 ${summaryMap.REJECTCNT} 건</span>
		                        <span class="status-badge prog edms" data-stat-code="ESC002">진행 ${summaryMap.PROGCNT} 건</span>
		                        <span class="status-badge withdraw edms" data-stat-code="ESC005">회수 ${summaryMap.WITHDRAWCNT} 건</span>
		                        <span class="status-badge pend edms" data-stat-code="ESC001">대기 ${summaryMap.PENDCNT} 건</span>
							</div>
						</div>

						<div class="approval-list-search-row ea-header-actions" style="display:flex; gap:8px; justify-content: flex-end; align-items: center;">
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
									<th>번호</th>
									<th>제목</th>
									<th>기안자</th>
									<th>기안일</th>
									<th>결재상태</th>
								</tr>
							</thead>
							<tbody id="approval-list-tbody">
								<c:choose>
									<c:when test="${pagingVO.dataList ne null and pagingVO.dataList[0].edmsNo ne 0}">
										<c:forEach items="${pagingVO.dataList}" var="approval">
											<tr>
												<td>${approval.edmsManageNo}</td>
												<td style="text-align: left"><a href="" style="color:#007bff; text-decoration: none;" data-edms-stat-code="${approval.edmsStatCode}" data-edms-no="${approval.edmsNo}"> ${approval.edmsTitle}</a></td>
												<td>${approval.empName}</td>
												<td><fmt:formatDate value="${approval.edmsReqDate}" pattern="yyyy/MM/dd" type="date" /> </td>
												<td>
												<c:if test="${approval.edmsStatCode eq 'ESC001'}">
													<span style="background:#818681;color:#fff;padding:4px 12px;border-radius:16px;font-size:0.97em;">대기</span>
												</c:if>
												<c:if test="${approval.edmsStatCode eq 'ESC002'}">
													<span style="background:#4caf50;color:#fff;padding:4px 12px;border-radius:16px;font-size:0.97em;">진행</span>
												</c:if>
												<c:if test="${approval.edmsStatCode eq 'ESC003'}">
													<span style="background:#007bff;color:#fff;padding:4px 12px;border-radius:16px;font-size:0.97em;">승인</span>
												</c:if>
												<c:if test="${approval.edmsStatCode eq 'ESC004'}">
													<span style="background:#b71c1c;color:#fff;padding:4px 12px;border-radius:16px;font-size:0.97em;">반려</span>
												</c:if>
												<c:if test="${approval.edmsStatCode eq 'ESC005'}">
													<span style="background:#ec841a;color:#fff;padding:4px 12px;border-radius:16px;font-size:0.97em;">회수</span>
												</c:if>
												</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr><td colspan="6" style="text-align:center;">검색 결과가 없습니다.</td></tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
						<div class="d-flex justify-content-center align-items-center">
							<div class="approval-pagination" id="pagingArea" style="margin-left:auto;">
								${pagingVO.pagingHTML }
							</div>
							<div style="margin-top:18px; margin-left : auto;">
								<a class="ea-btn btn-primary" href="${pageContext.request.contextPath}/emp/edms/approvalDraft" style="background-color: #234aad"><i class="fas fa-plus"></i> 등록</a>
							</div>
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

		sessionStorage.setItem("baseurl",window.location.pathname);//타켓 url
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