<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<html>
<head>
<script type="text/javascript">
	$(document).ready(function() {
		$("#lform").get(0).submit();
	});
</script>
</head>
<body>
<form id="lform" name="lform" method="post" action="<c:url value="/configuration/dataLink/policy/mimeTypeCheck.lin" />">
<input name="mime_type" id="mime_type" type="hidden" value="${mimeTypeForm.mime_type}"/>
<input name="fileName" id="fileName" type="hidden" value="${mimeTypeForm.fileName}"/>
<input name="extension" id="extension" type="hidden" value="${mimeTypeForm.extension}"/>
<input name="duplicateMimeType" id="duplicateMimeType" type="hidden" value="${mimeTypeForm.duplicateMimeType}"/>
</form>
</body>
</html>