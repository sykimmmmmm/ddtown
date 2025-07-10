<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<style>
    /* 폼 전체를 flex 컨테이너로 설정 */
    #orderSearchForm {
        display: flex;
        flex-wrap: wrap; /* 필요하면 줄바꿈 허용 */
        align-items: center; /* 세로 중앙 정렬 */
        justify-content: space-between; /* 양 끝 정렬 (중요!) */
        gap: 15px; /* 주요 그룹들 사이의 간격 */
        margin-bottom: 20px; /* 폼 아래 여백 */
    }

    /* 주문일 필드 그룹 */
    .date-filter-group {
        display: flex;
        align-items: center;
        gap: 8px; /* label, input, ~ 사이의 간격 */
    }

    /* 검색어 입력 및 버튼 그룹 */
    .search-input-group {
        display: flex;
        align-items: center;
        gap: 8px; /* input, button 사이의 간격 */
    }

    /* 개별 요소 스타일 (기존 코드에서 가져왔거나 추가) */
    .ea-date-input,
    .ea-search-input {
        padding: 5px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }

    .ea-btn {
        padding: 8px 12px;
        background-color: #234AAD; /* 예시 색상 */
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .ea-btn i {
        margin-right: 5px;
    }

    .text-center {
        text-align: center;
    }

    /* 주문 상태 뱃지 스타일 (예시) */
    .order-status-badge {
        display: inline-block;
        padding: 4px 8px;
        border-radius: 12px;
        font-size: 0.85em;
        color: #fff;
        font-weight: bold;
    }

    .status-OSC00 { background-color: #4CAF50; } /*  기본 상태 : 초록색 */
    .status-OSC001 { background-color: #2196F3; } /* 결제 완료 : 파란색 */ 
    .status-OSC008 { background-color: #FF4D4D; } /* 취소/환불 : 빨간색 */
    .label {
    	font-weight: var(--font-weight-bold);
    }
    </style>

<div class="mypage-section-header">
	<h3>주문 내역</h3>
</div>
<form id="orderSearchForm" action="${pageContext.request.contextPath}/mypage/orders" method="get" class="search-filter-controls">
        <input type="hidden" name="currentPage" id="orderCurrentPage" value="${not empty orderPagingVO.currentPage ? orderPagingVO.currentPage : 1}" />
        
        <div class="date-filter-group">
	        <label class="label" for="orderDateStart">주문일:</label>
	        <input type="date" id="orderDateStart" name="orderDateStart" class="ea-date-input" value="${currentOrderDateStart}"> ~
	        <input type="date" id="orderDateEnd" name="orderDateEnd" class="ea-date-input" value="${currentOrderDateEnd}">
        </div>
        <div class="search-input-group">
	        <input type="text" id="orderSearchWord" name="searchWord" class="ea-search-input" placeholder="상품명을 입력해주세요." value="${currentSearchWord}">
	        <button type="submit" id="orderSearchButton" class="ea-btn"><i class="fas fa-search"></i> 검색</button>
		</div>
</form>

    <table class="ea-table">
        <thead>
            <tr>
                <th>주문일자</th>
                <th>상품명</th>
                <th>결제 금액</th>
                <th>주문 상태</th>
            </tr>
        </thead>
        <tbody>

            <c:choose>
                <c:when test="${not empty orderPagingVO and not empty orderPagingVO.dataList}">
                    <c:forEach var="order" items="${orderPagingVO.dataList}">
                        <tr>
                            <td><fmt:formatDate value="${order.orderDate}" pattern="yy.MM.dd"/></td>
                            <td>
                                <c:if test="${not empty order.orderDetailList}">
                                    <a href="${pageContext.request.contextPath}/goods/order/detail?orderNo=${order.orderNo}">${order.orderDetailList[0].goodsNm}
	                                    <c:if test="${order.orderDetailList.size() > 1}">
	                                        외 ${order.orderDetailList.size() - 1}건
	                                    </c:if>
                                    </a>
                                </c:if>
                                <c:if test="${empty order.orderDetailList}">
                                    (상품 정보 없음)
                                </c:if>
                            </td>
                            <td><fmt:formatNumber value="${order.orderTotalPrice}" pattern="#,###원"/></td>
                            <td>
                                <span class="order-status-badge status-${order.orderStatCode}">
                                    ${order.orderStatName}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="6" class="text-center">주문 내역이 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

	<div class="d-flex justify-content-center ea-pagination" id="orderPaginationArea">
	    <c:if test="${not empty orderPagingVO}">
	        ${orderPagingVO.getPagingHTML()} <%-- ⭐⭐⭐ 이 부분이 페이징 HTML을 화면에 그립니다. ⭐⭐⭐ --%>
	    </c:if>
	    <c:if test="${empty orderPagingVO}"></c:if>
	</div>
<script>
//CSRF 토큰 설정
const csrfToken = $("meta[name='_csrf']").attr("content");
const csrfHeader = $("meta[name='_csrf_header']").attr("content");
const headers = {};
if (csrfToken && csrfHeader) {
    headers[csrfHeader] = csrfToken;
}
    document.addEventListener('DOMContentLoaded', function() {
        const orderSearchForm = document.getElementById("orderSearchForm");
        const orderCurrentPageInput = document.getElementById("orderCurrentPage");
        const orderPaginationArea = document.getElementById("orderPaginationArea");

        document.getElementById('orderSearchWord').value = '${currentSearchWord}';
        //document.getElementById('orderSearchStatType').value = '${currentSearchStatType}';
        document.getElementById('orderDateStart').value = '${currentOrderDateStart}';
        document.getElementById('orderDateEnd').value = '${currentOrderDateEnd}';

        if (orderPaginationArea) {
            orderPaginationArea.addEventListener("click", function(e) {
                e.preventDefault(); 
                const clickedElement = e.target.closest(".page-link"); 
                if (clickedElement && clickedElement.dataset.page) { 
                    orderCurrentPageInput.value = clickedElement.dataset.page; 
                    orderSearchForm.submit(); 
                }
            });
        }
    });

    function resetOrderSearchForm() {
        document.getElementById('orderSearchWord').value = '';
        //document.getElementById('orderSearchStatType').value = '';
        document.getElementById('orderDateStart').value = '';
        document.getElementById('orderDateEnd').value = '';
        document.getElementById('orderCurrentPage').value = '1'; 
        document.getElementById('orderSearchForm').submit();
    }
</script>