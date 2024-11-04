<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="isApprovalUse" value="${ '' ne approverArray || '' ne selfApproval }" />
<!DOCTYPE html>
<html>
<head>
<%
String array = (String)request.getAttribute("approverArray");
String self = (String)request.getAttribute("selfApproval");
System.out.println("isApprovalUse="+("".equals(array)|| "".equals(self)) );
String recomment = URLEncoder.encode((String)request.getAttribute("comment"), "UTF-8");
String retitle = URLEncoder.encode((String)request.getAttribute("title"), "UTF-8");
%>
<%-- 암호화 모듈 사용 준비 --%>
<%@include file="/WebUI/include/encryptUtil.jsp" %>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.approval.common.js" />"></script>
<script type="text/javascript">
	var u_id = '${customfunc:pbkdfEncodedString(loginUser.users_id)}';
	$(document).ready(function() {
		var app_manager = new ApprovalManager();
		app_manager.setMustChooseApprover('${isApprovalUse}','${selfApproval}',"${approverArray ne ''}");
		
		if( app_manager.getMustChooseApprover() ){
			app_manager.saveLastApprover('${approverArray}');
		}
		
		resultCheckInnorix();
		setTimeout(function() { 
			location.href="/data/file/sendList.lin"
		}, 4000);
		
	});

	function resultCheckInnorix () {
		var comment = '<%=recomment%>';
		var title = '<%=retitle%>';
		comment = comment.replace(/\+/gi, '%20');
		title = title.replace(/\+/gi, '%20');
		$.ajax({
			type : "post",
			url : "/data/file/fileSendComplete.lin",
			data : {jsonLastfileList: '${jsonLastfileList}', approverArray : '${approverArray}',
			title : decodeURIComponent(title), afterApproval : '${afterApproval}', selfApproval : '${selfApproval}', comment : decodeURIComponent(comment), csrf : '${loginUser.csrf}'},
			dataType : "json",
			error : function(xhr, status, error) {
				if (xhr.status == 401) {
					resultSessionExpire(xhr);
				} else if (xhr.status == 200) {
					resultInterceptorError(xhr);
				} else {
					resultError(error);
				}
			}
		});
	}

</script>
<style type="text/css">
.img_caption{font-size:30px; font-weight:bold; color: #ff6a00;}
.watingMsg_box dl{padding:5px 0 7px 0; width:100%; position:relative; margin-top:100px; text-align:center;}
.watingMsg_box dt{padding-top:15px; text-align:center;}
.watingMsg_box dd{padding:30px;  text-align:center; font-weight:bold; font-size:1.7em; display:inline-block;  color:#3399ff; margin-bottom:30px; margin-right:30px;}
.topWarp{height:31px;}
.watingMsg{line-height:35px;}
.watingMsg .point{color:#ff984e;}
.back_btn{margin-top:30px;background: #5c5c5c; color: white; padding:5px; border-radius:5px;}
</style>
</head>
<body>
	<div class="box_type05 watingMsg_box">
	<div class="topWarp">
		<div class="titleBox">
		</div>
	</div>
	<dl>
		<dt class="mg_b30">
			<img src="<c:url value="../../../Images/fileUpload/loading.gif" />" alt="자료전송중입니다..."  style="width:160px;"/>
		</dt>
			<dd>
				<span class="watingMsg">
					자료전송중입니다.</br>
					잠시만 기다려주세요
				</span>
			</dd>
	</dl>
	</div>
</body>
</html>
