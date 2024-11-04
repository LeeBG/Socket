<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />

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

	function insert(pol_seq, cud_cd) {
		$("#pol_seq").val(pol_seq);
		$("#cud_cd").val(cud_cd);
	
		var form = document.lform;
		form.action = "<c:url value="/policy/filePolicy/filePolicyInfo.lin" />";
		form.submit();
	}

	function checkDelete() {
		if (!$(":checkbox[name=chk]").is(":checked")) {
			alert("삭제 할 항목을 선택하세요.");
			return;
		}
	
		if (confirm("선택 목록을 삭제하겠습니까?")) {
			var requestURL = "<c:url value="/policy/filePolicy/deleteFilePolicyMgt.lin" />";
			var successURL = "<c:url value="/policy/filePolicy/filePolicyMgt.lin" />";
			resultCheck($("#lform"), requestURL, successURL, true);
		}
	}
	
	$(document).ready(function() {
		checkFocusMessage($("#searchValue"),"최대 100자까지 가능합니다.");
	});
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/policy/filePolicy/filePolicyMgt.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="page" name="page"/>
<input type="hidden" id="isdel_yn" name="isdel_yn"/>
<input id="pol_seq" name="pol_seq" type="hidden" value = ""/>
<input id="cud_cd" name="cud_cd" type="hidden" value = ""/>
<input id="searchField" name="searchField" type="hidden" value="${fPolFileMgtForm.searchField}"/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">파일전송정책 관리</h2>
				<p class="breadCrumbs">정책관리 > 파일전송정책 관리</p>
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
									<select id="searchCondition" title="파일전송정책 검색조건">
									<option selected="selected" value="pol_seq">정책ID</option>
									<option value="pol_nm" >파일전송 정책명</option>
									<option value="note">설명</option>
									</select>
									<input type="text" class="text_input" style="max-width:65%;" id="searchValue" name="searchValue" onkeypress="if(event.keyCode==13) {search(); return false;}" value="${fPolFileMgtForm.filterSearchValue}" onkeyup="onlySizeFillter(this,100)"/>
									<button class="btn_common theme" onClick="search()">조회</button>
									<button class="btn_common theme" onClick="init()">초기화</button>
								<c:if test="${auth_cd == 1}">
									<button class="btn_common theme" onclick="insert('', '${CUD_CD_C}')">추가</button>
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
					<div class="top_con mg_l5 mg_t10">
					<c:if test="${auth_cd == 1}">
						<button class="btn_common"  onclick="checkDelete();">삭제</button>
					</c:if>
					</div>
					<table summary="파일전송정책" style="table-layout : fixed" class="mg_t5">
					<caption>정책ID, 정책명, 설명</caption>
						<colgroup>
							<c:if test="${auth_cd == 1}">
								<col style="width:3%;"/>
							</c:if>
							<col style="width:17%;" />
							<col style="width:35%;" />
							<col style="width:45%;" />
						</colgroup>
						<thead>
							<tr>
								<c:if test="${auth_cd == 1}">
									<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
								</c:if>
								<th class="Rborder">정책ID</th>
								<th class="Rborder">정책명</th>
								<th>설명</th>
							</tr>
						</thead>
						<tbody>
						<c:choose>
						<c:when test="${not empty fPolFileMgtList}">
							<c:forEach items="${fPolFileMgtList}" var="fPolFileMgt">
								<tr>
								<c:if test="${auth_cd == 1}">
									<c:choose>
										<c:when test="${fPolFileMgt.isdel_yn eq 'N'}">
											<td class="td_chekbox Rborder t_center"></td>
										</c:when>
										<c:otherwise>
											<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" id="chk_${fPolFileMgt.pol_seq}" name="chk" value="${fPolFileMgt.pol_seq}" /></td>
										</c:otherwise>
									</c:choose>
								</c:if>
									<td class="t_center Rborder" onclick="insert('${fPolFileMgt.pol_seq}', '${CUD_CD_U}')" >
										<c:out value="${fPolFileMgt.pol_seq}" />
									</td>
									<td class="t_center Rborder" onclick="insert('${fPolFileMgt.pol_seq}', '${CUD_CD_U}')" >
										<c:out value="${fPolFileMgt.pol_nm}"/>
									</td>
									<td class="t_center" onclick="insert('${fPolFileMgt.pol_seq}', '${CUD_CD_U}')" >
										<c:out value="${fPolFileMgt.note}" />
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
								<td colspan="${auth_cd eq '1' ? '4' : '3'}" class="td_last">
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
