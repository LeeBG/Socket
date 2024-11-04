<%@ page contentType="text/html; charset=utf-8" %>
<%@page import="kr.co.s3i.sr1.cacheEnv.cache.common.CacheUtility"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="getSiteCode" value="${customfunc:getSiteCode()}" />
<c:set var="getUsePathTxt" value="${customfunc:getMessage('use.path.text')}" />


<html>
<head>
<script>
	function ssoLogin() {
		window.location.href = '/sso/business.jsp';
	}
	
	function manualLogin() {
		window.location.href = '/force/sign/index.lin';
	}
	
	function portalLogin() {
		window.location.href = '/force/sign/index.lin';
	}
	
	
</script>
<style type="text/css">
.img_caption{font-size:20px; font-weight:bold; color: #ff6a00;}
.errorMsg_box dl{padding:5px 0 7px 0; width:100%; position:relative; margin-top:100px; text-align:center;}
.errorMsg_box dt{padding-top:15px;}
.errorMsg_box dd{padding:30px; background-color:#5c5c5c; text-align:center; font-size:1.3em; display:inline-block; border:1px solid #ddd; color:#ffffff; margin-bottom:30px;}
.topWarp{height:31px;}
.errorMsg{line-height:35px;}
.errorMsg .point{color:#ff984e;}
.back_btn{margin-top:30px;background: #5c5c5c; color: white; padding:5px; border-radius:5px;}
</style>
</head>

<body>
<div class="box_type05 errorMsg_box">
	<div class="topWarp">
		<div class="titleBox">
		</div>
	</div>
	<dl>
		<dt class="mg_b30">
			<img src="<c:url value="../../../Images/common/warning.png" />" alt="경고이미지" />
			<br>
			<img src="<c:url value="../../../Images/common/warning_txt.png" />" alt="시스템오류"  style="width:160px;"/>
		</dt>
		<dd>
			<span class="errorMsg">
				보안상 로그인 페이지를 표시할 수 없습니다.
				<br>
				<span class="point"> ${getUsePathTxt} 통해 로그인 후 ${customfunc:getMessage('common.text.title')} 사용이 가능합니다.</span>
			</span>
		</dd>
	</dl>
	<c:if test="${getSiteCode eq 'kbcard'}">
		<div class="t_center">
			<button type="button" class="btn_sso_login" onClick="ssoLogin();">
				<span>SSO 로그인</span>
			</button>
		</div>
	</c:if>
	<c:if test="${getSiteCode eq 'kcredit'}">		
		<div class="t_center">
			<button type="button" class="btn_sso_login" onClick="manualLogin();">
				<span>수동 로그인</span>
			</button>
		</div>
	</c:if>
	<%-- 
	<div class="t_center">
		<button type="button" class="back_btn" onClick="history.back();">
			<span>뒤로가기</span>
		</button>
	</div>
	--%>
</div>
</body>
</html>


