<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
<script type="text/javascript" src="/JavaScript/module/common.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	checkAgentStatus();
});

function checkAgentStatus(){
	s3i_wsAgentConnect(installUI, close, onMessage, nonInstallUI);
}

function controlModal( show_hide_code , text ){
	var modal_alert_dom = document.getElementById("modal_alert");
	if( text ){
		changeInnerHtml( document.getElementById("modal_alert_text") , text );
	}
	if( show_hide_code == 'show' ){
		showUI( modal_alert_dom );
	}
	if( show_hide_code == 'hide' ){
		hideUI( modal_alert_dom );
	}
}

function executeAgentAndRetryFromDownloadPage(){
	executeAgentAndTryReconnectPerEvenryTwoSeconds(installUI, close, onMessage, nonInstallUI);
}

function installUI(){
	hideModal();
	changeTextAndButton(true);
}

function nonInstallUI(){
	hideModal();
	changeTextAndButton(false);
}

function close(){
	//connect -> wsclose 될때 (Agent가 종료, 미실행시 발생)
	if( isIE() ){
		clearReconnectInterval();
		nonInstallUI();
	}
	console.log("disConnected.....");
}

function onMessage( res ){
	console.log('agent로 부터 메세지 수신 =>',res);
}

function hideModal(){
	controlModal( 'hide' );
}

function changeTextAndButton( isInstalled ){
	var $agent_text = $("#agent_status");
	$("#agent_button").find('input').addClass('none');
	if( isInstalled ){
		$agent_text.text( "설치됨" );
		$("#agent_button").find('.install').removeClass('none');
	}else{
		$agent_text.text( "미설치" );
		$("#agent_button").find('.noninstall').removeClass('none');
	}
}

function executeAgentAfterFewSeconds( seconds ){
	setTimeout( executeAgentAndRetryFromDownloadPage , seconds * 1000 );
}
</script>
<link href="/css/common.css" rel="stylesheet" type="text/css" />
<link href="/css/style.css" rel="stylesheet" type="text/css" />
<link href="/css/popup.css" rel="stylesheet" type="text/css" />
<style>
body{ line-height:inherit;}
h1{ text-align: left; font-weight:bold;}
table{width:100%; margin-top: 10px; border-collapse:collapse;}
table tr{border2px solid black !important;}
table td{text-align: center; border:1px solid #afafaf; padding: 10px 0px;}
table td,input{font-family:NanumGothicRegular,"맑은 고딕",Dotum,Helvetica,AppleGothic,Sans-serif;}
.title{border-top:2px solid black !important;}
.title td{font-weight:bold; border-top:2px solid black !important;}
#agent_status{font-weight:bold;}
table input[type='button'],.java_button{background: linear-gradient(#828282,#4a4a4a); color: white; padding: 5px; border:none; border-radius: 3px; cursor:pointer;}
.navy_border{border-top:3px solid #0c5199 !important;}
.r_border_none{border-right:none;}
.l_border_none{border-left:none;}
.change_pw_title{font-size:1.5em !important;margin-top:25px !important; margin-bottom:40px;}
.caption{font-size:2em;}
.content td{ color: #616161;}
.l_button{margin-right:20px;}
.java_button{float:right; padding:5px !important; border:none !important;}
#ie_http_notice{ color: black; font-size:0.8em; font-weight:normal !important;}

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
<%-- 다운로드 프로그램 안내 --%>
<div class="wrap">
	<div class="change_pw_box" style="width: 75%;">
		<div>
			<button class="btn_small java_button" onClick="jreDownload();">
				JAVA 다운로드
			</button>
		</div>
		<h1>${customfunc:getMessage('common.text.title')} 시스템 필수 프로그램 안내</h1>
		<div class="mg_t20 Tborder navy_border">
			<p class="change_pw_title">
			아래와 같은 프로그램 설치가 필요합니다.<br>
			프로그램 설치후 새로고침하여 설치현황을 확인해주세요.<br>
			아래 설치현황에 설치가 모두 완료된 경우 메인페이지로 버튼을 클릭하여 이동합니다.<br>
			<%--
			<br>
			<span id="ie_http_notice">
			주의! InternetExploler인 경우, 프로그램 실행 전 옵션을 먼저 확인해주세요.<br>
			 - 인터넷옵션 > 보안 > 로컬인트라넷 > 사이트 클릭 > 다른 영역에 없는 로컬(인트라넷) 사이트를 모두 포함 설정 을 해제해주세요.
			</span>
			 --%>
			</p>
			<strong class="caption">보안 필수 프로그램</strong>
			<table>
				<tr class="title">
					<td class="l_border_none">프로그램명</td>
					<td>내용</td>
					<td>설치현황</td>
					<td class="r_border_none">설치관리</td>
				</tr>
				<tr class="content">
					<td class="l_border_none">Net-ProtectAgent</td>
					<td>파일데이터 암호화 및 전송 프로그램입니다.</td>
					<td id="agent_status">
						미설치
					</td>
					<td id="agent_button" class="r_border_none">
						<input type="button" class="noninstall none" value="다운로드" onclick="agentDownload(); executeAgentAfterFewSeconds();">
						<input type="button" class="noninstall none" value="실행하기" onclick="executeAgentAndRetryFromDownloadPage();">
						<input type="button" class="install none" value="다시설치하기" onclick="agentDownload();">
					</td>
				</tr>
			</table>
		</div>
		<div class="btn_area_center mg_t50 pd_t30">
			<button type="button" class="btn_big theme l_button" onclick="location.reload();">새로고침</button>
			<button type="button" class="btn_big theme" onclick="javascript:location.href='/'">메인페이지로</button>
		</div>
	</div>
</div>
	
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
	<span id="modal_alert_text">보안프로그램 확인중입니다.<br>잠시만 기다려주세요.</span>
</section>
</body>
