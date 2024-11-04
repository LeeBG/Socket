<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<script type="text/javascript">
	$(document).ready(function() {
		
	});

	function goPage(page) {
		$("#page").val(page);
		$("#lform").get(0).submit();
	}

	function search() {
		var errmsg = new cls_errmsg();

		var sDate = $(":input[name=startDay]").val();
		var sHour = $(":input[name=startHour]").val();
		var sMin= $(":input[name=startMin]").val();
		var eDate = $(":input[name=endDay]").val();
		var eHour= $(":input[name=endHour]").val();
		var eMin= $(":input[name=endMin]").val();

		var sDateCheck = dateFormatCheck(sDate);
		var sHourCheck = dateFormatCheck(sHour, "hour");
		var sMinCheck = dateFormatCheck(sMin, "minute");
		var eDateCheck = dateFormatCheck(eDate);
		var eHourCheck = dateFormatCheck(eHour, "hour");
		var eMinCheck = dateFormatCheck(eMin, "minute");

		if (!sDateCheck) errmsg.append(null, "<spring:message code="data.file.sendList.search.script.invalid.startDate" arguments="\" + sDate + \"" />");
		else if (!sHourCheck) errmsg.append(null, "<spring:message code="data.file.sendList.search.script.invalid.startHour" />");
		else if (!sMinCheck) errmsg.append(null, "<spring:message code="data.file.sendList.search.script.invalid.startMinute" />");
		else if (!eDateCheck) errmsg.append(null, "<spring:message code="data.file.sendList.search.script.invalid.endDate" arguments="\" + eDate + \"" />");
		else if (!eHourCheck) errmsg.append(null, "<spring:message code="data.file.sendList.search.script.invalid.endHour" />");
		else if (!eMinCheck) errmsg.append(null, "<spring:message code="data.file.sendList.search.script.invalid.endMinute" />");
		else if (!dateCheck(sDate + "-" + sHour + "-" + sMin, eDate + "-" + eHour + "-" + eMin, "minute")) 
		errmsg.append(null, "<spring:message code="data.file.sendList.search.script.invalid.searchDate" arguments="\" + sDate + \" \" + sHour + \":\" + sMin + \",\" + eDate + \" \" + eHour + \":\" + eMin + \"" />");

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		$("#lform").get(0).submit();
	}
	
	$(document).ready(function() {
		checkFocusMessage($("#searchValue"),"최대 100자까지 가능합니다.");
	});
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/audit/streamAudit/sConnInfoList.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden"/>
<input id="pageListSize" name="pageListSize" type="hidden" value="10"/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">스트림 연계 이력</h2>
				<p class="breadCrumbs">로그관리 > 스트림 연계 이력</p>
			</div>
		</div>
		<div class="conWrap">
			<h3>검색조건</h3>
			<div class="conBox searchBox t_center">
				<div class="topCon nBorder">
					<table summary="정책 검색조건" style="table-layout : fixed" >
					<caption>검색조건, 버튼</caption>
						<tbody>
							<colgroup>
								<col style="width:100%;"/>
							</colgroup>
							<tr>
								<td class="t_center">
									<span class="search_day">
										<input type="text" name="startDay" value="${sConnInfoForm.startDay}" readonly class="text_input short t_center"/>
										<img class="img_ico" onclick="showCalendar('lform', 'startDay', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">
										<input type="text" name="startHour" maxLength="2" value="${sConnInfoForm.startHour}" style="width:40px;" /><span class="b_text">시</span>
										<input type="text" name="startMin" maxLength="2" value="${sConnInfoForm.startMin}" style="width:40px;" /><span class="b_text">분</span>
									</span>
									&#126;
									<span class="search_day">
										<input type="text" name="endDay" value="${sConnInfoForm.endDay}" class="text_input short t_center" readonly />
										<img class="img_ico" onclick="showCalendar('lform', 'endDay', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">&nbsp;&nbsp;
										<input type="text" name="endHour" maxLength="2" value="${sConnInfoForm.endHour}" style="width:40px;" /><span class="b_text">시</span>
										<input type="text" name="endMin" maxLength="2" value="${sConnInfoForm.endMin}" style="width:40px;" /><span class="b_text">분</span>
									</span>
									<select id="searchField" name="searchField" title="목록 검색조건" class="mg_l20">
										<option <c:if test="${sConnInfoForm.searchField eq 'pol_seq'}">selected="selected"</c:if> value="pol_seq">정책ID</option>
										<option <c:if test="${sConnInfoForm.searchField eq 'stm_id'}">selected="selected"</c:if> value="stm_id">서버ID</option>
										<option <c:if test="${sConnInfoForm.searchField eq 'rst_cd'}">selected="selected"</c:if> value="rst_cd">성공여부</option>
									</select>
									<input id="searchValue" name="searchValue" type="text" class="text_input long" style="max-width:70%;" value="${sConnInfoForm.searchValue}" placeholder="검색어를 입력해주세요." onkeyup="onlySizeFillter(this,100)"/>
									<button class="btn_common theme" onClick="search();">검색</button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="conWrap tableBox">
			<h3>목록</h3>
			<div class="conBox">
				<div class="table_area_style01 hoverTable">
					<table summary="스트림 연계 이력" style="table-layout : fixed" class="mg_t5">
					<caption>스트림 연계 이력</caption>
						<colgroup>
							<col style="width:10%;"/>
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:15%;" />
							<col style="width:15%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder">정책ID</th>
								<th class="Rborder">서버ID</th>
								<th class="Rborder">망구분</th>
								<th class="Rborder">접속IP</th>
								<th class="Rborder">접속PORT</th>
								<th class="Rborder">중계IP</th>
								<th class="Rborder">중계PORT</th>
								<th class="Rborder">연결상태</th>
								<th class="Rborder">성공여부</th>
								<th class="Rborder">비고</th>
								<th class="Rborder">발생시간</th>
							</tr>
						</thead>
						<tbody>
						<c:choose>
						<c:when test="${not empty sConnInfoList}">
							<c:forEach items="${sConnInfoList}" var="sConnInfo">
								<tr>
									<c:choose>
										<c:when test="${sConnInfo.pol_seq eq ''}">
											<c:set var="pol_seq_str" value="알수없음" />
										</c:when>
										<c:otherwise>
											<c:set var="pol_seq_str" value="${sConnInfo.pol_seq}" />
										</c:otherwise>
									</c:choose>
									<td class="t_center Rborder" title="<c:out value="${pol_seq_str}" />">
										<c:out value="${pol_seq_str}" />
									</td>
									<td class="t_center Rborder" title="<c:out value="${sConnInfo.stm_id}" />">
										<c:out value="${sConnInfo.stm_id}" />
									</td>
									
									<c:choose>
										<c:when test="${sConnInfo.io_cd eq 'I'}">
											<c:set var="io_cd_str" value="보안영역" />
										</c:when>
										<c:otherwise>
											<c:set var="io_cd_str" value="비-보안영역" />
										</c:otherwise>
									</c:choose>
									<td class="t_center Rborder" title="<c:out value="${io_cd_str }" />">
										<c:out value="${io_cd_str }" />
									</td>
									
									<td class="t_center Rborder" title="<c:out value="${sConnInfo.source_ip}" />">
										<c:out value="${sConnInfo.source_ip}" />
									</td>
									<td class="t_center Rborder" title="<c:out value="${sConnInfo.source_port}" />">
										<c:out value="${sConnInfo.source_port}" />
									</td>
									<td class="t_center Rborder" title="<c:out value="${sConnInfo.dest_ip}" />">
										<c:out value="${sConnInfo.dest_ip}" />
									</td>
									<td class="t_center Rborder" title="<c:out value="${sConnInfo.dest_port}" />">
										<c:out value="${sConnInfo.dest_port}" />
									</td>
									
									<c:choose>
										<c:when test="${sConnInfo.conn_type == 1}">
											<c:set var="conn_type_str" value="연결" />
										</c:when>
										<c:otherwise>
											<c:set var="conn_type_str" value="연결종료" />
										</c:otherwise>
									</c:choose>
									<td class="t_center Rborder" title="<c:out value="${conn_type_str }" />">
										<c:out value="${conn_type_str }" />
									</td>
									
									<c:choose>
										<c:when test="${sConnInfo.rst_cd eq 'S'}">
											<c:set var="rst_cd_str" value="성공" />
										</c:when>
										<c:otherwise>
											<c:set var="rst_cd_str" value="실패" />
										</c:otherwise>
									</c:choose>
									<td class="t_center Rborder" title="<c:out value="${rst_cd_str }" />">
										<c:out value="${rst_cd_str }" />
									</td>
									
									<td class="t_center Rborder" title="<spring:message code="sm.lg.sConnInfo.disconnReason_${sConnInfo.disconn_reason}"/>">
										<spring:message code="sm.lg.sConnInfo.disconnReason_${sConnInfo.disconn_reason}"/>
										<%-- <c:choose>
											<c:when test="${sConnInfo.disconn_reason eq '1'}">
												<c:out value="사용자 연결종료" />
											</c:when>
											<c:when test="${sConnInfo.disconn_reason eq '2'}">
												<c:out value="WebShell Pattern 탐지" />
											</c:when>
											<c:when test="${sConnInfo.disconn_reason eq '3'}">
												<c:out value="목적지 연결실패" />
											</c:when>
											<c:when test="${sConnInfo.disconn_reason eq '4'}">
												<c:out value="허용되지 않은 IP or MAC" />
											</c:when>
											<c:when test="${sConnInfo.disconn_reason eq '5'}">
												<c:out value="허용되지 않은 프로토콜" />
											</c:when>
											<c:otherwise>
												<c:out value="" />
											</c:otherwise>
										</c:choose> --%>
									</td>
									<td class="t_center Rborder" title="<c:out value="${sConnInfo.write_date}" />">
										<c:out value="${sConnInfo.write_date}" />
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="11">
									<div class="no_result">
										<spring:message code="global.script.search.no.result" />
									</div>
								</td>
							</tr>
						</c:otherwise>
						</c:choose>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="11" class="td_last">
								<span class="text_list_number"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></span>
								<div class="pagenate t_center">
									${pageList}
								</div>
								</td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>