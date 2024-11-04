<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<c:set var="getSiteCode" value="${customfunc:getSiteCode()}" />
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />
<c:set var="in_title_str" value="${customfunc:codeDes('NP_CD', 'I')} -> ${customfunc:codeDes('NP_CD', 'O')}" />
<c:set var="out_title_str" value="${customfunc:codeDes('NP_CD', 'O')} -> ${customfunc:codeDes('NP_CD', 'I')}" />

<c:set var="m_size_str" 			value="개별 파일 용량" />
<c:set var="m_size_str2" 			value="(첨부파일 한개당 최대용량)" />
<c:set var="one_m_size_str" 		value="합계 파일 용량" />
<c:set var="one_m_size_str2" 		value="(첨부파일들의 용량의 합)" />
<c:set var="up_m_size_str" 			value="개인별 자료함 용량" />
<c:set var="up_m_size_str2" 		value="(업로드된 파일들 용량의합)" />
<c:set var="clipboard_size_str" 	value="클립보드 파일 용량" />
<c:set var="bw_cd_str"				value="확장자 필터링 설정" />
<c:set var="load_exts_policy_str" 	value="확장자 목록" />
<c:set var="load_exts_approval_policy_str" 	value="확장자 결재 필터링 설정" />
<c:set var="vc_yn_str"				value="백신검사" />
<c:set var="up_f_cnt" 				value="1회당 최대 파일전송개수" />
<c:set var="title_size" 			value="제목 설정" />
<c:set var="tx_download"			value="보낸자료함 다운로드" />
<c:set var="f_pol_file_m_size_min" value="${customfunc:miniMaxInteger('f_pol_file_m_size_min')}" />
<c:set var="f_pol_file_m_size_max" value="${customfunc:miniMaxInteger('f_pol_file_m_size_max')}" />
<c:set var="f_pol_file_m_size_cs_min" value="${customfunc:miniMaxInteger('f_pol_file_m_size_cs_min')}" />
<c:set var="f_pol_file_m_size_cs_max" value="${customfunc:miniMaxInteger('f_pol_file_m_size_cs_max')}" />
<c:set var="f_pol_file_one_m_size_min" value="${customfunc:miniMaxInteger('f_pol_file_one_m_size_min')}" />
<c:set var="f_pol_file_one_m_size_max" value="${customfunc:miniMaxInteger('f_pol_file_one_m_size_max')}" />
<c:set var="f_pol_file_one_m_size_cs_min" value="${customfunc:miniMaxInteger('f_pol_file_one_m_size_cs_min')}" />
<c:set var="f_pol_file_one_m_size_cs_max" value="${customfunc:miniMaxInteger('f_pol_file_one_m_size_cs_max')}" />
<c:set var="f_pol_file_up_m_size_min" value="${customfunc:miniMaxInteger('f_pol_file_up_m_size_min')}" />
<c:set var="f_pol_file_up_m_size_max" value="${customfunc:miniMaxInteger('f_pol_file_up_m_size_max')}" />
<c:set var="f_pol_file_max_cnt_min" value="${customfunc:miniMaxInteger('f_pol_file_max_cnt_min')}" />
<c:set var="f_pol_file_max_cnt_max" value="${customfunc:miniMaxInteger('f_pol_file_max_cnt_max')}" />
<c:set var="f_pol_file_max_cnt_cs_min" value="${customfunc:miniMaxInteger('f_pol_file_max_cnt_cs_min')}" />
<c:set var="f_pol_file_max_cnt_cs_max" value="${customfunc:miniMaxInteger('f_pol_file_max_cnt_cs_max')}" />
<c:set var="f_pol_title_size_min" value="${customfunc:miniMaxInteger('f_pol_title_size_min')}" />
<c:set var="f_pol_title_size_max" value="${customfunc:miniMaxInteger('f_pol_title_size_max')}" /> 
<c:set var="f_pol_mail_file_size_max" value="${customfunc:miniMaxInteger('f_pol_mail_file_size_max')}" /> 
<c:set var="f_pol_mail_file_size_min" value="${customfunc:miniMaxInteger('f_pol_mail_file_size_min')}" /> 
<c:set var="f_pol_dlp_timeout_min" value="${customfunc:miniMaxInteger('f_pol_dlp_timeout_min')}" /> 
<c:set var="f_pol_dlp_timeout_max" value="${customfunc:miniMaxInteger('f_pol_dlp_timeout_max')}" />
<c:set var="f_pol_depth_size_min" value="${customfunc:miniMaxInteger('f_pol_file_compress_depth_size_min')}" /> 
<c:set var="f_pol_depth_size_max" value="${customfunc:miniMaxInteger('f_pol_file_compress_depth_size_max')}" />
<c:set var="f_pol_file_apt_scan_max_file_size_min" value="${customfunc:miniMaxInteger('f_pol_file_apt_scan_max_file_size_min')}" />
<c:set var="f_pol_file_apt_scan_max_file_size_max" value="${customfunc:miniMaxInteger('f_pol_file_apt_scan_max_file_size_max')}" />
<c:set var="f_pol_file_clipboard_size_min" value="${customfunc:miniMaxInteger('f_pol_file_clipboard_size_min')}" />
<c:set var="f_pol_file_clipboard_size_max" value="${customfunc:miniMaxInteger('f_pol_file_clipboard_size_max')}" />
<c:set var="isUseApprovalExtension" value="${IS_EXT_APP_POLICY_UI_USE}" /> 
<%-- <link href="<c:url value="/css/ui.tooltip.css?ver=01804100011" />" rel="stylesheet" type="text/css"/> --%>
<style type="text/css">
/* Tooltip container */
.tooltip {
    position: relative;
    display: inline-block;
    /* font-size: 10px; */
}

/* Tooltip text */
.tooltip .tooltiptext {
    visibility: hidden;
    position: absolute;
    width: 280px;
    background-color: #555;
    color: #fff;
    text-align: left; 
    font-size: 11px; 
    padding: 5px 0;
    border-radius: 6px;
    z-index: 999;
    opacity: 0;
    transition: opacity 0.3s;
}

/* Show the tooltip text when you mouse over the tooltip container */
.tooltip:hover .tooltiptext {
    visibility: visible;
    opacity: 1;
}

.tooltip-bottom {
  top: 135%;
  left: 50%;  
  margin-left: -60px;
}

.tooltip-bottom-left {
  top: 126%;
  left: 50%;  
  margin-left: -60px;
}

.tooltip-bottom::after {
    content: "";
    position: absolute;
    bottom: 100%;
    left: 30%;
    margin-left: -5px;
    border-width: 5px;
    border-style: solid;
    border-color: transparent transparent #555 transparent;
}
input[name='bw_cd'], input[name='encrypt_filter']{
	margin-left:5px;
}
input[type='radio'],label{
	cursor: pointer;
}
</style>
<script type="text/javascript">
var f_pol_file_m_size_min = "${f_pol_file_m_size_min}";
var f_pol_file_m_size_max = "${f_pol_file_m_size_max}";
var f_pol_file_m_size_cs_min = "${f_pol_file_m_size_cs_min}";
var f_pol_file_m_size_cs_max = "${f_pol_file_m_size_cs_max}";
var f_pol_file_one_m_size_min = "${f_pol_file_one_m_size_min}";
var f_pol_file_one_m_size_max = "${f_pol_file_one_m_size_max}";
var f_pol_file_one_m_size_cs_min = "${f_pol_file_one_m_size_cs_min}";
var f_pol_file_one_m_size_cs_max = "${f_pol_file_one_m_size_cs_max}";
var f_pol_file_up_m_size_min = "${f_pol_file_up_m_size_min}";
var f_pol_file_up_m_size_max = "${f_pol_file_up_m_size_max}";
var f_pol_file_max_cnt_min = "${f_pol_file_max_cnt_min}";
var f_pol_file_max_cnt_max = "${f_pol_file_max_cnt_max}";
var f_pol_file_max_cnt_cs_min = "${f_pol_file_max_cnt_cs_min}";
var f_pol_file_max_cnt_cs_max = "${f_pol_file_max_cnt_cs_max}";
var f_pol_title_size_min = "${f_pol_title_size_min}";
var f_pol_title_size_max = "${f_pol_title_size_max}";
var f_pol_mail_file_size_max = "${f_pol_mail_file_size_max}";
var f_pol_mail_file_size_min = "${f_pol_mail_file_size_min}";
var f_pol_dlp_timeout_max = "${f_pol_dlp_timeout_max}";
var f_pol_dlp_timeout_min = "${f_pol_dlp_timeout_min}";
var f_pol_depth_size_min = "${f_pol_depth_size_min}";
var f_pol_depth_size_max = "${f_pol_depth_size_max}";
var f_pol_file_apt_scan_max_file_size_min = "${f_pol_file_apt_scan_max_file_size_min}";
var f_pol_file_apt_scan_max_file_size_max = "${f_pol_file_apt_scan_max_file_size_max}";
var f_pol_file_clipboard_size_min = "${f_pol_file_clipboard_size_min}";
var f_pol_file_clipboard_size_max = "${f_pol_file_clipboard_size_max}";

	$(document).ready(function() {
		<c:if test="${getSiteCode ne 'hrd'}">
			$(".mail_layout").css("display","none");
		</c:if>
		
		<c:if test="${customfunc:cacheString('clipboardUseYN') eq 'N'}">
			$(".clipboard_layout").css("display","none");
		</c:if>
		
		selectBoxControl();
		compressHelpTooltip();
		encryptBtnAble();
		<c:if test="${customfunc:cacheString('csAgentUseYN') eq 'N'}">
			$(".cs_layout").css("display","none");
		</c:if>
		
		<c:if test="${customfunc:cacheString('clipboardUseYN') eq 'N'}">
			$(".clipboard_layout").css("display","none");
		</c:if>
		
		<c:if test="${innerVCUseYN eq 'N'}">
			innerVaccineRemove();
		</c:if>
		
		<c:choose>
			<c:when test="${customfunc:cacheString('multiVCUseYN') eq 'Y'}">
				multiVaccineSetting();
			</c:when>
			<c:otherwise>
				multiVaccineRemove();
			</c:otherwise>
		</c:choose>
		
		<c:choose>
			<c:when test="${customfunc:cacheString('dlpUseYN') eq 'Y'}">
				dlpSetting();
				dlpTimeoutTooltip();
			</c:when>
			<c:otherwise>
				dlpRemove();
			</c:otherwise>
		</c:choose>
		
		<c:choose>
			<c:when test="${customfunc:cacheString('aptUseYN') eq 'Y'}">
				<c:if test="${customfunc:getSync('APT_COMPANY') eq 'after_detect'}">
					$(".apt_send_layout").css("display", "none");
				</c:if>
				aptSetting();				
			</c:when>
			<c:otherwise>
				aptRemove();
			</c:otherwise>
		</c:choose>

		<c:choose>
			<c:when test="${customfunc:cacheString('oleUseYN') eq 'Y'}">
				oleSetting();
			</c:when>
			<c:otherwise>
				oleRemove();
			</c:otherwise>
		</c:choose>
		
		
		<c:if test="${customfunc:cacheString('txDownloadUseYN') eq 'N'}">
			$(".tx_download_layout").css("display","none");
		</c:if>

		<c:if test="${auth_cd != 1}">
		allInputDisable();
		</c:if>
		
		selectedExts();
		
	});
	
	function innerVaccineRemove(){
		$(".vc_yn_In_layout").children().attr("disabled",true).css("cursor","no-drop");
		$("#lform_In").append('<input type="hidden" name="vc_yn" value="N">');
	}
	
	function multiVaccineRemove(){
		$("#vc_In_box").remove();
		$("#vc_Out_box").remove();
	}
	
	function dlpRemove(){
		$(".dlp_layout").css("display","none");
		$("#dlp_yn_In_N").attr("checked",true);
		$("#dlp_yn_Out_N").attr("checked",true);
	}
	
	function aptRemove() {
		$(".apt_layout").css("display","none");
		$("#apt_yn_In_N").attr("checked",true);
		$("#apt_yn_Out_N").attr("checked",true);
	}

	function oleRemove(){
		$(".ole_layout").css("display","none");
		$("#ole_yn_In_N").attr("checked",true);
		$("#ole_yn_Out_N").attr("checked",true);
	}

	function selectedExts() {
		var innerExts_seq = '${innerfPolFileInfo.exts_seq}';
		var outerExts_seq = '${outerfPolFileInfo.exts_seq}';
		var innerEnc_Exts_seq = '${innerfPolFileInfo.enc_exts_seq}';
		var outerEnc_Exts_seq = '${outerfPolFileInfo.enc_exts_seq}';
		var innerExts_ap_seq = '${innerfPolFileInfo.exts_ap_seq}';
		var outerExts_ap_seq = '${outerfPolFileInfo.exts_ap_seq}';
		var innerExts_ap_yn = '${innerfPolFileInfo.exts_ap_yn}';
		var outerExts_ap_yn = '${outerfPolFileInfo.exts_ap_yn}';
		
		$("#loadExtsPolicy_In").val(innerExts_seq).attr("selected","selected");
		$("#loadExtsPolicy_Out").val(outerExts_seq).attr("selected","selected");
		$("#load_Enc_Exts_Policy_In").val(innerEnc_Exts_seq).attr("selected","selected");
		$("#load_Enc_Exts_Policy_Out").val(outerEnc_Exts_seq).attr("selected","selected");
		$("#loadExtsApprovalPolicy_In").val(innerExts_ap_seq).attr("selected","selected");
		$("#loadExtsApprovalPolicy_Out").val(outerExts_ap_seq).attr("selected","selected");

		if(innerExts_ap_yn == "Y"){
			$("#loadExtsApprovalPolicy_In").attr("disabled", false);
		}else{
			$("#loadExtsApprovalPolicy_In").attr("disabled", true);
		}
		if(outerExts_ap_yn == "Y"){
			$("#loadExtsApprovalPolicy_Out").attr("disabled", false);
		}else{
			$("#loadExtsApprovalPolicy_Out").attr("disabled", true);
		}
	}

	function load() {
		var loadPolicyValue = $("#loadFilePolicy option:selected").val();
		var requestURL = "<c:url value="/policy/filePolicy/loadFPolFileInfo.lin" />?loadPolicyValue="+loadPolicyValue;
		resultCheckFunc("", requestURL, function(response) {

			var innerfPolFileInfo = response['innerfPolFileInfo'];
			var outerfPolFileInfo = response['outerfPolFileInfo'];
			var netArray = ["In", "Out"];
			var policyArray = [innerfPolFileInfo, outerfPolFileInfo];

			for (var i = 0; i < netArray.length; i++) {
				$("#m_size_" + netArray[i]).val(policyArray[i].m_size);
				$("#one_m_size_" + netArray[i]).val(policyArray[i].one_m_size);
				$("#up_m_size_" + netArray[i]).val(policyArray[i].up_m_size);
				$("#loadExtsPolicy_" + netArray[i]).val(policyArray[i].exts_seq).attr("selected","selected"); 
				$("#load_Enc_Exts_" + netArray[i]).val(policyArray[i].exts_seq).attr("selected","selected"); 

				var frm = document.forms['lform_'+ netArray[i]];
				frm.org_save_yn.value = policyArray[i].org_save_yn;
				frm.vc_yn.value = policyArray[i].vc_yn;
				frm.cf_chk_yn.value = policyArray[i].cf_chk_yn;
				frm.bw_cd.value = policyArray[i].bw_cd;
			}
		});
	}

	function initialize() {
		window.location.reload();
	}

	//정책 추가
	function save() {
		if (validCheckPolicyFileInfo()) {
			return false; 
		}
		titleFilter('pol_nm2', 'note2');
		
		<c:if test="${customfunc:cacheString('multiVCUseYN') eq 'Y'}">
			vcInCategorySetting();
			vcOutCategorySetting();
		</c:if>
		$("#dlp_in_timeout").val($("#dlp_timeout_In").val());
		$("#dlp_out_timeout").val($("#dlp_timeout_Out").val());
		$("#dlp_in_send_yn").val($("input[name=dlp_send_yn_in]:checked").val());
		$("#dlp_out_send_yn").val($("input[name=dlp_send_yn_out]:checked").val());
		$("#apt_in_yn").val($("input[name=apt_yn_In]:checked").val());			
		$("#apt_in_send_yn").val($("input[name=apt_send_yn_in]:checked").val());
		$("#apt_out_send_yn").val($("input[name=apt_send_yn_out]:checked").val());
		$("#apt_in_scan_max_file_size").val($("#apt_scan_max_file_size_In").val());
		$("#apt_out_scan_max_file_size").val($("#apt_scan_max_file_size_Out").val());
		$("#ole_in_fail_send_yn").val($("input[name=ole_fail_send_yn_in]:checked").val());
		$("#ole_out_fail_send_yn").val($("input[name=ole_fail_send_yn_out]:checked").val());
		$("#tx_in_download_yn").val($("input[name=tx_download_yn_in]:checked").val());
		$("#tx_out_download_yn").val($("input[name=tx_download_yn_out]:checked").val());
		
		$("#apt_in_file_size_filter_use_yn").val($("input[name=apt_file_size_filter_use_yn_In]:checked").val());
		$("#apt_out_file_size_filter_use_yn").val($("input[name=apt_file_size_filter_use_yn_Out]:checked").val());
		$("#exts_seq_In").val($("#loadExtsPolicy_In").val()).attr("selected", "selected");
		$("#exts_seq_Out").val($("#loadExtsPolicy_Out").val()).attr("selected", "selected");
		$("#enc_exts_seq_In").val($("#load_Enc_Exts_Policy_In").val()).attr("selected", "selected");
		$("#enc_exts_seq_Out").val($("#load_Enc_Exts_Policy_Out").val()).attr("selected", "selected");
		$("#exts_ap_seq_In").val($("#loadExtsApprovalPolicy_In").val()).attr("selected", "selected");
		$("#exts_ap_seq_Out").val($("#loadExtsApprovalPolicy_Out").val()).attr("selected", "selected");
		$("#up_m_use_yn_In").val($("input[name='up_m_use_yn_In']:checked").val());
		$("#up_m_use_yn_Out").val($("input[name='up_m_use_yn_Out']:checked").val());
		$("#clipboard_yn_In").val($("input[name='clipboard_yn_In']:checked").val());
		$("#clipboard_yn_Out").val($("input[name='clipboard_yn_Out']:checked").val());
		$("#depth_in_size").val($("#depth_size_In").val()).attr("selected", "selected");
		$("#depth_out_size").val($("#depth_size_Out").val()).attr("selected", "selected");

		var requestURL = "<c:url value="/policy/filePolicy/updateFilePolicyInfo.lin" />";
		var successURL = "<c:url value="/policy/filePolicy/filePolicyMgt.lin" />";
		
		/* var lform_in_leng = document.lform_In.vc_yn.length;
		for (var i = 0; i < lform_in_leng; i++) {
			document.lform_In.vc_yn[i].disabled = false;
		} */
	

		$(":button").attr("disabled", true);
		resultCheckFunc($("#lform_In"), requestURL, function(response) {
			var code = response['code'];
			$("#pol_seq").val($("#pol_seq2").val());
			$("#pol_nm").val($("#pol_nm2").val());
			$("#note").val($("#note2").val());
			if (code == '200') {

				var requestURL = "<c:url value="/policy/filePolicy/insertFilePolicyMgt.lin" />";
				/* var lform_out_leng = document.lform_Out.vc_yn.length;
				for (var i = 0; i < lform_out_leng; i++) {
					document.lform_Out.vc_yn[i].disabled = false;
				} */
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
		location.href = "<c:url value="/policy/filePolicy/filePolicyMgt.lin" />";
	}

	function validCheckPolicyFileInfo() {
		var netArray = ["In", "Out"];

		if (empty($("#pol_nm2").val())){
			alert("<spring:message code="vaild.message.model.global.pol_nm" />");
			return true;
		}

		for (var i = 0; i < netArray.length; i++) {
			var messageTitle = netArray[i] == "In" ? "${in_title_str}" : "${out_title_str}";
			var isUseFileCnt =$("#lform_"+netArray[i]+" input[name='up_f_cnt_yn']:checked").val()=='Y';
			var isUseFileCntCs =$("#lform_"+netArray[i]+" input[name='up_f_cnt_cs_yn']:checked").val()=='Y';
			if (!isValidSameRange($("#m_size_"+ netArray[i]).val(),f_pol_file_m_size_min,f_pol_file_m_size_max)) {
				alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.m_size" />");
				return true;
			} else if (!isValidSameRange($("#m_size_cs_"+ netArray[i]).val(),f_pol_file_m_size_cs_min,f_pol_file_m_size_cs_max)) {
				alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.m_size_cs" />");
				return true;
			} else if (!isValidSameRange($("#one_m_size_"+ netArray[i]).val(),f_pol_file_one_m_size_min,f_pol_file_one_m_size_max)) {
				alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.one_m_size" />");
				return true;
			} else if (!isValidSameRange($("#one_m_size_cs_"+ netArray[i]).val(),f_pol_file_one_m_size_cs_min,f_pol_file_one_m_size_cs_max)) {
				alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.one_m_size_cs" />");
				return true;
			} else if (!isValidSameRange($("#up_m_size_"+ netArray[i]).val(),f_pol_file_up_m_size_min,f_pol_file_up_m_size_max)) {
				alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.up_m_size" />");
				return true;
			} else if (!isValidSameRange($("#dlp_timeout_"+ netArray[i]).val(),f_pol_dlp_timeout_min,f_pol_dlp_timeout_max)) {
				alert("[" + messageTitle + "] <spring:message code="valid.message.model.FPolFileInfo.dlp_timeout" />");
				return true;
			}else if ( isUseFileCnt && !isValidSameRange($("#up_f_cnt_"+ netArray[i]).val(),f_pol_file_max_cnt_min,f_pol_file_max_cnt_max)) {
				alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.up_f_cnt" />");
				return true;
			}else if ( isUseFileCntCs && !isValidSameRange($("#up_f_cnt_cs_"+ netArray[i]).val(),f_pol_file_max_cnt_cs_min,f_pol_file_max_cnt_cs_max)) {
				alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.up_f_cnt" />");
				return true;
			} else if (!isValidSameRange($("#title_size_min_"+ netArray[i]).val(),f_pol_title_size_min,f_pol_title_size_max)) {
				alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.title_size_min" />");
				return true;
			} else if (!isValidSameRange($("#title_size_max_"+ netArray[i]).val(),f_pol_title_size_min,f_pol_title_size_max)) {
				alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.title_size_min" />");
				return true;
			} else if (!isValidSameRange($("#apt_scan_max_file_size_"+ netArray[i]).val(),f_pol_file_apt_scan_max_file_size_min,f_pol_file_apt_scan_max_file_size_max)) {
				alert("[" + messageTitle + "] APT검사 파일 사이즈 값이 올바르지 않습니다.");
				return true;
			} else if (!isValidSameRange($("#clipboard_size_"+ netArray[i]).val(),f_pol_file_clipboard_size_min,f_pol_file_clipboard_size_max)) {
				alert("[" + messageTitle + "] 클립보드 파일 사이즈 값이 올바르지 않습니다.");
				return true;
			} else if (!isValidSameRange($("#pol_nm2").val().length, 1, 50)) {
				alert("정책명은 1 ~ 50자리까지 입력이 가능합니다.");
				return true;
			} else if (Number($("#title_size_min_"+ netArray[i]).val()) >= Number($("#title_size_max_"+ netArray[i]).val())){
				alert("[" + messageTitle + "] 제목길이의 앞자리 숫자를 "+$("#title_size_max_"+ netArray[i]).val()+"자보다 작게 입력하세요.");
				return true;
			} else if( ! checkOneMSizeBoundary() ) {
				return true;
			} else if ($("#bw_cd_" + netArray[i] + "_W").attr('checked') == 'checked' || $("#bw_cd_" + netArray[i] + "_B").attr('checked') == 'checked') {
				if (empty($("#loadExtsPolicy_"+ netArray[i] +" option:selected").val())) {
					alert("[" + messageTitle + "] <spring:message code="vaild.message.model.FPolFileInfo.exts_seq" />");
					return true;
				}
			}
		}
		return false;
		
		<%--개별 파일 용량, 합계 파일 용량 체크--%>
		function checkOneMSizeBoundary() {
			var mIn = $("#m_size_In").val();
			var mcIn = $("#m_size_cs_In").val();
			var omIn = $("#one_m_size_In").val();
			var omcIn = $("#one_m_size_cs_In").val();
			var mOut = $("#m_size_Out").val(); 
			var mcOut = $("#m_size_cs_Out").val(); 
			var omOut = $("#one_m_size_Out").val();
			var omcOut = $("#one_m_size_cs_Out").val();
			var inDepthSize = $("#depth_size_In").val();
			var outDepthSize = $("#depth_size_Out").val();
			var msg = "";

			if(mIn == '' || mIn == 'undefined' || mIn == null) mIn = 0;
			if(mcIn == '' || mcIn == 'undefined' || mcIn == null) mcIn = 0;
			if(omIn == '' || omIn == 'undefined' || omIn == null) omIn = 0;
			if(omcIn == '' || omcIn == 'undefined' || omcIn == null) omcIn = 0;
			if(mOut == '' || mOut == 'undefined' || mOut == null) mOut = 0;
			if(mcOut == '' || mcOut == 'undefined' || mcOut == null) mcOut = 0;
			if(omOut == '' || omOut == 'undefined' || omOut == null) omOut = 0;
			if(omcOut == '' || omcOut == 'undefined' || omcOut == null) omcOut = 0;
			if(inDepthSize == '' || inDepthSize == 'undefined' || inDepthSize == null) inDepthSize = 0; 
			if(outDepthSize == '' || outDepthSize == 'undefined' || outDepthSize == null) outDepthSize = 0;

			if( (parseInt(mIn) > parseInt(omIn)) && (parseInt(mOut) > parseInt(omOut)) && (parseInt(mcIn) > parseInt(omcIn)) && (parseInt(mcOut) > parseInt(omcOut)) ) {
				$("#m_size_In").val(omIn);
				$("#m_size_cs_In").val(omcIn);
				$("#m_size_Out").val(omOut);
				$("#m_size_cs_Out").val(omcOut);
				msg = "<spring:message code="vaild.message.model.FPolFileInfo.not.boundary.m_size_both" />"; <%--\'개별 파일 용량\'이 \'합계 파일 용량\'보다 클 수 없습니다.--%>
			} else if (parseInt(mIn) > parseInt(omIn)) {
				$("#m_size_In").val(omIn);
				msg = "(${in_title_str}) <spring:message code="vaild.message.model.FPolFileInfo.not.boundary.m_size_in" />"; <%--(업무망->인터넷망) \'개별 파일 용량\'이 \'합계 파일 용량\'보다 클 수 없습니다.--%>
			} else if (parseInt(mcIn) > parseInt(omcIn)) {
				$("#m_size_cs_In").val(omcIn);
				msg = "(${in_title_str}) <spring:message code="vaild.message.model.FPolFileInfo.not.boundary.m_size_cs_in" />"; <%--(업무망->인터넷망) \'개별 파일 용량\'이 \'합계 파일 용량\'보다 클 수 없습니다.--%>
			} else if(parseInt(mOut) > parseInt(omOut)) {
				$("#m_size_Out").val(omOut);
				msg = "(${out_title_str}) <spring:message code="vaild.message.model.FPolFileInfo.not.boundary.m_size_out" />"; <%--(인터넷망->업무망) \'개별 파일 용량\'이 \'합계 파일 용량\'보다 클 수 없습니다.--%>
			} else if(parseInt(mcOut) > parseInt(omcOut)) {
				$("#m_size_cs_Out").val(omcOut);
				msg = "(${out_title_str}) <spring:message code="vaild.message.model.FPolFileInfo.not.boundary.m_size_cs_out" />"; <%--(인터넷망->업무망) \'개별 파일 용량\'이 \'합계 파일 용량\'보다 클 수 없습니다.--%>
			} else if(inDepthSize == 0) {
				$("#depth_size_In").val(f_pol_depth_size_min);
				msg = "<spring:message code="vaild.message.model.FPolFileInfo.not.boundary.in_depth_size" />";
			} else if(outDepthSize == 0) {
				$("#depth_size_Out").val(f_pol_depth_size_min);
				msg = "<spring:message code="vaild.message.model.FPolFileInfo.not.boundary.out_depth_size" />";
			}

			if( msg != "" ) {
				alert(msg);
				return false;
			}

			return true;
		}
	}
	
	function chkValue(position){
		var chkVal = $('input:checkbox[id="title_use_yn_'+position+'"]').is(":checked");
		if(chkVal){
			$("#title_use_yn_"+position).val("Y");
		}else{
			$("#title_use_yn_"+position).val("N");
		}	
	}
	
	$(document).ready(function() {
		var netArray = ["In", "Out"];
	
		for (var i = 0; i < netArray.length; i++) {
			checkFocusMessage($("#m_size_"+ netArray[i]),f_pol_file_m_size_min +" ~ "+ f_pol_file_m_size_max +"Mbytes 최대 "+ f_pol_file_m_size_max.length +"자리까지 입력이 가능합니다.");
			checkFocusMessage($("#m_size_cs_"+ netArray[i]),f_pol_file_m_size_cs_min +" ~ "+ f_pol_file_m_size_cs_max +"Gbytes 최대 "+ f_pol_file_m_size_cs_max.length +"자리까지 입력이 가능합니다.");
			checkFocusMessage($("#one_m_size_"+ netArray[i]),f_pol_file_one_m_size_min +" ~ "+ f_pol_file_one_m_size_max +"Mbytes 최대 "+ f_pol_file_one_m_size_max.length +"자리까지 입력이 가능합니다.");
			checkFocusMessage($("#one_m_size_cs_"+ netArray[i]),f_pol_file_one_m_size_cs_min +" ~ "+ f_pol_file_one_m_size_cs_max +"Gbytes 최대 "+ f_pol_file_one_m_size_cs_max.length +"자리까지 입력이 가능합니다.");
			checkFocusMessage($("#up_m_size_"+ netArray[i]),f_pol_file_up_m_size_min +" ~ "+ f_pol_file_up_m_size_max +"Mbytes 최대 "+ f_pol_file_up_m_size_max.length +"자리까지 입력이 가능합니다.");
			checkFocusMessage($("#pol_nm2"), "1 ~ 50자리까지 입력이 가능합니다.");
			checkFocusMessage($("#note2"), "1 ~ 100자리까지 입력이 가능합니다.");
			checkFocusMessage($("#up_f_cnt_"+ netArray[i]),f_pol_file_max_cnt_min +" ~ "+f_pol_file_max_cnt_max +"개 최대 "+f_pol_file_max_cnt_max.length+"자리까지 입력이 가능합니다.");
			checkFocusMessage($("#up_f_cnt_cs_"+ netArray[i]),f_pol_file_max_cnt_cs_min +" ~ "+f_pol_file_max_cnt_cs_max +"개 최대 "+f_pol_file_max_cnt_cs_max.length+"자리까지 입력이 가능합니다.");
			checkFocusMessage($("#title_size_min_"+ netArray[i]),f_pol_title_size_min +" ~ "+f_pol_title_size_max+"자 최대 "+f_pol_title_size_max.length+"자리까지 입력이 가능합니다.");
			checkFocusMessage($("#title_size_max_"+ netArray[i]),f_pol_title_size_min +" ~ "+f_pol_title_size_max+"자 최대 "+f_pol_title_size_max.length+"자리까지 입력이 가능합니다.");
			checkFocusMessage($("#mail_file_size_"+ netArray[i]),f_pol_mail_file_size_min +" ~ "+ f_pol_mail_file_size_max +"Mbytes 최대  " + f_pol_mail_file_size_max.length + "자리까지 입력이 가능합니다.");
			checkFocusMessage($("#dlp_timeout_"+ netArray[i]),f_pol_dlp_timeout_min +" ~ "+ f_pol_dlp_timeout_max +"초 최대  " + f_pol_dlp_timeout_max.length + "자리까지 입력이 가능합니다.");
			checkFocusMessage($("#apt_scan_max_file_size_"+ netArray[i]),f_pol_file_apt_scan_max_file_size_min +" ~ "+ f_pol_file_apt_scan_max_file_size_max +"Mbytes 최대 "+ f_pol_file_apt_scan_max_file_size_max.length +"자리까지 입력이 가능합니다.");
			checkFocusMessage($("#clipboard_size_"+ netArray[i]),f_pol_file_clipboard_size_min +" ~ "+ f_pol_file_clipboard_size_max +"Mbytes 최대 "+ f_pol_file_clipboard_size_max.length +"자리까지 입력이 가능합니다.");
		}
	});
	// 백신 카테고리 사용/사용안함 disabled 처리 ,cursor 처리
	function multiVaccineSetting(){
		if($("#vc_yn_Out_N").is(":checked") == true){
			$("#vc_Out_box").children().attr("disabled",true);
			$("#vc_Out_box").children().css("cursor","no-drop");
		}
		if($("#vc_yn_In_N").is(":checked") == true){
			$("#vc_In_box").children().attr("disabled",true);
			$("#vc_In_box").children().css("cursor","no-drop");
		}
		
		$("#vc_yn_Out_Y").click(function(){
			$("#vc_Out_box").children().attr("disabled",false);
			$("#vc_Out_box").children().css("cursor","default");
			$("#vc_category_Out_sga_chk").attr("checked","checked");
			$("#vc_category_Out_clam_chk").attr("checked","checked");
		});
		$("#vc_yn_Out_N").click(function(){
			$("#vc_Out_box").children().attr("disabled",true);
			$("#vc_Out_box").children().css("cursor","no-drop");
		});
		$("#vc_yn_In_Y").click(function(){
			$("#vc_In_box").children().attr("disabled",false);
			$("#vc_In_box").children().css("cursor","default");
			$("#vc_category_In_sga_chk").attr("checked","checked");
			$("#vc_category_In_clam_chk").attr("checked","checked");
		});
		$("#vc_yn_In_N").click(function(){
			$("#vc_In_box").children().attr("disabled",true);
			$("#vc_In_box").children().css("cursor","no-drop");
		});
		
		$(".vc_category_Out").change(function(){
			if( ($(".vc_category_Out:checked").length) < 1){
				msg = "<spring:message code="vaild.message.model.FPolFileInfo.vaccineCategory" />";
				alert(msg);
				this.checked = true;
			}
		});
		$(".vc_category_In").change(function(){
			if( ($(".vc_category_In:checked").length) < 1){
				msg = "<spring:message code="vaild.message.model.FPolFileInfo.vaccineCategory" />";
				alert(msg);
				this.checked = true;
			}
		});
	}
	// vaccine category Outer값 setting 0:VC Not Use 1:VirusChaser 2:ClamAV 3:Multi
	function vcOutCategorySetting(){
		var count = 0;
		if($("#vc_category_Out_sga_chk").is(":checked") == true){
			count += 1;			
		}
		if($("#vc_category_Out_clam_chk").is(":checked") == true){
			count += 2;		
		}
		if($("#vc_yn_Out_N").is(":checked") == true){
			count = 0;
		}
		$("#vc_Out_category").val(count);
	}
	// vaccine category Inner값 setting 0:VC Not Use 1:VirusChaser 2:ClamAV 3:Multi
	function vcInCategorySetting(){
		var count = 0;
		if($("#vc_category_In_sga_chk").is(":checked") == true){
			count += 1;			
		}
		if($("#vc_category_In_clam_chk").is(":checked") == true){
			count += 2;		
		}
		if($("#vc_yn_In_N").is(":checked") == true){
			count = 0;
		}
		$("#vc_In_category").val(count);
	}

	function dlpSetting(){
		if($("#dlp_yn_Out_N").is(":checked") == true){
			$("#dlp_send_Out").children().attr("disabled",true);
			$("#dlp_send_Out").children().css("cursor","no-drop");
			$("#dlp_timeout_Out").attr("disabled",true);
			$("#dlp_timeout_Out").css("cursor","no-drop");
		}
		if($("#dlp_yn_In_N").is(":checked") == true){
			$("#dlp_send_In").children().attr("disabled",true);
			$("#dlp_send_In").children().css("cursor","no-drop");
			$("#dlp_timeout_In").attr("disabled",true);
			$("#dlp_timeout_In").css("cursor","no-drop");
		}
		
		$("#dlp_yn_Out_Y").click(function(){
			$("#dlp_send_Out").children().attr("disabled",false);
			$("#dlp_send_Out").children().css("cursor","pointer");
			$("#dlp_timeout_Out").attr("disabled",false);
			$("#dlp_timeout_Out").css("cursor","auto");
			$("#dlp_send_Out_Y").attr("checked","checked");
		});
		$("#dlp_yn_Out_N").click(function(){
			$("#dlp_send_Out").children().attr("disabled",true);
			$("#dlp_send_Out").children().css("cursor","no-drop");
			$("#dlp_timeout_Out").attr("disabled",true);
			$("#dlp_timeout_Out").css("cursor","no-drop");
		});
		$("#dlp_yn_In_Y").click(function(){
			$("#dlp_send_In").children().attr("disabled",false);
			$("#dlp_send_In").children().css("cursor","pointer");
			$("#dlp_timeout_In").attr("disabled",false);
			$("#dlp_timeout_In").css("cursor","auto");
			$("#dlp_send_In_Y").attr("checked","checked");
			$("#dlp_send_In_N").attr("checked",false);
		});
		$("#dlp_yn_In_N").click(function(){
			$("#dlp_send_In").children().attr("disabled",true);
			$("#dlp_send_In").children().css("cursor","no-drop");
			$("#dlp_timeout_In").attr("disabled",true);
			$("#dlp_timeout_In").css("cursor","no-drop");
		});
	}
	
	function aptSetting() {
		aptScanMaxFileSizeTooltip();
		
		$("#apt_send_In").children().attr("disabled",true);
		$("#apt_send_In").children().css("cursor","no-drop");
		$("#apt_yn_In").children().attr("disabled",true);
		$("#apt_yn_In").children().css("cursor","no-drop");
		$("#apt_file_size_In").children().attr("disabled",true);
		$("#apt_file_size_In").children().css("cursor","no-drop");
		
		if($("#apt_yn_Out_N").is(":checked") == true) {
			$("#apt_send_Out").children().attr("disabled",true);
			$("#apt_send_Out").children().css("cursor","no-drop");

			$("#apt_file_size_Out").children().attr("disabled", true);
			$("#apt_file_size_Out").children().css("cursor","no-drop");
		}
		
		$("#apt_yn_Out_Y").click(function() {
			$("#apt_send_Out").children().attr("disabled",false);
			$("#apt_send_Out").children().css("cursor","pointer");	
			$("#apt_file_size_Out").children().attr("disabled", false);
			$("#apt_file_size_Out").children().css("cursor","pointer");
		});
		$("#apt_yn_Out_N").click(function() {
			$("#apt_send_Out").children().attr("disabled",true);
			$("#apt_send_Out").children().css("cursor","no-drop");
			$("#apt_send_Out_Y").attr("checked", false);
			$("#apt_send_Out_N").attr("checked", "checked");
			$("#apt_file_size_Out").children().attr("disabled", true);
			$("#apt_file_size_Out").children().css("cursor","no-drop");
			$("#apt_file_size_filter_use_yn_Out_Y").attr("checked", false);
			$("#apt_file_size_filter_use_yn_Out_N").attr("checked", "checked");
			$("#apt_scan_max_file_size_Out").val(f_pol_file_apt_scan_max_file_size_min);
		});
	}

	function oleSetting(){
		if($("input[id='ole_yn_In_N']").filter("[value='N']").is(":checked")) {
			$("#ole_fail_send_In").children().attr("disabled", true);
			$("#ole_fail_send_In").children().css("cursor","no-drop");
		}
			
		if($("input[id='ole_yn_Out_N']").filter("[value='N']").is(":checked")) {
			$("#ole_fail_send_Out").children().attr("disabled", true);
			$("#ole_fail_send_Out").children().css("cursor","no-drop");
		}
		
		$("#ole_yn_In_Y").click(function(){
			$("#ole_fail_send_In").children().attr("disabled",false);
			$("#ole_fail_send_In").children().css("cursor","pointer");
		});
		
		
		$("#ole_yn_In_N").click(function(){
			$("#ole_fail_send_In").children().attr("disabled",true);
			$("#ole_fail_send_In").children().css("cursor","no-drop");
		});
		
		$("#ole_yn_Out_Y").click(function(){
			$("#ole_fail_send_Out").children().attr("disabled",false);
			$("#ole_fail_send_Out").children().css("cursor","pointer");
		});
		
		$("#ole_yn_Out_N").click(function(){
			$("#ole_fail_send_Out").children().attr("disabled",true);
			$("#ole_fail_send_Out").children().css("cursor","no-drop");
		});
	}

	function dlpTimeoutTooltip(){
		$(".dlpHelp").hover(function(){
			var rightArea = $("#wrap");
			var popupPosition = $(this).offset();
			var helpPopupTop = popupPosition.top + 25;
			var helpPopupLeft = popupPosition.left + 20;
			var helpPopupDiv = "<div class='helpPopup' style='position:absolute; top:"+ helpPopupTop + "px; left:"+ helpPopupLeft + "px; background-color:#fff; border:3px solid orange; padding:12px; z-index:9999;'><p>" + "<spring:message code='valid.message.model.FPolFileInfo.dlp_timeout_info'/>" + "</p></div>";
			rightArea.append(helpPopupDiv);
		},function(){
			$('.helpPopup').remove();
		});
	}
	
	function selectBoxload(networkposition, chk){
		if(networkposition=='In'){
			if(chk=='Y'){
				$("#loadExtsApprovalPolicy_In").attr("disabled", false);
			}else{
				$("#loadExtsApprovalPolicy_In").attr("disabled", true);
			}
		}else{
			if(chk=='Y'){
				$("#loadExtsApprovalPolicy_Out").attr("disabled", false);
			}else{
				$("#loadExtsApprovalPolicy_Out").attr("disabled", true);
			}	
		}
	}
	
	function encryptBtnAble() {
		<%-- 암호화 확장자 필터링 영역 제어 --%>
		if($("input[id='bw_cd_Out_N']").filter("[value='N']").is(":checked")) {
			disableTrue(false);
		}
		if($("input[id='bw_cd_In_N']").filter("[value='N']").is(":checked")) {
			disableTrue(true);
		}
		
		$(".enc_tooltip_I").hide();
		$(".enc_tooltip_O").hide();
		
		$("input[id='bw_cd_In_N']").click(function() {
			disableTrue(true);
		}); 
		$("input[id='bw_cd_In_W']").click(function() {
			disableFalse(true);
		}); 
		$("input[id='bw_cd_In_B']").click(function() {
			disableFalse(true);
		}); 
		$("input[id='bw_cd_Out_N']").click(function() {
			disableTrue(false);
		}); 
		 $("input[id='bw_cd_Out_W']").click(function() {
			disableFalse(false);
		}); 
		$("input[id='bw_cd_Out_B']").click(function() {
			disableFalse(false);
		}); 
		<%-- 암호화 확장자 필터링 영역 제어 --%>

		function disableTrue( isInnernetworkPosition ) {
			if ( isInnernetworkPosition ) {
				$(".encrypt_I_filte").attr("disabled", true);
				$(".encrypt_I_filte").css("cursor","no-drop");
				$(".ole_In").children().attr("disabled", true);
				$(".ole_In").children().css("cursor","no-drop");

				$("#tooltip_radio_I").show();
				$("#tooltip_select_I").show();
			}else {
				$(".encrypt_O_filte").attr("disabled", true);
				$(".encrypt_O_filte").css("cursor","no-drop");
				$(".ole_Out").children().attr("disabled", true);
				$(".ole_Out").children().css("cursor","no-drop");

				$("#tooltip_radio_O").show();
				$("#tooltip_select_O").show();
			}
		}
		
		function disableFalse( isInnernetworkPosition ) {
			if ( isInnernetworkPosition ) {
				$(".encrypt_I_filte").attr("disabled", false);
				$(".encrypt_I_filte").css("cursor","auto");
				$(".ole_In").children().attr("disabled", false);
				$(".ole_In").children().css("cursor","pointer");
				if($("input[id='ole_yn_In_N']").filter("[value='N']").is(":checked")) {
					$("#ole_fail_send_In").children().attr("disabled", true);
					$("#ole_fail_send_In").children().css("cursor","no-drop");
				}

				$("#tooltip_radio_I").hide();
				$("#tooltip_select_I").hide();
			}else {
				$(".encrypt_O_filte").attr("disabled", false);
				$(".encrypt_O_filte").css("cursor","auto");
				$(".ole_Out").children().attr("disabled", false);
				$(".ole_Out").children().css("cursor","pointer");
				if($("input[id='ole_yn_Out_N']").filter("[value='N']").is(":checked")) {
					$("#ole_fail_send_Out").children().attr("disabled", true);
					$("#ole_fail_send_Out").children().css("cursor","no-drop");
				}

				$("#tooltip_radio_O").hide();
				$("#tooltip_select_O").hide();
			}
		}
	}

	function compressHelpTooltip() {
		$(".compressHelp").hover(function() {
			var rightArea = $("#wrap");
			var popupPosition = $(this).offset();
			var helpPopupTop = popupPosition.top + 25;
			var helpPopupLeft = popupPosition.left - 330;
			var helpPopupDiv = "<div class='helpPopup' style='position:absolute; top:"+ helpPopupTop + "px; left:"+ helpPopupLeft + "px; background-color:#fff; border:3px solid orange; padding:12px; z-index:9999;'><p>" + "<spring:message code='valid.message.model.FPolFileInfo.compress.help'/>" + "</p></div>";
			rightArea.append(helpPopupDiv);
		},function() {
			$('.helpPopup').remove();
		});
	}

	function selectBoxControl() {
		var in_depth_select = null;
		var out_depth_select = null;
		var depthMin = parseInt(f_pol_depth_size_min);
		var depthMax = parseInt(f_pol_depth_size_max);

		for (var i=depthMin; i <= depthMax; i++) {
			in_depth_select = ('${innerfPolFileInfo.depth_size}' == i) ? 'selected' : '';
			out_depth_select = ('${outerfPolFileInfo.depth_size}' == i) ? 'selected' : '';
			$("#depth_size_In").append('<option ' + in_depth_select + ' value=' + i + '>' + parseInt(depthMin + i) + '중 압축</option>');
			$("#depth_size_Out").append('<option ' + out_depth_select + ' value=' + i + '>' + parseInt(depthMin + i) + '중 압축</option>');
		}
	}
	
	function aptScanMaxFileSizeTooltip() {
		$(".aptHelp").hover(function(){
			var rightArea = $("#wrap");
			var popupPosition = $(this).offset();
			var helpPopupTop = popupPosition.top + 25;
			var helpPopupLeft = popupPosition.left + 20;
			var helpPopupDiv = "<div class='helpPopup' style='position:absolute; top:"+ helpPopupTop + "px; left:"+ helpPopupLeft + "px; background-color:#fff; border:3px solid orange; padding:12px; z-index:9999;'><p>" + "설정한 파일사이즈 이하의 파일에 한해 APT 검사를 진행 합니다." + "</p></div>";
			rightArea.append(helpPopupDiv);
		},function(){
			$('.helpPopup').remove();
		});
	}
</script>
</head>
<body>
<div class="rightArea filePolicyInfoDiv">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">파일전송정책 관리</h2>
				<p class="breadCrumbs">정책관리 > 파일전송정책 관리</p>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>파일 전송 정책</h3>
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
								<td class=""><input type="text" class="text_input" id="pol_nm2" name="pol_nm2" onkeyup="onlySizeFillter(this,50)"  value="${fPolFileMgtForm.pol_nm}" /></td>
								<th class="t_center">설명</th>
								<td class=""><input type="text" class="text_input"id="note2" name="note2" onkeyup="onlySizeFillter(this,100)" value="${fPolFileMgtForm.note}"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="tableArea" style="overflow:hidden;">
				<form name="lform_In" id="lform_In" method="post" action="" onSubmit="return false;">
					<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf}" />
					<input type="hidden" id="enc_exts_seq_In" name="enc_exts_seq" value="">
					<input type="hidden" id="exts_seq_In" name="exts_seq" value="">
					<input type="hidden" id="exts_ap_seq_In" name="exts_ap_seq" value="">
					<input type="hidden" id="up_m_use_yn_In" name="up_m_use_yn" value="">
					<input type="hidden" id="clipboard_yn_In" name="clipboard_yn" value="">
					<input type="hidden" id="org_save_term" name="org_save_term" value="5">
					<input type="hidden" id="depth_in_size" name="depth_size" value="">
					<input type="hidden" id="mail_yn" name="mail_yn" value="N">
					<input type="hidden" id="vc_In_category" name="vc_category" value="1">
					<input type="hidden" id="dlp_in_timeout" name="dlp_timeout" value="" />
					<input type="hidden" id="dlp_in_send_yn" name="dlp_send_yn" value="" />
					<input type="hidden" id="apt_in_yn" name="apt_yn" value="" />
					<input type="hidden" id="apt_in_send_yn" name="apt_send_yn" value="" />
					<input type="hidden" id="apt_in_file_size_filter_use_yn" name="apt_file_size_filter_use_yn" value="" />
					<input type="hidden" id="apt_in_scan_max_file_size" name="apt_scan_max_file_size" value="" />					
					<input type="hidden" id="ole_in_fail_send_yn" name="ole_fail_send_yn" value="" />
					<input type="hidden" id="tx_in_download_yn" name="tx_download_yn" value="" />
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
									<th class="no_border" title="${m_size_str}">${m_size_str}<span class="cs_layout">(WEB)</span><br />${m_size_str2}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="m_size_In" name="m_size" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_m_size_max)},${f_pol_file_m_size_min},${f_pol_file_m_size_max})" value="${innerfPolFileInfo.m_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr class="cs_layout">
									<th class="no_border" title="${m_size_str}">${m_size_str}(CS)<br />${m_size_str2}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="m_size_cs_In" name="m_size_cs" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_m_size_cs_max)},${f_pol_file_m_size_cs_min},${f_pol_file_m_size_cs_max})" value="${innerfPolFileInfo.m_size_cs}" size="10" maxlength="10" /> Gbytes
									</td>
								</tr>
								<tr>
									<th title="${one_m_size_str}">${one_m_size_str}<span class="cs_layout">(WEB)</span><br />${one_m_size_str2}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="one_m_size_In" name="one_m_size" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_one_m_size_max)},${f_pol_file_one_m_size_min},${f_pol_file_one_m_size_max})" value="${innerfPolFileInfo.one_m_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr class="cs_layout">
									<th title="${one_m_size_str}">${one_m_size_str}(CS)<br />${one_m_size_str2}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="one_m_size_cs_In" name="one_m_size_cs" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_one_m_size_cs_max)},${f_pol_file_one_m_size_cs_min},${f_pol_file_one_m_size_cs_max})" value="${innerfPolFileInfo.one_m_size_cs}" size="10" maxlength="10" /> Gbytes
									</td>
								</tr>
								<tr>
									<th title="${up_m_size_str}">${up_m_size_str}<br />${up_m_size_str2}</th>
									<td class="t_center">
										<input type="radio" id="up_m_use_yn_In_Y" name="up_m_use_yn_In" value="Y" ${innerfPolFileInfo.up_m_use_yn eq "Y" ? ' checked' : ''}/>
										<label for="up_m_use_yn_In_Y">사용</label>
										<input type="radio" id="up_m_use_yn_In_N" name="up_m_use_yn_In" value="N" ${innerfPolFileInfo.up_m_use_yn eq "N" ? ' checked' : ''}/>
										<label for="up_m_use_yn_In_N">사용안함</label><br><br>
										<input type="text" class="text_input mid" id="up_m_size_In" name="up_m_size" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_up_m_size_max)},${f_pol_file_up_m_size_min},${f_pol_file_up_m_size_max})" value="${innerfPolFileInfo.up_m_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr class="cs_layout clipboard_layout">
									<th title="${clipboard_size_str}">${clipboard_size_str}(CS)</th>
									<td class="t_center">
										<input type="radio" id="clipboard_yn_In_Y" name="clipboard_yn_In" value="Y" ${innerfPolFileInfo.clipboard_yn eq "Y" ? ' checked' : ''}/>
										<label for="clipboard_yn_In_Y">사용</label>
										<input type="radio" id="clipboard_yn_In_N" name="clipboard_yn_In" value="N" ${innerfPolFileInfo.clipboard_yn eq "N" ? ' checked' : ''}/>
										<label for="clipboard_yn_In_N">사용안함</label><br><br>
										<input type="text" class="text_input mid" id="clipboard_size_In" name="clipboard_size" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_clipboard_size_max)},${f_pol_file_clipboard_size_min},${f_pol_file_clipboard_size_max})" value="${innerfPolFileInfo.clipboard_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr>
									<th title="${bw_cd_str}">${bw_cd_str}</th>
									<td class="t_center">
										<span class="tooltip">
											<input type="radio" id="bw_cd_In_B" class="bw_cd_In" name="bw_cd" value="B" ${innerfPolFileInfo.bw_cd == "B" ? ' checked' : ''} />
											<label for="bw_cd_In_B">Black</label>
											<input type="radio" id="bw_cd_In_W" class="bw_cd_In"name="bw_cd" value="W" ${innerfPolFileInfo.bw_cd == "W" ? ' checked' : ''} />
											<label for="bw_cd_In_W">White</label>
											<input type="radio" id="bw_cd_In_N" class="bw_cd_In" name="bw_cd" value="N"  ${innerfPolFileInfo.bw_cd == "N" ? ' checked' : ''} />
											<label for="bw_cd_In_N">사용안함</label>
											<span class="tooltiptext tooltip-bottom-left enc_tooltip_I" >※ 암호화 파일 필터링 설정을 사용안함 처리해야 활성화 됩니다.</span>
										</span>
									</td>
								</tr>
								<tr>
									<th title="${load_exts_policy_str}">${load_exts_policy_str}</th>
									<td class="t_center">
										<div class="select_layer select01" id="query22">
											<select id="loadExtsPolicy_In" name="loadExtsPolicy" title="확장자정책 불러오기">
												<c:forEach items="${fExtsMgtFormList}" var="loadExtsPolicy">
													<option value="${loadExtsPolicy.exts_seq}">${loadExtsPolicy.exts_nm}</option>
												</c:forEach>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th title="${bw_cd_str}">암호화 ${bw_cd_str}</th>
									<td class="t_center">
									<span class="tooltip">
										<input type="radio" id="encrypt_I_filter_A" name="encrypt_filter" class="encrypt_I_filte" value="A" ${innerfPolFileInfo.encrypt_filter == "A" ? ' checked' : ''}/>
										<label for="encrypt_I_filter_A">허용</label>
										<input type="radio" id="encrypt_I_filter_D" name="encrypt_filter" class="encrypt_I_filte" value="D"  ${innerfPolFileInfo.encrypt_filter == "D" ? ' checked' : ''}/>
										<label for="encrypt_I_filter_D">차단</label>
										<input type="radio" id="encrypt_I_filter_N" name="encrypt_filter" class="encrypt_I_filte" value="N"  ${innerfPolFileInfo.encrypt_filter == "N" || innerfPolFileInfo.encrypt_filter == null ? ' checked' : ''}/>
										<label for="encrypt_I_filter_N">사용안함</label>
										<span class="tooltiptext tooltip-bottom-left" id="tooltip_radio_I">※ 확장자 필터링 설정을 사용처리해야 활성화 됩니다.</span>
									</span>
									</td>
								</tr>
								<tr>
									<th title="${load_exts_policy_str}">암호화 ${load_exts_policy_str}</th>
									<td class="t_center">
										<div class="select_layer select01" id="query23">
										<span class="tooltip">
											<select id="load_Enc_Exts_Policy_In" name="loadEncExtsPolicy" class="encrypt_I_filte" title="확장자정책 불러오기">
												<c:forEach items="${fExtsMgtFormList}" var="loadExtsPolicy">
													<option value="${loadExtsPolicy.exts_seq}">${loadExtsPolicy.exts_nm}</option>
												</c:forEach>
											</select>
											<span class="tooltiptext tooltip-bottom-left" id="tooltip_select_I">※ 확장자 필터링 설정을 사용처리해야 활성화 됩니다.</span>
										</span>
										</div>
									</td>
								</tr>
								<tr class="${ isUseApprovalExtension ? '' : 'none' }">
									<th title="${load_exts_approval_policy_str}">${load_exts_approval_policy_str}</th>
									<td class="t_center">
										<input type="radio" id="bw_cd_approval_In_Y" name="exts_ap_yn" value="Y" ${innerfPolFileInfo.exts_ap_yn == "Y" ? ' checked' : ''} onchange="selectBoxload('In','Y')"/>
										<label for="bw_cd_approval_In_Y">사용</label>
										<input type="radio" id="bw_cd_approval_In_N" name="exts_ap_yn" value="N" ${innerfPolFileInfo.exts_ap_yn == "N" ? ' checked' : ''} onchange="selectBoxload('In','N')"/>
										<label for="bw_cd_approval_In_N">사용안함</label><br>
										<div class="select_layer select01" style="padding-top: 10px;" id="select_load_In">
											<select id="loadExtsApprovalPolicy_In" name="loadExtsApprovalPolicy" title="확장자정책 불러오기">
												<c:forEach items="${fExtsMgtFormList}" var="loadExtsPolicy">
													<option value="${loadExtsPolicy.exts_seq}">${loadExtsPolicy.exts_nm}</option>
												</c:forEach>
											</select>
										</div>
									</td>
								</tr>
								<tr class="ole_layout">
									<th title="OLE검사">OLE검사</th>
									<td class="t_center">
									<span class="tooltip ole_In">
										<input type="radio" id="ole_yn_In_Y" name="ole_yn" class="" value="Y" ${outerfPolFileInfo.ole_yn == "Y" ? ' checked' : ''}/>
										<label for="ole_yn_In_Y" class="mg_r15">사용</label>
										<input type="radio" id="ole_yn_In_N" name="ole_yn" class="" value="N" ${outerfPolFileInfo.ole_yn == "N" || outerfPolFileInfo.ole_yn == null ? ' checked' : ''} />
										<label for="ole_yn_In_N">사용안함</label>
										<span class="tooltiptext tooltip-bottom-left" id="tooltip_radio_O">※ 확장자 필터링 설정을 사용처리해야 활성화 됩니다.</span>
									</span>
									</td>
								</tr>
								<tr class="ole_layout">
									<th title="OLE검출실패 파일 전송">OLE검출실패 파일 전송</th>
									<td id="ole_fail_send_In" class="t_center ole_In">
										<input type="radio" id="ole_fail_send_In_Y" name="ole_fail_send_yn_in" value="Y" ${outerfPolFileInfo.ole_fail_send_yn == "Y" ? ' checked' : ''} />
										<label for="ole_fail_send_In_Y" class="mg_r15">전송</label>
										<input type="radio" id="ole_fail_send_In_N" name="ole_fail_send_yn_in" value="N" ${outerfPolFileInfo.ole_fail_send_yn == "N" || outerfPolFileInfo.ole_fail_send_yn == null  ? ' checked' : ''}/>
										<label for="ole_fail_send_In_N">전송안함</label>
									</td>
								</tr>
								<tr>
									<th title="${title_size}">${title_size}</th>
									<td class="t_center">
										<span class="tooltip"><input type="checkbox" id="title_use_yn_In" name="title_use_yn" value="${innerfPolFileInfo.title_use_yn}"${innerfPolFileInfo.title_use_yn eq 'Y' ? "CHECKED":""} onclick="chkValue('In')"><label for="title_use_yn_In">필수</label> 
										<span class="tooltiptext tooltip-bottom">※ 필수 체크 <br>-> 설정된 길이 내에 무조건 입력<br>※ 필수 해제 <br>-> 입력하지 않아도 업로드 첫번째 파일명으로 자동입력 </span>
										</span>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
										<input type="text" class="text_input" style="width:10%;" id="title_size_min_In" name="title_size_min" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_title_size_max)},${f_pol_title_size_min},${f_pol_title_size_max})" value="${innerfPolFileInfo.title_size_min}" size="10" maxlength="10" />
										~
										<input type="text" class="text_input" style="width:10%;" id="title_size_max_In" name="title_size_max" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_title_size_max)},${f_pol_title_size_min},${f_pol_title_size_max})" value="${innerfPolFileInfo.title_size_max}" size="10" maxlength="10" />&nbsp;자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</td>
								</tr>
								<tr>
									<th title="${up_f_cnt}">${up_f_cnt}<span class="cs_layout">(WEB)</span></th>
									<td class="t_center">
										<input type="radio" id="up_f_cnt_Y_In" name="up_f_cnt_yn" value="Y" ${ innerfPolFileInfo.up_f_cnt ne null ? 'checked' : '' }/>
										<label for="up_f_cnt_Y_In">
											<input type="text" class="text_input mid_label" id="up_f_cnt_In" name="up_f_cnt" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_max_cnt_max)},${f_pol_file_max_cnt_min},${f_pol_file_max_cnt_max})" value="${innerfPolFileInfo.up_f_cnt}" size="10" maxlength="10" />&nbsp;개 
										</label>
										<input type="radio" class="mg_Fl10" id="up_f_cnt_N_In" name="up_f_cnt_yn" value="N" ${ innerfPolFileInfo.up_f_cnt eq null ? 'checked' : '' }/>
										<label for="up_f_cnt_N_In">사용안함</label>
									</td>
								</tr>
								<tr class="cs_layout">
									<th title="${up_f_cnt}">${up_f_cnt}(CS)</th>
									<td class="t_center">
										<input type="radio" id="up_f_cnt_cs_Y_In" name="up_f_cnt_cs_yn" value="Y" ${ innerfPolFileInfo.up_f_cnt_cs ne null ? 'checked' : '' }/>
										<label for="up_f_cnt_cs_Y_In">
											<input type="text" class="text_input mid_label" id="up_f_cnt_cs_In" name="up_f_cnt_cs" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_max_cnt_cs_max)},${f_pol_file_max_cnt_cs_min},${f_pol_file_max_cnt_cs_max})" value="${innerfPolFileInfo.up_f_cnt_cs}" size="10" maxlength="10" />&nbsp;개 
										</label>
										<input type="radio" class="mg_Fl10" id="up_f_cnt_cs_N_In" name="up_f_cnt_cs_yn" value="N" ${ innerfPolFileInfo.up_f_cnt_cs eq null ? 'checked' : '' }/>
										<label for="up_f_cnt_cs_N_In">사용안함</label>
									</td>
								</tr>
								<tr>
									<th title="${vc_yn_str}" class="vc_layout">${vc_yn_str}</th>
									<td class="t_center">
										<div class="vc_yn_In_layout">
										<input type="radio" id="vc_yn_In_Y" name="vc_yn" value="Y" ${innerfPolFileInfo.vc_yn == "Y" ? ' checked' : ''} />
										<label for="vc_yn_In_Y" class="mg_r15">사용</label>
										<input type="radio" id="vc_yn_In_N" name="vc_yn" value="N" ${innerfPolFileInfo.vc_yn == "N" ? ' checked' : ''} />
										<label for="vc_yn_In_N">사용안함</label>
										</div>
										<br>
										
										<div id="vc_In_box" class="vc_yn_In_layout">
										<input type="checkbox" class="vc_category_In" id="vc_category_In_sga_chk" value="Y" ${innerfPolFileInfo.vc_category == 3 || innerfPolFileInfo.vc_category == 1 ? 'checked' : ''} />
										<label for="vc_category_In_sga_chk" class="mg_r15">VirusChaser</label>
										<input type="checkbox" class="vc_category_In" id="vc_category_In_clam_chk" value="Y" ${innerfPolFileInfo.vc_category == 3 || innerfPolFileInfo.vc_category == 2 ? 'checked' : ''} />
										<label for="vc_category_In_clam_chk" class="mg_r15">ClamAV</label>
										</div>
									</td>
								</tr>
								<tr class="mail_layout">
									<th title="메일발송">자료메일발송<br />(메일 첨부 파일 용량)</th>
									<td class="t_center" style="color: #dcdcdc;">
										<input type="radio" id="mail_yn_In_Y" name="mail_yn" value="Y" style="cursor: no-drop;" disabled="disabled"/>
										<label for="mail_yn_In_Y" class="mg_r15" style="cursor: no-drop;">사용</label>
										<input type="radio" id="mail_is_yn_In_N" name="mail_yn" value="N" style="cursor: no-drop;" disabled="disabled" checked="checked"/>
										<label for="mail_yn_In_N" style="cursor: no-drop;">사용안함</label><br><br>
										<input type="text" class="text_input mid" id="mail_file_size_In" name="mail_file_size"  style="cursor: no-drop;" value="${innerfPolFileInfo.mail_file_size}" disabled="disabled" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr>
									<th title="중첩 압축파일">중첩 압축파일</th>
									<td id="overlap_compress_in" class="t_center">
										<input type="radio" id="overlap_compress_in_N" name="compress_yn" value="N" ${innerfPolFileInfo.compress_yn == "N" || innerfPolFileInfo.compress_yn == null ? ' checked' : ''}/>
										<label id="label_compress_in_N" for="overlap_compress_in_N" class="mg_r15">허용</label>
										<input type="radio" id="overlap_compress_in_Y" name="compress_yn" value="Y" ${innerfPolFileInfo.compress_yn == "Y" ? ' checked' : ''}/>
										<label id="label_compress_in_Y" for="overlap_compress_in_Y">차단</label><br><br>
										<select id="depth_size_In" name="depth_size_In"></select>
										<img class="compressHelp" src="/Images/icon/icon_small_question.gif" />
									</td>
								</tr>
								<tr  class="dlp_layout">
									<th title="개인정보검출">개인정보검출</th>
									<td class="t_center">
										<input type="radio" id="dlp_yn_In_Y" name="dlp_yn" value="Y" ${innerfPolFileInfo.dlp_yn == "Y" ? ' checked' : ''}/>
										<label for="dlp_yn_In_Y" class="mg_r15">사용</label>
										<input type="radio" id="dlp_yn_In_N" name="dlp_yn" value="N" ${innerfPolFileInfo.dlp_yn == "N" || innerfPolFileInfo.dlp_yn == null ? ' checked' : ''}/>
										<label for="dlp_yn_In_N">사용안함</label><br><br>
										<input type="text" class="text_input mid" id="dlp_timeout_In" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_dlp_timeout_max)},${f_pol_dlp_timeout_min},${f_pol_dlp_timeout_max})" value="${innerfPolFileInfo.dlp_timeout}" size="10" maxlength="10" /> 초
										<img class="dlpHelp" src="/Images/icon/icon_small_question.gif" />
									</td>
								</tr>
								<tr  class="dlp_layout">
									<th title="개인정보검출 파일 전송">개인정보검출 파일 전송</th>
									<td id="dlp_send_In" class="t_center">
										<input type="radio" id="dlp_send_In_Y" name="dlp_send_yn_in" value="Y" ${innerfPolFileInfo.dlp_send_yn == "Y" ? ' checked' : ''} />
										<label for="dlp_send_In_Y" class="mg_r15">전송</label>
										<input type="radio" id="dlp_send_In_N" name="dlp_send_yn_in" value="N" ${innerfPolFileInfo.dlp_send_yn == "N" || innerfPolFileInfo.dlp_send_yn == null  ? ' checked' : ''}/>
										<label for="dlp_send_In_N">전송안함</label>
									</td>
								</tr>
								<tr  class="apt_layout">
									<th title="APT검사">APT검사</th>
									<td id="apt_yn_In" class="t_center">
										<input type="radio" id="apt_yn_In_Y" name="apt_yn_In" value="Y"  />
										<label for="apt_yn_In_Y" class="mg_r15">사용</label>
										<input type="radio" id="apt_yn_In_N" name="apt_yn_In" value="N" checked />
										<label for="apt_yn_In_N">사용안함</label>
									</td>
								</tr>
								<tr class="apt_layout apt_send_layout">
									<th title="APT 검출파일 전송">APT 검출파일 전송</th>
									<td id="apt_send_In" class="t_center">
										<input type="radio" id="apt_send_In_Y" name="apt_send_yn_in" value="Y"  />
										<label for="apt_send_In_Y" class="mg_r15">전송</label>
										<input type="radio" id="apt_send_In_N" name="apt_send_yn_in" value="N" checked />
										<label for="apt_send_In_N">전송안함</label>
									</td>
								</tr>
								<tr class="apt_layout">
									<th title="APT검사 파일 사이즈 제한">APT검사 파일사이즈 제한</th>
									<td id="apt_file_size_In" class="t_center">
										<input type="radio" id="apt_file_size_filter_use_yn_In_Y" name="apt_file_size_filter_use_yn_In" value="Y" />
										<label for="apt_file_size_filter_use_yn_In_Y" class="mg_r15">사용</label>
										<input type="radio" id="apt_file_size_filter_use_yn_In_N" name="apt_file_size_filter_use_yn_In" value="N" checked />
										<label for="apt_file_size_filter_use_yn_In_N">사용안함</label><br><br>
										<input type="text" class="text_input mid" id="apt_scan_max_file_size_In" name=apt_scan_max_file_size_In
											onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_apt_scan_max_file_size_max)},${f_pol_file_apt_scan_max_file_size_min},${f_pol_file_apt_scan_max_file_size_max})" 
												value="${innerfPolFileInfo.apt_scan_max_file_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr class="tx_download_layout">
									<th title="${tx_download}">${tx_download}</th>
									<td id="tx_download_In" class="t_center">
										<input type="radio" id="tx_download_In_Y" name="tx_download_yn_in" value="Y" ${innerfPolFileInfo.tx_download_yn == "Y" || innerfPolFileInfo.tx_download_yn == null ? ' checked' : ''}/>
										<label for="tx_download_In_Y" class="mg_r15">사용</label>
										<input type="radio" id="tx_download_In_N" name="tx_download_yn_in" value="N" ${innerfPolFileInfo.tx_download_yn == "N" ? ' checked' : ''}/>
										<label for="tx_download_In_N">사용안함</label>
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
				<input type="hidden" id="cud_cd" name="cud_cd" value="${fPolFileMgtForm.cud_cd}">
				<input type="hidden" id="isdel_yn" name="isdel_yn" value="${fPolFileMgtForm.isdel_yn}">
				<input type="hidden" id="enc_exts_seq_Out" name="enc_exts_seq" value="">
				<input type="hidden" id="exts_seq_Out" name="exts_seq" value="">
				<input type="hidden" id="exts_ap_seq_Out" name="exts_ap_seq" value="">
				<input type="hidden" id="up_m_use_yn_Out" name="up_m_use_yn" value="">
				<input type="hidden" id="clipboard_yn_Out" name="clipboard_yn" value="">
				<input type="hidden" id="org_save_term" name="org_save_term" value="5">
				<input type="hidden" id="depth_out_size" name="depth_size" value="">
				<input type="hidden" id="vc_Out_category" name="vc_category" value="1">
				<input type="hidden" id="dlp_out_timeout" name="dlp_timeout" value="" />
				<input type="hidden" id="dlp_out_send_yn" name="dlp_send_yn" value="" />
				<input type="hidden" id="apt_out_send_yn" name="apt_send_yn" value="" />
				<input type="hidden" id="apt_out_file_size_filter_use_yn" name="apt_file_size_filter_use_yn" value="" />
				<input type="hidden" id="apt_out_scan_max_file_size" name="apt_scan_max_file_size" value="" />
				<input type="hidden" id="ole_out_fail_send_yn" name="ole_fail_send_yn" value="" />
				<input type="hidden" id="tx_out_download_yn" name="tx_download_yn" value="" />
				<!-- <input type="hidden" id="vc_yn" name="vc_yn" value="Y"> -->
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
									<th class="no_border" title="${m_size_str}">${m_size_str}<span class="cs_layout">(WEB)</span><br />${m_size_str2}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="m_size_Out" name="m_size" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_m_size_max)},${f_pol_file_m_size_min},${f_pol_file_m_size_max})" value="${outerfPolFileInfo.m_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr class="cs_layout">
									<th class="no_border" title="${m_size_str}">${m_size_str}(CS)<br />${m_size_str2}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="m_size_cs_Out" name="m_size_cs" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_m_size_cs_max)},${f_pol_file_m_size_cs_min},${f_pol_file_m_size_cs_max})" value="${outerfPolFileInfo.m_size_cs}" size="10" maxlength="10" /> Gbytes 
									</td>
								</tr>
								<tr>
									<th title="${one_m_size_str}">${one_m_size_str}<span class="cs_layout">(WEB)</span><br />${one_m_size_str2}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="one_m_size_Out" name="one_m_size" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_one_m_size_max)},${f_pol_file_one_m_size_min},${f_pol_file_one_m_size_max})" value="${outerfPolFileInfo.one_m_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr class="cs_layout">
									<th title="${one_m_size_str}">${one_m_size_str}(CS)<br />${one_m_size_str2}</th>
									<td class="t_center">
										<input type="text" class="text_input mid" id="one_m_size_cs_Out" name="one_m_size_cs" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_one_m_size_cs_max)},${f_pol_file_one_m_size_cs_min},${f_pol_file_one_m_size_cs_max})" value="${outerfPolFileInfo.one_m_size_cs}" size="10" maxlength="10" /> Gbytes
									</td>
								</tr>
								<tr>
									<th title="${up_m_size_str}">${up_m_size_str}<br />${up_m_size_str2}</th>
									<td class="t_center">
										<input type="radio" id="up_m_use_yn_Out_Y" name="up_m_use_yn_Out" value="Y" ${outerfPolFileInfo.up_m_use_yn eq "Y" ? ' checked' : ''}/>
										<label for="up_m_use_yn_Out_Y">사용</label>
										<input type="radio" id="up_m_use_yn_Out_N" name="up_m_use_yn_Out" value="N" ${outerfPolFileInfo.up_m_use_yn eq "N" ? ' checked' : ''}/>
										<label for="up_m_use_yn_Out_N">사용안함</label><br><br>
										<input type="text" class="text_input mid" id="up_m_size_Out" name="up_m_size" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_up_m_size_max)},${f_pol_file_up_m_size_min},${f_pol_file_up_m_size_max})" value="${outerfPolFileInfo.up_m_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr class="cs_layout clipboard_layout">
									<th title="${clipboard_size_str}">${clipboard_size_str}(CS)</th>
									<td class="t_center">
										<input type="radio" id="clipboard_yn_Out_Y" name="clipboard_yn_Out" value="Y" ${outerfPolFileInfo.clipboard_yn eq "Y" ? ' checked' : ''}/>
										<label for="clipboard_yn_Out_Y">사용</label>
										<input type="radio" id="clipboard_yn_Out_N" name="clipboard_yn_Out" value="N" ${outerfPolFileInfo.clipboard_yn eq "N" ? ' checked' : ''}/>
										<label for="clipboard_yn_Out_N">사용안함</label><br><br>
										<input type="text" class="text_input mid" id="clipboard_size_Out" name="clipboard_size" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_clipboard_size_max)},${f_pol_file_clipboard_size_min},${f_pol_file_clipboard_size_max})" value="${outerfPolFileInfo.clipboard_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr>
									<th title="${bw_cd_str}">${bw_cd_str}</th>
									<td class="t_center">
										<span class="tooltip">
											<input type="radio" id="bw_cd_Out_B" class="bw_cd_Out" name="bw_cd" value="B" ${outerfPolFileInfo.bw_cd == "B" ? ' checked' : ''} />
											<label for="bw_cd_Out_B">Black</label>
											<input type="radio" id="bw_cd_Out_W" class="bw_cd_Out" name="bw_cd" value="W" ${outerfPolFileInfo.bw_cd == "W" ? ' checked' : ''} />
											<label for="bw_cd_Out_W">White</label>
											<input type="radio" id="bw_cd_Out_N" class="bw_cd_Out" name="bw_cd" value="N"  ${outerfPolFileInfo.bw_cd == "N" ? ' checked' : ''} />
											<label for="bw_cd_Out_N">사용안함</label>
											<span class="tooltiptext tooltip-bottom-left enc_tooltip_O" >※ 암호화 파일 필터링 설정을 사용안함 처리해야 활성화 됩니다.</span>
										</span>
									</td>
								</tr>
								<tr>
									<th title="${load_exts_policy_str}">${load_exts_policy_str}</th>
									<td class="t_center">
										<div class="select_layer select01" id="query22">
											<select id="loadExtsPolicy_Out" name="loadExtsPolicy" title="확장자정책 불러오기">
												<c:forEach items="${fExtsMgtFormList}" var="loadExtsPolicy">
												<option value="${loadExtsPolicy.exts_seq}">${loadExtsPolicy.exts_nm}</option>
												</c:forEach>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th title="${bw_cd_str}">암호화 ${bw_cd_str}</th>
									<td class="t_center">
									<span class="tooltip">
										<input type="radio" id="encrypt_O_filter_A" name="encrypt_filter" class="encrypt_O_filte" value="A" ${outerfPolFileInfo.encrypt_filter == "A" ? ' checked' : ''}/>
										<label for="encrypt_O_filter_A">허용</label>
										<input type="radio" id="encrypt_O_filter_D" name="encrypt_filter" class="encrypt_O_filte" value="D"  ${outerfPolFileInfo.encrypt_filter == "D" ? ' checked' : ''}/>
										<label for="encrypt_O_filter_D">차단</label>
										<input type="radio" id="encrypt_O_filter_N" name="encrypt_filter" class="encrypt_O_filte" value="N"  ${outerfPolFileInfo.encrypt_filter == "N" || outerfPolFileInfo.encrypt_filter == null ? ' checked' : ''}/>
										<label for="encrypt_O_filter_N">사용안함</label>
										<span class="tooltiptext tooltip-bottom-left" id="tooltip_radio_O">※ 확장자 필터링 설정을 사용처리해야 활성화 됩니다.</span>
									</span>
									</td>
								</tr>
								<tr>
									<th title="${load_exts_policy_str}">암호화 ${load_exts_policy_str}</th>
									<td class="t_center">
										<div class="select_layer select01" id="query23">
										<span class="tooltip">
											<select id="load_Enc_Exts_Policy_Out" name="loadEncExtsPolicy" class="encrypt_O_filte" title="확장자정책 불러오기">
												<c:forEach items="${fExtsMgtFormList}" var="loadExtsPolicy">
												<option value="${loadExtsPolicy.exts_seq}">${loadExtsPolicy.exts_nm}</option>
												</c:forEach>
											</select>
											<span class="tooltiptext tooltip-bottom-left" id="tooltip_select_O">※ 확장자 필터링 설정을 사용처리해야 활성화 됩니다.</span>
										</span>
										</div>
									</td>
								</tr>
								<tr class="${ isUseApprovalExtension ? '' : 'none' }">
									<th title="${load_exts_approval_policy_str}">${load_exts_approval_policy_str}</th>
									<td class="t_center">
										<input type="radio" id="bw_cd_approval_Out_Y" name="exts_ap_yn" value="Y" ${outerfPolFileInfo.exts_ap_yn == "Y" ? ' checked' : ''} onchange="selectBoxload('Out','Y')"/>
										<label for="bw_cd_approval_Out_Y">사용</label>
										<input type="radio" id="bw_cd_approval_Out_N" name="exts_ap_yn" value="N" ${outerfPolFileInfo.exts_ap_yn == "N" ? ' checked' : ''} onchange="selectBoxload('Out','N')"/>
										<label for="bw_cd_approval_Out_N">사용안함</label><br>
										<div class="select_layer select01" style="padding-top: 10px;" id="select_load_Out">
										<span class="tooltip">
											<select id="loadExtsApprovalPolicy_Out" name="loadExtsApprovalPolicy" title="확장자정책 불러오기">
												<c:forEach items="${fExtsMgtFormList}" var="loadExtsPolicy">
													<option value="${loadExtsPolicy.exts_seq}">${loadExtsPolicy.exts_nm}</option>
												</c:forEach>
												<span class="tooltiptext tooltip-bottom-left" id="tooltip_enc_O">※ 확장자 필터링 설정을 사용처리해야 활성화 됩니다.</span>
											</select>
										</span>
										</div>
									</td>
								</tr>
								<tr class="ole_layout">
									<th title="OLE검사">OLE검사</th>
									<td class="t_center">
									<span class="tooltip ole_Out">
										<input type="radio" id="ole_yn_Out_Y" name="ole_yn" class="" value="Y" ${outerfPolFileInfo.ole_yn == "Y" ? ' checked' : ''}/>
										<label for="ole_yn_Out_Y" class="mg_r15">사용</label>
										<input type="radio" id="ole_yn_Out_N" name="ole_yn" class="" value="N" ${outerfPolFileInfo.ole_yn == "N" || outerfPolFileInfo.ole_yn == null ? ' checked' : ''} />
										<label for="ole_yn_Out_N">사용안함</label>
										<span class="tooltiptext tooltip-bottom-left" id="tooltip_radio_O">※ 확장자 필터링 설정을 사용처리해야 활성화 됩니다.</span>
									</span>
									</td>
								</tr>
								<tr class="ole_layout">
									<th title="OLE검출실패 파일 전송">OLE검출실패 파일 전송</th>
									<td id="ole_fail_send_Out" class="t_center ole_Out">
										<input type="radio" id="ole_fail_send_Out_Y" name="ole_fail_send_yn_out" value="Y" ${outerfPolFileInfo.ole_fail_send_yn == "Y" ? ' checked' : ''} />
										<label for="ole_fail_send_Out_Y" class="mg_r15">전송</label>
										<input type="radio" id="ole_fail_send_Out_N" name="ole_fail_send_yn_out" value="N" ${outerfPolFileInfo.ole_fail_send_yn == "N" || outerfPolFileInfo.ole_fail_send_yn == null  ? ' checked' : ''}/>
										<label for="ole_fail_send_Out_N">전송안함</label>
									</td>
								</tr>
								<tr>
									<th title="${title_size}">${title_size}</th>
									<td class="t_center">
										<span class="tooltip"><input type="checkbox" id="title_use_yn_Out" name="title_use_yn" value="${outerfPolFileInfo.title_use_yn}"${outerfPolFileInfo.title_use_yn eq 'Y' ? "CHECKED":""} onclick="chkValue('Out')"><label for="title_use_yn_Out">필수</label> 
										<span class="tooltiptext tooltip-bottom">※ 필수 체크 <br>-> 설정된 길이 내에 무조건 입력<br>※ 필수 해제 <br>-> 입력하지 않아도 업로드 첫번째 파일명으로 자동입력 </span>
										</span>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br><br>
										<input type="text" class="text_input" style="width:10%;" id="title_size_min_Out" name="title_size_min" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_title_size_max)},${f_pol_title_size_min},${f_pol_title_size_max})" value="${outerfPolFileInfo.title_size_min}" size="10" maxlength="10" />
										~
										<input type="text" class="text_input" style="width:10%;" id="title_size_max_Out" name="title_size_max" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_title_size_max)},${f_pol_title_size_min},${f_pol_title_size_max})" value="${outerfPolFileInfo.title_size_max}" size="10" maxlength="10" />&nbsp;자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</td>
								</tr>
								<tr>
									<th title="${up_f_cnt}">${up_f_cnt}<span class="cs_layout">(WEB)</span></th>
									<td class="t_center">
										<input type="radio" id="up_f_cnt_Y_Out" name="up_f_cnt_yn" value="Y" ${ outerfPolFileInfo.up_f_cnt ne null ? 'checked' : '' }/>
										<label for="up_f_cnt_Y_Out">
											<input type="text" class="text_input mid_label" id="up_f_cnt_Out" name="up_f_cnt" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_max_cnt_max)},${f_pol_file_max_cnt_min},${f_pol_file_max_cnt_max})" value="${outerfPolFileInfo.up_f_cnt}" size="10" maxlength="10" />&nbsp;개
										</label>
										<input type="radio" class="mg_Fl10" id="up_f_cnt_N_Out" name="up_f_cnt_yn" value="N" ${ outerfPolFileInfo.up_f_cnt eq null ? 'checked' : '' }/>
										<label for="up_f_cnt_N_Out">사용안함</label>
									</td>
								</tr>
								<tr class="cs_layout">
									<th title="${up_f_cnt}">${up_f_cnt}(CS)</th>
									<td class="t_center">
										<input type="radio" id="up_f_cnt_cs_Y_Out" name="up_f_cnt_cs_yn" value="Y" ${ outerfPolFileInfo.up_f_cnt_cs ne null ? 'checked' : '' }/>
										<label for="up_f_cnt_cs_Y_Out">
											<input type="text" class="text_input mid_label" id="up_f_cnt_cs_Out" name="up_f_cnt_cs" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_max_cnt_cs_max)},${f_pol_file_max_cnt_cs_min},${f_pol_file_max_cnt_cs_max})" value="${outerfPolFileInfo.up_f_cnt_cs}" size="10" maxlength="10" />&nbsp;개
										</label>
										<input type="radio" class="mg_Fl10" id="up_f_cnt_cs_N_Out" name="up_f_cnt_cs_yn" value="N" ${ outerfPolFileInfo.up_f_cnt_cs eq null ? 'checked' : '' }/>
										<label for="up_f_cnt_cs_N_Out">사용안함</label>
									</td>
								</tr>
								<tr>
									<th title="${vc_yn_str}" class="vc_layout">${vc_yn_str}</th>
									<td class="t_center">
										<div class="vc_yn_layout">
										<input type="radio" id="vc_yn_Out_Y" name="vc_yn" value="Y" ${outerfPolFileInfo.vc_yn == "Y" ? ' checked' : ''}/>
										<label for="vc_yn_Out_Y" class="mg_r15">사용</label>
										<input type="radio" id="vc_yn_Out_N" name="vc_yn" value="N" ${outerfPolFileInfo.vc_yn == "N" ? ' checked' : ''}/>
										<label for="vc_yn_Out_N">사용안함</label>
										</div>
										<br>
										
										<div id="vc_Out_box">
										<input type="checkbox" class="vc_category_Out" id="vc_category_Out_sga_chk" value="Y" ${outerfPolFileInfo.vc_category == 3 || outerfPolFileInfo.vc_category == 1 ? 'checked' : ''}/>
										<label for="vc_category_Out_sga_chk" class="mg_r15">VirusChaser</label>
										<input type="checkbox" class="vc_category_Out" id="vc_category_Out_clam_chk" value="Y" ${outerfPolFileInfo.vc_category == 3 || outerfPolFileInfo.vc_category == 2 ? 'checked' : ''}/>
										<label for="vc_category_Out_clam_chk" class="mg_r15">ClamAV</label>
										</div>
									</td>
								</tr>
								<tr class="mail_layout">
									<th title="메일발송">자료메일발송<br />(메일 첨부 파일 용량)</th>
									<td class="t_center">
										<input type="radio" id="mail_yn_Out_Y" name="mail_yn" value="Y" ${outerfPolFileInfo.mail_yn == "Y" ? ' checked' : ''}/>
										<label for="mail_yn_Out_Y" class="mg_r15">사용</label>
										<input type="radio" id="mail_yn_Out_N" name="mail_yn" value="N" ${outerfPolFileInfo.mail_yn == "N" || outerfPolFileInfo.mail_yn == null ? ' checked' : ''}/>
										<label for="mail_yn_Out_N">사용안함</label><br><br>
										<input type="text" class="text_input mid" id="mail_file_size_Out" name="mail_file_size" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_mail_file_size_max)},${f_pol_mail_file_size_min},${f_pol_mail_file_size_max})" value="${outerfPolFileInfo.mail_file_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr>
									<th title="중첩 압축파일">중첩 압축파일</th>
									<td id="overlap_compress_out" class="t_center">
										<input type="radio" id="overlap_compress_out_N" name="compress_yn" value="N" ${outerfPolFileInfo.compress_yn == "N" || outerfPolFileInfo.compress_yn == null ? ' checked' : ''} />
										<label id="label_compress_out_N" for="overlap_compress_out_N" class="mg_r15">허용</label>
										<input type="radio" id="overlap_compress_out_Y" name="compress_yn" value="Y" ${outerfPolFileInfo.compress_yn == "Y" ? ' checked' : ''}/>
										<label id="label_compress_out_Y" for="overlap_compress_out_Y">차단</label><br><br>
										<select id="depth_size_Out" name="depth_size_Out"></select>
										<img class="compressHelp" src="/Images/icon/icon_small_question.gif" />
									</td>
								</tr>
								<tr class="dlp_layout">
									<th title="개인정보검출">개인정보검출</th>
									<td class="t_center">
										<input type="radio" id="dlp_yn_Out_Y" name="dlp_yn" value="Y" ${outerfPolFileInfo.dlp_yn == "Y" ? ' checked' : ''} />
										<label for="dlp_yn_Out_Y" class="mg_r15">사용</label>
										<input type="radio" id="dlp_yn_Out_N" name="dlp_yn" value="N" ${outerfPolFileInfo.dlp_yn == "N" || outerfPolFileInfo.dlp_yn == null ? ' checked' : ''}/>
										<label for="dlp_yn_Out_N">사용안함</label><br><br>
										<input type="text" class="text_input mid" id="dlp_timeout_Out" onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_dlp_timeout_max)},${f_pol_dlp_timeout_min},${f_pol_dlp_timeout_max})" value="${outerfPolFileInfo.dlp_timeout}" size="10" maxlength="10" /> 초
										<img class="dlpHelp" src="/Images/icon/icon_small_question.gif" />
									</td>
								</tr>
								<tr class="dlp_layout">
									<th title="개인정보검출 파일 전송">개인정보검출 파일 전송</th>
									<td id="dlp_send_Out" class="t_center">
										<input type="radio" id="dlp_send_Out_Y" name="dlp_send_yn_out" value="Y" ${outerfPolFileInfo.dlp_send_yn == "Y" ? ' checked' : ''}  />
										<label for="dlp_send_Out_Y" class="mg_r15">전송</label>
										<input type="radio" id="dlp_send_Out_N" name="dlp_send_yn_out" value="N" ${outerfPolFileInfo.dlp_send_yn == "N"  || outerfPolFileInfo.dlp_send_yn == null ? ' checked' : ''}/>
										<label for="dlp_send_Out_N">전송안함</label>
									</td>
								</tr>
								<tr  class="apt_layout">
									<th title="APT검사">APT검사</th>
									<td class="t_center">
										<input type="radio" id="apt_yn_Out_Y" name="apt_yn" value="Y" ${outerfPolFileInfo.apt_yn == "Y" ? ' checked' : ''}/>
										<label for="apt_yn_Out_Y" class="mg_r15">사용</label>
										<input type="radio" id="apt_yn_Out_N" name="apt_yn" value="N" ${outerfPolFileInfo.apt_yn == "N" || outerfPolFileInfo.apt_yn == null ? ' checked' : ''}/>
										<label for="apt_yn_Out_N">사용안함</label>
									</td>
								</tr>
								<tr  class="apt_layout apt_send_layout">
									<th title="APT 검출파일 전송">APT 검출파일 전송</th>
									<td id="apt_send_Out" class="t_center">
										<input type="radio" id="apt_send_Out_Y" name="apt_send_yn_out" value="Y" ${outerfPolFileInfo.apt_send_yn == "Y" ? ' checked' : ''} />
										<label for="apt_send_Out_Y" class="mg_r15">전송</label>
										<input type="radio" id="apt_send_Out_N" name="apt_send_yn_out" value="N" ${outerfPolFileInfo.apt_send_yn == "N" || outerfPolFileInfo.apt_send_yn == null  ? ' checked' : ''}/>
										<label for="apt_send_Out_N">전송안함</label>
									</td>
								</tr>
								<tr class="apt_layout">
									<th title="APT검사 파일 사이즈 제한">APT검사 파일사이즈 제한</th>
									<td id="apt_file_size_Out" class="t_center">
										<input type="radio" id="apt_file_size_filter_use_yn_Out_Y" name="apt_file_size_filter_use_yn_Out" value="Y" 
														${outerfPolFileInfo.apt_file_size_filter_use_yn == "Y"  ? ' checked' : ''}/>
										<label for="apt_file_size_filter_use_yn_Out_Y">사용</label>
										<img class="aptHelp" src="/Images/icon/icon_small_question.gif" />
										<input type="radio" id="apt_file_size_filter_use_yn_Out_N" name="apt_file_size_filter_use_yn_Out" value="N" 
														${outerfPolFileInfo.apt_file_size_filter_use_yn == "N" || outerfPolFileInfo.apt_file_size_filter_use_yn == null ? ' checked' : ''} />
										<label for="apt_file_size_filter_use_yn_Out_N">사용안함</label><br><br>
										<input type="text" class="text_input mid" id="apt_scan_max_file_size_Out" name=apt_scan_max_file_size_Out
											onkeyup="onlyNumBetweenFillter(this,${fn:length(f_pol_file_apt_scan_max_file_size_max)},${f_pol_file_apt_scan_max_file_size_min},${f_pol_file_apt_scan_max_file_size_max})" 
												value="${outerfPolFileInfo.apt_scan_max_file_size}" size="10" maxlength="10" /> Mbytes
									</td>
								</tr>
								<tr class="tx_download_layout">
									<th title="${tx_download}">${tx_download}</th>
									<td id="tx_download_Out" class="t_center">
										<input type="radio" id="tx_download_Out_Y" name="tx_download_yn_out" value="Y" ${outerfPolFileInfo.tx_download_yn == "Y" || outerfPolFileInfo.tx_download_yn == null ? ' checked' : ''} />
										<label for="tx_download_Out_Y" class="mg_r15">사용</label>
										<input type="radio" id="tx_download_Out_N" name="tx_download_yn_out" value="N" ${outerfPolFileInfo.tx_download_yn == "N" ? ' checked' : ''}/>
										<label for="tx_download_Out_N">사용안함</label>
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
