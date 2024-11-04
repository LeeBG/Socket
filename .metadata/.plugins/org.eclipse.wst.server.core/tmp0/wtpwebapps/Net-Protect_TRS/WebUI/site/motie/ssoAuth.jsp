<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@page import="cg.cntc.diffieHellmanKey.DHKeyExchange"%>
<%@page import="java.net.URLDecoder"%>
()
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SSO AUTH</title>
<% 

String systemId = request.getParameter("systemId");
String gatherRandom = request.getParameter("gatherRandom");

String dhKey = "";
int nRandom1 = 0;
int nRandom2 = 0;
int nPkRandom1 = 0;
int nPkRandom2 = 0;

DHKeyExchange dhKeyEx = new DHKeyExchange();

String[] gatherSplit = gatherRandom.split("#");

System.out.println("gatherRandom : " +gatherRandom);
try{
	nPkRandom1 	= Integer.parseInt(gatherSplit[0]);
	nPkRandom2 	= Integer.parseInt(gatherSplit[1]);
	nRandom1 	= Integer.parseInt(gatherSplit[2]);
	nRandom2 	= dhKeyEx.getIntRandom(DHKeyExchange.MAX_RANDOM_A) + 1;
	// 키 생성
 	dhKey = dhKeyEx.getReceiverDHKey(nPkRandom1, nPkRandom2, nRandom1, nRandom2);
	
 	session.setAttribute("dhKey", dhKey);
 	request.setAttribute("systemId", systemId);
 	request.setAttribute("random2", nRandom2);
}catch(Exception e){
	e.printStackTrace();
}
System.out.println("ssoAuth.nRandom2 : " + nRandom2);
System.out.println("ssoAuth.getSession : " + request.getRequestedSessionId());

%>
<script type="text/javascript">
window.onload = function(){
	document.form.submit();
}
</script>
</head>
<body>
<!-- <form name="form" method="post" action="/site/motie/test.lin"> -->
<form name="form" method="post" action="https://ekp.motie.go.kr/sso/createKeyResult.jsp">
	<input name="random2" value="${random2}" type="hidden" />${random2}
	<input name="systemId" value="${systemId}" type="hidden" />${systemId}
</form> 
</body>
</html>
