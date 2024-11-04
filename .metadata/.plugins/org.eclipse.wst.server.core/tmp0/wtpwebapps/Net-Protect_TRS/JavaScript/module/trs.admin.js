function addExtension( formid, ext, block_msg ){
	var mimetype;
	if( block_msg.indexOf(']') > 0 ){
		var s_idx = block_msg.lastIndexOf('[');
		var e_idx = block_msg.lastIndexOf(']');
		mimetype = block_msg.substring(s_idx+1 , e_idx);
	}else{
		mimetype = block_msg;
	}

	if( ext == '' ||  ext == '없음' ){
		alert('빈값인 확장자는 목록에 추가할 수 없습니다.');
		return;
	}
	if( mimetype == '없음' || mimetype == '' ){
		alert('다음과 같은 마임타입은 목록에 추가할 수 없습니다.\n마임타입 : ['+mimetype+']');
		return;
	}
	if( ! confirm( '확장자 : ['+ext+'], 마임타입 : ['+mimetype+'] 를 확장자 목록에 추가하시겠습니까?' ) ){
		return;
	}
	
	$('#exts').val(ext);
	$('#mime_type').val(mimetype);
	
	var requestURL = "/policy/extPolicy/insertExt.lin";

	resultCheckFunc($("#"+formid), requestURL, function(response) {
		var code = response['code'];
		var message = response['message'];
		if (code == "200") {
			alert('다음과 같은 정보가 확장자 목록에 추가되었습니다.\n확장자 : ['+ext+'], 마임타입 : ['+mimetype+']\n확장자 정책은 따로 설정이 필요합니다.');
			return;
		} 
		if( message ){
			alert(message+'\n확장자 : ['+ext+'], 마임타입 : ['+mimetype+']');
		}else{
			alert('확장자 추가에 실패했습니다.\n확장자 : ['+ext+'], 마임타입 : ['+mimetype+']');
		}
	});
}