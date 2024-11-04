<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<script type="text/javascript">
function search() {
	var searchConditionValue = $("#searchCondition option:selected").val();
	$("#searchField").val(searchConditionValue);
	$("#lform").get(0).submit();
}

function self_close(){
	self.opener = self;
	window.close();
}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden"id="page" name="page"/>
<input type="hidden"id="app_seq" name="app_seq" />
<input type="hidden" id="cud_cd" name="cud_cd" />
<input type="hidden"id="isde_yn" name="isdel_yn" />
<input id="searchField" name="searchField" type="hidden" value="${approvalPolicyForm.searchField}"/>
	<div class="conWrap">
		<h3>상세정보</h3>
		<div class="topCon t_center pd_t10 pd_b10 Bborder">
			<table summary="승인정책정보" style="table-layout : fixed" class="mg_t5">
				<tbody>
					<tr>
						<td><label>정책ID : </label>
							<label>${approvalPolicyLabel.app_seq}</label></td>
						<td><label>정책명 : </label>
							<label>${approvalPolicyLabel.app_nm}</label></td>
						<td><label>설명 : </label>
							<label>${approvalPolicyLabel.note}</label></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="conWrap">
		<h3>목록</h3>
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
								<select id="searchCondition" title="승인정책 검색조건" class="selected_extension_approval_list">
									<option <c:if test="${approvalPolicyForm.searchField eq 'dept_nm'}">selected="selected"</c:if> value="dept_nm">부서</option>
									<c:if test="${ userInfoYn eq 'Y' }">
										<option <c:if test="${approvalPolicyForm.searchField eq 'users'}">selected="selected"</c:if> value="users">사용자</option>
									</c:if>>
								</select>
								<input type="text" class="text_input" style="max-width:70%;" id="searchValue" name="searchValue" value="${approvalPolicyForm.searchValue}"/>
								<button class="btn_common theme" onClick="search()">조회</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="popWrapCustom_area table_area_style01 hoverTable">
				<table summary="승인정책" style="table-layout : fixed" class="mg_t5">
				<c:choose>
					<c:when test="${ userInfoYn eq 'Y' }">
						<caption>부서, 사용자ID, 사용자명</caption>
						<colgroup>
							<col style="width:30%;" />
							<col style="width:35%;" />
							<col style="width:35%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder">부서</th>
								<th class="Rborder">사용자ID</th>
								<th class="Rborder">사용자명</th>	
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${paging.totalCount ne 0}">
									<c:forEach items="${approvalPolicyList}" var="approvalPolicy">
										<tr>
											<td class="t_center Rborder">
											<c:out value="${approvalPolicy.dept_nm}" /></td>
											<td class="t_center Rborder">
											<c:out value="${approvalPolicy.users_id}" /></td>
											<td class="t_center">
											<c:out value="${approvalPolicy.users_nm}" /></td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td class="t_center" colspan="3"><div class="no_result">결과가 없습니다.</div></td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="3" class="td_last">
								<span class="text_list_number"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></span>
								<div class="pagenate t_center">
									${pageList}
								</div>
								</td>
							</tr>
						</tfoot>
					</c:when>
					<c:otherwise>
						<jsp:include page="/WebUI/include/approvalPolicyDeptPopup.jsp"></jsp:include>
					</c:otherwise>
				</c:choose>
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