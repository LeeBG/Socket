<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>

<html>
<head>
<script type="text/javascript">
function add() {
	location.href = "<c:url value="/license/licenseRegister.lin" />";
}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/license/licenseAdmin.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden" />
<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">라이센스 관리</h2>
				<p class="breadCrumbs">라이센스 관리 > 라이센스 관리</p>
			</div>
		</div>
	<div class="conWrap tableBox">
			<div class="conBox" align="right"><h3>현재유효한 사용자수 = ${license.user_count}</h3></div>
			<div class="conBox">
				<div class="table_area_style01 hoverTable">
					<div class="top_con mg_l5 mg_t10">
					</div>
					<table summary="라이센스등록" style="table-layout : fixed" class="mg_t5">
						<thead>
							<tr>
								<th class="Rborder">사이트아이디</th>
								<th class="Rborder">발급날짜</th>
								<th class="Rborder">만료날짜</th>
								<th class="Rborder">사용자수</th>
								<th class="Rborder">등록일자</th>
								<th class="Rborder">등록자</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
							<c:when test="${not empty licenseInfoFormList}">
								<c:forEach items="${licenseInfoFormList}" var="data">
								<tr>
									<td class="t_center Rborder"><c:out value="${data.site_id}" /></td>
									<td class="t_center Rborder"><c:out value="${data.start_date}" /></td>
									<td class="t_center Rborder"><c:out value="${data.end_date}" /></td>
									<td class="t_center Rborder"><c:out value="${data.user_count}" /></td>
									<td class="t_center Rborder"><fmt:formatDate value="${data.crt_time}" pattern="yyyy-MM-dd kk:mm" /></td>
									<td class="t_center Rborder"><c:out value="${data.register}" /></td>
								</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td class="t_center" colspan="6"><div class="no_result">등록된 라이센스가 없습니다.</div></td>
								</tr>
							</c:otherwise>
							</c:choose>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="6" class="td_last">
								<span class="text_list_number"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></span>
								<div class="pagenate t_center">
									${pageList}
								</div>
								</td>
							</tr>
						</tfoot>
					</table>
						<div class="t_center mg_t30 mg_b30">
							<button class="btn_common theme" onclick="add()">추가</button>
						</div>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>
