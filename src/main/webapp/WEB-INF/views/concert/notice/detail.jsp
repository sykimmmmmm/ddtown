<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>콘서트 공지사항 상세</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <%@ include file="../../modules/translation.jsp" %>
    <style> 
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f8f9fa; color: #333; }
        .detail-container { width: 800px; margin: 30px auto; padding: 30px; border: 1px solid #e0e0e0; border-radius: 8px; background-color: #ffffff; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        h1 { text-align: center; color: #2c3e50; margin-bottom: 30px; padding-bottom: 15px; border-bottom: 2px solid #3498db; }
        .detail-info { margin-bottom: 20px; padding-bottom:15px; border-bottom:1px solid #eee; font-size:0.9em; color:#555; display:flex; justify-content:space-between;}
        .detail-content { margin-top: 20px; margin-bottom: 30px; line-height: 1.8; min-height: 150px; padding:15px; background-color:#fdfdfd; border:1px solid #f0f0f0; border-radius:4px;}
        .detail-content pre { white-space: pre-wrap; word-wrap: break-word; font-family: inherit; font-size:1em; }
        .attachment-section { margin-top:20px; padding-top:15px; border-top:1px solid #eee;}
        .attachment-list { list-style-type: none; padding-left: 0; margin-top: 10px; }
        .attachment-list li { margin-bottom: 10px; padding: 8px; background-color: #f9f9f9; border: 1px solid #eee; border-radius: 4px; display: flex; align-items: center; }
        .attachment-list img.file-preview { max-width: 200px; max-height: 200px; object-fit: contain; border: 1px solid #ddd; margin-right: 10px; border-radius: 3px;}
        .attachment-list a { text-decoration: none; color: #007bff; }
        .actions { margin-top: 30px; padding-top: 20px; border-top: 2px solid #3498db; text-align: right;}
        .actions a, .actions button { padding: 10px 18px; margin-left: 10px; border-radius: 5px; text-decoration: none; font-size: 0.95em; border: none; cursor: pointer;}
        .actions .list-btn { background-color: #6c757d; color: white; }
        .actions .edit-btn { background-color: #ffc107; color: #212529; }
        .actions .delete-btn { background-color: #dc3545; color: white; }
        .message { padding: 15px; margin-bottom: 20px; border-radius: 5px; text-align: center; font-size: 1.05em;}
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="detail-container">
    	<sec:authentication property="principal.username" var="currentLoggedInUsername"/>
        <c:if test="${not empty noticeVO}">
            <h1><c:out value="${noticeVO.concertNotiTitle}"/></h1>

            <div class="detail-info">
            	<span><strong>작성자:</strong>
                    <c:out value="${noticeVO.empUsername}"/>
                </span>
                <span><strong>등록일:</strong> <fmt:formatDate value="${noticeVO.concertRegDate}" pattern="yyyy-MM-dd HH:mm"/></span>
                <c:if test="${noticeVO.concertModDate != null && noticeVO.concertModDate != noticeVO.concertRegDate}">
                    <span><strong>수정일:</strong> <fmt:formatDate value="${noticeVO.concertModDate}" pattern="yyyy-MM-dd HH:mm"/></span>
                </c:if>
            </div>

            <div class="detail-content">
                <pre><c:out value="${noticeVO.concertNotiContent}"/></pre>
            </div>

            <c:if test="${not empty noticeVO.attachmentFileList}">
                <div class="attachment-section">
                    <strong>첨부파일:</strong>
                    <ul class="attachment-list">
                        <c:forEach var="file" items="${noticeVO.attachmentFileList}">
                            <li>
                                <c:choose>
                                    <c:when test="${file.fileMimeType != null && file.fileMimeType.startsWith('image/')}">
                                        <a href="<c:url value='${file.webPath}'/>" target="_blank" title="클릭하여 원본 이미지 보기">
                                            <img src="<c:url value='${file.webPath}'/>" alt="<c:out value='${file.fileOriginalNm}'/>" class="file-preview"/>
                                        </a>
                                        <a href="<c:url value='${file.webPath}'/>" download="${file.fileOriginalNm}">
                                            <c:out value="${file.fileOriginalNm}"/> (<c:out value="${file.fileFancysize}"/>) - 다운로드
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value='${file.webPath}'/>" download="${file.fileOriginalNm}">
                                            <c:out value="${file.fileOriginalNm}"/> (<c:out value="${file.fileFancysize}"/>)
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <div class="actions">
                <a href="<c:url value='/concert/notice/list'/>" class="list-btn">목록으로</a>
                <sec:authorize access="hasAnyRole('ROLE_EMPLOYEE', 'ROLE_ADMIN')">
	                <c:if test="${noticeVO.empUsername == currentLoggedInUsername and pageContext.request.isUserInRole('ROLE_EMPLOYEE') or pageContext.request.isUserInRole('ROLE_ADMIN')}">
	                    <a href="<c:url value='/concert/notice/mod/${noticeVO.concertNotiNo}'/>" class="edit-btn">수정하기</a>
	                    <form action="<c:url value='/concert/notice/delete/${noticeVO.concertNotiNo}'/>" method="post" style="display:inline;">
	                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	                        <button type="submit" class="delete-btn" onclick="return confirm('정말로 이 공지사항을 삭제하시겠습니까?');">삭제하기</button>
	                    </form>
	                </c:if>
            	</sec:authorize>
            </div>

        </c:if>
        <c:if test="${empty noticeVO}">
            <c:if test="${not empty errorMessage}">
                <div class="message error">${errorMessage}</div>
            </c:if>
            <p style="text-align:center; font-size: 1.1em; color: #555;">해당 공지사항 정보를 찾을 수 없습니다.</p>
            <div class="actions" style="text-align:center;">
               <a href="<c:url value='/concert/notice/list'/>" class="list-btn">목록으로</a>
           </div>
       </c:if>
    </div>
   	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
</body>
</html>