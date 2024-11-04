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

<script type="text/javascript">
var graph_manager = null;
var jqgrid_manager = new jqGridManager();
$(document).ready(function(){
	bindEventOnSearchDateInput(true);
	/** 전체 조회 **/
	jqgrid_manager.setting("total");
	jqgrid_manager.init(jqgridModel, formVal);
	$("#jqgh_mainGrid_write_time").contents()[0].textContent = "일별";
	
	graph_manager = new Graph();
	setCalendar();
	
	// calendar 변경 시 reload
	$("input[name='startDay']").on('change',function() {
		dateViewChange();		
		reload();
	});

	$("input[name='endDay']").on('change',function() {		
		reload();
	});
});
/** 조회 **/
function reload() {
	if( !checkValidation() ) return;
	
	graph_manager.graphInit();
	jqgrid_manager.setting("total");
	jqgrid_manager.reload(jqgridModel, formVal);
}

function dateViewChange() {
	var flag = $(':radio[name="statistics"]:checked').val();
	if(flag == 'D' || flag == 'P') {
		$("input[name='startDayView']").val($("input[name='startDay']").val());
	}else if(flag == 'M') {
		$("input[name='startDayView']").val($("input[name='startDay']").val().substring(0, 7));
	}else if(flag == 'Y') {
		$("input[name='startDayView']").val($("input[name='startDay']").val().substring(0, 4));
	}
}

function checkValidation() {
	if($(':radio[name="statistics"]:checked').val() == 'P') {
		if( ! isValidDateValue() ) return false;
		if( !checkMaxPriod($("input[name='startDay']").val(), $("input[name='endDay']").val()) ) {
			alert("기간통계조회 최대 조회기간은 31일 입니다.");
			return false;
		}
	}
	return true;
}

function checkMaxPriod(startDate, endDate) {
	var eDate = moment(endDate);
	var mDate = moment(startDate);
	mDate.add(30 , 'days');
	
	return dateCheck(eDate.format('YYYY[-]MM[-]DD'), mDate.format('YYYY[-]MM[-]DD'), "day");
}

/** 라디오 버튼 클릭 시 일일/월간/년간 날짜 초기화 **/
function setCalendar() {
	var flag = $(':radio[name="statistics"]:checked').val();
	
	$('#end_date_span').css("display", "none");
	$("input[name='startDay']").val(moment().format('YYYY-MM-DD'));
	$("input[name='endDay']").val(moment().format('YYYY-MM-DD'));
	
	if (flag == '' || flag == 'undefined') {
		$("#day_statistics").attr("checked", true);
		$("#jqgh_mainGrid_write_time").contents()[0].textContent = "시간별";
	} else if (flag == 'D') {
		$("#day_statistics").attr("checked", true);
		$("#jqgh_mainGrid_write_time").contents()[0].textContent = "시간별";
	} else if (flag == 'M') {
		$("#month_statistics").attr("checked", true);
		$("#jqgh_mainGrid_write_time").contents()[0].textContent = "일별";
	} else if (flag == 'Y') {
		$("#year_statistics").attr("checked", true);
		$("#jqgh_mainGrid_write_time").contents()[0].textContent = "월별";
	} else if (flag == 'P') {
		$('#end_date_span').css("display", "inline-block");
		$("input[name='startDay']").val(moment().add(-7, 'days').format('YYYY-MM-DD'));
		$("#period_statistics").attr("checked", true);
		$("#jqgh_mainGrid_write_time").contents()[0].textContent = "일별";
	}
	dateViewChange();
	reload();
}

function excelDown() {
	$("#search_date").val($("input[name='startDayView']").val());
	$("#search_end_date").val($("input[name='endDay']").val());
	$("#date_flag").val($(':radio[name="statistics"]:checked').val());

	var form = document.lform;
	form.action = "<c:url value="/trsMonitor/totalStatisticsExcelDownload.lin" />";
	form.submit();
}

function showStartDatepicker() {
	$.datepicker._showDatepicker( $("input[name='startDay']").get(0), "T" );
}
</script>
<style type="text/css">
.bb-tooltip tbody tr th {
   font-size: 11px;
}
.bb-tooltip td {
   font-size: 10px;
   padding: 3px 6px;
   background-color: #3A3D60;
   border-left: 1px dotted #999;
}
.bb text {fill: #c7c7c7;}
.bb line {stroke: #c7c7c7;}
.bb-ygrids line {
	stroke-dasharray: 1,0;
	stroke: #3c4262;
}
body {overflow-x: hidden; overflow-y: hidden;}
.bb svg { min-height: 105px; }
</style>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/trsMonitor/totalStatistics/totalStatisticsView.lin" />">
<input type="hidden" id="search_date" name="search_date" value="" />
<input type="hidden" id="search_end_date" name="search_end_date" value="" />
<input type="hidden" id="date_flag" name="date_flag" value="" />
<input type="hidden" id="sidx" name="sidx" value="" />
<input type="hidden" id="sord" name="sord" value="" />
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="chart_y_max" name="chart_y_max" value="" />
<input type="hidden" id="chart_y_unit" name="chart_y_unit" value="" />
<input type="hidden" id="chart_y2_max" name="chart_y2_max" value="" />
<input type="hidden" id="chart_y2_unit" name="chart_y2_unit" value="" />
<input type="hidden" id="inner" value ="${customfunc:codeDes('NP_CD', 'I')}" />
<input type="hidden" id="outer" value ="${customfunc:codeDes('NP_CD', 'O')}" />
<div class="detail-container-wrap">
	<div id="officeDetail" style="width: 100%; min-width: 1180px; max-width: 1800px; margin: 0 auto;">
		<div style="width: 95%; margin: 0 auto;">
			<div class="officeDetailLayout">
				<div class="detail-title">
					<jsp:include page="/WebUI/include/detail_Menu.jsp" >
						<jsp:param name="pageName" value="전체 통계" />
					</jsp:include>
				</div>
				<div class="users_div">
					<div class="detailBox" >
						<div class="table_area_style_total">
							<div class="conBox searchBox">
								<div class="topCon">
									<table cellspacing="0" cellpadding="0" summary="검색조건" style="table-layout : fixed" id="searchTable">
										<caption>검색조건, 버튼</caption>
										<tbody>
										<colgroup>
											<col class="col-layout"/>
										</colgroup>
										<tr>
											<td class="test">
												<span class="pd_l24">
													<input type="radio" id="day_statistics" name="statistics" value="D" onclick="setCalendar()"  /><label for="day_statistics" class="detail_date_font">일일통계</label>
													<input type="radio" id="month_statistics" name="statistics" value="M" onclick="setCalendar()" /><label for="month_statistics" class="detail_date_font">월간통계</label>
													<input type="radio" id="year_statistics" name="statistics" value="Y" onclick="setCalendar()" /><label for="year_statistics" class="detail_date_font" >년간통계</label>
													<input type="radio" id="period_statistics" name="statistics" value="P" onclick="setCalendar()" checked=checked /><label for="period_statistics" class="detail_date_font" >기간통계</label>
													<span class="period pd_r10">날짜 선택</span>
													<input type="text" name="startDayView" id="startDayView" value="${StaticsDetail.search_date}" readonly onfocus="showStartDatepicker()" class="text_input short t_center date-picker pd_r10" style="margin-right:3px; width: 100px !important;"/>
													<input type="text" name="startDay" id="startDay" value="${StaticsDetail.search_date}" readonly class="text_input short t_center date-picker pd_r10" style="margin-right:3px; width: 100px !important;display: none"/>
													<span id ="end_date_span" >
														~
														<input type="text" name="endDay" id="endDay" value="${StaticsDetail.search_end_date}" readonly class="text_input short t_center date-picker pd_r10" style="margin-right:3px; width: 100px !important;"/>
													</span>
												</span>
												<span class="btn_area pd_r10" style="float: right;">
													<button type="button" class="btn_common total_statistics_button" style="margin-left:10px;" onclick="reload()">조회</button>
													<button type="button" id="excel_down" class="btn_common total_statistics_button" onclick="excelDown()">엑셀다운로드</button>
												</span>
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="detail_div">
					<div class="detailBox" >
						<div class="sub_title_div">
							<span class="search_day none" style="position: absolute; left: 5%; z-index: 999;"><span id="startDayText"></span></span>
							<div id="hideTickLineText4"></div>
							<div id="graph_chart" style="font-weight: bold;"></div>
						</div>
					</div>
				</div>
				<div class="detail_div">
					<div class="detailBox">
						<div class="table_area_style_total">
							<table id="mainGrid"></table>
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