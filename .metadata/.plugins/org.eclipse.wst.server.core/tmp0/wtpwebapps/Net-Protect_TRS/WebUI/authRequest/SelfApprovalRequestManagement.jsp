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
	function deleteSelfApprovalRequest() {
		if (!$(":checkbox[name=chk]").is(":checked")) {
			alert("삭제할 이력을 선택하세요.");
			return;
		} 

		var requestURL = "<c:url value="/authRequest/deleteSelfApprovalRequest.lin" />";
		var successURL = "<c:url value="/authRequest/SelfApprovalRequestManagement.lin" />";
		resultCheck($("#lform"), requestURL, successURL, true)
	}

	$(document).ready(function() {
		checkFocusMessage($("#searchValueInput"),"최대 100자까지 가능합니다.");
	});
</script>
<style>
	.padding8{ padding:8px !important; }
	.first-item{ text-align: center; }
</style>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/authRequest/SelfApprovalRequestManagement.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="app_type" name="app_type" value="${approvalForm.app_type}" />
<input type="hidden" id="page" name="page" value="${approvalForm.currentPage}"/>
<input type="hidden" id="searchValue" name="searchValue" value="${approvalForm.searchValue}"/>
<input type="hidden" id="searchField" name="searchField"  value="${approvalForm.searchField}" />
<%-- <c:out value = "${authRequestList}"/> --%>
<div class="rightArea">
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold">자가결재 요청 관리</h2>
			<p class="breadCrumbs">인사관리 > 자가결재요청 관리</p>
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
			<div class="table_area_topCon mg_t10 mg_b5">
					<button type="button" class="btn_common theme button_left_margin mg_l5" onclick="deleteSelfApprovalRequest();">삭제</button>
			</div>
			<table summary="결재관리 테이블입니다." style="table-layout : fixed">
			
			<caption><spring:message code="common.approval.status"/>,결재요청자,결재제목,결재요청시각</caption>
				<colgroup>
					<col style="width:5%;" />	<!-- 결재상태 -->
					<col style="width:10%;" />	<!-- 결재상태 -->
					<col style="width:15%;" />	<!-- 요청자 -->
					<col style="width:31%;" />	<!-- 결재제목 -->
					<col style="width:13%;" />	<!-- 시작날짜 -->
					<col style="width:13%;" />	<!-- 종료날짜 -->
					<col style="width:13%;" />	<!-- 결재요청시각 -->
				</colgroup>
				<thead>
					<tr>
						<th class="right_line"><input type="checkbox" class="input_chk button_left_margin " id="allChk" name="allChk" onclick="togchk(this, 'chk');"/></th>
						<th class="right_line"><spring:message code="common.approval.status"/></th>
						<th class="right_line">요청자</th>
						<th class="right_line">제목</th>
						<th class="right_line">시작날짜</th>
						<th class="right_line">종료날짜</th>
						<th class="right_line">요청시각</th>
					</tr>
				</thead>
				<tbody>
				<c:choose>
				<c:when test="${not empty approvalList}">
				<c:forEach items="${approvalList}" var="approval">
					<tr id="tr_id_${approval.approval_seq}">
					<td class="first-item">
						<input type="checkbox" type="checkbox" class="input_chk button_left_margin" name="chk" id="chk" value="${approval.request_seq}" onclick="allCheckBoxCheck()"/>
					</td>
						<c:choose>
						<c:when test="${loginUser.users_id != approval.appr_id}">
							<td class="right_line t_center" id = "app_type">${customfunc:codeDes("APP_TYPE", approval.app_type) }</td>
						</c:when>
						<c:otherwise>
							<td class="right_line t_center" id = "app_type">${customfunc:codeDes("APP_TYPE", approval.app_type) }</td>
						</c:otherwise>
						</c:choose>
						<td class="right_line t_center"><span title="${approval.users_nm}(${approval.users_id})"><c:out value="${approval.users_nm}(${approval.users_id})" /></span></td>
						<td class="right_line t_left"><a href="javascript:;"  onClick="read('${approval.approval_seq}','${approval.request_seq}'); return false;">[자가결재요청]<c:out value="${approval.title}" /></a></td>
						<td class="right_line t_center"><c:out value = "${approval.startDate}"/></td>
						<td class="right_line t_center"><c:out value = "${approval.endDate}"/></td>
						<%-- <td class="right_line t_center"><fmt:formatDate value="${approval.endDate}" pattern="yyyy-MM-dd HH:mm" /></td> --%>
						<td class="right_line t_center"><fmt:formatDate value="${approval.crt_time}" pattern="yyyy-MM-dd HH:mm" /></td>
					</tr>
				</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td class="t_center" colspan="7"><div class="no_result"><spring:message code="global.script.search.no.result" /></div></td>
					</tr>
				</c:otherwise>
				</c:choose>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="7" class="td_last">
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
