<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="now" value="<%=new java.util.Date()%>" />
<c:set var="sysDate">
	<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" />
</c:set>
<html>
<head>
<script type="text/javascript" src="/JavaScript/module/trs.graph.js?v=5"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.call.js" />?v=20200103"></script>
<c:set var="getNetworkPosition" value="${customfunc:getNetworkPosition()}" /><!-- I, O -->
<script type="text/javascript">
var graph_manager = null;
$(document).ready(function(){
	bindEventOnSearchDateInput(true);
	graph_manager = new Graph();
	/** 전체 조회 **/
	reload();
	/** Interval 설정 **/
	setInterval("reload()", 1800 * 1000); // 30분에 한번씩 받아온다.
});

/** 조회 **/
function reload() {
	graph_manager.graphInit( );
	getTableStatisticsList();
	htmlChange();
}

function htmlChange() {
	if ($(':radio[name="statistics"]:checked').val() == 'D') {
		$('#th_change').html("시간");
	} else {
		$('#th_change').html("날짜");
	}
}

function getTableStatisticsList() {
	var param = {
			'search_date': $("input[name='startDay']").val(),
			'date_flag': $(':radio[name="statistics"]:checked').val()
	};
	
	$.ajax({
		url: "/dashboard/data.lin",
		data: param,
		cache : false,
		dataType: "json",
		success: function(data) {
			if( successFunc ) successFunc(data);
		}
	});
	
	function successFunc(response){
		var html = '';

		if( response.dataDetailList.length < 1 ) {
			html = "<tr>"
				+ "<td class='t_center' colspan='13'><div class='no_result02'>결과가 없습니다</div></td>";
			+"</tr>";
			$('#statisticsTable tbody').html(html)
			return;
		}

		for(var i=0; i<response.dataDetailList.length; i++ ) {
			html += getRowData(response.dataDetailList[i], i);
		}

		$('#statisticsTable tbody').html(html);
		
		<%-- y축 스크롤 박스 여부에 따른 width 너비 조정 --%>
		if(document.getElementById("scrollBox").scrollHeight - document.getElementById("scrollBox").clientHeight > 0){
			$(".tdBox").css({"width":"calc(100% - -17px)"}); 
		} else {
			$(".tdBox").css({"width":"100%"}); 
		}
	}

	function getRowData(response, i) {
		var write_time = ( i == 0 ) ? '합계' : getSubToDate(response.write_time);
		var rowData = "<tr style='cursor: default;'>"		
		+ "<td class='t_center Rborder' title='"+ write_time +"'>"
		+ write_time
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+response.send_count_i+"'>"
		+ response.send_count_i
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+response.send_count_o+"'>"
		+ response.send_count_o
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+response.send_count_total+"'>"
		+ response.send_count_total
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+fileSizeFormat(response.send_size_i)  +"'>"
		+ fileSizeFormat(response.send_size_i)
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+fileSizeFormat(response.send_size_o) +"'>"
		+ fileSizeFormat(response.send_size_o)
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+fileSizeFormat(response.send_size_total) +"'>"
		+ fileSizeFormat(response.send_size_total)
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+response.block_count_i+"'>"
		+ response.block_count_i
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+response.block_count_o+"'>"
		+ response.block_count_o
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+response.block_count_total+"'>"
		+ response.block_count_total
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+response.login_cnt_i+"'>"
		+ response.login_cnt_i
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+response.login_cnt_o+"'>"
		+ response.login_cnt_o
		+ "</td>"
		+ "<td class='t_center Rborder' title='"+response.login_cnt_total+"'>"
		+ response.login_cnt_total
		+ "</td>"
		+ "</tr>"

		return rowData;
	}
}

/** 라디오 버튼 클릭 시 일일/월간/년간 날짜 초기화 **/
function setCalendar( ) {
	var flag = $(':radio[name="statistics"]:checked').val();
	if (flag == '' || flag == 'undefined') {
		getDatePickerInput().datepicker( "option", "dateFormat", "yy-mm-dd" );
		$("input[name='startDay']").val(moment().format('YYYY-MM-DD'));
		reload();
	} else if (flag == 'D') {
		getDatePickerInput().datepicker( "option", "dateFormat", "yy-mm-dd" );
		$("input[name='startDay']").val(moment().format('YYYY-MM-DD'));
		reload();
	} else if (flag == 'M') {
		getDatePickerInput().datepicker( "option", "dateFormat", "yy-mm" );
		$("input[name='startDay']").val(moment().format('YYYY-MM'));
		reload();
	} else if (flag == 'Y') {
		getDatePickerInput().datepicker( "option", "dateFormat", "yy" );
		$("input[name='startDay']").val(moment().format('YYYY'));
		reload();
	}
}

function excelDown() {
	$("#search_date").val($("input[name='startDay']").val())
	$("#date_flag").val($(':radio[name="statistics"]:checked').val())

	var form = document.lform;
	form.action = "<c:url value="/dashboard/statisticsExcelDownload.lin" />";
	form.submit();
	form.action = "<c:url value="/dashboard/graph.lin" />";
}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/dashboard/logStatistics.lin" />">
<input type="hidden" id="search_date" name="search_date" value="" />
<input type="hidden" id="date_flag" name="date_flag" value="" />
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<!-- contents -->
	<div class="rightArea">
	<div class="logArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">로그통계 조회</h2>
				<p class="breadCrumbs">대쉬보드 > 로그통계 조회</p>
			</div>
		</div>
		<div class="top_area" style="min-width: 860px;">
			<div class="conWrap">
				<h3>검색조건</h3>
				<div class="conBox searchBox t_center">
					<div class="topCon nBorder pd_b10 pd_t10">
						<table summary="정책 검색조건" >
							<caption>검색조건, 버튼</caption>
							<tbody>
								<colgroup>
									<col style="width:100%;"/>
								</colgroup>
								<tr>
									<td class="t_center">
										<span class="mg_r10">날짜선택</span>
										<span class="mg_r100">
											<input type="text" name="startDay" id="startDay" value="${sysDate}" readonly class="text_input short t_center" style="margin-right:3px; width: 6% !important"/>
										</span>
	
										<span class="mg_r10">종류</span>
										<input type="radio" id="day_statistics" name="statistics" value="D" onclick="setCalendar()" checked=cheked /><label for="day_statistics" style="padding-left: 3px; padding-right: 3px;" >일일통계</label>
										<input type="radio" id="month_statistics" name="statistics" value="M" onclick="setCalendar()"/><label for="month_statistics" style="padding-left: 3px; padding-right: 3px;"  >월간통계</label>
										<input type="radio" id="year_statistics" name="statistics" value="Y" onclick="setCalendar()" /><label for="year_statistics"  style="padding-left: 3px; padding-right: 3px;" >년간통계</label>
	
										<span class="btn_area" style="float: right; padding-right: 30px;">
											<button class="btn_common theme" onclick="reload()">날짜조회</button>
											<button class="btn_common theme" onclick="excelDown()">엑셀다운로드</button>
										</span>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="middle_area" style="min-width: 860px;">
			<div id="graph_chart" style="font-weight: bold;">
			</div>
		</div>
		<div class="bottom_area" style="min-width: 860px;">
			<div class="conWrap tableBox">
			<h3>업무망/인터넷망 세부통계</h3>
				<div class="conBox">
					<div class="table_area_style01 hoverTable">
						<table class="thBox" style="">
							<tr>
								<th rowspan="2" class="Rborder" id="th_change" >날짜</th>
								<th colspan="3" class="Rborder">전송개수</th>
								<th colspan="3" class="Rborder">전송량</th>
								<th colspan="3" class="Rborder">이상파일</th>
								<th colspan="3" class="Rborder">사용자 접속 수</th>
							</tr>
							<tr>
								<th class="Rborder">업무망</th>
								<th class="Rborder">인터넷망</th>
								<th class="Rborder">전체</th>
								<th class="Rborder">업무망</th>
								<th class="Rborder">인터넷망</th>
								<th class="Rborder">전체</th>
								<th class="Rborder">업무망</th>
								<th class="Rborder">인터넷망</th>
								<th class="Rborder">전체</th>
								<th class="Rborder">업무망</th>
								<th class="Rborder">인터넷망</th>
								<th class="Rborder">전체</th>
							</tr>
						</table>
						<div class="scrollBox" id="scrollBox">
							<table class="tdBox" id="statisticsTable" style="width: 100%;">
								<tbody id="tbody_area">
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</div>
</form>
</body>
</html>
