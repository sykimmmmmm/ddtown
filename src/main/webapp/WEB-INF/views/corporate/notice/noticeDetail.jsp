<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DD TOWN - <c:out value="${noticeVO.entNotiTitle}" default="기업 공지 상세"/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;700;900&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Enhanced Notice Detail Styles */
        .notice-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 120px 0 80px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .notice-hero:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
        }
        
        .notice-hero h2 {
            font-size: clamp(3rem, 6vw, 4.5rem);
            font-weight: 900;
            color: white;
            margin-bottom: 20px;
            text-shadow: 0 4px 20px rgba(0,0,0,0.3);
            position: relative;
            z-index: 1;
        }
        
        .notice-hero p {
            font-size: 1.3rem;
            color: rgba(255, 255, 255, 0.9);
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
            position: relative;
            z-index: 1;
        }
        
        .notice-detail {
            padding: 100px 0;
            background: linear-gradient(45deg, #f8f9ff 0%, #f0f2ff 100%);
        }
        
        .notice-header {
        	display: block;
            background: white;
            padding: 40px;
            border-radius: 20px 20px 0 0;
            border-bottom: 1px solid rgba(102, 126, 234, 0.1);
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }
        
        .notice-header h3 {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            line-height: 1.4;
            display: block;
        }
        
        .notice-meta {
            display: block;
            align-items: center;
            gap: 20px;
            color: #666;
            font-size: 1rem;
            margin-top: 10px;
        }
        
        .notice-meta .date {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: linear-gradient(45deg, #f8f9ff 0%, #f0f2ff 100%);
            border-radius: 20px;
            border: 1px solid rgba(102, 126, 234, 0.1);
        }
        
        .notice-meta .date:before {
            content: '\f073';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            color: #667eea;
        }
        
        .notice-content {
            background: white;
            padding: 50px 40px;
            border-radius: 0 0 20px 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            border: 1px solid rgba(102, 126, 234, 0.1);
            border-top: none;
        }
        
        .notice-content-html {
            line-height: 1.8;
            color: #333;
            font-size: 1.1rem;
        }
        
        .notice-content-html p {
            margin-bottom: 1.5em;
        }
        
        .notice-content-html h4 {
            margin-top: 2em;
            margin-bottom: 1em;
            font-size: 1.3em;
            font-weight: 700;
            color: #333;
            padding-bottom: 0.5em;
            border-bottom: 2px solid #667eea;
        }
        
        .notice-content-html ul, .notice-content-html ol {
            margin-left: 30px;
            margin-bottom: 1.5em;
        }
        
        .notice-content-html li {
            margin-bottom: 0.5em;
            position: relative;
        }
        
        .notice-content-html ul li:before {
            content: '\f105';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            color: #667eea;
            position: absolute;
            left: -20px;
        }
        
        .notice-attachments-view {
            background: linear-gradient(45deg, #f8f9ff 0%, #f0f2ff 100%);
            padding: 30px;
            border-radius: 15px;
            margin-top: 40px;
            border: 1px solid rgba(102, 126, 234, 0.1);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }
        
        .notice-attachments-view h4 {
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .notice-attachments-view h4 i {
            color: #667eea;
        }
        
        .notice-attachments-view ul {
            list-style: none;
            padding: 0;
        }
        
        .notice-attachments-view li {
            margin-bottom: 15px;
        }
        
        .notice-attachments-view a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 20px;
            background: white;
            border-radius: 10px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
            border: 1px solid rgba(102, 126, 234, 0.1);
        }
        
        .notice-attachments-view a:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .notice-attachments-view a i {
            color: #667eea;
            font-size: 1.1rem;
        }
        
        .notice-attachments-view a:hover i {
            color: white;
        }
        
        .notice-actions {
            margin-top: 50px;
            text-align: center;
        }
        
        .notice-actions .btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 15px 30px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            border: 2px solid #667eea;
            transition: all 0.3s ease;
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.2);
        }
        
        .notice-actions .btn:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }
        
        .no-data {
            text-align: center;
            padding: 100px 20px;
            color: #666;
            font-size: 1.2rem;
        }
        
        .no-data:before {
            content: '\f119';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            font-size: 4rem;
            color: #ddd;
            display: block;
            margin-bottom: 30px;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .notice-header, .notice-content {
                padding: 25px;
            }
            
            .notice-header h3 {
                font-size: 1.5rem;
            }
            
            .notice-content-html {
                font-size: 1rem;
            }
            
            .notice-attachments-view {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
	<%@ include file="../modules/header.jsp" %>
	
    <main>
        <section class="notice-hero">
            <div class="container">
                <h2>기업 공지</h2>
                <p>DD TOWN의 최신 소식과 공지사항을 확인하실 수 있습니다.</p>
            </div>
        </section>

        <section class="notice-detail">
            <div class="container">
                <c:choose>
                    <c:when test="${not empty noticeVO}">
                        <div class="notice-header">
                            <h3><c:out value="${noticeVO.entNotiTitle}"/></h3>
                            <div class="notice-meta">
                                <span class="date">작성일: <fmt:formatDate value="${noticeVO.entNotiRegDate}" pattern="yyyy-MM-dd HH:mm"/></span>
                            </div>
                        </div>

                        <div class="notice-content notice-content-html">
                            ${noticeVO.entNotiContent}
                        </div>
                        
                        <c:if test="${not empty noticeVO.attachmentList}">
                            <div class="notice-attachments-view">
                                <h4><i class="fas fa-paperclip"></i> 첨부파일</h4>
                                <ul>
                                    <c:forEach var="file" items="${noticeVO.attachmentList}">
                                        <li>
                                            <a href="${pageContext.request.contextPath}/corporate/file/download/${file.attachDetailNo}"
                                            download="<c:out value='${file.fileOriginalNm}'/>">
                                                <i class="fas fa-file-download"></i> 
                                                <span><c:out value="${file.fileOriginalNm}"/> (<c:out value="${file.fileFancysize}" />)</span>
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>

                        <div class="notice-actions">
                            <a href="${pageContext.request.contextPath}/corporate/notice/list" class="btn btn-secondary">
                                <i class="fas fa-list"></i> 목록
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="no-data">요청하신 공지사항을 찾을 수 없습니다.</p>
                         <div class="notice-actions">
                            <a href="${pageContext.request.contextPath}/corporate/notice/list" class="btn btn-secondary">
                                <i class="fas fa-list"></i> 목록으로
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>

    <%@ include file="../modules/footer.jsp" %>

    <script src="${pageContext.request.contextPath}/resources/js/common/main.js"></script>
</body>
</html>