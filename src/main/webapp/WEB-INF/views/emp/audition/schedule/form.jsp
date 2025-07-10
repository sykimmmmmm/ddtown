<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/41.3.1/classic/ckeditor.js"></script>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN - 오디션 일정 등록페이지</title>
    <%@ include file="../../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/audition_management_style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
.audition-detail-header {
    margin-bottom: 20px; /* 제목 위쪽 여백 조정 */
}

.audition-field-row {
    display: flex;
    align-items: center; /* 수직 중앙 정렬 */
    margin-bottom: 15px; /* 각 줄 사이의 간격 조정 */
}

.audition-field-row strong {
    width: 80px; /* 레이블의 너비를 고정하여 정렬 */
    display: inline-block;
    text-align: left;
    margin-right: 10px; /* 레이블과 입력 필드 사이의 간격 */
}

 /* 저장,취소 버튼 */
      .audition-detail-actions {
    display: flex;         /* 이 컨테이너를 Flexbox로 만듭니다. */
    justify-content: flex-end; /* 모든 자식 요소를 오른쪽 끝으로 정렬합니다. */
    align-items: center;   /* 자식 요소들을 수직 중앙에 정렬합니다. */
    gap: 10px;             /* 자식 요소들 사이에 10px 간격을 줍니다. */
}
</style>
</head>
<body>
     <div class="emp-container">
     	<%@ include file="../../modules/header.jsp" %>
        <div class="emp-body-wrapper">
        	<%@ include file="../../modules/aside.jsp" %>
<!--  main  -->
			<main class="emp-content">
				<section class="audition-detail-hero">
		            <div class="container">
		                <h2>오디션 등록페이지</h2>
		            </div>
		        </section>
				<section class="audition-detail-section">
		            <div class="container">
						<form class="apply-form" action="/emp/audition/insert.do" method="post" id="signupForm" enctype="multipart/form-data">
							<sec:csrfInput/>
			                <div class="audition-detail-header">
			                    <span class="audition-status recruiting">
			                    		<strong>현재 상태 : </strong>&nbsp;&nbsp;&nbsp;&nbsp;
				                   <select id="audiStatCode" name="audiStatCode" class="am-filter-select" style="width: 200px;">
				                   		<option value="">전체</option>
									    <option value="ADSC001">예정</option>
									    <option value="ADSC002">진행중</option>
									    <option value="ADSC003">마감</option>
									</select>
			                    </span>
			                </div>
			                <div class="audition-field-row">
			                	<strong>제 목 : </strong>
			                    <input type="text" id="audiTitle" name="audiTitle" value="<c:out value='${audition.audiTitle }'  />" style="width: 80%;" placeholder="제목을 입력해주세요" required><br/>
			                </div>
			                <div class="audition-field-row">

			                    <strong>모집 분야 : </strong>
			                    	<select id="audiTypeCode" name="audiTypeCode" class="am-filter-select" style="width: 200px;">
			                    		<option value="">전체</option>
									    <option value="ADTC001">보컬</option>
									    <option value="ADTC002">댄스</option>
									    <option value="ADTC003">연기</option>
									</select>
									</div>
									<div class="audition-field-row">
			                    <strong>접수 시작일 : </strong>
			                    	<input type="date" id="audiStartDate" name="audiStartDate" value="${audition.audiStartDate}" style="width: 200px;"/>&nbsp;&nbsp;~&nbsp;&nbsp;
			                     <strong>접수 마감일 : </strong>
			                    	<input type="date" id="audiEndDate" name="audiEndDate" value="${audition.audiEndDate}" style="width: 200px;"/>
			                  </div>


			                <div class="audition-detail-content">
			                    <h4>오디션 내용</h4>
			                   <p>
			       				 <textarea id="audiContent" name="audiContent" class="form-control" style="width: 100%; height: 300px;" value="${audition.audiModDate}"></textarea>
			    				</p>
			                </div>

			                <div class="audition-detail-attachments">

							    <h4>첨부파일</h4>
							    <input type="file" id="audiMemFiles" name="audiMemFiles" class="form-control-file mt-2" multiple="multiple" />
			                </div></br>
			                <div class="audition-detail-actions">
			                  	<button  type="button" class="btn btn-primary" id="signupBtn" name="signupBtn">저장</button>
			                    <button type="reset" class="btn btn-secondary"
                        			onclick="javascript:location.href='/emp/audition/schedule'">취소</button>
			                </div>
			        	</form>
		            </div>
		        </section>
			</main>
		</div>
	</div>
</body>
<%@ include file="../../../modules/footerPart.jsp" %>

<%@ include file="../../../modules/sidebar.jsp" %>
<script type="text/javascript">
//CKEDITOR 초기화
document.addEventListener('DOMContentLoaded', function() {
    ClassicEditor
        .create( document.querySelector( '#audiContent' ))
        .then( editor => {
            editorInstance = editor; // **여기서 CKEditor 5 인스턴스를 editorInstance에 저장합니다.**
            editor.editing.view.change( writer => {
                writer.setStyle( 'min-height', '600px', editor.editing.view.document.getRoot() );
            });
        })
        .catch( error => {
            console.error( 'CKEditor 5 초기화 오류:', error );
            sweetAlert("error", "에디터 초기화 중 오류가 발생했습니다. 새로고침 후 다시 시도해주세요.");
        });
});

$(function(){
	let signupBtn = $("#signupBtn");			//등록하기 Element
	let signupForm = $("#signupForm");		// 등록하기 Form Element

	signupBtn.on("click",function(){
		let audiTitle = $("#audiTitle").val();		// 오디션 제목
		let audiTypeCode = $("#audiTypeCode").val();		// 모집 분야 코드
		let audiStatCode = $("#audiStatCode").val();		// 진행 상태 코드
		let audiContent = ""; // 기본값 설정
			audiContent = editorInstance.getData(); // CKEditor 5 인스턴스에서 데이터 가져오기
		let audiStartDate = $("#audiStartDate").val();		// 지원 접수 시작일
		let audiEndDate = $("#audiEndDate").val();		// 지원 접수 마감일
		let audiMemFiles = $("#audiMemFiles").val();
		let audiMemFilesInput = $("#audiMemFiles")[0];	// 업로드 파일들

		// 유효성 검사
		if (audiStatCode == null || audiStatCode === "") {
	        sweetAlert("error", "오디션 상태를 선택해주세요!");
	        $("#audiStatCode").focus();
	        return false;
	    }
		if(audiTitle == null || audiTitle.trim() == ""){
			sweetAlert("error","제목을 입력해주세요!");
			return false;
		}
		if (audiTypeCode == null || audiTypeCode === "") {
	        sweetAlert("error", "모집 분야를 선택해주세요!");
	        $("#audiTypeCode").focus();
	        return false;
	    }

		if (audiStartDate == null || audiStartDate === "") {
	        sweetAlert("error", "지원 접수 시작일을 입력해주세요!");
	        $("#audiStartDate").focus();
	        return false;
	    }
		if (audiEndDate == null || audiEndDate === "") {
	        sweetAlert("error", "지원 접수 마감일을 입력해주세요!");
	        $("#audiEndDate").focus();
	        return false;
	    }
		if(audiContent == null || audiContent.trim() == ""){
			sweetAlert("error","내용을 입력해주세요!");
			return false;
		}
// 		console.log("--- 오디션 등록/수정 값 확인 (console.log) ---");
// 	    console.log("제목 (audiTitle):", audiTitle);
// 	    console.log("모집 분야 코드 (audiTypeCode):", audiTypeCode);
// 	    console.log("진행 상태 코드 (audiStatCode):", audiStatCode);
// 	    console.log("오디션 내용 (audiContent):", audiContent);
// 	    console.log("지원 접수 시작일 (audiStartDate):", audiStartDate);
// 	    console.log("지원 접수 마감일 (audiEndDate):", audiEndDate);

	    signupForm.submit();
	})
})


</script>