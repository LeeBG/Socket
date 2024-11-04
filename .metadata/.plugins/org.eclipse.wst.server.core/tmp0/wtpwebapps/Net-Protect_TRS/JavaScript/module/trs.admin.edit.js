document.write("<script src='/JavaScript/common.js'></script>");
//document.write("<script src='/JavaScript/jquery.js'></script>");

function CustomEdit(){}
var customEdit = new CustomEdit();

CustomEdit.prototype.initAdminEditButton = function (column, disableYn) {
	try{
		$("input[name='admin_edit']").each(function() {
			$(this).removeClass("none");
		});
		
		$("input[name='admin_edit']").filter("[data-column='" + column + "']").each(function() {
			customEdit.toggleAdminEdit($(this).get(0), disableYn);
		});
	} catch(e) {
		console.log(e);
	}
}

CustomEdit.prototype.toggleAdminEdit = function (obj, lockStatus) {
	var column = obj.getAttribute('data-column');
	var originStatus = obj.getAttribute('data-status');
	var status ;
	var disabledYn ;
	
	if(lockStatus == 'tg')
		status = (originStatus == 'lock') ? 'unlock' : 'lock';
	else if(lockStatus == 'Y' || lockStatus == 'N')
		status = (lockStatus == 'Y') ? 'unlock':'lock';
	else
		return;
	
	if( status == 'lock' ) {
		disabledYn = 'N';
		
		if( column == 'use_yn' ) {
			$(":radio[name='" + column + "']input[value=" + $(obj).data('origin') + "]").attr("checked", true);
		} else {
			$("#" + column).val($(obj).data('origin'));
		}
	} else {
		disabledYn = 'Y';
	}
	
	obj.setAttribute('data-status', status);
	
	obj.className = status + '_icon';
	
	if(column == 'use_yn') {
		$(":radio[name='" + column + "']#use").changeReadonlyState(disabledYn, $("input[name='" + column + "']").eq(0).val());
		$(":radio[name='" + column + "']#unUse").changeReadonlyState(disabledYn, $("input[name='" + column + "']").eq(0).val());
	} else {
		$("#" + column).changeReadonlyState(disabledYn);
	}
}

CustomEdit.prototype.setUnlockAdminEditColumn = function () {
	var adminEditColumns = "";
	$("input[name='admin_edit']").filter("[data-status='unlock']").each(function() {
		if(adminEditColumns != "") adminEditColumns += ",";
		adminEditColumns += $(this).attr("data-column");
	});
	
	$("#adminEditColumns").val(adminEditColumns);
}

CustomEdit.prototype.showCustomNotice = function (custom_add_yn) {
	if(custom_add_yn == 'Y') {
		$("#customNoticeSpan").css("display", "block");
		
		$("input[name='admin_edit']").each(function() {
			$(this).addClass("none");
		});
		
		$("#l_pol_seq").changeReadonlyState(custom_add_yn);
		$("#f_pol_seq").changeReadonlyState(custom_add_yn);
		$("#a_pol_seq").changeReadonlyState(custom_add_yn);
		$("#fp_pol_seq").changeReadonlyState(custom_add_yn);
		$(":radio[name='use_yn']#use").changeReadonlyState(custom_add_yn, "Y");
		$(":radio[name='use_yn']#unUse").changeReadonlyState(custom_add_yn, "N");
	} else {
		$("#customNoticeSpan").css("display", "none");
	}
}

CustomEdit.prototype.setAdminEditOriginData = function (object) {
	if( object != null && object != 'undefined' && object != "" ) {
		$("input[name='admin_edit']").each(function() {
			var column = $(this).data("column");
			$(this).data("origin", object[column]);
		});
	}
}