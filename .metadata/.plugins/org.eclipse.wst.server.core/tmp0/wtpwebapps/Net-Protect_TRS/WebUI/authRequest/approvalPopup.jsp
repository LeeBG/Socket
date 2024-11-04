<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="approvalPolicy" value="${loginUser.approvalPolicy}" />
<c:set var="isApprovalUse" value="${approvalPolicy.approvalUse}" />
<c:set var="networkPosition" value="${customfunc:getNetworkPosition() }"/>

<script type="text/javascript">
var app_level = "${approvalLineLevel}";
var appSeq = "<c:out value="${approvalLineInfo[0].appSeq}"/>";
var selectedApprover = null;
var approver = new Array();
var approverArray = new Array();
var approverList;

$(document).ready(function() {
	init();
	setParentApprover();
	
	$("#app_line_level_select").on("change", function(event) { 
		try{
			changeApproverList($(this).find(":selected"), event); 
		} catch(e) {
			console.log(e);
		}
	});
});

function init() {
	for(var i = 0; i < app_level; i++) {
		approver[i] = null;
		approverArray[i] = new Array();
	}
	
	changeApproverList($("select[name='app_line_level_select").find("#1"), event); 
}

function setApprovalLineInfo(obj, event) {
	var appLineInfo;
	$.ajax({
		url: "/approvalLineInfo.lin?level=" + obj.val() + "&appSeq=" + appSeq,
		cache : false,
		success: function(data) {
			if(data == null || data == "") return;
			
			appLineInfo = JSON.parse(data);
			setApprovalLineCd(appLineInfo, obj);
		}
	});
}

function changeApproverList(obj, event) {
	var tableId = "tbl-approver-list";
	approverList = null;
	var level = obj.val();
	var deptSeq = obj.data("dept-seq");
	var levelCd = obj.data("app-line-cd");
	
	if( levelCd == 'DEP' && 
		( deptSeq == null || deptSeq == '' || deptSeq =='undefined' ) || ( levelCd == null || levelCd == '' || levelCd =='undefined' ) ) return;
	if( levelCd == 'PICK') level = obj.data("org-app-level");
	
	$.ajax({
		url: "/approvalLineApprover.lin?level=" + level + "&deptSeq=" + deptSeq + "&levelCd=" + levelCd,
		cache : false,
		async : false,
		success: function(data) {
			
			if(data == null || data == "" || data == "[]") {
			 	displayEmptyApprover(tableId); 
				setApprovalLineInfo(obj, event); 
				return;
			}
			
			approverList = JSON.parse(data);
			
			displayApproverList(approverList, tableId, level, obj.get(0).id - 1);
			
			setApprovalLineInfo(obj, event); 
		}
	});
}

function displayEmptyApprover(tableId) {
	$("#" + tableId + " > tbody").empty();
	
	var tbody = document.getElementById(tableId + "-tbody");
	var row = tbody.insertRow( tbody.rows.length );	//하단에 추가
	var cell = new Array();
	
	cell[0] = row.insertCell(0);
	cell[0].colSpan = 4;
	cell[0].className = "t_center";
	cell[0].innerHTML = "결재자가 설정되어있지 않습니다. 관리자에게 문의하세요.";
}

function displayApproverList(appList, tableId, level, index) {
	var row = new Array();
	var cell = new Array();
	
	$("#" + tableId + " > tbody").empty();
	
	approverList.forEach(function(value, idx) {
		var tbody = document.getElementById(tableId + "-tbody");
		var row = tbody.insertRow( tbody.rows.length );	//하단에 추가
		var cell = new Array();
		var checked ;

		try {
			checked = ( value.users_id == approver[index].users_id ) ? " checked" : "";
		} catch(e) { }
		
		
		for(var i=0; i<4; i++)
			cell[i] = row.insertCell(i);
		
		cell[0].className = "td_chekbox Rborder t_center";
		cell[0].innerHTML = "<input type='radio' name='radio_approver' class='input_chk' name='chk' onclick=\"selectApprover('" + value.users_id + "', '" + value.users_nm  + "');\"" + checked + " / >";
		
		cell[1].className = "t_center Rborder";
		cell[1].innerHTML = value.users_nm;
		
		cell[2].className = "t_center Rborder";
		cell[2].innerHTML = value.position_nm;
		
		cell[3].className = "t_center";
		cell[3].innerHTML = ( value.dept_nm == null || value.dept_nm == "undefined") ? "" : value.dept_nm;
	});
}

function setApprovalLineCd(appLineInfo, obj) {
	$("#appLineCdName").text(appLineInfo.appLineCdName);
	if (appLineInfo.appLineCd == "DEP") {
		$("#appLineDetail").show();
		
		var param = new Object();
		param.deptSeq = obj.data("dept-seq");
		
		$.ajax({
			url: "/hr/dept/findDept.lin",
			cache : false,
			async : false,
			type: "post",
			headers: { 
		        "Content-Type": "text/plain; charset=utf-8"
		    },
			data: JSON.stringify(param),
			success: function(data) {
				if(data == null || data == "" || data == "[]") {
					$("#appLineDept").text("결재자를 선택해주세요.");
					return;
				}
				
				$("#appLineDept").text(JSON.parse(data).dept_nm);
			}
		});
	}
	else $("#appLineDetail").hide();
}

function setParentApprover() {
	var pApproverArray = $(opener.document).find("#approverArray").val();
	jpApprover = (pApproverArray != null && pApproverArray != "") ? JSON.parse(pApproverArray) : new Array() ;
	
	var index;
	var count;
	jpApprover.forEach(function(user, i) {
		count = $(opener.document).find("#approver" + user.line_level).data("count");
		index = count - 1;
		
		setApproverHtml(user, count);
		approver[index] = user;
		approver[index].order = user.line_level;
		
		approverArray[index] = approver[index];
	});
	
	try{
		$("#tbl-approver-list-tbody input[data-user-id='" + approver[0].users_id + "']").eq(0).attr("checked", true);
	} catch(e) { }
}

function setApprover(obj) {
	var errmsg = new cls_errmsg();
	var order = obj.get(0).id;
	var level = obj.val();
	var index = order - 1;
	
	if(selectedApprover != null){
		setApproverHtml(selectedApprover, order);
		approver[index] = selectedApprover;
		approver[index].order = level;
		approver[index].line_level = level;
		
		approverArray[index] = approver[index];
	}
}

function checkSetApprovers() {
	var errmsg = new cls_errmsg();
	var msg = "";
	for(var i = 0; i < app_level; i ++){
		msg = "";
		
		if (approver[i] == null) msg = ( (app_level == 1) ? "" : (i + 1) ) + "차 결재자를 지정하세요";
		
		if(msg != "") errmsg.append(null, msg);
	}
	
	if (errmsg.haserror) {
		errmsg.show();
		return false;
	}
	
	return true;
}

function ok() {
	
	if (checkSetApprovers() == false) return;
	
	var approverArray = new Array();
	
	for(var i = 0; i < app_level; i++){
		if (approver[i] != null) {
			$(opener.document).find('#approver' + approver[i].line_level).html(approver[i].users_nm);
			approverArray.push(approver[i]);
		} 
	}
	$("#approverArray", opener.document).val( (approverArray.length > 0) ? JSON.stringify(approverArray) : "" );

	<c:if test="${approvalPolicy.self_app_yn eq 'Y'}">
	$("#selfApproval", opener.document).attr("checked", false);
	</c:if>
	window.close();
};

function selectApprover(users_id, users_nm) {
	var approverObj = new Object();
	approverObj.users_id = users_id;
	approverObj.users_nm = users_nm;

	selectedApprover = approverObj;
	setApprover($("#app_line_level_select").find(":selected"));
	
	<c:if test="${approvalLineLevel == 1}">
		approver[0] = selectedApprover;
		setApproverHtml(approver[0], '1');
	</c:if>
}

function setApproverHtml(approver, ord) {
	$('#approverSpan' + ord + '').html(approver.users_nm);
}
</script>
<style>
#level-cd-div {
	width: 60%;
	right: 20%;
}

#level-select {
	width: 18%; 
	right: 0;
}
#appLineCdName {
	font-weight: 700;
}
</style>
</head>
<body>
		<div class="popWrap">
			<h3>결재자 선택</h3>
			<div class="conBox" style="overflow:hidden;">
				<div class="popCon">
					<div class="table_area_topCon mg_t15 mg_b5" style="overflow:hidden; margin: 0px; padding: 10px 0; line-height:normal;">
						<div class="f_left mg_l5 pd_t5">
						<c:choose>
							<c:when test="${approvalLineLevel == 1}">
								<span class="text_bold mg_l15">· 결재자 : 
									<span class="nameBox" id="approverSpan1">결재자를 선택해주세요.</span>
								</span>
							</c:when>
							<c:otherwise>
								<c:forEach begin="1" end="${approvalLineLevel}" varStatus="index">
								<%-- 중부발전용 코드 if문 추가!! --%>
								<c:if test="${ index.count eq 1 }">
								<span class="text_bold mg_l15">· 결재자 : 
									<span class="nameBox" id="approverSpan${index.count }">결재자를 선택해주세요.</span>
								</span>
								</c:if>
								<c:if test="${ index.count ne 1 }">
								<span class="text_bold mg_l15" style="display:none !important;">· ${index.count }차 결재자 : 
									<span class="nameBox" id="approverSpan${index.count }">(미선택)</span>
								</span>
								</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						</div>
					</div>
					<div class="optionArea none" style="border-top: 1px solid #ccc;">
						<span class = "optionTitle">
							결재선선택
						</span>
						<div class="optionArea_rightBox f_right">
							<div class="optionArea_rightUnitBox" id="level-cd-div">
									<span id="appLineCdName" ></span><span id="appLineDetail"> : <span id="appLineDept" /></span>
							</div>
							<div class="optionArea_rightUnitBox" id="level-select">
								<select name="app_line_level_select" id="app_line_level_select" class="mg_50">
									<c:choose>
										<c:when test="${ approvalLineLevel eq 0 }">
												<option id="1" value="1" data-dept-seq="" data-app-line-cd="" >1차결재</option>
										</c:when>
										<c:when test="${approvalLineInfo != null && fn:length(approvalLineInfo) > 0}">
											<c:forEach var="info" items="${approvalLineInfo}" varStatus="index">
												<option id="${index.count }" value="${info.appLineLevel }" data-dept-seq="${info.deptSeq }" data-app-line-cd="${info.appLineCd }" <c:if test="${info.appLineCd eq 'PICK'}">data-org-app-level="${info.orgAppLineLevel}"</c:if> >${index.count }차결재</option>
											</c:forEach>
										</c:when>
									</c:choose>
								</select>
							</div>
								
							
						</div>
					</div>
					<div class="table_area_style01">
						<table cellspacing="0" cellpadding="0" summary="결재자 목록" style="table-layout : fixed;" class="" id="tbl-approver-list">
						<caption>체크박스, 성명, 직급, 부서</caption>
							<colgroup>
								<col style="width:5%;"/>
								<col style="width:35%;"/>
								<col style="width:20%;"/>
								<col style="width:40%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="Rborder"></th>
									<th class="Rborder">성명</th>
									<th class="Rborder">직급</th>
									<th>부서명</th>
								</tr>
							</thead>
							<tbody id="tbl-approver-list-tbody">
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="btn_area_center mg_t10 mg_b10">
				<button type="button" class="btn_big theme" onclick="ok();">확인</button>
				<button type="button" class="btn_big" onclick="window.close();">취소</button>
			</div>
		</div>
	</div>
</body>
</html>