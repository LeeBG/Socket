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

<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.admin.edit.js"/>"></script>

<script type="text/javascript">

	//부서 클릭 시 상세정보
	function userDetail() {
		checkFieldActivate(false);
		
		var requestURL = "<c:url value="/hr/dept/deptInfo.lin" />";
			resultCheckFunc($("#lform"), requestURL, function(response) {
			
			var dept = response['dept'];
			var custom_column = response['custom_column'];
			var default_info = response['default_info'];
			var custom_add_yn;
			if( dept ){
				custom_add_yn = dept.custom_add_yn;
			}
			var a_pol_list = response['a_pol_list'];
			var l_pol_list = response['l_pol_list'];
			var f_pol_list = response['f_pol_list'];
			var fp_pol_list = response['fp_pol_list'];
			
			initAdminEditButtonStatus( custom_column );
			customEdit.setAdminEditOriginData( default_info );
			customEdit.showCustomNotice( custom_add_yn );

			//$("#dept_seq").changeReadonlyState(custom_add_yn);
			$("#dept_nm").changeReadonlyState(custom_add_yn);
			
			$("#a_pol_seq").val(dept.a_pol_seq);
			$("#l_pol_seq").val(dept.l_pol_seq);
			$("#f_pol_seq").val(dept.f_pol_seq);
			$("#fp_pol_seq").val(dept.fp_pol_seq);
			$("#note").val(dept.note);
			
			if (dept.use_yn == "Y") {
				$(":radio[name=use_yn]#use").attr("checked", true);
			} else if (dept.use_yn == "N") {
				$(":radio[name=use_yn]#unUse").attr("checked", true);
			}
			$("input[name=dept_seq]").attr("readonly",'readonly');
			$("input[name=dept_seq]").addClass('readonly');
		});
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
	
	function activeDept(event, data) {
		var node = data.node;
		
		$("input[type=text]").val("");
		$("#dept_seq").val(node.data.dept_seq);
		$("#dept_nm").val(node.data.dept_nm);
		userDetail();
	}

	function insert() {
		var form = document.lform;
		var node = $("#tree").fancytree("getActiveNode");
		
		if (node == null) {
			alert('상위 부서을 선택해 주세요');
			return;
		} else {
			form.action = "<c:url value="/hr/dept/deptForm.lin" />?p_dept_seq=" + node.data.dept_seq + "&depth=" + node.data.depth;
			form.submit();
		}
	}

	function deptdel() {
		var form = document.lform;
		var node = $("#tree").fancytree("getActiveNode");

		if(empty($("#dept_seq").val())){
			alert("부서 선택이 되지 않았습니다.");
			return;
		} else {
			if(confirm("부서를 삭제 하시겠습니까? 모든이력이 삭제됩니다." ) ){
				var requestURL = "<c:url value="/hr/dept/deleteDept.lin" />";
				var successURL = "<c:url value="/hr/dept/deptManagement.lin" />";

				resultCheckFunc($("#lform"), requestURL, function(response) {
					var code = response['code'];
					var message = response['message'];
					if (code == '200') {
						alert('부서가 삭제 되었습니다.');
						$(location).attr("href", successURL);
					} else if (code == '300') {
						alert('사용자를 먼저 삭제하신 후 부서를 삭제하여 주세요.');
						$(location).attr("href", successURL);
					} else if (code == '400') {
						alert('하위부서를 먼저 삭제하신 후 부서를 삭제하여 주세요.');
						$(location).attr("href", successURL);
					} else {
						alert(message);
					}
				});
			}
		}
	}


	function initialize() {
		
		if(empty($("#dept_seq").val())){
			alert("부서 선택이 되지 않았습니다.");
			return;
		}
		
		var requestURL = "<c:url value="/hr/dept/deptInfo.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var dept = response['dept'];
			$("input[type=text]").val("");
			$("#dept_seq").val(dept.dept_seq);
			$("#dept_nm").val(dept.dept_nm);
			$("#l_pol_seq").val(dept.l_pol_seq);
			$("#f_pol_seq").val(dept.f_pol_seq);
			$("#note").val(dept.note);
			if (dept.use_yn == "Y") {
				$(":radio[name=use_yn]#use").attr("checked", true);
			} else if (dept.use_yn == "N") {
				$(":radio[name=use_yn]#unUse").attr("checked", true);
			}
		});
	}

	function save() {
		
		if(empty($("#dept_seq").val())){
			alert("부서 선택이 되지 않았습니다.");
			return;
		}

		if(isVaildCheckDept()){
			return false;
		}

		if (confirm("저장 하겠습니까?")) {
			var errmsg = new cls_errmsg();

			if (errmsg.haserror) {
				errmsg.show();
				return;
			}
			
			customEdit.setUnlockAdminEditColumn();

			var requestURL = "<c:url value="/fm/pl/insertFMPL0700.lin" />";
			var successURL = "<c:url value="/hr/dept/deptManagement.lin" />";

			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				if (code == '200') {
					alert('부서가 수정 되었습니다.');
					$(location).attr("href", successURL);
				} else {
					alert('부서 수정 중 에러가 발생 되었습니다.');
				}
			});
		} else {
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
		
		checkFieldActivate(true);
	});
	
	
	function checkFieldActivate(isDisabled){
		$("input[name=dept_nm]").attr("disabled",isDisabled);
		$("input[name=dept_seq]").attr("disabled",isDisabled);
		$("input[name=note]").attr("disabled",isDisabled);
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
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/dept/deptManagement.lin" />">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<!-- <input type="hidden" id="dept_seq" name="dept_seq" /> -->
	<input type="hidden" id="mgt_yn" name="mgt_yn" value="N"/>
	<input type="hidden" id="adminEditColumns" name="adminEditColumns" value=""/>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">부서 관리</h2>
				<p class="breadCrumbs">인사관리 > 부서 관리</p>
			</div>
		</div>
		<div class="conWrap trisectionWrap">
		
			<!-- 부서 트리 include start -->
			<jsp:include page="/WebUI/hr/user/include/deptTreeList.jsp">
				<jsp:param name="activeMethod" value="activeDept(event, data);"/>
				<jsp:param name="section" value="dept"/>
				<jsp:param name="inputInvisible" value="Y" />
			</jsp:include>	
			<!-- 부서 트리 include end -->
			
			<div class="conWrap trisection right">
				<h3>부서 정보수정</h3>
				<div class="conBox">
					<div class="table_area_style02">
						<table summary="하위메뉴 권한설정" style="table-layout : fixed;">
						<caption>메뉴명,허용여부</caption>
							<colgroup>
								<col style="width:13%;"/>
								<col style="width:37%;"/>
								<col style="width:13%;"/>
								<col style="width:37%;"/>
							</colgroup>
							<tbody>
								<tr>
									<th class="t_left">부서명</th>
									<td>
										<input type="text" class="text_input long" id="dept_nm" name="dept_nm" size="15" maxlength="15"/>
									</td>
									<th class="t_left">부서 아이디</th>
									<td>
										<input type="text" class="text_input long" id="dept_seq" name="dept_seq" readonly="readonly" size="15" maxlength="15"/>
										<input type="hidden" id="cud_cd" name="cud_cd" value="${CUD_CD_U}"/>
									</td>
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
										</select>
										<input type="button" name="admin_edit" class="lock_icon" onclick="customEdit.toggleAdminEdit(this, 'tg');" data-column="l_pol_seq" data-status="lock" />
										
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
										<input name="admin_edit" class="lock_icon" onclick="customEdit.toggleAdminEdit(this, 'tg');" data-column="f_pol_seq" data-status="lock" />
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
									<th class="t_left">Note.</th>
									<td colspan="3"><input type="text" class="text_input" id="note" name="note" size="200" maxlength="200"/></td>
								</tr>
								<tr>
									<th class="t_left">사용여부</th>
									<td colspan="3" >
										<input type="radio" name="use_yn" id="use" value="Y" checked="checked"/>
										<label for="use" class="mg_r10" >사용</label>
										<input type="radio" name="use_yn" id="unUse" value="N"/>
										<label for="unUsed">미사용</label>
										<input name="admin_edit" class="lock_icon" onclick="customEdit.toggleAdminEdit(this, 'tg');" data-column="use_yn" data-status="lock" />
									</td>
								</tr>
								<tr>
									<td colspan="4">
										<div style="font-size:13px; line-height:16px; color: #4e4e4e;">
											<span id="customNoticeSpan" style="color:red; display:none;">* 해당 부서는 관리자가 직접 추가한 부서입니다. 인사정보연동에서  <b>동기화 제외 대상</b>으로 관리자가 설정한 데이터가 적용됩니다.<br></span>
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
						<button type="button" class="btn_common theme mg_l5" onclick="save()">저장</button>
					</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>