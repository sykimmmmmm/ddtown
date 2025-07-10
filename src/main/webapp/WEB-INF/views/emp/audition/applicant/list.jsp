<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<!-- pdf관련 스크립트 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://unpkg.com/html2pdf.js@0.10.1/dist/html2pdf.js"></script>

<!-- 파일 로드 하는 HTML(모달창 닫기 관련) -->
<script src="/resources/plugins/jquery/jquery.min.js"></script>
<script src="/resources/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- /// adminlte3 사용 시작 /// -->
<link rel="stylesheet" href="/resources/dist/css/adminlte.min.css">
<script type="text/javascript" src="/resources/dist/js/adminlte.min.js"></script>
<script type="text/javascript" src="/resources/plugins/jquery/jquery.min.js"></script>
<!-- /// adminlte3 사용 끝 /// -->

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
<style>
	#applicant-info-for-pdf {
	    font-family: 'Noto Sans KR', sans-serif !important; /* <--- !important 필수 */
	}
	body {
	    font-family: 'Noto Sans KR', sans-serif;
	    color: #333;
	    background-color: #f8f9fa; /* 전체 페이지 배경색 */
	}

	a {
	    text-decoration: none;
	}

	.audition-status-tabs {
	    display: flex;       /* 탭들을 가로로 나열 */
	    border-bottom: 1px solid #e0e0e0; /* 아래쪽 경계선 */
	    margin-bottom: 15px; /* 아래 여백 - 검색/드롭다운과의 간격 조절 */
	    padding-bottom: 5px; /* 경계선과 탭 사이 여백 */

	    /* ★★★ 가로를 꽉 채우기 위한 핵심 변경/추가 ★★★ */
	    width: 100%;        /* 부모 요소의 전체 너비를 사용 */
	    box-sizing: border-box; /* 패딩, 보더가 너비에 포함되도록 */

	    /* 탭들이 가로 공간을 균등하게 분배하도록 설정 */
	    /* 이미지와 같이 각 탭이 동일한 너비로 공간을 채우면서 정렬되도록 합니다. */
	    justify-content: space-around; /* 탭들 사이에 균등한 간격을 둡니다. */
	    /* 또는 space-between; 을 사용하여 양쪽 끝에 탭을 배치하고 나머지 간격을 균등하게 할 수도 있습니다. */

	    /* 탭 텍스트가 넘치면 잘리도록 방지 (선택 사항) */
	    overflow-x: hidden;
	}

	/* 각 탭의 스타일 */
	.audition-status-tab {
	    padding: 10px 15px; /* 탭 내부 여백 (글씨 크기 키운 후 시각적으로 조절) */
	    text-decoration: none; /* 밑줄 제거 */
	    color: #555;          /* 기본 글자색 */
	    font-weight: 500;     /* 글자 두께 */
	    transition: color 0.3s ease, border-bottom 0.3s ease; /* 호버/활성 시 부드러운 전환 */
	    border-bottom: 2px solid transparent; /* 기본 밑줄 투명 (활성 시 색 변경) */
	    white-space: nowrap;  /* 탭 텍스트가 줄바꿈되지 않도록 */

	    /* ★★★ 글씨 크기 키우기 ★★★ */
	    font-size: 1.15em; /* 이전보다 약간 더 키워봄. 필요에 따라 조절 (16px 기준 약 18.4px) */
	    /* 또는 font-size: 19px; */

	    /* ★★★ 탭들이 가로 공간을 균등하게 차지하도록 ★★★ */
	    flex-grow: 1;     /* flex-container 내에서 남은 공간을 균등하게 채우도록 성장 */
	    text-align: center; /* 탭 내의 텍스트를 가운데 정렬 */
	    min-width: 0;     /* flex-grow가 제대로 작동하도록 설정 */
	}

	/* 마우스 오버 시 탭 스타일 */
	.audition-status-tab:hover {
	    color: #007bff;
	}

	/* 활성화된 탭 스타일 */
	.audition-status-tab.active {
	    color: #28a745; /* 활성 탭 글자색 (초록색 계열) */
	    border-bottom-color: #28a745;
	}

	.applicant-name-link {
	    color: #007bff !important;
	    font-weight: 500; /* 글자 두께를 약간 더 굵게 */
	    text-decoration: none; /* 밑줄 없음 유지 (원하시면 hover 시 밑줄 추가) */
	    cursor: pointer; /* 마우스 오버 시 손가락 모양 커서 (기본값이라 대부분 필요 없지만 명시적) */
	}

	.am-filter-select {
	    width: 90px; /* 원하는 값으로 조절하세요 */
	}

	/* 또는 부모 컨테이너 너비의 백분율로 설정 */
	.am-filter-select {
	    width: 20%; /* 원하는 백분율로 조절하세요 */
	}
	.am-search-input{
	    width: 150px; /* 원하는 백분율로 조절하세요 */
	}



	#searchForm {
	    background-color: #ffffff; /* 흰색 배경 */
	    border-radius: 8px; /* 둥근 모서리 */
	    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); /* 은은한 그림자 */
	    padding: 25px; /* 내부 여백 */
	    margin-bottom: 20px; /* 아래쪽 여백 */
	    border: 1px solid #e0e0e0; /* 연한 테두리 */

	    display: flex; /* 내부 요소들을 가로로 정렬 */
	    flex-wrap: wrap; /* 요소들이 넘칠 경우 다음 줄로 넘어가도록 */
	    gap: 10px; /* 요소들 간의 간격 */
	    align-items: center; /* 요소들을 세로 중앙 정렬 */
	}

	/* 오디션 상태 탭스 (예: "전체 오디션", "진행 중인 오디션", "마감된 오디션") */
	.audition-status-tabs {
	    flex-basis: 100%; /* 탭스는 항상 한 줄 전체를 차지 */
	    display: flex;
	    margin-bottom: 15px; /* 탭스와 검색 필드 사이 간격 */
	    border-bottom: 2px solid #e9ecef; /* 하단 구분선 */
	    padding-bottom: 5px; /* 탭 아래 여백 */
	}

	.audition-status-tab {
	    padding: 10px 15px;
	    text-decoration: none;
	    color: #6c757d; /* 기본 글자색 */
	    font-weight: bold;
	    border-radius: 5px 5px 0 0; /* 상단 모서리만 둥글게 */
	    transition: all 0.3s ease;
	    margin-right: 5px; /* 탭 간 간격 */
	}

	.audition-status-tab:hover {
	    color: #007bff; /* 호버 시 파란색 */
	    background-color: #f8f9fa; /* 호버 시 배경색 */
	}

	.audition-status-tab.active {
	    color: #007bff; /* 활성 탭 글자색 */
	    border-bottom: 2px solid #007bff; /* 활성 탭 하단 강조선 */
	    background-color: #ffffff;
	}

	/* 검색 필터 select 박스 */
	.am-filter-select {
	    padding: 8px 12px;
	    border: 1px solid #cccccc;
	    border-radius: 5px;
	    font-size: 1em;
	    color: #555555;
	    background-color: #fff;
	    cursor: pointer;
	    min-width: 150px; /* 최소 너비 설정 */
	    appearance: none; /* 기본 브라우저 스타일 제거 */
	    -webkit-appearance: none;
	    -moz-appearance: none;
	    background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23000000%22%20d%3D%22M287%2C197.3l-118.8-118.8c-4.1-4.1-10.8-4.1-14.9%2C0L5.3%2C197.3c-4.1%2C4.1-4.1%2C10.8%2C0%2C14.9c4.1%2C4.1%2C10.8%2C4.1%2C14.9%2C0l106.6-106.6l106.6%2C106.6c4.1%2C4.1%2C10.8%2C4.1%2C14.9%2C0C291.1%2C208.1%2C291.1%2C201.4%2C287%2C197.3z%22%2F%3E%3C%2Fsvg%3E'); /* 사용자 정의 드롭다운 아이콘 */
	    background-repeat: no-repeat;
	    background-position: right 10px center;
	    background-size: 12px;
	}
	.am-filter-select:focus {
	    border-color: #007bff;
	    outline: none;
	}

	/* 검색 입력 필드 */
	.am-search-input {
	    flex-grow: 1; /* 남은 공간을 채우도록 확장 */
	    padding: 8px 12px;
	    border: 1px solid #cccccc;
	    border-radius: 5px;
	    font-size: 1em;
	    color: #333333;
	}
	.am-search-input::placeholder {
	    color: #999999;
	}
	.am-search-input:focus {
	    border-color: #007bff;
	    outline: none;
	    box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
	}

	/* 버튼 기본 스타일 (.am-btn, .ea-btn) */
	.am-btn, .ea-btn {
	    padding: 8px 15px;
	    border: none;
	    border-radius: 5px;
	    font-size: 1em;
	    cursor: pointer;
	    transition: background-color 0.3s ease, color 0.3s ease;
	}

	/* 검색 버튼 */
	.am-btn {
	    background-color: #007bff; /* 파란색 */
	    color: #ffffff;
	}
	.am-btn:hover {
	    background-color: #0056b3; /* 진한 파란색 */
	}

	/* 초기화 버튼 */
	.ea-btn { /* 이 클래스가 기존에 있다면 덮어쓰거나, 새로운 이름을 부여해주세요 */
	    background-color: #6c757d; /* 회색 */
	    color: #ffffff;
	}
	.ea-btn:hover {
	    background-color: #5a6268; /* 진한 회색 */
	}
	.am-section-header {
	    background-color: #ffffff;
	    border-radius: 8px;
	    box-shadow: 0 4px 12px rgba(0,0,0,0.06);
	    padding: 25px 30px;
	    margin-bottom: 25px;
	}

	.am-section-header h2 {
	    font-size: 1.8em;
	    font-weight: 700;
	    color: #234aad; /* 메인 제목 색상 */
	    margin-bottom: 20px; /* 뱃지 컨테이너와의 간격 */
	}

	/* am-section-content (테이블과 페이징을 감싸는 박스 스타일) */
	.am-section-content {
	    background-color: #ffffff; /* 흰색 배경 */
	    border-radius: 8px; /* 둥근 모서리 */
	    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); /* 은은한 그림자 */
	    padding: 25px; /* 내부 여백 */
	    margin-top: 20px; /* 위쪽 여백 */
	    border: 1px solid #e0e0e0; /* 연한 테두리 */
	    overflow-x: auto;
	    font-size: medium;
	}

	/* am-table (테이블 기본 스타일) */
	.am-table {
	    width: 100%; /* 테이블 너비 100% */
	    border-collapse: collapse; /* 셀 경계선 병합 */
	    margin-bottom: 20px; /* 아래쪽 여백 */
	    font-size: 0.95em; /* 글자 크기 조정 */
	    min-width: 700px;
	}

	/* 테이블 헤더 (thead) 스타일 */
	.am-table thead th {
	    background-color: #f0f5ff; /* 헤더 배경색 */
	    color: #234aad; /* 헤더 글자색 */
	    font-weight: bold; /* 글자 굵게 */
	    padding: 12px 15px; /* 상하좌우 여백 */
	    text-align: center; /* 텍스트 중앙 정렬 */
	    border-bottom: 1px solid #dddddd; /* 하단 테두리 */
	    white-space: nowrap;
	}

	/* 테이블 바디 (tbody) 셀 스타일 */
	.am-table tbody td {
	    padding: 10px 15px; /* 상하좌우 여백 */
	    border-bottom: 1px solid #eeeeee; /* 하단 테두리 */
	    text-align: center; /* 텍스트 중앙 정렬 */
	    color: #555555; /* 글자색 */
	    text-align: center;
	    vertical-align: middle;
	}
	.applicant-name-link {
	    color: #007bff; /* 파란색 링크 */
	    font-weight: 500;
	    text-decoration: none;
	    transition: color 0.2s ease-in-out;
	}
	.applicant-name-link:hover {
	    color: #0056b3; /* 호버 시 진한 파란색 */
	    text-decoration: underline; /* 호버 시 밑줄 */
	}

	/* 테이블 행 (tr) - 짝수 번째 행 배경색 (줄무늬 효과) */
	.am-table tbody tr:nth-child(even) {
	    background-color: #fcfdff; /* 연한 회색 배경 */
	}

	/* 테이블 행 (tr) - 마우스 오버 효과 */
	.am-table tbody tr:hover {
	    background-color: #e9f7ff; /* 호버 시 연한 파란색 배경 */

	}

	/* 마지막 행의 하단 테두리 제거 (선택 사항) */
	.am-table tbody tr:last-child td {
	    border-bottom: none;
	}

	/* am-pagination (페이징 영역 스타일) */
	.am-pagination {
	    text-align: center; /* 페이징 요소들 중앙 정렬 */
	    margin-top: 25px; /* 위쪽 여백 */
	    display: flex; /* 내부 요소 정렬을 위해 flex 사용 */
	    justify-content: center; /* flex 자식 요소들을 가운데 정렬 */
	    align-items: center; /* flex 자식 요소들을 세로 중앙 정렬 */
	}

	/* 페이징 링크/버튼 기본 스타일 (예시: pagingVO.pagingHTML 내부) */
	.am-pagination a,
	.am-pagination span {
	    display: inline-block; /* 인라인 블록으로 표시 */
	    padding: 8px 14px; /* 여백 */
	    margin: 0 4px; /* 버튼 간 간격 */
	    border: 1px solid #dddddd; /* 테두리 */
	    border-radius: 4px; /* 둥근 모서리 */
	    text-decoration: none; /* 밑줄 제거 */
	    color: #007bff; /* 기본 글자색 (파랑) */
	    background-color: #ffffff; /* 배경색 */
	    transition: all 0.3s ease; /* 부드러운 전환 효과 */
	    font-weight: normal; /* 기본 폰트 굵기 */
	}

	/* 현재 페이지 버튼 스타일 */
	.am-pagination .current_page { /* pagingVO에서 current_page 같은 클래스를 생성한다고 가정 */
	    background-color: #007bff; /* 현재 페이지 배경색 (파랑) */
	    color: #ffffff; /* 현재 페이지 글자색 (흰색) */
	    border-color: #007bff; /* 현재 페이지 테두리색 */
	    font-weight: bold; /* 글자 굵게 */
	}

	/* 페이징 링크/버튼 호버 효과 */
	.am-pagination a:hover {
	    background-color: #e2f2ff; /* 호버 시 배경색 */
	    border-color: #0056b3; /* 호버 시 테두리색 */
	    color: #0056b3; /* 호버 시 글자색 */
	}

	/* 비활성화된 페이징 버튼 (예: 이전/다음 버튼이 비활성화될 때) */
	.am-pagination .disabled {
	    color: #cccccc; /* 흐린 글자색 */

	    background-color: #f8f8f8; /* 흐린 배경색 */
	    border-color: #eeeeee; /* 흐린 테두리색 */
	}

	/* 오디션 상태 뱃지 (진행상태 열의 뱃지) */
	.audition-status-badge.status-in-progress,
	.audition-status-badge.status-scheduled,
	.audition-status-badge.status-closed {
	    display: inline-block;
	    padding: 4px 8px;
	    border-radius: 12px; /* 더 둥글게 */
	    font-size: 1em; /* 작게 */
	    color: #fff;
	    white-space: nowrap;
	}
	.audition-status-badge.status-in-progress { background-color: #28a745; /* 진행중 - 녹색 */ }
	.audition-status-badge.status-scheduled { background-color: #007bff; /* 예정 - 파란색 */ }
	.audition-status-badge.status-closed { background-color: #6c757d; /* 마감 - 회색 */ }

	/* pdf 관련 */
	#applicant-info-for-pdf table {
	    width: 100%; /* 테이블이 부모 너비를 꽉 채우도록 */
	    border-collapse: collapse; /* 셀 경계선이 겹치도록 (선택 사항) */
	    table-layout: fixed; /* 이 속성이 중요합니다. 열 너비를 고정하여 내용 길이에 따라 늘어나지 않도록 합니다. */
	}

	#applicant-info-for-pdf th,
	#applicant-info-for-pdf td {
	    padding: 8px; /* 셀 안쪽 여백 조정 */
	    border: 1px solid #ddd; /* 경계선 스타일 (선택 사항) */
	    vertical-align: top; /* 내용이 여러 줄일 때 상단 정렬 (선택 사항) */
	}

	/* 항목 컬럼의 너비를 명시적으로 설정하여 줄입니다. */
	#applicant-info-for-pdf table tbody tr td:first-child {
	    width: 90px; /* 원하는 너비로 조절하세요. 픽셀 단위(px)나 퍼센트(%)로 설정 가능합니다. */
	    min-width: 90px; /* 최소 너비 지정 (선택 사항) */
	    max-width: 90px; /* 최대 너비 지정 (선택 사항) */
	    background-color: #f2f2f2; /* 배경색으로 구분 (선택 사항) */
	    word-break: break-all; /* 항목 이름이 길 경우 줄바꿈 */
	}

	/* 내용 컬럼 (두 번째 td)의 텍스트 줄바꿈 설정 */
	#applicant-info-for-pdf table tbody tr td:last-child {
	    word-break: break-word; /* 긴 텍스트 강제 줄바꿈 */
	}

	/* 다른 요소들의 마진/패딩도 필요시 조정 */
	#applicant-info-for-pdf p {
	    margin: 0;
	    padding: 0;
	}

	.audition-status-badge {
	    display: inline-block;
	    padding: 0.5em 1em;
	    font-size: 90%;
	    font-weight: 700;
	    line-height: 1;
	    text-align: center;
	    font-size: 0.9em;
	    white-space: nowrap;
	    vertical-align: baseline;
	    border-radius: 1rem;
	}
	/* 목록  지원 상태 관련 */
	/* 지원 완료 */
	.audition-status-badge.status-APSC001 {
	    background-color: #007bff; /* 파란색 */
	    color: #fff;
	}

	/* 합격 */
	.audition-status-badge.status-APSC002 {
	    background-color: #28a745; /* 초록색 */
	    color: #fff;
	}

	/* 불합격 */
	.audition-status-badge.status-APSC003 {
	    background-color: #dc3545; /* 빨간색 */
	    color: #fff;
	}


	/* 공통 뱃지 스타일 */
	.status-badges-container {
	    display: flex; /* 뱃지들을 한 줄에 정렬 */
	    flex-wrap: wrap; /* 공간 부족 시 다음 줄로 넘어가도록 */
	    gap: 20px; /* 뱃지 사이 간격 */
	    margin-bottom: 20px; /* 뱃지 컨테이너 아래 여백 */
	}
	.status-badge {
	    display: inline-flex;
	    align-items: center;
	    padding: .5em 1em;
	    font-size: .9em;
	    font-weight: 600;
	    line-height: 1;
	    text-align: center;
	    white-space: nowrap;
	    vertical-align: baseline;
	    border-radius: 0.5rem;
	    cursor: pointer; /* 클릭 가능하도록 커서 변경 */
	    transition: background-color 0.2s ease-in-out; /* 부드러운 호버 효과 */
	    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
	    padding: 10px 10px;
	}

	.status-badge .label {
	    margin-right: 8px;
	}
	.status-badge:hover {
	    transform: translateY(-2px); /* 호버 시 약간 위로 */
	    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
	    opacity: 0.9;
	}
	/* 총 지원자 수 뱃지 스타일 */
	.status-badge.all-applicants {
	    background-color: #6c757d; /* 회색 또는 메인 색상 */
	    color: #fff;
	    padding: 10px 10px;
	    margin: 2px;
	}

	/* 지원 완료 (APSC001) */
	.status-badge.status-APSC001 {
	    background-color: #007bff; /* 파란색 */
	    color: #fff;
	    padding: 10px 10px;
	    margin: 2px;
	}

	/* 합격 (APSC002) */
	.status-badge.status-APSC002 {
	    background-color: #28a745; /* 초록색 */
	    color: #fff;
	    padding: 10px 10px;
	    margin: 2px;
	}

	/* 불합격 (APSC003) */
	.status-badge.status-APSC003 {
	    background-color: #dc3545; /* 빨간색 */
	    color: #fff;
	    padding: 10px 10px;
	    margin: 2px;
	}
	.modal-content {
	    border-radius: 10px;
	    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
	    overflow: hidden; /* Ensure rounded corners clip content */
	}

	.modal-header {
	    background-color: #f0f5ff; /* 연한 파란색 계열 배경 */
	    border-bottom: 1px solid #e0e5f0;
	    padding: 20px 25px;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	}

	.modal-title {
	    color: #234aad; /* 메인 테마 색상 */
	    font-weight: 700;
	    font-size: 1.4em;
	    margin: 0;
	}

	.modal-header .close {
	    font-size: 1.8rem;
	    font-weight: 300;
	    color: #6c757d; /* 회색 닫기 버튼 */
	    opacity: 0.7;
	    transition: opacity 0.2s ease;
	}

	.modal-header .close:hover {
	    opacity: 1;
	    color: #333;
	}

	.modal-body {
	    padding: 25px 30px;
	    background-color: #ffffff;
	    font-size: medium;
	}

	.modal-footer {
	    border-top: none; /* 상단 테두리 제거 */
	    padding: 15px 30px 25px;
	    background-color: #ffffff;
	    justify-content: flex-end; /* 버튼을 오른쪽으로 정렬 */
	}

	/* --- 모달 내 버튼 그룹 --- */
	.am-form-actions {
	    display: flex;
	    gap: 12px; /* 버튼 간 간격 */
	    margin-bottom: 25px; /* 아래 상세 정보와의 간격 */
	    flex-wrap: wrap; /* 작은 화면에서 버튼이 줄바꿈되도록 */
	}

	/* --- 모달 내 버튼 개별 스타일 --- */
	.am-btn {
	    padding: 10px 18px;
	    border: none;
	    border-radius: 6px;
	    font-size: 1em;
	    font-weight: 600;
	    cursor: pointer;
	    transition: background-color 0.2s ease, transform 0.1s ease, box-shadow 0.2s ease;
	    display: inline-flex;
	    align-items: center;
	    gap: 8px; /* 아이콘과 텍스트 사이 간격 */
	    box-shadow: 0 2px 5px rgba(0,0,0,0.1); /* 버튼에 그림자 추가 */
	}

	.am-btn:hover {
	    transform: translateY(-2px); /* 호버 시 약간 위로 이동 */
	    box-shadow: 0 4px 8px rgba(0,0,0,0.15); /* 호버 시 그림자 강화 */
	}

	/* 합격 버튼 */
	.am-btn.success {
	    background-color: #28a745; /* 녹색 */
	    color: #fff;
	}
	.am-btn.success:hover {
	    background-color: #218838;
	}

	/* 불합격 버튼 */
	.am-btn.danger {
	    background-color: #dc3545; /* 빨간색 */
	    color: #fff;
	}
	.am-btn.danger:hover {
	    background-color: #c82333;
	}

	/* PDF 다운로드 버튼 */
	.am-btn.primary {
	    background-color: #007bff; /* 파란색 */
	    color: #fff;
	}
	.am-btn.primary:hover {
	    background-color: #0056b3;
	}

	/* --- 지원자 상세 정보 그리드 --- */
	.applicant-detail-view-grid {
	    display: grid;
	    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); /* 최소 280px 너비로 자동 배치 */
	    gap: 20px; /* 그리드 항목 간 간격 */
	    margin-bottom: 30px;
	    padding: 15px; /* 전체 그리드 컨테이너 내부 여백 */
	    border: 1px solid #e9ecef;
	    border-radius: 8px;
	    background-color: #fcfdff; /* 연한 배경색 */
	}

	.applicant-detail-view-grid .form-group {
	    display: flex;
	    flex-direction: column; /* 라벨과 p 태그를 세로로 정렬 */
	}

	.applicant-detail-view-grid .form-group label {
	    font-weight: 600;
	    color: #34495e; /* 라벨 색상 */
	    margin-bottom: 8px;
	    font-size: 0.95em;
	}

	.applicant-detail-view-grid .form-group p {
	    background-color: #f8faff; /* 내용 배경색 */
	    border: 1px solid #e0e5f0;
	    padding: 10px 15px;
	    border-radius: 5px;
	    color: #495057;
	    min-height: 40px; /* 최소 높이로 일관성 유지 */
	    display: flex; /* 내용을 세로 중앙 정렬하기 위해 flex 사용 */
	    align-items: center;
	    word-break: break-word; /* 긴 단어 줄바꿈 */
	    white-space: pre-wrap; /* 자기소개 등 텍스트 원본 줄바꿈 유지 */
	    line-height: 1.5; /* 줄 간격 */
	}

	.applicant-detail-view-grid .form-group.full-width {
	    grid-column: 1 / -1; /* 그리드 전체 너비 차지 */
	}

	/* --- 제출 서류 목록 스타일 --- */
	.submitted-files-list {
	    margin-top: 5px;
	    padding: 10px;
	    border: 1px dashed #b0c4de; /* 점선 테두리 */
	    border-radius: 5px;
	    background-color: #fefefe;
	    min-height: 60px; /* 파일이 없을 때도 적당한 높이 유지 */
	    display: flex;
	    flex-direction: column;
	    justify-content: center; /* 내용이 적을 때 가운데 정렬 */
	}

	.submitted-files-list p {
	    color: #888;
	    text-align: center;
	    font-style: italic;
	    margin-bottom: 0;
	    background: none; /* p태그에 불필요한 배경 제거 */
	    border: none;
	    padding: 0;
	}

	.submitted-files-list a {
	    color: #007bff;
	    text-decoration: none;
	    padding: 3px 0;
	    transition: color 0.2s ease;
	}

	.submitted-files-list a:hover {
	    color: #0056b3;
	    text-decoration: underline;
	}

	/* --- PDF 출력 영역 스타일 (모달 내부에 숨겨진 섹션) --- */
	#applicant-info-for-pdf {
	    font-family: 'Noto Sans KR', sans-serif !important;
	    padding: 25px;
	    background-color: #ffffff;
	    color: #333;
	    display: none; /* 기본적으로 숨김 처리 */
	}

	#applicant-info-for-pdf h2 {
	    font-size: 1.6em;
	    font-weight: 700;
	    color: #234aad;
	    margin-bottom: 20px;
	    text-align: center;
	    border-bottom: 2px solid #234aad;
	    padding-bottom: 10px;
	}

	#applicant-info-for-pdf table {
	    width: 100%;
	    border-collapse: collapse;
	    table-layout: fixed;
	    margin-bottom: 20px;
	}

	#applicant-info-for-pdf th,
	#applicant-info-for-pdf td {
	    padding: 10px 15px;
	    border: 1px solid #e0e0e0; /* 연한 테두리 */
	    vertical-align: top;
	    font-size: 0.9em; /* 폰트 크기 조정 */
	    line-height: 1.6;
	}

	/* PDF 테이블의 항목 컬럼 */
	#applicant-info-for-pdf table tbody tr td:first-child {
	    width: 120px; /* 고정 너비 */
	    min-width: 120px;
	    max-width: 120px;
	    font-weight: bold;
	    background-color: #f8faff; /* 배경색으로 구분 */
	    word-break: keep-all;
	    text-align: left;
	    color: #234aad;
	}

	/* PDF 테이블의 내용 컬럼 */
	#applicant-info-for-pdf table tbody tr td:last-child {
	    word-break: break-word;
	    text-align: left;
	    color: #495057;
	}

	#applicant-info-for-pdf p {
	    margin: 0;
	    padding: 0;
	}

</style>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DDTOWN - 오디션 지원자 정보</title>
    <%@ include file="../../../modules/headerPart.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="emp-container">
        <%@ include file="../../modules/header.jsp" %>
        <div class="emp-body-wrapper">
            <%@ include file="../../modules/aside.jsp" %>
            <main class="emp-content" style="font-size: small;">
            	<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					<ol class="breadcrumb">
					  <li class="breadcrumb-item"><a href="#" style="color:black;">오디션 관리</a></li>
					  <li class="breadcrumb-item active" aria-current="page">지원자 정보</li>
					</ol>
				</nav>
                <section id="applicant-info-section" class="am-section active-section">
                    <div class="am-section-header">
                        <div class="status-badges-container">
                        <h2>지원자 정보 조회</h2>
                        <%-- 2. 상태별 인원 수(뱃지) --%>
						    <form id="applicantFilterForm" method="get" action="/emp/audition/applicant" style="font-size: large;">
						    	<input type="hidden" name="page" value="1">
						    	<input type="hidden" name="badgeSearchType">
						    	<input type="hidden" name="audiNo" id="audiNo">
		                        <div class="status-badge all-applicants" data-status-code="" style="cursor: pointer;">
							        <span class="label">전체</span>
							        <span class="count">${totalApplicantCount}명</span>
							    </div>

					    	    <input type="hidden" name="auditionStatusCode" id="hiddenAuditionStatusCode">
   								<input type="hidden" name="searchType" id="hiddenSearchType">

						    	<c:forEach var="entry" items="${appStatCodeCnt}">
						    		<div class="status-badge status-${entry.key}" data-status-code="${entry.key}" style="cursor: pointer;">
						    			<span class="label">
						    				<c:choose>
						                        <c:when test="${entry.key eq 'APSC001'}">지원완료</c:when>
						                        <c:when test="${entry.key eq 'APSC002'}">합격</c:when>
						                        <c:when test="${entry.key eq 'APSC003'}">불합격</c:when>
						                    </c:choose>
						    			</span>
						    			 <span class="count">${entry.value}명</span>
						    		</div>
						    	</c:forEach>
						    </form>
                        </div>
                        <!-- 검색부분 -->
                        <div class="am-header-actions">
                        	<form method="get" id="searchForm"  action="/emp/audition/applicant">
                        		<input type="hidden" name="page" id="page"/>
                        		<input type="hidden" name="auditionStatusCode" id="auditionStatusCode" value="${auditionStatusCode}"/>
		                            <select id="searchType" name="searchType" class="am-filter-select" style="min-width: 550px;">
		                                <option value="all" <c:if test="${searchType eq 'all' or searchType eq null}"> selected</c:if>>오디션 선택</option>
		                               	<c:forEach var="audition" items="${auditionDropdownList}">
		                               		<option value="${audition.audiNo}"
		                               			<c:if test="${searchType ne 'all' and searchType == audition.audiNo}">selected</c:if>
		                               		>${audition.audiTitle}</option>
		                               	</c:forEach>
		                            </select>
		                            <input type="search" name="searchWord" id="searchWord" placeholder="지원자명" class="am-search-input" value="${searchWord }">
		                            <button type="submit" id="btn-search-applicant" class="am-btn"><i class="fas fa-search"></i> 검색</button>
<!-- 		                            <button type="button" id="resetSearchButton" class="ea-btn" style="width:70px; margin-left: 5px;">초기화</button> -->
		                            <input type="hidden" id="currentAudiNo" value="${audition.audiNo}">
	                        	</form>
	                        	<div class="audition-status-tabs">
					                <a href="#" class="audition-status-tab <c:if test="${auditionStatusCode eq 'all' or auditionStatusCode eq null}">active</c:if> aTab" data-status-code="all">
					                	전체 오디션(<c:out value="${totalAuditionCount}" default="0"/>) [예정<c:out value="${auditionStatCount.ADSC001}" default="0"/>건]
					                </a>

					                <a href="#" class="audition-status-tab <c:if test="${auditionStatusCode eq 'ADSC002'}">active</c:if> aTab" data-status-code="ADSC002">
					                	진행 중인 오디션(<c:out value="${auditionStatCount.ADSC002}" default="0"/>)
					                </a>
					                <a href="#" class="audition-status-tab <c:if test="${auditionStatusCode eq 'ADSC003'}">active</c:if> aTab" data-status-code="ADSC003">
					                	마감된 오디션(<c:out value="${auditionStatCount.ADSC003}" default="0"/>)
					                </a>
					            </div>
	                        </div>
	                    </div>
	                    <div class="am-section-content">
	                      <table class="am-table" id="applicant-table">
	                          <thead>
	                              <tr>
	                                  <th style="width:10%;">지원번호</th>
	                                  <th style="width:10%;">심사 결과</th>
	                                  <th style="width:10%;">이름</th>
	                                  <th>지원한 오디션</th>
	                                  <th style="width:7%;">지원분야</th>
	                                  <th style="width:12%;">제출일</th>
	                              </tr>
	                          </thead>
	                          <tbody id="applicant-table-body">
	                          	<c:forEach var="auditionUser" items="${AuditionUserList}">
					                <tr>
					                    <td>${auditionUser.applicantNo}</td>
					                    <td>
					                    	<span class="audition-status-badge
					                    		<c:choose>
										            <c:when test="${auditionUser.appStatCode eq 'APSC001'}">status-APSC001</c:when>
										            <c:when test="${auditionUser.appStatCode eq 'APSC002'}">status-APSC002</c:when>
										            <c:when test="${auditionUser.appStatCode eq 'APSC003'}">status-APSC003</c:when>
										        </c:choose>
					                    	">
						                    	<c:choose>
										            <c:when test="${auditionUser.appStatCode eq 'APSC001'}">지원완료</c:when>
										            <c:when test="${auditionUser.appStatCode eq 'APSC002'}">합격</c:when>
										            <c:when test="${auditionUser.appStatCode eq 'APSC003'}">불합격</c:when>
										        </c:choose>
									        </span>
					                    </td>
					                    <td><a href="#" class="applicant-name-link" data-toggle="modal" data-target="#modalDetail" data-app-no="${auditionUser.appNo}" style="cursor: pointer; text-decoration: none; color: inherit;">${auditionUser.applicantNm}</a></td>
					                    <td style="text-align: left;">${auditionUser.audition.audiTitle}</td>
					                    <td>
					                    	<c:choose>
							                    <c:when test="${auditionUser.audition.audiTypeCode eq 'ADTC001'}">보컬</c:when>
							                    <c:when test="${auditionUser.audition.audiTypeCode eq 'ADTC002'}">댄스</c:when>
							                    <c:when test="${auditionUser.audition.audiTypeCode eq 'ADTC003'}">연기</c:when>
							                </c:choose>
					                    </td>
					                    <td>
					                    <c:set value="${fn:split(auditionUser.appRegDate, ' ')}" var="appRegDate"/>
					                    		${appRegDate[0]}
					                    </td>
					                </tr>
					            </c:forEach>
	                          </tbody>
	                      </table>

	                      <div class="am-pagination" id="pagingArea">
	                          ${pagingVO.pagingHTML }
	                      </div>
	                      <div class="am-pagination" id="applicant-pagination"></div>
	                    </div>

	                </section>
	<!-- 지원자 상세/심사 모달 -->
	                <div class="modal fade" id="modalDetail">
	    				<div class="modal-dialog modal-lg">
	        				<div class="modal-content">
					            <div class="modal-header">
					                <h4 class="modal-title" id="modalDetailTitle">지원자 상세 정보 및 심사</h4>
					                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
					                    <span aria-hidden="true">&times;</span>
					                </button>
					            </div>
	            				<div class="modal-body">
				                	<div class="am-form-actions" style="margin-bottom: 20px;">
				                    	<button type="button" id="btn-approve-applicant" class="am-btn success">합격</button>
				                    	<button type="button" id="btn-reject-applicant" class="am-btn danger">불합격</button>
				                    	<button type="button" id="btn-download-applicant-pdf" class="am-btn primary"><i class="fas fa-file-pdf"></i> PDF로 다운로드</button>
				                	</div>

	               					<div class="am-form applicant-detail-view-grid" style="margin-bottom: 30px;">
					                    <div class="form-group">
					                        <label>지원 오디션</label>
					                        <p id="view-applicant-audition-name">-</p>
					                    </div>
					                    <div class="form-group">
					                        <label>지원번호</label>
					                        <p id="view-applicant-id">-</p>
					                    </div>
					                    <div class="form-group">
					                        <label>이름</label>
					                        <p id="view-applicant-name">-</p>
					                    </div>
					                    <div class="form-group">
					                        <label>생년월일</label>
					                        <p id="view-applicant-birthdate">-</p>
					                    </div>
					                    <div class="form-group">
					                        <label>연락처</label>
					                        <p id="view-applicant-contact">-</p>
					                    </div>
					                    <div class="form-group">
					                        <label>이메일</label>
					                        <p id="view-applicant-email">-</p>
					                    </div>
					                    <div class="form-group full-width">
					                        <label>지원 분야</label>
					                        <p id="view-applicant-field">-</p>
					                    </div>
					                    <div class="form-group full-width">
					                        <label>자기소개</label>
					                        <p id="view-applicant-self-introduction" style="white-space: pre-wrap;">-</p>
					                    </div>
					                    <div class="form-group full-width">
					                        <label>제출 서류 목록</label>
					                        <div id="view-applicant-submitted-files" class="submitted-files-list">
					                            <p>제출된 서류가 없습니다.</p>
					                        </div>
					                    </div>
					                     <div class="form-group">
					                        <label>심사 결과</label>
					                        <p id="view-applicant-status">-</p>
					                    </div>
	               					</div>
	<!-- pdf부분 -->
	                				<div id="applicant-info-for-pdf" style="padding: 20px; display: none;"> <h2>지원자 상세 정보</h2>
									<table>
			                        	<thead>
				                            <tr>
				                                <th style="width: 100px;" >항목</th>
				                                <th>내용</th>
				                            </tr>
			                        	</thead>
			                        	<tbody>
				                            <tr>
				                                <td>지원 오디션</td>
				                                <td id="pdf-applicant-audition-name"></td>
				                            </tr>
				                            <tr>
				                                <td>지원번호</td>
				                                <td id="pdf-applicant-id"></td>
				                            </tr>
				                            <tr>
				                                <td>지원자 이름</td>
				                                <td id="pdf-applicant-name"></td>
				                            </tr>
				                            <tr>
				                                <td>생년월일</td>
				                                <td id="pdf-applicant-birth"></td>
				                            </tr>
				                            <tr>
				                                <td>성별</td>
				                                <td id="pdf-applicant-gender"></td>
				                            </tr>
				                            <tr>
				                                <td>연락처</td>
				                                <td id="pdf-applicant-phone"></td>
				                            </tr>
				                            <tr>
				                                <td>이메일</td>
				                                <td id="pdf-applicant-email"></td>
				                            </tr>
				                            <tr>
				                                <td>지원 분야</td>
				                                <td id="pdf-applicant-field"></td>
				                            </tr>
				                            <tr>
				                                <td>자기소개서</td>
				                                <td id="pdf-app-cover-letter"></td>
				                            </tr>
				                            <tr>
				                                <td>첨부 파일</td>
				                                <td id="pdf-submitted-files"></td>
				                            </tr>
				                             <tr>
				                                <td>심사 결과</td>
				                                <td id="pdf-applicant-status"></td>
				                            </tr>
			                        	</tbody>
									</table>
								</div>
							</div>
							<div class="modal-footer justify-content-between">
								<button type="button" class="btn btn-default" data-dismiss="modal" id="closeBtn">닫기</button>
							</div>
						</div>
					</div>
				</div>
			</main>
		</div>
	</div>
<!-- /// 모달 끝 /// -->
</body>
<%@ include file="../../../modules/footerPart.jsp" %>

<%@ include file="../../../modules/sidebar.jsp" %>
<script>

// 검색 입력란에서 엔터 키를 눌렀을 때 폼 제출 방지
document.getElementById('searchWord').addEventListener('keypress', function(e) {
       if (e.key === 'Enter') {
           e.preventDefault(); // 기본 폼 제출 동작을 막음
           document.getElementById('btn-search-applicant').click(); // 검색 버튼을 수동으로 클릭하여 검색 함수 실행
       }
   });

$(function(){
	let pagingArea = $("#pagingArea");	//페이징 영역
	let applicantFilterForm = $("#applicantFilterForm");// 상태 뱃지 Form

	let currentApplicantAppNo = null;
	//합격여부 표시
	function getAppStatusText(statusCode) {
	    if (!statusCode) {
	        return '-'; // 코드가 없으면 하이픈 반환
	    }

	    switch (statusCode) {
	        case 'APSC002':
	            return '합격';
	        case 'APSC003':
	            return '불합격';
	        case 'APSC001':
	            return '지원 완료';
	        default:
	            return '알 수 없음'; // 정의되지 않은 코드가 들어올 경우
	    }
	}
	 //지원분야 상태
	function getTypeCodeText(typeCode) {
	    if (!typeCode) {
	        return '-'; // 값이 없거나 유효하지 않으면 하이픈 반환
	    }
	    switch (typeCode) {
	        case 'ADTC001':
	            return '보컬';
	        case 'ADTC002':
	            return '댄스';
	        case 'ADTC003':
	            return '연기';
	        default:
	            return '알 수 없음'; // 정의되지 않은 코드가 들어올 경우
	    }
	}
	//날짜 출력 형태
	function formatBirthdate(dateTimeString) {
	    if (!dateTimeString) {
	        return '-'; // 값이 없거나 유효하지 않으면 하이픈 반환
	    }

	    // "YYYY-MM-DD HH:MM:SS" 형식의 문자열에서 날짜 부분만 추출
	    const datePart = dateTimeString.split(' ')[0]; // 예: '2025-03-12'

	    return datePart;
	}

	// 페이지네이션 로직
	$(document).on('click', '.page-link', function(e) {

        e.preventDefault(); // 기본 링크 동작(href="#") 방지

        var page = $(this).data('page'); // data-page 속성 값 가져오기

        if (page) { // page 값이 유효한 경우에만 실행
            $('#page').val(page); // hidden input #page의 값을 설정
            $('#searchForm').submit(); // 검색 폼 제출
        }
	});

// 	//초기화버튼 이벤트
// 	$('#resetSearchButton').on('click', function() {
//         // 검색 필드 값 초기화
//         $('#searchType').val('all');   // 신고 유형 '전체 유형'으로
//         $('#searchCode').val('all');   // 처리 상태 '전체 상태'로
//         $('#searchWord').val(''); // 검색어 입력 필드 비움
//         $('#page').val(1);             // 페이지를 1페이지로 초기화
//         $("#auditionStatusCode").val("all");
//         // 폼 제출
//          $("#searchForm").submit();
//         //fn_list(audiNo, page);
//     });//end resetSearchButton


	/* 탭 클릭 이벤트 */
	$(".aTab").on("click", function(e) {
		e.preventDefault();

		let statusCode = $(this).data("statusCode");	//선택한 값

		$(".audition-status-tab").removeClass("active"); //기존 선택 비활성화하고 선택한 탭 활성화
		$(this).addClass("active");

		$("#auditionStatusCode").val(statusCode);
		$('#searchType').val('all');   // 신고 유형 '전체 유형'으로
//		$('#searchCode').val('all');   // 처리 상태 '전체 상태'로
		$('#searchWord').val(''); // 검색어 입력 필드 비움
		$("#page").val("1");

		$("#searchForm").submit();
	});//end aTab->click

	/* 상태별 뱃지 클릭 이벤트 */
	$(".status-badges-container .status-badge").on("click", function(){
		const statusCode = $(this).data("status-code");

		applicantFilterForm.find("input[name='badgeSearchType']").val(statusCode); // 값 설정

		$('#hiddenAuditionStatusCode').val($('#auditionStatusCode').val());
		$('#hiddenSearchType').val($('#searchType').val());

//		$('#searchCode').val('all');
		$('#searchWord').val('');
		$('#page').val(1);

		applicantFilterForm.submit();
	});//end status-badge


	// 지원자 상세/심사/다운로드 모달 등
	const detailModal = document.querySelector('.applicant-detail-view-grid');

	// 이전에 연결된 이벤트 리스너가 있다면 제거하여 중복 호출 방지
	$("#applicant-table-body").off('click', '.applicant-name-link');
	$("#applicant-table-body").on('click', '.applicant-name-link', function() {
		const appNo = $(this).data('appNo'); // data-app-no 속성 값 가져오기

	 	currentApplicantAppNo = appNo;	//현재 지원자 번호 저장

        $.ajax({
            url: "/api/emp/audition/applicant/detail?appNo="+appNo,
            type: "get",
            success: function(res) {

                if (res) {
                    // 모달 내 각 요소에 데이터 채우기
                    document.getElementById('view-applicant-audition-name').innerText = res.audition.audiTitle || '-'; // 오디션명
                    document.getElementById('view-applicant-id').innerText = res.applicantNo || '-';
                    document.getElementById('view-applicant-name').innerText = res.applicantNm || '-';
                    document.getElementById('view-applicant-birthdate').innerText = res.applicantBirth || '-'; // 예: "YYYY-MM-DD" 형식
                    document.getElementById('view-applicant-contact').innerText = res.applicantPhone || '-';
                    document.getElementById('view-applicant-email').innerText = res.applicantEmail || '-';
                    document.getElementById('view-applicant-field').innerText = getTypeCodeText(res.audition.audiTypeCode);
                    document.getElementById('view-applicant-self-introduction').innerText = res.appCoverLetter || '-';

                    const statusElement = document.getElementById('view-applicant-status');
                    if (statusElement) {
                        const statusText = getAppStatusText(res.appStatCode); // 상태 코드를 텍스트로 변환
                        statusElement.innerText = statusText;
                        // 상태에 따른 색상/스타일 적용 (여기서 모달 내 상태 표시를 위해 상태 코드에 따라 스타일을 변경합니다)
                        if (res.appStatCode === 'APSC003') { // 합격
                            statusElement.style.color = 'red';
                            statusElement.style.fontWeight = 'bold';
                        } else if (res.appStatCode === 'APSC004') { // 불합격
                            statusElement.style.color = 'red';
                            statusElement.style.fontWeight = 'bold';
                        } else { // 기타 (심사 중, 접수 완료 등)
                            statusElement.style.color = 'black'; // 기본 색상
                            statusElement.style.fontWeight = 'normal';
                        }
                    }

                    // 제출 서류관련 다운로드 부분
                    const submittedFilesContainer = document.getElementById('view-applicant-submitted-files');
                    if (res.fileList && res.fileList.length > 0) {
                        let filesHtml = ``;
                        res.audition.fileList.forEach(file => {
                            const tempDiv = document.createElement('div');
                            tempDiv.innerHTML = file.fileOriginalNm;
                            const decodedFileName = tempDiv.textContent || tempDiv.innerText;
                            const fileAttachDetailNo = file.attachDetailNo;
                            const downloadUrl = `/corporate/Audition/download.do?attachDetailNo=\${fileAttachDetailNo}`;
                            filesHtml += `<div class="file-item">
                                <a href="\${downloadUrl}" class="attachment-link" target="_blank" download>
                                    \${decodedFileName}
                                </a>
                            </div>`;
                        });
                        submittedFilesContainer.innerHTML = filesHtml;
                    } else {
                        submittedFilesContainer.innerHTML = `<p>제출된 서류가 없습니다.</p>`;
                    }

                 	// PDF용 HTML 테이블에 데이터 채우는 코드
                    document.getElementById('pdf-applicant-audition-name').innerText = res.audition.audiTitle || '';
                    document.getElementById('pdf-applicant-id').innerText = res.appNo || '';
                    document.getElementById('pdf-applicant-name').innerText = res.applicantNm || '';
                    document.getElementById('pdf-applicant-birth').innerText = res.applicantBirth || '';
                    document.getElementById('pdf-applicant-gender').innerText = res.applicantGender || '';
                    document.getElementById('pdf-applicant-phone').innerText = res.applicantPhone || '';
                    document.getElementById('pdf-applicant-email').innerText = res.applicantEmail || '';
                    document.getElementById('pdf-applicant-field').innerText = getTypeCodeText(res.audition.audiTypeCode);
                    document.getElementById('pdf-app-cover-letter').innerText = res.appCoverLetter || '';

                    // 파일 PDF
                    document.getElementById('pdf-submitted-files').innerHTML = submittedFilesContainer.innerHTML;

                    document.getElementById("modalDetail").classList.add("show");
                    document.getElementById("modalDetail").style.display = "block";
                    document.getElementById("modalDetail").setAttribute("aria-modal", "true");
                    document.getElementById("modalDetail").setAttribute("role", "dialog");

                    // PDF 다운로드 버튼 클릭 이벤트
                    // 이 리스너는 AJAX 성공 시 매번 다시 등록되므로, 기존 onclick을 덮어쓰는 방식을 사용하겠습니다.
                    // 이렇게 하면 모달이 열릴 때마다 최신 데이터로 PDF가 생성됩니다.
                    const downloadBtn = document.getElementById('btn-download-applicant-pdf');
                    // 기존에 다른 이벤트 리스너가 addEventListener로 추가되어 있다면, off를 사용해야 합니다.
                    // 여기서는 안전하게 이전 onclick 함수를 덮어씁니다.
                    downloadBtn.onclick = function() {
                        const element = document.getElementById('applicant-info-for-pdf'); // PDF로 만들 HTML 요소 지정
                     	// PDF 생성 직전: 요소를 보이게 합니다.
                        element.style.display = 'block';
                        const opt = {
                        	    margin:       1,
                        	    filename:     res.applicantNm + '_지원자정보.pdf',
                        	    image:        { type: 'jpeg', quality: 0.98 },
                        	    html2canvas:  {
                        	        scale: 2,
                        	        logging: true,
                        	        dpi: 192,
                        	        letterRendering: true,
                        	        useCORS: true,
                        	        allowTaint: true
                        	    },
                        	    jsPDF:        {
                        	        unit: 'in',
                        	        format: 'letter',
                        	        orientation: 'portrait',
                        	        compress: false
                        	    }
                        	};

                        html2pdf().set(opt).from(element).save().then(function() {
                            // PDF 생성 완료 후: 요소를 다시 숨깁니다.
                            element.style.display = 'none';
                        }).catch(function(error) {
                            console.error("PDF 생성 중 오류 발생:", error);
                            // 오류 발생 시에도 요소를 다시 숨겨야 합니다.
                            element.style.display = 'none';
                            alert("PDF 다운로드에 실패했습니다. 콘솔을 확인해 주세요.");
                        });
                    };

                } else {
                    alert("지원자 상세 정보를 찾을 수 없습니다.");
                }
            },
            error: function(xhr, status, error) {
                console.error("지원자 상세 정보 불러오기 실패:", status, error);
                alert("지원자 상세 정보를 불러오는 데 실패했습니다.");
            }
        });
    });//end applicant-name-link
	// 이름/상세보기 버튼 클릭 시 상세 모달 오픈 및 심사 기능
	async function customConfirm(message) {
    	const result = await Swal.fire({
	        title: '확인',
	        text: message,
	        icon: 'question',
	        showCancelButton: true,
	        confirmButtonColor: '#3085d6',
	        cancelButtonColor: '#d33',
	        confirmButtonText: '예',
	        cancelButtonText: '아니오'
    	});
    	return result.isConfirmed;
	}

    // --- SweetAlert2를 사용하도록 customAlert 함수 수정 ---
    async function customAlert(message, type = 'success', title = '알림') {
        await Swal.fire({
            title: title,
            text: message,
            icon: type,
            confirmButtonColor: '#3085d6',
            confirmButtonText: '확인'
        });
    }
	// 합격/불합격 버튼 처리
	const btnApprove = document.getElementById('btn-approve-applicant');
	const btnReject = document.getElementById('btn-reject-applicant');


	btnApprove.addEventListener('click', async function(){
       if(currentApplicantAppNo){
           const newStatusCode = 'APSC002';
           const confirmed = await customConfirm("합격으로 처리하고 메시지를 보내겠습니까?");
           if (!confirmed) {
               return;
           }

           const applicantEmail = document.getElementById('view-applicant-email').innerText;
           const applicantNm = document.getElementById('view-applicant-name').innerText;

           let data = {
   				appNo : currentApplicantAppNo,
   				appStatCode : newStatusCode,
   				applicantEmail : applicantEmail,
   				applicantNm : applicantNm
   			}

           $.ajax({
      		 url : "/api/emp/audition/StauesUpdate",
      		type: "post",
      		data : JSON.stringify(data),
      		contentType: "application/json; charset=utf-8",
      		beforeSend : function(xhr) {
		        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
		    },
      		success : async function(res){
      			if (res.Status == "SUCCESS") {
      				await customAlert("성공적으로 처리되었습니다.")

      				const applicantStatusSpan = document.getElementById('view-applicant-status');
                    if (applicantStatusSpan) {
                        applicantStatusSpan.innerText = '합격';
                        applicantStatusSpan.classList.remove('text-gray-900', 'font-semibold');
                        applicantStatusSpan.classList.add('text-green-600', 'font-bold'); // 시각적 강조
                    }
                    //중요: 메인 테이블 행 업데이트
                    const $rowToUpdate = $(`#applicant-table-body tr`).filter(function() {
                        // 현재 지원자의 appNo와 일치하는 행 찾기
                        return $(this).find('a.applicant-name-link').data('app-no') === currentApplicantAppNo;
                    });

                    if ($rowToUpdate.length > 0) {
                        const $statusBadge = $rowToUpdate.find('.audition-status-badge');
                        $statusBadge.text('합격');
                        // 기존 상태 클래스 제거 후 새로운 상태 클래스 추가
                        $statusBadge.removeClass('status-APSC001 status-APSC003').addClass('status-APSC002');
                    }
      				//이메일 전송결과 알림창
      				if (res.emailStatus === "SENT") {
      					await customAlert(res.emailMessage || "이메일이 성공적으로 전송되었습니다.");
                    } else if (res.emailStatus === "FAILED_EMAIL_SEND") {
                    	await customAlert("이메일 전송에 실패했습니다: " + (res.emailMessage || "알 수 없는 오류"));
                    }
      				//다시 띄우기
      				const currentAudiNo = document.getElementById('searchType').value;
                    if (currentAudiNo) {
                    	 document.getElementById('searchType').dispatchEvent(new Event('change'));
                    }

                } else { // 서버에서 Status가 'FAILED' 또는 'ERROR'인 경우
                	await customAlert("처리 실패: " + (res.message || "알 수 없는 오류"));
      			}
      		}
      	 })
       }//end if
   }) //end btnApprove

     //불합격 버튼
	if (btnReject) {
   	    btnReject.addEventListener('click', async function(){
   	        if(currentApplicantAppNo){
   	        	const newStatusCode = 'APSC003'; // 불합격 코드
	   	        const confirmed = await customConfirm("불합격으로 처리하고 이메일을 보내겠습니까?");

	            if (!confirmed) {
	                return;
	            }

   	            const applicantEmail = document.getElementById('view-applicant-email').innerText;
   	            const applicantNm = document.getElementById('view-applicant-name').innerText;

   	            let data = {
   	                appNo : currentApplicantAppNo,
   	                appStatCode : newStatusCode,
   	                applicantEmail : applicantEmail,
   	                applicantNm : applicantNm
   	            };

   	            $.ajax({
   	                url : "/api/emp/audition/StauesUpdate2",
   	                type: "post",
   	                data : JSON.stringify(data),
   	                contentType: "application/json; charset=utf-8",
   	                beforeSend : function(xhr) {
   	                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
   	                },
   	                success : async function(res){
   	                    if (res.Status == "SUCCESS") {
   	                    	await customAlert(res.message || "성공적으로 처리되었습니다.");

   	                     // 모달 내 상태 업데이트: 불합격
                            const applicantStatusSpan = document.getElementById('view-applicant-status');
                            if (applicantStatusSpan) {
                                applicantStatusSpan.innerText = '불합격';
                                applicantStatusSpan.classList.remove('text-gray-900', 'font-semibold');
                                applicantStatusSpan.classList.add('text-red-600', 'font-bold'); // 시각적 강조
                            }

   	                        // 모달 상세 정보 새로고침
   	                        if (currentApplicantAppNo) {
   	                           $("#applicant-table-body").find(`.detail-btn[data-app-no="${currentApplicantAppNo}"]`).click();
   	                        }
	   	                     const $rowToUpdate = $(`#applicant-table-body tr`).filter(function() {
	                             // 현재 지원자의 appNo와 일치하는 행 찾기
	                             return $(this).find('a.applicant-name-link').data('app-no') === currentApplicantAppNo;
	                         });

                         if ($rowToUpdate.length > 0) {
                             const $statusBadge = $rowToUpdate.find('.audition-status-badge');
                             $statusBadge.text('불합격');
                             // 기존 상태 클래스 제거 후 새로운 상태 클래스 추가
                             $statusBadge.removeClass('status-APSC001 status-APSC002').addClass('status-APSC003');
                         }
   	                        // 이메일 전송 결과 알림
   	                        if (res.emailStatus === "SENT") {
   	                        	await customAlert(res.emailMessage || "이메일이 성공적으로 전송되었습니다.");
   	                        } else if (res.emailStatus === "FAILED_EMAIL_SEND") {
   	                        	await customAlert("이메일 전송에 실패했습니다: " + (res.emailMessage || "알 수 없는 오류"));
   	                        }

   	                        // 지원자 목록 테이블 새로고침
   	                        const currentAudiNo = document.getElementById('searchType').value;
   	                        if (currentAudiNo) {
   	                            document.getElementById('searchType').dispatchEvent(new Event('change'));
   	                        }

   	                    } else {
   	                    	await customAlert("처리 실패: " + (res.message || "알 수 없는 오류"));
   	                    }
   	                },
   	                error: async function(xhr, status, error) {
   	                    console.error("불합격 처리 AJAX 요청 실패:", status, error, xhr.responseText);
   	                 await customAlert("불합격 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
   	                }
   	            });
   	        } else {
   	        	await customAlert("상태를 변경할 지원자가 선택되지 않았습니다.");
   	        }
   	    });//end btnReject
   	}//end if

	//모달창 닫기 버튼 이벤트
  	//닫기 버튼 클릭시
    $('#closeBtn').on('click', function() {
        $('#modalDetail').modal('hide');
    });
	//X버튼 클릭시
    $('#modalDetail .close').on('click', function() {
        $('#modalDetail').modal('hide');
    });
});//end 달러function
</script>
</html>