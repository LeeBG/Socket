<%@page import="java.util.UUID"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="systemCode" value="${customfunc:cacheString('initMod')}" /><!-- T, S -->
<c:set var="getNetworkPosition" value="${customfunc:getNetworkPosition()}" /><!-- I, O -->
<c:set var="copyRight" value="${customfunc:getTypeData('copyright')}" />

<!-- 스트림 연계 보안영역 Server : INT_STM_Net-Protect_V2.0.0.345
스트림 연계 비-보안영역 Server : Ext_STM_Net-Protect_V2.0.0.345
자료전송 보안영역 Server : INT_TRS_Net-Protect_V2.0.0.345
자료전송 비-보안영역Server : Ext_TRS_Net-Protect_V2.0.0.345 -->
<!-- systemCode = ${systemCode }
getNetworkPosition = ${getNetworkPosition } -->
<%@include file="../common/encryptUtil.jsp" %>
<c:set var="inner_prgm_nm" value="" />
<c:set var="outer_prgm_nm" value="" />
<c:set var="inner_version" value="" />
<c:set var="outer_version" value="" />
<c:set var="browserTitle" value="${customfunc:getTypeData('admin')}" />
<c:choose>
	<c:when test="${systemCode eq 'T' }">
		<c:if test="${getNetworkPosition eq 'I' }">
			<c:set var="inner_prgm_nm" value="INT_TRS_Net-Protect_V" />
			<c:set var="outer_prgm_nm" value="EXT_TRS_Net-Protect_V" />
			<c:set var="inner_version" value="${customfunc:cacheString('programInfo_Int')}" />
			<c:set var="outer_version" value="${customfunc:cacheString('programInfo_Ext')}" />
		</c:if>
	</c:when>
	<c:when test="${systemCode eq 'S' }">
		<c:if test="${getNetworkPosition eq 'I' }">
			<c:set var="prgm_nm" value="INT_STM_Net-Protect_V" />
			<c:set var="version" value="${customfunc:cacheString('programInfo_Int')}" />
		</c:if>
		<c:if test="${getNetworkPosition eq 'O' }">
			<c:set var="prgm_nm" value="EXT_STM_Net-Protect_V" />
			<c:set var="version" value="${customfunc:cacheString('programInfo_Ext')}" />
		</c:if>
	</c:when>
	<c:otherwise><c:set var="prgm_nm" value="INT_STM_Net-Protect_V" /></c:otherwise>
</c:choose>
<c:set var="program_info" value="${prgm_nm }${version }" />

<c:choose>
	<c:when test="${customfunc:isInnerPosition()}">
		<c:set var="networkCss" value="workPC" />
	</c:when>
	<c:otherwise>
		<c:set var="networkCss" value="internetPC" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${fn:indexOf(requestUri, 'trans') > -1}">
		<c:set var="titleCss" value="transAdminPC" />
	</c:when>
	<c:otherwise>
		<c:set var="titleCss" value="streamAdminPC" />
	</c:otherwise>
</c:choose>
<c:set var="loginRequestUri" value="${fn:replace(requestUri, '.lin', 'Login.lin')}" />
<html>
<head>
<%@include file="../common/encryptUtil.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		document.title = '${browserTitle}';
		$("input[type='password']").attr("autocomplete","off");
	});

	function login() {
		var form = document.lform;
		var errmsg = cls_errmsg();

		if (empty(form.users_pw.value) || empty(form.users_id2.value)) errmsg.append(form.users_id2, "로그인 정보가 올바르지 않습니다.");
		/* if (empty(form.users_id.value)) errmsg.append(form.users_id, "<spring:message code ="sign.index.script.invalid.id" />");
		if (empty(form.users_pw.value)) errmsg.append(form.users_pw, "<spring:message code ="sign.index.script.invalid.password" />"); */
		//form.remember.value = (form.remember.checked ? "remember" : "");

		if (errmsg.haserror) {
			errmsg.show();
			return;
		} 

		aesUtil.encryptJQSelectorToSelectorValues( $('#users_id2'), $('#users_id') );
		$('#users_id2').val("");
		aesUtil.encryptJQSelectorValue( $('#users_pw') );

		var requestURL = "<c:url value="${loginRequestUri}" />";
		var successURL = "<c:url value="/index.lin" />";

		resultCheckFunc($("#lform"), requestURL, function(response) {
			$('#users_pw').val("");
			var code = response['code'];
			var message = response['message'];
			if (code == "${customfunc:codeString('LI_CD','SUCC')}") {
				if ("${sessionScope.loginUser.pw_change_day}" == '') {
					$(location).attr("href", successURL);
				} else {
					alert("비밀번호 변경 기간이 ${sessionScope.loginUser.pw_change_day}일 남았습니다.");					
					$(location).attr("href", successURL);
				}
			} else if (code == "${customfunc:codeString('LI_CD','ERROR_LOGIN_PWD_CHANGE')}") {
				alert("비밀번호 변경기간이 경과하였습니다.\n비밀번호를 변경 후 사용해 주세요.");
				location.href = "<c:url value="/hr/user/changePasswordForm.lin" />";
			} else {
				if (code == 202) {
					alert(message);
				} else {
					alert(message);
				}
				
			}
		});
	}

	function loginKeyCheck(event) {
		if (event.keyCode == 13) {
			s3i_networkInfo();
		}
	}

	onload = function() {
		var form = document.lform;
		if (form) {
			form.users_id.focus();
		}

		$('#users_id').on('keydown', function(e) {
			if (e.keyCode == 9) {
				$("#users_pw").removeAttr("readonly");
			}
		});
	}
</script>

<%-- 중부발전코드 --%>
<style type="text/css">
@media (min-width: 1360px){
	#footer {
	    padding: 17px 0 !important;
	}
}
@media (max-width: 1360px){
	#footer {
	    padding: 7px 0 !important;
	} 
}
</style>

</head>
<body>
<div id="login_wrap" class="${networkCss}">
	<div class="login_area">
		<div class="loginBox">
			<div class="login_type ${titleCss}"></div>
			<div class="dis_table form_outer_div">
				<div class="dis_inner_cell">
					<h1 class="logo_h">
						LOGO
					</h1>
					<form name="lform" id="lform" method="post" action="<c:url value="/sign/login.lin" />" onSubmit="return false;">
						<input type="hidden" name="csrf" value="<%=UUID.randomUUID()%>"/>
						<input type="hidden" name="jsonNetworkInfo" id="jsonNetworkInfo" value = ""/>
						<fieldset>
						<legend>id, password insert form</legend>
							<div class="login_form_area">
								<div class="input_area">
									<input  type="text" value="" name="users_id2" id="users_id2" class="input_login" placeholder="<spring:message code="common.id.adminid"/>"/><br/>
									<input  type="text" value="" name="users_id" id="users_id" style="display: none;" class="input_login" placeholder="<spring:message code="common.id.adminid"/>"/>
									<input type="password" name="user_pwd_fake" id="user_pwd_fake" autocomplete="off" style="display: none;">
									<input onfocus="this.removeAttribute('readonly');" type="password" value="" name="users_pw" id="users_pw" autocomplete="off" class="input_login" placeholder="패스워드"/>
									<!-- <p class="optionBox">
										<input type="checkbox" name="remember" id="remember" />
										<label for="check_saveid">아이디저장</label>
									</p> -->
								</div>
								<button type="submit" class="btn_login workPC" onClick="login();">
									<span class="ir_desc">로그인</span>
								</button>
							</div>
							<span class="alertArea" id="alertArea"></span>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div id="footer">
	<p class="copyright"></p>
		<p class="copyright"><span style="padding-right: 40px;">${copyRight}</span><span style="padding-right: 40px;">Net-Protect_V3.0</span><span style="padding-right: 40px;">${inner_prgm_nm}${inner_version}</span><span>${outer_prgm_nm}${outer_version}</span></p>
	</div>
</div>
</body>
</html>
