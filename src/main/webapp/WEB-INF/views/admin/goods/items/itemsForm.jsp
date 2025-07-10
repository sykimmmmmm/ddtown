<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<%--
  컨트롤러에서 다음 속성들을 설정하고 이 페이지로 포워드해야 합니다:
  request.setAttribute("isEditMode", true/false); // 수정 모드 여부
  if (isEditMode) {
      request.setAttribute("item", itemObject); // 상품 정보 객체 (Map 또는 DTO)
                                               // itemObject는 name, sku, category, price, stock, status, description, images (List<ImageDTO>) 등을 포함
  }
  request.setAttribute("adminUser", adminUserObject); // 헤더용 관리자 정보
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 등록 - DDTOWN 관리자 시스템</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/admin_items.css">
    <%@ include file="../../../modules/headerPart.jsp" %>
</head>
<body>
<div class="emp-container">
	<%@ include file="../../modules/header.jsp" %>

	<div class="emp-body-wrapper">
            <%@ include file="../../modules/aside.jsp" %>

            <main class="emp-content">
            <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/admin/goods/items/list" style="color:black;">굿즈샵 관리</a></li>
                        <li class="breadcrumb-item"><a href="/admin/goods/items/list" style="color:black;">품목 관리</a></li>
                        <li class="breadcrumb-item active" aria-current="page">상품 등록</li>
                    </ol>
                </nav>
                <section id="goodsItemFormSection" class="ea-section active-section">
                    <div class="ea-section-header">
                        <h2>상품 등록</h2>
                    	<div class="ea-header-actions">
	                        <c:if test="${not empty successMessage}">
	                            <div class="alert alert-success">${successMessage}</div>
	                        </c:if>
	                        <c:if test="${not empty errorMessage}">
	                            <div class="alert alert-danger">${errorMessage}</div>
	                        </c:if>
                        </div>
                     </div>

	 				<form method="POST" action="${pageContext.request.contextPath}/admin/goods/items/form" enctype="multipart/form-data" novalidate>
	                    <sec:csrfInput/> <input type="hidden" name="edmsContent"/> <%-- 필요하다면 유지 --%>
	                    <input type="hidden" name="edmsStatCode" id="edmsStatCode"/> <%-- 필요하다면 유지 --%>
						<input type="hidden" name="goodsDivCode" value="GDC003">
	                    <div class="form-row">
	                        <div class="form-group">
	                            <label for="goodsNm">상품명 <span class="required">*</span></label>
	                            <input type="text" id="goodsNm" name="goodsNm" required value="<c:out value='${item.goodsNm}'/>">
	                        </div>
	                        <div class="form-group">
	                            <label for="goodsCode">상품코드</label>
	                            <input type="text" id="goodsCode" name="goodsCode" readonly placeholder="자동 생성" value="<c:out value='${item.goodsCode}'/>">
	                        </div>
						    <div class="form-group">
						        <label for="artGroupNo">아티스트 그룹 <span class="required">*</span></label>
						        <select id="artGroupNo" name="artGroupNo" required>
						            <option value="">아티스트를 선택하세요</option>
						            <c:forEach var="artist" items="${artistList}">
						                <option value="${artist.artGroupNo}" <c:if test="${item.artGroupNo == artist.artGroupNo}">selected</c:if>>
						                    <c:out value="${artist.artGroupNm}"/>
						                </option>
						            </c:forEach>
						        </select>
						    </div>
	                    </div>

						<div class="form-row">
                            <div class="form-group">
                                <label for="useOptionsCheckbox">옵션 사용</label>
                                <input type="checkbox" id="useOptionsCheckbox" name="useOptions" value="true" checked>
                            </div>
                        </div>

                        <div class="form-row" id="mainStockSection">
                            <div class="form-group">
                                <label for="stockRemainQty">재고수량<span class="required">*</span></label>
                                <input type="number" id="stockRemainQty" name="stockRemainQty" min="0" value="<c:out value='${item.stockRemainQty}'/>">
                            </div>
                        </div>

                        <div id="optionsInputSection">
	                        <div class="d-flex justify-contents-center" style="align-items:center; gap:30px;">
	                            <label>상품 옵션</label>
	                            <button type="button" id="addOptionBtn" class="ea-btn sm outline">옵션 추가</button>
	                        </div>
                            <div id="goodsOptionsContainer">
                                <div class="option-set form-row ">
                                	<div class="form-group">
                                		<label>색상</label>
                                        <input type="text" name="options[0].goodsOptNm" placeholder="옵션명 (예: 레드/S)">
                                    </div>
                                    <div class="form-group">
                                		<label>재고수량</label>
                                        <input type="number" name="options[0].initialStockQty" placeholder="초기 재고 수량" min="0">
                                    </div>
                                    <!-- <div class="form-group">
                                		<label>추가가격</label>
                                        <input type="number" name="options[0].goodsOptPrice" placeholder="옵션 추가 가격" min="0">
                                    </div> -->
                                    <div class="form-group">
                                		<label>비고</label>
                                        <input type="text" name="options[0].goodsOptEtc" placeholder="옵션 설명 (비고)">
                                    </div>
                                </div>
                            </div>
                        </div>

						<div class="form-row">
                            <div class="form-group">
                                <label for="goodsPrice">판매가격 <span class="required">*</span></label>
                                <input type="number" id="goodsPrice" name="goodsPrice" min="0" step="1" required value="<c:out value='${item.goodsPrice}'/>">
                            </div>
                            <div class="form-group">
                                <label for="itemStatus">판매상태 <span class="required">*</span></label>
                                <select id="itemStatus" name="statusEngKey" required>
                                    <option value="IN_STOCK" <c:if test="${item.statusEngKey == 'IN_STOCK' or empty item.statusEngKey}">selected</c:if>>판매중</option>
                                    <option value="SOLD_OUT" <c:if test="${item.statusEngKey == 'SOLD_OUT'}">selected</c:if>>품절</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="goodsContent">상품설명 <span class="required">*</span></label>
                            <textarea id="goodsContent" name="goodsContent" required><c:out value='${item.goodsContent}'/></textarea>
                        </div>

                        <div class="form-group">
                            <label for="goodsFiles">상품 이미지 <span class="required">*</span></label>
                            <div class="image-upload-area" id="imageUploadArea">
                                <p>이미지를 드래그하거나 클릭하여 업로드하세요</p>
                                <input type="file" id="goodsFiles" name="goodsFiles" multiple accept="image/*" style="display: none;" required>
                                <button type="button" class="ea-btn" onclick="document.getElementById('goodsFiles').click()">
                                    <i class="fas fa-upload"></i> 이미지 선택
                                </button>
                            </div>

                            <div class="image-preview-container" id="imagePreviewContainer">
                                <%-- 기존 이미지 표시 (수정 모드일 경우) --%>
<%--                                 <c:if test="${isEditMode and not empty item.images}"> --%>
<%--                                     <c:forEach var="image" items="${item.images}"> --%>
<%--                                         <div class="image-preview existing-image" data-file-path="${image.filePath}"> --%>
<%--                                             <img src="${pageContext.request.contextPath}/uploads/goods/${image.fileName}" alt="상품 이미지" style="max-width: 100px; max-height: 100px; margin: 5px; border: 1px solid #ddd;"> --%>
<%--                                             <button type="button" class="remove-existing-image-btn" title="이 이미지 제거" data-file-path="${image.filePath}">&times;</button> --%>
<!--                                         </div> -->
<%--                                     </c:forEach> --%>
<%--                                 </c:if> --%>
                                <%-- 새로 추가하는 이미지 미리보기는 여기에 JS로 추가됩니다 --%>
                            </div>
                        </div>

						<div class="form-actions">
                            <a href="${pageContext.request.contextPath}/admin/goods/items/list" class="ea-btn">취소</a>
                            <button type="submit" id="goodsRegisterSubmitBtn" class="ea-btn primary"><i class="fas fa-save"></i>
                                등록
                            </button>
                        </div>
                    </form>

                </section>
            </main>
        </div>
    </div>
</body>
<%@ include file="../../../modules/footerPart.jsp" %>

<%@ include file="../../../modules/sidebar.jsp" %>
<script>
document.addEventListener('DOMContentLoaded', function() {

//------------------------중복 제출 방어--------------------------------------
// JavaScript 최상단 또는 DOMContentLoaded 내부의 적절한 위치
const submitButton = document.getElementById('goodsRegisterSubmitBtn');
// form action이 /admin/goods/items/form 이므로 이에 맞춰 수정
const itemFormForSubmit = document.querySelector('form[action$="/items/form"]');

// const isEditMode = ${isEditMode ? 'true' : 'false'};



if (itemFormForSubmit && submitButton) {
    itemFormForSubmit.addEventListener('submit', function(event) {
        if (submitButton.dataset.submitted === 'true') {
            console.warn('폼 중복 제출 시도 감지됨 (JS).');
            event.preventDefault(); // 이미 제출 중이면 다시 제출 막기
            return false;
        }
        submitButton.dataset.submitted = 'true'; // 제출 상태 표시
        submitButton.disabled = true;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 처리 중...';

        // (주의) 만약 클라이언트측 유효성 검사 실패로 submit을 막고 버튼을 다시 활성화해야 한다면
        // 이 로직은 유효성 검사 통과 *후에* 실행되거나, 실패 시 버튼을 다시 활성화해야 합니다.
    });
}

      //------------------------옵션 추가 / 삭제 로직---------------------------------
      const addButton = document.getElementById('addOptionBtn');
      const container = document.getElementById('goodsOptionsContainer');

      // 초기 옵션 세트가 로드되었는지 확인하고 optionIndex 설정
      let optionIndex = 0;
      const existingOptionSets = container.getElementsByClassName('option-set');
      if (existingOptionSets.length > 0) {
          // 기존 옵션이 있다면 마지막 옵션의 인덱스 + 1로 시작
          const lastOptionSet = existingOptionSets[existingOptionSets.length - 1];
          const nameAttr = lastOptionSet.querySelector('input[name^="options"]').name;
          const match = nameAttr.match(/options\[(\d+)\]/);
          if (match && match[1]) {
              optionIndex = parseInt(match[1]) + 1;
          } else {
              optionIndex = existingOptionSets.length; // 기본값
          }
      }

      addButton.addEventListener('click', function() {
          const newOptionSetDiv = document.createElement('div');
          newOptionSetDiv.classList.add('option-set', 'form-row'); // form-row 클래스 추가

          newOptionSetDiv.innerHTML = `
              <div class="form-group">
                  <input type="text" name="options[\${optionIndex}].goodsOptNm" placeholder="옵션명 (예: 레드/S)">
              </div>
              <div class="form-group">
                  <input type="number" name="options[\${optionIndex}].initialStockQty" placeholder="초기 재고 수량" min="0">
              </div>
              <div class="form-group">
                  <input type="number" name="options[\${optionIndex}].goodsOptPrice" placeholder="옵션 추가 가격" min="0">
              </div>
              <div class="form-group">
                  <input type="text" name="options[\${optionIndex}].goodsOptEtc" placeholder="옵션 설명 (비고)">
              </div>
              <div class="form-group">
                  <button type="button" class="remove-option-btn ea-btn danger">삭제</button>
              </div>
          `;

          container.appendChild(newOptionSetDiv);
          optionIndex++;
      });

      container.addEventListener('click', function(event) {
          if (event.target.classList.contains('remove-option-btn')) {
              // 옵션 세트가 하나만 남았을 때는 삭제하지 않음
              if (container.getElementsByClassName('option-set').length > 1) {
                  event.target.closest('.option-set').remove();
                  // 옵션 삭제 시 인덱스 재정렬 필요 (선택 사항, 서버에서 처리 가능하면 생략)
                  // 여기서는 간단하게 삭제만 처리하고 서버에서 List를 받아 처리한다고 가정
              } else {
                  alert('최소한 하나의 옵션은 존재해야 합니다.');
              }
          }
      });
      //------------------------옵션 추가 / 삭제 로직 끝---------------------------------

      //------------------------옵션 사용 여부에 따른 변경 로직--------------------------------
      const useOptionsCheckbox = document.getElementById('useOptionsCheckbox');
      const mainStockSection = document.getElementById('mainStockSection'); // 상품 레벨 재고 섹션
      const stockRemainQtyInput = document.getElementById('stockRemainQty'); // 상품 레벨 재고 input
      const optionsInputSection = document.getElementById('optionsInputSection'); // 옵션 입력 영역 섹션

      function toggleSectionsBasedOnOptions() {
          if (useOptionsCheckbox.checked) { // 옵션 사용 시
              mainStockSection.style.display = 'none'; // 상품 레벨 재고 숨김
              stockRemainQtyInput.disabled = true;     // 비활성화하여 값 전송 안되게
              stockRemainQtyInput.required = false;    // 필수입력 해제

              optionsInputSection.style.display = 'block'; // 옵션 입력 영역 보임
              // 옵션 입력 필드들 활성화
              optionsInputSection.querySelectorAll('input, button').forEach(el => el.disabled = false);
              // 첫 번째 옵션명은 필수로 설정 (예시)
              const firstOptNm = optionsInputSection.querySelector('input[name="options[0].goodsOptNm"]');
              if(firstOptNm) firstOptNm.required = true;

          } else { // 옵션 미사용 시
              mainStockSection.style.display = '';    // 상품 레벨 재고 보임 (기본 display 스타일로)
              stockRemainQtyInput.disabled = false;
              stockRemainQtyInput.required = true;     // 필수입력 설정

              optionsInputSection.style.display = 'none'; // 옵션 입력 영역 숨김
              // 옵션 입력 필드들 비활성화
              optionsInputSection.querySelectorAll('input, button').forEach(el => el.disabled = true);
              const firstOptNm = optionsInputSection.querySelector('input[name="options[0].goodsOptNm"]');
              if(firstOptNm) firstOptNm.required = false; // 필수입력 해제
          }
      }

      useOptionsCheckbox.addEventListener('change', toggleSectionsBasedOnOptions);
      toggleSectionsBasedOnOptions(); // 페이지 로드 시 초기 상태 설정
      //------------------------옵션 사용 여부에 따른 변경 로직 끝--------------------------------



      //------------------------이미지 미리보기 / 파일 관리 로직---------------------------------
      const goodsFilesInput = document.getElementById('goodsFiles'); //파일 입력 필드
      const imageUploadArea = document.getElementById('imageUploadArea'); // 드래그 앤 드롭 영역
      const imagePreviewContainer = document.getElementById('imagePreviewContainer');

      let currentFilesDataTransfer = new DataTransfer();

//       // 페이지 로드 시 기존 이미지 처리 (수정 모드일 경우)
//       <c:if test="${isEditMode and not empty item.images}">
//           <c:forEach var="image" items="${item.images}">
//               const existingPreviewDiv = imagePreviewContainer.querySelector(`.image-preview.existing-image[data-file-path="\${'${image.filePath}'}"]`);
//               if(existingPreviewDiv) {
//                   existingPreviewDiv.querySelector('.remove-existing-image-btn').addEventListener('click', function() {
//                       const filePathToRemove = this.dataset.filePath;
//                       // 서버로 전송할 "삭제할 기존 이미지" 목록에 추가하는 로직 필요
//                       // 예: hidden input 필드에 삭제할 filePath를 추가
//                       const removedImageInput = document.createElement('input');
//                       removedImageInput.type = 'hidden';
//                       removedImageInput.name = 'removedImagePaths'; // 컨트롤러에서 받을 이름
//                       removedImageInput.value = filePathToRemove;
//                       itemFormForSubmit.appendChild(removedImageInput);
//                       this.closest('.image-preview').remove();
//                       console.log("기존 이미지 제거 요청됨:", filePathToRemove);
//                   });
//               }
//           </c:forEach>
//       </c:if>


      goodsFilesInput.addEventListener('change', function(event) {
          const newFiles = event.target.files; //사용자가 이번에 새로 선택한 파일들

          Array.from(newFiles).forEach(file => {

              if (file.type.startsWith('image/')) {
                  let exists = false;
                  for (let i = 0; i < currentFilesDataTransfer.files.length; i++) {
                      // 이름과 크기가 모두 같으면 중복으로 간주 (더 정확한 비교 필요 시 hash 사용)
                      if (currentFilesDataTransfer.files[i].name === file.name && currentFilesDataTransfer.files[i].size === file.size) {
                          exists = true;
                          break;
                      }
                  }

                  if (!exists) {
                      currentFilesDataTransfer.items.add(file); //관리 목록에 파일 추가
                      displayImagePreview(file); // 미리보기 함수 호출
                  }
              } else {
                  alert('이미지 파일만 업로드할 수 있습니다!');
              }
          });

          goodsFilesInput.files = currentFilesDataTransfer.files; // input 필드에 현재 관리 목록의 파일들 설정

//           logFileListState(goodsFilesInput.files, "파일 선택(change) 후 goodsFilesInput.files");

//           event.target.value = ''; //동일 파일 재선택 가능하도록 input 초기화
      });

      // 드래그 앤 드롭 기능
      imageUploadArea.addEventListener('dragover', (e) => {
          e.preventDefault();
          e.stopPropagation();
          imageUploadArea.classList.add('drag-over');
      });

      imageUploadArea.addEventListener('dragleave', (e) => {
          e.preventDefault();
          e.stopPropagation();
          imageUploadArea.classList.remove('drag-over');
      });

      imageUploadArea.addEventListener('drop', (e) => {
          e.preventDefault();
          e.stopPropagation();
          imageUploadArea.classList.remove('drag-over');

          const files = e.dataTransfer.files;
          // goodsFilesInput의 change 이벤트 핸들러를 재활용하기 위해 새로운 DataTransfer 객체에 파일 추가
          // 또는 goodsFilesInput.files = files; 로 직접 할당 후 change 이벤트 트리거
          // (권장) goodsFilesInput.files에 직접 할당
          goodsFilesInput.files = files; // 드롭된 파일들을 input에 할당

          // 그리고 change 이벤트를 수동으로 트리거하여 기존 change 리스너가 작동하도록 함
          const changeEvent = new Event('change', { bubbles: true });
          goodsFilesInput.dispatchEvent(changeEvent);
      });

      //--------------------추가한 이미지 미리보기 로직---------------------------
      function displayImagePreview(file) {
          const reader = new FileReader();
          reader.onload = function(e) {

              const previewDiv = document.createElement('div');
              previewDiv.classList.add('image-preview', 'new-image'); // 새로 추가된 이미지임을 표시
              previewDiv.dataset.fileName = file.name; // 고유 식별자로 파일 이름 사용

              previewDiv.innerHTML = `
                  <img src="\${e.target.result}" alt="\${file.name}">
                  <button type="button" class="remove-image-preview-btn" title="이 이미지 제거">&times;</button>
              `;
              imagePreviewContainer.appendChild(previewDiv);
          };

          //FileReader 에러 핸들러 추가
          reader.onerror = function(e) {
              console.error("파일을 읽는 중 오류가 발생했습니다: ", file.name, e);
          	alert("파일을 읽는 중 오류가 발생했습니다: " + file.name);
          };

          reader.readAsDataURL(file); //파일 읽기 시작
      }

//----------------------------추가한 이미지 제거 로직 (새로 추가된 이미지)---------------------------
      imagePreviewContainer.addEventListener('click', function(event) {
          if (event.target.classList.contains('remove-image-preview-btn')) {
              const previewElement = event.target.closest('.image-preview'); // 가장 가까운 .image-preview 부모 찾기
              const fileNameToRemove = previewElement.dataset.fileName;

              // 기존 이미지 삭제 버튼인지, 새로 추가된 이미지 삭제 버튼인지 구분
              if (previewElement.classList.contains('existing-image')) {
                  // 기존 이미지 삭제 로직: 서버로 삭제할 이미지 경로를 전송해야 함
                  const filePathToRemove = previewElement.dataset.filePath;
                  const removedImageInput = document.createElement('input');
                  removedImageInput.type = 'hidden';
                  removedImageInput.name = 'removedImagePaths'; // 컨트롤러에서 받을 이름
                  removedImageInput.value = filePathToRemove;
                  itemFormForSubmit.appendChild(removedImageInput);

              } else if (previewElement.classList.contains('new-image')) {
                  // 새로 추가된 이미지 삭제 로직: DataTransfer 객체에서 제거
                  const newTempDataTransfer = new DataTransfer();
                  for (let i = 0; i < currentFilesDataTransfer.files.length; i++) {
                      // 파일 이름과 크기가 모두 같으면 동일 파일로 간주
                      if (!(currentFilesDataTransfer.files[i].name === fileNameToRemove &&
                            currentFilesDataTransfer.files[i].size === previewElement.fileSize)) { // fileSize 속성 추가 필요
                          newTempDataTransfer.items.add(currentFilesDataTransfer.files[i]);
                      }
                  }
                  currentFilesDataTransfer = newTempDataTransfer;
                  goodsFilesInput.files = currentFilesDataTransfer.files;
              }

              previewElement.remove(); // 미리보기 DOM 제거
          }
      });

      // 디버깅용 함수
      function logFileListState(fileList, msg) {
          console.log(`--- ${msg} ---`);
          if (fileList.length === 0) {
              console.log("파일 목록이 비어 있습니다.");
              return;
          }
          Array.from(fileList).forEach((file, index) => {
              console.log(`[${index}] 이름: ${file.name}, 크기: ${file.size}, 타입: ${file.type}`);
          });
          console.log(`총 파일 개수: ${fileList.length}`);
      }

      // 초기 로드 시 기존 이미지의 파일 크기를 previewElement.dataset에 저장 (제거 로직에 필요)
      // (주의: file size는 File 객체에만 존재하며, 이미 업로드된 파일에는 없음.
      // 따라서 기존 이미지는 파일 경로로만 식별하는 것이 일반적임)
      // 위 remove-image-preview-btn 로직 수정 시 existing-image와 new-image를 구분하여 처리하도록 함
      // new-image의 경우 file.size를 dataset에 저장할 수 있도록 displayImagePreview 함수에 추가
      // displayImagePreview 함수 내에서 previewDiv.dataset.fileSize = file.size; 추가
  });
  </script>

</html>