<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:choose>
		<c:when test="${mode == 'edit'}">공지사항 수정</c:when>
		<c:otherwise>공지사항 등록</c:otherwise>
	</c:choose> - DDTOWN 관리자</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/pages/admin_portal.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/pages/notice_custom.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/41.3.1/classic/ckeditor.js"></script>
<style>
/* 기존 스타일 유지 또는 외부 CSS 파일로 이동 */
.emp-sidebar .emp-nav-item.active, .emp-sidebar .emp-nav-item.open {
	background-color: #495057;
	color: #fff;
}

.emp-submenu {
	padding-left: 20px;
}

.emp-submenu a.active {
	font-weight: bold;
	color: var(--primary-color, #007bff);
}

.submenu-arrow {
	transition: transform 0.3s ease;
	display: inline-block;
}

.emp-nav-item.open .submenu-arrow {
	transform: rotate(90deg);
}

.current-attachments-list {
	list-style: none;
	padding-left: 0;
}

.current-attachments-list li {
	margin-bottom: 5px;
}

.current-attachments-list button {
	margin-left: 10px;
	background: none;
	border: none;
	color: red;
	cursor: pointer;
}

.current-attachments-list button .fa-times {
	font-size: 0.9em;
}

.file-input-wrapper {
	margin-bottom: 10px;
}
</style>
</head>
<body>
	<div class="emp-container">
		<header class="emp-header">
			<div class="emp-logo">
				<a href="${pageContext.request.contextPath}/admin/main">DDTOWN
					관리자 포털</a>
			</div>
			<div class="emp-user-info">
				<span><i class="fas fa-user-circle"></i> <c:out
						value="${loginAdmin.adminName}" default="관리자" /> (<c:out
						value="${loginAdmin.adminId}" default="admin_user" />)</span> <a
					href="${pageContext.request.contextPath}/admin/logout"
					class="emp-logout-btn" id="adminLogoutBtn"><i
					class="fas fa-sign-out-alt"></i> 로그아웃</a>
			</div>
		</header>
		<div class="emp-body-wrapper">
			<aside class="emp-sidebar">
				<nav class="emp-nav">
					<ul>
						<li><a
							href="${pageContext.request.contextPath}/admin/notice/list"
							class="emp-nav-item active" data-menu="corp"> <i
								class="fas fa-bullhorn"></i> 공지사항 관리
						</a></li>
						<li><a href="#" class="emp-nav-item has-submenu"
							data-menu="cs"> <i class="fas fa-headset"></i> 고객센터 <span
								class="submenu-arrow">&gt;</span>
						</a>
							<ul class="emp-submenu" id="submenu-cs" style="display: none;">
								<li><a
									href="${pageContext.request.contextPath}/admin/cs/faq/list"
									class="emp-nav-item">FAQ 관리</a></li>
								<li><a
									href="${pageContext.request.contextPath}/admin/cs/inquiry/list"
									class="emp-nav-item">1:1문의 관리</a></li>
							</ul></li>
						<li><a href="#" class="emp-nav-item has-submenu"
							data-menu="community"> <i class="fas fa-users"></i> 아티스트 커뮤니티
								관리 <span class="submenu-arrow">&gt;</span>
						</a>
							<ul class="emp-submenu" id="submenu-community"
								style="display: none;">
								<li><a
									href="${pageContext.request.contextPath}/admin/community/member/list"
									class="emp-nav-item">회원관리</a></li>
								<li><a
									href="${pageContext.request.contextPath}/admin/community/artist/list"
									class="emp-nav-item">아티스트 관리</a></li>
								<li><a
									href="${pageContext.request.contextPath}/admin/community/group/list"
									class="emp-nav-item">그룹 관리</a></li>
								<li><a
									href="${pageContext.request.contextPath}/admin/community/report/list"
									class="emp-nav-item">신고 관리</a></li>
								<li><a
									href="${pageContext.request.contextPath}/admin/community/blacklist/list"
									class="emp-nav-item">블랙리스트 관리</a></li>
								<li><a
									href="${pageContext.request.contextPath}/admin/community/apt/list"
									class="emp-nav-item">APT 관리</a></li>
							</ul></li>
						<li><a href="#" class="emp-nav-item has-submenu"
							data-menu="goods"> <i class="fas fa-store"></i> 굿즈샵 관리 <span
								class="submenu-arrow">&gt;</span>
						</a>
							<ul class="emp-submenu" id="submenu-goods" style="display: none;">
								<li><a
									href="${pageContext.request.contextPath}/admin/goods/notice/list"
									class="emp-nav-item">공지사항 관리</a></li>
								<li><a
									href="${pageContext.request.contextPath}/admin/goods/items/list"
									class="emp-nav-item">품목 관리</a></li>
								<li><a
									href="${pageContext.request.contextPath}/admin/goods/categories/list"
									class="emp-nav-item">품목 카테고리 관리</a></li>
								<li><a
									href="${pageContext.request.contextPath}/admin/goods/orders/list"
									class="emp-nav-item">주문내역 관리</a></li>
								<li><a
									href="${pageContext.request.contextPath}/admin/goods/cancelRefund/list"
									class="emp-nav-item">취소 / 환불 관리</a></li>
							</ul></li>
						<li><a href="${pageContext.request.contextPath}/admin/stats"
							class="emp-nav-item" data-menu="stats"> <i
								class="fas fa-chart-line"></i> 통계관리
						</a></li>
					</ul>
				</nav>
			</aside>
			<main class="emp-content">
				<div class="notice-main-box">
					<h2 class="notice-form-title">
						<c:choose>
							<c:when test="${mode == 'edit'}">공지사항 수정</c:when>
							<c:otherwise>공지사항 등록</c:otherwise>
						</c:choose>
					</h2>
					<%-- 폼 전송 시 파일 업로드를 위해 enctype="multipart/form-data" 추가 --%>
					<form class="notice-form" id="noticeForm"
						action="${pageContext.request.contextPath}/admin/notice/save"
						method="post" enctype="multipart/form-data">
						<sec:csrfInput />
						<c:if test="${mode == 'edit'}">
							<input type="hidden" id="entNotiNo" name="entNotiNo"
								value="<c:out value='${noticeVO.entNotiNo}'/>">
						</c:if>
						<input type="hidden" name="mode"
							value="<c:out value='${mode}' default='new'/>">
						<div class="notice-form-group">
							<label for="noticeTitleInput">제목</label> <input type="text"
								id="noticeTitleInput" name="entNotiTitle"
								placeholder="공지사항 제목을 입력하세요"
								value="<c:out value='${noticeVO.entNotiTitle}'/>" required>
						</div>
						<div class="notice-form-group">
							<label for="noticeContentInput">내용</label>
							<textarea id="noticeContentInput" name="entNotiContent"
								placeholder="공지사항 내용을 입력하세요"><c:out
									value='${noticeVO.entNotiContent}' /></textarea>
						</div>
						<div class="notice-form-group">
							<label for="noticeAttachmentsInput">첨부파일</label>
							<div class="file-input-wrapper">
								<input type="file" id="noticeAttachmentsInput" name="boFile"
									multiple>
							</div>
							<c:if test="${mode == 'edit' && not empty noticeVO.attachmentList}">
                                <div id="currentAttachments" style="margin-top:10px;">
                                    <h4>기존 첨부파일</h4>
                                    <ul class="current-attachments-list" id="currentAttachmentsList">
                                    	<c:forEach var="file" items="${noticeVO.attachmentList}">
	                                        <li data-attachDetailNo="${file.attachDetailNo }">
	                                        	<span class="file-info">
	                                        		<c:out value="${file.fileOriginalNm }"/> (<c:out value="${file.fileFancysize }"/>)
	                                        	</span>
	                                       		<button type="button" onclick="deleteFile(event)">X</button> 
	                                        </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </c:if>
						</div>
						<div class="notice-form-actions">
							<button type="button" class="btn btn-detail"
								onclick="
									<c:choose>
										<c:when test='${mode == "edit" }'>
											location.href='${pageContext.request.contextPath}/admin/notice/detail?id=${noticeVO.entNotiNo}';
										</c:when>
										<c:otherwise>
											location.href='${pageContext.request.contextPath}/admin/notice/list';
										</c:otherwise>
									</c:choose>
								">
								<i class="fas fa-times"></i> 취소
							</button>
							<button type="submit" class="btn btn-edit">
								<i class="fas fa-save"></i>
								<c:choose>
									<c:when test="${mode == 'edit'}">수정</c:when>
									<c:otherwise>등록</c:otherwise>
								</c:choose>
							</button>
						</div>
					</form>
				</div>
			</main>
		</div>
	</div>
	<%@ include file="../../modules/footerPart.jsp" %>

	<%@ include file="../../modules/sidebar.jsp" %> 
<script>
document.addEventListener('DOMContentLoaded', function() {

    let editorInstance;
	
    // CKEditor 초기화
    ClassicEditor
        .create( document.querySelector( '#noticeContentInput' ))
        .then( editor => {
            editorInstance = editor;
        })
        .catch( error => {
            console.error( error );
    	});
    
})
</script>
	
</body>
</html>
