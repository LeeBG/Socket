var jqGridManager = function(){
	var jqgridModel = {};
	var formVal;
	this.setting = function(page){
		var inner = $('#inner').val();
		var outer = $('#outer').val();
		if(page == "user"){
			setUserStatistics();
		}else if(page == "dashboard"){
			setDashBoard();
		}else if(page == "total") {
			setTotalStatistics();
		}
	}
	this.init = function(param,form){
		jqGridSet(form,param.urlVal,param.colNamesVal,param.colModelVal,param.postDataVal,param.rowNumVal,param.rowListVal,param.heightVal,param.widthVal,param.sortnameVal,param.sortorderVal,param.paddingVal);
		//jqgrid sub header
		form.jqGrid('setGroupHeaders', {
			  useColSpanStyle: true, 
			  groupHeaders:param.groupHeadersVal
		});
	}
	this.reload = function(param,form){
		form.setGridParam({postData:param.postDataVal}).trigger("reloadGrid");
	}
}
//jqgrid ajax
function jqGridSet(gridObj,urlVal, colNamesVal, colModelVal, postDataVal, rowNumVal, rowListVal, heightVal, widthVal, sortnameVal,sortorderVal, paddingVal){

	var empty_padding_css = Math.round((heightVal/2)/100) * 100; 
	
	gridObj.jqGrid({
   		 url : urlVal, 
   		 datatype : "JSON",
   		 mtype : "GET", 
   		 colNames: colNamesVal, 
   		 colModel: colModelVal, 
   		 postData :  postDataVal,
   		 rowNum : rowNumVal,
   		 rowList: rowListVal,
   		 pager: $('#pager'), 
   		 width: widthVal, 
   		 height: heightVal,
   		 scrollOffset: 0,
   	     shrinkToFit: true,
   	     viewrecords: true,
   	     sortname: sortnameVal,
   	     sortorder:sortorderVal,
   	     loadComplete: function (data) {
   	    	if(data.Model){
   	    		$(":input[name=sord]").val(data.Model.sord);
   	    		$(":input[name=sidx]").val(data.Model.sidx);
   	    	}
   	    	if(data.rows == 0){
   	    		$("#excel_down").attr("disabled",true);
   	    		$("#excel_down").css("cursor","no-drop");
   	    		gridObj.children().append("<tr><td colspan='15' align='center'><div class='grid_empty' style='position: absolute;left: 44%;font-weight:bold;padding:" + paddingVal + "px 0;'>결과가 없습니다.</div></td></tr>");
   	    	}else{
   	    		$("#excel_down").attr("disabled",false);
   	    		$("#excel_down").css("cursor","pointer");
   	    	}
   	    	$(".ui-paging-info").text("(총 " + data.records + "건)");
   	     }
	});
}

function setUserStatistics(){
	
	var urlVal = "/trsMonitor/userStatisticsData.lin";
	var colNamesVal = ['부서명','사용자ID','사용자명', inner.value, outer.value, '전체', inner.value, outer.value, '전체', inner.value, outer.value, '전체','차단<br>파일수'  ,'위변조<br>파일수', '암호화<br>파일수' ,'바이러스의심<br>파일수', '감염<br>파일수', '스캔 실패<br>파일수'];
	var colModelVal = [	   		
		{name:'dept_nm',index:'dept_nm', width:70, align:"center"},
   		{name:'users_id',index:'users_id', width:60, align:"center"},
   		{name:'users_nm',index:'users_nm', width:60, align:"center"},
   		{name:'login_cnt_i',index:'login_cnt_i', width:60, align:"center"},
   		{name:'login_cnt_o',index:'login_cnt_o', width:60, align:"center"},
   		{name:'login_cnt_all',index:'login_cnt_all', width:60, align:"center"},
   		{name:'send_success_count_i',index:'send_success_count_i', width:60, align:"center"},
   		{name:'send_success_count_o',index:'send_success_count_o', width:60, align:"center"},
   		{name:'send_success_count_all',index:'send_success_count_all', width:60, align:"center"},
   		{name:'send_size_i',index:'send_size_i', width:60, align:"center", formatter:fileSize},
   		{name:'send_size_o',index:'send_size_o', width:60, align:"center", formatter:fileSize},
   		{name:'send_size_all',index:'send_size_all', width:60, align:"center", formatter:fileSize},
   		{name:'filter_count',index:'filter_count', width:60, align:"center"},
   		{name:'forgery_count',index:'forgery_count', width:60, align:"center"},
   		{name:'protect_count',index:'protect_count', width:60, align:"center"},
   		{name:'suspicious_count',index:'suspicious_count', width:60, align:"center"},
   		{name:'infected_count',index:'infected_count', width:60, align:"center"},
   		{name:'scan_fail_count',index:'scan_fail_count', width:60, align:"center"}
   	];
	var postDataVal = {
   			startDay: $(":input[name=startDay]").val(),
   			endDay: $(":input[name=endDay]").val(),
   			searchField: $("#searchField").val(),
   			searchValue: $("#searchValue").val()
	};
	var rowNumVal = 20;
	var rowListVal = [20,30,50,100];
	var heightVal = 670;
	var widthVal = 1660;
	var sortnameVal = "send_success_count_all";
	var sortorderVal = "desc";
	var groupHeadersVal =[
			{startColumnName: 'login_cnt_i', numberOfColumns: 3, titleText: '로그인 횟수'},
			{startColumnName: 'send_success_count_i', numberOfColumns: 3, titleText: '전송개수'},
			{startColumnName: 'send_size_i', numberOfColumns: 3, titleText: '전송량'}
		];
	var paddingVal = 280; 
	formVal = $("#mainGrid");
	jqgridModel = {
			'urlVal': urlVal,
 			'colNamesVal':colNamesVal,
			'colModelVal':colModelVal,
			'postDataVal':postDataVal,
			'rowNumVal':rowNumVal,
			'rowListVal':rowListVal,
			'sortnameVal':sortnameVal,
			'heightVal':heightVal,
			'widthVal':widthVal,
			'sortnameVal': sortnameVal,
			'sortorderVal': sortorderVal,
			'groupHeadersVal':groupHeadersVal,
			'paddingVal':paddingVal,
			'groupHeadersVal':groupHeadersVal
	};
}

function setDashBoard(){
	var urlVal = "/trsMonitor/abnormalData.lin";
	var colNamesVal = ['전송영역','발생일시','사용자','접속IP', '사유', '파일명', '파일크기'];
	var colModelVal = [	   		
		{name:'io_cd',index:'io_cd', width:60, align:"center", formatter: io_cd_formatter},
   		{name:'crt_time',index:'crt_time', width:60, align:"center", formatter: "date",  formatoptions: {srcformat:'Y-m-d H:i:s',newformat: "Y-m-d H:i" }},
   		{name:'users_id',index:'users_id', width:60, align:"center"},
   		{name:'connect_ip',index:'connect_ip', width:70, align:"center"},
   		{name:'vc_status',index:'vc_status', width:60, align:"center", formatter: vc_status_formatter},
   		{name:'file_nm',index:'file_nm', width:60, align:"center"},
   		{name:'file_size',index:'file_size', width:60, align:"center", formatter:fileSize}
   	];
	var postDataVal = {
   		startDate: saveNowDate
	};
	var rowNumVal = 10;
	var rowListVal = [10,20,30,50,100];
	var heightVal = 260;
	var widthVal = 1660;
	var sortnameVal = "crt_time";
	var sortorderVal = "desc";
	var paddingVal = 110;
	
	formVal = $("#mainGrid");
	jqgridModel = {
			'urlVal': urlVal,
 			'colNamesVal':colNamesVal,
			'colModelVal':colModelVal,
			'postDataVal':postDataVal,
			'rowNumVal':rowNumVal,
			'rowListVal':rowListVal,
			'sortnameVal':sortnameVal,
			'heightVal':heightVal,
			'widthVal':widthVal,
			'sortnameVal': sortnameVal,
			'sortorderVal':sortorderVal,
			'paddingVal':paddingVal
	};
}

function vc_status_formatter(cellValue, options, rowData){
	if(cellValue == "0"){
		return "스캔실패";
	}else if(cellValue == "3"){
		return "바이러스 파일";
	}else if(cellValue == "4"){
		return "바이러스의심 파일";
	}else if(cellValue == "10"){
		return "암호화 파일";
	}else if(cellValue == "11"){
		return "위변조 파일";
	}else if(cellValue == "12"){
		return "차단 파일";
	}else if(cellValue == "14"){
		return "중첩압축 파일";
	}
}

function io_cd_formatter(cellValue, options, rowData){
	if(cellValue == "I"){
		return inner.value + " -> " + outer.value;
	}else{
		return outer.value + " -> " + inner.value;
	}
}

function setTotalStatistics(){
	var urlVal = "/trsMonitor/tableData.lin";
	var colNamesVal = ['시간', inner.value, outer.value, '전체', inner.value, outer.value, '전체', inner.value, outer.value, '전체', inner.value, outer.value, '전체'];
	var colModelVal = [
		{name:'write_time', index:'write_time', width:60, align:"center", formatter: dateSet},
		{name:'send_success_count_i', index:'send_success_count_i', width:60, align:"center"},
		{name:'send_success_count_o', index:'send_success_count_o', width:60, align:"center"},
		{name:'send_success_count_total', index:'send_success_count_total', width:60, align:"center"},
		{name:'send_size_i', index:'send_size_i', width:60, align:"center", formatter: fileSize},
		{name:'send_size_o', index:'send_size_o', width:60, align:"center", formatter: fileSize},
		{name:'send_size_total', index:'send_size_total', width:60, align:"center", formatter: fileSize},
		{name:'block_count_i', index:'block_count_i', width:60, align:"center"},
		{name:'block_count_o', index:'block_count_o', width:60, align:"center"},
		{name:'block_count_total', index:'block_count_total', width:60, align:"center"},
		{name:'login_cnt_i', index:'login_cnt_i', width:60, align:"center"},
		{name:'login_cnt_o', index:'login_cnt_o', width:60, align:"center"},
		{name:'login_cnt_total', index:'login_cnt_total', width:60, align:"center"}
		];
	
	var heightVal = 360;
	var widthVal = 1660;
	var sortnameVal = "write_time";
	var sortorderVal = "desc";
	var postDataVal = {
			search_date: $(":input[name=startDayView]").val(),
			search_end_date: $("input[name='endDay']").val(),
			date_flag: $(':radio[name="statistics"]:checked').val()
	};
	var groupHeadersVal =[
			{startColumnName: 'send_success_count_i', numberOfColumns: 3, titleText: '전송개수'},
			{startColumnName: 'send_size_i', numberOfColumns: 3, titleText: '전송량'},
			{startColumnName: 'block_count_i', numberOfColumns: 3, titleText: '이상파일'},
			{startColumnName: 'login_cnt_i', numberOfColumns: 3, titleText: '사용자 접속 수'}
		];
	var paddingVal = 129;
	
	formVal = $("#mainGrid");
	jqgridModel = {
			'urlVal': urlVal,
 			'colNamesVal':colNamesVal,
			'colModelVal':colModelVal,
			'postDataVal':postDataVal,
			'sortnameVal':sortnameVal,
			'heightVal':heightVal,
			'widthVal':widthVal,
			'sortnameVal': sortnameVal,
			'sortorderVal': sortorderVal,
			'groupHeadersVal':groupHeadersVal,
			'paddingVal':paddingVal
	};
}

function dateSet(cellValue, options, rowData) {
	if(cellValue.length > 5) return '합계'
	else if($(':radio[name="statistics"]:checked').val() == 'D') return cellValue + '시';
	else if($(':radio[name="statistics"]:checked').val() == 'M' || $(':radio[name="statistics"]:checked').val() == 'P') return cellValue.slice(0, 2) + '-' + cellValue.slice(2, 4);
	else return cellValue + '월';
}

function fileSize(cellValue, options, rowData) {
	if(cellValue == 0){
		return "0B";
	}else{
		var unit = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    	var count = Math.floor(Math.log(cellValue) / Math.log(1024));
    	return (cellValue / Math.pow(1024, count)).toFixed(2) + " " + unit[count];
	}  
}