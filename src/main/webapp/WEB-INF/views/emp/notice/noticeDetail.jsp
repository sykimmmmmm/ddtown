 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 공지사항 상세 정보</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <%@ include file="../../modules/headerPart.jsp" %>
<style>
    body {
        font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
        margin: 0;
        background-color: #f4f6f9;
        color: #212529;
    }
    a { text-decoration: none; }
    a:hover { color: #007bff; }
    h4 { font-size: 1.3em; margin-bottom: 18px; color: #234aad; padding-bottom: 10px; border-bottom: 2px solid #234aad; font-weight: 700; }
    /* ---------------------------------- */
    /* 상세 페이지 레이아웃 (`detail.jsp`) */
    /* ---------------------------------- */
    .detail-view-container {
        background: #fff; padding: 30px 35px; border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }
    .detail-header {
        padding-bottom: 20px;
        border-bottom: 1px solid #dee2e6;
        margin-bottom: 25px;
        display: flex; /* Flexbox 추가 */
        justify-content: space-between; /* 양 끝 정렬 */
        align-items: flex-end; /* 아래쪽 정렬 */
        gap: 15px;
    }
    .detail-title-meta-group { 
        flex-basis: auto; /* ⭐수정: 콘텐츠 크기에 맞게 너비 조절⭐ */
        flex-grow: 1; /* ⭐추가: 남은 공간을 차지하여 오른쪽에 버튼을 밀어냄⭐ */
    }
    .detail-header-actions {
    	display: flex;
    	gap: 8px;
    	margin-bottom: 5px;
	}
    .detail-title {
        font-size: 1.8em; font-weight: 600; margin-bottom: 10px; color: #2c3e50;
    }
    .detail-meta {
        font-size: 1em; color: #6c757d; display: flex; align-items: center; gap: 15px; flex-wrap: wrap;
    }
    .detail-meta .divider { color: #e0e0e0; }
    .detail-content {
        min-height: 100px; line-height: 1.8; font-size: 1em; margin-bottom: 30px;
        padding: 20px; white-space: pre-wrap; word-break: keep-all;
        background-color: #f8f9fa; border: 1px solid #e9ecef; border-radius: 5px;
    }
    .detail-info-table { margin-bottom: 30px; }
    .detail-info-table table {
        width: 100%; border-top: 2px solid #333; border-collapse: collapse;
    }
    .detail-info-table th, .detail-info-table td {
        border-bottom: 1px solid #dee2e6; padding: 15px; font-size: 0.95em;
    }
    .detail-info-table th {
        background-color: #f8f9fa; width: 25%; text-align: left; font-weight: 600;
    }
    .detail-attachments { margin-bottom: 30px; }
    .detail-attachments ul { list-style: none; padding: 0; margin: 0; }
    .detail-attachments li {
        display: flex; align-items: center; padding: 12px; border-radius: 5px;
        transition: background-color 0.2s; border: 1px solid #e9ecef;
    }
    .detail-attachments li:not(:last-child) { margin-bottom: 10px; }
    .detail-attachments li:hover { background-color: #f4f6f9; }
    .detail-attachments .file-preview {
        width: 100px; height: 100px; object-fit: cover;
        border-radius: 4px; margin-right: 15px; border: 1px solid #dee2e6;
    }

    /* ---------------------------------- */
    /* 버튼 UI (공통)                   */
    /* ---------------------------------- */
    .actions-container { text-align: right; padding-top: 25px; margin-top: 20px; border-top: 1px solid #e9ecef; display: flex;  justify-content: flex-end; gap: 8px; }
    .actions-container .btn { margin-left: 0; }
    .btn {
        display: inline-block; padding: 10px 20px; font-size: 0.95em; font-weight: 500;
        text-align: center; text-decoration: none; border: none; border-radius: 6px;
        cursor: pointer; transition: all 0.2s ease-in-out;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .btn:hover { transform: translateY(-1px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
    .btn-submit, .btn-primary { background-color: #007bff; color: white; }
    .btn-submit:hover, .btn-primary:hover { background-color: #0056b3; }
    .btn-secondary { background-color: #6c757d; color: white; }
    .btn-secondary:hover { background-color: #5a6268; }
    .btn-danger { background-color: #dc3545; color: white; }
    .btn-danger:hover { background-color: #c82333; }
</style>
</head>
<body>
    <div class="emp-container">
    <%@ include file="../modules/header.jsp" %>
		<div class="emp-body-wrapper">
			<%@ include file="../modules/aside.jsp" %>
			<main class="emp-content" style="position:relative; min-height:600px;">
			<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
			<ol class="breadcrumb">
			  <li class="breadcrumb-item" style="color:black;">아티스트 커뮤니티 관리</li>
			  <li class="breadcrumb-item"><a href="/emp/community/notice/list" style="color:black;">공지사항 관리</a></li>
			  <li class="breadcrumb-item active" aria-current="page">공지사항 상세</li>
			</ol>
			</nav><br/>
                <c:if test="${not empty errorMessage}"><div class="message error">${errorMessage}</div></c:if>

                <c:if test="${not empty noticeVO}">
                    <div class="detail-view-container">
                        <%-- ⭐공지사항 제목과 메타 정보, 그리고 수정/삭제 버튼을 담는 하나의 헤더 영역⭐ --%>
                        <div class="detail-header">
                            <%-- ⭐제목과 작성자/날짜 등의 메타 정보를 묶는 그룹⭐ --%>
                            <div class="detail-title-meta-group">
	                            <h2 class="detail-title"><c:out value="${noticeVO.comuNotiTitle}"/></h2>
	                            <div class="detail-meta">
                                    <span><strong>카테고리:</strong> 
                                        <c:choose>
                                            <c:when test="${noticeVO.comuNotiCatCode == 'CNCC001'}">일반 공지사항</c:when>
                                            <c:when test="${noticeVO.comuNotiCatCode == 'CNCC002'}">콘서트 공지사항</c:when>
                                        </c:choose>
                                    </span>
                                    <span class="divider">|</span>
                                    <span><strong>아티스트: </strong>${noticeVO.artGroupNm}</span>
                                    <span class="divider">|</span>
                                    <span><strong>작성자: </strong>${noticeVO.empUsername}</span>
                                    <span class="divider">|</span>
                                    <span><strong>작성일: </strong> <fmt:formatDate value="${noticeVO.comuNotiRegDate}" pattern="yyyy-MM-dd HH:mm"/></span>
                                </div>
                            </div>

                            <%-- ⭐수정/삭제 버튼 영역 (타이틀 옆에 위치)⭐ --%>
                            <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
                                <div class="detail-header-actions">
                                    <sec:authentication property="principal.username" var="currentUsername"/>
                                    <c:if test="${currentUsername == noticeVO.empUsername or pageContext.request.isUserInRole('ROLE_ADMIN')}">
                                        <c:url var="modUrl" value="/emp/community/notice/mod/${noticeVO.comuNotiNo}">
                                            <c:param name="searchType" value="${pagingVO.searchType}"/>
                                            <c:param name="searchWord" value="${pagingVO.searchWord}"/>
                                            <c:param name="currentPage" value="${pagingVO.currentPage}"/>
                                            <c:param name="artGroupNo" value="${pagingVO.artGroupNo}"/>
                                        </c:url>
                                        <a href="${modUrl}" class="btn btn-primary btn-sm"><i class="fa-solid fa-pen-to-square"></i> 수정</a>
                                        
                                        <form action="<c:url value='/emp/community/notice/delete/${noticeVO.comuNotiNo}'/>" method="post" style="display:inline;" onsubmit="return confirm('정말로 이 공지를 삭제하시겠습니까?');">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <input type="hidden" name="searchType" value="${pagingVO.searchType}">
                                            <input type="hidden" name="searchWord" value="${pagingVO.searchWord}">
                                            <input type="hidden" name="currentPage" value="${pagingVO.currentPage}">
                                            <input type="hidden" name="artGroupNo" value="${pagingVO.artGroupNo}"/>
                                            <button type="submit" class="btn btn-danger btn-sm"><i class="fa-solid fa-trash-can"></i> 삭제</button>
                                        </form>
                                    </c:if>
                                </div>
                            </sec:authorize>
                        </div>

                        <%-- 공지사항 본문 내용 --%>
                        <div class="detail-content"><c:out value="${noticeVO.comuNotiContent}"/></div>

                        <c:if test="${not empty noticeVO.attachmentFileList}">
                            <div class="detail-attachments">
                                <h4>첨부파일</h4>
                                <ul>
                                    <c:forEach var="file" items="${noticeVO.attachmentFileList}">
                                        <li>
                                            <a href="<c:url value='${file.webPath}'/>" target="_blank">
                                                <c:if test="${file.fileMimeType != null && file.fileMimeType.startsWith('image/')}">
                                                    <img src="<c:url value='${file.webPath}'/>" class="file-preview" alt="미리보기"/>
                                                </c:if>
                                            </a>
                                            <a href="<c:url value='${file.webPath}'/>" download="${file.fileOriginalNm}">
                                                <c:out value="${file.fileOriginalNm}"/> (<c:out value="${file.fileFancysize}"/>)
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>
						<div class="actions-container">
                            <c:url var="listUrl" value="/emp/community/notice/list">
                                <c:param name="searchType" value="${pagingVO.searchType}" />
                                <c:param name="searchWord" value="${pagingVO.searchWord}" />
                                <c:param name="currentPage" value="${pagingVO.currentPage}" />
                                <c:param name="artGroupNo" value="${pagingVO.artGroupNo}"/>
                            </c:url>
                            <a href="${listUrl}" class="btn btn-secondary"><i class="fa-solid fa-list"></i> 목록</a>
                        </div>
                    </div>
                </c:if>
			</main>
		</div>
	</div>
	<%@ include file="../../modules/footerPart.jsp" %>
	<%@ include file="../../modules/sidebar.jsp" %>
<script type="text/javascript">

</script>
</body>
</html>