<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세 - DDTOWN 관리자</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/ckeditorInquiry/ckeditor.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="https://uicdn.toast.com/grid/latest/tui-grid.css" />
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.1/dist/js/adminlte.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>
<script type="text/javascript" src="https://uicdn.toast.com/tui.pagination/v3.4.0/tui-pagination.js"></script>
<%@ include file="../../modules/headerPart.jsp" %>
<style type="text/css">

 /* admin_member_detail.html에서 가져온 스타일 */
.detail-card { background-color: #fff; border: 1px solid #e7eaf3; border-radius: 8px; padding: 25px; box-shadow: 0 1px 3px rgba(0,0,0,0.04); margin-bottom: 10px; }
.detail-card h3 { font-size: 1.3em; color: #2c3e50; margin-top: 0; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #eee; }

.info-list { list-style: none; padding: 0; margin: 0; overflow: hidden; /* float 해제 */ }
.info-list dt {
    font-weight: 600; /* admin_portal.css의 .ea-form label과 유사하게 */
    color: #333;      /* admin_portal.css의 .ea-form label과 유사하게 */
    width: 120px;
    float: left;
    clear: left;
    margin-bottom: 1rem; /* admin_portal.css의 .ea-form .form-group과 유사하게 */
    line-height: 38px;
    padding-right: 10px; /* 우측 여백 추가 */
    box-sizing: border-box;
}
.info-list dd {
    margin-left: 130px;
    margin-bottom: 1rem; /* admin_portal.css의 .ea-form .form-group과 유사하게 */
    color: #333;
    min-height: 38px;
    display: flex;
    align-items: center;
}
/* 입력 필드 스타일은 admin_portal.css의 .ea-form input, select 스타일을 최대한 활용하도록 class 부여 고려 */
.info-list dd input[type="text"],
.info-list dd input[type="email"],
.info-list dd select {
    width: calc(20% - 22px);
    padding: .75rem .9rem; /* admin_portal.css .ea-form input과 동일하게 */
    font-size: .95rem;    /* admin_portal.css .ea-form input과 동일하게 */
    line-height: 1.5;     /* admin_portal.css .ea-form input과 동일하게 */
    color: #495057;       /* admin_portal.css .ea-form input과 동일하게 */
    background-color: #fff;
    border: 1px solid #ced4da; /* admin_portal.css .ea-form input과 동일하게 */
    border-radius: .25rem;   /* admin_portal.css .ea-form input과 동일하게 */
    box-sizing: border-box;
    height: 38px; /* 일관성 유지 */
}
 .info-list dd select {
    width: auto; /* select는 내용에 맞게 */
    min-width: 150px;
    height: auto;
}

.info-list dd span.view-mode-text {
    padding: 8px 0;
    display: inline-block; /* span도 높이를 가지도록 */
    line-height: 22px; /* 기본 텍스트 줄 높이 */
}
.status-badge-in-detail { /* 상세 정보 내 상태 뱃지 */
     padding: 5px 10px; border-radius: 12px; font-size: 0.8em; font-weight: 500; color: white; display:inline-block;
}
.status-badge-in-detail.normal { background-color: #2ecc71; } /* 정상 */
.status-badge-in-detail.suspended { background-color: #f39c12; } /* 활동정지 */
.status-badge-in-detail.banned { background-color: #e74c3c; } /* 블랙리스트 */
.status-badge-in-detail.dormant { background-color: #7f8c8d; } /* 휴면 */

/* 삭제 버튼 스타일 */
.delete-member-btn {
    background-color: #e74c3c;
    color: white;
    border: none;
    margin-left: 10px;
}
.delete-member-btn:hover {
    background-color: #c0392b;
}

/* 커뮤리스트 */
.comuListArea{
	display: flex;
	gap : 20px;
}
.comuImg {
    height: 80px;
    width: 80px;
    border-radius: 50%;
    align-items: center;
    justify-content: center;
    background-color: #e9ecef;
    overflow: hidden;
    display: flex
;
    margin-top: 10px;
    margin-bottom: 10px;
}

.comuCard-header {
    padding: var(--bs-card-cap-padding-y) var(--bs-card-cap-padding-x);
    margin-bottom: 0;
    color: var(--bs-card-cap-color);
    background-color: var(--bs-card-cap-bg);
    border-bottom: var(--bs-card-border-width) solid var(--bs-card-border-color);
    text-align: center;
    width: 100%;
}

.card.border-primary.mb-3 {
    width: 250px;
    align-items: center;
    height: 390px;
    font-size: large;
}

.card.border-danger.mb-3 {
    width: 200px;
    align-items: center;
    height: 320px;
}

.card-body {
    flex: 1 1 auto;
    padding: var(--bs-card-spacer-y) var(--bs-card-spacer-x);
    color: var(--bs-card-color);
    text-align: left;
    width: 100%;
}
.card-body > p {
	margin-bottom: 5px;
}

.card-title {
    margin-bottom: var(--bs-card-title-spacer-y);
    color: var(--bs-card-title-color);
    border-top: 1px solid #cccccc40;
    padding: 10px;
    border-bottom: 1px solid #cccccc40;
    text-align: center;
}

span.comuActive {
    border: 1px solid;
    border-radius: 8px;
    /* width: 100px; */
    font-size: 10px;
    background-color: #2ecc71;
    color: white;
    /* max-width: 100%; */
    padding: 5px;
}

span.delete {
    border: 1px solid;
    border-radius: 8px;
    /* width: 100px; */
    font-size: 10px;
    background-color: #e74c3c;
    color: white;
    /* max-width: 100%; */
    padding: 5px;
}

#myChart{
	height : 200px;
	width : 100%;
}

.membershipCard{
	cursor : pointer;
	display: inline-grid;
	color: white;
	transition: transform 0.3s; /* 추가 */
	transform: perspective(800px) rotateY(0deg);
	transform-style: preserve-3d; /* 추가 */
}
.membershipCard > * {
	grid-area: 1 / 1 / 1 / 1;
  width: 180px;
  height: 100px;
  padding: 12px;
  border-radius: 8px;
  backface-visibility: hidden; /* 추가 */
  font-size: 0.8em;
}
.membershipCard.flipped{
	transform: perspective(800px) rotateY(180deg);
}

.card.border-primary.back {
  transform: rotateY(180deg); /* 추가 */
}
.tui-grid-table {
	font-size: large;
}
/* 짝수 그룹 배경색 */
.tui-grid-cell.order-group-even {
/* 	background-color : #4D96FF; */
  border-right: 1px solid aliceblue;
}

.tui-grid-cell.order-group-odd{
/* 	background-color: #85e3e7; */
	background-color: skyblue;
	border-right: 1px solid aliceblue;
}
.tui-grid-cell.order-group-cancel {
/* 	background-color : #ff38ae; */
/* 	color: white; */
  border-right: 1px solid aliceblue;
}

.tui-grid-cell.order-group-odd-cancel{
/* 	background-color: #e680f1; */
	background-color: #ffc0cb;
	font-weight: bold;
	border-right: 1px solid aliceblue;
}

/* 그룹 마지막 행 하단 굵은 선 */
.tui-grid-cell.order-group-last-row {
  border-bottom: 2px solid aliceblue;
}

.btn-group {
    display: flow;
    /* margin-left: auto; */
    text-align: end;
}
.ea-form-actions {
    margin-top: 25px;
    padding-top: 20px;
    border-top: 1px solid #e9ecef;
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    width: 100%;
}
</style>
</head>
<script type="text/javascript">

let myChartInstance = null;

let date = new Date();
let month = date.getMonth() + 1;
let months = [];
for(let i=1; i<=month; i++){
	months.push(i + "월");
}

// 현재 보고있는 사용자의 아이디 추출
let path = window.location.pathname;
let pathList = path.split("/");
let memUsername = pathList[pathList.length - 1];
//

// 주문 그리드에 출력해줄 메소드
function orderGridData(data){
	$.ajax({
		url : '/admin/community/member/orderDataForGrid/' + memUsername,
		type : 'get',
		data : data,
		success : function(res){
			let label = res.label;
			let sellOrderCollapse = document.getElementById("sellOrderCollapse");
			let cancelOrderCollapse = document.getElementById("cancelOrderCollapse");

			let sellCollapse = new bootstrap.Collapse(sellOrderCollapse, {toggle : false})
			let cancelCollapse = new bootstrap.Collapse(cancelOrderCollapse, {toggle : false})
			if(label == '판매금액'){
				$("#sellGridArea").html(`<div id="grid"></div>`);
				sellCollapse.show();
				cancelCollapse.hide();

				$("#cancelOrderCollapse").attr("style","display:none");

				$("#gridPageArea").html(res.pagingVO.pagingHTML);
				let page = res.pagingVO.currentPage;

				let contentData = res.data.content;
				let flag = true;

				let tempData = [];
				for(let i=0; i<contentData.length; i++){
					let detailList = contentData[i].orderDetailList;
					let temp = 0;
					let rowData = null;
					let count = 0;
					for(let j=0; j<detailList.length; j++){
						let details = detailList[j];
						let detail = detailList[j].goodsVO.options.length;

						let total = 0;

						for(let m=0; m<detailList.length; m++){
							let cnt = detailList[m].goodsVO.options.length;

							total = temp + cnt;
							temp = cnt;
						}

						for(let k=0; k<detail; k++){
							rowData = {
								orderRownum : contentData[i].orderRownum,
								orderDate :contentData[i].orderDate,
								orderPayMethodNm : contentData[i].orderPayMethodNm,
								goodsNm : details.goodsVO.goodsNm,
								goodsOptNm : details.goodsVO.options[k].goodsOptNm,
								orderDetQty : details.cartQty,
								goodsOptPrice : details.goodsVO.options[k].goodsOptPrice,
								optTotal : details.cartQty * details.goodsVO.options[k].goodsOptPrice,
								orderTotalPrice : contentData[i].orderTotalPrice
							}
							count++;

							tempData.push(rowData);

							let groupClass = flag ? 'order-group-odd' : 'order-group-even';
							const classList = [groupClass]; // 기본으로 배경색 클래스 추가

						    // 그룹의 마지막 행이면 구분선 클래스 추가
						    if (count === detail.length - 1) {
						      classList.push('order-group-last-row');
						    }

							if(count == 1){

								rowData['_attributes'] = {
									rowSpan: {
					                    orderRownum: total,
					                    orderDate: total,
					                    orderPayMethodNm: total,
					                    orderTotalPrice: total,
					                },
					                className: {
					                    row: classList // 첫 번째 행에도 classList 적용
					                }
								}
							}else{
								rowData['_attributes'] = {
					                className: {
					                    row: classList // 첫 번째 행이 아닌 경우에도 classList 적용
					                }
					            };
							}
						}
					}
					flag = !flag;

				}

				let Grid = tui.Grid;

				const grid = new Grid({
					el : document.getElementById('grid'),
					columns : [
						{
							header : 'No',
							name : 'orderRownum',
							align : 'center',
							width : 10,
						},
						{
							header : '주문일자',
							name : 'orderDate',
							width : 110,
							formatter: ({ value }) => {
						        const date = new Date(value);
						        return `\${date.getFullYear()}-\${String(date.getMonth() + 1).padStart(2, '0')}-\${String(date.getDate()).padStart(2, '0')}`;
						 	}
						},
						{
							header : '결제수단',
							name : 'orderPayMethodNm',
							width : 110,
						},

						{
							header : '상품명',
							name : 'goodsNm',
						},

						{
							header : '옵션명',
							name : 'goodsOptNm',
							width : 120,
						},

						{
							header : '수량',
							name : 'orderDetQty',
							align : 'right',
							width : 50,
							formatter : ({ value }) => value + '개',
						},

						{
							header : '옵션별 금액',
							name : 'goodsOptPrice',
							align : 'right',
							width : 98,
							formatter: ({ value }) => value.toLocaleString('ko-KR') + '원'
						},

						{
							header : '옵션 합계',
							name : 'optTotal',
							align : 'right',
							width : 107,
							formatter: ({ value }) => value.toLocaleString('ko-KR') + '원'
						},
						{
							header : '총 결제금액',
							name : 'orderTotalPrice',
							align : 'right',
							width : 120,
							formatter: ({ value }) => value.toLocaleString('ko-KR') + '원'
						},

					],
					data : tempData,
					columnOptions: {
				        resizable: true
				    },
				})
			}else{
				$("#cancelOrderCollapse").attr("style","display:block");
				$("#cancelGridArea").html(`<div id="cancelGrid"></div>`);
				sellCollapse.hide();
				cancelCollapse.show();

				$("#cancelGridPageArea").html(res.pagingVO.pagingHTML);
				let page = res.pagingVO.currentPage;

				let contentData = res.data.content;
				let flag = true;

				let tempData = [];
				for(let i=0; i<contentData.length; i++){
					let detailList = contentData[i].cancelOrderDetailVO;
					let temp = 0;
					let rowData = null;
					let count = 0;
					for(let j=0; j<detailList.length; j++){
						let details = detailList[j];
						let detail = detailList[j].goodsVO.options.length;

						let total = 0;

						for(let m=0; m<detailList.length; m++){
							let cnt = detailList[m].goodsVO.options.length;

							total = temp + cnt;
							temp = cnt;
						}

						if(details.goodsVO.options.length == 0){
							rowData = {
								cancelRum : contentData[i].cancelRum,
								cancelReqDate :contentData[i].cancelReqDate,
								cancelReasonName : contentData[i].cancelReasonName,
								cancelReasonDetail : contentData[i].cancelReasonDetail,
								goodsNm : details.goodsVO.goodsNm,
								goodsOptNm : '없음',
								orderDetQty : details.cartQty,
								goodsOptPrice : details.goodsVO.goodsPrice,
								optTotal : details.cartQty * details.goodsVO.goodsPrice,
								cancelReqPrice : contentData[i].cancelReqPrice
							}



							let groupClass = flag ? 'order-group-odd' : 'order-group-even';
							const classList = [groupClass]; // 기본으로 배경색 클래스 추가

						    // 그룹의 마지막 행이면 구분선 클래스 추가
						    if (count === detail.length - 1) {
						      classList.push('order-group-last-row');
						    }

						    rowData['_attributes'] = {
				                className: {
				                    row: classList // 첫 번째 행이 아닌 경우에도 classList 적용
				                }
				            };
						    tempData.push(rowData);
						}

						for(let k=0; k<detail; k++){
							if(details.goodsVO.options.length == 0){
							}

							rowData = {
								cancelRum : contentData[i].cancelRum,
								cancelReqDate :contentData[i].cancelReqDate,
								cancelReasonName : contentData[i].cancelReasonName,
								cancelReasonDetail : contentData[i].cancelReasonDetail,
								goodsNm : details.goodsVO.goodsNm,
								goodsOptNm : details.goodsVO.options[k].goodsOptNm ? details.goodsVO.options[k].goodsOptNm : '없음',
								orderDetQty : details.cartQty,
								goodsOptPrice : details.goodsVO.options[k].goodsOptPrice ? details.goodsVO.options[k].goodsOptPrice : details.goodsVO.goodsPrice,
								optTotal : details.cartQty * details.goodsVO.options[k].goodsOptPrice ? details.goodsVO.options[k].goodsOptPrice : details.goodsVO.goodsPrice,
								cancelReqPrice : contentData[i].cancelReqPrice
							}
							count++;
							tempData.push(rowData);

							let groupClass = flag ? 'order-group-odd-cancel' : 'order-group-cancel';
							const classList = [groupClass]; // 기본으로 배경색 클래스 추가

						    // 그룹의 마지막 행이면 구분선 클래스 추가
						    if (count === detail.length - 1) {
						      classList.push('order-group-last-row');
						    }

							if(count == 1){

								rowData['_attributes'] = {
									rowSpan: {
										cancelRum: total,
										cancelReqDate: total,
										cancelReasonName: total,
										cancelReasonDetail : total,
										cancelReqPrice: total,
					                },
					                className: {
					                    row: classList // 첫 번째 행에도 classList 적용
					                }
								}
							}else{
								rowData['_attributes'] = {
					                className: {
					                    row: classList // 첫 번째 행이 아닌 경우에도 classList 적용
					                }
					            };
							}
						}
					}
					flag = !flag;

				}

				let Grid = tui.Grid;

				const grid = new Grid({
					el : document.getElementById('cancelGrid'),
					columns : [
						{
							header : 'No',
							name : 'cancelRum',
							align : 'center',
							width : 10,
						},
						{
							header : '취소유형',
							name : 'cancelReasonName',
							align : 'center',
							width : 90
						},
						{
							header : '취소일자',
							name : 'cancelReqDate',
							width : 110,
							formatter: ({ value }) => {
						        const date = new Date(value);
						        return `\${date.getFullYear()}-\${String(date.getMonth() + 1).padStart(2, '0')}-\${String(date.getDate()).padStart(2, '0')}`;
						 	}
						},
						{
							header : '취소사유',
							name : 'cancelReasonDetail',
							width: 200,
						},
						{
							header : '상품명',
							name : 'goodsNm',
						},

						{
							header : '옵션명',
							name : 'goodsOptNm',
							width : 80,
						},
						{
							header : '수량',
							name : 'orderDetQty',
							align : 'right',
							width : 50,
							formatter : ({ value }) => value + '개',
						},
						{
							header : '옵션별 금액',
							name : 'goodsOptPrice',
							align : 'right',
							width : 93,
							formatter: ({ value }) => value.toLocaleString('ko-KR') + '원'
						},
						{
							header : '옵션 합계',
							name : 'optTotal',
							align : 'right',
							width : 90,
							formatter: ({ value }) => value.toLocaleString('ko-KR') + '원'
						},
						{
							header : '총 취소금액',
							name : 'cancelReqPrice',
							align : 'right',
							width : 120,
							formatter: ({ value }) => value.toLocaleString('ko-KR') + '원'
						},

					],
					data : tempData,
				})
			}
		},
		error : function(error){
			console.log(error.status)
		}
	})
}

function chart(dataset){

	if(myChartInstance){
		myChartInstance.destroy();
	}
	let temp = 0;
	for(let i=0; i<dataset.length; i++){
		let data = dataset[i].data;

		for(let j=0; j<data.length; j++){
			if(temp < data[j]){
				temp = data[j];
			}
		}
	}

	let maxY;
	if(temp % 2 == 0){
		maxY = temp + 2;
	}else{
		maxY = temp + 3;
	}

	let ctx = document.getElementById("myChart");
	myChartInstance = new Chart(ctx, {
		type : 'bar',
		data : {
			labels : months,
			datasets : dataset
		},
		options : {
			responsive:false,
			scales : {
				y: {
					beginAtZero : true,
					max: maxY,
					ticks : {
						precision : 0
					}
				},

			}
		}
	})
}

let orderChartInstance = null;

function orderChartDisplay(dataset){
	let cha = document.getElementById("orderChart");
	orderChartInstance = new Chart(cha, {
		data : {
			labels : months,
			datasets : dataset
		},
		options : {
			onClick: function(event, elements, chart) {
	          let clickMonth = elements[0].index + 1;

	          let dataIndex = elements[0].datasetIndex;

	          let label = chart.data.datasets[dataIndex].label

	          let type = chart.data.datasets[dataIndex].type

	          if(type != 'bar' || elements.length == 0){
	        	  return;
	          }


	          let curYear = moment().year();
	          let yearMonth = curYear + '-' + clickMonth;

	          let curMonthStart = moment(yearMonth).startOf("month").format("YYYY/MM/DD");
	          let curMonthEnd = moment(yearMonth).endOf("month").format("YYYY/MM/DD");

	          let data = {
	        	  "currentPage" : 1,
	        	  "startDate" : curMonthStart,
	        	  "endDate" : curMonthEnd,
	        	  "label" : label
	          }

	          orderGridData(data);

	          $("#gridPageArea").on("click",'a',function(e){
	      		e.preventDefault();
	      		let currentPage = e.target.dataset.page;

	      		let data = {
      	        	  "currentPage" : currentPage,
      	        	  "startDate" : curMonthStart,
      	        	  "endDate" : curMonthEnd,
      	        	  "label" : label
      	          }

      	          orderGridData(data);
	      		});

	          $("#cancelGridPageArea").on("click",'a',function(e){
		      		e.preventDefault();
		      		let currentPage = e.target.dataset.page;

		      		let data = {
	      	        	  "currentPage" : currentPage,
	      	        	  "startDate" : curMonthStart,
	      	        	  "endDate" : curMonthEnd,
	      	        	  "label" : label
	      	          }

	      	          orderGridData(data);
		      		});

	        },
	        responsive : true,
		}
	})
}

function orderChart(memUsername){
	$.ajax({
		url : '/admin/community/member/orderData/'+memUsername,
		type : 'get',
		success : function(res){
			let dataset = res;
			orderChartDisplay(dataset);
		},
		error : function(error){
			console.log(error.status)
		}
	})
}

$(function(){

	$("a[id=listBtn]").on("click",function(){
		let currentPage = sessionStorage.getItem("currentPage");
		let searchWord = sessionStorage.getItem("searchWord");
		let searchType = sessionStorage.getItem("searchType");
		let preUrl = `/admin/community/member/main?searchType=\${searchType}&searchWord=\${searchWord}&currentPage=\${currentPage}`
		$("#listBtn").attr("href",preUrl);
	});

	let spanMemberName = $("#detailMemberName");
	let spanNickName = $("#detailMemberNickname");
	let spanEmail = $("#detailMemberEmail");
	let spanStatType = $("#detailMemberStatus");

	let firstName = $("#editfirstName");
	let lastName = $("#editLastName");
	let nickName = $("#editMemberNickname");
	let email = $("#editMemberEmail");
	let statType = $("#editMemberStatus");

	let formActionButtons =$("#formActionButtons");
	let flag = false;

	$("#editMemberInfoBtn").on("click",function(){

		if(!flag){

			nickName.val(spanNickName.html());
			email.val(spanEmail.html());

			spanMemberName.attr("style","display:none");
			spanNickName.attr("style","display:none");
			spanEmail.attr("style","display:none");
			spanStatType.attr("style","display:none");

			firstName.attr("style","display:block");
			lastName.attr("style","display:block");
			nickName.attr("style","display:block");
			email.attr("style","display:block");
			statType.attr("style","display:block");
			formActionButtons.attr("style","display:block");
			$("#editMemberInfoBtn").attr("style","display:none");
		}
	});

	$("#cancelEditBtn").on("click",function(){
		spanMemberName.attr("style","display:block");
		spanNickName.attr("style","display:block");
		spanEmail.attr("style","display:block");
		spanStatType.attr("style","display:block");

		firstName.attr("style","display:none");
		lastName.attr("style","display:none");
		nickName.attr("style","display:none");
		email.attr("style","display:none");
		statType.attr("style","display:none");
		formActionButtons.attr("style","display:none");
		$("#editMemberInfoBtn").attr("style","display:block;float: right; margin-top: -5px;");
	});

	$("#saveMemberInfoBtn").on("click",function(){
		let memUsername = $("#detailMemberId").html();

		let data = new FormData();
		data.append("memNicknm",nickName.val());
		data.append("memStatCode",statType.val());
		data.append("peopleVO.peoLastNm", lastName.val());
		data.append("peopleVO.peoFirstNm", firstName.val());
		data.append("peopleVO.peoEmail", email.val());

		Swal.fire({
			title : "수정하시겠습니까?",
			icon : "question",
			showConfirmButton : true,
			showCancelButton : true,
			confirmButtonText : "예",
			cancelButtonText : "아니오"
		}).then((result) => {
			if(result.isConfirmed){
				$.ajax({
					url : "/admin/community/member/update/" + memUsername,
					type : "post",
					data : data,
					processData : false,
					contentType : false,
					success : function(res){
						if(res == "OK"){
							Swal.fire({
								title : "수정완료!",
								text : "수정이 완료되었습니다.",
								icon : "success",
								showConfirmButton : true,
							}).then((result) => {
								location.href = "/admin/community/member/detail/" + memUsername;
							});
						}
					},
					error : function(error, status, thrown){
						console.log(error.status)
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

	$("#deleteMemberBtn").on("click", function(){
		let memUsername = $("#detailMemberId").html();

		Swal.fire({
			title : "탈퇴요청",
			text : "정말로 탈퇴처리하시겠습니까?",
			icon : "warning",
			showCancelButton : true,
			confirmButtonText : "예",
			cancelButtonText : "아니오"
		}).then((result) => {
			if(result.isConfirmed){
				$.ajax({
					url : "/admin/community/member/delete/" + memUsername,
					type : "post",
					success : function(res){
						if(res == "OK"){
							Swal.fire({
								title : "탈퇴처리완료!",
								text : "정상적으로 탈퇴처리되었습니다.",
								icon : "success",
							}).then((result) => {
								location.href = "/admin/community/member/main";
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

	let cardInfo = document.querySelectorAll("#cardInfo");
	cardInfo.forEach(div => {
		div.addEventListener("click",function(e){
			let artGroupNo = $(this)[0].dataset.artgroupno;
			let memUsername = $(this)[0].dataset.memusername;
			let comuProfileNo = $(this)[0].dataset.comuprofileno;


			$("#divMyChart").html(`<canvas id="myChart" height="200"></canvas>`);

			$.ajax({
				url : '/admin/community/member/cntData/'+artGroupNo,
				type : 'get',
				data : {
					"memUsername" : memUsername,
					"artGroupNo" : artGroupNo,
					"comuProfileNo" : comuProfileNo
				},
				success : function(res){
					chart(res);
				},
				error : function(error){
					console.log(error.status);
				}
			});
		})
	})

	let card = document.querySelectorAll('.membershipCard');
	card.forEach( div => {
		div.addEventListener("click",function(){
			div.classList.toggle('flipped');
		})
	})

	orderChart(memUsername);
	$("#sellOrderCollapse").on("show.bs.collapse", function(e){

	});

	$("#cancelOrderCollapse").on("hide.bs.collapse", function(){
	})

	$("#cancelOrderCollapse").on("show.bs.collapse", function(){
	})

});

</script>
<body>
<div class="emp-container">
        <%@ include file="../modules/header.jsp" %>

        <div class="emp-body-wrapper">
            <%@ include file="../modules/aside.jsp" %>
				<main class="emp-content" style="font-size: large;">
					<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
					  <ol class="breadcrumb">
					    <li class="breadcrumb-item"><a href="#">아티스트 커뮤니티 관리</a></li>
					    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/community/member/main" style="color:black;">회원목록</a></li>
					    <li class="breadcrumb-item active" aria-current="page">회원 상세</li>
					  </ol>
					</nav>
					<section id="memberDetailSection" class="ea-section">
						<div class="ea-section-header">
				            <h2 id="memberDetailTitle">회원 상세 정보</h2>

				        </div>
				        <div class="detail-card basic-info">
				        	<h3>기본 정보
				                <button type="button" class="ea-btn sm delete-member-btn" id="deleteMemberBtn" style="float: right; margin-top: -5px; margin-right: 10px;"><i class="fas fa-trash-alt"></i> 탈퇴</button>
				                <button type="button" class="ea-btn sm outline" id="editMemberInfoBtn" style="float: right; margin-top: -5px;"><i class="fas fa-edit"></i>수정</button>
				            </h3>
					        <form id="memberInfoForm">
					        	<dl class="info-list">
					        		<dt>아이디:</dt>
					                <dd><span class="view-mode-text" id="detailMemberId">${memberVO.memUsername }</span></dd>

						        	<dt>이름:</dt>
						            <dd>
						            	<c:set value="${memberVO.peopleVO.peoFirstNm }" var="fristNm" />
						            	<c:set value="${memberVO.peopleVO.peoLastNm }" var="lastNm" />
						                <span class="view-mode-text" id="detailMemberName">${lastNm }${fristNm }</span>
						                <input type="text" id="editLastName" name="memberName" style="display:none;" class="ea-form-control" value="${lastNm }">
						                <input type="text" id="editfirstName" name="memberName" style="display:none;" class="ea-form-control"  value="${fristNm }">
						            </dd>

						            <dt>닉네임:</dt>
					                <dd>
					                    <span class="view-mode-text" id="detailMemberNickname">${memberVO.memNicknm }</span>
					                    <input type="text" id="editMemberNickname" name="memberNickname" style="display:none;" class="ea-form-control">
					                </dd>

					                <dt>이메일:</dt>
					                <dd>
					                    <span class="view-mode-text" id="detailMemberEmail">${memberVO.peopleVO.peoEmail }</span>
					                    <input type="email" id="editMemberEmail" name="memberEmail" style="display:none;" class="ea-form-control">
					                </dd>

					                <dt>가입일:</dt>
					                <dd><span class="view-mode-text" id="detailMemberJoinDate">${memberVO.memRegDate }</span></dd>

					                <dt>가입경로:</dt>
					                <dd><span class="view-mode-text">${memberVO.memRegDetCode }</span></dd>

					                <dt>회원 상태:</dt>
					                <dd>
					                	<c:choose>
				              				<c:when test="${memberVO.memStatDetCode eq '정상'}">
				              					<span class="status-badge answered" id="detailMemberStatus" data-code=${memberVO.memStatCode }>${memberVO.memStatDetCode }</span>
				              				</c:when>
				              				<c:when test="${memberVO.memStatDetCode eq '정지' }">
				              					<span class="status-badge pending" id="detailMemberStatus">${memberVO.memStatDetCode }</span>
				              				</c:when>
				              				<c:otherwise>
				              					<span class="status-badge danger" id="detailMemberStatus">${memberVO.memStatDetCode }</span>
				              				</c:otherwise>
				              			</c:choose>
					                    <select id="editMemberStatus" name="memberStatus" style="display:none;" class="ea-filter-select">
					                    	<c:forEach items="${codeList }" var="code">
					                    		<option value="${code.commCodeDetNo }" <c:if test="${code.commCodeDetNo eq memberVO.memStatCode }">selected</c:if> >${code.description }</option>
					                    	</c:forEach>
					                    </select>
					                </dd>
					        	</dl>
					        	<div class="btn-group">
						        	<a href="/admin/community/member/main" class="ea-btn outline sm" id="listBtn"><i class="fas fa-list"></i> 목록</a>
						        	<div class="ea-form-actions" id="formActionButtons" style="display:none;">
						                <button type="button" class="ea-btn primary" id="saveMemberInfoBtn">저장</button>
						                <button type="button" class="ea-btn outline" id="cancelEditBtn">취소</button>
						            </div>
					        	</div>
					        </form>
				        </div>
				        <div class="detail-card basic-info comuList">
				        	<div>
					        	<h3>팔로우 정보 </h3>
				        	</div>
				        	<div class="comuListArea">
				        		<c:choose>
				        			<c:when test="${joinComuList.size() != 0 }">
				        				<c:forEach items="${joinComuList }" var="comu">
											<c:choose>
												<c:when test="${comu.comuDelYn eq 'Y' }">
													<c:set value="border-danger" var="borderCss" />
												</c:when>
												<c:otherwise>
													<c:set value="border-primary" var="borderCss" />
												</c:otherwise>
											</c:choose>
											<div class="card ${borderCss } mb-3" id="cardInfo" style="max-width: 18rem;" data-artGroupNo="${comu.artGroupNo }"
												data-memUsername="${memberVO.memUsername }"
												data-comuProfileNo="${comu.comuProfileNo }"
												data-bs-toggle="collapse" data-bs-target="#comuDetailCollapse"
												role="button" aria-expanded="false" aria-controls="comuDetailCollapse">
												<div class="comuCard-header">${comu.comuNm } APT</div>
												<div class="comuImg">
													<img src="${comu.comuProfileImg }">
												</div>
												<div class="card-body">
													<h5 class="card-title">${comu.comuNicknm }</h5>
													<div class="card-text">가입일 : ${comu.comuRegDate }</div>
													<div class="card-text">게시글 수 : ${comu.postCnt }</div>
													<div class="card-text">댓글 수 : ${comu.replyCnt }</div>
													<div class="card-text">탈퇴여부 :
													<c:choose>
														<c:when test="${comu.comuDelYn eq 'Y' }">
															<span class="delete">활동 중단</span>
														</c:when>
														<c:otherwise>
															<span class="comuActive">활동중</span>
														</c:otherwise>
													</c:choose>
													</div>
												</div>
											</div>
										</c:forEach>
				        			</c:when>
				        			<c:otherwise>
				        				팔로우 중인 APT가 없습니다.
				        			</c:otherwise>
				        		</c:choose>
							</div>
						</div>
						<div class="collapse" id="comuDetailCollapse">
							<div class="detail-card basic-info">
								<div class="card card-body" id="divMyChart">
									<canvas id="myChart" height="100"></canvas>
								</div>
							</div>
						</div>
						<div class="detail-card basic-info">
							<h3>멤버십 정보</h3>
							<c:choose>
								<c:when test="${not empty membershipList }">
									<c:forEach items="${membershipList }" var="mbsp" varStatus="i">
										<c:set value="${mbsp[i.index] }" var="item"/>
										<div class="membershipCard">
											<div class="card border-primary front mb-3"
												style="max-width: 18rem;">
												<div class="card-header">
													<h3 class="membership-plan-name"><i class="fa-solid fa-gem" style="margin-right: 8px; color: #63DEFD;"></i><c:out value="${item.membershipDesc.mbspNm}" /></h3>
													<span class="card-plan-number">No. <c:out value="${item.membershipDesc.mbspNo}" /></span>
												</div>
												<div class="card-body text-primary">
													<p class="card-info-item"><strong>아티스트:</strong> <c:out value="${item.membershipDesc.artistGroupVO.artGroupNm}" /></p>
													<p class="card-info-item"><strong>담당자:</strong> <c:out value="${item.membershipDesc.artistGroupVO.empUsername}" /></p>
													<p class="card-info-item"><strong>가격:</strong> ₩<fmt:formatNumber value="${item.membershipDesc.mbspPrice}" type="number" groupingUsed="true" /></p>
													<p class="card-info-item"><strong>기간:</strong> <c:out value="${item.membershipDesc.mbspDuration}" />일</p>
													<p class="card-info-item"><strong>가입일:</strong> <fmt:formatDate value="${item.subStartDate}" pattern="yyyy-MM-dd" /></p>
													<p class="card-info-item"><strong>종료일:</strong> <fmt:formatDate value="${item.subEndDate}"  pattern="yyyy-MM-dd" /></p>
													<p class="card-info-item"><strong>상태:</strong> <c:out value="${item.codeDetailVO.description}" /></p>
												</div>
											</div>
											<div class="card border-primary back mb-3"
												style="max-width: 18rem;">
												<div class="card-header">구독 이력</div>
												<div class="card-body text-primary">
													<c:choose>
														<c:when test="${not empty item.subMembership.entrySet() }">
															<c:forEach items="${item.subMembership.entrySet() }" var="historyMbspList" varStatus="j">
																<c:set value="${historyMbspList.value }" var="historyMbsp"/>
																<p class="card-info-item"><strong>내역 ${j.index + 1  }:</strong> <fmt:formatDate value="${historyMbsp.subStartDate}" pattern="YYYY-MM-dd" /> ~ <fmt:formatDate value="${historyMbsp.subEndDate}" pattern="YYYY-MM-dd"/> </p>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<p class="card-info-item"><strong>이전 이력이 없습니다.</strong></p>
														</c:otherwise>
													</c:choose>

												</div>
											</div>
										</div>
									</c:forEach>
								</c:when>
								<c:otherwise>
									이용중인 멤버십이 없습니다.
								</c:otherwise>
							</c:choose>
						</div>
						<div class="detail-card basic-info">
							<h3>구매목록</h3>
							<canvas id="orderChart"  height="100"></canvas>
						</div>

						<div class="collapse" id="sellOrderCollapse">
							<div class="detail-card basic-info">
							<h3>판매 상세</h3>
								<div class="card card-body" id="sellGridArea">
									<div id="grid"></div>
								</div>
								<div id="gridPageArea">

								</div>
							</div>
						</div>
						<div class="collapse" id="cancelOrderCollapse">
							<div class="detail-card basic-info">
							<h3>취소 상세</h3>
								<div class="card card-body" id="cancelGridArea">
									<div id="cancelGrid"></div>
								</div>
								<div id="cancelGridPageArea">
								</div>
							</div>
						</div>
				</section>
				</main>
			</div>
		</div>
<%@ include file="../../modules/footerPart.jsp" %>

<%@ include file="../../modules/sidebar.jsp" %>
</body>
</html>