<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<script type="text/javascript" src="<c:url value="/JavaScript/webtoolkit.base64.js" />"></script>
<script type="text/javascript">
	$(document).ready(function() {
		showTable();
		$('#searchValue').keypress(function(e) {
		if (e.which == 13) {
			return false;
		}
		});
	});

	function showTable() {
		var requestURL = "<c:url value="/fm/lg/changeApprovalList.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
		var fUserList = response['fUserList'];
		var paging = response['paging'];
		var pageList =  response['pageList'];

		var extensionTbody = $("#extensionTable tbody");
		$("#extensionTable tbody tr").remove();
		var extension = "";
		if (fUserList.length >  0) {
			for (var i=0; i < fUserList.length; i++) {
				var position = (fUserList[i].position_nm != '') ? fUserList[i].position_nm : '-';
				extension = '<tr> \n';
				extension += '   <td class="td_chekbox Rborder t_center"><input type="radio" id="use" name="use_yn" value="' + fUserList[i].users_id + '"/></td> \n';
				extension += '   <td class="t_center Rborder">' + fUserList[i].dept_nm + '</td> \n';
				extension += '   <td class="t_center Rborder">' + position + '</td> \n';
				extension += '   <td class="t_center Rborder">' + fUserList[i].users_id + '</td> \n';
				extension += '   <td class="t_center Rborder">' + fUserList[i].users_nm + '</td> \n';
				extension += '</tr> \n';
				extensionTbody.append(extension);
			}
		} else {
			extension = '<tr> \n';
			extension += '<td class="t_center right_line" colspan="5"><spring:message code="global.script.search.no.result" /></td> \n';
			extension += '</tr> \n';
			extensionTbody.append(extension);
		}
		var page = Base64.decode(pageList);
		$("#pageDiv").html(page);
		$("#total").html("총 " + paging.totalCount + "건");
		});
	}

	function goPage(page) {
		$("#page").val(page);
		showTable();
	}

	function search() {
		var searchConditionValue = $("#searchCondition option:selected").val();
		$("#searchValue").val($('#searchValueInput').val());
		$("#searchField").val(searchConditionValue);
		$("#page").val(1);
		showTable();
	}

	function save() {
		var form = document.lform;
		var app_id = $('input[name="use_yn"]:checked').val();
		$("#app_id").val(app_id);
		var appseqList = ${app_seq};
		$("#appSeqList").val(JSON.stringify(appseqList));

		if (!$('input:radio[name=use_yn]').is(':checked')) {
			alert("변경할 결재자를 선택하세요.");
			return;
		}

		if (confirm("결재자를 변경하시겠습니까?")) {
		var requestURL = "<c:url value="/fm/lg/changeApproval.lin" />";
		var successURL = "<c:url value="/fm/lg/FMLG0700.lin" />";

		resultCheck($("#lform"), requestURL, successURL, true);
		}
	}
	

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/fm/lg/changeApprovalFMLG0700.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden" />
<input type="hidden"id="app_id" name="app_id" />
<input type="hidden"id="app_seq" name="app_seq" />
<input type="hidden"id="appSeqList" name="appSeqList" />
<input id="searchPosition" name="searchPosition" type="hidden" value="${approvalForm.searchPosition}" />
<input id="np_cd" name="np_cd" type="hidden" value="${approvalForm.np_cd}" />
<input id="searchField" name="searchField" type="hidden" value="${approvalForm.searchField}" />
<input id="searchValue" name="searchValue" type="hidden" value="${approvalForm.searchField}" />
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">결재미처리 이력</h2>
				<p class="breadCrumbs">로그관리 > 결재미처리 이력</p>
			</div>
		</div>
		<div class="conWrap">
			<h3>검색조건</h3>
			<div class="conBox searchBox t_center">
				<div class="topCon nBorder pd_b10 pd_t10">
					<table summary="결재자 검색조건" style="table-layout : fixed">
					<caption>검색조건, 버튼</caption>
						<tbody>
							<colgroup>
								<col style="width:100%;"/>
							</colgroup>
							<tr>
								<td class="t_center">
								<select id="searchCondition" title="결재자 변경 검색조건" class="selected_extension_approval_list">
									<option <c:if test="${approvalForm.searchField eq 'dept_nm'}">selected="selected"</c:if> value="dept_nm">부서</option>
									<option <c:if test="${approvalForm.searchField eq 'users'}">selected="selected"</c:if> value="users">결재자</option>
								</select>
								<input type="text" class="text_input" style="max-width:70%;" id="searchValueInput" name="searchValueInput" value="${approvalForm.searchValue}"/>
								<button class="btn_common theme" onClick="search()">조회</button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="conWrap">
			<div class="conBox">
				<div class="table_area_style01 hoverTable">
					<table id="extensionTable" summary="결재 미처리 결재자 변경" style="table-layout : fixed" class="mg_t5">
					<caption>결재자선택, 부서, 직급, 결재자ID, 결재자명</caption>
						<colgroup>
							<col style="width:8%;"/>
							<col style="width:25%;" />
							<col style="width:20%;" />
							<col style="width:30%;" />
							<col style="width:30%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder">결재자선택</th>
								<th class="Rborder">부서</th>
								<th class="Rborder">직급</th>
								<th class="Rborder">결재자ID</th>
								<th class="Rborder">결재자명</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="5" class="td_last">
									<span id ="total" class="text_list_number"></span>
										<div id="pageDiv" class="pagenate t_center">
									</div>
								</td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
		</div>
		<div class="pagenate t_center">
			<button class="btn_common theme" onclick="save()">저장</button>
		</div>
	</div>
</form>
</body>
</html>