<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>

<head>
<c:choose>
	<c:when test="${grantCount > 0}">
		<c:set var="css_class" value="point01" />
	</c:when>
	<c:otherwise>
		<c:set var="css_class" value="point02" />
	</c:otherwise>
</c:choose>
<!--  	<style type="text/css">
		body {
			background-color: #FFFFFF;
			font-family: Dotum, "돋움", sans-serif;
			padding: 0px;
			margin: 0px;
		}
		.workNum {
			display:inline-block;
			padding-top:5px;
			font-size:23px;
		}
		.point01 {
			color:#f22e8b;
		}
		
	</style> -->
<style type="text/css">
  #wrap {
   width:100%;  font-family: "맑은 고딕", Malgun Gothic , dotum, Arial; font-size:15px;
  }
  .workNum {
   display:inline-block;
   padding-top:5px;
   padding-left:45px;
   font-size:23px;
  }
  .point01 {
   color:#505050 !important;
  }
  .point02 {
   color:#505050 !important;
  }
  body {
    background-color:white;
    line-height:1.5em;
  }
 </style>
<title></title>
<link rel="stylesheet" type="text/css" href="/wyzeip/html/main/css/main_17think.css" />
<script type="text/javascript" src="/wyzeip/script/jquery/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="/wyzeip/script/jquery/common.js"></script>
<script type="text/javascript" src="/wyzeip/script/jquery/main.js"></script>
<script type="text/javascript" src="/wyzeip/script/common/windowutil.js"></script>
</head>
<body>
<div id="wrap">
<ul class="workSum" >
  <span class="workNum" ><a class="${css_class}"  href="/authorize.lin?code=ftc&ptype=SSO&paction=login&USER_EKP_ID=${user_ekp_id}" target="_blank">${grantCount}</a></span>
</ul>
</div>
</body>
</html>