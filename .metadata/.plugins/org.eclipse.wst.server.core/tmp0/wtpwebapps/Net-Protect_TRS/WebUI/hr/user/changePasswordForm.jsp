<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="loginPolicy" value="${loginUser.loginPolicy}" />
<c:set var="init_pwd_yn" value="${loginUser.init_pwd_yn}" />
<c:set var="pw_cycle" value="${loginPolicy.pw_cycle}" />
<c:set var="env" value="${sessionScope.envInfo}" />
<!-- LOG_FPATH, LOG_FNAME -->
<c:set var="logoUrl" value="/Images/common/logo_s3i.gif" />
<c:choose>
	<c:when test="${env.log_fname == '' }">
		<c:set var="logoUrl" value="/Images/common/logo_s3i.gif" />
	</c:when>
	<c:otherwise>
		<c:set var="logoUrl" value="${env.log_fpath}${env.log_fname }" />
	</c:otherwise>	
</c:choose>
<script type="text/javascript">
	$(document).ready(function(){
		
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
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/user/changePasswordForm.lin" />">
	<input type="hidden" id="changePassword" name="changePassword" value="changePassword">
	<div class="wrap">
		<div class="change_pw_box">
			<h1 class="t_left"><img src="${logoUrl}" alt="logo" title="logo" width="225" /></h1>
			<div class="mg_t20 Tborder">
				<p class="change_pw_title">비밀번호를 변경해주세요.</p>
				<p class="change_pw_info mg_t20">
				<c:choose>
					<c:when test="${init_pwd_yn eq 'Y'}">
						패스워드가 초기화 된 후 처음 접속하셨습니다. 안전한 개인정보 보호를 위해, 비밀번호 변경을 안내하고 있습니다.<br/>
						새로운 패스워드로 변경하여 소중한 개인정보를 안전하게 보호하세요.
					</c:when>
					<c:otherwise>
						안전한 개인정보 보호를 위한 정책에 따라 ${pw_cycle}일 이상 비밀번호를 변경하지 않은 경우, 비밀번호 변경을 안내하고 있습니다.<br/>
						비밀번호의 주기적 변경 관리를 통해 소중한 개인정보를 안전하게 보호하세요.
					</c:otherwise>
				</c:choose>
				</p>
				<div class="mg_t50 change_pw_inputArea">
					<dl>
						<dt>· 현재비밀번호</dt>
						<dd><input type="password" class="text_input" id="users_pw" name="users_pw" /></dd>
					</dl>
					<dl>
						<dt>· 새 비밀번호</dt>
						<dd><input type="password" class="text_input" id="users_pw_re" name="users_pw_re" onkeyup="chkPw();" /></dd>
					</dl>
					<dl>
						<dt>· 새 비밀번호 확인</dt>
						<dd>
							<input type="password" class="text_input" id="users_pw_re2" name="users_pw_re2" onkeyup="chkPw();" />
							<!-- 패스워드 확인 문구 -->
							<span id="match" class="pwChk match none">* 일치</span>
							<!--  패스워드 확인 문구 -->
							<span id="mismatch" class="pwChk mismatch">* 불일치</span>
						</dd>
					</dl>
				</div>
				<!-- <br> -->
				<!-- <span style="color: red;">*비밀번호 변경시 초기패스워드 posid000!을 사용할수 없으니 다른패스워드로 변경해주세요.</span> -->
			</div>
			<div class="btn_area_center mg_t50 pd_t30 Tborder">
				<button type="button" class="btn_big theme" onclick="update();">확인</button>
				<!-- <button type="button" class="btn_big mg_l10">다음에 변경하기</button> -->
			</div>
		</div>
	</div>
</form>
</body>
</html>