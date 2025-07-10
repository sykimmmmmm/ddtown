<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 관리자 - 기업 공지사항 관리</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/pagination.css">
    <%@ include file="../../modules/headerPart.jsp" %>
    <style>
        /* JSP에 직접 스타일을 넣는 것보다 외부 CSS 파일로 분리하는 것이 좋습니다. */
        .alert {
		    padding: 15px; /* 내부 여백 */
		    margin-bottom: 20px; /* 아래쪽 여백 */
		    border: 1px solid transparent; /* 테두리 */
		    border-radius: 4px; /* 모서리 둥글게 */
		    text-align: center; /* 텍스트 가운데 정렬 */
		    font-weight: bold; /* 글자 굵게 */
		    display: block;
		}
		.alert-success {
		    color: #155724;        /* 글자색: 짙은 녹색 */
		    background-color: #d4edda; /* 배경색: 연한 녹색 (가장 중요) */
		    border: 1px solid #c3e6cb; /* 테두리: 연한 녹색 테두리 */
		}

		.alert-danger {
		    color: #721c24;
		    background-color: #f8d7da;
		    border: 1px solid #f5c6cb;
		}

        .notice-table .notice-title {
            text-align: left;
            max-width: 400px; /* 제목이 너무 길 경우 ...으로 표시되도록 */
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .notice-table .text-center {
            text-align: center;
        }
        .notice-important-row td {
            font-weight: bold;
            background-color: #fffbe6; /* 중요 공지 배경색 예시 */
        }
        .notice-important-row .fa-thumbtack {
            color: var(--primary-color, #007bff);
        }
        #noticeAddButton {
		    width: auto; /* 내용에 맞게 너비 자동 조절 */
		    min-width: max-content; /* 최소 너비를 내용만큼 확보 (예: "검색" 두 글자) */
		    white-space: nowrap; /* 글자가 두 줄로 나뉘는 것을 방지 */
		    writing-mode: horizontal-tb !important; /* 혹시라도 writing-mode가 세로로 설정된 경우 강제 변경 */
		    padding-left: 12px; /* 버튼 내부 여백 (기존 .ea-btn 스타일에 따라 조절) */
		    padding-right: 12px; /* 버튼 내부 여백 (기존 .ea-btn 스타일에 따라 조절) */
		}
		.ea-section-footer-actions {
			display: flex;
			justify-content: flex-end;
			margin-top: 15px;
			padding-bottom: 10px;
		}
		.notice-summary-status {
			display: flex;
			justify-content: flex-start;
			align-items: center;
			gap: 25px;
			padding: 15px 0;
		}
		.notice-summary-status .stat-item {
        	white-space: nowrap; /* 텍스트가 줄바꿈되지 않도록 방지 */
    	}

    	.notice-summary-status .stat-value {
	        font-weight: bold;
	        color: #007bff; /* 통계 값 강조 (선택 사항) */
	        margin-left: 5px; /* 숫자와 단위 사이 간격 */
    	}
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>

            <main class="emp-content" style="font-size: large;">
	            <c:if test="${not empty msg }">
	            	<div class="alert alert-success" role="alert">
	            		<c:out value="${msg }"/>
	            	</div>
	            </c:if>
                <section class="ea-section">
                    <div class="ea-section-header">
                    	<div class="ea-header-left-content">
                    		<h2>기업 공지사항 관리</h2>

                    		<div class="notice-summary-status">
		                   		<div class="stat-item">
		                   			<strong>총 공지사항 : </strong><span class="stat-value"><c:out value="${totalNoticeCnt }"></c:out></span>건
		                   		</div>
		                   		<div class="stat-item">
		                   			<strong>[공지] : </strong><span class="stat-value"><c:out value="${gongjiCnt }"></c:out></span>건
		                   		</div>
		                   		<div class="stat-item">
		                   			<strong>[안내] : </strong><span class="stat-value"><c:out value="${annaeCnt }"></c:out></span>건
		                   		</div>
		                   	</div>
                    	</div>

	                    <div class="ea-header-actions">
	                        <form class="input-group input-group-sm" method="get" id="searchForm">
	                        	<input type="hidden" name="currentPage" value="1" id="page">
	                            <input type="text" id="searchWord" name="searchWord" value="${pagingVO.searchWord }" class="ea-search-input" placeholder="제목을 입력해주세요.">
	                            <div class="input-group-append">
									<button type="submit" class="ea-btn primary">
										<i class="fas fa-search"></i>검색
									</button>
								</div>
	                        </form>
	                    </div>
                   	</div>

                    <table class="ea-table" id="noticeListTable">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>제목</th>
                                <th>등록일</th>
                            </tr>
                        </thead>
                        <tbody id="noticeTableBody">
                            <c:if test="${empty pagingVO.dataList}">
                                <tr>
                                    <td colspan="5" class="text-center">등록된 공지사항이 없습니다.</td>
                                </tr>
                            </c:if>
                            <c:forEach var="notice" items="${pagingVO.dataList}" varStatus="status">
                                <tr>
                                    <td class="text-center"><c:out value="${notice.entNotiNo}"/></td>
                                    <td class="notice-title" id="noticeTitle">
                                    	 <c:url var="finalDetailUrl" value="/admin/notice/detail?id=${notice.entNotiNo}">
	                                        <c:if test="${not empty pagingVO.searchWord}">
	                                            <c:param name="searchWord" value="${pagingVO.searchWord}"/>
	                                        </c:if>
	                                        <c:if test="${not empty pagingVO.currentPage && pagingVO.currentPage > 1}">
	                                            <c:param name="currentPage" value="${pagingVO.currentPage}"/>
	                                        </c:if>
	                                    </c:url>
                                        <a href="${finalDetailUrl}">
                                            <c:out value="${notice.entNotiTitle}"/>
                                        </a>
                                    </td>
                                    <td class="text-center"><fmt:formatDate value="${notice.entNotiRegDate}" pattern="yyyy-MM-dd"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="d-flex justify-content-center align-items-center">
	                    <div class="pagination-container" id="pagingArea" style="margin-left: auto;">
				             ${pagingVO.pagingHTML}
				        </div>
				        <div class="ea-section-footer-actions" style="margin-left: auto;">
				        	<a class="ea-btn primary" href="/admin/notice/register" id="noticeAddButton"><i class="fas fa-plus"></i> 등록 </a>
	               		</div>
                    </div>
               	</section>
            </main>
          </div>
        </div>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<script>
document.addEventListener('DOMContentLoaded', function() {

	$(function(){
	    const pagingArea = $('#pagingArea');
	    const searchForm = $('#searchForm');

	    if(pagingArea.length > 0) {
	        pagingArea.on('click', 'a', function(event) {
	            event.preventDefault();
	            const page = $(this).data('page'); // data-page 속성에서 클릭된 페이지 번호 가져옴

	            // 검색폼의 현재 searchType과 searchWord 값을 가져옴
	            const searchType = searchForm.find('select[name="searchType"]').val();
	            const searchWord = searchForm.find('input[name="searchWord"]').val();

	            // 페이지 이동을 위한 URL
	            let targetPageUrl = '${pageContext.request.contextPath}/admin/notice/list?currentPage=' + page;


	            if (searchType && searchWord && searchWord.trim() !== '') {
	                targetPageUrl += '&searchType=' + encodeURIComponent(searchType);
	                targetPageUrl += '&searchWord=' + encodeURIComponent(searchWord);
	            }
// 	            console.log("페이지네이션 클릭: " + targetPageUrl);
	            window.location.href = targetPageUrl;
	        });
	    }
	});

    // "검색" 버튼 클릭 시 currentPage를 1로 초기화 (새로운 검색)
    searchForm.querySelector("button[type='submit']").addEventListener("click", function() {
        pageInput.value = "1";
    });
});
</script>
</body>
</html>
