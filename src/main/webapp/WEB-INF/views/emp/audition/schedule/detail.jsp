<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN - 오디션 일정 상세페이지</title>
    
    <%@ include file="../../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/audition_management_style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
	<style type="text/css">
		body {
		    font-family: 'Noto Sans KR', sans-serif;
		    color: #333;
		    background-color: #f8f9fa; /* 전체 페이지 배경색 */
		}
		
		a {
		    text-decoration: none;
		    color: inherit; /* 기본 링크 색상 상속 */
		}
        main {
            padding: 25px;
/*             max-width: 1200px; */
/*             margin: 0 auto; /* 중앙 정렬 */ */
            box-sizing: border-box; /* 패딩이 너비에 포함되도록 */
            font-size: small;
        }
        .audition-detail-section .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            border: 1px solid #e0e0e0;
        }

        /* 상세 정보 헤더 */
        .audition-detail-header {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
            gap: 15px;
        }
        .audition-detail-header .audition-status {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 0.85em;
            font-weight: bold;
            color: #fff;
            margin-right: 15px;
            background-color: #007bff; /* 예정됨, 진행중, 마감 색상 */
        }
        .audition-detail-header .audition-detail-title {
            margin: 0;
            font-size: 1.8em;
            color: #234aad;
		    font-weight: 600;
		    flex-grow: 1;
        }

        /* 세부 정보 섹션 */
        .detail-info-grid {
            display: grid;
            grid-template-columns: 150px 1fr; /* 제목 열 너비 고정, 내용 열은 남은 공간 차지 */
            gap: 5px 20px; /* 행 간격, 열 간격 */
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            background-color: #fcfdff;
            font-size: large;
        }
        .detail-info-grid strong {
            font-weight: bold;
            color: #555;
        }
        .detail-info-grid .info-label {
            font-weight: 600;
		    color: #34495e; /* 라벨 색상 */
		    padding: 5px 0;
		    display: flex;
		    align-items: center;
        }
        .detail-info-grid .info-value {
            padding: 5px 0;
		    color: #495057;
		    background-color: #f8faff; /* 값 영역 배경색 */
		    border: 1px solid #e0e5f0;
		    border-radius: 5px;
		    padding: 10px 15px;
		    min-height: 40px; /* 최소 높이로 일관성 유지 */
		    display: flex; /* 내용 세로 중앙 정렬 */
		    align-items: center;
		    word-break: break-word;
        }

        /* 오디션 내용*/
        .audition-detail-content,
        .audition-detail-attachments {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            background-color: #fcfdff;
        }
        .audition-detail-content h4,
        .audition-detail-attachments h4 {
            font-size: 1.4em;
            color: #234aad;
            font-weight: 600;
		    margin-top: 0;
		    margin-bottom: 18px;
		    padding-bottom: 10px;
		    border-bottom: 2px solid #e0e5f0;
        }
        .audition-detail-content p {
            line-height: 1.8;
            color: #495057;
            white-space: pre-wrap; /* 줄바꿈 유지 */
            font-size: 1em;
        }
        .audition-detail-attachments .list-unstyled {
            list-style: none;
            padding-left: 0;
        }
        .audition-detail-attachments .attachment-link {
            display: inline-flex; /* 아이콘과 텍스트 정렬 */
            align-items: center;
            color: #007bff;
            text-decoration: none;
            margin-bottom: 8px;
            font-size: 1em;
    		transition: all 0.2s ease;
        }
        .audition-detail-attachments .attachment-link i {
            margin-right: 10px;
            color: #6c757d;
            font-size: 1.1em;
        }
        .audition-detail-attachments .attachment-link:hover {
            color: #0056b3;
		    text-decoration: underline;
		    transform: translateX(3px);
        }
   /* 수정,삭제 버튼 */
        .audition-detail-actions {
		    display: flex;         /* 이 컨테이너를 Flexbox로 만듭니다. */
		    justify-content: flex-end; /* 모든 자식 요소를 오른쪽 끝으로 정렬합니다. */
		    align-items: center;   /* 자식 요소들을 수직 중앙에 정렬합니다. */
		    gap: 10px;             /* 자식 요소들 사이에 10px 간격을 줍니다. */
		}
		.audition-status-badge {
		    display: inline-block;
		    padding: 1em 1em; /* 패딩 조정 */
		    font-size: 1em; /* 폰트 크기 조정 */
		    font-weight: 700;
		    line-height: 1;
		    text-align: center;
		    white-space: nowrap;
		    vertical-align: middle;
		    border-radius: 12rem; /* 둥근 뱃지 형태 */
		    opacity: 0.95;
		    color: #fff;
		    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		}
		
		/* '예정' 상태일 때의 스타일 (ADSC001) */
		.audition-status-badge.status-scheduled {
		    background-color: #007bff; /* 파란색 (정보성) */
		}
		
		/* '진행중' 상태일 때의 스타일 (ADSC002) */
		.audition-status-badge.status-in-progress {
		    background-color: #28a745; /* 녹색 (성공/진행) */
		}
		
		/* '마감' 상태일 때의 스타일 (ADSC003) */
		.audition-status-badge.status-closed {
		    background-color: #6c757d; /* 회색 (경고/마감) */
		}
		.btn-secondary {
		    background-color: #6c757d; /* 회색 */
		    color: #fff;
		    border: none;
		    padding: 10px 18px;
		    border-radius: 6px;
		    font-size: 1em;
		    font-weight: 600;
		    cursor: pointer;
		    transition: background-color 0.2s ease, transform 0.1s ease, box-shadow 0.2s ease;
		    display: inline-flex;
		    align-items: center;
		    gap: 8px;
		    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		    margin-left: auto; /* 제목과 뱃지 이후 오른쪽 끝으로 이동 */
		}
		.btn-secondary:hover {
		    background-color: #5a6268;
		    transform: translateY(-2px);
		    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
		}
		.btn-primary { /* 수정, 삭제 버튼 */
		    background-color: #007bff; /* 파란색 */
		    color: #fff;
		    border: none;
		    padding: 10px 18px;
		    border-radius: 6px;
		    font-size: 1em;
		    font-weight: 600;
		    cursor: pointer;
		    transition: background-color 0.2s ease, transform 0.1s ease, box-shadow 0.2s ease;
		    display: inline-flex;
		    align-items: center;
		    gap: 8px;
		    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		}
		.btn-primary:hover {
		    background-color: #0056b3;
		    transform: translateY(-2px);
		    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
		}
		#delBtn {
		    background-color: #dc3545; /* 빨간색 */
		}
		#delBtn:hover {
		    background-color: #c82333;
		}
	</style>
</head>
<body>
     <div class="emp-container">
        <%@ include file="../../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../../modules/aside.jsp" %>
<!--  main  -->        
			<main style="width: 100%;">
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">오디션 관리</a></li>
					  <li class="breadcrumb-item location"><a href="/emp/audition/schedule" style="color:black;">일정 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">오디션 상세정보</li>
					</ol>
				</nav>
				<section class="audition-detail-hero">
		            <div class="container" style="max-width: none;" >
		                <h2>오디션 상세정보</h2>
		            </div>
		        </section>
				
				<section class="audition-detail-section">
		            <div class="container" style="max-width: none;">
		                <div class="audition-detail-header">
		                    <span class="audition-status-badge
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
							</span>
		                    <h3 class="audition-detail-title">${audition.audiTitle }</h3>
		                    <!--  작성자만 보이기 -->
		                    <sec:authentication property="principal.username" var="currentUsername" />
		                    <c:if test="${currentUsername eq audition.empUsername}">
		                    <a href="/emp/audition/updateForm.do?audiNo=${audition.audiNo }" class="btn btn-primary" style="white-space: nowrap;">
		                        <i class="fa-solid fa-pen-to-square"></i> 수정</a>
		                    <form action="/emp/audition/delete.do"  method="post" id="delForm" style="display: inline; white-space: nowrap;">    
 		                    	<button type="submit" class="btn btn-primary" id="delBtn"><i class="fa-solid fa-trash-can"></i> 삭제</button>							
								<input type="hidden" name="audiNo" value="${audition.audiNo}" />		                   
		                   		<sec:csrfInput/>
							</form>
							</c:if>
		                </div>
		                <div class="detail-info-grid">
		                    <div class="info-label">모집 분야</div>
		                    	<div class="info-value">
			                    	<c:choose>
		                       			<c:when test="${audition.audiTypeCode eq 'ADTC001'}">보컬</c:when>
		                       			<c:when test="${audition.audiTypeCode eq 'ADTC002'}">댄스</c:when>
		                       			<c:when test="${audition.audiTypeCode eq 'ADTC003'}">연기</c:when>
			                    	</c:choose>
		                    	</div>		                    
		                    <div class="info-label">모집 기간</div>
							<div class="info-value">
							    <c:set value="${fn:split(audition.audiStartDate, ' ')}" var="auditionStartDate"/> ${auditionStartDate[0]}
							    ~
							    <c:set value="${fn:split(audition.audiEndDate, ' ')}" var="auditionEndDate"/> ${auditionEndDate[0]}
							</div>
			                <div class="info-label">공고 등록일시</div>
			                <div class="info-value"><c:set value="${fn:split(audition.audiRegDate, ' ')}" var="auditionRegDate"/> ${auditionRegDate[0] }</div>			                
			                <div class="info-label">공고 수정일시</div>
			                <div class="info-value"><c:set value="${fn:split(audition.audiModDate, ' ')}" var="auditionModDate"/> ${auditionModDate[0] }</div>
		                </div>
		                <div class="audition-detail-content">
		                    <h4>오디션 내용</h4>
		                   <p>
		       				 ${audition.audiContent}
		    				</p>
		                </div>
		                
		                <c:if test="${not empty audition.fileList}">
		                <div class="audition-detail-attachments">
						    <h4>첨부파일</h4>
						    <ul class="list-unstyled">						    	
						    		<c:forEach var="file" items="${audition.fileList}">
							    		<li>
								            <a href="<c:url value='/Emp/Audition/download.do'>
								            	 <c:param name='attachDetailNo' value='${file.attachDetailNo}'/>
								            	 </c:url>" class="attachment-link">
								                <i class="fas fa-file-pdf"></i>
								                 ${file.fileOriginalNm}
								            </a>
							        	</li>
						    		</c:forEach>												    
						    </ul>
		                </div>
						</c:if>
		                <div class="audition-detail-actions">
		                	<a href="${pageContext.request.contextPath}/emp/audition/schedule" class="btn btn-secondary"  style="margin-left: auto;">
		                    	<i class="fas fa-list"></i> 목록
		                    </a>
		                </div>
		            </div>
		        </section>
			</main>  
		    </div>
		<footer class="emp-footer">
			<p>&copy; 2025 DDTOWN Entertainment. All rights reserved. (직원 전용)</p>
		</footer>
	</div>
<!-- 수정 성공시 알림창 -->	
	<script>
	$(function(){
        <c:if test="${not empty message}">
        var message = "${message}"; // 컨트롤러에서 넘어온 message 값을 JavaScript 변수에 할당

        if (typeof swal === 'function') {
            swal({
                title: "알림",
                text: message,
                icon: "success",
                button: "확인",
            });
        }
    	</c:if>
    });
    </script>
</body>
<%@ include file="../../../modules/footerPart.jsp" %>

<%@ include file="../../../modules/sidebar.jsp" %>
<script>

</script> 
</html>