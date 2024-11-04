<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />

<%-- 암호화 모듈 사용 준비 --%>
<%@include file="/WebUI/include/encryptUtil.jsp" %>

<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
<script type="text/javascript" src="/JavaScript/webtoolkit.base64.js"></script>
<script type="text/javascript" src="/JavaScript/s3iFileWSock.js"></script>
<script type="text/javascript" src="/JavaScript/module/sso.js?v=20220712"></script>
<script type="text/javascript" src="/JavaScript/common.js"></script>
<script type="text/javascript">
var moleg={
	AUTH_URL		: "http://iportal.moleg.go.kr/portal/sIdCheck.do",
	AUTH_SUCCESS	: "200",
	AUTH_FAIL		: "500",
	sid				: '${param.SID}',
	uid				: null
};

$(document).ready(function(){
	if( isAuthUrlStartWithHttps() ){
		var url = location.href.replace('https','http');
		<%--url = url.replace( '8443' ,'8081' ); // test code--%>
		location.href = url;
	}
	<%-- 테스트시 아래 함수명을 authorizeTest 변경 필요함.--%>
	authorizeMoleg();
	
	function authorizeMoleg(){
		//moleg portal로 사용자 확인
		authorizeUser( 
			login ,          <%--auth success callback--%>
			function(error){ <%-- auth fail callback --%>		
				showErrorDialog(error);
			}
		);
	}
	
	function authorizeTest(){
		authorizeTestUser( 
			login ,          <%--auth success callback--%>
			function(error){ <%-- auth fail callback --%>		
				showErrorDialog(error);
			}
		);
	}
});

function isAuthUrlStartWithHttps(){
	var now_protocol = location.protocol; 
	if( moleg.AUTH_URL.indexOf('https://') > -1 ){
		return true;
	}else if(moleg.AUTH_URL.indexOf('/') == 0 && now_protocol == 'https:'){
		return true;
	}
	
	return false;
}

function isHttps(){
	return ( location.protocol == "https:" );
}

<%-- 법제처 portal 사이트로 사용자 인증 확인 --%>
function authorizeUser( authSuccessFx, authFailFx ){
	$.ajax({
		url			: moleg.AUTH_URL+'?SID='+moleg.sid,
		dataType 	: 'xml',
		success		: function(res){checkResponse( res, authSuccessFx, authFailFx );},
		error		: showErrorDialog,
		cache		: false
	});
}
<%-- 법제처 연동 테스트  test code--%>
<%--
function authorizeTestUser( authSuccessFx, authFailFx ){
	$.ajax({
		url			: '/authorize/test.lin?site=moleg&SID='+moleg.sid,
		dataType 	: 'xml',
		success		: function(res){checkResponse( res, authSuccessFx, authFailFx );},
		error		: showErrorDialog,
		cache		: false
	});
}
--%>

<%-- 법제처에 로그인 인증 확인 --%>
function checkResponse( response , successCallback , failCallback ){
	console.log( 'auth response = ', response);
	try {
		var login_info = response.getElementsByTagName("LoginInfo")[0];
		var auth_result = login_info.getElementsByTagName("authCode")[0].firstChild.data;
		
		switch ( auth_result ) {
		case moleg.AUTH_SUCCESS:
			if( successCallback ){
				moleg.uid = login_info.getElementsByTagName("info")[0].getElementsByTagName("userId")[0].firstChild.data;
				$("#users_id").val( aesUtil.encrypt(moleg.uid) );
				successCallback();
			}
			break;
		default:
			if( failCallback ){	
				var error = { code : errorCode.LOGIN_AUTHORIZE_ERROR, data:login_info.getElementsByTagName("content")[0].firstChild.data+" code=["+auth_result+"]"};
				failCallback(error);
			}
			break;
		}
	} catch (e) {
		console.log("법제처 인증 도중 알수없는 에러 발생했음. e=",e);
		showErrorDialog({code:0});
	}
}

<%-- TRS 로그인 시도 아이디로만 로그인하는 /sign/sso.lin로 인증 --%>
function login(){
	ssoLogin( redirectToFirstPage , error, false );
	
	function redirectToFirstPage(){
		var url = "https://"+location.host;
		<%--url = url.replace('8081','8443'); // test code--%>
		location.href = url+"<c:url value="/sign/index.lin" />";
	}
	
	function error( response ){
		console.log(response);
		var error = {code:errorCode.TRS_LOGIN_ERROR,data:response};
		showErrorDialog(error);
	}
}

</script>
<style>
/*modal alert section*/
#modal_alert{position: absolute; z-index:1000; left:0; top:0; width:100%; height:100%;background:rgba(0,0,0,0.5);}
#modal_alert span{line-height:20px;padding: 20px 0;display: block;text-align:  center;color: white;font-size: 14px;width: 40%;margin: 0 30%;}
/*loading css*/
.sk-circle {
  margin: 0 auto;
  width: 70px;
  height: 70px;
  position: relative;
  margin-top: 20%;
}
.sk-circle .sk-child {
  width: 100%;
  height: 100%;
  position: absolute;
  left: 0;
  top: 0;
}
.sk-circle .sk-child:before {
  content: '';
  display: block;
  margin: 0 auto;
  width: 15%;
  height: 15%;
  background-color: white;
  border-radius: 100%;
  -webkit-animation: sk-circleBounceDelay 1.2s infinite ease-in-out both;
          animation: sk-circleBounceDelay 1.2s infinite ease-in-out both;
}
.sk-circle .sk-circle2 {
  -webkit-transform: rotate(30deg);
      -ms-transform: rotate(30deg);
          transform: rotate(30deg); }
.sk-circle .sk-circle3 {
  -webkit-transform: rotate(60deg);
      -ms-transform: rotate(60deg);
          transform: rotate(60deg); }
.sk-circle .sk-circle4 {
  -webkit-transform: rotate(90deg);
      -ms-transform: rotate(90deg);
          transform: rotate(90deg); }
.sk-circle .sk-circle5 {
  -webkit-transform: rotate(120deg);
      -ms-transform: rotate(120deg);
          transform: rotate(120deg); }
.sk-circle .sk-circle6 {
  -webkit-transform: rotate(150deg);
      -ms-transform: rotate(150deg);
          transform: rotate(150deg); }
.sk-circle .sk-circle7 {
  -webkit-transform: rotate(180deg);
      -ms-transform: rotate(180deg);
          transform: rotate(180deg); }
.sk-circle .sk-circle8 {
  -webkit-transform: rotate(210deg);
      -ms-transform: rotate(210deg);
          transform: rotate(210deg); }
.sk-circle .sk-circle9 {
  -webkit-transform: rotate(240deg);
      -ms-transform: rotate(240deg);
          transform: rotate(240deg); }
.sk-circle .sk-circle10 {
  -webkit-transform: rotate(270deg);
      -ms-transform: rotate(270deg);
          transform: rotate(270deg); }
.sk-circle .sk-circle11 {
  -webkit-transform: rotate(300deg);
      -ms-transform: rotate(300deg);
          transform: rotate(300deg); }
.sk-circle .sk-circle12 {
  -webkit-transform: rotate(330deg);
      -ms-transform: rotate(330deg);
          transform: rotate(330deg); }
.sk-circle .sk-circle2:before {
  -webkit-animation-delay: -1.1s;
          animation-delay: -1.1s; }
.sk-circle .sk-circle3:before {
  -webkit-animation-delay: -1s;
          animation-delay: -1s; }
.sk-circle .sk-circle4:before {
  -webkit-animation-delay: -0.9s;
          animation-delay: -0.9s; }
.sk-circle .sk-circle5:before {
  -webkit-animation-delay: -0.8s;
          animation-delay: -0.8s; }
.sk-circle .sk-circle6:before {
  -webkit-animation-delay: -0.7s;
          animation-delay: -0.7s; }
.sk-circle .sk-circle7:before {
  -webkit-animation-delay: -0.6s;
          animation-delay: -0.6s; }
.sk-circle .sk-circle8:before {
  -webkit-animation-delay: -0.5s;
          animation-delay: -0.5s; }
.sk-circle .sk-circle9:before {
  -webkit-animation-delay: -0.4s;
          animation-delay: -0.4s; }
.sk-circle .sk-circle10:before {
  -webkit-animation-delay: -0.3s;
          animation-delay: -0.3s; }
.sk-circle .sk-circle11:before {
  -webkit-animation-delay: -0.2s;
          animation-delay: -0.2s; }
.sk-circle .sk-circle12:before {
  -webkit-animation-delay: -0.1s;
          animation-delay: -0.1s; }

@-webkit-keyframes sk-circleBounceDelay {
  0%, 80%, 100% {
    -webkit-transform: scale(0);
            transform: scale(0);
  } 40% {
    -webkit-transform: scale(1);
            transform: scale(1);
  }
}

@keyframes sk-circleBounceDelay {
  0%, 80%, 100% {
    -webkit-transform: scale(0);
            transform: scale(0);
  } 40% {
    -webkit-transform: scale(1);
            transform: scale(1);
  }
}
</style>
</head>
<body>
<form name="lform" id="lform" method="post" action="<c:url value="/sign/sso.lin" />" onSubmit="return false;">
<input type="hidden" name="csrf" id="csrf" value=""/>
<input type="hidden" name="jsonNetworkInfo" id="jsonNetworkInfo" value = ""/>
<input type="hidden" name="users_id" id="users_id" value="" />
<input type="hidden" name="users_pw" value="encsso"/>
</form>
<%-- 알림창 --%>
<section id="modal_alert">
	<div class="sk-circle">
	  <div class="sk-circle1 sk-child"></div>
	  <div class="sk-circle2 sk-child"></div>
	  <div class="sk-circle3 sk-child"></div>
	  <div class="sk-circle4 sk-child"></div>
	  <div class="sk-circle5 sk-child"></div>
	  <div class="sk-circle6 sk-child"></div>
	  <div class="sk-circle7 sk-child"></div>
	  <div class="sk-circle8 sk-child"></div>
	  <div class="sk-circle9 sk-child"></div>
	  <div class="sk-circle10 sk-child"></div>
	  <div class="sk-circle11 sk-child"></div>
	  <div class="sk-circle12 sk-child"></div>
	</div>
	<span id="modal_alert_text">로그인 중 입니다. 잠시만 기다려주세요.</span>
</section>
</body>
</html>
