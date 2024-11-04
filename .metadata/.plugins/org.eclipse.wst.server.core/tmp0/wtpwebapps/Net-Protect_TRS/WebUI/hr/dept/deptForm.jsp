<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<%//request.getHeader("referer");%>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<script>
/* function initialize() {
	$("input[type=text]").val("");
	$("#l_pol_seq").val(1);
	$("#f_pol_seq").val(1);
} */

function save() {
	if(isVaildCheckDept()){
		return false;
	}

	if (confirm("저장 하겠습니까?" )) {
		var errmsg = new cls_errmsg();
		if (errmsg.haserror) {
			errmsg.show();
			return;
		}
		var requestURL = "<c:url value="/fm/pl/insertFMPL0700.lin" />";
		var successURL = "<c:url value="/hr/dept/deptManagement.lin" />";
	
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			if (code == '200') {
				alert('부서가 추가되었습니다.');
				$(location).attr("href", successURL);
			} else if(code == '210'){
				alert('중복된 부서 아이디 입니다. 아이디를 변경해 주세요.');
			} else {
				alert('부서 추가 중 에러가 발생 되었습니다.');
			}
		});
	}else{
		return;
	}
}

function isVaildCheckDept(){
	if(empty($("#dept_seq").val())){
		alert("<spring:message code="vaild.message.model.deptManagement.dept_seq" />");
		return true;
	}
	if(empty($("#dept_nm").val())){
		alert("<spring:message code="vaild.message.model.deptManagement.dept_nm" />");
		return true;
	}
	if($("#note").val().length > 100){
		alert("<spring:message code="vaild.message.model.deptManagement.note" />");
		return true;
	}
	if(empty($("#l_pol_seq option:selected").val())){
		alert("<spring:message code="vaild.message.model.deptManagement.l_pol_seq" />");
		return true;
	}
	if(empty($("#f_pol_seq option:selected").val())){
		alert("<spring:message code="vaild.message.model.deptManagement.f_pol_seq" />");
		return true;
	}
	return false;
}

$(document).ready(function() {
	checkFocusMessage($("#dept_nm"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#note"),"최대 200자까지 가능합니다.");
	$("input[name=dept_seq]").attr("readonly",true);
	$("input[name=dept_seq]").attr("style","background-color:#D4D0C8;");
});

</script>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/fm/pl/FMPL0800.lin" />">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">부서 관리</h2>
				<p class="breadCrumbs">인사관리 > 부서 관리</p>
			</div>
		</div>
		<div class="conWrap">
			<h3>부서 추가</h3>
			<div class="conBox">
				<div class="table_area_style02">
					<table cellspacing="0" cellpadding="0" summary="하위메뉴 권한설정" style="table-layout : fixed;">
					<caption>메뉴명,허용여부</caption>
						<colgroup>
							<col style="width:10%;"/>
							<col style="width:40%;"/>
							<col style="width:10%;" />
							<col style="width:40%;" />
						</colgroup>
						<tbody>
							<tr>
								<th class="t_left">부서명</th>
								<td><input type="text" class="text_input long" id="dept_nm" name="dept_nm" size="15" maxlength="15"/>
								<input type="hidden" class="text_input long" id="p_dept_seq" name="p_dept_seq" value="${p_dept_seq}"/>
								<input type="hidden" class="text_input long" id="depth" name="depth" value="${depth}"/>
								<input type="hidden" id="cud_cd" name="cud_cd" value="${CUD_CD_C}"/>
								</td>
								<th class="t_left">부서 아이디</th>
								<td><input type="text" class="text_input long" id="dept_seq" name="dept_seq" size="15" maxlength="15" readonly="readonly" value="${createDeptSeq }" /></td>
							</tr>
							
							<tr>
										<th class="t_left">로그인 정책</th>
										<td><select title="로그인정책" id="l_pol_seq" name="l_pol_seq">
												<c:choose>
													<c:when test="${not empty cPolLoginMgtList}">
														<c:forEach items="${cPolLoginMgtList}"
															var="cPolLoginMgtList">
															<option
																value="<c:out value="${cPolLoginMgtList.login_seq}"/>">
																<c:out value="${cPolLoginMgtList.login_nm}" />
															</option>
														</c:forEach>
													</c:when>
												</c:choose>
										</select></td>
										<th class="t_left">파일전송정책</th>
										<td><select title="파일전송정책" id="f_pol_seq"
											name="f_pol_seq">
												<c:choose>
													<c:when test="${not empty fPolFileMgtList}">
														<c:forEach items="${fPolFileMgtList}"
															var="fPolFileMgtList">
															<option
																value="<c:out value="${fPolFileMgtList.pol_seq}"/>">
																<c:out value="${fPolFileMgtList.pol_nm}" />
															</option>
														</c:forEach>
													</c:when>
												</c:choose>
										</select></td>
									</tr>
									<tr>
										<th class="t_left">결재정책</th>
										<td><select title="결재정책" id="a_pol_seq" name="a_pol_seq">
												<c:choose>
													<c:when test="${not empty approvalPolicyList}">
														<c:forEach items="${approvalPolicyList}"
															var="approvalPolicy">
															<option
																value="<c:out value="${approvalPolicy.app_seq}"/>">
																<c:out value="${approvalPolicy.app_nm}" />
															</option>
														</c:forEach>
													</c:when>
												</c:choose>
										</select></td>
										<th class="t_left">자료보존정책</th>
										<td><select title="자료보존정책" id="fp_pol_seq"
											name="fp_pol_seq">
												<c:choose>
													<c:when test="${not empty fPreservationPolMgtFormList}">
														<c:forEach items="${fPreservationPolMgtFormList}"
															var="fPreservationPolMgtForm">
															<option
																value="<c:out value="${fPreservationPolMgtForm.pol_seq}"/>">
																<c:out value="${fPreservationPolMgtForm.pol_nm}" />
															</option>
														</c:forEach>
													</c:when>
												</c:choose>
										</select></td>
									</tr>

							<tr>
								<th class="t_left">Note.</th>
								<td colspan="3"><input type="text" class="text_input" id="note" name="note" size="200" maxlength="200"/></td>
							</tr>
							<tr>
								<th class="t_left">사용여부</th>
								<td colspan="3">
									<input type="radio" name="use_yn" id="use"  value="Y" checked="checked"/>
									<label for="use" class="mg_r10" >사용</label>
									<input type="radio" name="use_yn" id="unUsed"  value="N"/>
									<label for="unUsed">미사용</label>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_area_center mg_t10 mg_b10">
					<button type="button" class="btn_common theme mg_l5" onclick="save()">저장</button>
					<button type="button" class="btn_common theme" onclick = "history.back()">뒤로가기</button>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>