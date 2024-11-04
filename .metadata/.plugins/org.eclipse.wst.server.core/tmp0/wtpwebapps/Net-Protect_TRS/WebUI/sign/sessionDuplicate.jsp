<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="siteCode" value="${customfunc:getSiteCode()}"/>
<html>
<head>
<c:set var="env" value="${sessionScope.envInfo}" />
<!-- LOG_FPATH, LOG_FNAME -->
<c:set var="logoUrl" value="/Images/common/logo_s3i.gif" />
<script type="text/javascript">
	function go() {
		location.href = "<c:url value="${url}" />";
	}
</script>
</head>
<body>
<div class="wrap">
	<div class="change_pw_box">
		<h1 class="t_left"><img src="${logoUrl}" alt="logo" title="logo" width="225" /></h1>
		<div class="mg_t20 Tborder">
			<p class="change_pw_title"></p>
			<p class="change_pw_info mg_t20 t_center">
				<c:choose>
					<c:when test="${isAdminKickOut }">
						다른 관리자 (${adminUsersId })가 로그인되어 접속이 종료 되었습니다.
					</c:when>
					<c:otherwise>
						다른 PC (${ip})에서 로그인되어 접속이 종료 되었습니다.
					</c:otherwise>
				</c:choose>
			</p>
		</div>
		<div class="btn_area_center mg_t50 pd_t30 Tborder">
			<button type="button" class="btn_big theme" onclick="go();">확인</button>
		</div>
	</div>
</div>
</body>
</html>
</body>
</html>
