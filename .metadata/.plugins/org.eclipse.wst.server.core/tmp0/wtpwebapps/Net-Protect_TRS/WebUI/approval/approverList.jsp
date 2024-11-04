<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<html>
<head>
<script type="text/javascript">
	$(document).ready(function() {
		$("#select_first").text('이름');

		$("#query").click(function(){
			$("#queryList").toggle();
		});

		$("#queryList > li > a").click(function(){
			$("#select_first").text($(this).text());
			$("#searchField").val($(this).attr('id'));
		});

		$("#pageLine").click(function(){
			$("#pageLineList").toggle();
		});

		$("#pageLineList > li > a").click(function(){
			$("#select_pageLine_first").text($(this).text());
		});
	});

	function del() {
		if (!$(":checkbox[name=chk]").is(":checked")) {
			alert("삭제할 결재자를 선택하세요");
			return;
		}

		if (confirm("선택한 결재자를 삭제 하겠습니까?")) {
			var requestURL = "<c:url value="/approval/deleteApprover.lin" />";
			var successURL = "<c:url value="/approval/approverList.lin" />";
			resultCheck($("#lform"), requestURL, successURL, true);
		}
	}

	function search() {
		$("#lform").get(0).submit();
	}

	function ins() {
		var url = "<c:url value="/approval/approverPopup.lin" />";
		var attibute = "resizable=no,scrollbars=yes,width=475,height=690,top=5,left=5,toolbar=no,resizable=no";
		var popupWindow = window.open(url, "addressBookPopup", attibute);
		popupWindow.focus();
	}

	function approvalListRefresh(){
		$("#lform").get(0).submit();
	}
</script>
</head>

<body>
<form id="lform" onsubmit="return false;" method="post" action="<c:url value="/approval/approverList.lin" />">
<input id="page" name="page" type="hidden"/>
<input id="searchField" name="searchField" type="hidden" value="${searchField}"/>

<!-- contents -->
<div id="contentPageHeader">
	<div id="contentPageTitle">
		<h3>결재자 관리</h3>
	</div>
	<div id="contentPageLocation">
		<ul>
			<li class="Lfirst">자료전송 결재 관리</span></li>
			<li class="Llast"><span>결재자 관리</span></li>
		</ul>
	</div>
</div>
<fieldset id="contentBody">
<legend>search</legend>
<!-- search -->
<%-- <div class="search_area_type01 mg_t30 mg_b20">
	<h4>search</h4>
	<div class="right_area">
		<div class="search_box clear_f">
			<div class="select_layer select01" id="query">
				<a class="select_first" id="select_first"><spring:message code="email.addressBookList.searchList.all" /></a>
				<ul class="select_layer_list" id="queryList" style="display: none;">
					<li>
						<a id="sch_name">이름</a>
					</li>
				</ul>
			</div>
			<div class="f_left">
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="search_query2"/>
			</div>
			<div class="f_right" style="width:100px">
				<button type="submit" class="btn_search_st01" onClick="search()">
					<span class="ir_desc">검색</span>
				</button>
			</div>
		</div>
	</div>
</div> --%>
<!-- //search -->	
<div class="table_area_style01 pd_t20">
	<div class="top_con">
		<button type="submit" class="btn_add_st02 f_left va_left" onclick="ins();">
			<span class="ir_desc">추가</span>
		</button>
		<button type="submit" class="btn_i_del_st02 va_middle mg_l10" onclick="del();">
			<span class="ir_desc">삭제</span>
		</button>
	</div>
	<table summary="결재자 관리 테이블입니다.">
	<caption>이름, 부서, 직급</caption>
		<colgroup>
			<col style="width:10%;" />
			<col style="width:30%;" />
			<col style="width:30%;" />
			<col style="width:30%;" />
		</colgroup>
		<thead>
			<tr>
				<th class="right_line"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
				<th class="right_line">이름</th>
				<th class="right_line">부서</th>
				<th class="right_line">직급</th>
			</tr>
		</thead>
		<tbody>
		<c:choose>
		<c:when test="${not empty approverList}">
		<c:forEach items="${approverList}" var="approver">
			<tr id="tr_id_${approver.approver_id}">
				<td class="right_line t_center"><input type="checkbox" class="input_chk" name="chk" id="chk" value="${approver.approver_id }" /></td>
				<td class="right_line t_center">${approver.approver_nm }</td>
				<td class="right_line t_center">${approver.dept_nm }</td>
				<td class="right_line t_center">${approver.position_nm}</td>
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
</fieldset>
<!-- //contents -->
</form>
</body>
</html>
