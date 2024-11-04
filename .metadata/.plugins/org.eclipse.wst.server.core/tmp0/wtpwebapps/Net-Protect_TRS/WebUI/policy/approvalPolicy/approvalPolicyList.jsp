<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="CUD_CD_D" value="${customfunc:codeString('CUD_CD', 'DELETE')}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />
<script type="text/javascript">
$(document).ready(function() {
	/* var searchFieldValue = $("#searchField").val();
	$("#searchCondition").val(searchFieldValue).attr("selected", "selected"); */
});

function init() {
	$("#searchField").val("");
	$("#searchValue").val("");
	$("#lform").get(0).submit();
}
function search() {
	var searchConditionValue = $("#searchCondition option:selected").val();
	$("#searchField").val(searchConditionValue);
	$("#lform").get(0).submit();
}

function insert(app_seq, cud_cd, modify_auth) {
	$("#app_seq").val(app_seq);
	$("#cud_cd").val(cud_cd);
	$("#modify_auth").val(modify_auth);
	
	var form = document.lform;
	form.action = "<c:url value="/policy/approvalPolicy/approvalPolicyView.lin" />";
	form.submit();
}

function popupView(app_seq, type){
	var url = "<c:url value="/policy/approvalPolicy/approvalPolicyPopup.lin" />?app_seq=" + app_seq + "&type=" + type;
	var attibute = "width=1000, height=800, directories=no, resizable=yes, scrollbars=yes, top=5, left=5, toolbar=no";
	var popupWindow = window.open(url, "popup", attibute);
	popupWindow.focus();
}

function checkDelete(cud_cd) {
	if (!$(":checkbox[name=chk]").is(":checked")) {
		alert("삭제 할 항목을 선택하세요.");
		return;
	}
	$("#cud_cd").val(cud_cd);
	if (confirm("선택 목록을 삭제하겠습니까?")) {
		var requestURL = "<c:url value="/policy/approvalPolicy/deleteApprovalPolicy.lin" />";
		var successURL = "<c:url value="/policy/approvalPolicy/approvalPolicyList.lin" />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}
}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" >
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden"id="page" name="page"/>
<input type="hidden"id="app_seq" name="app_seq" />
<input type="hidden"id=modify_auth name="modify_auth" />
<input type="hidden" id="cud_cd" name="cud_cd" />
<input type="hidden"id="isde_yn" name="isdel_yn" />
<input id="searchField" name="searchField" type="hidden" value="${approvalPolicyForm.searchField}"/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">결재정책 관리</h2>
				<p class="breadCrumbs">정책관리 > 결재정책 관리</p>
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
									<select id="searchCondition" title="결재정책 검색조건">
										<option <c:if test="${approvalPolicyForm.searchField eq 'app_seq'}">selected="selected"</c:if> value="app_seq">정책ID</option>
										<option <c:if test="${approvalPolicyForm.searchField eq 'app_nm'}">selected="selected"</c:if> value="app_nm">결재 정책명</option>
										<option <c:if test="${approvalPolicyForm.searchField eq 'note'}">selected="selected"</c:if> value="note">설명</option>
									</select>
									
									<input type="text" class="text_input" style="max-width:70%;" id="searchValue" name="searchValue" value="${approvalPolicyForm.searchValue}"/>
									<button class="btn_common theme" onClick="search()">조회</button>
									<button class="btn_common theme" onClick="init()">초기화</button>
								<c:if test="${auth_cd == 1 || auth_cd == 3}">
									<button class="btn_common theme" onclick="insert('', '${CUD_CD_C}', 'Y')">추가</button>
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
					<c:if test="${auth_cd == 1 || auth_cd == 3}">
						<button class="btn_common"  onclick="checkDelete('${CUD_CD_D}');">삭제</button>
					</c:if>
					</div>
					<table summary="결재정책" style="table-layout : fixed" class="mg_t5">
					<caption>정책ID, 정책명, 설명, 설정된 사용자</caption>
						<colgroup>
						<c:if test="${auth_cd == 1 || auth_cd == 3}">
							<col style="width:3%;"/>
						</c:if>
							<col style="width:15%;" />
							<col style="width:15%;" />
							<col style="width:25%;" />
							<col style="width:25%;" />
							<col style="width:25%;" />
						</colgroup>
						<thead>
							<tr>
							<c:if test="${auth_cd == 1 || auth_cd == 3}">
								<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
							</c:if>
								<th class="Rborder">정책ID</th>
								<th class="Rborder">정책명</th>
								<th class="Rborder">설명</th>
								<th>설정된 사용자</th>
								<th>설정된 부서</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
							<c:when test="${not empty approvalPolicyFormList}">
								<c:forEach items="${approvalPolicyFormList}" var="approvalPolicy">
									<c:set var="modify_auth" value="" />
									<c:if test="${approvalPolicy.modify_auth eq 'N'}">
										<c:set var="modify_auth" value="disabled" />
									</c:if>
									<tr>
									<c:if test="${auth_cd == 1 || auth_cd == 3}">
									<c:choose>
										<c:when test="${approvalPolicy.isdel_yn eq 'N'}">
											<td class="td_chekbox Rborder t_center"></td>
										</c:when>
										<c:otherwise>
											<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" id="chk_${approvalPolicy.app_seq}" name="chk" value="${approvalPolicy.app_seq}" ${modify_auth} /></td>
										</c:otherwise>
									</c:choose>
									</c:if>
										<td class="t_center Rborder" onclick="insert('${approvalPolicy.app_seq}', '${CUD_CD_U}', '${approvalPolicy.modify_auth}')">
										<c:out value="${approvalPolicy.app_seq}" /></td>
										<td class="t_center Rborder" onclick="insert('${approvalPolicy.app_seq}', '${CUD_CD_U}', '${approvalPolicy.modify_auth}')">
										<c:out value="${approvalPolicy.app_nm}" /></td>
										<td class="t_center Rborder" onclick="insert('${approvalPolicy.app_seq}', '${CUD_CD_U}', '${approvalPolicy.modify_auth}')">
										<c:out value="${approvalPolicy.note}" /></td>
										<td class="t_center Rborder" id="setAppUser" onclick="popupView('${approvalPolicy.app_seq}', this.id)">
										<c:out value="${approvalPolicy.usrCnt} 명" /></td>
										<td class="t_center" id="setAppDept" onclick="popupView('${approvalPolicy.app_seq}', this.id)">
										<c:out value="${approvalPolicy.deptCnt} 개" /></td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td class="t_center" colspan="6">
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
								<td colspan="${auth_cd eq '1' || auth_cd eq '3' ? '6' : '4'}" class="td_last">
								<span class="text_list_number"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></span>
								<div class="pagenate t_center">
									${pageList}
									${pageIndex}
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