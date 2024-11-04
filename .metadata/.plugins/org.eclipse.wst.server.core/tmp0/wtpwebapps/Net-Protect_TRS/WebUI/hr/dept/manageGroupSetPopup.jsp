<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="deptGroupList" value="${deptGroupList}"/>
<html>
<head>
<title>관리자 그룹 설정</title>
</head>

<script type="text/javascript">
var ckName = "deptGroupList";

$(document).ready(function() {

	setDeptGroupData();
	$('#dept_add').css("display", "none");
	$('#dept_del').css("display", "none");
});

function setDeptGroupData() {
	var deptGroup = JSON.parse('${deptList}');
	deptGroup.forEach(function(value, idx) {
		loadDeptGroupData(value);
	});
	changeApproverCount(t_userBodyId);
}

function loadDeptGroupData(value) {
	var tbody = document.getElementById(t_userBodyId);
	var row = tbody.insertRow( tbody.rows.length );
	
	var cell1 = row.insertCell(0);
	var cell2 = row.insertCell(1);

	row.className = "sltd_usr_list";

	cell1.className = "usr_nm_td";
	cell1.innerHTML = "<input type='checkbox' name='deptGroupList[]' value='" + value.manage_value + 
		"' data-dept_seq='" + value.seq + "' ' /><span class='usr_nm'>" + value.dept_nm +"</span>";
	
	cell2.className = "down_dept_td";
	cell2.innerHTML = "<input type='checkbox' class='chk_down_dept' name='down_dept_"+value.manage_value+"' id='down_dept' " + (value.down_dept_yn == 'Y' ? ' checked' : '' ) + "/>";

	add_click_selection_action(row, "input[name=down_dept]");
}

function saveDept() {
	var cnt = 0;
	var items = new Array();
	var obj, value;
	
	for( var i = 0 ; i< document.getElementById(t_userBodyId).rows.length; i++ ) {
		obj = {};
		obj["manageValue"] = $("[name='" + ckName + "[]']").eq(cnt).val();
		obj["downDeptYn"] = $("[name='down_dept_" + obj["manageValue"] + "']").is(":checked") ? "Y" : "N";
		
		cnt++;
		items.push(obj);
	}
	
	if(confirm("부서 그룹 설정하시겠습니까?" ) ){
		$("#admin_id").val('${admin_id}');
		$("#items").val(JSON.stringify(items));
		var requestURL = "<c:url value="/hr/dept/insertDeptGroupSet.lin" />";
		var successURL = "<c:url value="/hr/dept/manageGroupSetPopup.lin" />";

		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			if (code == '200') {
				alert(message);
			} else {
				alert(message);
			}
		});
	}
}

function activeDept(event, data) {
	var node = data.node;
	
	$("input[type=text]").val("");
	$("#dept_seq").val(node.data.dept_seq);
	$("#dept_nm").val(node.data.dept_nm);
}

function self_close(){
	self.opener = self;
	window.close();
}
</script>
<style>
.popWrapCustom {
	overflow: hidden;
	border: none;
}
.outBox{width:50%; float:left}
</style>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/dept/manageGroupSetPopup.lin" />">
	<input id="dept_seq" name="dept_seq" type="hidden" value = ""/>
	<input id="dept_nm" name="dept_nm" type="hidden" value = ""/>
	<input id="admin_id" name="admin_id" type="hidden" value = ""/>
	<input id="items" name="items" type="hidden" value = ""/>
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="wrap">
		<div class="popWrap trisectionWrap">
			<h3>관리 그룹 설정</h3>
			<div class="apprcode_wrap">
				<input type="radio" name="deptGroup" id="deptGroup" value="deptGroup" checked disabled="disabled"><label for="deptGroup">부서 </label>
			</div>
			<div id="deptGroupDiv">
				<div class="popWrapCustom popWrap trisectionWrap" style="margin: 0px auto;">
					<!-- 부서 트리 include start -->
					<jsp:include page="/WebUI/hr/user/include/deptTreeList.jsp">
						<jsp:param name="activeMethod" value="activeDept(event, data);"/>
						<jsp:param name="section" value="dept"/>
						<jsp:param name="inputInvisible" value="Y" />
						<jsp:param value="activeApprover(event, data);" name="activeUserMethod"/>
						<jsp:param value="beforeActiveDeptNodeMethod(event, data);" name="beforeActiveDeptNodeMethod"/>
					</jsp:include>	
					<!-- 부서 트리 include end -->
		
					<div class="trisection right">
						<jsp:include page="/WebUI/hr/user/include/deptSelectList.jsp" flush="false">
							<jsp:param name="tdClass" value="Rborder" />
						</jsp:include> 
					</div>
				</div>
			</div>
		</div>
		<div class="btn_area_center mg_t10 mg_b10">
			<button type="button" class="btn_big theme" onclick="saveDept();">확인</button>
			<button type="button" class="btn_big" onclick="javascript:self_close();">닫기</button>
		</div>
	</div>
</form>
</body>
</html>
