/**
 * 
 */
$(document).ready(function(){
	getNoticeEnv( showNotification );
	
	function showNotification( data ){
		env_cookie_consist_day = data['cookie_consist_day'];
		var network = (typeof(networkPosition) != 'undefined') ? networkPosition : (typeof(env) != 'undefined' && env.networkPosition) ? env.networkPosition : '';
		var bfaf = location.href.includes('/sign/index') || location.href.includes('/sign/gpki/index') ? 'bf' : 'af';
		if( network == 'I' && bfaf =='bf' ){
			if ( data['user_in_bf_login_notice'] ){
				new NPPopupManager(data['user_in_bf_login_notice'].replace(/\n/g,'<br>'), 'N', data['env_seq'] , data['cookie_consist_day']);
			}
		}else if( network == 'I' && bfaf =='af' ){
			if ( data['user_in_af_login_notice'] ){
				new NPTimedNotificationManager(data['user_in_af_login_notice'].replace(/\n/g,'<br>'), 'N', data['env_seq'], data['cookie_consist_day']);
			}
		}else if( network == 'O' && bfaf =='bf' ){
			if ( data['user_out_bf_login_notice'] ){
				new NPPopupManager(data['user_out_bf_login_notice'].replace(/\n/g,'<br>'), 'N', data['env_seq'], data['cookie_consist_day']);
			}
		}else if( network == 'O' && bfaf == 'af' ){
			if ( data['user_out_af_login_notice'] ){
				new NPTimedNotificationManager(data['user_out_af_login_notice'].replace(/\n/g,'<br>'), 'N', data['env_seq'], data['cookie_consist_day']);
			}
		}
	}
});

function getNoticeEnv ( successCallbackFx ){
	$.ajax({
		url:'/env/notification.lin',
		method: 'GET',
		cache: false,
		dataType: 'json',
		success: function( data ){
			if( successCallbackFx ){
				successCallbackFx( data );
			}
		},
		error: function(error){
			console.error(error);
		}
	});

}

var NPPopupManager = function( content , sampleYN , env_seq , cookie_consist_day ){
	content = content.replace(/\n/g,'<br>');
	this.isSample = sampleYN == 'Y' ? true : false;
	
	if( ! this.isSample && document.cookie ){
		var env_seq_before = env_seq - 1;
		
		if( document.cookie.indexOf('bf.popup.' + env_seq_before) > -1){
			setCookie('bf.popup.' + env_seq_before, '', 0); // env_seq가 변경되어 기존 cookie 삭제
		}
		
		if( document.cookie.indexOf('bf.popup.' + env_seq + '=noshow') > -1 ){
			return;
		}
	}
	
	var classes = 'nonevisible layer_popup';
	this.outerid = 'layerOuter';
	this.popupid = 'layerPopup';
	this.noshowid = 'popup-noshow';
	this.layerOuterCode = [
		'<div id="'+this.outerid+'" class="layerOuter">',
		'</div>'
	].join('');
	this.layerPopupCode = [
		'<div id="'+this.popupid+'" class="'+classes+'">',
			'<div class="header">알림<a class="close close-image">팝업닫기</a></div>',
			'<div class="body table"><p class="cell">'+content+'</p></div>',
			'<div class="footer">',
				'<input type="checkbox" id="'+this.noshowid+'"><label for="'+this.noshowid+'">' + cookie_consist_day +'일동안 보지않기</label>',
				'<button class="button close" style="margin-left:10px;">닫기</button>',
			'</div>',
		'</div>'
	].join('');
	
	this.create(env_seq, cookie_consist_day);
};

NPPopupManager.prototype.create = function(env_seq, cookie_consist_day){
	$('body').append(this.layerOuterCode);
	$('#'+this.outerid).append(this.layerPopupCode);

	var popupManager = this;
	
	var $outer = $('#'+this.outerid);
	var $popup = $('#'+this.popupid);
	$popup.draggable().position({
		of : $outer,
		my : "center center"
	});
	$popup.find('.close').click(function(){
		popupManager.close(env_seq, cookie_consist_day);
	})
	$outer.click(function(){
		popupManager.close(env_seq, cookie_consist_day);
	})
	$popup.removeClass('nonevisible');
	$popup.find('div').click(function(e){
		e.stopPropagation();
	})
};

NPPopupManager.prototype.close = function(env_seq, cookie_consist_day){
	if( ! this.isSample && $('#'+this.noshowid).prop('checked') ){
		setCookie('bf.popup.' + env_seq,'noshow', cookie_consist_day);
	}
	$("#"+this.outerid).remove();
}

var NPTimedNotificationManager = function( content , sampleYN , env_seq , cookie_consist_day){
	this.isSample = sampleYN == 'Y' ? true : false;
	content = content.replace(/\n/g,'<br>');
	if( ! this.isSample && document.cookie ){
		var env_seq_before = env_seq - 1;
		
		if( document.cookie.indexOf('af.popup.' + env_seq_before) > -1){
			setCookie('af.popup.' + env_seq_before, '', 0); // env_seq가 변경되어 기존 cookie 삭제
		}
		
		if( document.cookie.indexOf('af.popup.' + env_seq + '=noshow') > -1 ){
			return;
		}
	}
	
	var classes = 'layer_notification';
	this.notiid = 'layerNotification';
	this.noshowid = 'noti-noshow';
	this.timeout = 6;
	this.notificationCode = [
		'<div id="'+this.notiid+'" class="'+classes+'" style="display:none;">',
			'<div class="header pd_a5">알림<a class="close close-image pd_a3">팝업닫기</a></div>',
			'<div class="body pd_a5">'+content+'</div>',
			'<div class="footer pd_a5 t_right">',
				'<input type="checkbox" id="'+this.noshowid+'"><label for="'+this.noshowid+'">' + cookie_consist_day + '일동안 보지않기</label>',
			'</div>',
		'</div>'
	].join('');
	
	this.create(env_seq, cookie_consist_day);
}

NPTimedNotificationManager.prototype.create = function(env_seq, cookie_consist_day){
	var notiManager = this;
	
	var $noti = $('#'+this.notiid);
	
	if( $noti.length > 0 ) {
		$noti.remove(); 
		clearTimeout( this.timeoutid );
	}
	
	$('body').append(this.notificationCode);
	$noti = $('#'+this.notiid).fadeIn('slow');
	$noti.find('.close').click(function(){
		notiManager.close(env_seq, cookie_consist_day);
	});
	
	//setTimeout( function(){ notiManager.close(); } , this.timeout*1000 );
};

NPTimedNotificationManager.prototype.close = function(env_seq, cookie_consist_day){
	if( ! this.isSample && $('#'+this.noshowid).prop('checked') ){
		setCookie('af.popup.' + env_seq,'noshow',cookie_consist_day);
	}
	var $noti = $('#'+this.notiid);
	$noti.fadeOut('slow');
	this.timeoutid = setTimeout(function(){$noti.remove();},1000);
};

function setCookie(cookie_name, value, days) {
  var exdate = new Date();
  exdate.setDate(exdate.getDate() + days);
  // 설정 일수만큼 현재시간에 만료값으로 지정

  var cookie_value = escape(value) + ((days == null) ? '' : ';    expires=' + exdate.toUTCString()+';path=/');
  document.cookie = cookie_name + '=' + cookie_value;
}
