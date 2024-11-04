<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="isApprovalUse" value="${sessionScope.loginUser.approvalPolicy.approvalUse}" />
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:choose>
<c:when test="${isApprovalUse}">
	<c:set var="colspan" value="6"/>
</c:when>
<c:otherwise>
	<c:set var="colspan" value="5"/>
</c:otherwise>
</c:choose>
<html>
<head>
<script type="text/javascript">
	bindEventOnSearchDateInput();

	$(document).ready(function() {
		if ('${dataForm.searchField }' == 'file_nm') {
			$("#select_first").text($("#file_nm").text());
		}

		$("#pageLine").click(function(){
			$("#pageLineList").toggle();
		});

		$("#pageLineList > li > a").click(function(){
			$("#select_pageLine_first").text($(this).text());
		});
	});

	function search() {
		var errmsg = new cls_errmsg();

		try {
			checkDateValidation();
		} catch (e) {
			errmsg.append(null,e);
		}
		
		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		$("#lform").get(0).submit();
	}

	function read(sequence) {
		var url = "<c:url value="/data/file/dataView.lin" />?data_seq=" + sequence + "&networkPosition=${dataForm.networkPosition}";
		var attibute = "resizable=no,scrollbars=yes,width=800,height=700,top=5,left=5,toolbar=no,resizable=no";
		var popupWindow = window.open(url, "lincubeSendList", attibute);
		popupWindow.focus();
	}

	function del() {
		var errmsg = new cls_errmsg();

		if (!$(":checkbox[name=chk]").is(":checked")) {
			errmsg.append(null, "<spring:message code="data.file.sendList.search.script.required.delete" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		if (confirm("<spring:message code="data.file.sendList.search.script.confirm.delete" />")) {
			var requestURL = "<c:url value="/data/file/delete.lin" />";
			var successURL = "<c:url value="/data/file/sendList.lin" />";
			resultCheck($("#lform"), requestURL, successURL, true);
		}
	}

	function withdrawApproval(dataSeq) {
		if (confirm("결재 대기중인 자료를 회수 하겠습니까?")) {
			var requestURL = "<c:url value="/data/file/withdrawApproval.lin" />?data_seq=" + dataSeq;
			var successURL = "<c:url value="/data/file/sendList.lin" />";
			resultCheck($("#lform"), requestURL, successURL, true);
		}
	}
	
	$(document).ready(function() {
		checkFocusMessage($("#searchValue"),"최대 100자까지 가능합니다.");
	});
	
	function allCheckBoxCheck(){
		var isCheckBox = true;
		$('input:checkbox[name="chk"]').each(function() {
			if(this.checked == false){
				$("#allChk").attr('checked', false);
				isCheckBox = false;
			}
		});
		
		if(isCheckBox){
			$("#allChk").attr('checked', true);
		}
	}
	
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/data/file/sendList.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden"/>
<input id="type" name="type" type="hidden" value="tx"/>
<div class="rightArea">
<div class="topWarp">
	<div class="titleBox">
		<h2 class="f_left text_bold">보낸자료</h2>
		<p class="breadCrumbs">이력관리 > 보낸자료</p>
	</div>
</div>
<div class="conWrap">
	<h3>검색조건</h3>
	<div class="conBox searchBox t_center">
		<div class="topCon nBorder"  >
			<table summary="정책 검색조건" style="table-layout : fixed" >
			<caption>검색조건, 버튼</caption>
				<colgroup>
				</colgroup>
				<tbody>
					<tr>
						<td class="t_center">
							<jsp:include page="/WebUI/include/date_input.jsp">
								<jsp:param name="s_day" value="${dataForm.startDay}"/>
								<jsp:param name="s_hour" value="${dataForm.startHour}"/>
								<jsp:param name="s_min" value="${dataForm.startMin}"/>
								<jsp:param name="e_day" value="${dataForm.endDay}"/>
								<jsp:param name="e_hour" value="${dataForm.endHour}"/>
								<jsp:param name="e_min" value="${dataForm.endMin}"/>
							</jsp:include>
							<select id="searchField" name="searchField" title="목록 검색조건" class="mg_l20">
								<option value="title" ${dataForm.searchField eq 'title' ? 'selected' : ''}><spring:message code="data.file.receiveList.search.select.title" /></option>
								<option value="file_nm" ${dataForm.searchField eq 'file_nm' ? 'selected' : ''}><spring:message code="data.file.receiveList.search.select.fileName" /></option>
							</select>
							<input id="searchValue" name="searchValue" type="text" class="text_input long" style="max-width:70%;" value="${dataForm.searchValue}" placeholder="검색어를 입력해주세요." onkeyup="onlySizeFillter(this,100)"/>
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
			<div class="table_area_topCon mg_t10 mg_b5">
				<button type="button" class="btn_common mg_l5" onclick="del();" >삭제</button>
				<%-- <select id="pageListSize" name="pageListSize" title="리스트 노출 갯수" class="mg_l20">
					<option value="5" ${dataForm.pageListSize eq '5' ? 'selected' : ''}>5</option>
					<option value="10" ${dataForm.pageListSize eq '10' ? 'selected' : ''}>10</option>
				</select> --%>
			</div>
			
			<table summary="받은자료" style="table-layout : fixed">
			<caption>삭제유무, 중요, 제목, 파일, 전송일</caption>
				<colgroup>
					<col style="width:5%;" />
					<col style="width:8%;" />
					<col style="width:40%;" />
					<col style="width:13%;" />
					<col style="width:13%;" />
					<c:if test="${isApprovalUse}">
						<col style="width:8%;" />
					</c:if>
				</colgroup>
				<thead>
					<tr>
						<th class="right_line"><input type="checkbox" class="input_chk" id="allChk" name="allChk" onclick="togchk(this, 'chk');"/></th>
						<th><spring:message code="data.file.sendList.list.status" /></th>
						<th><spring:message code="data.file.sendList.list.title" /></th>
						<th><spring:message code="data.file.sendList.list.file" /></th>
						<th><spring:message code="data.file.sendList.list.sendDate" /></th>
						<c:if test="${isApprovalUse}">
						<th>회수</th>
						</c:if>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty dataList}">
						<c:forEach items="${dataList}" var="data">
							<tr id="tr_id_${data.data_seq}">
								<td class="right_line t_center"><input type="checkbox" class="input_chk" name="chk" id="chk" value="${data.data_seq}" onclick="allCheckBoxCheck()" /></td>
								<td class="t_center text_red">
									${customfunc:codeDes('DATA_STATUS', data.status)}
								</td>
								<td><a title="${data.title}" href="javascript:;"  onClick="read('${data.data_seq}'); return false;"><c:out value="${data.title }" escapeXml="true" /></a></td>
								<td class="t_center">
									${fn:length(data.attachFileFormList)}<spring:message code="data.file.sendList.list.file.unit" />(<c:out value="${customfunc:BigFileSizeFormat(data.totalAttachFileSize)}" />)
								</td>
								<td class="t_center"><fmt:formatDate value="${data.crt_time}" pattern="yyyy-MM-dd HH:mm" /></td>
								<c:if test="${isApprovalUse}">
									<td class="t_center">
									<c:if test="${data.status eq 'AW'}">
										<button type="button" class="btn_common mg_l5" onclick="withdrawApproval('${data.data_seq}');" >회수</button>
									</c:if>
									</td>
								</c:if>
							</tr>
						</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="${colspan}"><div class="no_result"><spring:message code="global.script.search.no.result" /></div></td>
							</tr>
						</c:otherwise>
						</c:choose>
					
				</tbody>
				<tfoot>
					<tr>
						<td colspan="${colspan}" class="td_last">
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
