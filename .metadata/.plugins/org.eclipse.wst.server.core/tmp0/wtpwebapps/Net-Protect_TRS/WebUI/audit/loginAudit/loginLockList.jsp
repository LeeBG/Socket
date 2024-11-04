<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>

<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<script type="text/javascript">
	$(document).ready(function(){
		<c:if test="${auth_cd == 4}">
		allInputDisable();
		</c:if>
	});

	function clearLoginLock(seq, users_id) {
		if(confirm("잠긴계정을 해제 하겠습니까?" ) ){
			$("#seq").val(seq);
			$("#users_id").val(users_id);
	
			var requestURL = "<c:url value="/audit/loginAudit/clearLoginLock.lin" />";
			var successURL = "<c:url value="/audit/loginAudit/loginLockList.lin" />";
			resultCheck($("#lform"), requestURL, successURL, true);
		}
	}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/audit/loginAudit/loginLockList.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="page" name="page" />
<input type="hidden" id="seq" name="seq" value="${loginLockForm.seq}"/>
<input type="hidden" id="users_id" name="users_id" />
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">잠금계정 관리</h2>
				<p class="breadCrumbs">인사관리 > 잠금계정 관리</p>
			</div>
		</div>
		<div class="conWrap tableBox">
			<h3>목록</h3>
			<div class="conBox">
				<div class="table_area_style01 hoverTable">
					<table summary="잠금계정" style="table-layout : fixed" class="mg_t5">
					<caption>사용자명, 잠긴시간</caption>
						<colgroup>
							<col style="width:25%;"/>
							<col style="width:25%;" />
							<col style="width:25%;" />
							<col style="width:25%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder">사용자명</th>
								<th colspan="2" class="Rborder">잠긴 시간</th>
								<!-- <th class="Rborder">자동해제 시간</th> -->
								<th class="Rborder">해제</th>
							</tr>
						</thead>
						<tbody>
						<c:choose>
						<c:when test="${not empty loginLockFormList}">
							<c:forEach items="${loginLockFormList}" var="loginLockForm">
								<tr>
									<td class="t_center Rborder" onclick="" >
										<c:out value="${loginLockForm.users_id}(${loginLockForm.users_nm})" />
									</td>
									<td colspan="2" class="t_center Rborder" onclick="" >
										<fmt:formatDate value="${loginLockForm.crt_date}" pattern="yyyy-MM-dd HH:mm" />
									</td>
									<%-- <td class="t_center Rborder" onclick="" >
										<fmt:formatDate value="${loginLockForm.end_date}" pattern="yyyy-MM-dd HH:mm" />
									</td> --%>
									<td class="t_center Rborder" onclick="" >
									<c:if test="${auth_cd != 4}">
										<button type="button" class="btn_common theme mg_l5" onclick="clearLoginLock('${loginLockForm.seq}','${loginLockForm.users_id}')">해제</button>
									</c:if>
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="21">
									<div class="no_result">
										<spring:message code="global.script.search.no.result" />
									</div>
								</td>
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
	</div>
	
</form>
</body>
</html>
