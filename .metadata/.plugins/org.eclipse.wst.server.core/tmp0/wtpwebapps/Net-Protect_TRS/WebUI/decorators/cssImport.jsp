<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<!-- cssImport.jsp -->
<c:set var="cssUrl" value="${sessionScope.cssUrl }" />
<!-- CssnetworkPosition = ${CssnetworkPosition } -->
<!-- cssUrl = ${cssUrl } -->
<!-- cssNum = ${cssNum } -->
<!-- adminCssNum = ${adminCssNum } -->
<!-- inCssNum = ${inCssNum } -->
<!-- outCssNum = ${outCssNum } -->
<c:if test="${cssUrl != '' }">
<link href="<c:url value="${cssUrl }" />" rel="stylesheet" type="text/css" />
</c:if>