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
	bindEventOnSearchDateInput(true);
	
	function read(approval_seq, data_seq, np_cd) {
		var url = "<c:url value="/approval/approvalView.lin" />?approval_seq=" + approval_seq + "&data_seq=" + data_seq+"&view_type=DY" + "&np_cd=" + np_cd;
		var attibute = "resizable=yes,scrollbars=yes,width=800,height=700,top=5,left=5,toolbar=no";
		var popupWindow = window.open(url, "lincubeApprovalView", attibute);
		popupWindow.focus();
	}

	function search() {
		if( ! isValidDateValue() )
			return; 

		$("#searchApprovalField").val($("select[name=selectApprovalField]").val());
		$("#searchValue").val($("#searchValueInput").val());
		$("#searchField").val($("select[name=selectSearchField]").val());

		$("#page").val("1");
		
		$("#lform").get(0).submit();
	}
	
	$(document).ready(function() {
		setDateInputDivPosition();
		checkFocusMessage($("#searchValueInput"),"최대 100자까지 가능합니다.");
	});
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/approval/deptHistoryList.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="app_type" name="app_type" value="${approvalForm.app_type}" />
<input type="hidden" id="page" name="page" value="${approvalForm.currentPage}"/>
<input type="hidden" id="searchValue" name="searchValue" value="${approvalForm.searchValue}"/>
<input type="hidden" id="searchField" name="searchField"  value="${approvalForm.searchField}" />
<input type="hidden" id="searchApprovalField" name="searchApprovalField"  value="${approvalForm.searchApprovalField}" />

<div class="rightArea">
<div class="topWarp">
	<div class="titleBox">
		<h2 class="f_left text_bold">부서결재 이력함</h2>
		<p class="breadCrumbs">결재관리 > 부서결재 이력함</p>
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
							<jsp:include page="/WebUI/include/date_input_advanced.jsp">
								<jsp:param name="t_day" value="${today}"/>
								<jsp:param name="s_day" value="${approvalForm.startDay}"/>
								<jsp:param name="e_day" value="${approvalForm.endDay}"/>
								<jsp:param name="period" value="${period}"/>
							</jsp:include>
							<select id="selectApprovalField" name="selectApprovalField" title="목록 검색조건" class="mg_l20">
								<option selected="selected" id="ALL">전체</option>
								<option <c:if test="${approvalForm.searchApprovalField eq 'Y'}">selected="selected"</c:if> id="Y" value="Y">승인</option>
								<option <c:if test="${approvalForm.searchApprovalField eq 'R'}">selected="selected"</c:if> id="R" value="R">반려</option>
								<option <c:if test="${approvalForm.searchApprovalField eq 'AC'}">selected="selected"</c:if> id="AC" value="AC">이상파일확인</option>
							</select>
							<select id="selectSearchField" name="selectSearchField" title="목록 검색조건" class="mg_50">
								<option <c:if test="${approvalForm.searchField eq 'title'}">selected="selected"</c:if> value="title">제목</option>
								<option <c:if test="${approvalForm.searchField eq 'users_nm'}">selected="selected"</c:if> value="users_nm">요청자</option>
								<option <c:if test="${approvalForm.searchField eq 'real_appr_nm'}">selected="selected"</c:if> value="real_appr_nm">결재자</option>
							</select>
							<input id="searchValueInput" name="searchValueInput" type="text" class="text_input long" style="max-width:70%;" placeholder="검색어를 입력해주세요." value="${approvalForm.searchValue}" onkeyup="onlySizeFillter(this,100)" onkeydown="return keyDownEnterDoSearch();"/>
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
			<caption><spring:message code="common.approval.status"/>,결재요청자,결재제목,결재요청시각,결재시각</caption>
				<colgroup>
					<col style="width:12%;" />	<!-- 결재상태 -->
					<col style="width:12%;" />	<!-- 작성자 -->
					<col style="width:12%;" />	<!-- 작성자 -->
					<col style="width:29%;" />	<!-- 결재제목 -->
					<col style="width:14%;" />	<!-- 결재요청시각 -->
					<col style="width:14%;" />	<!-- 결재완료시각 -->
				</colgroup>
				<thead>
					<tr>
						<th class="right_line"><spring:message code="common.approval.status"/></th>
						<th class="right_line">요청자</th>
						<th class="right_line">결재자</th>
						<th class="right_line">제목</th>
						<th class="right_line">요청시각</th>
						<th class="right_line">결재시각</th>
					</tr>
				</thead>
				<tbody>
				<c:choose>
				<c:when test="${not empty approvalList}">
				<c:forEach items="${approvalList}" var="approval">
					<tr id="tr_id_${approval.approval_seq}" onClick="read('${approval.approval_seq}','${approval.data_seq}','${approval.np_cd}'); return false;">
						<td class="right_line t_center">${customfunc:codeDes("APP_TYPE", approval.app_type) }</td>
						<td class="right_line t_center"><a title="${approval.users_nm}(${approval.users_id})"><c:out value="${approval.users_nm}(${approval.users_id})" /></a></td>
						<td class="right_line t_center"><a title="${approval.real_appr_nm}(${approval.real_appr_id})"><c:out value="${approval.real_appr_nm}(${approval.real_appr_id})" /></a></td>
						<td class="right_line"><%-- <a title="${approval.title}" href="javascript:;"  onClick="read('${approval.approval_seq}','${approval.data_seq}'); return false;"> --%><c:out value="${approval.title}" /><!-- </a> --></td>
						<td class="right_line t_center"><fmt:formatDate value="${approval.crt_time}" pattern="yyyy-MM-dd HH:mm" /></td>
						<td class="right_line t_center"><fmt:formatDate value="${approval.app_time}" pattern="yyyy-MM-dd HH:mm" /></td>
					</tr>
				</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td class="t_center" colspan="6"><div class="no_result"><spring:message code="global.script.search.no.result" /></div></td>
					</tr>
				</c:otherwise>
				</c:choose>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="6" class="td_last" style="background-color: #EEEEEE;">
							<jsp:include page="/WebUI/include/footer_list_count_select.jsp">
								<jsp:param name="size" value="${approvalForm.pageListSize}"/>
								<jsp:param name="currentPage" value="${approvalForm.currentPage}"/>
							</jsp:include>
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
