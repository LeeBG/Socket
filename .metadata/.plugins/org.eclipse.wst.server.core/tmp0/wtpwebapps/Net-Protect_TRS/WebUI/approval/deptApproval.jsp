<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<html>
<head>
<c:set var="loginUser" value="${sessionScope.loginUser}"/>
<link href="<c:url value="/Style/ui.fancytree_origin.css" />" rel="stylesheet" type="text/css"/>
<style type="text/css">
.tree_area {float: left;height: 440px;width: 395px;}
.tree_left_con {float: left;width: 790px;}
.tree_right_con {float: right;width: 395px;}
.min_h {min-height: 13px;}
ul.fancytree-container {
	background-color: white;
	border: 2px dotted gray;
	float: left;
	height: 365px;
	margin: 0;
	overflow: auto;
	padding: 3px;
	position: relative;
	white-space: nowrap;
	width: 97%;
}
</style>
<script type="text/javascript" src="<c:url value="/JavaScript/fancytree/jquery.fancytree.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/fancytree/jquery.fancytree.filter.js" />"></script>

<script type="text/javascript">

var treeData = ${deptTreeData};
var treeData2 = ${approverTreeData};

var select_dept_seqs = "";
var select_user_id = "";

	$(document).ready(function() {
		$('input[type="text"]').val('');

		$('#find_user_btn').click(function() {
			findUsers();
		});

	});

	var storeKey = null;

	$(document).ready(function() {
		$("#tree").fancytree({
			extensions: ["filter"],
			filter: {
				autoApply: true,  // Re-apply last filter if lazy data is loaded
				counter: true,  // Show a badge with number of matching child nodes near parent icons
				fuzzy: false,  // Match single characters in order, e.g. 'fb' will match 'FooBar'
				hideExpandedCounter: true,  // Hide counter badge, when parent is expanded
				highlight: true,  // Highlight matches by wrapping inside <mark> tags
				mode: "pass"  // Grayout unmatched nodes (pass "hide" to remove unmatched node instead)
			},
			quicksearch: true,
			checkbox: true,
			selectMode: 1,
			source : treeData,
			autoScroll: true,

			clickFolderMode: 2, // 1:activate, 2:expand, 3:activate and expand, 4:activate (dblclick expands)

			select: function(event, data) {
				// Get a list of all selected nodes, and convert to a key array:
				node = data.node;
				var selected = node.isSelected();

				var tree2 = $("#tree2").fancytree("getTree");

				tree2.visit(function(node){
					node.setSelected(false);
				});

				if (selected) {
					tree2.getNodeByKey(node.key).setExpanded(true);
					tree2.getNodeByKey(node.key).setActive(true);

					if (approverList) {
						for (var i=0; i < approverList.length; i++) {
							//alert(approverList[i].users_id  + " , " + approverList[i].users_nm);
							tree2.getNodeByKey(approverList[i].users_id).setSelected(true);
						}
					}
				}

				var approverList = node.data.approverList;
				if (approverList) {
					for (var i=0; i < approverList.length; i++) {
						$("#tree2").fancytree("getTree").getNodeByKey(approverList[i].users_id).setSelected(true);
					}
				}
				select_dept_seqs = $.map(data.tree.getSelectedNodes(), function(node){
					return node.key;
				});

				var select_dept_nms = $.map(data.tree.getSelectedNodes(), function(node){
					return node.data.dept_nm;;
				});

				$("#select_depts").text(select_dept_nms.join(", "));
			},

			keydown: function(event, data) {
				if( event.which === 32 ) {
					data.node.toggleSelected();
					return false;
				}
			},
			// The following options are only required, if we have more than one tree on one page:
//				initId: "treeData",
			cookieId: "fancytree-1",
			idPrefix: "fancytree-1-"
		});

		var tree1 = $("#tree").fancytree("getTree");

		$("#search_tree1").keyup(function(e){
			var n;
			var opts = {
					autoExpand: true,
					leavesOnly: false
				};
			var match = $(this).val();

			if(e && e.which === $.ui.keyCode.ESCAPE || $.trim(match) === ""){
				$("button#btnResetSearch1").click();
				return;
			}

			n = tree1.filterNodes(match, opts);

			$("button#btnResetSearch1").attr("disabled", false);
			$("span#match1").text("[" + n + "개 일치]");

		}).focus();

		$("button#btnResetSearch1").click(function(e){
			$("#search_tree1").val("");
			$("span#matches").text("");
			tree1.clearFilter();
			$("span#match1").text("[0개 일치]");
		}).attr("disabled", true);

		$("#tree2").fancytree({
			extensions: ["filter"],
			filter: {
				autoApply: true,  // Re-apply last filter if lazy data is loaded
				counter: false,  // Show a badge with number of matching child nodes near parent icons
				fuzzy: false,  // Match single characters in order, e.g. 'fb' will match 'FooBar'
				hideExpandedCounter: true,  // Hide counter badge, when parent is expanded
				highlight: true,  // Highlight matches by wrapping inside <mark> tags
				mode: "dimm"  // Grayout unmatched nodes (pass "hide" to remove unmatched node instead)
			},
			quicksearch: true,
			checkbox: true,
			selectMode: 2,
			source : treeData2,
			autoScroll: true,
			clickFolderMode: 2, // 1:activate, 2:expand, 3:activate and expand, 4:activate (dblclick expands)
			select: function(event, data) {
				if (data.tree.getSelectedNodes().length > 0) {
					select_user_id = $.map(data.tree.getSelectedNodes(), function(node){
						if (!node.isFolder()) {
							return node.key;
						}
					});
				} else {
					select_user_id = "";
				}
				//alert(select_user_id);
				// Display list of selected nodes
				/* var select_user_name;
				var select_user_dept_nm;
				var select_user_position;

				if (data.tree.getSelectedNodes().length > 0) {
					select_user_id = $.map(data.tree.getSelectedNodes(), function(node){
						if (!node.isFolder()) {
							return node.key;
						}
					});
					select_user_name = $.map(data.tree.getSelectedNodes(), function(node){
						if (!node.isFolder()) {
							return node.data.user_name + " (" + node.data.user_id + ")";
						}
					});
					select_user_dept_nm = $.map(data.tree.getSelectedNodes(), function(node){
						if (!node.isFolder()) {
							return node.data.dept_nm;
						}
					});
				select_user_position = $.map(data.tree.getSelectedNodes(), function(node){
						if (!node.isFolder()) {
							return node.data.user_position;
						}
					});
				} else {
					select_user_id = "";
					select_user_name = "부서관리자를 선택하세요";
					select_user_dept_nm = "부서관리자를 선택하세요";
					/* select_user_position = "부서관리자를 선택하세요";
				} */

				/* $("#select_user_name").text(select_user_name);
				$("#select_user_dept_nm").text(select_user_dept_nm);
				$("#select_user_position").text(select_user_position); */
			},
			click: function(event, data) {
				node = data.node;
				if (!node.isFolder()) {
					$("#select_user_name").text(node.data.user_name);
					$("#select_user_dept_nm").text(node.data.dept_nm);
					$("#select_user_position").text(node.data.user_position);
				}
			},
			keydown: function(event, data) {
				if( event.which === 32 ) {
					data.node.toggleSelected();
					return false;
				}
			},
			// The following options are only required, if we have more than one tree on one page:
//				initId: "treeData",
			cookieId: "fancytree-2",
			idPrefix: "fancytree-2-"
		});

		var tree2 = $("#tree2").fancytree("getTree");

		$("#search_tree2").keyup(function(e){
			var n;
			var opts = {
					autoExpand: true,
					leavesOnly: true
				};
			var match = $(this).val();

			if(e && e.which === $.ui.keyCode.ESCAPE || $.trim(match) === ""){
				$("button#btnResetSearch2").click();
				return;
			}

			n = tree2.filterNodes(match, opts);

			$("button#btnResetSearch2").attr("disabled", false);
			$("span#match2").text("[" + n + "개 일치]");
		}).focus();

		$("button#btnResetSearch2").click(function(e){
			$("#search_tree2").val("");
			$("span#matches").text("");
			tree2.clearFilter();
			$("span#match2").text("[0개 일치]");
		}).attr("disabled", true);
	});

	function setDeptApproval(){
		var errmsg = new cls_errmsg();

		if (!select_dept_seqs || !select_dept_seqs.length || select_dept_seqs.length == 0) {
			errmsg.append(null, "부서를 선택하세요");
		}
		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		//alert(select_user_id);
		if (confirm("부서관리자를 변경하시겠습니까?")) {
			$("#dept_seqs").val(select_dept_seqs.join(","));
			if (select_user_id != '') {
				$("#users_id").val(select_user_id.join(","));
			}

			var requestURL = "<c:url value="/approval/setDeptApproval.lin" />";
			var successURL = "<c:url value="/approval/deptApproval.lin" />";

			resultCheck($("#lform"), requestURL, successURL, true);
		} else {
			return;
		}
	}


	function deleteDeptApproval() {
		var errmsg = new cls_errmsg();

		if (!select_dept_seqs || !select_dept_seqs.length || select_dept_seqs.length == 0) {
			errmsg.append(null, "부서를 선택하세요");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		if (confirm("결재권을 회수 하시겠습니까?")) {
			$("#dept_seqs").val(select_dept_seqs.join(","));

			var requestURL = "<c:url value="/approval/deleteDeptApproval.lin" />";
			var successURL = "<c:url value="/approval/deptApproval.lin" />";

			resultCheck($("#lform"), requestURL, successURL, true);
		} else {
			return;
		}
	}
</script>
</head>
<body>
<!-- contents -->
<div id="contentPageHeader">
	<div id="contentPageTitle">
		<h3>부서관리자 지정</h3>
	</div>
	<div id="contentPageLocation">
		<ul>
			<li class="Lfirst"><span>자료전송</span></li>
			<li><span>자료전송 결재 관리</span></li>
			<li class="Llast"><span>부서 관리자 지정</span></li>
		</ul>
	</div>
</div>
<!-- 트리 영역 -->
<div class="tree_area mg_t20">
	<div class="table_area_style02">
		<table cellspacing="0" cellpadding="0" summary="사용자 추가 테이블입니다.">
			<tr><th><span>부서 선택</span>&nbsp;<span id="match1"></span></th></tr>
		</table>
	</div>
	<div id="tree" class="mg_t5"></div>
	<div class="table_area_style04 btn_area_left pd_t10" style="width:350px;">
		<table cellspacing="0" cellpadding="0" summary="부서 검색">
			<caption>설명, 사용자명, 찾기버튼</caption>
			<colgroup>
				<col style="width:25%;" />
				<col style="width:65%;" />
				<col style="width:10%;" />
			</colgroup>
			<tbody>
				<tr>
					<th><span class="list">부서 검색</span></th>
					<td>
						<input type="text" class="text_input" id="search_tree1" name="search_tree1"/>
					</td>
					<td>
						<button id="btnResetSearch1">&nbsp;&times;</button>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<div class="tree_area mg_t20">
	<div class="table_area_style02">
		<table cellspacing="0" cellpadding="0" summary="사용자 추가 테이블입니다.">
			<tr><th><span>부서관리자 선택</span>&nbsp;<span id="match2"></span></th></tr>
		</table>
	</div>
	<div id="tree2" class="mg_t5"></div>
	<div class="table_area_style04 btn_area_left pd_t10" style="width:350px;">
		<table cellspacing="0" cellpadding="0" summary="사용자 검색">
			<caption>설명, 사용자명, 찾기버튼</caption>
			<colgroup>
				<col style="width:25%;" />
				<col style="width:65%;" />
				<col style="width:10%;" />
			</colgroup>
			<tbody>
				<tr>
					<th><span class="list">사용자 검색</span></th>
					<td>
						<input type="text" class="text_input" id="search_tree2" name="search_tree2"/>
					</td>
					<td>
						<button id="btnResetSearch2">&nbsp;&times;</button>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<!-- //트리 영역 -->
<!-- 추가,수정,삭제영역 -->
<form id="lform" name="lform" method="post" action="" onSubmit="return false;">
<input type="hidden" id="dept_seqs" name="dept_seqs">
<input type="hidden" id="users_id" name="users_id">
<div class="tree_left_con mg_t10">
	<fieldset>
	<legend>부서 정보</legend>
	<!-- 사용자 추가 -->
	<div class="box_type02 table_area_style01">
		<table cellspacing="0" cellpadding="0" summary="사용자 추가 테이블입니다.">
			<caption>상위부서, 이름, 아이디, 패스워드, 패스워드 재입력, 권한</caption>
			<colgroup>
				<col style="width:40%;">
				<col style="width:30%;">
				<col style="width:30%;">
			</colgroup>
			<!-- <tbody>
				<tr>
					<th><span>선택 부서</span></th>
					<td><span id="select_depts" class="min_h">없음</span></td>
					<td>
						<button type="button" id="btnDeleteDeptApproval" class="btn_noImg" onclick="deleteDeptApproval();">
							<span>결재권 회수</span>
						</button>
					</td>
				</tr>
				<tr>
					<th><span>선택 부서관리자 성명</span></th>
					<td colspan="2"><span id="select_user_name" class="min_h">부서관리자를 선택하세요</span></td>
				</tr>
				<tr>
					<th><span>선택 부서관리자 직급</span></th>
					<td colspan="2"><span id="select_user_dept_nm" class="min_h">부서관리자를 선택하세요</span></td>
				</tr>
				<tr>
					<th><span>선택 부서관리자 부서</span></th>
					<td colspan="2"><span id="select_user_position" class="min_h">부서관리자를 선택하세요</span></td>
				</tr>
			</tbody> -->
			<tbody>
				<tr>
					<th><span>부서</span></th>
					<th><span>성명</span></th>
					<th><span>직급</span></th>
					<!-- <th><span id="select_depts" class="min_h">없음</span></td> -->
				</tr>
				<tr>
					<td><span id="select_user_dept_nm" class="min_h">선택 부서관리자 부서</span></td>
					<td><span id="select_user_name" class="min_h">선택 부서관리자 성명</span></th>
					<td><span id="select_user_position" class="min_h">선택 부서관리자 직급</span></th>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="btn_area_right pd_t8">
		<button type="submit" id="btnInsertDeptApproval" class="btn_noImg" onClick="setDeptApproval();">
			<span>부서관리자 지정</span>
		</button>
	</div>
	</fieldset>
</div>
</form>
<!-- //contents -->
</body>
</html>