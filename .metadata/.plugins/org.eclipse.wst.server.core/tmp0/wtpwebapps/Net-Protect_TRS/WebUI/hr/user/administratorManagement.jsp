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
<head>

<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<!--  fancytree -->
<link rel="stylesheet" type="text/css" href="<c:url value="/css/ui.fancytree.css"/>">
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.js"/>"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.filter.js"/>"></script>

<script type="text/javascript">
$(function(){
	//기본트리생성
	$("#tree").fancytree({
		autoScroll: true,
		checkbox: false,
		selectMode: 1,
		quicksearch: true,
		source: {
			url: "<c:url value="/hr/user/userTreeRootGroup.lin" />?dept_seq=${customfunc:cacheString('adminDeptSeq')}"
		},
		extensions: ["filter"],
		filter: {
			autoApply: true,
			counter : false,
			mode: "dimm"
		},

		lazyLoad: function(event, data) {
			var node = data.node;
			data.result = {
				url: "<c:url value="/hr/user/adminTreeSubGroup.lin"/>?dept_seq=" + node.data.dept_seq,
				data: {mode: "children", parent: node.key},
				// IE에서 리로드안되서 true에서 false로 변경
				cache: false
			};
		},

		loadChildren: function(event, data) {
			data.node.visit(function(subNode){
				if( subNode.isUndefined()) {
					var node = subNode;
					var data_seq = node.data.dept_seq;
					subNode.load();
				}
			});
		},

		activate: function(event, data){
			var node = data.node;
			if (!node.isFolder()) {
				$("input[type=text]").val("");
				$("#dept_seq").val(node.data.dept_seq);
				$("#users_id").val(node.data.users_id);
				$("#users_id_span").html(node.data.users_id);
				$("#users_nm").val(node.data.users_nm);
				$("#users_dept_nm").text(node.data.users_dept_nm);
				userDetail();
			}
		}
	});

	var tree = $("#tree").fancytree("getTree");

	//검색 input text
	$("input[name=search]").keyup(function(e){
		match = $(this).val();
		var tree = $.ui.fancytree.getTree();
		if (e && e.which === $.ui.keyCode.ESCAPE || $.trim(match) === "") {
			tree.clearFilter();
		}
		if( this.value != "" ){
			//$("button#btnResetSearch").click();
			n = tree.filterBranches.call(tree, match, tree_search_filter_opts);
		}
		return;
	});
	
	$("#search").on("keypress", function (e) {
	    if (e.keyCode == 13) {
	        // bad code!
	    	$("button#btnResetSearch").click();
	    }
	})
	
	var tree_search_filter_opts = {
			autoExpand : false,
			leavesOnly: true,
			highlight: true,
			mode : 'dimm'
			//hideExpandedCounter: false,
			//hideExpanders: false,
			//nodata: false, 
		};
		
		var tree_search_filter_opts_enter = {
				autoExpand : true,
				leavesOnly: true,
				highlight: true,
				mode : 'hide'
				//hideExpandedCounter: false,
				//hideExpanders: false,
				//nodata: false, 
		};
	//검색 버튼클릭
	$("button#btnResetSearch").click(
		function(e){
			match = $("input[name=search]").val();
			var tree = $.ui.fancytree.getTree();
			if ($.trim(match) === "") {
				tree.clearFilter();
				return;
			}
			n = tree.filterBranches.call(tree, match, tree_search_filter_opts_enter);
	});

	//사용자 클릭 시 상세정보
	function userDetail() {
		setUserInfo();
	}
	//fancytree end
});

function initialize() {
	if(empty($("#users_id").val())){
		alert("관리자 선택이 되지 않았습니다.");
		return;
	}
	
	setUserInfo();
}

function insert() {
	var form = document.lform;

	var node = $("#tree").fancytree("getActiveNode");
	if (node == null){
		alert("그룹을 선택해 주세요");
		return;
	}
	var dept_nm = node.data.dept_nm;
	if (dept_nm == null) {
		alert("그룹을 선택해 주세요 ");
		return;
	}			
	var dept_seq = node.data.dept_seq;
	$('#dept_seq').val(dept_seq);
	$('#dept_nm').val(dept_nm);
	form.action = "<c:url value="/hr/user/insertAdminUser.lin" />";
	form.submit();
}

function deleteAdmin(){
	$users_id = $("#users_id");
	if( ! $users_id || $users_id.val() == "" ){
		alert("삭제할 관리자를 선택해주세요."); 
		return;
	}

	if(confirm("관리자를 삭제 하시겠습니까?" ) ) {
		$("#cud_cd").val("D");
	
		var requestURL = "<c:url value="/hr/user/updateAdminUser.lin" />";
		var successURL = "<c:url value="/hr/user/administratorManagement.lin" />";
	
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			if (code == '200') {
				alert(message); // 관리자가 삭제되었습니다.
				$(location).attr("href", successURL);
			} else if(code == '210'){
				alert(message); // 존재하지않는 아이디입니다.
			} else if(code == '500'){
				alert(message); // 사용자 삭제 중 에러가 발생 되었습니다.
			}else {
				alert(message); // 사용자 삭제 중 에러가 발생 되었습니다.
			}
		});
	}
}

function setUserInfo() {
	checkFieldActivate(false);
	var requestURL = "<c:url value="/hr/user/treeUserInfo.lin" />"; 
	resultCheckFunc($("#lform"), requestURL, function(response) {

		var users = response['users'];
		$("#position_nm").val(users.position_nm);
		$("#job_nm").val(users.job_nm);
		$("#auth_cd").val(users.auth_cd);
		$("#l_pol_seq").val(users.l_pol_seq);
		$("#f_pol_seq").val(users.f_pol_seq);
		$("#a_pol_seq").val(users.a_pol_seq);
		$("#hp").val(users.hp);
		$("#email").val(users.email);
		$("#note").val(users.note);
		$("#inner_ip").val(users.allowIp);

		if(users.auth_cd == 3) $('#dept_setting').css("display", "");
		else $('#dept_setting').css("display", "none");

		//$(":radio[name=use_yn]#use"+users.use_yn).attr("checked",true);
		//$(":radio[name=self_approval_yn]#self_approval"+users.self_approval_yn).attr("checked",true);
		$("input:radio[name='use_yn']:radio[value="+users.use_yn+"]").prop("checked", true);
	});
}

function save() {
	var errmsg = new cls_errmsg();
	
	if(empty($("#users_id").val())){
		alert("관리자 선택이 되지 않았습니다.");
		return;
	}
	
	if(isVaildCheckUserManagement()){
		return;
	}
	var $admin_allow_ip = $("#inner_ip");
	var ip_arr = $admin_allow_ip.val() ? $admin_allow_ip.val().split(",") : null;

	if( empty($admin_allow_ip.val()) ){
		errmsg.append($admin_allow_ip, "관리자 접속IP를 입력 하세요.");
	} else if( ip_arr ) {
		if( ip_arr.length > '${adminIpCount}' ){
			errmsg.append($admin_allow_ip, "관리자 접속IP는 '${adminIpCount}'개까지 등록할 수 있습니다.");
		} else {
			for( var i=0; i<ip_arr.length ; i++ ){
				if( !isValidIP(ip_arr[i]) ){
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

	if(confirm("관리자 정보를 수정 하겠습니까?" ) ){
		var requestURL = "<c:url value="/hr/user/updateAdminUser.lin" />";
		var successURL = "<c:url value="/hr/user/administratorManagement.lin" />";

		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			if (code == '200') {
				alert('관리자가 수정 되었습니다.');
				$(location).attr("href", successURL);
			} else {
				alert(message);
			}
		});
	}
}

function init(){
	if(empty($("#users_id").val())){
		alert("관리자 선택이 되지 않았습니다.");
		return;
	}
	
	if(confirm("패스워드를 초기화 하겠습니까?" ) ){
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
	}else{
		return;
	}
}

function isVaildCheckUserManagement(){
	if(empty($("#users_id").val())){
		alert("${customfunc:getMessage('common.id.commonid')}가 올바르지 않습니다.");
		return true;
	}
	if(empty($("#users_nm").val())){
		alert("성명이 올바르지 않습니다.");
		return true;
	}
	
	if(empty($("#l_pol_seq option:selected").val())){
		alert("로그인 정책이 올바르지 않습니다.");
		return true;
	}
	if(empty($("#f_pol_seq option:selected").val())){
		alert("파일전송 정책이 올바르지 않습니다.");
		return true;
	}
	return false;
}

$(document).ready(function() {
	checkFocusMessage($("#users_nm"),"최대 10자까지 가능합니다.");
	checkFocusMessage($("#position_nm"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#job_nm"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#hp"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#email"),"최대 45자까지 가능합니다.");
	checkFocusMessage($("#note"),"최대 200자까지 가능합니다.");
	checkFocusMessage($("#search"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#inner_ip"), "${adminIpMaxLength}자 까지 입력이 가능합니다.(xxx.xxx.xxx.xxx)");
	
	checkFieldActivate(true);
});

function checkFieldActivate(isDisabled){
	$("input[name=users_id]").attr("disabled",isDisabled);
	$("input[name=users_nm]").attr("disabled",isDisabled);
	$("input[name=position_nm]").attr("disabled",isDisabled);
	$("input[name=job_nm]").attr("disabled",isDisabled);
	$("input[name=hp]").attr("disabled",isDisabled);
	$("input[name=email]").attr("disabled",isDisabled);
	$("input[name=note]").attr("disabled",isDisabled);
}

function groupSet(){
	if(empty($("#users_id").val())){
		alert("관리자 선택이 되지 않았습니다.");
		return;
	}
	var url = "/hr/dept/manageGroupSetPopup.lin?id=" + $("#users_id").val();
	var attr = "resizable=no,scrollbars=no,toolbar=no,url=no,width=800,height=900,top=5,left=5,url=no";
	var popupWindow = window.open(url, "manageGroupSetPopup", attr);
	popupWindow.focus();
}

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/user/administratorManagement.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="dept_nm" name="dept_nm" />
<input type="hidden" id="dept_seq" name="dept_seq" />
<input type="hidden" id="a_pol_seq" name="a_pol_seq" value="1" />
<input type="hidden" id="mgt_yn" name="mgt_yn" value="Y"/>
<input type="hidden" id="cud_cd" name="cud_cd" value="${CUD_CD_U}" />
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">관리자 관리</h2>
				<p class="breadCrumbs">인사관리 > 관리자 관리</p>
			</div>
		</div>
		<div class="conWrap trisectionWrap">
			<div class="outBox">
				<div class="conWrap">
					<h3>관리자 목록</h3>
					<div class="conBox">
						<div class="topCon t_center pd_t10 pd_b10 Bborder">
							<input type="text" name="search" id="search" class="text_input max" placeholder="관리자ID, 이름, 부서" onkeyup="onlySizeFillter(this,15)" style="width:40%;"/>
							<button type="button" id="btnResetSearch" class="btn_common theme" >검색</button>
							<c:if test="${auth_cd != 4}">
								<button type="button" class="btn_common theme" onclick="insert()">관리자 추가</button>
								<button type="button" class="btn_common theme" onclick="deleteAdmin()">관리자 삭제</button>
							</c:if>
						</div>
					<div id="tree" class="treeBox pd_t10 mg_b10"></div>
					</div>
				</div>
				<!-- 
					<div class="btn_area_left">
					<c:if test="${auth_type != 2}">
						<button type="button" class="btn_common theme" onclick="insert()">관리자 추가</button>
					</c:if>
					</div>
				 -->
			</div>
			<div class="conWrap trisection right">
				<h3>관리자 정보수정</h3>
				<div class="conBox">
					<div class="table_area_style02">
						<table summary="관리자 정보 수정" style="table-layout : fixed;">
						<caption>관리자 정보 수정</caption>
							<colgroup>
								<col style="width:13%;"/>
								<col style="width:37%;"/>
								<col style="width:13%;" />
								<col style="width:37%;" />
							</colgroup>
							<tbody>
								<tr>
									<th class="t_left">부서명</th>
									<td id="users_dept_nm"><span></span></td>
									<th class="t_left">아이디</th>
									<td><span id="users_id_span">&nbsp;</span><input type="hidden" id="users_id" name="users_id" />
									</td>
								</tr>
								<tr>
									<th class="t_left"><font color="red"><b>*</b></font>&nbsp;성명</th>
									<td><input type="text" class="text_input long" id="users_nm" onkeyup="onlySizeFillter(this,10)" name="users_nm"/></td>
									<th class="t_left"><font color="red"><b>*</b></font>&nbsp;사용여부</th>
									<td colspan="3" >
										<input type="radio" name="use_yn" id="use" value="Y" checked="checked"/>
										<label for="use" class="mg_r10" >사용</label>
										<input type="radio" name="use_yn" id="unUse" value="N"/>
										<label for="unUsed">미사용</label>
									</td>
								</tr>
								<tr>
									<th class="t_left">직급</th>
									<td><input type="text" class="text_input long" id="position_nm" name="position_nm" onkeyup="onlySizeFillter(this,15)" size="15" maxlength="15"/></td>
									<th class="t_left">직책</th>
									<td><input type="text" class="text_input long" id="job_nm" name="job_nm" onkeyup="onlySizeFillter(this,15)" size="15" maxlength="15"/></td>
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
									<th class="t_left"><font color="red"><b>*</b></font>&nbsp;관리자 접속IP</th>
									<td colspan="3" class="i_ip">
										<input type="text" class="text_input long" id="inner_ip" name="inner_ip" onkeyup="onlySizeFillter(this,'${adminIpMaxLength}')"/>
										<p class="helpBox mg_t20" id="pwd_explanation">관리자 접속IP는 ','로 구분 하여 ${adminIpCount}개 까지 가능</p>
									</td>
								</tr>
								<!-- <tr class="none">
									<th class="t_left">보안영역 허용IP</th>
									<td class="i_ip"><input type="text" class="text_input long" id="inner_ip" name="inner_ip" placeholder="xxx.xxx.xxx.xxx"/></td>
									<th class="t_left">비-보안영역 허용IP</th>
									<td class="o_ip"><input type="text" class="text_input long" id="outer_ip" name="outer_ip" placeholder="xxx.xxx.xxx.xxx"/></td>
								</tr> -->
								<tr class="none">
									<th class="t_left">보안영역 MAC</th>
									<td class="i_ip"><input type="text" class="text_input long" id="inner_mac" name="inner_mac" onkeyup="onlySizeFillter(this,17)" placeholder="xx-xx-xx-xx-xx-xx"/></td>
									<th class="t_left">비-보안영역 MAC</th>
									<td class="o_ip"><input type="text" class="text_input long" id="outer_mac" name="outer_mac" onkeyup="onlySizeFillter(this,17)" placeholder="xx-xx-xx-xx-xx-xx"/></td>
								</tr>
								<tr>
									<th class="t_left">Mobile</th>
									<td><input type="text" class="text_input long" id="hp" name="hp" onkeyup="onlySizeFillter(this,15)" size="15" maxlength="15"/></td>
									<th class="t_left">E-mail</th>
									<td><input type="text" class="text_input long" id="email" name="email" onkeyup="onlySizeFillter(this,45)" size="45" maxlength="45"/></td>
								</tr>
								<tr>
									<th class="t_left">Note.</th>
									<td colspan="3"><input type="text" class="text_input" id="note" name="note" onkeyup="onlySizeFillter(this,200)" size="200" maxlength="200"/></td>
								</tr>
								<c:if test="${auth_cd != 4}">
								<tr>
									<th class="t_left">패스워드 초기화</th>
									<td colspan="3">
										<button type="button" class="btn_common" onclick="init()">패스워드 초기화</button>
									</td>
								</tr>
								</c:if>
								<tr id="dept_setting">
									<th class="t_left">부서 관리 설정</th>
									<td colspan="3">
										<button type="button" class="btn_common" onclick="groupSet()">설정</button>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn_area_center mg_t10 mg_b10">
					<c:if test="${auth_cd == 1}">
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