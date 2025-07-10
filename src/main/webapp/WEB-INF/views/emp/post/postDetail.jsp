<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시물 상세보기 - DDTOWN 직원 포털</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" ></script>
    <style>
    	body {
        font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
        margin: 0;
        background-color: #f4f6f9;
        color: #212529;
	    }
	    a {
		    color: var(--primary-color);
		    text-decoration: none;
		    transition: color var(--transition-fast);
	    }
	    .text-center { text-align: center; }
    	.emp-content{
	    	flex: 1; /* 남은 공간을 채우도록 설정 */
	        padding: 25px;
	        background-color: #f5f6fa;
	        display: flex;
	        flex-direction: column; /* 세로 정렬 */
	        align-items: center; /* 내용 중앙 정렬 */
	        font-size: medium;
    	}
    	.emp-content > nav { /* emp-content 바로 하위의 nav (브레드크럼) */
	        width: 100%; /* 너비 100%로 설정하여 좌우 여백을 가질 수 있도록 함 */
	        padding: 0 10px; /* 좌우 패딩 추가 */
	        box-sizing: border-box; /* 패딩이 너비에 포함되도록 */
	        text-align: left; /* 내부 텍스트 왼쪽 정렬 (필요시) */
	        align-self: flex-start; /* ⭐이 요소만 플렉스 시작점(왼쪽)으로 정렬⭐ */
	    }
    	.post-detail-container,
    	.post-reply-container {
		    width: 100%; /* 부모 너비에 맞춤 */
/* 	        max-width: 1000px; /* 최대 너비 설정 */ */
	        margin: 20px 0; /* 좌우 마진 0으로 설정, emp-content의 align-items: center로 중앙 정렬 */
	        background: #fff;
	        border-radius: 10px;
	        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06); /* 통일된 그림자 */
	        padding: 36px;
		}
        .post-detail-container h2 { font-size: 1.8em; color: #234aad; margin-bottom: 28px; font-weight: 700; }
        .post-detail-table { width: 100%; border-collapse: separate; margin-bottom: 24px; border-radius: 8px; }
        .post-detail-table th, .post-detail-table td { padding: 12px 15px; text-align: left; font-size: 1em; border-bottom: 1px solid #eee; }
        .post-detail-table th { width: 150px; color: #234aad; background: #f0f5ff; font-weight: 600; border-right: 1px solid #e0e5f0; }
        .post-detail-table td { background: #fafbfc; color: #495057; }
        .post-detail-table tr:last-child th,
	    .post-detail-table tr:last-child td {
	        border-bottom: none; /* 마지막 행 하단 테두리 제거 */
	    }
        .post-detail-content { min-height: 120px; border: 1px solid #e0e0e0; border-radius: 6px; padding: 18px 14px; background: #fcfcfc; margin-bottom: 18px; font-size: 1.05em; line-height: 1.8; color: #343a40; }
        .file-link { color: #234aad; text-decoration: underline; margin-left: 8px; font-weight: 500; }
        .imgContainer{
        	position: relative;
        	margin: 15px 0 5px 0; /* 이미지 상단 여백 추가 */
	        max-width: 60%; /* 이미지 크기 조정 */
	        border-radius: 8px;
	        overflow: hidden; /* 이미지 둥근 모서리 적용 */
	        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
	        display: inline-block; /* 여러 이미지 가로 정렬 */
	        vertical-align: top; /* 상단 정렬 */
	        margin-right: 15px;
        }
        .imgContainer img {
		    max-width: 100%;
		    height: auto;
		    display: block; /* 이미지 하단 여백 제거 */
		}
		.deleteImgBtn {
		    position: absolute; /* 부모인 .image-container를 기준으로 위치 */
		    top: 8px;     /* 상단에서 5px 떨어지게 */
		    right: 8px;   /* 우측에서 5px 떨어지게 */
		    background-color: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
	        color: white;
	        border: none;
	        border-radius: 50%;
	        width: 28px; /* 버튼 크기 고정 */
	        height: 28px;
	        display: flex; /* 아이콘 중앙 정렬 */
	        justify-content: center;
	        align-items: center;
	        cursor: pointer;
	        font-size: 1.1em;
	        z-index: 10;
	        transition: background-color 0.2s;
		}
		.deleteImgBtn:hover {
		    background-color: rgba(255, 0, 0, 0.7);
		}
		.new-preview { /* 새로 추가된 이미지 미리보기 스타일 */
	        border: 1px dashed #ced4da;
	        padding: 5px;
	    }
	    /* ---------------------------------- */
    /* 버튼 섹션                         */
    /* ---------------------------------- */
    .post-detail-btns {
        text-align: center;
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid #eee; /* 구분선 추가 */
        display: flex;
    	justify-content: right;
    }
    .post-detail-btns button {
        padding: 10px 25px;
        font-size: 1em;
        border: none;
        border-radius: 6px;
        margin: 0 6px;
        cursor: pointer;
        transition: all 0.2s ease-in-out;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .post-detail-btns button:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    .post-detail-btns .list-btn { background: #6c757d; color: #fff; } /* 회색 */
    .post-detail-btns .list-btn:hover { background: #5a6268; }
    .post-detail-btns .btn-primary { background: #234aad; color: #fff; } /* 파란색 */
    .post-detail-btns .btn-primary:hover { background: #1a3c8a; }
    .post-detail-btns .delete-btn { background: #dc3545; color: #fff; } /* 삭제 버튼 색상 (현재 사용 안 됨) */
    .post-detail-btns .delete-btn:hover { background: #c82333; }

    /* ---------------------------------- */
    /* 댓글 섹션                         */
    /* ---------------------------------- */
    .post-reply-container h2 {
        font-size: 1.8em;
	    color: #234aad;
	    margin-bottom: 28px;
	    font-weight: 700;
    }

    .comment-section h3 {
        font-size: 1.15em;
        color: #234aad;
        margin-bottom: 12px;
        display: flex;
        align-items: baseline;
        gap: 10px;
    }
    .comment-section h3 span {
        font-size: 0.9em;
        color: #6c757d;
        font-weight: normal;
    }
    .comment-section h3 span#totalReply {
        font-weight: bold;
        color: #212529;
    }
    .comment-section form#searchForm {
	    display: flex;
	    gap: 8px;
	    margin-bottom: 20px;
	    flex-wrap: wrap;
	    max-width: 440px;
	    margin-left: auto;
	}
    .comment-section form#searchForm select,
    .comment-section form#searchForm input[type="search"] {
        padding: 8px 12px;
        border: 1px solid #ced4da;
        border-radius: 5px;
        font-size: 0.95em;
    }
    .comment-section form#searchForm select {
        -webkit-appearance: none; -moz-appearance: none; appearance: none;
        background-image: url('data:image/svg+xml;utf8,<svg fill="%234A4A4A" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/><path d="M0 0h24v24H0z" fill="none"/></svg>');
        background-repeat: no-repeat; background-position: right 8px center; background-size: 16px; padding-right: 28px;
        min-width: 100px;
    }
    .comment-section form#searchForm input[type="search"] {
        flex-grow: 1;
        min-width: 200px;
    }
    .comment-section form#searchForm button {
        padding: 8px 18px;
        font-size: 0.95em;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .comment-section form#searchForm button:hover {
        background-color: #0056b3;
    }
    /* 댓글 테이블 */
    .comment-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05); /* 댓글 테이블에도 그림자 */
        margin-bottom: 20px;
    }
    .comment-table th,
    .comment-table td {
        padding: 10px 12px;
        text-align: center;
        font-size: 0.92em;
        border-bottom: 1px solid #e9ecef; /* 하단 테두리 */
    }
    .comment-table thead th {
        background: #f0f5ff;
        color: #234aad;
        font-weight: 600;
    }
    .comment-table tbody tr:last-child td {
        border-bottom: none;
    }
    .comment-table tbody tr:nth-child(even) {
        background-color: #f9f9f9; /* 짝수 행 배경색 */
    }
    .comment-table tbody tr:hover {
        background-color: #eef7ff; /* 호버 시 배경색 변경 */
    }
    .comment-table td.content {
        text-align: left;
        color: #343a40;
    }
    .comment-table td .comment-delete-btn {
        padding: 6px 14px;
        background: #dc3545;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 0.85em;
        transition: background-color 0.2s;
    }
    .comment-table td .comment-delete-btn:hover {
        background: #c82333;
    }
    /* 댓글 없을 때 */
    .comment-table tbody tr td[colspan="3"] {
        padding: 40px 0;
        color: #6c757d;
        font-style: italic;
    }
    /* ---------------------------------- */
    /* 모달 스타일    						  */
    /* ---------------------------------- */
    .modal-dialog {
        max-width: 800px;
    }
    .modal-content {
        border-radius: 10px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
    }
    .modal-header {
        background-color: #234aad;
        color: white;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
        padding: 15px 20px;
    }
    .modal-header .btn-close {
        filter: invert(1); /* X 버튼을 흰색으로 변경 */
    }
    .modal-title {
        font-weight: 600;
    }
    .modal-body {
        padding: 25px;
    }
    .modal-body .col-form-label {
        font-weight: 600;
        color: #343a40;
    }
    .modal-body .form-control,
    .modal-body textarea {
        border-radius: 5px;
        border: 1px solid #ced4da;
        padding: 10px 12px;
    }
    .modal-body textarea {
        min-height: 100px;
        resize: vertical;
    }
    .modal-body input[type="datetime-local"] {
        padding: 8px 12px;
    }
    .modal-footer {
        padding: 15px 20px;
        border-top: 1px solid #e9ecef;
        display: flex;
        justify-content: center;
        gap: 10px;
    }
    .modal-footer .btn {
        padding: 8px 20px;
        font-size: 1em;
        border-radius: 5px;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    .modal-footer .btn-primary {
        background-color: #234aad;
        color: white;
    }
    .modal-footer .btn-primary:hover {
        background-color: #1a3c8a;
    }
    .modal-footer .btn-secondary {
        background-color: #6c757d;
        color: white;
    }
    .modal-footer .btn-secondary:hover {
        background-color: #5a6268;
    }
    /* 체크박스 스타일 */
    #editMemberShipYn {
        transform: scale(1.3); /* 체크박스 크기 키우기 */
        margin-left: 10px;
        vertical-align: middle;
    }
    /* 새로 추가된 이미지 미리보기 영역 */
    .editImgArea {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-top: 10px;
        border: 1px solid #e0e0e0;
        border-radius: 6px;
        padding: 10px;
        background-color: #fcfcfc;
    }
    .postMaintained {
	    border: 1px solid aliceblue;
	    border-radius: 8pt;
	    background-color: #2bdb2b3d;
	    font-weight: 600;
        max-width: 50pt;
    	text-align: center;
	}
	.postRemoved {
	    border: 1px solid aliceblue;
	    border-radius: 8pt;
	    background-color: #fb00005c;
	    font-weight: 600;
	    max-width: 50pt;
    	text-align: center;
	}

	.reply-header {
	    display: flex;
	    justify-content: space-between;
	    border-bottom: 1px solid aliceblue;
	    margin-bottom: 30px;
	    padding-bottom: 10px;
	}

	.reply-header h5 {
	    margin: 0;
	    border: none;
	    padding: 0;
	    align-content: center;
	}

	span.reply-count {
	    border: 1px solid aliceblue;
	    border-radius: 25pt;
	    padding: 10pt;
	    margin: 0;
	    background-color: #ceeafe;
	    color: #234aad;
	    font-weight: 600;
	    height: fit-content;
	}
	.post-detail-header {
	    display: flex;
	    justify-content: space-between;
	}

	.post-detail-header button {
	    padding: 0pt 7pt 0pt 7pt;
	    height: 30pt;
	    background-color: #234aad;
	    color: white;
	    transition: all 0.2s ease;
	}

    .post-detail-header button:hover {
        background-color: #234aada6;
    }

    label.col-form-label.membership {
	    border: 1px solid aliceblue;
	    border-radius: 10pt;
	    background-color: cornflowerblue;
	    color: white;
	    text-align: center;
	    cursor: pointer;
	    padding: 2pt 7pt 2pt 7pt;
	    font-size: 10pt;
	    transition: 0.3s ease;
	}

	label.col-form-label.membership:hover {
	    transform: translateY(-10px);
	    box-shadow: 0px 7px 8px cornflowerblue;
	    scale: 1.05;
	}

	.mb-3.membership {
	    height: auto;
	    display: flex;
	    justify-content: center;
	}
	.mb-3.membership input[type=checkbox]:checked + label.col-form-label.membership{
		background-color: #234aad;
		scale : 0.9;
	}


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
						<li class="breadcrumb-item"><a href="#" style="color:black;"> 아티스트 커뮤니티 관리</a></li>
						<li class="breadcrumb-item"><a href="/emp/post/list" style="color:black;">게시물 관리</a></li>
						<li class="breadcrumb-item active" aria-current="page">게시물 관리</li>
					</ol>
				</nav>
                <div class="post-detail-container">
                	<div class="post-detail-header">
	                    <h2>게시물 상세보기</h2>
	                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" id="editModal" data-bs-target="#postEdit"><i class="fa-solid fa-pen-to-square"></i> 수정</button>
                	</div>
                    <table class="post-detail-table">
                        <tr>
                            <th>ID</th>
                            <td><c:out value="${artistVO.comuPostNo }"/></td>
                        </tr>
                        <tr>
                            <th>아티스트</th>
                            <td>${artistVO.writerProfile.artistVO.artNm }</td>
                        </tr>
                        <tr>
                            <th>작성일</th>
                            <td><fmt:formatDate value="${artistVO.comuPostRegDate }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        </tr>
                        <tr>
                            <th>좋아요 수</th>
                            <td>${artistVO.comuPostLike }</td>
                        </tr>
                        <tr>
                            <th>멤버십 여부</th>
                            <td>
                            	<c:if test="${artistVO.comuPostMbspYn eq 'Y'}">
                            		멤버십 전용
                            	</c:if>
                            	<c:if test="${artistVO.comuPostMbspYn eq 'N'}">
                            		전체 공개
                            	</c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>게시글 삭제 여부</th>
                            <td>
                            	<c:if test="${artistVO.comuPostDelYn eq 'Y'}">
                            		<div class="postRemoved">삭제됨</div>
                            	</c:if>
                            	<c:if test="${artistVO.comuPostDelYn eq 'N'}">
                            		<div class="postMaintained">유지중</div>
                            	</c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>게시글 상태</th>
                            <td>${artistVO.commCodeDetailVO.description }</td>
                        </tr>

                    </table>
                    <div class="post-detail-content">
                        <c:out value="${artistVO.comuPostContent }" />
                        <c:if test="${not empty artistVO.postFiles }">
                        	<c:forEach items="${artistVO.postFiles }" var="file">
                        		<img src="${file.webPath }" alt="첨부 이미지" style="margin-top:12px; max-width:50%; border-radius:8px;">
                        	</c:forEach>
                        </c:if>
                    </div>
                    <div class="post-detail-btns">
                        <button type="button" class="list-btn" onclick="window.location.href='/emp/post/list'"><i class="fa-solid fa-list"></i> 목록</button>
                    </div>
                </div>
                <div class="post-reply-container">
                	<div class="reply-header">
	                	<h2>댓글 상세보기</h2>
	                    <span class="reply-count">전체 : <span id="totalReply"></span></span>
                	</div>
                	<div class="comment-section">
                        <form id="searchForm">
	                        <select class="searchType" id="searchType" name="searchType">
	                        	<option id="typeAll" value="">전체</option>
	                        	<option id="typeWriter" value="writer">작성자</option>
	                        	<option id="typeContent" value="content">내용</option>
	                        </select>
	                        <input type="search" class="searchWord" id="searchWord" name="searchWord" value="" placeHolder="작성자 또는 내용을 입력해주세요" />
	                        <button type="button" class="btn btn-primary" id="searchBtn"><i class="fas fa-search"></i> 검색</button>
                        </form>
	                        <table class="comment-table">
                            <thead>
                                <tr>
                                    <th>작성자</th>
                                    <th>내용</th>
                                    <th>작성일</th>
                                    <th style="white-space: nowrap;">삭제여부</th>
                                </tr>
                            </thead>
                            <tbody id="replyArea">
                            </tbody>
                        </table>
                        <div id="pagingArea">
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>


	<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<div id="modalArea">
<div class="modal fade" id="postEdit" tabindex="-1" aria-labelledby="postEditModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="postEditModalLabel">${artistVO.writerProfile.artistVO.artNm } 게시글</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<form id="editForm">
					<div class="mb-3">
						<label for="comuPostRegDate" class="col-form-label">작성일</label>
						<input type="datetime" class="form-control" id="comuPostRegDate" value="<fmt:formatDate value="${artistVO.comuPostRegDate }" pattern="YYYY-MM-dd HH:mm:ss"/>" readonly="readonly">
					</div>
					<div class="mb-3">
						<label for="comuPostModDate" class="col-form-label">수정일</label>
						<input type="datetime" min="${artistVO.comuPostModDate }" class="form-control" id="comuPostModDate" value="<fmt:formatDate value="${artistVO.comuPostModDate }" pattern="YYYY-MM-dd HH:mm:ss"/>" readonly="readonly">
					</div>
					<div class="mb-3 membership">
						<input type="checkbox" id="editMemberShipYn"  <c:if test="${artistVO.comuPostMbspYn eq 'Y'}">checked</c:if> style="display:none;"/>
						<label for="editMemberShipYn" class="col-form-label membership">멤버십 전용</label>
						<input type="hidden" id="memberShipYn" name="memberShipYn" value=""/>
					</div>
					<div class="mb-3">
						<label for="postImg" class="col-form-label">사진</label>
						<div class="editImgArea">
							<c:if test="${not empty artistVO.postFiles }">
	                        	<c:forEach items="${artistVO.postFiles }" var="file">
	                        		<div class="imgContainer">
		                        		<img src="${file.webPath }" alt="첨부 이미지">
		                        		<button class="deleteImgBtn" id="deleteImgBtn" data-fileGorupNo="${file.fileGroupNo }" data-fileNo="${file.attachDetailNo }" ><i class="bi bi-x-circle-fill"></i></button>
	                        		</div>
	                        	</c:forEach>
	                        </c:if>
						</div>
					</div>
					<div class="mb-3">
						<label for="comuPostContent" class="col-form-label">내용</label>
						<textarea class="form-control" id="comuPostContent">${artistVO.comuPostContent }</textarea>
					</div>
					<div class="mb-3">
						<input type="file" name="files" id="editFile" multiple accept="image/*">
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="updatePostBtn">수정</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>
</div>
</body>
<script>

$(function(){
	replyList();



	let pathName = window.location.pathname;
	let pathList = pathName.split("/");
	let comuPostNo = pathList[4];

	let fileMap = new Map();	// 업로드한 파일 담을 객체
	let fileNum = 0;		// 업로드한 파일의 순번

	let upFile = new Map();	// 수정 중 업로드한 파일 담을 객체
	let upFileNum = 0;		// 수정 중 업로드한 파일의 순번

	let deleteFileList = [];	// 삭제할 파일의 상세번호
	let deleteFileGroupNo = new Map();	// 삭제할 파일의 그룹번호

	$(".editImgArea").on("click","button",function(e){
		e.preventDefault();
		let parentDiv = $(this).parent('div');
		let fileNo = $(this)[0].dataset.fileno;
		let fileGroupNo = $(this)[0].dataset.filegorupno;

		deleteFileList.push(fileNo);
		deleteFileGroupNo.set(fileNo, parentDiv);

		parentDiv.hide();
	});

	$("#editFile").on("change",function(e){
		let files = e.target.files;

		let html = ``;
		for(let i=0; i<files.length; i++){
			let file = files[i];

			fileMap.set(fileNum.toString(),file);

			let reader = new FileReader();
    		reader.onload = function(e){
    			html = `
    				<div class="imgContainer new-preview">
	            		<img src="\${e.target.result}" alt="첨부 이미지" >
	            		<button class="deleteImgBtn" id="deleteImgBtn" ><i class="bi bi-x-circle-fill"></i></button>
	        		</div>
					`;
        		fileNum++;
			$(".editImgArea").append(html);
    		}
    		reader.readAsDataURL(file);
		}

	});

	$("#updatePostBtn").on("click",function(){


		let checked = $("#editMemberShipYn").is(":checked");
		$("#memberShipYn").val(checked);


		if(deleteFileList != null && deleteFileList.length > 0){
			$("#deleteFiles").val(deleteFileList);
		}


		let fileList = document.getElementById("editFile");
		let files = fileList.files;


		let data = new FormData();
		data.append("comuPostNo","${artistVO.comuPostNo}");
		data.append("boardTypeCode", "${artistVO.boardTypeCode}");


		data.append("memUsername","${artistVO.writerProfile.artistVO.memUsername}");
		data.append("comuPostContent", $("#comuPostContent").val());

		if("${artistVO.fileGroupNo}" != null && "${artistVO.fileGroupNo}" != ''){
			data.append("fileGroupNo","${artistVO.fileGroupNo}");
		}

		if(deleteFileList != null && deleteFileList.length > 0){
			data.append("deleteFiles",deleteFileList);
		}else{
			data.append("deleteFiles",deleteFileList);
		}

		if(checked){
			data.append("comuPostMbspYn","Y");
		}else{
			data.append("comuPostMbspYn","N");
		}

		if(files.length > 0){
			for(let i=0; i<files.length; i++){
				data.append("files",files[i]);
			}
		}

		$.ajax({
			url : "/community/update/post",
			type : "POST",
			data : data,
			processData : false,
			contentType : false,
			success : function(res){
				if(res == "OK"){
					Swal.fire({
						title : '수정완료!',
						text : '게시글 수정이 정상적으로 완료되었습니다!',
						icon : 'success',
					}).then((result) => {
						location.href = "/emp/post/detail/${artistVO.comuPostNo}" ;
					});
				}else{
					Swal.fire({
						title : '수정실패!',
						text : '수정 작업 중 오류가 발생되었습니다. 관리자에게 문의바랍니다.',
						icon : 'error'
					})
				}

			},
			error : function(error){
				console.log(error.status);
			},
			beforeSend : function(xhr) {
		        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
		    }
		})
	});

	$("#searchBtn").on("click",function(){
		let searchType = $("#searchType").val();
		let searchWord = $("#searchWord").val();


		let data = {
			"searchType" : searchType,
			"searchWord" : searchWord
		}

		replyList(data);
	});

	$("#searchWord").on("keydown",function(e){
		let data = {
			"searchWord" : $("#searchWord").val(),
			"searchType" : $("#searchType").val()
		}
		if (e.key === 'Enter') {
			replyList(data);
		}
	})

	$("#pagingArea").on("click","a",function(e){
		e.preventDefault();
		let page = $(this)[0].dataset.page;

		let searchType = $("#searchType").val();
		let searchWord = $("#searchWord").val();

		data = {
			"searchType" : searchType,
			"searchWord" : searchWord,
			"currentPage" : page
		}

		replyList(data);
	});

	$("#postEdit").on("hide.bs.modal",function(){
		$("#editForm")[0].reset();

		deleteFileGroupNo.forEach(($element, fileNo) => {
	        $element.show();
	        // 필요하다면 deleteFileList 등에서도 제거
	    });
		deleteFileGroupNo.clear();
		deleteFileList.length = 0;
	});

});

function replyList(data){
	let pathName = window.location.pathname;
	let pathList = pathName.split("/");
	let comuPostNo = pathList[4];

	$.ajax({
		url : '/emp/post/replyList/' + comuPostNo,
		type : 'get',
		data : data,
		success : function(res){
			if(res.pagingVO.searchWord != null && res.pagingVO.searchWord != ''){
				$("#searchWord").val(res.pagingVO.searchWord);
			}
			let replyList = res.pagingVO.dataList;
			let html = ``;
			if(replyList != null &&replyList.length > 0){
				for(let i=0; i<replyList.length; i++){
					let reply = replyList[i];

					let comuReplyRegDate = reply.comuReplyRegDate;
					let comuReplyModDate = reply.comuReplyModDate;

					let formatDate;

					if(comuReplyRegDate === comuReplyModDate){
						formatDate = dateFormat(comuReplyRegDate);
					}else{
						formatDate = dateFormat(comuReplyModDate) + " (수정됨)";
					}

					let replyDel;
					if(reply.comuReplyDelYn == 'Y'){
						replyDel = '삭제됨';
					}else{
						replyDel = '유지중';
					}

					html += `
						<tr>
	                        <td style="text-align: left; white-space: nowrap;">\${reply.replyMember.comuNicknm}</td>
	                        <td class="content" style="white-space: nowrap;">\${reply.comuReplyContent}</td>
	                        <td style="white-space: nowrap;">\${formatDate}</td>
	                        <td>\${replyDel}</td>
	                    </tr>
					`;
				}


			}else{
				html = `
					<tr>
	                    <td colspan="4">조회하실 댓글이 없습니다.</td>
	                </tr>
				`;

			}
			$("#replyArea").html(html);
			$("#pagingArea").html(res.pagingVO.pagingHTML);
			$("#totalReply").html(res.pagingVO.totalRecord);
		},
		error : function(error){
			console.log(error.status);
		}
	});
}

function dateFormat(jsonDate){
	if (!jsonDate) return "";
	let date = new Date(jsonDate);
	let month = date.getMonth() + 1;
    let day = date.getDate();
    let hour = date.getHours();
    let minute = date.getMinutes();
    let second = date.getSeconds();

    month = month >= 10 ? month : '0' + month;
    day = day >= 10 ? day : '0' + day;
    hour = hour >= 10 ? hour : '0' + hour;
    minute = minute >= 10 ? minute : '0' + minute;
    second = second >= 10 ? second : '0' + second;

    return date.getFullYear() + '-' + month + '-' + day + " " + hour + ":" + minute + ":" + second;
}
</script>


</html>