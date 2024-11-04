/**
 * 파일서버로 파일을 전송
 */

var NPFileTransManager = function(){
	var file_server_connector = null;
	var selectedFiles = [];
	var index = 0;
	var percent_uis = {};
	var self = this;
	var isDownLoad = false;
	var isVcUpdate = false;
	var isGpkiCopy = false;
	var isAgentUpdate = false;
	
	this.init = function(){
		if( file_server_connector ) return true;
		
		// host must be start with websocket protocol. example) ws://localhost:8080...
		var protocol = (location.protocol=='http:') ? 'ws:' : 'wss:';
		var ip = location.hostname;
		var port = (protocol == 'ws:') ? aesUtil.decrypt(env.wsFileServerPort) : aesUtil.decrypt(env.wssFileServerPort);
		var server_host = protocol+"//"+ip+":"+port;
		try{
			console.log("connect to fileserver. "+server_host);
			file_server_connector = new BinaryClient( server_host );
			bindClientEvents( file_server_connector );
		}catch (e) {
			console.log("error occur! e = ",e);
			return false;
		}
		
		return true;
	}
	
	this.upload = function( file , agentUpdate ){
		
		if ( file != null ) {
			var obj = {
					'key' : 0,
					'file' : file
			};
			selectedFiles.push(obj);
			/* zip 파일형식이면 인증서 복사, tar 파일형식이면 백신 수동업데이트 */
			if (self.getFileExtension( file.name ) == 'zip') {
				isGpkiCopy = true;
			} else {
				if(agentUpdate){
					isAgentUpdate = true;	
				}else{
					isVcUpdate = true;
				}
			}
		}

		if( ! selectedFiles || selectedFiles.length == 0 ){
			console.log('no selected file. please select uploading file!');
			return;
		}

		var interval;
		var try_count = 0;
		
		var send_button = $('#send_button');
		
		changeFileSendButton( send_button , 'preparing' );
		
		try{
			interval = setInterval(function(){
				
				if( try_count == 5 ){
					file_server_connector = null;
					clearInterval( interval );
					changeFileSendButton(send_button,'error');
					throw "connector is not ready.";
				}
				
				if( ! file_server_connector || file_server_connector._socket.readyState != 1 ){
					try_count ++;
					return;
				}
				
				changeFileSendButton(send_button,'processing');
				
				sendFileToFileServer( 0 );
				
			},500);
		}catch(e){
			console.error( e );
		}

		function sendFileToFileServer( i ){
			if( interval ){
				clearInterval( interval );
				interval = null;
			}
			if (isVcUpdate || isGpkiCopy || isAgentUpdate) {
				fileUpload( i );
			} else {
				setTimeout(function(){
					var file = selectedFiles[i].file;

					var ui = {
						selector : $("#file"+selectedFiles[i].key).find('.process>span'),
						eventid : null,
						index : i
					};
					
					ui.selector.html("0%");
			    	
					var stream = file_server_connector.send(file, {name: aesUtil.encrypt(file.name), size: file.size , index : i , basepath : aesUtil.encrypt(aesUtil.decrypt(env.basepath)+env.basepath_suffix) , position : env.networkPosition , key: i });

					percent_uis[stream.id] = ui;
					bindStreamEvents( stream );
					showProgressText( stream );
				},1000);
			}
		}
		
		function showProgressText(stream){
			var ui = percent_uis[stream.id];
			var percent = Math.round((stream._writeLength/selectedFiles[ui.index].file.size)*100);
			
			if( percent >= 100 ){
				ui.selector.html('파일 저장중<span class="loading_txt"></span>');
				ui.loadingeventid = setInterval( function(){ showLoadingText(ui.selector.find('.loading_txt')); } , 500);
				var ui = percent_uis[stream.id];
				if( ui ){
					clearInterval( ui.eventid );
				}
				return;
			}
			
			if( percent > 0 ) {
				ui.selector.html(percent+"%");
			}
			
			if( ! ui.eventid ){
				ui.eventid = setInterval(function(){
					showProgressText( stream );
				},500);
			}
		}
		
		function showLoadingText( $loading ){
			var length = ($loading.html().length)+1;
			var text = '';
			for( var i=0; i<(length-1)%5+1; i++ ){
				text += '.';
			}
			$loading.html( text );
		}
		
		function bindStreamEvents(stream){
			stream.on('data', function(data){
				var ui = percent_uis[stream.id];
				if( ui ){
					clearInterval( ui.eventid );
					clearInterval( ui.loadingeventid );
					delete percent_uis[stream.id];
				}
				if( data.message && data.message == 'end' ){
					ui.selector.html('전송 완료');
				}else{
					ui.selector.html('전송 오류');
				}
				
			    var key = data.meta.index;

				selectedFiles[key].file.send_status = 0;
				selectedFiles[key].file.path	= aesUtil.decrypt(data.meta.path);
				selectedFiles[key].file.orgname	= aesUtil.decrypt(data.meta.orgname);
				selectedFiles[key].file.status	= 0;
				selectedFiles[key].file.savename = data.meta.savename;
				selectedFiles[key].init			= true;
				
		    	//하나의 파일이 다 올라갔을 때 다음 파일 업로드 한다.
		    	if( key != selectedFiles.length-1 ) {
		    		sendFileToFileServer( key+1 );
		    	}else{
		    		checkAllFileInitComplete(0);
		    	}
		    }); 
		}

		function checkAllFileInitComplete( i ){
			if( i == selectedFiles.length ){
				completeUploadingFiles( selectedFiles, isVcUpdate, isGpkiCopy, isAgentUpdate);
				return;
			}
			
			if( selectedFiles[i].init ){
				checkAllFileInitComplete( i+1 );
			}else{
				setTimeout( function(){checkAllFileInitComplete(i)} , 500 );
			}
		}
		
		function fileUpload( i ){
			var file = selectedFiles[i].file;
			var stream = file_server_connector.send(file, {name: aesUtil.encrypt(file.name), size: file.size , index : i , basepath : aesUtil.encrypt(aesUtil.decrypt(env.basepath)+env.basepath_suffix) , position : env.networkPosition , key: i });

			stream.on('data', function(data){
				var key = data.meta.index;

				selectedFiles[key].file.send_status = 0;
				selectedFiles[key].file.path	= aesUtil.decrypt(data.meta.path);
				selectedFiles[key].file.orgname	= aesUtil.decrypt(data.meta.orgname);
				selectedFiles[key].file.status	= 0;
				selectedFiles[key].file.savename = data.meta.savename;
				selectedFiles[key].init			= true;
				
				completeUploadingFiles( selectedFiles[key].file, isVcUpdate, isGpkiCopy, isAgentUpdate);
			}); 
		}
	}
	
	function bindClientEvents( client ){
		if( ! client ) {
			console.log('not connect to server! so can\'t bind event...');
			return;
		}
		
		//Wait for connection to BinaryJS server
		client.on('open', function(){
			console.log('connect to server.');
		});
		
		//connect from server
		client.on('stream', function( stream , meta ){
		});
		
	}
	
	
	this.add = function(file){
		try{
			if( isDuplicateFileName( file ) ){
				throw "duplicateFileName";
			}
			
			if( file.size == 0 && !isAllowEmptyFile() ){
				throw "emptyFile";
			}
			
			if( ! isValidSize( file ) ){
				throw "notAllowedSize";	
			}
			
			if( ! isValidExtension( file ) ){
				throw "notAllowedExtension";
			}
		
			file.key = index;
			var obj = {
				'key' : index,
				'file' : file
			};
			selectedFiles.push(obj);
		} catch(e){
			return e;
		}
		return index++;
	}
	
	this.remove = function( index ){
		for( var i=0; i<selectedFiles.length; i++ ){
			var file = selectedFiles[i];
			if( file.key == index ){
				selectedFiles.splice( i , 1 );
				return;
			}
		}
	}
	
	this.download = function( network_position , data_seq , ath_ord , orgname ){
		var link = document.createElement("a");
		link.setAttribute('href','/download/file/'+network_position+'/'+data_seq+'/'+ath_ord+'.lin');
		link.innerHTML = 'download';
		
		makeHiddenDivAndAppend( link );
		
		link.click();
		
		setTimeout( function(){changeDownloadCnt(network_position, data_seq, ath_ord )} , 300 );
		downloadCheckProcess(network_position, data_seq, ath_ord);		
	}

	this.downloadZip = function( network_position , data_seq , orders, orgname ){
		var url = '/download/file/'+network_position+'/'+data_seq+'.lin';
			
		if( orders != null ){ 
			url+='?'; 
			for( var i=0; i <orders.length; i++ ){
				url += 'orders='+orders[i].value;
				url += (i != orders.length -1) ? '&' : '';
			}
		}
			
		var link = document.createElement("a");
		link.setAttribute('href',url);
		link.innerHTML = 'download';
		
		makeHiddenDivAndAppend( link );
			
		link.click();
			
		setTimeout( function(){changeDownloadCnt( network_position, data_seq, orders )} , 300 );
		downloadCheckProcess(network_position, data_seq, orders);
	}
	
	this.downloadClipboard = function( io_cd , clipboard_seq ) {
		var link = document.createElement("a");
		link.setAttribute('href','/download/clipboard/'+ io_cd +'/'+clipboard_seq + '.lin');
		link.innerHTML = 'download';
		
		makeHiddenDivAndAppend( link );
		
		link.click();
		
		var btnDownload = $('#btnDownload');
		changeFileSendButton( btnDownload , 'down_disable' );
		setTimeout(function() {changeFileSendButton( btnDownload , 'download' )}, 2500);	
		
	}
	
	this.isEmptyFile = function(){
		if( ! selectedFiles || selectedFiles.length == 0 )
			return true;
		
		return false;
	}
	
	this.files = function(){
		return selectedFiles;
	}

	this.sumSize = function(){
		var sum=0;
		for( var i=0; i<selectedFiles.length; i++ ){
			sum += selectedFiles[i].file.size;
		}
		return sum;
	}
	
	this.validateValidExtension = function () {
		$.ajax({
			type : "post",
			url : "/policy/extPolicy/validateValidExtension.lin",
			async : false,
			cache : false,
			data : JSON.stringify(getJsonFileList(selectedFiles)),
			dataType : "json",
			headers: { 
		        "Content-Type": "text/plain; charset=utf-8"
		    },
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
		
		function getJsonFileList(files){
			var list = [];
			for( var i=0; i<files.length; i++ ){
				var file = files[i].file;
				var file_obj= {
					"filename" : file.name
				};
				list.push( file_obj );
			}

			return list;
		}
	}
	
	this.isValidCount = function (fileMaxCnt){
		if( fileMaxCnt == ''){
			return true;
		}
		return selectedFiles.length <= fileMaxCnt;
	}
	
	this.getFileExtension = function( filename ){
		if( filename.indexOf('.') == -1 ) return '';
		
		return filename.substring( filename.lastIndexOf('.')+1 , filename.length).toLowerCase();
	}
	
	function isAllowEmptyFile() {
		if( ! alw_extension ) return false;
		
		return ( alw_extension.indexOf("[empty_file]") > -1 );
	}
	
	function isValidExtension( file ){
		if( ! alw_extension ) return true;
		var errmsg = new cls_errmsg();
		try { // 확장자 복호화 실패 시 Exception을 발생시키며 튕겨냄.
			var extensions = aesUtil.decrypt(alw_extension).toLowerCase().split(',');
			if (extensions == '' || !extensions) {
				throw "유효하지 않은 요청입니다.";
			}
		} catch (e) {
			errmsg.append(null , e);
			errmsg.show();
			return false;
		}
		
		var file_ext = self.getFileExtension( file.name );

		if( is_white_list == 'true' ){
			//white
			if( extensions.indexOf( file_ext ? file_ext :"[no_ext]" ) != -1 )
				return true;
			
			return false;
		}else{
			//black
			if( extensions.indexOf( file_ext ) == -1 ){
				return true;
			}
			return false;
		}
	}
	
	function isValidSize( file ){
		if( env.file.one_size < file.size ){
			return false;
		}
		var expect_size = self.sumSize() + file.size;
		if( env.file.total_size < expect_size ){
			return false;
		}
		return true;
	}
	
	function makeHiddenDivAndAppend( link ){
		var hidden_div = document.getElementById('hidden_div');
		
		if( hidden_div == null ){
			hidden_div = document.createElement("div");
			hidden_div.setAttribute('id','hidden_div');
			hidden_div.setAttribute('class','none');
			document.body.appendChild( hidden_div );
		}
		
		hidden_div.appendChild(link);
	}
	
	function isDuplicateFileName( file ){
		for(var i=0; i <selectedFiles.length; i++){
			if( selectedFiles[i].file.name == file.name ){
				return true;
			}
		}
		return false;
	}
	
	function changeDownloadCnt( network_position, data_seq, orders ){
		
		var param = {
			'search': 'download_cnt',
		};
		if( orders ){
			var arr = [];
			for( var i=0; i<orders.length; i++ ){
				arr.push(orders[i].value);
			}
			param.orders=arr;
		}
		$.ajax({
			type : "get",
			url : "/file/"+network_position+"/"+data_seq+".lin",
			data : param, 
			dataType : "json",
			cache : false,
			error : function(xhr, status, error) {
				console.error(xhr);
			},
			success : function(response) {
				var $file;
				var $count;
				var $max;
				var $checkbox;
				var order;
				
				for( var i=0; i<response.length; i++ ){
					var info = response[i];
					order = info['order'];
					
					if( ! info['download_cnt'] ){return;}
					
					$file = $("#attachfile"+order);
					$count = $("#download_cnt"+order);
					$max = $("#download_max_cnt"+order);
					$checkbox = $("#chk"+order);
					
					$count.text( info['download_cnt'] );

					if( parseInt($count.text()) >= parseInt($max.text()) ){
						$checkbox.attr({"disabled":"disabled"});
						$checkbox.prop("checked",false);
					}
				}
			}
		});
	}
};

/**
 * 특정영역에 파일 드래그 드랍 이벤트를 지정하는 함수
 * @param $selector 이벤트 지정 대상 (jquery object)
 * @returns
 */
function bindFileDragAndDropEvent( $selector ){
	$selector.on('dragenter', doNothing);
	$selector.on('dragover', doNothing);
	$selector.text('Drag files here');
	$selector.on('drop', function(e){
		e.originalEvent.preventDefault();
		var file = e.originalEvent.dataTransfer.files[0];
		
		// Add to list of uploaded files
		$('<div align="center"></div>').append($('<a></a>').text(file.name).prop('href', '/'+file.name)).appendTo('body');
	}); 

	// Deal with DOM quirks
	function doNothing (e){
	  e.preventDefault();
	  e.stopPropagation();
	}
}

/**
 * 파일을 선택할 수 있도록 탐색기를 호출하여 선택한 파일 정보를 가져오는 함수
 */
function clickInputFile( fileManager , fileMaxCnt ){
	var fileinput = $("<input type='file' multiple>");
	fileinput.on('change',function(e){
		appendFileList( fileManager , $(this)[0].files, fileMaxCnt );
	});
	fileinput.click();
	
}

function appendFileList( fileManager , files , fileMaxCnt ){
	var files_html = '';
	var fail_files_str = '';
	for(var i=0; i<files.length ; i++ ){
		var file = files[i];
		var key = fileManager.add( file );
		if( isOccurError( key ) ){
			if( fail_files_str != '' ){
				fail_files_str += '\n';
			}
			fail_files_str += '- '+file.name+' ('+getSizeText(file.size)+')';
			continue;
		}
		files_html +='<ul id="file'+key+'">';
		files_html +='<li class="name " style="width:50%;"><input type="checkbox" value="'+file.key+'" style="margin-left:10px;"> '+file.name+'</li>';
		files_html +='<li class="size" style="width:30%;"><span style="margin-left:10px;">'+getSizeText(file.size)+'</span></li>';
		files_html +='<li class="process" style="width:20%;"><span style="margin-left:10px;">전송 대기</span></li>';
		files_html +='</ul>';
	}
	$("#file_uploader .list").append( files_html );
	changeFileEmptyUI(fileManager);
	changeExtraFileCountUI(fileManager,fileMaxCnt);
	
	if( fail_files_str != '' ){
		alert('전송할 수 없는 파일이 있습니다.\n파일명 중복, 파일크기 또는 확장자를 확인해주세요.\n[파일목록]\n'+fail_files_str);
	}
	
	function isOccurError( key ){
		if( typeof key === "string"){
			return true;
		}
		return false;
	}
}

function changeExtraFileCountUI( fileManager, fileMaxCnt ){
	if( fileMaxCnt != '' && Number(fileManager.files().length) > Number(fileMaxCnt) ){
		$("#maxFileCount").css("color","red");
	}else{
		$("#maxFileCount").css("color","black");
	}
}

function changeFileEmptyUI( fileManager ){
	var $file_div = $("#file_uploader");
	var $empty = $file_div.find('.empty');
	var $list = $file_div.find('.list');
	
	if( fileManager.files().length == 0 ){
		$("#maxFileCount").html( "0" );
		$("#maxFileSize").html( "0.0KB" );
		showEmpty();
		return;
	}

	showList();
	$("#maxFileCount").html(fileManager.files().length);
	$("#maxFileSize").html( getSizeText(fileManager.sumSize()) );
	
	function showEmpty(){
		$empty.show();
		$list.hide();
	}
	function showList(){
		$list.show();
		$empty.hide();
	}
}

var SIZE_ARR=['bytes','KB','MB','GB','TB','PB'];
function getSizeText( byte_size ){
	var e = ( byte_size == 0 || byte_size == 'undefined' ) ? 0 : Math.floor(Math.log(byte_size) / Math.log(1024));
	return (byte_size / Math.pow(1024, e)).toFixed(1) +  SIZE_ARR[e];
}

function completeUploadingFiles( files, isVcUpdate, isGpkiCopy, isAgentUpdate ){
	$("#fileInfoListTbody tbody tr").remove();
	
	var file_msg = (isVcUpdate || isGpkiCopy || isAgentUpdate) ? getJsonVcFileObj() : getJsonFileList();
	$("#jsonLastfileList").val(JSON.stringify(file_msg));
	
	var successUrl = "";

	if ( isVcUpdate ) { /* 백신 수동업데이트 */
		successUrl = "/vaccine/vaccineInfo.lin";
		resultCheckFunc($("#lform"), "/vaccine/vaccineInfo/moduleUpdate.lin", function(response) {
			var code = response['code'];
			if (code == '200') {
				isloading.stop();
				location.reload();
				alert("백신업데이트가 진행됩니다.\n소요시간은 1분에서 10분정도 소요됩니다.\n목록을 확인해주세요.");
			} else {
				alert("백신업데이트 도중 오류가 발생하였습니다.");
			}
		});
	} else if ( isAgentUpdate ) {
		successUrl = "/systemManagement/commonManagement/agentInfo.lin";
		resultCheckFunc($("#lform"), "/systemManagement/commonManagement/moduleUpdate.lin", function(response) {
			var code = response['code'];
			if (code == '200') {
				isloading.stop();
				location.reload();
				alert("에이전트 업데이트가 진행됩니다.\n소요시간은 1분정도 소요됩니다.\n목록을 확인해주세요.");
			} else {
				isloading.stop();
				alert("에이전트 업데이트 도중 오류가 발생하였습니다.");
			}
		});
	} else if ( isGpkiCopy ) { /* 망간 인증서 복사 */
		resultCheckFunc($("#lform"), "/gpki/gpkiCopy.lin", function(response) {
			console.log( "gpkiCopy result => ",response['result'] );
			if( response['result'] == '200' ){
				alert('망간 인증서복사가 진행됩니다.');
				$("#param").val( response.gpkiCopyData.certificate_number );
				$("#lform").get(0).submit();
			}else{
				alert(response['message']);
				location.reload();
			}
			hideModal();
		});
	} else { /* 자료전송 */
		successUrl = "/data/file/sendList.lin";
		if( app_manager.getMustChooseApprover() ){
			app_manager.saveLastApprover($('#approverArray').val());
		}
		resultCheckFunc($("#lform"), "/data/file/fileSendComplete.lin", compeleteSuccess);
	}
	
	function getJsonVcFileObj(){
		var file_obj= {
			"file_send_status" : files.send_status,
			"orig_filename" : files.name,
			"orig_filepath" : "",
			"orig_filesize" : files.size,
			"server_filepath" : files.path,
			"status" : files.status,
			"uuri_filename" :files.savename
		};
		
		return file_obj;
	}
	
	function getJsonFileList(){
		var list = [];
		for( var i=0; i<files.length; i++ ){
			var file = files[i].file;
			var file_obj= {
				"file_send_status" : file.send_status,
				"orig_filename" : aesUtil.encrypt(file.orgname),
				"orig_filepath" : "",
				"orig_filesize" : file.size,
				"server_filepath" : file.path,
				"status" : file.status,
				"uuri_filename" :file.savename
			};
			list.push( file_obj );
		}
		var result = {
			"F_CODE" : "1000",
			"S3I_FileInfoList" : list
		}
		
		return result;
	}
	
	function compeleteSuccess(response) {
		resultUnsuccessFunc(response, successUrl, false, processError);
	}
	
	function processError(response) {
		resultMessage(response);
		$(location).attr("href", successUrl);
		//changeFileSendButton( $('#send_button') , 'error');
	}
}
var time;

function downloadFromLink( checkbox_selector , whole_cnt ){
	if(!file_manager.isDownLoad) {
		var orders = $(checkbox_selector);
		
		if (orders == null || orders.length == 0) {
			alert("다운로드 파일을 선택하세요");
			return;
		}
		
		var data_seq = $("#data_seq").val();
		var order;
		
		if( orders.length > 1 ){
			//zip파일로 묶어서 다운받는 URL호출
			if( whole_cnt ){
				if( orders.length == Number(whole_cnt) )
					orders = null;
			}else if( orders.length == $("[id^='filename']").length ){
				orders = null;
			}
			file_manager.downloadZip( data_position , data_seq , orders, $("#filename"+order).val() );
		}else{
			//1개의 파일을 선택하여 다운 받을 때
			file_manager.download( data_position , data_seq , orders[0].value , $("#filename"+order).val() );
		}		
	}
}

function oneFileDownloadFromLink(network_position , data_seq , ath_ord , orgname) {
	if(!file_manager.isDownLoad) {
		file_manager.download( network_position , data_seq , ath_ord , orgname );
	}
}

function downloadCheckProcess(data_position, data_seq, orders) {
	var btnDownload = $('#btnDownload');
	changeFileSendButton( btnDownload , 'down_disable' );
	file_manager.isDownLoad = true;
	
	time = setTimeout(function() {
		if( orders ) {
			getDownloadStatus(data_position, data_seq);
		}else {
			getDownloadStatus(data_position, data_seq, orders);			
		}
	}, 2500);	
	getDownloadComplete(data_position, data_seq, orders);
}

function getDownloadStatus( network_position, data_seq, orders ) {
	var param = {
		'network_position': network_position,
		'data_seq': data_seq,
		'orders': (orders == null || orders == "")? "":orders
	};
	
	$.ajax({
		type : "get",
		url : "/file/getDownloadStatus.lin",
		data : param, 
		dataType : "json",
		cache : false,
		error : function(xhr, status, error) {
			console.error(xhr);
		},
		success : function(response) {
			var result = response['result'];
			
			if(result == "1") {
				setTimeout(function() {
					getDownloadStatus(data_position, data_seq, orders);
				},1000);
			}else {
				file_manager.isDownLoad = false;
				changeFileSendButton( $('#btnDownload') , 'download' );
			}
		}
	});
}

function getDownloadComplete(network_position, data_seq, orders){
	var url = '/file/getDownloadComplete/'+network_position+'/'+data_seq+'.lin';
	
	if( orders != null ){ 
		url+='?';
		if(typeof(orders) == 'string'){
			var order = JSON.parse(orders);
			url += 'orders=' + order;
		}else{
			for( var i=0; i <orders.length; i++ ){
				url += 'orders='+orders[i].value;
				url += (i != orders.length -1) ? '&' : '';
			}
		}
		
	}
	
	$.ajax({
		type : "get",
		url : url,
		dataType : "json",
		cache : false,
		error : function(xhr, status, error) {
			console.error(xhr);
		},
		success : function(response) {
			var app_download = response['app_download'];
			var app_download_use = response['app_download_use'];
			var files = response['files'];
			if(app_download){
				appRejectBtnShow(); // 결재자 전체 다운로드 시 버튼 활성화
			}
			
			// 다운로드 시간 UI 업데이트
			for(var i=0;i<files.length;i++){
				if(app_download_use){
					$('#download_time' + files[i].ath_ord).text(dateFormatter(files[i].app_download_time));
				}else{
					$('#download_time' + files[i].ath_ord).text(dateFormatter(files[i].user_download_time));
				}
			}
		}
	});
}

function dateFormatter(timestamp){
	var date = new Date(timestamp);
	date.setHours(date.getHours() + 9);
    return date.toISOString().replace('T', ' ').substring(0, 16);
}

function btnBlocking($id){
	buttonInActive($id);
	
	_time = setTimeout(function(){
		buttonActive($id);
	},2500);
	
	eval(""+$($id).attr("id")+" = _time;");
}

function buttonActive($id){
	$id.removeClass('disabled');
	eval("var cloneST = "+$($id).attr("id"));
	clearTimeout(cloneST);
}


function buttonInActive($id){
	$id.addClass('disabled');
}

function changeFileSendButton($button,type){
	var text = $button.find('.text');
	$button.removeClass('disable');
	$button.removeClass('error');
	$button.removeClass('preparing');
	$button.removeClass('down_disable');
	
	switch (type) {
	case 'ready':
		text.html('자료전송');
		break;
	case 'preparing':
		text.html('전송준비중');
		$button.addClass('preparing');
		break;
	case 'down_disable':
		text.html('준비중..');
		$button.addClass('down_disable');
		break;
	case 'processing':
		text.html('전송중...');
		$button.addClass('disable');
		break;
	case 'error':
		text.html('재시도');
		$button.addClass('error');
		break;
	case 'full' :
		text.html('용량 초과');
		$button.addClass('full');
		break;
	case 'send' :
		text.html('<img class="btn_icon" alt="자료전송아이콘" src="/Images/icon/icon_file_03.png"/>보내기');
		break;
	case 'download' :
		text.html('&nbsp;다운로드&nbsp;');
		break;
	}
}

// 결재자 approvalView 페이지 파일 다운로드 완료 시 승인, 반려 버튼 보이게 처리
function appRejectBtnShow() {
	$('#app_btn').removeClass('none');
	$('#rj_btn').removeClass('none');
}