<%@page import="kr.co.s3i.sr1.cacheEnv.cache.common.CacheUtility"%>
<%@page import="kr.co.s3i.sr1.common.utility.CommonUtility"%>
<%@page import="kr.co.s3i.sr1.common.exception.UserNullpointException"%>
<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%@page import="gov.mogaha.gkmc.main.servlet.portal.sso.aria.ARIAProvider"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<%@page import="com.ubintis.common.util.JsonParse"%>

<%@ page import="cg.cntc.enDeCrypt.Base64" %>
<%@ page import="cg.cntc.enDeCrypt.EgovCipherService" %>
<%@ page import="com.crinity.customized.mke.webapps.out.util.EncryptSDK" %>
<!DOCTYPE html>
<html>
<head>
	<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
	<script type="text/javascript" src="/JavaScript/webtoolkit.base64.js"></script>
	<script type="text/javascript" src="/JavaScript/module/sso.js"></script>
	<script type="text/javascript" src="/JavaScript/common.js"></script>
</head>
<%
String errorCode = "";
String result = null;
String id = request.getParameter("id");
String sso_id = EncryptSDK.decData(id);
//String sso_id = "appruser1"; 테스트 코드

System.out.println("sso_id :::: " + sso_id);
if( sso_id != null && !"".equals(sso_id) ){
	session.setAttribute("sso_id", sso_id);
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
