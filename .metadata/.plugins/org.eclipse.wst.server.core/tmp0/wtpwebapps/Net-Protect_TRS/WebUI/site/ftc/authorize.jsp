<%@page import="kr.co.s3i.sr1.common.cipher.ARIA"%>
<%@page language="java" contentType="text/html;charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="getSiteCode" value="${customfunc:getSiteCode()}" />
<!DOCTYPE html>
<html>
<head>
	<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
	<script type="text/javascript" src="/JavaScript/webtoolkit.base64.js"></script>
	<script type="text/javascript" src="/JavaScript/module/sso.js"></script>
	<script type="text/javascript" src="/JavaScript/common.js"></script>
</head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%
	String result = null;
	String errorCode = "";
	String user_id = null;
	int spritLength = 4;
	ARIA aria = null;

	//parameter 에서 인증 토큰 획득
	String ptype = request.getParameter("ptype");
	String paction = request.getParameter("paction");
	String user_ekp_id = request.getParameter("USER_EKP_ID");
	System.out.println("*===== ptype =====* " + ptype);
	System.out.println("*===== paction =====* " + paction);
	System.out.println("*===== USER_EKP_ID =====* " + user_ekp_id);

	try{
		
		if ( errorCode.equals("param_not_found") ) {
			result = "fail";
		}else if( !ptype.equals("SSO") ) {
			result = "fail";
		} else {
			aria = new ARIA();
			user_id = aria.AriaDecrypt(user_ekp_id, spritLength);
		
			System.out.println("*===== user_id =====* "+ user_id);
			
			if( user_id != null && !"".equals(user_id) ){
				session.setAttribute("sso_id", user_id);
				result = "success";
			}else{
				result = "fail";
			}
		}
		
	}catch(Exception e){
 	 	System.out.println("Aria 복호화 중 오류 발생");
 	}
%>

<% if( "success".equals(result) ) {%>

<script type="text/javascript">
$(document).ready(function() {
	var action = '<%=paction%>';
	if(action == "login") {
		login();
	}else {
		alert("처리중 중 오류가 발생하였습니다. 정의 되지 않은 paction - ("+action+")");
	}
});

function login() {
	var requestURL = "<c:url value='/sign/sso.lin'/>";
	var successURL = "<c:url value='/site/ftc/sendForm.lin' />";
	var pwdChgURL = "<c:url value='/hr/user/changePasswordForm.lin' />";
	 
	resultCheckFunc($("#lform"), requestURL, function(response) {
		var code = response['code'];
		var message = response['message'];
		if (code == "${customfunc:codeString('LI_CD','SUCC')}" || code == "${customfunc:codeString('LI_CD','ERROR_LOGIN_PWD_CHANGE')}") {
			location.href = successURL;
		} else {
			if( message ){
				alert(message);
			}else{
				alert("로그인 정보가 올바르지 않습니다.[code="+code+"]");
			}
		}
	});
}

</script>
<body>
	<form name="lform" id="lform" method="post"  onSubmit="return false;">
		<input type = "hidden" name="users_id" value="" />
	</form>
</body>

<% } else {%>

<script>
var code = '<%=errorCode%>';
alert('로그인 중 오류가 발생하였습니다. '+(code!=''? '(code='+code+')' : ''));
</script>

<% }%>
</html>
