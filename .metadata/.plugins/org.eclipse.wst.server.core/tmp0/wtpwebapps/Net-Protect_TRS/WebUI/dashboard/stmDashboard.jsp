<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="/css/theme_red.css">
<title>Stream Dashboard</title>
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
var i_DataCntlineChart = ${selectInnerSTMSessionCntList};
var i_DataSumlineChart = ${selectInnerSTMPacketSumList};

var o_barChart1 = [70, 120, 50, 130, 70, 80, 60];
var o_barChart2 = [110, 800, 120, 110, 90, 40, 80];
var o_DataCntlineChart = ${selectOuterSTMSessionCntList};
var o_DataSumlineChart = ${selectOuterSTMPacketSumList};

var selectInnerTopSTMIdList;
if ("${selectInnerTopSTMIdList}" == "null"){
	selectInnerTopSTMIdList = "${selectInnerTopSTMIdList}"
} else{
	selectInnerTopSTMIdList = ${selectInnerTopSTMIdList};
}
var selectOuterTopSTMIdList;
if ("${selectOuterTopSTMIdList}" == "null"){
	selectOuterTopSTMIdList = "${selectOuterTopSTMIdList}";
} else{
	selectOuterTopSTMIdList = ${selectOuterTopSTMIdList};
}

var t_xaxis = ['00시','01시','02시','03시','04시','05시','06시','07시','08시','09시','10시','11시','12시','13시','14시','15시','16시','17시','18시','19시','20시','21시','22시','23시'];

function topUser(stmTopUserList) {
	$("#topUserList").val(stmTopUserList);
	var response;
	var innerMid="";
	var outerMid="";
	$.ajax({
		type:"GET",
		url:"/dashboard/stmTopUserList.lin",
		data : { "stmTopUserList" : stmTopUserList },
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
			var selectInnerSTMTopUserListSize = arr[0].selectInnerSTMTopUserListSize;
				if (selectInnerSTMTopUserListSize==0) {
					var innerNullResult =
						"<table summary='그래프1 상세정보' style='table-layout: fixed;'>"+
						"<thead>"+
						"<tr>"+
						"<th colspan='3'>보안</th>"+
						"</tr>"+
						"<tr>"+
						"<th class='t_center Rborder'>순위</th>"+
						"<th class='t_center Rborder'>접속IP</th>"+
						"<th class='t_center Rborder'>전송량</th>"+
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
						"<th class='t_center Rborder'>접속IP</th>"+
						"<th class='t_center Rborder'>전송량</th>"+
						"</tr>"+
						"</thead>"+
						"<tbody>";

						for(var i=0; i<selectInnerSTMTopUserListSize; i++){
						innerMid +=
						"<tr>"+
						"<td class='t_center Rborder'>"+(i+1)+"</td>"+
						"<td class='t_center Rborder'>"+arr[i].inner_topUsers_source_ip+"</td>"+
						"<td class='t_center Rborder'>"+arr[i].inner_topUsers_data_sum+"MB"+"</td>"+
						"</tr>";

						}
						var innerEnd = 
						"</tbody>"+
						"</table>";

						innerResult = innerFirst + innerMid + innerEnd ;

					$("#innertopUserList").html(innerResult);
				}
				///////////////////비-보안영역 테이블/////////////////////////
				var selectOuterSTMTopUserListSize = arr[6].selectOuterSTMTopUserListSize;
				if (selectOuterSTMTopUserListSize==0) {
					var outerNullResult = 
						"<table summary='그래프1 상세정보' style='table-layout: fixed;'>"+
						"<thead>"+
						"<tr>"+
						"<th colspan='3'>비-보안</th>"+
						"</tr>"+
						"<tr>"+
						"<th class='t_center Rborder'>순위</th>"+
						"<th class='t_center Rborder'>접속IP</th>"+
						"<th class='t_center Rborder'>전송량</th>"+
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
					for (var i=selectOuterSTMTopUserListSize; i<arr.length; i++){
						outerMid +=
						"<tr>"+
						"<td class='t_center Rborder'>"+j+"</td>"+
						"<td class='t_center Rborder'>"+arr[i].outer_topUsers_source_ip+"</td>"+
						"<td class='t_center Rborder'>"+arr[i].outer_topUsers_data_sum+"MB"+"</td>"+
						"</tr>";
						j = j+1;
					}

						var outerEnd =
						"</tbody>"+
						"</table>";

						outerResult = outerFirst + outerMid + outerEnd;

					$("#outertopUserList").html(outerResult);
				}
		}
	});
}

$(document).ready(function() {	
	jqplotData();
	setInterval("pageReload()", 60000);
});

function pageReload() {
	document.lform.submit();
}

function jqplotData() {
	jqplotGragh('i_doublegraph',[i_barChart1,i_barChart2,i_DataCntlineChart,i_DataSumlineChart]);
	jqplotGragh('o_doublegraph',[o_barChart1,o_barChart2,o_DataCntlineChart,o_DataSumlineChart]);

	if(selectInnerTopSTMIdList != "null" ){
		pieChart('i_pieGraph',selectInnerTopSTMIdList)
	}

	if(selectOuterTopSTMIdList !="null"){
		pieChart('o_pieGraph',selectOuterTopSTMIdList)
	}
}

function jqplotGragh(divId,dataList) {
	$.jqplot (divId, dataList,
				{
				series:[{
					label:'평균세션수',
					renderer:$.jqplot.BarRenderer,
					linePattern: 'dashed',
					markerOptions: { style:'filledSquare'},
					pointLabels: {show:true},
					yaxis:'y2axis',
					rendererOptions : {
							barWidth : 3                    // 막대그래프의 넓이를 지정
							,barPadding : 5                // 막대그래프의 여백을 지정
							,highlightMouseOver : false
							// 막대그래프의 클릭여부를 지정 (기본값 : true)
					},
						},
					{
					label:'평균전송량',
					renderer:$.jqplot.BarRenderer,
					linePattern: 'dashed',
					markerOptions: { style:'filledSquare'},
					pointLabels: {show:true},
					yaxis:'yaxis',
					rendererOptions : {
							barWidth : 3                    // 막대그래프의 넓이를 지정
							,barPadding : 5                // 막대그래프의 여백을 지정
							,highlightMouseOver : false    // 막대그래프의 클릭여부를 지정 (기본값 : true)
					},
					},
					{// lineChart 배열을 꺽은선 그래프로 지정한다.
						label:'세션수',
						color : '#00FFFF',
						disableStack : true,      // 데이터의 합또한 합쳐지는 것을 방지하기위해 꺽은선 그래프는 disableStack을 true로 선언
					// jQuery.jqplot.LineRenderer(꺽은선 그래프)의 플러그인은 기본적으로 지정하지 않아도 된다.
						renderer : $.jqplot.LineRenderer,
						yaxis:'y2axis'
					},
					{// lineChart 배열을 꺽은선 그래프로 지정한다.
						label:'패킷전송량',
						color : '#0000FF',
						disableStack : true,      // 데이터의 합또한 합쳐지는 것을 방지하기위해 꺽은선 그래프는 disableStack을 true로 선언
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
						renderer:$.jqplot.CategoryAxisRenderer,
						ticks : t_xaxis,
						},
					yaxis: {
					labelRenderer: $.jqplot.CanvasAxisTickRenderer,
						label:'(MB)',
						min:0,
						tickOptions:{
								fontFamily:'Helvetica',
								fontSize: '8pt',
								labelPosition : 'end',
								formatString:'%g'
								},
						autoscale: true
					},
					y2axis: {
					labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
						label:'세션수',
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
	<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/dashboard/stmDashboard.lin" />">
	<input id="topUserList" name="topUserList" type="hidden" value="${topUserList}"/>
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
		<div class="rightArea">
			<div class="topWarp">
				<div class="titleBox">
					<h2 class="f_left text_bold"></h2>
					<p class="breadCrumbs">인사관리 > 인사관리</p>
				</div>
			</div>
			<div class="conWrap dashboardBox" style="width: 25%">
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
			<div class="conWrap dashboardBox" style="width: 25%">
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
									<span class="colorBox"
										style="width:${outerDashBoardChartForm.hostCpu}px"></span>
								</p>
								<p class="percentView">${outerDashBoardChartForm.hostCpu}%</p>
							</div>
							<div class="graphItem purple">
								<p class="name">MEMORY</p>
								<p class="percentBar">
									<span class="colorBox"
										style="width:${outerDashBoardChartForm.hostMemory}px"></span>
								</p>
								<p class="percentView">${outerDashBoardChartForm.hostMemory}%</p>
							</div>
							<div class="graphItem green">
								<p class="name">HDD</p>
								<p class="percentBar"
									style="width:${outerDashBoardChartForm.diskSize}px">
									<span class="colorBox"></span>
								</p>
								<p class="percentView">${outerDashBoardChartForm.diskSize}</p>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="conWrap dashboardBox" style="width: 18% ;height: 200px;">
				<h3>보안 영역 최다 사용 정책TOP5</h3>
				<div class="conBox graphBox">
					<div class="graph_line1">
						<div class="graph_box">
							<c:if test="${selectInnerTopSTMIdList ne 'null'}">
								<div id="i_pieGraph" class="f_left mg_t20" style="width: 99%; height: 150px;"></div>
							</c:if>
							<c:if test="${selectInnerTopSTMIdList eq 'null'}">
								<div class="no_result">
								최근 24시간 내 자료전송 결과가 없습니다.
								</div>
							</c:if>
						</div>
					</div>
				</div>
			</div>
			<div class="conWrap dashboardBox" style="width: 18% ;height: 200px;">
				<h3>비-보안 영역 최다 사용 정책TOP5</h3>
				<div class="conBox graphBox">
					<div class="graph_line1">
						<div class="graph_box">
							<c:if test="${selectOuterTopSTMIdList ne 'null'}">
								<div id="o_pieGraph" class="f_left mg_t20" style="width: 99%; height: 150px;"></div>
							</c:if>
							<c:if test="${selectOuterTopSTMIdList eq 'null'}">
								<div class="no_result">
								 최근 24시간 내 자료전송 결과가 없습니다.
								</div>
							</c:if>
						</div>
					</div>
				</div>
			</div>
			<div class="conWrap dashboardBox">
				<h3>보안 영역 스트림 연계 현황</h3>
				<div class="conBox graphBox">
				<p>
				<c:choose>
					<c:when test="${not empty selectInnerSTMRecentSessionCnt}">
						현재 세션 수: ${selectInnerSTMRecentSessionCnt.data_cnt}개&nbsp;&nbsp;
					</c:when>
					<c:otherwise>
						<div class="no_result">현재 연결된 세션이 없습니다.</div>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${not empty selectInnerSTMRecentPacketDataSum}">
						패킷 사용량: ${selectInnerSTMRecentPacketDataSum.data_sum} MB/S
					</c:when>
					<c:otherwise>
						<div class="no_result">현재 사용되는 패킷이 없습니다.</div>
					</c:otherwise>
				</c:choose>
				</p>
					<div class="graph_line1" id ="innerTRSChart">
						<div id="i_doublegraph" class="f_left mg_t20" style="width: 99%; height: 20%;"></div>
					</div>
				</div>
			</div>
			<div class="conWrap dashboardBox">
				<h3>비-보안 영역 스트림 연계 현황</h3>
				<p>
				<c:choose>
					<c:when test="${not empty selectOuterSTMRecentSessionCnt}">
						현재 세션 수: ${selectOuterSTMRecentSessionCnt.data_cnt}개&nbsp;&nbsp;
					</c:when>
					<c:otherwise>
						<div class="no_result">현재 연결된 세션이 없습니다.</div>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${not empty selectOuterSTMRecentPacketDataSum}">
						패킷 사용량: ${selectOuterSTMRecentPacketDataSum.data_sum} MB/S
					</c:when>
					<c:otherwise>
						<div class="no_result">현재 사용되는 패킷이 없습니다.</div>
					</c:otherwise>
				</c:choose>
				</p>
				<div class="conBox graphBox">
					<div class="graph_line1" id ="innerTRSChart">
						<div id="o_doublegraph" class="f_left mg_t20" style="width: 99%; height: 20%;"></div>
					</div>
				</div>
			</div>
			<div class="conWrap dashboardBox" style="width: 30%">
				<h3>스트림 연계 최다 사용자</h3>
				<div class="table_area_style01">
				<button class="btn_common theme" id="m_button"style="float:right" onClick="topUser('m')" >월간</button>
				<button class="btn_common theme" id="m_button"style="float:right" onClick="topUser('w')" >주간</button>
				<button class="btn_common theme" id="m_button"style="float:right" onClick="topUser('d')" >일간</button>
				<div id="innertopUserList">
					<p class="tableTitle"></p>
					<table summary="그래프1 상세정보" style="table-layout:fixed;">
						<caption>그래프1 상세정보</caption>
							<thead>
							<tr>
								<th colspan="3">보안</th>
							</tr>
								<tr>
									<th class="t_center Rborder">순위</th>
									<th class="t_center Rborder">접속IP</th>
									<th class="t_center">전송량</th>
								</tr>
							</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty selectSTMInnerTopUserList}">
									<c:forEach items="${selectSTMInnerTopUserList}" var= "sConnInfo" varStatus="status">
										<tr>
											<td class="t_center Rborder"><c:out value="${sConnInfo.rank}" /></td>
											<td class="t_center Rborder"><c:out value="${sConnInfo.source_ip}" /></td>
											<td class="t_center Rborder"><c:out value="${sConnInfo.data_sum}" />MB</td>
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
						<table summary="그래프1 상세정보" style="table-layout:fixed;">
						<caption>그래프1 상세정보</caption>
							<thead>
							<tr>
								<th colspan="3">비-보안</th>
							</tr>	
								<tr>
									<th class="t_center Rborder">순위</th>
									<th class="t_center Rborder">접속IP</th>
									<th class="t_center">전송량</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty selectSTMOuterTopUserList}">
										<c:forEach items="${selectSTMOuterTopUserList}" var= "sConnInfo" varStatus="status">
											<tr>
												<td class="t_center Rborder"><c:out value="${sConnInfo.rank}" /></td>
												<td class="t_center Rborder"><c:out value="${sConnInfo.source_ip}" /></td>
												<td class="t_center Rborder"><c:out value="${sConnInfo.data_sum}" />MB</td>
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
			<div class="conWrap dashboardBox" style="overflow-Y:scroll; height:235px;width: 30%">
				<h3>현재 최다 사용 정책 현황</h3>
				<div class="table_area_style01">
					<table summary="그래프1 상세정보" style="table-layout: fixed;">
						<caption>그래프1 상세정보</caption>
						<thead>
							<tr>
								<th>순위</th>
								<th>정책명</th>
								<th>전송량</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty selectNowSTMIdList}">
									<c:forEach items="${selectNowSTMIdList}" var="sPacketSizeForm" varStatus="status" end="10">
										<tr>
											<td class="t_center Rborder"><c:out value="${status.count}" /></td>
											<td class="t_center Rborder"><c:out value="${sPacketSizeForm.stm_id}" /></td>
											<td class="t_center Rborder"><c:out value="${sPacketSizeForm.data_sum}" />MB/S</td>
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
			<div class="conWrap dashboardBox" style="width: 550px">
				<h3>이상 연결 요청 이력</h3>
				<div class="table_area_style01">
					<table summary="그래프1 상세정보" style="table-layout: fixed;">
						<thead>
							<tr>
								<th class="t_center Rborder">발생시간</th>
								<th class="t_center Rborder">정책명</th>
								<th class="t_center Rborder">접속IP</th>
								<th class="t_center Rborder">망구분</th>
								<th class="t_center Rborder">비고</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty selectFailConnList}">
									<c:forEach items="${selectFailConnList}" var="dataForm">
										<tr>
											<td class="t_center Rborder"><c:out value='${dataForm.write_date}' /></td>
											<td class="t_center Rborder"><c:out value="${dataForm.stm_id}" /></td>
											<td class="t_center Rborder"><c:out value='${dataForm.source_ip}' /></td>
											<td class="t_center Rborder">
											<c:choose>
													<c:when test="${dataForm.io_cd eq 'I'}">
														보안영역
													</c:when>
													<c:otherwise>
														비-보안영역
													</c:otherwise>
											</c:choose>
											</td>
											<td class="t_center Rborder">
											<c:choose>
												<c:when test="${dataForm.disconn_reason eq '1'}">
												<c:out value="사용자 연결종료" />
												</c:when>
												<c:when test="${dataForm.disconn_reason eq '2'}">
												<c:out value="WebShell Pattern 탐지" />
												</c:when>
												<c:when test="${dataForm.disconn_reason eq '3'}">
												<c:out value="목적지 연결실패" />
												</c:when>
												<c:when test="${dataForm.disconn_reason eq '4'}">
												<c:out value="허용되지 않은 IP or MAC" />
												</c:when>
												<c:when test="${dataForm.disconn_reason eq '5'}">
												<c:out value="허용되지 않은 프로토콜" />
												</c:when>
												<c:otherwise>
												<c:out value="" />
												</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td class="t_center" colspan="5"><div class="no_result">결과가 없습니다.</div></td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</form>
</body>
</html>