<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>자주 묻는 질문</title>

<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/fontawesome-free/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/reset.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/variables.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/components/navigation.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/components/buttons.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/components/footer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/notice.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/cs_main.css">
<!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/admin_portal.css">-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script type="text/javascript">
	<c:if test="${not empty message }">
		Swal.fire({
				title : "${message }",
				icon : "success",
				draggable : true
			});
		<c:remove var="message" scope="request"/>
		<c:remove var="message" scope="session"/>
	</c:if>
	function sweetAlert(type, msg){
		Swal.fire({
			title : msg,
			icon : type,
			draggable : true
		});
	}
</script>



<%--
    headerPart.jsp에 다음이 로드되고 있다고 가정합니다:
    - AdminLTE CSS, FontAwesome CSS, iCheck Bootstrap CSS (또는 AdminLTE 내장)
    - jQuery, SweetAlert2
    - 사용자가 제공한 커스텀 CSS 파일들 (reset.css, variables.css, base.css, layout.css, cs_main.css 등)

    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !!! 중요: 아코디언 기능 및 AdminLTE 전체 기능이 정상 작동하려면                    !!!
    !!! 아래 JavaScript 파일들이 headerPart.jsp 또는 이 페이지 하단에 반드시 로드되어야 합니다 !!!
    !!! (jQuery 다음, adminlte.min.js 이전에 bootstrap.bundle.min.js 로드)           !!!
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    --%>
<style>
    /*
    ========================================
    :root - 테마 색상 및 공통 변수 정의
    ========================================
    */
    :root {
        --dd-purple: #8A2BE2; /* 헤더의 메인 보라색 */
        --dd-purple-dark: #7322bf;
        --dd-purple-light: #f3eaff;
        --dd-gray-100: #f8f9fa;
        --dd-gray-200: #e9ecef;
        --dd-gray-500: #adb5bd;
        --dd-gray-700: #495057;
        --dd-text-dark: #212529;
        --dd-text-light: #6c757d;
        --dd-font: 'Source Sans Pro', 'Malgun Gothic', sans-serif;
    }

    /*
    ========================================
    전체 레이아웃 및 기본 스타일
    ========================================
    */
  	body {
	    background: linear-gradient(135deg, #1a1a2e 0%, #2a1e4a 50%, #8a2be2 100%); /* 중간색을 약간 더 보라색 계열로 조정 */
	    background-attachment: fixed; /* 배경을 뷰포트에 고정 */
	    background-size: cover; /* 배경이 전체 영역을 커버하도록 */
	    min-height: 100vh;
	    margin: 0;
	    font-family: "Noto Sans KR", 돋움, Dotum, 굴림, Gulim, Tahoma, Verdana, sans-serif;
	    color: #ffffff;
	    overflow-x: hidden;
	}

    .wrapper {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }

    .content-wrapper.no-layout {
        margin-left: 0 !important;
        flex-grow: 1;
        background-color: transparent; /* wrapper 배경색을 사용하도록 투명 처리 */
    }

    /* 페이지 메인 타이틀 */
    .page-main-title {
        font-size: 2.5rem;
        font-weight: 700;
        color: white;
        text-align: center;
        margin-bottom: 2rem !important;
    }

    /*
    ========================================
    탭 메뉴 (FAQ / 1:1 문의)
    ========================================
    */
    .tabListArea {
        display: flex;
        justify-content: center; /* 탭 메뉴를 중앙에 배치 */
        border-bottom: 2px solid var(--dd-gray-200);
        margin-bottom: 2.5rem;
    }

    .nav-tabs {
        border-bottom: none; /* 부트스트랩 기본 밑줄 제거 */
    }

    .nav-tabs .nav-item {
        margin-bottom: -2px; /* 탭이 하단 경계선에 걸치도록 조정 */
    }

    .nav-tabs .nav-link {
        border: none;
        border-bottom: 2px solid transparent;
        color: white;
        font-size: 1.2rem;
        font-weight: 600;
        padding: 0.8rem 1.8rem;
        transition: all 0.2s ease-in-out;
    }

    .nav-tabs .nav-link:hover {
        color: #a06fff;
    }

    /* 활성화된 탭 스타일 */
    .nav-tabs .nav-link.active {
        color: var(--dd-purple);
        border-bottom: 2px solid var(--dd-purple);
        background-color: transparent;
    }

    /*
    ========================================
    FAQ 섹션
    ========================================
    */

    /* 검색 폼 스타일 */
    #faqList .card-body > form {
        display: flex;
        gap: 10px;
        align-items: center;
        margin-bottom: 2rem;
    }
    #faqList #searchWord { flex-grow: 1; }
    #faqList #searchBtn {
        background-color: var(--dd-purple);
        border-color: var(--dd-purple);
        color: white;
    }
    #faqList #searchBtn:hover {
        background-color: var(--dd-purple-dark);
        border-color: var(--dd-purple-dark);
    }

    /* 아코디언(FAQ 목록) 스타일 */
    .faq-accordion .card {
        border: 1px solid var(--dd-gray-200);
        border-radius: .5rem;
        margin-bottom: 1rem;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        overflow: hidden; /* radius 적용을 위해 */
    }
    .faq-accordion .card-header {
        padding: 0;
        background-color: #fff;
        border-bottom: none;
    }

    .faq-accordion .btn-faq-toggle {
        color: var(--dd-text-dark);
        font-weight: 600;
        font-size: 1.1rem;
        padding: 1rem 1.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
        text-align: left;
        text-decoration: none;
        background: none;
        border: none;
        position: relative;
    }

    .faq-accordion .btn-faq-toggle:hover {
        background-color: var(--dd-purple-light);
    }

    .faq-accordion .btn-faq-toggle .faq-icon {
        transition: transform .2s ease-in-out;
    }

    /* 아코디언 열렸을 때 스타일 */
    .faq-accordion .btn-faq-toggle[aria-expanded="true"] {
        color: var(--dd-purple);
    }
    .faq-accordion .btn-faq-toggle[aria-expanded="true"] .faq-icon {
        transform: rotate(-180deg);
    }

    /* FAQ 답변 영역 */
    .faq-answer-body {
        padding: 1.5rem !important;
        background-color: #fff;
        line-height: 1.8;
        color: var(--dd-text-light);
        border-top: 1px solid var(--dd-gray-200);
    }
    .faq-answer-body > strong:first-child {
        color: var(--dd-purple);
        font-weight: 700;
        margin-right: 5px;
    }

    /* 페이지네이션 */
    .pagination-container {
        margin-top: 2.5rem;
    }
    .pagination .page-item .page-link { color: var(--dd-purple); }
    .pagination .page-item.active .page-link {
        background-color: var(--dd-purple);
        border-color: var(--dd-purple);
        color: white;
    }

    /*
    ========================================
    1:1 문의 섹션
    ========================================
    */
    #inquiryList .list-group-item {
        transition: background-color 0.2s ease;
    }
    #inquiryList .list-group-item:hover {
        background-color: var(--dd-gray-100);
    }

    /* 문의 등록 버튼 */
    #modalOpen {
        background-color: var(--dd-purple); /* 대체될 값이지만, 변수 정의가 없다면 기본으로 남겨둠 */
	    border-color: var(--dd-purple);   /* 대체될 값이지만, 변수 정의가 없다면 기본으로 남겨둠 */
	    color: #fff; /* 글자색은 흰색 유지 */
	    padding: 12px 20px; /* 패딩을 늘려 버튼 크기 확보 */
	    font-size: 1.05em; /* 글자 크기 살짝 키우기 */
	    border: none; /* 테두리 없애기 */
	    border-radius: 10px; /* 모서리 둥글게 */
	    cursor: pointer; /* 마우스 오버 시 커서 변경 */
	    background: linear-gradient(135deg, #c471ed 0%, #b36ffb 100%); /* 밝은 보라에서 진한 보라 그라데이션 */
	    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3); /* 깊이감 있는 그림자 */
	    transition: all 0.3s ease; /* 모든 속성에 부드러운 전환 효과 */
	    outline: none;
    }
    #modalOpen:hover {
        background: linear-gradient(135deg, #b36ffb 0%, #a260f0 100%); /* 호버 시 더 진하고 깊은 그라데이션 */
	    transform: translateY(-4px); /* 버튼이 더 크게 올라오는 효과 */
	    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
    }
    #modalOpen:active {
	    background: linear-gradient(135deg, #a260f0 0%, #904ddb 100%); /* 클릭 시 가장 진한 그라데이션 */
	    transform: translateY(0); /* 원래 위치로 돌아가며 눌리는 느낌 */
	    box-shadow: 0 3px 8px rgba(0, 0, 0, 0.2); /* 그림자 약하게 */
	}

    /*
    ========================================
    모달 (1:1 문의 작성)
    ========================================
    */
    .modal_1 {
        background-color: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
    }

    .modal-content {
        border-radius: 0.75rem !important;
    }

    .modal-header {
        background-color: var(--dd-purple-light);
        border-bottom: none;
        padding: 1.2rem 1.5rem;
    }
    .modal-header .modal-title { color: var(--dd-purple-dark); }
    .modal-header .close {
        font-size: 1.5rem;
        background: transparent;
        border: none;
        opacity: 0.7;
    }
    .modal-header .close:hover { opacity: 1; }

    .form-control:focus, .form-select:focus {
        border-color: var(--dd-purple);
        box-shadow: 0 0 0 0.25rem rgba(138, 43, 226, 0.25);
    }

    #insertBtn {
        background-color: var(--dd-purple);
        border-color: var(--dd-purple);
        width: 150px;
    }
    .text-center.border-top.pt-3.mt-3 {
	    display: flex;
	    justify-content: end;
	    gap : 5px;
	}
    #insertBtn:hover {
        background-color: var(--dd-purple-dark);
        border-color: var(--dd-purple-dark);
    }

    .search-container{
    	flex-shrink: 0;
   		display: flex;
	    align-items: center;
	    gap: 10px;
	    /* width: 100px; */
	    width: max-content;
	    align-items: center;
	    /* width: 100%; */
	}
	.searchArea {
	    align-items: center;
	    display: flex;
	    justify-content: space-between;
	;
	}

    #faqList #searchWord {
	    flex-grow: 1;
	    width: 300px;
	}

    #faqList #searchBtn {
	    background-color: var(--dd-purple);
	    border-color: var(--dd-purple);
	    color: white;
	    width: 100px;
	}
    .cateDropdown {
        width: 150px;
	    height: 40px;
	    padding: 5px;
	    border: 1px solid #ccc;
	    border-radius: 4px;
	}

	.category-container label{
		border: 1px solid;
	}

	.category-container label.btn:hover {
		background-color: #8a2be2;
		color : white;
		box-shadow : 5px 5px 10px rgba(0,0,0,0.3);
		transition : all 0.3s ease;;
		opacity: 1;
	}

	.category-container label.btn:focus,
	.category-container input[type=radio]:checked + label.btn{
		background-color: #8a2be2;
		color : white;
	}
	.mt-4.mb-3 {
	    margin-left: auto;
	}
	.footer {
	    display: flex;             /* ⭐ 필수: Flex 컨테이너로 만듭니다. */
	    /* position: relative; (필요에 따라) */
	    margin: 20px 0 0 0;
	    align-items: center;       /* ⭐ 세로 정렬: pagingArea와 버튼의 기준선이 다를 수 있으니 center가 더 깔끔할 수 있습니다. */
	    width: 100%;               /* ⭐ 필수: 부모의 너비를 100%로 확보합니다. */
	    /* justify-content는 여기서는 명시적으로 설정하지 않습니다. margin: auto가 공간을 조절하기 때문입니다. */
	    padding: 0 15px; /* (선택 사항) 푸터 좌우 패딩 */
	}

	.pagingArea {
	    margin-left: auto;  /* ⭐ pagingArea를 가운데로 보내기 위해 왼쪽 마진 최대로 */
	    padding: 5px;
	}

	.assBtn-container {
	    margin-left: auto; /* ⭐ 이 요소를 오른쪽 끝으로 밉니다. */
	    flex-shrink: 0;
	}

	.inqSearchArea {
	    width: 100%;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-bottom: 10px;
	}
	.inq-search-container {
	    display: flex;
	    gap: 5px;
	    width: auto;
	}
	input#inqSearchBtn {
	    width: 100px;
	    color: #fff;
	    padding: 10px 15px;
	    font-size: 1em;
	    border: none;
	    border-radius: 8px;
	    cursor: pointer;
	    background: linear-gradient(135deg, #c471ed 0%, #b36ffb 100%); /* 기본 그라데이션 */
	    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3); /* 기본 그림자 */
	    transition: all 0.3s ease; /* 모든 속성에 부드러운 전환 효과 */
	    outline: none; /* 클릭 시 나타나는 외곽선 제거 */
	}
	/* 호버 시 스타일 */
	input#inqSearchBtn:hover {
	    background: linear-gradient(135deg, #b36ffb 0%, #a260f0 100%); /* 호버 시 약간 더 진한 그라데이션 */
	    transform: translateY(-3px); /* 버튼이 살짝 위로 올라오는 효과를 더 크게 */
	    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.35); /* 그림자도 더 강조 */
	}
	/* 클릭 시 스타일 (선택 사항) */
	input#inqSearchBtn:active {
	    background: linear-gradient(135deg, #a260f0 0%, #904ddb 100%); /* 클릭 시 더 진한 그라데이션 */
	    transform: translateY(0); /* 다시 원래 위치로 돌아가며 눌리는 느낌 */
	    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
	}
	.inq-category-container label {
    border: 1px solid #c299ff; /* 기존 테두리 색상을 약간 더 밝은 보라색으로 조정 */
    color: white; /* 글자색은 흰색 유지 */
    background: linear-gradient(135deg, #a88be8 0%, #7b43a9 100%); /* 부드러운 보라색 그라데이션 */
    padding: 8px 15px; /* 내부 여백 추가로 시각적 개선 */
    border-radius: 5px; /* 모서리를 약간 둥글게 */
    transition: all 0.3s ease; /* 모든 변화에 부드러운 전환 효과 */
    cursor: pointer; /* 클릭 가능한 요소임을 나타냄 */
    display: inline-block; /* 패딩이 잘 적용되도록 블록 요소로 변경 */
}

/* 호버 시 스타일 (선택 사항: 사용자 경험 개선) */
.inq-category-container label:hover {
    background: linear-gradient(135deg, #8b5edb 0%, #6a3a9b 100%); /* 호버 시 더 진한 그라데이션 */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 은은한 그림자 추가 */
    transform: translateY(-2px); /* 살짝 위로 올라오는 효과 */
}

	.inq-category-container label.btn:focus,
	.inq-category-container input[type=radio]:checked + label.btn{
		background-color: #8a2be2;
		color : white;
	}

	button#modalHeaderClose {
	    margin-left: auto;
	}

	button#modalFooterClose {
	    border-radius: 8px;
	    background-color: #dee2e6;
	}

</style>
</head>
<script type="text/javascript">

$(function(){

	faqList();

	$("#inquiryTab").on("click",function(){
		$(".page-main-title").html("1:1 문의");
		getList();
	});

	$("#faqTab").on("click",function(){
		$(".page-main-title").html("자주 묻는 질문");
		faqList();
	});

	let radioButtons = $("input[type='radio']");

	radioButtons.on("click",function(event){
		let code = event.target.value;
	});

	const pagingArea = $('#pagingArea');
    if(pagingArea.length > 0) {
        pagingArea.on('click', 'a', function(event) {
            event.preventDefault();
            const page = $(this).data('page');
            let searchType = $("#searchType").val();
        	let searchWord = $("#searchWord").val();

            let data = {
            	"page" : page,
            	"searchWord" : searchWord,
        		"searchType" : searchType
            }

            faqList(data);
        });
    }

    $("#searchBtn").on("click",function(){
    	let searchType = $("#searchType").val();
    	let searchWord = $("#searchWord").val();

    	let data = {
    		"searchWord" : searchWord,
    		"searchType" : searchType
    	}

    	faqList(data);
    });

    $("#insertBtn").on("click",function(){

    	let typeCode = $("#inqTypeCode").val();

    	if(typeCode == ''){
    		Swal.fire({
    			title : '작성 요청',
    			text : '문의 유형을 선택해주세요!',
    			icon : 'warning'
    		})
    		$("#inqTypeCode").focus();
    		return false;
    	}

    	if($("#inqTitle").val() == '' || $("#inqTitle").val() == null){
    		Swal.fire({
    			title : '작성 요청',
    			text : '문의 제목을 입력해주세요!',
    			icon : 'warning'
    		})
    		$("#inqTitle").focus();
    		return false;
    	}

    	if($("#inqContent").val() == '' || $("#inqContent").val() == null){
    		Swal.fire({
    			title : '작성 요청',
    			text : '문의 내용을 입력해주세요!',
    			icon : 'warning'
    		})
    		$("#inqContent").focus();
    		return false;
    	}

    	Swal.fire({
    		title : '문의 요청',
    		text : '작성하신 문의를 요청하시겠습니까?',
    		icon : "question",
    		showCancelButton : true,
    		confirmButtonText : '예',
    		cancelButtonText : '아니오'
    	}).then((result) => {
    		if(result.isConfirmed){



    			let data = new FormData();

    	    	data.append("inqTitle",$("#inqTitle").val());
    	    	data.append("inqContent",$("#inqContent").val());
    	    	data.append("typeDetailCode",$("#inqTypeCode").val());

    	    	$.ajax({
    	    		url : "/inquiry/insert",
    	    		type : "post",
    	    		data : data,
    	    		processData : false,
    	    		contentType : false,
    	    		success : function(res){
    	    			if(res.status == "OK"){
    	    				Swal.fire({
    	    					title : '문의 등록',
    	    					text : '문의가 정상적으로 등록되었습니다.',
    	    					icon : 'success'
    	    				});
    	    				$("#inquiryModal").modal('hide');
    	    				getList();
    	    			}
    	    		},
    	    		error : function(jqXHR, status, errorThrown){
    	                let errorMessage = "문의 등록 중 오류가 발생했습니다.";
    	                if (jqXHR.responseJSON && jqXHR.responseJSON.message) {
    	                    errorMessage = jqXHR.responseJSON.message;
    	                } else if (jqXHR.statusText) {
    	                    errorMessage += ` (오류: \${jqXHR.statusText})`;
    	                }
    					console.log("Error inserting inquiry: ", jqXHR.status, errorThrown, jqXHR.responseText);
    	                alert(errorMessage);
    				},
    				beforeSend : function(xhr) {
    			        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
    			    }
    	    	});
    		}
    	});

    });

    $("#inquiryModal").on("hide.bs.modal",function(){
    	$("#inquiryForm")[0].reset();
    });

    $("#modalHeaderClose").on('click',function(e){
    	e.preventDefault();
    	Swal.fire({
    		title : '취소요청',
    		text : '작성중인 내용은 저장되지 않습니다.',
    		icon : 'warning',
    		showCancelButton : true,
    		confirmButtonText : '예',
    		cancelButtonText : '아니오'
    	}).then((result) => {
    		if(result.isConfirmed){
    			$("#inquiryModal").modal('hide');
    			$("#inquiryForm")[0].reset();
    		}
    	});
    });

    $("#modalFooterClose").on('click',function(e){
    	e.preventDefault();
    	Swal.fire({
    		title : '취소요청',
    		text : '작성중인 내용은 저장되지 않습니다.',
    		icon : 'warning',
    		showCancelButton : true,
    		confirmButtonText : '예',
    		cancelButtonText : '아니오'
    	}).then((result) => {
    		if(result.isConfirmed){
    			$("#inquiryModal").modal('hide');
    			$("#inquiryForm")[0].reset();
    		}
    	});
    });

    $(".category-container").on("click","input[name=cates]",function(){
    	let data = {
    		"searchType" : $(this).val(),
    		"searchWord" : $("#searchWord").val()
    	}
    	faqList(data);
    });

    $(".pagingArea").on("click","a",function(e){
    	e.preventDefault();
    	const page = $(this).data('page');
    	let data = {
    		"page" : page,
    	}
    	getList(data);
    });

    $(".inq-category-container").on("click","input[type=radio]",function(){
    	let data = {
    		"searchWord" : $("#inqSearchWord").val(),
    		"searchType" : $(this).val()
    	}
    	getList(data);
    });

    $("#inqSearchBtn").on("click",function(){
    	let searchType = $("input[name=inqCates]:checked").val();
    	let data = {
    		"searchWord" : $("#inqSearchWord").val(),
    		"searchType" : searchType
    	}
    	getList(data);

    });

});

function faqList(data){
	$.ajax({
		url : "/faq/main",
		type : "get",
		data : data,
		success : function(res){
			let codeList = res.codeList;
			let list = res.list;
			let pagingVO = res.pagingVO;

			let codeAreaHtml = `
				<input type="radio" class="btn-check" name="cates" id="cateAll" value=""`;
			if(pagingVO.searchType == null || pagingVO.searchType == ''){
				codeAreaHtml += `checked `;
			}

			codeAreaHtml += `
				/>
				<label class="btn" for="cateAll" id="cateAll">전체</label>
			`;

			for(let i=0; i<codeList.length; i++){
				let code = codeList[i];
				codeAreaHtml += `

					<input type="radio" class="btn-check" name="cates" id="\${code.commCodeDetNo}" value="\${code.commCodeDetNo}"
					`;
				if(pagingVO.searchType == code.commCodeDetNo){
					codeAreaHtml += `checked`;
				}
				codeAreaHtml += `
					/>
					<label class="btn" for="\${code.commCodeDetNo}">\${code.description}</label>
				`;
			}
			$(".category-container").html(codeAreaHtml);



			let optionHtml = `<option value="">전체</option>`;
			for(let i=0; i<codeList.length; i++){
				let code = codeList[i];
				let select = "";
				if(pagingVO.searchType != null){
					if(code.commCodeDetNo == pagingVO.searchType){
						select = "selected"
					}
				}
				optionHtml += `
					<option value="\${code.commCodeDetNo }" \${select}>\${code.description }</option>
				`;
			}

			$("#searchType").html(optionHtml);

			let listHtml = ``;
			if(list != null && list.length > 0){

				listHtml = `<div class="accordion faq-accordion" id="faqAccordionList">`;

				for(let i=0; i<list.length; i++){
					let faq = list[i];
					let show = '';
					let collapsed = '';
					let flag = false;
					if(i == 0){
						show = "show";
						collapsed = 'collapsed';
						let flag = true;
					}
					listHtml += `
						<div class="card card-light card-outline mb-2 faq-item-panel" data-category="\${faq.description}">
							<div class="card-header" id="headingFaq_\${faq.faqNo}">
								<h2 class="mb-0">
										<button class="btn-faq-toggle \${collapsed}" type="button"
											data-bs-toggle="collapse" data-bs-target="#collapseFaq_\${faq.faqNo}"
											aria-expanded="\${flag}" aria-controls="collapseFaq_\${faq.faqNo}">
										Q. (\${faq.description}) \${faq.faqTitle}
										<span class="faq-icon"><i class="fas fa-chevron-down"></i></span>
									</button>
								</h2>
							</div>
							<div id="collapseFaq_\${faq.faqNo}" class="collapse \${show}"
								 aria-labelledby="headingFaq_\${faq.faqNo}" data-parent="#faqAccordionList">
								<div class="card-body faq-answer-body">
									A. <c:out value="\${faq.faqAnswer}" escapeXml="true"/> <%-- HTML 태그가 포함될 수 있다면 escapeXml="false" --%>
								</div>
							</div>
						</div>
					`;
				}

				listHtml += `</div>`;

			}else{
				listHtml = `
					<div class="callout callout-info">
						<h5><i class="icon fas fa-info"></i> 정보</h5>
						<p>등록된 FAQ가 없습니다.</p>
					</div>
				`;
			}

			$("#faqListArea").html(listHtml);

			$("#pagingArea").html(pagingVO.pagingHTML);

		},
		error : function(res){
			console.log(res);
		}
	});
}

function getList(data){
	$.ajax({
		url : "${pageContext.request.contextPath}/inquiry/list",
		type : "get",
		data : data,
		success : function(res){
			let pagingVO = res.pagingVO;
			let codeList = res.codeList;

			let inqCateHtml = `<input type="radio" class="btn-check" name="inqCates" id="inqCateAll" value=""`;
			if(pagingVO.searchType == null || pagingVO.searchType == ''){
				inqCateHtml += `checked`;
			}
			inqCateHtml += `
				/>
				<label class="btn" for="inqCateAll" >전체</label>
			`;

			for(let i=0; i<codeList.length; i++){
				let code = codeList[i];
				inqCateHtml += `

					<input type="radio" class="btn-check" name="inqCates" id="\${code.commCodeDetNo}" value="\${code.commCodeDetNo}"
					`;
				if(pagingVO.searchType == code.commCodeDetNo){
					inqCateHtml += `checked`;
				}
				inqCateHtml += `
					/>
					<label class="btn" for="\${code.commCodeDetNo}">\${code.description}</label>
				`;
			}

			$(".inq-category-container").html(inqCateHtml);

			let html = ``;
			if(res.inqVO != null && res.inqVO.length > 0){
				for(let i=0; i<res.inqVO.length; i++){
					let inq = res.inqVO[i];
					let regDate = dateFormat(inq.inqRegDate);

                    let statusDescription = (inq.empUsername && inq.inqAnsContent) ? inq.inqStatCodeDes : "상태 미확인";
                    let statusClass = 'bg-secondary text-white';
                    if (statusDescription === '답변완료') {
                        statusClass = 'bg-success-subtle text-success-emphasis';
                    } else if (statusDescription === '답변대기') {
                        statusClass = 'bg-warning-subtle text-warning-emphasis';
                    }

                    let typeDescription = (inq.typeDetailCode && inq.inqTypeCodeDes) ? inq.inqTypeCodeDes : "유형 미확인";

					html += `
						<a href="${pageContext.request.contextPath}/inquiry/detail/\${inq.inqNo}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 px-3">
                            <div>
								<h5 class="mb-1 fw-bold text-dark fs-6">\${inq.inqTitle ? inq.inqTitle : '제목 없음'}</h5>
								<small class="text-muted small">\${regDate} | \${typeDescription}</small>
                            </div>
							<span class="badge rounded-pill \${statusClass} fw-bold py-2 px-2 small">\${statusDescription}</span>
						</a>
					`;
				}
			}else{
				html = `
					<div class="list-group-item text-center p-5">
	                    <p class="mb-0">등록된 1:1 문의가 없습니다.</p>
	                </div>
				`;
			}

            let option = `<option value="">문의 유형을 선택하세요</option>`;
			if(res.codeList != null && res.codeList.length > 0){
				for(let i=0; i<res.codeList.length; i++){
					let code = res.codeList[i];
					option += `
						<option value="\${code.commCodeDetNo}">\${code.description}</option>
					`;
				}
			}
			$("#inqTypeCode").html(option);
			$("#inqList").html(html);

			$(".pagingArea").html(res.pagingVO.pagingHTML);
		},
		error : function(error, status, xhr){
			console.log("Error fetching list: ", error.status, xhr);
            $("#inqList").html('<div class="list-group-item text-center p-5 text-danger"><p class="mb-0">문의 목록을 불러오는데 실패했습니다. 잠시 후 다시 시도해주세요.</p></div>');
		}
	});
}

function contentLengthCheck(ele){
	let size = ele.value.length;
	let text = ele.value;

	if(size > 1000){
		alert("더이상 작성하실 수 없습니다.");
		let subText = text.substring(0,1000);
		ele.value = subText;

		$(ele).parents("#contentArea").find(".cmt-sub-size").text(subText.length);
		return false;
	}

	$(ele).parents("#contentArea").find(".cmt-sub-size").text(size);
}

function titleLengthCheck(ele){
	let size = ele.value.length;
	let text = ele.value;

	if(size > 100){
		alert("제목은 100자 이상을 넘길 수 없습니다.");
		let subText = text.substring(0,100);
		ele.value = subText;

		return false;
	}

}

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

    return date.getFullYear() + '-' + month + '-' + day + ' ' + hour + ':' + minute + ':' + second;
}

</script>
<body class="hold-transition">
<%@ include file="../../modules/communityHeader.jsp" %>
    <div class="mypage-container">
		<div class="wrapper">
		    <div class="content-wrapper no-layout">
		        <section class="content pt-5 pb-4">
		            <div class="container-fluid">
		                <div class="row">
		                    <div class="col-12 mb-4">
		                        <h1 class="page-main-title">자주 묻는 질문</h1>
		                    </div>
		                </div>
		                <div>
		                	<nav class="tabListArea">
			                	<ul class="nav nav-tabs" id="myTab" role="tablist">
								  <li class="nav-item" role="presentation">
								    <button class="nav-link active" id="faqTab" data-bs-toggle="tab"
								    	data-bs-target="#faqList" type="button" role="tab" aria-controls="faq" aria-selected="true">FAQ</button>
								  </li>
								  <li class="nav-item" role="presentation">
								    <button class="nav-link" id="inquiryTab" data-bs-toggle="tab"
								    	data-bs-target="#inquiryList" type="button" role="tab" aria-controls="inquiry" aria-selected="false">1대1</button>
								  </li>
								</ul>
							</nav>
		                </div>
					<%-- [수정 후] 이 코드로 교체해주세요. --%>
						<div class="tab-content" id="myTabContent">
						    <%-- 1. FAQ 탭 패널 --%>
						    <div class="tab-pane fade show active" id="faqList" role="tabpanel" aria-labelledby="faqTab" tabindex="0">
						        <div class="row">
						            <div class="col-md-10 offset-md-1">
						                <div class="card card-outline card-primary shadow-sm">
						                    <div class="card-body">
						                    	<div class="searchArea">
							                    	<div class="category-container">

							                    	</div>
							                    	<div class="search-container">
								                            <%-- (내용은 그대로 유지) --%>
							                            <select class="cateDropdown" id="searchType" name="searchType">

							                            </select>
							                            <input type="text" class="text-input" id="searchWord" name="searchWord"/>
							                            <input type="button" id="searchBtn" value="검색" class="btn btn-primary"/>
							                    	</div>
						                    	</div>
						                        <hr>
						                        <%-- (이하 FAQ 목록 로직은 그대로 유지) --%>
						                        <div id="faqListArea">
		                                        </div>
						                        <div class="pagination-container" id="pagingArea">
						                            ${pagingVO.pagingHTML}
						                        </div>
						                    </div>
						                </div>
						            </div>
						        </div>
						    </div>

						    <%-- 2. 1:1 문의 탭 패널 --%>
						    <div class="tab-pane fade" id="inquiryList" role="tabpanel" aria-labelledby="inquiryTab" tabindex="0">
							    <%-- 이 div에 max-width를 적용하고, mx-auto로 중앙 정렬합니다. --%>
							    <div class="p-4 d-flex flex-column align-items-center mx-auto" style="max-width: 1500px;">
							    	<div class="inqSearchArea">
				                    	<div class="inq-category-container">

				                    	</div>
				                    	<div class="inq-search-container">
				                            <input type="text" class="text-input" id="inqSearchWord" name="searchWord" placeholder="제목을 입력해주세요."/>
				                            <input type="button" id="inqSearchBtn" value="검색" class="btn btn-primary"/>
				                    	</div>
			                    	</div>
							        <div class="list-group shadow-sm rounded-3 w-100" id="inqList">
							            <%-- JavaScript에 의해 내용이 채워지는 영역 --%>
							        </div>

							        <div class="footer">
								        <div class="pagingArea">
								        </div>

										<div class=assBtn-container>
									        <div class="addBtn">
									            <button class="btn btn-primary rounded-3 fw-bold px-4 py-2" id="modalOpen" data-bs-toggle="modal" data-bs-target="#inquiryModal" style="font-size: 1.1em;">새 문의하기</button>
									        </div>
										</div>
								    </div>
						        </div>
							</div>
						</div>
		            </div>
		        </section>
		    </div>
		</div>
</div>

<div class="modal fade" id="inquiryModal" aria-labelledby="inquiryModalLabel" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content shadow-lg rounded-3 border-0">
            <div class="modal-header px-4 py-3">
                <h2 class="modal-title fs-5 text-dark" id="inquiryModalLabel">1:1 문의하기</h2>
                <%-- Using data-bs-dismiss for the standard close button is cleaner --%>
	            <button type="button" class="close" id="modalHeaderClose"><span aria-hidden="true">x</span></button>
            </div>
            <div class="modal-body p-4">
    	        <form id="inquiryForm">
    	        	<sec:csrfInput/>
    	            <div class="mb-3">
    	                <label for="inquiryName" class="form-label fw-bold text-dark">이름</label>
    	                <sec:authentication property="principal.memberVO.peoName" var="name"/>
    	                <input type="text" class="form-control rounded-3" id="inquiryName" name="inquiryName" value="${name }" readonly>
    	            </div>
    	            <div class="mb-3">
    	                <label for="inqTypeCode" class="form-label fw-bold text-dark">문의 유형</label>
    	                <select class="form-control" id="inqTypeCode" name="inqTypeCode" required>
    	                    <%-- Options populated by JavaScript --%>
    	                </select>
    	            </div>
    	            <div class="mb-3">
    	                <label for="inqTitle" class="form-label fw-bold text-dark">문의 제목</label>
    	                <input type="text" class="form-control rounded-3" id="inqTitle" name="inqTitle" onkeyup="titleLengthCheck(this)" required>
    	            </div>
    	            <div class="mb-3" id="contentArea">
    	                <label for="inqContent" class="form-label fw-bold text-dark">문의 내용</label>
    	                <textarea class="form-control rounded-3" id="inqContent" name="inqContent" rows="5" onkeyup="contentLengthCheck(this)" required style="min-height: 150px;"></textarea>
    	                <div class="text-right pt-2">
							<span class="pt-1"><span class="cmt-sub-size">0</span>/1000</span>
						</div>
    	            </div>
    	            <p class="text-body-secondary small mt-n2 mb-3">문의 내용에 개인정보(주민번호, 카드번호 등)가 포함되지 않도록 주의해주세요.</p>
                </form>
                <div class="text-center border-top pt-3 mt-3">
   	                <input type="button" id="insertBtn" class="btn btn-primary rounded-3 fw-bold px-4 py-2" value="문의 등록" style="font-size: 1.1em;" />
   	                <button type="button" class="close" id="modalFooterClose">닫기</button>
   	            </div>
            </div>
	    </div>
	</div>
</div>
<div id="footer">
       <!-- FOOTER -->
    <jsp:include page="/WEB-INF/views/modules/communityFooter.jsp" />
    <script src="${pageContext.request.contextPath}/resources/js/pages/communityFooter.js"></script>
    <!-- FOOTER END -->
</div>
</body>
</html>