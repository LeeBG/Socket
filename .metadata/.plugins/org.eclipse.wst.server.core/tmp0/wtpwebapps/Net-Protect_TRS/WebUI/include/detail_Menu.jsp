<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<div class="dropmenu" style="float: left; height: 100%; vertical-align: middle; padding-top: 1px;">
	<ul>
	<li><a class="menu" href="#" id="current"><img src="/Images/icon/icon_list.png"> ${param.pageName}</a>
		<ul class="sub_menu">
			<c:if test="${auth_cd eq 1}">
				<li style="border-bottom:1px solid #2c324a;"><a href="<c:url value="/trsMonitor/dashboard/dashboardView.lin" />"><span class="listStyle">·</span>TRS 현황 Dashboard</a></li>
			</c:if>
			<li style="border-bottom:1px solid #2c324a;"><a href="<c:url value="/trsMonitor/totalStatistics/totalStatisticsView.lin"/>"><span class="listStyle">·</span>전체 통계</a></li>
			<li><a href="<c:url value="/trsMonitor/userStatistics.lin"/>"><span class="listStyle">·</span>사용자별 통계</a></li>
		</ul>
	</li>
	</ul>
</div>