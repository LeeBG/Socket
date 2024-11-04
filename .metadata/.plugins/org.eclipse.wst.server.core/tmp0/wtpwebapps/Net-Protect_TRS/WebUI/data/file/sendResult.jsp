<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<html>
<head>
<c:set var="network_position" value="${loginUser.network_position}" />
<c:set var="tSize" value="0" />
<script type="text/javascript">
	$(document).ready(function() {
		//sendMessage();
	});

	function go() {
		location.href = "<c:url value="/data/file/sendForm.lin" />";
	}

	function sendMessage() {
		var approverId = '${approverId}';
		if (approverId != "") {	// 결재자 있는 경우만 메신저 알람 요청
			var form = document.lform;
	
			form.action = "<c:url value="/data/file/sendMessanger.lin" />";
			form.target = "messangerFrame";
			form.submit();
		}
	}
</script>
</head>
<body>

<form id="lform" name="lform" method="post" onSubmit="return false;">
<input type="hidden" name="approverId" id="approverId" value="${approverId}" />
<div id="contentPageHeader">
	<div id="contentPageTitle">
		<h3><spring:message code="data.file.sendForm.title" /></h3>
	</div>
	<div id="contentPageLocation">
		<ul>
			<li class="Lfirst"><span>자료전송</span></li>
			<li class="Llast"><span><spring:message code="data.left.data.send.${network_position}" /></span></li>
		</ul>
	</div>
</div>
<div class="box_type05 mg_t30 sendData_detail_box">
	<dl>
		<c:choose>
			<c:when test="${isDirectSend eq 'true'}">
				<dt class="mg_b30"><img src="<c:url value="/Images/contents/sendFile_chk.gif" />" alt="자료전송이 완료되었습니다" /></dt>
			</c:when>
			<c:otherwise>
				<dt class="mg_b30"><img src="<c:url value="/Images/contents/sendFile_approval_chk.gif" />" alt="결재 대기 중입니다" /></dt>
			</c:otherwise>
		</c:choose>
		<dd>
			<div class="scroll_area_title">
				<span class="fileName"><spring:message code="data.file.fileSendComplete.list.file.name" /></span> 
				<span class="fileVolume"><spring:message code="data.file.fileSendComplete.list.file.size" /></span>
			</div>
			<div class="scroll_area3">
				<table cellspacing="0" cellpadding="0" border="0" summary="자료전송 정보를 상세히 볼 수 있는 표입니다.">
					<caption>제목, 전송일, 첨부파일</caption>
					<colgroup>
						<col style="width:80%;"/>
						<col style="width:20%;"/>
					</colgroup>
					<tbody>
						<c:forEach items="${sendFileInfoJsonArray}" var="sendFileInfo" varStatus="i">
						<c:set var="tSize" value="${tSize + sendFileInfo.fileSize}"/>
						<tr>
							<td class="noAttach"><c:out value="${customfunc:base64Decode(sendFileInfo.fileName)}" /></td>
							<td class="t_right"><c:out value="${customfunc:BigFileSizeFormat(sendFileInfo.fileSize)}" /></td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="scroll_area_sum">
				<span class="sendFileSum">총 <c:out value="${fn:length(sendFileInfoJsonArray)}" />개 / <c:out value="${customfunc:BigFileSizeFormat(tSize)}" /></span>
			</div>
		</dd>
	</dl>
	<div class="t_center">
		<button type="button" class="btn_chk_st01 t_center mg_b20 mg_t30" onClick="go();">
			<span class="ir_desc">확인</span>
		</button>
	</div>
</div>
</form>
<iframe name="messangerFrame" id="messangerFrame" width="0%" src="about:blank" height="0px" style="border-width:1px;border-color:black;border-style:solid;"></iframe>
</body>
</html>