<%@page import="kr.co.s3i.sr1.common.utility.CommonUtility"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<link rel="shortcut icon" href="<c:url value="/Images/icon/lockfavicon.ico" />?v=1" type="image/x-icon"/>
<!-- printable.jsp -->
<c:set var="isIE" value="${customfunc:isIE(pageContext.request)}" />
<c:set var="isIE9" value="<%=CommonUtility.isIE9(request) %>" />
<c:set var="getNetworkPosition" value="${customfunc:getNetworkPosition()}" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link href="<c:url value="/css/popup.css?v=20221107" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/style.css" />?v=20221107" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/common.css" />" rel="stylesheet" type="text/css" />
<jsp:include page="./cssImport.jsp" />
<link href="<c:url value="/Style/jquery-ui.css" />" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/common.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery-ui.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.cookie.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/sess.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/moment.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.session.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.approval.lock.js" />"></script>
<c:if test="${ isIE9 }">
<link rel="stylesheet" href="/css/placeholder_polyfill.min.css"/>
</c:if>
<script type="text/javascript">
$(document).ready(function(){
	checkSession();
});
</script>
<decorator:head />
</head>

<body>
<div style="width:95%; margin:15px auto; ">
<decorator:body />
<div id="wrap">
<c:if test="${ isIE9 }">
	<jsp:include page="../common/include/ie9_body.jsp" />
</c:if>
</div>
</div>
</body>
</html>
