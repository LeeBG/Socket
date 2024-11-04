<%@page import="java.net.InetAddress"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<script type="text/javascript" src="/JavaScript/module/trs.cipher.js"></script>
<script type="text/javascript" src="/JavaScript/aes.js"></script>
<script type="text/javascript" src="/JavaScript/pbkdf2.js"></script>
<c:set var="AesMap" value="${customfunc:PBKDF2AESInfo()}"/>
<script type="text/javascript">
var constant = {
	en_i : '${AesMap.iv}',
	en_s : '${AesMap.salt}',
	en_p : '${AesMap.phrase}'
};
var aesUtil = new AesUtil(constant.en_s,constant.en_p,constant.en_i);
</script>
