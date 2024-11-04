<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link href="<c:url value="/css/common.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/style.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/css/popup.css" />" rel="stylesheet" type="text/css" />
<body>
	<div class="wrap">
		<div class="change_pw_box" style="width: 75%;">
			<div class="mg_t20 Tborder">
				<p class="change_pw_title">오류!</p>
				<p class="change_pw_title">로그인 정보를 찾을 수 없습니다.</p>
				<p class="change_pw_title none">
					<span>자세한 내용 : </span>
					<span>${msg}</span>
				</p>
			</div>
			<div class="btn_area_center mg_t50 pd_t30 Tborder">
				<button type="button" class="btn_big theme" onclick="history.back();">뒤로 가기</button>
			</div>
		</div>
	</div>
</body>
</html>
