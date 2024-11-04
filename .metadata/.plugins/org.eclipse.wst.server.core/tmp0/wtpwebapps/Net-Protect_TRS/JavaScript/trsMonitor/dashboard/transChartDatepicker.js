$(document).ready(function() {
	//자료 전송 추이
	/*
	*/
	saveDay($('#noweDate').val());
	datePick();
});

	//달력 되 공간 클릭시 달력 사라짐 이벤트 등록
	$(document).on('click', function(event) {
		var ele = event.target;
		 if (
			//찾은거
			!$(ele).hasClass("hasDatepicker") && !$(ele).hasClass("ui-datepicker") && !$(ele).hasClass("ui-icon") && !$(ele).parent().parents(".ui-datepicker").length
			//추가한거
			&& !$(ele).hasClass("ui-datepicker-header")
			&& !$(ele).hasClass("ui-corner-all")
	    	&& $(ele).parent().attr('class') != 'ui-datepicker-trigger' 
			&& (event.target.nodeName != 'IMG' && event.target.nodeName != 'BUTTON')
	    ){
	    	$('.search_day').hide();
	    }
	});
		
	/*
	$(document).click(function(e) {
		var ele = $(e.toElement);
	    if (
			//찾은거
			!ele.hasClass("hasDatepicker") && !ele.hasClass("ui-datepicker") && !ele.hasClass("ui-icon") && !$(ele).parent().parents(".ui-datepicker").length
			//추가한거
			&& !$(ele).hasClass("ui-datepicker-header")
			&& !$(ele).hasClass("ui-corner-all")
	    	&& $(ele).parent().attr('class') != 'ui-datepicker-trigger' 
			&& $(ele).context.tagName != 'IMG'
	    ){
	    	$('.search_day').hide();
	    }
	});
	*/

var saveNowDate;

function datePick() {
	var MWDcal = {
		dateFormat : 'yy-mm-dd',
		prevText : '이전 달',
		nextText : '다음 달',
		monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
		monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
		dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
		dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
		dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
		showOtherMonths: true,
		showMonthAfterYear : true,
		selectOtherMonths:true,
		changeMonth : true,
		changeYear : true,
		onSelect : function(dateText, inst) {
			clearInterval(detail3Timer); //3번째 차트 해제
			clearInterval(detail4Timer); //4번째 차트 해제
			clearInterval(detail5Timer); //jqgrid interval 해제
			$('#noweDate').val(dateText);
			saveDay(dateText);
			$('.search_day').hide();
			
			//그래프3
			chart3dDtaReload();
			
			//그래프4
			initServerGraph();
			setScheduleRefresh4();
			
			//jqgrid
			jqgrid_manager.setting("dashboard");
			jqgrid_manager.reload(jqgridModel,formVal);
			initAbnormalList();
		},
		onClose : function(dateText, inst) {
		}
	};
	
	$("#startDayText").datepicker(MWDcal);
}

function saveDay(day){
	saveNowDate = day;
}
