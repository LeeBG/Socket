<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@page import="kr.co.s3i.sr1.common.cipher.AES128Utility"%>
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
<% request.setCharacterEncoding("UTF-8"); %>
<%
	AES128Utility aesUtility = null;
	String result = null;
	String errorCode = "";
	String resultCode = session.getAttribute("resultCode") == null? "" : session.getAttribute("resultCode").toString();
	String secureSessionId = session.getAttribute("secureSessionId") == null ? "" : session.getAttribute("secureSessionId").toString();
	String id = session.getAttribute("id") == null ? "" : session.getAttribute("id").toString();
	/* test code 주석 */
	//String id = "kjy";
	System.out.println("*===== resultCode =====* " + resultCode);
	System.out.println("*===== Encrypt before id =====* " + id);

	aesUtility = new AES128Utility();
	id = aesUtility.encode_PBKDF2Key(id);
	System.out.println("*===== Encrypt after id =====* " + id);

	if(!"000000".equals(resultCode)){
		System.out.println("****************** sso error 발생 ******************");
		System.out.println("sso error code info:"+resultCode);
		result = "fail";
	}

	if( id != null && !"".equals(id) ){
		result = "success";
	}else{
		result = "fail";
	}
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
		<input type = "hidden" name="users_id" value="<%=id%>" />
	</form>
</body>

<% } else {%>

<script>
<%-- var code = '<%=errorCode%>';
alert('로그인 중 오류가 발생하였습니다. '+(code!=''? '(code='+code+')' : '')); --%>
</script>

<% }%>
</html>