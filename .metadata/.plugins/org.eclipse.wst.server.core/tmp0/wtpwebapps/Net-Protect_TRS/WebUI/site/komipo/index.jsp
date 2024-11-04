<%@page import="kr.co.s3i.sr1.common.BaseCode"%>
<%@page import="kr.co.s3i.sr1.cacheEnv.cache.common.CacheUtility"%>
<%@ page contentType="text/html; charset=utf-8" %>
<% 
 if( CacheUtility.isInnerPosition() ){
	//중부발전 SSO연동 URL. 
	//SSO 로그인 성공시 세션 생성후 /sign/index.lin으로 이동, 실패시 세션을 만들지 않고 /sign/index.lin으로 이동
	response.sendRedirect("/authorize.lin?code=komipo"); 
}else{ 
	response.sendRedirect(BaseCode.USER_LOGIN_URL);
}
%>
