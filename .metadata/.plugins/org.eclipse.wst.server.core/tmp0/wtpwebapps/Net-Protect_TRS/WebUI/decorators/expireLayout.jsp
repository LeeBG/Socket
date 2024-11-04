<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<spring:theme code="CSS" var="localeCss" />
<spring:theme code="JavaScript" var="localeJavaScript" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<link rel="shortcut icon" href="<c:url value="/Images/icon/lockfavicon.ico" />?v=1" type="image/x-icon" />
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="networkPosition" value="${customfunc:getNetworkPosition()}" />

<!-- expireLayout.jsp -->
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
<link href="<c:url value="/css/common.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/style.css" />?v=20221107" rel="stylesheet" type="text/css" />
<jsp:include page="./cssImport.jsp" />
<link href="<c:url value="/css/calendar.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/Style/jquery-ui.css" />" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/common.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery-ui.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.cookie.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/sess.js" />"></script>
<decorator:head />
</head>

<body>
<!-- wrap -->
<div id="wrapper">
	<page:applyDecorator page="/WebUI/common/header.jsp" name="panel" />

	<div id="container">
		<!-- contents -->
		<decorator:body />
		<!-- contents -->
	</div>
	<!-- //container -->
</div>
<!-- //wrap -->
<%-- <!-- footer -->
	<div id="footer">
		<page:applyDecorator page="/WebUI/common/footer.jsp" name="panel" />
	</div>
	<!-- //footer --> --%>
<!-- //footer -->
</body>
</html>
