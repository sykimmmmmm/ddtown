<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>콘서트 좌석 관리 - DDTOWN 직원 포털</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <style type="text/css">
    	body {
	        font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
	        color: #333;
	        background-color: #f8f9fa; /* Light background for the whole page */
    	}
    	h2.fw-bold {
	        color: #234aad; /* Main heading color */
	        font-size: 1.8em;
	        margin-bottom: 20px;
	    }
    	#seatTable th, #seatTable td {
    		text-align : inherit;
    	}
    	.card {
        border-radius: 8px;
        border: 1px solid #e0e5f0;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .card-header {
        background-color: #f8faff !important; /* Lighter header background */
        border-bottom: 1px solid #e9ecef;
        padding: 18px 20px;
    }
    .card-title {
        font-size: 1.15em;
        font-weight: 600;
        color: #234aad; /* Card title color */
    }
    .card-body {
        padding: 20px;
        font-size: large;
    }

    /* Select Box (Concert Select) */
    .form-select {
        border-radius: 6px;
        border: 1px solid #ced4da;
        padding: 10px 15px;
        font-size: 1em;
    }
    .form-select:focus {
        border-color: #80bdff;
        box-shadow: 0 0 0 0.25rem rgba(0, 123, 255, 0.25);
    }

    /* Seat Table Styling */
    #seatTable {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        font-size: large;
    }
    #seatTable th, #seatTable td {
        padding: 15px 20px; /* More padding */
        vertical-align: middle;
        border-bottom: 1px solid #e9ecef;
        font-size: 0.95em;
    }
    #seatTable thead th {
        background-color: #f0f5ff; /* Header background color */
        color: #234aad;
        font-weight: 600;
        text-align: center; /* Center align header text */
    }
    #seatTable tbody tr:last-child td {
        border-bottom: none; /* No bottom border for the last row */
    }
    #seatTable tbody td {
        color: #495057;
        text-align: center; /* Center align all body cells by default */
    }
    /* Specific alignment for sections, grades (left) and price (right) */
    #seatTable tbody td:nth-child(1), /* 섹션 */
    #seatTable tbody td:nth-child(2) /* 좌석 등급 */ {
        text-align: left;
    }
    #seatTable tbody td:nth-child(3) { /* 가격 */
        text-align: right;
    }

    /* Edit Button in Table */
    .edit-seat-btn {
        padding: 6px 12px;
        font-size: 0.85em;
        border-radius: 5px;
    }
    .btn-primary {
        background-color: #234aad; /* Custom primary blue */
        border-color: #234aad;
    }
    .btn-primary:hover {
        background-color: #1a3c8a;
        border-color: #1a3c8a;
    }
    /* Modal Styling */
    .modal-header {
        background-color: #f0f5ff !important; /* Modal header background */
        border-bottom: 1px solid #e0e5f0;
    }
    .modal-title {
        color: #234aad !important; /* Consistent primary color for modal title */
        font-weight: 700;
        font-size: 1.25em;
    }
    .modal-body {
        padding: 25px;
    }
    .modal-footer {
        border-top: none;
        padding: 15px 25px 25px;
    }

    /* Form within Modal */
    .form-label {
        font-weight: 600;
        color: #34495e;
        margin-bottom: 8px;
    }
    .form-control, .form-select {
        border-radius: 5px;
        padding: 10px 12px;
        border: 1px solid #ced4da;
    }
    .form-control:focus, .form-select:focus {
        border-color: #234aad;
        box-shadow: 0 0 0 0.25rem rgba(35, 74, 173, 0.25);
    }

    .btn-outline-secondary {
        border-color: #6c757d;
        color: #6c757d;
    }
    .btn-outline-secondary:hover {
        background-color: #6c757d;
        color: white;
    }
    .title {
    	font-size: 1.7em;
	    font-weight: 700;
	    color: #234aad;
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    margin-bottom: 0;
    }
    </style>

</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
            <main class="emp-content container-fluid py-4" style="min-height:600px; font-size: large;">
	            <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">콘서트 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">콘서트 좌석 관리</li>
					</ol>
				</nav>
			    <div class="row align-items-center mb-4">
			        <div class="col-md-8">
			            <h2 class="title">콘서트 좌석 관리</h2>
			        </div>
			    </div>

			    <div class="row mb-4">
			        <div class="col-12">
			            <div class="card shadow-sm">
			                <div class="card-body">
			                    <label for="concertSelect" class="form-label visually-hidden">콘서트 선택</label>
			                    <select class="form-select" id="concertSelect">
			                        <c:choose>
			                            <c:when test="${empty concertList}">
			                                <option value="">예정중인 콘서트가 없습니다.</option>
			                            </c:when>
			                            <c:otherwise>
			                                <c:forEach items="${concertList}" var="concert">
			                                    <option value="${concert.concertNo}">${concert.concertNm}</option>
			                                </c:forEach>
			                            </c:otherwise>
			                        </c:choose>
			                    </select>
			                </div>
			            </div>
			        </div>
			    </div>

			    <div class="row gx-4" style="font-size: large;">

			        <div class="col-lg-6 mb-4">
			            <div class="card shadow-sm h-100">
			                <div class="card-header bg-white border-bottom py-3">
			                    <h5 class="card-title mb-0">섹션별 좌석 등급 및 가격 정보</h5>
			                </div>
			                <div class="card-body p-0">
			                    <div class="table-responsive">
			                        <table class="table table-hover table-striped mb-0" id="seatTable">
			                            <thead>
			                                <tr class="text-center">
			                                    <th scope="col" width="20%">섹션</th>
			                                    <th scope="col" width="20%">좌석 등급</th>
			                                    <th scope="col" width="25%" >가격</th>
			                                    <th scope="col" width="15%">좌석 수</th>
			                                    <th scope="col" width="20%" >변경</th>
			                                </tr>
			                            </thead>
			                            <tbody id="seatTableBody" class="text-center">

			                            </tbody>
			                        </table>
			                    </div>
			                </div>
			            </div>
			        </div>

			        <div class="col-lg-6 mb-4">
			            <div class="card shadow-sm h-100">
			                <div class="card-header bg-white border-bottom py-3">
			                    <h5 class="card-title mb-0">공연장 구역 정보</h5>
			                </div>
			                <div class="card-body d-flex flex-column">
			                    <div class="stage-area text-center mb-3">
			                        <div class="stage bg-dark text-white p-2 rounded-3 fw-bold">STAGE</div>
			                    </div>
			                    <div class="seat-map-svg-wrapper flex-grow-1 position-relative overflow-hidden" style="height: 400px; max-width: 100%;"> <%-- SVG 컨테이너 --%>
<%-- 			                        <object data="${pageContext.request.contextPath}/resources/concertHall.svg" type="image/svg+xml" id="hallSvg" style="opacity:0; transform : scale(0.4); position: absolute; top:-168px; left:-340px;"></object> --%>
			                        <object data="${pageContext.request.contextPath}/resources/seatSection.svg" type="image/svg+xml" id="hall" style="transform : scale(0.3); position: absolute; top:-213px; left:-358px;"></object>
			                    </div>
			                </div>
			            </div>
			        </div>
			    </div>
			</main>
        </div>
    </div>

<div class="modal fade" id="seatModal" tabindex="-1" aria-labelledby="seatModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header bg-light">
                <h5 class="modal-title text-primary fw-bold" id="seatModalLabel">구역별 좌석 등급 및 가격 변경</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <form id="seatForm">
                    <input type="hidden" id="concertNo" name="concertNo">

                    <div class="mb-3">
                        <label for="seatSection" class="form-label fw-bold">구역 선택 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="seatSection" name="seatSection" readonly>
                    </div>

                    <div class="mb-3">
                        <label for="seatGrade" class="form-label fw-bold">좌석 등급 <span class="text-danger">*</span></label>
                        <select class="form-select" id="seatGrade" name="seatGradeCode">
                            <c:forEach items="${gradeList}" var="grade">
                            	<option value="${grade.commCodeDetNo}">${grade.description}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="seatPrice" class="form-label fw-bold">가격 <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="seatPrice" name="seatPrice" required min="0" max="1000000" placeholder="0">
                    </div>

                </form>
            </div>

            <div class="modal-footer justify-content-center border-top-0">
                <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal" id="seatCancelBtn">취소</button>
                <button type="button" class="btn btn-primary px-4" id="seatSaveBtn">저장</button>
            </div>
        </div>
    </div>
</div>

	<%@ include file="../../modules/footerPart.jsp" %>
	<%@ include file="../../modules/sidebar.jsp" %>
<script>
	$(function(){

		const seatModal = $("#seatModal");

		seatModal.on("show.bs.modal",function(e){
			let target = e.relatedTarget;
			if(target){
				let seatGradeCode = $(target).data("seatGradeCode");
				let seatSection = $(target).data("seatSection");
				let concertNo = $(target).data("concertNo");
				let seatPrice = $(target).data("seatPrice");

				$("#concertNo").val(concertNo);
				$("#seatSection").val(seatSection);
				$("#seatGrade").val(seatGradeCode);
				$("#seatPrice").val(seatPrice);
			}

		})

		seatModal.on("hide.bs.modal",function(){
			$("#concertNo").val("");
			$("#seatSection").val("");
			$("#seatGrade").val("");
			$("#seatPrice").val("");
		})

		$("#seatSaveBtn").on("click",function(){

			let seatGradeCode = $("#seatGrade").val();
			let seatSection = $("#seatSection").val();
			let concertNo = $("#concertNo").val();
			let seatPrice = $("#seatPrice").val();

			let data = {
				concertNo, seatSection, seatGradeCode, seatPrice
			}

			Swal.fire({
				   title: '저장 하시겠습니까?',
				   text: '잘못 저장시 다시 수정하셔야합니다.',
				   icon: 'warning',

				   showCancelButton: true, // cancel버튼 보이기. 기본은 원래 없음
				   confirmButtonColor: '#3085d6', // confrim 버튼 색깔 지정
				   cancelButtonColor: '#d33', // cancel 버튼 색깔 지정
				   confirmButtonText: '저장', // confirm 버튼 텍스트 지정
				   cancelButtonText: '취소', // cancel 버튼 텍스트 지정

				}).then(result => {
				   // 만약 Promise리턴을 받으면,
				    if(result.isConfirmed) { // 만약 모달창에서 confirm 버튼을 눌렀다면
				    	$.ajax({
							url : "/api/emp/concert/seat/update",
							type : "post",
							contentType : "application/json; charset=utf-8",
							data : JSON.stringify(data),
							beforeSend : function(xhr){
								xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}")
							},
							success : function(res){
								let {result, concertNo} = res;
								if(result == "OK"){
									sweetAlert("success","등급 또는 가격 수정 완료했습니다.");
									$("#seatCancelBtn").click();
									getSeatInfo(concertNo);
								}
							},
							error : function(err){
								sweetAlert("error","등급 또는 가격 수정에 실패했습니다.");
							}

						})
				    }
				});
		})

		const hall = document.getElementById("hall");
		let section;
		hall.onload = function(){
			const svgDocument = this.contentDocument;
			section = svgDocument.querySelectorAll('g[class^="section_"]');

			$(section).each((i,v)=>{
				$(v).css("cursor","pointer")
			})

			$(section).on("click",function(){
				let seatGradeCode = $(this).data("seatGradeCode");
				let seatSection = $(this).data("seatSection");
				let concertNo = $(this).data("concertNo");
				let seatPrice = $(this).data("seatPrice");
				if(seatSection != null && seatGradeCode != null && seatPrice != null && concertNo != null){
					$("#concertNo").val(concertNo);
					$("#seatSection").val(seatSection);
					$("#seatGrade").val(seatGradeCode);
					$("#seatPrice").val(seatPrice);
					seatModal.modal("show")
				}else{
					sweetAlert("error","좌석정보를 못 불러왔습니다.");
				}
			})
		}



		let concertSelect = $("#concertSelect"); // 콘서트 정보 불러오기
		let selectedConcert = concertSelect.val();
		// 첫 로딩 때 선택된 콘서트 불러오기
		if(selectedConcert != ""){
			getSeatInfo(selectedConcert);
		}

		concertSelect.on("change",function(){
			let concertNo = $(this).val();
			getSeatInfo(concertNo);
		})

		function getSeatInfo(concertNo){
			$.ajax({
				url : `/api/emp/concert/getseatinfo?concertNo=\${concertNo}`,
				type : "get",
				success : function(res){
					let {seatGradeList} = res
					let seatHtml = ``;
					if(seatGradeList.length > 0){
						for(let seatGrade of seatGradeList){
							let {seatGradeNm,seatPrice,seatGradeCode,seatSection,sectionCount} = seatGrade
							seatHtml += `
								<tr>
									<td>\${seatSection}구역</td>
									<td>\${seatGradeNm}</td>
		                            <td class="text-center">\${seatPrice.toLocaleString()}</td>
		                            <td>\${sectionCount}</td>
		                            <td>
		                            	<button class="btn btn-sm btn-primary edit-seat-btn"
		                            	data-seat-grade-code="\${seatGradeCode}"
		                            	data-seat-section="\${seatSection}"
		                            	data-concert-no="\${concertNo}"
		                            	data-seat-price="\${seatPrice}"
		                            	data-bs-target="#seatModal" data-bs-toggle="modal">수정</button>
		                            </td>
	                            </tr>
							`;

							section.forEach(v=>{
								if ($(v).hasClass('section_' + seatSection)) {
									$(v).data("seatGradeCode",seatGradeCode);
									$(v).data("seatSection",seatSection);
									$(v).data("concertNo",concertNo);
									$(v).data("seatPrice",seatPrice);
									$(v).data("bsTarget","#seatModal");
									$(v).data("bsToggle","modal");
								}
							})
						}
					}else{
						section.forEach(v=>$(v).removeData())
					}

					$("#seatTableBody").html(seatHtml);
				},
				error : function(err){
					console.log(err);
				}
			})
		}
	});
</script>
</body>
</html>