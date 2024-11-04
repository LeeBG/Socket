<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<html>
<head>
<script type="text/javascript">
$(document).ready(function() {
	$.ajax({
		url : "http://test.api.com:8080/hr/user/api/password.lin",
		contentType: "text/plain",
		type : 'PUT',
		dataType: "json",
		data: '{"users_id":"<c:out value="${id}"/>", "users_pw":"<c:out value="${passwd}"/>"}',
		cache: false,
		processData: false,
		error : function(xhr, status, error) {
			if (xhr.status == 401) {
				resultSessionExpire(xhr);
			} else if (xhr.status == 200) {
				resultInterceptorError(xhr);
			} else {
				console.log("error");
			}
		},
		success : function(result) {
			console.log(result);
		}
	});
});
</script>
</head>
<body>

</body>
</html>