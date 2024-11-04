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

function add_approval_line_user(obj) {
	insert_row(t_userBodyId, obj);
	changeApproverCount(t_userBodyId);
}

function changeApproverCount(id) {
	$("#user-count").text( document.getElementById(id).rows.length );
}

function getApproverObject(v) {
	var obj = new Object();
	
	obj.users_id = v["users_id"];
	obj.users_nm = v["users_nm"];
	obj.dept_seq = v["dept_seq"];
	obj.default_yn = v["defaultUserYn"];
	obj.use_yn = v["use_yn"];
	obj.cud_cd = v["cud_cd"];
	
	return obj;
}

function remove_selected_user(target) {
	target.each(function() {
		$(this).parent().parent().remove();
	});
	changeApproverCount(t_userBodyId);
}

function existApproverList(userId) {
	var flag = false;
	
	$("input[name='appLineUserList_${np_cd}[]']").each(function() {
		if($(this).val() == userId) {
			alert("지정된 결재자 목록에 동일한 사용자가 존재합니다.");
			flag = true;
		}
	});
	
	return flag;
}

function insert_row(id, obj, selector) {
	if ( ! checkSelectedUser(obj) ) return;
	
	var tbody = document.getElementById(id);
	var row = tbody.insertRow( tbody.rows.length );	//하단에 추가

	var cell1 = row.insertCell(0);
	var cell2 = row.insertCell(1);
	
	row.className = "sltd_usr_list";
	
	cell1.className = "usr_nm_td";
	cell1.innerHTML = "<input type='checkbox' name='appLineUserList_${np_cd}[]' value='" + obj.users_id + "' data-users_nm='" + obj.users_nm
		+ "' data-dept_seq='" + obj.dept_seq + "' ' /><span class='usr_nm'>" + obj.users_nm + "(" + obj.users_id + ")"
		+ ( isDisableUser(obj) ? "(비활성화)" : "" ) +  "</span>";
	
	cell2.className = "dft_appr_td";
	cell2.innerHTML = "<input type='radio' name='dft_appr' id='dft_appr_" + obj.users_id + "' " + (obj.default_yn == 'Y' ? ' checked' : '' ) + "/>";

	add_click_selection_action(row, "input[name=dft_appr]");
	
	function checkSelectedUser( obj ) {
		if( ( obj == null ) || ( obj == '' ) || ( obj == 'undefined' ) || 
				( obj.users_id == null ) || ( obj.users_id == '') || ( obj.users_id == 'undefined' ) ) {
			alert("사용자 목록에서 사용자를 선택해주세요.");
			return false;
		}
		
		return true;
	}
	
	function isDisableUser(obj) {
		return (obj.use_yn == "N" || obj.cud_cd == "D");
	}
}

function validateAppLineUser() {
	if( ( $("input[name='dft_appr']:checked").length < 1 ) ) {
		alert("기본결재자를 선택해주세요");
		return false;
	}
	
	return true;
}
</script>

<style>
.context-menu-selection {
    background-color: #507AAA !important;
    color: #f8f8f8 !important;
}
</style>

<%-- Action 추가하기 --%>
<jsp:include page="/WebUI/common/include/action/userSelectEventManager.jsp" />
<%-- Action 추가하기  --%>
<td class=${ param.tdClass }>
	<div class="table_area_style02">
		<div class="outBox  user-list-outbox">
			<div class="conWrap user-list-conwrap">
				<h3>지정된 결재자 (<span id="user-count">0</span>명)</h3>
				<div class="conBox user-list-conbox">
					<div class="user-list-content">
						<table id="sltd_usr_tbl" class="usr_con_tbl">
							<thead>
								<th class="con_hdr_h1">사용자명(${customfunc:getMessage('common.id.commonid')})</th>
								<th class="con_hdr_h2">기본결재자</th>
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