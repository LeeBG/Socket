var hideTickLineTextTimer;

var ServerChartI1; 
var ServerChartI2;
var ServerChartI3;
var ServerChartO1;
var ServerChartO2;
var ServerChartO3;

var cpu_I;
var cpu_O;
var memory_I;
var memory_O;
var disksize_I;
var disksize_O;

var arr_cpu_i = new Array();
var arr_cpu_o = new Array();
var arr_memory_i = new Array();
var arr_memory_o = new Array();
var arr_disksize_i = new Array();
var arr_disksize_o = new Array();

var category = [];

var isSetIntervalChart12 = false;

var reloadTime12 = 5;

$(document).ready(function() {
	//망별 서버상태 그래프
	/*
	*/
	isSetIntervalChart12 = true;
	chart1Start();
});


function chart1Start() {
	dataList("Init");
}

function dataList(callType) {
	var requestURL = "/trsMonitor/serverStatusInfo.lin";
	var params = {};
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
			if(response != null && response != 'undefined') {
				setCategories(response);
				checkInterval();
				if(callType == "Init") {
					ServerChartI1 = setChart12( "#hideTickLineText1", response);
					ServerChartI2 = setChart12( "#hideTickLineText2", response);
					ServerChartI3 = setChart12( "#hideTickLineText3", response);
					ServerChartO1 = setChart12( "#hideTickLineText4", response);
					ServerChartO2 = setChart12( "#hideTickLineText5", response);
					ServerChartO3 = setChart12( "#hideTickLineText6", response);
					
					if(isSetIntervalChart12) {
						if(hideTickLineTextTimer) clearInterval(hideTickLineTextTimer);						
						setTimer12();
					}
				}else {
					setChart12Timer(ServerChartI1, "#hideTickLineText1", response);
					setChart12Timer(ServerChartI2, "#hideTickLineText2", response);
					setChart12Timer(ServerChartI3, "#hideTickLineText3", response);
					setChart12Timer(ServerChartO1, "#hideTickLineText4", response);
					setChart12Timer(ServerChartO2, "#hideTickLineText5", response);
					setChart12Timer(ServerChartO3, "#hideTickLineText6", response);
				}
				
			}else {
				console.log("response is empty!!");
			}
		}
	});
	
	function setChart12(ChartId, response) {
		var columnsData = new Array();
		columnsData = makeData12(ChartId, response);
		return loadGraph(ChartId, columnsData);
	}
	
	function setTimer12() {
		hideTickLineTextTimer = setInterval(function(){
			dataList("Timer");
		},(reloadTime12 * 1000));
	}
	
	function setChart12Timer(ChartName, ChartId, response) {
		var columnsData = new Array();
		columnsData = makeData12(ChartId, response);
		var colors = top_getColor3(ChartId);
		
		ChartName.data.colors(colors);
		ChartName.load({
			columns: columnsData,
			categories: category 
		});
	}
	
	function setCategories(response) {
		if(category.length == 31) {
			category.shift();
		}
		category.push(response.write_time);
	}
	
	function checkInterval() {
		if(category.length == 31 && reloadTime12 == 5) { //Data가 충분히 쌓였으면 interval을 조정 한다.
			if(hideTickLineTextTimer) clearInterval(hideTickLineTextTimer);		
			reloadTime12 = 30;
			setTimer12();
		}
	}
	
	function makeData12(ChartId, response) {
		var columnsData = new Array();
		if( ChartId == '#hideTickLineText1' ) {
			if(arr_cpu_i.length == 0) arr_cpu_i.push("CPU");
			else if(arr_cpu_i.length == 31)	arr_cpu_i.splice(1, 1);
			
			cpu_I = response.cpu_i;
			arr_cpu_i.push(response.cpu_i);
			columnsData.push(arr_cpu_i);
		}else if( ChartId == '#hideTickLineText2' ) {
			if(arr_memory_i.length == 0) arr_memory_i.push("MEMORY");
			else if(arr_memory_i.length == 31) arr_memory_i.splice(1, 1);
			
			memory_I = response.memory_i;
			arr_memory_i.push(response.memory_i);
			columnsData.push(arr_memory_i);
		}else if( ChartId == '#hideTickLineText3' ) {
			if(arr_disksize_i.length == 0) arr_disksize_i.push("DISK");
			else if(arr_disksize_i.length == 31) arr_disksize_i.splice(1, 1);
			
			disksize_I = response.disksize_i;
			arr_disksize_i.push(response.disksize_i);
			columnsData.push(arr_disksize_i);
		}else if( ChartId == '#hideTickLineText4' ) {
			if(arr_cpu_o.length == 0) arr_cpu_o.push("CPU");
			else if(arr_cpu_o.length == 31)	arr_cpu_o.splice(1, 1);
			
			cpu_O = response.cpu_o;
			arr_cpu_o.push(response.cpu_o);
			columnsData.push(arr_cpu_o);
		}else if( ChartId == '#hideTickLineText5' ) {
			if(arr_memory_o.length == 0) arr_memory_o.push("MEMORY");
			else if(arr_memory_o.length == 31) arr_memory_o.splice(1, 1);
			
			memory_O = response.memory_o;
			arr_memory_o.push(response.memory_o);
			columnsData.push(arr_memory_o);
		}else if( ChartId == '#hideTickLineText6' ) {
			if(arr_disksize_o.length == 0) arr_disksize_o.push("DISK");
			else if(arr_disksize_o.length == 31) arr_disksize_o.splice(1, 1);
			
			disksize_O = response.disksize_o;
			arr_disksize_o.push(response.disksize_o);
			columnsData.push(arr_disksize_o);
		}
		setLastDataSetTxt(cpu_I, cpu_O, memory_I, memory_O, disksize_I, disksize_O);
		return columnsData;
	}
}

//그래프 로드
function loadGraph(ChartId, columnsData){
	var serverStatusChart = bb.generate({
		data : {
			columns : columnsData,
			unload: true,
			type : "area-spline",
			index: 0,  // or 'x' key value
			id: "CPU",  // data id
			value: 500  // data value
		},
		axis : {
			x : {
				type: "category",
	            categories: category,
				show : false,
				tick : {
					show : false,
					text : {
						show : false
					}
				}
			},
			y : {
				show : false,
				max : 100,
				tick : {
					show : true,
					count: 5,
					text : {
						show : false
					}
				}
			}
		},
		grid: {
		    y: {
		      show: true
		    }
		},
		legend : {
			show : false
		},
		point: {
			r: 0
		},
		done: function() {
		},
		bindto : ChartId
	});
	serverStatusChart.resize({
		height : 120
	});
	var colors = top_getColor3(ChartId);
	serverStatusChart.data.colors(colors);
	return serverStatusChart;
}

function emptyStrChk(emptyStr){
	var retStr = "";
	if(emptyStr == null || emptyStr === "" || emptyStr == 'undefined' || emptyStr == undefined){
		retStr = "-";
	}else{
		retStr = emptyStr;
	}
	return retStr;
}

function setLastDataSetTxt(cpu_I, cpu_O, memory_I, memory_O, disksize_I, disksize_O){
	$('#cpu_I').text("("+emptyStrChk(cpu_I)+"%)");
	$('#cpu_O').text("("+emptyStrChk(cpu_O)+"%)");
	$('#memory_I').text("("+emptyStrChk(memory_I)+"%)");
	$('#memory_O').text("("+emptyStrChk(memory_O)+"%)");
	$('#disksize_I').text("("+emptyStrChk(disksize_I)+"%)");
	$('#disksize_O').text("("+emptyStrChk(disksize_O)+"%)");
}

function top_getColor3(ChartId) {	
	var ret_color;
	
	if(ChartId == '#hideTickLineText1') ret_color = { CPU : setColor(cpu_I, $('#cpu_warning').val(), $('#cpu_error').val()) };
	if(ChartId == '#hideTickLineText2') ret_color = { MEMORY : setColor(memory_I, $('#memory_warning').val(), $('#memory_error').val()) };
	if(ChartId == '#hideTickLineText3') ret_color = { DISK : setColor(disksize_I, $('#disk_warning').val(), $('#disk_error').val()) };
	if(ChartId == '#hideTickLineText4') ret_color = { CPU : setColor(cpu_O, $('#cpu_warning').val(), $('#cpu_error').val()) };
	if(ChartId == '#hideTickLineText5') ret_color = { MEMORY : setColor(memory_O, $('#memory_warning').val(), $('#memory_error').val()) };	
	if(ChartId == '#hideTickLineText6') ret_color = { DISK : setColor(disksize_O, $('#disk_warning').val(), $('#disk_error').val()) };
	
	return ret_color;
}

function setColor(_v, _w_v, _e_v) {
	var color = "";
	var normal = "#24ca80";
	var warn = "#FFA547";
	var err = "#E949A8";
	
	var colNumber = Number(_v); 
	if(colNumber < Number(_w_v)) {
		color = normal;
	}else if(colNumber >= Number(_w_v) && colNumber <= Number(_e_v)) {
		color = warn;
	}else if(colNumber > Number(_e_v)) {
		color = err;
	}else{
		color = normal;
	}
	return color;
}
