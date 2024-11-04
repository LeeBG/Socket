<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<html>
<head>
<!-- style.css .optionArea{margin:15px 0 5px 0;}으로 변경 margin제외한 나머지는 기존과 동일 -->
<script type="text/javascript">
	$(document).ready(function() {
		$("#query").click(function(){
			$("#queryList").toggle();
		});

		$("#queryList > li > a").click(function(){
			$("#select_first").text($(this).text());
			$("#searchField").val($(this).attr('id'));
		});

		$('#searchValue').keypress(function(e) {
			if (e.which == 13) {
				search();
				return false;
			}
		});

		$('#find_user_nm').keypress(function(e) {
			if (e.which == 13) {
				findUser();
				return false;
			}
		});

		$("#find_user_btn").click(function(e){
			$("#findUserDiv").show();
		});

		$("#findUserDivCloseBtn").click(function(e){
			findUserDivClose();
		});

		$("#find_user_div_btn").click(function(e){
			findUser();
		});
	});

	function findUserDivClose() {
		$("#find_user_nm").val("");
		$("#findUsersTable tbody tr").remove();
		$("#findUsersTable thead tr").remove();
		var findUsersTableHead = $("#findUsersTable thead");
		var findUsersTableHeadTr = "";
		findUsersTableHeadTr = '<tr> \n';
		findUsersTableHeadTr += '<th>이름</th> \n';
		findUsersTableHeadTr += '</tr> \n';
		findUsersTableHeadTr += '<tr style="height:35px;"> \n';
		findUsersTableHeadTr += '<td>이름을 검색하세요.</td> \n';
		findUsersTableHeadTr += '</tr> \n';
		style="color: black;cursor: pointer;"
		findUsersTableHead.append(findUsersTableHeadTr);
		$("#findUserDiv").hide();
	}

	function insert(){
		var errmsg = new cls_errmsg();

		if ($("#users_id").val().empty()) {
			errmsg.append($("#users_id"), "<spring:message code="user.customUserList.list.script.invalid.users_id" />");
		}

		if ($("#users_nm").val().empty()) {
			errmsg.append($("#users_nm"), "<spring:message code="user.customUserList.list.script.invalid.users_nm" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		var requestURL = "<c:url value="/users/user/customUserInsert.lin" />";
		var successURL = "<c:url value="/users/user/customUserList.lin" />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}

	function del() {
		var errmsg = new cls_errmsg();

		if (!$(":checkbox[name=chk]").is(":checked")) {
			errmsg.append(null, "<spring:message code="user.customUserList.list.script.required.delete" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		if (confirm("<spring:message code="user.customUserList.list.script.confirm.delete" />")) {
			var requestURL = "<c:url value="/users/user/customUserDelete.lin" />";
			var successURL = "<c:url value="/users/user/customUserList.lin" />";
			resultCheck($("#lform"), requestURL, successURL, true);
		}
	}

	function search() {
		var errmsg = new cls_errmsg();

		if ($("#searchValue").val().empty()) {
			errmsg.append($("#searchValue"), "<spring:message code="user.customUserList.list.script.invalid.query" />");
		}	

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		$("#lform").get(0).submit();
	}

	function insertUser(find_users_id, find_user_nm) {
		$("#users_id").val(find_users_id);
		$("#users_nm").val(find_user_nm);
		findUserDivClose();
	}

	function findUser() {
		var errmsg = new cls_errmsg();
		if ($("#find_user_nm").val().empty()) {
			errmsg.append($("#find_user_nm"), "<spring:message code="user.customUserList.list.script.invalid.user.query" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}
		var requestURL = "<c:url value="/users/user/findUser.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var userList = response['userList'];
			var findUsersTableBody = $("#findUsersTable tbody");
			var findUsersTableHead = $("#findUsersTable thead");
			$("#findUsersTable thead tr").remove();
			$("#findUsersTable tbody tr").remove();

			var user = "";
			////////////////////////////////////////
			if (userList && userList.length > 0) {
				for (var i=0; i < userList.length; i++) {
					var dept_seq_tree = "/";
					dept_seq_tree = response[userList[i].dept_seq];
					user = '<tr> \n';
//					user += '	<td onclick="insertUser(\''+userList[i].users_id+'\',\''+userList[i].users_nm+'\');" id="'+userList[i].dept_seq+'" style="cursor: pointer;">' + userList[i].users_nm + '</td> \n';
					user += '	<td onclick="insertUser(\''+userList[i].users_id+'\',\''+userList[i].users_nm+'\');" id="'+userList[i].dept_seq+'" style="cursor: pointer;">' + dept_seq_tree + userList[i].users_nm + '</td> \n';
					user += '</tr> \n';
					findUsersTableBody.append(user);
				}
			} else {
				user = '<tr style="height:35px; "> \n';
				user += '<td>검색 결과가 없습니다.</td> \n';
				user += '</tr> \n';
				findUsersTableHead.append(user);
			}
		});
	}
</script>
</head>
<body>
<div id="contentPageHeader">
	<div id="contentPageTitle">
		<h3>결재자 추가</h3>
	</div>
	<div id="contentPageLocation">
		<ul>
			<li class="Lfirst"><span>자료전송</span></li>
			<li class="Llast"><span>결재자 추가</span></li>
		</ul>
	</div>
</div>
<form name="lform" id="lform" method="post" action="<c:url value="/users/user/customUserList.lin" />" onSubmit="return false;">
<input id="page" name="page" type="hidden"/>
<input id="users_id" name="users_id" type="hidden"/>
<div class="optionArea2 table_area_style08" style="height: 27px; ">
	<table cellspacing="0" cellpadding="0" summary="접속 사용자 추가 테이블입니다..">
	<caption>직번, 이름, 부서, 결재권한</caption>
		<colgroup>
				<col style="width:50%;" />
				<col style="width:50%;" />
			</colgroup>
			<tbody>
				<tr>
					<td>
						<label for="users_nm"><spring:message code="user.customUserList.list.insert.users_nm" /></label>
						<input id="users_nm" name="users_nm" type="text" class="text_input" readonly/>
						<button type="button" id="find_user_btn" class="btn_find_st02">
							<span class="ir_desc">찾기</span>
						</button>
					</td>
					<td>
						<button type="button" class="btn_add_st03 f_right mg_r15"  onClick="insert();">
							<span class="ir_desc"><spring:message code="user.customUserList.list.insert.submit" /></span>
						</button>
					</td>
				</tr>
			</tbody>
	</table>
</div>

<div class="table_area_style01 pd_t30">
	<div class="top_con2">
		<button type="button" class="btn_i_del_st02 f_left va_middle" onclick="del();">
			<span class="ir_desc"><spring:message code="user.customUserList.list.delete.submit" /></span>
		</button>
		<div class="search_box2 f_right pd_b5">
			<div class="select_layer select01" id="query">
				<a class="select_first" id="select_first"><spring:message code="user.customUserList.list.search.select.name" /></a>
				<ul class="select_layer_list" id="queryList" style="display: none;" >
					<li>
						<a id="users_nm"><spring:message code="user.customUserList.list.search.select.name" /></a>
					</li>
				</ul>
			</div>
			<input type="text" id="searchValue" name="searchValue" class="text_input mg_l5" value="${usersForm.searchValue }" style="width:150px"/>
			<button type="button" class="btn_search_st05" onClick="search()">
				<span class="ir_desc"><spring:message code="user.customUserList.list.find.title" /></span>
			</button>
		</div>
	</div>
	<table cellspacing="0" cellpadding="0" summary="접속 추가 사용자관리 테이블입니다." style="table-layout : fixed">
	<caption>직번코드,이름,부서,결재권한</caption>
		<colgroup>
			<col style="width:5%;" />
			<col style="width:20%;" />
			<col style="width:15%;" />
			<col style="width:75%;" />
		</colgroup>
		<thead>
			<tr>
				<th class="right_line"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
				<th class="right_line"><spring:message code="global.script.id" /></th>
				<th class="right_line"><spring:message code="user.customUserList.list.insert.users_nm" /></th>
				<th class="right_line"><spring:message code="user.customUserList.list.insert.dept_nm" /></th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
			<c:when test="${not empty customUsersFormsList}">
			<c:forEach items="${customUsersFormsList}" var="usersForms">
				<tr id="tr_id_${usersForms.users_id}">
					<td class="right_line t_center"><input type="checkbox" class="input_chk" name="chk" id="chk" value="${usersForms.users_id}" /></td>
					<td class="right_line t_center">
						<c:out value="${usersForms.users_id}"/>
					</td>
					<td class="right_line t_center">
						<c:out value="${usersForms.users_nm}"/>
					</td>
					<td class="right_line t_center">
						<c:out value="${usersForms.dept_nm}"/>
					</td>
				</tr>
			</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td class="t_center" colspan="4"><div class="no_result"><spring:message code="global.script.search.no.result" /></div></td>
				</tr>
			</c:otherwise>
			</c:choose>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="4" class="td_last">
					<span class="text_list_number"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></span>
					<div class="pagenate t_center">
						${pageList}
					</div>
				</td>
			</tr>
		</tfoot>
	</table>
</div>
<div id="findUserDiv" class="popup findDept_wrap" style="display: none;">
	<div class="popupContentBox">
		<div class="findDept_Tbox">
			<input type="text" class="popup_input" id="find_user_nm" name="find_user_nm"/>
			<button type="button" class="btn_search_st04" id="find_user_div_btn">
				<span class="ir_desc">검색</span>
			</button>
		</div>
		<div class="findDept_Bbox">
			<fieldset>
			<legend>이름 검색 결과</legend>
			<div class="address_find_area address_view_box" style="max-height:184px;">
				<table id="findUsersTable" cellspacing="0" cellpadding="0" summary="이름검색 결과 나오는 테이블">
				<caption>이름</caption>
					<colgroup>
						<col style="width:50%;" />
					</colgroup>
					<thead>
						<tr>
							<th>이름</th>
						</tr>
						<tr style="height:35px;">
							<td>이름을 검색하세요.</td>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
			</fieldset>
		</div>
		<div class="popup_bottom_btnArea">
			<button id="findUserDivCloseBtn" type="button" class="btn_cancel_popup mg_l10 ">
				<span class="ir_desc">취소</span>
			</button>
		</div>
	</div>
</div>
</form>
</body>
</html>
