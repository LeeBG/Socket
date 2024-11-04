<%@page import="kr.co.s3i.sr1.common.cipher.AES256Utility"%>
<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SSO TEST</title>
<% 
	AES256Utility aes256 = new AES256Utility();

	String id = "test1"; // 사용자 id
	String code = "cnuh"; // 사이트 명
	String encid = "";
	try {
		encid = aes256.encode_PBKDF2Key(id); // 사용자 id 암호화
	} catch (Exception e) {
		e.printStackTrace();
	}
	request.setAttribute("id", encid);
	request.setAttribute("code",code );
%>
<script type="text/javascript">
window.onload = function(){
	document.form.submit();
}
</script>
</head>
<body>
<form name="form" method="post" action="/authorize.lin">
	<input name="id" value="${id}" type="hidden" />
	<input name="code" value="${code}" type="hidden" />
</form> 
</body>
</html>