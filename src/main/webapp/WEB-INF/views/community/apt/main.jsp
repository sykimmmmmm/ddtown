<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>APT</title>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor-viewer.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/mainservice_common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/artist_community.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<script src='https://cdn.jsdelivr.net/npm/fullcalendar-scheduler@6.1.17/index.global.min.js'></script>
<%@ include file="../../modules/headerPart.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pages/communityModal.css">

<style>
body{
	background: linear-gradient(135deg, #1a1a2e 0%, #2a1e4a 50%, #8a2be2 100%); /* 중간색을 약간 더 보라색 계열로 조정 */
    background-attachment: fixed; /* 배경을 뷰포트에 고정 */
    background-size: cover; /* 배경이 전체 영역을 커버하도록 */
    min-height: 100vh;
    margin: 0;
    font-family: "Noto Sans KR", 돋움, Dotum, 굴림, Gulim, Tahoma, Verdana, sans-serif;
    color: #ffffff;
    overflow-x: hidden;
}
.apt-main-layout {
    display: flex;
    max-width: none; /* 아티스트 그리드 max-width에 맞춰 조정 */
    margin: 30px auto; /* 중앙 정렬 */
    gap: 25px; /* 요소 간 간격 유지 */
    padding: 0 20px; /* 내부 패딩 유지 */
    justify-content: center; /* 자식 요소들을 가로 중앙으로 정렬 */
    align-items: flex-start; /* 세로 정렬 상단으로 설정 */
    font-size: large;
}
.main-header {
    background: rgba(230, 179, 255, 0.08); /* 연보라 느낌의 투명한 배경 */
    backdrop-filter: blur(20px); /* 블러 강도 증가 */
    border-bottom: 1px solid rgba(255, 255, 255, 0.15); /* 테두리 연하게 */
    box-shadow: 0 4px 25px rgba(0, 0, 0, 0.4); /* 그림자 진하게 */
    position: sticky;
    top: 0;
    z-index: 1000;
    height: 150px;
    border-radius: 0 0 25px 25px; /* 모서리 더 둥글게 */
    transition: all 0.3s ease;
}
.apt-header {
    /* 기존 스타일 재정의 또는 제거 */
    background: rgba(255, 255, 255, 0.08); /* 연보라 느낌의 투명한 배경 */
    backdrop-filter: blur(15px); /* 블러 강도 증가로 깊이감 강조 */
    border: 1px solid rgba(255, 255, 255, 0.2); /* 은은하고 고급스러운 테두리 */
    border-radius: 18px; /* 더 둥근 모서리 */
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.4); /* 더욱 강하고 넓은 그림자로 입체감 */
    padding: 25px 30px; /* 패딩 증가로 여유 공간 확보 */
    display: flex;
    align-items: center;
    gap: 25px; /* 요소 간 간격 증가 */
    margin-bottom: 25px; /* 하단 마진 증가 */
    transition: all 0.4s ease; /* 부드러운 전환 효과 */
    position: relative; /* 의사 요소의 기준점 */
    overflow: hidden; /* 배경 애니메이션이 밖으로 나가지 않도록 */
}
.apt-header:hover {
    box-shadow: 0 12px 45px rgba(138, 43, 226, 0.5); /* 호버 시 그림자 강조 및 색상 변화 */
    transform: translateY(-5px); /* 살짝 위로 떠오르는 효과 */
    border-color: rgba(138, 43, 226, 0.4); /* 호버 시 테두리 색상 변화 */
}
.apt-header h2,
.apt-header .artist-stats {
    color: #ffffff; /* 내부 텍스트를 흰색으로 변경 */
    text-shadow: 0 1px 4px rgba(0, 0, 0, 0.2); /* 텍스트 그림자 추가 */
}
.apt-header h2 img {
    width: 25px;
    height: 25px;
    vertical-align: middle; /* 텍스트와 이미지 정렬 */
}
.apt-header::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle at 50% 50%, rgba(255, 255, 255, 0.1), transparent);
    transform: rotate(45deg);
    opacity: 0.8;
    transition: all 0.8s ease;
    z-index: 1; /* 콘텐츠보다 뒤에 오도록 */
    pointer-events: none; /* 클릭 이벤트 방지 */
}
.apt-header:hover::before {
    transform: rotate(0deg);
    opacity: 1;
    background: radial-gradient(circle at 50% 50%, rgba(255, 255, 255, 0.2), transparent);
}
.apt-header > div {
    position: relative; /* 콘텐츠가 의사 요소 위에 오도록 z-index 부여 기준점 */
    z-index: 2;
}
.apt-header-actions .btn-apt-action {
    background: linear-gradient(45deg, #8a2be2, #da70d6); /* 그라데이션 버튼 */
    color: #ffffff;
    border: none;
    border-radius: 25px;
    padding: 10px 20px;
    font-weight: 600;
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    transition: all 0.3s ease;
}
.apt-header-actions .btn-apt-action:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(138, 43, 226, 0.4);
    background: linear-gradient(45deg, #da70d6, #8a2be2);
}
.apt-header-actions .btn-apt-action.following {
    background: rgba(255, 255, 255, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.4);
    color: #fff;
    box-shadow: none;
}
.apt-header-actions .btn-apt-action.following:hover {
    background: rgba(255, 255, 255, 0.3);
    transform: translateY(0);
    box-shadow: none;
}
.membership-blur {
    filter: blur(5px);
    pointer-events: none;
}
.membership-only {
    position: relative;
}
.membership-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 255, 255, 0.9);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 2;
}
.membership-badge {
    background: #8a2be2;
    color: #fff;
    padding: 2px 6px;
    border-radius: 10px;
    font-size: 0.8em;
    margin-left: 5px;
}
div#imgArea {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}
.imgDiv{
	position: relative;
    width: 300px;
    /* height: auto; */
    border: 1px solid #ddd;
    padding: 10px;
    box-sizing: border-box;
}
.imgDiv img{
	width: 100%;
    height: auto;
    display: block;
}
.imgDiv i{
	position: absolute;
    top: -15%;
    right: 10%;
    color: white;
}
button#imgDeleteBtn {
    background-color: black;
    position: absolute;
    top: 15px;
    left: 260px;
    height: 20px;
    width: 10px;
    padding: 10px;
    border-radius: 50%;
    z-index: 10;
}
.replyWriterInfo {
    display: flex;
    align-items: center;
    gap: 10px;
}
.artist-avatar-placeholder {
    /* 1. 컨테이너 기본 스타일 설정 */
    width: 60px; /* 원하는 크기로 조절하세요 */
    height: 60px; /* width와 동일한 값으로 설정 */
    position: relative; /* 자식 요소의 기준점이 됨 */

    /* 2. 원형으로 만들기 */
    border-radius: 50%;

    /* 3. 내부 이미지가 원을 벗어나지 않도록 설정 */
    overflow: hidden;

    /* 이미지가 로드되기 전이나 없을 때를 위한 배경색 (선택 사항) */
    background-color: #f0f0f0;
}
.artist-avatar-placeholder img {
    /* 4. 이미지가 컨테이너를 꽉 채우도록 설정 */
    width: 100%;
    height: 100%;

    /* 5. 이미지 비율을 유지하면서 잘리지 않도록 채우기 (가장 중요한 속성) */
    object-fit: cover;
}
.modal-header h2 {
    width: 100%; /* h2가 modal-header의 전체 너비를 차지하도록 강제하여 p가 다음 줄로 내려가게 함 */
    /* 필요에 따라 마진 조정 */
    margin-bottom: 5px; /* h2와 p 사이 간격 추가 */
}
.modal-header p.membership-duration {
	width: 100%;
    display: block; /* p 태그가 새로운 줄에서 시작하도록 함 */
    margin-top: 5px; /* 선택 사항: 제목과 기간 사이에 약간의 간격 추가 */
}
.modal-header {
    flex-direction: column; /* Flex 아이템들을 수직 방향으로 정렬 (h2, p 순서대로 세로 배치) */
    align-items: center; /* 가운데 정렬 */
    text-align: center; /* 텍스트 가운데 정렬 */
}
.feed-item-header {
    display: flex;
    align-items: center;
    margin-bottom: 15px; /* 하단 마진 증가 */
    border-bottom: 1px solid rgba(255, 255, 255, 0.2); /* 투명하고 은은한 구분선 */
    padding-bottom: 15px; /* 패딩도 증가하여 여백 확보 */
    font-size: medium;
}
.postProfile {
	text-decoration : none;
    display: flex;
    align-items: center;
}
.feed-item:hover {
    box-shadow: 0 10px 30px rgba(138, 43, 226, 0.4); /* 마우스 오버 시 보라색 계열로 더 크고 진한 그림자 */
    transform: translateY(-5px); /* 살짝 위로 떠오르는 효과 */
    border-color: rgba(138, 43, 226, 0.5); /* 호버 시 테두리 색상 강조 */
}
.feed-item {
    background: rgba(255, 255, 255, 0.08); /* 연한 투명 배경 */
    backdrop-filter: blur(10px); /* 배경 블러 효과 추가 */
    border-radius: 15px; /* 더 둥근 모서리로 부드러운 느낌 */
    margin-bottom: 20px; /* 아이템 간 간격 약간 증가 */
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.25); /* 깊이감 있는 그림자 */
    border: 1px solid rgba(255, 255, 255, 0.15); /* 은은한 테두리 */
    padding: 20px; /* 패딩을 약간 늘려 콘텐츠 여유 공간 확보 */
    transition: all 0.3s ease; /* 모든 전환에 부드러운 효과 */
    overflow: hidden; /* 내부 요소가 넘치지 않도록 */
    position: relative;
    z-index: 1;
}
.feed-item-header .author-name,
.feed-item-content .post-text,
.feed-item-actions .action-btn {
    color: #ffffff !important; /* 내부 텍스트를 흰색으로 변경 (블러 배경과 잘 어울리도록) */
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2); /* 텍스트 그림자 추가 */
}

.feed-item-header .author-info .post-time,
.feed-item-actions .action-btn i {
    color: rgba(255, 255, 255, 0.7); /* 보조 텍스트는 약간 투명한 흰색 */
}

.feed-item-actions .action-btn:hover {
    color: #fff; /* 호버 시 완전 흰색 */
}
div#openModal {
    background: rgba(255, 255, 255, 0.15); /* 연한 투명 배경 */
    backdrop-filter: blur(10px); /* 배경 블러 효과 */
    border: 1px solid rgba(255, 255, 255, 0.3); /* 은은한 흰색 테두리 */
    border-radius: 15px; /* 더 둥근 모서리 */
    padding: 20px 25px;
    margin-bottom: 15px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.35);
    transition: all 0.4s ease;
    overflow: hidden;
    color: white;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
}
div#openModal:hover{
	box-shadow: 0 15px 45px rgba(138, 43, 226, 0.6), 0 0 20px rgba(255, 255, 255, 0.4) inset;
    transform: translateY(-5px); /* 살짝 떠오르는 효과 유지 */
    border-color: rgba(138, 43, 226, 0.7);
    background: rgba(255, 255, 255, 0.2);
}
.artistPostInserBtn{
	background: none;
    border: none;
    padding: 0;
    width: 100%;
    text-align: left;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 10px;
    color: white;
}
.placeholder-text {
    color: white;
    font-size: 1em;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.4); /* 가독성 위한 그림자 */
}
.feed-item-actions {
    display: flex;
    padding-top: 10px;
    border-top: 1px solid #f0f0f0;
    margin-top: 15px;
    align-items: baseline;
}
button#postListLike {
    color: #fd6083;
}
span#likeCount {
    margin-left: 5px;
    font-style: normal;
}
textarea#comuPostContent {
    width: 100%;
    height: 200px;
    border-radius: 8px;
    font-size: 15px;
    resize: none;
}
label.checkbox-label {
    border: 1px solid;
    width: 100px;
    height: 30px;
    align-content: center;
    text-align: center;
    border-radius: 15px;
    cursor: pointer;
    margin-bottom: 10px;
    transition: 0.8s;
}
label.checkbox-label:hover {
    box-shadow: 0px 0px 20px;
    transform: scale(1.1);
    background-color: #6a0dad;
    color: white;
}
.inserPostCheckbox input[type=checkbox]:checked + label.checkbox-label{
	background-color : #6a0dad;
	color: white;
}
.inserPostCheckbox {
    justify-items: center;
}
input#fileName {
    height: 40px;
    width: 530px;
    padding: 12px;
    cursor: initial;
}
label.file-label {
    border: 1px solid rgba(255, 255, 255, 0.5);
    border-radius: 10px;
    width: 80px;
    height: 40px;
    align-content: center;
    text-align: center;
    background: linear-gradient(45deg, rgba(138, 43, 226, 0.45), rgba(218, 112, 214, 0.7)); /* 투명도를 더 낮춰 훨씬 진하게 */
    backdrop-filter: blur(10px);
    color: white; /* 텍스트 색상을 흰색으로 */
    font-weight: bold; /* 텍스트를 좀 더 두껍게 */
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5); /* 텍스트 그림자 추가 */
    cursor: pointer;
    transition: all 0.3s ease;
}
label.file-label:hover {
    background: linear-gradient(45deg, rgba(138, 43, 226, 0.45), rgba(218, 112, 214, 0.9)); /* 호버 시 더 불투명하고 진하게 */
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4); /* 그림자도 더 진하게 */
    transform: translateY(-2px); /* 살짝 더 위로 떠오르는 효과 */
}
input#insertPostFile {
    display: none;
}
.file-wrap {
    display: flex;
    gap: 2px;
    margin-top: 30px;
    justify-content: right;
}
.detailImgContainer {
	margin-top: 10px;
}
.detailImg {
    width: 800px;
    height: auto;
    margin-top: 10px;
    margin-bottom: 15px;
}
.detailImg img{
	width : 90%;
	border-radius: 10px;
}
textarea#editComuPostContent {
    width: 100%;
    height: 200px;
    border-radius: 8px;
    font-size: 15px;
    resize: none;
}
.notice-container {
	border: 1px solid aliceblue;
    height: 80px;
    padding-top: 10px;
    padding-left: 20px;
    margin-bottom: 10px;
    background-color: white;
    padding-right: 20px;
    border-radius: 10px;
    padding-bottom: 90px;
    transition: transform 0.3s ease;
}
.notice-container:hover{
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    transform: translateY(-5px);
}
.noticeTitle-container {
    display: flex;
    justify-content: space-between;
    margin-top: 10px;
    font-size: 20px;
    margin-bottom: 20px;
}
span.noticeTitle {
    color: black;
    font-size: 14px;
    max-width: 250pt;
}
.noticeDate {
    font-size: 12px;
    color: #7f9097;
}
@keyframes heartbeat{
	0% {transform: scale(1);}
	25% {transform: scale(1.2);}
	50% {transform: scale(1);}
	75% {transform: scale(1.2);}
	100% {transform: scale(1);}
}
.newNotice {
    animation: heartbeat 1s ease-in-out infinite;
    color: #ff0000ab;
}

.notice-container b {
    display: flex;
    gap: 5px;
}
.noSearchPostList {
    border: 1px solid aliceblue;
    background-color: white;
    background-color: #fff;
    border-radius: 8px;
    margin-bottom: 15px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    padding: 15px;
    transition: transform 0.3s ease;
    color: #ff0000ad;
}
.noSearchPostList:hover {
	box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.2);
    transform: translateY(-2px);
}
.noticeList-container {
    margin-bottom: 10pt;
}
.carousel-item-title {
    max-width: 100%;
    border-bottom: 1px solid aliceblue;
    margin-bottom: 10pt;
    padding-bottom: 5pt;
    color: black;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    font-weight: 600;
}
.author-avatar {
    width: 50px; /* 원하는 크기 */
    height: 50px; /* width와 동일하게 설정 */
    border-radius: 50%; /* 원형으로 만듦 */
    overflow: hidden; /* 넘치는 부분 숨김 */
    /* 기존 스타일 유지 */
    background-color: #8a2be2;
    color: #fff;
    display: flex; /* 이미지를 중앙에 배치하기 위함 */
    align-items: center;
    justify-content: center;
}
.author-avatar img {
    width: 100%;
    height: 100%;
    object-fit: cover; /* 이미지 비율 유지하며 채움 */
}
form#replyForm {
    gap: 10pt;
}
#calendar {
    font-family: 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; /* 기존 유지 (한글 폰트는 body 또는 global에 정의된 것을 따름) */
    background-color: #ffffff;
    border-radius: 8px; /* 멤버십 카드, 차트 박스와 유사한 둥근 모서리 */
    padding: 20px; /* 내부 여백 */
    box-shadow: 0 2px 8px rgba(0,0,0,0.05); /* 멤버십 카드, 차트 박스와 유사한 그림자 */
}
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
.fc-col-header-cell-cushion {
    color: #6c757d; /* 부트스트랩 secondary 텍스트 색상과 유사 */
    font-weight: 600;
    padding: 10px 0;
}
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
.fc-event-time{
	display : none;
}
.fc-event-title{
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
	word-break: break-all;
}
body .tooltip.bs-tooltip-auto{
	max-width : 320px;
	width : 320px;
}
body .tooltip-inner{
	max-width : 300px;
	width : 300px;
}
/* 툴팁 (popper.js 관련) - 기존 스타일 유지하면서 크기 조정 */
.popper,
.tooltip {
  position: absolute;
  z-index: 9999;
  background: #343a40; /* 어두운 배경 (부트스트랩 dark 색상) */
  color: #FFFFFF;
  width: auto; /* 내용에 따라 너비 자동 조절 */
  max-width: 200px; /* 최대 너비 설정 */
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
.fc-toolbar-title {
    font-size: 1.8em;
    font-weight: 700;
    color: #343a40; /* 어두운 텍스트 색상 */
    line-height: 1.2;
}
.fc-daygrid-day-number {
    padding: 4px 6px;
    font-size: 0.9em;
    color: #495057; /* 기본 날짜 숫자 색상 */
}
.fc-license-message{
	display: none;
}
#detailPostModal .post-pane-body {
    margin: 15px 0;
    padding: 0 10px;
    font-size: large;
}
.community-join-btn{
	background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #667eea 100%);
    border-radius: 100px;
    color: #fff;
    font-size: 15px;
    font-weight: 700;
    height: 40px;
    line-height: 40px;
    padding: 0 30px;
}
.entertainment-goods-sidebar {
    background: linear-gradient(135deg, #8B5CF6 0%, #A855F7 50%, #9333EA 100%);
    border-radius: 20px;
    padding: 0;
    box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
    overflow: hidden;
    position: relative;
    margin-bottom: 20px;
    border: 2px solid rgba(255, 255, 255, 0.1);
}
.entertainment-goods-sidebar::before {
    content: "";
    position: absolute;
    top: -50%;
    right: -50%;
    width: 100%;
    height: 100%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
    animation: floatAnimation 6s ease-in-out infinite;
    pointer-events: none;
}
@keyframes floatAnimation {
    0%, 100% { transform: translateY(0px) rotate(0deg); }
    50% { transform: translateY(-10px) rotate(5deg); }
}
.goods-sidebar-header {
    padding: 20px 20px 15px;
    text-align: center;
    position: relative;
    z-index: 2;
}
.sidebar-title {
    color: white;
    font-size: 18px;
    font-weight: 700;
    margin: 0 0 5px 0;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}
.sidebar-title i {
    color: #FCD34D;
    animation: sparkle 2s ease-in-out infinite;
}
@keyframes sparkle {
    0%, 100% { transform: scale(1) rotate(0deg); }
    50% { transform: scale(1.2) rotate(180deg); }
}
.sidebar-subtitle {
    color: rgba(255, 255, 255, 0.8);
    font-size: 12px;
    font-weight: 400;
}
.enhanced-carousel {
    margin: 0 15px;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    background: white;
    position: relative;
}
.enhanced-carousel-inner {
    border-radius: 15px;
}
.enhanced-carousel-item {
    position: relative;
    transition: all 0.5s ease;
}
.goods-link {
    display: block;
    text-decoration: none;
    color: inherit;
    transition: all 0.3s ease;
}

.goods-link:hover {
    text-decoration: none;
    color: inherit;
    transform: scale(1.02);
}
.goods-image-container {
    position: relative;
    overflow: hidden;
    height: 250px;
}
.goods-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}
.goods-link:hover .goods-image {
    transform: scale(1.1);
}
.image-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, rgba(139, 92, 246, 0.8), rgba(168, 85, 247, 0.8));
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: all 0.3s ease;
}
.goods-link:hover .image-overlay {
    opacity: 1;
}
.overlay-content {
    color: white;
    text-align: center;
    transform: translateY(20px);
    transition: transform 0.3s ease;
}
.goods-link:hover .overlay-content {
    transform: translateY(0);
}
.overlay-content i {
    font-size: 24px;
    margin-bottom: 8px;
    display: block;
}
.overlay-content span {
    font-size: 14px;
    font-weight: 600;
}
/* 상품명 영역 */
.enhanced-title {
    background: linear-gradient(135deg, #FFFFFF 0%, #F8FAFC 100%);
    padding: 15px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-top: 1px solid rgba(139, 92, 246, 0.1);
    min-height: 60px;
}
.title-content {
    color: #1F2937;
    font-weight: 600;
    font-size: 14px;
    line-height: 1.4;
    flex: 1;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}
.title-decoration {
    margin-left: 10px;
    color: #8B5CF6;
    font-size: 16px;
    opacity: 0.7;
    transition: all 0.3s ease;
}
.goods-link:hover .title-decoration {
    opacity: 1;
    transform: scale(1.2);
    color: #EC4899;
}
/* 인디케이터 */
.entertainment-indicators {
    bottom: -35px;
    margin-bottom: 0;
}
.entertainment-indicators button {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background-color: rgba(255, 255, 255, 0.5);
    border: 2px solid rgba(255, 255, 255, 0.7);
    margin: 0 4px;
    transition: all 0.3s ease;
}
.entertainment-indicators button.active {
    background-color: #000;
    border-color: #000;
    transform: scale(1.2);
    box-shadow: 0 0 10px rgba(252, 211, 77, 0.5);
}
/* 컨트롤 버튼 */
.entertainment-control {
    width: 40px;
    height: 40px;
    background: rgba(255, 255, 255, 0.9);
    border-radius: 50%;
    border: none;
    opacity: 0;
    transition: all 0.3s ease;
    backdrop-filter: blur(10px);
}
.enhanced-carousel:hover .entertainment-control {
    opacity: 1;
}
.entertainment-control:hover {
    background: white;
    box-shadow: 0 5px 15px rgba(139, 92, 246, 0.3);
    transform: scale(1.1);
}
.control-icon {
    color: #8B5CF6;
    font-size: 18px;
    font-weight: bold;
}
/* 사이드바 푸터 */
.goods-sidebar-footer {
    padding: 15px 20px 20px;
    text-align: center;
    position: relative;
    z-index: 2;
}
.footer-sparkles {
    color: white;
    font-size: 15px;
    font-weight: 500;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    cursor: pointer;
    transition: all 0.3s ease;
    padding: 8px 15px;
    border-radius: 20px;
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
}
.footer-sparkles:hover {
    background: rgba(255, 255, 255, 0.2);
    transform: translateY(-2px);
}
.footer-sparkles i:first-child {
    color: #FCD34D;
    animation: twinkle 1.5s ease-in-out infinite;
}
@keyframes twinkle {
    0%, 100% { opacity: 1; transform: scale(1); }
    50% { opacity: 0.5; transform: scale(0.8); }
}
.footer-sparkles i:last-child {
    transition: transform 0.3s ease;
}
.footer-sparkles:hover i:last-child {
    transform: translateX(3px);
}
.entertainment-goods-sidebar:hover {
    transform: translateY(-3px);
    box-shadow: 0 25px 50px rgba(139, 92, 246, 0.4);
}
/* 반응형 디자인 */
@media (max-width: 768px) {
    .entertainment-goods-sidebar {
        border-radius: 15px;
    }
    
    .goods-sidebar-header {
        padding: 15px 15px 10px;
    }
    
    .sidebar-title {
        font-size: 16px;
    }

    .enhanced-carousel {
        margin: 0 10px;
    }

    .goods-image-container {
        height: 200px;
    }

    .enhanced-title {
        padding: 12px;
        min-height: 50px;
    }

    .title-content {
        font-size: 13px;
    }
}

/* 로딩 애니메이션 */
.enhanced-carousel-item.active .goods-image {
    animation: slideInFade 0.8s ease-out;
}

@keyframes slideInFade {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.notAllDaySchedule {
    gap: 10pt;
    align-items: center;
}
.notAllDaySchedule input {
    width: 150pt;
}
.form-check.form-switch {
    align-content: center;
}
.mb-3.allday {
    display: flex;
    gap: 10pt;
}
#scheduleModal input[type=text]:disabled {
	background-color:white;
}
#scheduleModal textarea[disabled] {
	background-color:white;
    resize: none;
}
input#title {
    border: 1px solid #e2e5e9;
    padding-left: 10px;
}
.notAllDaySchedule input {
    text-align: center;
}
input#allDate {
    width: 200pt;
    text-align: center;
}
#artistFeedSearchWrap {
   	background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(12px);
    border-radius: 18px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    padding: 18px 25px;
    margin-bottom: 25px !important;
    display: flex;
    align-items: center;
    box-shadow: 0 6px 25px rgba(0, 0, 0, 0.35);
    transition: all 0.4s ease;
    position: relative;
    justify-content: flex-start;
    flex-wrap: wrap; /* 내부 요소가 공간이 부족하면 줄바꿈되도록 */
    gap: 10px;
}

#artistFeedSearchWrap:hover {
    box-shadow: 0 8px 35px rgba(138, 43, 226, 0.4);
    transform: translateY(-3px);
    border-color: rgba(138, 43, 226, 0.5);
}
#artistFeedSearchWrap input[type="text"],
#artistFeedSearchWrap input[type="search"] {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.3);
    color: #ffffff;
    padding: 10px 15px;
    border-radius: 8px;
    font-size: 1em;
    outline: none;
    transition: border-color 0.3s ease;
    flex-grow: 1; /* 남은 공간을 최대한 채움 */
    flex-shrink: 1; /* 필요하면 줄어들 수 있음 */
    min-width: 550px;
}
/* post-composer: 포스트 작성 영역 */
.post-composer {
    background: rgba(255, 255, 255, 0.08); /* 투명도를 높여 더 돋보이게 */
    backdrop-filter: blur(12px); /* 블러 강도 증가 */
    border-radius: 18px; /* 더 둥근 모서리 */
    border: 1px solid rgba(255, 255, 255, 0.15); /* 테두리 강조 */
    padding: 22px 25px; /* 패딩 증가 */
    margin-bottom: 25px; /* 하단 마진 증가 */
    box-shadow: 0 8px 30px 0 rgba(0, 0, 0, 0.35); /* 그림자 강조 */
    transition: all 0.3s ease; /* 부드러운 전환 */
   	color: white;
   	text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
}

.post-composer:hover {
    box-shadow: 0 10px 38px 0 rgba(138, 43, 226, 0.45); /* 호버 시 그림자 더 강조 */
    transform: translateY(-3px); /* 위로 이동 효과 */
}

.post-composer .artistPostInserBtn {
    display: flex;
    align-items: center;
    gap: 18px; /* 간격 증가 */
    width: 100%;
    background: none;
    border: none;
    cursor: pointer;
    padding: 0; /* 버튼 자체 패딩 제거 */
    color: #e0e0e0; /* 텍스트 색상 조정 */
    font-size: 1.15em; /* 폰트 크기 증가 */
    font-weight: 500; /* 폰트 두께 */
    text-align: left;
}
.searchArea {
    display: flex;
    gap: 10px; /* 입력 필드와 버튼 사이 간격 */
    align-items: center;
    width: 100%; /* 부모 요소에 꽉 채우도록 */
    margin: 0 auto; /* 가운데 정렬 (선택 사항) */
}

/* search input field */
.searchArea input[type="search"] {
    flex: 1; /* 남은 공간을 모두 차지하도록 */
    padding: 12px 18px; /* 패딩 증가 */
    border: 1px solid rgba(255, 255, 255, 0.2); /* 투명한 흰색 테두리 */
    border-radius: 25px; /* 더 둥근 모서리 */
    background: rgba(255, 255, 255, 0.1); /* 투명한 배경 */
    font-size: 1em; /* 폰트 크기 */
    outline: none; /* 포커스 시 기본 아웃라인 제거 */
    transition: all 0.3s ease; /* 부드러운 전환 효과 */
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 은은한 그림자 */
}

.searchArea input[type="search"]::placeholder {
    color: #cccccc; /* 플레이스홀더 색상 */
    opacity: 0.8;
}

.searchArea input[type="search"]:focus {
    background: rgba(255, 255, 255, 0.15); /* 포커스 시 배경 살짝 밝게 */
    border-color: #e6b3ff; /* 포커스 시 보라색 테두리 */
    box-shadow: 0 0 0 3px rgba(138, 43, 226, 0.3); /* 보라색 글로우 효과 */
}
.searchArea input[type="button"] {
    flex-shrink: 0; /* 크기가 줄어들지 않도록 */
    padding: 12px 25px; /* 패딩 증가 */
    border: none;
    border-radius: 25px; /* 둥근 모서리 */
    background: linear-gradient(45deg, #8a2be2, #da70d6); /* 그라데이션 배경 */
    color: #ffffff; /* 텍스트 색상 */
    font-size: 1em; /* 폰트 크기 */
    font-weight: bold;
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2); /* 그림자 */
    transition: all 0.3s ease; /* 부드러운 전환 효과 */
}

.searchArea input[type="button"]:hover {
    background: linear-gradient(45deg, #da70d6, #8a2be2); /* 호버 시 그라데이션 방향 변경 */
    transform: translateY(-2px); /* 살짝 위로 이동 */
    box-shadow: 0 6px 20px rgba(138, 43, 226, 0.4); /* 호버 시 그림자 강조 */
}
.searchArea input[type="button"]:active {
    transform: translateY(0); /* 클릭 시 원위치 */
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3); /* 클릭 시 그림자 약화 */
}
.apt-tabs {
    display: flex;
    justify-content: center;
    padding: 0;
    margin-bottom: 30px; /* 고정될 때도 하단 여백 필요 */
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    overflow: hidden;
    width: auto;
    gap: 30px;
}
/* 개별 탭 버튼 */
.apt-tabs .tab-item {
    background: none; /* 기본 배경 제거 */
    border: none; /* 기본 테두리 제거 */
    padding: 15px 25px; /* 패딩 증가 */
    color: rgba(255, 255, 255, 0.7); /* 기본 텍스트 색상 (약간 투명한 흰색) */
    font-size: 1.05em; /* 폰트 크기 약간 증가 */
    font-weight: 600; /* 폰트 두께 */
    cursor: pointer;
    transition: all 0.3s ease; /* 부드러운 전환 효과 */
    white-space: nowrap; /* 텍스트가 줄바꿈되지 않도록 */
    position: relative; /* 하단 밑줄 애니메이션 기준점 */
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* 텍스트 그림자 */
    margin: 0;
}
.apt-tabs .tab-item:hover {
    color: #ffffff; /* 호버 시 흰색 */
    background-color: rgba(255, 255, 255, 0.05); /* 호버 시 약간 밝아지는 배경 */
}
.apt-tabs .tab-item.active {
    color: #ffffff; /* 활성화 시 흰색 */
    background: linear-gradient(90deg, #8a2be2, #da70d6); /* 그라데이션 배경 */
    box-shadow: 0 2px 10px rgba(138, 43, 226, 0.4); /* 그림자 추가 */
    font-weight: 700; /* 더 두꺼운 폰트 */
    /* 활성화된 탭 하단 강조 효과 */
    border-bottom: 3px solid #f0f0f0; /* 강한 하단 테두리 */
}
.apt-tabs .tab-item.active:active {
    transform: translateY(0); /* 클릭 시 원위치 */
    box-shadow: 0 1px 8px rgba(138, 43, 226, 0.3); /* 그림자 약화 */
}
#searchFormBtn {
    /* 기존 스타일 재정의 */
    background: linear-gradient(45deg, #8a2be2, #da70d6); /* 보라색 그라데이션 */
    color: white; /* 흰색 텍스트 */
    border: none; /* 테두리 제거 */
    padding: 10px 20px; /* 패딩 조정 */
    border-radius: 10px; /* 둥근 모서리 */
    font-size: 1em; /* 폰트 크기 */
    font-weight: bold; /* 폰트 두께 */
    cursor: pointer; /* 마우스 오버 시 커서 변경 */
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2); /* 그림자 추가 */
    transition: all 0.3s ease; /* 부드러운 전환 효과 */
    flex-shrink: 0;
}

#searchFormBtn:hover {
    background: linear-gradient(45deg, #da70d6, #8a2be2); /* 호버 시 그라데이션 반전 */
    transform: translateY(-2px); /* 살짝 떠오르는 효과 */
    box-shadow: 0 6px 20px rgba(138, 43, 226, 0.4); /* 호버 시 그림자 강조 */
}

#searchFormBtn:active {
    transform: translateY(0); /* 클릭 시 원위치 */
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2); /* 클릭 시 그림자 축소 */
}
.radioBtnArea {
    display: flex;
    gap: 10px; /* 라디오 버튼 간 간격 */
    flex-wrap: wrap; /* 너무 많으면 줄바꿈 */
    margin-top: 15px; /* 검색창 아래 여백 */
    padding-top: 15px; /* 상단 패딩 */
   	width: 100%;
   	justify-content: normal;
}
/* 모든 라디오 버튼 레이블 (선택되지 않은 상태) */
.radioBtnArea .btn-outline-primary {
    /* 기존 Bootstrap 스타일 재정의 */
    background-color: rgba(255, 255, 255, 0.1); /* 투명한 배경 */
    border: 1px solid rgba(255, 255, 255, 0.3); /* 은은한 테두리 */
    color: rgba(255, 255, 255, 0.8); /* 약간 투명한 흰색 텍스트 */
    border-radius: 20px; /* 더 둥근 알약 모양 */
    padding: 8px 18px; /* 패딩 조정 */
    font-size: 0.9em; /* 폰트 크기 */
    font-weight: 500; /* 폰트 두께 */
    transition: all 0.3s ease; /* 부드러운 전환 */
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* 텍스트 그림자 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); /* 은은한 그림자 */
    flex-shrink: 0;
}
.radioBtnArea .btn-outline-primary:hover {
    background-color: rgba(255, 255, 255, 0.2); /* 호버 시 배경 살짝 진해짐 */
    border-color: rgba(255, 255, 255, 0.4); /* 호버 시 테두리 살짝 진해짐 */
    color: #ffffff; /* 호버 시 텍스트 흰색 */
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15); /* 호버 시 그림자 강조 */
    transform: translateY(-1px); /* 살짝 떠오르는 효과 */
}
/* 선택된 라디오 버튼의 레이블 */
.radioBtnArea .btn-check:checked + .btn-outline-primary {
    background: linear-gradient(45deg, #8a2be2, #da70d6); /* 보라색 그라데이션 배경 */
    color: white; /* 흰색 텍스트 */
    border-color: #8a2be2; /* 테두리 색상 강조 */
    font-weight: bold; /* 폰트 두께 강조 */
    box-shadow: 0 4px 15px rgba(138, 43, 226, 0.3); /* 선택 시 그림자 강조 */
    transform: translateY(0); /* 떠오르는 효과 없앰 */
}
.post-composer .post-placeholder-text {
    color: white !important; /* 우선순위 높임 */
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
}
.modal-content .btn-primary { /* 모달 내부 기본 버튼 스타일 */
    background: linear-gradient(45deg, #8a2be2, #da70d6);
    color: white;
    border: none;
    padding: 12px 25px;
    border-radius: 10px;
    font-weight: bold;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    transition: all 0.3s ease;
}
.modal-content .btn-primary:hover {
    background: linear-gradient(45deg, #da70d6, #8a2be2);
    box-shadow: 0 6px 20px rgba(138, 43, 226, 0.4);
    transform: translateY(-2px);
}
.btn-view-membership {
    background: linear-gradient(135deg, #e6b3ff 0%, #8a2be2 100%);
    border: 1px solid #ffffff;
    border-radius: 10px; /* 둥근 모서리 */
    color: white; /* 텍스트 색상 흰색 */
    font-weight: bold; /* 텍스트 두껍게 */
    font-size: 1.05em; /* 글자 크기 살짝 키움 */
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3); /* 텍스트 그림자 */
    padding: 12px 25px; /* 패딩으로 버튼 크기 조절 */
    display: inline-flex; /* 내부 요소 정렬을 위해 flexbox 사용 */
    align-items: center; /* 세로 중앙 정렬 */
    gap: 8px; /* 텍스트와 화살표 사이 간격 */
    cursor: pointer;
    text-decoration: none; /* 밑줄 제거 (a 태그일 경우) */
    transition: all 0.3s ease; /* 모든 속성에 부드러운 전환 효과 */
    box-shadow: 0 5px 15px rgba(138, 43, 226, 0.5);
    margin-top: 10px;
}
.btn-view-membership .arrow {
    font-size: 1.2em; /* 화살표 크기 조절 */
    transition: transform 0.3s ease; /* 화살표 이동 애니메이션 */
}
.btn-view-membership:hover {
    background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%);
    border-color: rgba(255, 255, 255, 0.8); /* 호버 시 테두리 더 선명하게 */
    box-shadow: 0 8px 30px rgba(138, 43, 226, 0.7); /* 호버 시 보라색 그림자 강조 */
    transform: translateY(-3px); /* 버튼 살짝 위로 떠오르는 효과 */
}
.btn-view-membership:hover .arrow {
    transform: translateX(5px); /* 호버 시 화살표 살짝 오른쪽으로 이동 */
}
.feed-item-content img {
	width: auto;
    max-width: 100%; /* 이미지가 부모 요소(feed-item)의 너비를 넘지 않도록 합니다. */
    height: 400px; /* 이미지의 원래 비율을 유지하며 높이를 자동 조정합니다. */
    display: block; /* 이미지 하단에 불필요한 여백을 제거합니다. */
    margin: 0 auto 5px auto;
    border-radius: 10px; /* (선택 사항) 피드 아이템의 둥근 모서리와 어울리게 이미지도 둥글게 */
    object-fit: contain;
    z-index: 2;
    position: relative;
}
.modal-fullscreen-custom {
    --bs-modal-width: 90vw; /* 전체 너비의 90% 사용 */
    --bs-modal-height: 90vh; /* 전체 높이의 90% 사용 */
    margin: auto; /* 중앙 정렬 */
    display: flex;
    align-items: center;
    justify-content: center;
}

/* --- 닫기 버튼 --- */
.btn-close-white {
    position: absolute;
    top: 20px;
    right: 20px;
    z-index: 1060; /* 모달 내용 위에 있도록 */
    opacity: 0.8;
    transition: opacity 0.3s ease;
}

.btn-close-white:hover {
    opacity: 1;
    transform: scale(1.1);
}
div#fanFeedSearchWrap {
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(12px);
    border-radius: 18px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    padding: 18px 25px;
    margin-bottom: 25px !important;
    display: flex;
    align-items: center;
    box-shadow: 0 6px 25px rgba(0, 0, 0, 0.35);
    transition: all 0.4s ease;
    position: relative;
    justify-content: flex-start;
    flex-wrap: wrap;
    gap: 10px;
}

form#artistSearchForm {
    width: 100%;
}

div#noticeSearchWarp {
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(12px);
    border-radius: 18px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    padding: 18px 25px;
    margin-bottom: 25px !important;
    display: flex;
    align-items: center;
    box-shadow: 0 6px 25px rgba(0, 0, 0, 0.35);
    transition: all 0.4s ease;
    position: relative;
    justify-content: flex-start;
    flex-wrap: wrap;
    gap: 10px;
}

form#noticeSearchForm {
    width: 100%;
}

.post-pane-body p {
    white-space: pre-line;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/modules/communityHeader.jsp" />

	<sec:authentication property="principal" var="user"/>
	<input type="hidden" id="communityArtistGroupNo" value="${artistGroupVO.artGroupNo }">
	<input type="hidden" id="communityArtistGroupNm" value="${artistGroupVO.artGroupNm }">
	<input type="hidden" id="mediaServerUrl" value="${mediaServerUrl}">
<%-- 	    <c:out value="${artistGroupVO}"/> --%>
<%-- 	    <c:out value="${user}"/> --%>
<c:set value="${artistGroupVO.communityVO.totalArtist }" var="artists"></c:set>
    <c:choose>
		<c:when test="${communityVO.artistTabYn }">
			<c:set value="${artistPostVO }" var="communityPostVO" />
		</c:when>
		<c:otherwise>
			<c:set value="${fanPostVO }" var="communityPostVO" />
		</c:otherwise>
	</c:choose>
	<c:set value="${userProfile.memberShipYn }" var="memberShipCheck" />

    <div class="apt-main-layout">
<!--     	<aside class="apt-sidebar"> -->
<!-- 			<div class="sidebar-widget goods-widget"> -->
<!-- 				<div id="carouselExampleFade" class="carousel slide carousel-fade" data-bs-ride="carousel"> -->
<!-- 					<div class="carousel-inner"> -->
<%-- 						<c:forEach items="${thumnailImages }" var="img" varStatus="i"> --%>
<%-- 							<a href="${pageContext.request.contextPath}/goods/detail?goodsNo=${img.goodsNo }"> --%>
<%-- 								<div class="carousel-item <c:if test="${i.index == 0 }">active</c:if>" data-bs-interval="5000"> --%>
<!-- 									<div class="carousel-item-title"> -->
<%-- 										<c:out value="${img.goodsNm }" /> --%>
<!-- 									</div> -->
<%-- 									<img src="${img.representativeImageFile.webPath }" class="d-block w-100" > --%>
<!-- 								</div> -->
<!-- 							</a> -->
<%-- 						</c:forEach> --%>
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 			</div> -->
<!-- 		</aside> -->

			<aside class="apt-sidebar">
			    <div class="sidebar-widget goods-widget entertainment-goods-sidebar pt-3">
			        <!-- 헤더 추가 -->

			        <div id="carouselExampleFade" class="carousel slide carousel-fade enhanced-carousel" data-bs-ride="carousel" data-bs-interval="4000">

			            <div class="carousel-inner enhanced-carousel-inner">
			                <c:forEach items="${thumnailImages }" var="img" varStatus="i">
			                    <a href="${pageContext.request.contextPath}/goods/detail?goodsNo=${img.goodsNo }" class="goods-link">
			                        <div class="carousel-item enhanced-carousel-item <c:if test="${i.index == 0 }">active</c:if>" data-bs-interval="5000">
			                            <div class="goods-image-container">
			                                <img src="${img.representativeImageFile.webPath }" class="d-block w-100 goods-image" alt="${img.goodsNm}">
			                                <div class="image-overlay">
			                                    <div class="overlay-content">
			                                        <i class="bi bi-eye-fill"></i>
			                                        <span>자세히 보기</span>
			                                    </div>
			                                </div>
			                            </div>
			                            <div class="carousel-item-title enhanced-title">
			                                <div class="title-content">
			                                    <c:out value="${img.goodsNm }" />
			                                </div>
			                            </div>
			                        </div>
			                    </a>
			                </c:forEach>
			            </div>

			            <!-- 컨트롤 버튼 추가 -->
			            <button class="carousel-control-prev entertainment-control" type="button" data-bs-target="#carouselExampleFade" data-bs-slide="prev" style="top: 40%">
			                <i class="bi bi-chevron-left control-icon"></i>
			                <span class="visually-hidden">이전</span>
			            </button>
			            <button class="carousel-control-next entertainment-control" type="button" data-bs-target="#carouselExampleFade" data-bs-slide="next" style="top: 40%">
			                <i class="bi bi-chevron-right control-icon"></i>
			                <span class="visually-hidden">다음</span>
			            </button>
			        </div>

			        <!-- 푸터 추가 -->
			        <div class="goods-sidebar-footer" onclick="toGoodsShop()">
			            <div class="footer-sparkles">
			                <i class="bi bi-stars"></i>
			                <span>더 많은 굿즈 보러가기</span>
			                <i class="bi bi-arrow-right"></i>
			            </div>
			        </div>
			    </div>
			</aside>

        <div class="apt-container">
            <header class="apt-header">
                <div class="apt-header-avatar">
                    <div class="artist-avatar-placeholder"><img alt="" src="${artistGroupVO.artGroupProfileImg}"> </div>
                </div>
                <div class="apt-header-info">
                	<input type="hidden" id="artistGroupProfileImg" value="${artistGroupVO.artGroupProfileImg}">
                    <h2 class="d-flex gap-2">
                    	<c:out value="${artistGroupVO.artGroupNm }" />
                    	<img alt="아티스트 인증 마크" src="${pageContext.request.contextPath }/resources/img/verified.png" style="width: 25px; height: 25px;">
                   	</h2>
                    <div class="artist-stats">
                        <span><c:out value="${artists }"/>명</span> &bull; <span><fmt:formatNumber value="${fansWithoutDel}" pattern="#,###"/></span> 팬
                    </div>
                </div>
                <div class="apt-header-actions">
	               	<c:if test="${followFlag eq 'Y'}">
		                <button class="btn-apt-action following" id="followToggleBtn">
		                    <span class="follow-icon">✔</span> 팔로잉
		                </button>
	               	</c:if>
	            </div>
            </header>

            <ul class="nav apt-tabs" id="comuTab" role="tabList">
            	<li class="nav-item" role="presentation">
			        <button class="tab-item active" id="artistPost" data-bs-toggle="tab" data-bs-target="#artistPostList" type="button" role="tab" aria-controls="artistPostList" aria-selected="true" >아티스트</button>
			    </li>
			    <li class="nav-item" role="presentation">
			        <button class="tab-item" id="fanPost" data-bs-toggle="tab" data-bs-target="#fanPostList" type="button" role="tab" aria-controls="fanPostList" aria-selected="false">팬</button>
			    </li>
			    <li class="nav-item" role="presentation">
			        <button class="tab-item" id="live" data-bs-toggle="tab" data-bs-target="#liveArea" type="button" role="tab" aria-controls="liveArea" aria-selected="false">라이브</button>
			        <%-- <button class="tab-item" id="live" href="/community/apt/${artistGroupVO.artGroupNo}/live">라이브</button>  <-----원래 사용하시던거          --%>
			    </li>
			    <li class="nav-item" role="presentation">
			        <button class="tab-item" id="schedule" data-bs-toggle="tab" data-bs-target="#scheduleList" type="button" role="tab" aria-controls="scheduleList" aria-selected="false">스케줄</button>
			    </li>
			    <li class="nav-item" role="presentation">
			        <button class="tab-item" id="noticeApt" data-bs-toggle="tab" data-bs-target="#noticeAptList" type="button" role="tab" aria-controls="noticeAptList" aria-selected="false">공지사항</button>
			    </li>
            </ul>

            <main class="apt-content-area">

                <div class="tab-pane show active" id="artistPostList" role="tabpanel" aria-labelledby="artistPost">
                   	<div id="artistFeedSearchWrap" style="margin-bottom:10px; display:flex; gap:8px; align-items:center;">

                    </div>

                    <!-- 등록 모달 오픈 -->
                    <sec:authorize access="hasRole('ARTIST')">
	                    <div class="post-composer" id="openModal">
					        <button type="button" class="artistPostInserBtn" data-bs-toggle="modal" data-bs-target="#insertPostModal">
						        <div class="profile-placeholder"></div>
						        <span class="placeholder-text"><i class="fa-solid fa-arrow-up-from-bracket"></i> 오늘의 생각을 공유해보세요!</span>
							</button>
					    </div>
                    </sec:authorize>
				    <!-- 등록 모달 오픈 끝 -->

                    <div id="artistFeedList" class="feedList">

                    </div>
                </div>

                <div class="tab-pane" id="fanPostList" role="tabpanel" aria-labelledby="fanPost">
                	<div id="fanFeedSearchWrap" style="margin-bottom:10px; display:flex; gap:8px; align-items:center;">

                    </div>
                    <c:if test="${userProfile.comuMemCatCode eq 'CMCC001' || userProfile.comuMemCatCode eq 'CMCC002' }">
	                    <div class="post-composer" id="openModal">
					        <button type="button" data-bs-toggle="modal" data-bs-target="#insertPostModal">
						        <div class="profile-placeholder"></div>
						        <span class="placeholder-text"><i class="fa-solid fa-arrow-up-from-bracket"></i> 오늘의 생각을 공유해보세요!</span>
							</button>
					    </div>
                    </c:if>

					 <div id="fanFeedList" class="feedList">

                    </div>
                </div>

				<sec:authentication property="principal.username" var="currentUserId"/>

				<div class="tab-pane<c:if test='${requestScope["javax.servlet.forward.request_uri"].endsWith("/live")}'> show active</c:if>" id="liveArea" role="tabpanel" aria-labelledby="live">

				    <%-- 'Live 방송하기' 버튼은 유지 --%>
				    <sec:authorize access="hasRole('ARTIST')">
				        <c:forEach items="${artistGroupVO.artistList}" var="artist">
				            <c:if test="${artist.memUsername eq currentUserId}">
				                <button onclick="startLive()" id="stream-info" class="btn btn-danger mt-4" data-user-id="${currentUserId}"
				                                           data-room-id="stream-room-${artistGroupVO.artGroupNo }">
				                    <i class="bi bi-mic-fill"></i> Live 방송하기
				                </button>
				            </c:if>
				        </c:forEach>
				    </sec:authorize>

					<%-- 라이브 정보가 동적으로 로드될 영역 --%>
				    <div id="liveContentArea" class="mt-4">
				        <%-- JavaScript로 여기에 라이브 정보가 삽입됩니다. --%>
				        <div class="text-center p-5 text-muted border rounded" id="liveLoadingIndicator" style="display: none;">
				            <div class="spinner-border text-primary" role="status">
				                <span class="visually-hidden">Loading...</span>
				            </div>
				            <p class="mt-3 mb-0">라이브 정보를 불러오는 중...</p>
				        </div>
				        <div class="text-center p-5 text-muted border rounded" id="noLiveMessage" style="display: none;">
				            <i class="bi bi-camera-video-off" style="font-size: 3rem;"></i>
				            <p class="mt-3 mb-0">현재 진행 중인 라이브 방송이 없습니다.</p>
				        </div>
				    </div>

<!-- 				    <div> -->
<!-- 				    	여기에다가 멤버십이 없으면, 블러처리 해서 클릭 안되게 막을거고 -->
<!-- 				    	멤버십이 있으면, 블러 처리 해체해서 영상을 볼 수 있게 만들거야. -->
<!-- 				    	Tyrdager -->
<!-- 						<iframe width="560" height="315" src="https://www.youtube.com/embed/Q9KCtQaI2EI?si=gqJ4KwQOHQbeqhw1" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe> -->
<!-- 						Tyrdager · MUHANLOOP -->

<!-- 						Tyrdager -->

<!-- 						℗ MUHANLOOP -->

<!-- 						Released on: 2019-02-28 -->

<!-- 						Music Publisher: GMS MUSIC -->
<!-- 						Lyricist, Composer, Arranger: MUHANLOOP -->


<!-- 				    </div> -->
				</div>

			    <div class="tab-pane" id="scheduleList" role="tabpanel" aria-labelledby="schedule">
			        <p class="loading-placeholder" style="text-align: center; display: block;">
			        	<div id="calendar"></div>
					</p>
			    </div>

			    <div class="tab-pane" id="noticeAptList" role="tabpanel" aria-labelledby="noticeApt">
			    	<div id="noticeSearchWarp" style="margin-bottom:10px; display:flex; gap:8px; align-items:center;">

	                </div>
				    <div id="noticeList" >

	                </div>

	                <div id="noticePagingArea">

	                </div>

			    </div>

            </main>
        </div>




<!-- /////////////////////////////////////////////////////////////////////////////////////////////////////// -->






        <aside class="apt-sidebar">
            <div class="sidebar-widget apt-level-widget">
                <h3>APT 현황</h3>
                <div class="apt-floor-display" id="aptFloorDisplay">
                	<!-- 1. div 연산자를 사용하여 10명당 1층으로 계산 (정수 나눗셈) -->
                	<c:set var="aptFloor" value="${Math.floor(fansWithoutDel div 10) } "/>
                	<fmt:formatNumber value="${aptFloor }" pattern="#,###,###"/>층
                </div>


                <div class="fan-count-tooltip-wrapper"> <p class="fan-count-display">팬 <span id="sidebarFanCountApprox">
                	<fmt:formatNumber value="${fansWithoutDel}" pattern="#,###,###"></fmt:formatNumber> </span>명</p>
                </div>
            </div>
            <c:if test="${not empty userProfile }">
				<c:if test="${not empty membershipInfo }">
	            <div class="sidebar-widget membership-widget">
	                <div class="membership-icon">💎</div>
	                <h3>Membership</h3>
	                <c:choose>
	                	<c:when test="${hasMembership }">
	                		<p><strong>멤버십에 가입되어 있습니다!</strong></p>
	                		<p>특별한 컨텐츠를 즐겨보세요.</p>
	                		<button class="btn-view-membership" onclick="location.href='${pageContext.request.contextPath}/mypage/memberships'" style="cursor:pointer; color: white;">
			                나의 멤버십 보기 <span class="arrow">&gt;</span>
			            </button>
	                	</c:when>
	                	<c:otherwise>
	                		<p>지금 멤버십에 가입하고, 특별한 혜택을 누려보세요.</p>
			                <button class="btn-join-membership" id="openMembershipModalBtn" data-bs-toggle="modal" data-bs-target="#membershipModalOverlay">
			                    멤버십 가입하기 <span class="arrow">&gt;</span>
			                </button>
	                	</c:otherwise>
	                </c:choose>
	            </div>
				</c:if>

	             <!-- 마이 프로필 영역 추가 -->
	             <div id="myProfile" class="sidebar-widget my-profile-widget" style="margin-bottom: 20px; text-align: center; cursor: pointer; color: white;" data-comu-profile-no="${userProfile.comuProfileNo}">
	                <div style="width: 80px; height: 80px; margin: 0 auto; border-radius: 50%; overflow: hidden; background-color: #e9ecef; display: flex; align-items: center; justify-content: center;">
	                	<img alt="프로필 img" src="${userProfile.comuProfileImg}" style="height: 100%; object-fit: cover;">
	                </div>
	                <p id="myProfileNickname" style="margin-top: 8px; font-weight: bold; font-size: 1.1em;">${userProfile.comuNicknm}</p>
	                <small>내가 쓴 글 : ${fn:length(userProfile.postList)}개</small> | <small>내가 쓴 댓글 : ${fn:length(userProfile.replyList)}개</small>
	            </div>
			</c:if>

        </aside>
    </div>

     <div class="modal fade" id="membershipModalOverlay" tabindex="-1" aria-labelledby="membershipModalLabel" aria-hidden="true"
     	data-artist-group-no="${artistGroupVO.artGroupNo }"
     	data-membership-goods-no="${artistGroupVO.membershipGoodsNo}">
        <div class="modal-dialog modal-xl">
	        <div class="modal-content membership-modal" style="font-size: large;">
	            <button class="modal-close-btn" id="closeMembershipModalBtn" aria-label="Close" data-bs-dismiss="modal">&times;</button>
	            <div class="modal-header">
	                <h2>${membershipInfo.mbspNm }</h2>
	                <p class="membership-duration">이용 기간: 결제일로부터 ${membershipInfo.mbspDuration}일</p>
	            </div>
	            <div class="modal-body">
	                <div class="membership-main-image">
	                </div>
	                <h3>주요 혜택 안내</h3>
	                <ul class="modal-benefits-list">
	                    <li>✔️ 멤버십 전용 콘텐츠 이용 가능 (일부 블러 처리된 콘텐츠 즉시 해제!)</li>
	                    <li>🗓️ APT 메인 상단에서 아티스트 구독일 D-Day 확인</li>
	                    <li>🎤 콘서트/팬미팅 선예매 및 특별 이벤트 참여 기회</li>
	                    <li>🎁 한정판 멤버십 키트 제공 (별도 구매 또는 등급에 따라)</li>
	                </ul>

	                <h3>이용 안내 및 유의사항</h3>
	                <ul class="modal-notes-list" style="margin-bottom: 0px;">
	                    <li>본 멤버십은 비용을 선지불하여 이용하는 유료 서비스입니다.</li>
	                    <li>멤버십은 아티스트(솔로, 그룹)별로 별도 운영되며, 본 멤버십은 [${artistGroupVO.artGroupNm }] 전용입니다.</li>
	                    <li>그룹 내 솔로 활동 멤버 발생 시, 해당 멤버의 커뮤니티는 별도 생성/운영될 수 있습니다.</li>
	                    <li>자세한 내용은 구매 페이지의 약관을 참고해주세요.</li>
	                </ul>
	            </div>
	            <div class="modal-footer" style="margin: 0px;">
	                <div class="membership-price">₩ <fmt:formatNumber value="${membershipInfo.mbspPrice}" pattern="###,###"></fmt:formatNumber> <span class="vat-notice">(VAT 포함)</span></div>
	                <button class="btn-modal-purchase" id="goToPurchasePageBtn">멤버십 구매하기</button>
	            </div>
	        </div>
        </div>
    </div>

	<c:if test="${followFlag eq 'N'}">
	     <!-- 커뮤니티 가입 오버레이 -->
	    <div id="communityOverlay" class="d-flex align-items-center fixed-bottom">
	        <div class="community-overlay-bg" style="position:absolute; height:400px; bottom: 0px; width:100%; background: linear-gradient(180deg, #0000, #000000ed); border-radius: 5px;"></div>
	        <div class="d-flex p-2 align-items-center justify-content-around w-100" style="position:relative; z-index:1000; height: 100px;">
		        <span style="color: #fff; width:70%; font-size:1.2em; font-weight: bold;">커뮤니티 팔로우를 해서 모든 컨텐츠를 즐겨보세요</span>
		        <button class="community-join-btn" id="followBtn" style="width:30% color:#fff">팔로우하기</button>
	        </div>
	    </div>

	    <!-- 닉네임 입력 모달 -->
	    <div class="modal fade" id="commProfileModal" tabindex="-1" aria-labelledby="nicknameModalLabel" aria-hidden="true">
	        <div class="modal-dialog modal-dialog-centered">
	            <div class="modal-content">
	                <div class="modal-header">
	                    <h5 class="modal-title" id="commProfileModalLabel">커뮤니티 프로필을 만들어보세요!</h5>
	                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	                </div>
	                <div class="modal-body">
	                	<div class="mb-3 d-flex justify-content-center align-items-center">
	                        <div class="profile-img-box" id="previewImgBox" style="width:100px; height:100px; border-radius: 50%; cursor:pointer; overflow: hidden; object-fit:cover; ">
	                            <img alt="프로필이미지" src="${pageContext.request.contextPath}/upload/profile/base/defaultImg.png" id="previewImg" style="height: 100px; width:100%;">
	                        </div>
	                	</div>
	                    <div class="mb-3">
	                        <label for="comuNicknm" class="form-label">닉네임</label>
	                        <input type="text" class="form-control" id="comuNicknm" name="comuNicknm" maxlength="12" placeholder="12자 이내로 입력하세요">
	                    </div>

	                    <div class="mb-3">
	                        <label for="imgFile" class="form-label">프로필 이미지</label>
	                        <input class="form-control" type="file" id="imgFile" name="imgFile" accept="image/*">
	                    </div>
	                </div>
	                <div class="modal-footer">
	                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	                    <button type="button" class="btn btn-primary" id="profileSubmitBtn">완료</button>
	                </div>
	            </div>
	        </div>
	    </div>
	</c:if>

    <!-- DM 모달이 삽입될 컨테이너 -->
    <div id="weverse-dm-modal-container"></div>


<!-- 아티스트 글 등록 모달 -->
<div class="modal fade " id="insertPostModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
	aria-labelledby="insertPostModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h1 class="modal-title fs-5" id="insertPostModalLabel">
					<c:out value="${artistGroupVO.artGroupNm }" />
				</h1>
				<button type="button" class="btn-close"
					aria-label="Close" id="insertModalHeaderCloseBtn"></button>
			</div>
			<div class="modal-body">
				<form id="postForm" action="/community/insert/post"
					enctype="multipart/form-data" method="post">
					<input type="hidden" name="artGroupNo" value="${artistGroupVO.artGroupNo }" />
					<input type="hidden" name="boardTypeCode" value="${communityVO.boardTypeCode }" />
					<input type="hidden" name="artistTabYn" value="${communityVO.artistTabYn }" />

					<div id="imgArea"></div>

					<div>내용</div>
					<textarea rows="5" cols="10" id="comuPostContent"
						onkeyup="contentLengthCheck(this)" name="comuPostContent" placeholder="내용을 입력해주세요."></textarea>

					<div class="text-right pt-2">
						<span class="pt-1"><span class="cmt-sub-size">0</span>/1000</span>
					</div>

					<sec:authorize access="hasRole('ARTIST')">
						<div class="inserPostCheckbox">
							<input type="checkbox" id="postMemberShipYn" name="postMemberShipYn" value="멤버십전용 게시물" style="display:none"/>
							<label for="postMemberShipYn" class="checkbox-label">멤버십전용</label>
							<input type="hidden" id="memberShipYn" name="memberShipYn" value="" />
						</div>
					</sec:authorize>
					<div class="file-wrap">
						<input type="text" name="fileName" id="fileName" class="fileName" placeholder="선택된 파일이 없습니다." readonly="readonly" />
						<input type="file" name="files" id="insertPostFile" multiple accept="image/*">
						<label for="insertPostFile" class="file-label">파일선택</label>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="postSendBtn">저장</button>
				<button type="button" class="btn btn-secondary"
					id="addPostModalCloseBtn">취소</button>
			</div>
		</div>
	</div>
</div>

<!-- 아티스트 글 등록 모달 끝 -->

<!-- 아티스트 글 수정 모달 -->
<div class="modal fade " id="editPostModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="editPostModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h1 class="modal-title fs-5" id="editPostModalLabel">
					<c:out value="포스트 수정" />
				</h1>
				<button type="button" class="btn-close"
					aria-label="Close" id="editPostModalHeaderCloseBtn"></button>
			</div>
			<div class="modal-body">
				<form id="editPostForm" enctype="multipart/form-data" method="post">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					<input type="hidden" name="artGroupNo" value="${artistGroupVO.artGroupNo }" />
					<input type="hidden" name="comuPostNo" id="postNum" />
					<input type="hidden" id="fileGroupNo" name="fileGroupNo" />
					<input type="hidden" id="deleteFiles" name="deleteFiles" />

					<div id="editImgArea" class="editImg"></div>
					<div id="plusImg" class="editImg"></div>

					<div>내용</div>
					<textarea rows="5" cols="10" id="editComuPostContent"
						 name="comuPostContent" onkeyup="contentLengthCheck(this)"></textarea>
					<div class="text-right pt-2">
						<span class="pt-1"><span class="cmt-sub-size">0</span>/1000</span>
					</div>

					<c:if test="${communityVO.artistTabYn }">
						<label for="editPostMemberShipYn" id="checkBoxMbs">
							<input type="checkbox" id="editPostMemberShipYn" name="postMemberShipYn" value="멤버십전용 게시물" />
							<input type="hidden" id="editMemberShipYn" name="memberShipYn"
							value="" /> 멤버십전용
						</label>
					</c:if>
					<input type="file" name="files" id="editInsertPostFile" multiple accept="image/*">
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="postUpdateBtn">수정</button>
				<button type="button" class="btn btn-secondary"
					 id="postUpdateCloseBtn">취소</button>
			</div>
		</div>
	</div>
</div>
<!-- 아티스트 글 수정 모달 끝 -->

<!-- 신고모달 -->
<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="reportModalLabel">신고사유 선택</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="reportForm" method="post">
        	<input type="hidden" name="targetComuPostNo" id="targetComuPostNo">
        	<input type="hidden" name="targetBoardTypeCode" id="targetBoardTypeCode">
        	<input type="hidden" name="targetComuReplyNo" id="targetComuReplyNo" value="">
        	<input type="hidden" name="artGroupNo" id="reportArtGroupNo">
        	<input type="hidden" name="targetComuProfileNo" id="targetComuProfileNo">
        	<input type="hidden" name="reportTargetTypeCode" id="reportTargetTypeCode">
          <div class="mb-3">
          	<div class="radioArea">
          	</div>
          </div>
          <div class="mb-3">
            <label for="targetNick" class="col-form-label">신고 처리 대상:</label>
            <input type="text" class="form-control" id="targetNick" disabled="disabled" />
          </div>
          <div class="mb-3">
            <label for="targetContent" class="col-form-label">처리 내용:</label>
            <textarea class="form-control" id="targetContent" disabled="disabled"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="reportSendBtn">신고하기</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>

<!-- 포스트 상세 모달 ver2 -->
<div class="modal fade" id="detailPostModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-fullscreen-custom">
         <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>

        <div class="modal-content">
            <div class="modal-body p-0">
                <div class="d-flex h-100">

                    <div class="post-pane" id="postBox">
                    </div>

                    <div class="comment-pane">
					    <div class="comment-pane-header">
					        <strong class="mx-auto" id="replyCount"></strong>
					    </div>

					    <div class="comment-pane-body" id="replyList" style="font-size: large;">

					    </div>

					    <div class="comment-pane-footer">
					    	<form action="/community/reply/insert" method="get" id="replyForm">
								<input type="hidden" id="boardTypeCode" name="boardTypeCode" />
								<input type="hidden" id="comuPostNo" name="comuPostNo" />
								<input type="hidden" id="artGroupNo" name="artGroupNo" value="${artistGroupVO.artGroupNo }" />
							    <div class="input-group">
						        	<textarea id="comuReplyContent" onkeyup="replyContentLengthCheck(this)" name="comuReplyContent" class="form-control" placeholder="댓글을 입력하세요." aria-label="댓글 입력" rows="1" style="resize: none;"></textarea>
						        	<button class="btn btn-primary" type="button" id="replyBtn">등록</button>
							    </div>
								<div class="text-right pt-2">
									<span class="pt-1"><span class="cmt-sub-size">0</span>/300</span>
								</div>
							</form>
						</div>
					</div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- 스케줄 상세 모달 -->
<div class="modal fade" id="scheduleModal" tabindex="-1" aria-labelledby="scheduleModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="scheduleModalLabel">일정상세</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" id="closeBtn"></button>
			</div>
			<div class="modal-body">
	        	<div class="mb-3">
	        		 <label for="title" class="form-label">일정명</label>
	        		 <input type="text" class="form-control-plaintext" id="title" name="title" disabled="disabled">
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
					<label for="dateUrl" class="col-form-label">경로</label><br/>
					<a href="" id="datelink"></a>
				</div>
				<div class="mb-3 allday">
					<label for="allDayStatus" class="col-form-label">하루일정여부</label>
					<div class="form-check form-switch">
					  <input class="form-check-input" type="checkbox"  id="allDayStatus" name="allDayStatus" disabled="disabled">
					</div>
				</div>
				<div class="mb-3">
					<label for="date" class="col-form-label">일정</label>
					<div class="notAllDaySchedule" style="display:none">
						<input type="text" name="datetimes" id="startDate" class="form-control" disabled="disabled"/> <span>~</span>
						<input type="text" name="datetimes" id="endDate" class="form-control" disabled="disabled"/>
					</div>
					<div class="allDaySchedule" style="display:none">
						<input type="text" name="datetimes" id="allDate" class="form-control" disabled="disabled"/>
					</div>
				</div>
	        </div>
	        <div class="modal-footer">
			  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="cancelBtn">닫기</button>
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
<script type="text/javascript">

function toGoodsShop(){
	window.location.href = "http://localhost:6688/goods/main";
}

// 멤버십 가입하기 버튼 이벤트
document.addEventListener('DOMContentLoaded', function () {
	// 멤버십 구매하기 버튼
	const mbspBtn = document.getElementById('openMembershipModalBtn');
	const membershipModal = document.getElementById('membershipModalOverlay');
	const closeModalBtn = document.querySelector('#closeMembershipModalBtn');
	const goToPurchasePageBtn = document.getElementById('goToPurchasePageBtn');

	const csrfMeta = document.querySelector('meta[name="_csrf"]');
	const csrfHeaderMeta = document.querySelector('meta[name="_csrf_header"]');

	let csrfToken = csrfMeta.getAttribute('content');
	let csrfHeaderName = csrfHeaderMeta.getAttribute('content');

	let artistGroupNo = membershipModal.dataset.artistGroupNo;
	let membershipGoodsNo = parseInt(membershipModal.dataset.membershipGoodsNo);

	// 결제 구현
	goToPurchasePageBtn.addEventListener('click', function() {
		requestKakaoPaySubscription(membershipGoodsNo, artistGroupNo);
	});

	function requestKakaoPaySubscription(goodsNo, artistGroupNo) {
		// 1. 결제할 멤버십 상품 정보 정의
		const orderData = {
				orderItems: [
					{
						goodsNo: goodsNo,
						goodsOptNo: null,
						qty: 1,
						goodsNm: "DDTOWN 아티스트 멤버십",
					}
				],
				singleGoodsName: "DDTOWN 아티스트 멤버십",
				totalAmount: "${membershipInfo.mbspPrice}",
				isFromCart: false,
				orderTypeCode: "OTC001", // 멤버십
				orderPayMethodNm: "카카오페이",
				orderRecipientNm: "${user.memberVO.peoName}",
	            orderRecipientPhone: "${user.memberVO.peoPhone}", // 유효하지 않은 전화번호
	            orderZipCode: "${user.memberVO.memZipCode}", // 더미 우편번호
	            orderAddress1: "${user.memberVO.memAddress1}", // 더미 주소
	            orderAddress2: "${user.memberVO.memAddress2}", // 더미 상세 주소
	            orderEmail: "${user.memberVO.peoEmail}", // 더미 이메일
	            orderMemo: `멤버십 상품 구매 - 아티스트 그룹 번호 : \${artistGroupNo}`
		};

// 		console.log("카카오페이 결제 준비 요청 데이터 : ", orderData);

		const headers = {
				'Content-Type':'application/json'
		};

		if (csrfToken && csrfHeaderName) { // null 체크 후 할당
		    headers[csrfHeaderName] = csrfToken;
		}

		// 2. 백엔드 API 호출
		fetch('/goods/order/pay/ready', {
			method: 'POST',
			headers: headers,
			body: JSON.stringify(orderData)
		})
		.then(response => {
			if(!response.ok) {
				return response.text().then(errorMessage => {
					console.error("백엔드 오류 응답: ", errorMessage);
				});
			}
			return response.json();
		})
		.then(data => {
			const nextRedirectUrl = data.next_redirect_pc_url;

			if(nextRedirectUrl) {
// 				console.log("카카오페이 결제 페이지로 리다이렉트: ", nextRedirectUrl);
				window.location.href = nextRedirectUrl;
				localStorage.setItem("url",window.location.href);

			} else {
// 				console.log("카카오페이 리다이렉트 URL을 받지 못했습니다. 데이터: ", data);
			}
		})
		.catch(error => {
			console.log("카카오페이 결제 준비 중 예외 발생: ", error.message);
		})
	};

});


// 방송하기 관련 스크립는 별도의js를 import 합니다. 하단에 있음.

function fullCalendar(artGroupNo){
	var calendarEl = document.getElementById('calendar');
	var calendar = new FullCalendar.Calendar(calendarEl,{
		height : 'auto',
		initialView : 'dayGridMonth',
		handleWindowResize : true,
		locale : 'ko',
		buttonText : {
			today : '오늘',
			month : '달',
			week : '이번주'
		},
		events : {
			url : '/community/fullcalendar/event/' + artGroupNo,
			type : 'get',
			success : function(res){
				return res;
			}
		},
		eventDidMount: function(info) {

			let { title, allDay, extendedProps, startStr,endStr} = info.event;
			let { place, content } = extendedProps;
			let startDate = fulldateFormat(startStr)
			let endDate = fulldateFormat(endStr)
			let formattedDate = "";
			if(allDay){
				formattedDate = startDate;
			}else{
				formattedDate = `\${startDate} ~ \${endDate}`;
			}
			tooltipHtml = `
				<div> 제 목 : \${title}</div>
				<div> 장 소 : \${place}</div>
				<div> 내 용 : \${content}</div>
				<div> 시 간 : \${formattedDate}</div>
			`;
			var tooltip = new bootstrap.Tooltip(info.el, {
			   title : tooltipHtml,
			html : true,
			   placement: 'top',
			   trigger: 'hover',
			   container: 'body'
			});
	    },
	    headerToolbar : {
			start : 'prevYear,prev,next,nextYear today',
			center : 'title',
			end : 'dayGridMonth,dayGridWeek'
		},
		eventClick : function(e){
        	e.jsEvent.cancelBubble = true;		// 일정에 있는 url 막기
        	e.jsEvent.preventDefault();

        	const detailModal = new bootstrap.Modal(document.getElementById('scheduleModal'));

        	detailModal.show(e);
        },
	});
	calendar.render();
}

function fulldateFormat(jsonDate){
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

    return month + "월 " + day + "일 " + hour + "시" + minute + "분";
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

    return month + '.' + day + ". " + hour + ":" + minute;
}

let infiniteOb;

function artistPostList(data){
	let artGroupNo = data.artGroupNo;
	$.ajax({
		url : "/community/gate/" + artGroupNo + "/apt/api",
		type : "get",
		data : data,
		success : function(res){
			let tab = res.tab;
			let pagingVO = res.pagingVO;
			let artistGroupVO = res.artistGroupVO;
			let artistList = artistGroupVO.artistList;
			let { userProfile, followFlag } = res;

			let searchId;
			if(tab){
				searchId = "artistFeedSearchInput";
			}else{
				searchId = "fanFeedSearchInput";
			}

			let searchHtml = `
				<form id="artistSearchForm">
					<div class="searchArea">
						<input type="hidden" id="comuArtGroupNo" value="\${artistGroupVO.artGroupNo }" />
						<input type="hidden" id="artistTabYn" name="artistTabYn" value="\${tab }" />
						<input type="hidden" name="searchType" id="searchType" />
						<input type="search" name="searchWord" id="\${searchId}"
			`;

			if(pagingVO.searchWord != null){
				searchHtml += `value="\${pagingVO.searchWord }"`;
			}

			searchHtml += `
						placeholder="게시글 검색 (제목)" style="flex:1; padding:7px 10px; border:1px solid #ccc; border-radius:6px; font-size:0.95em;">
						<input type="button" id="searchFormBtn" class="btn btn-primary" value="검색" />
					</div>
				`;

			if(tab){
				searchHtml += `
					<div class="radioBtnArea">
						<input type="radio" class="btn-check" name="artistNm" id="all" value=""`;
				if(pagingVO.searchType == null || pagingVO.searchType == ''){
					searchHtml += `checked`;
				}
				searchHtml += `/>
					<label class="btn btn-outline-primary" for="all">전체</label>
				`;
				for(let i=0; i<artistList.length; i++){

					let artist = artistList[i];
					let checked;
					if(pagingVO.searchType != null && pagingVO.searchType != 'undefined'){

						if(artist.memUsername == pagingVO.searchType){
							checked = `<input type="radio" class="btn-check" name="artistNm" id="\${artist.artNm }" value="\${artist.memUsername }" checked />`;
						}else{
							checked = `<input type="radio" class="btn-check" name="artistNm" id="\${artist.artNm }" value="\${artist.memUsername }" />`;
						}

					}else{
						checked = `<input type="radio" class="btn-check" name="artistNm" id="\${artist.artNm }" value="\${artist.memUsername }" />`;
					}

					searchHtml += `
						\${checked}
						<label class="btn btn-outline-primary" for="\${artist.artNm }">\${artist.artNm }</label>

					`;
				}

				searchHtml += `
						</div>
					</form>`;

				$("#artistFeedSearchWrap").html(searchHtml);
			}else{
				searchHtml += `</form>`;

				$("#fanFeedSearchWrap").html(searchHtml);
			}

			// 아티스트 탭일 때
			if(tab){
				let artistPostVO = res.artistPostVO;

				let postHtml = ``;
				if(artistPostVO.length > 0 && artistPostVO != null){
					for(let i=0; i<artistPostVO.length; i++){
						let post = artistPostVO[i];
						let postModDate = dateFormat(post.comuPostModDate);
						let postRegDate = dateFormat(post.comuPostRegDate);

						let blurPostYn;
						if(userProfile == null || post.comuPostMbspYn == 'Y' && userProfile.memberShipYn == 'N'){
							blurPostYn = 'Y';
						}else{
							blurPostYn = 'N';
						}

						if(userProfile == null){
							if(post.comuPostMbspYn == 'Y'){
								blurPostYn = 'Y';
							}else{
								blurPostYn = 'N';
							}
						}else {
							if(post.comuPostMbspYn == 'Y' && userProfile.memberShipYn == 'N'){
								blurPostYn = 'Y';
							}else{
								blurPostYn = 'N';
							}
						}

						let lastPost;

						if(i === artistPostVO.length - 1 && tab){
							lastPost = "lastPost";
						}

						postHtml += `
							<div class="feed-item feedBox \${lastPost}"  data-post-id="\${post.comuPostNo }" >
								<div class="feed-item-header">
								<a href="/community/\${post.artGroupNo}/profile/\${post.comuProfileNo}" id="profileLink" class="postProfile">
									<div class="author-avatar" style="background-color:'#8a2be2'; color:'#fff';"><img src="\${post.writerProfile.comuProfileImg }"></div>
									<div class="author-info">
										<span class="author-name" style="color:'#8a2be2';">\${post.writerProfile.comuNicknm}</span>
										<span class="post-time">
										`;
						if(post.comuPostRegDate != post.comuPostModDate){
											postHtml += `\${postModDate} (수정됨) </span>`;
						}else{
											postHtml += `\${postRegDate} </span>`;
						}

						if(post.memberShipYn){
											postHtml += `<span class="membership-badge" style="background:#8a2be2;color:#fff;padding:2px 6px;border-radius:10px;font-size:0.8em;margin-left:5px;">멤버십 전용</span>`;
						}
						postHtml += `
									</div>
								</a>

									<div class="post-options">
										<button id="dropCate" class="post-options-btn" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi bi-three-dots-vertical"></i></button>
										<ul class="dropdown-menu" aria-labelledby="dropCate">
									`;
						if(followFlag == 'Y'&&userProfile.memUsername == post.writerProfile.memUsername){
						postHtml += `
							<li><a class="dropdown-item" href="#" id="edit" data-bs-toggle="modal" data-bs-target="#editPostModal" data-bs-postNum="\${post.comuPostNo }" data-bs-categroy="listEdit">수정</a></li>
							<li><hr class="dropdown-divider"></li>
						    <li><a class="dropdown-item" href="#" id="delete" data-bs-postNum="\${post.comuPostNo }" data-bs-categroy="delete">삭제</a></li>
						`;
						}else{
						postHtml += `
							<li><a class="dropdown-item" href="#" id="reportPost"
									data-bs-toggle="modal"
									data-bs-target="#reportModal"
									data-bs-whatever="\${post.comuPostNo }"
									data-bs-boardType="\${post.boardTypeCode }"
									data-bs-comuProfileNo="\${post.comuProfileNo }"
									data-bs-comuNick="\${post.writerProfile.comuNicknm }"
									data-bs-comuContent="\${post.comuPostContent }"
									data-bs-selectType="RTTC001">신고</a></li>
						`;
						}
						postHtml += `
										</ul>
								</div>
								</div>
								<a href=`;
						if(blurPostYn == 'Y'){
							postHtml += `""`;
						}else{
							postHtml += `"#detailPostModal"`;
						}
							postHtml +=`id="postLink" data-bs-toggle="modal" data-bs-postNum="\${post.comuPostNo}" data-bs-membershipBlur="\${blurPostYn}">
						`;

						if(userProfile == null){
							if(post.memberShipYn){
								postHtml += `<div class="feed-item-content membership-blur" data-post-id="\${post.comuPostNo }" style="position:relative;">`;
							}else{
								postHtml += `<div class="feed-item-content" data-post-id="\${post.comuPostNo }" >`;
							}
						}else{
							if(post.memberShipYn && userProfile.memberShipYn == 'N'){
								postHtml += `<div class="feed-item-content membership-blur" data-post-id="\${post.comuPostNo }" style="position:relative;">`;
							}else{
								postHtml += `<div class="feed-item-content" data-post-id="\${post.comuPostNo }" >`;
							}
						}

						postHtml += `

										<form id="postForm\${i }" data-postNum="\${post.comuPostNo }">
											<div class="openPostModal" id="openPostModal" data-postNum=\${post.comuPostNo }>
						`;

						if(post.postFiles != null && post.postFiles.length > 0){
							postHtml += `<div class="post-img">`;
							for(let j=0; j<post.postFiles.length; j++){
								let postFile = post.postFiles[j];
								postHtml += `<img src="\${postFile.webPath }">`;
							}
							postHtml += `</div>`;
						}

						postHtml += `
												<div class="post-text" id="artistPostViewer">\${post.comuPostContent}</div>
											</div>
										</form>

									</div>
									<div class="feed-item-actions">
										<button class="action-btn comment-toggle-btn"><i class="bi bi-chat-left-dots"></i> 댓글 <span class="count"> \${post.comuPostReplyCount }</span></button>
									</a>
										<button class="action-btn comment-toggle-btn" id="postListLike"
											data-board-type-code="\${post.boardTypeCode}"
											data-comu-post-no="\${post.comuPostNo}">
						`;

						if(post.likeYn == 'N'){
							postHtml += `<i class="bi bi-heart"><span id="likeCount">\${post.comuPostLike }</span></i>`;
						}else{
							postHtml += `<i class="bi bi-heart-fill"><span id="likeCount">\${post.comuPostLike }</span></i>`;
						}

						postHtml += `
										</button>
									</div>
								</div>
							</div>
						</a>
						</div>
						`;
					}
				}else{	// 게시물이 하나도 없을 때
					postHtml += `
					<div class="noSearchPostList">
						<i class="bi bi-exclamation-circle"></i> 조회가능한 게시물이 없습니다.
					</div>
				`;
				}

				$("#artistFeedList").html(postHtml);

			}else{

				let fanPostVO = res.fanPostVO;

				let postHtml = ` `;
				$("#artistFeedList").html(postHtml);
				if(fanPostVO.length > 0 && fanPostVO != null){
					for(let i=0; i<fanPostVO.length; i++){
						let post = fanPostVO[i];
						let postModDate = dateFormat(post.comuPostModDate);
						let postRegDate = dateFormat(post.comuPostRegDate);


						let lastPost;

						if(i === fanPostVO.length - 1){
							lastPost = "lastPost";
						}

						postHtml += `
							<div class="feed-item feedBox \${lastPost}" data-post-id="\${post.comuPostNo }">
							<div class="feed-item-header">
								<a href="/community/\${post.artGroupNo}/profile/\${post.comuProfileNo}"  class="postProfile">
								<div class="author-avatar" style="background-color:'#8a2be2'; color:'#fff';"><img src="\${post.writerProfile.comuProfileImg }"></div>
								<div class="author-info">
									<span class="author-name" style="color:'#8a2be2';">\${post.writerProfile.comuNicknm}</span>
									<span class="post-time">
						`;

						if(post.comuPostRegDate != post.comuPostModDate){
							postHtml += `\${postModDate} (수정됨) </span>`;
						}else{
							postHtml += `\${postRegDate} </span>`;
						}

						postHtml += `
									</div>
								</a>
									<div class="post-options">
										<button id="dropCate" class="post-options-btn" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi bi-three-dots-vertical"></i></button>
										<ul class="dropdown-menu" aria-labelledby="dropCate">
						`;
						if(userProfile.memUsername == post.writerProfile.memUsername){
						postHtml += `
							<li><a class="dropdown-item" href="#" id="edit" data-bs-toggle="modal" data-bs-target="#editPostModal" data-bs-postNum="\${post.comuPostNo }" data-bs-categroy="listEdit">수정</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item" href="#" id="delete" data-bs-postNum="\${post.comuPostNo }" data-bs-categroy="delete">삭제</a></li>
						`;
						}else{
						postHtml += `
							<li><a class="dropdown-item" href="#" id="reportPost"
									data-bs-toggle="modal"
									data-bs-target="#reportModal"
									data-bs-whatever="\${post.comuPostNo }"
									data-bs-boardType="\${post.boardTypeCode }"
									data-bs-comuProfileNo="\${post.comuProfileNo }"
									data-bs-comuNick="\${post.writerProfile.comuNicknm }"
									data-bs-comuContent="\${post.comuPostContent }"
									data-bs-selectType="RTTC001">신고</a></li>
						`;
						}
						postHtml += `
										</ul>
									</div>
								</div>
							<div class="feed-item-content" data-post-id="\${post.comuPostNo }" >
								<a href="#detailPostModal" data-bs-toggle="modal" data-bs-postNum="\${post.comuPostNo}">
									<form id="postForm\${i }" data-postNum="\${post.comuPostNo }">
										<div class="openPostModal" id="openPostModal" data-postNum=\${post.comuPostNo }>
						`;

						if(post.postFiles != null && post.postFiles.length > 0){
							postHtml += `<div class="post-img">`;
							for(let j=0; j<post.postFiles.length; j++){
								let postFile = post.postFiles[j];
								postHtml += `<img src="\${postFile.webPath }">`;
							}
							postHtml += `</div>`;
						}

						postHtml += `
							<div class="post-text" id="artistPostViewer">\${post.comuPostContent}</div>
								</div>
							</form>

							</div>
							<div class="feed-item-actions">
								<button class="action-btn comment-toggle-btn"><i class="bi bi-chat-left-dots"></i> 댓글 <span class="count">\${post.comuPostReplyCount }</span></button>
							</a>
								<button class="action-btn comment-toggle-btn" id="postListLike"
									data-board-type-code="\${post.boardTypeCode}"
									data-comu-post-no="\${post.comuPostNo}">
							`;

						if(post.likeYn == 'N'){
							postHtml += `<i class="bi bi-heart"><span id="likeCount">\${post.comuPostLike }</span></i>`;
						}else{
							postHtml += `<i class="bi bi-heart-fill"><span id="likeCount">\${post.comuPostLike }</span></i>`;
						}

						postHtml += `
										</button>
									</div>
								</div>
							</div>
						</a>
						`;

					}

				}else{
					postHtml += `
						<div class="noSearchPostList">
							<i class="bi bi-exclamation-circle"></i> 조회가능한 게시물이 없습니다.
						</div>
					`;
				}

				$("#fanFeedList").html(postHtml);
			}

			let last = document.querySelector('.feed-item.lastPost');

			let flag = false;
			infiniteOb = new IntersectionObserver((entries) => {
			  entries.forEach(entry => {
				    if(entry.isIntersecting){
				    	if(!flag){
					    	setupInfiniteScrollObserver(res, last);
				    		flag = true;
				    	}else{
				    		last = document.querySelector('.feed-item.lastPost');
				    		infiniteOb.disconnect();
				    		infiniteOb.unobserve(last);
				    	}
				    }
			  });
			});

			infiniteOb.observe(last);

		},
		error : function(error){
			console.log(error);
		}
	})
}

function infinitePost(res){

	let artistTabYn = res.tab;
	let page = res.pagingVO.currentPage + 1;
	let searchWord;
	let searchType;
	let artGroupNo = res.artistGroupVO.artGroupNo;

	if(artistTabYn){
		searchWord = $("#artistFeedSearchInput").val();
	}else{
		searchWord = $("#fanFeedSearchInput").val();
	}

	let data = {
		"page" : page,
		"searchWord" : searchWord,
		"searchType" : searchType,
		"artistTabYn" : artistTabYn,
		"artGroupNo" : artGroupNo
	}

	$.ajax({
		url : "/community/gate/" + artGroupNo + "/apt/api",
		type : 'get',
		data : data,
		success : function(response){
			let tab = response.tab;
			let pagingVO = response.pagingVO;
			let artistGroupVO = response.artistGroupVO;
			let artistList = artistGroupVO.artistList;
			let { userProfile, followFlag } = response;

			if(tab){
				let artistPostVO = response.artistPostVO;

				if(artistPostVO.length > 0 && artistPostVO != null){
					let postHtml = ``;
					if(artistPostVO.length > 0 && artistPostVO != null){
						for(let i=0; i<artistPostVO.length; i++){
							let post = artistPostVO[i];
							let postModDate = dateFormat(post.comuPostModDate);
							let postRegDate = dateFormat(post.comuPostRegDate);

							let blurPostYn;
							if(userProfile == null){
								if(post.comuPostMbspYn === 'Y'){
									blurPostYn = 'Y';
								}else{
									blurPostYn = 'N';
								}
							}else {
								if(post.comuPostMbspYn == 'Y' && userProfile.memberShipYn == 'N'){
									blurPostYn = 'Y';
								}else{
									blurPostYn = 'N';
								}
							}

							let lastPost;

							if(i === artistPostVO.length - 1){
								lastPost = "lastPost";
							}

							postHtml += `
								<div class="feed-item feedBox \${lastPost}"  data-post-id="\${post.comuPostNo }" >
									<div class="feed-item-header">
									<a href="/community/\${post.artGroupNo}/profile/\${post.comuProfileNo}" id="profileLink" class="postProfile">
										<div class="author-avatar" style="background-color:'#8a2be2'; color:'#fff';"><img src="\${post.writerProfile.comuProfileImg }"></div>
										<div class="author-info">
											<span class="author-name" style="color:'#8a2be2';">\${post.writerProfile.comuNicknm}</span>
											<span class="post-time">
											`;
							if(post.comuPostRegDate != post.comuPostModDate){
												postHtml += `\${postModDate} (수정됨) </span>`;
							}else{
												postHtml += `\${postRegDate} </span>`;
							}

							if(post.memberShipYn){
												postHtml += `<span class="membership-badge" style="background:#8a2be2;color:#fff;padding:2px 6px;border-radius:10px;font-size:0.8em;margin-left:5px;">멤버십 전용</span>`;
							}
							postHtml += `
										</div>
									</a>

										<div class="post-options">
											<button id="dropCate" class="post-options-btn" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi bi-three-dots-vertical"></i></button>
											<ul class="dropdown-menu" aria-labelledby="dropCate">
										`;
							if(userProfile.memUsername == post.writerProfile.memUsername){
							postHtml += `
								<li><a class="dropdown-item" href="#" id="edit" data-bs-toggle="modal" data-bs-target="#editPostModal" data-bs-postNum="\${post.comuPostNo }" data-bs-categroy="listEdit">수정</a></li>
								<li><hr class="dropdown-divider"></li>
							    <li><a class="dropdown-item" href="#" id="delete" data-bs-postNum="\${post.comuPostNo }" data-bs-categroy="delete">삭제</a></li>
							`;
							}else{
							postHtml += `
								<li><a class="dropdown-item" href="#" id="reportPost"
										data-bs-toggle="modal"
										data-bs-target="#reportModal"
										data-bs-whatever="\${post.comuPostNo }"
										data-bs-boardType="\${post.boardTypeCode }"
										data-bs-comuProfileNo="\${post.comuProfileNo }"
										data-bs-comuNick="\${post.writerProfile.comuNicknm }"
										data-bs-comuContent="\${post.comuPostContent }"
										data-bs-selectType="RTTC001">신고</a></li>
							`;
							}
							postHtml += `
											</ul>
									</div>
									</div>
									<a href=`;
							if(blurPostYn == 'Y'){
								postHtml += `""`;
							}else{
								postHtml += `"#detailPostModal"`;
							}
								postHtml +=`id="postLink" data-bs-toggle="modal" data-bs-postNum="\${post.comuPostNo}" data-bs-membershipBlur="\${blurPostYn}">
							`;

							if(userProfile == null){
								if(post.memberShipYn){
									postHtml += `<div class="feed-item-content membership-blur" data-post-id="\${post.comuPostNo }" style="position:relative;">`;
								}else{
									postHtml += `<div class="feed-item-content" data-post-id="\${post.comuPostNo }" >`;
								}
							}else{
								if(post.memberShipYn && userProfile.memberShipYn == 'N'){
									postHtml += `<div class="feed-item-content membership-blur" data-post-id="\${post.comuPostNo }" style="position:relative;">`;
								}else{
									postHtml += `<div class="feed-item-content" data-post-id="\${post.comuPostNo }" >`;
								}
							}

							postHtml += `

											<form id="postForm\${i }" data-postNum="\${post.comuPostNo }">
												<div class="openPostModal" id="openPostModal" data-postNum=\${post.comuPostNo }>
							`;

							if(post.postFiles != null && post.postFiles.length > 0){
								postHtml += `<div class="post-img">`;
								for(let j=0; j<post.postFiles.length; j++){
									let postFile = post.postFiles[j];
									postHtml += `<img src="\${postFile.webPath }">`;
								}
								postHtml += `</div>`;
							}

							postHtml += `
													<div class="post-text" id="artistPostViewer">\${post.comuPostContent}</div>
												</div>
											</form>

										</div>
										<div class="feed-item-actions">
											<button class="action-btn comment-toggle-btn"><i class="bi bi-chat-left-dots"></i> 댓글 <span class="count">\${post.comuPostReplyCount }</span></button>
										</a>
											<button class="action-btn comment-toggle-btn" id="postListLike"
												data-board-type-code="\${post.boardTypeCode}"
												data-comu-post-no="\${post.comuPostNo}">
							`;

							if(post.likeYn == 'N'){
								postHtml += `<i class="bi bi-heart"><span id="likeCount">\${post.comuPostLike }</span></i>`;
							}else{
								postHtml += `<i class="bi bi-heart-fill"><span id="likeCount">\${post.comuPostLike }</span></i>`;
							}

							postHtml += `
											</button>
										</div>
									</div>
								</div>
							</a>
							</div>
							`;
						}
					}

					$("#artistFeedList").append(postHtml);

				}else{
					return;
				}


			}else{

				let fanPostVO = response.fanPostVO;

				if(fanPostVO.length > 0 && fanPostVO != null){
					let postHtml = ``;
					$("#artistFeedList").html(postHtml);
					if(fanPostVO.length > 0 && fanPostVO != null){
						for(let i=0; i<fanPostVO.length; i++){
							let post = fanPostVO[i];
							let postModDate = dateFormat(post.comuPostModDate);
							let postRegDate = dateFormat(post.comuPostRegDate);


							let lastPost;

							if(i === fanPostVO.length - 1){
								lastPost = "lastPost";
							}

							postHtml += `
								<div class="feed-item feedBox \${lastPost}" data-post-id="\${post.comuPostNo }">
								<div class="feed-item-header">
									<a href="/community/\${post.artGroupNo}/profile/\${post.comuProfileNo}"  class="postProfile">
									<div class="author-avatar" style="background-color:'#8a2be2'; color:'#fff';"><img src="\${post.writerProfile.comuProfileImg }"></div>
									<div class="author-info">
										<span class="author-name" style="color:'#8a2be2';">\${post.writerProfile.comuNicknm}</span>
										<span class="post-time">
							`;

							if(post.comuPostRegDate != post.comuPostModDate){
								postHtml += `\${postModDate} (수정됨) </span>`;
							}else{
								postHtml += `\${postRegDate} </span>`;
							}

							postHtml += `
										</div>
									</a>
										<div class="post-options">
											<button id="dropCate" class="post-options-btn" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi bi-three-dots-vertical"></i></button>
											<ul class="dropdown-menu" aria-labelledby="dropCate">
							`;
							if(userProfile.memUsername == post.writerProfile.memUsername){
							postHtml += `
								<li><a class="dropdown-item" href="#" id="edit" data-bs-toggle="modal" data-bs-target="#editPostModal" data-bs-postNum="\${post.comuPostNo }" data-bs-categroy="listEdit">수정</a></li>
								<li><hr class="dropdown-divider"></li>
								<li><a class="dropdown-item" href="#" id="delete" data-bs-postNum="\${post.comuPostNo }" data-bs-categroy="delete">삭제</a></li>
							`;
							}else{
							postHtml += `
								<li><a class="dropdown-item" href="#" id="reportPost"
										data-bs-toggle="modal"
										data-bs-target="#reportModal"
										data-bs-whatever="\${post.comuPostNo }"
										data-bs-boardType="\${post.boardTypeCode }"
										data-bs-comuProfileNo="\${post.comuProfileNo }"
										data-bs-comuNick="\${post.writerProfile.comuNicknm }"
										data-bs-comuContent="\${post.comuPostContent }"
										data-bs-selectType="RTTC001">신고</a></li>
							`;
							}
							postHtml += `
											</ul>
										</div>
									</div>
								<div class="feed-item-content" data-post-id="\${post.comuPostNo }" >
									<a href="#detailPostModal" data-bs-toggle="modal" data-bs-postNum="\${post.comuPostNo}">
										<form id="postForm\${i }" data-postNum="\${post.comuPostNo }">
											<div class="openPostModal" id="openPostModal" data-postNum=\${post.comuPostNo }>
							`;

							if(post.postFiles != null && post.postFiles.length > 0){
								postHtml += `<div class="post-img">`;
								for(let j=0; j<post.postFiles.length; j++){
									let postFile = post.postFiles[j];
									postHtml += `<img src="\${postFile.webPath }">`;
								}
								postHtml += `</div>`;
							}

							postHtml += `
								<div class="post-text" id="artistPostViewer">\${post.comuPostContent}</div>
									</div>
								</form>

								</div>
								<div class="feed-item-actions">
									<button class="action-btn comment-toggle-btn"><i class="bi bi-chat-left-dots"></i> 댓글 <span class="count">\${post.comuPostReplyCount }</span></button>
								</a>
									<button class="action-btn comment-toggle-btn" id="postListLike"
										data-board-type-code="\${post.boardTypeCode}"
										data-comu-post-no="\${post.comuPostNo}">
								`;

							if(post.likeYn == 'N'){
								postHtml += `<i class="bi bi-heart"><span id="likeCount">\${post.comuPostLike }</span></i>`;
							}else{
								postHtml += `<i class="bi bi-heart-fill"><span id="likeCount">\${post.comuPostLike }</span></i>`;
							}

							postHtml += `
											</button>
										</div>
									</div>
								</div>
							</a>
							`;

						}

					}

					$("#fanFeedList").append(postHtml);



				}else{
					return;
				}

				let newLast = document.querySelector('.feed-item.lastPost');

				infiniteOb = new IntersectionObserver((entries) => {
				  entries.forEach(entry => {
					    if(entry.isIntersecting && response.pagingVO.currentPage != response.pagingVO.totalPage){
					    	setupInfiniteScrollObserver(response, newLast);
					    }
				  });
				});

				infiniteOb.observe(newLast);
			}
		},
		error : function(error){
			console.log(error.status);
            isLoading = false; // 에러 발생 시 로딩 플래그 해제
            $("#loadingSpinner").hide(); // 로딩 스피너 숨김
            hasMore = false; // 에러 발생 시 더 이상 로드하지 않음
            if (infiniteOb) { // 에러 발생 시 옵저버 연결 해제
                infiniteOb.disconnect();
            }
		}
	});
}

//--- Intersection Observer 설정 함수 (새로 추가) ---
//이 함수는 게시물 목록이 새로 로드되거나 검색될 때마다 호출되어야 합니다.
function setupInfiniteScrollObserver(res, last) {
	 // 기존 옵저버가 있다면 연결 해제
	 if (infiniteOb) {
	     infiniteOb.disconnect();
	 }

	 infiniteOb = new IntersectionObserver((entries, observer) => {
	     entries.forEach(entry => {
	         if (entry.isIntersecting) {
	             entry.target = last;
	             $(last).removeClass("lastPost");
	             $(last).addClass("undefined");
	             infiniteOb.unobserve(last);
	             infinitePost(res);
	         }
	     });
	 });

	 infiniteOb.observe(last);

}


//상세 모달 창에서 좋아요 버튼 클릭 시
function likeBtn(e){
	let icon = e.children('i');
	let like = e.children('span');

	let iconAttr = icon.attr("class")
	let likeCount = e.children('span').html();

	let updateLikeCount;

	if(iconAttr === "bi bi-heart-fill"){
		icon.attr("class","bi bi-heart");
		updateLikeCount = parseInt(likeCount) - 1;
	}else{
		icon.attr("class","bi bi-heart-fill");
		updateLikeCount = parseInt(likeCount) + 1;
	}

	like.html(updateLikeCount);

}

//좋아요 수 업데이트
function likeUpdate(data){
	$.ajax({
		url : "/community/like/update",
		type : "post",
		data : data,
		processData : false,
		contentType : false,
		success : function(res){
			if(res == 'OK'){
				let boardTypeCode = data.get("boardTypeCode");
				let artistTabFlag = true;
				if (boardTypeCode == 'ARTIST_BOARD'){
					artistTabFlag = true;
				}else{
					artistTabFlag = false;
				}
				let param = {
					"artGroupNo" : $("#communityArtistGroupNo").val(),
					"artistTabYn" : artistTabFlag
				}
				artistPostList(param);
			}
		},
		error : function(error){
			console.log(error.status);
		},
		beforeSend : function(xhr){
			xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}')
		}
	});
}

function noticeList(data){
	let artGroupNo = data.artGroupNo;
	$.ajax({
		url : '/community/notice/' + artGroupNo,
		type : 'get',
		data : data,
		success : function(res){
			let pagingVO = res.pagingVO;
			let artistGroupVO = res.artistGroupVO;
			let noticeCodeVO = res.noticeCodeVO;
			let noticeList = pagingVO.dataList;

			let searchHtml = `
				<form id="noticeSearchForm">
					<div class="searchArea">
					   <input type="search" name="searchWord" id="noticeSearchWord"
			`;

			if(pagingVO.searchWord != null && pagingVO.searchWord != ''){
				searchHtml += `value="\${pagingVO.searchWord }"`;
			}else{
				searchHtml += `value="" `;
			}

			searchHtml += `
			   placeholder="공지사항 검색 (제목)" style="flex:1; padding:7px 10px; border:1px solid #ccc; border-radius:6px; font-size:0.95em;">
			   <input type="button" id="noticeSearchFormBtn" class="btn btn-primary" value="검색" />
					</div>
				<div class="radioBtnArea">
				<input type="radio" class="btn-check"name="searchType" id="noticeAll"  value=""
			`;

			if(pagingVO.searchType == null || pagingVO.searchType == ''){
				searchHtml += `checked`;
			}

			searchHtml += `
				/>
				<label class="btn btn-outline-primary" for="noticeAll">전체</label>
			`;
			for(let i=0; i<noticeCodeVO.length; i++){
				let code = noticeCodeVO[i];
				searchHtml += `
					<input type="radio" class="btn-check" name="searchType" id="\${code.commCodeDetNo }" value="\${code.commCodeDetNo }"
				`;
				if(code.commCodeDetNo == pagingVO.searchType){
					searchHtml += `checked/>`;
				}else{
					searchHtml += `/>`;
				}
				searchHtml += `<label class="btn btn-outline-primary" for="\${code.commCodeDetNo }"><c:out value="\${code.description }" /></label>`;

			}
			searchHtml += `
					</div>
				</form>
			`;

			$("#noticeSearchWarp").html(searchHtml);

			let date = new Date();
			let currentDay = date.getDate();

			let noticeListHtml = `
			<div class="noticeList-container">
			`;
			if(noticeList.length > 0 && noticeList != null){
				for(let i=0; i<noticeList.length; i++){
					let notice = noticeList[i];

					let noticeDate = new Date(notice.comuNotiRegDate);
					let noticeDay = noticeDate.getDate();

					let noticeRegDate = dateFormat(notice.comuNotiRegDate);
					noticeListHtml += `
					<div class="notice-container">
						<a href="/community/notice/post/\${notice.comuNotiNo }">
							<b><div>[\${notice.codeDescription} ]</div>`;
					noticeListHtml += `
							</b>
							<div class="noticeTitle-container">
								<span class="noticeTitle">\${notice.comuNotiTitle }</span>
								<div class="noticeDate">\${noticeRegDate}</div>
							</div>
						</a>
					</div>
					`;
				}
			}else{
				noticeListHtml += `
				<div class="noSearchPostList">
					<i class="bi bi-exclamation-circle"></i> 조회가능한 게시물이 없습니다.
				</div>
				`;
			}
			noticeListHtml += `</div>`;

			$("#noticeList").html(noticeListHtml);

			$("#noticePagingArea").html(pagingVO.pagingHTML);

		},
		error : function(error){
			console.log(error.status);
		}
	})
}

$(function(){

	let fileMap = new Map();	// 업로드한 파일 담을 객체
	let fileNum = 0;		// 업로드한 파일의 순번

	let upFile = new Map();	// 수정 중 업로드한 파일 담을 객체
	let upFileNum = 0;		// 수정 중 업로드한 파일의 순번

	let deleteFileList = [];	// 삭제할 파일의 상세번호
	let deleteFileGroupNo = new Map();	// 삭제할 파일의 그룹번호

	let likeFlag = false;	// 좋아요 버튼 클릭 여부
	let oldLikeCount;		//
	let newLikeCount;

	let artistTabFlag = true;

	// 초기 데이터 불러오기
	let first = {
		"artGroupNo" : $("#communityArtistGroupNo").val(),
	}
	artistPostList(first);
	// 초기 데이터 불러오기 끝

	// 아티스트 탭 클릭 시
	$("#artistPost").on("shown.bs.tab",function(){
		let newHash = "artistPostList";
		window.location.hash = newHash;
		artistTabFlag = true;
		let data = {
			"artGroupNo" : $("#communityArtistGroupNo").val(),
			"artistTabYn" : artistTabFlag
		}
		artistPostList(data);

	});


	$("button","#comuTab").on("show.bs.tab",function(e){
		if("${followFlag}" == 'N'){
			sweetAlert("error","팔로우 후 사용 가능합니다!")
			e.preventDefault();
			return false;
		}
	})

	// 팬탭 클릭 시
	$("#fanPost").on("shown.bs.tab",function(e){
			let newHash = "fanPostList";
			window.location.hash = newHash;
			artistTabFlag = false;
			let data = {
				"artGroupNo" : $("#communityArtistGroupNo").val(),
				"artistTabYn" : artistTabFlag
			}
			artistPostList(data);
	});

	// 스케줄 클릭 시
	$("#schedule").on("shown.bs.tab",function(){
		let newHash = "scheduleList";
		window.location.hash = newHash;
		let artGroupNo = $("#communityArtistGroupNo").val();
		fullCalendar(artGroupNo);
	});

	// 공지사항 클릭 시
	$("#noticeApt").on("shown.bs.tab",function(){
		let newHash = "noticeAptList";
		window.location.hash = newHash;
		let data ={
			"artGroupNo" : $("#communityArtistGroupNo").val()
		}
		noticeList(data);
	});

	// 게시글 댓글 목록에서 하트 클릭 시 반영
	$(".feedList").on("click","button[id=postListLike]" ,function(){
		let curLikeClass = $(this).children("i")[0].className;	// 클릭한 하트의 클래스 이름
		let curLikeCount = $(this).children("i").children("span")[0].innerHTML;	// 클릭한 하트의 카운트

		let updateCount;	// 클릭 후 변경될 숫자 객체

		let pm = 0;
		if(curLikeClass == 'bi bi-heart'){		// 클릭한 하트의 클래스가 bi bi-heart 라면
			$(this).children("i")[0].className = "bi bi-heart-fill";
			updateCount = parseInt(curLikeCount) + 1;
			pm++;
		}else{		// 클릭한 하트의 클래스가 bi bi-heart 라면
			$(this).children("i")[0].className = "bi bi-heart";
			updateCount = parseInt(curLikeCount) - 1;
			pm--;
		}

		// 새로운 카운트 수 화면상 바꿔줌
		$(this).children("i").children("span")[0].innerHTML = updateCount;

		// 선택한 하트에 담긴 데이터들 가져옴
		let boardTypeCode = $(this)[0].dataset.boardTypeCode;
		let comuPostNo = $(this)[0].dataset.comuPostNo;
		let artGroupNo = $("#communityArtistGroupNo").val()

		// formdata로 묶어서 likeUpdate로 보냄
		let data = new FormData();
		data.append("comuPostNo",comuPostNo);
		data.append("boardTypeCode",boardTypeCode);
		data.append("artGroupNo",artGroupNo);
		data.append("insertDelete", pm);

		likeUpdate(data);
	});

	// 게시글 목록에서 수정버튼을 눌렀을 때
	$("#editPostModal").on("show.bs.modal",function(e){
		let postNum = e.relatedTarget.getAttribute('data-bs-postNum');
		updateModalInfo(postNum);
	});


	// 수정 모달에 있는 파일 영역에 i태그 클릭 시 (파일 삭제)
	// 수정중111
	$("#editImgArea").on("click","button",function(){
		let pr = $(this).parent("div").remove();

		// 수정 이미지 영역에 이미지 element
		let img = $(this).parent('div').find('img')[0];

		if(img.dataset.filenum != null){
			deleteFileList.push(img.dataset.filenum);	// 삭제할 파일 리스트에 삭제한 파일의 상세번호를 넣음
		}
		deleteFileGroupNo.set(img.dataset.filegroupno,deleteFileList);	// 삭제할 파일 리스트를 삭제할 파일의 그룹번호를 키로 설정하고 안에 삭제할 파일 리스트를 넣음
	});

	// 게시글 수정 전송 버튼 클릭 시
	$("#postUpdateBtn").on("click",function(){

		Swal.fire({
			title : '수정요청',
			text : '이전에 작성된 내용은 복구가 불가합니다. 수정하시겠습니까?',
			icon : 'question',
			showCancelButton : true,
			cancelButtonText : '아니오',
			confirmButtonText : '예',
		}).then((result) => {
			if(result.isConfirmed){
				// 아티스트 탭인지 구분
				let tabCheck = $("#artistTabYn").val();
				if(tabCheck){
					let checkeded = $("#editPostMemberShipYn").is(':checked');
					$("#editMemberShipYn").val(checkeded);
				}

				let artGroupNo = $("#communityArtistGroupNo").val();

				if(deleteFileList != null && deleteFileList.length > 0){
					$("#deleteFiles").val(deleteFileList);
				}

				// 폼 데이터로 보내주기 위함
				let editPostForm = document.getElementById("editPostForm");

				let data = new FormData(editPostForm);

				$.ajax({
					url : "/community/update/post",
					type : "post",
					data : data,
					processData : false,
					contentType : false,
					success : function(res){
						if(res == "OK"){
							Swal.fire({
								title : '수정 성공!',
								text : '게시글이 성공적으로 수정이 완료되었습니다!',
								icon : 'success'
							}).then((result) => {
								$("#editPostModal").modal('hide');
								let data = {
									"artGroupNo" : $("#communityArtistGroupNo").val(),
									"artistTabYn" : artistTabFlag
								}
								artistPostList(data);
							});
						}else{
							Swal.fire({
								title : '수정 실패',
								text : '수정이 실패되었습니다. 실패 반복시 관리자에게 문의바랍니다.',
								icon : 'error'
							})
						}

					},
					error : function(error){
						console.log(error.status);
					},
					beforeSend : function(xhr) {
				        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
				    }
				})
			}
		})


	});

	// 게시글 목록에서 삭제 버튼 클릭 시
	$(".feedList").on("click","a[id=delete]",function(e){
		e.preventDefault();

		let postNum = e.target.dataset.bsPostnum;

		let artGroupNo = $("#communityArtistGroupNo").val();

		let data = new FormData();
		data.append("artGroupNo",artGroupNo);
		data.append("comuPostNo",postNum);

		Swal.fire({
			title : "삭제 요청",
			text : '게시글을 삭제하시겠습니까? 삭제된 게시글은 복구가 불가합니다',
			icon : "question",
			showCancelButton : true,
			cancelButtonText : "아니오",
			confirmButtonText : "예"
		}).then((result) => {
			if(result.isConfirmed){
				$.ajax({
					url : "/community/delete/post/" + postNum,
					type : "post",
					data : data,
					contentType : false,
					processData : false,
					success : function(res){
						if(res == "OK"){
							Swal.fire({
								title : '삭제 완료',
								text : '정상적으로 삭제가 되었습니다.',
								icon : "success"
							})

							let param = {
								"artGroupNo" : $("#communityArtistGroupNo").val(),
								"artistTabYn" : artistTabFlag
							}

							artistPostList(param);
						}else{
							alert("게시글이 삭제가 되지 않았습니다.");
						}
					},
					error : function(error){
						console.log(error.status);
					},
					beforeSend : function(xhr) {
				        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
				    }
				})
			}
		});

	});


	// 닫기 버튼 행동제어
	$("#editPostModal").on("shown.bs.modal",function(e){
		let editBtnInfo = e.relatedTarget.getAttribute("data-bs-categroy");
		let closeBtn = $("#editPostModal").find("button[id=postUpdateCloseBtn]");

		// 상세 모달에서 수정 버튼 클릭 시 아래의 속성을 추가 시켜줌으로 닫기 버튼 눌렀을 떄
		// 다시 상세모달이 오픈됨
		if(editBtnInfo === 'detailEdit'){
			$("#editPostModal").children("div[class=modal-footer]").children("button[class=btn-secondary]");
			closeBtn.attr("data-bs-target","#detailPostModal");
			closeBtn.attr("data-bs-toggle","modal");
		}else{
			// 받아온 editBtnInfo가 detailEdit이 아니라면 해당 속성을 넣었던 걸 지워줌
			closeBtn.removeAttr("data-bs-target");
			closeBtn.removeAttr("data-bs-toggle");
		}
	});

	// 수정모달 취소 버튼 클릭 시
	$("#postUpdateCloseBtn").on("click",function(){
		updatePostModalClose();
	});

	// 수정모달 헤더 취소 버튼 클릭 시
	$("#editPostModalHeaderCloseBtn").on("click",function(){
		updatePostModalClose();
	});

	// 등록 모달에서 취소 버튼 클릭 시
	$("#addPostModalCloseBtn").on("click",function(){
		insertPostModalClose();
	});

	// 등록모달 헤더 x버튼 클릭 시
	$("#insertModalHeaderCloseBtn").on("click",function(){
		insertPostModalClose();
	});

	// 댓글 작성
	$("#replyBtn").on("click", function(e){
		e.preventDefault();
		let content = $("#comuReplyContent");
		if(content.val().trim() == null || content.val().trim() == ""){
			Swal.fire({
				title : '작성 필요!',
				text : '댓글을 작성해주세요.',
				icon : 'warning'
			});
			return false;
		}

		let detailModal = document.getElementById("detailPostModal");
		let myDetailModal = bootstrap.Modal.getInstance(detailModal);

		myDetailModal.hide();

		let replyForm = document.getElementById("replyForm");

		let data = new FormData(replyForm);

		$.ajax({
			url : "/community/reply/insert",
			type : "post",
			data : data,
			processData : false,
			contentType : false,
			success : function(res){
				if(res.result == "OK"){

					let data = {
						"artGroupNo" : $("#communityArtistGroupNo").val(),
						"artistTabYn" : artistTabFlag
					}

					artistPostList(data);

					let detailModalReOpen = document.getElementById("detailPostModal");
					let detailModal = new bootstrap.Modal(detailModalReOpen);
					let postNum = res.replyVO.comuPostNo;

					openDetailModal(postNum);

					detailModal.show();

				}
			},
			error : function(error){
				console.log(error.status);
			},
			beforeSend : function(xhr) {
		        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
		    }
		});
	});

	// 상세 모달창 열렸을 시
	$("#detailPostModal").on("show.bs.modal",function(e){

		$("#replyForm").children("div.text-right.pt-2").children("span.pt-1").children(".cmt-sub-size").text("0")
		$("#comuReplyContent").val("");
		$("#replyList").html("");
		$("#detailImgArea").html("");

		let postNum;
		if(e.relatedTarget){
			postNum = e.relatedTarget.getAttribute('data-bs-postNum')
			openDetailModal(postNum);
		}
	})

	// 상세모달 열리고 나서의 행동
	$("#detailPostModal").on("shown.bs.modal",function(){

		$("#postBox").on("click","#delete",function(){
			Swal.fire({
				title : "삭제 요청",
				text : '게시글을 삭제하시겠습니까? 삭제된 게시글은 복구가 불가합니다.',
				icon : 'question',
				showCancelButton : true,
				cancelButtonText : '아니오',
				confirmButtonText : '예'
			}).then((result) => {
				if(result.isConfirmed){
					let postNum = $(this)[0].dataset.comuPostNo;

					let artGroupNo = $("#communityArtistGroupNo").val();

					let data = new FormData();
					data.append("artGroupNo",artGroupNo);
					data.append("comuPostNo",postNum);

					$.ajax({
						url : "/community/delete/post/" + postNum,
						type : "post",
						data : data,
						contentType : false,
						processData : false,
						success : function(res){
							if(res == "OK"){
								Swal.fire({
									title : '삭제 완료',
									text : '정상적으로 삭제가 되었습니다.',
									icon : "success"
								}).then((result) => {
									let param = {
										"artGroupNo" : $("#communityArtistGroupNo").val(),
										"artistTabYn" : artistTabFlag
									}

									artistPostList(param);

									$("#detailPostModal").modal('hide');
								})
							}else{
								alert("게시글이 삭제가 되지 않았습니다.");
							}
						},
						error : function(error){
							console.log(error.status);
						},
						beforeSend : function(xhr) {
					        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
					    }
					})
				}
			});
		});

		// 댓글 삭제 버튼 클릭 시
		let replyDeleteBtnList = document.querySelectorAll("#replyDeleteBtn");
		replyDeleteBtnList.forEach(btn => {
			btn.addEventListener("click",function(e){
				e.preventDefault();
				Swal.fire({
					title : '삭제요청',
					text : "삭제시 복구가 불가합니다.",
					icon : 'question',
					showCancelButton : true,
					cancelButtonText : '아니오',
					confirmButtonText : '예'
				}).then((result) =>{
					if(result.isConfirmed){
						let detailModal = document.getElementById("detailPostModal");
						let myDetailModal = bootstrap.Modal.getInstance(detailModal);

						myDetailModal.hide();

						let test = e.target.dataset.comuReplyNo;
						let postNo = e.target.dataset.postNo;
						let replyNo = e.target.dataset.comuReplyNo;

						let data = new FormData();
						data.append("replyNo", replyNo)
						$.ajax({
							url : "/community/reply/delete",
							type : "post",
							data : data,
							contentType : false,
							processData : false,
							success : function(res){
								if(res == 'OK'){
									Swal.fire({
										title : '삭제 성공',
										text : '댓글이 정상적으로 삭제가 완료되었습니다.',
										icon : 'success'
									})

									let data = {
										"artGroupNo" : $("#communityArtistGroupNo").val(),
										"artistTabYn" : artistTabFlag
									}

									artistPostList(data);

									let detailModalReOpen = document.getElementById("detailPostModal");
									let detailModal = new bootstrap.Modal(detailModalReOpen);

									openDetailModal(postNo);

									detailModal.show();
								}
							},
							error : function(error){
								console.log(error.status);
							},
							beforeSend : function(xhr) {
						        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
						    }
						});
					}
				});


			})
		});

		oldLikeCount = $(this).find("#likeCount").html();

		$("#likeButton").on("click", function(){
			likeFlag = true;
			likeBtn($(this));
		});

	});

	// 상세 모달 닫혔을 시 좋아요에 변화가 있을 시
	$("#detailPostModal").on("hide.bs.modal",function(e){

		newLikeCount = $(this).find("#likeCount").html();

		let comuPostNo = $(this).find("#comuPostNo").val();
		let boardTypeCode = $(this).find("#boardTypeCode").val();
		let artGroupNo = $("#communityArtistGroupNo").val();

		// 기존의 좋아요 수가 40이라고 가정
		// 액션 1. 좋아요 버튼을 누르지 않고 창을 닫을 때 좋아요 수 변화가 없음
		// 액션 2. 좋아요 버튼을 누르고 창을 닫을 때 좋아요 수는 +1인 상태 그래서 창을 닫을 때 41이 되어 있음. 이전에 있던 좋아요 수보다 새로운 좋아요 수가 더 높기에 pM에 1이 들어가 있음
		// 액션 3. 좋아요 버튼을 취소하고 창을 닫을 떄 좋아요 수는 -1인상태 그래서 창을 닫을 때 39가 되어 있음. 이전에 있던 좋아요 수가 더 높기에 pM에 -1이 들어가 있음
		let pM = 0;
		if(oldLikeCount == newLikeCount){
			pM = 0;
		}else if(oldLikeCount > newLikeCount){
			pM = -1;
		}else if(oldLikeCount < newLikeCount){
			pM = +1;
		}

		if(likeFlag){	// 좋아요가 변경이 되었다면
			let data = new FormData();
			data.append("comuPostNo",comuPostNo);
			data.append("boardTypeCode",boardTypeCode);
			data.append("artGroupNo",artGroupNo);
			data.append("insertDelete", pM);

			likeUpdate(data);
		}

	});

	// 글 등록 시
	$("#postSendBtn").on("click",function(){
		Swal.fire({
			title : '등록 요청',
			text : '게시글을 등록하시겠습니까?',
			icon : 'question',
			showCancelButton : true,
			confirmButtonText : '예',
			cancelButtonText : '아니오'
		}).then((result) => {
			if(result.isConfirmed){
				let checkeded = $("#postMemberShipYn").is(':checked');
				$("#memberShipYn").val(checkeded);
				let postForm = document.getElementById("postForm");

				let artGroupNo = $("#comuArtGroupNo").val();

				let data = new FormData(postForm);

				$.ajax({
					url : "/community/insert/post",
					type : "post",
					data : data,
					processData : false,
					contentType : false,
					success : function(res){
						if(res == 'OK'){
							Swal.fire({
								title : '저장완료!',
								text : '게시글이 정상적으로 저장되었습니다!',
								icon : 'success'
							});
							$("#insertPostModal").modal('hide');

							let data = {
								"artGroupNo" : $("#communityArtistGroupNo").val(),
								"artistTabYn" : artistTabFlag
							}

							artistPostList(data);

						}else{
							alert("글 등록 실패")
						}
					},
					error : function(error){
						console.log(error.status);
					},
					beforeSend : function(xhr) {
				        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
				    }
				});
			}
		});

	});


	// 검색에 있는 아티스트 클릭 시
	$("#artistFeedSearchWrap").on("click", "input[name=artistNm]", function(){
		$(this).val();
		let data = {
			"artGroupNo" : $("#communityArtistGroupNo").val(),
			"searchType" : $(this).val(),
			"searchWord" : $("#artistFeedSearchInput").val(),
			"artistTabYn" : artistTabFlag
		}
		artistPostList(data);
	});

	// 아티스트 탭 검색 버튼 클릭 시
	$("#artistFeedSearchWrap").on("click", "input[id=searchFormBtn]", function(){
		let searchType = $("input[name=artistNm]:checked").val();
		let data = {
			"artGroupNo" : $("#communityArtistGroupNo").val(),
			"searchType" : searchType,
			"searchWord" : $("#artistFeedSearchInput").val(),
			"artistTabYn" : artistTabFlag
		}
		artistPostList(data);
	});

	$("#fanFeedSearchWrap").on("click", "input[id=searchFormBtn]", function(){
		let data = {
			"artGroupNo" : $("#communityArtistGroupNo").val(),
			"searchWord" : $("#fanFeedSearchInput").val(),
			"artistTabYn" : artistTabFlag
		}
		artistPostList(data);
	});

	const hash = window.location.hash;
	if(hash){
		if(hash == '#scheduleList'){
			const schedule = new bootstrap.Tab(document.getElementById('schedule'));
						schedule.show();
						$("#schedule").click()
		}
		if(hash == '#fanPostList'){
			const fanPost = new bootstrap.Tab(document.getElementById('fanPost'));
			fanPost.show();
			$("#fanPost").click();

		}
		if(hash == '#artistPostList'){
			const artistPost = new bootstrap.Tab(document.getElementById('artistPost'));
						artistPost.show();
						$("#artistPost").click();
		}
		if(hash == '#noticeAptList'){
			const noticeApt = new bootstrap.Tab(document.getElementById('noticeApt'));
						noticeApt.show();
						$("#noticeApt").click();
		}
	}

	let pathname = window.location.pathname;
	let path = pathname.split('/');

	if(path[2] == 'live'){
		let artGroupNo = $("#communityArtistGroupNo").val();

		$("#live").attr("class","tab-item active");

		$("#liveList").addClass("show active");

	}

	// 알림 클릭으로 라이브 탭 진입 시 처리
	if(window.location.hash === '#liveArea') {

		// 페이지 로드 완료 후 라이브 탭 활성화
		$(document).ready(function() {
			setTimeout(() => {
				// Bootstrap 탭 활성화
				const liveTab = new bootstrap.Tab(document.getElementById('live'));
				liveTab.show();

				// URL 해시 제거 (깔끔한 URL 유지)
				history.replaceState(null, null, window.location.pathname);
			}, 100);
		});
	}



	// 이미지 영역 가져오기
	let area = $("#imgArea");

	$("#insertPostFile").on("change",function(e){

		let files = e.target.files;

	    let fileArr = [];

		let html = ``;
		for(let i=0; i<files.length; i++){
			let file = files[i];
			fileArr.push(file.name);

			fileMap.set(fileNum.toString(),file);

			let reader = new FileReader();
    		reader.onload = function(e){
    			html += `
					<div class="imgDiv">
						<img src="\${e.target.result}"  data-fileNum='\${fileNum}' >
							<button class="imgDeleteBtn" id="imgDeleteBtn">
								<i class="bi bi-x-lg"></i>
							</button>
						</img>
					</div>
					`;
        		fileNum++;
			$("#imgArea").html(html);
    		}
    		reader.readAsDataURL(file);
		}

		// 파일명 노출방법2: 배열 값들을 줄바꿈하여 표시
		var fileList = fileArr.join(', ');
		$(this).siblings('#fileName').val(fileList);

	});

	// 이미지 삭제 시 files map에 삭제
	area.on("click","button",function(){
		let pr = $(this).parent("div").remove();
		let cur = $(this).parent("div").children('img')[0].dataset.filenum;

		files.delete(cur);

	});


	// 등록 모달 열렸을 시
	$("#insertPostModal").on("show.bs.modal",function(){
		if(artistTabFlag){
			$("#postForm").children("label[for=memberShipYn]").attr("style","display:block");
			$("#postForm").children("input[name=boardTypeCode]").val('ARTIST_BOARD');
			$("#postForm").children("input[name=artistTabYn]").val('true');
			let tabCheck = $("#artistTabYn").val();

			if(tabCheck){
				$("#postMemberShipYn").prop("checked",false);
			}
		}else{
			$("#postForm").children("label[for=memberShipYn]").attr("style","display:none");
			$("#postForm").children("input[name=boardTypeCode]").val('FAN_BOARD');
			$("#postForm").children("input[name=artistTabYn]").val('false');
		}

		$("#comuPostContent").val("");
		$("#insertPostFile").val("");
		$("#imgArea").html("");
		$("#fileName").val("");

		let content = document.getElementById("comuPostContent");
		contentLengthCheck(content);
	});

	// 수정 모달 닫았을 시
	$("#editPostModal").on("hide.bs.modal",function(){
		$("#editImgArea").html("");
		let tabCheck = $("#artistTabYn").val();
		if(tabCheck){
			$("#editPostMemberShipYn").prop("checked",false);
		}
		$("#editInsertPostFile").val("");
	});



	// 수정 모달에서 파일 선택 클릭 시
	$("#editInsertPostFile").on("change",function(e){
		let files = e.target.files;

		for(let i=0; i<files.length; i++){
			let file = files[i];

			fileMap.set(fileNum.toString(),file);

			let reader = new FileReader();
    		reader.onload = function(e){
    			let html = `
					<div class="imgDiv">
						<img src="\${e.target.result}"  data-fileNum='\${fileNum}' >
							<button class="imgDeleteBtn" id="imgDeleteBtn">
								<i class="bi bi-x-lg"></i>
							</button>
						</img>
					</div>
				`;
        		fileNum++;
				$("#editImgArea").append(html);
    		}
    		reader.readAsDataURL(file);
		}

	});

	$("#reportModal").on("show.bs.modal",function(e){

		let postNo = e.relatedTarget.getAttribute('data-bs-whatever');
		let boardType = e.relatedTarget.getAttribute('data-bs-boardType');
		let comuProfileNo = e.relatedTarget.getAttribute('data-bs-comuProfileNo');
		let comuNick = e.relatedTarget.getAttribute('data-bs-comuNick');
		let comuContent = e.relatedTarget.getAttribute('data-bs-comuContent');
		let selectType = e.relatedTarget.getAttribute('data-bs-selectType');
		let comuReplyNo = e.relatedTarget.getAttribute('data-bs-comuReplyNo');


		let code = ${codeMap};
		let reasonCode = code.reasonCode;
		let reportStatCode = code.reportStatCode;
		let reportTarCode = code.reportTarCode;

		let targetCode;

		let info = {
			"postNo" : postNo,
			"boardType" : boardType,
			"comuProfileNo" : comuProfileNo,
			"reasonCode" : reasonCode,
			"reportTarCode" : selectType,
			"comuNick" : comuNick,
			"comuContent" : comuContent,
			"comuReplyNo" : comuReplyNo
		};
		reportModalInfo(info);

	});


	$("#reportSendBtn").on("click",function(){

		Swal.fire({
			title : '신고',
			text : '본 신고는 운영 정책에 따라 처리되며, 신고 내용이 서비스 약관에 위배될 경우 해당 게시물 또는 사용자는 적절한 조치를 받게 됩니다. 부적절한 신고는 처리되지 않을 수 있습니다.',
			footer : '허위 신고 시 서비스 이용에 불이익을 받을 수 있습니다. 신중하게 신고해주세요.',
			icon : 'warning',
			showCancelButton : true,
			cancelButtonText : '취소',
			confirmButtonText : '신고'
		}).then((result) => {
			if(result.isConfirmed){
				let reportForm = document.getElementById("reportForm");

				let data = new FormData(reportForm);
				$.ajax({
					url : "/community/send/report",
					type : "post",
					data : data,
					contentType : false,
					processData : false,
					success : function(res){
						if(res == 'OK'){
							Swal.fire({
								title : '접수 완료',
								text : '신고가 접수되었습니다. 빠른 시일 내 조치하겠습니다!',
								icon : 'success'
							});
							$("#reportModal").modal('hide');
						}else if(res == 'EXIST'){
							Swal.fire({
								text : '이미 신고하셨습니다.',
								icon : 'error'
							});
							$("#reportModal").modal('hide');
						}
					},
					error : function(error){
						console.log(error.status);
					},
					beforeSend : function(xhr) {
				        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
				    }
				});
			}
		});
	});

	$("#reportModal").on("hide.bs.modal",function(e){
		$("#targetComuReplyNo").val("");
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

    	let twolDayDiv = $("div[class=notAllDaySchedule]");
    	let oneDayDiv = $("div[class=allDaySchedule]");
    	let modalStartDate = $("#startDate");
    	let modalEndDate = $("#endDate");
    	let allDate = $("#allDate");

		let target = e.relatedTarget;

		let { title, url, textColor, backgroundColor, id, allDay, startStr, endStr, start, end } = target.event;
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
    	link.html(title+" 바로가기 <i class='fa-solid fa-arrow-up-right-from-square'></i>");

    	if(allDay){
    		$("#allDayStatus").prop("checked",true);

    		if(endStr == null || end == null){
    			endStr = startStr;
    			oneDayDiv.attr("style","display:flex");
    			allDate.val(startStr)
    		}else{
    			let endDateStr = new Date(endStr);
    			let startDateStr = new Date(startStr)
    			if(endDateStr.getDay() - 1 == startDateStr.getDay()){
    				oneDayDiv.attr("style","display:flex");
    				allDate.val(startStr)
    			}else{
	    			twolDayDiv.attr("style","display:flex")
		    		modalStartDate.val(startStr);
		    		modalEndDate.val(endStr);
    			}
    		}


    	}else{
    		$("#allDayStatus").prop("checked",false);
    		twolDayDiv.attr("style","display:flex");
    		let formatStart = scheduleDateFormat(start);
    		let formatEnd = scheduleDateFormat(end);
    		modalStartDate.val(formatStart);
    		modalEndDate.val(formatEnd);
    	}
	});

	$("#scheduleModal").on('hide.bs.modal',function(){
		let twolDayDiv = $("div[class=notAllDaySchedule]");
    	let oneDayDiv = $("div[class=allDaySchedule]");

    	twolDayDiv.attr("style","display:none");
    	oneDayDiv.attr("style","display:none");
	});

	$("#noticeSearchWarp").on("click","input[id=noticeSearchFormBtn]",function(){
		let searchType = $("#noticeSearchForm input[name=searchType]:checked").val();
		let data = {
			"searchType" : searchType,
			"searchWord" : $("#noticeSearchWord").val(),
			"artGroupNo" : $("#communityArtistGroupNo").val()
		}

		noticeList(data);
	});

	$("#noticeSearchWarp").on("click", "input[name=searchType]", function(){
		let data = {
			"searchType" : $(this).val(),
			"searchWord" : $("#noticeSearchWord").val(),
			"artGroupNo" : $("#communityArtistGroupNo").val()
		}
		noticeList(data);
	});

// 	let postArea = document.getElementByClassName("apt-content-area");
// 	$(".apt-content-area").scroll(function() {
//         // 스크롤이 페이지 하단에 도달했는지 확인하는 조건
// //         console.log("문서 전체 높이 : ", (document).height()) // 문서 전체 높이
//         console.log("현재 스크롤바의 위치 : ", (window).scrollTop()) // 현재 스크롤바의 위치
//         console.log("현재 브라우저 창의 높이 : ", (window).height()) // 현재 브라우저 창의 높이

// //         if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) { // 100px 여유 공간
// //             // 스크롤이 하단에 도달하면 다음 페이지 로드
// //         }
//     });

	$("#artistFeedList").on("click",'a[id=postLink]',function(e){
		e.preventDefault();
		let membershipYn = $(this)[0].getAttribute('data-bs-membershipBlur');
		if(membershipYn == 'Y'){
			Swal.fire({
				title : '멤버십 전용',
				text : '해당 게시글을 멤버십 전용 게시물입니다. 멤버십 가입 후 이용 가능합니다.',
				icon : 'error'
			})
		}
	})





	$("#test").on("click",function(){
		$("#postDetailModal").modal('show');
	});


	// 팔로우 기능
	// 팔로우버튼
	let followFlag = "${followFlag}" != 'N' ? true : false;
	let followToggleBtn = $("#followToggleBtn"); // 팔로우 버튼

	followToggleBtn.on("click",function(){
		if(followFlag){
			Swal.fire({
				   title: '팔로우를 취소하시겠습니까?',
				   text: '취소 후 재 가입시 기존 데이터에 접근할 수 없습니다.',
				   icon: 'warning',

				   showCancelButton: true, // cancel버튼 보이기. 기본은 원래 없음
				   confirmButtonColor: '#3085d6', // confrim 버튼 색깔 지정
				   cancelButtonColor: '#d33', // cancel 버튼 색깔 지정
				   confirmButtonText: '확인', // confirm 버튼 텍스트 지정
				   cancelButtonText: '취소', // cancel 버튼 텍스트 지정

				}).then(result => {
				   // 만약 Promise리턴을 받으면,
				    if(result.isConfirmed) { // 만약 모달창에서 confirm 버튼을 눌렀다면
				    	let comuProfileNo = "${userProfile.comuProfileNo}";
				    	let artGroupNo = "${userProfile.artGroupNo}";
				    	let memUsername = "${userProfile.memUsername}";
				    	let data = {
				    			comuProfileNo : comuProfileNo,
				    			artGroupNo : artGroupNo,
				    			memUsername : memUsername,
				    	}
				    	// 팔로우 취소
				    	$.ajax({
				    		url : "/api/community/removeapt",
				    		type : "post",
				    		contentType : "application/json; charset=utf-8",
				    		data : JSON.stringify(data),
				    		beforeSend : function(xhr){
								xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}')
							},
				    		success : function(res){
				    			location.reload();
				    		},
				    		error : function(err){
				    			console.log(err);
				    			sweetAlert("error","취소 도중 에러가 발생했습니다. 다시 시도해주세요!");
				    		}
				    	});

				    }
				});
		}else{
			$("#commProfileModal").modal("show");
		}
	})

	if(!followFlag){
		let followBtn = $("#followBtn");	// 오버레이쪽 팔로우 버튼
		let commProfileModal = $("#commProfileModal"); // 커뮤니티 프로필 생성 모달
		let previewImgBox = $("#previewImgBox"); //미리보기이미지박스
		let imgFile = $("#imgFile"); // 이미지 첨부 파일
		let previewImg = $("#previewImg"); // 미리보기 이미지
		let comuNicknm = $("#comuNicknm"); // 닉네임 필드
		let file = null;	// 파일 없으면 null
		let profileSubmitBtn = $("#profileSubmitBtn"); // 닉네임 등록 버튼

		followBtn.on("click",function(){
			commProfileModal.modal("show");
		});

		// 프로필 이미지 박스 클릭시 이미지파일 선택
		previewImgBox.on("click",function(){
			imgFile.click();
		})

		// 프로필 이미지 이벤트
		imgFile.on("change",function(){
			const defaultPath = "${pageContext.request.contextPath}/upload/profile/base/defaultImg.png";
			const maxSize = 2 * 1024 * 1024;
			file = this.files[0];

			if(file == null){
				previewImg.attr("src", defaultPath);
				return false;
			}

			if(file.size > maxSize){
				sweetAlert("error", "파일 사이즈는 2MB 미만으로 선택해주세요!");
				$(this).val("");
				file = null;
				previewImg.attr("src", defaultPath);
				return false;
			}

			if(!file.type.startsWith("image/")){
				sweetAlert("error", "이미지파일만 선택해주세요");
				$(this).val("");
				file = null;
				previewImg.attr("src", defaultPath);
				return false;
			}

			let fileReader = new FileReader();
			fileReader.onload = function(e){
				previewImg.attr("src", e.target.result);
			};

			fileReader.readAsDataURL(file);
		})

		profileSubmitBtn.on("click",function(){
			let comuNicknmVal = comuNicknm.val();
			if(comuNicknmVal == null || comuNicknmVal.trim() == ''){
				sweetAlert("error","닉네임을 입력해주세요");
				return false;
			}
			if(comuNicknmVal.length > 12){
				sweetAlert("error","닉네임은 12자 이내로 입력해주세요");
				return false;
			}

			let formData = new FormData();
			let artGroupNo = "${artistGroupVO.artGroupNo}";
			let memUsername = "${user.username}";
			formData.append("artGroupNo",artGroupNo);
			formData.append("memUsername",memUsername);
			formData.append("comuNicknm", comuNicknmVal);
			if(file != null){
				formData.append("imgFile", file);
			}
			joinCommunity(formData);
		})
	}
	$("#commProfileModal").on("hide.bs.modal",function(){
		$("#comuNicknm", $(this)).val("");
		$("#previewImg").attr("src","${pageContext.request.contextPath}/upload/profile/base/defaultImg.png");
		$("#imgFile").val("");

	})

	function joinCommunity(formData){
		$.ajax({
			url : '/api/community/joinapt',
			type : "post",
			processData : false,
			contentType : false,
			data : formData,
			beforeSend : function(xhr){
				xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}')
			},
			success : function(res){
				location.reload();
			},
			error : function(err){
				console.log(err);
				sweetAlert("error","팔로우 하는 도중 에러가 발생했습니다. 다시 시도해주세요!");
			}
		});
	}

	let myProfile = $("#myProfile"); // 마이프로필 엘리먼트
	myProfile.on("click",function(){
		let artGroupNo = "${artistGroupVO.artGroupNo}";
		let comuProfileNo = $(this).data("comuProfileNo");
		location.href = `${pageContext.request.contextPath}/community/\${artGroupNo}/profile/\${comuProfileNo}`;
	});


	// 모달 수정 부분
	// feedItem 클릭시 모달 오픈
// 	$(".feed-item-content").each((i,v) => {
// 		$(v).on("click",function(){
// 			let postNum = $(this).data("postId");

// 			openDetailModal(postNum);
// 			$("#detailPostModal").modal("show");
// 		})
// 	});
});
function contentLengthCheck(ele){
	let size = ele.value.length;
	let text = ele.value;
	if(size > 1000){
		alert("글 작성은 1000자 이상을 넘을 수 없습니다.");
		let subText = text.substring(0,1000);
		ele.value = subText;
		$(ele).parents("form").find(".cmt-sub-size").text(subText.length);
		return false;
	}

	$(ele).parent("form").find(".cmt-sub-size").text(size);
}

function replyContentLengthCheck(ele){
	let size = ele.value.length;
	let text = ele.value;
	if(size > 300){
		Swal.fire({
			title : '입력 초과!',
			text : '댓글은 300자 초과 작성할 수 없습니다.',
			icon : 'error'
		});
		let subText = text.substring(0,300);
		ele.value = subText;
		$(ele).parents("#replyForm").children("div.text-right.pt-2").children("span.pt-1").children(".cmt-sub-size").text(subText.length);
		return false;
	}

	$(ele).parents("#replyForm").children("div.text-right.pt-2").children("span.pt-1").children(".cmt-sub-size").text(size);
}



function scheduleDateFormat(jsonDate){
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

    return month + '-' + day + ' ' + hour + ':' + minute;
}



/* let info = {
"postNo" : postNo,
"boardType" : boardType,
"comuProfileNo" : comuProfileNo,
"reasonCode" : reasonCode,
"reportTarCode" : reportTarCode,
"comuNick" : comuNick,
"comuContent" : comuContent
"comuReplyNo" : comuReplyNo
}; */

function reportModalInfo(info){
// 	<input type="radio" class="btn-check" name="options-outlined" id="success-outlined" autocomplete="off" checked>
// 	<label class="btn btn-outline-primary" for="success-outlined">Checked success radio</label>

// 	<input type="radio" class="btn-check" name="options-outlined" id="danger-outlined" autocomplete="off">
// 	<label class="btn btn-outline-danger" for="danger-outlined">Danger radio</label>
	let postNo = info.postNo;
	let boardType = info.boardType;
	let comuProfileNo = info.comuProfileNo;
	let reasonCodeList = info.reasonCode;
	let reportTarCode = info.reportTarCode;
	let artGroupNo = $("#communityArtistGroupNo").val();
	let comuReplyNo = info.comuReplyNo;

	let targetNick = info.comuNick;

	let targetContent = info.comuContent;

	let radioHtml = ``;
	for(let i=0; i<reasonCodeList.length; i++){
		let reasonCode = reasonCodeList[i];
		radioHtml += `
			<input type="radio" class="btn-check" name="reportReasonCode" id="\${reasonCode.commCodeDetNm}" value="\${reasonCode.commCodeDetNo}" autocomplete="off">
		 	<label class="btn btn-outline-primary" for="\${reasonCode.commCodeDetNm}">\${reasonCode.description}</label>
		`;
	}

	$(".radioArea").html(radioHtml);

	$("#targetNick").val(targetNick);
	$("#targetContent").html(targetContent);

	$("#targetComuPostNo").val(postNo);
	$("#targetBoardTypeCode").val(boardType);
	$("#reportArtGroupNo").val(artGroupNo);
	$("#targetComuProfileNo").val(comuProfileNo);
	$("#reportTargetTypeCode").val(reportTarCode);

	if(comuReplyNo != null){
		$("#targetComuReplyNo").val(comuReplyNo);
	}

}

function updateModalInfo(postNum){
	$.ajax({
		url : "/community/post/get/" + postNum,
		type : "get",
		success : function(res){

			$("#postNum").val(res.comuPostNo);

			$("#editComuPostContent").text(res.comuPostContent);

			let content = document.getElementById("editComuPostContent");
			contentLengthCheck(content);

			$("#fileGroupNo").val(res.fileGroupNo);

			if(res.artistTabYn){
				if(res.memberShipYn){
					$("#editPostMemberShipYn").prop("checked",true);
				}
				$("#checkBoxMbs").attr("style", "display:block");
			}else{
				$("#checkBoxMbs").attr("style", "display:none");
			}

			let html = ``;
			if(res.postFiles != null && res.postFiles.length > 0){
				for(let i=0; i<res.postFiles.length; i++){
					let postFile = res.postFiles[i];
					html += `
						<div class="imgDiv">
							<img src="\${postFile.webPath}"  data-fileNum='\${postFile.attachDetailNo}' >
								<button class="imgDeleteBtn" id="imgDeleteBtn">
									<i class="bi bi-x-lg"></i>
								</button>
							</img>
						</div>
					`;
				}
			}


			$("#editImgArea").append(html);


		},
		error : function(error){
			console.log(error.status);
		}
	});
}

//모달 수정 부분
function openDetailModal(postNum){

	let artGroupNo = $("#communityArtistGroupNo").val();

	let data = new FormData();
	data.append("artGroupNo",artGroupNo);
	data.append("comuPostNo",postNum )

	$.ajax({
		url : "/community/post/detail/" + postNum,
		type : "get",
		data : {
			"artGroupNo" : artGroupNo,
			"comuPostNo" : postNum
		},
		success : function(res){
			// 작성자 정보
			let writer = res.writerProfile;
			let {comuProfileImg : writerImg, comuNicknm : writerNick, comuProfileNo:writerComuProfileNo} = writer;
			let userProfileNo = 0;
				if("${not empty userProfile}"){
					userProfileNo = "${userProfile.comuProfileNo}"
				}
			// 게시판 정보
			let {comuPostContent:content,postFiles,boardTypeCode
				,comuPostNo,likeYn, comuPostRegDate:regDate
				,comuPostModDate : modDate
				,comuPostLike : likeCount, comuPostReplyList, comuPostReplyCount} = res


			$("#comuPostNo").val(comuPostNo);
			$("#boardTypeCode").val(boardTypeCode);

			let likeIcon = $("#likeBtn").children('i');
			let likeClass;
			if(likeYn == 'Y'){
				likeClass = "bi bi-suit-heart-fill";
			}else{
				likeClass = "bi bi-suit-heart";
			}
			likeIcon.attr("class",likeClass);

			let date;
			if(regDate === modDate){
				date = dateFormat(regDate);
			}else{
				date = dateFormat(modDate) + "(수정됨)";
			}

			let postHtml = ``;
			postHtml = `
				<div class="post-pane-header">
                	<div class="d-flex align-items-center">
                        <img src="\${writerImg}" class="rounded-circle" width="50px" style="height:50px;">
                        <div class="ms-2">
                            <strong class="d-block">\${writerNick}</strong>
                            <small class="text-muted">\${date}</small>
                        </div>
                	</div>
                	<div class="dropdown">
				        <button class="btn btn-link text-secondary p-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
				            <i class="bi bi-three-dots-vertical"></i>
				        </button>
				        <ul class="dropdown-menu"
				`;
			if(writerComuProfileNo == userProfileNo){
				postHtml += `
					<li><button class="dropdown-item" data-bs-target="#editPostModal" data-bs-toggle="modal" data-bs-dismiss="modal" data-bs-postNum="\${postNum}" id="edit" data-bs-categroy="detailEdit">수정</button></li>
		            <li><button class="dropdown-item" data-comu-post-no="\${postNum}" id="delete"  >삭제</button></li>
				`;
			}else{
				postHtml += `
					<li><button class="dropdown-item text-danger" data-comu-post-no="\${postNum}"
						data-bs-toggle="modal" data-bs-target="#reportModal"
							data-bs-whatever="\${postNum }"
						data-bs-boardtype="\${boardTypeCode}"
						data-bs-comuprofileno="\${writerComuProfileNo}"
						data-bs-comunick="\${writerNick}"
						data-bs-comucontent="\${content}"
						data-bs-selecttype="RTTC001">신고</button></li>
				`;
			}
			postHtml += `
				        </ul>
				    </div>
                </div>
                <div class="post-pane-body">
                `;
            if(postFiles != null && postFiles.length > 0){
            	postHtml += `<div class="detailImgContainer">`;
            	for(let file of postFiles){
            		postHtml += `
            			<div class="detailImg">
            				<img src="\${file.webPath}" alt="\${file.fileOriginalNm}" width="150px" height="150px">
            			</div>
            		`;
            	}
            	postHtml +=`</div>`;
            }
            postHtml += `
                	<p>\${content}<p>
                </div>
                <div class="post-pane-footer">
                `;
            if(likeYn == 'Y'){
            postHtml += `
				    <button type="button" class="btn btn-like active" data-comu-post-no="\${postNum}" data-comu-profile-no="\${userProfileNo}" id="likeButton">
				        <i class="bi bi-heart-fill"></i>
				        <span id="likeCount">\${likeCount}</span>
				    </button>
            	`;
            }else{
            	postHtml += `
				    <button type="button" class="btn btn-like" data-comu-post-no="\${postNum}" data-comu-profile-no="\${userProfileNo}" id="likeButton">
				        <i class="bi bi-heart"></i>
				        <span id="likeCount">\${likeCount}</span>
				    </button>
            	`;
            }
            postHtml +=`
				</div>
			`;

			$("#postBox").html(postHtml);

			$("#replyCount").html("답글 " + comuPostReplyCount + "개");

			// 댓글 영역
			let replyHtml = ``;
			for(let reply of comuPostReplyList){
				let {comuReplyContent, comuReplyRegDate, comuReplyNo, replyMember, comuReplyModDate} = reply;
				let {comuProfileImg, comuNicknm, comuProfileNo:replyComuProfileNo} = replyMember;
				replyHtml += `
					<div class="comment-item">
		            <img src="\${comuProfileImg}" class="rounded-circle comment-avatar">
		            <div class="comment-main-wrapper">
		            	<div class="comment-header">
		            		<strong>\${comuNicknm}</strong>
		            		<div class="dropdown">
						        <button class="btn btn-link text-secondary p-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
						            <i class="bi bi-three-dots-vertical"></i>
						        </button>
						        <ul class="dropdown-menu">
					`;
					if(userProfileNo == replyComuProfileNo){
						replyHtml += `
				            <li><button class="dropdown-item" data-comu-reply-no="\${comuReplyNo}" data-post-no="\${comuPostNo}" id="replyDeleteBtn">삭제</button></li>
						`;
					}else{
						replyHtml += `
							<li><button class="dropdown-item text-danger"
								data-bs-toggle="modal"
								data-bs-target="#reportModal"
								data-bs-whatever="\${comuPostNo}"
								data-bs-comuReplyNo="\${comuReplyNo}"
								data-bs-boardType="\${boardTypeCode}"
								data-bs-comuProfileNo="\${replyComuProfileNo}"
								data-bs-comuNick="\${comuNicknm}"
								data-bs-comuContent="\${comuReplyContent}"
								data-bs-selectType="RTTC002"
								>신고</button></li>
						`;
					}
					replyHtml += `
										</ul>
						            </div>
						        </div>
						        <div class="comment-body-text" style="font-size: medium;"> <p>\${comuReplyContent}</p>
						            <small class="text-muted">\${dateFormat(comuReplyModDate)}</small>
						        </div>
						    </div>
						</div>
					`;
			}
			$("#replyList").html(replyHtml);

			$("#boardTypeCode",$("#postBox")).val(boardTypeCode);
			$("#comuPostNo",$("#postBox")).val(comuPostNo)

		},
		error : function(error){
			console.log(error.status);
		}
	});
}

function insertPostModalClose(){
	Swal.fire({
		title : '작성 취소 요청',
		text : '지금까지 작성한 내용은 저장되지 않습니다. 정말로 취소하시겠습니까?',
		icon : 'question',
		showCancelButton : true,
		cancelButtonText : '아니오',
		confirmButtonText : '예'
	}).then((result) => {
		if(result.isConfirmed){
			$("#insertPostModal").modal('hide')
		}
	});
}

function updatePostModalClose(){
	Swal.fire({
		title : '수정취소 요청',
		text : '지금까지 작성한 내용은 저장되지 않습니다. 정말로 취소하시겠습니까?',
		icon : 'question',
		showCancelButton : true,
		cancelButtonText : '아니오',
		confirmButtonText : '예'
	}).then((result) => {
		if(result.isConfirmed){
			$("#editPostModal").modal('hide')
		}
	});
}

</script>
<script src="${pageContext.request.contextPath}/resources/js/pages/live/apt-community.js"></script>
<script>
$(document).ready(function() {
    // 페이지에 라이브 정보 카드가 있는지 확인
    const liveCard = $('.card[data-broadcast-id]');
    if (liveCard.length > 0) {
        const mediaServerUrl = $('#mediaServerUrl').val(); // mediaServerUrl 값 가져오기
        const socket = new SockJS(`${mediaServerUrl}/ws`);
        const stompClient = Stomp.over(socket);

        stompClient.connect({}, function(frame) {
//             console.log('메인 페이지 - 미디어 서버 STOMP 연결 성공');

            // 페이지에 있는 모든 라이브 카드에 대해 각각 구독 설정
            liveCard.each(function() {
                const broadcastId = $(this).data('broadcast-id');

                stompClient.subscribe('/topic/viewers/' + broadcastId, function(message) {
                    const data = JSON.parse(message.body);
                    // ID로 정확한 span 태그를 찾아 내용 업데이트
                    $('#viewer-count-' + broadcastId).text(data.viewerCount);
                });
            });
        });
    }
});
</script>
</body>
</html>