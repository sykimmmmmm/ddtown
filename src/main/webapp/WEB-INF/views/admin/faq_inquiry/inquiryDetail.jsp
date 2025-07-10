<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 상세 및 답변 - DDTOWN 관리자</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript" src="https://cdn.ckeditor.com/ckeditor5/41.3.1/classic/ckeditor.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<%@ include file="../../modules/headerPart.jsp" %>

<style type="text/css">
	.answer-header {
	    display: flex;
	    justify-content: space-between;
	}

	.ea-btn.warning {
	    background-color: #ffc107;
	    color: #212529;
	    border-color: #ffc107;
	    width: 70pt;
	    position: relative;
	}

	.answer-header {
	    display: flex;
	    justify-content: space-between;
	    margin-top: 0;
	    margin-bottom: 15px;
	    padding-bottom: 10px;
	    border-bottom: 1px dashed #ddd;
	    align-content: center;
	    align-items: center;
	}
	.answer-cate {
	    font-size: 1.1em;
	    color: #2c3e50;
	    font-weight: 600;
	}

	a {
		color : black;
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
	const currentUrl = location.href;
    const sliceUrl = currentUrl.split("/");
    const inqNo = sliceUrl[sliceUrl.length -1];
    let editorInstance; // 에디터 인스턴스를 저장할 변수를 선언합니다.

    ClassicEditor
        .create(document.querySelector('#inqAnsContent'))
        .then(newEditor => {
            editorInstance = newEditor;
        })
        .catch(error => {
            console.error(error);
        });

    let inqStatCode = null;

    $.ajax({
    	url : "/admin/inquiry/detailData/"+inqNo,
    	type : "get",
    	success : function(res){
    		let className = "";
    		inqStatCode = res.statDetailCode;
    		let peopleInfo = res.phone + " ( " + res.userEmail + " ) ";

    		$("#inqNo").html(res.inqNo);
    		if(res.inqStatCodeDes == '접수됨'){
    			className = "status-badge pending";
    			$("#inqStatCodeDes").attr('class',className)
    		}else{
    			className = "status-badge answered";
    			$("#inqStatCodeDes").attr('class',className)
    		}
    		$("#inqStatCodeDes").html(res.inqStatCodeDes);
    		$("#inqUsername").html(res.memUsername);
    		$("#inqTypeCodeDes").html(res.inqTypeCodeDes);
    		$("#inqRegDate").html(dateFormat(res.inqRegDate));
    		$("#peopleInfo").html(peopleInfo);
    		$("#inqTitle").html(res.inqTitle);
    		$("#inqContent").html(res.inqContent);
    		$("#inqStatCode").val(inqStatCode);

    		if(res.inqAnsContent != null && res.inqAnsContent != ""){
    			$("#answerHistorySection").attr("style","display:block;");
    			$("#previousAnswer").attr("style","display:block;");
    			$("#prevAnswerer").html(res.empUsername);
    			$("#prevAnswerDate").html(dateFormat(res.inqAnsRegDate));
    			$("#previousAnswerContent").html(res.inqAnsContent);
    			$("#answerForm").attr("style","display:none;");
    			$("#submitAnswerBtn").attr("style","display:none");
    		}
    	},
    	error : function(error, status, thrown){
    		console.log(error.status);
    	}
    });

    $("#cancelBtn").on("click",function(){
    	if($("#cancelBtn").html() != "수정취소"){
	    	Swal.fire({
	    		title : "목록으로 돌아가시겠습니까?",
	    		text : "작성중이었던 내용은 저장되지 않습니다.",
	    		icon : 'warning',
	    		showCancelButton: true,
	    		confirmButtonColor: '#3085d6',
	   	      	cancelButtonColor: '#d33',
	   	      	confirmButtonText: '예',
	   	     	 cancelButtonText: '취소',
	    	}).then((result) => {
	    		if(result.isConfirmed){
	    			location.href="/admin/inquiry/main";
	    		}
	    	});
    	}else{
    		Swal.fire({
    			title : '수정을 취소하시겠습니까?',
    			text : '작성중이었던 내용은 저장되지 않습니다.',
    			icon : 'warning',
    			showCancelButton : true,
    			confirmButtonColor: '#3085d6',
	   	      	cancelButtonColor: '#d33',
	   	      	confirmButtonText: '예',
	   	     	cancelButtonText: '취소'
    		}).then((result) => {
    			if(result.isConfirmed){
    				$("#answerForm").attr("style","display:none;");
    				$("#submitAnswerBtn").attr("style","display:none");
    				$("#cancelBtn").html("목록으로");
    			}
    		});
    	}
    });

    $("#submitAnswerBtn").on("click",function(){
	    	let inqAnsContent = editorInstance.getData();
	    	let inqStatCode = $("#inqStatCode").val();
	    	let data = new FormData();
	    	data.append("inqAnsContent",inqAnsContent);
	    	data.append("statDetailCode", inqStatCode);

    	if($("#submitAnswerBtn").html() == "수정하기"){
    		Swal.fire({
    			title : "문의 답변을 수정하시겠습니까?",
    			icon : 'question',
    			showCancelButton : true,
    			confirmButtonText : '수정',
    			cancelButtonText : '취소',
    		}).then((result) => {
    			if(result.isConfirmed){
    				$.ajax({
    					url : "/admin/inquiry/update/" + inqNo,
    					type : "post",
    					data : data,
    					contentType : false,
    					processData : false,
    					success : function(res){
    						if(res == "OK"){
    							Swal.fire({
    								title : '수정 완료!',
    								text : '수정이 완료되었습니다!',
    								icon : 'success',
    								showConfrimButton : true
    							}).then((result) => {
    								if(result.isConfirmed){
    									location.href = "/admin/inquiry/detail/" + inqNo;
    								}
    							});
    						}else{
    							Swal.fire({
    								title : '수정 실패!',
    								text : '문의 답변 수정에 실패했습니다. 다시 시도해주세요!',
    								icon : 'error'
    							});
    						}
    					},
    					error : function(error, status, thrown){
    						console.log(error.status);
    						Swal.fire({
								title : '수정 실패!',
								text : '문의 답변 수정에 실패했습니다. 다시 시도해주세요!',
								icon : 'error'
							});
    					},
    					beforeSend : function(xhr) {
	        		        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
	        		    }
    				});
    			}
    		});
    	}else{
	    	Swal.fire({
	    		title : "문의 답변을 등록하시겠습니까?",
	    		icon : 'question',
	    		showCancelButton : true,
	    		confirmButtonText : '저장',
	    		cancelButtonText : '취소',
	    	}).then((result) => {
	    		if(result.isConfirmed){
	    			$.ajax({
	    				url : "/admin/inquiry/insert/" + inqNo,
	    				type : "post",
	    				data : data,
	    				contentType : false,
	    				processData : false,
	    				success : function(res){
	    					if(res == "OK"){
	    						Swal.fire({
	    							title : '등록 완료!',
	    							text : '문의 답변 등록이 완료되었습니다!',
	    							icon : 'success',
	    							showConfrimButton : true,
	    						}).then((result) => {
	    							location.href = "/admin/inquiry/detail/"+inqNo;
	    						});
	    					}else{
	    						Swal.fire({
    								title : '등록 실패!',
    								text : '문의 답변 등록에 실패했습니다. 다시 시도해주세요!',
    								icon : 'error'
    							});
	    					}
	    				},
	    				error : function(error, status, thrown){
	    					console.log(error.status);
	    					Swal.fire({
								title : '등록 실패!',
								text : '문의 답변 등록에 실패했습니다. 다시 시도해주세요!',
								icon : 'error'
							});
	    				},
	    				beforeSend : function(xhr) {
	        		        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
	        		    }
	    			});
	    		}
	    	});

    	}

    });

    $("#updateAnswerBtn").on("click",function(){
    	$("#answerForm").attr("style","display:block;");
    	let submitAnswerBtn = $("#submitAnswerBtn");
    	submitAnswerBtn.html("수정하기");
    	submitAnswerBtn.attr("class", "ea-btn warning");
    	$("#cancelBtn").html("수정취소");
    	editorInstance.setData($("#previousAnswerContent").html());
    	$("#submitAnswerBtn").attr("style","display:block");
    });
});

function contentLengthCheck(ele){
	let size = ele.value.length;
	let text = ele.value;


	if(size > 1000){
		let subText = text.substring(0,650);
		ele.value = subText;
		Swal.fire({
			title : "입력초과!",
			text : "문의 답변은 1000자 이상 작성하실 수 없습니다.",
			icon : "error",
			timer : "1500"
		}).then((result) => {
			$(ele).parents("#inquiryAnswerForm").find(".cmt-sub-size").text(subText.length);
			return false;
		});
	}

	$(ele).parent("#inquiryAnswerForm").find(".cmt-sub-size").text(size);
}



</script>
<body>
<div class="emp-container">
	<%@ include file="../modules/header.jsp" %>



       <div class="emp-body-wrapper">
           <%@ include file="../modules/aside.jsp" %>

			<main class="emp-content" style="font-size: large;">
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#">고객센터</a></li>
					  <li class="breadcrumb-item" aria-current="page"><a href="${pageContext.request.contextPath}/admin/inquiry/main">1:1문의</a></li>
					  <li class="breadcrumb-item active" aria-current="page">1:1문의 상세</li>
					</ol>
				</nav>
				<section id="csInquiryDetailSection" class="ea-section active-section" style="font-size: larger;">
					<div class="ea-section-header">
			            <h2 id="inquiryDetailTitle">1:1 문의 상세 및 답변</h2>
			        </div>

			        <div class="inquiry-detail-container">
			        	<section class="inquiry-section user-inquiry">
			        		<h3>사용자 문의 내용</h3>
			        		<dl class="inquiry-meta-grid">
			        			<div><dt>문의 번호:</dt><dd id="inqNo"></dd></div>
			        			<div><dt>문의 상태:</dt><dd><span class="status-badge pending" id="inqStatCodeDes"></span></dd></div>
			        			<div><dt>문의자 ID:</dt><dd id="inqUsername"></dd></div>
			        			<div><dt>문의 유형:</dt><dd id="inqTypeCodeDes">배송</dd></div>
			                    <div><dt>문의일:</dt><dd id="inqRegDate"></dd></div>
			                    <div style="white-space: nowrap;"><dt>연락처(이메일):</dt><dd id="peopleInfo"></dd></div>
			        		</dl>
			        		<h4>문의 제목: <span id="inqTitle" style="font-weight:normal;"></span></h4>
			                <div class="inquiry-content-view" id="inqContent"></div>
			        	</section>

			        	<section class="inquiry-section answer-history" id="answerHistorySection" style="display:none">
			        		<div class="answer-header">
				        		<div class="answer-cate">답변 내역</div>
				        		<button type="button" class="ea-btn primary" id="updateAnswerBtn">수정</button>
			        		</div>
			        		<div class="answer-item" id="previousAnswer" style="display:none;">
			        			<div class="answer-meta">
			        				<span id="prevAnswerer"></span> | <span id="prevAnswerDate"></span>
			        			</div>
			        			<div class="answer-text" id="previousAnswerContent">
			        			</div>
			        		</div>
			        	</section>
			        	<section class="inquiry-section answer-form" id="answerForm" style="display:block">
			        		<h3 id="answerFormTitle">답변 작성</h3>
			        		<form class="ea-form" id="inquiryAnswerForm">
			        			<input type="hidden" id="inqNo" name="inqNo">
			        			<input type="hidden" id="inqStatCode" name="inqStatCode" />
			        			<label for="inqAnsContent">답변 내용</label>
			        			<textarea id="inqAnsContent" name="answerContent" ></textarea>
			        			<div class="text-right pt-2">
									<span class="pt-1"><span class="cmt-sub-size">0</span>/1000</span>
								</div>
			        		</form>
			        	</section>
			       		<div class="ea-form-actions">
			                <button type="button" class="ea-btn primary" id="submitAnswerBtn" style="display:block">등록</button>
			                <button type="button" class="ea-btn outline" id="cancelBtn">목록</button>
			            </div>
			        </div>
				</section>
			</main>
		</div>
	</div>
</body>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
</html>