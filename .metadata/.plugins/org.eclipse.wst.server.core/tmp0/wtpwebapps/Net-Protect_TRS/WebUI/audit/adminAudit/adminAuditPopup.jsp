<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<% 
pageContext.setAttribute("newline", ",");
pageContext.setAttribute("br", "<br/>");
%>
<html>
<head>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />

<script type="text/javascript">
	
	function self_close(){
		self.opener = self;
		window.close();
	}
	 
		
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" >
<input id="page" name="page" type="hidden"/>
<input id="seq" name="seq" type="hidden" value = ""/>
			<div class="conWrap">
				<h3>변경이력</h3>
				<div class="conBox">
					<div class="table_area_style01 hoverTable">
						<table cellspacing="0" cellpadding="0" summary="연계정책목록" style="table-layout : fixed" class="mg_t5">
						<caption>항목명,변경전항목,변경후항목</caption>
						<colgroup>
							<col style="width:170px;"/>
							<col/>
							<col/>
						</colgroup>
							<thead>
								<tr>
									<th class="Rborder">항목명</th>
									<th class="Rborder">변경전항목</th>
									<th class="Rborder">변경후항목</th>	
								</tr>
							</thead>
							<tbody>
								<c:if test="${not empty adminAuditPopupList}">
									<c:forEach items="${adminAuditPopupList}" var="adminAuditPopupList">
										<tr>
											<td class="Rborder t_center" title="<c:out value="${adminAuditPopupList.division}" />">
												<c:out value="${adminAuditPopupList.division}" />
											</td>
											<c:choose>
												<c:when test="${adminAuditPopupList.division eq '결재권자' || adminAuditPopupList.division eq '결재자'}">
													<td class="Rborder" style="padding: 10px;">
														<c:choose>
															<c:when test="${adminAuditPopupList.comparison eq 'Y'}">
																<c:if test="${adminAuditPopupList.before eq 'null'}">
																</c:if>
																<c:if test="${adminAuditPopupList.before ne 'null'}">
																<span style="color:blue; line-height: 20px;" title="${adminAuditPopupList.before}"><c:out value="${fn:replace(adminAuditPopupList.before, newline, '<br>')}" escapeXml="false"/></span>
																</c:if>
															</c:when>	
															<c:otherwise>
																<c:if test="${adminAuditPopupList.before eq 'null'}">
																</c:if>
																<c:if test="${adminAuditPopupList.before ne 'null'}">
																<span style="line-height: 20px;" title="${adminAuditPopupList.before}"><c:out value="${fn:replace(adminAuditPopupList.before, newline, '<br>')}" escapeXml="false"/></span>
																</c:if>
															</c:otherwise>
														</c:choose>
													</td>
													<td class="Rborder" style="padding: 10px;">
														<c:choose>
														<c:when test="${adminAuditPopupList.comparison eq 'Y'}">
															<c:if test="${adminAuditPopupList.after eq 'null'}">
															</c:if>
															<c:if test="${adminAuditPopupList.after ne 'null'}">
															<span style="color:blue; line-height: 20px;" title="${adminAuditPopupList.after}"><c:out value="${fn:replace(adminAuditPopupList.after, newline, '<br>')}" escapeXml="false"/></span>
															</c:if>
														</c:when>
														<c:otherwise>
															<c:if test="${adminAuditPopupList.after eq 'null'}">
															</c:if>
															<c:if test="${adminAuditPopupList.after ne 'null'}">
															<span style="line-height: 20px;" title="${adminAuditPopupList.after}"><c:out value="${fn:replace(adminAuditPopupList.after, newline, '<br>')}" escapeXml="false"/></span>
															</c:if>
														</c:otherwise>
													</c:choose>
													</td>
												</c:when>
												<c:otherwise>
													<td class="Rborder t_center">
														<c:choose>
														<c:when test="${adminAuditPopupList.comparison eq 'Y'}">
															<span style="color:blue" title="${adminAuditPopupList.before}"><c:out value="${adminAuditPopupList.before}" /></span>
														</c:when>
														<c:otherwise>
															<span title="${adminAuditPopupList.before}"><c:out value="${adminAuditPopupList.before}" /></span>
														</c:otherwise>
														</c:choose>
													</td>
													<td class="Rborder t_center">
														<c:choose>
															<c:when test="${adminAuditPopupList.comparison eq 'Y'}">
																<span style="color:blue" title="${adminAuditPopupList.after}"><c:out value="${adminAuditPopupList.after}" /></span>
															</c:when>
															<c:otherwise>
																<span title="${adminAuditPopupList.after}"><c:out value="${adminAuditPopupList.after}" /></span>
															</c:otherwise>
														</c:choose>
													</td>
												</c:otherwise>
											</c:choose>
										</tr>
									</c:forEach>
								</c:if>  
							</tbody>
							<tfoot>
								<tr>
									<td colspan="3" class="td_last" style="border-bottom:0;" align="center">
										<button class="btn_small" onclick="javascript:self_close();">닫기</button>
									</td>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>
</form>
</body>
</html>