<%@page import="kr.co.s3i.sr1.common.cipher.AES128Utility"%>
<%@ page
	language="java"
	contentType="text/html;charset=utf-8"
	import="java.util.*"
%>
<%@ page import="com.initech.eam.nls.*" %>
<%@ page import="com.initech.eam.smartenforcer.*" %>
<%@ page import="com.initech.eam.nls.command.*" %>
<%@ page import="java.util.UUID"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<!DOCTYPE html>
<html>
<%@ include file="config.jsp" %>
<head>
	<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
	<script type="text/javascript" src="/JavaScript/webtoolkit.base64.js"></script>
	<script type="text/javascript" src="/JavaScript/module/sso.js"></script>
	<script type="text/javascript" src="/JavaScript/common.js"></script>
</head>
<%
	AES128Utility aesUtility = null;

	// 쿠키 암호화 적용
	CookieManager.setEncStatus(false);
	
	String sso_id = null;
	String uurl = null;
		
	//1.SSO ID 수신
	sso_id = getSsoId(request);
	
	//2.UURL 수신
	uurl = request.getParameter("UURL");
	
	System.out.println("*================== [login_exec.jsp]  sso_id = "+sso_id);
	System.out.println("*================== [login_exec.jsp]  uurl ="+uurl);
 	if (sso_id == null) {
		//3.SSO ID 가 없다면 로그인 페이지로 이동
		if (uurl == null)	uurl = ASCP_URL;
		goLoginPage(response, uurl);
		return;
	} else {
		
		//4.쿠키 유효성 확인 :0(정상)
		String retCode = getEamSessionCheck(request,response);
		if(!retCode.equals("0")){
			goErrorPage(response, Integer.parseInt(retCode));	
			return;
		}
		//5.업무시스템에 읽을 사용자 아이디를 세션으로 생성
		String EAM_ID = (String)session.getAttribute("SSO_ID");
		if(EAM_ID == null || EAM_ID.equals("")) {
			session.setAttribute("SSO_ID", sso_id);
		}
		
	 	try{
			aesUtility = new AES128Utility();
	 	 	sso_id=aesUtility.encode_PBKDF2Key(sso_id);
	 	}catch(Exception e){
	 	 	System.out.println( "암호화 중 오류 발생");
	 	}

		//6.업무시스템 페이지 호출(세션 페이지 또는 메인페이지 지정)  --> 업무시스템에 맞게 URL 수정!
		//response.sendRedirect("/app2/index.jsp");
	}
%>

<script type="text/javascript">
// ajax 로 /sign/sso.lin 호출
//응답받으면 200(성공)인경우 sign/index.lin으로 ㄱㄱ
//그외에는 에러메세지
var sso_id = '<%=sso_id%>';
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
		<input type = "hidden" name="users_id" value="<%=sso_id%>" />
		<input type = "hidden" name="users_pw" value="encsso"/>
	</form>
</body>
</html>
