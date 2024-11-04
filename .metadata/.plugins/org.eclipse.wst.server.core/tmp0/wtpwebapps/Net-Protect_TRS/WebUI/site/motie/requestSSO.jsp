<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>requestSSO</title>
</head>
<script type="text/javascript">
window.onload = function(){
	document.form.submit();
}
</script>
<%
 	String code = "in-motie";
	request.setAttribute("code",code );
	
	String step = "Authorization";
	request.setAttribute("step", step);
	
	String systemId = "systemId";
	request.setAttribute("systemId", systemId);
	
	String gatherRandom = "1#0#212";
	request.setAttribute("gatherRandom", gatherRandom);
	
%>
<body>
<form name="form" method="post" action="/authorize.lin">
	<input name="gatherRandom" value="${gatherRandom}" type="hidden" />
	<input name="systemId" value="${systemId}" type="hidden" />
	<input name="step" value="${step}" type="hidden" />
	<input name="code" value="${code}" type="hidden" />
</form> 
</body>
</html>