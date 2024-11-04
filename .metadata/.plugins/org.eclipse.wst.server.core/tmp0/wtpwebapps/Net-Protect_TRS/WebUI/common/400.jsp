<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% response.setStatus(400);%>
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
				<p class="change_pw_title">HTTP 의 규약에 맞지않는 요청을 하셨습니다.</p>
				<p class="change_pw_title">다시 시도해 주세요.</p>
			</div>
			<div class="btn_area_center mg_t50 pd_t30 Tborder">
				<button type="button" class="btn_big theme" onclick="history.back();">뒤로 가기</button>
			</div>
		</div>
	</div>
</body>
</html>
