document.write('<object classid="CLSID:FB1DC4F7-58E5-4AE0-A935-0D0EBCB8F450" codebase="./SWELCtrl_.cab#version=2,0,2,28" width="0" height="0" id="SWELCtrl" ></object>');
var authkey = "WLAF-EOXB-TJPG-QALF";
var processtype = "2";
function swork_start(controltype) {
	console.log("SWELCtrl.js swork_start()");
	try {
		var statuscheck = SWELCtrl.SWorkGetStatus(authkey);
		console.log(" statuscheck = [" + statuscheck + "]");
		if (statuscheck == 3 || statuscheck == 101) {
			var ret1 = SWELCtrl.SWorkSetProcess(authkey, processtype);
			var ret2 = SWELCtrl.SWorkSetIEControlPolicy(authkey, controltype);
			//console.log(" [" + authkey + "]/[" + processtype + "/[" + controltype + "/[" + ret2 + "");
			if (ret2 == true) {
				console.log("정상 동작 : 리턴값1[" + ret1 + "]");
			} else {
				console.log("에러 발생 : 리턴값1[" + ret1 + "]");
			}
		} else if (statuscheck == 1) {
			console.log("S-Work이 로그인 되어 있지 않습니다.");
		}
	} catch (e) {
		console.log("S-Work Linker 가 설치되지 되어 있지 않습니다.");
	}
	setTimeout(function(){
		swork_end();
	},60000);
}

function swork_end() {
	console.log("SWELCtrl.js swork_end()");
	SWELCtrl.SWorkReleaseProcess(authkey, processtype);
}
$(document).ready(function() {
	window.onunload = function() {
		swork_end();
	}
});
