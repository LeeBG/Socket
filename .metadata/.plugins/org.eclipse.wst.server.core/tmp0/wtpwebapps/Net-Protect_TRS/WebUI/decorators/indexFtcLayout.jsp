<%@page import="kr.co.s3i.sr1.common.utility.CommonUtility"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<spring:theme code="CSS" var="localeCss" />
<spring:theme code="JavaScript" var="localeJavaScript" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<link rel="shortcut icon" href="<c:url value="/Images/icon/lockfavicon.ico" />?v=1" type="image/x-icon" />
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="networkPosition" value="${customfunc:getNetworkPosition()}" />
<!-- indexLayout.jsp -->
<c:set var="env" value="${sessionScope.envInfo}" />
<c:set var="isIE9" value="<%=CommonUtility.isIE9(request) %>" />
<c:choose>
	<c:when test="${loginUser.auth_cd < 5 }">
		<c:set var="browserTitle" value="${env.admin_title }" />
	</c:when>
	<c:otherwise>
		<c:if test="${networkPosition eq 'I' }">
			<c:set var="browserTitle" value="${env.user_in_title }" />
		</c:if>
		<c:if test="${networkPosition eq 'O' }">
			<c:set var="browserTitle" value="${env.user_out_title }" />
		</c:if>
	</c:otherwise>
</c:choose>
<c:if test="${empty browserTitle}">
	<c:choose>
		<c:when test="${customfunc:cacheString('initMod') eq 'T'}">
			<c:set var="browserTitle" value="자료전송 시스템" />
		</c:when>
		<c:otherwise>
			<c:set var="browserTitle" value="스트리밍 시스템" />
		</c:otherwise>
	</c:choose>
</c:if>
<title>${browserTitle}</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<c:set var="requestURI" value="${pageContext.request.requestURI}"/>
<link href="<c:url value="/css/new_login.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/style.css" />?v=20221107" rel="stylesheet" type="text/css" />
<jsp:include page="./cssImport.jsp" />
<script type="text/javascript" src="<c:url value="/JavaScript/${localeJavaScript}" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
<c:if test="${ isIE9 }">
<link rel="stylesheet" href="/css/placeholder_polyfill.min.css"></link>
</c:if>
<decorator:head />
</head>

<body>
	<decorator:body />
	<c:if test="${ isIE9 }">
	<jsp:include page="../common/include/ie9_body.jsp" />
	</c:if>
</body>
</html>
