<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 관리 - DDTOWN 관리자 시스템</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <%@ include file="../../../modules/headerPart.jsp" %>
    <style>
        a {
            text-decoration: none;
        }
        .goods-notice-section {
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .emp-search-input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 250px;
        }
        .emp-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .emp-table th, .emp-table td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            text-align: center;
        }
        .emp-table th {
            background-color: #f8f9fa;
            font-weight: 600;
        }
        .emp-table tr:hover {
            background-color: #f8f9fa;
        }
        .doc-link {
            color: #333;
            text-decoration: none;
        }
        .doc-link:hover {
            color: #007bff;
            text-decoration: underline;
        }
        /* 기존 emp-pagination 대신 ea-pagination 사용 */
        .ea-pagination { /* emp-pagination 대신 ea-pagination으로 변경 */
            display: flex;
            justify-content: center;
            gap: 5px;
            margin-top: 20px;
        }
        .ea-pagination a, .ea-pagination span { /* a, span 태그 모두 스타일 적용 */
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-decoration: none;
            color: #333;
            cursor: pointer; /* span도 클릭 가능하도록 */
        }
        .ea-pagination a.active, .ea-pagination span.active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .emp-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        .emp-btn.primary {
            background-color: #007bff;
            color: white;
        }
        .emp-btn.primary:hover {
            background-color: #0056b3;
        }
        .emp-btn.sm {
            padding: 6px 12px;
            font-size: 12px;
        }
        /* 검색 드롭다운 스타일 추가 */
        .search-select { /* 이 스타일은 더 이상 필요 없을 가능성이 높습니다. */
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-right: 5px; /* 입력 필드와의 간격 */
        }
        /* --- 이 부분을 추가해주세요 --- */
		.emp-table td:nth-child(2) { /* 테이블의 두 번째 컬럼(제목)에 해당하는 td만 선택 */
		    text-align: left;
		}

		/* 기존 d-flex justify-content-center align-items-center를 사용하는 부모 컨테이너에 적용 */
		.d-flex.justify-content-center.align-items-center {
		    justify-content: space-between; /* 양 끝 정렬 */
		    width: 100%; /* 부모 컨테이너가 가로 전체를 차지하도록 보장 */
		    padding: 15px 0; /* 상하 여백 추가 (필요시 조절) */
		}

		/* 페이지네이션을 중앙에 더 가깝게 만들기 위해 flexbox 정렬을 활용합니다. */
		.ea-pagination {
		    flex-grow: 1; /* 남은 공간을 차지하여 중앙 정렬에 기여 */
		    display: flex; /* 내부 ul을 정렬하기 위해 flex 컨테이너로 만듦 */
		    justify-content: center; /* 내부 ul (페이지 링크들)을 중앙 정렬 */
		    margin: 0; /* 기본 마진 제거 */
		    padding: 0;
		}

		/* 등록 버튼 컨테이너를 오른쪽으로 밀착시키기 위해 */
		.button-container-right {
		    flex-shrink: 0; /* 줄어들지 않도록 설정 */
		    margin-left: auto; /* 남은 공간을 모두 가져가서 오른쪽으로 밀착시킵니다. */
		}
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../../modules/aside.jsp" %>
            <main class="emp-content" style="font-size: large;">
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/admin/goods/notice/list" style="color:black;">굿즈샵 관리</a></li>
                        <li class="breadcrumb-item active" aria-current="page">공지사항 관리</li>
                    </ol>
                </nav>
                <section class="goods-notice-section">
                    <div class="emp-section-header" style="display:flex;justify-content:space-between;align-items:center;">
					    <h2>공지사항 관리</h2>
					    <div class="emp-header-actions" style="display:flex;gap:8px;">
					        <form id="searchForm" action="/admin/goods/notice/list" method="get" style="display:flex;align-items:center;">
					            <input type="hidden" name="currentPage" value="${pagingVO.currentPage}">
					            <input type="hidden" name="searchType" value="title"> <%-- 제목 검색 고정 --%>
					            <input type="text" name="searchWord" id="goodsNoticeSearchInput" class="emp-search-input"
					                   placeholder="제목을 입력하세요." value="${pagingVO.searchWord}">
					            <button type="submit" id="goodsNoticeSearchBtn" class="emp-btn"><i class="fas fa-search"></i> 검색</button>
					        </form>
					    </div>
					</div>
                    <table class="emp-table" style="margin-top:20px;">
                        <thead>
                            <tr>
                                <th style="width:8%;">번호</th>
                                <th>제목</th>
                                <th style="width:12%;">작성일</th>
                                <th style="width:12%;">수정일</th>
                            </tr>
                        </thead>
                        <tbody id="goodsNoticeTableBody">
                            <c:choose>
                                <c:when test="${not empty pagingVO.dataList}">
                                    <c:forEach var="notice" items="${pagingVO.dataList}">
                                        <tr>
                                            <td>${notice.goodsNotiNo}</td>
                                            <td><a href="/admin/goods/notice/detail?id=${notice.goodsNotiNo}&currentPage=${pagingVO.currentPage}&searchType=${pagingVO.searchType}&searchWord=${pagingVO.searchWord}" class="doc-link">${notice.goodsNotiTitle}</a></td>
                                            <td><fmt:formatDate value="${notice.goodsRegDate}" pattern="yyyy-MM-dd"/></td>
                                            <td><fmt:formatDate value="${notice.goodsModDate}" pattern="yyyy-MM-dd"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7">등록된 공지사항이 없습니다.</td> </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    <div class="d-flex justify-content-center align-items-center">
                    	<div class="ea-pagination" id="pagingArea">
					        ${pagingVO.pagingHTML }
					    </div>

					    <div class="button-container-right">
					        <a href="/admin/goods/notice/form" class="emp-btn primary"><i class="fas fa-plus"></i>등록</a>
					    </div>
					</div>
                </section>
            </main>
        </div>
    </div>
<%@ include file="../../../modules/footerPart.jsp" %>

<%@ include file="../../../modules/sidebar.jsp" %>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const searchForm = document.getElementById("searchForm");
    const pageInput = searchForm.querySelector("input[name='currentPage']");
    const searchTypeInput = searchForm.querySelector("input[name='searchType']"); // searchType input 추가
    const searchWordInput = searchForm.querySelector("input[name='searchWord']"); // searchWord input 추가
    const paginationControls = document.getElementById("pagingArea");

    if (paginationControls) {
        paginationControls.addEventListener("click", function(e) {
            e.preventDefault();

            const clickedLink = e.target.closest('a.page-link');

            if (clickedLink && clickedLink.dataset.page) {
                const parentLi = clickedLink.closest('.page-item');

                if (parentLi && !parentLi.classList.contains('disabled')) {
                    const newPage = clickedLink.dataset.page;
//                     console.log("클릭된 페이지 링크: " + newPage);
//                     console.log("폼의 current page 값 (변경 전): " + pageInput.value);

                    // pageInput.value = newPage; // 이 부분 주석 처리

                    // URL을 직접 구성하여 페이지 이동
                    const baseUrl = searchForm.action;
                    const queryParams = new URLSearchParams();
                    queryParams.append('currentPage', newPage);
                    queryParams.append('searchType', searchTypeInput.value); // hidden input의 값 사용
                    queryParams.append('searchWord', searchWordInput.value); // text input의 값 사용

                    const newUrl = baseUrl + '?' + queryParams.toString();
//                     console.log("새 URL로 이동 시도:", newUrl);
                    window.location.href = newUrl; // 페이지 강제 이동

//                     console.log("폼의 current page 값 (변경 후): " + pageInput.value); // 이 메시지는 window.location.href 이후에 실행되지 않을 수 있음
                } else {
//                     console.log("비활성화된 페이지 링크(disabled) 또는 현재 페이지(active)를 클릭했습니다. 이동하지 않습니다.");
                }
            }
        });
    }
});
</script>
</body>
</html>