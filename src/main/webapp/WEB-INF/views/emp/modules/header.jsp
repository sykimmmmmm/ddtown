<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<header class="emp-header">
    <div class="emp-logo">
        <a href="/emp/main">DDTOWN 직원 포털</a>
    </div>
    <div class="emp-user-info">
		<sec:authentication property="principal.username" var="username"/>
		<sec:authentication property="principal.employeeVO" var="empVO"/>
		<c:set value="${empVO.userTypeCode }" var="utc"/>
		<span><i class="fas fa-user-circle"></i><c:out value="${utc eq 'UTC004' ? '관리자' : '직원'  }" default="관리자"/> ${empVO.peoName} <small>${empVO.empDepartNm} ${empVO.empPositionNm}</small> (<c:out value="${username}" default="admin_user"/>)</span>
		<form action="/logout" method="post">
			<sec:csrfInput/>
			<button type="submit" class="btn emp-logout-btn"><i class="fas fa-sign-out-alt"></i> 로그아웃</button>
		</form>
		<a href="${pageContext.request.contextPath}/admin/logout" class="emp-logout-btn" id="adminLogoutBtn"></a>
	</div>
</header>