<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>

<link rel="stylesheet" type="text/css" href="/css/theme_red.css">
<title>dashboard</title>
<script src="https://code.jquery.com/jquery-3.0.0.min.js"></script>
<script type="text/javascript" src="<c:url value="/jqplot/jquery.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/jquery.jqplot.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.canvasTextRenderer.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.canvasAxisLabelRenderer.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.enhancedLegendRenderer.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.pieRenderer.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.barRenderer.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.categoryAxisRenderer.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.dateAxisRenderer.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.highlighter.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.canvasAxisTickRenderer.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.cursor.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.highlighter.min.js" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/jqplot/jquery.jqplot.min.js" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/jqplot/jquery.jqplot.min.css" />" />

<script type="text/javascript">
var i_barChart1 = [90, 80, 60, 80, 70, 60, 40, 23, 56, 48, 66, 123, 78];
var i_barChart2 = [100.12, 50.4456, 70, 600, 900, 500, 100, 890, 975, 624, 674, 351, 784];
var i_DataCntlineChart = ${selectInnerTRSDataCntList};
var i_DataSumlineChart = ${selectInnerTRSDataSumList};
var o_barChart1 = [70, 120, 50, 130, 70, 80, 60];
var o_barChart2 = [110, 800, 120, 110, 90, 40, 80];
var o_DataCntlineChart = ${selectOuterTRSDataCntList};
var o_DataSumlineChart = ${selectOuterTRSDataSumList}; 
var selectInnerTopFileExtlist = ${selectInnerTopFileExt};
var selectOuterTopFileExtlist = ${selectOuterTopFileExt};

var t_xaxis = ['00시','01시','02시','03시','04시','05시','06시','07시','08시','09시','10시','11시','12시','13시','14시','15시','16시','17시','18시','19시','20시','21시','22시','23시'];

function innerTRSChart(transChart, np_cd) {
	var np_cd = np_cd;
	$.ajax({
			type:"GET",
			url:"/dashboard/innerDashboardChart.lin",
			data : {"transChart" : transChart, "np_cd" : np_cd},
			async : false,
			cache : false,
			success:function(data){
				$("#innerTRSChart").empty();
				var data = $.parseJSON(data);
				i_DataCntlineChart = data.selectInnerTRSDataCntList;
				i_DataSumlineChart = data.selectInnerTRSDataSumList;

				if (transChart == "t"){
					t_xaxis = ['00시','01시','02시','03시','04시','05시','06시','07시','08시','09시','10시','11시','12시','13시','14시','15시','16시','17시','18시','19시','20시','21시','22시','23시'];
				} else if (transChart == "d"){
					var result = new Array();	
					for(var i=0; i<i_DataCntlineChart.length; i++){
						result[i] = i+1+ "일";
					result.push(result[i]);
					}
					result.pop();
					t_xaxis = result;
				} else if (transChart == "w"){
					t_xaxis = ['월','화','수','목','금','토','일'];
				} else if (transChart == "m"){
					t_xaxis = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
				}
				var comment = "<div id='i_doublegraph' class='f_left mg_t20' style='width: 99%; height: 20%;'>"
								+"</div>";

				$("#innerTRSChart").append(comment);

				jqplotGragh('i_doublegraph',[i_barChart1,i_barChart2,i_DataCntlineChart,i_DataSumlineChart]);
			}
	});
}

function outerTRSChart(transChart, np_cd) {
	var np_cd = np_cd;
	$.ajax({
			type:"GET",
			url:"/dashboard/outerDashboardChart.lin",
			data : {"transChart" : transChart, "np_cd" : np_cd},
			async : false,
			cache : false,
			success:function(data){
				$("#outerTRSChart").empty();
				var data = $.parseJSON(data);
				o_DataCntlineChart = data.selectOuterTRSDataCntList;
				o_DataSumlineChart = data.selectOuterTRSDataSumList;

				if (transChart == "t"){
					t_xaxis = ['00시','01시','02시','03시','04시','05시','06시','07시','08시','09시','10시','11시','12시','13시','14시','15시','16시','17시','18시','19시','20시','21시','22시','23시'];
				} else if (transChart == "d"){
					var result = new Array();	
					for(var i=0; i<o_DataCntlineChart.length; i++){
						result[i] = i+1+ "일";
					result.push(result[i]);
					}
					result.pop();
					t_xaxis = result;
				} else if (transChart == "w"){
					t_xaxis = ['월','화','수','목','금','토','일'];
				} else if (transChart == "m"){
					t_xaxis = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
				}
				var comment = "<div id='o_doublegraph' class='f_left mg_t20' style='width: 99%; height: 20%;'>"
								+"</div>";

				$("#outerTRSChart").append(comment);

				jqplotGragh('o_doublegraph',[o_barChart1,o_barChart2,o_DataCntlineChart,o_DataSumlineChart]);
		}
	});
}

//일간,주간,월간 구분자를 판별하는 function.
function topUser(topUserList) {
	var response;
	var innerMid="";
	var outerMid="";
	$.ajax({
		type:"GET",
		url:"/dashboard/topUserList.lin",
		data : { "topUserList" : topUserList },
		dataType: "json",
		async : false,
		cache : false,
		success:function(data){
	 		var arr = new Array();
			var obj = new Object();
			var test="";
			var innerResult;
			var outerResult;
			arr = data;
			///////////////////보안영역 테이블/////////////////////////
			var selectInnerTopUserListSize = arr[0].selectInnerTopUserListSize;
				if (selectInnerTopUserListSize==0) {
					var innerNullResult = 
						"<table summary='그래프1 상세정보' style='table-layout: fixed;'>"+
						"<thead>"+
						"<tr>"+
						"<th colspan='3'>보안</th>"+
						"</tr>"+
						"<tr>"+
						"<th class='t_center Rborder'>순위</th>"+
						"<th class='t_center Rborder'>사용자</th>"+
						"<th class='t_center Rborder'>전송횟수</th>"+
						"</tr>"+
						"</thead>"+
						"<tbody>" + 
						"<tr>"+
						"<td class='t_center' colspan='3'><div class='no_result'>"+"결과가 없습니다."+"</div></td>"+
						"</tr>"+
						"</tbody>"+
						"</table>";

					$("#innertopUserList").html(innerNullResult);
				} else {
						var innerFirst =
						"<table summary='그래프1 상세정보' style='table-layout: fixed;'>"+
						"<thead>"+
						"<tr>"+
						"<th colspan='3'>보안</th>"+
						"</tr>"+
						"<tr>"+
						"<th class='t_center Rborder'>순위</th>"+
						"<th class='t_center Rborder'>사용자</th>"+
						"<th class='t_center Rborder'>전송횟수</th>"+
						"</tr>"+
						"</thead>"+
						"<tbody>" ;

						for(var i=0; i<selectInnerTopUserListSize; i++){
						innerMid +=
						"<tr>"+
						"<td class='t_center Rborder'>"+(i+1)+"</td>"+
						"<td class='t_center Rborder'>"+arr[i].inner_topUsers_id+"</td>"+
						"<td class='t_center Rborder'>"+arr[i].inner_topUsers_cnt+"건"+"</td>"+
						"</tr>";

						}
						var innerEnd = 
						"</tbody>"+
						"</table>"; 

						innerResult = innerFirst + innerMid + innerEnd ;

					$("#innertopUserList").html(innerResult);
				}
				///////////////////비-보안영역 테이블/////////////////////////
				var selectOuterTopUserListSize = arr[1].selectOuterTopUserListSize;
				if (selectOuterTopUserListSize==0) {
					var outerNullResult = 
						"<table summary='그래프1 상세정보' style='table-layout: fixed;'>"+
						"<thead>"+
						"<tr>"+
						"<th colspan='3'>비-보안</th>"+
						"</tr>"+
						"<tr>"+
						"<th class='t_center Rborder'>순위</th>"+
						"<th class='t_center Rborder'>사용자</th>"+
						"<th class='t_center Rborder'>전송횟수</th>"+
						"</tr>"+
						"</thead>"+
						"<tbody>" +
						"<tr>"+
						"<td class='t_center' colspan='3'><div class='no_result'>"+"결과가 없습니다."+"</div></td>"+
						"</tr>"+
						"</tbody>"+
						"</table>";

					$("#outertopUserList").html(outerNullResult);
				} else{
					var outerFirst =
						"<table summary='그래프1 상세정보' style='table-layout: fixed;'>"+
						"<thead>"+
						"<tr>"+
						"<th colspan='3'>비-보안</th>"+
						"</tr>"+
						"<tr>"+
						"<th class='t_center Rborder'>순위</th>"+
						"<th class='t_center Rborder'>사용자</th>"+
						"<th class='t_center Rborder'>전송횟수</th>"+
						"</tr>"+
						"</thead>"+
						"<tbody>" ;

					var j = 1;
					for (var i=selectInnerTopUserListSize; i<arr.length; i++){
						outerMid +=
						"<tr>"+
						"<td class='t_center Rborder'>"+j+"</td>"+
						"<td class='t_center Rborder'>"+arr[i].outer_topUsers_id+"</td>"+
						"<td class='t_center Rborder'>"+arr[i].outer_topUsers_cnt+"건"+"</td>"+
						"</tr>";
						j = j+1;
					}

						var outerEnd =
						"</tbody>"+
						"</table>";

						outerResult = outerFirst + outerMid + outerEnd ;

					$("#outertopUserList").html(outerResult);
				}
		}
	});
}

	var reloadPageInterval = 60000;
	var doReloadFuncInterval = 5000;
	var lastActionTime;
	var reloadTimerId;

function doReloadPage() {
	var date = new Date();
	var nowTime = date.getTime();
	if (lastActionTime + reloadPageInterval < nowTime) {
	clearInterval(reloadTimerId);
	location.reload(true);
	}
}

function updateLastActionTime() {
	var date = new Date();
	lastActionTime = date.getTime();
}

//페이지 리로드
function setReloadPageInterval() {
	var date = new Date();
	lastActionTime = date.getTime();
	if (reloadPageInterval != 0) {
		reloadTimerId = setInterval("doReloadPage()", doReloadFuncInterval);
	}
	addEvent(document, "mousemove", updateLastActionTime);
	addEvent(document, "keydown", updateLastActionTime);
}

$(document).ready(function() {	
	jqplotData();
	setReloadPageInterval();
});

function jqplotData(){
	jqplotGragh('i_doublegraph',[i_barChart1,i_barChart2,i_DataCntlineChart,i_DataSumlineChart])
	jqplotGragh('o_doublegraph',[o_barChart1,o_barChart2,o_DataCntlineChart,o_DataSumlineChart])
	pieChart('i_pieGraph',selectInnerTopFileExtlist)
	pieChart('o_pieGraph',selectOuterTopFileExtlist)
}

function jqplotGragh(divId,dataList){
	$.jqplot (divId, dataList,
				{
				 series:[{
					label:'횟수평균',
					renderer:$.jqplot.BarRenderer,		 			
					linePattern: 'dashed',
					markerOptions: { style:'filledSquare' },
					pointLabels:{show:true},
					yaxis:'y2axis',
					rendererOptions : {
							barWidth : 3                    // 막대그래프의 넓이를 지정
							,barPadding : 5                // 막대그래프의 여백을 지정
							,highlightMouseOver : false
							// 막대그래프의 클릭여부를 지정 (기본값 : true)
					},
						},
					{
					label:'크기평균',
					renderer:$.jqplot.BarRenderer,
					linePattern: 'dashed',
					markerOptions: { style:'filledSquare' },
					pointLabels:{show:true},
					yaxis:'yaxis',
					rendererOptions : {
							barWidth : 3                    // 막대그래프의 넓이를 지정
							,barPadding : 5                // 막대그래프의 여백을 지정
							,highlightMouseOver : false    // 막대그래프의 클릭여부를 지정 (기본값 : true)
					},
					}, 
					{// lineChart 배열을 꺽은선 그래프로 지정한다.
						label:'자료전송횟수',  
						disableStack : true,      // 데이터의 합또한 합쳐지는 것을 방지하기위해 꺽은선 그래프는 disableStack을 true로 선언
							/* markerOptions: { style:'x' },
						pointLabels:{show:true}, */
					// jQuery.jqplot.LineRenderer(꺽은선 그래프)의 플러그인은 기본적으로 지정하지 않아도 된다.
						renderer : $.jqplot.LineRenderer,
						yaxis:'y2axis'
						
					},
					{// lineChart 배열을 꺽은선 그래프로 지정한다.
						label:'자료전송크기',
						disableStack : true,      // 데이터의 합또한 합쳐지는 것을 방지하기위해 꺽은선 그래프는 disableStack을 true로 선언
		/*				markerOptions: { style:'x' },
						pointLabels:{show:true}, */
						// jQuery.jqplot.LineRenderer(꺽은선 그래프)의 플러그인은 기본적으로 지정하지 않아도 된다.
						renderer : $.jqplot.LineRenderer,
						yaxis:'yaxis',
						}
						
					],
					legend :{  // Legend 옵션  
					renderer : $.jqplot.EnhancedLegendRenderer,
						show : true, // Legend 표시 유무
						placement : 'inside', // Legend 위치 (Default값은 inside) 
						textColor : 'black',  // Legend 내부 Text Color
						rowSpacing : '0px',  // Legend 들간의 사이 공간
						location : 'ne',  // Legend 위치 (e,w,s,n)(동,서,남,북) 조합가능
						fontsize : '3px'
					},
					highlighter: {
						show: true,
						showLabel: true,
						tooltipAxes: 'y',
						sizeAdjust: 7.5 , 
						tooltipLocation : 'ne'
						},
				axes: {
					xaxis: {
						min:0,
						max:24,
						label:'시간',
						fontFamily : 'Helvetica',
						//renderer:$.jqplot.DateAxisRenderer,
						renderer:$.jqplot.CategoryAxisRenderer,
						ticks : t_xaxis,
						/* tickOptions:{
							formatString : '%y/%m/%d'
						}, */
						},
					yaxis: {
					labelRenderer: $.jqplot.CanvasAxisTickRenderer,
						label:'(MB)',
//						text:('100px','100px','(MB)'),
						min:0,
					/* 	labelOptions:{
							fontFamily:'Helvetica',
							fontSize: '10pt',
							angle : 0,
							labelPosition : 'end'
						}, */
						tickOptions:{
								fontFamily:'Helvetica',
								fontSize: '8pt',
								//angle : 0,
								labelPosition : 'end',
								formatString:'%g'
								},
						autoscale: true
					},
					y2axis: {
					labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
						label:'횟수',
						min:0,
						labelOptions:{
							fontFamily:'Helvetica',
							fontSize: '10pt',
							angle : 0,
							labelPosition : 'end',
						},
						tickOptions:{
						fontSize : 8,
						formatString : '%g'
						},
						autoscale: true
						}
					}
				}
	);
}

function pieChart(divId,dataList){	
	$.jqplot (divId, dataList,
			{
				seriesDefaults: {
				//원형으로 렌더링
					renderer: $.jqplot.PieRenderer,
				//원형상단에 값보여주기(알아서 %형으로 변환)
					rendererOptions: {
						showDataLabels : true,
						startAngle: 90,
						sliceMargin: 1,
						highlightMouseOver: true
					},
				/*  cursor: {
					style: 'pointer',       // A CSS spec for the cursor type to change the
											// cursor to when over plot.
					show: true,
					showTooltip: true,      // show a tooltip showing cursor position.
					}, */
					highlighter: {
							show: true,
							useAxesFormatters: false,
							tooltipLocation:'n',
							tooltipSeparator:', ',
							tooltipFormatString: '%s%d',
							fadeTooltip:'fast',
						}
				},
				//우측 색상별 타이틀 출력
				legend: { 
							show:true, 
							location: 'e' 
						}
			}
	
	);
}

</script>
</head>
<body onload="pageRefresh()">
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/user/userManagement.lin" />">
<div class="rightArea">
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold"></h2>
			<p class="breadCrumbs">인사관리 > 인사관리</p>
		</div>
	</div>
	<div class="conWrap dashboardBox">
		<h3>보안영역 서버 자원 사용량</h3>
		<div class="conBox graphBox">
			<h2>
				<p align="center">HostIp : ${innerDashBoardChartForm.hostIp}</p>
			</h2>
			<br /> <br />
			<!-- 컬러 적용시 graphItem뒤에 한칸띄고 red, orange, sky, green, pink, purple-->
			<div class="graphItem pink">
				<p class="name">CPU</p>
				<p class="percentBar">
					<span class="colorBox"
						style="width:${innerDashBoardChartForm.hostCpu}px"></span>
				</p>
				<p class="percentView">${innerDashBoardChartForm.hostCpu}%</p>
			</div>
			<div class="graphItem purple">
				<p class="name">MEMORY</p>
				<p class="percentBar">
					<span class="colorBox"
						style="width:${innerDashBoardChartForm.hostMemory}px"></span>
				</p>
				<p class="percentView">${innerDashBoardChartForm.hostMemory}%</p>
			</div>
			<div class="graphItem green">
				<p class="name">HDD</p>
				<p class="percentBar"
					style="width:${innerDashBoardChartForm.diskSize}px">
					<span class="colorBox"></span>
				</p>
				<p class="percentView">${innerDashBoardChartForm.diskSize}</p>
			</div>
		</div>
	</div>
	<div class="conWrap dashboardBox">
		<h3>비-보안영역 서버 자원 사용량</h3>
		<div class="conBox graphBox">
			<div class="graph_line1">
				<div class="graph_box">
					<h2>
						<p align="center">HostIp : ${outerDashBoardChartForm.hostIp}</p>
					</h2>
					<br /> <br />
					<!-- 컬러 적용시 graphItem뒤에 한칸띄고 red, orange, sky, green, pink, purple-->
					<div class="graphItem pink">
						<p class="name">CPU</p>
						<p class="percentBar">
							<span class="colorBox" style="width:${outerDashBoardChartForm.hostCpu}px"></span>
						</p>
						<p class="percentView">${outerDashBoardChartForm.hostCpu}%</p>
					</div>
					<div class="graphItem purple">
						<p class="name">MEMORY</p>
						<p class="percentBar">
							<span class="colorBox" style="width:${outerDashBoardChartForm.hostMemory}px"></span>
						</p>
						<p class="percentView">${outerDashBoardChartForm.hostMemory}%</p>
					</div>
					<div class="graphItem green">
						<p class="name">HDD</p>
						<p class="percentBar" style="width:${outerDashBoardChartForm.diskSize}px">
							<span class="colorBox"></span>
						</p>
						<p class="percentView">${outerDashBoardChartForm.diskSize}</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="conWrap dashboardBox">
		<h3>보안영역 최다 파일 확장자 TOP5</h3>
		<div class="conBox graphBox">
			<div class="graph_line1">
				<div class="graph_box">
					<c:choose>
						<c:when test="${not empty selectOuterTopFileExt}">
							<div id="i_pieGraph" class="f_left mg_t20" style="width: 99%; height: 20%;"></div>
						</c:when>
					<c:otherwise>
						<tr>
							<td class="t_center" colspan="3"><div class="no_result">
								최근 24시간 내 자료전송 결과가 없습니다.
							</div></td>
						</tr>
					</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</div>
	<div class="conWrap dashboardBox">
		<h3>비-보안영역 최다 파일 확장자 TOP5</h3>
		<div class="conBox graphBox">
			<div class="graph_line1">
				<div class="graph_box">
					<c:choose>
						<c:when test="${not empty selectInnerTopFileExt}">
							<div id="o_pieGraph" class="f_left mg_t20"
								style="width: 99%; height: 20%;"></div>
						</c:when>
					<c:otherwise>
						<tr>
							<td class="t_center" colspan="3"><div class="no_result">
								최근 24시간 내 자료전송 결과가 없습니다.
							</div></td>
						</tr>
					</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</div>
	<div class="conWrap dashboardBox" >
		<h3>자료전송 최다 사용자&nbsp;&nbsp;</h3>
		<div class="table_area_style01" id="test">
			<button class="btn_common theme" id="m_button" style="float: right" onClick="topUser('m')">월간</button>
			<button class="btn_common theme" id="m_button" style="float: right" onClick="topUser('w')">주간</button>
			<button class="btn_common theme" id="m_button" style="float: right" onClick="topUser('d')">일간</button>
			<div id="innertopUserList">
			<table summary="그래프1 상세정보" style="table-layout: fixed;">
					<thead>
						<tr>
							<th colspan="3">보안</th>
						</tr>
						<tr>
							<th class="t_center Rborder">순위</th>
							<th class="t_center Rborder">사용자</th>
							<th class="t_center Rborder">전송횟수</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${not empty selectInnerTopUserList}">
								<c:forEach items="${selectInnerTopUserList}" var="dataForm" end="4" varStatus="status">
									<tr>
										<td class="t_center Rborder"><c:out value="${status.count}" /></td>
										<td class="t_center Rborder"><c:out value="${dataForm.users_id}" /></td>
										<td class="t_center Rborder"><c:out value="${dataForm.users_cnt}" />건</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td class="t_center" colspan="3"><div class="no_result">결과가 없습니다.</div></td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
			</table>
			</div>
			<div id="outertopUserList">
			<table summary="그래프1 상세정보" style="table-layout: fixed;">
				<thead>
					<tr>
						<th colspan="3">비-보안</th>
					</tr>
					<tr>
						<th class="t_center Rborder">순위</th>
						<th class="t_center Rborder">사용자</th>
						<th class="t_center Rborder">전송횟수</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty selectOuterTopUserList}">
							<c:forEach items="${selectOuterTopUserList}" var="dataForm" end="4" varStatus="status">
								<tr>
									<td class="t_center Rborder"><c:out value="${status.count}" /></td>
									<td class="t_center Rborder"><c:out value="${dataForm.users_id}" /></td>
									<td class="t_center Rborder"><c:out value="${dataForm.users_cnt}" />건</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="3"><div class="no_result">결과가 없습니다.</div></td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			</div>
		</div>
	</div>
	<div class="conWrap dashboardBox">
		<h3>자료전송 현황</h3>
		<div class="table_area_style01">
			<p class="tableTitle">결재 미처리 이력</p>
			<table summary="그래프1 상세정보" style="table-layout: fixed;">
				<caption>그래프1 상세정보</caption>
				<colgroup>
					<col style="width: 26%;" />
					<col style="width: 10%;" />
					<col style="width: 24%;" />
					<col style="width: 15%;" />
					<col style="width: 15%;" />
					<col style="width: 10%;" />
				</colgroup>
				<thead>
					<tr>
						<th>제목</th>
						<th>사용자</th>
						<th>전송시간</th>
						<th>상태</th>
						<th>영역</th>
						<th>결재자</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty selectLastApprovalList}">
							<c:forEach items="${selectLastApprovalList}" var="approvalForm"
								varStatus="status">
								<tr>
									<td class="t_center Rborder"><c:out value="${approvalForm.title}" /></td>
									<td class="t_center Rborder"><c:out value="${approvalForm.users_id}" /></td>
									<td class="t_center Rborder"><fmt:formatDate value="${approvalForm.crt_time}" pattern="yyyy-MM-dd kk:mm" /></td>
									<td class="t_center Rborder">
									<c:if test="${approvalForm.app_yn eq 'N'}">
											승인대기
										</c:if>
									</td>
									<td class="t_center Rborder"><c:choose>
											<c:when test="${approvalForm.np_cd eq 'I'}">
												보안영역
											</c:when>
											<c:otherwise>
												비-보안영역
											</c:otherwise>
										</c:choose></td>
									<td class="t_center Rborder"><c:out value="${approvalForm.appr_id}" /></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="3"><div class="no_result"> 결과가 없습니다.</div></td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
	</div>
	<div class="conWrap dashboardBox">
		<h3>최근 백신 탐지 이력</h3>
		<div class="table_area_style01">
			<table summary="그래프1 상세정보" style="table-layout: fixed;">
				<thead>
					<tr>
						<th class="t_center Rborder">파일명</th>
						<th class="t_center Rborder">탐지명</th>
						<th class="t_center Rborder">사용자</th>
						<th class="t_center Rborder">전송시간</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty selectLastVcFileList}">
							<c:forEach items="${selectLastVcFileList}" var="dataForm">
								<tr>
									<td class="t_center Rborder"><c:out value="${dataForm.file_nm}" /></td>
									<td class="t_center Rborder"><c:out value="${dataForm.virus_name}" /></td>
									<td class="t_center Rborder"><c:out value='${dataForm.crtr_id}' /></td>
									<td class="t_center Rborder"><fmt:formatDate value='${dataForm.crt_time}' pattern="yyyy-MM-dd kk:mm" /></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="3"><div class="no_result"> 결과가 없습니다.</div></td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
	</div>
	<div class="conWrap dashboardBox">
		<h3>보안영역 자료 전송 현황</h3>
		<div class="conBox graphBox">
			<button class="btn_common theme" id="m_button" style="float: right" onClick="innerTRSChart('m', 'I')">월간</button>
			<button class="btn_common theme" id="m_button" style="float: right" onClick="innerTRSChart('w', 'I')">주간</button>
			<button class="btn_common theme" id="m_button" style="float: right" onClick="innerTRSChart('d', 'I')">일간</button>
			<button class="btn_common theme" id="m_button" style="float: right" onClick="innerTRSChart('t', 'I')">시간</button>
			<div class="graph_line1" id ="innerTRSChart">
				<c:choose>
						<c:when test="${not empty selectInnerTRSDataCntList}">
							<div id="i_doublegraph" class="f_left mg_t20" style="width: 99%; height: 20%;"></div>
						</c:when>
						<c:otherwise>
						<tr>
							<td class="t_center" colspan="3">
							<div class="no_result">
								최근 24시간 내 자료전송 결과가 없습니다.
							</div>
							</td>
						</tr>
						</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
	<div class="conWrap dashboardBox">
		<h3>비-보안영역 자료 전송 현황</h3>
		<div class="conBox graphBox">
			<button class="btn_common theme" id="m_button" style="float: right" onClick="outerTRSChart('m', 'O')">월간</button>
			<button class="btn_common theme" id="m_button" style="float: right" onClick="outerTRSChart('w', 'O')">주간</button>
			<button class="btn_common theme" id="m_button" style="float: right" onClick="outerTRSChart('d', 'O')">일간</button>
			<button class="btn_common theme" id="m_button" style="float: right" onClick="outerTRSChart('t', 'O')">시간</button>
			<div class="graph_line1" id ="outerTRSChart">
				<c:choose>
							<c:when test="${not empty selectOuterTRSDataCntList}">
								<div id="o_doublegraph" class="f_left mg_t20"
									style="width: 99%; height: 20%;"></div>
							</c:when>
							<c:otherwise>
							<tr>
								<td class="t_center" colspan="3"><div class="no_result">
									최근 24시간 내 자료전송 결과가 없습니다.
								</div></td>
							</tr>
							</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</div>
</form>
</body>
</html>