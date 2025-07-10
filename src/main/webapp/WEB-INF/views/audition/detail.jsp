<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DD TOWN 오디션 상세보기</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;700;900&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <%@ include file="../modules/headerPart.jsp" %>
    <style>
        /* Enhanced Audition Detail Styles */
        body {
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            font-family: 'Noto Sans KR', 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
        }
        
        .audition-detail-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 120px 0 80px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .audition-detail-hero:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
        }
        
        .audition-detail-hero h2 {
            font-size: clamp(3rem, 6vw, 4.5rem);
            font-weight: 900;
            color: white;
            margin: 0;
            text-shadow: 0 4px 20px rgba(0,0,0,0.3);
            position: relative;
            z-index: 1;
        }
        
        .audition-detail-section {
            padding: 100px 0;
            position: relative;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .audition-detail-header {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.1);
            border: 1px solid rgba(102, 126, 234, 0.1);
            position: relative;
            overflow: hidden;
        }
        
        .audition-detail-header:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .audition-status {
            display: inline-block;
            padding: 12px 24px;
            border-radius: 25px;
            font-weight: 700;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .audition-status.recruiting.status-scheduled {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
        }
        
        .audition-status.recruiting.status-in-progress {
            background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%);
            color: white;
        }
        
        .audition-status.recruiting.status-closed {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        
        .audition-detail-title {
            font-size: 2.5rem;
            font-weight: 800;
            color: #333;
            margin: 0;
            line-height: 1.2;
        }
        
        .audition-detail-meta {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.1);
            border: 1px solid rgba(102, 126, 234, 0.1);
            list-style: none;
            margin-left: 0;
            padding-left: 40px;
        }
        
        .audition-detail-meta li {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid rgba(102, 126, 234, 0.1);
            font-size: 1.1rem;
        }
        
        .audition-detail-meta li:last-child {
            border-bottom: none;
        }
        
        .audition-detail-meta li strong {
            color: #667eea;
            font-weight: 600;
            min-width: 150px;
            margin-right: 20px;
        }
        
        .audition-detail-meta li strong:before {
            content: '';
            display: inline-block;
            width: 6px;
            height: 6px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            margin-right: 10px;
        }
        
        .audition-detail-content,
        .audition-detail-attachments {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.1);
            border: 1px solid rgba(102, 126, 234, 0.1);
        }
        
        .audition-detail-content h4,
        .audition-detail-attachments h4 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(102, 126, 234, 0.1);
            position: relative;
        }
        
        .audition-detail-content h4:before,
        .audition-detail-attachments h4:before {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 60px;
            height: 2px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .audition-detail-content p {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #555;
            margin: 0;
        }
        
        .audition-detail-attachments ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .audition-detail-attachments li {
            margin-bottom: 20px;
        }
        
        .attachment-link,
        .attachment-link-download {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            padding: 15px 20px;
            background: linear-gradient(135deg, #f8f9ff 0%, #f0f2ff 100%);
            border: 1px solid rgba(102, 126, 234, 0.2);
            border-radius: 12px;
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        
        .attachment-link:hover,
        .attachment-link-download:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .attached-image-container {
            margin-bottom: 20px;
            padding: 20px;
            background: #f8f9ff;
            border-radius: 15px;
            border: 1px solid rgba(102, 126, 234, 0.1);
        }
        
        .attached-image {
            border-radius: 10px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }
        
        .audition-detail-actions {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.1);
            border: 1px solid rgba(102, 126, 234, 0.1);
            text-align: center;
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 15px 30px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            min-width: 150px;
            justify-content: center;
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        /* Enhanced Footer Styles */
        .site-footer {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            color: white;
            padding: 80px 0 30px;
            position: relative;
            overflow: hidden;
        }
        
        .site-footer:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="footerPattern" width="40" height="40" patternUnits="userSpaceOnUse"><circle cx="20" cy="20" r="1" fill="white" opacity="0.05"/></pattern></defs><rect width="100" height="100" fill="url(%23footerPattern)"/></svg>');
            pointer-events: none;
        }
        
        .footer-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 60px;
            margin-bottom: 50px;
            position: relative;
            z-index: 1;
        }
        
        .footer-logo {
            font-family: 'Montserrat', sans-serif;
            font-size: 3rem;
            font-weight: 900;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 20px;
        }
        
        .footer-description {
            font-size: 1.1rem;
            line-height: 1.8;
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 30px;
        }
        
        .footer-contact {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .contact-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 0;
            color: rgba(255, 255, 255, 0.9);
        }
        
        .contact-item i {
            color: #667eea;
            width: 20px;
        }
        
        .footer-links h3 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 25px;
            color: white;
        }
        
        .footer-links ul {
            list-style: none;
            padding: 0;
        }
        
        .footer-links a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            padding: 8px 0;
            display: block;
            transition: color 0.3s ease;
        }
        
        .footer-links a:hover {
            color: #667eea;
        }
        
        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 30px;
            text-align: center;
            color: rgba(255, 255, 255, 0.6);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .audition-detail-header,
            .audition-detail-meta,
            .audition-detail-content,
            .audition-detail-attachments,
            .audition-detail-actions {
                padding: 25px;
                margin-bottom: 25px;
            }
            
            .audition-detail-title {
                font-size: 2rem;
            }
            
            .audition-detail-actions {
                flex-direction: column;
            }
            
            .footer-container {
                grid-template-columns: 1fr;
                gap: 40px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="./../corporate/modules/header.jsp" %>
    
    <main>
        <section class="audition-detail-hero">
            <div class="container">
                <h2>오디션 상세정보</h2>
            </div>
        </section>
        
        <section class="audition-detail-section">
            <div class="container">
                <div class="audition-detail-header">
                    <div class="audition-status recruiting
                        <c:choose>
                            <c:when test="${audition.audiStatCode eq 'ADSC001'}">status-scheduled</c:when>
                            <c:when test="${audition.audiStatCode eq 'ADSC002'}">status-in-progress</c:when>
                            <c:when test="${audition.audiStatCode eq 'ADSC003'}">status-closed</c:when>
                        </c:choose>
                    ">
                        <c:choose>
                            <c:when test="${audition.audiStatCode eq 'ADSC001'}">예정</c:when>
                            <c:when test="${audition.audiStatCode eq 'ADSC002'}">진행중</c:when>
                            <c:when test="${audition.audiStatCode eq 'ADSC003'}">마감</c:when>
                        </c:choose>
                    </div>
                    <h3 class="audition-detail-title">${audition.audiTitle}</h3>
                </div>
                
                <ul class="audition-detail-meta">
                    <li>
                        <strong>모집 분야:</strong>
                        <c:choose>
                            <c:when test="${audition.audiTypeCode eq 'ADTC001'}">보컬</c:when>
                            <c:when test="${audition.audiTypeCode eq 'ADTC002'}">댄스</c:when>
                            <c:when test="${audition.audiTypeCode eq 'ADTC003'}">연기</c:when>
                        </c:choose>
                    </li>
                    <li>
                        <strong>접수 기간:</strong>
                        <c:set value="${fn:split(audition.audiStartDate, ' ')}" var="auditionStartDate"/>
                        <c:set value="${fn:split(audition.audiEndDate, ' ')}" var="auditionEndDate"/>
                        ${auditionStartDate[0]} ~ ${auditionEndDate[0]}
                    </li>
                </ul>
                
                <div class="audition-detail-content">
                    <h4>오디션 내용</h4>
                    <p>${audition.audiContent}</p>
                </div>
                
                <c:if test="${not empty audition.fileList}">
                	<div class="audition-detail-attachments">
                        <h4>첨부파일</h4>
                        <ul class="list-unstyled">
                            <c:forEach var="file" items="${audition.fileList}">
                                <li>
                                    <c:choose>
                                        <c:when test="${fn:startsWith(file.fileMimeType, 'image/')}">
                                            <div class="attached-image-container">                                               
                                                <span>${file.fileOriginalNm}</span>
                                                <a href="<c:url value='/corporate/Audition/download.do'>
                                                         <c:param name='attachDetailNo' value='${file.attachDetailNo}'/>
                                                         </c:url>" class="attachment-link-download" style="margin-left: 10px;">
                                                    <i class="fas fa-download"></i> 다운로드
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="<c:url value='/corporate/Audition/download.do'>
                                                     <c:param name='attachDetailNo' value='${file.attachDetailNo}'/>
                                                     </c:url>" class="attachment-link">
                                                <i class="fas fa-file-alt"></i> ${file.fileOriginalNm}
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>                            
                        </ul>
                	</div>
                </c:if>                
                <div class="audition-detail-actions">
                    <a href="${pageContext.request.contextPath}/corporate/audition/schedule" class="btn btn-secondary">
                        <i class="fas fa-list"></i> 목록
                    </a>
                    <c:if test="${audition.audiStatCode eq 'ADSC002'}">
                        <a href="/corporate/audition/supportForm.do?audiNo=${audition.audiNo}" class="btn btn-primary">
                            <i class="fas fa-pen"></i> 지원하기
                        </a>
                    </c:if>
                </div>
            </div>
        </section>
    </main>
	
	<%@ include file="../corporate/modules/footer.jsp" %>

<script src="${pageContext.request.contextPath}/resources/js/common/main.js"></script>
<script type="text/javascript">
    $(function(){
        let listBtn = $("#listBtn");		//목록 버튼
        let supportBtn = $("#supportBtn");	//지원하기 버튼
        //목록 버튼 클릭 이벤트
        listBtn.on("click", function(){
            location.href = "/corporate/audition/schedule";
        });
        // 지원하기 버튼 클릭 이벤트
        supportBtn.on("click", function(){
            location.href = "/corporate/audition/supportForm.do";
        });
    })
</script>
</body>
</html>
