<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN 관리자 - 아티스트 계정 관리</title>
    <%@ include file="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/pages/group-management.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.js"></script>
    <style>
        /* admin_portal.css에 정의된 스타일을 최대한 활용합니다. */
        /* 아티스트명 링크 스타일 */
        .artist-name-link {
            font-weight: 500;
            color: #007bff; /* 기본 링크 색상 */
            text-decoration: none;
        }
        .artist-name-link:hover {
            text-decoration: underline;
        }
        .emp-user-info small{
        	color : white;
       	}
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
			<c:set var="title" value="새 그룹 등록"/>
			<c:if test="${status eq 'U' }">
				<c:set var="title" value="그룹 수정"/>
			</c:if>
			<c:set var="text" value="등록"/>
			<c:if test="${status eq 'U' }">
				<c:set var="text" value="수정"/>
			</c:if>
            <main class="emp-content">
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">아티스트 커뮤니티 관리</a></li>
					  <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/community/group/list" style="color:black;">그룹 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">그룹 등록</li>
					</ol>
				</nav>
                <section class="ea-section">
                    <div class="ea-section-header">
                        <h2>${title }</h2>
                        <button type="button" id="groupDataBtn" class="btn btn-secondary btn-sm">그룹</button>
                    </div>
                    <form class="ea-form" id="newGroupForm" method="post" action="${pageContext.request.contextPath}/admin/community/group/regist" encType="multipart/form-data">
                    	<sec:csrfInput/>
                    	<c:if test="${status eq 'U' }">
	                    	<input type="hidden" name="artGroupNo" value="${artistGroupVO.artGroupNo}">
	                    	<input type="hidden" name="artGroupProfileImg" value="${artistGroupVO.artGroupProfileImg}">
                    	</c:if>
                        <div class="form-group">
                            <label for="groupName">그룹명</label>
                            <input type="text" id="artGroupNm" name="artGroupNm" value="${artistGroupVO.artGroupNm }" required>
                        </div>
                        <div class="form-group">
                            <label for="artGroupDebutdate">데뷔일 / 데뷔 예정일</label>
                            <input type="text" id="artGroupDebutdate" name="artGroupDebutdate" value="${artistGroupVO.artGroupDebutdate }">
                        </div>
                        <div class="form-group" id="autocomplete">
                            <label for="empUsername">담당자 등록</label>
                            <select class="form-control h-20" name="empUsername" id="empUsername">
                            	<c:forEach items="${empList }" var="emp">
                            		<option value="${emp.username }" <c:if test="${artistGroupVO.empUsername eq emp.username}">selected</c:if>>${emp.peoName }</option>
                            	</c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
		                    <fieldset>
		                        <legend style="font-weight: bold; padding: 0; margin-bottom: 5px; border: 0; display: block; width:auto;">활동유형:</legend>
		                        <div class="radio-options-wrapper" style="display: block; margin-left: 0px; margin-top: 5px;">
		                            <label class="radio-label" for="artGroupTypeGroup" style="margin-right: 15px; cursor:pointer; font-weight:normal; display: inline-flex; align-items: center; white-space: nowrap;">
		                                그룹 <input type="radio" name="artGroupTypeCode" value="AGTC001" id="artGroupTypeGroup" style="margin-left: 5px;" checked <c:if test="${artistGroupVO.artGroupTypeCode eq 'AGTC001'}">checked</c:if>>
		                            </label>
		                            <label class="radio-label" for="artGroupTypeSolo" style="cursor:pointer; font-weight:normal; display: inline-flex; align-items: center; white-space: nowrap;">
		                                솔로 <input type="radio" name="artGroupTypeCode" value="AGTC002" id="artGroupTypeSolo" style="margin-left: 5px;" <c:if test="${artistGroupVO.artGroupTypeCode eq 'AGTC002'}">checked</c:if>>
		                            </label>
		                        </div>
		                    </fieldset>
		                </div>

                        <div class="form-group">
                           	<fieldset>
		                        <legend class="form-label" style="font-weight: bold; padding: 0; margin-bottom: 10px; border: 0; display: block; width: auto;">그룹멤버</legend>
		                        <div id="selectedArtistContainer" class="members-container" style="margin-bottom: 10px; min-height: 40px; border: 1px solid #ddd; padding: 8px; border-radius: 4px;">
	                            	<c:forEach items="${artistGroupVO.artistList }" var="artist">
	                            		<p class="member-tag" >
											${artist.artNm }
											<span class="removeAritistBtn" data-art-no="${artist.artNo}">
												<i class="bi bi-x"></i>
											</span>
										</p>
	                            	</c:forEach>
		                        </div>
		                        <div class="input-group-for-member-add" style="display: flex; gap: 8px; align-items: center; margin-bottom: 10px;">
		                            <select id="artistSelect" class="form-control" style="flex-grow: 1;">
		                                <option value="">-- 아티스트 선택 --</option>
		                                <c:forEach items="${artistList}" var="artist">
		                                    <option value="${artist.artNo}_${artist.artNm}">${artist.artNm }</option>
		                                </c:forEach>
		                            </select>
		                            <button type="button" id="addArtistBtn" class="action-button" style="white-space: nowrap;">멤버 추가</button>
		                        </div>
		                    </fieldset>
                        </div>

                        <div class="form-group">
                           	<fieldset>
		                        <legend class="form-label" style="font-weight: bold; padding: 0; margin-bottom: 10px; border: 0; display: block; width: auto;">앨범등록</legend>
		                        <div id="selectedAlbumContainer" class="members-container" style="margin-bottom: 10px; min-height: 40px; border: 1px solid #ddd; padding: 8px; border-radius: 4px;">
	                            	<c:forEach items="${artistGroupVO.albumList}" var="album">
	                            		<p class="member-tag" >
											${album.albumNm }
											<span class="removeAlbumBtn" data-album-nm="${album.albumNm}" data-album-no="${album.albumNo }">
												<i class="bi bi-x"></i>
											</span>
										</p>
	                            	</c:forEach>
		                        </div>
		                        <div class="input-group-for-member-add" style="display: flex; gap: 8px; align-items: center; margin-bottom: 10px;">
		                            <select id="albumSelect" class="form-control" style="flex-grow: 1;">
		                                <option value="">-- 앨범 선택 --</option>
		                                <c:forEach items="${albumList}" var="album">
		                                    <option value="${album.albumNo}_${album.albumNm}">${album.albumNm }</option>
		                                </c:forEach>
		                            </select>
		                            <button type="button" id="addAlbumBtn" class="action-button" style="white-space: nowrap;">앨범 추가</button>
		                        </div>
		                    </fieldset>
                        </div>
                        <div class="form-group">
                            <label for="groupProfileImage">프로필 이미지</label>
                            <input type="file" id="groupProfileImage" name="profileImage" accept="image/*" class="ea-form-control" style="width:auto; height:auto; padding: 5px;">
                            <img id="groupProfileImagePreview" src="" alt="">
                        </div>

                        <div class="form-group">
                            <label for="artGroupContent">그룹 소개</label>
                            <textarea id="artGroupContent" name="artGroupContent" placeholder="그룹에 대한 간략한 소개를 입력하세요." class="ea-form-control">${artistGroupVO.artGroupContent }</textarea>
                        </div>

                        <div class="ea-form-actions">
                        	<c:set var="url" value="/admin/community/group/list"/>
                        	<c:if test="${status eq 'U' }">
	                        	<c:set var="url" value="/admin/community/group/detail?artGroupNo=${artistGroupVO.artGroupNo }"/>
                        	</c:if>
                            <a href="${url }" class="ea-btn outline">취소</a>
                            <button type="submit" class="ea-btn primary" id="registerGroupBtn">${text }</button>
                        </div>
                    </form>
                </section>
            </main>
        </div>
    </div>
</body>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() {

	let groupProfileImage = document.getElementById("groupProfileImage");
	let groupProfileImagePreview = document.getElementById("groupProfileImagePreview");

	groupProfileImage.addEventListener("change",function(){
		const file = this.files[0];
		if(!file.type.startsWith("image/")){
			sweetAlert("error","사진 파일만 입력해주세요");
			this.value = null;
			groupProfileImagePreview.src = "";
			return false;
		}
		const maxSize = 2 * 1024 * 1024;
		if(file.size > maxSize){
			sweetAlert("error", "2MB 미만의 사진만 등록해주세요");
			this.value = "";
			groupProfileImagePreview.src = "";
			return false;
		}

		const reader = new FileReader();
		reader.onload = function(e){
			groupProfileImagePreview.src = e.target.result
			groupProfileImagePreview.css("height", "150px");
		}
		reader.readAsDataURL(file);

	});
});
$(function(){
	// 아티스트 그룹 추가 폼
	let newGroupForm = $("#newGroupForm");
	// 아티스트 추가 등록
	let addArtistBtn = $("#addArtistBtn");
	// 아티스트 기존 멤버 제거
	let removeAritistBtn = $(".removeAritistBtn");
	// 앨범 추가 등록
	let addAlbumBtn = $("#addAlbumBtn");
	// 기존 앨범 삭제
	let removeAlbumBtn = $(".removeAlbumBtn");
	// 추가 할 멤버
	let artistSelect = $("#artistSelect");
	// 추가 할 앨범
	let albumSelect = $("#albumSelect");

	let selectedArtistContainer = $("#selectedArtistContainer");
	let selectedAlbumContainer = $("#selectedAlbumContainer");

	// 업데이트일때 브레드크럼 추가
	let updateFlag = "${status}"||'C';
	if(updateFlag == 'U'){
		let activebread = $("ol.breadcrumb").find("li.active");
		let bread = $(`<li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/community/group/detail?artGroupNo=${artistGroupVO.artGroupNo}" style="color:black;">그룹 상세</a></li>`)
		activebread.text("그룹 수정").before(bread);
	}

	// 아티스트 추가 버튼
	addArtistBtn.on("click",function(){
		let artInfo = artistSelect.val().split("_");
		let artNo = artInfo[0];
		let artNm = artInfo[1];
		let selectedInput = selectedArtistContainer.find(`p.member-tag > span[data-art-no=\${artNo}]`).length;
		if(selectedInput > 0){
			sweetAlert("error","이미 추가된 멤버입니다.");
			return false;
		}
		// 솔로 일때 한명만 선택
		const typeCheck = $("input[name='artGroupTypeCode']:checked").val();
		if(typeCheck == 'AGTC002' && selectedArtistContainer.children().length > 0 ){
			sweetAlert("error", "솔로는 한명만 선택가능합니다!");
			return false;
		}
		const addInput = newGroupForm.find(`input[type="hidden"][name="removeArtists"][value="\${artNo}"]`);
		if(addInput.length > 0){
			addInput.remove();
		}
		let html = ``;
		html += `
			<p class="member-tag" >
				\${artNm }
				<span class="removeAritistBtn" data-art-no="\${artNo}">
					<i class="bi bi-x"></i>
				</span>
			</p>
		`;
		selectedArtistContainer.append(html)
		let hiddenInput = `
			<input type="hidden" name="addArtists" value="\${artNo}">
		`;
		newGroupForm.append(hiddenInput);
	})

	// 아티스트 제거 버튼
	selectedArtistContainer.on("click",".removeAritistBtn",function(){
		let artNo = $(this).data("artNo");
		let div = $(this).parent("p.member-tag");
		div.remove();
		let hiddenInput = `
			<input type="hidden" name="removeArtists" value="\${artNo}">
		`;
		const addInput = newGroupForm.find(`input[type="hidden"][name="addArtists"][value="\${artNo}"]`);
		if(addInput.length > 0){
			addInput.remove();
		}
		newGroupForm.append(hiddenInput);
	});

	// 앨범 추가 버튼
	addAlbumBtn.on("click",function(){
		let artInfo = albumSelect.val().split("_");
		let albumNo = artInfo[0];
		let albumNm = artInfo[1];
		const existingAddInput = newGroupForm.find(`input[type="hidden"][name="addAlbums"][value="${albumNo}"]`);
	    if (existingAddInput.length > 0) {
	        sweetAlert("error", "이미 추가된 앨범입니다."); // 메시지 수정
	        return false;
	    }
		const addInput = newGroupForm.find(`input[type="hidden"][name="removeAlbums"][value="\${albumNo}"]`);
		addInput.remove();
		let html = ``;
		html += `
			<p class="member-tag" >
				\${albumNm }
				<span class="removeAlbumBtn" data-album-nm="\${albumNm}" data-album-no="\${albumNo}">
					<i class="bi bi-x"></i>
				</span>
			</p>
		`;
		selectedAlbumContainer.append(html)
		let hiddenInput = `
			<input type="hidden" name="addAlbums" value="\${albumNo}">
		`;
		newGroupForm.append(hiddenInput);
		albumSelect.find(`option[value="\${albumNo}_\${albumNm}"]`).remove();
	})

	// 앨범 제거 버튼
	selectedAlbumContainer.on("click",".removeAlbumBtn",function(){
		let albumNo = $(this).data("albumNo");
		let albumNm = $(this).data("albumNm");
		let div = $(this).parent("p.member-tag");
		div.remove();
		const albumOpt = new Option(albumNm,albumNo+"_"+albumNm);
		albumSelect.append(albumOpt);
		let hiddenInput = `
			<input type="hidden" name="removeAlbums" value="\${albumNo}">
		`;
		const addInput = newGroupForm.find(`input[type="hidden"][name="addAlbums"][value="\${albumNo}"]`);
		if(addInput.length > 0){
			addInput.remove();
		}
		newGroupForm.append(hiddenInput);
	});

	// 벨리데이션 추가
	$.validator.addMethod("koreanDateFormat", function(value, element) {
        // 정규 표현식: YY/MM/DD 형식 (예: 24/01/15)
        // 연도는 00-99, 월은 01-12, 일은 01-31
        return this.optional(element) || /^\d{4}\/(0[1-9]|1[0-2])\/(0[1-9]|[12]\d|3[01])$/.test(value);
    }, "올바른 날짜 형식(YYYY/MM/DD)으로 입력해주세요.");

	newGroupForm.validate({
        rules: {
            artGroupNm: {
                required: true,
                maxlength: 32
            },
            artGroupDebutdate: {
                required: true,
                koreanDateFormat : true
            },
            empUsername: {
                required: true
            },
            artGroupTypeCode: {
                required: true
            },
            // 'addArtists' 또는 기존 'artistList'가 하나라도 있어야 함
            // 즉, 'selectedArtistContainer'에 p.member-tag가 하나라도 있어야 함
            artGroupMembersExist: { // 가상의 필드 이름, 실제 input 필드와 매핑되지 않음
                required: function(element) {
                    // 기존 멤버 + 새로 추가된 멤버의 총 개수 확인
                    return selectedArtistContainer.children('.member-tag').length === 0;
                }
            },
            // 'profileImage'는 파일이 선택되었을 때만 파일 형식 검사.
            // 'required'는 기존 이미지가 없을 때만 적용 (수정 시나리오)
            profileImage: {
            	required: function(element) {
            		const isUpdateMode = $('input[name="artGroupNo"]').length > 0 && $('input[name="artGroupNo"]').val() !== '';
                    // 수정 모드이면서, 기존 이미지가 있거나 새로운 파일이 선택되었다면 필수가 아님
                    if (isUpdateMode) {
                        return false;
                    }
                    // 그 외의 경우 (등록 모드, 또는 수정 모드인데 기존 이미지 없고 새 파일도 없을 때) 필수
                    return true;
                }
            },
            artGroupContent: {
                required: true,
                maxlength: 600
            }
        },
        messages: {
            artGroupNm: {
                required: "그룹명을 입력해주세요.",
                maxlength: "그룹명은 최대 {0}자까지 입력 가능합니다."
            },
            artGroupDebutdate: {
                required: "데뷔일을 입력해주세요."
            },
            empUsername: {
                required: "담당자를 선택해주세요."
            },
            artGroupTypeCode: {
                required: "활동 유형을 선택해주세요."
            },
            artGroupMembersExist: {
                required: "그룹 멤버를 1명 이상 추가해주세요."
            },
            profileImage: {
                required: "프로필 이미지를 선택해주세요."
            },
            artGroupContent: {
                required: "그룹 소개를 입력해주세요.",
                maxlength: "그룹 소개는 최대 {0}자까지 입력 가능합니다."
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
        showErrors: function(errorMap, errorList) {
            this.defaultShowErrors(); // 기본 오류 메시지 표시 로직도 실행 (span 태그로 표시)
        },
        submitHandler: function(form) {
            // 폼이 유효할 경우 실제 폼 제출
        	let updateFlag = $("#registerGroupBtn").text();
            if(updateFlag === "수정"){
                newGroupForm.attr("action","${pageContext.request.contextPath}/admin/community/group/update");
            }
            form.submit();
        }
    });




})
</script>
</html>