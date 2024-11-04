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
<link href="<c:url value="/css/trsMonitor/reset.css" />?ver=1" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/trsMonitor/common.css" />?ver=4" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/trsMonitor/style.css" />?v=20201203" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/popup.css" />?v=20221107" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/trsMonitor/theme_total.css" />?v=20" rel="stylesheet" type="text/css" />
<link href="<c:url value="/Style/jquery-ui.css" />?v=190320" rel="stylesheet" type="text/css"/>
<link href="<c:url value="/css/trsMonitor/theme_user.css" />?v=20220104" rel="stylesheet" type="text/css" />
<link href="<c:url value="/Style/ui.jqgrid.css" />?ver=1" rel="stylesheet" type="text/css"/>
<jsp:include page="./cssImport.jsp" />
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.jqgrid.js" />?v=20221103"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/calendar.js" />?v=20221014"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/ui.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/trsMonitor/common.js" />?v=201215"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery-ui.js" />?v=20220223"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.cookie.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/sess.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/moment.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.session.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.approval.lock.js" />?ver=1"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.approval.common.js" />?ver=20221013"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/trsMonitor/htmlappend.js" />?ver=3"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/grid.locale-kr.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.jqGrid.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.graph.js" />?v=20220223"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.call.js" />?v=20220223"></script>
<script type="text/javascript">
$(document).ready(function(){
	checkSession();
});
</script>
<decorator:head />
</head>
<body bgcolor="2a2948">
<!-- wrap -->
<div id="wrap" class="detail-page">
	<decorator:body />
</div>
<!-- //wrap -->
</body>
</html>
