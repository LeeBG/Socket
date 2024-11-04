/**
 * 하단 그래프 영역
 */
document.write("<script src='/JavaScript/d3.min.js'></script>");
document.write("<link href='/css/billboard.css' rel='stylesheet' type='text/css' />");
document.write("<script src='/JavaScript/billboard.js'></script>");

var Graph = function(){
	var param_index = 1;
	var graphChart;
	var renderedResponse;

	this.graphInit = function() {
		var param = {
				'search_date': $("input[name='startDayView']").val(),
				'search_end_date': $("input[name='endDay']").val(),
				'date_flag': $(':radio[name="statistics"]:checked').val()
		};
		$.ajax({
			url: "/trsMonitor/graph.lin",
			cache : false,
			data : param,
			dataType: "json",
			success: this.setGraphInfo
		});

	}
	
	this.setGraphInfo = function(response) {
		setGraph(response);
	}

	function setGraph(response) {
		graphChart = bb.generate({
			bindto: "#graph_chart",
			data: {
				columns:[
					graph_manager.setDataCount(response),
					graph_manager.setDataSize(response),
					graph_manager.setLoginCount(response),
					graph_manager.setBlockCount(response)
				],
				axes: {
					"전송개수" : "y",
					"전송량(MB)" : "y2",
					"사용자 접속 수" : "y",
					"이상파일개수" : "y"
				},
				types: {
					"전송개수" : "bar",
					"전송량(MB)" : "area-spline",
					"사용자 접속 수" : "bar",
					"이상파일개수" : "bar"
				},
				colors: {
					"전송개수" : "#FAD82C",
					"전송량(MB)" : "#FFBEFF",
					"사용자 접속 수" : "#F0742B",
					"이상파일개수" : "#0004c8"
				}
			},
			axis: {
				x: {
					type: "category",
					categories: graph_manager.setCategory(response)
				},
				y: {
					min : 0,
					label : "개수",
					color : "white"
				},
				y2: {
					min : 0,
					show: true,
					label: "전송량(MB)"
				}
			},
		}); 
		// 눈금 음수값 제거
		$(".tick").each(function(){
			var test = $(this).children().eq(1).children().text();
			if(test < 0){
				$(this).hide();
			}
		});
		
		// 엑셀 출력시 chart setting 
		setChartExcelDownload();
	}

	this.setDataCount = function(response) {
		var category = [];
		category.push("전송개수");
		for (var i=0; i<response.countData.length; i++) {
			category.push(response.countData[i]);
		}
		return category;
	}
	
	this.setDataSize = function(response) {
		var category = [];
		category.push("전송량(MB)");
		for (var i=0; i<response.sizeData.length; i++) {
			category.push(graph_manager.dataSizeMbFmatter(response.sizeData[i]));
		}
		return category;
	}
	
	this.setBlockCount = function(response) {
		var category = [];
		category.push("이상파일개수");
		for (var i=0; i<response.blockData.length; i++) {
			category.push(response.blockData[i]);
		}
		return category;
	}
	
	this.setLoginCount = function(response) {
		var category = [];
		category.push("사용자 접속 수");
		for (var i=0; i<response.loginData.length; i++) {
			category.push( response.loginData[i]);
		}
		return category;
	}

	this.setCategory = function(response) {
		var category = [];
		for (var i=0; i<response.categoryData.length; i++) {
			category.push(response.categoryData[i]);
		}
		return category;
	}

	this.dataSizeMbFmatter = function(cellvalue) {	
		if(cellvalue == 0) return '0';
		var k = 1024,
		dm = 1 || 2;
		return parseFloat((cellvalue / Math.pow(k, 2)).toFixed(dm));
	}
	
	function setChartExcelDownload(){
		var chart_y_max = $(".bb-axis-y").children().eq(-2).children().eq(1).text();
		var chart_y = $(".bb-axis-y").children().eq(-3).children().eq(1).text();     // 두번쨰 max값
		var chart_y_unit = (chart_y_max - chart_y); // y축 간격
		
		var chart_y2_max = $(".bb-axis-y2").children().eq(-2).children().eq(1).text(); 
		var chart_y2 = $(".bb-axis-y2").children().eq(-3).children().eq(1).text();   // 두번쨰 max값
		var chart_y2_unit = (chart_y2_max - chart_y2); // y2축 간격
		
		$("input[name=chart_y_max").val(chart_y_max);
		$("input[name=chart_y_unit").val(chart_y_unit);
		
		$("input[name=chart_y2_max").val(chart_y2_max);
		$("input[name=chart_y2_unit").val(chart_y2_unit);
		
	}
}
