
/**
2000 : agent와 통신시 에러나는 경우
2001 : 법제처 로그인요청시 미인증 사용자인 경우
2002 : TRS로그인 요청시 로그인에 실패한 경우
*/
var errorCode={
	AGENT_TRANSFER_ERROR 	: "2000",
	LOGIN_AUTHORIZE_ERROR 	: "2001",	
	TRS_LOGIN_ERROR 		: "2002"
};

/**
TRS ID로만 로그인 인증
성공시 목록페이지로, 실패시 에러 다이얼로그 호출
*/
function ssoLogin( successCallbackFx, failCallbackFx, isGpkiUse ) {
	var form = document.lform;
	var errmsg = cls_errmsg();
	var loginReqeustUrl = null;

	if( isGpkiUse ) loginReqeustUrl = "/sign/gpkiLogin.lin";
	else loginReqeustUrl = "/sign/sso.lin";

	resultCheckFunc($("#lform"), loginReqeustUrl, function(response) {
		var code = response['code'];
		var message = response['message'];
		if (code == "200") {
			successCallbackFx();
		} else {
			failCallbackFx(response);
		}
	});
}


//다이얼로그 보여주기
function showErrorDialog( error ){
	console.log('error = ',error);
	switch (error.code) {
	case errorCode.AGENT_TRANSFER_ERROR:
		alert("Agent와 통신 중에 문제가 발생하였습니다.");
		break;
	case errorCode.LOGIN_AUTHORIZE_ERROR:
		alert("사용자 인증 중에 문제가 발생하였습니다."+" "+error.data);
		break;
	case errorCode.TRS_LOGIN_ERROR:
		alert("로그인 처리 중에 문제가 발생하였습니다. [code="+error.data.code+"]");
		break;
	default:
		alert("알 수 없는 문제가 발생하였습니다.");
		break;
	}
}
