<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="csAgentUseYN" value="${customfunc:cacheString('csAgentUseYN')}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<html>
<head>
<link rel="stylesheet" type="text/css" href="/css/spectrum.min.css">
<script type="text/javascript" src="/JavaScript/spectrum.min.js"></script>
<script type="text/javascript">
var netArray = ["In","Out"];

	$(document).ready(function() {
		for(var i in netArray){
			$('#thema_' + netArray[i]).spectrum({
		        type: "component",
		        preferredFormat: "hex",
		        togglePaletteOnly: false,
		        showInput: false,
		        showInitial: false,
		        showButtons: true,
		  		showAlpha: false,
		  		allowEmpty: false
		    });
		}
		$(".sp-choose").addClass("theme");
		$(".sp-cancel").addClass("theme");

		setProxyDuplicateDisabled();
	});

	function setProxyDuplicateDisabled() {
		if($("input[id='proxy_period_use_yn_N']").filter("[value='N']").is(":checked")) {
			$(".proxy_du_filter").attr("disabled", true);
			$(".proxy_du_filter").css("cursor","no-drop");
		} else {
			$(".proxy_du_filter").attr("disabled", false);
			$(".proxy_du_filter").css("cursor","auto");
		}
		
		$("input[id='proxy_period_use_yn_N']").click(function() {
			$(".proxy_du_filter").attr("disabled", true);
			$(".proxy_du_filter").css("cursor","no-drop");
		}); 
		
		$("input[id='proxy_period_use_yn_Y']").click(function() {
			$(".proxy_du_filter").attr("disabled", false);
			$(".proxy_du_filter").css("cursor","auto");
		}); 
	}

	function save(){
		<c:if test="${csAgentUseYN eq 'Y' }">
			if (validCheckThema()) {
				return false; 
			}
		</c:if>
		var requestURL = "<c:url value="/systemManagement/commonManagement/update.lin" />";
		var successURL = "<c:url value="/systemManagement/commonManagement/commonCode.lin" />";
		
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			
			if (code == '200') {
				alert('설정이 저장되었습니다.');
			} else if (code = '500'){
				alert(message);
			} else {
				alert('설정 중 에러가 발생 되었습니다.');	
			}
		});
	}
	
	function validCheckThema(){
		var RegExp = /^\#(([0-9a-f]){3}|([0-9a-f]){4}|([0-9a-f]){6})$/i;
		for(var i in netArray){
			var messageTitle = (netArray[i] == "In") ? "${INNER}" : "${OUTER}";
			if( !RegExp.test($("#thema_" + netArray[i]).val()) ){
				alert("[" + messageTitle + "] <spring:message code="valid.message.model.commonCode.thema" />");
				return true;
			}
		}
		return false;
	}
</script>
<style type="text/css">
input[type='radio'],label{cursor: pointer;}
.sp-colorize-container{position: relative; left: 76px;}
#thema_Out , #thema_In{border-left: 1px solid #ddd !important; position: relative; right: 35px;}
</style>
</head>
<body>
	<form id="lform" name="lform" method="post" onsubmit="return false;">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">기능 설정</h2>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>공통 기능 설정</h3>
			<div class="conBox">
				<div class="table_area_style02">
					<table>
						<colgroup>
							<col style="width:35%;" />
							<col style="width:65%;" />
						</colgroup>
						<tr>
							<th class="Rborder t_left">암호화 파일 차단 사용 여부</th>
							<td>
								<input type="radio" id="not_normal_files_Y" name="not_normal" value="Y" ${fn:indexOf(commonCodeMap.not_normal, '10') > 0 ? ' checked' : ''}/>
								<label for="not_normal_files_Y" class="mg_r15">사용</label>
								<input type="radio" id="not_normal_files_N" name="not_normal" value="N" ${fn:indexOf(commonCodeMap.not_normal, '10') < 0 ? ' checked' : ''}/>
								<label for="not_normal_files_N">사용안함</label>
							</td>
						</tr>
						<tr>
							<th class="Rborder t_left">관리자 결재 미처리 이력 일괄 승인 사용 여부</th>
							<td>
								<input type="radio" id="unprocessed_approval_allow_Y" name="unprocessed_approval_allow_yn" value="Y" ${commonCodeMap.unprocessed_approval_allow_yn == "Y" ? ' checked' : ''}/>
								<label for="unprocessed_approval_allow_Y"  class="mg_r15">사용</label>
								<input type="radio" id="unprocessed_approval_allow_N" name="unprocessed_approval_allow_yn" value="N" ${commonCodeMap.unprocessed_approval_allow_yn == "N" ? ' checked' : ''}/>
								<label for="unprocessed_approval_allow_N">사용안함</label>
							</td>
						</tr>
						<tr>
							<th class="Rborder t_left">대리결재자 부서내 결재자들 지정 여부</th>
							<td>
								<input type="radio" id="proxy_dept_in_yn_Y" name="proxy_dept_in_yn" value="Y" ${commonCodeMap.proxy_dept_in_yn == "Y" ? ' checked' : ''}/>
								<label for="proxy_dept_in_yn_Y"  class="mg_r15">사용</label>
								<input type="radio" id="proxy_dept_in_yn_N" name="proxy_dept_in_yn" value="N" ${commonCodeMap.proxy_dept_in_yn == "N" ? ' checked' : ''}/>
								<label for="proxy_dept_in_yn_N">사용안함</label>
							</td>
						</tr>
						<tr>
							<th class="Rborder t_left">대리결재자 결재권자만 포함 여부</th>
							<td>
								<input type="radio" id="proxy_user_list_only_approver_Y" name="proxy_user_list_only_approver" value="Y" ${commonCodeMap.proxy_user_list_only_approver == "Y" ? ' checked' : ''}/>
								<label for="proxy_user_list_only_approver_Y"  class="mg_r15">사용</label>
								<input type="radio" id="proxy_user_list_only_approver_N" name="proxy_user_list_only_approver" value="N" ${commonCodeMap.proxy_user_list_only_approver == "N" ? ' checked' : ''}/>
								<label for="proxy_user_list_only_approver_N">사용안함</label>
							</td>
						</tr>
						<tr>
							<th class="Rborder t_left">대리결재 기간 사용 여부</th>
							<td>
								<input type="radio" id="proxy_period_use_yn_Y" name="proxy_period_use_yn" value="Y" ${commonCodeMap.proxy_period_use_yn == "Y" ? ' checked' : ''}/>
								<label for="proxy_period_use_yn_Y"  class="mg_r15">사용</label>
								<input type="radio" id="proxy_period_use_yn_N" name="proxy_period_use_yn" value="N" ${commonCodeMap.proxy_period_use_yn == "N" ? ' checked' : ''}/>
								<label for="proxy_period_use_yn_N">사용안함</label>
							</td>
						</tr>
						<tr>
							<th class="Rborder t_left">대리결재자 기간 중복 불가 설정 사용 여부</th>
							<td>
								<input type="radio" id="proxy_period_duplicate_yn_Y" name="proxy_period_duplicate_yn" class="proxy_du_filter" value="Y" ${commonCodeMap.proxy_period_duplicate_yn == "Y" ? ' checked' : ''}/>
								<label for="proxy_period_duplicate_yn_Y"  class="mg_r15">사용</label>
								<input type="radio" id="proxy_period_duplicate_yn_N" name="proxy_period_duplicate_yn" value="N" class="proxy_du_filter" ${commonCodeMap.proxy_period_duplicate_yn == "N" ? ' checked' : ''}/>
								<label for="proxy_period_duplicate_yn_N">사용안함</label>
							</td>
						</tr>
						<c:if test="${csAgentUseYN eq 'Y' }">
							<tr>
								<th class="Rborder t_left">CS 자동 로그인 사용 여부</th>
								<td>
									<input type="radio" id="agent_auto_login_use_Y" name="agent_auto_login_use_yn" value="Y" ${commonCodeMap.agent_auto_login_use_yn == "Y" ? ' checked' : ''}/>
									<label for="agent_auto_login_use_Y"  class="mg_r15">사용</label>
									<input type="radio" id="agent_auto_login_use_N" name="agent_auto_login_use_yn" value="N" ${commonCodeMap.agent_auto_login_use_yn == "N" ? ' checked' : ''}/>
									<label for="agent_auto_login_use_N">사용안함</label>
								</td>
							</tr>
							<tr>
								<th class="Rborder t_left">CS 일괄 다운로드 사용 여부</th>
								<td>
									<input type="radio" id="agent_batch_download_use_Y" name="batch_download_use_yn" value="Y" ${commonCodeMap.batch_download_use_yn == "Y" ? ' checked' : ''}/>
									<label for="agent_batch_download_use_Y"  class="mg_r15">사용</label>
									<input type="radio" id="agent_batch_download_use_N" name="batch_download_use_yn" value="N" ${commonCodeMap.batch_download_use_yn == "N" ? ' checked' : ''}/>
									<label for="agent_batch_download_use_N">사용안함</label>
								</td>
							</tr>
							<tr>
								<th class="Rborder t_left">CS ${INNER } 테마</th>
								<td>
									<input type="text" id="thema_In" class="text_input long" name="thema_i" maxlength="7" value="${commonCodeMap.thema_i}" />
								</td>
							</tr>
							<tr>
								<th class="Rborder t_left">CS ${OUTER } 테마</th>
								<td>
									<input type="text" id="thema_Out" class="text_input long" name="thema_o" maxlength="7" value="${commonCodeMap.thema_o}" />
								</td>
							</tr>
						</c:if>
					</table>
				</div>
			</div>
			<div class="t_center mg_t10 mg_b10">
				<button class="btn_common theme" onClick="save()">저장</button>
			</div>
		</div>
	</div>
	</form>
</body>
</html>