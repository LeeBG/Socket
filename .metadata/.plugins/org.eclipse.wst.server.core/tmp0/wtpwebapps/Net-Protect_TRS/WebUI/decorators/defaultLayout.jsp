<%@page import="kr.co.s3i.sr1.common.utility.CommonUtility"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<spring:theme code="CSS" var="localeCss" />
<spring:theme code="JavaScript" var="localeJavaScript" />
<!DOCTYPE HTML>
<html>
<!-- defaultLayout.jsp -->
<head>
<link rel="shortcut icon" href="<c:url value="/Images/icon/lockfavicon.ico" />?v=1" type="image/x-icon">
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="networkPosition" value="${customfunc:getNetworkPosition()}" />
<c:set var="isIE9" value="<%=CommonUtility.isIE9(request) %>" />

<c:set var="env" value="${sessionScope.envInfo}" />
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

<title>${browserTitle}</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta name="description" content="">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="<c:url value="/css/reset.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/common.css" />?ver=20220523" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/style.css" />?v=20240205" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/popup.css" />?v=20221107" rel="stylesheet" type="text/css" />
<link href="<c:url value="/Style/jquery-ui.css" />?v=190320" rel="stylesheet" type="text/css"/>
<jsp:include page="./cssImport.jsp" />
<script type="text/javascript" src="<c:url value="/JavaScript/calendar.js" />?v=221014"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/ui.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/common.js" />?v=220904"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery-ui.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.cookie.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/sess.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/moment.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.session.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.approval.lock.js" />?ver=1"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.approval.common.js" />?ver=20240215"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/common.js" />?ver=4"></script>
<c:if test="${ isIE9 }">
<link rel="stylesheet" href="/css/placeholder_polyfill.min.css">
</c:if>
<script type="text/javascript">
$(document).ready(function(){
	checkSession();
});
</script>
<decorator:head />
</head>
<body>
<!-- wrap -->
<%-- <page:applyDecorator page="/WebUI/common/header.jsp" name="panel" /> --%>
<div id="wrap">
	<page:applyDecorator page="/WebUI/common/userLeft.jsp" name="panel" />
	<page:applyDecorator page="/WebUI/common/userTop.jsp" name="panel" />
	<decorator:body />
	<c:if test="${ isIE9 }">
	<jsp:include page="../common/include/ie9_body.jsp" />
	</c:if>
</div>
<!-- //wrap -->
</body>
</html>
