<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>

<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<script type="text/javascript">
	var delApprArr = {};
	var deptApprObj = {};
	var apprCnt = 0;

	$(function(){

		$("button#btnAllApproval").click(function(e) {
			var url = "<c:url value="/hr/user/approvalAllListPopup.lin" />";
			var attibute = "resizable=no,scrollbars=yes,width=775,height=690,top=5,left=5,toolbar=no,resizable=no";
			var popupWindow = window.open(url, "approvalListPopup", attibute);
			popupWindow.focus();
		});

	});
	
	function activeDeptApproval(event, data) {
		var node = data.node;
		if (node.isFolder()) {
			$("#dept_seq").val(node.data.dept_seq);
			$("#dept_nm").val(node.data.dept_nm);
			$("#deptNmSpan").html(node.data.dept_nm);
			initSearch();
			if("${auth_cd}" == 3) {
				var deptGroup = JSON.parse('${deptGroupList}');
				var chkGroupFlag = false;
				deptGroup.forEach(function(value, idx) {
					if(value.manage_value == data.node.data.dept_seq) {
						chkGroupFlag = true;
					}
				});
 				if(!chkGroupFlag) {
					alert('권한이 없는 부서입니다. \n권한 추가는 관리자에게 문의해주세요.');
					return false;
				}
				userDetail();
			} else {
				userDetail();
			}
		}
	}
	
	function initSearch() {
		$("#searchValue").val("");
		$("#incSubGroupChk").attr("checked", false);
		approvalManager.initApprover();
	}
	
	//부서 클릭 시 상세정보
	function userDetail() {
		var requestURL = "<c:url value="/hr/user/selectUserListJson.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var userList = response['userList'];
			var deptApprovalForm = response['deptApprovalForm'];
			
			$('.approvalTr').remove();
			apprCnt = 0;
			
			if(userList != null){
				var str = "";
				var appr_id = deptApprovalForm.appr_id;
				var app_id_Split = appr_id.split(',');
				
				if( userList == 'undefined' ||  userList.length == 0 ) {
					$('#approvalTbody').append("<tr class='approvalTr'><td colspan='6' style='text-align:center;'><div class='no_result'>결과가 없습니다.</div></td></tr>");
				} else {
					for (var i = 0; i < userList.length; i++) {
						var users_id = userList[i].appr_id;
						var users_nm = userList[i].users_nm;
						var dept_seq = userList[i].dept_seq;
						var position_nm = userList[i].position_nm;
						var job_nm = userList[i].job_nm;
						var use_yn = userList[i].use_yn;
						/* var status = userList[i].status; */
						var checked = "";
						
						if( delApprArr[dept_seq] == null || delApprArr[dept_seq] == 'undefined' || delApprArr[dept_seq] == '' ) delApprArr[dept_seq] = [];
						if( deptApprObj[dept_seq] == null || deptApprObj[dept_seq] == 'undefined' || deptApprObj[dept_seq] == '' ) deptApprObj[dept_seq] = new Object();
						
						if( app_id_Split.indexOf(users_id) != -1 ) {
							checked = ' checked="checked" ';
							approvalManager.addApproverUserElement(users_id, users_nm, dept_seq);
							apprCnt++;
						} 
						
						var notUsed = use_yn == 'N' ? "user-not-used" : "";  
						//결재자가 없어도 저장 되도록.
						str = str + "<tr class='approvalTr " + notUsed + "'><td class='t_center'><input type='checkbox' id='chk"+users_id+"' data-id='" + users_id + "' data-name='" + users_nm+ "' name='users_id' data-dept='" + dept_seq + "' onclick='approvalManager.addApprover(this)' value='"+users_id+','+users_nm+"' "+checked+"></td><td class='t_center'>"+users_nm+"</td><td class='t_center' data-seq='" + dept_seq + "'>"+userList[i].dept_nm+"</td><td class='t_center'>"+users_id+"</td><td class='t_center'>"+position_nm+"</td><td class='t_center'>"+job_nm+"</td></tr>";
					}
					$('#approvalTbody').append(str);
				}
			} else {
				$('#approvalTbody').append("<tr class='approvalTr'><td colspan='6' style='text-align:center;'><div class='no_result'>결과가 없습니다.</div></td></tr>");
			}

			$("#apprCntSpan").html( apprCnt );
		});
	}
	
	function onCheck(thiss){
		var chk = $(thiss).attr("checked");
		var users_id = $(thiss).val();
		
		if($('input:checkbox[name="users_id"]:checked').length == 0 ){
			alert('부서의 결재자가 지정되어야 합니다.');
			$(thiss).attr('checked',true);
		}
	}
	
	//fancytree end
	function save(){
		approvalManager.createApprList();
		
		if( ! checkBeforeSave() ) return;
		
		var requestURL = "<c:url value="/hr/user/insertApproval.lin" />";
		var successURL = "<c:url value="/hr/user/approvalManagement.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			var node = $("#tree").fancytree("getActiveNode");
			if( node && node.isLazy() ){
				node.lazyLoad();
			}

			if (code == '200') {
				alert(message);
				//$(location).attr("href", successURL);
				delApprArr = {};
			} else {
				alert(message);
			}
		}); 
		
	}
	
	function checkBeforeSave() {
		var deptApprs = JSON.parse($("#dept_apprs").val());
		var result = true;
		
		jQuery.map( delApprArr, function(n, i) {
			if( checkExistsPickApprover(n.join(',')) ) {
				result = false;
				return;
			}
		});
		
		return result;
	}
	
	function checkExistsPickApprover(users_ids) {
		var result = false;
		
		$.ajax({
			url: "/checkExistsPickApprover.lin?users_ids=" + users_ids + "&dept_seq=" + $("#dept_seq").val(),
			cache : false,
			async: false,
			success: function(response) {
				
				if(response == null || response == "") return;
				
				response = JSON.parse(response);
				
				if(response.msg != null) {
					alert(response.msg);
					result = true;
				} 
			}
		});
		
		return result;
	}

	$(document).ready(function() {
		checkFocusMessage($("#search"),"최대 15자까지 가능합니다.");
	});
	
	function ApprovalManager(){}
	var approvalManager = new ApprovalManager();
	
	ApprovalManager.prototype.searchApproval = function () {
		if($("#dept_seq").val().empty()) return alert("부서를 선택해주세요.");
		approvalManager.initApprover();
		userDetail();
	}
	
	ApprovalManager.prototype.addApprover = function (obj) {
		var id = $(obj).val().split(',')[0];
		var name = $(obj).val().split(',')[1];
		
		var deptTd = $(obj).parent().parent().children().eq(2);
		var deptSeq = deptTd.data('seq');
		var isExist = ( $("input[name='apprs']").filter("[value='" + id + "']").length > 0 );

		if( $(obj).is(":checked") ) {
			if( ! isExist ) {
				approvalManager.addApproverUserElement(id, name, deptSeq);
				approvalManager.controlApproverCount("up");
				approvalManager.pushApproverObj(deptSeq, id, name, "add");
				
				var index = delApprArr[deptSeq].indexOf(id);
				if( index > -1 ) delApprArr[deptSeq].splice(index, 1);
			}
		} else {
			if( isExist ) {
				var escapedId = approvalManager.escapeSelector(id);
				
				$('#apprs_'+ escapedId).parent().remove();
				approvalManager.deleteApprover(deptSeq, id);
				approvalManager.controlApproverCount('down');
				approvalManager.pushApproverObj(deptSeq, id, name, "remove");
			}
		}
	}
	
	ApprovalManager.prototype.pushApproverObj = function (deptSeq, id, name, type) {
		var apprObj = deptApprObj[deptSeq];
		var apprIdArr = null;
		var apprNmArr = null;
		
		if( apprObj != null && apprObj != "" && apprObj != 'undefined' ) {
			apprIdArr = apprObj.users_ids;
			apprNmArr = apprObj.users_nms;
			
			if( apprIdArr == null || apprIdArr == 'undefined' ) {
				apprIdArr = [];
				apprNmArr = [];
			}
		} else {
			deptApprObj[deptSeq] = new Object();
			apprIdArr = [];
			apprNmArr = [];
		}
		
		if (type == 'add') {
			apprIdArr.push(id);
			apprNmArr.push(name);
		} else if (type == 'remove'){
			var index = apprIdArr.indexOf(id);
			if( index > -1 ) {
				apprIdArr.splice(index, 1);
				apprNmArr.splice(index, 1);
			}
		}
		
		deptApprObj[deptSeq].users_ids = apprIdArr;
		deptApprObj[deptSeq].users_nms = apprNmArr;
	}
	
	ApprovalManager.prototype.deleteBtn = function (obj, id) {
		var escapedId = approvalManager.escapeSelector(id);
		
		$('#apprs_'+ escapedId).parent().remove();
		$('#chk' + escapedId).attr("checked", false);
		
		var deptSeq = $('#chk' + escapedId).data("dept");
		
		approvalManager.deleteApprover(deptSeq, id);
		approvalManager.controlApproverCount('down');
	}
	
	ApprovalManager.prototype.escapeSelector = function (selector) {
	    return selector.replace(/([!"#$%&'()*+,.\/:;<=>?@[\\\]^`{|}~])/g, '\\\\$1');
	}
	
	ApprovalManager.prototype.deleteApprover = function (deptSeq, id) {
		if( delApprArr[deptSeq] == null || delApprArr[deptSeq] == 'undefined' || delApprArr[deptSeq] == '' ) 
			delApprArr[deptSeq] = [];
		delApprArr[deptSeq].push(id);
	}
	
	ApprovalManager.prototype.addApproverUserElement = function (id, name, deptSeq) {
		var li = "<li><input type='hidden' value='" + id + "' name='apprs' data-name='" + name + "' /><span>" + name +
			"</span> <button class='btn_del' type='button' id='apprs_" + id +"' onclick=\"approvalManager.deleteBtn(this, '" + id + "')\"><span class='ir_desc'>삭제</span></button></li>";
		$('#selected_approver_list').append(li);
	}
	
	ApprovalManager.prototype.controlApproverCount = function (type) {
		apprCnt = (type == 'up') ? (apprCnt + 1) : (type == 'down') ? (apprCnt - 1) : apprCnt ;
		$("#apprCntSpan").html( apprCnt );
	}
	
	ApprovalManager.prototype.initApproverCount = function () {
		apprCnt = 0;
	}
	
	ApprovalManager.prototype.initApprover = function () {
		approvalManager.removeDeptApproverSection();
		approvalManager.initApproverCount();
		delApprArr = {};
		deptApprObj = {};
	}
	
	ApprovalManager.prototype.removeDeptApproverSection = function () {
		$("#selected_approver_list").html("");
	}
	
	ApprovalManager.prototype.createApprList = function () {
		$('#del_ids').val(JSON.stringify(delApprArr));
		$('#dept_apprs').val(JSON.stringify(deptApprObj));
		
	}
</script>
<style type="text/css">
.table_area_style02 table td {
	padding: 15px 5px 15px 5px;
}
.selected_approver_list {
	width: 100%;
}
ul.selected_approver_list li {
    float: left;
    margin-right: 5px;
    margin-top: 3px;
    padding: 5px;
    border: 1px solid #ddd;
    background-color: #fff;
    text-align: center;
}
.selected_approver_button {
	float:right;
}
.selected_appr_div {
	width:100%;
    height: 80px;
    overflow: auto;
}
.selected_appr_div .ulDeptDiv {
	display: table-row;
	margin-bottom: 5px;
}
#userListTableDiv {
	height: 430px;
	overflow: auto;
	/* background-color: #f9f9f9; */ 
}
</style>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/dept/deptManagement.lin" />">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<input type="hidden" id="dept_apprs" name="dept_apprs" value="" />
	<input type="hidden" id="del_ids" name="del_ids" value="" />
	<input type="hidden" id="chk_nm" name="chk_nm" value="" />
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">결재자 관리</h2>
				<p class="breadCrumbs">인사관리 > 결재자 관리</p>
			</div>
		</div>
		<div class="conWrap trisectionWrap">
		
			<!-- 부서 트리 include start -->
			<jsp:include page="/WebUI/hr/user/include/deptTreeList.jsp">
				<jsp:param name="activeMethod" value="activeDeptApproval(event, data);"/>
				<jsp:param name="section" value="approval"/>
			</jsp:include>		
			<!-- 부서 트리 include end -->
			
			<div class="conWrap trisection right">
				<h3>결재자 관리 &nbsp;|&nbsp;<span id="deptNmSpan" /></h3>
				<div class="conBox">
					<div class="mg_l7 mg_t10 mg_b5">
						<div class="mg_t5">
							<select id="searchCondition" name="searchCondition" title="확장자정책 검색조건">
								<option selected="selected" value="position_nm">${customfunc:getMessage('common.text.position_nm')}</option>
								<option value="job_nm">${customfunc:getMessage('common.text.job_nm')}</option>
								<option value="users_id">${customfunc:getMessage('common.id.commonid')}</option>
								<option value="users_nm">사용자명</option>
							</select>
							<input type="text" class="text_input" style="max-width:20%;" id="searchValue" name="searchValue" onkeypress="if(event.keyCode==13) {approvalManager.searchApproval(); return false;}" value="${fExtsMgtForm.searchValue}" onkeyup="onlySizeFillter(this,30)"/>
							<button class="btn_common theme mg_r10" onclick="approvalManager.searchApproval();">검색</button>
							<input type="checkbox" id="incSubGroupChk" name="incSubGroupChk" />
							<label for="isInSubGroupChk">하위 부서 구성원 포함</label>
						</div>
					</div>
					<div class="table_area_style02">
						<table summary="하위메뉴 권한설정" style="table-layout : fixed;">
						<caption>메뉴명,허용여부</caption>
							<colgroup>
								<col style="width:10%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
							</colgroup>
							<tbody>
								<tr class="Tborder">
									<th class="t_center" style="background-color: white;padding-top: 17px; padding-bottom: 15px;vertical-align: top;">
										결재자 목록<div class="mg_t5">(<span id="apprCntSpan">0</span>명)</div>
									</th>
									<td class="t_center" colspan="5" class="ulBox" style="padding-left:0px; padding-right:0px;">
										<div class="selected_appr_div" id="selected_appr_div">
											<ul class="selected_approver_list" id="selected_approver_list"></ul>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
						<table summary="하위메뉴 권한설정" style="table-layout : fixed;">
							<caption>메뉴명,허용여부</caption>
							<colgroup>
								<col style="width:10%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
							</colgroup>
							<tbody>
								<tr>
									<th class="t_center">결재자 선택</th>
									<th class="t_center">사용자명</th>
									<th class="t_center">부서명</th>
									<th class="t_center">${customfunc:getMessage('common.id.commonid')}</th>
									<th class="t_center">${customfunc:getMessage('common.text.position_nm')}</th>
									<th class="t_center">${customfunc:getMessage('common.text.job_nm')}</th>
								</tr>
							</tbody>
						</table>
					</div>
					<div id="userListTableDiv" class="table_area_style02 Bborder">
						<table summary="하위메뉴 권한설정" style="table-layout : fixed;">
							<colgroup>
								<col style="width:10%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
								<col style="width:20%;"/>
							</colgroup>
							<tbody id="approvalTbody">
								<tr class="approvalTr">
									<td colspan="6" style="text-align:center;"><div class="no_result">부서를 선택해주세요.</div></td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div class="btn_area_center mg_t10 mg_b10">
					<c:if test="${auth_cd != 4}">
						<button type="button" class="btn_common theme mg_l5" onclick="save()">저장</button>
					</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>