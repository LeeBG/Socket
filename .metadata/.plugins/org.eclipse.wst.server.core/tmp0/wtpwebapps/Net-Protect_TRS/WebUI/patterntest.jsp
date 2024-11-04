<%@page import="kr.co.s3i.sr1.common.utility.CommonUtility"%>
<%@page import="java.net.InetAddress"%>
<%@ page contentType="text/html; charset=utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>pattern test page</TITLE>
</HEAD>

<BODY>
<%
String serverIp = request.getRequestURL()+"";
serverIp = serverIp.replace("http://", "").replace("/WebUI/patterntest.jsp", "");
%>
	server IP : <%=serverIp %><br />
	host IP   : <%=CommonUtility.getClientIp(request) %><br />
	receive message : <%=(String)request.getParameter("command") %><br />
</BODY>
</HTML>
