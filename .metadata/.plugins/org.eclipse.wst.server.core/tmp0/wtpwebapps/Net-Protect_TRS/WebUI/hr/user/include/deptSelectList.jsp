<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/css/approval/approvalPolicy.css?ver=018122100009"/>">
<script type="text/javascript">
var userCnt = 0;
var t_userBodyId = "usr_list_tbody";

$(document).ready(function() {
	changeApproverCount(t_userBodyId);
});

function add_dept(obj) {
	insert_row(t_userBodyId, obj);
	changeApproverCount(t_userBodyId);
}

function changeApproverCount(id) {
	$("#user-count").text( document.getElementById(id).rows.length );
}

function remove_selected_dept(target) {
	target.each(function() {
		$(this).parent().parent().remove();
	});
	changeApproverCount(t_userBodyId);
}

function existDeptList(deptSeq) {
	var flag = false;
	$("input[name='deptGroupList[]']").each(function() {
		if($(this).val() == deptSeq) {
			alert("지정된 부서 목록에 동일한 부서가 존재합니다.");
			flag = true;
		}
	});
	
	return flag;
}

function insert_row(id, obj, selector) {
	if ( ! checkSelectedDept(obj) ) return;
	
	var tbody = document.getElementById(id);
	var row = tbody.insertRow( tbody.rows.length );	//하단에 추가

	var cell1 = row.insertCell(0);
	var cell2 = row.insertCell(1);
	
	row.className = "sltd_usr_list";
	
	cell1.className = "usr_nm_td";
	cell1.innerHTML = "<input type='checkbox' name='deptGroupList[]' value='" + obj.dept_seq + 
		"' data-dept_seq='" + obj.dept_seq + "' ' /><span class='usr_nm'>" + obj.dept_nm +"</span>";
	
	cell2.className = "down_dept_td";
	cell2.innerHTML = "<input type='checkbox' class='chk_down_dept' name='down_dept_"+obj.dept_seq+"' id='down_dept' " + (obj.downGroup_yn == 'Y' ? ' checked' : '' ) + "/>";

	add_click_selection_action(row, "input[name=down_dept]");
	
	function checkSelectedDept( obj ) {
		if( ( obj == null ) || ( obj == '' ) || ( obj == 'undefined' ) || 
				( obj.dept_nm == null ) || ( obj.dept_nm == '') || ( obj.dept_nm == 'undefined' ) ) {
			alert("부서 목록에서 부서를 선택해주세요.");
			return false;
		}
		
		return true;
	}
}
</script>

<style>
.context-menu-selection {
    background-color: #507AAA !important;
    color: #f8f8f8 !important;
}
#down_dept {
	display: inherit
}
</style>

<%-- Action 추가하기 --%>
<jsp:include page="/WebUI/common/include/action/deptSelectEventManager.jsp" />
<%-- Action 추가하기  --%>
<td class=${ param.tdClass }>
	<div class="table_area_style02">
		<div class="outBox  user-list-outbox">
			<div class="conWrap user-list-conwrap">
				<h3>지정된 부서 (<span id="user-count">0</span>개)</h3>
				<div class="conBox user-list-conbox">
					<div class="user-list-content">
						<table id="sltd_usr_tbl" class="usr_con_tbl">
							<thead>
								<tr>
									<th class="con_hdr_h1">부서명</th>
									<th class="con_hdr_h2">하위부서포함</th>
								</tr>
							</thead>
							<tbody id="usr_list_tbody" >
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="bnt-ctrl">
				<button type="button" class="btn_add">
					&gt;
				</button>
				<button type="button" class="btn_remove">
					&lt;
				</button>
			</div>
		</div>
	</div>
</td>