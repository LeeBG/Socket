<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<!-- userTop.jsp -->
<c:set var="systemCode" value="${sessionScope.loginUser.system_cd}" /><!-- T, S -->
<c:set var="getNetworkPosition" value="${customfunc:getNetworkPosition()}" /><!-- I, O -->
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />
<c:set var="getSiteCode" value="${customfunc:getSiteCode()}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<html>
<head>
</head>
<body>
	<div class="topArea">
		<div class="top_page_icon">
			<img src="/Images/icon/icon_page_${getNetworkPosition}_white.png">
		</div>
		<div class="top_title">
			<c:if test="${auth_cd eq 5}">
				<c:choose>
					<c:when test="${getSiteCode eq 'komsco'}">
						망간 자료전송
					</c:when>
					<c:when test="${getSiteCode eq 'kins'}">
						<c:if test="${getNetworkPosition eq 'I'}">${INNER}</c:if>
						<c:if test="${getNetworkPosition eq 'O'}">${OUTER}</c:if> ${customfunc:getMessage('common.text.title.kins')} 시스템
					</c:when>
					<c:otherwise>
						<c:if test="${getNetworkPosition eq 'I'}">${INNER}</c:if>
						<c:if test="${getNetworkPosition eq 'O'}">${OUTER}</c:if> ${customfunc:getMessage('common.text.title')} 시스템
					</c:otherwise>
				</c:choose>
			</c:if>
			<c:if test="${auth_cd eq 1 || auth_cd eq 3 || auth_cd eq 4}">
				${customfunc:getMessage('common.text.title')} 시스템 관리자
			</c:if>
		</div>
	</div>
</body>
</html>
