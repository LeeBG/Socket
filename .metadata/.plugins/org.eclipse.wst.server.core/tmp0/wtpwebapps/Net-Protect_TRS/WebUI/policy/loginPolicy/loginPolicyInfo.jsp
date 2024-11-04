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

<c:set var="login_ss_keep_time_min" value="${customfunc:miniMaxInteger('login_ss_keep_time_min')}" />
<c:set var="login_ss_keep_time_max" value="${customfunc:miniMaxInteger('login_ss_keep_time_max')}" />
<c:set var="login_ss_keep_time_cs_min" value="${customfunc:miniMaxInteger('login_ss_keep_time_cs_min')}" />
<c:set var="login_ss_keep_time_cs_max" value="${customfunc:miniMaxInteger('login_ss_keep_time_cs_max')}" />
<c:set var="login_pw_len_min_min" value="${customfunc:miniMaxInteger('login_pw_len_min_min')}" />
<c:set var="login_pw_len_min_max" value="${customfunc:miniMaxInteger('login_pw_len_min_max')}" />
<c:set var="login_pw_len_max_min" value="${customfunc:miniMaxInteger('login_pw_len_max_min')}" />
<c:set var="login_pw_len_max_max" value="${customfunc:miniMaxInteger('login_pw_len_max_max')}" />
<c:set var="login_pw_cycle_min" value="${customfunc:miniMaxInteger('login_pw_cycle_min')}" />
<c:set var="login_pw_cycle_max" value="${customfunc:miniMaxInteger('login_pw_cycle_max')}" />

<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<style type="text/css">
label{
	cursor: pointer;
	position:relative;
	top: -1px;
	font-size:1em;
}
</style>

<script type="text/javascript">

var login_ss_keep_time_min = "${login_ss_keep_time_min}";
var login_ss_keep_time_max = "${login_ss_keep_time_max}";
var login_ss_keep_time_cs_min = "${login_ss_keep_time_cs_min}";
var login_ss_keep_time_cs_max = "${login_ss_keep_time_cs_max}";
var login_pw_len_min_min = "${login_pw_len_min_min}";
var login_pw_len_min_max = "${login_pw_len_min_max}";
var login_pw_len_max_min = "${login_pw_len_max_min}";
var login_pw_len_max_max = "${login_pw_len_max_max}";
var login_pw_cycle_min = "${login_pw_cycle_min}";
var login_pw_cycle_max = "${login_pw_cycle_max}";

function ssKeepTimeCsSetting(){
	if($("#no-limit").is(":checked") == true){
		$("#ss_keep_time_cs").attr("disabled",true);
		$("#ss_keep_time_cs").css("cursor","no-drop");
	}
	
	$("#no-limit").click(function(){
		if($("#no-limit").is(":checked") == true){
			$("#ss_keep_time_cs").attr("disabled",true);
			$("#ss_keep_time_cs").css("cursor","no-drop");
		}else{
			$("#ss_keep_time_cs").attr("disabled",false);
			$("#ss_keep_time_cs").css("cursor","auto");
		}
	});
}

function initialize() {
	window.location.reload();
}

function cancel() {
	location.href = "<c:url value="/policy/loginPolicy/loginPolicyMgt.lin" />";
}

function save() {
	titleFilter('login_nm', 'note');
	var errmsg = new cls_errmsg();

	if (empty($("#login_seq").val())) {
		errmsg.append($("#login_seq"), "정책 ID가 올바르지 않습니다.");
	} else if (empty($("#login_nm").val())) {
		errmsg.append($("#login_nm"), "정책명이 올바르지 않습니다.");
	} else if($("#login_nm").val().length > 50){
		errmsg.append($("#login_nm"), "정책명은 50자 이하로 입력 하세요.");
	}else if ($("#note").val().length > 100){
		errmsg.append($("#login_nm"), "설명은 100자 이하로 입력 하세요.");
	} else if(!isNumber($("#ss_keep_time").val()) || !isValidSameRange($("#ss_keep_time").val(), login_ss_keep_time_min, login_ss_keep_time_max)){
		errmsg.append($("#ss_keep_time"), "<spring:message code="vaild.message.model.loginPolicy.ss_keep_time" />");
	} else if(!isNumber($("#ss_keep_time_cs").val()) || !isValidSameRange($("#ss_keep_time_cs").val(), login_ss_keep_time_cs_min, login_ss_keep_time_cs_max)){
		errmsg.append($("#ss_keep_time_cs"), "<spring:message code="vaild.message.model.loginPolicy.ss_keep_time" />");
	} else if(!isNumber($("#pw_len_min").val()) || !isValidSameRange($("#pw_len_min").val(), login_pw_len_min_min, login_pw_len_min_max)){
		errmsg.append($("#pw_len_min"), "<spring:message code="vaild.message.model.loginPolicy.pw_len_min" />");
	} else if(!isNumber($("#pw_len_max").val()) || !isValidSameRange($("#pw_len_max").val(), login_pw_len_max_min, login_pw_len_max_max)){
		errmsg.append($("#pw_len_max"), "<spring:message code="vaild.message.model.loginPolicy.pw_len_max" />");
	} else if(Number($("#pw_len_min").val()) > Number($("#pw_len_max").val())){
		errmsg.append(null, "<spring:message code="vaild.message.model.loginPolicy.pw_len_max" />");
	} else if(!isNumber($("#pw_cycle").val()) || !isValidSameRange($("#pw_cycle").val(), login_pw_cycle_min, login_pw_cycle_max)){
		errmsg.append($("#pw_len_min"), "<spring:message code="vaild.message.model.loginPolicy.pw_cycle" />");
	} else if(empty($(":input:radio[name=fail_cnt]:checked").val())){
		errmsg.append(null, "<spring:message code="vaild.message.model.loginPolicy.fail_cnt" />");
	} else if(empty($(":input:radio[name=fail_delay]:checked").val())){
		errmsg.append(null, "<spring:message code="vaild.message.model.loginPolicy.fail_delay" />");
	} else if($("#f_pw").val().length > 20){
		errmsg.append($("#f_pw"), "초기 패스워드는 20자 까지 가능합니다.");
	}

	<c:if test="${cPolLoginMgtForm.login_seq eq 'L00002'}">
	var $admin_allow_ip = $("#admin_allow_ip");
	var ip_arr = $admin_allow_ip.val() ? $admin_allow_ip.val().split(",") : null;
	
	if(!isNumber($("#pw_len_min").val()) || !isValidSameRange($("#pw_len_min").val(), login_pw_len_min_min, login_pw_len_min_max)){
		errmsg.append($("#f_pw"), "초기 패스워드는 20자 까지 가능합니다.");
	} else if( empty($admin_allow_ip.val()) ){
		errmsg.append($admin_allow_ip, "관리자 접속IP를 입력 하세요.");
	} else if( ip_arr ){
		if( ip_arr.length > 4 ){
			errmsg.append($admin_allow_ip, "관리자 접속IP는 4개까지 등록할 수 있습니다.");
		}else{
			for( var i=0; i<ip_arr.length ; i++ ){
				if( !isValidIP(ip_arr[i]) ){
					errmsg.append($admin_allow_ip, "IP의 형식을 확인해주세요. IP는 xxx.xxx.xxx.xxx 이어야 합니다.");
					break;
				}
			}
		}
	}
	</c:if>
	
	
	if (errmsg.haserror) {
		errmsg.show();
		return;
	}
	
	var requestURL = "<c:url value="/policy/loginPolicy/insertCPolLoginMgt.lin" />";
	var successURL = "<c:url value="/policy/loginPolicy/loginPolicyMgt.lin" />";

	$(":button").attr("disabled", true);
	resultCheckFunc($("#lform"), requestURL, function(response) {
		$(":button").attr("disabled", false);
		resultSuccess(response, successURL, true);
	});
}

$(document).ready(function() {
	<c:if test="${customfunc:cacheString('csAgentUseYN') eq 'N'}">
		$(".cs_layout").css("display","none");
	</c:if>
	<c:if test="${auth_cd != 1}">
	allInputDisable();
	</c:if>
	allOffInputKeyDown();

	checkFocusMessage($("#login_nm"),"최대 50자까지 입력이 가능합니다.");
	checkFocusMessage($("#note"),"최대 100자까지 입력이 가능합니다.");
	checkFocusMessage($("#ss_keep_time"), "최소 " + login_ss_keep_time_min+ " ~ "+ login_ss_keep_time_max +"분까지 입력이 가능합니다.");
	checkFocusMessage($("#ss_keep_time_cs"), "최소 " + login_ss_keep_time_cs_min+ " ~ "+ login_ss_keep_time_cs_max +"시간까지 입력이 가능합니다.");
	checkFocusMessage($("#pw_len_min"), "최소 " + login_pw_len_min_min+ " ~ "+ login_pw_len_min_max +"까지 입력이 가능합니다.");
	checkFocusMessage($("#pw_len_max"), "최소 " + login_pw_len_max_min+ " ~ "+ login_pw_len_max_max +"까지 입력이 가능합니다.");
	checkFocusMessage($("#pw_cycle"), "최소 " + login_pw_cycle_min+ " ~ "+ login_pw_cycle_max +"까지 입력이 가능합니다.");
	checkFocusMessage($("#f_pw"), "최대 20까지 입력이 가능합니다.");
	<c:if test="${cPolLoginMgtForm.login_seq eq 'L00002'}">
	checkFocusMessage($("#admin_allow_ip"), "63자 까지 입력이 가능합니다.(xxx.xxx.xxx.xxx,xxx.xxx.xxx.xxx)");
	</c:if>
	ssKeepTimeCsSetting();
});
</script>

</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/policy/loginPolicy/loginPolicyMgt.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="cud_cd" name="cud_cd" value="${cud_cd}">
<input type="hidden" id="crt_id" name="crt_id" value="${cPolLoginMgtForm.crt_id}">
<input type="hidden" id="isdel_yn" name="isdel_yn" value="${cPolLoginMgtForm.isdel_yn}">
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">로그인정책 관리</h2>
				<p class="breadCrumbs">정책관리 > 로그인정책 관리</p>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>로그인 정책</h3>
			<div class="conBox">
				<div class="topCon" >
					<table summary="로그인정책" style="table-layout : fixed" >
					<caption>정책ID, 정책명, 설명</caption>
						<colgroup>
							<col style="width:7%;"/>
							<col style="width:10%;" />
							<col style="width:5%;" />
							<col style="width:24%;" />
							<col style="width:5%;" />
							<col style="width:44%;" />
						</colgroup>
						<tbody>
							<tr>
								<th class="t_center">정책ID</th>
								<td class=""><input type="text" class="text_input" id="login_seq" name="login_seq" value="${cPolLoginMgtForm.login_seq}" readonly="readonly" /></td>
								<th class="t_center">정책명</th>
								<td class=""><input type="text" class="text_input" id="login_nm" name="login_nm" onkeyup="onlySizeFillter(this, 50)" size="50" value="${cPolLoginMgtForm.login_nm}" /></td>
								<th class="t_center">설명</th>
								<td class=""><input type="text" class="text_input" id="note" style="width:90%;" name="note" onkeyup="onlySizeFillter(this,100)" size="100" value="${cPolLoginMgtForm.note}" /></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="table_area_style02 Tborder">
					<table summary="로그인정책 설정" style="table-layout : fixed">
					<caption>로그인정책 설정</caption>
						<colgroup>
							<col style="width:15%;"/>
							<col style="width:85%;" />
						</colgroup>
						<tbody>
							<%-- <tr>
								<th class="no_border t_left">중복로그인</th>
								<td>
									<input type="radio" id="dupl_login_Y" name="dupl_login_yn" value="Y" ${cPolLoginMgtForm.dupl_login_yn == "Y" ? ' checked' : ''} /><label for="dupl_login_Y" class="mg_r30">허용</label>
									<input type="radio" id="dupl_login_N" name="dupl_login_yn" value="N" ${cPolLoginMgtForm.dupl_login_yn == "N" ? ' checked' : ''} /><label for="dupl_login_N">차단</label>
								</td>
							</tr> --%>
							<tr>
								<th class="t_left">세션 유지 시간<span class="cs_layout">(WEB)</span></th>
								<td>
									<input type="text" class="text_input short t_center" id="ss_keep_time" name="ss_keep_time" onkeyup="onlyNumBetweenFillter(this,${fn:length(login_ss_keep_time_max)},${login_ss_keep_time_min},${login_ss_keep_time_max})" value="${cPolLoginMgtForm.ss_keep_time}"/> 분
								</td>
							</tr>
							<tr class="cs_layout">
								<th class="t_left">세션 유지 시간(CS)</th>
								<c:choose>
									<c:when test="${cPolLoginMgtForm.login_seq ne 'L00002'}">
										<td>
											<input type="text" class="text_input short t_center" id="ss_keep_time_cs" name="ss_keep_time_cs" onkeyup="onlyNumBetweenFillter(this,${fn:length(login_ss_keep_time_cs_max)},${login_ss_keep_time_cs_min},${login_ss_keep_time_cs_max})" value="${cPolLoginMgtForm.ss_keep_time_cs}"/> 시간
											<input type="checkbox" id="no-limit" name="ss_keep_time_cs" value="25" style="margin-left:20px;" ${cPolLoginMgtForm.is_no_limit ? 'checked': ''}/>
											<label for="no-limit">제한 없음</label>
										</td>
									</c:when>
									<c:otherwise>
										<td style="color: #dcdcdc;">
											<input type="text" class="text_input short t_center" id="ss_keep_time_cs" name="ss_keep_time_cs" style="cursor: no-drop;" disabled value="${cPolLoginMgtForm.ss_keep_time_cs}"/> 시간
											<input type="checkbox" id="no-limit-chk" style="margin-left:20px;cursor: no-drop;" disabled/>
											<label for="no-limit-chk" style="cursor: no-drop;">제한 없음</label>
										</td>
									</c:otherwise>
								</c:choose>
							</tr>
							<tr>
								<th class="t_left">패스워드 복잡도</th>
								<td>
									<p class="mg_b10">패스워드는 <input type="text" class="text_input short t_center" id="pw_len_min" name="pw_len_min" onkeyup="onlyNumBetweenFillter(this, ${fn:length(login_pw_len_min_max)}, ${login_pw_len_min_min}, ${login_pw_len_min_max})" value ="${cPolLoginMgtForm.pw_len_min}" /> 자 이상,
									&nbsp;<input type="text" class="text_input short t_center" id="pw_len_max" name="pw_len_max" onkeyup="onlyNumBetweenFillter(this, ${fn:length(login_pw_len_max_max)}, ${login_pw_len_max_min}, ${login_pw_len_max_max})" value ="${cPolLoginMgtForm.pw_len_max}" /> 자 이하</p>
									<%-- <p class="mg_b5"><input type="radio" id="pw_cpxy_1" name="pw_cpxy_cd" value="1" ${cPolLoginMgtForm.pw_cpxy_cd == "1" ? ' checked' : ''} /><label for="pw_cpxy_1">영문</label></p>
									<p class="mg_b5"><input type="radio" id="pw_cpxy_2" name="pw_cpxy_cd" value="2" ${cPolLoginMgtForm.pw_cpxy_cd == "2" ? ' checked' : ''} /><label for="pw_cpxy_2">영문, 숫자 조합</label></p> 
									<p class="mg_b5"><input type="radio" id="pw_cpxy_3" name="pw_cpxy_cd" value="3" ${cPolLoginMgtForm.pw_cpxy_cd == "3" ? ' checked' : ''} /><label for="pw_cpxy_3">영문, 숫자 특수문자 조합</label></p> --%>
									<p class="helpBox mg_t20" id="pwd_explanation">영문, 숫자 특수문자 조합 ${pwd_explanation}</p>
								</td>
							</tr>
							<tr>
								<th class="t_left">패스워드 변경 주기</th>
								<td>
									<p class="mg_b5"><input type="text" class="text_input short t_center" id="pw_cycle" name="pw_cycle" onkeyup="onlyNumBetweenFillter(this,${fn:length(login_pw_cycle_max)},${login_pw_cycle_min},${login_pw_cycle_max})" value="${cPolLoginMgtForm.pw_cycle }" /><label for="pw_cpxy_3">일</label></p>
								</td>
							</tr>
							<tr>
								<th class="t_left">로그인 실패 횟수</th>
								<td>
									<input type="radio" id="fail_cnt_1" name="fail_cnt" value="5" ${cPolLoginMgtForm.fail_cnt == "5" ? ' checked' : ''} /><label for="fail_cnt_1" class="mg_r30">5회</label>
									<input type="radio" id="fail_cnt_2" name="fail_cnt" value="7" ${cPolLoginMgtForm.fail_cnt == "7" ? ' checked' : ''} /><label for="fail_cnt_2" class="mg_r30">7회</label>
									<input type="radio" id="fail_cnt_3" name="fail_cnt" value="10" ${cPolLoginMgtForm.fail_cnt == "10" ? ' checked' : ''} /><label for="fail_cnt_3">10회</label>
								</td>
							</tr>
							<c:set var="hidden_class" value="" />
							<c:if test="${cPolLoginMgtForm.login_seq != 'L00002'}">
								<c:set var="hidden_class" value="none" />
							</c:if>
							<tr class="${hidden_class }">
								<th class="t_left">실패시 대기시간 (관리자용)</th>
								<td>
									<input type="radio" id="fail_delay_1" name="fail_delay" value="5" ${cPolLoginMgtForm.fail_delay == "5" ? ' checked' : ''} /><label for="fail_delay_1" class="mg_r30">5분</label>
									<input type="radio" id="fail_delay-2" name="fail_delay" value="10" ${cPolLoginMgtForm.fail_delay == "10" ? ' checked' : ''} /><label for="fail_delay_2" class="mg_r30">10분</label>
									<input type="radio" id="fail_delay_3" name="fail_delay" value="15" ${cPolLoginMgtForm.fail_delay == "15" ? ' checked' : ''} /><label for="fail_delay_3">15분</label>
								</td>
							</tr>
							<tr class="none">
								<th class="t_left">초기 패스워드</th>
								<td>
									<%-- <input type="text" id="f_pw" name="f_pw" class="text_input mid t_center" value="${cPolLoginMgtForm.f_pw}"/> --%>
									<input type="text" id="f_pw" name="f_pw" class="text_input mid t_center" value="!"/>
								</td>
							</tr>
							<c:if test="${cPolLoginMgtForm.login_seq eq 'L00002'}">
							<tr class="none">
								<th class="t_left">관리자 접속IP</th>
								<td>
									<input type="text" class="text_input long" id="admin_allow_ip" name="admin_allow_ip" onkeyup="onlySizeFillter(this,63)" placeholder="xxx.xxx.xxx.xxx(','로 구분)" value="${cPolLoginMgtForm.admin_allow_ip }"/>
									<p class="helpBox mg_t20" id="pwd_explanation">관리자 접속IP는 ','로 구분 하여 4개 까지 가능</p>
								</td>
							</tr>
							<tr class="none">
								<th class="t_left">관리자 정책 유무</th>
								<td>
									<input type="radio" id="is_adminY" name="is_admin" value="Y" <c:if test="${cPolLoginMgtForm.is_admin eq 'Y'}">checked="checked"</c:if> /> Y&nbsp;&nbsp;&nbsp;
									<input type="radio" id="is_adminN" name="is_admin" value="N" <c:if test="${cPolLoginMgtForm.is_admin eq 'N'}">checked="checked"</c:if> /> N
								</td>
							</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				<div class="t_center mg_t30 mg_b30">
				<c:if test="${auth_cd == 1}">
					<button class="btn_common theme" onclick="initialize()">초기화</button>
					<button class="btn_common theme" onclick="save()">저장</button>
				</c:if>
					<button class="btn_common theme" onclick="cancel()">취소</button>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>