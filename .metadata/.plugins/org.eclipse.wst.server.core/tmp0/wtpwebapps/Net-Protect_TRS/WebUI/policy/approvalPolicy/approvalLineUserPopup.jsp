<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<title>결재선 사용자 지정</title>
</head>
<script type="text/javascript">
var ckName = "appLineUserList_${np_cd}";
var meteKeys = [ "dept_seq" , "users_nm" ];
var appSeq = "${param.appSeq}";
var psLineLevel = "${param.appLineLevel}";

var CODE_ALL_APPR = "{ALL}";
var all_appr_item = {
	appSeq : appSeq,
	users_id : CODE_ALL_APPR,
	appLineLevel : "${param.appLineLevel}",
	defaultUserYn : "N"
};

<%-- cookie데이터를 불러오기 위해 필요한 변수--%>
var cookie = $.cookie(ckName) ? JSON.parse($.cookie(ckName)) : new Array();
var luserItems = cookie;

$(document).ready(function() {
	setResizeWindow($(".wrap").eq(0));
	
	loadAppLineUserData();
});

function loadAppLineUserData() {
	if( cookie[psLineLevel - 1] && cookie[psLineLevel - 1] != ''){
		if( cookie[psLineLevel - 1][0]["users_id"] == CODE_ALL_APPR ){
			$('#selectApprDiv').addClass('none');
			changeActiveDiv( $('#allappr') );
		}else{
			changeActiveDiv( $('#selectappr') );
			setAppLineUserCookieData();
		}
	} else {
		loadStoredAppLineUserList( fn_SetDefaultApprStatus );
	}
	
	//쿠키, 서버에 저장된 값이 없으면 기본적으로 '결재자 지정'이 선택되도록 한다.
	function fn_SetDefaultApprStatus(){
		changeActiveDiv( $('#selectappr') );
	}
}

function setResizeWindow(obj) {
	window.resizeTo(obj.outerWidth() + 20, obj.outerHeight() + 150);
}

function loadStoredAppLineUserList( nodataFunc ) {
	var appLineUserList;
	
	$.ajax({
		url: "/policy/approvalPolicy/StoredApprovalLineUserList.lin?appSeq=" + appSeq + "&appLineLevel=" + psLineLevel + "&np_cd=${np_cd}",
		cache : false,
		success: function(data) {
			if( ! data || data=="" || data== "[]") { // 서버에 저장된 정보가 없을 때
				if( nodataFunc ){
					nodataFunc();
				}
				return;
			}

			approverList = JSON.parse(data);
			if( approverList[0]["users_id"] == CODE_ALL_APPR ){ // 전체결재자 정보가 저장된 경우
				$('#selectApprDiv').addClass('none');
				changeActiveDiv( $('#allappr') );
			}else{// 결재자 지정이 저장된 경우
				changeActiveDiv( $('#selectappr') );
				approverList.forEach(function(v,i,o) {
					insert_row(t_userBodyId, getApproverObject(v));
				});
				
				changeApproverCount(t_userBodyId);
			}
		}
	});
}

function setAppLineUserCookieData() {
	var index = psLineLevel - 1;
	
	if( ( cookie.length < psLineLevel ) || ( cookie[index] == null || cookie[index] == "") ) 
		return;
	
	cookie[index].forEach(function(v,i,o) {
		insert_row(t_userBodyId, getApproverObject(v));
	});
	
	changeApproverCount(t_userBodyId);
}


function setMetaData(obj, cnt) {
	for( var key in meteKeys ) {
		value = $("[name='" + ckName + "[]']").eq(cnt).data( meteKeys[key] );
		obj[meteKeys[key]] = value ? value : "";
	}
	
	return obj;
}

function ok() {
	var apprcode = $('[name="apprcode"]:checked').val();
	
	if( apprcode == 'selectappr' )
		if( ! validateAppLineUser() ) 
			return ;
		
	setAppLineUserData(apprcode);
	
	history.back();
}

function setAppLineUserData( apprcode ) {
	var cnt = 0;
	var items = new Array();
	var obj, value;
	
	if( apprcode == 'allappr' ){
		items.push(all_appr_item);
	}else{
		for( var i = 0 ; i< document.getElementById(t_userBodyId).rows.length; i++ ) {
			obj = {};
			
			obj["users_id"] = $("[name='" + ckName + "[]']").eq(cnt).val();
			obj["appSeq"] = appSeq;
			obj["appLineLevel"] = psLineLevel;
			obj["defaultUserYn"] = $("[id='dft_appr_" + obj["users_id"] + "']").is(":checked") ? "Y" : "N";
			obj = setMetaData(obj, cnt);
			
			cnt++;
			items.push(obj);
		}
	}
	
	luserItems["${param.appLineLevel - 1}"] = items;
	$.cookie(ckName, JSON.stringify(luserItems));
}

function activeApprover(event, data) {
	var node = data.node;
	if (!node.isFolder()) {
		$("input[type=text]").val("");
		$("#dept_seq").val(node.data.dept_seq);
		$("#users_id").val(node.data.users_id);
		$("#users_nm").val(node.data.users_nm);
		$("#dept_nm").text(node.data.users_dept_nm);
	}
}

function beforeActiveDeptNodeMethod(event, data) {
	initUserInfo();
	
	function initUserInfo() {
		$("#dept_seq").val("");
		$("#users_id").val("");
		$("#users_nm").val("");
		$("#dept_nm").text("");
	}
}

$(document).on('click','.apprcode_wrap', function(){
	$this = $(this);
	if( $this.hasClass('active') ) return;
	
	var $input = $this.find('input[type="radio"]');
	changeActiveDiv( $input );
});

function changeActiveDiv( $input ){
	var type = $input ? $input.attr('id') : '';
	
	$('.apprcode_wrap').removeClass('active');
	$input.parent().addClass('active');
	$input.attr('checked','checked');
	
	switch (type) {
	case 'allappr':
		$('#selectApprDiv').slideUp('slow');
		break;
	case 'selectappr':
		$('#selectApprDiv').slideDown('slow');
		break;
	}
}
</script>
<style>
.popWrapCustom {
	overflow: hidden;
	border: none;
}
</style>
<body>
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="wrap">
		<div class="popWrap trisectionWrap">
			<h3>${param.appLineLevel}차 결재자 지정</h3>
			<div class="apprcode_wrap">
				<input type="radio" name="apprcode" id="allappr" value="allappr"><label for="allappr"> 모든 결재자</label>
			</div>
			<div class="apprcode_wrap">
				<input type="radio" name="apprcode" id="selectappr" value="selectappr"><label for="selectappr"> 결재자 지정</label>
			</div>
			<div id="selectApprDiv">
				<div class="popWrapCustom popWrap trisectionWrap" style="margin: 0px auto;">
					<jsp:include page="/WebUI/hr/user/include/userTreeList.jsp" flush="false">
						<jsp:param value="50%" name="width" />
						<jsp:param value="Y" name="midadmin_auth"/>
						<jsp:param value="Y" name="useYn"/>
						<jsp:param value="Y" name="validUser"/>
						<jsp:param value="200" name="depttreeHeight"/>
						<jsp:param value="200" name="usertreeHeight"/>
						<jsp:param value="activeApprover(event, data);" name="activeUserMethod"/>
						<jsp:param value="beforeActiveDeptNodeMethod(event, data);" name="beforeActiveDeptNodeMethod"/>
						<jsp:param value="Y" name="isApproverListYn"/>
					</jsp:include> 
		
					<div class="trisection right">
						<jsp:include page="/WebUI/hr/user/include/userSelectList.jsp" flush="false">
							<jsp:param name="tdClass" value="Rborder" />
							<jsp:param name="np_cd" value="${np_cd }" />
						</jsp:include> 
					</div>
				</div>
			</div>
		</div>
		<div class="btn_area_center mg_t10 mg_b10">
			<button type="button" class="btn_big theme" onclick="ok();">확인</button>
			<button type="button" class="btn_big" onclick="history.back();">이전</button>
		</div>
	</div>
</body>
</html>
