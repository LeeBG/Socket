<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<html>
<head>
</head>

<body>

<table width="600" cellspacing="0" cellpadding="0" class="margin_auto">
	<tr>
		<td class="center">
			<table width="600" cellspacing="0" cellpadding="0">
				<tr>
					<td height="250"></td>
				</tr>
				<tr>
					<td width="4" height="4"><img src="<c:url value="../../../Images/r01.gif" />" width="4" height="4"></td>
					<td height="4" style="background:url('<c:url value="../../../Images/rtop.gif" />');"></td>
					<td width="4" height="4"><img src="<c:url value="../../../Images/r02.gif" />" width="4" height="4"></td>
				</tr>
				<tr>
					<td style="background:url('<c:url value="../../../Images/rleft.gif" />');"></td>
					<td bgcolor="#f8f8f8" class="center" style="padding:20px;">
						<div><spring:message code="common.defaultErrorMessage.title" /></div>
						<div class="tpadding15">
							<strong><font color="#ff0000"><c:out value="${errorMessage}" /></font></strong>
						</div>
						<div class="tpadding15"><input type="button" value="<spring:message code="common.defaultErrorMessage.confirm.button" />" onClick="popupClose();" class="btn"></div>
					</td>
					<td style="background:url('<c:url value="../../../Images/rright.gif" />');"></td>
				</tr>
				<tr>
					<td><img src="<c:url value="../../../Images/r03.gif" />" width="4" height="4"></td>
					<td style="background:url('<c:url value="../../../Images/rbottom.gif" />');"></td>
					<td><img src="<c:url value="../../../Images/r04.gif" />" width="4" height="4"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</body>
</html>
