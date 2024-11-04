var INFO_TYPE = { FIRST : '1st', SECOND : '2nd', THIRD : '3rd' }
var SYSTEM_INFO_CD_STR = { LOGIN_CNT : 'L', TOTAL_CNT : 'T' }


var detail4Timer = null;
var reloadTime4 = 60;

$(document).ready(function() {
	var inner = $('#inner').val();
	var outer = $('#outer').val();
	initServerGraph();
	setScheduleRefresh4();
});

function createCircleGraph(cdStr, type, data, count, c1_text, c2_text) {
	
	var color = top_getColor(cdStr, count);

	var selector = (cdStr == SYSTEM_INFO_CD_STR.LOGIN_CNT) ? 'L' : 'T';
	selector += '-';
	selector += type;
	selector += '-';
	selector += 'ratio';
	
	var titleStr = count+"";

	return bb.generate({
		data : {
			columns : data,
			type : "donut",
			colors : color
		},
		donut : {
			title : titleStr,
			label : {
				ratio : 200
			}
		},
		legend : {
			show : false,
			position : {
				x : 47.234375,
				y : 9
			}
		},
		gauge : {
			fullCircle : true,
			width : 10,
			label : {
				extents : function(value, isMax) {
					return '';
				},
				format : function(value, ratio) {
					return '';
				}
			},
			title : ""
		},
		size : { height: 105 },
/*		size : {
			width : 119,
			height : 105
		},*/
		grid : {
			x : {
				show : true
			},
			y : {
				show : true
			}
		},
		tooltip: {
	        linked: true,
	        // grouped: false,
	        contents: function (data){
	        	var idName = data[0].name;
				var tooltipData = makeContentData(cdStr, idName, c1_text, c2_text);
				var tTxt = tooltipData.text;
				if(tTxt == null) {
					tTxt = "0";
				}
				
				var tooltipTitle = data[0].name;
				if(tTxt == "0" || tTxt == 0) {
					tooltipTitle = inner.value + "/" + outer.value;
				}
				var tColor = tooltipData.color;
	          return '<div class="bb-tooltip-container bullets" style="position: absolute;pointer-events: none;display: block;top: 0px;left: 0px;">' +
	                  '<table class="bb-tooltip">' +
	                  '<tbody>' + 
	                      '<tr>' + 
	                        '<th data-title>' +tooltipTitle+ '</th>' +
	                      '</tr>' +
	                      '<tr class="bb-tooltip-name-d" style="background-color:'+tColor+';">' +
	                        '<td>'+tTxt+'개</td>' +
	                      '</tr>' + 
	                    '</tbody>' +
	                  '</table></div>';
	        }
	      },
		onrendered : function() {
		},
		bindto : '#' + selector
	})
}

function makeContentData(cdStr, idName, c1_text, c2_text) {
	var data;
	if(cdStr == 'L'){
		if(idName == inner.value){
			data = {
					id : inner.value,
					name : inner.value,
					text : c1_text,
					color : "#0E7ED8"
			}
		}
		if(idName == outer.value){
			data = {
					id : outer.value,
					name : outer.value,
					text : c2_text,
					color : "#28DF8F"
			}
		}
	}else if(cdStr == 'T'){
		if(idName == inner.value){
			data = {
					id : inner.value,
					name : inner.value,
					text : c1_text,
					color : "#E949A8"
			}
		}
		if(idName == outer.value){
			data = {
					id : outer.value,
					name : outer.value,
					text : c2_text,
					color : "#FFA547"
			}
		}
	}

	return data;
}

function initServerGraph() {
	
		top_getServerInfo(SYSTEM_INFO_CD_STR.LOGIN_CNT).then(function(response) {
			initChart4Data(SYSTEM_INFO_CD_STR.LOGIN_CNT, INFO_TYPE.FIRST, response.user_login_percent_i, response.user_login_percent_o, response.user_login_sum_cnt, response.user_login_cnt_i, response.user_login_cnt_o);
			initChart4Data(SYSTEM_INFO_CD_STR.LOGIN_CNT, INFO_TYPE.SECOND, response.admin_login_percent_i, response.admin_login_percent_o, response.admin_login_sum_cnt, response.admin_login_cnt_i, response.admin_login_cnt_o);
			initChart4Data(SYSTEM_INFO_CD_STR.LOGIN_CNT, INFO_TYPE.THIRD, response.login_fail_percent_i, response.login_fail_percent_o, response.login_fail_sum_cnt, response.login_fail_cnt_i, response.login_fail_cnt_o);
		});
		top_getServerInfo(SYSTEM_INFO_CD_STR.TOTAL_CNT).then(function(response) {
			initChart4Data(SYSTEM_INFO_CD_STR.TOTAL_CNT, INFO_TYPE.FIRST, response.send_success_percent_i, response.send_success_percent_o, response.send_success_sum_cnt, response.send_success_cnt_i, response.send_success_cnt_o);
			initChart4Data(SYSTEM_INFO_CD_STR.TOTAL_CNT, INFO_TYPE.SECOND, response.send_fail_percent_i, response.send_fail_percent_o, response.send_fail_sum_cnt, response.send_fail_cnt_i, response.send_fail_cnt_o); 
			initChart4Data(SYSTEM_INFO_CD_STR.TOTAL_CNT, INFO_TYPE.THIRD, response.block_percent_i, response.block_percent_o, response.block_sum_cnt, response.block_cnt_i, response.block_cnt_o); 
		});
	 
	
	
	function initChart4Data(cdStr, type, value, value2, count, c1_text, c2_text, block_count) {
		var data = makeData4(cdStr, type, value, value2);
		var graph = createCircleGraph(cdStr, type, data, count, c1_text, c2_text, block_count);
		return graph;
	}
}

function makeData4(cdStr, type, value, value2) {
	
	var _value = value;
	var _value2 = value2;
	if(_value == 0 && _value2 == 0){
		_value = 100;
		_value2 = 0;
	}else{
		_value = value;
		_value2 = value2;
	}
	
	var data = new Array();
	var arr2 = new Array();
	var arr3 = new Array();
	
	arr2.push(inner.value);
	arr2.push(_value);
	
	arr3.push(outer.value);
	arr3.push(_value2);
	
	data.push(arr2);
	data.push(arr3);
	
	return data;
}

function setScheduleRefresh4() {
	if(detail4Timer) clearInterval(detail4Timer);
	
	detail4Timer = setInterval(initServerGraph, reloadTime4 * 1000);
}

function checkEmptyGraph(count) {
	if(isNumber(count+"")) {
		if(Number(count) == 0) {
			return true;
		}
	}
	return false;
}

function top_getColor(cdStr, count) {
	var o_color = new Object();
	if(checkEmptyGraph(count)) {
		o_color[inner.value] = "#c7c7c7";
		o_color[outer.value] = "#c7c7c7";
	}else {
		if(cdStr == 'L'){
			o_color[inner.value] = "#0E7ED8";
			o_color[outer.value] = "#28DF8F";
		}
		if(cdStr == 'T'){
			o_color[inner.value] = "#E949A8";
			o_color[outer.value] = "#FFA547";
		}
	}	
	return o_color;
}

function top_getServerInfo(cdStr, callback) {
	var requestURL = "/trsMonitor/trsStatusInfo.lin";
	var params = {cntStr : cdStr, nowDate : saveNowDate};
	var result;
	return $.ajax({
		type : "post",
		cache : false,
		url : requestURL,
		data : params,
		dataType : "json",
		error : function(xhr, status, error) {
			if(callback) callback(true);
			if (xhr.status == 401) {
				resultSessionExpire(xhr);
			} else if (xhr.status == 200) {
				resultInterceptorError(xhr);
			} else {
				console.warn("[request url-" + requestURL + "] cause : " + xhr.responseText);
			}
		},
		success : function(response) {
			if(callback) callback(false);
			return ( response != null && response != 'undefined' ) ? response : null;
		}
	});
}
