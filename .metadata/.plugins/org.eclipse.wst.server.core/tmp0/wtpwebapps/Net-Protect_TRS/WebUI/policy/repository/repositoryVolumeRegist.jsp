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
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<script type="text/javascript">
	//사용자 클릭 시 상세정보
	function userDetail() {
		setUserInfo();
	}
	
	function activeUserNode(event, data) {
		var node = data.node;
		if (!node.isFolder()) {
			$(".right input[type=text]").val("");
			$("#dept_seq").val(node.data.dept_seq);
			$("#users_id").val(node.data.users_id);
			$("#users_id_display").html(node.data.users_id);
			$("#users_nm").html(node.data.users_nm);
			$("#users_dept_nm").text(node.data.users_dept_nm);
			userDetail();
		}
	}

	function setUserInfo() {

		var requestURL = "<c:url value="/hr/user/treeUserInfo.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {

			var users = response['users'];
			var custom_add_yn = "N";
			
			$("#dept_seq");
			$("#users_nm");
			$("#position_nm").html(users.position_nm);
			$("#job_nm").html(users.job_nm);
			$("#f_pol_seq [value='" + users.f_pol_seq + "']").prop("selected", true);
			$("#nowFilePolicy").html($("#f_pol_seq [value='" + users.f_pol_seq + "']").html().trim() + "(" + users.f_pol_seq + ")");
			setRepositoryVolumeInfo();
			
		});
	}
	
	function setRepositoryVolumeInfo() {
		var requestURL = "<c:url value="/policy/repository/repositoryVolumeViewJson.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var repository = response['repository'];

			if(repository != null && repository != 'undefined' && repository.f_pol_seq != null && repository.f_pol_seq != "" && repository.f_pol_seq != 'undefined') {
				$("#now_start_date").html(repository.start_date);
				$("#now_end_date").html(repository.end_date);
				$("#f_pol_seq [value='" + repository.f_pol_seq + "']").prop("selected", true);
				$("#cud_cd").val('${CUD_CD_U}');
				$("#volumeStatus").html(repository.statusDiaplay);
				$("#volume_seq").val(repository.volume_seq);
			} else {
				$("#now_start_date").html("");
				$("#now_end_date").html("");
				$("#cud_cd").val('${CUD_CD_C}');
				$("#volumeStatus").html("&nbsp;");
				$("#volume_seq").val();
			}
			
			if(repository != null) {
				$("#nowInnerVolumeSize").html( numberWithCommas(repository.innerFPolFileInfo.up_m_size) );
				$("#nowOuterVolumeSize").html( numberWithCommas(repository.outerFPolFileInfo.up_m_size) );
			}
		});
	}

	function save() {

		if (empty($("#users_id").val())) {
			alert("사용자 선택이 되지 않았습니다.");
			return;
		}
		
		$("#start_date").val($("#repoStartDateSpan").html());
		$("#end_date").val($("#repoEndDateSpan").html());
		
		if (confirm("자료함 용량을 수정 하겠습니까?")) {

			var requestURL = "<c:url value="/policy/repository/repositoryVolume.lin" />";
			var successURL = "<c:url value="/policy/repository/repositoryVolumeMgt.lin" />";

			$("#users_id").changeReadonlyState("Y");
					
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
	
	function numberWithCommas(x) {
	  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	$(document).ready(function() {
		 initRepoVolumePeriod();
	});
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
		<jsp:include page="/WebUI/policy/repository/include/includeRepositoryVolumeModule.jsp" />
		<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
		<input type="hidden" id="dept_nm" name="dept_nm" /> 
		<input type="hidden" id="dept_seq" name="dept_seq" />
		<input type="hidden" id="auth_cd" name="auth_cd" />
		<input type="hidden" id="cud_cd" name="cud_cd" value="${CUD_CD_C}" />
		<input type="hidden" id="volume_seq" name="volume_seq"/>
		<div class="rightArea">
			<div class="topWarp">
				<div class="titleBox">
					<h2 class="f_left text_bold">개별 자료함 용량 관리</h2>
					<p class="breadCrumbs">정책관리 > 개별 자료함 용량 관리</p>
				</div>
			</div>
			<div class="conWrap trisectionWrap">
			
				<!-- 사용자 트리 include start -->
				<jsp:include page="/WebUI/hr/user/include/userTreeList.jsp" flush="false">
					<jsp:param value="N" name="onlyApprover"/>
					<jsp:param value="Y" name="inputInvisible"/>
					<jsp:param value="300" name="depttreeHeight"/>
					<jsp:param value="300" name="usertreeHeight"/>
					<jsp:param value="activeUserNode(event, data);" name="activeUserMethod"/>
				</jsp:include>
				<!-- 사용자 트리 include end -->
				
				<div class="conWrap trisection right">
					<h3>사용자 정보</h3>
					<div class="conBox">
						<div class="table_area_style02">
							<table summary="사용자 정보 수정" style="table-layout: fixed;">
								<caption>사용자 정보 수정</caption>
								<colgroup>
									<col style="width: 13%;" />
									<col style="width: 37%;" />
									<col style="width: 13%;" />
									<col style="width: 37%;" />
								</colgroup>
								<tbody>
									<tr>
										<th class="t_left">부서명</th>
										<td id="users_dept_nm" colspan="3"><span>&nbsp;</span></td>
										
									</tr>
									<tr>
										<th class="t_left">성명</th>
										<td>
											<span id="users_nm" name="users_nm" >&nbsp;</span>
										</td>
										<th class="t_left">${customfunc:getMessage('common.id.commonid')}</th>
										<td>
											<input type="hidden" id="users_id" name="users_id" />
											<span id="users_id_display">&nbsp;</span>
										</td>
									</tr>
									<tr>
										<th class="t_left">직급</th>
										<td>
											<span id="position_nm" name="position_nm" >&nbsp;</span>
										</td>
										<th class="t_left">직책</th>
										<td>
											<span id="job_nm" name="job_nm">&nbsp;</span>
										</td>
									</tr>
									<tr>
										<th class="t_left">현재 파일전송정책</th>
										<td colspan="3">
											<span id="nowFilePolicy">&nbsp;</span>
										</td>
									</tr>
									<tr>
										<th class="t_left">현재 업무망 용량</th>
										<td>
											<span id="nowInnerVolumeSize">0</span> MB
										</td>
										<th class="t_left">현재 인터넷망 용량</th>
										<td>
											<span id="nowOuterVolumeSize">0</span> MB
										</td>
									</tr>
									<tr>
										<th class="t_left">용량증설 적용 기간</th>
										<td>
											<span id="now_start_date">&nbsp;</span> ~ <span id="now_end_date">&nbsp;</span>
										</td>
										<th class="t_left">용량증설 상태</th>
										<td>
											<span id="volumeStatus">&nbsp;</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="conWrap trisection right">
					<h3>개별 자료함 용량 기간 변경</h3>
					<div class="conBox">
						<div class="table_area_style02">
							<table summary="사용자 정보 수정" style="table-layout: fixed;">
								<caption>사용자 정보 수정</caption>
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
															<option value="<c:out value="${fPolFileMgtList.pol_seq}"/>">
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
								<button type="button" class="btn_common theme mg_l5"
									onclick="save()">저장</button>
							</c:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>