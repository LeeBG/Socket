<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.lang.*,java.math.*" %>
<%@ page import="java.security.*" %>
<%@ page import="com.innorix.servlet.multipartrequest.MultipartRequest" %>
<%@ page import="com.innorix.servlet.compress.Compress" %>
<%@ page import="com.innorix.servlet.integrity.Integrity" %>
<%@ page import="com.innorix.servlet.transfer.InnorixTransfer" %>

<%
// 파일이 저장될 서버측 디렉토리(전체경로)
 String saveDir = "C:/upload/data";

// 파일이 저장될 서버측 디렉토리(풀경로)
//String saveDir = delimiterReplace(request.getRealPath(request.getServletPath()));
saveDir = saveDir.substring(0, saveDir.lastIndexOf("/") + 1) + "data";

int maxPostSize = 2147483000;

InnorixTransfer innoTransfer = new InnorixTransfer(request, response, maxPostSize, "UTF-8", saveDir);

String result = innoTransfer.Save();
%>

<%!
private String delimiterReplace(String fullDir)
{
	String ret1 = fullDir.replaceAll("\\\\+", "/");
	String ret2 = ret1.replaceAll("\\/+", "/");

	return ret2;
}
%>
