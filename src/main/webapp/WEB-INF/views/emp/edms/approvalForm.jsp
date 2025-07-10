<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기안서 작성</title>
<%@ include file="../../modules/headerPart.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/approval_draft_style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    /* 테마 색상 변수 선언 (최소한으로 유지) */
    :root {
        --theme-purple: #8a2be2;
        --theme-purple-darker: #6c1bb1;
        --theme-purple-lighter: #f3eaff;
        --theme-blue: #007bff;
        --theme-blue-darker: #0056b3;
        --theme-blue-lighter: #e0f2ff;
    }
    /* 커스텀 포커스 스타일 (테마 색상 적용) */
    .form-control.custom-focus:focus,
    .form-select.custom-focus:focus {
        border-color: var(--theme-blue);
        box-shadow: 0 0 0 0.2rem rgba(138, 43, 226, 0.25);
    }
    /* 커스텀 버튼 스타일 (테마 색상 적용) */
    .btn-blue-theme {
        background-color: var(--theme-blue);
        color: #fff;
        border-color: var(--theme-blue);
    }
    .btn-outline-blue-theme {
        color: var(--theme-blue);
        border-color: var(--theme-blue);
    }
    .btn-outline-blue-theme:hover {
        background-color: var(--theme-blue-lighter);
        color: var(--theme-blue);
        border-color: var(--theme-blue);
    }
    /* 커스텀 테두리 색상 (테마 색상 적용) */
    .border-blue-theme {
        border-color: var(--theme-blue) !important;
    }
    .btn-blue-theme:hover {
        background-color: var(--theme-blue-darker);
        border-color: var(--theme-blue-darker);
        color: #fff;
    }
    /* 커스텀 테두리 색상 (테마 색상 적용) */
    .btn-blue-theme {
    	background-color: var(--theme-blue);
        color: #fff;
        border-color:var(--theme-blue) !important;
    }
    .btn-blue-theme:hover {
        background-color: var(--theme-blue-darker);
        border-color: var(--theme-blue-darker);
        color: #fff;
    }
	/* approvalLineModal 에 적용될 스크롤바 숨김 및 스크롤 설정 */
	/* 부서, 직원, 결재라인, 참조자 목록 스크롤바 숨김 (공통) */
	#modalDepartmentList::-webkit-scrollbar,
	#modalEmployeeList::-webkit-scrollbar,
	#modalApprovalLineList::-webkit-scrollbar,
	#modalReferrerList::-webkit-scrollbar {
	    display: none; /* Chrome, Safari 등 */
	}
	#modalDepartmentList,
	#modalEmployeeList,
	#modalApprovalLineList,
	#modalReferrerList {
	    scrollbar-width: none; /* Firefox */
	    -webkit-overflow-scrolling: touch; /* iOS 스크롤 부드럽게 */
	}
	/* 각 스크롤 영역에 overflow-y 적용 */
	#approvalLineModal .modal-body #modalDepartmentList,
	#approvalLineModal .modal-body #modalEmployeeList,
	#approvalLineModal .modal-body #modalApprovalLineList,
	#approvalLineModal .modal-body #modalReferrerList {
	    overflow-y: auto; /* 내용이 넘칠 때 스크롤바 표시 */
	    flex-grow: 1; /* 부모 컨테이너 내에서 가능한 모든 공간을 차지하도록 확장 */
	}
	/* 추가적으로, .card-body 내 flex-grow를 정확히 적용하여 내용이 확장되도록 합니다. */
	#approvalLineModal .col-md-3 .card-body,
	#approvalLineModal .col-md-5 .card-body,
	#approvalLineModal .col-md-3 .card.shadow-sm.mb-3.flex-grow-1 .card-body, /* 결재라인 card-body */
	#approvalLineModal .col-md-3 .card.shadow-sm.flex-grow-1 .card-body /* 참조자 card-body */
	{
	    display: flex;
	    flex-direction: column;
	    flex-grow: 1; /* card-body가 남은 공간을 차지하도록 */
	}
	.p-3.rounded.mb-4 {
	    background-color: #ffffff; /* 섹션 배경 흰색 */
	    border: 1px solid #e9ecef; /* 연한 테두리 */
	    border-radius: 0.5rem !important;
	    padding: 1.5rem !important;
	    box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075) !important; /* 미세한 그림자 */
	    margin-bottom: 2rem !important; /* 아래쪽 여백 강조 */
	}
	h5.text-dark.border-bottom.pb-2.mb-3 {
	    font-size: 1.2rem;
	    font-weight: 600;
	    color: #495057 !important;
	    border-bottom: 1px solid #dee2e6 !important;
	    padding-bottom: 0.75rem !important;
	    margin-bottom: 1.5rem !important;
	    display: flex;
	    align-items: center;
	}
	#customFileBtn {
	    background-color: var(--theme-blue); /* 파란색 테마 */
	    color: #fff;
	    border: none;
	    padding: 0.5rem 1rem;
	    border-radius: 0.25rem;
	    cursor: pointer;
	    transition: background-color 0.2s;
	    font-size: 0.9rem;
	}
	#customFileBtn:hover {
	    background-color: var(--theme-blue-darker);
	}
	#approversDisplay,
	#referrersDisplay {
	    min-height: 40px; /* 최소 높이 설정 */
	    border: 1px dashed #ced4da; /* 점선 테두리 */
	    border-radius: 0.25rem;
	    padding: 0.5rem;
	    align-items: center; /* 세로 중앙 정렬 */
	    color: #6c757d; /* 안내 문구 색상 */
	    font-size: 0.9rem;
	}
	#approversDisplay span,
	#referrersDisplay span {
	    display: inline-block; /* 각 항목을 인라인 블록으로 */
	    background-color: var(--theme-blue-lighter); /* 연한 보라색 배경 */
	    color: var(--theme-blue-darker);
	    padding: 0.3em 0.6em;
	    border-radius: 0.25em;
	    margin-right: 0.5em; /* 항목 간 간격 */
	    font-size: 0.85em;
	    font-weight: 500;
	}
	#approvalLineModal .modal-content {
	    border-radius: 0.5rem;
	}
	#approvalLineModal .modal-header {
	    border-bottom: 1px solid #e9ecef;
	    padding: 1rem 1.5rem;
	}
	#approvalLineModal .modal-title {
	    font-size: 1.3rem;
	    font-weight: 600;
	}
	#approvalLineModal .modal-body {
	    padding: 1.5rem;
	    display: flex;
	    flex-direction: column;
	}
	#approvalLineModal .modal-footer {
	    border-top: 1px solid #e9ecef;
	    padding: 1rem 1.5rem;
	}
	/* Card headings inside modal */
	#approvalLineModal .panel-heading {
	    font-size: 1.1rem;
	    font-weight: 600;
	    color: #343a40;
	    margin-bottom: 0.75rem !important;
	}
	#approvalLineModal .panel-heading.d-flex {
	    align-items: center;
	    justify-content: space-between;
	}
	#approvalLineModal #empSearch {
	    max-width: 60%; /* 검색창 너비 조정 */
	    margin-left: auto;
	    font-size: 0.85rem;
	    padding: 0.375rem 0.75rem;
	}
	#modalDepartmentList .list-group-item,
	#modalEmployeeList .list-group-item {
	    font-size: 0.9rem;
	    padding: 0.5rem 0.75rem;
	    border: none; /* 기본 테두리 제거 */
	    border-bottom: 1px solid #eee; /* 아래쪽 테두리만 */
	    cursor: pointer;
	    transition: background-color 0.2s, color 0.2s;
	}
	#modalDepartmentList .list-group-item:last-child,
	#modalEmployeeList .list-group-item:last-child {
	    border-bottom: none; /* 마지막 항목은 테두리 없음 */
	}
	#modalDepartmentList .list-group-item:hover,
	#modalEmployeeList .list-group-item:hover {
	    background-color: var(--theme-blue-lighter);
	    color: var(--theme-blue);
	}
	#modalEmployeeList .list-group-item-select {
	    background-color: var(--theme-blue) !important;
	    color: #fff !important;
	    font-weight: 500;
	}
	/* Approval/Referrer Add Buttons in Modal */
	#modalAddApproversBtn,
	#modalAddReferrersBtn {
	    width: 80px; /* 버튼 너비 고정 */
	    font-weight: 600;
	}
 	#modalApprovalLineList .p-1,
 	#modalReferrerList .p-1 {
 	    background-color: #f8f9fa; /* 연한 배경 */
 	    color: #343a40;
 	    white-space: nowrap;
 	}
	#modalApprovalLineList .p-1 span.info small,
	#modalReferrerList .p-1 span.info small {
	    color: #6c757d;
	}
	.removeApprovalBtn,
	.removeReferenceBtn {
	    cursor: pointer;
	    color: #dc3545; /* 빨간색 X 아이콘 */
	    font-size: 1.1rem;
	    margin-left: 10px;
	    transition: color 0.2s;
	}
	.removeApprovalBtn:hover,
	.removeReferenceBtn:hover {
	    color: #c82333;
	}
	.error-message {
	    color: #dc3545;
	    font-size: 0.85em;
	    margin-top: 0.25rem;
	    display: block; /* 줄바꿈 */
	}
	/* Bootstrap Overrides for custom-focus */
	.form-control:focus, .form-select:focus {
	    box-shadow: none; /* Bootstrap 기본 그림자 제거 */
	}
	.btn-primary {
		background-color: #0d6efd;
	}
	.btn-primary:hover {
		background-color: #234aad;
	}
</style>
</head>
<body class="bg-body-secondary">
	<sec:authentication property="principal.employeeVO" var="employeeVO"/>
	<div class="emp-container w-100">
        <%@ include file="../modules/header.jsp" %>
        <div class="emp-body-wrapper w-100">
            <%@ include file="../modules/aside.jsp" %>
			<form id="edmsApprovalForm" action="/emp/edms/registApproval" method="post" encType="multipart/form-data" class="w-100" style="font-size: large;">
			<sec:csrfInput/>
			<div id="hiddenBox"></div>
			<input type="hidden" name="empUsername" value="${employeeVO.empUsername}">
			<input type="hidden" id="edmsContent" name="edmsContent"/>
			<input type="hidden" name="edmsStatCode" id="edmsStatCode"/>
			<main class="container p-lg-4 p-md-3 p-2 w-100" style="max-width: none; margin-top: 20px;">
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">전자결재</a></li>
					  <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/emp/edms/approvalBox" style="color:black;">상신 문서함</a></li>
					  <li class="breadcrumb-item active" aria-current="page">기안서 작성</li>
					</ol>
				</nav>
			    <div class="row">
			        <div class="col-lg-12 mb-12">
			        	<div class="d-flex align-items-center">
				            <h2 class=" text-dark mb-4">기안서 작성</h2>
				            <div class="d-flex align-items-center gap-2" style="margin-left: auto;">
					            <button type="button" class="btn btn-secondary btn-sm" id="auditionBtn" style="font-size: large;">오디션 기획</button>
					            <button type="button" class="btn btn-secondary btn-sm" id="artistBtn" style="font-size: large;">아티스트 기획</button>
					            <button type="button" class="btn btn-secondary btn-sm" id="concertBtn" style="font-size: large;">콘서트 기획</button>
				            </div>
			        	</div>
			            <div class="card shadow-sm">
			                <div class="card-body p-4">
			                    <div class="mb-3">
			                        <label for="formNo" class="form-label fw-semibold text-dark">문서종류</label>
			                        <select id="formNo" name="formNo" class="form-select custom-focus ">
			                        	<c:forEach items="${formList }" var="formVO" varStatus="vs">
											<option value="${formVO.formNo }" <c:if test="${vs.first }">selected</c:if> >${formVO.formNm }</option>
										</c:forEach>
			                        </select>

			                    </div>

			                    <div class="p-3 rounded mb-4">
			                        <h5 class="text-dark border-bottom pb-2 mb-3">문서 정보</h5>
			                        <div class="row mb-2 align-items-center">
			                            <label for="draftDept" class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">기안 부서:</label>
			                            <div class="col-lg-10 col-md-9">
			                                <input type="text" class="form-control form-control-sm custom-focus" value="${employeeVO.empDepartNm }" readonly>
			                            </div>
			                        </div>
			                        <div class="row mb-2 align-items-center">
			                            <label for="empUsername" class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">기안자 이름:</label>
			                            <div class="col-lg-10 col-md-9">
			                                <input type="text" class="form-control form-control-sm custom-focus " id="empUsername" value="${employeeVO.peoName }" readonly>
			                            </div>
			                        </div>
			                        <div class="row mb-2 align-items-center">
			                            <label for="edmsTitle" class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">기안서 제목:</label>
			                            <div class="col-lg-10 col-md-9">
			                                <input type="text" id="edmsTitle" name="edmsTitle" class="form-control form-control-sm custom-focus ">
			                            </div>
			                        </div>
			                        <div class="row align-items-center">
			                            <label for="edmsUrgenYn" class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">긴급도</label>
			                            <div class="col-lg-10 col-md-9">
									        <select id="edmsUrgenYn" name="edmsUrgenYn" class="form-select form-control-sm custom-focus w-auto">
									            <option value="N">보통</option>
									            <option value="Y" <c:if test="${edmsVO.edmsUrgenYn eq 'Y'}">selected</c:if>>긴급</option>
									        </select>
									    </div>
			                        </div>
			                    </div>

								<div id="content"></div>

								<div class="p-3 rounded mb-4">
									<h5 class="text-dark border-bottom pb-2 mb-3">파일</h5>
									<div class="d-flex mb-2 align-items-center">
										<label for="myFile" class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">파일 첨부</label>
										<input type="file" id="addFile" name="addFileList" multiple style="display: none;">
										<button type="button" class="ea-btn primary btn-sm" id="customFileBtn">파일 선택</button>
										<span id="fileNameDisplay" class="file-name-display">선택된 파일 없음</span>
									</div>
								</div>

		                        <div class="p-3 rounded mb-4">
								    <h5 class="text-dark border-bottom pb-2 mb-3">
								    	결재선 정보
  									    <button type="button" class="btn btn-outline-blue-theme fw-semibold me-auto" id="approverBtn" data-bs-toggle="modal" data-bs-target="#approvalLineModal">결재선 설정</button>
								    </h5>
								    <div class="row mb-2 align-items-center">
								        <label class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">결재자</label>
								        <div class="col-lg-10 col-md-9 d-flex flex-wrap gap-2" id="approversDisplay">
								            결재자 2명을 선택해주세요
								        </div>
								    </div>
								    <div class="row align-items-center">
								        <label class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">참조자</label>
								        <div class="col-lg-10 col-md-9 d-flex flex-wrap gap-2" id="referrersDisplay">
								        	참조자를 2명이상 선택해주세요
								        </div>
								    </div>
								</div>

			                    <div class="d-flex justify-content-end gap-2 mt-3">
			                        <button type="submit" class="btn btn-blue-theme fw-semibold" ><i class="fa-solid fa-arrow-up"></i> 상신</button>
			                        <a class="btn btn-secondary fw-semibold" href="${pageContext.request.contextPath}/emp/edms/approvalBox" ><i class="fa-solid fa-xmark"></i> 취소</a>
			                    </div>
			                </div>
			            </div>
			        </div>
			    </div>
			</main>
			</form>
		</div>
	</div>

<!-- modal  -->
<div class="modal fade w-100" style="z-index:1060;"id="approvalLineModal" tabindex="-1" aria-labelledby="approvalLineModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-xl">
		<div class="modal-content w-100" style="max-width: 1200px;">
			<div class="modal-header">
				<h5 class="modal-title" id="approvalLineModalLabel">결재선 설정</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body" style="max-height: 700px;">
			    <div class="row g-3 d-flex h-100">
			        <div class="col-md-3 d-flex flex-column">
			        	<div class="card shadow-sm h-100 d-flex flex-column">
			                <div class="card-body d-flex flex-column flex-grow-1">
			                    <h6 class="panel-heading border-bottom pb-2 mb-2">부서</h6>
			                    <div id="modalDepartmentList" class="list-group flex-grow-1" style="overflow-y: auto; max-height: 400px;">
			                    </div>
			                </div>
			            </div>
			        </div>

			        <div class="col-md-5 d-flex flex-column">
			        	<div class="card shadow-sm h-100 d-flex flex-column">
			                <div class="card-body d-flex flex-column">
			                	<div class="panel-heading border-bottom pb-2 mb-2 d-flex">
				                    <h6>직원 목록</h6>
				                    <input type="text" id="empSearch" class="form-control form-control-sm"
				                     style="width:70%; margin-left:auto;" placeholder="부서 선택 후 이름을 검색해주세요"/>
			                	</div>
			                    <div id="modalEmployeeList" class="list-group mb-3 flex-grow-1" style="overflow-y: auto; max-height: 400px;">
			                        <p class="text-muted p-3 text-center">왼쪽에서 부서를 선택해주세요.</p>
			                    </div>
			                </div>
			            </div>
			        </div>

			        <div class="col-md-1 d-flex flex-column justify-content-center">
				        <div class="d-flex flex-column align-items-center">
					        <button type="button" class="btn btn-sm btn-primary mb-5" id="modalAddApproversBtn">결재</button>
					        <button type="button" class="btn btn-sm btn-secondary" id="modalAddReferrersBtn">참조</button>
				    	</div>
					</div>

			        <div class="col-md-3 d-flex flex-column">
			        	<div class="card shadow-sm mb-3 flex-grow-1">
				        	<div class="card-body d-flex flex-column">
			                    <h6 class="panel-heading border-bottom pb-2 mb-2">결재라인</h6>
			                    <div id="modalApprovalLineList" class="list-group list-group-flush flex-grow-1" style="overflow-y: auto;">
			                    	<c:choose>
										<c:when test="${empty edmsVO.approverList}">
										</c:when>
										<c:otherwise>
											<c:forEach items="${edmsVO.approverList}" var="approver">
												<div class="p-1" >
													<span class="info"><span class="p-1">${approver.empName} ${approver.empPositionNm} <small>(${approver.empDepartNm})</small></span></span>
													<span class="removeApprovalBtn" style="cursor:pointer;" data-emp-username="${approver.empUsername}" data-emp-position-code="${approver.empPositionCode}" >
														<i class="bi bi-x"></i>
													</span>
												</div>
											</c:forEach>
										</c:otherwise>
									</c:choose>
			                    </div>
			                </div>
			            </div>
			            <div class="card shadow-sm flex-grow-1">
			            	<div class="card-body d-flex flex-column">
			                    <h6 class="panel-heading border-bottom pb-2 mb-2">참조자</h6>
			                    <div id="modalReferrerList" class="list-group list-group-flush flex-grow-1" style="overflow-y: auto;">
				                    <c:choose>
										<c:when test="${empty edmsVO.referenceList}">
										</c:when>
										<c:otherwise>
											<c:forEach items="${edmsVO.referenceList}" var="reference">
												<div class="p-1" >
													<span class="info"> <span class="p-1">${reference.empName} ${reference.empPositionNm}  <small>(${reference.empDepartNm})</small></span></span>
													<span class="removeReferenceBtn" style="cursor:pointer;" data-emp-username="${reference.empUsername}" data-emp-position-code="${reference.empPositionCode}">
														<i class="bi bi-x"></i>
													</span>
												</div>
											</c:forEach>
										</c:otherwise>
									</c:choose>
			                    </div>
			                </div>
			            </div>
			        </div>
			    </div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="closeBtn">닫기</button>
				<button type="button" class="btn btn-primary" id="saveApprovalLineBtn">저장</button>
			</div>
		</div>
	</div>
</div>

</body>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<script type="text/javascript">
$(function(){

	let edmsApprovalForm = $("#edmsApprovalForm");
	let content = $("#content");
	let formNoEl = $("#formNo");
	let submitBtn = $("#submitBtn");
	let approverBtn = $("#approverBtn");
	let approvalLineModal = $("#approvalLineModal");

	// 문서 종류에 따른 양식 변경
	formNoEl.on("change",function(){
		let formNo = $(this).val()
		formDetail(formNo);
	})

	formDetail(formNoEl.val());

	let addFile = $("#addFile");// 파일인풋
	let customFileBtn = $("#customFileBtn"); // 커스텀 파일 선택
	// 파일 첨부 리스트 보기
	customFileBtn.on("click",function(){
		addFile.click();
	})
	// 파일 첨부 이벤트
	addFile.on("change",function(){
		let files = this.files;
		const maxSize = 2 * 1024 * 1024;
		if(files.length > 0){
			let fileNames = [];
			for(let file of files){
				fileNames.push(file.name);
			}
			let text  = '';
			if(files.length == 1){
				text = fileNames[0];
			}else{
				text = fileNames[0] + " 외 " + (fileNames.length -1) + "개"
			}
			$("#fileNameDisplay").text(text);
		}else{
			$("#fileNameDisplay").text("선택된 파일 없음");
		}
	});

	let removeFileBtn = $("#removeFileBtn");
	removeFileBtn.on("click",function(){
		let fileDetailNo = $(this).data("fileDetailNo");
		let html = ``;
		html += `<input type="hidden" name="deleteFileList" value="\${fileDetailNo}">`
		edmsApprovalForm.append(html);
	});



	// 결재선 관련
	// 결재선 지정 모달
	approverBtn.on("click",function(){
		approvalLineModal.modal('show');
		displayDepartList();
	})
	let empListData = []; // 결재선 직원 목록 필터를 위한 데이터담을곳
	const modalDepartmentList = $("#modalDepartmentList"); // 부서 목록
	const modalEmployeeList = $("#modalEmployeeList"); // 직원목록
	const modalAddApproversBtn = $("#modalAddApproversBtn"); // 결재 추가 버튼
	const modalAddReferrersBtn = $("#modalAddReferrersBtn"); // 참조 추가 버튼
	const modalApprovalLineList = $("#modalApprovalLineList"); // 결재자 리스트
	const modalReferrerList = $("#modalReferrerList"); // 참조자 리스트
	const closeBtn = $("#closeBtn"); //  모달 닫기 버튼
	const saveApprovalLineBtn = $("#saveApprovalLineBtn"); //  결재자 참조자 저장 버튼

	// 직원목록 검색 기능
	let isComposing = false; // 한글 합성

	$("#empSearch").on("compositionstart",function(e){
		isComposing = true;
	}).on("compositionend",function(e){
		isComposing = false;
		searchName();
	}).on("input",function(){
		if(!isComposing){
			searchName();
		}
	})

	// 부서 목록 클릭시 해당 부서 직원 목록 보이기
	modalDepartmentList.on("click",".list-group-item",function(){
		const empDepartCode = $(this).data("empDepartCode");
		displayEmpList(empDepartCode)
	})

	// 직원 클릭시 해당 직원 포커스
	modalEmployeeList.on("click",".list-group-item",function(){
		$(".list-group-item",modalEmployeeList).removeClass("list-group-item-select");
		$(this).addClass("list-group-item-select");

	})

	modalAddApproversBtn.on("click",function(){
		const targetEl = modalEmployeeList.children('ul').children("li.list-group-item-select");
		const targetUsername = targetEl.data("empUsername");
		const targetEmpPositionCode = targetEl.data("empPositionCode");
		const targetName = targetEl.html();
		// 직원 선택후 가능
		if(targetEl[0] == null){
			sweetAlert("error", "직원을 선택해주세요");
			return false;
		}
		// 결재자리스트에 해당 직원 있는지 확인
		if(modalApprovalLineList.children("div").children(`span[data-emp-username="\${targetUsername}"]`).length > 0){
			sweetAlert("error","이미 선택된 결재자입니다");
			return false;
		}
		// 참조자리스트에 해당 직원 있는지 확인
		if(modalReferrerList.children("div").children(`span[data-emp-username="\${targetUsername}"]`).length > 0){
			sweetAlert("error","이미 선택된 결재자입니다");
			return false;
		}
		// 결재자리스트 2명까지 선택 가능
		if(modalApprovalLineList.children().length>1){
			sweetAlert("error", "최대 2명까지 선택해주세요");
			return false;
		}
		//modalApprovalLineList
		// 없으면 추가
		let html = ``;
		html += `
			<div class="p-1" style="position:relative;" >
				<span class="info"><span class="p-1">\${targetName}</span></span>
				<span class="removeApprovalBtn"
				data-emp-username="\${targetUsername}"
				data-emp-position-code="\${targetEmpPositionCode}"
				style="position:absolute; top:-11px; right:-3px;"
				>
					<i class="bi bi-x"></i>
				</span>
			</div>
		`;
		modalApprovalLineList.append(html);
	})

	modalAddReferrersBtn.on("click",function(){
		const targetEl = modalEmployeeList.children('ul').children("li.list-group-item-select");
		const targetUsername = targetEl.data("empUsername");
		const targetEmpPositionCode = targetEl.data("empPositionCode");
		const targetName = targetEl.html();
		// 직원 선택 후 가능
		if(targetEl[0] == null){
			sweetAlert("error", "직원을 선택해주세요");
			return false;
		}
		// 참조자리스트에 해당 직원 있는지 확인
		if(modalReferrerList.children("div").children(`span[data-emp-username="\${targetUsername}"]`).length > 0){
			sweetAlert("error","이미 선택된 참조자입니다");
			return false;
		}
		// 결재자리스트에 해당 직원 있는지 확인
		if(modalApprovalLineList.children("div").children(`span[data-emp-username="\${targetUsername}"]`).length > 0){
			sweetAlert("error","이미 선택된 결재자입니다");
			return false;
		}

		//modalReferrerList
		// 없으면 추가
		let html = ``;
		html += `
			<div class="p-1" style="position:relative;" >
				<span class="info"><span class="p-1">\${targetName}</span></span>
				<span class="removeReferenceBtn"
					data-emp-username="\${targetUsername}"
					data-emp-position-code="\${targetEmpPositionCode}"
					style="position:absolute; top:-11px; right:-3px;"
					>
					<i class="bi bi-x"></i>
				</span>
			</div>
		`;
		modalReferrerList.append(html);
	})

	// 결재자 취소 이벤트
	let ApproverHideList = []
	modalApprovalLineList.on("click",".removeApprovalBtn",function(){
		let targetEl = $(this).parent("div");
		ApproverHideList.push(targetEl)
		targetEl.remove();
	})

	// 참조자 취소 이벤트
	let reffererHideList = []
	modalReferrerList.on("click",".removeReferenceBtn",function(){
		let targetEl = $(this).parent("div");
		reffererHideList.push(targetEl);
		targetEl.remove();
	});

	const approversDisplay = $("#approversDisplay"); // 결재자 목록
	const referrersDisplay = $("#referrersDisplay"); // 참조자 목록

	// 결재자 및 참조자 저장 버튼
	saveApprovalLineBtn.on("click",function(){
		// 결재자 저장
		let hiddenBox = $("#hiddenBox");
		hiddenBox.html("");
		let addApproverCount = 0;
		let approverList = modalApprovalLineList.find("div");
		let displayHtml = '';
		if(approverList.length == 0){
			approvalLineModal.modal("hide");
			return;
		}
		approverList.each((i,v) => {
			let dataSpan = $(v).find("span.removeApprovalBtn");
			const empUsername = dataSpan.data("empUsername");
			const empPositionCode = dataSpan.data("empPositionCode");
			let html = ``;
			html += `<input type="hidden" name="addApproverList[\${addApproverCount}].empUsername" value="\${empUsername}">`
			html += `<input type="hidden" name="addApproverList[\${addApproverCount}].empPositionCode" value="\${empPositionCode}">`
			addApproverCount++;

			let infoSpan = $(v).find("span.info");
			displayHtml += infoSpan.html();

			hiddenBox.append(html);
		})
		approversDisplay.html(displayHtml);

		// 참조자 저장
		let addRefererCount = 0;
		let referenceList = modalReferrerList.find("div");
		if(referenceList.length == 0){
			approvalLineModal.modal("hide");
			return;
		}
		displayHtml = '';
		referenceList.each((i,v) => {
			let dataSpan = $(v).find("span.removeReferenceBtn");
			const empUsername = dataSpan.data("empUsername");
			const empPositionCode = dataSpan.data("empPositionCode");
			let html = ``;
			html += `<input type="hidden" name="addReferenceList[\${addRefererCount}].empUsername" value="\${empUsername}">`
			html += `<input type="hidden" name="addReferenceList[\${addRefererCount}].empPositionCode" value="\${empPositionCode}">`
			addRefererCount++;

			let infoSpan = $(v).find("span.info");
			displayHtml += infoSpan.html();

			hiddenBox.append(html);
		})
		referrersDisplay.html(displayHtml);

		approvalLineModal.modal("hide");
		reffererHideList = [];
		ApproverHideList = [];
	});

	// 모달 닫기 버튼 클릭시 모달 닫힘
	closeBtn.on('click',function(){
		approvalLineModal.modal('hide');
		ApproverHideList.forEach(v=>{
			modalApprovalLineList.append(v)
		})
		reffererHideList.forEach(v=>{
			modalReferrerList.append(v)
		})
	})

	// 결재선 관련 끝

	// 밸리데이션 검증
	edmsApprovalForm.validate({
		rules: {
			edmsTitle : {
                required: true,
                maxlength: 60
            }
		},
        messages: {
        	edmsTitle: {
                required: "제목을 입력해주세요.",
                maxlength: "제목은 최대 {0}자까지 입력 가능합니다."
        	}
        },
        errorElement: 'span',
        errorClass: 'error-message',
        highlight: function(element, errorClass, validClass) {
            $(element).addClass('is-invalid');
        },
        unhighlight: function(element, errorClass, validClass) {
            $(element).removeClass('is-invalid');
        },
        // sweetAlert과 연동하여 오류 메시지 표시
        showErrors: function(errorMap, errorList) {
            if (this.numberOfInvalids() > 0) {
                let errorMessage = "";
                for (let i = 0; i < errorList.length; i++) {
                    errorMessage += errorList[i].message + "<br>";
                }
                sweetAlert("error", errorMessage);
            }
            this.defaultShowErrors(); // 기본 오류 메시지 표시 로직도 실행 (span 태그로 표시)
        },
        submitHandler: function(form) {
        	let edmsContent = $("#edmsContent");
    	    let edmsStatCode = $("#edmsStatCode");

    	    if(approversDisplay.children('span').length != 2){
    	    	sweetAlert("error","결재자를 총 2명 지정해주세요");
    	    	return false;
    	    }
    	    if(referrersDisplay.children('span').length < 2){
    	    	sweetAlert("error","참조자 최소 2명 지정해주세요");
    	    	return false;
    	    }

    	    // content의 복사본을 만들어서 원본을 훼손하지 않고 작업합니다.
    	    let contentForSubmission = content.clone();

    	    // 1. input[type="text"], input[type="date"] 태그들을 hidden input으로 변경하고 값 표시
    	    contentForSubmission.find('input[type="text"], input[type="date"]').each(function() {
    	        let value = $(this).val();
    	        let name = $(this).attr('name');
    	        let id = $(this).attr('id');

    	        // 기존 input 태그를 hidden input으로 변경하고 값을 유지
    	        let hiddenInputHtml = `<input type="hidden" name="\${name || ''}" id="\${id || ''}" value="\${value}">`;

    	        // 값을 보여줄 텍스트 (span 태그로 감싸서)
    	        let visibleTextHtml = `<span>\${value}</span>`;

    	        $(this).replaceWith(hiddenInputHtml + visibleTextHtml); // 기존 태그를 hidden input과 값으로 대체
    	    });

    	    // 2. textarea 태그들을 hidden input으로 변경하고 값 표시
    	    contentForSubmission.find('textarea').each(function() {
    	        let value = $(this).val();
    	        let name = $(this).attr('name');
    	        let id = $(this).attr('id');

    	        // 기존 textarea 태그를 hidden input으로 변경하고 값을 유지
    	        let hiddenInputHtml = `<input type="hidden" class="txa" name="\${name || ''}" id="\${id || ''}" value="\${value}">`;

    	        // 값을 보여줄 텍스트 (span 태그로 감싸서)
    	        let visibleTextHtml = `<span>\${value}</span>`;

    	        $(this).replaceWith(hiddenInputHtml + visibleTextHtml); // 기존 태그를 hidden input과 값으로 대체
    	    });

    	    edmsStatCode.val("ESC001");
    	    // 수정된 컨텐츠 내용을 첨부합니다.
    	    edmsContent.val(contentForSubmission.html());

            form.submit();
        }
	})



	// 오디션 기안서 양식
	auditionData = {
		formNo : 1,
		edmsTitle : "하반기 오디션 기획안입니다.",
		edmsUrgenYn : 'N',
		auditionName : "하반기 DDTOWN 오디션 너의 꿈을 펼쳐봐",
		auditionPurpose : "신규 아티스트 모집을 위한 오디션",
		targetAudience : "20세 이하의 남성",
		keyRequirements : "즉석 라이브 가능한 자",
		recruitmentPeriod : "2025.08.01 ~ 2025.09.01",
		reviewSchedule : "2025.09.20",
		finalAnnouncement : "2025.10.01",
		processMethod : "온라인 플랫폼을 통한 비대면 오디션",
		evaluationCriteria : "가창력 (30%) / 퍼포먼스 (30%) / 스타성 (40%)",
		totalBudget : "10,000,000원",
		budgetDetails : `홍보 및 공고 : 3,000,000원
심사위원 수당 : 2,000,000원
운영비 : 5,000,000원
		`
	};

	// 아티스트 기안서 양식
	artistData = {
		formNo : 2,
		edmsTitle : "아티스트 등록안입니다.",
		edmsUrgenYn : 'Y',
		artistName : "박건우",
		activityField : "솔로 가수",
		contractType : "전속 아티스트 계약",
		contractPeriod : "2025.08.01 ~ 2025.09.01",
		keyPerformance : "파워보컬과 매력넘치는 개성"
	}

	// 콘서트 기안서 양식
	concertData = {
		formNo : 3,
		edmsTitle : "박건우 아티스트 콘서트 기획안입니다.",
		edmsUrgenYn : 'N',
		concertTitle : "박건우 단독 콘서트",
		concertDate : "2025/07/07 오후 6:00",
		concertVenue : "블루스퀘어 SOL 트래블 홀",
		mainArtist : "박건우",
		expectedAudience : "1,000명",
		totalBudget : "2천만원",
		promotionChannels : "유튜브",
		notes : "아티스트와 팬들간의 소통"
	}

	$("#auditionBtn").on("click",function(){
		let {formNo, edmsTitle, edmsUrgenYn, auditionName, auditionPurpose
			,targetAudience, keyRequirements, recruitmentPeriod, reviewSchedule, finalAnnouncement
			,processMethod, evaluationCriteria, totalBudget, budgetDetails} = auditionData
		$("#formNo").val(formNo);
		formDetail(formNo);
		setTimeout(()=>{
			$("#edmsTitle").val(edmsTitle);
			$("#edmsUrgenYn").val(edmsUrgenYn);
			$("#auditionName").val(auditionName);
			$("#auditionPurpose").val(auditionPurpose);
			$("#targetAudience").val(targetAudience);
			$("#keyRequirements").val(keyRequirements);
			$("#recruitmentPeriod").val(recruitmentPeriod);
			$("#reviewSchedule").val(reviewSchedule);
			$("#finalAnnouncement").val(finalAnnouncement);
			$("#processMethod").val(processMethod);
			$("#evaluationCriteria").val(evaluationCriteria);
			$("#totalBudget").val(totalBudget);
			$("#budgetDetails").val(budgetDetails);
		},300)
	})

	$("#artistBtn").on("click",function(){
		let {formNo, edmsTitle, edmsUrgenYn, artistName, activityField
			,contractType, contractPeriod, keyPerformance} = artistData
		$("#formNo").val(formNo);
		formDetail(formNo);
		setTimeout(()=>{
			$("#edmsTitle").val(edmsTitle);
			$("#edmsUrgenYn").val(edmsUrgenYn);
			$("#artistName").val(artistName);
			$("#activityField").val(activityField);
			$("#contractType").val(contractType);
			$("#contractPeriod").val(contractPeriod);
			$("#keyPerformance").val(keyPerformance);
		},300)
	})

	$("#concertBtn").on("click",function(){
		let {formNo, edmsTitle, edmsUrgenYn, concertTitle, concertDate
			,concertVenue, mainArtist, expectedAudience,totalBudget, promotionChannels,notes} = concertData
		$("#formNo").val(formNo);
		formDetail(formNo);
		setTimeout(()=>{
			$("#edmsTitle").val(edmsTitle);
			$("#edmsUrgenYn").val(edmsUrgenYn);
			$("#concertTitle").val(concertTitle);
			$("#concertDate").val(concertDate);
			$("#concertVenue").val(concertVenue);
			$("#mainArtist").val(mainArtist);
			$("#expectedAudience").val(expectedAudience);
			$("#totalBudget").val(totalBudget);
			$("#promotionChannels").val(promotionChannels);
			$("#notes").val(notes);
		},300)
	})

	// 부서목록 보이기
	function displayDepartList(){
		$.ajax({
			url : "/api/emp/edms/departList",
			type : "get",
			success : function(res){
				let html = ``;
				html += `<ul class="list-group">`;
				for(let data of res){
					html += `
						<li class="list-group-item list-group-item-action" data-emp-depart-code="\${data.commCodeDetNo}">\${data.description}</li>
					`
				}
				html += `</ul>`
				modalDepartmentList.html(html);
			}
		});
	}

	//해당 부서 클릭시 직원목록 보이기
	function displayEmpList(empDepartCode){
		$.ajax({
			url : "/api/emp/edms/empList?empDepartCode="+empDepartCode,
			type : "get",
			success : function(res){
				empListData = res;
				createList(empListData);
			}
		});
	}
	function searchName(){
		let keyword = $("#empSearch").val();
		if(keyword.trim() != ""){
			let filteredList = empListData.filter(v => {
				let name = v.peoName;
				if(name.includes(keyword)){
					return true;
				}else{
					return false;
				}
			})
			createList(filteredList)
		}else{
			createList(empListData)
		}
	}

	function createList(list){
		let html = ``;
		html += `<ul class="list-group">`;
		for(let data of list){
			const {empPositionNm, empUsername,peoName, empPositionCode,empDepartNm} = data;
			html += `
				<li class="list-group-item list-group-item-action" data-emp-username="\${empUsername}" data-emp-position-code="\${empPositionCode}">\${peoName} \${empPositionNm} <small>(\${empDepartNm})</small></li>
			`
		}
		html += `</ul>`
		modalEmployeeList.html(html);
	}

	// 해당 폼 클릭시 폼정보 불러오기
	function formDetail(formNo){
		let data = {
				formNo : formNo
		};
		$.ajax({
			url : "/api/emp/edms/form",
			type : "post",
			beforeSend : function(xhr) {
		        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		    },
		    contentType : "application/json; charset=utf-8",
		    data : JSON.stringify(data),
		    success : function(res){
		    	$("#content").html(res.formContent);
		    },
		    error : function(err){
		    	console.err(err);
		    }
		});
	}
});
</script>
</html>