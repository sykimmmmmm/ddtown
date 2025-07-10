<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 상세 - DDTOWN 관리자</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <%-- CSS 파일 경로 수정: ${pageContext.request.contextPath}/resources/css/admin/ 를 기준으로 설정 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/notice_custom.css">
    <%@ include file="../../modules/headerPart.jsp" %>
    <style>
        /* JSP에 직접 스타일을 넣는 것보다 외부 CSS 파일로 분리하는 것이 좋습니다. */
        /* admin_portal.css 또는 notice_custom.css 파일로 이 스타일들을 옮기는 것을 권장합니다. */
        .emp-sidebar .emp-nav-item.active,
        .emp-sidebar .emp-nav-item.open {
            background-color: #495057; /* 예시 활성/오픈 배경색 */
            color: #fff;
        }
        .emp-submenu {
            padding-left: 20px;
        }
        .emp-submenu a.active {
            font-weight: bold;
            color: var(--primary-color, #007bff); /* 기본값 설정 */
        }
        .submenu-arrow {
            transition: transform 0.3s ease;
            display: inline-block; /* transform 적용을 위해 */
        }
        .emp-nav-item.open .submenu-arrow {
            transform: rotate(90deg);
        }
        /* 공지사항 내용 중 이미지 크기 조절 */
        .notice-content-view img {
            max-width: 100%;
            height: auto;
            margin-top: 1em;
            margin-bottom: 1em;
        }
        .notice-attachments-view ul {
            list-style: none;
            padding-left: 0;
        }
        .notice-attachments-view li a {
            text-decoration: none;
            color: #337ab7;
        }
        .notice-attachments-view li a:hover {
            text-decoration: underline;
        }
        .notice-attachments-view .fa-file-download {
            margin-right: 5px;
        }
        .notice-detail-meta span {
            margin-right: 15px;
        }
        .notice-detail-meta #noticeDetailFixed {
            color: var(--primary-color, #007bff);
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="emp-container">
        <header class="emp-header">
            <div class="emp-logo"><a href="${pageContext.request.contextPath}/admin/main">DDTOWN 관리자 포털</a></div>
            <div class="emp-user-info">
                <%-- 로그인한 관리자 정보 (동적으로 표시) --%>
                <span><i class="fas fa-user-circle"></i> <c:out value="${loginAdmin.adminName}" default="관리자"/> (<c:out value="${loginAdmin.adminId}" default="admin_user"/>)</span>
                <a href="${pageContext.request.contextPath}/admin/logout" class="emp-logout-btn" id="adminLogoutBtn"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
            </div>
        </header>
        <div class="emp-body-wrapper">
            <aside class="emp-sidebar">
                <nav class="emp-nav">
                     <ul>
                        <li>
                            <%-- 현재 페이지가 "공지사항 관리"의 하위 페이지이므로 active 클래스 추가 --%>
                            <a href="${pageContext.request.contextPath}/admin/notice/list" class="emp-nav-item active" data-menu="corp"> <i class="fas fa-bullhorn"></i> 공지사항 관리 </a>
                        </li>
                        <li>
                            <a href="#" class="emp-nav-item has-submenu" data-menu="cs">
                                <i class="fas fa-headset"></i> 고객센터 <span class="submenu-arrow">&gt;</span>
                            </a>
                            <ul class="emp-submenu" id="submenu-cs" style="display: none;"> <%-- 초기에는 닫힌 상태로 --%>
                                <li><a href="${pageContext.request.contextPath}/admin/cs/faq/list" class="emp-nav-item">FAQ 관리</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/cs/inquiry/list" class="emp-nav-item">1:1문의 관리</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="emp-nav-item has-submenu" data-menu="community">
                                <i class="fas fa-users"></i> 아티스트 커뮤니티 관리 <span class="submenu-arrow">&gt;</span>
                            </a>
                            <ul class="emp-submenu" id="submenu-community" style="display: none;">
                                <li><a href="${pageContext.request.contextPath}/admin/community/member/list" class="emp-nav-item">회원관리</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/community/artist/list" class="emp-nav-item">아티스트 관리</a></li>
                                 <li><a href="${pageContext.request.contextPath}/admin/community/group/list" class="emp-nav-item">그룹 관리</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/community/report/list" class="emp-nav-item">신고 관리</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/community/blacklist/list" class="emp-nav-item">블랙리스트 관리</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/community/apt/list" class="emp-nav-item">APT 관리</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="emp-nav-item has-submenu" data-menu="goods">
                                <i class="fas fa-store"></i> 굿즈샵 관리 <span class="submenu-arrow">&gt;</span>
                            </a>
                            <ul class="emp-submenu" id="submenu-goods" style="display: none;">
                                <li><a href="${pageContext.request.contextPath}/admin/goods/notice/list" class="emp-nav-item">공지사항 관리</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/goods/items/list" class="emp-nav-item">품목 관리</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/goods/categories/list" class="emp-nav-item">품목 카테고리 관리</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/goods/orders/list" class="emp-nav-item">주문내역 관리</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/goods/cancelRefund/list" class="emp-nav-item">취소 / 환불 관리</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/stats" class="emp-nav-item" data-menu="stats">
                                <i class="fas fa-chart-line"></i> 통계관리
                            </a>
                        </li>
                    </ul>
                </nav>
            </aside>
            <main class="emp-content">
                <div class="notice-main-box">
                    <c:choose>
                        <c:when test="${not empty noticeVO}">
                            <div class="notice-detail-header">
                                <h2 class="notice-page-title"><c:out value="${noticeVO.entNotiTitle}"/></h2>
                                <div class="notice-detail-meta">
                                    <span>작성자: <c:out value="${noticeVO.empUsername}" default="관리자"/></span>
                                    <span>등록일: <fmt:formatDate value="${noticeVO.entNotiRegDate}" pattern="yyyy-MM-dd"/></span>
                                </div>
                            </div>
                            <div class="notice-content-view">
                                ${noticeVO.entNotiContent}
                            </div>

                            <c:if test="${not empty noticeVO.attachmentList}">
                                <div class="notice-attachments-view">
                                    <h4><i class="fas fa-paperclip"></i> 첨부파일</h4>
                                    <ul>
                                        <c:forEach var="file" items="${noticeVO.attachmentList}">
                                            <li>
                                                <a href="${pageContext.request.contextPath}/admin/file/download/${file.attachDetailNo}"
                                                download="<c:out value='${file.fileOriginalNm}'/>">
                                                    <i class="fas fa-file-download"></i> <c:out value="${file.fileOriginalNm}"/>
                                                    <c:out value="${file.fileFancysize}" />
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </c:if>

                            <div class="notice-actions-bottom">
                                <button class="btn btn-edit" onclick="location.href='${pageContext.request.contextPath}/admin/notice/form?id=${noticeVO.entNotiNo}&mode=edit'"><i class="fas fa-edit"></i> 수정</button>
                                <form action="${pageContext.request.contextPath }/admin/notice/noticeDelete" method="post" style="display:inline;">
                                	<sec:csrfInput/>
                                	<input type="hidden" name="id" value="${noticeVO.entNotiNo }">
                                	<button type="submit" class="btn btn-delete" onclick="return confirm('정말 삭제하시겠습니까? 삭제 후 되돌릴 수 없습니다.');">
                                	<i class="fas fa-trash-alt"></i> 삭제</button>
                                </form>
                                <c:url var="finalListUrl" value="/admin/notice/list">
                                      <c:if test="${not empty searchWord}">
                                          <c:param name="searchWord" value="${searchWord}"/>
                                      </c:if>
                                      <c:if test="${not empty currentPage && currentPage > 1}">
                                          <c:param name="currentPage" value="${currentPage}"/>
                                      </c:if>
                                  </c:url>
                               	<button class="btn btn-detail" onclick="location.href='${finalListUrl}'"><i class="fas fa-list"></i> 목록</button>
                            </div>
                        </c:when>
                        <c:otherwise>
                             <div class="notice-detail-header">
                                <h2 class="notice-page-title">오류</h2>
                             </div>
                             <div class="notice-content-view">
                                <p style="text-align:center; color:red;">요청하신 공지사항을 찾을 수 없거나 잘못된 접근입니다.</p>
                             </div>
                             <div class="notice-actions-bottom">
                                <button class="btn btn-detail" onclick="location.href='${pageContext.request.contextPath}/admin/notice/list'"><i class="fas fa-list"></i> 목록으로</button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %> 
<script>
document.addEventListener('DOMContentLoaded', function() {

	//페이지네이션 처리 시작
	const searchForm = document.getElementById("searchForm");
    const pageInput = searchForm.querySelector("input[name='currentPage']"); // hidden input의 name 사용
    const paginationControls = document.getElementById("pagingArea");

    if (paginationControls) { // paginationControls 요소가 존재할 때만 이벤트 리스너 추가
        paginationControls.addEventListener("click", function(e) {
            e.preventDefault(); // 기본 링크 이동 방지

            // 클릭된 요소가 'page-link' 클래스를 가지고 있고 'A' 또는 'SPAN' 태그인지 확인
            if (e.target.classList.contains("page-link") && (e.target.nodeName === "A" || e.target.nodeName === "SPAN")) {
                pageInput.value = e.target.dataset.page; // data-page 속성 값으로 hidden input 업데이트
                searchForm.submit(); // 폼 제출
            }
        });
    }
    // 페이지네이션 처리 끝
    
    
});
</script>
</body>
</html>
