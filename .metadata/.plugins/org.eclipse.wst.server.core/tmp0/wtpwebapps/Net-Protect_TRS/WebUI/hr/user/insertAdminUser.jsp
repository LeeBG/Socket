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
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<script>
function initialize() {
	$("input[type=text]").val("");
	$("#l_pol_seq").val(1);
	$("#f_pol_seq").val(1);
}

function save() {
	var errmsg = new cls_errmsg();
	var auth_cd = $('#auth_cd').val();
	if (auth_cd == '1' || auth_cd == '15'){
		$('#auth_type').val('1');
	} else {
		$('#auth_type').val('3');
	}

	if (isVaildCheckUserManagement()){
		return;
	}
	var $admin_allow_ip = $("#inner_ip");
	var ip_arr = $admin_allow_ip.val() ? $admin_allow_ip.val().split(",") : null;
	
	if( empty($admin_allow_ip.val()) ) {
		errmsg.append($admin_allow_ip, "관리자 접속IP를 입력 하세요.");
    } else if( ip_arr ) {
        if( ip_arr.length > '${adminIpCount}' ){
            errmsg.append($admin_allow_ip, "관리자 접속IP는 ${adminIpCount}개까지 등록할 수 있습니다.");
        } else {
            for( var i=0; i<ip_arr.length ; i++ ){
                if( !isValidIP(ip_arr[i]) ) {
                    errmsg.append($admin_allow_ip, "IP의 형식을 확인해주세요. IP는 xxx.xxx.xxx.xxx 이어야 합니다.");
                    break;
                }
            }
        }
    }

	if (errmsg.haserror) {
		errmsg.show();
		return;
	}

	if (confirm("관리자를 추가 하겠습니까?" ) ){
		var dept_nm = '${dept_nm}';
		var dept_seq = '${dept_seq}';
		var requestURL = "<c:url value="/hr/user/updateAdminUser.lin" />";
		var successURL = "<c:url value="/hr/user/administratorManagement.lin" />";
	
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			if (code == '200') {
				//alert('사용자가 추가되었습니다.');
				alert(message);
				$(location).attr("href", successURL);
			} else if(code == '210'){
				alert(message);
//				alert('중복된 아이디 입니다. 아이디를 변경해 주세요.');
			} else if(code == '500'){
				alert(message);
			}else {
//				alert('사용자 추가 중 에러가 발생 되었습니다.');
				alert(message);
			}
		});
	}else{
		return;
	}
}
function isVaildCheckUserManagement(){
	if(empty($("#users_id").val())){
		alert("<spring:message code="vaild.message.model.adminManagement.users_id" />");
		return true;
	}
	if($("#users_id").val().length < 3 || $("#users_id").val().length > 30 ) {
		alert("ID는 3~30자로 입력 하세요.");
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
	/* if($("#inner_ip").val().length > 15){
		alert("<spring:message code="vaild.message.model.userManagement.inner_ip" />");
		return true;
	}
	if($("#outer_ip").val().length > 15){
		alert("<spring:message code="vaild.message.model.userManagement.outer_ip" />");
		return true;
	} */
	
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
	
	return false;
}


$(document).ready(function() {
	checkFocusMessage($("#users_id"),"최소 3자부터 최대 30자까지 가능합니다.");
	checkFocusMessage($("#users_nm"),"최대 10자까지 가능합니다.");
	checkFocusMessage($("#position_nm"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#job_nm"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#inner_ip"),"최대 ${adminIpMaxLength}자까지 가능합니다.");
	//checkFocusMessage($("#outer_ip"),"최대 15자까지 가능합니다.");
	//checkFocusMessage($("#inner_mac"),"최대 17자까지 가능합니다.");
	//checkFocusMessage($("#outer_mac"),"최대 17자까지 가능합니다.");
	checkFocusMessage($("#hp"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#email"),"최대 45자까지 가능합니다.");
	checkFocusMessage($("#note"),"최대 200자까지 가능합니다.");
});


</script>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/user/administratorManagement.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="a_pol_seq" name="a_pol_seq" value="A00001" />
<input name="auth_type" id="auth_type" type="hidden" value="3"/>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">관리자 관리</h2>
				<p class="breadCrumbs">인사관리 > 관리자 관리</p>
			</div>
		</div>
		<div class="conWrap">
			<h3>관리자 추가</h3>
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
								<th class="t_left"><font color="red"><b>*</b></font>&nbsp;아이디</th>
								<td><input type="text" class="text_input long" id="users_id" name="users_id" size="30" maxlength="30"/></td>
							</tr>
							<tr>
								<th class="Rborder t_left"><font color="red"><b>*</b></font>&nbsp;성명</th>
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
								<th class="Rborder t_left">직책</th>
								<td><input type="text" class="text_input long" id="job_nm" name="job_nm" size="15" maxlength="15"/></td>
							</tr>
							<tr>
								<th class="t_left"><font color="red"><b>*</b></font>&nbsp;권한</th>
								<td>
									<select title="권한정책" id="auth_cd" name="auth_cd">
										<c:choose>
										<c:when test="${not empty fAuthInfoList}">
											<c:forEach items="${fAuthInfoList}" var="fAuthInfoList">
													<option value="<c:out value="${fAuthInfoList.auth_cd}"/>">
													<c:out value="${fAuthInfoList.auth_cd_nm}"/>
													</option>
											</c:forEach>
										</c:when>
										</c:choose>
									</select>
								</td>
								<th></th>
								<td></td>				
							</tr>
							<tr class="none">
								<th class="t_left">로그인 정책</th>
								<td>
									<select title="로그인정책" id="l_pol_seq" name="l_pol_seq">
										<c:choose>
										<c:when test="${not empty cPolLoginMgtList}">
											<c:forEach items="${cPolLoginMgtList}" var="cPolLoginMgtList">
												<option value="<c:out value="${cPolLoginMgtList.login_seq}"/>">
													<c:out value="${cPolLoginMgtList.login_nm}"/>
												</option>
											</c:forEach>
										</c:when>
										</c:choose>
									</select>
								</td>
								<th class="t_left">파일전송정책</th>
								<td>
									<select title="파일전송정책" id="f_pol_seq" name="f_pol_seq">
										<c:choose>
										<c:when test="${not empty fPolFileMgtList}">
											<c:forEach items="${fPolFileMgtList}" var="fPolFileMgtList">
												<option value="<c:out value="${fPolFileMgtList.pol_seq}"/>">
													<c:out value="${fPolFileMgtList.pol_nm}"/>
												</option>
											</c:forEach>
										</c:when>
										</c:choose>
									</select>
								</td>
							</tr>
							<tr>
								<th class="Rborder t_left"><font color="red"><b>*</b></font>&nbsp;관리자 접속IP</th>
								<!-- <th class="t_left">관리자 접속IP</th> -->
								<td colspan="3">
									<input type="text" class="text_input long" id="inner_ip" name="inner_ip" onkeyup="onlySizeFillter(this,'${adminIpMaxLength}')"/>
									<p class="helpBox mg_t20" id="pwd_explanation">관리자 접속IP는 ','로 구분 하여 ${adminIpCount}개 까지 가능</p>
								</td>
							</tr>
							<!-- <tr>
								<th class="t_left">보안영역 허용IP</th>
								<td class="i_ip"><input type="text" class="text_input long" id="inner_ip" name="inner_ip" placeholder="xxx.xxx.xxx.xxx"/></td>
								<th class="t_left">비-보안영역 허용IP</th>
								<td class="o_ip"><input type="text" class="text_input long" id="outer_ip" name="outer_ip" placeholder="xxx.xxx.xxx.xxx"/></td>
							</tr> -->
							<tr class="none">
								<th class="t_left">보안영역 허용MAC</th>
								<td class="i_ip"><input type="text" class="text_input long" id="inner_mac" name="inner_mac" placeholder="xx-xx-xx-xx-xx-xx"/></td>
								<th class="t_left">비-보안영역 허용MAC</th>
								<td class="o_ip"><input type="text" class="text_input long" id="outer_mac" name="outer_mac" placeholder="xx-xx-xx-xx-xx-xx"/></td>
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