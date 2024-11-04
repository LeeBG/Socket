<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@page import="SafeIdentity.SSO"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<!DOCTYPE html>
<html>
<head>
	<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
	<script type="text/javascript" src="/JavaScript/webtoolkit.base64.js"></script>
	<script type="text/javascript" src="/JavaScript/module/sso.js"></script>
	<script type="text/javascript" src="/JavaScript/common.js"></script>
</head>
<%
	String result = null;
	String errorCode = "";
	String users_id = "";
	String ssoToken = request.getParameter("SSO_TOKEN");
	System.out.println("===================================================================");
	System.out.println("ssoToken : " + ssoToken);

	SSO sso = new SSO();
	int resultCode = sso.verifyToken(ssoToken);
	System.out.println("resultCode : " + resultCode);

	if (resultCode == 0) {
		users_id = sso.getValueUserID();
		result = "success";
		session.setAttribute("sso_id", users_id);
	} else {
		result = "fail";
		errorCode = "invlid token";
	}
	
	/* Test 용도 id값 입력 필요 TEST진행 시 아래 3줄 주석 해제 */
	//users_id = "g488";
	//result = "success";
	//session.setAttribute("sso_id", users_id);

	System.out.println("users_id : " + users_id);
	System.out.println("===================================================================");
%>

<% if( "success".equals(result) ) {%>

<script type="text/javascript">
$(document).ready(function() {
	login();
});
function login(){
	var requestURL = "<c:url value='/sign/sso.lin'/>";
	var successURL = "<c:url value='/data/file/sendForm.lin' />";
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