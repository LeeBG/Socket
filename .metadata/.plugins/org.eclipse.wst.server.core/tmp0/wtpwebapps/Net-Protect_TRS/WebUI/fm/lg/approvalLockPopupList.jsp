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
<c:set var="loginUser" value="${sessionScope.loginUser}"/>
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<html>
<head>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />

<script type="text/javascript">
	
	function self_close(){
		self.opener = self;
		window.close();
	}

	function download(){
		var errmsg = new cls_errmsg();

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		var frm = document.lform;
		frm.action="<c:url value="/fm/lg/approvalLockCreteExcelDownload.lin" />";
		frm.submit();
		frm.action="<c:url value="/fm/lg/approvalLockPopupList.lin" />";
	}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" >
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden"/>
<input id="seq" name="seq" type="hidden" value = ""/>
		<div class="t_right pd_r15">
			<button type="button"  onclick="download()" class="btn_common theme">사후결재제한결재자목록엑셀다운로드</button>
			</div>
			<div class="conWrap">
				<h3>사후결재제한 결재자목록</h3>
				<div class="conBox">
					<div class="table_area_style01 hoverTable">
						<table cellspacing="0" cellpadding="0" summary="연계정책목록" style="table-layout : fixed" class="mg_t5">
						<caption>사용자아이디,사용자이름,부서명,사후결재제한기간</caption>
						<colgroup>
							<col style="width:15%;" />
							<col style="width:12%;" />
							<col style="width:15%;" />
							<col style="width:17%;" />
							<col style="width:35%;" />
						</colgroup>
							<thead>
								<tr>
									<th class="Rborder">제한영역</th>
									<th class="Rborder">${customfunc:getMessage('common.id.commonid')}</th>
									<th class="Rborder">이름</th>
									<th class="Rborder">부서명</th>	
									<th class="Rborder">사후결재제한기간</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty selectapprovalLockList}">
										<c:forEach items="${selectapprovalLockList}" var="approvalPolicy">
											<tr>
												<td class="Rborder t_center">
													<c:if test="${approvalPolicy.np_cd eq 'I' }">${INNER} -> ${OUTER}</c:if>
													<c:if test="${approvalPolicy.np_cd eq 'O' }">${OUTER} -> ${INNER}</c:if>
												</td>
												<td class="Rborder t_center">
													<c:out value="${approvalPolicy.users_id}" />
												</td>
												<td class="Rborder t_center">
													<c:out value="${approvalPolicy.users_nm}" />
												</td>
												<td class="Rborder t_center">
													<c:out value="${approvalPolicy.dept_nm}" />
												</td>
												<td class="Rborder t_center">
													<fmt:formatDate value="${approvalPolicy.numdate}" pattern="yyyy-MM-dd" /> 날짜 이전에 미결재건이 있습니다.
												</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td class="t_center" colspan="5"><div class="no_result">결과가 없습니다.</div></td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="5" class="td_last">
									<span class="text_list_number"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></span>
									<div class="pagenate t_center">
										${pageList}
									</div>
									</td>
								</tr>
							</tfoot>
							
						</table>
					</div>
				</div>
			</div>
				<div class="pagenate t_center">
					<button class="btn_big" onclick="javascript:self_close();">닫기</button>
				</div>
</form>
</body>
</html>
