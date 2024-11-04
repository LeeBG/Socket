<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SSO TEST</title>
<% 
	Object dhKeyObj = request.getAttribute("dhKey");
	String dhKey = dhKeyObj.toString();
	session.setAttribute("dhKey", dhKey);
	System.out.println("test.dhKey : " + dhKey);
	System.out.println("test.sessionId : " + request.getRequestedSessionId());
	String pCode="appruser1"; //<-id 입력
	request.setAttribute("pCode", pCode);
	String code = "in-motie";
	request.setAttribute("code",code );
%>
<script type="text/javascript">
window.onload = function(){
	document.form.submit();
}
</script>
</head>
<body>
<form name="form" method="post" action="/authorize.lin">
	<input name="code" value="${code}" type="hidden" />${code}
	<input name="pCode" value="${pCode}" type="hidden" />${pCode}
</form> 
</body>
</html>
