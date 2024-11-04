if(top != window) {
  top.location = window.location
}

var ERROR_MSG_TITLE = "";
var EXPIRE_MSG = "세션이 만료되었습니다.";
var ERROR_INTERCEPTOR = "잘못된 접근입니다.";

function allInputDisable() {
	$("input").each(function(idx){
		$(this).attr("disabled", true);
	});
}
function cls_errmsg() {
	this.haserror = false;
	this.msg = "";
	this.append = errmsg__append;
	this.show = errmsg__show;
	this.showSuccess = successMsg__show;
	this.init = errmsg__init;
	return this;
}

function errmsg__append(obj, msg) {
	if (!this.haserror) {
		try {
			if (obj != null) {
				obj.focus();
			}
		} catch (e) {
		}

		this.haserror = true;
		this.msg = "";
	}else{
		this.msg += "\n";
	}

	this.msg += msg;
}

function errmsg__show() {
	if (this.haserror) {
		alert(this.msg);
	}
	return !this.haserror;
}

function successMsg__show() {
	if (this.haserror) {
		alert(this.msg);
	}
	return !this.haserror;
}

function errmsg__init() {
	this.haserror = false;
	this.msg = "";
}

function resultCheck(formObj, requestURL, successURL, useSuccessMessage) {
	$.ajax({
		type : "post",
		url : requestURL,
		data : $(formObj).serialize(),
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
			resultSuccess(response, successURL, useSuccessMessage);
		}
	});
}

function resultCheckFunc(formObj, requestURL, successFunc) {
	var jsonObj = $.parseJSON(formObj);
	var params = null;
	if (jsonObj == null || typeof jsonObj != 'object') {
		params = $(formObj).serialize();
	} else {
		params = jsonObj;
	}

	$.ajax({
		type : "post",
		url : requestURL,
		data : params,
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
			if (successFunc != null) {
				successFunc(response);
			}
		}
	});
}

function resultCheckFunc(formObj, requestURL, successFunc, errorFunc) {
	var jsonObj = $.parseJSON(formObj);
	var params = null;
	if (jsonObj == null || typeof jsonObj != 'object') {
		params = $(formObj).serialize();
	} else {
		params = jsonObj;
	}

	$.ajax({
		type : "post",
		url : requestURL,
		data : params,
		dataType : "json",
		error : function(xhr, status, error) {
			if (xhr.status == 401) {
				resultSessionExpire(xhr);
			} else if (xhr.status == 200) {
				resultInterceptorError(xhr);
			} else {
				errorFunc(xhr.response);
			}
		},
		success : function(response) {
			if (successFunc != null) {
				successFunc(response);
			}
		}
	});
}

function beforeSendResultCheckFunc(formObj, requestURL, successFunc) {
	var jsonObj = $.parseJSON(formObj);
	var params = null;
	if (jsonObj == null || typeof jsonObj != 'object') {
		params = $(formObj).serialize();
	} else {
		params = jsonObj;
	}

	$
			.ajax({
				type : "post",
				url : requestURL,
				data : params,
				dataType : "json",
				beforeSend : function() { // "Ajax 실행전 실행될 스크립트"
					$("#loading_img").css("display", "block");
					$("body")
							.append(
									"<div id='loading_back' style='position:absolute; width:100%; height:150%; z-index:10; background-color:#000; margin-top:-500px;'></div>");
					$("#loading_back").fadeTo(0, 0.6);
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
					if (successFunc != null) {
						successFunc(response);
					}
				}
			});
}

function autoCompleteId(formObj, siteCode) {
	if (siteCode != "cnuh") {
		return;
	}
	$("#users_id").autocomplete({
		source : function( request, response ) {
			userIdAutoComplete(formObj, response);
		},
		//글자순으로 보여주는 옵션
		matchContains: true,
		//조회를 위한 최소글자수
		minLength: 10,
		messages: {
			noResults: '',
			results: function() {}
		},
		select: function( event, ui ) {
			//만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생
			$("#users_pw").focus();
		}
	});
	function userIdAutoComplete(formObj, response) {
		$.ajax({
			type: 'post',
			url: "/sign/userIdAutoComplete.lin",
			dataType: "json",
			data: $(formObj).serialize(),
			success : function(data) {
				response($.map(data, function(item) {
					return{
						label: item.users_id + " : " +item.dept_nm + "("+item.position_nm+")",
						value : item.users_id,
						id: item.users_id
					};
				}))
			}
		});
	}
}

function resultSessionExpire(response) {
	alert(EXPIRE_MSG);

	var context = getContextPath();
	$(location).attr("href", context + "/sign/management.lin");
}

function resultInterceptorError(response) {
	alert(ERROR_INTERCEPTOR);

	$(location).attr("href", location.href);
}

function getContextPath() {
	var offset = location.href.indexOf(location.host) + location.host.length;
	var ctxPath = location.href.substring(offset, location.href.indexOf('/',
			offset + 1));
	return ctxPath;
}

function resultSuccess(response, successURL, useSuccessMessage) {
	if (response.code == "200") {
		if (successURL != "") {
			if (useSuccessMessage == true) {
				alert(response.message);
			}
			$(location).attr("href", successURL);
		}
	} else {
		resultMessage(response);
	}
}

function resultUnsuccessFunc(response, successURL, useSuccessMessage, unSuccessFunction) {
	if (response.code == "200") {
		if (successURL != "") {
			if (useSuccessMessage == true) {
				alert(response.message);
			}
			$(location).attr("href", successURL);
		}
	} else {
		unSuccessFunction(response);
	}
}

function resultMessage(response) {
	var errmsg = new cls_errmsg();

	var messages = response.message;
	for (var i = 0; i < messages.length; i++) {
		errmsg.append(null, messages[i]);
	}

	if (errmsg.haserror) {
		errmsg.show();
	}
}

function resultError(error) {
	var errmsg = new cls_errmsg();

	errmsg.append(null, error);

	if (errmsg.haserror) {
		errmsg.show();
	}
}

function getValidNumberRange(number, from, to) {
	if (number == null || number == "")
		return number;
	if (number < from) {
		return from;
	} else if (number > to) {
		return to;
	} else {
		return number;
	}
}

function isValidPhone(number) {
	if (number.length <= 0 || number.charAt(0) != "0" || number.length < 9
			|| 13 < number.length) {
		return false;
	}

	for (var i = 0; i < number.length; i++) {
		var c = number.charAt(i);
		if (!isNumber(c) && c != '-') {
			return false;
		}
	}

	return true;
}

function isValidPhoneList(id) {
	var isInvalid = false;
	var numbers = $("#" + id).val().split("\n");
	if (!empty($("#" + id).val()) && numbers.length > 0) {
		for (var i = 0; i < numbers.length; i++) {
			number = trim(numbers[i]);
			if (empty(number))
				continue;
			if (!isValidPhone(number)) {
				isInvalid = true;
				break;
			}
		}
	}
	return isInvalid;
}

function isValidEmail(email) {
	var length = email.length;

	if (length < 7 || length > 320) {
		return false;
	}

	var list = email.split(/@/);

	if (!(list.length == 2)) {
		return false;
	}

	if (list[0].length > 64) {
		return false;
	}

	if (!regexp(list[0], /^[^ -,\/:-@\[-^`{-}~]+$/)) {
		return false;
	}

	if (!isValidURL(list[1])) {
		return false;
	}

	return true;
}

function isValidEmailList(id) {
	var ret = {};

	var hasReceiver = false;
	var disableReceiver = false;
	var receivers = $("#" + id).val().split("\n");
	if (!empty($("#" + id).val()) && receivers.length > 0) {
		for (var i = 0; i < receivers.length; i++) {
			receiver = trim(receivers[i]);
			if (empty(receiver))
				continue;
			if (isValidEmail(receiver)) {
				hasReceiver = true;
			} else {
				disableReceiver = true;
				break;
			}
		}
	}

	ret.hasReceiver = hasReceiver;
	ret.disableReceiver = disableReceiver;
	return ret;
}

function isValidPassword(password, complexity) {
	var minLength = 4;
	var maxLength = 20;

	if (complexity == undefined) {
		return false;
	}

	if (complexity == 0) {
		return !password.empty();
	}

	var length = password.length;

	if (length < minLength || length > maxLength) {
		return false;
	} else {
		var regex1 = /\d/;
		var regex2 = /[a-zA-Z]/;
		var regex3 = /[`~!?:;@\#$%^&*\()\-=+_'\"|{}<>,.]/gi;

		if (complexity > 1) {
			if (!(regex1.test(password) && regex2.test(password))) {
				return false;
			} else {
				if (complexity > 2) {
					if (!regex3.test(password)) {
						return false;
					} else {
						return true;
					}
				}
				return true;
			}
		} else {
			return true;
		}
	}
}

function isValidURL(url) {
	var list = url.split(/\./);
	var length = list.length;

	if (length < 2) {
		return false;
	}

	if (url.length > 255) {
		return false;
	}

	for (var i = 0; i < length - 1; i++) {
		if (!regexp(list[0], /^[^ -,\/:-@\[-`{-}~]+$/)) {
			return false;
		}
	}

	var suffix = list[length - 1];
	var slength = suffix.length;
	if (!regexp(suffix, /^[a-z]+$/) || slength < 2 || slength > 5) {
		return false;
	}

	return true;
}

function isValidMac(macAddress) {
	var regex=/^([0-9a-f]{1,2}[\.:-]){5}([0-9a-f]{1,2})$/i;
	if (regex.test(macAddress)) {
		return true;
	} else {
		return false;
	}
}

// 192.168.0.2->pass, 192.168.0.2/24->fail
/*function isValidIP(ip) {
	if (!regexp(ip, /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/)) {
		return false;
	}

	var iplist = ip.split("\.");
	for (var i = 0; i < iplist.length; i++) {
		if (iplist[i] < 0 || iplist[i] > 255) {
			return false;
		}
	}
	return true;
}*/
function isValidIP(ip) {
	if (!regexp(ip, /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/)) {
		return false;
	}

	var iplist = ip.split("\.");
	for (var i = 0; i < iplist.length; i++) {
		if (iplist[0] < 1 || iplist[0] > 255) {
			return false;
		}
		if (iplist[i+1] < 0 || iplist[i+1] > 255) {
			return false;
		}
	}
	return true;
}


// 192.168.0.2->pass, 192.168.0.2/24->pass
function isValidIP2(ip) {
	if (!regexp(ip, /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/)
			&& !regexp(ip,
					/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(\/(([1-2]?[0-9])|(3[0-2]))){0,1}$/)) {
		return false;
	}

	var iplist = ip.split("\.");
	for (var i = 0; i < iplist.length; i++) {
		if (iplist[i] < 0 || iplist[i] > 255) {
			return false;
		}
	}

	return true;
}

function isValidIpList2(id) {
	var isInvalid = false;
	var ips = $("#" + id).val().split("\n");

	if (empty($("#" + id).val())) {
		isInvalid = true;
		return isInvalid;
	}

	for (var i = 0; i < ips.length; i++) {
		ip = trim(ips[i]);
		if (empty(ip))
			continue;
		if (!isValidIP2(ip)) {
			isInvalid = true;
			break;
		}
	}

	return isInvalid;
}

function isValidIPSimple(ip) {
	/*if (!regexp(ip, /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/)) {
		return false;
	}*/

	var iplist = ip.split("\.");
	for (var i = 0; i < iplist.length; i++) {
		if (iplist[i] < 0 || iplist[i] > 255) {
			return false;
		}
	}
	return true;
}

function isValidPort(port) {
	if (!regexp(port, /^\d+$/)) {
		return false;
	}

	if (parseInt(port) < 1 || parseInt(port) > 65535) {
		return false;
	}

	return true;
}

function isValidServer(server) {
	return (isValidURL(server) || isValidIP(server));
}

function isNumber(s) {
	if (s.empty()) {
		return false;
	}
	if (regexp(s, /(^\s)|(\s$)/) || isNaN(s)) {
		return false;
	} else {
		return true;
	}
}

function isValidExtension(s) {
	if (regexp(s, /^[0-9a-zA-Z]{1,30}$/i)) {
		return true;
	} else {
		return false;
	}
}

function isValidExtensionList(id) {
	var extension = '';
	var extensions = $("#" + id).val().split(",");
	if (!empty($("#" + id).val()) && extensions.length > 0) {
		for (var i = 0; i < extensions.length; i++) {
			extension = trim(extensions[i]);
			if (empty(extension))
				continue;
			if (isValidExtension(extension)) {
				// do nothing
			} else {
				return false;
			}
		}
	}
	return true;
}

function togchk(obj, name) {
	$("input:checkbox[name=" + name + "]:enabled").attr("checked", $(obj).is(":checked"));
}

function togchk2(checked, name) {
	$("input:checkbox[name=" + name + "]").attr("checked", checked);
}

function radioCheck(obj) {
	if (obj == undefined) {
		return false;
	}

	if (obj.length == 0) {
		return false;
	}

	for (var i = 0; i < obj.length; i++) {
		if (obj[i].checked) {
			return true;
		}
	}

	return false;
}

function radioCheckValue(obj) {
	var rtn = "";

	if (obj == undefined) {
		return rtn;
	}

	for (var i = 0; i < obj.length; i++) {
		if (obj[i].checked) {
			rtn = obj[i].value;
			break;
		}
	}

	return rtn;
}

function isSelect(name) {
	if (!name)
		name = "chk";

	var elements = document.getElementsByName(name);
	for (var i = 0; i < elements.length; i++) {
		if (elements[i].name == name && elements[i].checked) {
			return true;
		}
	}

	return false;
}

function regexp(s, regexp) {
	return regexp.test(s);
}

function stringLength(s) {
	var n = 0;
	for (var i = 0; i < s.length; i++) {
		var hex = escape(s.substring(i, i + 2));
		if (hex == "%0D%0A") {
			i++;
		} else {
			n++;
		}
	}
	return n;
}

function setCookie(name, value, expiredays) {
	var todayDate = new Date();
	todayDate.setTime(todayDate.getTime() + expiredays);
	document.cookie = name + "=" + escape(value) + "; path=/; expires="
			+ todayDate.toGMTString() + ";";
}

function getCookie(name) {
	var search = name + "=";

	if (document.cookie.length > 0) {
		var decodedCookie = decodeURIComponent(document.cookie);
		var ca = decodedCookie.split(';');
		for (var i = 0; i < ca.length; i++) {
			var c = ca[i];
			c = c.replace(/^\s*/,"");
			
			if (c.indexOf(name + '=') == 0) 
				return unescape(c.substring(name.length + 1, c.length));
		}
	}

	return "";
}

String.prototype.empty = function() {
	return (this == undefined || this.trim() == "");
};

String.prototype.trim = function() {
	if (this == undefined)
		return "";
	return this.replace(/^\s+|\s+$/g, "");
};

String.prototype.ltrim = function() {
	if (this == undefined)
		return "";
	return this.replace(/^\s+/, "");
};

String.prototype.rtrim = function() {
	if (this == undefined)
		return "";
	return this.replace(/\s+$/, "");
};

String.prototype.replaceAll = function(str1, str2)
{
  var temp_str = this.trim();
  temp_str = temp_str.replace(eval("/" + str1 + "/gi"), str2);
  return temp_str;
};

function addEvent(obj, type, fn) {
	if (obj.addEventListener) {
		obj.addEventListener(type, fn, false);
	} else if (obj.attachEvent) {
		obj["e" + type + fn] = fn;
		obj[type + fn] = function() {
			obj["e" + type + fn](window.event);
		};

		obj.attachEvent("on" + type, obj[type + fn]);
	}
}

function eventClose(e) {
	var code = (window.event) ? event.keyCode : e.which;

	if (code == 27) {
		popupClose();
	}
}

function popupClose() {
	if (window.opener == undefined) {
		window.opener = window;
	}
	window.close();
}

function getFullDigit(input) {
	input = input + '';
	return (input != null && input.length == 1 ? '0' + input : input);
}

function fileSizeFormat(value) {
	var intByteSize = parseInt(value);

	return intByteSize >= Math.pow(1024, 3) ? parseFloat(
			value / Math.pow(1024, 3)).toFixed(1)
			+ ' GB' : intByteSize >= Math.pow(1024, 2) ? parseFloat(
			value / Math.pow(1024, 2)).toFixed(1)
			+ ' MB' : intByteSize >= 1024 ? parseFloat(value / 1024).toFixed(1)
			+ ' KB' : intByteSize + ' B';
}

function trim(s) {
	if (s == undefined)
		return "";
	return s.replace(/^[\r\n\t ]+/, "").replace(/[\r\n\t ]+$/, "");
}

function empty(s) {
	return (s == undefined || trim(s) == "");
}

function elementDisable(id) {
	$("#id").attr("disabled", "disabled");
}

function elementsDisable(ids) {
	if (ids.length > 0) {
		for (var i = 0; i < ids.length; i++) {
			$("#" + ids[i]).attr("disabled", "disabled");
		}
	}
}

function elementEnable(id) {
	$("#id").removeAttr("disabled");
}

function elementsEnable(ids) {
	if (ids.length > 0) {
		for (var i = 0; i < ids.length; i++) {
			$("#" + ids[i]).removeAttr("disabled");
		}
	}
}

function setReadOnly(id) {
	$("#" + id).attr("readonly", "readonly");
}

function unsetReadOnly(id) {
	$("#" + id).removeAttr("readonly");
}

var HTML_CHAR_MAP = {
	'<' : '&lt;',
	'>' : '&gt;',
	'&' : '&amp;',
	'"' : '&quot;',
	"'" : '&#39;'
};

function escapeHtml(s) {
	return s.replace(/[<>&"']/g, function(ch) {
		return HTML_CHAR_MAP[ch];
	});
}

function unEscapeHtml(s) {
	return s.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&')
			.replace(/&quot;/g, '"').replace(/&#39;/g, "'");
}

function locationHref(url) {
	location.href = url;
}

function goPage(page) {
	$("#page").val(page);
	$("#pageMove").val("Y");
	$("#lform").get(0).submit();
}

function goTotalPage(page) {
	$("#page").val(page);
	$("#pageMove").val("Y");
	getTotalDataList();
}

function setPagingHtml(totalCount, pageList) {
	var paging_area= "<span class='text_list_number'>총" + totalCount + "건</span>"
	+ "<div class='pagenate t_center'>"
	+ pageList
	+ "</div>" ;
	$('#td_last').html(paging_area);
}

function goLastPage(){ 
	var curPage = Number($("#page").val()); 
	if(curPage > 1){ 
		$("#page").val((curPage)-1); 
		$("#lform").get(0).submit(); 
	}
}

function getDataStatus(str) {
	switch (str) {
	case "SS":
		return "전송완료";
	case "S":
		return "전송중";
	case "R":
		return "반려";
	case "AW":
		return "결재대기";
	case "F":
		return "전송오류";
	case "WD":
		return "회수완료";
	case "EW":
		return "기타검사대기";
	default:
		return "";
	}
}

// === mouseover tooltip start ===
document
		.write('<div id="lyrtooltip" name="lyrtooltip" style="font-size:9pt;border:1px solid #5256ac;position:absolute;display:none;z-index:10;padding:5px;background-color:#f3f3f3;word-wrap:break-word;" onmouseover="fixtooltip(true)" onmouseout="fixtooltip(false)"></div>');
var browser = navigator.userAgent;
var tooltiptimeoutid;
var tooltipfixed;

function fixtooltip(f) {
	tooltipfixed = f;
}

// obj : [this] or [String]
// When using [this] as parameter, this.value will be displayed in tooltip. In
// other case, [String] will be displayed.
function tooltip(event, obj) {
	var o = document.getElementById('lyrtooltip');
	if (obj == null && !tooltipfixed) {
		if (o) {
			o.opened = false;
			o.style.display = "none";
			clearTimeout(tooltiptimeoutid);
		}
	} else {
		if (o && event && document) {
			var str;
			if (typeof (obj) == "object" && obj != null) {
				str = obj.innerHTML;
			} else {
				str = obj;
			}

			o.innerHTML = str;
			o.style.display = "block";

			var BT = "";
			var BL = "";
			var BW = "";
			var BH = "";

			if (browser.indexOf('Safari') == -1) {
				BT = document.documentElement.scrollTop;
				BL = document.documentElement.scrollLeft;
				BW = document.documentElement.clientWidth;
				BH = document.documentElement.clientHeight;
			} else {
				BT = document.body.scrollTop;
				BL = document.body.scrollLeft;
				BW = document.body.clientWidth;
				BH = document.body.clientHeight;
			}

			BT = parseInt(BT);
			BL = parseInt(BL);
			BW = parseInt(BW);
			BH = parseInt(BH);

			var BR = BL + BW;
			var BB = BT + BH;

			var T = event.clientY + BT + 2;
			var L = event.clientX + BL + 2;
			var W = o.clientWidth;
			var H = o.clientHeight;

			if ((L + W + 2) > BR) {
				L = BR - W - 30;
			}

			if ((T + H + 2) > BB) {
				T = BB - H - 2;
			}

			o.style.top = T + "px";

			if (L < 0) {
				o.style.left = "30px";
			} else {
				o.style.left = L + "px";
			}

			if (BW > 1024 && (str != null && str.length > 400)) {
				o.style.left = "30px";
			}

			o.opened = true;

			tooltiptimeoutid = setTimeout("tooltip(null)", 5000);
		}
	}
	return;
}
// === mouseover tooltip end ===

//=== progress bar start ===

var blindDiv = "<div class=\"bg_blind\" id=\"blind\" style=\"display:none;cursor:wait;position:absolute;left:0;top:0;overflow-y:hidden;background:white;\"></div>";
document.write(blindDiv);

//숫자, 최대길이 필터
function onlyNumFillter(txtbox,maxSize) {
	var v = txtbox.value;
	if(v.length > 1){
		txtbox.value = v.substring(0,maxSize);
	}
	if (v.match(/[\-\+]?\d*(\.\d*)?/g)[0] != v) {
		txtbox.value = v.match(/[\-\+]?\d*(\.\d*)?/g)[0];
	}
}

//숫자 사이값 필터
function onlyNumBetweenFillter(txtbox,maxSize,minNum,maxNum) {
	var v = txtbox.value;
	if(v == null || v == ""){
		txtbox.value = v;
		return;
	}
	
	if(v.length > maxSize){
		txtbox.value = v.substring(0,maxSize);
	}
	
	$(txtbox).blur(function(){
		v = txtbox.value;
		if(v == null || v == ""){
			txtbox.value = null;
		}else if(v <= minNum){
			txtbox.value = minNum;
		}else if(v >= maxNum){
			txtbox.value = maxNum;
		}
	});
	if (v.match(/[\-\+]?\d*(\.\d*)?/g)[0] != v) {
		txtbox.value = v.match(/[\-\+]?\d*(\.\d*)?/g)[0];
	}
}
//사이즈 최대길이 필터
function onlySizeFillter(txtbox,maxSize) {
	var v = txtbox.value;
	if(v.length > maxSize){
		txtbox.value = v.substring(0,maxSize);
	}
}

// === helpPopup start ===
function opneHelpPopup(obj,message){
	var rightArea = $("#wrap");
	var popupPosition = $(obj).offset();
	var helpPopupTop = popupPosition.top + 25;
	var helpPopupLeft = popupPosition.left + 20;
	var helpPopupDiv = "<div class='helpPopup' style='position:absolute; top:"+ helpPopupTop + "px; left:"+ helpPopupLeft + "px; background-color:#fff; border:3px solid orange; padding:12px; z-index:9999;'><p>" + message + "</p></div>";
	rightArea.append(helpPopupDiv);
}

function closeHelpPopup(){
	$('.helpPopup').remove();
}

function checkFocusMessage(obj, message){
	$(obj).blur(function() {
		closeHelpPopup();
	}).focus(function() {
		opneHelpPopup(this, message);
	});
}
// === helpPopup end ===

function isValidSameRange(i,min,max){
	i = Number(i);
	min = Number(min);
	max = Number(max);
	if(i >= min && max >= i){
		return true;
	}
	return false;
}
function chkword(obj, maxByte) {

	var strValue = obj.value;
	var strLen = strValue.length;
	var totalByte = 0;
	var len = 0;
	var oneChar = "";
	var str2 = "";

	for (var i = 0; i < strLen; i++) {
		oneChar = strValue.charAt(i);
		if (escape(oneChar).length > 4) {
			totalByte += 2;
		} else {
			totalByte++;
		}

		// 입력한 문자 길이보다 넘치면 잘라내기 위해 저장
		if (totalByte <= maxByte) {
			len = i + 1;
		}
	}

	// 넘어가는 글자는 자른다.
	if (totalByte > maxByte) {
		alert(maxByte + "자를 초과 입력 할 수 없습니다.");
		str2 = strValue.substr(0, len);
		obj.value = str2;
		chkword(obj, 4000);
	}
}

$.prototype.changeReadonlyState = function( custom_add_yn , db_value ){
	var $this = $(this);
	if( ! custom_add_yn || custom_add_yn == 'Y') {
		$this.removeAttr("readonly")
		     .removeAttr("title")
		     .removeClass("readonly");
	    $this.tooltip({
	    	disabled : true
	    });
		
		if( $this.is("select") ){
			$this.removeAttr("onFocus")
			     .removeAttr("onChange");
		}
		if( $this.attr('type') == 'radio'){
			$this.removeAttr("disabled");
		}
	}else{
		$this.attr("readonly","readonly")
		     .attr("title","외부 연동 데이터로 수정이 불가능합니다.")
		     .addClass("readonly")
		     .tooltip({disabled : false});
		if( $this.is("select") ){
			$this.attr({'onFocus':'this.initialSelect = this.selectedIndex;','onChange':'this.selectedIndex = this.initialSelect;'});
		}
		if( $this.attr('type') == 'radio' && $this.val() != db_value){
			$this.attr("disabled","disabled");
		}
	}
}
function addZeroNumber( num ){
	if( num > 0 && num < 10 ) 
		return '0'+num;
	return num;
}

function keyDownEnterDoSearch(){
	if(event.keyCode == 13){
		return search();
	}
}

function SendTimeCheck( enteredTime, nowTime, preSendTime ){
	var timeCheck = true;
	var pageTime = (new Date()).getTime() - enteredTime.getTime();
	var remainTime = 30*1000 - (nowTime - preSendTime) - pageTime;
	if( remainTime > 0 ){
		alert(Math.ceil(remainTime/1000)+"초 후에 전송이 가능합니다.");
		timeCheck = false;
	}
	return timeCheck;
}

function serverStatusIcon(server_status) {
	if (server_status == '2') {
		return "<img src='../Images/icon/icon_warning_off.png'>" ;
	} else if (server_status == '3') {
		return "<img src='../Images/icon/icon_system_error_off.png'>" ;
	} else {
		return "<img src='../Images/icon/icon_complete_off.png'>" ;
	}
}

function serverStatusText(code){
	var retStr;
	if(code == '2'){
		return '<font class="status_color warn">주의</font>';
	} else if(code == '3') {
		return '<font class="status_color error">장애</font>';
	} else {
		return '<font class="status_color ok">정상</font>';
	}
}

function getTimeStampToDate(time) {
	if (time == null || time == '') return "-"; 
	var d = new Date(time);
	var rst = pad(  d.getFullYear() , 2 ) + "-"
	+  pad(  (d.getMonth()+1)  , 2 ) + "-"
    + pad( d.getDate() , 2 ) + " "
    + pad(  d.getHours() , 2 )   + ":"
    + pad(  d.getMinutes() , 2 ) ; 
	 return rst;
}

function pad(number, length) {
    var str = '' + number;
    while (str.length < length) {
    	str = '0' + str;
    }
    return str;
}    

function showModal() {
	$(":button").attr("disabled",true);
	controlModal( 'show' );
}

function hideModal() {
	$(":button").attr("disabled",false);
	controlModal( 'hide' );
}

function controlModal( show_hide_code , text ){
	var modal_alert_dom = document.getElementById("modal_alert");
	if( text ){
		changeInnerHtml( document.getElementById("modal_alert_text") , text );
	}
	if( show_hide_code == 'show' ) {
		modal_alert_dom.style.display = "";
	}
	if( show_hide_code == 'hide' ) {
		modal_alert_dom.style.display = "none";
	}
}

function popupWindow(url, title, w, h) {
    var y = window.outerHeight / 2 + window.screenY - ( h / 2);
    var x = window.outerWidth / 2 + window.screenX - ( w / 2);
    return window.open(url, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + w + ', height=' + h + ', top=' + y + ', left=' + x);
}