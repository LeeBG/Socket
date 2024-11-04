<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<html>
<head>
<style type="text/css">
.errorMsg_box dl{padding:5px 0 7px 0; width:100%; position:relative; margin-top:100px; text-align:center;}
.errorMsg_box dt{padding-top:15px;}
.errorMsg_box dd{padding:12px 15px; background-color:#f5f5f5; text-align:center; font-weight:bold; font-size:1.3em; display:inline-block; border:1px solid #ddd; color:red; margin-bottom:30px;}
.topWarp{height:31px;}
</style>
</head>

<body>
<div class="box_type05 errorMsg_box" style="position:relative; z-index:-1; margin-left:270px;">
	<div class="topWarp">
		<div class="titleBox">
		</div>
	</div>
	<dl>
		<dt class="mg_b30"><img src="<c:url value="../../../Images/contents/errorMsg.gif" />" alt="다음과 같은 에러가 발생했습니다." /></dt>
			<dd>
				<span class="errorMsg">
					<c:choose>
						<c:when test="${not empty exception && not empty exception.errorMessage}">
							<spring:message code="${exception.errorMessage.key}" arguments="${exception.errorMessage.args}" />
						</c:when>
						<c:when test="${not empty exceptionMessage}">
							<% pageContext.setAttribute("lf", "\n"); %>
							<c:set var="pos" value="${fn:indexOf(exceptionMessage, lf)}" />
							<c:set var="preMessage" value="${fn:substring(exceptionMessage, 0, pos)}" />
							<c:choose>
								<c:when test="${not empty preMessage}">
									<strong><font color="#ff0000"><spring:message code="common.defaultErrorMessage.not.clear.exception" /></font></strong>
								</c:when>
								<c:otherwise>
									<spring:message code="common.defaultErrorMessage.not.clear.exception" />
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<spring:message code="common.defaultErrorMessage.unknown.error" />
						</c:otherwise>
					</c:choose>
				</span>
			</dd>
	</dl>
	<div class="t_center">
		<button type="button" class="btn_chk_st01 t_center mg_b20" onClick="go();">
			<span class="ir_desc">확인</span>
		</button>
	</div>
</div>
</body>
</html>