<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />
<c:set var="in_title_str" value="${customfunc:codeDes('NP_CD', 'I')} -> ${customfunc:codeDes('NP_CD', 'O')}" />
<c:set var="out_title_str" value="${customfunc:codeDes('NP_CD', 'O')} -> ${customfunc:codeDes('NP_CD', 'I')}" />
<script type="text/javascript">
	$(function() {
		clearCookieData();
		<c:if test="${auth_cd != 1 && modify_auth != 'Y'}">
		allInputDisable();
		</c:if>
		allOffInputKeyDown();
		<%-- 사후 결재 제한 영역 제어 --%>
		if( $(".after_app_type_In").filter("[value='N']").is(":checked") ){
			$("#after_app_lock_priod_div_In").css({"color":"#dcdcdc","cursor":"no-drop"});
			$("#after_app_lock_period_In").attr("disabled",true).css({"cursor":"no-drop","color":"#dcdcdc"});
			$("#lock_period_explanation_In").css("color", "#dcdcdc");
		}
		
		if( $(".after_app_type_Out").filter("[value='N']").is(":checked") ){
			$("#after_app_lock_priod_div_Out").css({"color":"#dcdcdc","cursor":"no-drop"});
			$("#after_app_lock_period_Out").attr("disabled",true).css({"cursor":"no-drop","color":"#dcdcdc"});
			$("#lock_period_explanation_Out").css("color", "#dcdcdc");
		}
		
		$(".after_app_type_In").click(function() {
			if( $(this).val() == 'N' ) {
				$("#after_app_lock_period_In").val(0);
				$("#after_app_lock_priod_div_In").css({"color":"#dcdcdc","cursor":"no-drop"});
				$("#after_app_lock_period_In").attr("disabled",true).css({"cursor":"no-drop","color":"#dcdcdc"});
				$("#lock_period_explanation_In").css("color", "#dcdcdc");
			} else {
				$("#after_app_lock_priod_div_In").css({"color":"#363636","cursor":"auto"});
				$("#after_app_lock_period_In").attr("disabled",false).css({"cursor":"auto","color":"#363636"});
				$("#lock_period_explanation_In").css("color", "red");
			}
		});
		
		$(".after_app_type_Out").click(function() {
			if( $(this).val() == 'N' ) {
				$("#after_app_lock_period_Out").val(0);
				$("#after_app_lock_priod_div_Out").css({"color":"#dcdcdc","cursor":"no-drop"});
				$("#after_app_lock_period_Out").attr("disabled",true).css({"cursor":"no-drop","color":"#dcdcdc"});
				$("#lock_period_explanation_Out").css("color", "#dcdcdc");
			} else {
				$("#after_app_lock_priod_div_Out").css({"color":"#363636","cursor":"auto"});
				$("#after_app_lock_period_Out").attr("disabled",false).css({"cursor":"auto","color":"#363636"});
				$("#lock_period_explanation_Out").css("color", "red");
			}
		});
		<%-- 사후 결재 제한 영역 제어 --%>
		
		<%-- 동일 적용 영역 제어 --%>
		if( $("#same_apply").is(":checked") ){
			$(".same_apply").attr("disabled", true);
			$("#after_app_lock_priod_div_Out").css("color", "#dcdcdc");
			$("#lock_period_explanation_Out").css("color", "#dcdcdc");
		}
		
		$("#same_apply").click(function(){
			if( $(this).is(":checked")) {
				$(".same_apply").attr("disabled", true);
				$("#after_app_lock_priod_div_Out").css("color", "#dcdcdc");
				$("#lock_period_explanation_Out").css("color", "#dcdcdc");
			} else {
				$(".same_apply").attr("disabled", false);
				$("#after_app_lock_priod_div_Out").css("color", "#363636");
				if( ! $(".after_app_type_Out").filter("[value='N']").is(":checked") ){
					$("#lock_period_explanation_Out").css("color", "red");
				}
			}
		});
		<%-- 동일 적용 영역 제어 --%>
		
		checkFocusMessage($("#after_app_lock_period"), '<spring:message code="approval.approvalPolicyView.afterRestriction.limit.period" arguments="100"/>');
		checkFocusMessage($("#app_nm2"), "1 ~ 50자리까지 입력이 가능합니다.");
		checkFocusMessage($("#note2"),"최대 100자까지 입력이 가능합니다.");
	});
	
	function storeAppLineData() {
		$("#appLineList_In").val($.cookie("appLineList_I"));
		$("#appLineUserList_In").val($.cookie("appLineUserList_I"));
		$("#appLineList_Out").val($.cookie("appLineList_O"));
		$("#appLineUserList_Out").val($.cookie("appLineUserList_O"));
	}
	
	function clearCookieData() {
		$.cookie("appLineList_I", null);
		$.cookie("appLineUserList_I", null);
		$.cookie("appLineList_O", null);
		$.cookie("appLineUserList_O", null);
	}

	function cancel() {
		location.href = "<c:url value="/policy/approvalPolicy/approvalPolicyList.lin" />";
	}

	function save() {
		var errmsg = new cls_errmsg();
		titleFilter('app_nm2', 'note2');
		
		if( ! validateBeforeSave() ) return;
	
		storeAppLineData();

		var requestURL = '<c:url value="/policy/approvalPolicy/updateApprovalPolicy.lin" />';
		var successURL = '<c:url value="/policy/approvalPolicy/approvalPolicyList.lin" />';
		
		$(".app_seq").val($("#app_seq2").val());
		$(".app_nm").val($("#app_nm2").val());
		$(".note").val($("#note2").val());
		//라디오버튼 desabled 풀기
		/* var radio_leng = $(":input:radio[name=app_direction]").length;
		for(var i=0 ; i< radio_leng; i++){
			$('input:radio[name=app_direction]').eq(i).attr("disabled", false);
		} */
		$(":button").attr("disabled", true);
		if( $("#same_apply").is(":checked") ){
			$("#same_apply_In").val("Y");
		}
		resultCheckFunc($("#lform_In"), requestURL, function(response) {
			var code = response['code'];
			
			if (code == '200'){
				
				var requestURL = '<c:url value="/policy/approvalPolicy/insertApprovalPolicy.lin" />';
				
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
	
	function validateBeforeSave() {
		var errmsg = new cls_errmsg();
		
		/* 	
		var app_level = $("#app_level").val();
		var self_app_yn = $(":input:radio[name=self_app_yn]:checked").val();
		if(app_level > 1){
			if(self_app_yn == 'Y'){
				errmsg.append(null, "2차 결재 이상일 경우 자가결재을 사용하지 못합니다.");
			}
		} */

		var appNm = $("#app_nm2").val();
		if( appNm == null || appNm == "" ) errmsg.append(null, "정책명을 입력해주세요.");
		
		if (errmsg.haserror) {
			errmsg.show();
			return false;
		}
		
		return true;
	}
	
	function clickApprovalLineButton(position) {
		var level = document.getElementById("app_level_" + position).value;
		var app_seq = document.getElementById("app_seq2").value;
		
		var np_cd = position.substring(0,1);
		var url = "/policy/approvalPolicy/approvalLinePopup.lin?appLineLevel=" + level + "&appSeq=" + app_seq + "&np_cd=" + np_cd;
		var attr = "resizable=no,scrollbars=no,toolbar=no,url=no,width=625,height=690,top=5,left=5,url=no";
		var popupWindow = window.open(url, "approvalLinePopup", attr);
		popupWindow.focus();
	}
	
</script>
</head>
<body>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">결재정책 관리</h2>
				<p class="breadCrumbs">정책관리 > 결재정책 관리</p>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>상세정보</h3>
			<div class="conBox">
				<div class="topCon">
					<table summary="결재정책" style="table-layout : fixed" >
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
								<td><input type="text" class="text_input" id="app_seq2" name="app_seq2" value="${approvalPolicyForm.app_seq}" readonly="readonly" /></td>
								<th class="t_center">정책명</th>
								<td><input type="text" class="text_input" id="app_nm2" name="app_nm2" onkeyup="onlySizeFillter(this,50)" size="50" value="${approvalPolicyForm.app_nm}" /></td>
								<th class="t_center">설명</th>
								<td><input type="text" class="text_input" id="note2" name="note2" onkeyup="onlySizeFillter(this,100)" size="100" value="${approvalPolicyForm.note}" /></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="tableArea" style="overflow:hidden;">
					<form id="lform_In" name="lform_In" onsubmit="return false;">
						<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
						<input type="hidden" id="cud_cd" name="cud_cd" value="${cud_cd}">
						<input type="hidden" class="app_seq" name="app_seq" value="">
						<input type="hidden" class="app_nm" name="app_nm" value="">
						<input type="hidden" class="note" name="note" value="">
						<input type="hidden" id="isdel_yn" name="isdel_yn" value="${approvalPolicyForm.isdel_yn}">
						<input type="hidden" id="together_app_yn" name="together_app_yn" value="N">
						<input type="hidden" id="same_apply_In" name="same_apply" value="N">
					<div class="left_tableBox">
						<div class="table_area_style02 Tborder">
							<div class="table_area_topCon title h_title">${in_title_str}
								<input type="checkbox" id="same_apply" ${innerfPolApprMgt.same_apply == "Y" ? ' checked' : ''} style="margin-left:30px;height:15px !important;"/>
								<label for="same_apply" class="mg_r15" style="font-size:0.8em !important;">동일 적용</label>
							</div>
							<table summary="결재정책 설정" style="table-layout : fixed">
							<caption>로그인정책 설정</caption>
							<colgroup>
								<col style="width:15%;"/>
								<col style="width:85%;"/>
							</colgroup>
							<tbody>
								<tr>
									<th class="t_left">결재 차수</th>
									<td>
										<select id="app_level_In" name="app_level" title="결재차수 불러오기">
											<option value="1" ${innerfPolApprMgt.app_level == 1 ? ' selected' : ''}>1차 결재</option>
											<option value="2" ${innerfPolApprMgt.app_level == 2 ? ' selected' : ''}>2차 결재</option>
											<option value="3" ${innerfPolApprMgt.app_level == 3 ? ' selected' : ''}>3차 결재</option>
											<option value="4" ${innerfPolApprMgt.app_level == 4 ? ' selected' : ''}>4차 결재</option>
											<option value="5" ${innerfPolApprMgt.app_level == 5 ? ' selected' : ''}>5차 결재</option>
											<option value="6" ${innerfPolApprMgt.app_level == 6 ? ' selected' : ''}>6차 결재</option>
										</select>
										<c:if test="${auth_cd == 1 || modify_auth == 'Y'}">
											<button type="button" class="btn_small" name="app_line_button_In" id="app_line_button_In" onclick="clickApprovalLineButton('In')" >결재선관리</button>
										</c:if>
									</td>
								</tr>
								<tr>
									<th class="t_left">자가결재</th>
									<td>
										<input type="radio" id="self_app_Y_In" name="self_app_yn" value="Y" ${innerfPolApprMgt.self_app_yn == "Y" ? ' checked' : ''} /><label for="self_app_Y_In"><spring:message code="base.code.common.use.Y"/><%-- 사용 --%></label>&nbsp;
										<input type="radio" id="self_app_N_In" name="self_app_yn" value="N" ${innerfPolApprMgt.self_app_yn == "N" ? ' checked' : ''} /><label for="self_app_N_In"><spring:message code="base.code.common.use.N"/><%-- 미사용 --%></label>
									</td>
								</tr>
								<tr>
									<th class="t_left">사후결재</th>
									<td>
										<p class="mg_b10">
											<input type="radio" id="after_app_D_In" class="after_app_type_In" name="after_app_type" value="D" ${innerfPolApprMgt.after_app_type == "D" ? ' checked' : ''} /><label for="after_app_D_In"><spring:message code="approval.approvalPolicyView.afterAppType.D"/><%-- 매일 --%></label>&nbsp;
											<input type="radio" id="after_app_H_In" class="after_app_type_In" name="after_app_type" value="H" ${innerfPolApprMgt.after_app_type == "H" ? ' checked' : ''} /><label for="after_app_H_In"><spring:message code="approval.approvalPolicyView.afterAppType.H"/><%-- 공휴일 --%></label>&nbsp;
											<input type="radio" id="after_app_N_In" class="after_app_type_In" name="after_app_type" value="N" ${innerfPolApprMgt.after_app_type == "N" ? ' checked' : ''} /><label for="after_app_N_In"><spring:message code="approval.approvalPolicyView.afterAppType.N"/><%-- 미사용 --%></label>
										</p>
										<div id="after_app_lock_priod_div_In">
											<p>
												<spring:message code="approval.approvalPolicyView.afterRestriction.period"/>
												<input type="text" class="text_input short t_center" name="after_app_lock_period" id="after_app_lock_period_In" onkeyup="onlyNumBetweenFillter(this,3,0,100)" style="width:50px;" value="${ innerfPolApprMgt.after_app_lock_period != null ? innerfPolApprMgt.after_app_lock_period : 0 }"/> 일
											</p>
											<p class="helpBox mg_t5" id="lock_period_explanation_In"><spring:message code="approval.approvalPolicyView.afterRestriction.notice.active"/></p>
										</div>
									</td>
								</tr>
								<%-- <tr>
									<th class="t_left">동시 결제</th>
									<td>
										<input type="radio" id="together_app_Y" name="together_app_yn" value="Y" ${approvalPolicyForm.together_app_yn == "Y" ? ' checked' : ''} /><label for="together_app_Y">사용</label>&nbsp;
										<input type="radio" id="together_app_N" name="together_app_yn" value="N" ${approvalPolicyForm.together_app_yn == "N" ? ' checked' : ''} /><label for=together_app_N">미사용</label>
									</td>
								</tr> --%>
								<tr>
									<th class="t_left">대리결재</th>
									<td>
										<input type="radio" id="proxy_app_Y_In" name="proxy_app_yn" value="Y" ${innerfPolApprMgt.proxy_app_yn == "Y" ? ' checked' : ''} /><label for="proxy_app_Y_In"><spring:message code="base.code.common.use.Y"/><%-- 사용 --%></label>&nbsp;
										<input type="radio" id="proxy_app_N_In" name="proxy_app_yn" value="N" ${innerfPolApprMgt.proxy_app_yn == "N" ? ' checked' : ''} /><label for="proxy_app_N_In"><spring:message code="base.code.common.use.N"/><%-- 미사용 --%></label>
									</td>
								</tr>
								<tr class="none">
									<th class="t_left">부재중결재</th>
									<td>
										<input type="radio" id="absence_app_Y_In" name="absence_app_yn" value="Y" ${innerfPolApprMgt.absence_app_yn == "Y" ? ' checked' : ''} /><label for="absence_app_Y_In"><spring:message code="base.code.common.use.Y"/><%-- 사용 --%></label>&nbsp;
										<input type="radio" id="absence_app_N_In" name="absence_app_yn" value="N" ${innerfPolApprMgt.absence_app_yn == "N" ? ' checked' : ''} /><label for="absence_app_N_In"><spring:message code="base.code.common.use.N"/><%-- 미사용 --%></label>
									</td>
								</tr>
								<tr>
									<th class="t_left">결재 사용 여부</th>
									<td>
										<input type="radio" id="use_yn_Y_In" name="use_yn" value="Y" ${innerfPolApprMgt.use_yn == "Y" ? ' checked' : ''} /><label for="use_yn_Y_In">사용</label>&nbsp;
										<input type="radio" id="use_yn_N_In" name="use_yn" value="N" ${innerfPolApprMgt.use_yn == "N" ? ' checked' : ''} /><label for="use_yn_N_In">사용 안함</label>
									</td>
								</tr>
							</tbody>
							</table>
						</div>
					</div>
					</form>
					<form name="lform_Out" id="lform_Out" onSubmit="return false;">
						<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
						<input type="hidden" class="app_seq" name="app_seq" value="">
						<input type="hidden" class="app_nm" name="app_nm" value="">
						<input type="hidden" class="note" name="note" value="">
						<input type="hidden" id="cud_cd" name="cud_cd" value="${cud_cd}">
						<input type="hidden" id="isdel_yn" name="isdel_yn" value="${approvalPolicyForm.isdel_yn}">
						<input type="hidden" id="together_app_yn" name="together_app_yn" value="N">
						<input type="hidden" name="same_apply" value="N">
						<%-- 결재선관리 데이터 저장을 위한 input --%>
						<input type="hidden" id="appLineList_Out" name="appLineList_Out" value="$.cookie('appLineList_O');" />
						<input type="hidden" id="appLineUserList_Out" name="appLineUserList_Out" value="$.cookie('appLineUserList_O');" />
						<input type="hidden" id="appLineList_In" name="appLineList_In" value="$.cookie('appLineList_I');" />
						<input type="hidden" id="appLineUserList_In" name="appLineUserList_In" value="$.cookie('appLineUserList_I');" />
						<%-- 결재선관리 데이터 저장을 위한 input --%>
					<div class="right_tableBox">
						<div class="table_area_style02 Tborder">
							<div class="table_area_topCon title h_title">${out_title_str}
								<input type="checkbox" id="same_apply" ${innerfPolApprMgt.same_apply == "Y" ? ' checked' : ''} style="margin-left:30px;height:15px !important; display: none;"/>
								<label for="same_apply" class="mg_r15" style="font-size:0.8em !important; display: none;">동일 적용</label>
							</div>
							<table summary="결재정책 설정" style="table-layout : fixed">
							<caption>로그인정책 설정</caption>
							<colgroup>
								<col style="width:15%;"/>
								<col style="width:85%;"/>
							</colgroup>
							<tbody>
								<tr>
									<th class="t_left">결재 차수</th>
									<td>
										<select class="same_apply" id="app_level_Out" name="app_level" title="결재차수 불러오기">
											<option value="1" ${outerfPolApprMgt.app_level == 1 ? ' selected' : ''}>1차 결재</option>
											<option value="2" ${outerfPolApprMgt.app_level == 2 ? ' selected' : ''}>2차 결재</option>
											<option value="3" ${outerfPolApprMgt.app_level == 3 ? ' selected' : ''}>3차 결재</option>
											<option value="4" ${outerfPolApprMgt.app_level == 4 ? ' selected' : ''}>4차 결재</option>
											<option value="5" ${outerfPolApprMgt.app_level == 5 ? ' selected' : ''}>5차 결재</option>
											<option value="6" ${outerfPolApprMgt.app_level == 6 ? ' selected' : ''}>6차 결재</option>
										</select>
										<c:if test="${auth_cd == 1 || modify_auth == 'Y'}">
											<button type="button" class="btn_small same_apply" name="app_line_button" id="app_line_button" onclick="clickApprovalLineButton('Out')" >결재선관리</button>
										</c:if>
									</td>
								</tr>
								<tr>
									<th class="t_left">자가결재</th>
									<td>
										<input type="radio" id="self_app_Y_Out" class="same_apply" name="self_app_yn" value="Y" ${outerfPolApprMgt.self_app_yn == "Y" ? ' checked' : ''} /><label for="self_app_Y_Out"><spring:message code="base.code.common.use.Y"/><%-- 사용 --%></label>&nbsp;
										<input type="radio" id="self_app_N_Out" class="same_apply" name="self_app_yn" value="N" ${outerfPolApprMgt.self_app_yn == "N" ? ' checked' : ''} /><label for="self_app_N_Out"><spring:message code="base.code.common.use.N"/><%-- 미사용 --%></label>
									</td>
								</tr>
								<tr>
									<th class="t_left">사후결재</th>
									<td>
										<p class="mg_b10">
											<input type="radio" id="after_app_D_Out" class="after_app_type_Out same_apply" name="after_app_type" value="D" ${outerfPolApprMgt.after_app_type == "D" ? ' checked' : ''} /><label for="after_app_D_Out"><spring:message code="approval.approvalPolicyView.afterAppType.D"/><%-- 매일 --%></label>&nbsp;
											<input type="radio" id="after_app_H_Out" class="after_app_type_Out same_apply" name="after_app_type" value="H" ${outerfPolApprMgt.after_app_type == "H" ? ' checked' : ''} /><label for="after_app_H_Out"><spring:message code="approval.approvalPolicyView.afterAppType.H"/><%-- 공휴일 --%></label>&nbsp;
											<input type="radio" id="after_app_N_Out" class="after_app_type_Out same_apply" name="after_app_type" value="N" ${outerfPolApprMgt.after_app_type == "N" ? ' checked' : ''} /><label for="after_app_N_Out"><spring:message code="approval.approvalPolicyView.afterAppType.N"/><%-- 미사용 --%></label>
										</p>
										<div id="after_app_lock_priod_div_Out">
											<p>
												<spring:message code="approval.approvalPolicyView.afterRestriction.period"/>
												<input type="text" class="text_input short t_center" name="after_app_lock_period" id="after_app_lock_period_Out" onkeyup="onlyNumBetweenFillter(this,3,0,100)" style="width:50px;" value="${ outerfPolApprMgt.after_app_lock_period != null ? outerfPolApprMgt.after_app_lock_period : 0 }"/> 일
											</p>
											<p class="helpBox mg_t5" id="lock_period_explanation_Out"><spring:message code="approval.approvalPolicyView.afterRestriction.notice.active"/></p>
										</div>
									</td>
								</tr>
								<tr>
									<th class="t_left">대리결재</th>
									<td>
										<input type="radio" id="proxy_app_Y_Out" class="same_apply" name="proxy_app_yn" value="Y" ${outerfPolApprMgt.proxy_app_yn == "Y" ? ' checked' : ''} /><label for="proxy_app_Y_Out"><spring:message code="base.code.common.use.Y"/><%-- 사용 --%></label>&nbsp;
										<input type="radio" id="proxy_app_N_Out" class="same_apply" name="proxy_app_yn" value="N" ${outerfPolApprMgt.proxy_app_yn == "N" ? ' checked' : ''} /><label for="proxy_app_N_Out"><spring:message code="base.code.common.use.N"/><%-- 미사용 --%></label>
									</td>
								</tr>
								<tr class="none">
									<th class="t_left">부재중결재</th>
									<td>
										<input type="radio" id="absence_app_Y_Out" name="absence_app_yn" value="Y" ${outerfPolApprMgt.absence_app_yn == "Y" ? ' checked' : ''} /><label for="absence_app_Y_Out"><spring:message code="base.code.common.use.Y"/><%-- 사용 --%></label>&nbsp;
										<input type="radio" id="absence_app_N_Out" name="absence_app_yn" value="N" ${outerfPolApprMgt.absence_app_yn == "N" ? ' checked' : ''} /><label for="absence_app_N_Out"><spring:message code="base.code.common.use.N"/><%-- 미사용 --%></label>
									</td>
								</tr>
								<tr>
									<th class="t_left">결재 사용 여부</th>
									<td>
										<input type="radio" id="use_yn_Y_Out" class="same_apply" name="use_yn" value="Y" ${outerfPolApprMgt.use_yn == "Y" ? ' checked' : ''} /><label for="use_yn_Y_Out">사용</label>&nbsp;
										<input type="radio" id="use_yn_N_Out" class="same_apply" name="use_yn" value="N" ${outerfPolApprMgt.use_yn == "N" ? ' checked' : ''} /><label for="use_yn_N_Out">사용 안함</label>
									</td>
								</tr>
							</tbody>
							</table>
						</div>
					</div>
					</form>
				</div>
				<div class="t_center mg_t30 mg_b30">
				<c:if test="${auth_cd == 1 || modify_auth == 'Y'}">
						<button class="btn_common theme" onclick="save()">저장</button>
				</c:if>
						<button class="btn_common theme" onclick="cancel()">취소</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
