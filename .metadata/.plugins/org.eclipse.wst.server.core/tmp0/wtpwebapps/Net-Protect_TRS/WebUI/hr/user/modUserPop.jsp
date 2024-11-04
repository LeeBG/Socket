<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="loginUser" value="${sessionScope.loginUser}" /> 
<c:choose>
	<c:when test="${customfunc:isInnerPosition()}">
		<c:set var="networkCss" value="workPC" />
	</c:when>
	<c:otherwise>
		<c:set var="networkCss" value="internetPC" />
	</c:otherwise>
</c:choose>
<head>
<script type="text/javascript">
	//${loginUser.auth_cd}
	$(document).ready(function() {
//		checkFocusMessage($("#users_pw_re"), "패스워드는 ${cPolLoginMgtForm.pw_len_min}자 이상, ${cPolLoginMgtForm.pw_len_max}자 이하의 영문, 숫자 그리고 특수 문자의 조합이어야 합니다.");
		checkFocusMessage($("#users_pw_re"), "1s");
	});

	function edit(){
		var users_pw_re = $('#users_pw_re').val();
		var users_pw_re2 = $('#users_pw_re2').val();

		<%-- 중부발전 관리자 패스워드 변경을 위해서 해당 페이지 활성화. 이메일은 사용하지 않기때문에 주석처리 1 --%>
		<%-- 
		var email = $('#email').val();
		if (empty(email) || !isValidEmail(email)) {
			alert('이메일 주소가 올바르지 않습니다.');
			return false;
		} --%>

		if (!empty(users_pw_re)) {
			if (users_pw_re == users_pw_re2) {
				$('#match').removeClass();
				$('#match').attr("class", "pwChk match");
				$('#mismatch').removeClass();
				$('#mismatch').attr("class", "pwChk mismatch none");

				var requestURL = "<c:url value="/hr/user/modUser.lin" />";
				resultCheckFunc($("#lform"), requestURL, function(response) {
					var code = response['code'];
					var message = response['message']; 
					if (code == 200){
						alert(message);
						window.close();
					}
					if (code == 500){
						alert(message);
					}
				});
			} else {
				alert('패스워드가 일치하지 않습니다.');
				$('#mismatch').removeClass();
				$('#mismatch').attr("class", "pwChk match");
				$("#mismatch").attr("style","color:red;");
				$('#match').removeClass();
				$('#match').attr("class", "pwChk mismatch none");
			}
		} else {
			alert('패스워드를 입력하세요.');
			$('#mismatch').removeClass();
			$('#mismatch').attr("class", "pwChk match");
			$("#mismatch").attr("style","color:red;");
			$('#match').removeClass();
			$('#match').attr("class", "pwChk mismatch none");
		}
	}

	function cancle(){
		window.close();
	}

	function chkPw(){
		var users_pw_re = $('#users_pw_re').val();
		var users_pw_re2 = $('#users_pw_re2').val();

		if(users_pw_re ==  users_pw_re2){
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

	$(document).ready(function() {
		checkFocusMessage($("#users_pw_re"), "패스워드는 ${cPolLoginMgtForm.pw_len_min}자 이상, ${cPolLoginMgtForm.pw_len_max}자 이하의 영문, 숫자 그리고 특수 문자의 조합이어야 합니다.");
		checkFocusMessage($("#users_pw_re2"), "패스워드는 ${cPolLoginMgtForm.pw_len_min}자 이상, ${cPolLoginMgtForm.pw_len_max}자 이하의 영문, 숫자 그리고 특수 문자의 조합이어야 합니다.");
	});
</script>
<style>
</style>
	<title>망연계 자료전송 시스템</title>
</head>
<body>
<form id="lform" name="lform" action="<c:url value="/hr/user/modUser.lin" />" method="post" onSubmit="return false;">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div id="wrap" class="wrap">
		<div class="popWrap">
			<h3>정보 변경</h3>
			<div class="conBox">
				<div class="popCon">
					<div class="table_area_style02">
						<table summary="자료 수신함" style="table-layout : fixed;" class="">
						<caption>요청자, 제목, 요청시간</caption>
							<colgroup>
								<col style="width:27%;"/>
								<col style="width:73%;"/>
							</colgroup>
							<tbody>
								<tr>
									<th class="Rborder t_left">이름</th>
									<td class="Tborder">${loginUser.users_nm }</td>
								</tr>
								<tr>
									<th class="Rborder t_left">현재 패스워드</th>
									<td><input type="password" id="users_pw" name="users_pw" class="text_input max" value="" /></td>
								</tr>
								<tr>
									<th class="Rborder t_left">패스워드</th>
									<td><input type="password" id="users_pw_re" name="users_pw_re" class="text_input max" value="" onkeyup="chkPw();" /></td>
								</tr>
								<tr>
									<th class="Rborder t_left">패스워드 확인</th>
									<td>
										<input type="password" id="users_pw_re2" name="users_pw_re2" class="text_input max" value="" onkeyup="chkPw();" />
										<!-- 패스워드 확인 문구 -->
										<span class="pwChk match none" id="match">* 일치</span>
										<span class="pwChk mismatch" id="mismatch">* 불일치</span>
										<!--  패스워드 확인 문구 -->
									</td>
								</tr>
								<%-- 중부발전 관리자 패스워드 변경을 위해서 해당 페이지 활성화. 이메일은 사용하지 않기때문에 주석처리 2 --%>
								<%-- <tr>
									<th class="Rborder t_left">이메일 주소</th>
									<td><input type="text" id="email" name="email" class="text_input max" value="${loginUser.email }" /></td>
								</tr> --%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="btn_area_center mg_t10 mg_b10">
				<button type="button" class="btn_big theme" onclick="edit();">수정</button>
				<button type="button" class="btn_big" onclick="cancle();">취소</button>
			</div>
		</div>
	</div>
</form>
</body>
</html>