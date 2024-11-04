<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@page import="kr.co.s3i.sr1.common.cipher.AES128Utility"%>
<%@page import="kr.co.s3i.sr1.common.utility.CommonUtility"%>

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
	AES128Utility aesUtility = new AES128Utility();
	String result = null;
	String errorCode = "";
	String id = "";
	
	String con_ip = CommonUtility.getClientIp(request);
	if( con_ip.equals( aesUtility.decrypt_PBKDF2Key(request.getParameter("conInfo"))) ) {
		id = aesUtility.decrypt_PBKDF2Key( request.getParameter("nac_users_id") );			
	}	
	
	if( id != null && !"".equals(id) ) {
		System.out.println("*===== user_id =====* "+ id);
		
		id = aesUtility.encode_PBKDF2Key(id);
		result = "success";
	}else {
		result = "fail";
		errorCode = "id isEmpty fail";
		System.out.println("*===== errorCode =====*" + errorCode);
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
var code = '<%=errorCode%>';
alert('로그인 중 오류가 발생하였습니다. '+(code!=''? '(code='+code+')' : ''));
</script>

<% }%>
</html>