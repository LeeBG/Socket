<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<%@include file="/WebUI/include/encryptUtil.jsp" %>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<script type="text/javascript">
</script>
	<title>망연계 자료전송 시스템</title>
</head>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="userIdText" value="${customfunc:getMessage('common.id.commonid')}"/>
<script>
function initialize() {
	$("input[type=text]").val("");
	$("#l_pol_seq").val('L00001');
	$("#f_pol_seq").val('F00001');
	$("#a_pol_seq").val('A00001');
	$("#fp_pol_seq").val('F00001');
}

function save() {
	var auth_cd = $('#auth_cd').val();
	if (auth_cd == '1' || auth_cd == '15'){
		$('#auth_type').val('1');
	} else {
		$('#auth_type').val('3');
	}

	if (isVaildCheckUserManagement()){
		return;
	}

	if (confirm("사용자를 추가 하겠습니까?" ) ){
		var dept_nm = '${dept_nm}';
		var dept_seq = '${dept_seq}';
		var requestURL = "<c:url value="/hr/user/updateUser.lin" />";
		var successURL = "<c:url value="/hr/user/userManagement.lin" />";
	
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			if (code == '200') {
				alert(message);
				//alert('사용자가 추가되었습니다.');
				$(location).attr("href", successURL);
			} else if(code == '210'){
				alert('중복된 ${userIdText} 입니다. ${userIdText}를 변경해 주세요.');
			} else if(code == '500'){
				alert(message);
			}else {
				alert('사용자 추가 중 에러가 발생 되었습니다.');
			}
		});
	}else{
		return;
	}
}
function isVaildCheckUserManagement(){
	if(empty($("#users_id").val())){
		alert('<spring:message code="vaild.message.model.userManagement.users_id" arguments="${userIdText}"/>');
		return true;
	}
	if($("#users_id").val().length < 3 || $("#users_id").val().length > 15 ) {
		alert("ID는 3~15자로 입력 하세요.");
		return true;
	}	
	if(empty($("#users_nm").val())){
		alert("<spring:message code="vaild.message.model.userManagement.users_nm" />");
		return true;
	}
	
	if(empty($("#l_pol_seq option:selected").val())){
		alert("<spring:message code="vaild.message.model.userManagement.l_pol_seq" />");
		return true;
	}
	if(empty($("#f_pol_seq option:selected").val())){
		alert("<spring:message code="vaild.message.model.userManagement.f_pol_seq" />");
		return true;
	}
	/* if(empty($("#a_pol_seq option:selected").val())){
		alert("<spring:message code="vaild.message.model.userManagement.a_pol_seq" />");
		return true;
	} */
	
	if($("#inner_ip").val().length > 15){
		alert("<spring:message code="vaild.message.model.userManagement.inner_ip" />");
		return true;
	}
	if($("#outer_ip").val().length > 15){
		alert("<spring:message code="vaild.message.model.userManagement.outer_ip" />");
		return true;
	}
	
	/* if($("#inner_mac").val().length > 17){
		alert("<spring:message code="vaild.message.model.userManagement.inner_mac" />");
		return true;
	}
	if($("#outer_mac").val().length > 17){
		alert("<spring:message code="vaild.message.model.userManagement.outer_mac" />");
		return true;
	} */
	
	if($("#hp").val().length > 15){
		alert("<spring:message code="vaild.message.model.userManagement.hp" />");
		return true;
	}
	if($("#email").val().length > 45){
		alert("<spring:message code="vaild.message.model.userManagement.email" />");
		return true;
	}
	
	<%-- ip 형식 검증 --%>
	if( $("#inner_ip").val().length != 0 && ! isValidIP2($("#inner_ip").val())){ 
		alert("보안영역 IP 형식이 올바르지 않습니다.");
		return true;
	}
	if( $("#outer_ip").val().length != 0 && ! isValidIP2($("#outer_ip").val())){ 
		alert("비-보안영역 IP 형식이 올바르지 않습니다.");
		return true;
	}
	
	return false;
}

$(document).ready(function() {
	checkFocusMessage($("#users_id"),"최소 3자부터 최대 15자까지 가능합니다.");
	checkFocusMessage($("#users_nm"),"최대 10자까지 가능합니다.");
	checkFocusMessage($("#position_nm"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#job_nm"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#inner_ip"),"최대 15자까지 가능합니다.(1.1.1.1 ~ 255.255.255.254)");
	checkFocusMessage($("#outer_ip"),"최대 15자까지 가능합니다.(1.1.1.1 ~ 255.255.255.254)");
	//checkFocusMessage($("#inner_mac"),"최대 17자까지 가능합니다.(xx:xx:xx:xx:xx:xx)");
	//checkFocusMessage($("#outer_mac"),"최대 17자까지 가능합니다.(xx:xx:xx:xx:xx:xx)");
	checkFocusMessage($("#hp"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#email"),"최대 45자까지 가능합니다.");
	checkFocusMessage($("#note"),"최대 200자까지 가능합니다.");
	
	
	$("#l_pol_seq").val('L00001');
	$("#f_pol_seq").val('F00001');
	$("#a_pol_seq").val('A00001');
	$("#fp_pol_seq").val('F00001');
});


</script>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/user/insertUser.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input name="auth_type" id="auth_type" type="hidden" value="3"/>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">사용자 관리</h2>
				<p class="breadCrumbs">인사관리 > 사용자 관리</p>
			</div>
		</div>
		<div class="conWrap">
			<h3>사용자 추가</h3>
			<div class="conBox">
				<div class="table_area_style02">
					<table summary="하위메뉴 권한설정" style="table-layout : fixed;">
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
								<td>${dept_nm}
								<input type="hidden" id="dept_seq" name="dept_seq" value="${dept_seq}"/>
								<input type="hidden" id="cud_cd" name="cud_cd" value="${CUD_CD_C}"/>
								<input type="hidden" id="allow_ip" name="allow_ip"/>
								<input type="hidden" id="allow_ip_i" name="allow_ip_i"/>
								<input type="hidden" id="allow_ip_o" name="allow_ip_o"/>
								</td>
								<th class="t_left"><font color="red"><b>*</b></font>&nbsp;${userIdText}</th>
								<td><input type="text" class="text_input long" id="users_id" name="users_id" size="15" maxlength="15"/></td>
							</tr>
							<tr>
								<th class="t_left"><font color="red"><b>*</b></font>&nbsp;성명</th>
								<td><input type="text" class="text_input long" id="users_nm" name="users_nm" size="10" maxlength="10"/></td>
								<th class="t_left"><font color="red"><b>*</b></font>&nbsp;사용여부</th>
								<td colspan="3">
									<input type="radio" name="use_yn" id="use_y"  value="Y" checked="checked"/>
									<label for="use" class="mg_r10" >사용</label>
									<input type="radio" name="use_yn" id="use_n"  value="N"/>
									<label for="unUsed">미사용</label>
								</td>
							</tr>
							<tr>
								<th class="t_left">직급</th>
								<td><input type="text" class="text_input long" id="position_nm" name="position_nm" size="15" maxlength="15"/></td>
								<th class="t_left">직책</th>
								<td><input type="text" class="text_input long" id="job_nm" name="job_nm" size="15" maxlength="15"/></td>
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
								<th class="t_left">보안영역 허용IP</th>
								<td class="i_ip"><input type="text" class="text_input long" id="inner_ip" name="inner_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx"/></td>
								<th class="t_left">비-보안영역 허용IP</th>
								<td class="o_ip"><input type="text" class="text_input long" id="outer_ip" name="outer_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx"/></td>
							</tr>
							<tr class="none">
								<th class="t_left">보안영역 허용MAC</th>
								<td class="i_ip"><input type="text" class="text_input long" id="inner_mac" name="inner_mac" placeholder="xx:xx:xx:xx:xx:xx"/></td>
								<th class="t_left">비-보안영역 허용MAC</th>
								<td class="o_ip"><input type="text" class="text_input long" id="outer_mac" name="outer_mac" placeholder="xx:xx:xx:xx:xx:xx"/></td>
							</tr>
							<tr>
								<th class="t_left">Mobile</th>
								<td><input type="text" class="text_input long" id="hp" name="hp" size="15" maxlength="15"/></td>
								<th class="t_left">E-mail</th>
								<td><input type="text" class="text_input long" id="email" name="email" size="45" maxlength="45"/></td>
							</tr>
							<tr>
								<!-- <th class="t_left">자가결재</th>
								<td> 
									<input type="radio" name="self_approval_yn" id="self_approval_y" value="Y" />
									<label for="use" class="mg_r10" >허용</label>
									<input type="radio" name="self_approval_yn" id="self_approval_y" value="N" checked="checked"/>
									<label for="unUsed">허용안함</label>
								</td> -->
							</tr>
							<tr>
								<th class="t_left">Note.</th>
								<td colspan="3"><input type="text" class="text_input" id="note" name="note" size="200" maxlength="200"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_area_center mg_t10 mg_b10">
					<button type="button" class="btn_common" onclick="initialize()">초기화</button>
					<button type="button" class="btn_common theme mg_l5" onclick="save()">저장</button>
					<button type="button" class="btn_common theme" onclick = "history.back()">뒤로가기</button>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>