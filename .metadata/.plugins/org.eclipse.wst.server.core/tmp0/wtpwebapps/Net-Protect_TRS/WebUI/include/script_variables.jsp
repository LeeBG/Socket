<%@ page contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<%-- 변수 초기화 --%>
<c:set var="networkPosition" value="${customfunc:getNetworkPosition() }"/>
<c:set var="basepath" value="${customfunc:encCacheString('basepath')}"/>
<c:set var="innerNetworkIp" value="${customfunc:encCacheString( (customfunc:getDuplicationServer() == '2') ? 'slaveInnerNetworkIp' : 'innerNetworkIp' )}"/>
<c:set var="outerNetworkIp" value="${customfunc:encCacheString( (customfunc:getDuplicationServer() == '2') ? 'slaveOuterNetworkIp' : 'outerNetworkIp' )}"/>
<c:set var="agentServicePort" value="${customfunc:encCacheString('agentServicePort')}"/>
<c:set var="wsFileServerPort" value="${customfunc:encCacheString('wsFileServerPort')}"/>
<c:set var="wssFileServerPort" value="${customfunc:encCacheString('wssFileServerPort')}"/>

<%-- 암호화 모듈 사용 준비 --%>
<%@include file="/WebUI/include/encryptUtil.jsp" %>

<script>
var env = {
	networkPosition : '${networkPosition}',
	basepath : '${basepath}',
	basepath_suffix : aesUtil.decrypt('${basepath}').slice(0,-1)=='/'? '' : '/',
	innerNetworkIp : '${innerNetworkIp}',
	outerNetworkIp : '${outerNetworkIp}',
	wsFileServerPort : '${wsFileServerPort}',
	wssFileServerPort : '${wssFileServerPort}',
	wsAgentPort : '${agentServicePort}',
	file : {
		one_size : '${perFileSize}',
		total_size : '${perOnceFileSize}'
	}
};
</script>