<%@ page contentType="text/html; charset=utf-8"%>

<script type="text/javascript">
$(document).ready(function() {
	prepareEvent();
});

function prepareEvent() {
	var t1 = document.getElementsByClassName("btn_add")[0];
	var t2 = document.getElementsByClassName("btn_remove")[0];

	t1.addEventListener('click', click_add_dept);
	t2.addEventListener('click', remove_dept);
}

function add_click_selection_action(row, selector) {
	$(selector).click(function() { event.stopPropagation(); });
	row.onclick = (function() { select_user_row($(this)); });
}

function select_user_row(obj) {
	var class_name = "context-menu-selection";
	obj.toggleClass(class_name);
	
	var checkbox = obj.find("input[name='deptGroupList[]']");
	checkbox.prop('checked', obj.hasClass(class_name));
}

function click_add_dept() {
	var deptSeq = $("#dept_seq").val();
	if(existDeptList(deptSeq)) return;
	var obj = new Object();
	obj.dept_seq = $("#dept_seq").val();
	obj.dept_nm = $("#dept_nm").val();
	obj.downGroup_yn = 'Y';
	
	add_dept(obj);
}

function remove_dept() {
	var rm_target = $("input[name='deptGroupList[]']:checked");
	
	if (rm_target.length < 1) {
		alert("삭제할 부서를 선택해주세요.");
		return;
	}
	
	if(confirm('부서를 제거하겠습니까?')) remove_selected_dept(rm_target);
}

</script>