<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />
<c:set var="in_title_str" value="${customfunc:codeDes('NP_CD', 'I')} -> ${customfunc:codeDes('NP_CD', 'O')}" />
<c:set var="out_title_str" value="${customfunc:codeDes('NP_CD', 'O')} -> ${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="rcv_keep_term_str" 		value="받은자료 목록 보존기간(사용자)" />
<c:set var="snd_keep_term_str" 		value="보낸자료 목록 보존기간(사용자)" />
<c:set var="list_keep_term_str" 	value="자료전송이력 보존기간(관리자)" />
<c:set var="login_list_keep_term" 	value="로그인이력 보존기간(관리자)" />
<c:set var="admin_audit_list_keep_term" 	value="관리자변경이력 보존기간(관리자)" />
<c:set var="org_save_yn_str" 		value="원본파일 저장여부" />
<c:set var="org_save_term_str" 		value="원본파일 저장기간" />
<c:set var="download_limit_str" 	value="파일 다운로드 횟수 제한" />

<c:set var="f_pol_file_rcv_keep_term_min" value="${customfunc:miniMaxInteger('f_pol_file_rcv_keep_term_min')}" />
<c:set var="f_pol_file_rcv_keep_term_max" value="${customfunc:miniMaxInteger('f_pol_file_rcv_keep_term_max')}" />
<c:set var="f_pol_file_snd_keep_term_min" value="${customfunc:miniMaxInteger('f_pol_file_snd_keep_term_min')}" />
<c:set var="f_pol_file_snd_keep_term_max" value="${customfunc:miniMaxInteger('f_pol_file_snd_keep_term_max')}" />
<c:set var="f_pol_file_list_keep_term_min" value="${customfunc:miniMaxInteger('f_pol_file_list_keep_term_min')}" />
<c:set var="f_pol_file_list_keep_term_max" value="${customfunc:miniMaxInteger('f_pol_file_list_keep_term_max')}" />
<c:set var="f_pol_file_login_list_keep_term_min" value="${customfunc:miniMaxInteger('f_pol_file_login_list_keep_term_min')}" />
<c:set var="f_pol_file_login_list_keep_term_max" value="${customfunc:miniMaxInteger('f_pol_file_login_list_keep_term_max')}" />
<c:set var="f_pol_file_admin_audit_list_keep_term_min" value="${customfunc:miniMaxInteger('f_pol_file_admin_audit_list_keep_term_min')}" />
<c:set var="f_pol_file_admin_audit_list_keep_term_max" value="${customfunc:miniMaxInteger('f_pol_file_admin_audit_list_keep_term_max')}" />
<c:set var="f_pol_file_org_save_term_min" value="${customfunc:miniMaxInteger('f_pol_file_org_save_term_min')}" />
<c:set var="f_pol_file_org_save_term_max" value="${customfunc:miniMaxInteger('f_pol_file_org_save_term_max')}" />
<c:set var="f_pol_file_download_cnt_min" value="1" />
<c:set var="f_pol_file_download_cnt_max" value="99" />
<script type="text/javascript">
var f_pol_file_rcv_keep_term_min = "${f_pol_file_rcv_keep_term_min}";
var f_pol_file_rcv_keep_term_max = "${f_pol_file_rcv_keep_term_max}";
var f_pol_file_snd_keep_term_min = "${f_pol_file_snd_keep_term_min}";
var f_pol_file_snd_keep_term_max = "${f_pol_file_snd_keep_term_max}";
var f_pol_file_list_keep_term_min = "${f_pol_file_list_keep_term_min}";
var f_pol_file_list_keep_term_max = "${f_pol_file_list_keep_term_max}";
var f_pol_file_login_list_keep_term_min = "${f_pol_file_login_list_keep_term_min}";
var f_pol_file_login_list_keep_term_max = "${f_pol_file_login_list_keep_term_max}";
var f_pol_file_admin_audit_list_keep_term_min = "${f_pol_file_admin_audit_list_keep_term_min}";
var f_pol_file_admin_audit_list_keep_term_max = "${f_pol_file_admin_audit_list_keep_term_max}";
var f_pol_file_org_save_term_min = "${f_pol_file_org_save_term_min}";
var f_pol_file_org_save_term_max = "${f_pol_file_org_save_term_max}";
var f_pol_file_download_cnt_min = "${f_pol_file_download_cnt_min}";
var f_pol_file_download_cnt_max = "${f_pol_file_download_cnt_max}";

$(document).ready(function() {
	<c:if test="${auth_cd != 1}">
	allInputDisable();
	</c:if>
	var netArray = ["In", "Out"];

	for (var i = 0; i < netArray.length; i++) {
		checkFocusMessage($("#rcv_keep_term_"+ netArray[i]),f_pol_file_rcv_keep_term_min +" ~ "+ f_pol_file_rcv_keep_term_max +"일 최대 "+ f_pol_file_rcv_keep_term_max.length +"자리까지 입력이 가능합니다.");
		checkFocusMessage($("#snd_keep_term_"+ netArray[i]),f_pol_file_snd_keep_term_min +" ~ "+ f_pol_file_snd_keep_term_max +"일 최대 "+ f_pol_file_snd_keep_term_max.length +"자리까지 입력이 가능합니다.");
		checkFocusMessage($("#list_keep_term_"+ netArray[i]),f_pol_file_list_keep_term_min +" ~ "+ f_pol_file_list_keep_term_max +"일 최대 "+ f_pol_file_list_keep_term_max.length +"자리까지 입력이 가능합니다.");
		checkFocusMessage($("#login_list_keep_term_In"),f_pol_file_login_list_keep_term_min +" ~ "+ f_pol_file_login_list_keep_term_max +"일 최대 "+ f_pol_file_login_list_keep_term_max.length +"자리까지 입력이 가능합니다.");
		checkFocusMessage($("#admin_audit_list_keep_term_In"),f_pol_file_admin_audit_list_keep_term_min +" ~ "+ f_pol_file_admin_audit_list_keep_term_max +"일 최대 "+ f_pol_file_admin_audit_list_keep_term_max.length +"자리까지 입력이 가능합니다.");
		checkFocusMessage($("#org_save_term_"+ netArray[i]),f_pol_file_org_save_term_min +" ~ "+ f_pol_file_org_save_term_max +"일 최대 "+ f_pol_file_org_save_term_max.length +"자리까지 입력이 가능합니다.");
		checkFocusMessage($("#download_max_cnt_"+netArray[i]),f_pol_file_download_cnt_min +" ~ "+ f_pol_file_download_cnt_max +"회 입력이 가능합니다."); 
	}
		checkFocusMessage($("#pol_nm2"), "1 ~ 50자리까지 입력이 가능합니다.");
		checkFocusMessage($("#note2"), "1 ~ 100자리까지 입력이 가능합니다.");
});

//정책 추가
function save() {
	if (validCheckPolicyFileInfo()) {
		return false; 
	}
	titleFilter('pol_nm2', 'note2');

	$("#exts_seq_In").val($("#loadExtsPolicy_In").val()).attr("selected", "selected");
	$("#exts_seq_Out").val($("#loadExtsPolicy_Out").val()).attr("selected", "selected");

	var requestURL = "<c:url value="/policy/filePreservationPolicy/updatefPreservationPolicyInfo.lin" />";
	var successURL = "<c:url value="/policy/filePreservationPolicy/fPreservationPolicyMgt.lin" />";

	$(":button").attr("disabled", true);
	resultCheckFunc($("#lform_In"), requestURL, function(response) {
		var code = response['code'];
		$("#pol_seq").val($("#pol_seq2").val());
		$("#pol_nm").val($("#pol_nm2").val());
		$("#note").val($("#note2").val());
		if (code == '200') {
			var requestURL = "<c:url value="/policy/filePreservationPolicy/insertFPreservationPolicyMgt.lin" />";
			resultCheckFunc($("#lform_Out"), requestURL, function(response) {
			$(":button").attr("disabled", false);
				var code = response['code'];
				var message = response['message'];

				if (code == '200') {
					alert('정책이 저장되었습니다.');
					$(location).attr("href", successURL);
				} else if (code == '500'){
					alert(message);
				} else {
					alert('정책 설정 중 에러가 발생 되었습니다.');
				}
			});
		} else {
			$(":button").attr("disabled", false);
			alert('정책 설정 중 에러가 발생 되었습니다.');
		}
	});
}

function cancel() {
	location.href = "<c:url value="/policy/filePreservationPolicy/fPreservationPolicyMgt.lin" />";
}

function validCheckPolicyFileInfo(){
	var netArray = ["In", "Out"];

	if (empty($("#pol_nm2").val())){
		alert("<spring:message code="vaild.message.model.global.pol_nm" />");
		return true;
	}

	for (var i = 0; i < netArray.length; i++) {
		var messageTitle = netArray[i] == "In" ? "${in_title_str}" : "${out_title_str}";

		if (!isValidSameRange($("#pol_nm2").val().length, 1, 50)) {
			alert("정책명은 1 ~ 50자리까지 입력이 가능합니다.");
			return true;
		} else if (!isValidSameRange($("#note2").val().length, 1, 100)) {
			alert("설명은 1 ~ 100자리까지 입력이 가능합니다.");
			return true;
		}
	
		var orgSaveTerm = $("#org_save_term_" + netArray[i]).val();
		var listKeepTerm = $("#list_keep_term_" + netArray[i]).val();
		var rcvKeepTerm = $("#rcv_keep_term_" + netArray[i]).val();
		var sndKeepTerm = $("#snd_keep_term_" + netArray[i]).val();
		
		if (Number(orgSaveTerm) > Number(listKeepTerm)) {
			alert("자료전송이력 보존기간(관리자)은 원본파일 저장기간 보다 커야 합니다.");
			return true;
		}else if (Number(rcvKeepTerm) > Number(orgSaveTerm) || Number(sndKeepTerm) > Number(orgSaveTerm)){
			alert("[" + messageTitle + "] <spring:message code="valid.message.model.FPolFileInfo.org_compare" />");
			return true;
		}else if (!isValidSameRange($("#list_keep_term_"+ netArray[i]).val(),f_pol_file_list_keep_term_min,f_pol_file_list_keep_term_max)) {
			alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.list_keep_term" />");
			return true;
		} else if (!isValidSameRange($("#snd_keep_term_"+ netArray[i]).val(),f_pol_file_snd_keep_term_min,f_pol_file_snd_keep_term_max)) {
			alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.snd_keep_term" />");
			return true;
		} else if (!isValidSameRange($("#org_save_term_"+ netArray[i]).val(),f_pol_file_org_save_term_min,f_pol_file_org_save_term_max)) {
			alert("[" + messageTitle + " <spring:message code="vaild.message.model.FPolFileInfo.org_save_term" />");
			return true;
		} else if (!isValidSameRange($("#login_list_keep_term_In").val(),f_pol_file_login_list_keep_term_min,f_pol_file_login_list_keep_term_max)) {
			alert("[" + messageTitle + " <spring:message code="vaild.message.model.FPolFileInfo.login_list_keep_term" />");
			return true;
		} else if (!isValidSameRange($("#admin_audit_list_keep_term_In").val(),f_pol_file_admin_audit_list_keep_term_min,f_pol_file_admin_audit_list_keep_term_max)) {
			alert("[" + messageTitle + " <spring:message code="vaild.message.model.FPolFileInfo.admin_audit_list_keep_term" />");
			return true;
		}
	}
	return false;
}
</script>
</head>
<body>
<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">자료보존정책 관리</h2>
				<p class="breadCrumbs">정책관리 > 자료보존정책 관리</p>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>자료 보존 정책</h3>
			<div class="conBox">
				<div class="topCon">
				<table summary="파일전송정책 추가" style="table-layout : fixed" >
					<caption>정책, 정책명, 설명, 선택확장자</caption>
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
								<td class=""><input type="text" class="text_input" id="pol_seq2" name="pol_seq2" value="${pol_seq}" readonly="readonly" /></td>
								<th class="t_center">정책명</th>
								<td class=""><input type="text" class="text_input" id="pol_nm2" name="pol_nm2" onkeyup="onlySizeFillter(this,50)"  value="${fPreservationPolMgtForm.pol_nm}" /></td>
								<th class="t_center">설명</th>
								<td class=""><input type="text" class="text_input"id="note2" name="note2" onkeyup="onlySizeFillter(this,100)" value="${fPreservationPolMgtForm.note}"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="tableArea">
				<form name="lform_In" id="lform_In" method="post" action="" onSubmit="return false;">
					<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf}" />
					<input type="hidden" id="exts_seq_In" name="exts_seq" value="">
					<input type="hidden" id="org_save_yn" name="org_save_yn" value="Y">
				<div class="left_tableBox">
					<div class="table_area_style02">
						<div class="table_area_topCon title">${in_title_str}</div>
						<table summary="파일전송정책" style="table-layout: fixed">
							<caption></caption>
							<colgroup>
								<col style="width: 45%;" />
								<col style="width: 55%;" />
							</colgroup>
							<tbody>
								<tr>
									<th title="${rcv_keep_term_str}">${rcv_keep_term_str}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="rcv_keep_term_In" name="rcv_keep_term" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_rcv_keep_term_max)},${f_pol_file_rcv_keep_term_min},${f_pol_file_rcv_keep_term_max})" value="${innerfPolFilePreservationInfo.rcv_keep_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr>
									<th title="${snd_keep_term_str}">${snd_keep_term_str}</th>
									<td class="t_center">
									<input type="text" class="text_input mid" id="snd_keep_term_In" name="snd_keep_term" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_snd_keep_term_max)},${f_pol_file_snd_keep_term_min},${f_pol_file_snd_keep_term_max})" value="${innerfPolFilePreservationInfo.snd_keep_term}" size="10" maxlength="4" /> 일
								</tr>
								<tr>
									<th title="${list_keep_term_str}">${list_keep_term_str}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="list_keep_term_In" name="list_keep_term" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_list_keep_term_max)},${f_pol_file_list_keep_term_min},${f_pol_file_list_keep_term_max})" value="${innerfPolFilePreservationInfo.list_keep_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr>
									<th title="${login_list_keep_term}">${login_list_keep_term}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="login_list_keep_term_In" name="login_list_keep_term" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_list_keep_term_max)},${f_pol_file_list_keep_term_min},${f_pol_file_list_keep_term_max})" value="${innerfPolFilePreservationInfo.login_list_keep_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr>
									<th title="${admin_audit_list_keep_term}">${admin_audit_list_keep_term}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="admin_audit_list_keep_term_In" name="admin_audit_list_keep_term" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_list_keep_term_max)},${f_pol_file_list_keep_term_min},${f_pol_file_list_keep_term_max})" value="${innerfPolFilePreservationInfo.admin_audit_list_keep_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr class="none">
									<th title="${org_save_yn_str}">${org_save_yn_str}</th>
									<td class="t_center">
										<input type="radio" id="org_save_yn_In_Y" name="org_save_yn" value="Y" ${innerfPolFilePreservationInfo.org_save_yn == "Y" ? ' checked' : ''} disabled="disabled"/>
										<label for="org_save_yn_In_Y" class="mg_r15">저장</label>
										<input type="radio" id="org_save_yn_In_N" name="org_save_yn" value="N" ${innerfPolFilePreservationInfo.org_save_yn == "N" ? ' checked' : ''} disabled="disabled"/>
										<label for="org_save_yn_In_N">저장 안함</label>
									</td>
								</tr>
								<tr>
									<th title="${org_save_term_str}">${org_save_term_str}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="org_save_term_In" name="org_save_term" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_org_save_term_max)},${f_pol_file_org_save_term_min},${f_pol_file_org_save_term_max})" value="${innerfPolFilePreservationInfo.org_save_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr>
									<th title="">${download_limit_str}</th>
									<td class="t_center">
										<input type="radio" name="download_limit_yn" id="download_limit_N_In" value="N" ${innerfPolFilePreservationInfo.download_max_cnt eq null ? 'checked' : ''}><label for="download_limit_N_In">제한 없음</label>
										<input type="radio" name="download_limit_yn" id="download_limit_Y_In" value="Y" ${innerfPolFilePreservationInfo.download_max_cnt ne null ? 'checked' : ''}>
										<label for="download_limit_Y_In">
											<input type="text" class="text_input mid" name="download_max_cnt" id="download_max_cnt_In" value="${innerfPolFilePreservationInfo.download_max_cnt}" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_download_cnt_max)},${f_pol_file_download_cnt_min},${f_pol_file_download_cnt_max})" value="${innerfPolFilePreservationInfo.download_max_cnt}" maxlength="2" /> 회 다운로드
										</label>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				</form>
				<form name="lform_Out" id="lform_Out" method="post" action="" onSubmit="return false;">
				<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
				<input type="hidden" id="pol_seq" name="pol_seq" value="">
				<input type="hidden" id="pol_nm" name="pol_nm" value="">
				<input type="hidden" id="note" name="note" value="">
				<input type="hidden" id="cud_cd" name="cud_cd" value="${fPreservationPolMgtForm.cud_cd}">
				<input type="hidden" id="isdel_yn" name="isdel_yn" value="${fPreservationPolMgtForm.isdel_yn}">
				<input type="hidden" id="exts_seq_Out" name="exts_seq" value="">
				<input type="hidden" id="org_save_yn" name="org_save_yn" value="Y">
				<div class="right_tableBox">
					<div class="table_area_style02">
						<div class="table_area_topCon title">${out_title_str}</div>
						<table summary="파일전송 정책" style="table-layout: fixed">
							<caption></caption>
							<colgroup>
								<col style="width: 45%;" />
								<col style="width: 55%;" />
							</colgroup>
							<tbody>
								<tr>
									<th title="${rcv_keep_term_str}">${rcv_keep_term_str}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="rcv_keep_term_Out" name="rcv_keep_term" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_rcv_keep_term_max)},${f_pol_file_rcv_keep_term_min},${f_pol_file_rcv_keep_term_max})" value="${outerfPolFilePreservationInfo.rcv_keep_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr>
									<th title="${snd_keep_term_str}">${snd_keep_term_str}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="snd_keep_term_Out" name="snd_keep_term" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_snd_keep_term_max)},${f_pol_file_snd_keep_term_min},${f_pol_file_snd_keep_term_max})" value="${outerfPolFilePreservationInfo.snd_keep_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr>
									<th title="${list_keep_term_str}">${list_keep_term_str}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="list_keep_term_Out" name="list_keep_term" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_list_keep_term_max)},${f_pol_file_list_keep_term_min},${f_pol_file_list_keep_term_max})" value="${outerfPolFilePreservationInfo.list_keep_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr>
									<th title="${login_list_keep_term}">${login_list_keep_term}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="login_list_keep_term_Out" name="login_list_keep_term" disabled="disabled" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_list_keep_term_max)},${f_pol_file_list_keep_term_min},${f_pol_file_list_keep_term_max})" value="${outerfPolFilePreservationInfo.login_list_keep_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr>
									<th title="${admin_audit_list_keep_term}">${admin_audit_list_keep_term}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="admin_audit_list_keep_term_Out" name="admin_audit_list_keep_term" disabled="disabled" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_list_keep_term_max)},${f_pol_file_list_keep_term_min},${f_pol_file_list_keep_term_max})" value="${outerfPolFilePreservationInfo.admin_audit_list_keep_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr class="none">
									<th title="${org_save_yn_str}">${org_save_yn_str}</th>
									<td class="t_center">
										<input type="radio" id="org_save_yn_Out_Y" name="org_save_yn" value="Y" ${outerfPolFilePreservationInfo.org_save_yn == "Y" ? ' checked' : ''} disabled="disabled"/>
										<label for="org_save_yn_Out_Y" class="mg_r15">저장</label>
										<input type="radio" id="org_save_yn_Out_N" name="org_save_yn" value="N" ${outerfPolFilePreservationInfo.org_save_yn == "N" ? ' checked' : ''} disabled="disabled"/>
										<label for="org_save_yn_Out_N">저장 안함</label>
									</td>
								</tr>
								<tr>
									<th title="${org_save_term_str}">${org_save_term_str}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="org_save_term_Out" name="org_save_term" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_org_save_term_max)},${f_pol_file_org_save_term_min},${f_pol_file_org_save_term_max})" value="${outerfPolFilePreservationInfo.org_save_term}" size="10" maxlength="4" /> 일
									</td>
								</tr>
								<tr>
									<th title="">${download_limit_str}</th>
									<td class="t_center">
										<input type="radio" name="download_limit_yn" id="download_limit_N_Out" value="N"  ${outerfPolFilePreservationInfo.download_max_cnt eq null ? 'checked' : ''}><label for="download_limit_N_Out">제한 없음</label>
										<input type="radio" name="download_limit_yn" id="download_limit_Y_Out" value="Y" ${outerfPolFilePreservationInfo.download_max_cnt ne null ? 'checked' : ''}>
										<label for="download_limit_Y_Out">
											<input type="text" class="text_input mid" name="download_max_cnt" id="download_max_cnt_Out" value="${outerfPolFilePreservationInfo.download_max_cnt}" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_download_cnt_max)},${f_pol_file_download_cnt_min},${f_pol_file_download_cnt_max})" value="${innerfPolFilePreservationInfo.download_max_cnt}" maxlength="2" /> 회 다운로드
										</label>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				</form>
			</div>
			<div class="t_center mg_t30 mg_b30">
			<c:if test="${auth_cd == 1}">
				<button class="btn_common theme" onClick="save()">저장</button>
			</c:if>
				<button class="btn_common theme" onClick="cancel()">취소</button>
			</div>
		</div>
	</div>
</div>
</body>
</html>
