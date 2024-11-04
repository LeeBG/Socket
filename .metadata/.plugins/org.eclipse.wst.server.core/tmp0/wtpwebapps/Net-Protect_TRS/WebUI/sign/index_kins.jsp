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
		<c:set var="agentDownloadUrl" value="/agent/I/Net-ProtectClientAgent-kins-I-Setup-1.0.3.exe" />
	</c:when>
	<c:otherwise>
		<c:set var="agentDownloadUrl" value="/agent/O/Net-ProtectClientAgent-kins-O-Setup-1.0.3.exe" />
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
		//rememberHide();
		initApprovalLockNotice();
		autoCompleteId(lform, "${siteCode}");
	});

	function rememberHide() {
		$(".kins_optionBox").css("display","none");
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
		form.remember.value = (form.remember.checked ? "remember" : "");
		

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		if (form.remember.checked) {
			var user_id = form.users_id2.value;
			setsaveUserIdLocalStorage(user_id);
		} else if (!form.remember.checked) {
			removesaveUserIdLocalStorage();
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
		var remember = getsaveUserIdLocalStorage();
		if (form) {
			if (remember != null && remember != "") {
				form.remember.checked = true;
				form.users_id2.value = remember;
			}
			if (form.users_id2.value != "") {
				form.users_pw.focus();
			} else {
				form.users_id2.focus();
			}
		}

		$('#users_id2').on('keydown', function(e) {
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
<style type="text/css">
#kins_login_wrap{width:100%; height:100%;}
#login_header{width:100%; height:240px; background-color:#f5f5f5; border-bottom:1px solid #ddd;text-align:center; }
h1 .logo_img{margin-top:110px; margin-left:60px;}
p.liginTitle{font-size:1.3em; font-weight:bold; margin:30px auto 0; background-color:#fff; padding:13px 0; border:1px solid #ddd; border-radius:20px; -moz-border-radius:20px;-ms-border-radius:20px;-o-border-radius:20px; width:300px;}

#kins_login_contents{width:100%;}
#kins_login_contents .loginBox{margin:80px auto 0; width:760px; }
#kins_login_contents .login_type{float:left; background-image:url('../Images/new_login/login_type_title3.gif'); margin-top:50px;}
#kins_login_contents .login_type.workPC{width:370px; height:65px; background-position:0 0; margin-left:-20px;}
#kins_login_contents .login_type.internetPC{width:420px; height:65px; background-position:0 -100px; margin-left:-70px;}
.login_form_area{overflow:hidden; width:370px; float:right; text-align:left;}
.kins_input_area{float:left;}
.login_form_area .input_login{width:240px; height:40px; background-color:#ffffff; border:1px solid #acacac; margin:5px 0; font-size:16px; padding-left:5px; line-height:2.3em;}
*:first-child+html .input_login{line-height:2.5em; width:240px; margin:3px 0;}

.kins_optionBox{position:relative; width:245px;}
.findPwd{display:inline-block; position:absolute; right:0; font-weight:bold;}

#remember{vertical-align:middle;width:15px; height:15px; margin:0;padding:0;}

button.btn_login{display:inline; float:right; width:118px;height:94px;background-image:url(../Images/new_login/btn_login.gif); margin-top:16px;}
button.btn_login.workPC{background-position:0 0;}
button.btn_login.internetPC{background-position:0 -100px;}
span.alertArea{margin:0 auto; display:none; width:60%; background-color:#f9f9f9; border:1px solid #eee; text-align:center; color:red; font-weight:bold; line-height:1.2em; clear:both; padding:12px 0;} 
.agent_btn{border:2px solid #ddd; padding:3px 1px 1px 1px; border-radius: 5px; margin: 15px 10px 15px 10px; width: 90px; float: right; background-color: white; font-weight: bold; font-size:0.5em; cursor:pointer; font-family: '돋움',Dotum,Helvetica,AppleGothic,sans-serif';}
/* footer */
#kins_login_footer{width:100%; position:fixed; left:0; bottom:0; border-top:1px solid #ddd;}
.copyright{text-align:center; font-size:0.78em; padding-top:10px; height:30px; color:#9d9d9d; line-height:20px;}
</style>
</head>
<body>
<div id="kins_login_wrap">
	<div id="login_header">
		<h1>
			<img class="logo_img" alt="LOGO" src="<c:url value="/Images/new_login/logo_login_kins.gif" />" />
		<span class="agent_btn" class="agent_btn" onclick="javascript:location.href='${agentDownloadUrl}';" title="다운로드">
				<img class="down_img" style="vertical-align: middle; margin-top: 0px; width:20px; height:20px;" alt="LOGO" src="<c:url value="/Images/button/agent_down_btn.png" />" />
				<span>다운로드</span>
		</span>
		</h1>
		<p class="liginTitle">망간 자료전송 시스템</p>
	</div>
	<div id="kins_login_contents">
			<form name="lform" id="lform" class="clipImg" method="post" action="<c:url value="/sign/login.lin" />" onSubmit="return false;">
			<input type="hidden" name="csrf" value="<%=UUID.randomUUID()%>"/>
			<input type="hidden" name="jsonNetworkInfo" id="jsonNetworkInfo" value = ""/>
			<fieldset>
			<legend>id, password insert form</legend>
				<div class="loginBox">
					<div class="login_type ${networkCss}"></div>
					<div class="login_form_area mg_t20">
						<div class="kins_input_area">
							<p class="kins_optionBox">
								<input type="checkbox" name="remember" id="remember" />
								<label for="check_saveid">아이디저장(마이다스 ID/PW)</label>
							</p>
							<input type="text" value="" name="users_id2" id="users_id2" class="input_login" placeholder="MIDAS ${customfunc:getMessage('common.id.commonid')}" /><br/>
							<input type="hidden" value="" name="users_id" id="users_id" style="display: none;"/>
							<input type="password" name="user_pwd_fake" id="user_pwd_fake" autocomplete="off" style="display: none;">
							<input onfocus="this.removeAttribute('readonly');" type="password" value="" name="users_pw" id="users_pw" autocomplete="off" class="input_login" placeholder="${customfunc:getMessage('login.password.input.prefix')}MIDAS 패스워드"/>
						</div>
						<div class="f_right" style="overflow: hidden;">
							<button type="submit" class="btn_login ${networkCss}" onClick="login();">
								<span class="ir_desc">로그인</span>
							</button>
						</div>
						<span class="ir_desc">로그인</span>
					</div>
					<span class="alertArea" id="alertArea"></span>
				</div>
			</fieldset>
		</form>
	</div>
	<div id="kins_login_footer">
		<p class="copyright">COPYRIGHT S3I ALL RIGHTS RESERVED.</p>
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

