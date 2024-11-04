<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>

<link rel="stylesheet" type="text/css" href="/css/reset.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/theme_dashboard.css">
<title>dashboard</title>
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
/* var i_barChart1 = [90, 80, 60, 80, 70, 60, 40, 23, 56, 48, 66, 123, 78];
var i_barChart2 = [100.12, 50.4456, 70, 600, 900, 500, 100, 890, 975, 624, 674, 351, 784]; */
var i_DataCntlineChart = ${selectInnerTRSDataCntList != null ? selectInnerTRSDataCntList : "[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]"};
var i_DataSumlineChart = ${selectInnerTRSDataSumList != null ? selectInnerTRSDataSumList : "[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]"};
/* var o_barChart1 = [70, 120, 50, 130, 70, 80, 60];
var o_barChart2 = [110, 800, 120, 110, 90, 40, 80]; */
var o_DataCntlineChart = ${selectOuterTRSDataCntList != null ? selectOuterTRSDataCntList : "[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]"};
var o_DataSumlineChart = ${selectOuterTRSDataSumList != null ? selectOuterTRSDataSumList : "[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]"};
var selectInnerTopFileExtlist;
if ("${selectInnerTopFileExt}" == "null"){
	selectInnerTopFileExtlist = "<c:out value="${selectInnerTopFileExt}"/>";
} else{
	selectInnerTopFileExtlist = ${selectInnerTopFileExt != null ? selectInnerTopFileExt : "''"};
}
var selectOuterTopFileExtlist;
if ("${selectOuterTopFileExt}" == "null"){
	selectOuterTopFileExtlist =  "<c:out value="${selectOuterTopFileExt}"/>";
} else{
	selectOuterTopFileExtlist =  ${selectOuterTopFileExt != null ? selectOuterTopFileExt : "''"};
}

var t_xaxis ; 
if(t_xaxis == null){
	t_xaxis = ['00시','01시','02시','03시','04시','05시','06시','07시','08시','09시','10시','11시','12시','13시','14시','15시','16시','17시','18시','19시','20시','21시','22시','23시'];
}

function innerTRSChart(innerChart_area, innerChart_np_cd) {
	var np_cd = np_cd;
	$("#innerChart_area").val(innerChart_area);
	$("#innerChart_np_cd").val(innerChart_np_cd);
	$.ajax({
			type:"GET",
			url:"/dashboard/innerDashboardChart.lin",
			data : {"transChart" : innerChart_area, "np_cd" : innerChart_np_cd},
			async : false,
			cache : false,
			success:function(data){
				$("#innerTRSChart").empty();
				var data = $.parseJSON(data);
				i_DataCntlineChart = data.selectInnerTRSDataCntList;
				i_DataSumlineChart = data.selectInnerTRSDataSumList;

				if (innerChart_area == "t"){
					t_xaxis = ['00시','01시','02시','03시','04시','05시','06시','07시','08시','09시','10시','11시','12시','13시','14시','15시','16시','17시','18시','19시','20시','21시','22시','23시'];
				} else if (innerChart_area == "d"){
					var result = new Array();	
					for(var i=0; i<i_DataCntlineChart.length; i++){
						result[i] = i+1+ "일";
					result.push(result[i]);
					}
					result.pop();
					t_xaxis = result;
				} else if (innerChart_area == "w"){
					t_xaxis = ['월','화','수','목','금','토','일'];
				} else if (innerChart_area == "m"){
					t_xaxis = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
				}
				var comment = "<div id='i_doublegraph' class='f_left mg_t20' style='width: 99%; height: 20%;'>"
								+"</div>";

				$("#innerTRSChart").append(comment);

				jqplotGragh('i_doublegraph',[/* i_barChart1,i_barChart2, */i_DataCntlineChart,i_DataSumlineChart]);
			}
	});
}

function outerTRSChart(outerChart_area, outerChart_np_cd) {
	var outerChart_np_cd = outerChart_np_cd;
	$("#outerChart_area").val(outerChart_area);
	$("#outerChart_np_cd").val(outerChart_np_cd);
	$.ajax({
			type:"GET",
			url:"/dashboard/outerDashboardChart.lin",
			data : {"transChart" : outerChart_area, "np_cd" : outerChart_np_cd},
			async : false,
			cache : false,
			success:function(data){
				$("#outerTRSChart").empty();
				var data = $.parseJSON(data);
				o_DataCntlineChart = data.selectOuterTRSDataCntList;
				o_DataSumlineChart = data.selectOuterTRSDataSumList;

				if (outerChart_area == "t"){
					t_xaxis = ['00시','01시','02시','03시','04시','05시','06시','07시','08시','09시','10시','11시','12시','13시','14시','15시','16시','17시','18시','19시','20시','21시','22시','23시'];
				} else if (outerChart_area == "d"){
					var result = new Array();
					for(var i=0; i<o_DataCntlineChart.length; i++){
						result[i] = i+1+ "일";
					result.push(result[i]);
					}
					result.pop();
					t_xaxis = result;
				} else if (outerChart_area == "w"){
					t_xaxis = ['월','화','수','목','금','토','일'];
				} else if (outerChart_area == "m"){
					t_xaxis = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
				}
				var comment = "<div id='o_doublegraph' class='f_left mg_t20' style='width: 99%; height: 20%;'>"
								+"</div>";

				$("#outerTRSChart").append(comment);

				jqplotGragh('o_doublegraph',[/* o_barChart1,o_barChart2, */o_DataCntlineChart,o_DataSumlineChart]);
		}
	});
}
//일간,주간,월간 구분자를 판별하는 function.
function topUser(topUserList) {
	var response;
	var innerMid="";
	var outerMid="";
	var param = $("#topUserList").val(topUserList);
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
				if (selectInnerTopUserListSize == 'undefined' || selectInnerTopUserListSize == 0) {
					var innerNullResult = createTopUserListTable("I", "<tr><td class='t_center' colspan='3'><div class='no_result'>"+"결과가 없습니다."+"</div></td></tr>");

					$("#innertopUserList").html(innerNullResult);
				} else {
					
					for(var i=0; i<selectInnerTopUserListSize; i++){
						innerMid += "<tr>" + 
						"<td class='t_center Rborder'>"+(i+1)+"</td>"+
						"<td class='t_center Rborder' title='" + arr[i].inner_topUsers_nm + "("+arr[i].inner_topUsers_id+")'>" + arr[i].inner_topUsers_nm + "("+arr[i].inner_topUsers_id+")</td>"+
						"<td class='t_center Rborder'>"+arr[i].inner_topUsers_cnt+"건"+"</td>" + 
						"</tr>";
					}
					
					innerResult = createTopUserListTable("I", innerMid);

					$("#innertopUserList").html(innerResult);
				}
				///////////////////비-보안영역 테이블/////////////////////////
				var selectOuterTopUserListSize = arr[arr.length-1].selectOuterTopUserListSize;
				if (selectOuterTopUserListSize == 'undefined' || selectOuterTopUserListSize == 0) {
					
					var outerNullResult = createTopUserListTable("O", "<tr><td class='t_center' colspan='3'><div class='no_result'>"+"결과가 없습니다."+"</div></td><tr>");

					$("#outertopUserList").html(outerNullResult);
					
				} else{
					
					var j = 1;
					selectInnerTopUserListSize += (selectInnerTopUserListSize == 'undefined' || selectInnerTopUserListSize == 0 ) ? 1 : 0;
					var totalSize = selectInnerTopUserListSize + selectOuterTopUserListSize;
					for (var i=selectInnerTopUserListSize; i<totalSize; i++){
						outerMid += "<tr>" + 
						"<td class='t_center Rborder'>"+j+"</td>"+
						"<td class='t_center Rborder' title='" + arr[i].outer_topUsers_nm +"("+arr[i].outer_topUsers_id+ ")'>"+ arr[i].outer_topUsers_nm +"("+arr[i].outer_topUsers_id+")</td>"+
						"<td class='t_center Rborder'>"+arr[i].outer_topUsers_cnt+"건"+"</td>" + 
						"</tr>";
						j = j+1;
					}
					
					$("#outertopUserList").html(  createTopUserListTable("O", outerMid) );
				}
		}
	});
	
	function createTopUserListTable(npCd, tdContent) {
		return "<table summary='그래프1 상세정보' style='table-layout: fixed;'>"+
		"<thead>"+
		"<tr>"+
		"<th colspan='3'>" + ( (npCd == 'I') ? "업무망" : "인터넷망" ) + "</th>"+
		"</tr>"+
		"<tr>"+
		"<th class='t_center Rborder'>순위</th>"+
		"<th class='t_center Rborder'>사용자</th>"+
		"<th class='t_center Rborder'>전송횟수</th>"+
		"</tr>"+
		"</thead>"+
		"<tbody>" + 
		tdContent +
		"</tbody>"+
		"</table>";
	}
}


$(document).ready(function() {	
	try{
		jqplotData();
	} catch(e) {
		console.log(e);
	}
	
	setInterval("pageReload()", 60000);
});

function pageReload() {
	document.lform.submit();
}

function xaxisCheck(xaxis){
	if (xaxis == "t" || xaxis == ""){
		t_xaxis = ['00시','01시','02시','03시','04시','05시','06시','07시','08시','09시','10시','11시','12시','13시','14시','15시','16시','17시','18시','19시','20시','21시','22시','23시'];
	} else if (xaxis == "d"){
		var result = new Array();	
		for(var i=0; i<i_DataCntlineChart.length; i++){
			result[i] = i+1+ "일";
		result.push(result[i]);
		}
		result.pop();
		t_xaxis = result;
	} else if (xaxis == "w"){
		t_xaxis = ['월','화','수','목','금','토','일'];
	} else if (xaxis == "m"){
		t_xaxis = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
	}
}

function jqplotData(){
	xaxisCheck("${innerChart_area}");
	jqplotGragh('i_doublegraph',[/* i_barChart1,i_barChart2, */i_DataCntlineChart,i_DataSumlineChart])
	xaxisCheck("${outerChart_area}");
	jqplotGragh('o_doublegraph',[/* o_barChart1,o_barChart2, */o_DataCntlineChart,o_DataSumlineChart])

	if(selectInnerTopFileExtlist != "null" && selectInnerTopFileExtlist != ""){
		pieChart('i_pieGraph',selectInnerTopFileExtlist)
	}

	if(selectOuterTopFileExtlist != "null" && selectInnerTopFileExtlist != ""){
		pieChart('o_pieGraph',selectOuterTopFileExtlist)
	}
}

function jqplotGragh(divId,dataList){
	dataList = 
	$.jqplot (divId, dataList,
				{
				 series:[/* {
					label:'횟수평균',
					color : '#ddd',
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
					color : '#aaa',
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
					},  */
					{// lineChart 배열을 꺽은선 그래프로 지정한다.
						label:'자료전송횟수',  
						color : '#4ac0c0',
						disableStack : true,      // 데이터의 합또한 합쳐지는 것을 방지하기위해 꺽은선 그래프는 disableStack을 true로 선언
						renderer : $.jqplot.LineRenderer,
						yaxis:'y2axis'
						
					},
					{// lineChart 배열을 꺽은선 그래프로 지정한다.
						label:'자료전송크기',
						color : '#4c88c7',
						disableStack : true,      // 데이터의 합또한 합쳐지는 것을 방지하기위해 꺽은선 그래프는 disableStack을 true로 선언
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
//						text:('100px','100px','(MB)'),
						min:0,
						tickOptions:{
								fontFamily:'Helvetica',
								fontSize: '8pt',
								//angle : 0,
								labelPosition : 'end'
								/* formatString:'%g' */
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
						fontSize : 8
						/* formatString : '%g' */
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
						highlightMouseOver: true,
						seriesColors: ["#ddd", "#A8D4F1", "#54A0DA", "#4c88c7", "#00419B"]
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
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/dashboard/trsDashboard.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<div class="rightArea">
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold">대쉬보드 조회</h2>
			<p class="breadCrumbs"></p>
		</div>
	</div>
	<div class="conWrap dashboardWrap">
		<div class="dashboard_top">
			<div class="conWrap dashboardBox">
				<h3>업무망 서버자원 사용량</h3>
				<div class="conBox graphBox">
					<!-- 컬러 적용시 graphItem뒤에 한칸띄고 red, orange, sky, green, pink, purple-->
					<div class="graphItem">
						<p class="name">CPU</p>
						<p class="percentNum">${innerDashBoardChartForm.hostCpu}%</p>
						<p class="percentBar">
							<span class="dashviewBox grayscale6"
								style="width:${innerDashBoardChartForm.hostCpu}%"></span>
						</p>
					</div>
					<div class="graphItem">
						<p class="name">MEMORY</p>
						<p class="percentNum">${innerDashBoardChartForm.hostMemory}%</p>
						<p class="percentBar">
							<span class="dashviewBox grayscale6"
								style="width:${innerDashBoardChartForm.hostMemory}%"></span>
						</p>
					</div>
					<div class="graphItem">
						<p class="name">HDD</p>
						<p class="percentNum">${innerDashBoardChartForm.diskSize}</p>
						<p class="percentBar">
							<span class="dashviewBox grayscale6"
								style="width:${innerDashBoardChartForm.diskSize}"></span>
						</p>
					</div>
				</div>
			</div>
			<div class="conWrap dashboardBox">
				<h3>인터넷망 서버자원 사용량</h3>
				<div class="conBox graphBox">
					<div class="graphItem ">
						<p class="name">CPU</p>
						<p class="percentNum">${outerDashBoardChartForm.hostCpu}%</p>
						<p class="percentBar">
							<span class="dashviewBox bluescale4"
								style="width:${outerDashBoardChartForm.hostCpu}%"></span>
						</p>
					</div>
					<div class="graphItem">
						<p class="name">MEMORY</p>
						<p class="percentNum">${outerDashBoardChartForm.hostMemory}%</p>
						<p class="percentBar">
							<span class="dashviewBox bluescale4" style="width:${outerDashBoardChartForm.hostMemory}%"></span>
						</p>
					</div>
					<div class="graphItem">
						<p class="name">HDD</p>
						<p class="percentNum">${outerDashBoardChartForm.diskSize}</p>
						<p class="percentBar">
							<span class="dashviewBox bluescale4"
								style="width:${outerDashBoardChartForm.diskSize}"></span>
						</p>
					</div>
				</div>		
			</div>
			<div class="conWrap dashboardBox">
				<h3>업무망 최다 파일 확장자 TOP5</h3>
					<div class="conBox graphBox">
						<div class="graph_line1">
							<div class="graph_box">
								<c:if test="${selectInnerTopFileExt ne 'null'}">
									<div id="i_pieGraph" class="f_left" style="width: 99%; height: 150px;"></div>
								</c:if>
								<c:if test="${selectInnerTopFileExt eq 'null'}">
									<div class="no_result">
										 최근 24시간 내 자료전송 결과가 없습니다.
									</div>
								</c:if>
							</div>
						</div>
					</div>	
			</div>
			<div class="conWrap dashboardBox last-item">
				<h3>인터넷망 최다 파일 확장자 TOP5</h3>
					<div class="conBox graphBox">
						<div class="graph_line1">
							<div class="graph_box">
								<c:if test="${selectOuterTopFileExt ne 'null'}">
									<div id="o_pieGraph" class="f_left" style="width: 99%; height: 150px;"></div>
								</c:if>
								<c:if test="${selectOuterTopFileExt eq 'null'}">
									<div class="no_result">
										 최근 24시간 내 자료전송 결과가 없습니다.
									</div>
								</c:if>
							</div>
						</div>
					</div>	
			</div>
		</div>
		<div class="dashboard_mid">
			<div class="conWrap dashboardBox">
				<h3>업무망 자료전송 현황</h3>
				<div class="graphViewOption">
					<button type="button" class="btn_small" onClick="innerTRSChart('t', 'I')">시간</button>
					<button type="button" class="btn_small" onClick="innerTRSChart('d', 'I')">일간</button>
					<button type="button" class="btn_small" onClick="innerTRSChart('w', 'I')">주간</button>
					<button type="button" class="btn_small" onClick="innerTRSChart('m', 'I')">월간</button>
				</div>
				<div class="conBox graphBox">
					<input type="hidden" id="innerChart_area" name="innerChart_area" value= "${innerChart_area}">
					<input type="hidden" id="innerChart_np_cd" name="innerChart_np_cd" value= "${innerChart_np_cd}">
					<div class="graph_line1" id ="innerTRSChart">
						<div id="i_doublegraph" class="f_left mg_t20" style="width: 99%; height: 16%;"></div>
					</div>
				</div>
			</div>
			<div class="conWrap dashboardBox">
				<h3>인터넷망 자료전송 현황</h3>
				<div class="graphViewOption">
					<button type="button" class="btn_small" onClick="outerTRSChart('t', 'O')">시간</button>
					<button type="button" class="btn_small" onClick="outerTRSChart('d', 'O')">일간</button>
					<button type="button" class="btn_small" onClick="outerTRSChart('w', 'O')">주간</button>
					<button type="button" class="btn_small" onClick="outerTRSChart('m', 'O')">월간</button>
				</div>
				<div class="conBox graphBox">
					<input type="hidden" id="outerChart_area" name="outerChart_area" value= "${outerChart_area}">
					<input type="hidden" id="outerChart_np_cd" name="outerChart_np_cd" value= "${outerChart_np_cd}">
					<div class="graph_line1" id ="outerTRSChart">
						<div id="o_doublegraph" class="f_left mg_t20" style="width: 99%; height: 16%;"></div>
					</div>
				</div>
			</div>
		</div>
		<div class="dashboard_bottom">
			<div class="conWrap dashboardBox" >
			<input type="hidden" id="topUserList" name="topUserList" value= "${topUserList}">
				<h3>자료전송 최다사용자</h3>
				<div class="graphViewOption">
					<button type="button" class="btn_small" onClick="topUser('d')" value="d">일간</button>
					<button type="button" class="btn_small" onClick="topUser('w')" value="w">주간</button>
					<button type="button" class="btn_small" onClick="topUser('m')" value="m">월간</button>
				</div>
				<div class="conBox graphBox" style="overflow-x:hidden;">
					<div class="dashboardTableArea">
						<div id="innertopUserList">
							<table summary="그래프1 상세정보" style="table-layout:fixed;">
								<caption>그래프1 상세정보</caption>
<%-- 									<colgroup>
										<col style="width:10%;"/>
										<col style="width:45%;"/>
										<col style="width:35%;"/>
									</colgroup> --%>
								<thead>	
									<tr>
										<th colspan="3">업무망</th>
									</tr>
									<tr>
										<th class="t_center Rborder">순위</th>
										<th class="t_center Rborder">사용자</th>
										<th class="t_center">전송횟수</th>
									</tr>
								</thead>
								<tbody>
									<c:choose>
										<c:when test="${not empty selectInnerTopUserList}">
											<c:forEach items="${selectInnerTopUserList}" var="dataForm" end="4" varStatus="status">
												<tr>
													<td class="t_center Rborder"><c:out value="${status.count}" /></td>
													<td class="t_center Rborder" title='<c:out value="${dataForm.users_nm}" />(<c:out value="${dataForm.users_id}" />)'><c:out value="${dataForm.users_nm}" />(<c:out value="${dataForm.users_id}" />)</td>
													<td class="t_center"><c:out value="${dataForm.users_cnt}" />건</td>
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
<%-- 									<colgroup>
										<col style="width:10%;"/>
										<col style="width:45%;"/>
										<col style="width:35%;"/>
									</colgroup> --%>
								<thead>	
									<tr>
										<th colspan="3">인터넷망</th>
									</tr>
									<tr>
										<th class="t_center Rborder">순위</th>
										<th class="t_center Rborder">사용자</th>
										<th class="t_center">전송횟수</th>
									</tr>
								</thead>
								<tbody>
									<c:choose>
										<c:when test="${not empty selectOuterTopUserList}">
											<c:forEach items="${selectOuterTopUserList}" var="dataForm" end="4" varStatus="status">
												<tr>
													<td class="t_center Rborder"><c:out value="${status.count}" /></td>
													<td class="t_center Rborder" title='<c:out value="${dataForm.users_nm}" />(<c:out value="${dataForm.users_id}" />)'><c:out value="${dataForm.users_nm}" />(<c:out value="${dataForm.users_id}" />)</td>
													<td class="t_center"><c:out value="${dataForm.users_cnt}" />건</td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr>
												<td class="t_center " colspan="3"><div class="no_result">결과가 없습니다.</div></td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="conWrap dashboardBox">
				<h3>결재 미처리 이력 TOP5</h3>
				<div class="conBox graphBox" style="overflow-x:hidden;">
					<div class="dashboardTableArea">
						<table summary="그래프1 상세정보" style="table-layout:fixed;">
							<caption>그래프1 상세정보</caption>
								<colgroup>
									<col style="width: 16%;" />
									<col style="width: 10%;" />
									<col style="width: 14%;" />
									<col style="width: 7%;" />
									<col style="width: 8%;" />
									<col style="width: 10%;" />
								</colgroup>
								<thead>	
									<tr>
										<th class="t_center Rborder">제목</th>
										<th class="t_center Rborder">사용자</th>
										<th class="t_center Rborder">전송시간</th>
										<th class="t_center Rborder">상태</th>
										<th class="t_center Rborder">영역</th>
										<th class="t_center">결재자</th>
									</tr>
								</thead>
								<tbody>
									<c:choose>
										<c:when test="${not empty selectLastApprovalList}">
											<c:forEach items="${selectLastApprovalList}" var="approvalForm"
												varStatus="status">
												<tr>
													<td class="t_center Rborder"><c:out value="${approvalForm.title}" /></td>
													<td class="t_center Rborder" title="<c:out value="${approvalForm.users_nm}" />(<c:out value="${approvalForm.users_id}" />)"><c:out value="${approvalForm.users_nm}" />(<c:out value="${approvalForm.users_id}" />)</td>
													<td class="t_center Rborder"><fmt:formatDate value="${approvalForm.crt_time}" pattern="yyyy-MM-dd kk:mm" /></td>
													<td class="t_center Rborder">
													<c:if test="${approvalForm.app_yn eq 'N'}">
															승인대기
														</c:if>
													</td>
													<td class="t_center Rborder"><c:choose>
															<c:when test="${approvalForm.np_cd eq 'I'}">
																업무망
															</c:when>
															<c:otherwise>
																인터넷망
															</c:otherwise>
														</c:choose></td>
													<td class="t_center Rborder" title="<c:out value="${approvalForm.appr_nm}" />(<c:out value="${approvalForm.appr_id}" />)"><c:out value="${approvalForm.appr_nm}" />(<c:out value="${approvalForm.appr_id}" />)</td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr>
												<td class="t_center" colspan="6"><div class="no_result"> 결과가 없습니다.</div></td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
					</div>
				</div>
			</div>
			<div class="conWrap dashboardBox last-item">
				<h3>백신 및 위변조 탐지 이력 TOP5</h3>
				<div class="conBox graphBox" style="overflow-x:hidden;">
					<div class="dashboardTableArea">
						<table summary="그래프1 상세정보" style="table-layout:fixed;">
							<caption>그래프1 상세정보</caption>
								<colgroup>
									<col style="width:45%;"/>
									<col style="width:30%;"/>
									<col style="width:35%;"/>
									<col style="width:35%;"/>
								</colgroup>
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
													<td class="t_center Rborder" title="<c:out value='${dataForm.users_nm}' />(<c:out value='${dataForm.crtr_id}' />)"><c:out value='${dataForm.users_nm}' />(<c:out value='${dataForm.crtr_id}' />)</td>
													<td class="t_center Rborder"><fmt:formatDate value='${dataForm.crt_time}' pattern="yyyy-MM-dd kk:mm" /></td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr>
												<td class="t_center" colspan="4"><div class="no_result"> 결과가 없습니다.</div></td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>		
	</div>
</div>
</form>
</body>
</html>