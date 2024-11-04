<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />

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
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/audit/streamAudit/sPacketList.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden"/>
<input id="pageListSize" name="pageListSize" type="hidden" value="10"/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">트래픽 이력</h2>
				<p class="breadCrumbs">로그관리 > 트래픽 이력</p>
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
										<input type="text" name="startDay" value="${sPacketSizeForm.startDay}" readonly class="text_input short t_center"/>
										<img class="img_ico" onclick="showCalendar('lform', 'startDay', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">
										<input type="text" name="startHour" maxLength="2" value="${sPacketSizeForm.startHour}" style="width:40px;" /><span class="b_text">시</span>
										<input type="text" name="startMin" maxLength="2" value="${sPacketSizeForm.startMin}" style="width:40px;" /><span class="b_text">분</span>
									</span>
									&#126;
									<span class="search_day">
										<input type="text" name="endDay" value="${sPacketSizeForm.endDay}" class="text_input short t_center" readonly />
										<img class="img_ico" onclick="showCalendar('lform', 'endDay', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">&nbsp;&nbsp;
										<input type="text" name="endHour" maxLength="2" value="${sPacketSizeForm.endHour}" style="width:40px;" /><span class="b_text">시</span>
										<input type="text" name="endMin" maxLength="2" value="${sPacketSizeForm.endMin}" style="width:40px;" /><span class="b_text">분</span>
									</span>
									<select id="searchField" name="searchField" title="목록 검색조건" class="mg_l20">
										<option <c:if test="${sPacketSizeForm.searchField eq 'pol_seq'}">selected="selected"</c:if> value="pol_seq">정책ID</option>
										<option <c:if test="${sPacketSizeForm.searchField eq 'stm_id'}">selected="selected"</c:if> value="stm_id">서버ID</option>
									</select>
									<input id="searchValue" name="searchValue" type="text" class="text_input long" style="max-width:70%;" value="${sPacketSizeForm.searchValue}" placeholder="검색어를 입력해주세요." onkeyup="onlySizeFillter(this,100)"/>
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
							<col style="width:15%;"/>
							<col style="width:15%;"/>
							<col style="width:15%;" />
							<col style="width:15%;" />
							<col style="width:25%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder">정책ID</th>
								<th class="Rborder">서버ID</th>
								<th class="Rborder">망구분</th>
								<th class="Rborder">전송량(KB)</th>
								<th class="Rborder">발생시간</th>
							</tr>
						</thead>
						<tbody>
						<c:choose>
						<c:when test="${not empty sPacketSizeList}">
							<c:forEach items="${sPacketSizeList}" var="sPacketSize">
								<tr>
									<td class="t_center Rborder">
										<c:out value="${sPacketSize.pol_seq}" />
									</td>
									<td class="t_center Rborder">
										<c:out value="${sPacketSize.stm_id}" />
									</td>
									<td class="t_center Rborder" >
										<c:choose>
											<c:when test="${sPacketSize.io_cd eq 'I'}">
												<c:out value="보안영역" />
											</c:when>
											<c:otherwise>
												<c:out value="비-보안영역" />
											</c:otherwise>
										</c:choose>
									</td>
									<td class="t_center Rborder" >
										<c:out value="${sPacketSize.datasize}" />
									</td>
									<td class="t_center Rborder" >
										<c:out value="${sPacketSize.write_date}" />
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="5">
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
								<td colspan="5" class="td_last">
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