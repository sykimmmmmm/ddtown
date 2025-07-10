<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시물 관리 - DDTOWN 직원 포털</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" ></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .post-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; background: #fff; }
        .post-table th, .post-table td { border: 1px solid #e0e0e0; padding: 12px 10px; text-align: center; font-size: 1em; }
        .post-table th { background: #f5f5f5; font-weight: 600; }
        .post-table td.content { text-align: left; }
        .post-table td .detail-btn { padding: 6px 18px; border: 1.5px solid #1976d2; background: #fff; color: #1976d2; border-radius: 6px; font-size: 1em; cursor: pointer; transition: background 0.2s, color 0.2s; }
        .post-table td .detail-btn:hover { background: #1976d2; color: #fff; }
        main.emp-content h2 {
        	font-size: 1.7em;
		    font-weight: 700;
		    color: #234aad;
		    display: flex;
		    align-items: center;
		    gap: 10px;
	    }
    /* 검색 영역 스타일 */
    .search-container {
        background: #fff;
        padding: 25px; /* 내부 패딩 조정 */
        border-radius: 10px; /* 둥근 모서리 */
        box-shadow: 0 5px 15px rgba(0,0,0,0.08); /* 부드러운 그림자 */
        margin-bottom: 30px; /* 테이블과의 간격 확보 */
    }
    .search-row {
        display: flex;
        align-items: center;
        gap: 15px; /* 요소들 간 간격 조정 */
        flex-wrap: wrap; /* 작은 화면에서 요소들이 줄바꿈되도록 */
    }
    .search-container #searchForm {
        display: flex;
        align-items: center;
        gap: 15px;
        flex-wrap: wrap;
        width: 100%; /* 폼이 컨테이너 너비를 채우도록 */
    }
    .search-container select,
    .search-container input[type="text"] {
        padding: 10px 15px; /* 패딩 조정 */
        border: 1px solid #ced4da; /* 테두리 색상 */
        border-radius: 6px; /* 둥근 모서리 */
        font-size: 1em;
        line-height: 1.5;
        color: #495057;
        flex-grow: 1; /* 입력 필드가 가능한 공간을 채우도록 */
        min-width: 180px; /* 최소 너비 설정 */
        transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }
    .search-container select:focus,
    .search-container input[type="text"]:focus {
        border-color: #80bdff;
        box-shadow: 0 0 0 0.25rem rgba(0, 123, 255, 0.25);
        outline: 0;
    }
    .search-container input[type="text"]::placeholder {
        color: #adb5bd; /* 플레이스홀더 색상 */
    }
    /* 검색 및 초기화 버튼 (ea-btn primary 클래스에 맞춰 재정의) */
    .search-container .ea-btn.primary {
        padding: 10px 22px; /* 패딩 조정 */
        font-size: 1em;
        font-weight: 600;
        border-radius: 6px;
        background-color: #007bff; /* 부트스트랩 primary */
        border-color: #007bff;
        color: #fff;
        cursor: pointer;
        transition: background-color 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    .search-container .ea-btn.primary:hover {
        background-color: #0056b3;
        border-color: #004085;
        box-shadow: 0 3px 8px rgba(0,0,0,0.2);
    }
    /* 테이블 스타일 */
    .post-table {
        border-collapse: separate; /* border-spacing 적용을 위해 */
        border-spacing: 0; /* 셀 경계선이 겹치지 않도록 */
        margin-bottom: 25px; /* 하단 여백 */
        border-radius: 10px; /* 테이블 전체에 둥근 모서리 */
        box-shadow: 0 5px 15px rgba(0,0,0,0.08); /* 테이블 전체에 그림자 */
        overflow: hidden; /* 둥근 모서리를 위해 내용 숨김 */
        background: #fff; /* 배경색 명시 */
    }
    .post-table th, .post-table td {
        border: none; /* 기본 테두리 제거 */
        padding: 15px; /* 패딩 조정 */
        text-align: center;
        vertical-align: middle;
        font-size: 0.95em; /* 폰트 사이즈 살짝 줄임 */
        color: #495057; /* 텍스트 색상 */
    }
    .post-table thead th {
        background: #f0f5ff; /* 헤더 배경색 (FullCalendar 버튼, 라이브 요약 테이블과 유사) */
        color: #234aad; /* 헤더 텍스트 색상 */
        font-weight: 700; /* 더 굵게 */
        border-bottom: 1px solid #d0d8e2; /* 헤더 하단에 구분선 */
    }
    .post-table tbody tr {
        transition: background-color 0.2s ease;
    }
    .post-table tbody tr:nth-child(even) {
        background-color: #f9f9f9; /* 짝수 행 배경색 */
    }
    .post-table tbody tr:hover {
        background-color: #eef7ff; /* 호버 시 배경색 변경 */
    }
    .post-table td {
        border-bottom: 1px solid #e9ecef; /* 셀 하단 구분선 */
    }
    .post-table tbody tr:last-child td {
        border-bottom: none; /* 마지막 행 하단 구분선 제거 */
    }
    /* 내용(content) 컬럼 스타일 */
    .post-table td.content {
        text-align: left; /* 좌측 정렬 유지 */
        max-width: 300px; /* 너무 길어지지 않도록 최대 너비 설정 (선택적) */
        white-space: nowrap; /* 한 줄로 표시 */
        overflow: hidden; /* 넘치는 내용 숨김 */
        text-overflow: ellipsis; /* 넘치는 내용 ...으로 표시 */
    }
    .post-table td.content a {
        color: #007bff; /* 링크 색상 부트스트랩 primary */
        text-decoration: none; /* 기본 밑줄 제거 */
        font-weight: 500;
        display: block; /* 전체 셀 영역을 링크처럼 사용 */
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .post-table td.content a:hover {
        text-decoration: underline; /* 호버 시 밑줄 */
    }
    /* 드롭다운 버튼 (아티스트 선택) */
    .post-table .dropdown .btn-secondary {
        background-color: #6c757d; /* 부트스트랩 secondary */
        border-color: #6c757d;
        color: #fff;
        padding: 8px 15px;
        font-size: 0.9em;
        font-weight: 600;
        border-radius: 6px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        transition: all 0.2s ease;
    }
    .post-table .dropdown .btn-secondary:hover {
        background-color: #5a6268;
        border-color: #545b62;
        box-shadow: 0 3px 8px rgba(0,0,0,0.2);
    }
    .post-table .dropdown-menu {
        border-radius: 8px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        padding: 8px 0; /* 드롭다운 메뉴 내부 패딩 */
    }
    .post-table .dropdown-item {
        font-size: 0.95em;
        padding: 10px 20px; /* 드롭다운 아이템 패딩 */
        color: #343a40;
    }
    .post-table .dropdown-item:hover,
    .post-table .dropdown-item:active {
        background-color: #e9ecef; /* 호버 시 배경색 */
        color: #212529;
    }
    .post-table .dropdown-divider {
        margin: 5px 0; /* 구분선 마진 */
    }
    hr {
	    border: none;
	    border-top: 1px solid currentColor;
	    margin-top: 25px; /* 상단 여백 조정 */
	    margin-bottom: 30px; /* 하단 여백 유지 */
	}
	.postMaintained {
	    border: 1px solid aliceblue;
	    border-radius: 8pt;
	    background-color: #2bdb2b3d;
	    font-weight: 600;
	}
	.postRemoved {
	    border: 1px solid aliceblue;
	    border-radius: 8pt;
	    background-color: #fb00005c;
	    font-weight: 600;
	}

    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
            <main class="emp-content" style="position:relative; min-height:600px; font-size: medium;">
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
						<li class="breadcrumb-item"><a href="#" style="color:black;"> 아티스트 커뮤니티 관리</a></li>
						<li class="breadcrumb-item active" aria-current="page">게시물 관리</li>
					</ol>
				</nav>
                <h2 class="emp-title" style="margin-bottom:18px;">게시물 관리</h2>
                <hr/>
                <!-- 검색 영역 추가 -->
                <div class="search-container" style="background:#fff; padding:20px; border-radius:8px; margin-bottom:20px; box-shadow:0 2px 8px rgba(0,0,0,0.05); display: flex; justify-content: end; ">
                    <div class="search-row" style="display:flex; align-items:center; gap:12px; margin-bottom:12px; width: 400pt;">
                    	<form id="searchForm" action="/emp/post/list" method="get">
	                        <select id="searchType" name="searchType" style="padding:8px 12px; border:1px solid #ddd; border-radius:4px; min-width:150px;">
	                        	<option value="" id="searchAll">전체</option>
	                            <option value="content">내용</option>
	                        </select>

	                        <input type="text" id="searchWord" name="searchWord" value="<c:if test="${not empty pagingVO.searchWord }">${pagingVO.searchWord }</c:if>" placeholder="내용을 입력해주세요" />
	                        <button type="button" class="ea-btn primary" id="searchBtn" ><i class="fas fa-search"></i>검색</button>
<!-- 	                        <button type="button" class="btn btn-primary" id="reset" >검색 초기화</button> -->
                    	</form>
                    </div>
                </div>

                <table class="post-table">
                    <thead>
                        <tr>
                        	<th>순번</th>
                            <th>ID</th>
                            <th>아티스트</th>
                            <th>내용</th>
                            <th>멤버십 여부</th>
                            <th>작성일</th>
                            <th>댓글 수</th>
                            <th>좋아요 수</th>
                            <th>삭제여부</th>
                        </tr>
                    </thead>
                    <tbody>
                    	<c:choose>
                    		<c:when test="${not empty pagingVO.dataList }">
                    			<c:forEach items="${pagingVO.dataList }" var="post">
		                    		<tr>
		                    			<td><c:out value="${post.rnum }" /></td>
			                            <td><c:out value="${post.comuPostNo }" /></td>
			                            <td><c:out value="${post.writerProfile.artistVO.artNm }"/></td>
			                            <td class="content"><a href="/emp/post/detail/${post.comuPostNo }"><c:out value="${post.comuPostContent }"/></a></td>
			                            <td>
				                            <c:if test="${post.comuPostMbspYn eq 'Y' }">
				                            	멤버십 전용
				                            </c:if>
				                            <c:if test="${post.comuPostMbspYn eq 'N' }">
				                            	전체 공개
				                            </c:if>
			                            </td>
			                            <td><fmt:formatDate value="${post.comuPostRegDate }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
			                            <td><c:out value="${post.comuPostReplyCount }" /></td>
			                            <td><c:out value="${post.comuPostLike }" /></td>
			                            <td>
			                            	<c:if test="${post.comuPostDelYn eq 'Y'}">
			                            		<div class="postRemoved">삭제됨</div>
			                            	</c:if>
			                            	<c:if test="${post.comuPostDelYn eq 'N'}">
			                            		<div class="postMaintained">유지중</div>
			                            	</c:if>
			                            </td>
			                        </tr>
		                    	</c:forEach>
                    		</c:when>
                    		<c:otherwise>
                    			<td colspan="9">작성한 게시글이 없습니다.</td>
                    		</c:otherwise>
                    	</c:choose>

                    </tbody>
                </table>
            </main>
        </div>
    </div>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
</body>
<script>

$(function(){
// 	$("#selectArtist").on("hidden.bs.dropdown",function(e){
// 		console.log($(this));
// 		console.log("e: " ,e.clickEvent.target.value);
// 	})

// 	$(".dropdown-menu").on("click","button",function(e){
// 		console.log("e",e.target.value);
// 	});

	$("#searchBtn").on("click",function(){

		if($("#searchWord").val() == null || $("#searchWord").val() == ''){
			alert("검색어를 입력해주세요");
			return false;
		}

		$("#searchForm").submit();
	});

	$("#reset").on("click",function(){
		$("#searchAll").prop("selected",true);
		$("#searchWord").val("");

		$("#searchForm").submit();
	});
});

</script>
</html>