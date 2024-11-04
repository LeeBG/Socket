document.write("<script src='/JavaScript/common.js'></script>");

var NOTICE_APPROVAL_LOCK_KEY = "noticeApprovalLock";
var AFTER_APPROVAL_KEY = "afterApproval";

function noticeApprovalLockToApprover(isTarget, period, networkCd){
	
	if( sessionStorage.getItem(NOTICE_APPROVAL_LOCK_KEY) == 'Y' ) return; 
	
	if( period == 0 || period == 'undefined' || period == null ) return; 
		
	if( isTarget != 'Y' ) return;

	$.ajax({
		url: "/checkAfterRestrictionLockApprover.lin",
		cache : false,
		type: "get",
		headers: { 
	        "Content-Type": "text/plain; charset=utf-8"
	    },
		async: false,
		success: function(response) {
			
			if(response == null || response == "") return;
			
			response = JSON.parse(response);
			
			if(response.msg != null) {
				alert(response.msg);
			}
		}
	});
	
	sessionStorage.setItem(NOTICE_APPROVAL_LOCK_KEY, 'Y');
	
}

function initApprovalLockNotice() {
	removeSessionStorage(NOTICE_APPROVAL_LOCK_KEY);
}

function existsAfterRestrictionLockApprover(jsonData, noticeType, onlyEnableNotice, docElement) {
	onlyEnableNotice = (onlyEnableNotice == undefined) ? false : onlyEnableNotice;
	noticeType = (noticeType == undefined) ? "notice" : noticeType;
	docElement = (docElement == undefined) ? document : docElement;
	
	var approverList = new Object();
	var result = true;
	
	var afterApprovalObj = $("#" + AFTER_APPROVAL_KEY, docElement);
	var afterApprovalLabelObj = $("label[for='" + AFTER_APPROVAL_KEY + "']", docElement);
	
	$.ajax({
		url: "/existsAfterRestrictionLockApprover.lin",
		cache : false,
		type: "post",
		headers: { 
	        "Content-Type": "text/plain; charset=utf-8"
	    },
		data: jsonData,
		async: false,
		success: function(response) {
			
			if(response == null || response == "") return;
			
			response = JSON.parse(response);
			
			if(response.msg != null) {
				
				if( noticeType == "notice" ){ 
					if( (onlyEnableNotice && afterApprovalObj.is(":checked")) || ! onlyEnableNotice ) alert(response.msg);
				} else if( noticeType == "confirm" ) {
					if( (onlyEnableNotice && afterApprovalObj.is(":checked")) || ! onlyEnableNotice ) 
						result = confirm(response.msg + '\n사전결재로 전송하시겠습니까?');
				}
				
				changeAfterApprovalStatus(afterApprovalObj, afterApprovalLabelObj, true);
				
			} else {
				changeAfterApprovalStatus(afterApprovalObj, afterApprovalLabelObj, false);
			}
		}
	});
	
	if(noticeType == "confirm") return result;
}

function changeAfterApprovalStatus(jObj, labeljObj, disable) {
	if(disable) {
		jObj.attr("disabled", true);
		jObj.attr("checked", false);
		labeljObj.css("color", "rgb(171, 169, 169)");
	} else {
		if( jObj.attr("disabled") ) {
			jObj.attr("disabled", false);
			jObj.attr("checked", false);
			labeljObj.css("color", "black");
		}
	}
}