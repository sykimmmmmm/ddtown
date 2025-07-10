<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>새 콘서트 공지사항 등록</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <style> 
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4; }
        .form-container { width: 700px; margin: 20px auto; padding: 30px; border: 1px solid #ddd; border-radius: 8px; background-color: #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: #333; margin-bottom: 30px;}
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: bold; color: #555; }
        .form-group input[type="text"],
        .form-group textarea,
        .form-group input[type="file"] { 
            width: calc(100% - 20px); padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 1em;
        }
        .form-group textarea { resize: vertical; min-height: 200px; } 
        .form-actions { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; text-align: right; }
        .form-actions input, .form-actions a { padding: 10px 20px; margin-left: 10px; border-radius: 5px; text-decoration: none; font-size: 1em; border: none; cursor: pointer;}
        .form-actions input[type="submit"] { background-color: #28a745; color: white; }
        .form-actions a { background-color: #6c757d; color: white; display: inline-block; }
        .message { padding: 15px; margin-bottom: 20px; border-radius: 5px; text-align: center; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>새 콘서트 공지사항 등록</h1>

        <c:if test="${not empty errorMessage}">
            <div class="message error">${errorMessage}</div>
        </c:if>

        <sec:authentication property="principal.employeeVO" var="employeeVO"/>
        <form method="post" action="<c:url value='/concert/notice/insert'/>" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            <div class="form-group">
                <label for="concertNotiTitle">제목:</label>
                <input type="text" id="concertNotiTitle" name="concertNotiTitle" value="<c:out value='${noticeVO.concertNotiTitle}'/>" required>
            </div>

            <div class="form-group">
                <label for="concertNotiContent">내용:</label>
                <textarea id="concertNotiContent" name="concertNotiContent" required><c:out value='${noticeVO.concertNotiContent}'/></textarea>
            </div>
            
            <div class="form-group">
            	<label for="empUsername">작성자:</label>
            	<input type="text" id="empUsername" name="empUsername" value="<c:out value='${noticeVO.empUsername }'></c:out>">
            </div>

            <div class="form-group">
                <label for="noticeFiles">첨부파일 :</label>
                
                <input type="file" id="noticeFiles" name="noticeFiles" multiple="multiple">
            </div>

            <div class="form-actions">
                <a href="<c:url value='/concert/notice/list'/>">목록으로</a>
                <input type="submit" value="등록하기">
            </div>
        </form>
    </div>
   	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
</body>
</html>