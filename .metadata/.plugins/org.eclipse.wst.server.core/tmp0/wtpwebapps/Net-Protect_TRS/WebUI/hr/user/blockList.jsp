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

		$('#find_dept_nm').keypress(function(e) {
			if (e.which == 13) {
				findDept();
				return false;
			}
		});

		$("#find_dept_btn").click(function(e){
			$("#findDeptDiv").show();
		});

		$("#findDeptDivCloseBtn").click(function(e){
			findDeptDivClose();
		});

		$("#find_dept_div_btn").click(function(e){
			findDept();
		});
	});

	function findDeptDivClose() {
		$("#find_dept_nm").val("");
		$("#findUsersTable tbody tr").remove();
		$("#findUsersTable thead tr").remove();
		var findUsersTableHead = $("#findUsersTable thead");
		var findUsersTableHeadTr = "";
		findUsersTableHeadTr = '<tr> \n';
		findUsersTableHeadTr += '<th>부서</th> \n';
		findUsersTableHeadTr += '</tr> \n';
		findUsersTableHeadTr += '<tr style="height:35px;"> \n';
		findUsersTableHeadTr += '<td>부서를 검색하세요.</td> \n';
		findUsersTableHeadTr += '</tr> \n';
		style="color: black;cursor: pointer;"
		findUsersTableHead.append(findUsersTableHeadTr);
		$("#findDeptDiv").hide();
	}

	function insert(){
		var errmsg = new cls_errmsg();

		if ($("#users_id").val().empty()) {
			errmsg.append($("#users_id"), "<spring:message code="user.addUserlist.list.script.invalid.users_id" />");
		}

		if ($("#users_nm").val().empty()) {
			errmsg.append($("#users_nm"), "<spring:message code="user.addUserlist.list.script.invalid.users_nm" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		var requestURL = "<c:url value="/users/user/addUserInsert.lin" />";
		var successURL = "<c:url value="/users/user/addUserList.lin" />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}

	function del() {
		var errmsg = new cls_errmsg();

		if (!$(":checkbox[name=chk]").is(":checked")) {
			errmsg.append(null, "<spring:message code="user.addUserlist.list.script.required.delete" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		if (confirm("<spring:message code="user.addUserlist.list.script.confirm.delete" />")) {
			var requestURL = "<c:url value="/users/user/addUserDelete.lin" />";
			var successURL = "<c:url value="/users/user/addUserList.lin" />";
			resultCheck($("#lform"), requestURL, successURL, true);
		}
	}

	function search() {
		var errmsg = new cls_errmsg();

		if ($("#searchValue").val().empty()) {
			errmsg.append($("#searchValue"), "<spring:message code="user.addUserlist.list.script.invalid.query" />");
		}	

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		$("#lform").get(0).submit();
	}

	function insertDept(find_dept_seq, find_dept_nm) {
		$("#dept_id").val(find_dept_seq);
		$("#dept_seq").val(find_dept_seq);
		$("#dept_nm").val(find_dept_nm);
		findDeptDivClose();
	}

	function findDept() {
		var errmsg = new cls_errmsg();
		if ($("#find_dept_nm").val().empty()) {
			errmsg.append($("#find_dept_nm"), "<spring:message code="user.addUserlist.list.script.invalid.dept.query" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}
		var requestURL = "<c:url value="/users/department/findDept.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var deptList = response['deptList'];
			var findUsersTableBody = $("#findUsersTable tbody");
			var findUsersTableHead = $("#findUsersTable thead");
			$("#findUsersTable thead tr").remove();
			$("#findUsersTable tbody tr").remove();

			var dept = "";
			if (deptList.length > 0) {
				for (var i=0; i < deptList.length; i++) {
					dept = '<tr style="height:35px; "> \n';
					dept += '	<td onclick="insertDept(\''+deptList[i].dept_seq+'\',\''+deptList[i].dept_nm+'\');" id="'+deptList[i].dept_seq+'" style="cursor: pointer;">' + deptList[i].dept_nm + '</td> \n';
					dept += '</tr> \n';
					findUsersTableBody.append(dept);
				}
			} else {
				dept = '<tr style="height:35px; "> \n';
				dept += '<td>검색 결과가 없습니다.</td> \n';
				dept += '</tr> \n';
				findUsersTableHead.append(dept);
			}
		});
	}
</script>
</head>
<body>
<div id="contentPageHeader">
	<div id="contentPageTitle">
		<h3>관리자 추가</h3>
	</div>
	<div id="contentPageLocation">
		<ul>
			<li class="Lfirst"><span>자료전송</span></li>
			<li class="Llast"><span>자가결재 직급코드</span></li>
		</ul>
	</div>
</div>
<form name="lform" id="lform" method="post" action="<c:url value="/users/user/addUserList.lin" />" onSubmit="return false;">
<input id="page" name="page" type="hidden"/>
<input id="dept_seq" name="dept_seq" type="hidden"/>
<div class="optionArea2 table_area_style08" style="height: 27px; ">
	<table cellspacing="0" cellpadding="0" summary="자가결재 직위코드 추가 테이블입니다..">
	<caption>직위코드</caption>
		<colgroup>
				<col style="width:18%;" />
				<col style="width:17%;" />
			</colgroup>
			<tbody>
				<tr>
					<td>
						<label for="dept_nm"><spring:message code="user.addUserlist.list.insert.dept_nm" /></label>
						<input id="dept_nm" name="dept_nm" type="text" class="text_input" readonly/>
						<button type="button" id="find_dept_btn" class="btn_find_st02">
							<span class="ir_desc">찾기</span>
						</button>
					</td>
					<td>
						<button type="button" class="btn_add_st03 f_right mg_r15"  onClick="insert();">
							<span class="ir_desc"><spring:message code="user.addUserlist.list.insert.submit" /></span>
						</button>
					</td>
				</tr>
			</tbody>
	</table>
</div>

<div class="table_area_style01 pd_t30">
	<div class="top_con2">
		<button type="button" class="btn_i_del_st02 f_left va_middle" onclick="del();">
			<span class="ir_desc"><spring:message code="user.addUserlist.list.delete.submit" /></span>
		</button>
		<div class="search_box2 f_right pd_b5">
			<div class="select_layer select01" id="query">
				<a class="select_first" id="select_first"><spring:message code="user.addUserlist.list.search.select.name" /></a>
				<ul class="select_layer_list" id="queryList" style="display: none;" >
					<li>
						<a id="users_nm"><spring:message code="user.addUserlist.list.search.select.name" /></a>
					</li>
				</ul>
			</div>
			<input type="text" id="searchValue" name="searchValue" class="text_input mg_l5" value="${usersForm.searchValue }" style="width:150px"/>
			<button type="button" class="btn_search_st05" onClick="search()">
				<span class="ir_desc"><spring:message code="user.addUserlist.list.find.title" /></span>
			</button>
		</div>
	</div>
	<table cellspacing="0" cellpadding="0" summary="접속 추가 사용자관리 테이블입니다." style="table-layout : fixed">
	<caption>직번코드,이름,부서,결재권한</caption>
		<colgroup>
			<col style="width:5%;" />
			<col style="width:30%;" />
			<col style="width:15%;" />
			<col style="width:30%;" />
			<col style="width:35%;" />
		</colgroup>
		<thead>
			<tr>
				<th class="right_line"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
				<th class="right_line"><spring:message code="global.script.id" /></th>
				<th class="right_line"><spring:message code="user.addUserlist.list.insert.users_nm" /></th>
				<th class="right_line"><spring:message code="user.addUserlist.list.insert.dept_nm" /></th>
				<th class="right_line"><spring:message code="user.addUserlist.list.insert.approver_type" /></th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
			<c:when test="${not empty addUsersFormsList}">
			<c:forEach items="${addUsersFormsList}" var="usersForms">
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
					<td class="t_center">
						<spring:message code="user.addUserlist.list.auth_type_${usersForms.auth_type}" />
					</td>
				</tr>
			</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td class="t_center" colspan="5"><div class="no_result"><spring:message code="global.script.search.no.result" /></div></td>
				</tr>
			</c:otherwise>
			</c:choose>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="5" class="td_last">
					<span class="text_list_number"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></span>
					<div class="pagenate t_center">
						${pageList}
					</div>
				</td>
			</tr>
		</tfoot>
	</table>
</div>

<div id="findDeptDiv" class="popup findDept_wrap" style="display: none;">
	<div class="popupContentBox">
		<div class="findDept_Tbox">
			<input type="text" class="popup_input" id="find_dept_nm" name="find_dept_nm"/>
			<button type="button" class="btn_search_st04" id="find_dept_div_btn">
				<span class="ir_desc">검색</span>
			</button>
		</div>
		<div class="findDept_Bbox">
			<fieldset>
			<legend>부서 검색 결과</legend>
			<div class="address_find_area address_view_box" style="max-height:184px;">
				<table id="findUsersTable" cellspacing="0" cellpadding="0" summary="부서검색 결과 나오는 테이블">
				<caption>체크박스, 이름, 부서</caption>
					<colgroup>
						<col style="width:50%;" />
					</colgroup>
					<thead>
						<tr>
							<th>부서</th>
						</tr>
						<tr style="height:35px;">
							<td>부서를 검색하세요.</td>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
			</fieldset>
		</div>
		<div class="popup_bottom_btnArea">
			<button id="findDeptDivCloseBtn" type="button" class="btn_cancel_popup mg_l10 ">
				<span class="ir_desc">취소</span>
			</button>
		</div>
	</div>
</div>
</form>
</body>
</html>
