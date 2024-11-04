<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<c:set var="user_dept_seq" value="${sessionScope.loginUser.dept_seq}" />

<html>
<head>
<link href="<c:url value="/Style/ui.dynatree.css" />" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.dynatree.min.js" />"></script>
<script type="text/javascript">
<!--
	var storeKey = null;

	$(function() {
		$("#tree").dynatree({
			clickFolderMode : 1,
			onCreate : function(node, nodeSpan) {
				node.render();
			},
			onClick : function(node, status) {
				var isLazy = node.isLazy();
				if (node && node.data.isFolder && !node.isExpanded() && node.isLazy()) {
					if (!node.data.loaded) {
						node.reloadChildren();
						node.data.loaded = true;
					}
				} 
			},
			onActivate : function(node) {
				if (node.data.isFolder) {
					$("#insert_parent").val(node.data.title);
					$("#select_name").val(node.data.title);
				} 
			},
			initAjax : {
				url : "<c:url value="/users/department/departmentTree.lin" />"
			},
			onLazyRead : function(node) {
				if (node.data.isFolder && !node.isExpanded()) {
					node.appendAjax({
						url : "<c:url value="/users/department/departmentInfo.lin" />",
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
						}
					});
					storeKey = null;
				} else {
					tree.loadKeyPath("/root/" + "${user_dept_seq}", function(node, status){
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

	function reloadTree(key) {
		storeKey = key;
		$("#tree").dynatree("getTree").reload();
	}

	function ins() {
		var node = $("#tree").dynatree("getActiveNode");
		if (node) {
			if (confirm("<spring:message code="users.department.list.script.confirm.insert" />")) {
				var errmsg = new cls_errmsg();
				if ($("#insert_name").val().empty()) {
					errmsg.append($("#insert_name"), "<spring:message code="users.department.list.script.invalid.department.name" />");
				}
				if ($("#insert_id").val().empty()) {
					errmsg.append($("#insert_id"), "<spring:message code="users.department.list.script.invalid.department.id" />");
				}
				if (errmsg.haserror) {
					errmsg.show();
					return;
				}

				$("#dept_nm").val($("#insert_name").val());
				$("#dept_id").val($("#insert_id").val());
				$("#depth").val(node.data.depth + 1);
				$("#p_dept_seq").val(node.data.dept_seq);

				var requestURL = "<c:url value="/users/department/departmentInsert.lin" />";
				resultCheckFunc($("#lform"), requestURL, function(response) {
					if (response.message != null) {
						alert(response.message);
					}
					if (response.code == '200') {
						reloadTree(node.getKeyPath());
						$("#insert_name").val("");
						$("#insert_id").val("");
					}
				});
			} else {
				return;
			}
		} else {
			alert('<spring:message code="users.department.list.insert.invalid.required.department" />');
		}
	}

	function mod() {
		var node = $("#tree").dynatree("getActiveNode");
		if (node) {
			if (confirm("<spring:message code="users.department.list.script.confirm.modify" />")) {
				var errmsg = new cls_errmsg();
				if ($("#update_name").val().empty()) {
					errmsg.append($("#update_name"), "<spring:message code="users.department.list.script.invalid.department.name" />");
				}
				if (errmsg.haserror) {
					errmsg.show();
					return;
				}

				$("#dept_nm").val($("#update_name").val());
				$("#dept_id").val(node.data.dept_id);
				$("#depth").val(node.data.depth);

				var requestURL = "<c:url value="/users/department/departmentUpdate.lin" />";
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
			alert('<spring:message code="users.department.list.script.invalid.select.department" />');
		}
	}

	function del() {
		var node = $("#tree").dynatree("getActiveNode");
		if (node) {
			if (node.data.dept_seq != null) {
				if (!confirm("<spring:message code="users.department.list.script.confirm.delete" />")) {
					return;
				}
				$("#dept_seq").val(node.data.dept_seq);
				$("#dept_id").val(node.data.dept_id);
				$("#p_dept_seq").val(node.data.p_dept_seq);

				var requestURL = "<c:url value="/users/department/departmentDelete.lin" />";
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
			alert('<spring:message code="users.department.list.script.invalid.select.department" />');
		}
	}

//-->
</script>
</head>

<body>

<form id="lform" name="lform" method="post" action="" onSubmit="return false;">
<input type="hidden" id="dept_nm" name="dept_nm">
<input type="hidden" id="dept_id" name="dept_id">
<input type="hidden" id="depth" name="depth" value="0">
<input type="hidden" id="dept_seq" name="dept_seq" value="0">
<input type="hidden" id="p_dept_seq" name="p_dept_seq" value="0">
<input type="hidden" id="forceDelete" name="forceDelete">

<!-- contents -->
<div id="content" class="clear_f">
	<h3><spring:message code="users.department.list.title" /></h3>
	<!-- 트리 영역 -->
	<div id="tree" class="tree_area mg_t20"></div>
	<!-- //트리 영역 -->
	<!-- 추가,수정,삭제영역 -->
	<div class="tree_left_con mg_t20">
		<form action="#">
		<fieldset>
		<legend>부서 추가 수정 삭제</legend>
		<!-- 부서 추가 -->
		<h4><spring:message code="users.department.list.insert.title" /></h4>
		<div class="box_type02 table_area_style04 mg_t8">
			<table cellspacing="0" cellpadding="0" summary="부서 추가 테이블입니다.">
				<caption>상위부서, 부서이름, 부서아이디</caption>
				<colgroup>
					<col style="width:30%;" />
					<col style="width:70%;" />
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="users.department.list.insert.parent" /></th>
						<td>
							<input type="text" class="text_input" id="insert_parent" name="insert_parent" disabled/>
						</td>
					</tr>
					<tr>
						<th><span class="chk_list"><spring:message code="users.department.list.insert.name" /></span></th>
						<td>
							<input type="text" class="text_input" id="insert_name" name="insert_name"/>
						</td>
					</tr>
					<tr>
						<th><span class="chk_list"><spring:message code="users.department.list.insert.id" /></span></th>
						<td>
							<input type="text" class="text_input" id="insert_id" name="insert_id"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_area_right pd_t8">
			<button type="submit" class="btn_add_st01" onClick="ins();">
				<span class="ir_desc"><spring:message code="users.department.list.insert.submit" /></span>
			</button>
		</div>
		<!-- //부서추가 -->
		<!-- 부서 수정,삭제 -->
		<h4 class="pd_t12">부서 수정 &amp; 삭제</h4>
		<div class="box_type02 table_area_style04 mg_t8">
			<table cellspacing="0" cellpadding="0" summary="부서 수정,삭제 테이블입니다.">
				<caption>선택부서, 변경할 부서 이름</caption>
				<colgroup>
					<col style="width:30%;" />
					<col style="width:70%;" />
				</colgroup>
				<tbody>
					<tr>
						<th><span class="chk_list"><spring:message code="users.department.list.modify.selected" /></span></th>
						<td>
							<input type="text" class="text_input" id="select_name" name="select_name" disabled/>
						</td>
					</tr>
					<tr>
						<th><span class="chk_list"><spring:message code="users.department.list.modify.changeName" /></span></th>
						<td>
							<input type="text" class="text_input" id="update_name" name="update_name"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_area_right pd_t8">
			<button type="submit" class="btn_modify_st01" onClick="mod();" style="margin-left:3px;">
				<span class="ir_desc"><spring:message code="users.department.list.modify.submit" /></span>
			</button>
			<button type="submit" class="btn_del_st01" onClick="del();" style="margin-left:3px;">
				<span class="ir_desc"><spring:message code="users.department.list.delete.submit" /></span>
			</button>
		</div>
		<!-- //부서 수정,삭제 -->
		</fieldset>
		</form>
	</div>
	<!-- //추가,수정,삭제영역 -->
</div>
<!-- //contents -->
</form>

</body>
</html>

