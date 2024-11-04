document.write("<script src='/JavaScript/common.js'></script>");

var currentOffset = calcOffset();
function checkSession(localTime) {
	var sessionExpiredTime;
	try{
		sessionExpiredTime = replaceSpecialSymbol(getCookie('SESSIONEXPIREDTIME'));
		sessionExpiredTime = JSON.parse(sessionExpiredTime);
	} catch(e) { }
	if(!localTime){
		localTime = sessionExpiredTime.serverTime;
	}
	localTime += 1000;
	
	var remainMillisecond = sessionExpiredTime.remainSessionTime - localTime;
    var remainSecond = Math.round( remainMillisecond / 1000 );
    
    if (sessionExpiredTime.remainSessionTime == null || sessionExpiredTime.remainSessionTime == '' 
    	|| sessionExpiredTime.remainSessionTime == 'undefined') {
    	$("#remainSessTime").text( 'checking..' );
    } else {
    	if ( remainMillisecond > 0 ) {
    		setTimeout('checkSession('+localTime+')', 1000);
    		$("#remainSessTime").text( moment().startOf('day').seconds(remainSecond).format('H:mm:ss') );
    	} else {
    		location.href='/sign/sessionExpire.lin';
    	}
    }
}

function calcOffset() {
	var sessionExpiredTime = replaceSpecialSymbol(getCookie('SESSIONEXPIREDTIME'));
	sessionExpiredTime = JSON.parse(sessionExpiredTime);
	
	return (new Date()).getTime() - sessionExpiredTime.serverTime;
}

function replaceSpecialSymbol(str) {
	var r_str = str.replace(/\\/gi, "");
	r_str = r_str.replace(/"{/g, "{");
	r_str = r_str.replace(/}"/g, "}");
	
	return r_str;
}