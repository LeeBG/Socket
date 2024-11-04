<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<!-- officeDetail.jsp -->
<c:set var="systemCode" value="${sessionScope.loginUser.system_cd}" />
<!-- T, S -->
<c:set var="auth_type" value="${sessionScope.loginUser.auth_type}" />

<c:set var="now" value="<%=new java.util.Date()%>" />
<c:set var="sysDate">
	<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" />
</c:set>
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />

<link href="<c:url value="/css/billboard.css" />" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/JavaScript/d3.min.js"></script>
<script type="text/javascript" src="/JavaScript/billboard.js"></script>

<script>
$(document).ready(function() {

	//페이지 종료시 Interval 등록 해제
	window.onbeforeunload = function () {
		console.log('reset setIntervals!!');
		clearIntervals();
	};

	function clearIntervals() {
		//1번째 차트 해제
		clearInterval(hideTickLineTextTimer); 
		//3번째 차트 해제
		clearInterval(detail3Timer);
		//4번째 차트 해제
		clearInterval(detail4Timer);
		//이상파일 전송 현황 해제
		clearInterval(detail5Timer);
	}
});
	
</script>
<%-- 망별 서버상태 그래프 내부,외부--%>
<script type="text/javascript" src="/JavaScript/trsMonitor/dashboard/serverStatusChart.js"></script>
<%-- 자료 전송 추이 --%>
<script type="text/javascript" src="<c:url value="/JavaScript/trsMonitor/dashboard/transChart.js" />?v=20221103"></script>
<%-- 달력 --%>
<script type="text/javascript" src="/JavaScript/trsMonitor/dashboard/transChartDatepicker.js"></script>
<%-- 통계 정보 --%>
<script type="text/javascript" src="<c:url value="/JavaScript/trsMonitor/dashboard/trsStatusChart.js" />?v=20221103"></script>
<%-- 이상 파일 전송 정보 --%>
<script type="text/javascript" src="/JavaScript/trsMonitor/dashboard/trsStatusData.js"></script>
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

body{
	overflow-x: hidden; overflow-y: hidden;
}

.bb svg { min-height: 105px; }

.chart12BgClass{ transform: scale(0.9) translate(15px, -10px); opacity: 0.1; }


.bb-ygrids line {
	stroke-dasharray: 1,0;
	stroke: #2c324a;
}

.bb-axis.bb-axis-x .tick tspan {fill: #c7c7c7;}
.bb-axis.bb-axis-x .tick line {stroke: #c7c7c7;}
#noweDate{border:0px; }
.bb-chart-arcs-title{fill:#fff; font-weight: bold; }
</style>
<form id="detailForm" name="detailForm" onsubmit="return false;" method="post">
<div class="detail-container-wrap">
	<div id="officeDetail" style="width: 100%; min-width: 1180px; max-width: 1800px; margin: 0 auto;">
		<input type="hidden" id="cpu_warning" name="cpu_warning" value="80" />
		<input type="hidden" id="cpu_error" name="cpu_error" value="90" />
		<input type="hidden" id="memory_warning" name="memory_warning" value="80" />
		<input type="hidden" id="memory_error" name="memory_error" value="90" />
		<input type="hidden" id="disk_warning" name="disk_warning" value="80" />
		<input type="hidden" id="disk_error" name="disk_error" value="90" />
		<input type="hidden" id="inner" value ="${customfunc:codeDes('NP_CD', 'I')}" />
		<input type="hidden" id="outer" value ="${customfunc:codeDes('NP_CD', 'O')}" />
		<div style="width: 95%; margin: 0 auto;">
			<div class="officeDetailLayout">
				<div class="detail-title">
					<jsp:include page="/WebUI/include/detail_Menu.jsp" >
						<jsp:param name="pageName" value="TRS 현황 Dashboard" />
					</jsp:include>
				</div>
				<div class="detail_div">
					<p class="title">망별 서버 상태</p>
					<div class="detailBox" >
						<div class="detail_div_child">
							<div class="sub_title_div">
								<div class="sub_title" style="float: left; text-align: left;">${INNER}</div>
							</div>
							<div class="graph1">
								<div id="hideTickLineText1"></div>
							</div>
							<div class="graph1">
								<div id="hideTickLineText2"></div>
							</div>
							<div class="graph1">
								<div id="hideTickLineText3"></div>
							</div>
							<div style="float: left; width: 100%;">
								<div class="" style="float: left; width: 33.3%; text-align: center;">
									<font color="a9aac1" size="2">CPU</font>
									<font color="8D90BC" size="2" id="cpu_I"></font>
								</div>
								<div class="" style="float: left; width: 33.3%; text-align: center;">
									<font color="a9aac1" size="2">MEMORY</font>
									<font color="8D90BC" size="2" id="memory_I"></font>
								</div>
								<div class="" style="float: left; width: 33.3%; text-align: center;">
									<font color="a9aac1" size="2">DISK</font>
									<font color="8D90BC" size="2" id="disksize_I"></font>
								</div>
							</div>
						</div>
						<div class="detail_div_child">
							<div class="sub_title_div">
								<div class="detail_font_size" style="float: left; text-align: left;">${OUTER}</div>
								<div style="float: left; text-align: right;" id="o_status_str"></div>
							</div>
							<div class="graph1">
								<div id="hideTickLineText4"></div>
							</div>
							<div class="graph1">
								<div id="hideTickLineText5"></div>
							</div>
							<div class="graph1">
								<div id="hideTickLineText6"></div>
							</div>
							<div style="float: left; width: 100%;">
								<div class="" style="float: left; width: 33.3%; text-align: center;">
									<font color="a9aac1" size="2">CPU</font>
									<font color="8D90BC" size="2" id="cpu_O"></font>
								</div>
								<div class="" style="float: left; width: 33.3%; text-align: center;">
									<font color="a9aac1" size="2">MEMORY</font>
									<font color="8D90BC" size="2" id="memory_O"></font>
								</div>
								<div class="" style="float: left; width: 33.3%; text-align: center;">
									<font color="a9aac1" size="2">DISK</font>
									<font color="8D90BC" size="2" id="disksize_O"></font>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="detail_div">
					<div class="title">
						<div style="text-align: left; ">
							 데이터 현황&nbsp;&nbsp;&nbsp;-&nbsp;
							<input type="text" id="noweDate" name="noweDate"  value="${sysDate}" readonly="readonly" class="text_input t_center" style="width: 100px; height: 18px; margin-right: 3px; background-color: #3c4262; color : white;" onclick="">
							<button type="button" class="ui-datepicker-trigger" onclick="$('.search_day').show();"><img src="/Images/icon/ico_cal.gif" alt="날짜 선택" title="날짜 선택" /></button>
						</div>
						<span class="search_day none" style="position: absolute; left: 5%; z-index: 999;"><span id="startDayText"></span></span>
					</div>
					<div class="detailBox">
						<div class="detail_div_child div_half34">
							<div class="sub_title_div"><p class="sub_title">자료 전송 추이</p></div>
							<div id="hideTickLineText7" class="graph2 mg_l5 mg_t15"></div>
							<div style="float: left; width: 100%;">
								<div class="" style="float: left; width: 100%; text-align: right;">
								<font color="5aaae7" size="1" style="font-weight: bold;">●&nbsp;자료전송(${INNER}) 개수</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="28df8f" size="1" style="font-weight: bold;">●&nbsp;자료전송(${OUTER}) 개수</font>&nbsp;&nbsp;&nbsp;&nbsp;
								</div>
							</div>
						</div>
						<div class="detail_div_child div_half34">
							<div class="sub_title_div"><p class="sub_title">통계 정보</p></div>
							<div class="detailBox">
								<div id="chart4-1" class="section statistics-section">
									<p class="section_title detail_font_size">TRS 접속 통계</p>
									<div class="grid3">
										<div id="L-1st-ratio" class="graphSection">
											<div class="graphValue"><span id="L-1st-value"></span></div>
										</div>
										<div id="L-2nd-ratio" class="graphSection">
											<div class="graphValue"><span id="L-2nd-value"></span></div>
										</div>
										<div id="L-3rd-ratio" class="graphSection">
											<div class="graphValue"><span id="L-3rd-value"></span></div>
										</div>
									</div>
									<div style="text-align: center; margin-top: 15px;">
										<font color="5aaae7" size="1">● ${INNER}</font><font color="28DF8F" size="1" class="mg_l10">● ${OUTER}</font>
									</div>
								</div>
								<div class="bg_line"></div>
								<div id="chart4-2" class="section statistics-section">
									<p class="section_title detail_font_size">자료전송 통계</p>
									<div class="grid3">
										<div id="T-1st-ratio" class="graphSection">
											<div class="graphValue"><span id="T-1st-value"></span></div>
										</div>
										<div id="T-2nd-ratio" class="graphSection">
											<div class="graphValue"><span id="T-2nd-value"></span></div>
										</div>
										<div id="T-3rd-ratio" class="graphSection">
											<div class="graphValue"><span id="T-3rd-value"></span></div>
										</div>
									</div>
									<div style="text-align: center; margin-top: 15px;">
										<font color="E949A8" size="1">● ${INNER}</font><font color="FFA547" size="1" class="mg_l10">● ${OUTER}</font>
									</div>
								</div>
							</div>
						</div>
					</div>
					<p class="title abnormal_title">이상파일 전송 현황</p>
					<div class="detailBox">
						<div class="table_area_style_total">
							<table id="mainGrid"></table>
							<div id="pager"></div>
						</div>
					</div>
					<div class="detailBox">
						<div class="table_area_style_total">
							<table id="testGrid"></table>
							<div id="pager"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
