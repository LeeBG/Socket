var sessionAutoExpireTimeout = 1000 * getCookie("SESSIONAUTOEXPIRETIME");
var sessionAutoExpireInterval = 1000;
var sessionAutoExpireLastTime;
var sessionAutoExpireTimeId;

function sessionAutoExpireDoExpire() {
	var date = new Date();
	var nowTime = date.getTime();
	if (sessionAutoExpireLastTime + sessionAutoExpireTimeout < nowTime) {
		clearInterval(sessionAutoExpireTimeId);
		document.location = "/sign/sessionExpire.lin";
	}
}

function sessionAutoExpireUpdateLastTime() {
	var date = new Date();
	sessionAutoExpireLastTime = date.getTime();
}

if (sessionAutoExpireTimeout > 0) {
	var date = new Date();
	sessionAutoExpireLastTime = date.getTime();
	sessionAutoExpireTimeId = setInterval("sessionAutoExpireDoExpire()", sessionAutoExpireInterval);

	addEvent(document, "mousemove", sessionAutoExpireUpdateLastTime);
	addEvent(document, "keydown", sessionAutoExpireUpdateLastTime);
}
