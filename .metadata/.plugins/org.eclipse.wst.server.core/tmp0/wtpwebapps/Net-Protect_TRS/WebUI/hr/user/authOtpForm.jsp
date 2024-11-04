<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<%-- isLoginOtpAuth users_id 값이 파라미터로 담기면 로그인 OTP 인증, 없으면 비밀번호 재설정 OTP 인증 --%>
<head>
<script type="text/javascript">
	$(document).ready(function(){
		$("#div_password").css('display', 'none');
		$("#div_confirm").css('display', 'none');

		if ( '${isLoginOtpAuth}' == 'true' ) {
			$("#password").focus();
			$("#name").attr("disabled",true);
		}
		
	});
	
	$(function() {
		$("#fingerBtn").css("display", "none");
		var auth_area = $('#auth_area');
		changeAuthTypeHtml( auth_area, $("input[name='auth_type']").val() )
		
		$("input[name='auth_type']").click(function() {
			if( $(this).val() == 'F' ) {
				changeAuthTypeHtml( auth_area,  $(this).val() )
				$("#otp_input").css("display", "none");
				$("#fingerBtn").css("display", "");
			} else {
				changeAuthTypeHtml( auth_area,  $(this).val() )
				$("#otp_input").css("display", "");
				$("#fingerBtn").css("display", "none");
			}
		});
	});

	function formSubmit(){
		var requestURL = "<c:url value="/hr/user/changePassword.lin" />";
		var successURL = "<c:url value="/" />";

		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			if (code == '200') {
				alert('비밀번호가 수정 되었습니다.');
				$(location).attr("href", successURL);
			} else {
				alert(message);
			}
		});
	}
	
	function update() {
		var users_pw = $('#users_pw_re').val();
		var users_pw_re = $('#users_pw_re2').val();
		if(users_pw ==  users_pw_re){
			formSubmit();
		}else{
			chkPw();
		}
	}
	
	function chkPw(){
		var users_pw = $('#users_pw_re').val();
		var users_pw_re = $('#users_pw_re2').val();
		if(users_pw ==  users_pw_re){
			$('#match').removeClass();
			$('#match').attr("class", "pwChk match");
			$('#mismatch').removeClass();
			$('#mismatch').attr("class", "pwChk mismatch none");
		}else{
			$('#mismatch').removeClass();
			$('#mismatch').attr("class", "pwChk match");
			$("#mismatch").attr("style","color:red;");
			$('#match').removeClass();
			$('#match').attr("class", "pwChk mismatch none");
			$('#mismatch').focus();
		}
	}

	function passwordDivShow(){
		$("#div_password").css('display', 'block');
		$("#div_confirm").css('display', 'block');

		$("#name").attr("disabled",true);
		$("#password").attr("disabled",true);
		$("#otpBtn").attr("disabled",true);
		$("#fingerBtn").attr("disabled",true);
		$("#auth_type_O").attr("disabled",true);
		$("#auth_type_F").attr("disabled",true);

		$("#name").css("cursor","no-drop");
		$("#password").css("cursor","no-drop");
		$("#otpBtn").css("cursor","no-drop");
		$("#fingerBtn").css("cursor","no-drop");
		$("#auth_type_O").css("cursor","no-drop");
		$("#auth_type_F").css("cursor","no-drop");
	}

	function optAuthSubmit( auth_type ){
		<%-- isLoginOtpAuth users_id 값이 파라미터로 담기면 로그인 OTP 인증, 없으면 비밀번호 재설정 OTP 인증 --%>
		var isLoginOtpAuth = '${isLoginOtpAuth}' == 'true'; 
		$('#isLoginOtpAuth').val( isLoginOtpAuth );

		var requestURL = "<c:url value="/hr/user/otpAuth.lin" />";
		var successURL = "<c:url value="/hr/user/authOtpForm.lin" />";

		if ( isLoginOtpAuth ) $('#users_id').val('${users_id}');

		isloading.start();
		var auth_area = $('#auth_area');
		if ( auth_type == 'F' ) {
			changeAuthTypeHtml( auth_area, 'F_PUSH' );
		}

		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['msg'];
			var otpForm = response['otpForm'];

			if (code == '0') {
				//alert(message);
				isloading.stop();

				if (isLoginOtpAuth) {
					location.href= "<c:url value="/data/file/sendForm.lin" />";
				} else {
					$('#name').val(otpForm.name);
					$('#password').val(otpForm.password);
					$('#users_id').val($('#name').val());
					passwordDivShow();
				}
			} else {
				alert(message);
				isloading.stop( code );
				changeAuthTypeHtml( auth_area, 'F_COMPLETE' );
				if(code == 200) {
					$('#name').val(otpForm.name);
					$('#password').val(otpForm.password);
				}
			}
		});
	}

	function otpAuth() {
		var auth_type = $('input[name="auth_type"]:checked').val();
		if ( validationChk( auth_type ) ) {
			optAuthSubmit( auth_type );
		}
	}

	function validationChk( auth_type ) {
		var errmsg = cls_errmsg();
		var name = $('#name').val();
		var password = $('#password').val();

		if ( empty(name) ) {
			errmsg.append(name, "사번을 입력해주세요.");
			errmsg.show();
			$('#name').focus();
			return false;
		}

		if ( auth_type == 'O' && empty(password) ) {
			errmsg.append(password, "OTP 값을 입력해주세요.");
			errmsg.show();
			$('#password').focus();
			return false;
		}

		if ( auth_type == 'O' && password.length != 6 ) {
			errmsg.append(password, "OTP 값 6자리를 입력하셔야 됩니다.");
			errmsg.show();
			$('#password').focus();
			return false;
		}

		return true;
	}
	
	function changeAuthTypeHtml( $div, type ){
		var title = $div.find('.text_title');
		var info = $div.find('.otp_info');
		var message = $div.find('.text_message');

		switch (type) {
			case 'F':
				title.html('생체인증');
				info.html('인증 버튼을 클릭시 푸시 메시지를 발송합니다.');
				break;
			case 'O':
				title.html('OTP');
				info.html('OTP 입력값은 6자리 숫자로 입력제한합니다.');
				break;
			case 'F_PUSH':
				message.html('푸시메시지를 발송했습니다.</br>만약 푸시메시지를 받지 못한 경우, 앱을 실행시켜서 로그인 하세요.');
				break;
			case 'F_COMPLETE':
				message.html('');
				break;
		}
	}

	isloading = {
			start : function() {
				$("#otpBtn").attr("disabled",true);
				$("#fingerBtn").attr("disabled",true);
				var auth_type = $('input[name="auth_type"]:checked').val();
				if (document.getElementById('wfLoading')) {
					return;
				}
				var ele = document.createElement('div');
				ele.setAttribute('id', 'wfLoading');
				ele.className = "loading-layer";
				if ( auth_type == 'O' ) {
					ele.innerHTML = '<span class="loading-wrap"><span class="loading-text"><span><MARQUEE style="width:150px;height:40px;font-size:30px;padding-top:20px;" behavior="scroll" direction="RIGHT">인증중입니다. 잠시만 기다려주세요.</MARQUEE></span></span></span>';
				} else {
					ele.innerHTML = '<span class="loading-wrap"><span class="loading-text"><span><MARQUEE style="width:375px;height:40px;font-size:30px;padding-top:20px;" behavior="scroll" direction="RIGHT">푸시메시지를 발송했습니다. 만약 푸시메시지를 받지 못한 경우, 앱을 실행시켜서 로그인 해주세요.</MARQUEE></span></span></span>';
				}
				
				$("body").append(ele);
				
				// Animation
				name = "active-loading";
				arr = ele.className.split(" ");
				if (jQuery.inArray('indexOf',arr) == -1) {	//change reson : IE8, IE9
					ele.className += " " + name;
				}
			},
			stop : function( code ) {
				if (code != 200) {
					$("#otpBtn").attr("disabled",false);
					$("#fingerBtn").attr("disabled",false);
				}
				var ele = $('#wfLoading');
				if (ele) {
					ele.remove();
				}
			}
		}
</script>
<style>
.loading-layer {
    display: block;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(68, 68, 68, 0.3);
    z-index: 11111;
}
.loading-layer .loading-wrap {
    display: table;
    width: 100%;
    height: 100%;
}
.loading-layer .loading-wrap .loading-text {
    display: table-cell;
    vertical-align: middle;
    text-align: center;
    color: #fff;
    text-shadow: 2px 3px 2.6px #a2a2a2;
    font-size: 3.8em;
    position: relative;
    top: -20px;
}
.loading-layer.active-loading .loading-wrap .loading-text span:nth-child(1) {
  animation: loading-01 0.82s infinite;
}
.loading-layer.active-loading .loading-wrap .loading-text span:nth-child(2) {
  animation: loading-02 0.82s infinite;
}
.loading-layer.active-loading .loading-wrap .loading-text span:nth-child(3) {
  animation: loading-03 0.82s infinite;
}

</style>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post">
<input type="hidden" id="changePassword" name="changePassword" value="otpChangePassword">
<input type="hidden" id="users_id" name="users_id" value="">
<input type="hidden" id="init_pwd_yn" name="init_pwd_yn" value="Y">
<input type="hidden" id="isLoginOtpAuth" name="isLoginOtpAuth" value="">
	<div class="wrap">
		<div class="change_pw_box">
			<h1 class="t_left"><img src="/Images/common/logo_s3i.gif" alt="logo" title="logo" width="225" /></h1>
			<div class="mg_t20 Tborder" id="auth_area">
				<p class="change_pw_title"><span class="text_title"></span> 인증을 진행해주세요.</p>
				<c:if test="${isLoginOtpAuth eq 'true'}">
					<p class="change_pw_info mg_t20">
						안전한 계정보호를 위해 <span class="text_title"></span> 인증 후, 로그인을 하고 있습니다.<br/>
						<span class="text_title"></span> 인증 후 로그인 해주세요. <span class="otp_info"></span><br/>
						안전한 계정 관리를 통해 소중한 개인정보를 안전하게 보호하세요.<br/>
						<span class="text_message"></span>
					</p>
				</c:if>
				<c:if test="${isLoginOtpAuth eq 'false'}">
					<p class="change_pw_info mg_t20">
						안전한 패스워드 변경을 위한 정책에 따라 <span class="text_title"></span> 인증 후, 비밀번호 변경을 안내하고 있습니다.<br/>
						<span class="text_title"></span> 인증 후 비밀번호를 변경해주세요. <span class="otp_info"></span><br/>
						비밀번호의 주기적 변경 관리를 통해 소중한 개인정보를 안전하게 보호하세요.<br/>
						<span class="text_message"></span>
					</p>
				</c:if>
				<div class="mg_t50 change_pw_inputArea">
					<dl>
						<dt>· 인증 방식</dt>
						<dd>
						<div style="padding : 3px;" id="auth_type_area">
							<input type="radio" id="auth_type_O" name="auth_type" value="O" checked="checked" /><label for="auth_type_O" style="padding-left: 6px; padding-right: 22px;">OTP인증</label>&nbsp;
							<c:choose>
								<c:when test="${isLoginOtpAuth eq 'true'}">
									<input type="radio" id="auth_type_F" name="auth_type" value="F" onclick="otpAuth();" /><label for="auth_type_F" style="padding-left: 6px;">생체인증</label>
								</c:when>
								<c:otherwise>
									<input type="radio" id="auth_type_F" name="auth_type" value="F" /><label for="auth_type_F" style="padding-left: 6px;">생체인증</label>
								</c:otherwise>
							</c:choose>
						</div>
						</dd>
					</dl>
					<dl>
						<dt>· 사용자 사번</dt>
						<dd>
							<input type="text" class="text_input" id="name" name="name" value="${users_id}" autofocus />
							<button type="submit" class="btn_big theme mg_l5" onclick="otpAuth();" id="fingerBtn">인증</button>
						</dd>
					</dl>
					<div id="otp_input">
						<dl>
							<dt>· OTP 입력</dt>
							<dd>
								<input type="text" class="text_input" id="password" name="password" onkeyup="onlyNumFillter(this,6)" value="" autofocus />
								<button type="submit" class="btn_big theme mg_l5" onclick="otpAuth();" id="otpBtn">인증</button>
							</dd>
						</dl>
					</div>
					<div id="div_password">
					<dl>
						<dt>· 새 비밀번호</dt>
						<dd><input type="password" class="text_input" id="users_pw_re" name="users_pw_re" onkeyup="chkPw();" /></dd>
					</dl>
					<dl>
						<dt>· 새 비밀번호 확인</dt>
						<dd>
							<input type="password" class="text_input" id="users_pw_re2" name="users_pw_re2" onkeyup="chkPw();" onkeypress="JavaScript:update()" />
							<span id="match" class="pwChk match none">* 일치</span>
							<span id="mismatch" class="pwChk mismatch">* 불일치</span>
						</dd>
					</dl>
					</div>
				</div>
			</div>
			<div class="btn_area_center mg_t50 pd_t30 Tborder" id="div_confirm" >
				<button type="button" class="btn_big theme" onclick="update();">확인</button>
			</div>
		</div>
	</div>
</form>
</body>
</html>