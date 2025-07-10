<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.fmt"  prefix="fmt"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>콘서트 일정 상세정보</title>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<%@ include file="../../modules/translation.jsp" %>
<style>
	body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f8f9fa; color: #333; }
	.detail-container {
	    width: 800px;
	    margin: 30px auto;
	    padding: 30px;
	    border: 1px solid #e0e0e0;
	    border-radius: 8px;
	    background-color: #ffffff;
	    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
	}
	h1 {
	    text-align: center;
	    color: #2c3e50;
	    margin-bottom: 30px;
	    padding-bottom: 15px;
	    border-bottom: 2px solid #3498db;
	}
	.detail-section {
	    margin-bottom: 25px;
	    padding-bottom: 20px;
	    border-bottom: 1px dashed #eee;
	}
	.detail-section:last-child {
	    border-bottom: none;
	    margin-bottom: 0;
	    padding-bottom: 0;
	}
	.detail-item {
	    margin-bottom: 12px;
	    line-height: 1.7;
	    display: flex;
	    flex-wrap: wrap;
	}
	.detail-item strong {
	    display: inline-block;
	    width: 180px; /* 레이블 너비 고정 */
	    font-weight: 600;
	    color: #555;
	    margin-right: 10px;
	}
	.detail-item span {
	    flex-grow: 1;
	    word-break: break-word;
	}
	.detail-item pre { /* CLOB 내용 표시용 */
	    background-color: #f9f9f9;
	    padding: 15px;
	    border-radius: 4px;
	    border: 1px solid #eee;
	    white-space: pre-wrap; /* 줄바꿈 및 공백 유지 */
	    word-wrap: break-word;
	    font-family: Consolas, 'Courier New', monospace;
	    font-size: 0.95em;
	    margin-top: 5px;
	    width: 100%;
	}
	.actions {
	    margin-top: 30px;
	    padding-top: 20px;
	    border-top: 2px solid #3498db;
	    text-align: right;
	}
	.actions a, .actions button {
	    padding: 10px 18px;
	    margin-left: 10px;
	    border-radius: 5px;
	    text-decoration: none;
	    font-size: 0.95em;
	    border: none;
	    cursor: pointer;
	    transition: background-color 0.2s ease-in-out;
	}
	.actions .list-btn { background-color: #6c757d; color: white; }
	.actions .list-btn:hover { background-color: #5a6268; }
	.actions .edit-btn { background-color: #ffc107; color: #212529; }
	.actions .edit-btn:hover { background-color: #e0a800; }
	.actions .delete-btn { background-color: #dc3545; color: white; }
	.actions .delete-btn:hover { background-color: #c82333; }
	.message {
	    padding: 15px;
	    margin-bottom: 20px;
	    border-radius: 5px;
	    text-align: center;
	    font-size: 1.05em;
	}
	.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
	.img-preview { max-width: 300px; max-height: 300px; border: 1px solid #ddd; margin-top: 5px; display: block;}
	.attachment-list { list-style-type: none; padding-left: 0; margin-top: 10px; }
        .attachment-list li { margin-bottom: 10px; padding: 8px; background-color: #f9f9f9; border: 1px solid #eee; border-radius: 4px; display: flex; align-items: center; }
        .attachment-list img.file-preview { /* 추가: 파일 미리보기 이미지 */
            max-width: 150px;
            max-height: 150px;
            object-fit: contain;
            border: 1px solid #ddd;
            margin-right: 10px;
            border-radius: 3px;
        }
        .attachment-list a { text-decoration: none; color: #007bff; }
        .attachment-list a:hover { text-decoration: underline; }
</style>
</head>
<body>
	<div class="detail-container">
        <h1>콘서트 일정 상세 정보</h1>

        <c:if test="${not empty errorMessage}">
            <div class="message error">${errorMessage}</div>
        </c:if>

        <c:if test="${not empty concertVO}">
            <div class="detail-section">
                <div class="detail-item"><strong>콘서트 번호:</strong> <span>${concertVO.concertNo}</span></div>
                <div class="detail-item"><strong>콘서트명:</strong> <span><c:out value="${concertVO.concertNm}"/></span></div>
            </div>

            <div class="detail-section">
                <div class="detail-item"><strong>아티스트 그룹:</strong>
                    <span>
                        <c:out value="${concertVO.artGroupName}"/>
                        <c:if test="${not empty concertVO.artGroupNo}"> (번호: ${concertVO.artGroupNo})</c:if>
                    </span>
                </div>
                <div class="detail-item"><strong>공연장:</strong>
                    <span>
                        <c:out value="${concertVO.concertHallName}"/>
                        <c:if test="${not empty concertVO.concertHallNo}"> (번호: ${concertVO.concertHallNo})</c:if>
                    </span>
                </div>
            </div>

            <div class="detail-section">
                <div class="detail-item"><strong>콘서트 카테고리 코드:</strong> <span>${concertVO.concertCatCode}</span></div>
                <div class="detail-item"><strong>예매 상태 코드:</strong> <span>${concertVO.concertReservationStatCode}</span></div>
                <div class="detail-item"><strong>콘서트 상태 코드:</strong> <span>${concertVO.concertStatCode}</span></div>
            </div>

            <div class="detail-section">
                <div class="detail-item"><strong>포스터 이미지 URL:</strong>
                    <span>
                        <c:out value="${concertVO.concertImg}"/>
                        <c:if test="${not empty concertVO.concertImg}">
                            <br><img src="<c:url value='${concertVO.concertImg}'/>" alt="콘서트 이미지" class="img-preview" onerror="this.style.display='none'"/>
                        </c:if>
                    </span>
                </div>
                <div class="detail-item"><strong>온라인 콘서트 여부:</strong> <span>${concertVO.concertOnlineYn == 'Y' ? 'Yes (온라인)' : 'No (오프라인)'}</span></div>
            </div>

            <div class="detail-section">
                <div class="detail-item"><strong>공연일:</strong> <span><fmt:formatDate value="${concertVO.concertDate}" pattern="yyyy년 MM월 dd일"/></span></div>
                <div class="detail-item"><strong>콘서트 주소:</strong> <span><c:out value="${concertVO.concertAddress}"/></span></div>
                <div class="detail-item"><strong>(예매/이벤트)시작일시:</strong> <span><fmt:formatDate value="${concertVO.concertStartDate}" pattern="yyyy년 MM월 dd일 HH시 mm분"/></span></div>
                <div class="detail-item"><strong>(예매/이벤트)종료일시:</strong> <span><fmt:formatDate value="${concertVO.concertEndDate}" pattern="yyyy년 MM월 dd일 HH시 mm분"/></span></div>
                <div class="detail-item"><strong>진행 시간:</strong> <span>${concertVO.concertRunningTime} 분</span></div>
            </div>

            <div class="detail-section">
                <div class="detail-item"><strong>콘서트 안내사항:</strong></div>
                <pre><c:out value="${concertVO.concertGuide}"/></pre>
            </div>
            
            <c:if test="${not empty concertVO.attachmentFileList}">
            <div class="detail-section">
                <div class="detail-item"><strong>첨부파일:</strong></div>
                <ul class="attachment-list">
                    <c:forEach var="file" items="${concertVO.attachmentFileList}">
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
                <a href="<c:url value='/concert/schedule/list'/>" class="list-btn">목록으로</a>
            	<sec:authorize access="isAuthenticated() and hasRole('ROLE_EMPLOYEE')">
	                <a href="<c:url value='/concert/schedule/mod/${concertVO.concertNo}'/>" class="edit-btn">수정하기</a>
	                <form action="<c:url value='/concert/schedule/delete/${concertVO.concertNo}'/>" method="post" style="display:inline;">
	                	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	                    <button type="submit" class="delete-btn" onclick="return confirm('정말로 이 [${concertVO.concertNm}] 일정을 삭제하시겠습니까?');">삭제하기</button>
	                </form>
                </sec:authorize>
            </div>

        </c:if>
        <c:if test="${empty concertVO and empty errorMessage}">
             <p style="text-align:center; font-size: 1.1em; color: #555;">해당 콘서트 정보를 찾을 수 없습니다.</p>
             <div class="actions" style="text-align:center;">
                <a href="<c:url value='/concert/schedule/list'/>" class="list-btn">목록으로</a>
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