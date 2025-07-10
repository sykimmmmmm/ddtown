<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>DDTOWN 굿즈샵 - 공지사항 상세</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/goods_notice.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css" />
    <style type="text/css">
    	.floating-nav {
		    position: fixed;
		    bottom: 100px;
		    right: 24px;
		    z-index: 1000;
		    display: flex;
		    flex-direction: column;
		    gap: 15px;
		}
    </style>
</head>
<body class="notice-detail-page-body">
    <%-- communityHeader.jsp 포함 --%>
    <jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />

    <div class="notice-detail-container">
        <header class="notice-detail-header">
            <h1>공지사항 상세</h1>
        </header>

        <div class="notice-detail-content-wrap">
            <c:choose>
                <c:when test="${not empty notice}">
                    <div class="notice-detail-title">
                        <h2>${notice.goodsNotiTitle}</h2>
                    </div>
                    <div class="notice-detail-info">
                        <span class="date">
                            작성일: <fmt:formatDate value="${notice.goodsRegDate}" pattern="yyyy-MM-dd HH:mm" />
                        </span>
                        <%-- 조회수는 표시하지 않습니다 (goodsNotiHit 필드 제거됨) --%>
                    </div>
                    <div class="notice-detail-body">
                        <%-- 공지사항 내용을 HTML 형식으로 저장했다면 escape="false"를 사용하여 HTML 태그가 그대로 렌더링되도록 합니다. --%>
                        <p>${notice.goodsNotiContent}</p>
                        
                        <%-- 첨부파일이 있다면 표시 (fileDetailList 필드 사용) --%>
                        <c:if test="${not empty notice.fileDetailList}">
                            <div class="notice-detail-attachments">
                                <h3>첨부파일</h3>
                                <ul>
                                    <c:forEach var="file" items="${notice.fileDetailList}">
                                        <li>
                                            <%-- 첨부파일 다운로드 경로 수정 --%>
                                            <a href="${pageContext.request.contextPath}/goods/notice/download/${file.attachDetailNo}">
                                                <i class="fas fa-file-alt"></i> ${file.fileOriginalNm}
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-notice-found">
                        <p>해당 공지사항을 찾을 수 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="notice-detail-actions">
            <a href="${pageContext.request.contextPath}/goods/notice/list" class="notice-btn-list">
                <i class="fas fa-list"></i> 목록으로
            </a>
        </div>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
    <script>
    // CSRF 토큰 및 헤더는 <meta> 태그에서 가져옵니다.
    const csrfToken = document.querySelector('meta[name="_csrf"]').content;
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;
    
    </script>
</body>
</html>