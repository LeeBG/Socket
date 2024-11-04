<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>

<c:set var="systemCode" value="${sessionScope.loginUser.system_cd}" /><!-- T, S -->
<c:set var="getNetworkPosition" value="${customfunc:getNetworkPosition()}" /><!-- I, O -->

<c:set var="hide_button" value="" />

<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="CUD_CD_D" value="${customfunc:codeString('CUD_CD', 'DELETE')}" />

<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<script type="text/javascript">
$(document).ready(function() {
	var searchFieldValue = $("#searchField").val();
	$("#searchCondition").val(searchFieldValue).attr("selected", "selected");
});

function init() {
	$("#searchField").val("");
	$("#searchValue").val("");
	$("#lform").get(0).submit();
}
function search() {
	var searchConditionValue = $("#searchCondition option:selected").val();
	$("#searchField").val(searchConditionValue);
	if ($("#searchValue").val().empty()) {
		alert('검색어를 입력해 주세요.');
		return;
	}
	$("#lform").get(0).submit();
}

function insert(login_seq, cud_cd, del_yn) {
	$("#login_seq").val(login_seq);
	$("#isdel_yn").val(del_yn);
	$("#cud_cd").val(cud_cd);

	var form = document.lform;
	form.action = "<c:url value="/policy/repository/repositoryVolumeRegist.lin" />";
	form.submit();
}

function checkDelete() {
	if (!$(":checkbox[name=chk]").is(":checked")) {
		alert("삭제 할 항목을 선택하세요.");
		return;
	}

	if (confirm("선택 목록을 삭제하겠습니까?")) {
		var requestURL = "<c:url value="/policy/repository/deleteRepositoryVolume.lin" />";
		var successURL = "<c:url value="/policy/repository/repositoryVolumeMgt.lin" />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}
}

function preventEvent() {
	var event = window.event;
	if (event.stopPropagation())
		event.stopPropagation(); // W3C 표준
	else
		event.cancelBubble = true; // 인터넷 익스플로러 방식
}

$(document).ready(function() {
	checkFocusMessage($("#searchValue"), "최대 100자까지 가능합니다.");
});
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/policy/repository/repositoryVolumeMgt.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="page" name="page" />
<input type="hidden" id="cud_cd" name="cud_cd" />
<input type="hidden"id="isde_yn" name="isdel_yn" />
<input type="hidden" id="login_seq" name="login_seq" />
<input id="searchField" name="searchField" type="hidden" value="${volumeForm.searchField}"/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">개별 자료함 용량 관리</h2>
				<p class="breadCrumbs">정책관리 > 개별 자료함 용량 관리</p>
			</div>
		</div>
		<div class="conWrap">
			<h3>검색조건</h3>
			<div class="conBox searchBox t_center">
				<div class="topCon nBorder pd_b10 pd_t10">
					<table summary="정책 검색조건" style="table-layout : fixed">
						<caption>검색조건, 버튼</caption>
						<tbody>
							<colgroup>
								<col style="width:100%;"/>
							</colgroup>
							<tr>
								<td class="t_center">
									<select id="searchCondition" title="로그인정책 검색조건">
										<option <c:if test="${cPolLoginMgtForm.searchField eq 'users_id'}">selected="selected"</c:if> value="users_id">${customfunc:getMessage('common.id.commonid')}</option>
										<%-- <option <c:if test="${cPolLoginMgtForm.searchField eq 'users_nm'}">selected="selected"</c:if> value="users_nm">사용자명</option> --%>
										<%-- <option <c:if test="${cPolLoginMgtForm.searchField eq 'period'}">selected="selected"</c:if> value="period">기간</option>
										<option <c:if test="${cPolLoginMgtForm.searchField eq 'status'}">selected="selected"</c:if> value="status">상태</option> --%>
									</select>
									<input type="text" class="text_input" style="max-width:70%;" id="searchValue" name="searchValue" onkeypress="if(event.keyCode==13) {search(); return false;}" value="${cPolLoginMgtForm.searchValue}" onkeyup="onlySizeFillter(this,100)"/>
									<button class="btn_common theme" onClick="search()">조회</button>
									<button class="btn_common theme" onClick="init()">초기화</button>
								<c:if test="${auth_cd != 3}">
									<button class="btn_common theme${hide_button }" onclick="insert('', '${CUD_CD_C}')">추가</button>
								</c:if>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="conWrap tableBox">
			<h3>목록</h3>
			<div class="conBox">
				<div class="table_area_style01 hoverTable">
					<div class="top_con pd_t10 pd_b10" style="font-size: 13px; color: rgb(85, 85, 85); padding-left: 10px; /* background-color: #eee; */ border-bottom: solid 1px #ddd;">
						- 사용자 별로 자료함 용량을 제어할 수 있습니다. 용량 관리에서 <b>기간만료</b> 또는 <b>삭제</b>되는  사용자는 <b>기본파일정책</b>이 적용됩니다.
					</div>
					<div class="top_con mg_l5 mg_t10">
					<c:if test="${auth_cd != 3}">
						<button class="btn_common"  onclick="checkDelete();">삭제</button>
					</c:if>
					</div>
					<table summary="로그인정책" style="table-layout : fixed" class="mg_t5">
					<caption>정책ID, 정책명, 설명</caption>
						<colgroup>
							<col style="width:3%;"/>
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
							<col style="width:10%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder" rowspan="2"></th>
								<th class="Rborder" rowspan="2">${customfunc:getMessage('common.id.commonid')}</th>
								<th class="Rborder" rowspan="2">상태</th>
								<th class="Rborder" rowspan="2">용량관리 파일정책</th>
								<th class="Rborder" colspan="2">용량관리 자료함 용량</th>
								<th class="Rborder" rowspan="2">시작일</th>
								<th class="Rborder" rowspan="2">종료일</th>
							</tr>
							<tr>
								<th class="Rborder">인터넷망</th>
								<th class="Rborder">업무망</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
							<c:when test="${not empty repositoryList}">
								<c:forEach items="${repositoryList}" var="repository">
									<tr onclick="window.location.href='/policy/repository/repositoryVolumeView.lin?seq=${repository.volume_seq}';">
										<td class="td_chekbox Rborder t_center">
											<input type="checkbox" class="input_chk" id="chk_${repository.volume_seq}" name="chk" value="${repository.volume_seq}" onclick="javascript:preventEvent();"/>
										</td>
										<td class="t_center Rborder" title="<c:out value="${repository.users_id}" />">
											<c:out value="${repository.users_id}" />
										</td>
										<td class="t_center Rborder" title="<c:if test="${ repository.status != null }"><spring:message code="policy.repository.volume.status.${repository.status}" /></c:if>">
											<c:if test="${ repository.status != null }">
												<spring:message code="policy.repository.volume.status.${repository.status}" />
											</c:if>
										</td>
										<td class="t_center Rborder" title="<c:out value="${repository.fPolFileMgt.pol_nm}" />(<c:out value="${repository.fPolFileMgt.pol_seq}" />)">
											<c:out value="${repository.fPolFileMgt.pol_nm}" />(<c:out value="${repository.fPolFileMgt.pol_seq}" />)
										</td>
										<td class="t_center Rborder" title="<fmt:formatNumber value="${repository.inner_volume_size}" pattern="#,###"/>MB">
											<c:choose>
												<c:when test="${repository.inner_volume_size > 0 }">
													<fmt:formatNumber value="${repository.inner_volume_size}" pattern="#,###"/>
												</c:when>
												<c:otherwise>0</c:otherwise>
											</c:choose> MB
										</td>
										<td class="t_center Rborder" title="<fmt:formatNumber value="${repository.outer_volume_size}" pattern="#,###"/>MB">
											<c:choose>
												<c:when test="${repository.outer_volume_size > 0 }">
													<fmt:formatNumber value="${repository.outer_volume_size}" pattern="#,###"/> 
												</c:when>
												<c:otherwise>0</c:otherwise>
											</c:choose> MB
										</td>
										<td class="t_center Rborder" title="<c:out value="${repository.start_date}" />">
											<c:out value="${repository.start_date}" />
										</td>
										<td class="t_center" title="<c:out value="${repository.end_date}" />">
											<c:out value="${repository.end_date}" />
										</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td class="t_center" colspan="8">
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
