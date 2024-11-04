<%@page import="java.util.UUID"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="systemCode" value="${customfunc:cacheString('initMod')}" /><!-- T, S -->
<c:set var="getNetworkPosition" value="${customfunc:getNetworkPosition()}" /><!-- I, O -->
<%-- <c:set var="copyRight" value="${customfunc:getTypeData('copyright')}" /> --%>
<c:set var="copyRight" value="${sessionScope.cssCopyright}" />
<c:set var="siteCode" value="${customfunc:cacheString('siteCode')}" />
<c:set var="csAgentUseYN" value="${customfunc:cacheString('csAgentUseYN')}" />
<!-- 
스트림 연계 보안영역 Server : INT_STM_Net-Protect_V2.0.0.345
스트림 연계 비-보안영역 Server : Ext_STM_Net-Protect_V2.0.0.345
자료전송 보안영역 Server : INT_TRS_Net-Protect_V2.0.0.345
자료전송 비-보안영역Server : Ext_TRS_Net-Protect_V2.0.0.345 -->
<!-- systemCode = ${systemCode }
getNetworkPosition = ${getNetworkPosition } -->
<c:set var="prgm_nm" value="" />
<c:set var="version" value="" />
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

<c:choose>
	<c:when test="${customfunc:isInnerPosition()}">
		<c:set var="agentDownloadUrl" value="/agent/I/Net-ProtectClientAgent-insu-I-Setup-1.1.6.exe" />
	</c:when>
	<c:otherwise>
		<c:set var="agentDownloadUrl" value="/agent/O/Net-ProtectClientAgent-insu-O-Setup-1.1.6.exe" />
	</c:otherwise>
</c:choose>

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
		//s3i_wsAgentConnect(hideModalAndSendMessagesToAgent,null,AG_processMessageFromAgent,redirectToDownloadPage);
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
<%--
	 /* 산업자원통상부 Agent 수동 실행 */
	/* function s3i_errorFun(evt) { //에러 처리 이벤트 함수
		if(confirm("Agent가 실행되지 않았습니다.\n\n상단에 Agent 다운로드 버튼을 클릭하여\nAgent 설치를 진행해 주세요.\n\nAgent를 설치하신 사용자께서는\n바탕화면에 Net-ProtectAgent를 실행하신 후\n확인을 클릭해 주세요.")){
			setTimeout("location.reload();", 10000);
		}
	} */
--%>
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
				location.href = '<c:url value="/hr/user/changePasswordForm.lin" />';
			} else {
				if( message ){
					form.users_id2.focus();
					alert(message);
				}else{
					alert("로그인 정보가 올바르지 않습니다.");
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
	<%--
	function chk(){
		var users_id = $('#users_id').val();
		users_id = users_id.replace("<", "&lt;").replace(">", "&gt;");
		$('#users_id').val(users_id);
		alert($('#users_id').val());
	}
	--%>
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
<style type="text/css">
	.network_insu_i{
		color: #24a7e0;
	}
	.network_insu_h{
		color: green;
	}
	.network_O{
		color: #b71f1f;
	}
	#login_area .login_type{
		background-image:url('../Images/new_login/logo_login_insu.png') !important;
		background-position:0px 0px !important;
	}
	#login_area{
		background-color: #00205C !important;
	}
</style>
</head>
<body>
<div id="login_wrap" class="${networkCss}">
	<div id="login_area" class="login_area">
		<c:if test="${csAgentUseYN eq 'Y'}">
			<c:set var="agent_css" value="agent_css" />
		</c:if>
		<div class="loginBox_wrap ${agent_css}">
			<c:if test="${ csAgentUseYN eq 'Y' }">
				<div class="agent_area" title="다운로드">
					<button class="btn_down_main" onclick="javascript:location.href='${agentDownloadUrl}';">
						<img class="down_img" alt="LOGO" src="<c:url value="/Images/button/agent_down_btn.png" />" />
						<span>CS 자료전송 프로그램 다운로드</span>
					</button>
				</div>
			</c:if>
			<div class="login_type ${networkCss} "></div>
			<div class="title login_text">
				<c:if test="${getNetworkPosition eq 'I'}"><span class="network_${siteCode }">${customfunc:getMessage('common.text.network.in')}</span>↔<span class="network_O">${customfunc:getMessage('common.text.network.out')}</span> ${customfunc:getMessage('common.text.title')} 시스템</c:if>
				<c:if test="${getNetworkPosition eq 'O'}"><span class="network_O">${customfunc:getMessage('common.text.network.out')}</span>↔<span class="network_${siteCode }">${customfunc:getMessage('common.text.network.in')}</span> ${customfunc:getMessage('common.text.title')} 시스템</c:if>
			</div>
			<div class="dis_table form_outer_div">
				<div class="dis_inner_cell">
					<form name="lform" id="lform" method="post" action="<c:url value="/sign/login.lin" />" onSubmit="return false;">
					<input type="hidden" name="csrf" value="<%=UUID.randomUUID()%>"/>
					<input type="hidden" name="jsonNetworkInfo" id="jsonNetworkInfo" value = ""/>
					<fieldset>
					<legend>id, password insert form</legend>
						<div class="login_form_area">
							<div class="certificate_login_box">
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
								<button type="submit" class="btn_login workPC" onClick="login();">
									<div class="btn_login_workPC"><span>로그인</span></div>
								</button>
							</div>
						</div>
					<span class="alertArea" id="alertArea"></span>
					</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div id="footer">
		<p class="copyright">
			<span style="padding-right: 100px;">${copyRight}</span>
			<span style="padding-right: 100px;">Net-Protect_V2.0.2</span><span style="padding-right: 100px;">V2.0.2.3</span><span>${program_info }</span>
		</p>
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
