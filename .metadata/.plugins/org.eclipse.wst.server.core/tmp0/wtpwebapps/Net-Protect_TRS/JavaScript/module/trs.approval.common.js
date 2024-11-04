document.write("<script src='/JavaScript/common.js'></script>");

function setApprovalDocCount(type, prgmId) {
	var countObj = $("#" + prgmId + "-count");
	
	if(countObj == null || countObj.size() == 0) return;
	
	$.ajax({
		url: "/approval/ApprovalDocCount.lin?docType=" + type,
		cache : false,
		type: "get",
		headers: { 
	        "Content-Type": "text/plain; charset=utf-8"
	    },
		async: false,
		success: function(response) {
			
			if(response == null || response == "") return;
			
			response = JSON.parse(response);
			
			if(response.result == "success") {
				countObj.html(response.count);
			}
		}
	});
}

var ApprovalManager = function() {
	var selfApproval_selector = '#selfApproval';
	var afterApproval_selector = '#afterApproval';
	var existExtAppFile = false;
	var self = this;
	
	var lastApprovers = [];
	var mustChooseApprover = false;
	
	this.setMustChooseApprover = function( isApprovalUse , selfApprovalYn , existApprovalLineInfo ) {
		if( isApprovalUse=='false' || ! existApprovalLineInfo || selfApprovalYn=='Y' ) return;
		
		mustChooseApprover = true;
	}
	this.getMustChooseApprover = function() {
		return mustChooseApprover;
	}
	
	this.existExtAppTarget = function () {
		existExtAppFile = false;
		
		if( ! alw_app_extension ) return false;
		
		try{ // 결재 확장자 복호화 실패 시 Exception을 발생시키며 튕겨냄.
			var extensions = aesUtil.decrypt(alw_app_extension).toLowerCase().split(',');
			if (extensions == '' || !extensions) throw "유효하지 않은 요청입니다.";
		} catch (e) {
			throw "유효하지 않은 요청입니다.";
		}
		
		var files = file_manager.files();
		
		for(var i=0; i < files.length; i++) {
			var file_ext = file_manager.getFileExtension( files[i].file.name );

			if ( extensions.indexOf( file_ext ) != -1 ) {
				existExtAppFile = true;
				return existExtAppFile;
			} 
		}
	}

	// Gzip 파일 체크
	this.checkGzipFile = function () {
		var files = file_manager.files();

		for(var i=0; i < files.length; i++) {
			var file_ext = file_manager.getFileExtension( files[i].file.name );

			if ( file_ext.indexOf( 'gz' ) != -1 ) {
				var flag = files[i].file.name.substring(0, files[i].file.name.length-3).lastIndexOf('.') != -1; // 확장자 형식이 있는 파일인지 확인
				if( ! flag ) return true;
			}
		}
		return false;
	}

	this.checkApprovalAuthority = function() {
		$.ajax({
			type : "post",
			url : "/approval/checkApprovalAuthority.lin",
			async : false,
			cache : false,
			data : $("#lform").serialize(),
			dataType : "json",
			error : function(xhr, status, error) {
				if (xhr.status == 401) {
					resultSessionExpire(xhr);
				} else if (xhr.status == 200) {
					resultInterceptorError(xhr);
				} else {
					resultError(error);
				}
			},
			success : function(response) {
				if( response['code'] != '200' ) {
					if( response['message'] != "" ) {
						throw response['message'];
					}
				}
			}
		});
	}
	
	//서버에서 조회하도록 변경해야함 - una
	this.checkAppLineApprover = function ( approverArray, users_id ) {
		var isSkip = true;
		
		approverArray.forEach( function ( user ) {
			if(user.users_id == users_id) {
				isSkip = false;
				return;
			}
		});
		
		return isSkip;
	}
	
	this.openApprovalPopup = function ( url ) {
		var attibute = "resizable=no,scrollbars=yes,width=750,height=750,top=5,left=5,toolbar=no,resizable=no,toolbar=no,resizable=no,url=no";
		var popupWindow = window.open(url, "approvalPopup", attibute);
		popupWindow.focus();
	}
	
	this.setDefaultApprover = function ( id, userInfo ) {
		$("#" + id + userInfo.line_level).html(userInfo.users_nm + getProxyInfo(userInfo.proxy_nm) ).attr("title", userInfo.proxy_nm_title);
	}
	
	this.initApprovalUser = function () {
		if( approvalUser != null && approvalUser != "" ) {
			if( lastApprovers && lastApprovers.length > 0 ){
				var newApprovalUser = [];
				for( var i=0; i<lastApprovers.length; i++ ){
					newApprovalUser.push({'line_level':lastApprovers[i]['line_level'],'users_id':lastApprovers[i]['users_id'],'users_nm':lastApprovers[i]['users_nm'],'proxy_nm':lastApprovers[i]['proxy_nm']
					,'proxy_nm_title':lastApprovers[i]['proxy_nm_title']})
				}
				approvalUser = JSON.stringify( newApprovalUser );
			}
			$("#approverArray").val(approvalUser);
			JSON.parse(approvalUser).forEach(function(userInfo) {
				app_manager.setDefaultApprover('approver', userInfo);
			});
		}
	}
	
	/* 자가결재 권한을 가진 경우, 자가결재 체크 여부 확인 */
	this.validateSelfApprovalChecked = function (confirm_msg, denied_msg) {
		if( ! $(selfApproval_selector).attr('checked') ) {
			$(selfApproval_selector).attr('checked', true);
			
			if( ! confirm(confirm_msg) ) {
				throw denied_msg;
				return false;
			}
		}
		
		return true;
	}
	
	this.initApprovalSetting = function (AfApprovalCheckYn) {
		if( $("#selfAppYn").val() == 'Y' ) {
			$('.approvalSection').hide();
			
			$(afterApproval_selector).parent().children().each(function(){
				if($(this).attr("for") == 'afterApproval' || $(this).attr("id") == 'afterApproval'){
					$(this).hide();
				}
			});
			
			$(selfApproval_selector).attr('checked', true);
		}
		else{
			(AfApprovalCheckYn == 'Y') ? $(afterApproval_selector).attr('checked', true) :  $(afterApproval_selector).attr('checked', false);
		}
		checkApproval();
	}
	
	this.initApprovalSettingCustom = function () {
		if( $("#selfAppYn").val() == 'Y' && $("#afterAppYn").val() == 'N' ) {
			$('.approvalSection').hide();
			$(selfApproval_selector).attr('checked', true);
		}else if( $("#selfAppYn").val() == 'Y' && $("#afterAppYn").val() == 'Y'){
			$(selfApproval_selector).attr('checked', false);
			$(afterApproval_selector).attr('checked', true);
		}
		else{
			$(afterApproval_selector).attr('checked', true);
		}
		checkApproval();
	}
	
	this.showExtApprovalLinePopUp = function (url) {
		var attibute = "resizable=no,scrollbars=yes,width=750,height=750,top=5,left=5,toolbar=no,resizable=no,toolbar=no,resizable=no,url=no";
		var popupWindow = window.open(url, "extApprovalLinePopUp", attibute);
		popupWindow.focus();
	}
	
	this.checkExtAppNshowPopup = function (url) {
		if(app_manager.existExtAppTarget()) {
			app_manager.showExtApprovalLinePopUp(url);
		}
	} 
	
	this.isExistExtAppFile = function () {
		return self.existExtAppTarget();
	}
	
	this.saveLastApprover = function( approverArray ){
		if( ! u_id ) return;
		
		var key = self.getLastApproverKey( u_id );
		
		//이미 있는 값을 제거
		self.removeLastApprover(key);
		
		if( !approverArray || approverArray=='' )
			return;
		
		//사용자가 선택한 값으로 다시 설정한다.
		var json = JSON.parse( approverArray );
		
		var savejson=[];
		
		if( json && json.length > 0 ){
			for( var i=0; i<json.length; i++ ){
				savejson.push( aesUtil.encrypt(json[i].users_id) );
			}
			localStorage.setItem(key, JSON.stringify(savejson) );
			localStorage.setItem(key+'.info', aesUtil.encrypt(approverArray) );	//asd
		}
	}
	
	this.getLastApproverKey = function( u_id ){
		if( ! u_id ) return;
		var user = aesUtil.decrypt( u_id );
		var key = aesUtil.encrypt(user+'.lastApprover');
		return key;
	}
	
	this.removeLastApprover = function(key){
		if( ! key ){
			key = self.getLastApproverKey ( u_id );
		}
		localStorage.removeItem(key);
	}
	
	this.initLastApprover = function(){
		if( ! u_id ) return;
		
		var key = self.getLastApproverKey ( u_id );

		var str = localStorage.getItem(key);
		var saved, apprline;
		
		if( !str || str=='' )
			return;
		
		getLineInfoNLevel(function(data){
			if( !data ) return;

			saved = JSON.parse( str );
			apprline = JSON.parse(data);

			if( ! saved || saved.length == 0 ) return;

			if( saved.length != apprline.approvalLineLevel ){
				self.removeLastApprover(key);
				return;
			}
			
			var line = apprline.approvalLineInfo;
			for( var i=0; i<saved.length; i++ ){
				var id = aesUtil.decrypt( saved[i] );

				getApprovalLineApprover(line[i]['appLineLevel'], line[i]['deptSeq'], line[i]['appLineCd'], function(data){
					pushExistApprover(id, data);
				});
			}
		});
		
		function pushExistApprover(id,data){
			if(data == null || data == "" || data == "[]") {
				return;
			}
			var users = JSON.parse( data );
			var contains = false;
			
			for( var i=0; i<users.length; i++ ){
				if( users[i]['users_id'] == id ){
					contains = true;
					lastApprovers.push( users[i] );
				}
			}
			
			if( ! contains ) {
				lastApprovers=[];
				return;
			}
		}
	}
	this.initLastApproverNoRelationDept = function(){
		if( ! u_id ) return;
		var key = self.getLastApproverKey ( u_id );
		
		var info = localStorage.getItem(key+'.info');
		if(!info || info==''){
			console.log("LastApprover null");
			return;
		}
		try {
			saveLastApproval = aesUtil.decrypt( info );
			$('#approverArray').val(saveLastApproval);
			//console.log($('#approverArray').val());
			var arr = JSON.parse(saveLastApproval);
			var users_nm = arr[0].users_nm;
			$("#approver1").text(users_nm);
		} catch (e) {
			console.log(e);
		}
	}
}

var ApprovalSelectionManager = function() {
	
}

function getProxyInfo(proxy_nm) {
	return ( proxy_nm && proxy_nm != 'undefined' ? "(대결자 : " + getProxyPasing(proxy_nm) + ")" : "" );
}

// ..외 몇명 parsing 함수
function getProxyPasing(proxy_nm) {
	var proxyArray = proxy_nm.split(',');
	var baseString = proxyArray[0] + ' 외 ';
	var addCount = proxyArray.length - 1;

	return (proxyArray.length == 1) ? proxy_nm : baseString + addCount + '명';
}
