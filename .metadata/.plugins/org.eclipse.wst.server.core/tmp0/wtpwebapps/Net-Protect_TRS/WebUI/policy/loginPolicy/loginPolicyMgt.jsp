<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>

<c:set var="systemCode" value="${sessionScope.loginUser.system_cd}" /><!-- T, S -->
<c:set var="getNetworkPosition" value="${customfunc:getNetworkPosition()}" /><!-- I, O -->
<c:set var="otpOption" value="${customfunc:cacheString('otpOption')}" /><!--Y, I, O -->

<c:set var="hide_button" value="" />
<c:choose>
	<c:when test="${systemCode eq 'S' && getNetworkPosition eq 'I' }">
		<c:set var="hide_button" value="none" />
	</c:when>
	<c:otherwise>
		<c:set var="hide_button" value="" />
	</c:otherwise>
</c:choose>

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

function insert(login_seq, cud_cd, del_yn) {
	$("#login_seq").val(login_seq);
	$("#isdel_yn").val(del_yn);
	$("#cud_cd").val(cud_cd);

	var form = document.lform;
	form.action = "<c:url value="/policy/loginPolicy/loginPolicyInfo.lin" />";
	form.submit();
}

function checkDelete() {
	if (!$(":checkbox[name=chk]").is(":checked")) {
		alert("삭제 할 항목을 선택하세요.");
		return;
	}

	if (confirm("선택 목록을 삭제하겠습니까?")) {
		var requestURL = "<c:url value="/policy/loginPolicy/deleteCPolLoginMgt.lin" />";
		var successURL = "<c:url value="/policy/loginPolicy/loginPolicyMgt.lin" />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}
}

function optSetting() {
	var url = "/policy/loginPolicy/loginOptSettingPopup.lin";
	var attr = "resizable=no,scrollbars=no,toolbar=no,url=no,width=625,height=690,top=5,left=5,url=no";
	var popupWindow = window.open(url, "loginOptSettingPopup", attr);
	popupWindow.focus();
}

$(document).ready(function() {
	checkFocusMessage($("#searchValue"),"최대 100자까지 가능합니다.");
});
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/policy/loginPolicy/loginPolicyMgt.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="page" name="page" />
<input type="hidden" id="cud_cd" name="cud_cd" />
<input type="hidden"id="isde_yn" name="isdel_yn" />
<input type="hidden" id="login_seq" name="login_seq" />
<input id="searchField" name="searchField" type="hidden" value="${cPolLoginMgtForm.searchField}"/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">로그인정책 관리</h2>
				<p class="breadCrumbs">정책관리 > 로그인정책 관리</p>
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
									<select id="searchCondition" title="로그인정책 검색조건">
										<option <c:if test="${cPolLoginMgtForm.searchField eq 'login_seq'}">selected="selected"</c:if> value="login_seq">정책ID</option>
										<option <c:if test="${cPolLoginMgtForm.searchField eq 'login_nm'}">selected="selected"</c:if> value="login_nm">로그인 정책명</option>
										<option <c:if test="${cPolLoginMgtForm.searchField eq 'note'}">selected="selected"</c:if> value="note">설명</option>
									</select>
									<input type="text" class="text_input" style="max-width:70%;" id="searchValue" name="searchValue" onkeypress="if(event.keyCode==13) {search(); return false;}" value="${cPolLoginMgtForm.searchValue}" onkeyup="onlySizeFillter(this,100)"/>
									<button class="btn_common theme" onClick="search()">조회</button>
									<button class="btn_common theme" onClick="init()">초기화</button>
								<c:if test="${auth_cd == 1}">
									<button class="btn_common theme${hide_button }" onclick="insert('', '${CUD_CD_C}')">추가</button>
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
					<c:if test="${auth_cd == 1}">
						<button class="btn_common"  onclick="checkDelete();">삭제</button>
					</c:if>
					<c:if test="${otpOption eq 'Y' }">
						<button class="btn_common theme${hide_button } login_otp_btn" onclick="optSetting()">로그인OTP인증설정</button>
					</c:if>
					</div>
					<table summary="로그인정책" style="table-layout : fixed" class="mg_t5">
					<caption>정책ID, 정책명, 설명</caption>
						<colgroup>
						<c:if test="${auth_cd == 1}">
							<col style="width:3%;"/>
						</c:if>
							<col style="width:17%;" />
							<col style="width:35%;" />
							<col style="width:45%;" />
						</colgroup>
						<thead>
							<tr>
							<c:if test="${auth_cd == 1}">
								<th class="Rborder">
									<input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/>
								</th>
							</c:if>
								<th class="Rborder">정책ID</th>
								<th class="Rborder">정책명</th>
								<th>설명</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
							<c:when test="${not empty loginPolicyList}">
								<c:forEach items="${loginPolicyList}" var="loginPolicy">
									<tr>
									<c:if test="${auth_cd == 1}">
										<c:choose>
											<c:when test="${loginPolicy.isdel_yn eq 'N'}">
												<td class="td_chekbox Rborder t_center"></td>
											</c:when>
											<c:otherwise>
												<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" id="chk_${loginPolicy.login_seq}" name="chk" value="${loginPolicy.login_seq}" /></td>
											</c:otherwise>
										</c:choose>
									</c:if>
										<td class="t_center Rborder" onclick="insert('${loginPolicy.login_seq}', '${CUD_CD_U}', '${loginPolicy.isdel_yn}')" title="<c:out value="${loginPolicy.login_seq}" />">
											<c:out value="${loginPolicy.login_seq}" />
										</td>
										<td class="t_center Rborder" onclick="insert('${loginPolicy.login_seq}', '${CUD_CD_U}', '${loginPolicy.isdel_yn}')" title="<c:out value="${loginPolicy.login_nm}" />">
											<c:out value="${loginPolicy.login_nm}" />
										</td>
										<td class="t_center" onclick="insert('${loginPolicy.login_seq}', '${CUD_CD_U}')" title="<c:out value="${loginPolicy.note}" />">
											<c:out value="${loginPolicy.note}" />
										</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td class="t_center" colspan="21">
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
								<td colspan="${auth_cd eq '1' ? '4' : '3'}" class="td_last">
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
