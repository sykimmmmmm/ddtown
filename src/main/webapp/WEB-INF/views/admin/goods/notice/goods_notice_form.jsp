<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>굿즈샵 공지사항 등록/수정 - DDTOWN 관리자 시스템</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <%@ include file="../../../modules/headerPart.jsp" %>
    <script src="https://cdn.ckeditor.com/ckeditor5/41.3.1/classic/ckeditor.js"></script>
    <style>
        .goods-notice-form-section {
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .emp-section-header {
            margin-bottom: 20px;
        }
        .emp-section-header h2 {
            margin: 0;
            color: #333;
        }
        .emp-form {
            max-width: 100%;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        .form-group input[type="text"],
        .form-group textarea,
        .form-group select { /* select 태그 스타일 추가 */
            width: 95%; /* 기존 값 */
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-group textarea {
            min-height: 200px;
            resize: vertical;
        }
        /* 상단 고정 체크박스 관련 CSS는 이제 필요 없으므로 제거됩니다. */
        /* .form-check-input {
            margin-right: 8px;
        }
        .form-check-label {
            color: #333;
            user-select: none;
        } */
        .file-upload-info {
            margin-top: 8px;
            font-size: 0.9em;
            color: #666;
        }
        .emp-form-actions {
            margin-top: 30px;
            text-align: right;
        }
        .emp-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            margin-left: 8px;
        }
        .emp-btn i {
            margin-right: 5px;
        }
        .emp-btn.primary {
            background-color: #007bff;
            color: white;
        }
        .emp-btn.primary:hover {
            background-color: #0056b3;
        }
        .emp-btn.default {
            background-color: #6c757d;
            color: white;
        }
        .emp-btn.default:hover {
            background-color: #5a6268;
        }
        .emp-btn.danger {
            background-color: #dc3545;
            color: white;
        }
        .emp-btn.danger:hover {
            background-color: #c82333;
        }
        .emp-btn.sm {
            padding: 6px 12px;
            font-size: 12px;
        }
        /* 파일 목록 스타일 */
        .existing-files {
            margin-top: 10px;
            padding: 10px;
            border: 1px dashed #ccc;
            border-radius: 4px;
            background-color: #f9f9f9;
        }
        .existing-files ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .existing-files li {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
            color: #555;
        }
        .existing-files li i {
            margin-right: 8px;
            color: #007bff;
        }
        .existing-files li span {
            flex-grow: 1;
        }
        .existing-files .delete-file-btn {
            background: none;
            border: none;
            color: #dc3545;
            cursor: pointer;
            margin-left: 10px;
            font-size: 1.1em;
            transition: color 0.2s;
        }
        .existing-files .delete-file-btn:hover {
            color: #c82333;
        }
    </style>
</head>
<body>
    <div class="emp-container">
        <%@ include file="../../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../../modules/aside.jsp" %>
            <main class="emp-content">
            <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/admin/goods/notice/list" style="color:black;">굿즈샵 관리</a></li>
                        <li class="breadcrumb-item"><a href="/admin/goods/notice/list" style="color:black;">공지사항 관리</a></li>
                        <li class="breadcrumb-item active" aria-current="page">공지사항 등록</li>
                    </ol>
                </nav>
                <section class="goods-notice-form-section">
                    <div class="emp-section-header">
                        <h2 id="formPageTitle"></h2>
                    </div>
                    <form id="goodsNoticeForm" class="emp-form" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <c:if test="${mode == 'edit'}">
                            <input type="hidden" id="goodsNotiNo" name="goodsNotiNo" value="${notice.goodsNotiNo}">
                        </c:if>

                        <input type="hidden" name="empUsername" value="관리자계정"> <%-- TODO: 실제 사용자명으로 변경 --%>

                        <div class="form-group">
                            <label for="goodsNotiTitle">제목</label>
                            <input type="text" id="goodsNotiTitle" name="goodsNotiTitle" value="${notice.goodsNotiTitle}" required>
                        </div>

                        <div class="form-group">
                            <label for="goodsNotiContent">내용</label>
                            <textarea id="goodsNotiContent" name="goodsNotiContent" rows="10">${notice.goodsNotiContent}</textarea>
                        </div>


                        <div class="form-group">
                            <label for="uploadFile">첨부파일</label>
                            <c:if test="${mode == 'edit' && not empty notice.fileDetailList}">
                                <div class="existing-files">
                                    <p>현재 첨부된 파일:</p>
                                    <ul id="existingFilesList">
                                        <c:forEach var="file" items="${notice.fileDetailList}">
                                            <li>
                                                <i class="fas fa-file-alt"></i>
                                                <span>${file.fileOriginalNm} (${file.fileFancysize})</span>
                                                <button type="button" class="delete-file-btn" data-file-detail-no="${file.attachDetailNo}" title="파일 삭제">
                                                    <i class="fas fa-times-circle"></i>
                                                </button>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </c:if>
                            <input type="file" id="uploadFile" name="uploadFile" multiple>
                            <div class="file-upload-info">최대 5개 파일 (각 파일 10MB 이하)</div>
                            <input type="hidden" id="deleteAttachDetailNos" name="deleteAttachDetailNos" value="">
                        </div>

                        <div class="emp-form-actions">
                            <a href="/admin/goods/notice/list" class="emp-btn default"><i class="fas fa-list"></i> 목록</a>
                            <button type="submit" id="submitButton" class="emp-btn primary"><i class="fas fa-check"></i> <span id="submitButtonText">등록</span></button>
                            <c:if test="${mode == 'edit'}">
                                <button type="button" class="emp-btn danger" id="deleteBtn"><i class="fas fa-times"></i> 삭제</button>
                            </c:if>
                        </div>
                    </form>
                </section>
            </main>
        </div>
    </div>
<%@ include file="../../../modules/footerPart.jsp" %>

<%@ include file="../../../modules/sidebar.jsp" %>
<script>
document.addEventListener('DOMContentLoaded', function() {
	let editorInstance;

    // CKEditor 초기화
    ClassicEditor
        .create( document.querySelector( '#goodsNotiContent' ))
        .then( editor => {
            editorInstance = editor;
        })
        .catch( error => {
            console.error( error );
    	});

    const form = document.getElementById('goodsNoticeForm');
    const formPageTitle = document.getElementById('formPageTitle');
    const submitButton = document.getElementById('submitButton');
    const submitButtonText = document.getElementById('submitButtonText');
    const deleteBtn = document.getElementById('deleteBtn');

    const mode = "${mode}";

    if (mode === 'edit') {
        formPageTitle.innerText = "굿즈샵 공지사항 수정";
        submitButtonText.innerText = "수정";
        form.action = "/admin/goods/notice/update";
        form.method = "POST";
    } else {
        formPageTitle.innerText = "굿즈샵 공지사항 등록";
        submitButtonText.innerText = "등록";
        form.action = "/admin/goods/notice/register";
        form.method = "POST";
        if (deleteBtn) {
            deleteBtn.style.display = 'none';
        }
    }

    if (deleteBtn) {
        deleteBtn.addEventListener('click', function() {
            const goodsNotiNo = document.getElementById('goodsNotiNo').value;
            if (confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
                const deleteForm = document.createElement('form');
                deleteForm.setAttribute('method', 'post');
                deleteForm.setAttribute('action', '/admin/goods/notice/delete');

                // CSRF 토큰 추가 (삭제 폼에도 필요합니다!)
                const csrfParamName = "${_csrf.parameterName}";
                const csrfToken = "${_csrf.token}";
                const csrfHiddenInput = document.createElement('input');
                csrfHiddenInput.setAttribute('type', 'hidden');
                csrfHiddenInput.setAttribute('name', csrfParamName);
                csrfHiddenInput.setAttribute('value', csrfToken);
                deleteForm.appendChild(csrfHiddenInput);


                const hiddenInput = document.createElement('input');
                hiddenInput.setAttribute('type', 'hidden');
                hiddenInput.setAttribute('name', 'id'); // 컨트롤러에서 goodsNotiNo로 받을 경우 'goodsNotiNo'로 변경해야 합니다.
                hiddenInput.setAttribute('value', goodsNotiNo);

                deleteForm.appendChild(hiddenInput);
                document.body.appendChild(deleteForm);
                deleteForm.submit();
            }
        });
    }

    const existingFilesList = document.getElementById('existingFilesList');
    const deleteAttachDetailNosInput = document.getElementById('deleteAttachDetailNos');
    const deletedFileIds = [];

    if (existingFilesList) {
        existingFilesList.addEventListener('click', function(event) {
            if (event.target.closest('.delete-file-btn')) {
                const button = event.target.closest('.delete-file-btn');
                const fileDetailNo = button.dataset.fileDetailNo;
                const listItem = button.closest('li');

                if (confirm('이 파일을 삭제하시겠습니까?')) {
                    deletedFileIds.push(fileDetailNo);
                    deleteAttachDetailNosInput.value = deletedFileIds.join(',');
                    listItem.remove();
//                     console.log('삭제 예정 파일 ID:', deletedFileIds);
                }
            }
        });
    }
});
</script>
</body>
</html>