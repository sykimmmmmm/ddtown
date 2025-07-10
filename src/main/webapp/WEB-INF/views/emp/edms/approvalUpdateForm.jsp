<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기안서 수정</title>
<%@ include file="../../modules/headerPart.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/approval_draft_style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.js"></script>
<style>
    /* 테마 색상 변수 선언 (최소한으로 유지) */
    :root {
        --theme-purple: #8a2be2;
        --theme-purple-darker: #6c1bb1;
        --theme-purple-lighter: #f3eaff;
        --theme-blue: #007bff;
        --theme-blue-darker: #0069d9;
        --theme-blue-lighter: #f3eaff;

    }

    /* 커스텀 포커스 스타일 (테마 색상 적용) */
    .form-control.custom-focus:focus,
    .form-select.custom-focus:focus {
        border-color: var(--theme-purple);
        box-shadow: 0 0 0 0.2rem rgba(138, 43, 226, 0.25);
    }

    /* 커스텀 버튼 스타일 (테마 색상 적용) */
    .btn-purple-theme {
        background-color: var(--theme-purple);
        color: #fff;
        border-color: var(--theme-purple);

    }
    .btn-purple-theme:hover {
        background-color: var(--theme-purple-darker);
        border-color: var(--theme-purple-darker);
        color: #fff;
    }

    .btn-outline-purple-theme {
        color: var(--theme-purple);
        border-color: var(--theme-purple);

    }
    .btn-outline-purple-theme:hover {
        background-color: var(--theme-purple-lighter);
        color: var(--theme-purple);
        border-color: var(--theme-purple);
    }
	/* 커스텀 버튼 스타일 (테마 색상 적용) */
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

    /* 커스텀 테두리 색상 (테마 색상 적용) */
    .border-purple-theme {
        border-color: var(--theme-purple) !important;
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
	    scrollbar-width: none;
	    -webkit-overflow-scrolling: touch;
	}

	/* 각 스크롤 영역에 overflow-y 적용 */
	#approvalLineModal .modal-body #modalDepartmentList,
	#approvalLineModal .modal-body #modalEmployeeList,
	#approvalLineModal .modal-body #modalApprovalLineList,
	#approvalLineModal .modal-body #modalReferrerList {
	    overflow-y: auto;
	    flex-grow: 1;
	}

	/* 추가적으로, .card-body 내 flex-grow를 정확히 적용하여 내용이 확장되도록 합니다. */
	#approvalLineModal .col-md-3 .card-body,
	#approvalLineModal .col-md-5 .card-body,
	#approvalLineModal .col-md-3 .card.shadow-sm.mb-3.flex-grow-1 .card-body,
	#approvalLineModal .col-md-3 .card.shadow-sm.flex-grow-1 .card-body
	{
	    display: flex;
	    flex-direction: column;
	    flex-grow: 1; /* card-body가 남은 공간을 차지하도록 */
	}
</style>
</head>
<body class="bg-body-secondary">
<sec:authentication property="principal.employeeVO" var="employeeVO"/>
<div class="emp-container w-100">
	<%@ include file="../modules/header.jsp" %>
	<div class="emp-body-wrapper w-100">
		<%@ include file="../modules/aside.jsp" %>
		<form id="edmsApprovalForm" action="${pageContext.request.contextPath}/emp/edms/update" method="post" encType="multipart/form-data" class="w-100">
			<sec:csrfInput/>
			<input type="hidden" id="formNo" name="formNo" value="${edmsVO.formNo}"/>
			<input type="hidden" id="edmsNo" name="edmsNo" value="${edmsVO.edmsNo}"/>
			<input type="hidden" id="empUsername" name="empUsername" value="${edmsVO.empUsername}"/>
			<input type="hidden" id="edmsContent" name="edmsContent"/>
			<input type="hidden" name="edmsStatCode" id="edmsStatCode"/>
			<input type="hidden" name="fileGroupNo" value="${edmsVO.fileGroupNo}">
			<div id="hiddenBox"></div>
			<main class="container p-lg-4 p-md-3 p-2 w-100">
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">전자결재</a></li>
					  <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/emp/edms/approvalBox" style="color:black;">상신 문서함</a></li>
					  <li class="breadcrumb-item active" aria-current="page">기안서 작성</li>
					</ol>
				</nav>
			    <div class="row">
			        <div class="col-lg-12 mb-12">
			            <h2 class=" text-dark mb-4">기안서 작성</h2>
			            <div class="card shadow-sm">
			                <div class="card-body p-4">
			                    <div class="mb-3">
			                        <label for="formNo" class="form-label fw-semibold text-dark">문서종류</label>
			                        <input type="text" class="form-control" value="${edmsVO.formNm}" readonly>

			                    </div>

			                    <div class="p-3 rounded mb-4">
			                        <h5 class="text-dark border-bottom pb-2 mb-3">문서 정보</h5>
			                        <div class="row mb-2 align-items-center">
			                            <label for="draftDept" class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">기안 부서</label>
			                            <div class="col-lg-10 col-md-9">
			                                <input type="text" class="form-control form-control-sm custom-focus" value="${employeeVO.empDepartNm }" readonly>
			                            </div>
			                        </div>
			                        <div class="row mb-2 align-items-center">
			                            <label for="empUsername" class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">기안자 이름</label>
			                            <div class="col-lg-10 col-md-9">
			                                <input type="text" class="form-control form-control-sm custom-focus " id="empUsername" value="${employeeVO.peoName }" readonly>
			                            </div>
			                        </div>
			                        <div class="row mb-2 align-items-center">
			                            <label for="edmsTitle" class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">기안서 제목</label>
			                            <div class="col-lg-10 col-md-9">
			                                <input type="text" id="edmsTitle" name="edmsTitle" class="form-control form-control-sm custom-focus" value="${edmsVO.edmsTitle}">
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

								<div id="content">
									${edmsVO.edmsContent}
								</div>

								<div class="p-3 rounded mb-4">
									<h5 class="text-dark border-bottom pb-2 mb-3">파일</h5>
									<div class="d-flex mb-2 align-items-center">
										<label for="myFile" class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">파일 첨부</label>
										<input type="file" id="addFile" name="addFileList" multiple style="display: none;">
										<button type="button" class="ea-btn primary btn-sm" id="customFileBtn">파일 선택</button>
										<span id="fileNameDisplay" class="file-name-display" style="width:150px;">선택된 파일 없음</span>
									</div>
									<div class="d-flex mb-2 align-items-center">
			                            <label class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">첨부파일 리스트</label>
			                            <div class="col-lg-10 col-md-9">
			                            	<c:choose>
			                            		<c:when test="${empty edmsVO.fileList}">
			                            			첨부된 파일이없습니다.
			                            		</c:when>
			                            		<c:otherwise>
				                            		<c:forEach items="${edmsVO.fileList}" var="file">
				                            			<div class="p-1" >
															${file.fileOriginalNm}<small>(${approver.empDepartNm})</small>
															<span class="removeFileBtn" style="cursor:pointer;" data-attach-detail-no="${file.attachDetailNo}" >
																<i class="bi bi-x"></i>
															</span>
														</div>
				                            		</c:forEach>
			                            		</c:otherwise>
			                            	</c:choose>
			                            </div>
			                        </div>
								</div>

		                        <div class="p-3 rounded mb-4">
								    <h5 class="text-dark border-bottom pb-2 mb-3">
								    	결재선 정보
  									    <button type="button" class="btn btn-outline-purple-theme fw-semibold me-auto" id="approverBtn" data-bs-toggle="modal" data-bs-target="#approvalLineModal">결재선 설정</button>
								    </h5>
								    <div class="row mb-2 align-items-center">
								        <label class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">결재자</label>
								        <div class="col-lg-10 col-md-9 d-flex flex-wrap gap-2" id="approversDisplay">
											<c:choose>
												<c:when test="${empty edmsVO.approverList}">
													결재자 정보 없음
												</c:when>
												<c:otherwise>
													<c:forEach items="${edmsVO.approverList}" var="approver">
														<span class="p-1">${approver.empName} ${approver.empPositionNm} <small>(${approver.empDepartNm})</small></span>
													</c:forEach>
												</c:otherwise>
											</c:choose>
								        </div>
								    </div>
								    <div class="row mb-2 align-items-center">
								        <label class="col-lg-2 col-md-3 col-form-label col-form-label-sm fw-semibold text-dark">참조자</label>
								        <div class="col-lg-10 col-md-9 d-flex flex-wrap gap-2" id="referrersDisplay">
								            <c:choose>
												<c:when test="${empty edmsVO.referenceList}">
													참조자 정보 없음
												</c:when>
												<c:otherwise>
													<c:forEach items="${edmsVO.referenceList}" var="reference">
														<span class="p-1">${reference.empName} ${reference.empPositionNm} <small>(${reference.empDepartNm})</small></span>
													</c:forEach>
												</c:otherwise>
											</c:choose>
								        </div>
							        </div>
							    </div>
							</div>

		                    <div class="d-flex justify-content-end gap-2 mt-3 mb-3">
		                        <button type="submit" class="btn btn-blue-theme fw-semibold" id="submitBtn">수정</button>
		                        <a href="${pageContext.request.contextPath}/emp/edms/approvalBox" class="btn btn-secondary fw-semibold me-3">취소</a>
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
			                    <h6 class="panel-heading border-bottom pb-2 mb-2">직원 목록 <small id="modalSelectedDepartmentName" class="text-muted"></small></h6>
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
	let submitBtn = $("#submitBtn");
	let approverBtn = $("#approverBtn");
	let approvalLineModal = $("#approvalLineModal");

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

	const modalDepartmentList = $("#modalDepartmentList"); // 부서 목록
	const modalEmployeeList = $("#modalEmployeeList"); // 직원목록
	const modalAddApproversBtn = $("#modalAddApproversBtn"); // 결재 추가 버튼
	const modalAddReferrersBtn = $("#modalAddReferrersBtn"); // 참조 추가 버튼
	const modalApprovalLineList = $("#modalApprovalLineList"); // 결재자 리스트
	const modalReferrerList = $("#modalReferrerList"); // 참조자 리스트
	const closeBtn = $("#closeBtn"); //  모달 닫기 버튼
	const saveApprovalLineBtn = $("#saveApprovalLineBtn"); //  결재자 참조자 저장 버튼

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
		if(targetEl == null){
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
			sweetAlert("error","이미 선택된 참조자입니다");
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
			<div class="p-1" >
				<span class="info"><span class="p-1">\${targetName}</span></span>
				<span class="removeApprovalBtn" data-emp-username="\${targetUsername}" data-emp-position-code="\${targetEmpPositionCode}">
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
		if(targetEl == null){
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
			<div class="p-1" >
				<span class="info"><span class="p-1">\${targetName}</span></span>
				<span class="removeReferenceBtn" data-emp-username="\${targetUsername}" data-emp-position-code="\${targetEmpPositionCode}">
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
		approverList.each((i,v) => {
			let dataSpan = $(v).find("span.removeApprovalBtn");
			const empUsername = dataSpan.data("empUsername");
			const empPositionCode = dataSpan.data("empPositionCode");
			let html = ``;
			html += `<input type="hidden" name="addApproverList[\${addApproverCount}].edmsNo" value="${edmsVO.edmsNo}">`
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
		displayHtml = '';
		referenceList.each((i,v) => {
			let dataSpan = $(v).find("span.removeReferenceBtn");
			const empUsername = dataSpan.data("empUsername");
			const empPositionCode = dataSpan.data("empPositionCode");
			let html = ``;
			html += `<input type="hidden" name="addReferenceList[\${addRefererCount}].edmsNo" value="${edmsVO.edmsNo}">`
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

	// 부서목록 보이기
	function displayDepartList(){
		modalDepartmentList.html('');
		modalEmployeeList.html('<p class="text-muted p-3 text-center">왼쪽에서 부서를 선택해주세요.</p>');
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
				let html = ``;
				html += `<ul class="list-group">`;
				for(let data of res){
					const {empPositionNm, empUsername,peoName, empPositionCode,empDepartNm} = data;
					html += `
						<li class="list-group-item list-group-item-action" data-emp-username="\${empUsername}" data-emp-position-code="\${empPositionCode}">\${peoName} \${empPositionNm} <small>(\${empDepartNm})</small></li>
					`
				}
				html += `</ul>`
				modalEmployeeList.html(html);
			}
		});
	}

	// 인풋태그 변환
	changeInputContent();
	// 문서 내용영역 인풋태그로 변환시키기
	function changeInputContent(){
		let content = $("#content");

		let currentHtml = content.clone();

		currentHtml.find('input[type="hidden"]').each(function() {
	        let name = $(this).attr('name');
	        let id = $(this).attr('id');
	        let value = $(this).val(); // hidden input의 값 (원래 태그의 값)

	        // 다음 형제 요소가 span 태그인지 확인하고 제거
	        let nextSpan = $(this).next('span');
	        if (nextSpan.length) {
	            nextSpan.remove(); // 값 표시용 span 태그 제거
	        }

	        let originalTagHtml;
	        // name과 클래스 속성을 기준으로 원래 태그의 종류를 구분하여 복원
	        if (name && $(this).hasClass('txa')) {
	            originalTagHtml = `<textarea name="\${name}" id="\${id || ''}" class="form-control form-control-sm custom-focus txa">\${value}</textarea>`;
	        } else if (name && (name.includes('date') || $(this).attr('type') === 'date')) { // date input으로 가정
	            originalTagHtml = `<input type="date" class="form-control form-control-sm custom-focus" name="\${name}" id="\${id || ''}" value="\${value}">`;
	        } else { // 기본적으로 text input으로 복원
	            originalTagHtml = `<input type="text" class="form-control form-control-sm custom-focus" name="\${name}" id="\${id || ''}" value="\${value}">`;
	        }

	        $(this).replaceWith(originalTagHtml); // hidden input을 원래 태그로 대체
	    });

	    // 4. 복원된 HTML을 원본 content 영역에 적용합니다.
	    content.html(currentHtml.html());
	}

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

    	    if(approversDisplay.children().length != 2){
    	    	sweetAlert("error","결재자를 모두 지정해주세요");
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
});
</script>
</html>