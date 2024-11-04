<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<div class="rightAreaTop">
	<div class="conTitleWrap">
		<div class="conTitle">
			<h2 style="font-weight:bold">${sessionScope.navi_menu_nm }</h2>
			<div class="breadCrumbs">${sessionScope.navi_nm }</div>
		</div>
	</div>
</div>