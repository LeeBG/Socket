<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<script type="text/javascript">
	function updateCache(name, idx) {
		$("#name").val(name);
		$("#value").val($("#value_" + idx).val());
		var requestURL = "<c:url value='/cache/updateCache.lin' />";
		var successURL = "<c:url value='/cache/setCache.lin' />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}

	function reload(name, value) {
		var requestURL = "<c:url value='/cache/cacheReload.lin' />";
		var successURL = "<c:url value='/cache/setCache.lin' />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/cache/setCache.lin" />">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<input id="name" name="name" type="hidden" />
	<input id="value" name="value" type="hidden" />
	<!-- contents -->
	<div class="rightArea">
	<div class="conWrap tableBox">
		<h3>목록</h3>
		<div class="conBox">
			<div class="table_area_style01">
				<div class="btn_area_right mg_r10 mg_t10 mg_b10">
					<button type="button" class="btn_common" onclick="reload();">전체 캐쉬 리로드</button>
				</div>
				<table summary="자료 수신함"
					style="table-layout: fixed">
					<caption>name, value, button</caption>
					<colgroup>
						<col style="width: 30%;" />
						<col style="width: 40%;" />
						<col style="width: 10%;" />
					</colgroup>
					<thead>
						<tr>
							<th class="Rborder">name</th>
							<th class="Rborder">value</th>
							<th class="Rborder">수정 버튼</th>
						</tr>
					</thead>
					<tbody id="values" class="a">
						<c:choose>
						<c:when test="${not empty cacheMap}">
							<c:forEach items="${cacheMap}" var="cache" varStatus="status">
								<tr>
									<td class="t_center Rborder">
										${cache.key }
									</td>
									<td class="t_center">
										<input id="value_${status.count}" type="text" value="${cache.value}"/>
									</td>
									<td class="t_center">
										<button type="button" class="btn_common" onclick="updateCache('${cache.key }', '${status.count }')">수정</button>
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="3">
									<div class="no_result">
										<spring:message code="global.script.search.no.result" />
									</div>
								</td>
							</tr>
					</c:otherwise>
				</c:choose>
					</tbody>
					<tfoot>
					</tfoot>
				</table>
			</div>
		</div>
	</div>
	</div>
</form>
</body>
</html>