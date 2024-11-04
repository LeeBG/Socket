<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<html>
<head>
<link rel="shortcut icon" href="<c:url value="/Images/icon/lockfavicon.ico" />?v=1" type="image/x-icon">
<!-- sessionExpire.jsp -->
<script type="text/javascript">
	function go() {
		location.href = "<c:url value="/sign/index.lin" />";
	}
</script>
</head>
<body>
<div id="content" style="margin-top: 130px;"> 
	<div class="frist_login_notice bg01" style="padding-top: 350px;">
		<div class="tpadding15 text_bold" style="font-size:1.3em;line-height:1.5em;">
			<span>
			<spring:message code="sign.sessionExpire.session.expire" arguments="${sessionAutoExpireTime}" />
			</span>
		</div>
		<div class="t_center mg_t30">
			<button type="submit" class="btn_chk_st01 btn_msg_ok" onClick="go();">
				<span class="ir_desc">확인</span>
			</button>
		</div> 
	</div>
</div>
</body>
</html>
</body>
</html>