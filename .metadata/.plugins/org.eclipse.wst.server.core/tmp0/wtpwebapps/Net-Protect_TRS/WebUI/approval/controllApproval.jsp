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
	function save() {
		if (confirm("사용자 결재정책을 수정 하겠습니까?")) {

			var requestURL = "<c:url value="/approval/approvalPolicy/updateUser.lin" />";
			var successURL = "<c:url value="/approval/controllApproval.lin" />";

			
			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				var message = response['message'];
				if (code == '200') {
					alert('사용자가 수정 되었습니다.');
				} else {
					alert(message);
				}
			});
		}
	}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/approval/controllApproval.lin" />">
	<input type="hidden"id="useMode" name="useMode" />
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<!-- contents -->
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold">결재정책 설정</h2>
			<p class="breadCrumbs">결재정책 설정</p>
		</div>
	</div>
	<div class="rightArea">
		<div class="conWrap tableBox">
			<h3>결재정책 설정</h3>
			<div class="conBox">
				<div class="table_area_style04">
					<table summary="인사DB동기화 셋팅" style="table-layout: fixed" >
						<caption>name, value, button</caption>
						<colgroup>
							<col style="width: 20%;" />
							<col style="width: 80%;" />
						</colgroup>
						<tbody id="values">
							<th class="Rborder">사용자 기본 결재 정책 설정</th>
							<td class="Rborder">
								<table summary="인사DB동기화 셋팅" style="table-layout: fixed" >
									<caption>name, value, button</caption>
									<colgroup>
										<col style="width: 25%;" />
										<col style="width: 25%;" />
										<col style="width: 25%;" />
									</colgroup>
									<tbody id="values">
										<tr>
											<th class="Rborder Tborder t_center">성명(아이디)</th>
											<th class="Rborder Tborder t_center">직급</th>
											<th class="Rborder Tborder t_center">결재정책</th>
										</tr>
										<c:choose>
											<c:when test="${not empty userList }">
												<c:forEach items="${userList}" var="user">
													<tr>
														<input type="hidden" id="users_id" name="users_id" <c:if test="${(user.position_nm != null || user.dept_seq == '1A') && user.custom_add_yn == 'N'}">style='cursor: no-drop;' disabled='disabled'</c:if> value="${user.users_id}" />
														<td class="Rborder Lborder t_center" >${user.users_nm}(${user.users_id})</td>
														<td class="Rborder Lborder t_center">
															<c:if test="${user.position_nm eq '' || user.position_nm eq null}">
																-
															</c:if>
															${user.position_nm}
														</td>
														<td class="Rborder Lborder t_center">
														<select id="a_pol_seq" name="a_pol_seq" 
														<c:if test="${(user.position_nm != null || user.dept_seq == '1A') && user.custom_add_yn == 'N'}"> title='직급이 있는 사용자나 안전기술원부서의 사용자는 정책을 설정 할 수 없습니다.' style='cursor: no-drop;' disabled='disabled'</c:if>>
															<c:choose>
																<c:when test="${not empty approvalPolicyList}">
																	<c:forEach items="${approvalPolicyList}" var="approvalPolicy">
																		<option value="${approvalPolicy.app_seq}" <c:if test="${approvalPolicy.app_seq eq user.a_pol_seq}">selected</c:if> >
																			<c:out value="${approvalPolicy.app_nm}" />
																		</option>
																	</c:forEach>
																</c:when>
															</c:choose>
														</select>
														</td>
													</tr>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<tr>
													<td class="t_center" colspan="3"><div class="no_result"><spring:message code="global.script.search.no.result" /></div></td>
												</tr>
											</c:otherwise>
										</c:choose>
									</tbody>
								</table>
							</td>
						</tbody>
					</table>
				</div>
				<div class="t_center mg_t30 mg_b30">
					<button class="btn_common theme" onclick="save()">저장</button>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>
