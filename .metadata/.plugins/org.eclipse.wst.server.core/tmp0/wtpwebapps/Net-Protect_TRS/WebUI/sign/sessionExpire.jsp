<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="siteCode" value="${customfunc:getSiteCode()}"/>
<c:set var="goLoginBtn" value="${customfunc:getMessage('sign.sessionExpire.session.login.button')}" />
<html>
<head>
<link href="<c:url value="/css/common.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/style.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/popup.css" />" rel="stylesheet" type="text/css" />
<style type="text/css">
img{ margin-top : 0px !important;}
.top_sec{margin-top:150px;}
.notice_txt{
	margin-top:20px;
}
.notice_txt > span{
	background-color:#5c5c5c; 
	color: white;
	padding:30px;
	display: inline-block;
	font-size:1.3em;
	line-height:35px;
}
</style>
<body style="background-color:#ebebeb;">
	<div class="wrap">
			<h1 class="top_sec">
				<img alt="LOGO" src="/Images/common/info.png"/>
				<br>
				<img alt="알림이미지" src="/Images/common/info_txt.png" style="width:200px;"/>
			</h1>
			<div class="t_center notice_txt">
				<span>
					${customfunc:getMessage('common.text.title')} 시스템
					<br>
					<c:if test="${sessionAutoExpireTime ne null}">
						<spring:message code="sign.sessionExpire.session.expire" arguments="${sessionAutoExpireTime}" />
					</c:if>
					<c:if test="${sessionAutoExpireTime eq null}">
						세션이 만료되어 로그아웃되었습니다.
					</c:if>
				</span>
			</div>
			<div class="btn_area_center mg_t50 pd_t30 Tborder">
				<button type="button" class="btn_big theme" onclick="location.href='/sign/logout.lin'" style="background-color: #2980b9; border-color: #35739c;">
					${goLoginBtn}
				</button>
			</div>
	</div>
</body>
</html>
