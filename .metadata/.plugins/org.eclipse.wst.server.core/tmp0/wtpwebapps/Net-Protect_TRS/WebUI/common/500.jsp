<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% response.setStatus(500);%>
<!DOCTYPE HTML>
<html>
<head>
<link href="<c:url value="/css/common.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/style.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/popup.css" />" rel="stylesheet" type="text/css" />
<body>
	<div class="wrap">
		<div class="change_pw_box" style="width: 75%;">
			<div class="mg_t20 Tborder">
				<p class="change_pw_title">내부 오류입니다.</p>
				<div class="mg_t50 change_pw_inputArea">
					<dl style="width: 80%;">
						<dt style="padding-top: 0px;">· Request URI:</dt>
						<dd><c:out value="${requestScope['javax.servlet.error.request_uri']}" /></dd>
					</dl>
					<dl style="width: 80%;">
						<dt style="padding-top: 0px;">· Exception</dt>
						<dd><c:out value="${requestScope['javax.servlet.error.exception']}" /></dd>
					</dl>
					<dl style="width: 80%;">
						<dt style="padding-top: 0px;">· Exception type</dt>
						<dd><c:out value="${requestScope['javax.servlet.error.exception_type']}" /></dd>
					</dl>
					<dl style="width: 80%;">
						<dt style="padding-top: 0px;">· Exception message</dt>
						<dd><c:out value="${requestScope['javax.servlet.error.message']}" /></dd>
					</dl>
				</div>
			</div>
			<div class="btn_area_center mg_t50 pd_t30 Tborder">
				<button type="button" class="btn_big theme" onclick="history.back();">뒤로 가기</button>
			</div>
		</div>
	</div>
</body>
</html>
