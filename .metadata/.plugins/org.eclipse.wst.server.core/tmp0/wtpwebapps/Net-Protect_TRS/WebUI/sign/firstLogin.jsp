<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:set var="complexity" value="${complexity}" />
<html>
<head>

<spring:message code="sign.firstLogin.script.passwordRule1" />
<script type="text/javascript">
	function change() {
		var complexity = '${complexity}';

		var errmsg = new cls_errmsg();
		if ($("#users_pwd").val().empty() || !isValidPassword($("#users_pwd").val(), complexity)) {
			if(complexity == 1 ) {
				errmsg.append($("#users_pwd"), "<spring:message code="sign.firstLogin.script.passwordRule1" />");
			}else if(complexity == 2 ) {
				errmsg.append($("#users_pwd"), "<spring:message code="sign.firstLogin.script.passwordRule2" />");
			}else if(complexity == 3 ) {
				errmsg.append($("#users_pwd"), "<spring:message code="sign.firstLogin.script.passwordRule3" />");
			}
		} else if ($("#users_pwd").val() != $("#rePwd").val()) {
			errmsg.append($("#rePwd"), "<spring:message code="users.user.list.script.invalid.pwd.different" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		if (confirm("<spring:message code="sign.firstLogin.script.checkIp" />")) {
			var requestURL = "<c:url value="/sign/changePassword.lin"/>";
			var successURL = "<c:url value="/sign/index.lin" />";
			resultCheck($("#lform"), requestURL, successURL, true);
		}
		return false;
	}
</script>
</head>
<body>
<form name="lform" id="lform" method="post" action="" onSubmit="return false;">
<div id="content">
	<div class="table_area_style03 msg_area box_type03">
		<div class="tpadding15 text_bold text_green01">
			<spring:message code="sign.firstLogin.script.firstLogin" /><br/>
			<spring:message code="sign.firstLogin.script.changePassword" /><br/>
			<c:choose>
			<c:when test="${'1' eq complexity}">
				<spring:message code="sign.firstLogin.script.passwordRule1" />
			</c:when>
			<c:when test="${'2' eq complexity}">
				<spring:message code="sign.firstLogin.script.passwordRule2" />
			</c:when>
			<c:when test="${'3' eq complexity}">
				<spring:message code="sign.firstLogin.script.passwordRule3" />
			</c:when>
			</c:choose>
		</div>
		<br/><br/>
		<div class="box_type04 table_area_style04">
			<table cellspacing="0" cellpadding="0" summary="사용자 추가 테이블입니다.">
				<caption>상위부서, 이름, 아이디, 패스워드, 패스워드 재입력, 권한</caption>
				<colgroup>
					<col style="width:30%;" />
					<col style="width:70%;" />
				</colgroup>
				<tbody>
					<tr>
						<th><span class="left_chk_list"><spring:message code="users.user.list.insert.password" /></span></th>
						<td>
							<input type="password" class="text_input" id="users_pwd" name="users_pwd"/>
						</td>
					</tr>
					<tr>
						<th><span class="left_chk_list"><spring:message code="users.user.list.insert.rePassword" /></span></th>
						<td>
							<input type="password" class="text_input" id="rePwd" name="rePwd"/>
						</td>
					</tr>
					<tr>
						<th>ip</th>
						<td>
							<input type="text" value="${allow_ip}" name="allow_ip" id="allow_ip" readonly="readonly" class="text_input_id" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="tpadding15">
			<button type="submit" class="btn_okfile_st03 btn_msg_ok" onClick="change();">
				<span class="ir_desc">확인</span>
			</button>
		</div> 
	</div>
</div>
</form>
</body>
</html>