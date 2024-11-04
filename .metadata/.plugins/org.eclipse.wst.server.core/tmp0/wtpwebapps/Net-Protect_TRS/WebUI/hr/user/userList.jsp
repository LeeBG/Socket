<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="user_dept_seq" value="${sessionScope.loginUser.dept_seq}" />
<html>
<head>
<c:set var="complexity" value="${loginPolicy.pwd_complexity}"/>
<c:set var="minLength" value="${loginPolicy.pwd_min_len}"/>
<c:set var="maxLength" value="${loginPolicy.pwd_max_len}"/>

<link href="<c:url value="/Style/ui.dynatree.css" />" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.dynatree.min.js" />"></script>
<script type="text/javascript">
var userList ="";
var complexity = '${complexity}';

	$(document).ready(function() {
		$('input[type="text"]').val('');

		$('#find_user_btn').click(function() {
			findUsers();
		});

		$('#update_disk_limit_btn').click(function() {
			updateDiskLimit();
		});

		$('#custom_disk_limit_chk').change(function() {
			if($("#custom_disk_limit_chk:checked").length){
				$("#custom_disk_limit_yn").val("Y");
				$("#custom_disk_limit").attr("readonly",false);
			} else {
				$("#custom_disk_limit_yn").val("N");
				$("#custom_disk_limit").attr("readonly",true);
			}
		});
	});

	var storeKey = null;

	$(function() {
		$("#tree").dynatree({
			clickFolderMode : 1,
			onCreate : function(node, nodeSpan) {
				node.render();
			},
			onClick : function(node, status) {
				//alert("onclick" + node + " (" + node.getKeyPath()+ ")");
				var isLazy = node.isLazy();
				if (node && node.data.isFolder && !node.isExpanded() && node.isLazy()) {
					if (!node.data.loaded) {
						node.reloadChildren();
						node.data.loaded = true;
					}
				} 
			},
			onActivate : function(node) {
				//alert("" + node + " (" + node.getKeyPath()+ ")");
				if (node.data.isFolder) {
					$("#insert_parent").val(node.data.title);
				} else {
					$("#select_name").val(node.data.title);
					$("#update_authority").val(node.data.auth_type);
					if (node.data.custom_disk_limit_yn == "Y") {
						$("#custom_disk_limit_chk").attr("checked", true);
						$("#custom_disk_limit").attr('readonly',false);
					} else {
						$("#custom_disk_limit_chk").attr("checked", false);
						$("#custom_disk_limit").attr('readonly',true);
					}
					$("#custom_disk_limit").val(node.data.custom_disk_limit);
				}
			},
			initAjax : {
				url : "<c:url value="/users/user/userTree.lin" />"
			},
			onLazyRead : function(node) {
				if (node.data.isFolder && !node.isExpanded()) {
					node.appendAjax({
						url : "<c:url value="/users/user/dapertmentInfo.lin" />",
						data : {
							dept_seq : node.data.dept_seq
						}
					});
				}
			},
			onPostInit: function(isReloading, isError) {
				var tree = $("#tree").dynatree("getTree");
				if (storeKey != null) {
					tree.loadKeyPath(storeKey, function(node, status) {
						if (status == "loaded") {
							node.expand();
						} else if (status == "ok") {
							if (node.isLazy()) {
								node.reloadChildren();
							}
							node.expand();
							node.activate();
						}
					});
					storeKey = null;
				} else {
					tree.loadKeyPath("/root/" + "${user_dept_seq}", function(node, status){
						//alert(" node : " + node);
						if(status == "ok") {
							node.reloadChildren();
							node.expand();
							node.data.loaded = true;
						}
					});
				}

			}
			
		});

		$("#lform td div:empty").html("&nbsp");
	});

	function findUsers() {
		var errmsg = new cls_errmsg();
		if ($("#find_users_nm").val().empty()) {
			errmsg.append($("#find_users_nm"), "<spring:message code="users.user.list.script.invalid.find.user" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		var requestURL = "<c:url value="/person/findUsers.lin" />";

		resultCheckFunc($("#nform"), requestURL, function(response) {
			userList = response['userList'];
			var successMessage = response['successMessage'];
			var searchMessage = $("#searchMessage");
			searchMessage.html(successMessage);

			var layer = $("#search_user_result");
			if (userList && userList.length > 0) {
				layer.css("display", "inline");
				//var tree = $("#tree").dynatree("getTree");

				//var search_user_result_div = $('#search_user_result_div');
				var searchUserTableTbody = $("#searchUserTable tbody");
				$("#searchUserTable tbody tr").remove();

				for (var i=0; i < userList.length; i++) {
					var code = response[userList[i].dept_seq+"code"];
					var parent_dept_seq_list = response[userList[i].dept_seq];
					var dept_seq_tree = "/";

					if (code == "200") {
						for (var j=0; j < parent_dept_seq_list.length; j++) {
							dept_seq_tree += parent_dept_seq_list[j].dept_nm + " / ";
						}
					} else {
						dept_seq_tree += parent_dept_seq_list + "/ ";
					}

					result = '<tr> \n';
					result += '	<th><span onclick="selectUser('+i+');" id="user' + i + '" style="color: black;cursor: pointer;">' + dept_seq_tree + userList[i].users_nm + '(' + userList[i].users_id + ')</span></th> \n';
					result += '</tr> \n';
					searchUserTableTbody.append(result);
				}
			} else {
				layer.css("display", "none");
			}
		});
	}

	function selectUser(order) {
		var user = userList[order];
		$("#select_name").val(user.users_nm);
		$("#update_authority").val(user.auth_type);
		$("#users_id").val(user.users_id);
		$("#custom_disk_limit_yn").val(user.custom_disk_limit_yn);
		$("#custom_disk_limit").val(user.custom_disk_limit);

		if (user.custom_disk_limit_yn == "Y") {
			$("#custom_disk_limit_chk").attr("checked", true);
			$("#custom_disk_limit").attr("readonly",false);
		} else {
			$("#custom_disk_limit_chk").attr("checked", false);
			$("#custom_disk_limit").attr("readonly",true);
		}
	}

	function reloadTree(key) {
		storeKey = key;
		$("#tree").dynatree("getTree").reload();
	}

	function ins() {
		var node = $("#tree").dynatree("getActiveNode");
		if (node && node.data.isFolder) {
			if (confirm("<spring:message code="users.user.list.script.confirm.insert" />")) {
				var errmsg = new cls_errmsg();

				if ($("#insert_name").val().empty()) {
					errmsg.append($("#insert_name"), "<spring:message code="users.user.list.script.invalid.name" />");
				}

				if ($("#insert_id").val().empty()) {
					errmsg.append($("#insert_id"), "<spring:message code="users.user.list.script.invalid.id" />");
				}

				if ($("#insert_pwd").val().empty()|| !isValidPassword($("#insert_pwd").val(), complexity)) {
					if(complexity == 1 ) {
						errmsg.append($("#insert_pwd"), "<spring:message code="users.user.list.script.passwordRule1" />");
					}else if(complexity == 2 ) {
						errmsg.append($("#insert_pwd"), "<spring:message code="users.user.list.script.passwordRule2" />");
					}else if(complexity == 3 ) {
						errmsg.append($("#insert_pwd"), "<spring:message code="users.user.list.script.passwordRule3" />");
					}
				} else if ($("#insert_pwd").val() != $("#insert_rePwd").val()) {
					errmsg.append($("#insert_rePwd"), "<spring:message code="users.user.list.script.invalid.pwd.different" />");
				}

				if ($("#insert_authority").val() == '0') {
					errmsg.append($("#insert_authority"), "<spring:message code="users.user.list.script.invalid.authority" />");
				}

				if (errmsg.haserror) {
					errmsg.show();
					return;
				}

				$("#users_nm").val($("#insert_name").val());
				$("#users_id").val($("#insert_id").val());
				$("#users_pwd").val($("#insert_pwd").val());
				$("#rePwd").val($("#insert_rePwd").val());
				$("#dept_seq").val(node.data.dept_seq);
				$("#auth_type").val($("#insert_authority").val());
				$("#custom_disk_limit").val(0);

				var requestURL = "<c:url value="/users/user/userInsert.lin" />";
				resultCheckFunc($("#lform"), requestURL, function(response) {
					if (response.message != null) {
						alert(response.message);
					}
					if (response.code == '200') {
						reloadTree(node.getKeyPath());
						$("#insert_name").val("");
						$("#insert_id").val("");
						$("#insert_pwd").val("");
						$("#insert_rePwd").val("");
					}
				});
			} else {
				return;
			}
		} else {
			alert('<spring:message code="users.user.list.script.invalid.parent" />');
		}
	}

	function mod() {
		var node = $("#tree").dynatree("getActiveNode");
		if (node && !node.data.isFolder) {
			if (confirm("<spring:message code="users.user.list.script.confirm.modify" />")) {
				var errmsg = new cls_errmsg();
				if ($("#update_name").val().empty()) {
					errmsg.append($("#update_name"), "<spring:message code="users.user.list.script.invalid.name" />");
				}

				if ($("#update_pwd").val().empty() || !isValidPassword($("#update_pwd").val(), complexity)) {
					if(complexity == 1 ) {
						errmsg.append($("#insert_pwd"), "<spring:message code="users.user.list.script.passwordRule1" />");
					}else if(complexity == 2 ) {
						errmsg.append($("#insert_pwd"), "<spring:message code="users.user.list.script.passwordRule2" />");
					}else if(complexity == 3 ) {
						errmsg.append($("#insert_pwd"), "<spring:message code="users.user.list.script.passwordRule3" />");
					}
				} else if ($("#update_pwd").val() != $("#update_rePwd").val()) {
					errmsg.append($("#update_pwd"), "<spring:message code="users.user.list.script.invalid.pwd.different" />");
				}

				if ($("#update_authority").val() == '0') {
					errmsg.append($("#update_authority"), "<spring:message code="users.user.list.script.invalid.authority" />");
				}

				if (errmsg.haserror) {
					errmsg.show();
					return;
				}

				$("#users_id").val(node.data.users_id);
				$("#users_nm").val($("#update_name").val());
				$("#newPwd").val($("#update_pwd").val());
				$("#rePwd").val($("#update_rePwd").val());
				$("#dept_seq").val(node.data.dept_seq);
				$("#auth_type").val($("#update_authority").val());

				var requestURL = "<c:url value="/users/user/userUpdate.lin" />";
				resultCheckFunc($("#lform"), requestURL, function(response) {
					if (response.message != null) {
						alert(response.message);
					}
					if (response.code == '200') {
						reloadTree(node.getKeyPath());
					}
				});

			} else {
				return;
			}
		} else {
			alert('<spring:message code="users.user.list.script.required.user" />');
		}
	}

	function del() {
		var node = $("#tree").dynatree("getActiveNode");
		if (node) {
			if (node.data.users_id != null) {
				if (!confirm("<spring:message code="users.user.list.script.confirm.delete" />")) {
					return;
				}
				$("#users_id").val(node.data.users_id);

				var requestURL = "<c:url value="/users/user/userDelete.lin" />";

				resultCheckFunc($("#lform"), requestURL, function(response) {
					if (response.message != null) {
						alert(response.message);
					}
					if (response.code == '200') {
						reloadTree(node.getKeyPath());
					}
				});

			}
		} else {
			alert('<spring:message code="users.user.list.script.required.user" />');
		}
	}

	function deleteUser(key) {
		resultCheckFunc($("#lform"), "<c:url value="/users/user/userDelete.lin" />",
			function(response) {
				if (response.message != null) {
					alert(response.message);
				} else {
					reloadTree(key);
				}
			});
	}

	function updateDiskLimit() {
		var errmsg = new cls_errmsg();
		var custom_disk_limit = $("#custom_disk_limit");

		if ($("#select_name").val().empty()) {
			errmsg.append($("#select_name"), "<spring:message code="users.user.list.script.required.user" />");
		} else if (!isNumber(custom_disk_limit.val()) || parseInt(custom_disk_limit.val()) < 1 || parseInt(custom_disk_limit.val()) > 1500) {
			errmsg.append(custom_disk_limit, "<spring:message code="users.user.list.script.invalid.diskLimit" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		var requestURL = "<c:url value="/users/user/updateDiskLimit.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var successMessage = response['successMessage'];
			var usableDisk = response['usableDisk'];
			alert(successMessage);
			$("#find_user_btn").click();
			$("#usableDisk").html(usableDisk);
		});

	}
</script>
</head>
<body>
<!-- contents -->
<div id="contentPageHeader">
	<div id="contentPageTitle">
		<h3><spring:message code="configuration.dataLink.policy.loginPolicy.title" /></h3>
	</div>
	<div id="contentPageLocation">
		<ul>
			<li class="Lfirst"><span>자료전송</span></li>
			<li><span>사용자관리</span></li>
			<li class="Llast"><span>사용자</span></li>
		</ul>
	</div>
</div>
	<!-- 트리 영역 -->
<div id="tree" class="tree_area mg_t20"></div>
<!-- //트리 영역 -->
<!-- 추가,수정,삭제영역 -->
<form id="lform" name="lform" method="post" action="" onSubmit="return false;">
<input type="hidden" id="page" name="page">
<input type="hidden" id="users_id" name="users_id">
<input type="hidden" id="users_nm" name="users_nm">
<input type="hidden" id="dept_seq" name="dept_seq" value="0">
<input type="hidden" id="users_pwd" name="users_pwd">
<input type="hidden" id="custom_disk_limit_yn" name="custom_disk_limit_yn">
<input type="hidden" id="newPwd" name="newPwd">
<input type="hidden" id="rePwd" name="rePwd">
<input type="hidden" id="auth_type" name="auth_type" value="0">
<div class="tree_left_con mg_t20">
	<fieldset>
	<legend>사용자 추가 수정 삭제</legend>
	<!-- 사용자 추가 -->
	<div class="box_type02 table_area_style04">
		<table cellspacing="0" cellpadding="0" summary="사용자 추가 테이블입니다.">
			<caption>상위부서, 이름, 아이디, 패스워드, 패스워드 재입력, 권한</caption>
			<colgroup>
				<col style="width:35%;" />
				<col style="width:65%;" />
			</colgroup>
			<tbody>
				<tr>
					<th><span><spring:message code="users.user.list.insert.parent" /></span></th>
					<td>
						<input type="text" class="text_input" id="insert_parent" name="insert_parent" disabled/>
					</td>
				</tr>
				<tr>
					<th><span><spring:message code="users.user.list.insert.name" /></span></th>
					<td>
						<input type="text" class="text_input" id="insert_name" name="insert_name"/>
					</td>
				</tr>
				<tr>
					<th><span><spring:message code="users.user.list.insert.id" /></span></th>
					<td>
						<input type="text" class="text_input" id="insert_id" name="insert_id"/>
					</td>
				</tr>
				<tr>
					<th><span><spring:message code="users.user.list.insert.password" /></span></th>
					<td>
						<input type="password" class="text_input" id="insert_pwd" name="insert_pwd"/>
					</td>
				</tr>
				<tr>
					<th><span><spring:message code="users.user.list.insert.rePassword" /></span></th>
					<td>
						<input type="password" class="text_input" id="insert_rePwd" name="insert_rePwd"/>
					</td>
				</tr>
				<tr>
					<th><spring:message code="users.user.list.authority" /></th>
					<td>
						<select id="insert_authority" name="insert_authority">
							<option value="0"><spring:message code="users.user.list.authority.title"/></option>
							<option value="1"><spring:message code="users.user.list.authority.admin"/></option>
							<option value="3"><spring:message code="users.user.list.authority.standard"/></option>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="btn_area_right pd_t8">
		<button type="submit" class="btn_add_st01" onClick="ins();">
			<span class="ir_desc"><spring:message code="users.user.list.insert.submit" /></span>
		</button>
	</div>
	<!-- //사용자 추가 -->
	<!-- 사용자 수정,삭제 -->
	<div class="box_type02 table_area_style04 mg_t30">
		<table cellspacing="0" cellpadding="0" summary="사용자 수정,삭제 테이블입니다.">
			<caption>선택사용자, 변경할 이름, 패스워드, 패스워드 재입력, 권한</caption>
			<colgroup>
				<col style="width:35%;" />
				<col style="width:65%;" />
			</colgroup>
			<tbody>
				<tr>
					<th><span><spring:message code="users.user.list.modify.selected" /></span></th>
					<td>
						<input type="text" class="text_input"  id="select_name" name="select_name" disabled/>
					</td>
				</tr>
				<tr>
					<th><span"><spring:message code="users.user.list.modify.changeName" /></span></th>
					<td>
						<input type="text" class="text_input" id="update_name" name="update_name"/>
					</td>
				</tr>
				<tr>
					<th><span><spring:message code="users.user.list.modify.password" /></span></th>
					<td>
						<input type="password" class="text_input" id="update_pwd" name="update_pwd"/>
					</td>
				</tr>
				<tr>
					<th><span><spring:message code="users.user.list.modify.rePassword" /></span></th>
					<td>
						<input type="password" class="text_input" id="update_rePwd" name="update_rePwd"/>
					</td>
				</tr>
				<tr>
					<th><span><spring:message code="users.user.list.insert.cunstomDisk"/></span></th>
					<td style="overflow:auto;">
						<input type="checkbox" class="input_chk" name="custom_disk_limit_chk" id="custom_disk_limit_chk"/>
						<input type="text" style="width: 120px;" class="text_input f_left" id="custom_disk_limit" name="custom_disk_limit" readonly/> MBytes
						<button type="submit" id="update_disk_limit_btn" class="btn_modify_st02 f_right">
							<span class="ir_desc">찾기</span>
						</button>
					</td>
				</tr>
				<tr>
					<th><spring:message code="users.user.list.authority" /></th>
					<td>
						<select id="update_authority" name="update_authority">
							<option value="0"><spring:message code="users.user.list.authority.title"/></option>
							<option value="1"><spring:message code="users.user.list.authority.admin"/></option>
							<option value="3"><spring:message code="users.user.list.authority.standard"/></option>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="btn_area_right pd_t8">
		<button type="submit" onClick="mod();" class="btn_modify_st01" style="margin-left:3px;">
			<span class="ir_desc">수정 완료</span>
		</button>
		<button type="submit" onClick="del();" class="btn_del_st01" style="margin-left:3px;">
			<span class="ir_desc">삭제 완료</span>
		</button>
	</div>
	<!-- //사용자 수정,삭제 -->
	</fieldset>
</div>
</form>
<!-- //사용자 찾기-->
<form id="nform" name="nform" method="post" action="" onSubmit="return false;">
<div class="table_area_style04 btn_area_left pd_t8 mg_t8" style="width:350px;">
	<table cellspacing="0" cellpadding="0" summary="사용자 찾기">
		<caption>설명, 사용자명, 찾기버튼</caption>
		<colgroup>
			<col style="width:25%;" />
			<col style="width:65%;" />
			<col style="width:10%;" />
		</colgroup>
		<tbody>
			<tr>
				<th><span class="list"><spring:message code="users.user.list.find.title"/></span></th>
				<td>
					<input type="text" class="text_input" id="find_users_nm" name="find_users_nm"/>
				</td>
				<td>
					<button type="submit" id="find_user_btn" class="btn_find_st02" style="margin-left:3px;">
						<span class="ir_desc">찾기</span>
					</button>
				</td>
			</tr>
			<tr>
				<th colspan="3"><span style="color:red;" id="searchMessage"></span></th>
			</tr>
		</tbody>
	</table>
</div>
<div id="search_user_result" style="display: none;">
	<div class="box_type02 table_area_style04 mg_t8">
		<table id="searchUserTable" cellspacing="0" cellpadding="0" summary="사용자 검색 결과">
			<caption>/부서/ 이름</caption>
			<colgroup>
				<col style="width:100%;" />
			</colgroup>
			<tbody>
				<tr>
				</tr>
			</tbody>
		</table>
	</div>
</div>
</form>
	<!-- //사용자 찾기-->
<!-- //contents -->
</body>
</html>