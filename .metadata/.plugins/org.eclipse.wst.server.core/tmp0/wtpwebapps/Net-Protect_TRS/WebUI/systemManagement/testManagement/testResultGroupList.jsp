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
	$(document).ready(function() {
		$("#testResultTable > tbody").delegate('tr', 'click', function() {
			viewDetail(this.id);
		});
	});

	function search() {
		$("#lform").get(0).submit();
	}

	function viewDetail(group_seq) {
		var url = "<c:url value="/systemManagement/testManagement/viewTestResult.lin" />?search_group_seq=" + group_seq;
		var attibute = "resizable=yes,scrollbars=yes,width=1200,height=800,top=5,left=5,toolbar=no,resizable=no";
		var popupWindow = window.open(url, "viewTestResult", attibute);
		popupWindow.focus();
	}

	function doTest(test_type){
		var title = '';
		if (test_type == 'SELF') {
			title = '${customfunc:codeDes("TEST_MODE_CD", customfunc:codeString("TEST_MODE_CD", "SELF"))}';
		} else {
			title = '${customfunc:codeDes("TEST_MODE_CD", customfunc:codeString("TEST_MODE_CD", "INTEGRITY"))}';
		}

		$('#test_type').val(test_type);

		if (confirm(title + " 수동 검사를 시작 하겠습니까?")) {
			var requestURL = "<c:url value="/systemManagement/testManagement/doTest.lin" />";

			resultCheckFunc($("#lform"), requestURL,  function(response) {
				var message = response['message'];
				alert(message);
			});
		}
	}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/systemManagement/testManagement/testResultGroupList.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden"id="page" name="page"/>
<input id="test_type" name="test_type" type="hidden"/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">시험 관리</h2>
				<p class="breadCrumbs">시스템관리 > 시험 관리</p>
			</div>
		</div>
			<div class="conWrap">
				<h3>수동 시험 구동</h3>
				<div class="conBox">
					<div class="topCon nBorder"  >
						<table cellspacing="0" cellpadding="0" summary="시험처리 검색조건" style="table-layout : fixed; width:98%;" >
						<caption>자체시험 수동 검사, 무결성 검사 수동 검사</caption>
							<colgroup>
								<col style="width:50%;"/>
								<col style="width:50%;"/>
							</colgroup>
							<tbody>
								<tr>
									<td class="t_center">
										자체 시험
										<c:set var="SELF" value='${customfunc:codeString("TEST_MODE_CD", "SELF")}'/>
										<button type="button" class="btn_common theme" onclick="javascript:doTest('${SELF}');">수동 검사</button>
									</td>
									<td class="t_center">
										무결성 검사
										<c:set var="INTEGRITY" value='${customfunc:codeString("TEST_MODE_CD", "INTEGRITY")}'/>
										<button type="button" class="btn_common theme" onclick="javascript:doTest('${INTEGRITY}');">수동 검사</button>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="conWrap">
				<h3>검색조건</h3>
				<div class="conBox">
					<div class="topCon nBorder"  >
						<table cellspacing="0" cellpadding="0" summary="시험처리 검색조건" style="table-layout : fixed; width:98%;" >
						<caption>시험명, 시험위치, 시험분류, 시험항목, 시험내용, 성공코드</caption>
							<colgroup>
								<col style="width:100%;"/>
							</colgroup>
							<tbody>
								<tr>
									<td class="t_center">
										시험위치&nbsp;
										<select title="시험방법" id="np_cd" name="np_cd">
											<option value="">전체</option>
											<option value='${customfunc:codeString("NP_CD", "INNER") }' <c:if test='${customfunc:codeString("NP_CD", "INNER") eq testResultForm.np_cd}'>selected="selected"</c:if>>${customfunc:codeDes("NP_CD", customfunc:codeString("NP_CD", "INNER")) }</option>
											<option value='${customfunc:codeString("NP_CD", "OUTER") }' <c:if test='${customfunc:codeString("NP_CD", "OUTER") eq testResultForm.np_cd}'>selected="selected"</c:if>>${customfunc:codeDes("NP_CD", customfunc:codeString("NP_CD", "OUTER")) }</option>
										</select>
										&nbsp;시험방법&nbsp;
										<select title="시험방법" id="test_start_cd" name="test_start_cd">
											<option value="">전체</option>
											<option value='${customfunc:codeString("TEST_START_CD", "SCHEDULE") }' <c:if test='${customfunc:codeString("TEST_START_CD", "SCHEDULE") eq testResultForm.test_start_cd}'>selected="selected"</c:if>>${customfunc:codeDes("TEST_START_CD", customfunc:codeString("TEST_START_CD", "SCHEDULE")) }</option>
											<option value='${customfunc:codeString("TEST_START_CD", "INIT") }' <c:if test='${customfunc:codeString("TEST_START_CD", "INIT") eq testResultForm.test_start_cd}'>selected="selected"</c:if>>${customfunc:codeDes("TEST_START_CD", customfunc:codeString("TEST_START_CD", "INIT")) }</option>
											<option value='${customfunc:codeString("TEST_START_CD", "MANUAL") }' <c:if test='${customfunc:codeString("TEST_START_CD", "MANUAL") eq testResultForm.test_start_cd}'>selected="selected"</c:if>>${customfunc:codeDes("TEST_START_CD", customfunc:codeString("TEST_START_CD", "MANUAL")) }</option>
										</select>
										<button type="button" class="btn_common theme" onclick="search()">조회</button>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="conWrap">
				<h3>목록</h3>
				<div class="conBox">
					<div class="table_area_style01 hoverTable">
						<div class="table_area_topCon mg_t15 mg_b5">
						</div>
						<table id="testResultTable" cellspacing="0" cellpadding="0" summary="연계정책목록" style="table-layout : fixed" class="mg_t5">
						<caption>요청자, 제목, 요청시간</caption>
							<thead>
								<tr>
									<th class="Rborder">시험 방법 </th>
									<th class="Rborder">시험 종류 </th>
									<th class="Rborder">시험 위치</th>
									<th class="Rborder">정상 건수</th>
									<th class="Rborder">비정상 건수</th>
									<th class="Rborder">처리 상태</th>
									<th class="Rborder">시작 시간</th>
									<th class="Rborder">종료 시간</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
								<c:when test="${not empty testResultList}">
									<c:forEach items="${testResultList}" var="testResult">
										<tr id="${testResult.group_seq }">
											<td class="Rborder t_center" title="<c:out value="${customfunc:codeDes('TEST_START_CD', testResult.test_start_cd)}" />">
												<c:out value="${customfunc:codeDes('TEST_START_CD', testResult.test_start_cd)}" />
											</td>
											<td class="Rborder t_center" title="<c:out value="${customfunc:codeDes('TEST_MODE_CD', testResult.test_mode_cd)}" />">
												<c:out value="${customfunc:codeDes('TEST_MODE_CD', testResult.test_mode_cd)}" />
											</td>
											<td class="Rborder t_center" title="<c:out value="${customfunc:codeDes('NP_CD', testResult.np_cd)}" />">
												<c:out value="${customfunc:codeDes('NP_CD', testResult.np_cd)}" />
											</td>
											<td class="Rborder t_center" title="<c:out value="${testResult.normal_count}" />">
												<c:out value="${testResult.normal_count}" />
											</td>
											<td class="Rborder t_center" title="<c:out value="${testResult.abnormal_count}" />">
												<c:out value="${testResult.abnormal_count}" />
											</td>
											<td class="Rborder t_center" title="<c:out value="${customfunc:codeDes('PROC_CD', testResult.proc_cd)}" />">
												<c:out value="${customfunc:codeDes('PROC_CD', testResult.proc_cd)}" />
											</td>
											<td class="Rborder t_center" title="<fmt:formatDate value="${testResult.crt_time}" pattern="yyyy-MM-dd HH:mm" />">
												<fmt:formatDate value="${testResult.crt_time}" pattern="yyyy-MM-dd HH:mm" />
											</td>
											<td class="Rborder t_center" title="<fmt:formatDate value="${testResult.crt_time}" pattern="yyyy-MM-dd HH:mm" />">
												<fmt:formatDate value="${testResult.crt_time}" pattern="yyyy-MM-dd HH:mm" />
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
							<tfoot>
								<tr>
								<td colspan="8" class="td_last">
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
