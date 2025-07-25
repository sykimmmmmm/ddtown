<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<aside class="emp-sidebar">
   <nav class="emp-nav">
       <ul>

           <li>
               <a href="#" class="emp-nav-item has-submenu" data-menu="community">
                   <i class="fas fa-users"></i> 아티스트 커뮤니티 관리 <span class="submenu-arrow">&gt;</span>
               </a>
               <ul class="emp-submenu" id="submenu-community">
                   <li><a href="${pageContext.request.contextPath}/admin/community/report/list" class="emp-nav-item">신고 관리</a></li>
                   <li><a href="${pageContext.request.contextPath}/admin/community/blacklist/list" class="emp-nav-item">블랙리스트 관리</a></li>
                   <li><a href="${pageContext.request.contextPath}/admin/community/member/main" class="emp-nav-item">회원관리</a></li>
                   <li><a href="${pageContext.request.contextPath}/admin/community/group/list" class="emp-nav-item">그룹 관리</a></li>
                   <li><a href="${pageContext.request.contextPath}/admin/community/artist/list" class="emp-nav-item">아티스트 관리</a></li>
               </ul>
           </li>
           <li>
               <a href="#" class="emp-nav-item has-submenu" data-menu="goods">
                   <i class="fas fa-store"></i> 굿즈샵 관리 <span class="submenu-arrow">&gt;</span>
               </a>
               <ul class="emp-submenu" id="submenu-goods">
                   <li><a href="${pageContext.request.contextPath}/admin/goods/orders/list" class="emp-nav-item">주문내역 관리</a></li>
                   <li><a href="${pageContext.request.contextPath}/admin/goods/cancelRefund/list" class="emp-nav-item">주문 취소 관리</a></li>
                   <li><a href="${pageContext.request.contextPath}/admin/goods/items/list" class="emp-nav-item">품목 관리</a></li>
                   <li><a href="${pageContext.request.contextPath}/admin/goods/notice/list" class="emp-nav-item">공지사항 관리</a></li>
               </ul>
           </li>
<!--            <li> -->
<%--                <a href="${pageContext.request.contextPath}/admin/stats" class="emp-nav-item" data-menu="stats"> --%>
<!--                     <i class="fas fa-chart-line"></i> 통계관리 -->
<!--                 </a> -->
<!--             </li> -->
            <li>
               <a href="${pageContext.request.contextPath}/admin/notice/list" class="emp-nav-item" data-menu="corp">
                   <i class="fas fa-bullhorn"></i> 공지사항 관리
               </a>
           </li>
           <li>
               <a href="#" class="emp-nav-item has-submenu" data-menu="cs">
                   <i class="fas fa-headset"></i> 고객센터 <span class="submenu-arrow">&gt;</span>
               </a>
               <ul class="emp-submenu" id="submenu-cs">
                   <li><a href="${pageContext.request.contextPath}/admin/inquiry/main" class="emp-nav-item">1:1문의 관리</a></li>
                   <li><a href="${pageContext.request.contextPath}/admin/faq/main" class="emp-nav-item">FAQ 관리</a></li>
               </ul>
           </li>
           <li>
                <a href="#" class="emp-nav-item has-submenu" data-menu="approval">
                    <i class="fas fa-file-signature"></i> 전자결재 <span class="submenu-arrow">&gt;</span>
                </a>
                <ul class="emp-submenu" id="submenu-approval">
                    <li><a href="${pageContext.request.contextPath}/emp/edms/approvalBox" class="emp-nav-item">상신 문서함</a></li>
                    <li><a href="${pageContext.request.contextPath}/emp/edms/requestList" class="emp-nav-item">받은 결재/참조 문서함</a></li>
                    <li><a href="${pageContext.request.contextPath}/emp/edms/approvalDraft" class="emp-nav-item">기안서 작성</a></li>
                </ul>
            </li>
            <li>
               <a href="${pageContext.request.contextPath}/emp/main" class="emp-nav-item" data-menu="emp">
                   <i class="fas fa-bullhorn"></i> 직원 포탈 가기
               </a>
           </li>
        </ul>
    </nav>
</aside>