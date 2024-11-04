<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="networkPosition" value="${customfunc:getNetworkPosition() }"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>장애 팝업 공지</title>
</head>
<body>
	<c:if test="${networkPosition eq 'I'}">
		<c:choose>
			<c:when test="${not empty in_bf_login_notice}">
				${in_bf_login_notice}
			</c:when>
			<c:otherwise>
				결과가 없습니다.
			</c:otherwise>
		</c:choose>
	</c:if>
	<c:if test="${networkPosition eq 'O'}">
		<c:choose>
			<c:when test="${not empty out_bf_login_notice}">
				${out_bf_login_notice}
			</c:when>
			<c:otherwise>
				결과가 없습니다.
			</c:otherwise>
		</c:choose>
	</c:if>
</body>
</html>