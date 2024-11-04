<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>

	<caption>부서 ID, 부서명</caption>
	<colgroup>
		<col style="width:50%;" />
		<col style="width:50%;" />
	</colgroup>
	<thead>
		<tr>
			<th class="Rborder">부서 ID</th>
			<th class="Rborder">부서명</th>	
		</tr>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${paging.totalCount ne 0}">
				<c:forEach items="${approvalPolicyList}" var="approvalPolicy">
					<tr>
						<td class="t_center Rborder">
						<c:out value="${approvalPolicy.dept_seq}" /></td>
						<td class="t_center">
						<c:out value="${approvalPolicy.dept_nm}" /></td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td class="t_center" colspan="2"><div class="no_result">결과가 없습니다.</div></td>
				</tr>
			</c:otherwise>
		</c:choose>
	</tbody>
	<tfoot>
		<tr>
			<c:choose>
				<c:when test="${ userInfoYn eq 'Y' }">
					<td colspan="3" class="td_last">
				</c:when>
				<c:otherwise>
					<td colspan="2" class="td_last">
				</c:otherwise>
			</c:choose>
			<span class="text_list_number"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></span>
			<div class="pagenate t_center">
				${pageList}
			</div>
			</td>
		</tr>
	</tfoot>