<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<html>
<head>
<c:choose>
	<c:when test="${networkPosition eq 'I'}">
		<c:set var="css_class" value="workPC" />
		<c:set var="liCss" value=""/>
	</c:when>
	<c:when test="${networkPosition eq 'O'}">
		<c:set var="css_class" value="workPC" />
		<c:set var="liCss" value="first-item"/>
		<c:if test="${empty sessionScope.loginUser.dept_nm}">
			<c:set var="liCss2" value="first-item"/>
		</c:if>
	</c:when>
	<c:otherwise></c:otherwise>
</c:choose>
<c:choose>
	<c:when test="${sessionScope.loginUser.auth_cd > 2}">
		<c:set var="sclass" value=""/>
	</c:when>
	<c:otherwise>
		<c:set var="sclass" value="first-item"/>
	</c:otherwise>
</c:choose>
<script type="text/javascript">
	$(document).ready(function() {
	});
</script>
<style>
	body{width:100%; height:100%; background-color:#f9f9f9; position:relative;}
	.wrap{overflow:auto;}
	.leftBox{position:fixed; top:0; left:0; width:15%; height:100%; background-color:#fff; border-right:1px solid #898989; }
	h1{width:100%; text-align:center; margin-top:30px;}
	nav{width:100%;}
	nav ul{width:78%; margin:0 auto; }
	nav ul.list01{margin-top:50px;}
	nav ul.list01>li{padding:20px 0; background:url('img/common/li_bottom_bg.gif') repeat-x 0 100%; font-size:1.1em; }
	nav ul.list01 li.last-item{background:none;}
	nav ul.list02{margin-top:10px;}
	nav ul.list02>li{font-size:0.9em; padding:4px 0;}
	.rightBox{width:85%; float:right;}
	.conWrap{width:98%; margin:0 auto; background-color:#fff; border:1px solid #bbb; border-radius:5px; -webkit-border-radius:5px; -moz-border-radius:5px; -o-border-radius:5px; }
	.conBox{overflow:auto; margin-top:-5px; background-color:#fff;}
	.conWrap.tableBox{height:700px; margin-top:10px; }
	.conWrap h3{width:99.4%; color:#fff; font-weight:bold; background:#0c5199; padding:13px 0 18px 10px; font-size:1em; border-radius:5px; -webkit-border-radius:5px; -moz-border-radius:5px; -o-border-radius:5px;}
	.conWrap.tableBox .conBox{height:93.5%;  border-top:1px solid #ddd; }
	.conWrap.tableBox .conBox2{border-top:1px solid #ddd; height:91%;  }
		.tab_box{overflow:auto; background-color:#fff;}
		.tab_box .tab{float:left; border-top:2px solid #fff; border-right:1px solid #ddd; text-align:center; padding:12px 10px; background-color:#fff;  z-index:999;}
		.tab_box .tab.on{background-color:#fff; border-top: 2px solid #1f518b; border-bottom:1px solid #fff;}
		.tab_box .tab p a{color:#ccc; line-height:1em;}
		.tab_box .tab.on p a{color:#1f518b; font-weight:bold;}
		.viewer_box{overflow-y:scroll; height:90%; border-top:1px solid #ddd; margin-top:-1px; padding-top:5px; }
	.conWrap.searchBox{height:100px; margin-top:10px;}
	.conWrap.searchBox .text_input{width:80%; height:27px; border:1px solid #ddd; margin-left:5px;}
	.conWrap.searchBox .conBox{width:100%; }
	.conWrap.searchBox .searchLine{width:90%; margin:15px auto;}
	.breadCrumbs{margin:20px 20px 0 0; text-align:right;}
</style>
</head>
<body>
</body>
</html>