<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<!-- LOG_FPATH, LOG_FNAME -->
<script type="text/javascript">
	$(document).ready(function(){
		$("#type").val('${type}');
	});

	function insert(){
		var requestURL = "<c:url value="/hr/user/insertAdmin.lin" />";
		var successURL = "<c:url value="/sign/trans.lin" />";

		var type = '${type}';
		if (type == 'stream') {
			successURL = "<c:url value="/sign/stream.lin" />";
		}

		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			alert(message);
			if (code == '200') {
				$(location).attr("href", successURL);
			}
		});
	}

	function chkPw(){
		var users_pw = $('#users_pw').val();
		var users_pw_re = $('#users_pw2').val();
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
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/user/firstAccessForm.lin" />">
<input type="hidden" id="type" name="type" value="">
	<div class="wrap">
		<div class="change_pw_box">
			<div class="mg_t20 Tborder">
				<p class="change_pw_title">관리자를 등록 하세요.</p>
				<div class="mg_t50 change_pw_inputArea">
					<dl>
						<dt>· 자료전송 관리자 ID </dt>
						<dd><input class="text_input" id="users_id" name="users_id" /></dd>
					</dl>
					<dl>
						<dt>· 새 비밀번호</dt>
						<dd><input type="password" class="text_input" id="users_pw" name="users_pw" onkeyup="chkPw();" /></dd>
					</dl>
					<dl>
						<dt>· 새 비밀번호 확인</dt>
						<dd>
							<input type="password" class="text_input" id="users_pw2" name="users_pw2" onkeyup="chkPw();" />
							<!-- 패스워드 확인 문구 -->
							<span id="match" class="pwChk match none">* 일치</span>
							<!--  패스워드 확인 문구 -->
							<span id="mismatch" class="pwChk mismatch">* 불일치</span>
						</dd>
					</dl>
					<dl>
						<dt>· IP</dt>
						<dd><input class="text_input" id="inner_ip" name="inner_ip"  /></dd>
					</dl>
				</div>
			</div>
			<div class="btn_area_center mg_t50 pd_t30 Tborder">
				<button type="button" class="btn_big theme" onclick="insert();">등록</button>
			</div>
		</div>
	</div>
</form>
</body>
</html>