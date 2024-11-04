<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="">
<input type="hidden"id="page" name="page"/>
<input id="search_group_seq" name="search_group_seq" type="hidden"/>
<input id="test_type" name="test_type" type="hidden"/>
	<!-- contents -->
	<div class="conWrap">
		<h3>시험 관리 상세 보기</h3>
		<div class="conBox">
			<div class="table_area_style01 hoverTable">
				<div class="table_area_topCon mg_t15 mg_b5">
				</div>
				<table id="testResultTable" cellspacing="0" cellpadding="0" summary="연계정책목록" style="table-layout : fixed" class="mg_t5">
				<caption>요청자, 제목, 요청시간</caption>
					<colgroup>
						<col style="width:25%;"/>
						<col style="width:10%;"/>
						<col style="width:15%;"/>
						<col style="width:10%;"/>
						<col style="width:20%;"/>
						<col style="width:20%;"/>
					</colgroup>
					<thead>
						<tr>
							<th class="Rborder">시험 이름 </th>
							<th class="Rborder">시험 종류 </th>
							<th class="Rborder">시험 결과</th>
							<th class="Rborder">처리 상태</th>
							<th class="Rborder">시작 시간</th>
							<th class="Rborder">종료 시간</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
						<c:when test="${not empty testResultList}">
							<c:forEach items="${testResultList}" var="testResult">
								<tr>
									<td class="Rborder t_center" title="<c:out value="${testResult.testCategory.test_name}" />">
										<c:out value="${testResult.testCategory.test_name}" />
									</td>
									<td class="Rborder t_center" title="<c:out value="${customfunc:codeDes('TEST_MODE_CD', testResult.testCategory.test_mode_cd)}" />">
										<c:out value="${customfunc:codeDes('TEST_MODE_CD', testResult.testCategory.test_mode_cd)}" />
									</td>
									<td class="Rborder t_center" title="<c:out value="${customfunc:codeDes('TEST_RESULT_CD', testResult.rst_cd)}" />">
										<c:out value="${customfunc:codeDes('TEST_RESULT_CD', testResult.rst_cd)}" />
									</td>
									<td class="Rborder t_center" title="<c:out value="${customfunc:codeDes('PROC_CD', testResult.proc_cd)}" />">
										<c:out value="${customfunc:codeDes('PROC_CD', testResult.proc_cd)}" />
									</td>
									<td class="Rborder t_center" title="<fmt:formatDate value="${testResult.crt_time}" pattern="yyyy-MM-dd HH:mm" />">
										<fmt:formatDate value="${testResult.crt_time}" pattern="yyyy-MM-dd HH:mm" />
									</td>
									<td class="Rborder t_center" title="<fmt:formatDate value="${testResult.end_time}" pattern="yyyy-MM-dd HH:mm" />">
										<fmt:formatDate value="${testResult.end_time}" pattern="yyyy-MM-dd HH:mm" />
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="7"><div class="no_result"><spring:message code="global.script.search.no.result" /></div></td>
							</tr>
						</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
			<div class="btn_area_center mg_t10 mg_b10">
				<button type="button" class="btn_common" onclick="window.close()">닫기</button>
			</div>
		</div>
	</div>
</form>
</body>
</html>