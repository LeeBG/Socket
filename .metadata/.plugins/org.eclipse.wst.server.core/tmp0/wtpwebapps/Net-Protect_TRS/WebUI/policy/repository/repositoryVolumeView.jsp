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

<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<!--  fancytree -->
<link rel="stylesheet" type="text/css" href="<c:url value="/css/ui.fancytree.css"/>">
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.js"/>"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.filter.js"/>"></script>

<script type="text/javascript">


	function save() {

		if( ! dateCheck($("input[name='start_date']").val(), $("input[name='end_date']").val(), "day" ) ) {
			alert("날짜가 올바르지 않습니다. 날짜를 확인해주세요.");
			return;
		}
		
		if (confirm("자료함 용량을 수정 하겠습니까?")) {

			var requestURL = "<c:url value="/policy/repository/repositoryVolume.lin" />";
			var successURL = "<c:url value="/policy/repository/repositoryVolumeMgt.lin" />";

			$("#users_id").changeReadonlyState("Y");
			$("input[name=users_id]").attr("disabled", false);
			$("#start_date").val($("#repoStartDateSpan").html());
			$("#end_date").val($("#repoEndDateSpan").html());
			
			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				var message = response['message'];
				if (code == '200') {
					alert(message);
					$(location).attr("href", successURL);
				} else {
					alert(message);
				}
			});
		}
	}

	$(document).ready(function() {
		checkFieldActivate(true);
		
		initRepoVolumePeriod();
	});

	function checkFieldActivate(isDisabled) {
		$("input[name=users_id]").attr("disabled", isDisabled);
		$("input[name=users_nm]").attr("disabled", isDisabled);
		$("input[name=position_nm]").attr("disabled", isDisabled);
		$("input[name=job_nm]").attr("disabled", isDisabled);
	}
</script>

<style type="text/css">
.readonly{
background:#ebebe4 !important;
cursor:not-allowed !important;
}
</style>
</head>
<body>
	<form id="lform" name="lform" onsubmit="return false;" method="post">
		<jsp:include page="/WebUI/policy/repository/include/includeRepositoryVolumeModule.jsp">
			<jsp:param name="start_date_value" value="${repository.start_date}" />
			<jsp:param name="end_date_value" value="${repository.end_date}" />
		</jsp:include>
		<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
		<input type="hidden" id="dept_nm" name="dept_nm" /> 
		<input type="hidden" id="dept_seq" name="dept_seq" />
		<input type="hidden" id="auth_cd" name="auth_cd" />
		<input type="hidden" id="cud_cd" name="cud_cd" value="${CUD_CD_U}" />
		<input type="hidden" id="volume_seq" name="volume_seq" value="${repository.volume_seq}" />
		<div class="rightArea">
			<div class="topWarp">
				<div class="titleBox">
					<h2 class="f_left text_bold">개별 자료함 용량 관리</h2>
					<p class="breadCrumbs">정책관리 > 개별 자료함 용량 관리</p>
				</div>
			</div>
			<div class="conWrap trisectionWrap">
				<div class="conWrap trisection">
					<h3>사용자 정보</h3>
					<div class="conBox">
						<div class="table_area_style02">
							<table summary="사용자 정보" style="table-layout: fixed;">
								<caption>사용자 정보</caption>
								<colgroup>
									<col style="width: 13%;" />
									<col style="width: 37%;" />
									<col style="width: 13%;" />
									<col style="width: 37%;" />
								</colgroup>
								<tbody>
									<tr>
										<th class="t_left">부서명</th>
										<td id="users_dept_nm" colspan="3"><span>${user.dept_nm }</span></td>
										
									</tr>
									<tr>
										<th class="t_left">성명</th>
										<td>
											<c:out value="${user.users_nm }"/>
										</td>
										<th class="t_left">${customfunc:getMessage('common.id.commonid')}</th>
										<td>
											<c:out value="${user.users_id }"/>
											<input type="hidden" id="users_id_input" name="users_id" value="${user.users_id }"/>
										</td>
									</tr>
									<tr>
										<th class="t_left">직급</th>
										<td>
											<c:out value="${ user.position_nm }"/>
										</td>
										<th class="t_left">직책</th>
										<td>
											<c:out value="${ user.job_nm }"/>
										</td>
									</tr>
									<tr>
										<th class="t_left">현재 파일전송정책</th>
										<td colspan="3">
											<span id="nowFilePolicy">
												<c:out value="${nowFilePolicyMgt.pol_nm }" />(<c:out value="${nowFilePolicyMgt.pol_seq }" />)
											</span>
										</td>
									</tr>
									<tr>
										<th class="t_left">현재 업무망 용량</th>
										<td>
											<fmt:formatNumber value="${ nowInnerFPolInfo.up_m_size }" pattern="#,###"/> MB
										</td>
										<th class="t_left">현재 인터넷망 용량</th>
										<td>
											<fmt:formatNumber value="${ nowOuterFPolInfo.up_m_size }" pattern="#,###"/> MB
										</td>
									</tr>
									<tr>
										<th class="t_left">용량증설 적용 기간</th>
										<td>
											<c:out value="${repository.start_date}" /> ~ <c:out value="${repository.end_date}" />
										</td>
										<th class="t_left">용량증설 상태</th>
										<td>
											<c:if test="${ repository.status != null }">
												<spring:message code="policy.repository.volume.status.${repository.status}" />
											</c:if>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="conWrap trisection">
					<h3>개별 자료함 용량 기간 변경</h3>
					<div class="conBox">
						<div class="table_area_style02">
							<table summary="개별 자료함 용량 관리 정보" style="table-layout: fixed;">
								<caption>개별 자료함 용량 관리 정보</caption>
								<colgroup>
									<col style="width: 13%;" />
									<col style="width: 37%;" />
									<col style="width: 13%;" />
									<col style="width: 37%;" />
								</colgroup>
								<tbody>
									<tr>
										<th class="t_left">적용 기간 변경</th>
										<td colspan="3">
											현재부터 <input type="text" class="text_input short t_center" id="repoPeriodInput" /> 일 적용&nbsp;&nbsp;( 적용 예정 기간 : <span id="repoStartDateSpan"></span> ~ <span id="repoEndDateSpan"></span> )
										</td>
									</tr>
									<tr>
										<th class="t_left">파일전송정책</th>
										<td colspan="3">
										<select title="파일전송정책" id="f_pol_seq" name="f_pol_seq">
											<c:choose>
												<c:when test="${not empty fPolFileMgtList}">
													<c:forEach items="${fPolFileMgtList}" var="fPolFileMgtList">
														<option value="<c:out value="${fPolFileMgtList.pol_seq}"/>" ${ (fPolFileMgtList.pol_seq eq repository.f_pol_seq) ? "selected" : ""}>
															<c:out value="${fPolFileMgtList.pol_nm}" />
														</option>
													</c:forEach>
												</c:when>
											</c:choose>
										</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="btn_area_center mg_t10 mg_b10">
							<c:if test="${auth_cd != 4}">
								<button type="button" class="btn_common" onclick="history.back()">뒤로가기</button>
								<!-- <button type="button" class="btn_common theme mg_l5" onclick="alert('삭제');">삭제</button> -->
								<button type="button" class="btn_common theme mg_l5" onclick="save()">저장</button>
							</c:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>