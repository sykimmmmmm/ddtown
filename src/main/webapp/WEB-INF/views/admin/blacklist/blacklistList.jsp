<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>블랙리스트 관리 - DDTOWN 관리자</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style >
		.input-group-append {
		    display: flex;
		}

		.status-badge.all-blacks {
		    background-color: #007bff; /* 파란색 - Bootstrap primary color와 유사 */
		    color: #fff; /* 글자색은 흰색 */
		}

		.status-badge.blacklist {
		    background-color: #ffc107; /* 주황색 */
		    color: #343a40; /* 배경색이 밝으므로 글자색을 어둡게 (검정 계열) */
		}

		.status-badge.reason-BRC001 { /* 예: '스팸' 사유 */
		    background-color: #6c757d; /* 회색 - 진한 색으로 */
		    color: #fff; /* 글자색은 흰색 */
		}
		.status-badge.reason-BRC002 { /* 예: '욕설' 사유 */
		    background-color: #17a2b8; /* 청록색 - 진한 색으로 */
		    color: #fff; /* 글자색은 흰색 */
		}
		.status-badge.reason-BRC003 { /* 예: '음란물' 사유 */
		    background-color: #dc3545; /* 빨간색 - 진한 색으로 */
		    color: #fff; /* 글자색은 흰색 */
		}
		.status-badge.reason-BRC004 { /* 예: '기타' 사유 */
		    background-color: #6f42c1; /* 보라색 - 진한 색으로 */
		    color: #fff; /* 글자색은 흰색 */
		}

		/* 만약 모든 reason- 뱃지에 대한 기본 색상을 통일하고 싶다면,
		   또는 특정 BRC 코드가 아닌 다른 사유도 고려한다면 아래와 같이 기본 스타일을 추가할 수 있습니다.
		*/
		.status-badge[class^="reason-"] { /* 'reason-'으로 시작하는 모든 클래스에 적용 */
		    background-color: #7b68ee; /* 기본 보라색 계열 */
		    color: #fff;
		}

		.blacklist-status-badge {
		    display: inline-block;
		    padding: 0.25em 0.6em;
		    font-size: 1em;
		    font-weight: 700;
		    line-height: 1;
		    text-align: center;
		    white-space: nowrap;
		    vertical-align: baseline;
		    border-radius: 12rem;
		    opacity: 0.8;
		}

		/* '비활성' 상태일 때의 스타일 */
		.blacklist-status-badge.status-inactive {
		    color: #fff;
		    background-color: #6c757d; /* 회색 배경 */
		}

		/* '활성' 상태일 때의 스타일 */
		.blacklist-status-badge.status-active {
		    color: #fff;
		    background-color: #dc3545; /* 빨간색 배경 */
		}

		.ea-section-header {
		    display: flex;             /* 자식 요소들을 가로로 나열합니다. */
		    align-items: center;       /* 자식 요소들을 세로 중앙에 정렬합니다. */
		    justify-content: space-between; /* 핵심: 왼쪽과 오른쪽 요소를 양쪽 끝으로 밀어냅니다. */
		    flex-wrap: wrap;           /* 화면이 좁아지면 요소들이 다음 줄로 넘어가도록 허용합니다. */
		    /* 필요하다면 여기에 padding이나 margin을 추가하여 여백을 조절할 수 있습니다. */
		}

		.ea-section-header h2 {
		    margin-right: 20px; /* 제목과 뱃지 컨테이너 사이에 간격을 줍니다. 필요에 따라 조절하세요. */
		    white-space: nowrap; /* 제목이 길어도 줄바꿈되지 않도록 합니다. */
		}

		.header-left-group {
		    display: flex;     /* 이 그룹 내부의 요소들도 가로로 나열합니다. */
		    align-items: center; /* 제목과 뱃지들이 세로 중앙에 오도록 합니다. */
		    flex-wrap: wrap;   /* 뱃지들이 많을 경우 줄바꿈을 허용합니다. */
		    /* 필요에 따라 margin-right를 줘서 오른쪽 그룹과의 최소 간격을 설정할 수 있습니다. */
		}
	</style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
            <main class="emp-content" style="font-size: large;">
            <!-- 네비게이션 바 -->
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">블랙리스트 관리</li>
					</ol>
				</nav>
                <section id="blacklistListSection" class="ea-section active-section" style="font-size: larger;">
                    <div class="ea-section-header">
                    	<div class="header-left-group">
	                        <h2>블랙리스트 회원 관리</h2>
	                        <div class="status-badges-container">
<!-- 뱃지 부분 -->
	                        	<form id="blackFilterForm" method="get" action="/admin/community/blacklist/list">
	                        		<input type="hidden" name="page" value="1">
		                        	<input type="hidden" name="badgeSearchType">
								    <%-- 1. 전체 블랙리스트 인원 현황 --%>
								    <div class="status-badge all-blacks" data-status-code="" style="cursor: pointer;">
								        <span class="label">전체</span>
								        <span class="count">${totalBlakcCount}건</span>
								    </div>
								    <!-- 현재 차단된 블랙리스트 수 -->
								    <div class="status-badge blacklist" data-status-code="Y" style="cursor: pointer;">
								        <span class="label">차단</span>
								        <span class="count">${blacklistCnt}명</span>
								    </div>
								    <%-- 2. 사유별 블랙리스트 인원 뱃지 (동적으로 생성) --%>
								    <c:forEach var="entry" items="${blackReasonCnts}">
									    <div class="status-badge reason-${entry.key}" data-status-code="${entry.key}" style="cursor: pointer;">
									        <span class="label">
									            <c:choose>
									                <c:when test="${entry.key eq 'BRC001'}">스팸</c:when>
									                <c:when test="${entry.key eq 'BRC002'}">욕설</c:when>
									                <c:when test="${entry.key eq 'BRC003'}">음란물</c:when>
									                <c:when test="${entry.key eq 'BRC004'}">기타</c:when>
									                <c:otherwise>${entry.key}</c:otherwise>
									            </c:choose>
									        </span>
									        <span class="count">${entry.value}명</span>
									    </div>
									</c:forEach>
								</form>
						    </div>
					    </div>
<!-- 검색부분 -->
                        <div class="ea-header-actions">
                        	<form class="input-group input-group-sm" method="get" id="searchForm" style="flex-wrap: nowrap; ">
								<input type="hidden" name="page" id="page"/>
								<%-- <select id="searchType" name="searchType" class="ea-filter-select" title="사유 필터">
	                                <option value="all" ${searchType == 'all' ? 'selected' : ''}>전체 유형</option>
	                                <option value="BRC001" ${searchType == 'BRC001' ? 'selected' : ''}>스팸</option>
	                                <option value="BRC002" ${searchType == 'BRC002' ? 'selected' : ''}>욕설</option>
	                                <option value="BRC003" ${searchType == 'BRC003' ? 'selected' : ''}>음란물</option>
	                                <option value="BRC004" ${searchType == 'BRC004' ? 'selected' : ''}>기타</option>
	                            </select>&nbsp; --%>
	                            <select id="searchCode" name="searchCode" class="ea-filter-select" title="상태 필터" style="width:100px;">
	                                <option value="all" ${searchCode == 'all' ? 'selected' : ''}>전체 상태</option>
	                                <option value="Y" ${searchCode == 'Y' ? 'selected' : ''}>차단</option>
	                                <option value="N" ${searchCode == 'N' ? 'selected' : ''}>해제</option>
	                            </select>&nbsp;
                            	<input type="search" class="ea-search-input" name="searchWord" id="blacklistSearchInput" placeholder="회원 검색" style="width:250px;" value="${searchWord }">&nbsp;
                            	<div class="input-group-append">
									<button type="submit" id="memberSearchButton" class="ea-btn primary" style="width:60px; white-space: nowrap;" >검색</button>
									<!-- <button type="button" id="resetSearchButton" class="ea-btn" style="width:70px; margin-left: 5px;">초기화</button> -->
								</div>
                            </form>
                        </div>
                    </div>
<!-- 리스트 부분 -->
                    <table class="ea-table">
                        <thead>
                            <tr>
                                <th class="col-number">번호</th>
                                <th class="col-blacklisted-date">차단 여부</th>
                                <th class="col-userId">회원</th>
                                <th class="col-reason">블랙리스트 사유</th>
                                <th class="col-blacklisted-date">지정일</th>
                                <th class="col-banDate">기간</th>
                                <th class="col-blacklisted-date">담당자</th>
                            </tr>
                        </thead>
                        <tbody id="blacklistTableBody">
                        	<c:forEach items="${blackList }" var="black">
	                        	<tr data-blacklist-id="BL001" data-user-id="troublemaker">
	                                <td>${black.banNo }</td>
 	                                <td>
 	                                	<span class="blacklist-status-badge
	                                		<c:choose>
					                            <c:when test="${black.banActYn eq 'N'}">status-inactive</c:when>
					                            <c:when test="${black.banActYn eq 'Y'}">status-active</c:when>
					                        </c:choose>
	                                	">
		                                	<c:choose>
				                       			<c:when test="${black.banActYn eq 'N'}">해제</c:when>
				                       			<c:when test="${black.banActYn eq 'Y'}">차단</c:when>
				                       		</c:choose>
			                       		</span>
	                                </td>
	                                <td class="col-userId" style="text-align: left;">
	                                	<a href="/admin/community/blacklist/detail?banNo=${black.banNo }" class="member-id-link">${black.memUsername } (${black.peoLastNm}${black.peoFirstNm})</a>
	                                </td>
	                                <td class="col-reason">
	                                	<c:choose>
			                       			<c:when test="${black.banReasonCode eq 'BRC001'}">스팸</c:when>
			                       			<c:when test="${black.banReasonCode eq 'BRC002'}">욕설</c:when>
			                       			<c:when test="${black.banReasonCode eq 'BRC003'}">음란물</c:when>
			                       			<c:when test="${black.banReasonCode eq 'BRC004'}">기타</c:when>
			                       		</c:choose>
	                                </td>
	                                <td>
	                                	<c:set value="${fn:split(black.banRegDate, ' ')}" var="banRegDate"/>
	                                	${banRegDate[0]}</td>
	                                <td>
	                                	<c:set value="${fn:split(black.banStartDate, ' ')}" var="banStartDate"/>
		                       			<c:set value="${fn:split(black.banEndDate, ' ')}" var="banEndDate"/>
		                       				${banStartDate[0]} ~ ${banEndDate[0]}
	                                </td>
	                                <td>${black.empUsername }</td>
	                            </tr>
                        	</c:forEach>
                        	<c:if test="${empty blackList}">
				                <tr>
				                    <td colspan="9">신고 내역이 없습니다.</td>
				                </tr>
				            </c:if>
                        </tbody>
                    </table>
                    <div class="ea-pagination" id="pagingArea">
                    	${pagingVO.pagingHTML }
                    </div>
                    <div style="text-align: right; margin-top: 10px;">
                    	<a class="ea-btn primary" href="/admin/community/blacklist/form" id="accountAddButton"  style="width:90px;"><i class="fas fa-plus"></i> 등록 </a>
					</div>
                </section>
            </main>
        </div>
    </div>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<script>

$(function(){

	let pagingArea = $("#pagingArea");	//페이징 영역
	let searchForm = $("#searchForm");	//검색 Form 태그 Element
	let blackFilterForm = $("#blackFilterForm");	//뱃지 Form Element

	// 페이지네이션 로직
	$(document).on('click', '.page-link', function(e) {
	    e.preventDefault(); // 기본 링크 동작(href="#") 방지

	    var page = $(this).data('page'); // data-page 속성 값 가져오기

	    if (page) { // page 값이 유효한 경우에만 실행
	        $('#page').val(page); // hidden input #page의 값을 설정
	        $('#searchForm').submit(); // 검색 폼 제출
	    }
	});

	/* //초기화 버튼
	$('#resetSearchButton').on('click', function() {
	    // 검색 필드 값 초기화
	    $('#searchType').val('all');   // 신고 유형 '전체 유형'으로
	    $('#searchCode').val('all');   // 처리 상태 '전체 상태'로
	    $('#reportSearchInput').val(''); // 검색어 입력 필드 비움
	    $('#page').val(1);             // 페이지를 1페이지로 초기화

	    // 폼 제출
	    $('#searchForm').submit();
	}); */

	 //뱃지 클릭 이벤트
	 $(".status-badges-container .status-badge").on("click", function(){
		 const statusCode = $(this).data("status-code");
// 		 console.log("선택된 차단 상태/사유 코드:", statusCode);

		 blackFilterForm.find("input[name='badgeSearchType']").val(statusCode);

         $('#searchCode').val('all');   // 처리 상태 '전체 상태'로
         $('#blacklistSearchInput').val(''); // 검색어 입력 필드 비움
         $('#page').val(1);             // 페이지를 1페이지로 초기화

         blackFilterForm.submit(); //제출
	 })
})
</script>
</body>
</html>