<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>APT 공지사항</title>
<style type="text/css">

.notice-content-container {
    white-space: pre-line;
}

.notice-container {
    border: 1px solid aliceblue;
    background-color: white;
    border-radius: 10px;
    margin: 30px;
    padding: 30px;
}

.notice-title-container {
    border-bottom: 1px solid aliceblue;
    margin-bottom: 20px;
    padding-bottom: 20px;
}

span.noticeDate {
    color: #a5adb8;
}

.notice-title-container h3 {
    margin-bottom: 0;
}

.notice-image-container {
    display: flex;
    flex-wrap: wrap;
    border-bottom: 1px solid aliceblue;
    padding-bottom: 20px;
    gap: 20px;
    justify-content: center;
}

.notice-content-container {
    border-bottom: 1px solid aliceblue;
    padding-bottom: 20px;
    margin-bottom: 20px;
    font-size: larger;
}

.notice-image-detail-container {
    max-width: 100%;
    height: 100%;
    flex: 1 1 calc(33% - 20px);
}

.pageMove {
    margin-top: 20pt;
    border-top: 1px solid aliceblue;
    padding-top: 15pt;
    display: flex;
    /* justify-content: center; */
    gap: 300pt;
}

.pageMove a {
    border: 1px solid aliceblue;
    border-radius: 8pt;
    background-color: #8a2be2;
    color: white;
    /* size: 20pt; */
    padding: 5pt;
    transition: transform 0.3s ease;
}

.pageMove a:hover {
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* 마우스 오버 시 더 크고 진한 그림자 */
    transform: translateY(-5px); /* 살짝 위로 떠오르는 효과 (선택 사항) */

}

</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />

	<div class="container">
		<div class="notice-container">
			<div class="notice-title-container">
				<div class='notice-type'>[<c:out value="${noticeVO.codeDescription }" />]</div>
				<h3><c:out value="${noticeVO.comuNotiTitle }" /></h3>
				<span class="noticeDate"><fmt:formatDate value="${noticeVO.comuNotiRegDate }" pattern="MM.dd HH:mm"/></span>
			</div>
			<c:if test="${not empty noticeVO.attachmentFileList}">
				<div class="notice-image-container">
				<c:forEach items="${noticeVO.attachmentFileList }" var="file">
					<c:set value="${file.fileMimeType }" var="mimeType" />
					<c:if test="${fn:contains(mimeType, 'image') }">
						<div class="notice-image-detail-container">
							<img  src="${file.webPath }">
						</div>
					</c:if>
				</c:forEach>
				</div>
			</c:if>
			<div class="notice-content-container">
				<c:out value="${noticeVO.comuNotiContent }" />
			</div>
			<div class="ntoice-files">
				<div class="notice-file-listName">첨부된 파일</div>
				<c:choose>
					<c:when test="${not empty noticeVO.attachmentFileList}">
						<c:forEach items="${noticeVO.attachmentFileList }" var="file">
							<c:set value="${file.fileMimeType }" var="mimeType" />
							<c:if test="${fn:contains(mimeType, 'text') }">
								<div class="notice-file-detail-container">
									<a href="/community/notice/file/download/${file.attachDetailNo }" download="<c:out value='${file.fileOriginalNm}'/>"><c:out value="${file.fileSaveNm }"/></a>
								</div>
							</c:if>
						</c:forEach>
					</c:when>
					<c:otherwise>
							첨부된 파일이 없습니다.
					</c:otherwise>
				</c:choose>
			</div>
			<div class="pageMove">
				<c:if test="${not empty preNoticeNo and preNoticeNo != 0}">
					<a href="/community/notice/post/${preNoticeNo }">이전글</a>
				</c:if>
				<a href="/community/gate/${artistGroupVO.artGroupNo }/apt">커뮤니티로 이동</a>
				<c:if test="${not empty aftNoticeNo and aftNoticeNo != 0}">
					<a href="/community/notice/post/${aftNoticeNo }">다음글</a>
				</c:if>
			</div>

		</div>
	</div>
	<div id="footer">
        <!-- FOOTER -->
        <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
        <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
        <!-- FOOTER END -->
    </div>
</body>
</html>