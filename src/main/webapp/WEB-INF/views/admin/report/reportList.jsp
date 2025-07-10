<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신고 관리 - DDTOWN 관리자</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/ckeditorInquiry/ckeditor.js"></script>

	<style >
		.input-group-append {
		    display: flex;
		}
		.status-badge.all-reports {
		    background-color: #007bff; /* 파란색 - Bootstrap primary color와 유사 */
		    color: #fff; /* 글자색은 흰색 */
		}
		.status-badge.noReportcnt {
		    background-color: #ffc107; /* 주황색 */
		    color: #343a40; /* 배경색이 밝으므로 글자색을 어둡게 (검정 계열) */
		}

		.status-badge.reason-RRC001 { /* 예: '스팸' 사유 */
		    background-color: #6c757d; /* 회색 - 진한 색으로 */
		    color: #fff; /* 글자색은 흰색 */
		}
		.status-badge.reason-RRC002 { /* 예: '욕설' 사유 */
		    background-color: #17a2b8; /* 청록색 - 진한 색으로 */
		    color: #fff; /* 글자색은 흰색 */
		}
		.status-badge.reason-RRC003 { /* 예: '음란물' 사유 */
		    background-color: #dc3545; /* 빨간색 - 진한 색으로 */
		    color: #fff; /* 글자색은 흰색 */
		}
		.status-badge.reason-RRC004 { /* 예: '기타' 사유 */
		    background-color: #6f42c1; /* 보라색 - 진한 색으로 */
		    color: #fff; /* 글자색은 흰색 */
		}
		/* 처리상태 색부분 */
		.report-status-badge {
		    display: inline-block; /* 인라인 요소처럼 배치하되, width/height, padding, margin 등을 적용할 수 있도록 합니다. */
		    padding: 0.5em 0.6em; /* 뱃지 안쪽 여백을 설정합니다.  em은 글자 크기에 비례하는 단위입니다. */
		    border-radius: 12em;      /* 뱃지의 모서리를 둥글게 만듭니다. */
		    font-size: 0.9em;         /* 뱃지 안 글자 크기를 설정합니다. */
		    font-weight: bold;        /* 글자를 굵게 만듭니다. */
		    text-align: center;       /* 글자를 가운데 정렬합니다. */
		    white-space: nowrap;      /* 텍스트가 줄바꿈되지 않도록 합니다. */
		    color: #fff;             /* 기본 글자색은 흰색으로 설정합니다. */


		}

		/* '접수됨' 상태 스타일 */
		.report-status-badge.status-received {
		    background-color: #007bff; /* 파란색 */
		    color: #fff;
		}

		/* '처리 완료' 상태 스타일 */
		.report-status-badge.status-completed {
		    background-color: #28a745; /* 초록색 */
		    color: #fff;
		}
		.ea-section-header {
		    display: flex;             /* 자식 요소들을 가로로 나열합니다. */
		    align-items: center;       /* 자식 요소들을 세로 중앙에 정렬합니다. */
		    justify-content: space-between; /* 가장 중요! 왼쪽 그룹과 오른쪽 그룹을 양쪽 끝으로 밀어냅니다. */
		    flex-wrap: wrap;           /* 화면이 좁아지면 요소들이 다음 줄로 넘어가도록 허용합니다. */
		    font-size: large;
		}

		.ea-section-header h2 {
		    margin-right: 20px; /* "신고 관리" 제목과 뱃지 컨테이너 사이에 간격을 줍니다. (필요에 따라 조절) */
		    white-space: nowrap; /* 제목이 줄바꿈되지 않도록 합니다. */
		}

		/* 새로 추가된 왼쪽 그룹 (제목 + 뱃지들) */
		.header-left-group {
		    display: flex;     /* 이 그룹 내부의 요소들도 가로로 나열합니다. */
		    align-items: center; /* 제목과 뱃지들이 세로 중앙에 오도록 합니다. */
		    flex-wrap: wrap;   /* 뱃지들이 많을 경우 줄바꿈을 허용합니다. */
		    /* 필요에 따라 margin-right를 줘서 오른쪽 그룹과의 최소 간격을 설정할 수 있습니다. */
		}

		.ea-header-actions {
		    display: flex;     /* 이 그룹 내부의 요소들 (드롭박스, 검색창, 버튼)을 가로로 나열합니다. */
		    align-items: center; /* 요소들을 세로 중앙에 정렬합니다. */
		    gap: 10px;         /* 드롭박스와 검색 입력 필드 사이에 간격을 줍니다. */
		    flex-wrap: wrap;   /* 반응형을 위해 추가. */
		}
	</style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
            <main class="emp-content" style="font-size: large;">
            <!-- 1. 네비게이션 바 -->
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">신고 관리</li>
					</ol>
				</nav>

                <section id="reportListSection" class="ea-section active-section">
                    <div class="ea-section-header">
                    	<div class="header-left-group">
	                        <h2>신고 관리</h2>
	                        <div class="status-badges-container">
								<%-- 2. 사유별 신고 인원 뱃지 --%>
	                        	<form id="reportFilterForm" method="get" action="/admin/community/report/list">
		                        	<input type="hidden" name="page" value="1">
		                        	<input type="hidden" name="badgeSearchType">
		                        	<div class="status-badge all-reports" data-status-code="" style="cursor: pointer;">
								        <span class="label">전체</span>
								        <span class="count">${totalReportCount}건</span>
								    </div>
			                        <div class="status-badge noReportcnt" data-status-code="RSC001" style="cursor: pointer;">
								        <span class="label">미처리</span>
								        <span class="count">${reportCnt}명</span>
								    </div>
								    <c:forEach var="entry" items="${reportReasonCnt}">
									    <div class="status-badge reason-${entry.key}" data-status-code="${entry.key}" style="cursor: pointer;">
									        <span class="label">
									            <c:choose>
									                <c:when test="${entry.key eq 'RRC001'}">스팸</c:when>
									                <c:when test="${entry.key eq 'RRC002'}">욕설</c:when>
									                <c:when test="${entry.key eq 'RRC003'}">음란물</c:when>
									                <c:when test="${entry.key eq 'RRC004'}">기타</c:when>
									                <c:otherwise>${entry.key}</c:otherwise>
									            </c:choose>
									        </span>
									        <span class="count">${entry.value}명</span>
									    </div>
									</c:forEach>
								</form>
	     					</div>
     					</div>
						<!-- 3. 신고검색부분 -->
                        <div class="ea-header-actions">
	                         <form class="input-group input-group-sm" method="get" id="searchForm" style="flex-wrap: nowrap; ">
								<input type="hidden" name="page" id="page"/>
								<select id="searchType" name="searchType" class="ea-filter-select" title="검ㅅ 필터">
	                                <option value="all" ${searchType == 'all' ? 'selected' : ''}>전체 유형</option>
	                                <option value="targetMemUsername" ${searchType == 'targetMemUsername' ? 'selected' : ''}>신고대상</option>
	                                <option value="memUsername" ${searchType == 'memUsername' ? 'selected' : ''}>신고자</option>
	                            </select>&nbsp;
<%-- 	                             <select id="searchType" name="searchType" class="ea-filter-select" title="신고 유형 필터">
	                                <option value="all" ${searchType == 'all' ? 'selected' : ''}>전체 유형</option>
	                                <option value="RTTC001" ${searchType == 'RTTC001' ? 'selected' : ''}>게시물</option>
	                                <option value="RTTC002" ${searchType == 'RTTC002' ? 'selected' : ''}>댓글</option>
	                                <option value="RTTC003" ${searchType == 'RTTC003' ? 'selected' : ''}>채팅</option>
	                            </select>&nbsp; --%>
<%-- 	                            <select id="searchCode" name="searchCode" class="ea-filter-select" title="처리 상태 필터">
	                                <option value="all" ${searchCode == 'all' ? 'selected' : ''}>전체 상태</option>
	                                <option value="RSC001" ${searchCode == 'RSC001' ? 'selected' : ''}>접수됨</option>
	                                <option value="RSC002" ${searchCode == 'RSC002' ? 'selected' : ''}>처리완료</option>
	                            </select>&nbsp;  --%>
	                            <input type="search" class="ea-search-input" name="searchWord" id="reportSearchInput" placeholder="신고 대상, 신고자 검색" style="width:250px;"  value="${searchWord}">&nbsp;
								<div class="input-group-append">
									<button type="submit" id="memberSearchButton" class="ea-btn primary" style="width:60px; white-space: nowrap;" >검색</button>
									<!-- <button type="button" id="resetSearchButton" class="ea-btn" style="width:70px; margin-left: 5px;">초기화</button> -->
								</div>
							</form>
                        </div>
                    </div>
					<!-- 4. 신고 목록 부분 -->
                    <table class="ea-table" style="font-size: large;">
                        <thead>
                            <tr style="white-space: nowrap;">
                                <th class="col-report-id">신고번호</th>
                                <th class="col-status">처리상태</th>
                                <th class="col-report-typeNo">게시글 번호</th>
                                <th class="col-report-type">신고유형</th>
                                <th class="col-reported-writer">신고대상</th>
                                <th class="col-reason">신고 사유</th>
                                <th class="col-reporter">신고자</th>
                                <th class="col-report-date">신고일</th>
                                <th class="col-status">동일 신고 수</th>
                            </tr>
                        </thead>
                        <tbody id="reportTableBody">
                       		<c:forEach items="${reportList}" var="report">
                        		<tr data-report-id="RPT001">
	                                <td>${report.reportNo }</td>
	                                <td>
	                                	 <span class="report-status-badge new
									        <c:choose>
									            <c:when test="${report.reportStatCode eq 'RSC001'}">status-received</c:when>
									            <c:when test="${report.reportStatCode eq 'RSC002'}">status-completed</c:when>
									        </c:choose>
									    ">
		                                	<c:choose>
		                                			<c:when test="${report.reportStatCode eq 'RSC001'}">접수됨</c:when>
					                       			<c:when test="${report.reportStatCode eq 'RSC002'}">처리 완료</c:when>
		                                	</c:choose>
	                                	</span>
	                                </td>
	                                <td>${report.targetComuPostNo }</td>
	                                <td>
	                                	<c:choose>
	                                			<c:when test="${report.reportTargetTypeCode eq 'RTTC001'}">게시글</c:when>
				                       			<c:when test="${report.reportTargetTypeCode eq 'RTTC002'}">댓글</c:when>
				                       			<c:when test="${report.reportTargetTypeCode eq 'RTTC003'}">채팅</c:when>
	                                	</c:choose>
	                                </td>
	                                <td class="col-reported-writer" style="text-align: left;">
	                                	<a href="/admin/community/report/detail?reportNo=${report.reportNo }">
	                                		${report.targetMemUsername} (${report.peoLastNm}${report.peoFirstNm})
	                                	</a>
	                                </td>
	                                <td class="col-reason">
	                                	<c:choose>
	                                			<c:when test="${report.reportReasonCode eq 'RRC001'}">스팸</c:when>
				                       			<c:when test="${report.reportReasonCode eq 'RRC002'}">욕설</c:when>
				                       			<c:when test="${report.reportReasonCode eq 'RRC003'}">음란물</c:when>
				                       			<c:when test="${report.reportReasonCode eq 'RRC004'}">기타</c:when>
	                                	</c:choose>
	                                </td>
	                                <td style="text-align: left;">${report.memUsername}</td>
	                                <td style="white-space: nowrap;">
	                                	<c:set value="${fn:split(report.reportRegDate, ' ')}" var="reportRegDate"/>
	                                	${reportRegDate[0]}
	                                </td>
	                                <td>${report.reportedCount}</td>
                            	</tr>
                       		</c:forEach>
                       		<c:if test="${empty reportList}">
					                <tr>
					                    <td colspan="9">신고 내역이 없습니다.</td>
					                </tr>
					            </c:if>
                        </tbody>
                    </table>
                    <div class="pagination-container" id="pagingArea">
                        ${pagingVO.pagingHTML}
                    </div>
                </section>
            </main>
        </div>
    </div>
<script>
$(function(){

	let pagingArea = $("#pagingArea");	//페이징 영역
	let searchForm = $("#searchForm");	//검색 Form 태그 Element
	let reportFilterForm = $("#reportFilterForm");	//뱃지 Form Element

   	 // 페이지네이션 로직
	 $(document).on('click', '.page-link', function(e) {
	     e.preventDefault(); // 기본 링크 동작(href="#") 방지

	     var page = $(this).data('page'); // data-page 속성 값 가져오기

	     if (page) { // page 값이 유효한 경우에만 실행
	         $('#page').val(page); // hidden input #page의 값을 설정
	         $('#searchForm').submit(); // 검색 폼 제출
	     }
	 });
/* 	 $('#resetSearchButton').on('click', function() {
	        // 검색 필드 값 초기화
	        $('#searchType').val('all');   // 신고 유형 '전체 유형'으로
	        $('#searchCode').val('all');   // 처리 상태 '전체 상태'로
	        $('#reportSearchInput').val(''); // 검색어 입력 필드 비움
	        $('#page').val(1);             // 페이지를 1페이지로 초기화

	        // 폼 제출
	        $('#searchForm').submit();
	    }); */

	 /* 뱃지 클릭 이벤트 */
	 $(".status-badges-container .status-badge").on("click", function(){
	     const statusCode = $(this).data("status-code");

	     reportFilterForm.find("input[name='badgeSearchType']").val(statusCode); // 값 설정

	     // 기존 검색 필드 초기화 (폼 내부에 hidden input으로 추가해두었으므로, 값만 초기화)
	     $('#searchType').val('all');   // 신고 유형 '전체 유형'으로
	     $('#searchCode').val('all');   // 처리 상태 '전체 상태'로
	     $('#reportSearchInput').val(''); // 검색어 입력 필드 비움
	     $('#page').val(1);             // 페이지를 1페이지로 초기화

	     reportFilterForm.submit(); // 폼 제출
	 });
})
</script>
</body>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
</html>