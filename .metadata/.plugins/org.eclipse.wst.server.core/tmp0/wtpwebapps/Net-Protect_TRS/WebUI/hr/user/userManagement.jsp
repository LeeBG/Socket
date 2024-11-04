<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<html>
<head>

<c:set var="CUD_CD_U"
	value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.admin.edit.js"/>"></script>

<script type="text/javascript">
	
	function activeUser(event, data) {
		var node = data.node;
		if (!node.isFolder()) {
			$(".right input[type=text]").val("");
			$("#dept_seq").val( node.data.dept_seq );
			$("#users_id").val( node.data.users_id );
			$("#users_id_span").text( node.data.users_id );
			$("#users_nm").val( node.data.users_nm );
			$("#users_dept_nm_div").text( node.data.users_dept_nm );
			$("#dept_nm").val( node.data.users_dept_nm );
			setUserInfo();
		}
	}
					
	function initialize() {
		if (empty($("#users_id").val())) {
			alert("사용자 선택이 되지 않았습니다.");
			return;
		}

		setUserInfo();
	}

	function insert() {
		var form = document.lform;

		var node = $("#depttree").fancytree("getActiveNode");
		if (node == null) {
			alert("부서를 선택해 주세요");
			return;
		}
		var dept_nm = node.data.dept_nm;
		if (dept_nm == null) {
			alert("부서를 선택해 주세요 ");
			return;
		}
		var dept_seq = node.data.dept_seq;
		$('#dept_seq').val(dept_seq);
		$('#dept_nm').val(dept_nm);
		form.action = "<c:url value="/hr/user/insertUser.lin" />";
		form.submit();
	}

	function userdel() {
		//var form = document.lform;

		if (empty($("#users_id").val())) {
			alert("사용자 선택이 되지 않았습니다.");
			return;
		}

		if(confirm("사용자를 삭제 하시겠습니까? 모든이력이 삭제됩니다." ) ){
			var requestURL = "<c:url value="/hr/user/deleteUser.lin" />";
			var successURL = "<c:url value="/hr/user/userManagement.lin" />";

			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				var message = response['message'];
				if (code == '200') {
					alert('사용자가 삭제 되었습니다.');
					$(location).attr("href", successURL);
				} else {
					alert(message);
				}
			});
		}
	}
	

	function setUserInfo() {

		checkFieldActivate(false);
		var requestURL = "<c:url value="/hr/user/treeUserInfo.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {

			var users = response['users'];
			var custom_column = response['custom_column'];
			var default_info = response['default_info'];
			var exist_rv_yn = response['exist_rv_yn'];
			
			var custom_add_yn = users.custom_add_yn;
			
			initAdminEditButtonStatus( custom_column );
			customEdit.setAdminEditOriginData( default_info );
			customEdit.showCustomNotice( custom_add_yn );
			
			showChaingDeptBnt(custom_add_yn);
			displayPwdBnt(response['chg_pwd_use']);
			
			$("#exist_rv_yn").val(exist_rv_yn);
			
			$("#dept_seq").changeReadonlyState(custom_add_yn);
			$("#users_nm").changeReadonlyState(custom_add_yn);
			
			$("#position_nm").val(users.position_nm).changeReadonlyState(custom_add_yn);
			$("#job_nm").val(users.job_nm).changeReadonlyState(custom_add_yn);
			$("#auth_cd").val(users.auth_cd).changeReadonlyState(custom_add_yn);
			$("#l_pol_seq").val(users.l_pol_seq);
			$("#f_pol_seq").val(users.f_pol_seq);
			$("#a_pol_seq").val(users.a_pol_seq);
			$("#fp_pol_seq").val(users.fp_pol_seq);
			$("#inner_ip").val(users.inner_ip);
			$("#outer_ip").val(users.outer_ip);
			$("#custom_add_yn").val(custom_add_yn);
			//$("#inner_mac").val(users.inner_mac);
			//$("#outer_mac").val(users.outer_mac);
			$("#hp").val(users.hp).changeReadonlyState(custom_add_yn);
			$("#email").val(users.email).changeReadonlyState(custom_add_yn);
			$("#note").val(users.note);

			$(":radio[name=use_yn]input[value=" + users.use_yn + "]").attr("checked", true);
			$(":radio[name=self_approval_yn]#self_approval"
							+ users.self_approval_yn).attr("checked", true);

		});
		
		function displayPwdBnt(chg_pwd_use) {
			$("#pwdInitBnt").changeReadonlyState( ( chg_pwd_use == false ) ? "N" : "Y");
			$("#pwdInitBnt").prop("disabled", (chg_pwd_use == false) );
		}
		
		function showChaingDeptBnt( custom_add_yn ) {
			var findDeptBnt = $("button[id='btnFindDept']");
			if ( custom_add_yn == 'Y' ) findDeptBnt.eq(0).show();
			else findDeptBnt.eq(0).hide();
		}
	}
	
	function initAdminEditButtonStatus(custom_column) {
		customEdit.initAdminEditButton('use_yn', 'N');
		customEdit.initAdminEditButton('a_pol_seq', 'N');
		customEdit.initAdminEditButton('f_pol_seq', 'N');
		customEdit.initAdminEditButton('fp_pol_seq', 'N');
		customEdit.initAdminEditButton('l_pol_seq', 'N');
		
		if(custom_column != null && custom_column != 'undefined' && custom_column != "") {
			for( var i=0; i<custom_column.length; i++ ) {
				customEdit.initAdminEditButton(custom_column[i], 'Y');
			}
		}
	}

	function save() {

		if (empty($("#users_id").val())) {
			alert("사용자 선택이 되지 않았습니다.");
			return;
		}

		if (isVaildCheckUserManagement()) {
			return;
		}

		if (confirm("사용자 정보를 수정 하겠습니까?")) {

			var requestURL = "<c:url value="/hr/user/updateUser.lin" />";
			var successURL = "<c:url value="/hr/user/userManagement.lin" />";

			customEdit.setUnlockAdminEditColumn();
			
			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				var message = response['message'];
				if (code == '200') {
					alert('사용자가 수정 되었습니다.');
					//$(location).attr("href", successURL);
				} else {
					alert(message);
				}
			});
		}
	}

	function init() {
		if (empty($("#users_id").val())) {
			alert("사용자 선택이 되지 않았습니다.");
			return;
		}

		if (confirm("패스워드를 초기화 하겠습니까?")) {
			var requestURL = "<c:url value="/hr/user/initPassword.lin" />";
			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				var message = response['message'];
				if (code == '200') {
					alert(message);
				} else {
					alert(message);
				}
			});
		} else {
			return;
		}
	}

	function isVaildCheckUserManagement() {
		var isUserAllowedIpLogin = '${userAllowedIpLoginYn}' == 'Y';
		if (empty($("#users_id").val())) {
			alert("${customfunc:getMessage('common.id.commonid')}가 올바르지 않습니다.");
			return true;
		}
		if (empty($("#users_nm").val())) {
			alert("성명이 올바르지 않습니다.");
			return true;
		}
		
		if (empty($("#l_pol_seq option:selected").val())) {
			alert("로그인 정책이 올바르지 않습니다.");
			return true;
		}
		if (empty($("#f_pol_seq option:selected").val())) {
			alert("파일전송 정책이 올바르지 않습니다.");
			return true;
		}
		
		if( isUserAllowedIpLogin ) {
			<%-- IP 마지막에 ','가 있을 경우 replace --%>
			$("#inner_ip").val($("#inner_ip").val().replace(/,\s*$/, ''));
			$("#outer_ip").val($("#outer_ip").val().replace(/,\s*$/, ''));
		}else {
			<%-- IP 하나만 설정 가능 --%>
			$("#inner_ip").val($("#inner_ip").val().split(',')[0]);
			$("#outer_ip").val($("#outer_ip").val().split(',')[0]);
		}

		<%-- ip 형식 검증 --%>		
		if( $("#inner_ip").val().length != 0 && ! checkValidIp($("#inner_ip").val(), isUserAllowedIpLogin) ) return true;
		else if( $("#outer_ip").val().length != 0 && ! checkValidIp($("#outer_ip").val(), isUserAllowedIpLogin) ) return true;
		
		return false;
	}

	function popDept() {
		var url = "<c:url value="/hr/dept/findDeptPop.lin" />";
		var attibute = "resizable=no,scrollbars=no,width=475,height=690,top=5,left=5,toolbar=no,resizable=no";
		var popupWindow = window.open(url, "addressBookPopup", attibute);
		popupWindow.focus();
	}

	function setChildValue(seq, nm) {
		$('#dept_seq').val(seq);
		$('#dept_nm').val(nm);
		$("#users_dept_nm_div").text( nm );
	}
	
	$(document).ready(function() {
		
		addEvent();
		
		checkFieldActivate(true);

		init();
		
		function addEvent() {
			checkFocusMessage($("#users_nm"), "최대 10자까지 가능합니다.");
			checkFocusMessage($("#position_nm"), "최대 15자까지 가능합니다.");
			checkFocusMessage($("#job_nm"), "최대 15자까지 가능합니다.");
			if( "${userAllowedIpLoginYn}" == 'Y' ) {
				checkFocusMessage($("#inner_ip"), "영역IP는 ','로 구분 하여 최대 200자까지 설정 가능합니다.");
				checkFocusMessage($("#outer_ip"), "영역IP는 ','로 구분 하여 최대 200자까지 설정 가능합니다.");
			} else {
				checkFocusMessage($("#inner_ip"), "최대 15자까지 가능합니다.");
				checkFocusMessage($("#outer_ip"), "최대 15자까지 가능합니다.");
			}
			//checkFocusMessage($("#inner_mac"),"최대 17자까지 가능합니다.(xx:xx:xx:xx:xx:xx)");
			//checkFocusMessage($("#outer_mac"),"최대 17자까지 가능합니다.(xx:xx:xx:xx:xx:xx)");
			checkFocusMessage($("#hp"), "최대 15자까지 가능합니다.");
			checkFocusMessage($("#email"), "최대 45자까지 가능합니다.");
			checkFocusMessage($("#note"), "최대 200자까지 가능합니다.");
			checkFocusMessage($("#search"), "최대 15자까지 가능합니다.");
			
			addCheckRepositoryVolumnFPolSeq();
		}
		
		function addCheckRepositoryVolumnFPolSeq() {
			<%-- 용량증설 적용 사용자 체크를 위한 이벤트 --%>
			var prev_var;
			$("#f_pol_seq").focus(function() {
			    prev_val = $(this).val();
			}).change(function() {
				if (checkUseVolumeRepositoryPolicy()) {
					$(this).val(prev_val);
					return false;
				}
			});
		}
		
		function init() {
			$("button[id='btnFindDept']").eq(0).hide();
		}
	});
	
	function checkFieldActivate(isDisabled) {
		$("input[name=users_id]").attr("disabled", isDisabled);
		$("input[name=users_nm]").attr("disabled", isDisabled);
		$("input[name=position_nm]").attr("disabled", isDisabled);
		$("input[name=job_nm]").attr("disabled", isDisabled);
		$("input[name=inner_ip]").attr("disabled", isDisabled);
		$("input[name=outer_ip]").attr("disabled", isDisabled);
		$("input[name=hp]").attr("disabled", isDisabled);
		$("input[name=email]").attr("disabled", isDisabled);
		$("input[name=note]").attr("disabled", isDisabled);
		//$("input[name=search]").attr("disabled",isDisabled);
	}

	function changeFilePolicy(obj) {
		if (!checkUseVolumeRepositoryPolicy())
			customEdit.toggleAdminEdit(obj, 'tg');
	}

	function checkUseVolumeRepositoryPolicy(users_id) {
		if ($("#exist_rv_yn").val() == 'Y') {
			alert("용량증설 적용 중인 사용자의 파일전송정책은 수동으로 변경할 수 없습니다. [ 정책관리 > 개별 자료함 용량 관리 ] 에서 사용자를 확인해주시기 바랍니다.");
			return true;
		}

		return false;
	}

	function checkValidIp(ip, isMultiIp) {
		if( isMultiIp ) {
			ip = ip.split(",");
			for (var i=0; i < ip.length; i++) {
				if( ! isValidIP2(ip[i]) ) {
					alert("영역 IP 형식이 올바르지 않습니다.");
					return false;
				}
			}
		} else {
			if( ! isValidIP2(ip) ) {
				alert("영역 IP 형식이 올바르지 않습니다.");
				return false;
			}
		}
		return true;
	}
</script>
<style type="text/css">
.readonly{
background:#ebebe4 !important;
cursor:not-allowed !important;
}
.lock_icon {
    vertical-align: middle;
    margin-bottom: 3px;
    width: 20px;
    height: 20px;
    background-image: url('/Images/icon/icon_lock.png');
    background-color:#ffffff;
    border: none;
    cursor : pointer;
}
.unlock_icon {
    vertical-align: middle;
    margin-bottom: 3px;
    width: 20px;
    height: 20px;
    background-image: url('/Images/icon/icon_unlock.png');
    background-color:#ffffff;
    border: none;
    cursor : pointer;
}
</style>
</head>
<body>
	<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/user/userManagement.lin" />">
		<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
		<input type="hidden" id="dept_nm" name="dept_nm" /> 
		<input type="hidden" id="dept_seq" name="dept_seq" />
		<input type="hidden" id="auth_cd" name="auth_cd" />
		<input type="hidden" id="custom_add_yn" name="custom_add_yn" />
		<input type="hidden" id="cud_cd" name="cud_cd" value="${CUD_CD_U}" />
		<input type="hidden" id="adminEditColumns" name="adminEditColumns" value=""/>
		<div class="rightArea">
			<div class="topWarp">
				<div class="titleBox">
					<h2 class="f_left text_bold">사용자 관리</h2>
					<p class="breadCrumbs">인사관리 > 사용자 관리</p>
				</div>
			</div>
			<div class="conWrap trisectionWrap">
			
				<!-- 사용자 트리 include start -->
				<jsp:include page="/WebUI/hr/user/include/userTreeList.jsp" flush="false">
					<jsp:param value="N" name="onlyApprover"/>
					<jsp:param value="Y" name="ableUserControl"/>
					<jsp:param value="Y" name="inputInvisible"/>
					<jsp:param value="300" name="depttreeHeight"/>
					<jsp:param value="300" name="usertreeHeight"/>
					<jsp:param value="activeUser(event, data);" name="activeUserMethod"/>
				</jsp:include>
				<!-- 사용자 트리 include end -->
				
				<div class="conWrap trisection right">
					<h3>사용자 정보수정</h3>
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
										<td id="users_dept_nm">
											<div id="users_dept_nm_div" style="display:inline-block;"></div>
											<button type="button" id="btnFindDept" class="btn_common theme mg_l5" onclick="popDept()">부서변경</button>
										</td>
										<th class="t_left">${customfunc:getMessage('common.id.commonid')}</th>
										<td><span id="users_id_span">&nbsp;</span><input type="hidden" id="users_id" name="users_id" /></td>
									</tr>
									<tr>
										<th class="t_left"><font color="red"><b>*</b></font>&nbsp;성명</th>
										<td><input type="text" class="text_input long"
											id="users_nm" onkeyup="onlySizeFillter(this,10)"
											name="users_nm" /></td>
										<th class="t_left"><font color="red"><b>*</b></font>&nbsp;사용여부</th>
										<td colspan="3">
											<input type="radio" name="use_yn" id="use" value="Y" checked="checked" /> <label for="use" class="mg_r10">사용</label> 
											<input type="radio" name="use_yn" id="unUse" value="N" /> <label for="unUsed">미사용</label>
											<input name="admin_edit" class="lock_icon" onclick="customEdit.toggleAdminEdit(this, 'tg');" data-column="use_yn" data-status="lock" />
										</td>
									</tr>
									<tr>
										<th class="t_left">직급</th>
										<td><input type="text" class="text_input long"
											id="position_nm" name="position_nm"
											onkeyup="onlySizeFillter(this,15)" size="15" maxlength="15" /></td>
										<th class="t_left">직책</th>
										<td><input type="text" class="text_input long"
											id="job_nm" name="job_nm" onkeyup="onlySizeFillter(this,15)"
											size="15" maxlength="15" /></td>
									</tr>
									<%-- 
									<tr>
										<th class="t_left">권한</th>
										<td><select title="권한정책" id="auth_cd" name="auth_cd">
												<c:choose>
													<c:when test="${not empty fAuthInfoList}">
														<c:forEach items="${fAuthInfoList}" var="fAuthInfoList">
															<option value="<c:out value="${fAuthInfoList.auth_cd}"/>">
																<c:out value="${fAuthInfoList.auth_cd_nm}" />
															</option>
														</c:forEach>
													</c:when>
												</c:choose>
										</select></td>
										<th></th>
										<td></td>
									</tr>
									 --%>
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
										</select>
										<input name="admin_edit" class="lock_icon" onclick="customEdit.toggleAdminEdit(this, 'tg');" data-column="l_pol_seq" data-status="lock" />
										</td>
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
										</select>
										<input name="admin_edit" class="lock_icon" onclick="changeFilePolicy(this);" data-column="f_pol_seq" data-status="lock" />
										<input type="hidden" name="exist_rv_yn" id="exist_rv_yn"/>
										</td>
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
										</select>
										<input name="admin_edit" class="lock_icon" onclick="customEdit.toggleAdminEdit(this, 'tg');" data-column="a_pol_seq" data-status="lock" />
										</td>
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
										</select>
										<input name="admin_edit" class="lock_icon" onclick="customEdit.toggleAdminEdit(this, 'tg');" data-column="fp_pol_seq" data-status="lock" />
										</td>
									</tr>
									<tr>
										<th class="t_left">${INNER}영역 IP</th>
										<td class="i_ip"><input type="text"
											class="text_input long" id="inner_ip" name="inner_ip"
											onkeyup="if( ${userAllowedIpLoginYn eq 'N'} ){onlySizeFillter(this,15);}else{onlySizeFillter(this,200);}"
											placeholder="xxx.xxx.xxx.xxx" /></td>
										<th class="t_left">${OUTER}영역 IP</th>
										<td class="o_ip"><input type="text"
											class="text_input long" id="outer_ip" name="outer_ip"
											onkeyup="if( ${userAllowedIpLoginYn eq 'N'} ){onlySizeFillter(this,15);}else{onlySizeFillter(this,200);}"
											placeholder="xxx.xxx.xxx.xxx" /></td>
									</tr>
									<tr class="none">
										<th class="t_left">보안영역 MAC</th>
										<td class="i_ip"><input type="text"
											class="text_input long" id="inner_mac" name="inner_mac"
											onkeyup="onlySizeFillter(this,17)"
											placeholder="xx-xx-xx-xx-xx-xx" /></td>
										<th class="t_left">비-보안영역 MAC</th>
										<td class="o_ip"><input type="text"
											class="text_input long" id="outer_mac" name="outer_mac"
											onkeyup="onlySizeFillter(this,17)"
											placeholder="xx-xx-xx-xx-xx-xx" /></td>
									</tr>
									<tr>
										<th class="t_left">Mobile</th>
										<td><input type="text" class="text_input long" id="hp"
											name="hp" onkeyup="onlySizeFillter(this,15)" size="15"
											maxlength="15" /></td>
										<th class="t_left">E-mail</th>
										<td><input type="text" class="text_input long" id="email"
											name="email" onkeyup="onlySizeFillter(this,45)" size="45"
											maxlength="45" /></td>
									</tr>
									<tr>
										<!-- <th class="t_left">자가결재</th>
									<td> 
										<input type="radio" name="self_approval_yn" id="use2" value="Y" />
										<label for="use2" class="mg_r10" >허용</label>
										<input type="radio" name="self_approval_yn" id="unUse2" value="N" checked="checked"/>
										<label for="unUsed2">허용안함</label>
									</td> -->
										<!-- <th class="t_left">사용여부</th>
									<td colspan="3" >
										<input type="radio" name="use_yn" id="use" value="Y" checked="checked"/>
										<label for="use" class="mg_r10" >사용</label>
										<input type="radio" name="use_yn" id="unUse" value="N"/>
										<label for="unUsed">미사용</label>
									</td> -->
									</tr>
									<tr>
										<th class="t_left">Note.</th>
										<td colspan="3"><input type="text" class="text_input"
											id="note" name="note" onkeyup="onlySizeFillter(this,200)"
											size="200" maxlength="200" /></td>
									</tr>
									<c:if test="${auth_cd != 4}">
										<tr>
											<th class="t_left">패스워드 초기화</th>
											<td colspan="3">
												<button id="pwdInitBnt" type="button" class="btn_common" onclick="init()">패스워드 초기화</button>
											</td>
										</tr>
									</c:if>
									<tr>
										<td colspan="4">
											<div style="font-size:13px; line-height:16px; color: #4e4e4e;">
												<span id="customNoticeSpan" style="color:red; display:none;">* 해당 사용자는 관리자가 직접 추가한 사용자입니다. 인사정보연동에서  <b>동기화 제외 대상</b>으로 관리자가 설정한 데이터가 적용됩니다.<br></span>
												<img src='/Images/icon/icon_lock.png' style="width:13px; height:13px; vertical-align: middle;"/> : 인사정보연동 시, 데이터를 자동으로 동기화 합니다.<br>
												<img src='/Images/icon/icon_unlock.png' style="width:13px; height:13px; vertical-align: middle;"/> : 데이터를 직접 지정할 수 있습니다. 인사정보연동 시, 해당 데이터는 변경되지 않습니다.
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="btn_area_center mg_t10 mg_b10">
							<c:if test="${auth_cd != 4}">
								<button type="button" class="btn_common" onclick="initialize()">초기화</button>
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