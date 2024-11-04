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

<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<script type="text/javascript">
$(document).ready(function() {
	var searchFieldValue = $("#searchField").val();
	$("#searchCondition").val(searchFieldValue).attr("selected", "selected");
});

function init() {
	$("#searchField").val("");
	$("#searchValue").val("");

	$("#lform").get(0).submit();
}
function search() {
	var searchConditionValue = $("#searchCondition option:selected").val();
	$("#searchField").val(searchConditionValue);
	if ($("#searchValue").val().empty()) {
		alert('검색어를 입력해 주세요.');
		return;
	}
	$("#lform").get(0).submit();
}

function insert(exts_seq, cud_cd) {
	$("#exts_seq").val(exts_seq);
	$("#cud_cd").val(cud_cd);
	var form = document.lform;
	form.action = "<c:url value="/policy/extPolicy/extPolicyInfo.lin" />";
	form.submit();
}

function checkDelete() {
	if (!$(":checkbox[name=chk]").is(":checked")) {
		alert("삭제 할 항목을 선택하세요.");
		return;
	}

	if (confirm("선택 목록을 삭제하겠습니까?")) {
		var requestURL = "<c:url value="/policy/extPolicy/deleteExtPolicyMgt.lin" />";
		var successURL = "<c:url value="/policy/extPolicy/extPolicyMgt.lin" />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}
}

$(document).ready(function() {
	checkFocusMessage($("#searchValue"),"최대 100자까지 가능합니다.");
});
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/policy/extPolicy/extPolicyMgt.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="page" name="page" />
<input type="hidden"id="isde_yn" name="isdel_yn" value= "" />
<input type="hidden"id="exts_seq" name="exts_seq" value = ""/>
<input type="hidden" id="cud_cd" name="cud_cd" value = ""/>
<input id="searchField" name="searchField" type="hidden" value="${fExtsMgtForm.searchField}"/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">확장자정책 관리</h2>
				<p class="breadCrumbs">정책관리 > 확장자정책 관리</p>
			</div>
		</div>
		<div class="conWrap">
			<h3>검색조건</h3>
			<div class="conBox searchBox t_center">
				<div class="topCon nBorder pd_b10 pd_t10">
					<table summary="정책 검색조건" style="table-layout : fixed">
						<caption>검색조건, 버튼</caption>
						<tbody>
							<colgroup>
								<col style="width:100%;"/>
							</colgroup>
							<tr>
								<td class="t_center">
									<select id="searchCondition" title="확장자정책 검색조건">
										<option <c:if test="${fExtsMgtForm.searchField eq 'exts_seq'}">selected="selected"</c:if> value="exts_seq">정책ID</option>
										<option <c:if test="${fExtsMgtForm.searchField eq 'exts_nm'}">selected="selected"</c:if> value="exts_nm">확장자 정책명</option>
										<option <c:if test="${fExtsMgtForm.searchField eq 'note'}">selected="selected"</c:if> value="note">설명</option>
									</select>
									<input type="text" class="text_input" style="max-width:70%;" id="searchValue" name="searchValue" onkeypress="if(event.keyCode==13) {search(); return false;}" value="${fExtsMgtForm.searchValue}" onkeyup="onlySizeFillter(this,100)"/>
									<button class="btn_common theme" onClick="search()">조회</button>
								<c:if test="${auth_cd != 4}">
									<button class="btn_common theme" onClick="init()">초기화</button>
									<button class="btn_common theme" onclick="insert('', '${CUD_CD_C}')">추가</button>
								</c:if>
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
					<div class="top_con mg_l5 mg_t10">
					<c:if test="${auth_cd != 4}">
						<button class="btn_common"  onclick="checkDelete();">삭제</button>
					</c:if>
					</div>
					<table summary="확장자전송정책" style="table-layout : fixed" class="mg_t5">
					<caption>정책ID, 확장자 정책명, 설명</caption>
						<colgroup>
							<col style="width:3%;"/>
							<col style="width:17%;" />
							<col style="width:35%;" />
							<col style="width:45%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
								<th class="Rborder">정책ID</th>
								<th class="Rborder">확장자 정책명</th>
								<th>설명</th>
							</tr>
						</thead>
						<tbody>
						<c:choose>
						<c:when test="${not empty fExtsMgtListFormList}">
							<c:forEach items="${fExtsMgtListFormList}" var="fExtsMgtListForm">
								<tr>
									<c:choose>
										<c:when test="${fExtsMgtListForm.isdel_yn eq 'N'}">
											<td class="td_chekbox Rborder t_center"></td>
										</c:when>
										<c:otherwise>
											<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${fExtsMgtListForm.exts_seq}" value="${fExtsMgtListForm.exts_seq}" /></td>
										</c:otherwise>
									</c:choose>
									<td class="t_center Rborder" onclick="insert('${fExtsMgtListForm.exts_seq}', '${CUD_CD_U}')">
									<c:out value="${fExtsMgtListForm.exts_seq}" /></td>
									<td class="t_center Rborder" onclick="insert('${fExtsMgtListForm.exts_seq}', '${CUD_CD_U}')">
									<c:out value="${fExtsMgtListForm.exts_nm}" /></td>
									<td class="t_center" onclick="insert('${fExtsMgtListForm.exts_seq}', '${CUD_CD_U}')"> 
									<c:out value="${fExtsMgtListForm.note}" /></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="21">
									<div class="no_result" >
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
