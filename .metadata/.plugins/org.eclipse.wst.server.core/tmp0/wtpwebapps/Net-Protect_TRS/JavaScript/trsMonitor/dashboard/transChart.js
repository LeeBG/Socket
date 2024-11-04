$(document).ready(function() {
	/*
	 * 자료 전송 추이
	*/
	var inner = $('#inner').val();
	var outer = $('#outer').val();
	saveDay($('#noweDate').val());
	dataList3(ServerChart7, '#hideTickLineText7', 'D');
});
var ServerChart7;
var detail3Timer;
var arr = new Array();
var isSetInterval7 = false;

var reloadTime3 = 60;

function chart3dDtaReload(){	//다시 호출 [적용버튼]
	isSetInterval7 = false;
	clearInterval(detail3Timer);
	dataList3(ServerChart7, '#hideTickLineText7');
}

function dataList3(ChartName, ChartId){
	var requestURL = "/trsMonitor/transChartInfo.lin";
	var params = {ChartId : ChartId, nowDate : saveNowDate};
	$.ajax({
		type : "post",
		url : requestURL,
		cache: false,
		data : params,
		dataType : "json",
		error : function(xhr, status, error) {
			if (xhr.status == 401) {
				resultSessionExpire(xhr);
			} else if (xhr.status == 200) {
				resultInterceptorError(xhr);
			} else {
				console.log("error");
			}
		},
		success : function(response) {
			var code = response['code'];
			var message = response['message'];
				
			var arr2 = new Array();
			var arr3 = new Array();
			var maxValue = 0;
			if(code == "OK"){
				var columnsData = new Array();
				$(message).each(function(index, data) {
					arr.push(data.write_time);
				});
				arr2.push("자료전송(" + inner.value + ")");
				arr3.push("자료전송(" + outer.value + ")");
				$(message).each(function(index, data) {
					if(isNumber(data.send_count_i)) {
						if(maxValue < Number(data.send_count_i) ) {
							maxValue = data.send_count_i;
						}
					}
					
					if(isNumber(data.send_count_o)) {
						if(maxValue < Number(data.send_count_o) ) {
							maxValue = data.send_count_o;
						}
					}
					
					arr2.push(data.send_count_i);
					arr3.push(data.send_count_o);					
				});
				columnsData.push(arr2);
				columnsData.push(arr3);
				
				loadGraph3(ServerChart7, '#hideTickLineText7', columnsData, maxValue);
			}
		}
	});
}

function getYvalues(maxValue) {
	var yValues = new Array();
	yValues.push(0);
	var value = maxValue/4;
	for(var i = 0; i < 6; i++) {
		yValues.push( Number(value * (i+1))  );
	}
	return yValues;
}


function loadGraph3(ChartName, ChartId, columnsData, maxValue){
	
	if(Number(maxValue) == 0) {
		maxValue = 100;
	}
	var yValues = getYvalues(maxValue);
	
	ChartName = bb.generate({
		data : {
			columns : columnsData,
			type : "spline",
			unload: false
		},
		axis : {
			x : {
				tick : {
					show : true,
					text : {
						show : true
					}
				}
			},
			y : {
				show : false,
				max : Number(maxValue),
				tick : {
					show : true,
					values: yValues,
					text : {
						show : false
					}
				}
			}
		},
		tooltip : {
			format : {
				title : function(d) {
					return arr[d] + '시';
				}
			}
		},
		legend : {
			show : false
		},
		point: {
			//type: "rectangle"
			r: 1
		},
		grid: {
		    y: {
		      show: true
		    }
		},
		onrendered : function() {
			setTick();
			chart3SetTimer(ChartId);
		},
		done: function() {
		},
		bindto : ChartId
	});
	
	var obj = new Object();
	obj["자료전송(" + inner.value + ")"] = "#0E7ED8";
	obj["자료전송(" + outer.value + ")"] = "#28df8f";
	ChartName.data.colors(obj);
	/*
	ChartName.load({
		done: function() {
			dataList3(ChartName, ChartId, statisticsType);
			detail3Timer = setInterval(function(){
				dataList3(ChartName, ChartId, statisticsType);
			},(5 * 1000));
		}
	});
	*/
}
function chart3SetTimer(ChartId){
	if(!isSetInterval7){
		if(ChartId == '#hideTickLineText7'){
			detail3Timer = setInterval(function(){
				dataList3(ServerChart7, '#hideTickLineText7');
			},(reloadTime3 * 1000));
			isSetInterval7 = true;
		}
	}
}

function setTick() {
	$('#hideTickLineText7 > svg > g > g > g > text > tspan').each(function(index){
		var d = $(this).text();
		var mStr = d + '시';
		$(this).text(mStr);
	});
}
