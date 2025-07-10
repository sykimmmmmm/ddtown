<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/emp_common.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<%@ include file ="../../modules/headerPart.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.17/index.global.min.js'></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/dayjs@1.11.13/dayjs.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/ckeditorInquiry/ckeditor.js"></script>

<style type="text/css">
.calendar-header-bar { display: flex; align-items: flex-start; justify-content: space-between; }
.calendar-header-bar .calendar-title { font-size: 1.7em; font-weight: 700; color: #234aad; display: flex; align-items: center; gap: 10px; }
.calendar-header-bar .calendar-add-btn { background: #1976d2; color: #fff; border: none; border-radius: 6px; padding: 8px 20px; font-size: 1em; font-weight: 500; cursor: pointer; transition: background 0.2s ease, transform 0.1s ease;
box-shadow: 0 2px 5px rgba(0,0,0,0.1); display: flex; align-items: center; gap: 6px; white-space: nowrap; }
.calendar-header-bar .calendar-add-btn:hover { background: #1451a3; transform: translateY(-1px); box-shadow: 0 3px 8px rgba(0,0,0,0.2); }
.calendar-info-box { background: #fff; color: #444; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border-radius: 8px; padding: 18px 25px; margin-bottom: 25px; font-size: 1em; display: flex; align-items: center; gap: 10px; border-left: 4px solid #234aad; }
#calendar {
    font-family: 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; /* 기존 유지 (한글 폰트는 body 또는 global에 정의된 것을 따름) */
    background-color: #ffffff;
    border-radius: 8px; /* 멤버십 카드, 차트 박스와 유사한 둥근 모서리 */
    padding: 20px; /* 내부 여백 */
    box-shadow: 0 2px 8px rgba(0,0,0,0.05); /* 멤버십 카드, 차트 박스와 유사한 그림자 */
}
.mb-3 textarea.form-control {
    resize: vertical;
}
.mb-3 .form-control {
    resize: none;
}
.mb-3 .form-check.form-switch {
    display: flex; /* Flexbox 사용 */
    align-items: center; /* 세로 중앙 정렬 */
    gap: 10px; /* 레이블과 스위치 사이 간격 */
    justify-content: space-between; /* 왼쪽 정렬 */
    padding: 0;
}

/* 스위치 자체의 마진 조정 */
.mb-3 .form-check.form-switch .form-check-input {
    margin-left: 0; /* 기본 마진 제거 */
    flex-shrink: 0; /* 공간이 부족해도 스위치 크기 줄어들지 않도록 */
}

/* 레이블의 user-select-none 클래스에 대한 커서 변경 (선택적) */
.form-check-label.user-select-none {
    cursor: default; /* 마우스 커서를 기본 화살표로 변경 (클릭 불가 시각적 힌트) */
}

.mb-3 .form-control:disabled .form-control-color{
	background-color : #ffffff;
}

/* FullCalendar 툴바 (헤더) 버튼 스타일 */
.fc .fc-button-group > .fc-button {
    background-color: #f8f9fa; /* 밝은 회색 배경 */
    color: #495057; /* 어두운 회색 텍스트 */
    border: 1px solid #ced4da; /* 연한 테두리 */
    border-radius: 4px; /* 살짝 둥근 모서리 */
    font-weight: 500;
    padding: 6px 12px;
    transition: all 0.2s ease;
}

.fc .fc-button-group > .fc-button:hover {
    background-color: #e2e6ea; /* 호버 시 더 진한 회색 */
    border-color: #dae0e5;
    color: #212529;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.fc .fc-button-group > .fc-button.fc-button-active {
    background-color: #007bff; /* 부트스트랩 primary 색상과 유사 */
    color: #ffffff;
    border-color: #007bff;
    box-shadow: 0 1px 4px rgba(0,0,0,0.2);
}

/* FullCalendar 요일 헤더 */
.fc-col-header-cell-cushion {
    color: #6c757d; /* 부트스트랩 secondary 텍스트 색상과 유사 */
    font-weight: 600;
    padding: 10px 0;
}

/* FullCalendar 날짜 셀 스타일 */
.fc-daygrid-day {
    transition: background-color 0.1s ease;
}

.fc-daygrid-day:hover {
    background-color: #f5f5f5; /* 호버 시 배경색 */
}

.fc-day-today {
    background-color: #eaf6ff !important; /* 오늘 날짜 배경색을 더 부드럽게 */
    border: 1px solid #a8d6ff !important; /* 오늘 날짜 테두리 */
    border-radius: 6px; /* 오늘 날짜 모서리 살짝 둥글게 */
}

/* 주말 날짜 색상 */
.fc-day-sun .fc-daygrid-day-number {
    color: #dc3545; /* 빨간색 (부트스트랩 danger 색상) */
}
.fc-day-sat .fc-daygrid-day-number {
    color: #007bff; /* 파란색 (부트스트랩 primary 색상) */
}

.fc-event {
    background-color: #28a745; /* 기본 이벤트 색상 (구독중 active와 유사) */
    border: 1px solid azure;
    border-radius: 4px; /* 이벤트 모서리 둥글게 */
    font-size: 0.88em;
    padding: 2px 6px;
    color: #ffffff !important;
    white-space: normal; /* 텍스트가 길 경우 줄 바꿈 */
    box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}
/* 툴팁 (popper.js 관련) - 기존 스타일 유지하면서 크기 조정 */
.popper,
.tooltip {
  position: absolute;
  z-index: 9999;
  background: #343a40; /* 어두운 배경 (부트스트랩 dark 색상) */
  color: #FFFFFF;
  width: auto; /* 내용에 따라 너비 자동 조절 */
  max-width: 250px; /* 최대 너비 설정 */
  border-radius: 5px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.2);
  padding: 8px 12px;
  text-align: center;
  font-size: 0.85em;
  line-height: 1.4;
}
.style5 .tooltip { /* style5는 더 간결하게 조정 */
  background: #1e252b;
  color: #FFFFFF;
  max-width: 220px;
  width: auto;
  font-size: .8rem;
  padding: .6em 1em;
}
.popper .popper__arrow,
.tooltip .tooltip-arrow {
  width: 0;
  height: 0;
  border-style: solid;
  position: absolute;
  margin: 5px;
}

.tooltip .tooltip-arrow,
.popper .popper__arrow {
  border-color: #343a40; /* 툴팁 배경색과 동일하게 */
}
.style5 .tooltip .tooltip-arrow {
  border-color: #1e252b; /* style5 배경색과 동일하게 */
}
/* 툴팁 위치에 따른 화살표 조정 (크기 약간 줄임) */
.popper[x-placement^="top"],
.tooltip[x-placement^="top"] {
  margin-bottom: 8px;
}
.popper[x-placement^="top"] .popper__arrow,
.tooltip[x-placement^="top"] .tooltip-arrow {
  border-width: 6px 6px 0 6px;
  bottom: -6px;
  left: calc(50% - 6px);
}
.popper[x-placement^="bottom"],
.tooltip[x-placement^="bottom"] {
  margin-top: 8px;
}
.tooltip[x-placement^="bottom"] .tooltip-arrow,
.popper[x-placement^="bottom"] .popper__arrow {
  border-width: 0 6px 6px 6px;
  top: -6px;
  left: calc(50% - 6px);
}
.tooltip[x-placement^="right"],
.popper[x-placement^="right"] {
  margin-left: 8px;
}
.popper[x-placement^="right"] .popper__arrow,
.tooltip[x-placement^="right"] .tooltip-arrow {
  border-width: 6px 6px 6px 0;
  left: -6px;
  top: calc(50% - 6px);
}
.popper[x-placement^="left"],
.tooltip[x-placement^="left"] {
  margin-right: 8px;
}
.popper[x-placement^="left"] .popper__arrow,
.tooltip[x-placement^="left"] .tooltip-arrow {
  border-width: 6px 0 6px 6px;
  right: -6px;
  top: calc(50% - 6px);
}

/* FullCalendar 스크롤바 (필요시) */
.fc-scroller {
    overflow-y: auto;
    /* 웹킷 기반 브라우저 스크롤바 커스터마이징 */
    &::-webkit-scrollbar {
        width: 8px;
    }
    &::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }
    &::-webkit-scrollbar-thumb {
        background: #c0c0c0; /* 연한 회색 */
        border-radius: 10px;
    }
    &::-webkit-scrollbar-thumb:hover {
        background: #a0a0a0; /* 호버 시 약간 진하게 */
    }
}

/* FullCalendar의 캘린더 제목 (ex. May 2025) */
.fc-toolbar-title {
    font-size: 1.8em;
    font-weight: 700;
    color: #343a40; /* 어두운 텍스트 색상 */
    line-height: 1.2;
}

/* FullCalendar 날짜 번호 */
.fc-daygrid-day-number {
    padding: 4px 6px;
    font-size: 0.9em;
    color: #495057; /* 기본 날짜 숫자 색상 */
}
/* 모달 공통 스타일 */
.modal-content {
    border-radius: 10px; /* 모든 모달에 둥근 모서리 적용 */
    box-shadow: 0 5px 20px rgba(0,0,0,0.15); /* 더 부드러운 그림자 */
    overflow: hidden; /* 내부 요소가 둥근 모서리 밖으로 넘어가지 않도록 */
}

.modal-header {
    border-bottom: 1px solid #e9ecef; /* 구분선 색상 조정 */
    padding: 18px 25px; /* 헤더 패딩 조정 */
    background-color: #f8f9fa; /* 헤더 배경색 추가 */
}

.modal-title {
    font-weight: 700;
    color: #234aad; /* 브랜드 색상 사용 */
    font-size: 1.35em; /* 제목 크기 조정 */
}

.modal-body {
    padding: 25px; /* 바디 패딩 조정 */
}

.modal-footer {
    border-top: 1px solid #e9ecef; /* 구분선 색상 조정 */
    padding: 15px 25px; /* 푸터 패딩 조정 */
    background-color: #f8f9fa; /* 푸터 배경색 추가 */
    display: flex;
    justify-content: flex-end; /* 버튼들을 오른쪽으로 정렬 */
    gap: 10px; /* 버튼들 사이 간격 */
}

.btn-close {
    font-size: 0.9em;
    opacity: 0.7;
    transition: opacity 0.2s ease;
}
.btn-close:hover {
    opacity: 1;
}

/* 폼 컨트롤 (기존 .mb-3 .form-control 스타일과 유사하게) */
.modal-body .form-label {
    font-weight: 600;
    color: #495057;
    margin-bottom: 8px; /* 레이블과 입력 필드 간 간격 */
}

.modal-body .form-control,
.modal-body .form-control-plaintext,
.modal-body select {
    border: 1px solid #ced4da;
    border-radius: 6px; /* 입력 필드 둥근 정도 */
    padding: 0.5rem 0.85rem; /* 패딩 조정 */
    font-size: 1em;
    line-height: 1.5;
    color: #495057;
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.modal-body .form-control:focus,
.modal-body select:focus {
    border-color: #80bdff;
    box-shadow: 0 0 0 0.25rem rgba(0, 123, 255, 0.25);
    outline: 0;
}

/* disabled 상태의 입력 필드 */
.modal-body .form-control[disabled],
.modal-body .form-control-plaintext[disabled],
.modal-body textarea[disabled],
.modal-body select[disabled] {
    background-color: #f0f2f5; /* 더 부드러운 비활성화 배경색 */
    opacity: 0.9;
    cursor: not-allowed;
    color: #6c757d; /* 텍스트 색상도 약간 흐리게 */
    border-color: #e2e6ea; /* 비활성화 테두리 색상 */
}

/* input[type="color"] 스타일 */
.modal-body .form-control-color {
    height: calc(1.5em + 1rem + 2px); /* 부트스트랩 기본 높이와 유사하게 */
    width: 70px; /* 적절한 너비 설정 */
    padding: 0.2rem; /* 패딩 조정 */
    border-radius: 6px;
    border: 1px solid #ced4da;
    cursor: pointer;
}


/* 카테고리 선택 모달 (.card 스타일) */
#categorySelect .card {
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08); /* 카드에 그림자 추가 */
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    height: 100%; /* 부모 높이에 맞춰 */
    display: flex;
    flex-direction: column;
}

#categorySelect .card:hover {
    transform: translateY(-5px); /* 호버 시 살짝 위로 이동 */
    box-shadow: 0 6px 15px rgba(0,0,0,0.15); /* 호버 시 그림자 강화 */
}

#categorySelect .card a {
    text-decoration: none; /* 링크 밑줄 제거 */
    color: inherit; /* 링크 텍스트 색상 상속 */
    display: block; /* 링크 영역 전체 카드 */
    padding: 20px; /* 카드 바디 내부 패딩 */
    flex-grow: 1; /* 링크 내부 컨텐츠가 공간을 채우도록 */
}

#categorySelect .card-title {
    font-size: 1.4em;
    font-weight: 700;
    color: #1976d2; /* 카드 제목 색상 강조 */
    margin-bottom: 10px;
}

#categorySelect .card-text {
    font-size: 1em;
    color: #6c757d;
    line-height: 1.5;
}

/* 텍스트 색상 및 배경색 입력 필드 옆에 나란히 배치 */
.mb-3 .form-control-plaintext + .form-control-color {
    display: inline-block;
    vertical-align: middle;
    margin-left: 10px;
    width: 40px; /* 너비 조절 */
    height: 40px; /* 높이 조절 */
    padding: 0; /* 패딩 제거 */
}

/* 링크 스타일 */
#datelink {
    color: #007bff;
    text-decoration: none;
    font-weight: 500;
}
#datelink:hover {
    text-decoration: underline;
}

/* 버튼 스타일 (부트스트랩 기본 버튼에 추가) */
.modal-footer .btn {
    padding: 8px 18px;
    font-size: 0.95em;
    font-weight: 600;
    border-radius: 6px;
    transition: all 0.2s ease;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    color: white;
}

.modal-footer .btn-primary {
    background-color: #007bff;
    border-color: #007bff;
}
.modal-footer .btn-primary:hover {
    background-color: #0056b3;
    border-color: #004085;
    box-shadow: 0 3px 8px rgba(0,0,0,0.2);
}

.modal-footer .btn-secondary {
    background-color: #6c757d;
    border-color: #6c757d;
}
.modal-footer .btn-secondary:hover {
    background-color: #545b62;
    border-color: #494f55;
    box-shadow: 0 3px 8px rgba(0,0,0,0.2);
}

.modal-footer .btn-danger {
    background-color: #dc3545;
    border-color: #dc3545;
}
.modal-footer .btn-danger:hover {
    background-color: #bd2130;
    border-color: #b21f2d;
    box-shadow: 0 3px 8px rgba(0,0,0,0.2);
}

.modal-footer .btn-warning {
    background-color: #ffc107;
    border-color: #ffc107;
    color: #333; /* 경고 버튼 텍스트는 어둡게 */
}
.modal-footer .btn-warning:hover {
    background-color: #e0a800;
    border-color: #d39e00;
    box-shadow: 0 3px 8px rgba(0,0,0,0.2);
}
hr {
    border: none;
    border-top: 1px solid currentColor;
}
#datelink {
    color: #007bff;
    text-decoration: none;
    font-weight: bold;
    margin-top: 5px;
    display: inline-block;
    padding: 5px 0;
 }
#datelink:hover {
	color: #0056b3;
	text-decoration: underline;
}
.modal-dialog-scrollable .modal-content {
    overflow: scroll;
}

select#concertList {
    width: 100%;
}
</style>
</head>

<body>
<div class="emp-container">
<input type="hidden" id="firstArtistGroupNo" name="firstArtistGroupNo" />
	<%@ include file="../modules/header.jsp" %>

		<div class="emp-body-wrapper">
		<%@ include file="../modules/aside.jsp" %>
			<main class="emp-content" style="font-size: small;">
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
						<li class="breadcrumb-item"><a href="#" style="color:black;"> 아티스트 커뮤니티 관리</a></li>
						<li class="breadcrumb-item active" aria-current="page">일정 관리</li>
					</ol>
				</nav>
				<div class="calendar-header-bar">
			        <div class="calendar-title">아티스트 일정 관리</div>
			        <button class="calendar-add-btn" id="categorySelectModal" data-bs-toggle="modal" data-bs-target="#categorySelect"><i class="fas fa-calendar-plus"></i> 등록</button>
			    </div>
			    <hr/>
			    <div id="calendar"></div>
			</main>
	</div>
</div>


<!-- 카테고리 선택 모달 시작-->

<div class="modal fade" id="categorySelect" aria-hidden="true" aria-labelledby="categorySelectModalToggleLabel" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="categorySelectModalToggleLabel">일정 카테고리</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="row">
		  <div class="col-sm-6">
		    <div class="card">
		    	<a href="#scheduleAddModal" role="button" data-bs-toggle="modal" data-bs-category="concert">
			      <div class="card-body">
			        <h5 class="card-title">행사 / 공연</h5>
			        <p class="card-text">행사 또는 공연을 작성하는 모달로 이동합니다.</p>
			      </div>
		     	</a>
		    </div>
		  </div>
		  <div class="col-sm-6">
		    <div class="card">
		    	<a href="#scheduleAddModal" role="button" data-bs-toggle="modal" data-bs-category="etc">
			      <div class="card-body">
			        <h5 class="card-title">기타</h5>
			        <p class="card-text">일정을 작성하는 모달로 이동합니다.</p>
			      </div>
		      	</a>
		    </div>
		  </div>
		</div>
      </div>
    </div>
  </div>
</div>


<!-- 카테고리 선택 모달 끝 -->

<!-- 등록 모달 시작 -->
<div class="modal fade" id="scheduleAddModal" tabindex="-1" data-bs-backdrop="static" aria-labelledby="scheduleAddModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-scrollable">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="scheduleAddModalLabel">일정 등록</h5>
				<button type="button" class="btn-close" aria-label="Close" id="addCloseBtn"></button>
			</div>
			<div class="modal-body">
				<div class="mb-3" style="display:none">
					<label for="concertList" class="form-label">콘서트 일정 목록</label>
					<select id="concertList">
					</select>
				</div>
	        	<div class="mb-3">
	        		 <label for="addTitle" class="form-label">일정명</label>
	        		 <input type="text" class="form-control-plaintext" id="addTitle" name="title" placeholder="일정명을 입력해주세요.">
	        		 <input type="color" class="form-control-color" id="addTextColor">
	        		 <input type="hidden" id="artGroupNo" name="artGroupNo"  />
	        		 <input type="hidden" id="addArtSchCatCode" name="artSchCatCode" />
	        	</div>
	        	<div class="mb-3">
					<label for="addContent" class="col-form-label">내용</label>
					<textarea class="form-control" id="addContent" placeholder="내용을 입력해주세요."></textarea>
				</div>
				<div class="mb-3">
					<label for="addPlace" class="col-form-label">장소</label>
					<input type="text" name="place" id="addPlace" class="form-control" placeholder="장소를 입력해주세요."/>
				</div>
				<div class="mb-3">
					<label for="addDateUrl" class="col-form-label">경로</label>
					<input type="text" name="url" id="addDateUrl" class="form-control" placeholder="경로를 입력해주세요."/>
				</div>
				<div class="mb-3">
					<div class="form-check form-switch">
				        <label class="form-check-label user-select-none" for="addAllDayStatus">하루 일정 여부</label>
				        <input class="form-check-input" type="checkbox" id="addAllDayStatus" name="allDayStatus" role="switch">
				    </div>
				</div>
				<div class="mb-3">
					<label for="date" class="col-form-label">일정</label>
					<input type="text" name="addDatetimes" id="date" class="form-control"/>
					<input type="hidden" name="start" id="addStartDate" />
					<input type="hidden" name="end" id="addEndDate" />
					<input type="hidden" name="start" id="addAllStartDate" />
					<input type="hidden" name="end" id="addAllEndDate" />
				</div>
				<div class="mb-3" id="addBackgroundColorDiv">
					<label for="addBackgroundColor" class="form-label">일정 배경색</label>
					<input type="color" class="form-control form-control-color" id="addBackgroundColor" >
				</div>
	        </div>
	        <div class="modal-footer">
			  <button type="button" class="btn btn-primary" id="addBtn">추가</button>
			  <button type="button" class="btn btn-secondary" id="addCancelBtn">취소</button>
			  <button class="btn btn-info" data-bs-target="#categorySelect" data-bs-toggle="modal" data-bs-dismiss="modal">
			  	<i class="fa-solid fa-arrow-left"></i> 처음으로
			  </button>
			</div>
		</div>
	</div>
</div>
<!-- 등록 모달 끝 -->

<!-- 상세, 수정 모달 창 -->
<div class="modal fade" id="scheduleModal" tabindex="-1" data-bs-backdrop="static" aria-labelledby="scheduleModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="scheduleModalLabel">일정 상세</h5>
				<button type="button" class="btn-close" aria-label="Close" id="closeBtn"></button>
			</div>
			<div class="modal-body">
	        	<div class="mb-3">
	        		 <label for="일정명" class="form-label">일정명</label>
	        		 <input type="text" class="form-control-plaintext" id="title" name="title" disabled="disabled">
	        		 <input type="color" class="form-control-color" id="textColor" style="display:none">
	        		 <input type="hidden" id="dateId" name="dateId" />
	        	</div>
	        	<div class="mb-3">
					<label for="content" class="col-form-label">내용</label>
					<textarea class="form-control" id="content" disabled="disabled"></textarea>
				</div>
				<div class="mb-3">
					<label for="place" class="col-form-label">장소</label>
					<input type="text" name="place" id="place" class="form-control" disabled="disabled"/>
				</div>
				<div class="mb-3">
					<label for="dateUrl" class="col-form-label">경로</label>
					<a href="" id="datelink"></a>
					<input type="text" name="url" id="dateUrl" class="form-control" style="display:none"/>
				</div>
				<div class="mb-3">
					<div class="form-check form-switch">
						<label for="allDayCheck" class="form-check-label user-select-none">하루 일정 여부</label>
						<input class="form-check-input" type="checkbox" id="allDayStatus" name="allDayStatus" role="switch" disabled="disabled">
					</div>
				</div>
				<div class="mb-3">
					<label for="date" class="col-form-label">일정</label>
					<input type="text" name="datetimes" id="date" class="form-control" disabled="disabled"/>
					<input type="hidden" name="start" id="startDate" />
					<input type="hidden" name="end" id="endDate" />
					<input type="hidden" name="start" id="allStartDate" />
					<input type="hidden" name="end" id="allEndDate" />
				</div>
				<div class="mb-3" style="display:none" id="backgroundColorDiv" name="backgroundColorDiv">
					<label for="backgroundColor" class="form-label">일정 배경색</label>
					<input type="color" class="form-control form-control-color" id="backgroundColor" >
				</div>
	        </div>
	        <div class="modal-footer">
	          <button type="button" class="btn btn-danger" id="delete" style="display:none">삭제</button>
			  <button type="button" class="btn btn-primary" id="updateBtn">수정</button>
			  <button type="button" class="btn btn-secondary" id="cancelBtn">닫기</button>
			</div>
		</div>
	</div>
</div>
<!-- 수정 상세 모달 창 끝 -->

<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
</body>
<script type="text/javascript">

function checkBtn(e){


	let flag = false;
	let checkYn = $("#addAllDayStatus").is(":checked");

	if($("#addStartDate").val() == "" && $("#addAllStartDate").val() == ""){
		$("#addStartDate").val(e.start);
		$("#addEndDate").val(e.end);

		$("#addAllStartDate").val(formatDate(e.start,true));
		$("#addAllEndDate").val(dateFormat(e.end,true));

	}


	if(checkYn){
		$("#addAllDayStatus").val('Y')
		let newE = {
			start : $("#addAllStartDate").val(),
			end : $("#addAllEndDate").val()
		}

		datePicker(newE,checkYn, flag)
	}else{
		$("#addAllDayStatus").val('N')
		let newE = {
			start : $("#addStartDate").val(),
			end : $("#addEndDate").val()
		}

		datePicker(newE,checkYn, flag);
	}

}

$(function(){
	fullCalendar();

	// categorySelect 모달 내의 카테고리 선택 링크 클릭 이벤트 처리
    // 사용자가 '행사/공연' 또는 '방송' 카드를 클릭했을 때 실행됩니다.
    $('#categorySelect a[data-bs-toggle="modal"]').on('click', function(e) {
        // 클릭된 <a> 태그에서 data-bs-category 속성 값(예: 'concert', 'broadCast')을 가져옵니다.
        var selectedCategory = $(this).data('bs-category');
        var categoryCode = ''; // 데이터베이스에 저장될 실제 카테고리 코드

        // 'categorySelect' 모달의 '행사/공연'은 'ASCC002 (공연)'으로,
        // '방송'은 'ASCC001 (기타)'으로 매핑합니다.
        if (selectedCategory === 'concert') {
            categoryCode = 'ASCC002'; // '공연' 카테고리 코드
        } else if (selectedCategory === 'etc') {
            categoryCode = 'ASCC001'; // '기타' 카테고리 코드 (방송에 대한 명확한 카테고리가 없으므로 '기타'로 매핑)
            let selectStyle = $("#concertList").parent("div")[0].style.display;
            if(selectStyle != 'none'){
            	selectStyle = $("#concertList").parent("div")[0].style.display = 'none';
            }
        }

        // scheduleAddModal에 있는 숨겨진 입력 필드 'addArtSchCatCode'에 값을 설정합니다.
        $('#addArtSchCatCode').val(categoryCode);
    });

    // scheduleAddModal이 완전히 닫힐 때 숨겨진 카테고리 필드 값을 초기화합니다.
    $('#scheduleAddModal').on('hidden.bs.modal', function () {
        $('#addArtSchCatCode').val('');
    });

	// 새 일정 등록 버튼 클릭 했을 시
// 	$("#addScheduleBtn").on("click",function(){
// 		let modalId = document.getElementById("categorySelect");	// 등록 모달 아이디
// 		let modal = new bootstrap.Modal(modalId);	// 등록 모달 요소

// 		modal.show();	// 등록 모달 열기
// 	});
	// 등록 모달 창이 열렸을 시
	$("#scheduleAddModal").on("show.bs.modal",function(event){

		// 기존에 있던 내용들 지우기
		$("#addAllDayStatus").prop('checked',false);
		$("#addTitle").val("");
		$("#addTextColor").val("");
		$("#addContent").val("");
		$("#addPlace").val("");
		$("#addDateUrl").val("");
		$("#addBackgroundColor").val("");
		$("#addStartDate").val("");
		$("#addEndDate").val("");
		$("#addAllStartDate").val("");
		$("#addAllEndDate").val("");

		let currentTime = moment()		// 모달창이 열렸을 떄 현재 시간

		let date = formatDate(currentTime);	// 현재 시간을 일정에 표시하기 위해 날짜 형식을 변경

		// datePicker에게 일정을 주기 위한 객체 생성
		let e = {
			start : date,
			end : date
		}

		checkBtn(e);

		let category = event.relatedTarget.getAttribute('data-bs-category');

		// 등록되어 있는 콘서트 일정 가져오기
		if(category == 'concert'){
			$("#concertList").parents("div").attr("style","display:block");
			var calendarEl = document.getElementById("calendar");
			let currentCal = $("#fc-dom-1")[0].innerHTML;

			let parts = currentCal.split('년 ');
			let data;
	        if (parts.length === 2) {
	            let year = parseInt(parts[0]);
	            let month = parseInt(parts[1].replace('월', '')); // '월' 제거 후 숫자로 변환

	            month = month >= 10 ? month : '0' + month;

	            let endFormatDate;
	            let endMonth = parseInt(month) + 1;

	            if(endMonth == 13){
	            	year = year + 1;
	            	endMonth = 01;
	            	endFormatDate = year + "-" + endMonth;
	            }else{
	            	endFormatDate = year + "-" + endMonth;
	            }

	            let startFormatDate;
	            let startMonth = parseInt(month) - 1;
	            if(startMonth == 00){
	            	year = year - 1;
	            	startMonth = 12;
	            	startFormatDate = year + "-" + startMonth;
	            }else{
	            	startFormatDate = year + "-" + startMonth;
	            }


	            let curMonthStart = moment(startFormatDate).startOf("month").format("YYYY-MM-DD HH:mm:ss");
	            let curMonthEnd = moment(endFormatDate).endOf("month").format("YYYY-MM-DD HH:mm:ss");

	            let artGroupNo = $("#artGroupNo").val();
	            data = {
    	        	"category" : category,
    	        	"curMonthStart" : curMonthStart,
    	        	"curMonthEnd" : curMonthEnd,
    	        	"artGroupNo" : artGroupNo
    	        }
	        }


	        $.ajax({
	        	url : '/emp/schedule/concert/list',
	        	type : 'get',
	        	data : data,
	        	success : function(res){
	        		if(res != null && res.length > 0){
	        			let html = `<option value="">콘서트를 선택해주세요!</option>`;
	        			for(let i=0; i<res.length; i++){
	        				let concert = res[i];
	        				let temp1 = concert.concertNm.replaceAll('<', '&lt;');
	        				let temp2 = temp1.replaceAll('>', '&gt;');
	        				html +=`
	        					<option value=\${concert.concertNo}>\${temp2}(\${concert.commCodeDetVO.description})</option>
	        				`;
	        			}

	        			$("#concertList").html(html);
	        		}else{
	        			let html = `
	        				<option value="">등록된 콘서트가 없습니다!</option>
	        			`;
	        			$("#concertList").html(html);
	        		}
	        	},
	        	error : function(error){
	        		console.log(error.status)
	        	}
	        })
		}else{

		}



	});

	// 등록 모달에 있는 체크박스 클릭 시
	$("#addAllDayStatus").on("click",function(){
		checkBtn();

	});

	$("#addBtn").on("click",function(){

		let data = new FormData();
		data.append("artGroupNo",$("#artGroupNo").val());
		data.append("title",$("#addTitle").val());
		data.append("content",$("#addContent").val());
		data.append("place",$("#addPlace").val());
		data.append("url",$("#addDateUrl").val());
		data.append("textColor",$("#addTextColor").val());
		data.append("backgroundColor",$("#addBackgroundColor").val());
		data.append("allDayStatus",$("#addAllDayStatus").val());

		let selectedCategoryCode = $('#addArtSchCatCode').val();
		if (selectedCategoryCode) { // 값이 비어있지 않은 경우에만 추가 (NOT NULL 제약 조건 때문)
            data.append("artSchCatCode", selectedCategoryCode);
        } else {
        	// 카테고리 코드가 비어있는 경우
        	Swal.fire({
                title: "카테고리 미선택",
                text: "일정 카테고리를 선택해주세요.",
                icon: "warning",
                showConfirmButton: true
            });
            return false;
        }

		// 등록 버튼 클릭 시 시작 종료 일정을 보내는 것을 선택
		// 만약 하루 일정이 체크가 되어있다면 상태는 Y
		// 시작 일정 형식은 2025-05-30T00:00:00
		// 종료 일정 형식은 2025-05-31T00:00:00
		// 로 보내줌
		if($("#addAllDayStatus").is(':checked')){
			data.append("start",$("#addAllStartDate").val());
			data.append("end",$("#addAllEndDate").val());
		}else{
			// 만약 하루 일정이 체크가 되어있다면 상태는 N
			// 시작 일정 형식은 2025-05-30T12:20:40
			// 종료 일정 형식은 2025-05-31T15:10:20
			// 로 보내줌
			data.append("start",$("#addStartDate").val());
			data.append("end",$("#addEndDate").val());
		}

		$.ajax({
			url : "/emp/schedule/insert",
			type : "post",
			data : data,
			processData : false,
			contentType : false,
			success : function(res){
				if(res == "OK"){
					Swal.fire({
						title : "등록완료!",
						text : "정상적으로 등록이 완료되었습니다.",
						icon : "success",
						showConfirmButton : true
					}).then((result) => {
						location.href = "/emp/schedule/main";
					});
				}else{
					Swal.fire({
						title : "등록실패",
						text : "등록이 실패되었습니다. 다시 시도해주세요!",
						icon : "error",
						showConfirmButton : true
					}).then((result) => {
						location.href = "/emp/schedule/main";
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
	});

	$("#scheduleModal").on("show.bs.modal",function(e){

		let flag = true;	// 상세일정이라는 의미

		let modalTitle = $("#title");		// 상세 모달 제목
    	let modalContent = $("#content");	// 상세 모달 내용
    	let modalPlace = $("#place");		// 상세 모달 장소
    	let modalUrl = $("#dateUrl");		// 상세 모달
    	let modalTextColor = $("#textColor");	// 상세 모달 제목 색상
    	let modalBackgroundColor = $("#backgroundColor");	// 일정 배경 색
    	let modalDateId = $("#dateId");		// 일정 번호
    	let link = $("#datelink");			// url태그
    	let modalAllDayStatus = $("#allDayStatus");

		let target = e.relatedTarget;


		let { title, url, textColor, backgroundColor, id, allDay } = target.event;
		let { allDayStatus, content, place } = target.event.extendedProps;

		modalTitle.val(title);
    	modalContent.html(content);
    	modalPlace.val(place);
    	modalUrl.val(url);
    	modalTextColor.val(textColor);
    	modalBackgroundColor.val(backgroundColor);
    	modalDateId.val(id);
    	modalAllDayStatus.val(allDayStatus)

    	link.attr("href",url);
    	link.html(title+" 이동 <i class='fa-solid fa-arrow-up-right-from-square'></i>");

    	if(allDay){
    		$("#allDayStatus").prop("checked",true);
    	}else{
    		$("#allDayStatus").prop("checked",false);
    	}

    	detailCheckBtn(target);

	});

	// 상세 모달에 있는 수정 버튼 클릭 시
	$("#updateBtn").on("click",function(){
		if($("#updateBtn").html() === '수정'){
			$("#datelink").attr("style","display:none");

			$("#textColor").attr("style","display:block");
			$("#dateUrl").attr("style","display:block");
			$("div[name='backgroundColorDiv']").attr("style","display:block");

			$("input").attr("disabled",false);
			$("#content").attr("disabled",false);

			$("#delete").attr("style","display:block");

			$("#updateBtn").html("저장");
			$("#updateBtn").attr("class","btn btn-primary");

			$("#cancelBtn").html("취소");
		}else{
			let id = $("#dateId").val();


			let data = new FormData();

			data.append("title",$("#title").val());
			data.append("content",$("#content").val());
			data.append("place",$("#place").val());
			data.append("url",$("#dateUrl").val());
			data.append("allDayStatus",$("#allDayStatus").val());
			data.append("textColor",$("#textColor").val());
			data.append("backgroundColor",$("#backgroundColor").val());

			if($("#allDayStatus").val() === 'Y'){
				data.append("start",$("#allStartDate").val());
				data.append("end",$("#allEndDate").val());
			}else{
				data.append("start",$("#startDate").val());
				data.append("end",$("#endDate").val());
			}

			$.ajax({
				url : "/emp/schedule/dateUpdate/" + id,
				type : "post",
				data : data,
				processData : false,
				contentType : false,
				success : function(res){
					if(res == "OK"){
						Swal.fire({
							title : "수정 완료!",
							text : "정상적으로 수정이 완료되었습니다.",
							icon : "success",
							showConfirmButton : true
						}).then((result) => {
							location.href = "/emp/schedule/main";
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

	// 상세 모달에 있는 하루 일정 여부 클릭 시
	$("#allDayStatus").on("click",function(){
		detailCheckBtn();
	});

	// 상세 모달 닫혔을 때 이벤트
	$("#scheduleModal").on("hidden.bs.modal",function(){
		$("#datelink").attr("style","display:block");

		$("#textColor").attr("style","display:none");
		$("#dateUrl").attr("style","display:none");
		$("#backgroundColorDiv").attr("style","display:none");

		$("#delete").attr("style","display:none");

		$("#title").attr("disabled",true);
		$("#place").attr("disabled",true);
		$("#allDayStatus").attr("disabled",true);
		$("input[name='datetimes']").attr("disabled",true);
		$("#content").attr("disabled",true);

		$("#updateBtn").html("수정");
		$("#updateBtn").attr("class","btn btn-primary");

		$("#startDate").val("");
		$("#endDate").val("");
		$("#allStartDate").val("");
		$("#allEndDate").val("");
	});

	// 취소버튼 클릭 시
	$("#cancelBtn").on("click", function(){

		if($("#cancelBtn").html() === '닫기'){
			$("#scheduleModal").modal('hide');
		}else{
			Swal.fire({
				title : "취소요청",
				text : "수정중인 정보는 저장되지 않습니다. 정말로 취소하시겠습니까?",
				icon : "question",
				showCancelButton : true,
				cancelButtonText : "아니오",
				confirmButtonText : "예",
			}).then((result) => {
				if(result.isConfirmed){
					$("#scheduleModal").modal('hide');
				}else{
					return false;
				}
			});
		}
	});

	// 상세 모달 상단에 x버튼 클릭 시
	$("#closeBtn").on("click", function(){

		if($("#updateBtn").html() === '수정'){
			$("#scheduleModal").modal('hide');
		}else{
			Swal.fire({
				title : "취소요청",
				text : "수정중인 정보는 저장되지 않습니다. 정말로 취소하시겠습니까?",
				icon : "question",
				showCancelButton : true,
				cancelButtonText : "아니오",
				confirmButtonText : "예",
			}).then((result) => {
				if(result.isConfirmed){
					$("#scheduleModal").modal('hide');
				}else{
					return false;
				}
			});
		}
	});

	// 상세 모달 삭제 버튼 클릭 시
	$("#delete").on("click",function(){
		let id = $("#dateId").val();

		Swal.fire({
			title : "삭제하시겠습니까?",
			text : "삭제시 복구하실 수 없습니다.",
			icon : "question",
			showCancelButton : true,
			cancelButtonText : "아니오",
			confirmButtonText : "예",
		}).then((result) => {
			if(result.isConfirmed){
				$.ajax({
					url : "/emp/schedule/delete/" + id,
					type : "post",
					success : function(res){
						if(res == "OK"){
							Swal.fire({
								title : "삭제완료!",
								text : "정상적으로 삭제가 완료되었습니다.",
								icon : "success",
								showConfirmButton : true
							}).then((result) => {
								location.href = "/emp/schedule/main";
							});
						}else{
							Swal.fire({
								title : "삭제실패",
								text : "삭제가 실패되었습니다. 다시 시도해주세요!",
								icon : "error",
								showConfirmButton : true
							}).then((result) => {
								location.href = "/emp/schedule/main";
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

	// 등록 모달에서 취소 버튼 클릭 시
	$("#addCancelBtn").on("click",function(){
		Swal.fire({
			title : "취소요청",
			text : "작성중인 정보는 저장되지 않습니다. 정말로 취소하시겠습니까?",
			icon : "question",
			showCancelButton : true,
			cancelButtonText : "아니오",
			confirmButtonText : "예",
		}).then((result) => {
			if(result.isConfirmed){
				$('#scheduleAddModal').modal('hide');
			}else{
				return false;
			}
		});
	});

	$("#addCloseBtn").on("click",function(){
		Swal.fire({
			title : "취소요청",
			text : "작성중인 정보는 저장되지 않습니다. 정말로 취소하시겠습니까?",
			icon : "question",
			showCancelButton : true,
			cancelButtonText : "아니오",
			confirmButtonText : "예",
		}).then((result) => {
			if(result.isConfirmed){
				$('#scheduleAddModal').modal('hide');
			}else{
				return false;
			}
		});
	});

// 	$("#my-today-button").on("click",function(){
// 		console.log("오늘 버튼 클릭 됨");
// 	});

	$("#addBackgroundColor").on("input",function(){
		let backgroundColor = $(this).val();
		$("#scheduleAddModal .modal-header")[0].style.backgroundColor=backgroundColor;
	});

	$("#addTextColor").on("input",function(){
		let textColor = $(this).val();
		$("#scheduleAddModal .modal-header").children(".modal-title")[0].style.color = textColor

	});


	$("#concertList").on("change",function(e){
		let concertNo = $("#concertList").val();
		let artGroupNo = $("#artGroupNo").val();

		let data = {
			"concertNo" : concertNo,
			"artGroupNo" : artGroupNo
		}

		$.ajax({
			url : '/emp/schedule/concert/data',
			type : 'get',
			data : data,
			success : function(res){
				let { concertGuide, concertNm, concertDate, concertNo, concertRunningTime } = res;
				let { description } = res.commCodeDetVO;
				let { concertAddress } = res.concertHallVO;

				let concertName = concertNm + " (" + description + ")";

				$("#addTitle").val(concertName);
				$("#addContent").val(concertGuide);
				$("#addPlace").val(concertAddress);


				let date = formatDate(concertDate);	// 현재 시간을 일정에 표시하기 위해 날짜 형식을 변경

				let endDate = new Date(date);
				endDate.setMinutes(endDate.getMinutes() + (parseInt(concertRunningTime)-60));

				let finalEndDate = formatDate(endDate);

				let allStartDate = formatDate(concertDate,true);
				let allEndDate = dateFormat(concertDate,true);


				$("#addStartDate").val(date);
				$("#addEndDate").val(finalEndDate);

				$("#addAllStartDate").val(allStartDate);
				$("#addAllEndDate").val(allEndDate);

				// datePicker에게 일정을 주기 위한 객체 생성
				let e = {
					start : date,
					end : date
				}

				checkBtn(e);

				$("#addTextColor").val("#2E8B57");
				$("#addBackgroundColor").val("#F0FFF0");

				$("#scheduleAddModal .modal-header").children(".modal-title")[0].style.color = "#2E8B57"
				$("#scheduleAddModal .modal-header")[0].style.backgroundColor="#F0FFF0";
				$("#addArtSchCatCode").val("ASCC002");

			},
			error : function(error){
				console.log(error.status)
			}
		});
	});
});

function detailCheckBtn(e){

	let flag = true;
	let checkYn = $("#allDayStatus").is(":checked");


	if(e != null){
		let {start, end} = e.event;
		let {allDay:eventAllDay}  = e.event;

		if(eventAllDay != null){

			checkYn = eventAllDay;
		}

		if(checkYn){
			let editDate = dayjs(end);
			end = editDate.subtract(1,'day');
		}

		if($("#startDate").val() == "" && $("#allStartDate").val() == ""){
			$("#startDate").val(formatDate(start,checkYn));
			$("#endDate").val(dateFormat(end,checkYn));

			$("#allStartDate").val(formatDate(start,true));
			$("#allEndDate").val(dateFormat(end,true));
		}
	}

	if(checkYn){
		$("#allDayStatus").val('Y');
		let end = $("#allEndDate").val();

		let newE = {
			start : $("#allStartDate").val(),
			end : end
		}
		datePicker(newE,checkYn, flag)
	}else{
		$("#allDayStatus").val('N');
		let end = $("#endDate").val();
		let newE = {
			start : $("#startDate").val(),
			end : end
		}

		datePicker(newE,checkYn, flag)
	}
}

// 풀캘린더 영역 시작
function fullCalendar(){
	var calendarEl = document.getElementById("calendar");
	var calendar = new FullCalendar.Calendar(calendarEl,{
		height : 'auto',
		initialView : 'dayGridMonth',
		handleWindowResize : true,
		nowIndicator : true,
		eventOverlap : true,
		editable : true,
		selectable : true,
		buttonText : {
			today : '오늘',
			month : '달',
			week : '이번주'
		},

		eventDidMount: function(info) {

			let { place, content } = info.event.extendedProps;

			let subContent = content;
			if(content.length > 10){
				subContent = content.substring(0,10) + '...';
			}

			tooltipHtml = `
				<div> 장 소 : \${place}</div>
				<div> 내 용 : \${subContent}</div>
			`;
			var tooltip = new bootstrap.Tooltip(info.el, {
			   title : tooltipHtml,
			html : true,
			   placement: 'top',
			   trigger: 'hover',
			   container: 'body'
			});
	    },

		locale : 'ko',
		headerToolbar : {
			start : 'prevYear,prev,next,nextYear today',
			center : 'title',
			end : 'dayGridMonth,dayGridWeek'
		},
		events : {
			url : "/emp/schedule/list",
			type : "get",
			success : function(res){
				$("#artGroupNo").val(res.artGroupNo);
				let title = res.artGroupNm + "&nbsp;일정 관리";
				$(".calendar-title").html(title)
				return res.schedule;
			}
		},


        // 달력에 있는 일정을 클릭 시 하루에 대한 일정 상세로 이동
        select : function(e){
        	let editDate = dayjs(e.startStr);
        	let endStr = editDate.add(7,'day').format('YYYY-MM-DD');
        	calendar.changeView('timeGrid',{
        		start : e.startStr,
        		end : endStr
        	})
        },
        // 일정 클릭 시 이벤트
        eventClick : function(e){
        	e.jsEvent.cancelBubble = true;		// 일정에 있는 url 막기
        	e.jsEvent.preventDefault();

        	const detailModal = new bootstrap.Modal(document.getElementById('scheduleModal'));

        	detailModal.show(e);
        },
        eventDrop : function(e){
        	dragDropAfter(e);
        }
	});
	calendar.render();
}
// 풀 캘린더 영역 끝

function dragDropAfter(e){
	detailCheckBtn(e);

	let id = e.event.id;

	let allDay = e.event.allDay;
	let allDayStatus = e.event.extendedProps.allDayStatus;

	let data = new FormData();
	data.append("allDayStatus",allDayStatus);
	if(allDay){
		data.append("start",$("#allStartDate").val());
		data.append("end",moveDateFormat($("#allEndDate").val()));

	}else{
		data.append("start",$("#startDate").val());
		data.append("end",$("#endDate").val());
	}

	$.ajax({
		url : "/emp/schedule/dateMove/" + id,
		type : "post",
		data : data,
		processData : false,
		contentType : false,
		success : function(res){

			location.href="/emp/schedule/main";
		},
		error : function(error, status, thrown){
			console.log(error.status);
		},
		beforeSend : function(xhr) {
	        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
	    }
	});

}

// flag : 상세일정인지, 등록일정인지 판단
// e : 선택한 일정 정보
// checkYn : 하루 일정인지
function datePicker(e,checkYn, flag){

	let datePickerFormat = '';	// 화면 상 날짜 표현방식

	let timeSet = false;		// 시간 사용 여부

	// 하루 일정이면
	if(checkYn){
		datePickerFormat = 'YYYY-MM-DD';
		timeSet = false;

	// 하루 일정이 아니라면
	}else{
		datePickerFormat = 'YYYY-MM-DD HH:mm';
		timeSet = true;
	}

	let detail = "";

	// 상세 일정이 아니면 즉 등록 일정이라면
	if(!flag){
		detail = "input[name='addDatetimes']";
	}else{
		detail = "input[name='datetimes']";
	}
	$(detail).daterangepicker({
		timePicker : timeSet,
		startDate: e.start,
		endDate : e.end,
	    locale: {
	      format: datePickerFormat,
	      applyLabel : "적용",
	      cancelLabel : "취소",
	      daysOfWeek : [
	    	  "일","월","화","수","목","금","토"
	      ],
	      monthNames : [
	    	  "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"
	      ],
	      separator : " ~ "
	    },
	    drops : 'up'
	},function(start,end,label){
		let sV, eV;
		if(!flag){
			// 등록페이지 일정일 때
			if(checkYn){
				allStartVal = formatDate(start, checkYn);
				allEndVal = dateFormat(end, checkYn);
				$("#addAllStartDate").val(allStartVal);
				$("#addAllEndDate").val(allEndVal);

				startVal = formatDate(start);
				endVal = dateFormat(end);
				$("#addStartDate").val(startVal);
				$("#addEndDate").val(endVal);
			}else{
				allStartVal = formatDate(start, !checkYn);
				allEndVal = dateFormat(end, !checkYn);
				$("#addAllStartDate").val(allStartVal);
				$("#addAllEndDate").val(allEndVal);

				startVal = formatDate(start);
				endVal = dateFormat(end);
				$("#addStartDate").val(startVal);
				$("#addEndDate").val(endVal);
			}
		}else{
			// 상세페이지 일정일 때
			if(checkYn){
				allStartVal = formatDate(start, checkYn);
				let allEndVal = dateFormat(end,checkYn);

				$("#allStartDate").val(allStartVal);
				$("#allEndDate").val(allEndVal);

				startVal = formatDate(start);
				endVal = dateFormat(end);
				$("#startDate").val(startVal);
				$("#endDate").val(endVal);
			}else{
				allStartVal = formatDate(start, !checkYn);
				let allEndVal = dateFormat(end,!checkYn);


				$("#allStartDate").val(allStartVal);
				$("#allEndDate").val(allEndVal);


				startVal = formatDate(start);
				endVal = dateFormat(end);
				$("#startDate").val(startVal);
				$("#endDate").val(endVal);
			}
		}

	});
};

function dateFormat(updateDate, checkYn){
	if (!updateDate) return "";

	let date = new Date(updateDate);

	let year = date.getFullYear();
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

    // 하루 일정이라면
    if(checkYn){
    	hour = "23";
		minute = "59";
		second = "59";
    }

    // 하루 일정이면 일정 : 2025-05-30T00:00:00 으로 return
    // 하루 일정이 아니면 : 2025-05-30T15:15:15 으로 return
	return year + '-' + month + '-' + day + 'T' + hour + ':' + minute + ':' + second;
}

function formatDate(updateDate, checkYn){

	if (!updateDate) return "";

	let date = new Date(updateDate);

	let year = date.getFullYear();
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

    // 하루 일정이라면
    if(checkYn){
    	hour = "00";
		minute = "00";
		second = "00";
    }

    // 하루 일정이면 일정 : 2025-05-30T00:00:00 으로 return
    // 하루 일정이 아니면 : 2025-05-30T15:15:15 으로 return
	return year + '-' + month + '-' + day + 'T' + hour + ':' + minute + ':' + second;
};

function moveDateFormat(updateDate, checkYn){

	if (!updateDate) return "";

	let date = new Date(updateDate);

	let year = date.getFullYear();
	let month = date.getMonth() + 1;
    let day = date.getDate() + 1;
    let hour = date.getHours();
    let minute = date.getMinutes();
    let second = date.getSeconds();

    month = month >= 10 ? month : '0' + month;
    day = day >= 10 ? day : '0' + day;
    hour = hour >= 10 ? hour : '0' + hour;
    minute = minute >= 10 ? minute : '0' + minute;
    second = second >= 10 ? second : '0' + second;

    // 하루 일정이라면
    if(checkYn){
    	hour = "00";
		minute = "00";
		second = "00";
    }

    // 하루 일정이면 일정 : 2025-05-30T00:00:00 으로 return
    // 하루 일정이 아니면 : 2025-05-30T15:15:15 으로 return
	return year + '-' + month + '-' + day + 'T' + hour + ':' + minute + ':' + second;
};

</script>
</html>