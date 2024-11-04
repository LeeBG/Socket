<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<script type="text/javascript">
	bindEventOnSearchDateInput();

	function read(approval_seq, request_seq) {
		var url = "<c:url value="/authRequest/SelfApprovalRequestApprovalView.lin" />?approval_seq=" + approval_seq + "&request_seq=" + request_seq +"&view_type=W";
		var attibute = "resizable=no,scrollbars=yes,width=800,height=700,top=5,left=5,toolbar=no,resizable=no";
		var popupWindow = window.open(url, "lincubeApprovalView", attibute);
		popupWindow.focus();
	}

	function approvalListRefresh(){
		$("#lform").get(0).submit();
	}

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

		$("#searchValue").val($("#searchValueInput").val());
		$("#searchField").val($("select[name=selectSearchField]").val());

		$("#lform").get(0).submit();
	}
	
	
	$(document).ready(function() {
		checkFocusMessage($("#searchValueInput"),"최대 100자까지 가능합니다.");
	});
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/authRequest/SelfApprovalRequestList.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="app_type" name="app_type" value="${approvalForm.app_type}" />
<input type="hidden" id="page" name="page" value="${approvalForm.currentPage}"/>
<input type="hidden" id="searchValue" name="searchValue" value="${approvalForm.searchValue}"/>
<input type="hidden" id="searchField" name="searchField"  value="${approvalForm.searchField}" />

<div class="rightArea">
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold">결재 대기함</h2>
			<p class="breadCrumbs">권한요청> 결재 대기함</p>
		</div>
	</div>
<div class="conWrap">
	<h3>검색조건</h3>
	<div class="conBox searchBox t_center">
		<div class="topCon nBorder">
			<table summary="정책 검색조건" style="table-layout : fixed" >
			<caption>검색조건, 버튼</caption>
				<colgroup>
				</colgroup>
				<tbody>
					<tr>
						<td class="t_center">
							<jsp:include page="/WebUI/include/date_input.jsp">
								<jsp:param name="s_day" value="${approvalForm.startDay}"/>
								<jsp:param name="s_hour" value="${approvalForm.startHour}"/>
								<jsp:param name="s_min" value="${approvalForm.startMin}"/>
								<jsp:param name="e_day" value="${approvalForm.endDay}"/>
								<jsp:param name="e_hour" value="${approvalForm.endHour}"/>
								<jsp:param name="e_min" value="${approvalForm.endMin}"/>
							</jsp:include>
							<select id="selectSearchField" name="selectSearchField" title="목록 검색조건" class="mg_50">
								<option <c:if test="${approvalForm.searchField eq 'request_comment'}">selected="selected"</c:if> value="request_comment">제목</option>
								<option <c:if test="${approvalForm.searchField eq 'request_user_id'}">selected="selected"</c:if> value="request_user_id">요청자</option>
							</select>
							<input id="searchValueInput" name="searchValueInput" type="text" class="text_input long" style="max-width:70%;" placeholder="검색어를 입력해주세요." value="${approvalForm.searchValue}" onkeyup="onlySizeFillter(this,100)"/>
							<button class="btn_common theme" onClick="search()">검색</button>
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
			<table summary="결재관리 테이블입니다." style="table-layout : fixed">
			<caption><spring:message code="common.approval.status"/>,결재요청자,결재제목,파일,결재요청시각</caption>
				<colgroup>
					<col style="width:20%;" />	<!-- 결재상태 -->
					<col style="width:20%;" />	<!-- 요청자 -->
					<col style="width:40%;" />	<!-- 결재제목 -->
					<col style="width:20%;" />	<!-- 결재요청시각 -->
				</colgroup>
				<thead>
					<tr>
						<th class="right_line"><spring:message code="common.approval.status"/></th>
						<th class="right_line">요청자</th>
						<th class="right_line">제목</th>
						<th class="right_line">요청시각</th>
					</tr>
				</thead>
				<tbody>
				<c:choose>
				<c:when test="${not empty approvalList}">
				<c:forEach items="${approvalList}" var="approval">
					<tr id="tr_id_${approval.approval_seq}">
						<c:choose>
						<c:when test="${loginUser.users_id != approval.appr_id}">
							<td class="right_line t_center">${customfunc:codeDes("APP_TYPE", approval.app_type) }</td>
						</c:when>
						<c:otherwise>
							<td class="right_line t_center">${customfunc:codeDes("APP_TYPE", approval.app_type) }</td>
						</c:otherwise>
						</c:choose>
						<td class="right_line t_center"><span title="${approval.users_nm}(${approval.users_id})"><c:out value="${approval.users_nm}(${approval.users_id})" /></span></td>
						<td class="right_line"><a href="javascript:;"  onClick="read('${approval.approval_seq}','${approval.request_seq}'); return false;">[<spring:message code="common.selfapproval"/>요청]<c:out value="${approval.title}" /></a></td>
						<td class="right_line t_center"><fmt:formatDate value="${approval.crt_time}" pattern="yyyy-MM-dd HH:mm" /></td>
					</tr>
				</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td class="t_center" colspan="5"><div class="no_result"><spring:message code="global.script.search.no.result" /></div></td>
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
