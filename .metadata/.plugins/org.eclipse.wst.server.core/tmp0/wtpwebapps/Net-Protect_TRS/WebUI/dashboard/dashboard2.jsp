<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="/css/theme_red.css">
<title>dashboard2</title>
<script type="text/javascript" src="<c:url value="/jqplot/jquery.jqplot.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.canvasTextRenderer.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.canvasAxisLabelRenderer.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.enhancedLegendRenderer.min.js" />"></script>

<script type="text/javascript" src="<c:url value="/jqplot/plugins/jqplot.pieRenderer.min.js" />"></script>

<link rel="stylesheet" type="text/css" href="<c:url value="/jqplot/jquery.jqplot.min.js" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/jqplot/jquery.jqplot.min.css" />" />

<script type="text/javascript">


</script>
</head>
<body onload="pageRefresh()">
	<form id="lform" name="lform" onsubmit="return false;" method="post"
		action="<c:url value="/hr/user/userManagement.lin" />">
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

			<div class="conWrap dashboardBox">
				<h3>보안 영역 최다 사용 정책TOP5</h3>
				<div class="conBox graphBox">
					<div class="graph_line1">
						<div class="graph_box">
							<div id="chart4" class="f_left mg_t20" style="width: 99%; height: 20%;"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="conWrap dashboardBox">
				<h3>비-보안 영역 최다 사용 정책TOP5</h3>
				<div class="conBox graphBox">
					<div class="graph_line1">
						<div class="graph_box">
							<div id="chart2" class="f_left mg_t20" style="width: 99%; height: 20%;"></div>
						</div>
					</div>
				</div>
			</div>
<div class="conWrap dashboardBox">
				<h3>스트림 연계 최다 사용자</h3>
				<div class="table_area_style01">
				<button class="btn_common theme" id="m_button"style="float:right" onClick="splitCheck('m')">월간</button>
				<button class="btn_common theme" id="m_button"style="float:right" onClick="splitCheck('w')">주간</button>
				<button class="btn_common theme" id="m_button"style="float:right" onClick="splitCheck('d')">일간</button>
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
									<c:when test="${not empty selectSTMTopUserList}">
									<%-- <c:if test = "${sConnInfo.io_cd eq 'I'}" var="sConnInfo" > --%> 
										<c:forEach items="${selectSTMTopUserList}" var= "sConnInfo" varStatus="status" end="4">
											<tr>
												<td class="t_center Rborder"><c:out value="${sConnInfo.rank}" /></td>
												<td class="t_center Rborder"><c:out value="${sConnInfo.source_ip}" /></td>
 												<td class="t_center Rborder"><c:out value="${sConnInfo.data_sum}" />mb</td>
											</tr>
										</c:forEach>
										<%-- </c:if>  --%>
									</c:when>
									<c:otherwise>
										<tr>
											<td class="t_center" colspan="3"><div class="no_result">결과가 없습니다.</div></td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
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
									<c:when test="${not empty selectSTMTopUserList}">
									<%-- <c:if test = "${sConnInfo.io_cd eq 'I'}" var="sConnInfo" > --%> 
										<c:forEach items="${selectSTMTopUserList}" var= "sConnInfo" varStatus="status" begin="5">
											<tr>
												<td class="t_center Rborder"><c:out value="${sConnInfo.rank}" /></td>
												<td class="t_center Rborder"><c:out value="${sConnInfo.source_ip}" /></td>
 												<td class="t_center Rborder"><c:out value="${sConnInfo.data_sum}" />mb</td>
											</tr>
										</c:forEach>
										<%-- </c:if>  --%>
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
			<div class="conWrap dashboardBox">
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
								<c:when test="${not empty sPacketSizes}">
									<c:forEach items="${sPacketSizes}" var="k" varStatus="status" end="4">
										<tr>
											<td class="t_center Rborder"><c:out value="${status.count}" /></td>
											<td class="t_center Rborder"><c:out value="${k.stm_id}" /></td>
											<td class="t_center Rborder"><c:out value="${k.datasize}" />KB</td>										
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
			<div class="conWrap dashboardBox">
				<h3>이상 연결 요청 이력</h3>
				<div class="table_area_style01">
					<!-- <p class="tableTitle">비-보안영역 최다 자료 전송 TOP5</p> -->
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
								<c:when test="${not empty sConnInfoList}">
									<c:forEach items="${sConnInfoList}" var="dataForm">
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
											<%-- <td class="t_center Rborder"><c:out value="${dataForm.disconn_reason}"/></td> --%>
											<td class="t_center Rborder">
											<c:choose>
													<c:when test="${dataForm.io_cd eq '1' || '0'}">
														보안영역
													</c:when>
													<c:otherwise>
														비-보안영역
													</c:otherwise>
											</c:choose>
											</td>
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
			<div class="conWrap dashboardBox">
				<h3>스트림 연계 현황</h3>
				<div class="table_area_style01">
					<!-- <p class="tableTitle">보안영역 최다 자료 전송 TOP5</p> -->
					<table summary="그래프1 상세정보" style="table-layout: fixed;">
						<caption>그래프1 상세정보</caption>
						<colgroup>
							<col style="width: 10%;" />
							<col style="width: 45%;" />
							<col style="width: 35%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="t_center Rborder">순위</th>
								<th class="t_center Rborder">사용자ID(사용자명)</th>
								<th class="t_center">전송횟수</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty topTransCntInnerList}">
									<c:forEach items="${topTransCntInnerList}" var="dataForm" end="4" varStatus="status">
										<tr>
											<td class="t_center Rborder"><c:out value="${status.count}" /></td>
											<td class="t_center Rborder"><c:out value="${dataForm.users_id}" />(<c:out value="${dataForm.users_nm}" />)</td>
											<td class="t_center Rborder"><c:out value='${dataForm.transCnt}' />건</td>
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
	</form>
</body>
</html>