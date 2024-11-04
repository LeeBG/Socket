<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%@page import="gov.mogaha.gkmc.main.servlet.portal.sso.aria.ARIAProvider"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<%@page import="com.ubintis.common.util.JsonParse"%>

<%@ page import="com.ubintis.api.ApiUserService" %>
<%@ page import="com.ubintis.common.util.AddressUtil" %>
<%@ page import="com.ubintis.common.util.StrUtil" %>
<%@ page import="com.ubintis.framework.config.AgentConfig" %>
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
	String userData = "";
	String user_id = null;
	
	//parameter 에서 인증 토큰 획득
	String pni_token = StrUtil.NVL( request.getParameter( "pni_token" ) );
	String local_ip = "";
	System.out.println("*===== pni_token =====* " + pni_token);
	
	if( "".equals( pni_token ) ) {
		//parameter 에서 인증 토큰 획득 실패시 session에서 획득(통합 로그인시)
		pni_token = StrUtil.NVL( session.getAttribute( "pni_token" ) );
	}
	
	if( !"".equals( pni_token ) ) {
		local_ip = AddressUtil.getClientIp( request );
		
		//API를 이용하여 토큰으로 사용자 정보 조회
		ApiUserService service = new ApiUserService();
		errorCode = service.executeUserData( pni_token, local_ip );
		System.out.println("*===== errorCode =====*" + errorCode);

		if( "".equals( errorCode ) ) {
			userData = service.getUserData();
		}
	}else{
		errorCode = "TOKENERR";
	}
	
	//테스트코드!!
	//userData = "{\"user_id\":\"1test\",\"user_nm\":\"테스트\"}";
	//연동 테스트 후 제거 예정
	System.out.println("*===== userData =====* "+ userData);
	
	if (!"".equals(userData)) {
		HashMap loginDataMap = JsonParse.parse( userData );
		user_id = StrUtil.NVL(loginDataMap.get("userid"));
	}

	System.out.println("*===== user_id =====* "+ user_id);
	
	if( user_id != null && !"".equals(user_id) ){
		session.setAttribute("sso_id", user_id);
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
