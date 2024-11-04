<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<html>
<head>
<script type="text/javascript">
	$(document).ready(function() {
		location.href = "npagent://set-env?envInfo=<c:out value="${envInfo}"/>";
	});
</script>
</body>
</html>