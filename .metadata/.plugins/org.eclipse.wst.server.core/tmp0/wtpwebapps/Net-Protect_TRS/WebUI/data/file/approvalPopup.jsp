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
<c:set var="isUseWholeApproverSearch" value="${siteCode eq 'komsco'}"/>

<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.call.js" />?v=200103"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.approval.common.js?ver=20240215" />"></script>
<script type="text/javascript">
var app_level = "${approvalLineLevel}";
var selectedApprover = null;
var approver = new Array();
var approverArray = new Array();
var approverList;
var siteCode = "${siteCode}";
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

function setApprovalLineInfo(obj, levelCd, event) {
	var appLineInfo;
	var level = (levelCd == 'PICK') ? obj.data("org-app-level") : obj.val();
	
	getApprovalLineInfo(level, function(data){
		if(data == null || data == "") return;
		
		appLineInfo = JSON.parse(data);
		setApprovalLineCd(appLineInfo, obj);
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
	
	getApprovalLineApprover(level, deptSeq, levelCd, function(data){
		if(data == null || data == "" || data == "[]") {
		 	displayEmptyApprover(tableId); 
			setApprovalLineInfo(obj, levelCd, event); 
			return;
		}
		
		approverList = JSON.parse(data);
		
		displayApproverList(approverList, tableId, level, obj.get(0).id - 1);
		
		setApprovalLineInfo(obj, levelCd, event); 
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
		cell[0].innerHTML = "<input type='radio' name='radio_approver' class='input_chk' name='chk' onclick=\"selectApprover('" + value.users_id + "', '" + value.users_nm  + "', '" + value.proxy_nm  + "');\"" + checked + " / >";
		
		cell[1].className = "t_center Rborder";
		cell[1].title = ( value.proxy_nm_title == null || value.proxy_nm_title == "undefined") ? "" : value.proxy_nm_title;
		cell[1].innerHTML = value.users_nm + getProxyInfo(value.proxy_nm);
		
		cell[2].className = "t_center Rborder";
		
		if( siteCode ==  "kcredit" ) {
			cell[2].title = ( value.job_nm == null || value.job_nm == "undefined") ? "" : value.job_nm;
			cell[2].innerHTML = ( value.job_nm == null || value.job_nm == "undefined") ? "" : value.job_nm;
		}else {
			cell[2].title = ( value.position_nm == null || value.position_nm == "undefined") ? "" : value.position_nm;
			cell[2].innerHTML = ( value.position_nm == null || value.position_nm == "undefined") ? "" : value.position_nm;
		}
		
		cell[3].className = "t_center";
		cell[3].title = ( value.dept_nm == null || value.dept_nm == "undefined") ? "" : value.dept_nm;
		cell[3].innerHTML = ( value.dept_nm == null || value.dept_nm == "undefined") ? "" : value.dept_nm;
	});
}

function setApprovalLineCd(appLineInfo, obj) {
	$("#appLineCdName").text(appLineInfo.appLineCdName);
	if (appLineInfo.appLineCd == "DEP") {
		$("#appLineDetail").show();
		
		var param = new Object();
		param.deptSeq = obj.data("dept-seq");
		getFindDept( param , function(data){
			if(data == null || data == "" || data == "[]") {
				$("#appLineDept").text("결재자를 선택해주세요.");
				return;
			}
			
			$("#appLineDept").text(JSON.parse(data).dept_nm);
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
		
		if (approver[i] == null) msg = ( (app_level == 1) ? "" : ( (i+1)+"차 " ) ) + "결재자를 지정하세요";

		<c:if test="${isExtApprovalPopup eq 'true'}">
		if( msg == "" && approver[i]['users_id'] == '${loginUser.users_id}')
			msg = "본인 결재는 불가능합니다.";
		</c:if>
		
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
	
	app_level = parseInt(app_level) + ( ( app_level == 0 ) ? 1 : 0 );
	
	for(var i = 0; i < app_level; i++){
		if (approver[i] != null) {
			$(opener.document).find('#approver' + approver[i].line_level).html(approver[i].users_nm + getProxyInfo(approver[i].proxy_nm));
			approverArray.push(approver[i]);
		} 
	}
	$("#approverArray", opener.document).val( (approverArray.length > 0) ? JSON.stringify(approverArray) : "" );

	<c:if test="${approvalPolicy.self_app_yn eq 'Y'}">
	$("#selfApproval", opener.document).attr("checked", false);
	</c:if>
	
	<c:if test="${isExtApprovalPopup eq 'true'}">
	opener.fileupload('web', 'Y');
	</c:if>
	window.close();
};

function selectApprover(users_id, users_nm, proxy_nm) {
	var approverObj = new Object();
	approverObj.users_id = users_id;
	approverObj.users_nm = users_nm;
	approverObj.proxy_nm = proxy_nm;

	var approverArr = [approverObj];
	
	<c:if test="${approvalPolicy.after_app_yn eq 'Y' && isExtApprovalPopup eq 'false'}">
		existsAfterRestrictionLockApprover(JSON.stringify(approverArr), "notice", false, opener.document);
	</c:if>
	
	selectedApprover = approverObj;
	setApprover($("#app_line_level_select").find(":selected"));
	
	<c:if test="${approvalLineLevel == 1}">
		approver[0] = selectedApprover;
		setApproverHtml(approver[0], '1');
	</c:if>
}

function setApproverHtml(approver, ord) {
	$('#approverSpan' + ord + '').html(approver.users_nm + getProxyInfo(approver.proxy_nm));
}

//부서결재자 검색 
function searchOtherDeptApprover(){
	var searchConditionValue = $("#searchCondition option:selected").val();
	$("#searchField").val(searchConditionValue);
	
	if ($("#searchValue").val().empty()) {
		alert('검색어를 입력해 주세요.');
		return;
	}
	
	var param = new Object();
	param.searchField = $("#searchField").val();
	param.searchValue = $("#searchValue").val();
	
	getFindOtherDeptApproverList( param , function(data){
		setApproverListUI(data);
	});
	
	function setApproverListUI(data){
		var approverList = JSON.parse(data);
		
		if(approverList.apprInfoList.length == 0){
			var tableId = "tbl-approver-list";
			$("#" + tableId + " > tbody").empty();
			$("#" + tableId + " > tbody").append("<tr><td class='t_center' colspan ='4'><div class='no_result'>결과가 없습니다.</div></td></tr>");
		}
		else{
			var tableId = "tbl-approver-list";
			$("#" + tableId + " > tbody").empty();
			approverList.apprInfoList.forEach(function(value, idx) {
				if( value == null || value == 'undefined' || value == '' ) return;
				
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
				cell[2].innerHTML = ( value.position_nm == null || value.position_nm == "undefined") ? "" : value.position_nm;
				
				cell[3].className = "t_center";
				cell[3].innerHTML = ( value.dept_nm == null || value.dept_nm == "undefined") ? "" : value.dept_nm;
			});
		}
	}
}
</script>
<style>
#level-cd-div {
	width: 60%;
	right: 20%;
}

#level-select {
	width: 18%; 
    right: 5px;
}
#appLineCdName {
	font-weight: 700;
}
</style>
</head>
<body>
<form id="lform" name="lform">
<input id="searchField" name="searchField" type="hidden" value="${deptApprovalForm.searchField}"/>
	<div class="wrap">
		<div class="popWrap">
			<h3>결재자 선택</h3>
			<div class="conBox">
				<div class="popCon">
					<div class="table_area_topCon mg_t15 mg_b5" style="overflow:hidden; line-height:normal; margin:0px; padding: 10px 0;">
						<div class="f_left mg_l5 pd_t5">
						<c:choose>
							<c:when test="${approvalLineLevel == 1 or approvalLineLevel == 0 }">
								<span class="text_bold mg_l15">· 결재자 : 
									<span class="nameBox" id="approverSpan1">결재자를 선택해주세요.</span>
								</span>
							</c:when>
							<c:otherwise>
								<c:forEach begin="1" end="${approvalLineLevel}" varStatus="index">
								<span class="text_bold mg_l15">· ${index.count }차 결재자 : 
									<span class="nameBox" id="approverSpan${index.count }">(미선택)</span>
								</span>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						</div>
					</div>
					<div class="optionArea ${ (approvalLineLevel eq 1) or ((approvalLineLevel eq 0) ) ?'none':''}" style="border-top: 1px solid #ccc;">
						<span class = "optionTitle">
							결재선선택
						</span>
						<div class="optionArea_rightBox f_right">
							<c:if test="${ approvalLineLevel ne 0 }">
								<div class="optionArea_rightUnitBox" id="level-cd-div">
									<span id="appLineCdName" ></span><span id="appLineDetail"> : <span id="appLineDept" /></span>
								</div>
							</c:if>
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
					<c:if test = "${isUseWholeApproverSearch}">
					<div class="topCon t_center pd_t10 pd_b10 Tborder">
						<div class="conBox searchBox t_center">	
							<div class="topCon nBorder pd_b10 pd_t10">
								<table summary="정책 검색조건" style="table-layout : fixed">
									<caption>검색조건, 버튼</caption>
									<tbody>
										<colgroup>
											<col style="width:100%;"/>
										</colgroup>
										<tr>
											<td class="t_center">
												<select id="searchCondition" title="파일전송정책 검색조건">
												<option selected="selected" value="appr_nm">결재자 이름</option>
												<!-- <option value="dept_seq" >부서</option> -->
												<option value="appr_id">결재자 ${customfunc:getMessage('common.id.commonid')}</option>
												</select>
												<input type="text" class="text_input" style="max-width:65%;" id="searchValue" name="searchValue" onkeypress="if(event.keyCode==13) {searchOtherDeptApprover(); return false;}" value="${fPolFileMgtForm.filterSearchValue}" onkeyup="onlySizeFillter(this,100)"/>
												<button type="button" id="btnResetSearch" class="btn_common theme" onclick ="searchOtherDeptApprover()">검색</button>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					</c:if>
					<div class="table_area_style01">
						<table cellspacing="0" cellpadding="0" summary="결재자 목록" style="table-layout : fixed;" class="" id="tbl-approver-list">
						<caption>체크박스, 성명, 직급, 부서</caption>
							<colgroup>
								<col style="width:5%;"/>
								<col style="width:50%;"/>
								<col style="width:20%;"/>
								<col style="width:30%;" />
							</colgroup>
							<thead>
								<tr>
									<th class="Rborder"></th>
									<th class="Rborder">성명</th>
								<c:choose>
									<c:when test="${siteCode eq 'kcredit' }">
										<th class="Rborder">직책</th>
									</c:when>
									<c:otherwise>
										<th class="Rborder">직급</th>
									</c:otherwise>
								</c:choose>
									
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
</form>
</body>
</html>
