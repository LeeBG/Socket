<%@ page contentType="text/html; charset=utf-8"%>

<script type="text/javascript">
$(document).ready(function() {
	prepareEvent();
});

function prepareEvent() {
	var t1 = document.getElementsByClassName("btn_add")[0];
	var t2 = document.getElementsByClassName("btn_remove")[0];

	t1.addEventListener('click', click_add_approval_line_user);
	t2.addEventListener('click', remove_approval_line_user);
}

function add_click_selection_action(row, selector) {
	$(selector).click(function() { event.stopPropagation(); });
	row.onclick = (function() { select_user_row($(this)); });
}

function select_user_row(obj) {
	var class_name = "context-menu-selection";
	obj.toggleClass(class_name);
	
	var checkbox = obj.find("input[name='appLineUserList_${np_cd}[]']");
	checkbox.prop('checked', obj.hasClass(class_name));
}

function click_add_approval_line_user() {
	var userid = $("#users_id").val();
	
	if( is_not_select_user(userid) ) return;
	if(existApproverList(userid)) return;
		
	var obj = new Object();
	obj.users_id = $("#users_id").val();
	obj.users_nm = $("#users_nm").val();
	obj.dept_seq = $("#dept_seq").val();
	obj.dept_nm = $("#dept_nm").val();
	
	add_approval_line_user(obj);
}

function is_not_select_user(userid){
	if( userid == ''){
		alert('결재자 목록에 선택된 사용자가 없습니다.');
		return true;
	}
	return false;
}

function remove_approval_line_user() {
	var rm_target = $("input[name='appLineUserList_${np_cd}[]']:checked");
	
	if (rm_target.length < 1) {
		alert("삭제할 사용자를 선택해주세요.");
		return;
	}
	
	if(confirm('지정결재자를 제거하겠습니까?')) remove_selected_user(rm_target);
}

</script>