<%@page import="java.util.UUID"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="systemCode" value="${customfunc:cacheString('initMod')}" /><!-- T, S -->
<c:set var="getNetworkPosition" value="${customfunc:getNetworkPosition()}" /><!-- I, O -->
<c:set var="copyRight" value="${sessionScope.cssCopyright}" />
<c:set var="siteCode" value="${customfunc:cacheString('siteCode')}" />
<c:set var="prgm_nm" value="" />
<c:set var="version" value="" />
<c:set var="otpOption" value="${customfunc:cacheString('otpOption')}" /><!--Y, I, O -->
<c:choose>
	<c:when test="${systemCode eq 'T' }">
		<c:if test="${getNetworkPosition eq 'I' }">
			<c:set var="prgm_nm" value="INT_TRS_Net-Protect_V" />
			<c:set var="version" value="${customfunc:cacheString('programInfo_Int')}" />
			<c:set var="browserTitle" value="${customfunc:getTypeData('in_user')}" />
		</c:if>
		<c:if test="${getNetworkPosition eq 'O' }">
			<c:set var="prgm_nm" value="Ext_TRS_Net-Protect_V" />
			<c:set var="version" value="${customfunc:cacheString('programInfo_Ext')}" />
			<c:set var="browserTitle" value="${customfunc:getTypeData('out_user')}" />
		</c:if>
	</c:when>
	<c:when test="${systemCode eq 'S' }">
		<c:if test="${getNetworkPosition eq 'I' }">
			<c:set var="prgm_nm" value="INT_STM_Net-Protect_V" />
			<c:set var="version" value="${customfunc:cacheString('programInfo_Int')}" />
		</c:if>
		<c:if test="${getNetworkPosition eq 'O' }">
			<c:set var="prgm_nm" value="Ext_STM_Net-Protect_V" />
			<c:set var="version" value="${customfunc:cacheString('programInfo_Ext')}" />
		</c:if>
	</c:when>
	<c:otherwise><c:set var="prgm_nm" value="INT_STM_Net-Protect_V" /></c:otherwise>
</c:choose>
<c:set var="program_info" value="${prgm_nm }${version }" />
<%-- program_info = ${program_info } --%>
<c:choose>
	<c:when test="${customfunc:isInnerPosition()}">
		<c:set var="networkCss" value="workPC" />
		<c:set var="networkPosition" value="I" />
	</c:when>
	<c:otherwise>
		<c:set var="networkCss" value="internetPC" />
		<c:set var="networkPosition" value="O" />
	</c:otherwise>
</c:choose>
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />

<html>
<head>
<!-- s3iwebSocket.js 통신 js 파일입니다. -->
<script type="text/javascript" src="/JavaScript/webtoolkit.base64.js"></script>
<script type="text/javascript" src="/JavaScript/jquery-ui.js"></script>
<script type="text/javascript" src="/JavaScript/module/common.js?ver=2"></script>
<!-- 결재 제한 관련 js파일 -->
<script type="text/javascript" src="/JavaScript/module/trs.approval.lock.js"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.popup.js" />?v=20181119"></script>
<%@include file="../common/encryptUtil.jsp" %>
<script type="text/javascript">
	var networkPosition = '${networkPosition}';
	$(document).ready(function() {
		document.title = '${browserTitle}';
		$("input[type='password']").attr("autocomplete","off");
		rememberHide();
		initApprovalLockNotice();
		autoCompleteId(lform, "${siteCode}");
	});

	function rememberHide() {
		if ("${siteCode}" != "gsbd") $(".optionBox").css("display","none");
	}

	function hideModalAndSendMessagesToAgent(evt) { //연결 시작 이벤트 함수
		//연결성공
		controlModal( 'hide' );
		AG_sendUrlInfoAndLoginCheckToAgent();
	}

	function login() {
		var form = document.lform;
		var errmsg = cls_errmsg();
		if (empty(form.users_pw.value) || empty(form.users_id2.value)) errmsg.append(form.users_id2, "로그인 정보가 올바르지 않습니다.");
		
		if (empty(form.users_id2.value)) errmsg.append(form.users_id2, "<spring:message code ="sign.index.script.invalid.id" />");
		if (empty(form.users_pw.value)) errmsg.append(form.users_pw, "<spring:message code ="sign.index.script.invalid.password" />");
		if ("${siteCode}" == "gsbd") form.remember.value = (form.remember.checked ? "remember" : "");
		

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}
		
		aesUtil.encryptJQSelectorToSelectorValues( $('#users_id2'), $('#users_id') );
		$('#users_id2').val("");
		aesUtil.encryptJQSelectorValue( $('#users_pw') );


		var requestURL = "<c:url value="/sign/login.lin" />";
		var successURL = "<c:url value="/sign/index.lin" />";
		var otpFlag = ('${otpOption}' == '${getNetworkPosition}' || '${otpOption}' == 'Y') && '${LoginOtpAuthYn}' == 'Y';

		resultCheckFunc($("#lform"), requestURL, function(response) {
			$('#users_pw').val("");
			var code = response['code'];
			var message = response['message'];
			if (code == "${customfunc:codeString('LI_CD','SUCC')}") {
				<%-- isLoginOtpAuth users_id 값이 파라미터로 담기면 로그인 OTP 인증, 없으면 비밀번호 재설정 OTP 인증 --%>
				if ("${sessionScope.loginUser.pw_change_day}" == '') {
					( otpFlag ) ? auth() : $(location).attr("href", successURL);
				} else {
					alert("비밀번호 변경 기간이 ${sessionScope.loginUser.pw_change_day}일 남았습니다.");
					( otpFlag ) ? auth() : $(location).attr("href", successURL);
				}
			} else if (code == "${customfunc:codeString('LI_CD','ERROR_LOGIN_PWD_CHANGE')}") {
				alert("비밀번호 변경기간이 경과하였습니다.\n비밀번호를 변경 후 사용해 주세요.");
				if ( otpFlag ) {
					auth();
				} else {
					location.href = '<c:url value="/hr/user/changePasswordForm.lin" />';
				}
			} else {
				if( message ){
					alert(message);
				}else{
					alert("로그인 정보가 올바르지 않습니다.");
				}
			}
		});
	}

	function auth() {
		location.href = '<c:url value="/hr/user/authOtpForm.lin"/>';
	}

	function loginKeyCheck(event) {
		if (event.keyCode == 13) {
			s3i_networkInfo();
		}
	}

	onload = function() {
		var form = document.lform;
		var remember = getCookie("SESSIONID");
		if (form) {
			if ("${siteCode}" == "gsbd") {
				if (remember != null && remember != "") {
					form.remember.checked = true;
					form.users_id.value = remember;
				}
				if (form.users_id.value != "") {
					form.users_pw.focus();
				} else {
					form.users_id.focus();
				}
			}
			form.users_id.focus();
		}

		$('#users_id').on('keydown', function(e) {
			if (e.keyCode == 9) {
				$("#users_pw").removeAttr("readonly");
			}
		});
	}

	function controlModal( show_hide_code , text ){
		var modal_alert_dom = document.getElementById("modal_alert");
		if( text ){
			changeInnerHtml( document.getElementById("modal_alert_text") , text );
		}
		if( show_hide_code == 'show' ){
			showUI( modal_alert_dom );
		}
		if( show_hide_code == 'hide' ){
			hideUI( modal_alert_dom );
		}
	}
</script>
</head>
<body>
<div id="login_wrap" class="${networkCss}">
	<div class="login_area">
		<div class="loginBox">
			<c:if test="${getNetworkPosition eq 'I'}"><div class="login_type ${networkCss} login_text"><span class="network_text">${INNER}</span> ${customfunc:getMessage('common.text.title')} 시스템</div></c:if>
			<c:if test="${getNetworkPosition eq 'O'}"><div class="login_type ${networkCss} login_text"><span class="network_text">${OUTER}</span> ${customfunc:getMessage('common.text.title')} 시스템</div></c:if>
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
								<input type="text" value="" name="users_id2" id="users_id2" class="input_login" placeholder="${customfunc:getMessage('common.id.commonid')}" /><br/>
								<input type="hidden" value="" name="users_id" id="users_id" style="display: none;"/>
								<input type="password" name="user_pwd_fake" id="user_pwd_fake" autocomplete="off" style="display: none;">
								<input onfocus="this.removeAttribute('readonly');" type="password" value="" name="users_pw" id="users_pw" autocomplete="off" class="input_login" placeholder="${customfunc:getMessage('login.password.input.prefix')}패스워드"/>
								<p class="optionBox">
									<input type="checkbox" name="remember" id="remember" />
									<label for="check_saveid">아이디저장</label>
								</p>
							</div>
							<c:choose>
								<c:when test="${ otpOption eq getNetworkPosition or otpOption eq 'Y'}">
									<div class="opt_div_area">
										<button type="submit" onClick="login();" class="login_page_btn btn_common theme">
											<span class="text">로그인</span>
										</button>
										<button type="button" onClick="auth();" class="login_page_btn btn_common theme">
											<span class="text">비밀번호재설정</span>
										</button>
									</div>
								</c:when>
								<c:otherwise>
									<button type="submit" class="btn_login workPC" onClick="login();">
										<span class="ir_desc">로그인</span>
									</button>
								</c:otherwise>
							</c:choose>
						</div>
						<span class="alertArea" id="alertArea"></span>
					</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div id="footer">
		<p class="copyright" style="font-size:1.1em;">${copyRight}</p>
		<p class="copyright none"><span style="padding-right: 100px;">Net-Protect_V2.0</span><span style="padding-right: 100px;">R2.0.0.345</span><span>${program_info }</span></p>
	</div>
</div>
<%-- 알림창 --%>
<section class="${networkCss} none" id="modal_alert">
	<div class="sk-circle">
	  <div class="sk-circle1 sk-child"></div>
	  <div class="sk-circle2 sk-child"></div>
	  <div class="sk-circle3 sk-child"></div>
	  <div class="sk-circle4 sk-child"></div>
	  <div class="sk-circle5 sk-child"></div>
	  <div class="sk-circle6 sk-child"></div>
	  <div class="sk-circle7 sk-child"></div>
	  <div class="sk-circle8 sk-child"></div>
	  <div class="sk-circle9 sk-child"></div>
	  <div class="sk-circle10 sk-child"></div>
	  <div class="sk-circle11 sk-child"></div>
	  <div class="sk-circle12 sk-child"></div>
	</div>
	<span id="modal_alert_text">보안프로그램 확인중입니다.<br>잠시만 기다려주세요.</span>
</section>
</body>
</html>
