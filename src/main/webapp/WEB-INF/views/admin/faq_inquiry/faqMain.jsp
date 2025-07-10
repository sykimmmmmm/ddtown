<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FAQ 관리 - DDTOWN 관리자</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<%@ include file="../../modules/headerPart.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/ckeditorInquiry/ckeditor.js"></script>
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.1/dist/js/adminlte.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">


<!-- 아코디언 시작 -->
<!-- 아코디언 끝 -->

<style type="text/css">
.modal-header {
    display: flex;
    flex-shrink: 0;
    align-items: center;
    padding: var(--bs-modal-header-padding);
    border-bottom: var(--bs-modal-header-border-width) solid var(--bs-modal-header-border-color);
    border-top-left-radius: var(--bs-modal-inner-border-radius);
    border-top-right-radius: var(--bs-modal-inner-border-radius);
    gap: 10pt;
}
.modal-detail-title{
 	display: flex;
    justify-content: space-between;
    align-items: center;
}
.modal-detail-title .faq-info {
    display: flex;
    align-items: center;
    flex-grow: 1;
    gap: 10pt;
}

.modal-detail-title .faq-category {
    font-size: 0.7em;
    color: #fff;
    background-color: #5dade2;
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: 500;
    margin-right: 12px;
    flex-shrink: 0;
}

.modal-detail-title .faq-question-text {
    font-weight: 500;
    color: #2c3e50;
    flex-grow: 1;
}

.mb-3 .form-control {
	height : 300px;
    resize: none;
}

.mb-3 .form-control:disabled {
	background-color : #ffffff;
}

.faqTitleCss:disabled {
	background-color : #ffffff;
	width : 500px;
	height : 70px;
	border: 0px;
	resize: none;
}

.faqTitleCss {
    width: 500px;
    height: 40px;
    border: 1px solid #cccccc;
    border-radius: 4px;
    padding: 8px 12px;
    box-sizing: border-box;
    resize: none;
    scrollbar-width: none;
    font-size: 12pt;
}

.selectBox {
    position: relative;
    display: inline-block;
    width: 150px;
    font-weight: 400;
    font-size: 10pt;
}

.selectBox select{
	/* 기본 브라우저 스타일 제거 */
  appearance: none;
  -webkit-appearance: none; /* Safari, Chrome */
  -moz-appearance: none;    /* Firefox */

  /* 기본 스타일링 */
  width: 100%;
  padding: 10px 30px 10px 12px; /* 오른쪽 패딩은 화살표 공간 확보 */
  font-size: 16px;
  font-family: 'Arial', sans-serif;
  color: #333;
  background-color: #fff;
  border: 1px solid #ccc;
  border-radius: 5px;
  cursor: pointer;
  outline: none; /* 포커스 시 기본 아웃라인 제거 */
  box-sizing: border-box;
}

.selectBox::after {

  content: '';
  position: absolute;
  top: 50%;
  right: 12px;
  transform: translateY(-50%) rotate(45deg); /* 화살표 모양 만들기 */
  width: 6px;
  height: 6px;
  border-bottom: 2px solid #555; /* 화살표 색상 및 두께 */
  border-right: 2px solid #555;
  pointer-events: none; /* 화살표가 select 클릭 방해하지 않도록 */
  transition: transform 0.2s ease; /* 부드러운 효과 (선택사항) */
}

/* #updateForm {
    width: auto; /* 내용에 맞게 너비 자동 조절 */
    min-width: max-content; /* 최소 너비를 내용만큼 확보 (예: "검색" 두 글자) */
    white-space: nowrap; /* 글자가 두 줄로 나뉘는 것을 방지 */
    writing-mode: horizontal-tb !important; /* 혹시라도 writing-mode가 세로로 설정된 경우 강제 변경 */
    padding-left: 12px; /* 버튼 내부 여백 (기존 .ea-btn 스타일에 따라 조절) */
    padding-right: 12px; /* 버튼 내부 여백 (기존 .ea-btn 스타일에 따라 조절) */
} */
#searchBtn {
    width: auto; /* 내용에 맞게 너비 자동 조절 */
    min-width: max-content; /* 최소 너비를 내용만큼 확보 (예: "검색" 두 글자) */
    white-space: nowrap; /* 글자가 두 줄로 나뉘는 것을 방지 */
    writing-mode: horizontal-tb !important; /* 혹시라도 writing-mode가 세로로 설정된 경우 강제 변경 */
    padding-left: 12px; /* 버튼 내부 여백 (기존 .ea-btn 스타일에 따라 조절) */
    padding-right: 12px; /* 버튼 내부 여백 (기존 .ea-btn 스타일에 따라 조절) */
}
.input-group {
    gap: 5px;
    flex-wrap: nowrap;
}

button.close {
    font-size: xx-large;
    margin: 0;
    padding: 0;
}

.modal-header.detail {
    justify-content: space-between;
    align-items: baseline;
    margin-top: 0;
    padding-top: 0;
}

.answer-history{
	margin-top: 5pt;
}

div#cntArea {
    display: flex;
    gap: 10px;
    font-size: 6pt;
    align-items: center;
}

.cntArea .status-badge {
    font-size: 9px;
}

.cntArea input{
	display : none;
}
label.status-badge.allMem {
    padding: 5px 10px;
    font-size: 9px;
    font-weight: 500;
    color: white;
    display: inline-block;
    background-color: #227bff;

}

#cntArea label{
	cursor:pointer;
	transition : 0.3s ease;
	font-size: medium;
}

#cntArea label:hover {
    transform: scale(1.1);
    box-shadow: 0px 2px 10px #adaaad;
}

/* #cntArea input[name='searchCode']:checked + label{ */
/* 	border : none; */
/* 	transform : scale(0.95); */
/* } */
.cntGroup {
    display: flex;
    gap: 20px;
    align-items: center;
}

label.status-badge.comuFaq {
    background-color: #b700ff;
}

button#insertForm {
    width: 70pt;
}

.main-footer {
    display: flex;
}

.main-page {
    justify-content: center;
    width: 100%;
}

span.comu-cate {
    border: none;
    font-size: 10pt;
    border-radius: 8pt;
    background-color: #b700ff;
    color: white;
    padding: 4pt;
}

span.mem-cate {
    border: none;
    font-size: 10pt;
    border-radius: 8pt;
    background-color: #f39c12;
    color: white;
    padding: 4pt;
}

span.good-cate {
    border: none;
    font-size: 10pt;
    border-radius: 8pt;
    background-color: #2ecc71;
    color: white;
    padding: 4pt;
}

td.faq-title {
    text-align: left;
}
</style>
</head>

<script type="text/javascript">

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

    return date.getFullYear() + '-' + month + '-' + day;
}

$(function(){

	list();


	$("#cntArea").on("click","input[name=searchCode]",function(){
		let searchCode = $(this).val()

		let data = {
			"searchCode" : searchCode
		}

		list(data);
	});

	$("#searchBtn").on("click",function(){
		let searchCode = $('input[name="searchCode"]:checked').val();
		let data = {
			searchCode : searchCode,
			searchType : $("#searchType").val(),
			searchWord : $("#searchWord").val()
		}

		list(data);
	});

	$("#updateModal").on("hiden.bs.modal",function(){
		$("#faqTitleUpdate").val("");

		$("#faqAnswerUpdate").val("");

		$("#empUsernameUpdate").html("");

		$("#faqModDateUpdate").html("");
	});

	$("#updateModal").on('show.bs.modal',function(e){

		let faqNo = e.relatedTarget.getAttribute('data-bs-faqNo');

		$.ajax({
			url : "/admin/faq/detailData/" + faqNo,
			type : "get",
			success : function(res){

				$("#faqTitleUpdate").val(res.faqTitle);

				$("#faqAnswerUpdate").val(res.faqAnswer);

				$("#empUsernameUpdate").html(res.empUsername);

				$("#faqModDateUpdate").html(dateFormat(res.faqModDate));



				let select = document.querySelector("select[id=faqUpdateCategory]");
				let codeList = Array.from(select.options);

				for(let i=0; i<codeList.length; i++){
					let code = codeList[i];
					if(code.value == null || code.value == ""){
						codeList.splice(i,i+1);
					}
				}

				let codeHtml = ``;
				for(let i=0; i<codeList.length; i++){
					let code = codeList[i];
					let faqCate = res.faqCategory;
					let select = "";
					if(code.value == faqCate){
						select = "selected";
					}
					codeHtml += `
						<option value="\${code.value}" \${select}>\${code.innerHTML}</option>
					`;
				}
				select.innerHTML = codeHtml;

			},
			error : function(error, status, thrown){
				console.log(error.status);
			}
		});

	});

	$("#detailModal").on("show.bs.modal", function(event){
		let faqNo = event.relatedTarget.getAttribute('data-bs-faqNo');
		$.ajax({
			url : "/admin/faq/detailData/" + faqNo,
			type : "get",
			success : function(res){
				$("#faqCategoryView").html(res.description);
				if(res.faqCategory == "FC003"){
					$("#faqCategoryView").attr("style","background-color:#b700ff;");
				}else if(res.faqCategory == "FC002"){
					$("#faqCategoryView").attr("style","background-color:#f39c12;");
				}else{
					$("#faqCategoryView").attr("style","background-color:#2ecc71;");
				}

				$("#faqTitle").html(res.faqTitle);
				$("#faqTitleUpdate").html(res.faqTitle);

				$("#faqAnswer").html(res.faqAnswer);
				$("#faqAnswerUpdate").html(res.faqAnswer);

				$("#empUsername").html(res.empUsername);
				$("#empUsernameUpdate").html(res.empUsername);

				$("#faqModDate").html(dateFormat(res.faqModDate));
				$("#faqModDateUpdate").html(dateFormat(res.faqModDate));

				$("#updateData").attr("data-faqNo",res.faqNo);
				$("#update").attr("data-bs-faqNo",res.faqNo);
				$("#delete").attr("data-faqNo",res.faqNo);


				let select = document.querySelector("select[id=faqUpdateCategory]");
				let codeList = Array.from(select.options);

				for(let i=0; i<codeList.length; i++){
					let code = codeList[i];
					if(code.value == null || code.value == ""){
						codeList.splice(i,i+1);
					}
				}

				let codeHtml = ``;
				for(let i=0; i<codeList.length; i++){
					let code = codeList[i];
					let faqCate = res.faqCategory;
					let select = "";
					if(code.value == faqCate){
						select = "selected";
					}
					codeHtml += `
						<option value="\${code.value}" \${select}>\${code.innerHTML}</option>
					`;
				}
				select.innerHTML = codeHtml;

			},
			error : function(error, status, thrown){
				console.log(error.status);
			}
		});
	});

	$("#update").on("click",function(){
		let currentModal = $(this).closest('.modal');
		currentModal.modal('hide');
	});

	$("#updateData").on("click",function(){
		let faqNo = (this).dataset.faqno;
		let data = new FormData();
		data.append("faqTitle",$("#faqTitleUpdate").val());
		data.append("faqAnswer",$("#faqAnswerUpdate").val());
		data.append("faqCategory",$("#faqUpdateCategory").val());

		Swal.fire({
			title : "수정하시겠습니까?",
			icon : "question",
			showCancelButton: true,
			confirmButtonText : "예",
			cancelButtonText : "아니오"
		}).then((result) => {
			if(result.isConfirmed){
				$.ajax({
					url : "/admin/faq/updateData/" + faqNo,
					type : "post",
					data : data,
					processData : false,
					contentType : false,
					success : function(res){
						if(res == "OK"){
							Swal.fire({
								title : "수정완료!",
								text : "수정이 정상적으로 완료되었습니다.",
								icon : "success",
								showConfirmButton : true,
							}).then((result) => {
								let data = {
									searchCode : searchCode,
									searchType : $("#searchType").val(),
									searchWord : $("#searchWord").val()
								}
								list(data);
								$("#updateModal").modal('hide');

							});
						}
					},
					error : function(error, status, thrown){
						console.log(error.status);
					},
					beforeSend : function(xhr) {
				        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
				    }
				});
			}else{
				return false;
			}
		});

	});

	$("#insertData").on("click",function(){
		let data = new FormData();
		data.append("faqTitle",$("#faqTitleInsert").val());
		data.append("faqAnswer",$("#faqAnswerInsert").val());
		data.append("faqCategory",$("#faqCategoryInsert").val());

		Swal.fire({
			title : "저장하시겠습니까?",
			icon : "question",
			showCancelButton: true,
			confirmButtonText : "예",
			cancelButtonText : "아니오"
		}).then((result) => {
			if(result.isConfirmed){
				$.ajax({
					url : "/admin/faq/insert",
					type : "post",
					data : data,
					contentType : false,
					processData : false,
					success : function(res){
						if(res == "OK"){
							Swal.fire({
								title : "저장완료",
								text : "성공적으로 저장이 완료되었습니다.",
								icon : "success",
								showConfrimButton : true,
							}).then((result) => {
								location.href="/admin/faq/main";
							});
						}
					},
					error : function(error, thrown, status){

					},
					beforeSend : function(xhr) {
				        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
				    }
				});
			}else{
				return false;
			}
		});


	});

	const pagingArea = $('#pagingArea');
    if(pagingArea.length > 0) {
        pagingArea.on('click', 'a', function(event) {
            event.preventDefault();
            const page = $(this).data('page');

            let searchCode = $('input[name="searchCode"]:checked').val();

            let searchType = $("#searchType").val();
            let searchWord = $("#searchWord").val();

            let data = {
            	searchType : searchType,
            	searchWord : searchWord,
            	searchCode : searchCode,
            	page : page
            };
            list(data);
        });
    }


    $("#insertModal").on("show.bs.modal",function(){

    	let select = document.querySelector("select[id=faqCategoryInsert]");
		let codeList = Array.from(select.options);

		for(let i=0; i<codeList.length; i++){
			let code = codeList[i];
			if(code.value == null || code.value == ""){
				codeList.splice(i,i+1);
			}
		}

		let codeHtml = ``;
		for(let i=0; i<codeList.length; i++){
			let code = codeList[i];
			codeHtml += `
				<option value="\${code.value}" \${select}>\${code.innerHTML}</option>
			`;
		}
		select.innerHTML = codeHtml;
    });

    $("#delete").on("click",function(e){
    	let faqNo = e.target.dataset.faqno;
    	deleteFaqItem(faqNo);
    });

});

function list(data){

	$.ajax({
		url : "/admin/faq/list",
		type : "get",
		data : data,
		success : function(res){
			let html = ``;
			if(res != null && res.faqVO.length > 0){
				for(let i=0; i<res.faqVO.length; i++){
					let vo = res.faqVO[i];
					let date = dateFormat(vo.faqRegDate);
					let modDate = dateFormat(vo.faqModDate);

					let cntHtml = `
						<input type="radio" name="searchCode" id="all" value=""`;

					if(res.searchCode == null || res.searchCode == ''){
						cntHtml += `checked`;
					}
					cntHtml +=`
						/>
						<label for="all" class="status-badge allMem">전체 \${res.allFaqCnt}건</label>`;

					for(let j=0; j<res.cntList.length; j++){
						let cnt = res.cntList[j];
						cntHtml +=`
							<input type="radio" name="searchCode"`;
						if(cnt.commCodeDetNo == "FC001"){
							cntHtml += `id="goodFaq" value="\${cnt.commCodeDetNo}"`;
							if(res.searchCode == cnt.commCodeDetNo){
								cntHtml += `checked`;
							}
							cntHtml += `
								/>
								<label for="goodFaq" class="status-badge answered">굿즈샵 \${cnt.codeCnt}건</label>`;
						}else if(cnt.commCodeDetNo == "FC002"){
							cntHtml += `<input type="radio" name="searchCode" id="memFaq" value="\${cnt.commCodeDetNo}"`;
							if(res.searchCode == cnt.commCodeDetNo){
								cntHtml += `checked`;
							}
							cntHtml +=`
								/>
								<label for="memFaq" class="status-badge pending">회원 \${cnt.codeCnt}건</label>`;
						}else{
							cntHtml += `<input type="radio" name="searchCode" id="comuFaq" value="\${cnt.commCodeDetNo}"`;
							if(res.searchCode == cnt.commCodeDetNo){
								cntHtml += `checked`;
							}
							cntHtml +=`
								/>
								<label for="comuFaq" class="status-badge comuFaq">커뮤니티 \${cnt.codeCnt}건</label>`;
						}
					}

					$("#cntArea").html(cntHtml);
					let cateClass;
	                if(vo.faqCategory == "FC003"){
	                	cateClass = 'comu-cate';
	                }else if(vo.faqCategory == "FC002"){
	                	cateClass = 'mem-cate';
	                }else{
	                	cateClass = 'good-cate';
	                }
					html += `
					<tr data-inquiry-id="\${vo.faqNo}">
	                    <td>\${vo.faqTotalRow}</td>
	                    <td>
	                    <span class="\${cateClass}">
	                	\${vo.description}
	                	</span>
	                    </td>
	                    <td class="faq-title"><a data-bs-toggle="modal" href="#detailModal" data-bs-faqNo="\${vo.faqNo}">\${vo.faqTitle}</a></td>
	                    <td>\${date}</td>
	                    <td>\${modDate}</td>
	                </tr>
					`;
				}

			}else{
				html = `
					<td colspan="4">조회하신 게시물은 없습니다.</td>
				`;
			}


			let codeHtml = `<option value="">전체</option>`;
			if(res.codeList != null && res.codeList.length > 0){
				for(let i=0; i<res.codeList.length; i++){
					let code = res.codeList[i];
					let select = "";
					if(code.commCodeDetNo == res.pagingVO.searchType){
						select = "selected"
					}
					codeHtml += `
						<option value="\${code.commCodeDetNo}" \${select}>\${code.description}</option>
					`;
				}
				$("select[id=faqCategory]").html(codeHtml);
				$("select[id=faqUpdateCategory]").html(codeHtml);
				$("#faqCategoryInsert").html(codeHtml);
			}

			$("#pagingArea").html(res.pagingVO.pagingHTML);


			$("#faqTableBody").html(html);
		},
		error : function(error, status, thrown){
			console.log(error.status);
		}
	});
}


function deleteFaqItem(faqNo){
	Swal.fire({
		title : "정말로 삭제하시겠습니까?",
		text : "삭제가 완료되면 복구하실 수 없습니다.",
		icon : "warning",
		showCancelButton: true,
		confirmButtonText : "예",
		cancelButtonText : "아니오"
	}).then((result) => {
		if(result.isConfirmed){
			$.ajax({
				url : "/admin/faq/delete/" + faqNo,
				type : "post",
				success : function(res){
					if(res == "OK"){
						Swal.fire({
							title : "삭제 완료!",
							text : "정상적으로 삭제가 완료되었습니다.",
							icon : "success",
							showConfrimButton : true,
						}).then((result) => {
							location.href = "/admin/faq/main";
						});
					}
				},
				error : function(error, status, thrown){
					console.log(error.status);
				},
				beforeSend : function(xhr) {
			        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
			    }
			});
		}
	});
}

</script>
<body>

<div class="emp-container">
        <%@ include file="../modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>

				<main class="emp-content" style="font-size: larger;">
					<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
						<ol class="breadcrumb">
						  <li class="breadcrumb-item"><a href="#">고객센터</a></li>
						  <li class="breadcrumb-item" aria-current="page">FAQ</li>
						</ol>
					</nav>
					<section class="ea-section active-section" id="csFaqListSection">
						<div class="ea-section-header">
							<div class="cntGroup">
								<h2>FAQ 관리</h2>
								<div id="cntArea" class="cntArea">
								</div>
							</div>
							<div class="ea-header-actions">

								<form class="input-group input-group-sm" method="get" id="searchForm">

									<input type="hidden" name="currentPage" value="1" id="page">

									<input type="text" class="ea-search-input" name="searchWord" id="searchWord" placeholder="질문 검색...">


									<div class="input-group-append">
										<button type="button" class="ea-btn primary" id="searchBtn">
											<i class="fas fa-search"></i>검색
										</button>
									</div>
								</form>
							</div>
						</div>
						<table class="ea-table" id="faqTable">
							<thead>
				                <tr>
				                    <th class="col-number">번호</th>
				                    <th class="col-status">유형</th>
				                    <th class="col-title">질문</th>
				                    <th class="col-date">등록일</th>
				                    <th class="col-date">수정일</th>
				                </tr>
				            </thead>
				            <tbody id="faqTableBody">

				            </tbody>
						</table>

						<div class="main-footer">
							<div class="main-page">
								<div class="pagination-container" id="pagingArea">

								</div>
							</div>
							<div class="main-addBtn">
								<button class="ea-btn primary" id="insertForm" data-bs-toggle="modal" data-bs-target="#insertModal">
				                    <i class="fas fa-plus"></i> 등록
				                </button>
							</div>
						</div>
					</section>
				</main>
		</div>
</div>


<!-- 상세모달 -->
<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			 <div class="modal-header detail">
			 	<div class="modal-title">
			 		<div class="modal-detail-title" id="modalTitle">
				 		<h4 class="card-title w-100 faq-info">
					 		<span class="faq-category" id="faqCategoryView"></span>
					 		<span class="faq-question-text" id="faqTitle"></span>
				 		</h4>
			 		</div>
			 		<div class="answer-history">
				 		<div class="answer-meta">
	        				<span id="empUsername"></span> | <span id="faqModDate"></span>
	        			</div>
			 		</div>
			 	</div>
				<button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
				  <span aria-hidden="true">×</span>
				</button>
			 </div>
			 <div class="modal-body">
				<form>
					<div class="mb-3">
						<label for="faqAnswer" class="col-form-label">내용</label>
						<textarea class="form-control" id="faqAnswer" disabled="disabled"></textarea>
					</div>
				</form>
			 </div>
			 <div class="modal-footer">
				<button type="button" class="btn btn-primary" id="update" data-bs-toggle="modal" data-bs-target="#updateModal" data-faqNo="">수정</button>
				<button type="button" class="btn btn-danger" id="delete">삭제</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
			 </div>
		</div>
	</div>
</div>

<!-- 수정모달 -->
<div class="modal fade" id="updateModal" style="display: none;" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			 <div class="modal-header">
			 	<div class="modal-title">
			 		<div class="modal-detail-title" id="modalTitle">
				 		<h4 class="card-title w-100 faq-info">
					 		<select id="faqUpdateCategory" class="selectBox"></select>
							<textarea class="faqTitleCss" id="faqTitleUpdate"></textarea>
				 		</h4>
			 		</div>
			 	</div>
				<button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
				  <span aria-hidden="true">×</span>
				</button>
			 </div>
			 <div class="modal-body">
				<form>
					<div class="mb-3">
						<label for="faqAnswer" class="col-form-label">내용</label>
						<textarea class="form-control" id="faqAnswerUpdate"></textarea>
					</div>
				</form>
			 </div>
			 <div class="modal-footer">
				<button type="button" class="btn btn-primary" id="updateData" data-faqNo="">저장</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
			 </div>
		</div>
	</div>
</div>

<!-- 등록모달 -->
<div class="modal fade" id="insertModal" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			 <div class="modal-header">
			 	<div class="modal-title">
			 		<div class="modal-detail-title" id="modalTitle">
				 		<h4 class="card-title w-100 faq-info">
					 		<select id="faqCategoryInsert" class="selectBox"></select>
							<textarea class="faqTitleCss" id="faqTitleInsert"></textarea>
				 		</h4>
			 		</div>
			 	</div>
				<button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
				  <span aria-hidden="true">×</span>
				</button>
			 </div>
			 <div class="modal-body">
				<form>
					<div class="mb-3">
						<label for="faqAnswer" class="col-form-label">내용</label>
						<textarea class="form-control" id="faqAnswerInsert"></textarea>
					</div>
				</form>
			 </div>
			 <div class="modal-footer">
				<button type="button" class="btn btn-primary" id="insertData">저장</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
			 </div>
		</div>
	</div>
</div>
</body>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
</html>