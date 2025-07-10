<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아티스트 관리 - DDTOWN 직원 포털</title>
    <%@ include file ="../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/pagination.css">
    
    <%-- Font Awesome 및 jQuery CDN --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">  
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body>
    <div class="emp-container">
        <%@ include file="../modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
            
            <main class="emp-content">
                <section class="ea-section">
                    <div class="ea-section-header">
                        <h2 style="margin-bottom: 15px;">아티스트 관리</h2>
                        <div class="ea-header-actions">
                            <form method="GET" action="${pageContext.request.contextPath}/emp/artist/artist-management" class="artist-search-form">
                                <input type="hidden" name="searchType" value="name">
	                            <input type="text" name="searchWord" class="ea-search-input" value="<c:out value='${pagingVO.searchWord}'/>" placeholder="아티스트명을 입력하세요...">
	                            <input type="hidden" name="page" value="1">
	                            <button type="submit" id="artist-search-btn-submit" class="ea-btn primary"><i class="fas fa-search"></i> 검색</button>
                            </form>
                        </div>
                    </div>

                    <c:if test="${not empty pagingVO.dataList}">
                        <table class="ea-table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th class="col-profile-path">프로필 이미지 경로</th>
                                    <th>아티스트명</th>
                                    <th>수정일</th>
                                    <th class="col-actions">관리</th>
                                </tr>
                            </thead>
                            <tbody id="artist-table-body">
                                <c:forEach items="${pagingVO.dataList}" var="artist" varStatus="status">
                                    <tr>
                                        <td>${artist.artNo}</td>
                                        <td class="col-profile-path">
                                            <c:out value="${artist.artProfileImg }"/>
                                        </td>
                                        <td><c:out value="${artist.artNm }"/></td>
                                        <td>
                                            <fmt:formatDate value="${artist.artModDate }" pattern="yyyy-MM-dd HH:mm:ss" var="formattedModDate"/>
                                            <c:out value="${formattedModDate}"/>
                                        </td>
                                        <td class="col-actions">
                                            <button class="ea-btn sm outline edit-artist-btn"
                                                    data-artist-no="${artist.artNo}"
                                                    data-artist-nm="<c:out value='${artist.artNm}'/>"
                                                    data-artist-mod-date="${formattedModDate}"
                                                    data-artist-content="<c:out value='${artist.artContent}' escapeXml='true'/>"
                                                    data-artist-profileimg="<c:out value='${artist.artProfileImg}'/>">
                                                <i class="fas fa-edit"></i> 수정
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                    <c:if test="${empty pagingVO.dataList}">
                        <div class="portal-welcome-message" style="text-align: center; margin-top:20px;">
                             <p>
                                <c:choose>
                                    <c:when test="${not empty pagingVO.searchWord}">
                                        '<c:out value="${pagingVO.searchWord}"/>'에 대한 검색 결과가 없습니다.
                                    </c:when>
                                    <c:otherwise>
                                        등록된 아티스트가 없습니다.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </c:if>

                    <div id="pagingArea" class="ea-pagination">
                         ${pagingVO.pagingHTML}
                    </div>
                </section>
            </main>
        </div> 
    </div>

    <%-- 아티스트 정보 수정 모달 --%>
    <div id="editArtistModal" class="modal">
        <div class="modal-content">
            <h2>아티스트 정보 수정</h2>
             <form id="editArtistForm" class="ea-form">
                <input type="hidden" id="modalArtistNo" name="artNo">
				<input type="hidden" id="modalExistingArtProfileImg" name="existingArtProfileImg">
				
				<div class="d-flex justify-content-start" style="gap:50px; align-items: center;">
	                <div class="form-group">
	                    <label for="modalArtistName">아티스트명:</label>
	                    <input type="text" id="modalArtistName" name="artNm">
	                </div>
	                <div class="form-group">
	                    <label for="displayArtistModDateSpan">최근 수정일:</label> 
	                    <span id="displayArtistModDateSpan" style="display: block; margin-top: 4px; padding: 8px; background-color: #e9ecef; border-radius: 3px;"></span> 
	                </div>
				</div>
                <div class="form-group">
                    <label for="modalArtistContent">소개글:</label>
                    <textarea id="modalArtistContent" name="artContent" rows="4"></textarea>
                </div>
                <div class="form-group">
                    <label for="modalArtistProfileFileSelect">프로필 이미지 파일 선택:</label>
                    <input type="file" id="modalArtistProfileFileSelect" name="artistFile" accept="image/*">
                    <div>
                    	<img id="previewImage" alt="선택된 이미지 미리보기" src="" style="max-width: 100%; max-height: 200px; display: none;">
                    	<p id="noImageSelectedText" style="color: #666; margin-top: 5px;">선택된 이미지가 없습니다.</p>
                    </div>
                </div>

                <div class="ea-form-actions">
                    <button type="button" class="ea-btn primary" id="saveArtistChangesBtn"><i class="fas fa-save"></i> 저장</button>
                </div>
            </form>
        </div>
    </div>
    
    <%-- 푸터 Include --%>
    <%@ include file="../../modules/footerPart.jsp" %>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const navItemsWithSubmenu = document.querySelectorAll('.emp-sidebar .emp-nav-item.has-submenu');
            navItemsWithSubmenu.forEach(item => {
                const arrow = item.querySelector('.submenu-arrow');
                item.addEventListener('click', function(event) {
                    if (this.getAttribute('href') === '#') {
                        event.preventDefault();
                    }
                    const parentLi = this.parentElement;
                    const submenu = this.nextElementSibling;

                    if (submenu && submenu.classList.contains('emp-submenu')) {
                        const parentUl = parentLi.parentElement;
                        if (parentUl) {
                            Array.from(parentUl.children).forEach(siblingLi => {
                                if (siblingLi !== parentLi) {
                                    const siblingSubmenuControl = siblingLi.querySelector('.emp-nav-item.has-submenu.open');
                                    if (siblingSubmenuControl) {
                                        const siblingSubmenuElement = siblingSubmenuControl.nextElementSibling;
                                        siblingSubmenuControl.classList.remove('open');
                                        if (siblingSubmenuElement && siblingSubmenuElement.classList.contains('emp-submenu')) {
                                            siblingSubmenuElement.style.display = 'none';
                                        }
                                        const siblingArrow = siblingSubmenuControl.querySelector('.submenu-arrow');
                                        if (siblingArrow) siblingArrow.style.transform = 'rotate(0deg)';
                                    }
                                }
                            });
                        }
                    }
                    
                    this.classList.toggle('open');
                    if (submenu && submenu.classList.contains('emp-submenu')) {
                        submenu.style.display = this.classList.contains('open') ? 'block' : 'none';
                        if (arrow) arrow.style.transform = this.classList.contains('open') ? 'rotate(90deg)' : 'rotate(0deg)';
                    }
                });
            });

            // 현재 페이지 URL 기반으로 사이드바 메뉴 활성화
            const currentFullHref = window.location.href;
            document.querySelectorAll('.emp-sidebar .emp-nav-item[href]').forEach(link => {
                if (link.href === currentFullHref) {
                    link.classList.add('active');
                    let currentActiveElement = link;
                    while (true) {
                        const parentLi = currentActiveElement.parentElement;
                        if (!parentLi) break;
                        const parentSubmenuUl = parentLi.closest('ul.emp-submenu');
                        if (parentSubmenuUl) {
                            parentSubmenuUl.style.display = 'block';
                            const controllingAnchor = parentSubmenuUl.previousElementSibling;
                            if (controllingAnchor && controllingAnchor.classList.contains('has-submenu')) {
                                controllingAnchor.classList.add('active', 'open');
                                const arrow = controllingAnchor.querySelector('.submenu-arrow');
                                if (arrow) arrow.style.transform = 'rotate(90deg)';
                                currentActiveElement = controllingAnchor;
                            } else break;
                        } else break;
                    }
                }
            });
        });

        $(function() {
            const $editArtistModal = $('#editArtistModal');
            
            const $modalArtistProfileFileSelect = $('#modalArtistProfileFileSelect');
            const $previewImage = $('#previewImage');
            const $noImageSelectedText = $('#noImageSelectedText');
            
            function openModal() { $editArtistModal.css('display', 'block'); }
            function closeModal() { $editArtistModal.css('display', 'none'); 
            	$previewImage.attr('src', '').hide();
            	$noImageSelectedText.show();
            	$('#modalArtistProfileFileSelect').val(''); // 파일 input 초기화
            }

            $editArtistModal.find('.close-button').on('click', closeModal);
            $(window).on('click', function(event) {
                if ($(event.target).is($editArtistModal)) { closeModal(); }
            });

            $(document).on('click', '.edit-artist-btn', function() {
                const $button = $(this);
                $('#modalArtistNo').val($button.data('artist-no'));
                $('#modalArtistName').val($button.data('artist-nm'));
                $('#displayArtistModDateSpan').text($button.data('artist-mod-date'));
                $('#modalArtistContent').val($button.data('artist-content') || '');
                
                // 기존 프로필 이미지 경로가 있다면 미리보기에 표시
                const existingProfileImg = $button.data('artist-profileimg');
                $('#modalExistingArtProfileImg').val(existingProfileImg || '');

                if (existingProfileImg) {
                    $previewImage.attr('src', existingProfileImg).show();
                    $noImageSelectedText.hide();
                } else {
                    $previewImage.attr('src', '').hide();
                    $noImageSelectedText.show();
                }
                $('#modalArtistProfileFileSelect').val(''); // 파일 input 초기화
                openModal();
            });

			$modalArtistProfileFileSelect.on('change', function(event){
				const file = event.target.files[0];
				
				if(file){
					const reader = new FileReader(0);
					reader.onload = function(e){
						// 파일 읽기 후 미리보기 src 업데이트
						$previewImage.attr('src', e.target.result).show();
						$noImageSelectedText.hide();
					};
					
					reader.readAsDataURL(file);
				}else{
					$previewImage.attr('src','').hide();
					$noImageSelectedText.show();
				}
			});
			
			$('#saveArtistChangesBtn').on('click', function() {
				
		        // FormData 객체 생성 (파일 업로드를 위해 필요)
		        const formData = new FormData();
		        
		    	// @ModelAttribute ArtistVO artistVO 에 바인딩될 필드들
                formData.append('artNo', $('#modalArtistNo').val());
                formData.append('artNm', $('#modalArtistName').val());
                formData.append('artContent', $('#modalArtistContent').val());

             	// @RequestParam("existingArtProfileImg") String existingArtProfileImg 에 바인딩될 값
                formData.append('existingArtProfileImg', $('#modalExistingArtProfileImg').val());

                // @RequestParam("artistFile") MultipartFile artistFile 에 바인딩될 파일
                const profileFile = $('#modalArtistProfileFileSelect')[0].files[0];
                if (profileFile) {
                    formData.append('artistFile', profileFile);
                }
		        
		        $.ajax({
		            url: '${pageContext.request.contextPath}/emp/artist/update',
		            type: 'POST',
		            contentType: false, 
		            processData: false, 
		            data: formData,
		            beforeSend : function(xhr) {
		                var csrfHeader = "${_csrf.headerName}";
		                var csrfToken = "${_csrf.token}";
		                if (csrfHeader && csrfToken) {
		                    xhr.setRequestHeader(csrfHeader, csrfToken);
		                }
		            },
		            success: function(response) {
		                if(response && response.status === "success") {
		                    Swal.fire('성공!', '아티스트 정보가 성공적으로 저장되었습니다.', 'success')
		                      .then(() => {
		                        location.reload();
		                      });
		                } else {
		                    Swal.fire('오류', response.message || '아티스트 정보 저장 중 문제가 발생했습니다.', 'error');
		                }
		            },
		            error: function(xhr, status, error) {
		                console.error("저장 실패:", status, error, xhr.responseText);
		                let errorMsg = '아티스트 정보 저장에 실패했습니다.';
		                try {
		                    const errResponse = JSON.parse(xhr.responseText);
		                    if (errResponse && errResponse.message) {
		                        errorMsg += '\n오류: ' + errResponse.message;
		                    } else if (xhr.responseText) {
		                         errorMsg += '\n서버 응답: ' + xhr.responseText.substring(0,200);
		                    }
		                } catch(e) {
		                    if (xhr.responseText) {
		                         errorMsg += '\n서버 응답: ' + xhr.responseText.substring(0,200);
		                    }
		                }
		                Swal.fire('요청 실패', errorMsg, 'error');
		            }
		        });
		    });

            // 페이지네이션 로직
            const pagingArea = $('#pagingArea');
            if(pagingArea.length > 0) {
                pagingArea.on('click', 'a', function(event) { 
                    event.preventDefault();
                    const page = $(this).data('page');
                    
                    // 현재 URL에서 검색 파라미터 유지
                    const currentSearchUrl = new URL(window.location.href);
                    const searchType = currentSearchUrl.searchParams.get("searchType");
                    const searchWord = currentSearchUrl.searchParams.get("searchWord");

                    let targetPageUrl = '${pageContext.request.contextPath}/emp/artist/artist-management?page=' + page;

                    if (searchType && searchWord) {
                        targetPageUrl += '&searchType=' + encodeURIComponent(searchType);
                        targetPageUrl += '&searchWord=' + encodeURIComponent(searchWord);
                    }
                    window.location.href = targetPageUrl;
                });
            }
        });
    </script>
</body>
</html>