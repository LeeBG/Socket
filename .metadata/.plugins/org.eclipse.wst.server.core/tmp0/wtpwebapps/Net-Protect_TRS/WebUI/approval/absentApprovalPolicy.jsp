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

<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />
<c:set var="use_type_check" value="${privateApprovalForm.use_type}" />

<script type="text/javascript">

$(document).ready(function() {
	if('${use_type_check}'== '') {
		$("#use_type_N").attr("checked", true);
	}
});


function save() {
	var requestURL = "<c:url value="/approval/updateAbsentApprovalPolicy.lin" />";
	var successURL = "<c:url value="/approval/absentApprovalPolicy.lin" />";
	resultCheck($("#lform"), requestURL, successURL, true);
}

</script>

</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/approval/absentApprovalPolicy.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">부재중결재자 설정</h2>
				<p class="breadCrumbs">결재관리 > 부재중결재자 설정</p>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>부재중결재자 설정</h3>
			<div class="conBox">
				<div class="table_area_style02 Tborder">
					<table summary="로그인정책 설정" style="table-layout : fixed">
					<caption>부재중결재자 설정</caption>
						<colgroup>
							<col style="width:15%;"/>
							<col style="width:85%;" />
						</colgroup>
						<tbody>
							<tr>
								<th class="t_left">부재중결재</th>
								<td>
									<input type="radio" id="use_type_A" name="use_type" value="A" ${privateApprovalForm.use_type == "A" ? ' checked' : ''} /><label for="use_type_A">활성</label>&nbsp;
									<input type="radio" id="use_type_N" name="use_type" value="N" ${privateApprovalForm.use_type == "N" ? ' checked' : ''} /><label for="use_type_N">비활성</label>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="t_center mg_t30 mg_b30">
				<c:if test="${auth_cd != 4}">
					<button class="btn_common theme" onclick="save()">변경</button>
				</c:if>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>