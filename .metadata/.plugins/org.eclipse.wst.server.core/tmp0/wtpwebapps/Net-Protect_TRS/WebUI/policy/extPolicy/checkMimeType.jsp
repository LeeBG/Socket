<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<script type="text/javascript" src="<c:url value="/JavaScript/webtoolkit.base64.js" />"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$(".leftArea").hide();
		$("#lform").get(0).submit();
	});

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/policy/extPolicy/checkExtPopup.lin" />">
<input type="hidden" id="exts" name="exts" value="${extensionForm.exts}">
<input type="hidden" id="mime_type" name="mime_type" value="${extensionForm.mime_type}">
<input type="hidden" id="existYN" name="existYN" value="${extensionForm.existYN}">
</form>
</body>
</html>