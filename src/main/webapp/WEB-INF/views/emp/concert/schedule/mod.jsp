<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>콘서트 일정 수정</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <%@ include file="../../../modules/headerPart.jsp" %>
<style>
    /* ---------------------------------- */
    /* 공통 & 기본 설정                   */
    /* ---------------------------------- */
    body {
        font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
        margin: 0;
        background-color: #f4f6f9;
        color: #212529;
    }
    a { text-decoration: none; }

    /* ---------------------------------- */
    /* 폼 페이지 - 컨테이너 & 헤더        */
    /* ---------------------------------- */
    .form-view-container {
        background: #fff;
        padding: 30px 35px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }
    .form-header {
        padding-bottom: 20px;
        border-bottom: 1px solid #dee2e6;
        margin-bottom: 30px;
    }
    .form-title {
        font-size: 1.8em;
        font-weight: 600;
        margin-bottom: 0;
        color: #2c3e50;
    }

    /* ---------------------------------- */
    /* 폼 페이지 - 테이블 레이아웃        */
    /* ---------------------------------- */
    .form-table {
        width: 100%;
        border-top: 2px solid #333;
        border-collapse: collapse;
    }
    .form-table th, .form-table td {
        border-bottom: 1px solid #dee2e6;
        padding: 15px;
        font-size: 0.95em;
        vertical-align: middle;
    }
    .form-table th {
        width: 20%;
        background-color: #f8f9fa;
        text-align: left;
        font-weight: 600;
    }

    /* ---------------------------------- */
    /* 폼 요소(input, select 등) 스타일  */
    /* ---------------------------------- */
    .form-table input[type="text"],
    .form-table input[type="number"],
    .form-table input[type="date"],
    .form-table input[type="datetime-local"],
    .form-table select,
    .form-table textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ced4da;
        border-radius: 6px;
        font-size: 1em;
        box-sizing: border-box; /* padding을 포함하여 너비 계산 */
    }
    .form-table input:focus, 
    .form-table select:focus, 
    .form-table textarea:focus {
        outline: none;
        border-color: #80bdff;
        box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
    }
    .form-table textarea {
        min-height: 150px;
        resize: vertical;
    }
    /* 라디오 버튼 아이템 그룹 스타일 */
	.radio-item {
	    display: inline-flex;  /* 내부 요소를 한 줄로 정렬 */
	    align-items: center;   /* 라디오 버튼과 라벨을 세로 중앙 정렬 */
	    margin-right: 25px;    /* 'Yes' 그룹과 'No' 그룹 사이의 간격 */
	    cursor: pointer;       /* 전체 영역을 클릭 가능하도록 표시 */
	}
	
	/* 라디오 버튼 자체의 스타일 */
	.radio-item input[type="radio"] {
	    margin-right: 6px; /* 버튼과 라벨 텍스트 사이의 간격 */
	}
	
	/* 라벨 텍스트 스타일 */
	.radio-item label {
	    font-weight: normal;
	    padding-top: 1px; /* 미세한 세로 위치 조정 */
	}

    /* 기존 첨부파일 목록 */
    .attachment-list { list-style: none; padding: 0; margin: 0; }
    .attachment-list li { margin-bottom: 8px; }
    .attachment-list img { vertical-align: middle; margin-right: 8px; width: 40px; height: 40px; object-fit: cover; }

    /* ---------------------------------- */
    /* 버튼 UI (공통)                   */
    /* ---------------------------------- */
    .btn {
        display: inline-block;
        padding: 10px 20px;
        font-size: 0.95em;
        font-weight: 500;
        text-align: center;
        text-decoration: none;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: all 0.2s ease-in-out;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    .btn-submit { background-color: #8a2be2; color: white; }
    .btn-submit:hover { background-color: #d96fd1; color: white; }
    .btn-secondary { background-color: #6c757d; color: white; }
    .btn-secondary:hover { background-color: #5a6268; }

    .form-actions { text-align: right; padding-top: 25px; margin-top: 20px; border-top: 1px solid #e9ecef; }
    .form-actions .btn { margin-left: 8px; }
	#artGroupName{
		background-color: #e9ecef;
    	cursor: not-allowed;
    	color: #6c757d;
	}
	}
</style>
</head>
<body>
    <div class="emp-container">
    <%@ include file="../../modules/header.jsp" %>
		<div class="emp-body-wrapper">
			<%@ include file="../../modules/aside.jsp" %>
			<main class="emp-content" style="position:relative; min-height:600px;">
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
	                <ol class="breadcrumb">
	                    <li class="breadcrumb-item">콘서트 관리</li>
	                    <li class="breadcrumb-item"><a href="/emp/concert/schedule/list">콘서트 일정 관리</a></li>
	                    <li class="breadcrumb-item"><a href="/emp/concert/schedule/detail/${concertVO.concertNo}">콘서트 일정 상세 정보</a></li>
	                    <li class="breadcrumb-item active" aria-current="page">콘서트 일정 수정</li>
	                </ol>
	            </nav>
                <c:if test="${not empty errorMessage}"><div class="message error">${errorMessage}</div></c:if>

                <div class="form-view-container">
                    <div class="form-header">
                        <h2 class="form-title">콘서트 일정 수정 (번호: ${concertVO.concertNo})</h2>
                    </div>
                    <form method="post" action="<c:url value='/emp/concert/schedule/mod/${concertVO.concertNo}'/>" enctype="multipart/form-data">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        
                        <table class="form-table">
                            <tbody>
                                <tr>
                                    <th><label for="concertNm">콘서트명</label></th>
                                    <td><input type="text" id="concertNm" name="concertNm" value="<c:out value='${concertVO.concertNm}'/>" required></td>
                                </tr>
                                <tr>
                                    <th><label for="artGroupName">아티스트 그룹</label>
                                	<td>
                                		<input type="text" id="artGroupName" name="artGroupName" value="<c:out value='${concertVO.artGroupName}'/>" readonly>
                                		<input type="hidden" name="artGroupNo" value="${concertVO.artGroupNo}" />
                                	</td>
                                </tr>
                                <tr>
                                    <th><label for="concertHallNo">공연장</label></th>
                                    <td>
                                        <select name="concertHallNo" id="concertHallNo">
                                            <option value="1" ${concertVO.concertHallNo == 1 ? 'selected' : ''}>블루스퀘어 SOL 트래블 홀</option>
                                            <option value="1" ${concertVO.concertHallNo == 6 ? 'selected' : ''}>온라인 콘서트</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="concertAddress">공연 주소</label></th>
                                    <td><input type="text" id="concertAddress" name="concertAddress" value="<c:out value='${concertVO.concertAddress}'/>" required></td>
                                </tr>
                                <tr>
                                    <th><label for="concertDate">공연일</label></th>
                                    <td><input type="datetime-local" id="concertDate" name="concertDate" value="<fmt:formatDate value='${concertVO.concertDate}' pattern="yyyy-MM-dd'T'HH:mm"/>" required></td>
                                </tr>
                                <tr>
                                    <th><label>온라인 여부</label></th>
                                    <td>
                                    	<span class="radio-item">
                                        <input type="radio" id="onlineY_mod" name="concertOnlineYn" value="Y" ${concertVO.concertOnlineYn == 'Y' ? 'checked' : ''}> 
                                        <label for="onlineY_mod" class="radio-label">Yes</label>
                                        </span>
                                        <span class="radio-item">
                                        <input type="radio" id="onlineN_mod" name="concertOnlineYn" value="N" ${concertVO.concertOnlineYn == 'N' ? 'checked' : ''}> 
                                        <label for="onlineN_mod" class="radio-label">No</label>
                                        </span>
                                    </td>
                                </tr>
                                 <tr>
                                    <th><label for="concertRunningTime">진행 시간(분)</label></th>
                                    <td><input type="number" id="concertRunningTime" name="concertRunningTime" value="${concertVO.concertRunningTime}" required min="0"></td>
                                </tr>
                                <tr>
                                    <th><label for="concertStartDate">예매 시작일시</label></th>
                                    <td><input type="datetime-local" id="concertStartDate" name="concertStartDate" value="<fmt:formatDate value='${concertVO.concertStartDate}' pattern="yyyy-MM-dd'T'HH:mm"/>" required></td>
                                </tr>
                                <tr>
                                    <th><label for="concertEndDate">예매 종료일시</label></th>
                                    <td><input type="datetime-local" id="concertEndDate" name="concertEndDate" value="<fmt:formatDate value='${concertVO.concertEndDate}' pattern="yyyy-MM-dd'T'HH:mm"/>" required></td>
                                </tr>
                                 <tr>
                                    <th><label for="concertCatCode">카테고리 코드</label></th>
                                    <td>
                                        <select name="concertCatCode" id="concertCatCode">
                                            <option value="CCC001" ${concertVO.concertCatCode == 'CCC001' ? 'selected' : ''}>CCC001(온라인)</option>
                                            <option value="CCC002" ${concertVO.concertCatCode == 'CCC002' ? 'selected' : ''}>CCC002(오프라인)</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="concertReservationStatCode">예매 상태 코드</label></th>
                                    <td>
                                        <select name="concertReservationStatCode" id="concertReservationStatCode">
                                            <option value="CRSC001" ${concertVO.concertReservationStatCode == 'CRSC001' ? 'selected' : ''}>CRSC001(선예매기간)</option>
                                            <option value="CRSC002" ${concertVO.concertReservationStatCode == 'CRSC002' ? 'selected' : ''}>CRSC002(예매중)</option>
                                            <option value="CRSC003" ${concertVO.concertReservationStatCode == 'CRSC003' ? 'selected' : ''}>CRSC003(매진)</option>
                                            <option value="CRSC004" ${concertVO.concertReservationStatCode == 'CRSC004' ? 'selected' : ''}>CRSC004(종료)</option>
                                            <option value="CRSC005" ${concertVO.concertReservationStatCode == 'CRSC005' ? 'selected' : ''}>CRSC005(예정)</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="concertStatCode">콘서트 상태 코드</label></th>
                                    <td>
                                        <select name="concertStatCode" id="concertStatCode">
                                            <option value="CTSC001" ${concertVO.concertStatCode == 'CTSC001' ? 'selected' : ''}>CTSC001(예정)</option>
                                            <option value="CTSC002" ${concertVO.concertStatCode == 'CTSC002' ? 'selected' : ''}>CTSC002(진행)</option>
                                            <option value="CTSC003" ${concertVO.concertStatCode == 'CTSC003' ? 'selected' : ''}>CTSC003(종료)</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="concertGuide">콘서트 안내사항</label></th>
                                    <td><textarea id="concertGuide" name="concertGuide" maxlength="1000" required><c:out value='${concertVO.concertGuide}'/></textarea></td>
                                </tr>
                                
                                <c:if test="${not empty concertVO.attachmentFileList}">
                                    <tr>
                                        <th>기존 첨부파일 삭제</th>
                                        <td>
                                            <ul class="attachment-list">
                                            <c:forEach var="file" items="${concertVO.attachmentFileList}">
                                                <li>
                                                    <input type="checkbox" name="deleteFileNos" value="${file.attachDetailNo}" id="delFile_${file.attachDetailNo}">
                                                    <img src="<c:url value='${file.webPath}'/>" alt="<c:out value='${file.fileOriginalNm}'/>"/>
                                                    <label for="delFile_${file.attachDetailNo}">
                                                        <c:out value="${file.fileOriginalNm}"/> (<c:out value="${file.fileFancysize}"/>)
                                                    </label>
                                                </li>
                                            </c:forEach>
                                            </ul>
                                        </td>
                                    </tr>
                                </c:if>
                                <tr>
                                    <th><label for="concertFiles">새 첨부파일</label></th>
                                    <td><input type="file" id="concertFiles" name="concertFiles" multiple="multiple"></td>
                                </tr>
                            </tbody>
                        </table>

                        <div class="form-actions">
                            <c:url var="listBackUrl" value="/emp/concert/schedule/list">
                                <c:param name="searchType" value="${searchType}" />
                                <c:param name="searchWord" value="${searchWord}" />
                                <c:param name="currentPage" value="${currentPage}" />
                            </c:url>
                            <a href="${listBackUrl}" class="btn btn-secondary">목록으로</a>
                            <button type="submit" class="btn btn-submit">수정 완료</button>
                        </div>
                    </form>
                </div>
			</main>
		</div>
	</div>
	<%@ include file="../../../modules/footerPart.jsp" %>
	<%@ include file="../../../modules/sidebar.jsp" %>
<script type="text/javascript">
    
</script>
</body>
</html>