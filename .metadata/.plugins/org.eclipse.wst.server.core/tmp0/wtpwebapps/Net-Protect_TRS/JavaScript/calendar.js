var now = new Date();
var selectYear = now.getFullYear();
var selectMonth = now.getMonth();
var whatCalendar = null;
var defaultYear = 2008;

function showDate(whatCalendar) {
	var todays = new Date();
	var year = todays.getFullYear() + 1;

	var j = year - defaultYear + 1;
	$("select[name=year]").get(0).options.length = j;

	for (var i = 0; i < j; i++) {
		$("select[name=year] option").eq(i).val( (defaultYear + i));
		$("select[name=year] option").eq(i).text( (defaultYear + i));
	}

	displayCalendar(1);
}

function prevMonth() {
	var year_selectedIdx = $("select[name=year] :selected").index();
	var mon_selectedIdx = $("select[name=month] :selected").index();

	if (mon_selectedIdx < 1 && year_selectedIdx > 0) {
		$("select[name=year] option").eq(--year_selectedIdx).attr("selected", "selected");
		$("select[name=month] option").eq(11).attr("selected", true);
	} else if (mon_selectedIdx >= 1) {
		$("select[name=month] option").eq(--mon_selectedIdx).attr("selected", "selected");
	}

	displayCalendar(0);
}

function nextMonth() {
	var year_selectedIdx = $("select[name=year] :selected").index();
	var mon_selectedIdx = $("select[name=month] :selected").index();

	if (mon_selectedIdx >= 11 && year_selectedIdx < ( $("select[name=year] option").length - 1)) {
		$("select[name=year] option").eq(++year_selectedIdx).attr("selected", "selected");
		$("select[name=month] option").eq(0).attr("selected", "selected");
	} else if (mon_selectedIdx < 11) {
		$("select[name=month] option").eq(++mon_selectedIdx).attr("selected", "selected");
	}

	displayCalendar(0);
}

function checkAndMakeDay(day){

//	var nowDate = new Date(day);
	var nowDate = new Date(day.replace(/-/g, '/'));

	if( nowDate == "Invalid Date" || nowDate == null || nowDate == "" || isNaN(nowDate) ) {
		nowDate = new Date();
	}

	return nowDate;

}

function displayCalendar(init) {

	var i = 0;
	var nowYear = selectYear - defaultYear;
	var nowDay = now.getDate();

	if (init == 1) {

		nowDay = checkAndMakeDay( whatCalendar.value);
		nowYear = nowDay.getFullYear() - defaultYear;
		selectMonth = nowDay.getMonth();
		$("select[name=year] option").eq( nowYear).attr("selected", "selected");
		$("select[name=month] option").eq( selectMonth).attr("selected", "selected");
	}

	var year = $("select[name=year] :selected").index() + defaultYear;
	selectYear = year;

	var month = $("select[name=month] :selected").index();
	selectMonth = month;

	var days = getDaysInMonth(month + 1, year);
	var firstOfMonth = new Date(year, month, 1);
	var startingPos = firstOfMonth.getDay();

	days += startingPos;

	var btns = $("td .body input[type=button]");

	for (i = 0; i < startingPos; i++) {
		btns.eq(i).val( "");
	}
	for (i = startingPos; i < days; i++) {
		btns.eq(i).val( i - startingPos + 1);
	}

	if (month == selectMonth && year == nowYear + 1995) {
		btns.eq(nowDay + startingPos - 1).focus();
	}

	for (i = days; i < 42; i++) {
		btns.eq(i).val(i).val("");
	}
}

function leapYear(year) {
	if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
		return true;
	} else {
		return false;
	}
}

function getDaysInMonth(month, year) {
	var days = 30;

	if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
		days = 31;
	} else if (month == 4 || month == 6 || month == 9 || month == 11) {
		days = 30;
	} else if (month == 2) {
		if (leapYear(year)) {
			days = 29;
		} else {
			days = 28;
		}
	}

	return days;
}

function getDate(selectDate) {
	var layer = $("#calendar_lyr");
	var selectMonth1 = selectMonth + 1;

	if (whatCalendar == null) return;

	if (selectDate <= 0) return;

	if (selectDate < 10) {
		selectDate = "0" + selectDate;
	}

	if (selectMonth1 < 10) {
		selectMonth1 = "0" + selectMonth1;
	}

	whatCalendar.value = selectYear + "-" + selectMonth1 + "-" + selectDate;
	try{
		whatCalendar.onchange();
	} catch(e) { };

	layer.css("display", "none");
}

function calendarOpen(obj) {
	whatCalendar = obj;

	var layer = $("#calendar_lyr");

	showDate(whatCalendar);

	if (layer.css("display") == "none") {
		layer.css("display", "inline");
	} else {
		layer.css("display", "none");
	}
}

function calendarClose() {
	whatCalendar = null;
	var layer = $("#calendar_lyr");
	layer.css("display", "none");
}

function showCalendar(obj, name, event) {
	var layer = $("#calendar_lyr");

	layer.css("top", event.clientY + document.body.scrollTop + document.documentElement.scrollTop + 10 +"px");
	layer.css("left", event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - 115 +"px");

	calendarClose();

	calendarOpen(document.forms[obj][name]);
}

function dateFormatCheck(str, type) {
	if (str.length < 0) {
		return false;
	}

	if (type == "hour" || type == "minute") {
		var regexp = /^(\d{1,2})$/;
		if (!regexp.test(str)) {
			return false;
		}

		var maxValue = (type == "hour" ? 23 : 59);
		if (str < 0 || str > maxValue) {
			return false;
		}
	} else {
		var date = str.split("-");
		var year = date[0];
		var month = date[1];
		var day = date[2];

		var regexp = /^(\d{4})-(\d{1,2})-(\d{1,2})$/;
		if (!regexp.test(str)) {
			return false;
		}

		if (month < 1 || month > 12) {
			return false;
		}
		if (day < 1 || day > getDaysInMonth(month, year)) {
			return false;
		}
	}

	return true;
}

function dateCheck(sdate, edate, match) {
	if (!sdate || !edate) {
		return false;
	}

	var sd = sdate.split("-");
	var ed = edate.split("-");

	if (match == "day") {
		sd[3] = sd[4] = sd[5] = ed[3] = ed[4] = ed[5] = 0;
	} else if (match == "hour") {
		sd[4] = sd[5] = ed[4] = ed[5] = 0;
	} else if (match == "minute") {
		sd[5] = ed[5] = 0;
	}

	var sdate = new Date(sd[0], sd[1] - 1, sd[2], sd[3], sd[4], sd[5]);
	var edate = new Date(ed[0], ed[1] - 1, ed[2], ed[3], ed[4], ed[5]);
	return (sdate.getTime() <= edate.getTime());
}

// 검색창의 date관련 input태그에 datepicker와 validation highlight 에 대한 이벤트를 검.
function bindEventOnSearchDateInput( isExceptTime, proxyFlag ){
	$(document).ready(function(){
		var maxDate = proxyFlag ? "+30d" : "+0d"
		getDatePickerInput().datepicker({
			showOn: "both",
			buttonImage: "/Images/icon/ico_cal.gif",
			buttonText: "날짜 선택",
			dateFormat: 'yy-mm-dd',
			showOtherMonths: true,
			selectOtherMonths:true,
			changeMonth: true,
			changeYear: true,
			showMonthAfterYear: true,
			dayNamesMin: ["일","월","화","수","목","금","토"],
			monthNamesShort: ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],
			prevText: "이전달",
			nextText: "다음달",
			maxDate: maxDate
		});
	});
	
	if( isExceptTime ){ return; }

	$(document).on("focus","input[name$=Hour],input[name$=Min]",function(event){
		var hourname;
		var dayname;
		var minutename;
		
		if( event.target.name.indexOf("Hour") > -1 ){
			hourname = event.target.name;
			dayname = hourname.replace("Hour","Day");
			minutename = hourname.replace("Hour","Min");
		}
		if( event.target.name.indexOf("Min") > -1 ){
			minutename = event.target.name;
			dayname = minutename.replace("Min","Day");
			hourname = minutename.replace("Min","Hour");
		}
		
		if( $("input[name="+dayname+"]").val() == '' ){
			$("input[name="+dayname+"]").addClass("red_b");
		}
		if( $("input[name="+hourname+"]").val() == '' ){
			$("input[name="+hourname+"]").addClass("red_b");
		}
		if( $("input[name="+minutename+"]").val() == '' ){
			$("input[name="+minutename+"]").addClass("red_b");
		}
	});

	$(document).on("blur","input[name$=Hour],input[name$=Min]",function(event){
		var thisname = event.target.name;
		var $dayinput;
		var $hourinput;
		var $mininput;
		
		if( event.target.name.indexOf("Hour") > -1 ){
			$dayinput = $("input[name="+thisname.replace("Hour","Day")+"]");
			$hourinput = $("input[name="+thisname+"]");
			$mininput = $("input[name="+thisname.replace("Hour","Min")+"]");
		}
		if( event.target.name.indexOf("Min") > -1 ){
			$dayinput = $("input[name="+thisname.replace("Min","Day")+"]");
			$hourinput = $("input[name="+thisname.replace("Min","Hour")+"]");
			$mininput = $("input[name="+thisname+"]");
		}
		
		if( $hourinput.val() != '' || $mininput.val() != '' ){
			if( $dayinput.val() != '' ){
				$dayinput.removeClass("red_b");
			}
			if( $hourinput.val() != '' ){
				$hourinput.removeClass("red_b");
			}
			if( $mininput.val() != '' ){
				$mininput.removeClass("red_b");
			}
		}else{
			$dayinput.removeClass("red_b");
			$hourinput.removeClass("red_b");
			$mininput.removeClass("red_b");
		}
		
	});
	
	$(document).on("click","input[name$=Hour],input[name$=Min]",function(event){
		$(this).val("");
	});
	
}

function getDatePickerInput(){
	$inputs = $("input[type='text'][name$=Day]");
	if( $inputs && $inputs.length > 0 ){
		return $inputs;
	}
	$inputs = $("input[type='text'][id$=Day]");
	return $inputs;
}

function isValidDate( start, end ){
	if( start == '' || end == '' ){
		throw "날짜가 올바르지 않습니다. 날짜를 다시 확인해주세요.";
	}
	if( start  > end ){
		throw "시작날짜가 종료날짜보다 큽니다. 날짜를 다시 확인해주세요.";
	}
}
function isValidHourAndMin( start, end ){
	if( start == '' || end == '' ){
		throw "시간이 올바르지 않습니다. 시간을 다시 확인해주세요.";
	}
	if( start  > end ){
		throw "시작시간이 종료시간보다 큽니다. 시간을 다시 확인해주세요.";
	}
}

function checkDateValidation( isExceptTime ){
	var sDate = $(":input[name=startDay]").val();
	var eDate = $(":input[name=endDay]").val();

	var sDateCheck = dateFormatCheck(sDate);
	var eDateCheck = dateFormatCheck(eDate);
	
	var sHour = $(":input[name=startHour]").val();
	var sMin= $(":input[name=startMin]").val();
	var eHour= $(":input[name=endHour]").val();
	var eMin= $(":input[name=endMin]").val();
	
	
	if( isExceptTime ){
		isValidDate(sDate,eDate);
		if(sDate == eDate){
			isValidHourAndMin(sHour,eHour);
		}
		if(sDate == eDate && sHour == eHour){
			isValidHourAndMin(sMin,eMin);
		}
		return;
	}

	var sHourCheck = dateFormatCheck(sHour, "hour");
	var sMinCheck = dateFormatCheck(sMin, "minute");
	var eHourCheck = dateFormatCheck(eHour, "hour");
	var eMinCheck = dateFormatCheck(eMin, "minute");
	
	if( sHour != '' || sMin != '' ){
		if( sDate == '' || sHour == '' || sMin == '' ){
			throw "시작날짜의 시, 분단위까지 검색하는 경우, 날짜, 시, 분 모두 입력해주세요.";
		}
		if( ! sDateCheck ){
			throw "시작날짜에 입력값이 올바르지 않습니다. 날짜 입력값을 다시 확인해주세요.";
		}
		if( ! sHourCheck ){
			throw "시작날짜에 입력값이 올바르지 않습니다. 시 입력값을 다시 확인해주세요.";
		}
		if( ! sMinCheck ){
			throw "시작날짜에 입력값이 올바르지 않습니다. 분 입력값을 다시 확인해주세요.";
		}
		
		if(sHour.length == 1){ $(":input[name=startHour]").val( "0"+$(":input[name=startHour]").val() ) }
		if(sMin.length == 1){ $(":input[name=startMin]").val( "0"+$(":input[name=startMin]").val() ) }
	}
	if( eHour != '' || eMin != '' ){
		if( eDate == '' || eHour == '' || eMin == '' ){
			throw "종료날짜의 시, 분단위까지 검색하는 경우, 날짜, 시, 분 모두 입력해주세요.";
		}
		if( ! eDateCheck  ){
			throw "종료날짜에 입력값이 올바르지 않습니다. 날짜 입력값을 다시 확인해주세요.";
		}
		if( ! eHourCheck ){
			throw "종료날짜에 입력값이 올바르지 않습니다. 시 입력값을 다시 확인해주세요.";
		}
		if( ! eMinCheck ){
			throw "종료날짜에 입력값이 올바르지 않습니다. 분 입력값을 다시 확인해주세요.";
		}
		
		if(eHour.length == 1){ $(":input[name=endHour]").val( "0"+$(":input[name=endHour]").val() ) }
		if(eMin.length == 1){ $(":input[name=endMin]").val( "0"+$(":input[name=endMin]").val() ) }
	}
}
function toggleDateInput(){
	$('#dateInputDiv').toggleClass('nonevisible');
	$('#manIcon').toggleClass('active');
}
function showDateInput( ){
	$('#dateInputDiv').removeClass('nonevisible');
	$('#manIcon').addClass('active');
	$('[id^="btn_day_"]').removeClass('active');
	$('#btn_day_manual').addClass('active');
}
function closeDateInput( ){
	$('#dateInputDiv').addClass('nonevisible');
	$('#manIcon').removeClass('active');
}
function setDateInputDivPosition(){
	$('#dateInputDiv').position({
		of: $('#btn_day_manual'),
		my: 'right top+5',
		at: 'right bottom'
	});
}
function setDateText( start, end){
	$('#startDayText').html(start);
	$('input[name="startDay"]').val(start);
	$('#endDayText').html(end);
	$('input[name="endDay"]').val(end);
}
function setDateTextFromDateInputDiv(){
	try{
		var start = $('#startDay').val();
		var end = $('#endDay').val();
		isValidDate(start,end);
		
		setDateText(start, end);
		
		toggleDateInput();
		setSelectedDay(-1);
		closeDateInput();
	}catch(e){
		var errmsg = new cls_errmsg();
		errmsg.append(null,e);
		errmsg.show();
	}
}
function changeDate( day ){
	var end = $('#today').val();
	
	var start_d = new Date(end);
	start_d.setDate(start_d.getDate()-day);
	
	var start = start_d.getFullYear()+"-"+addZeroNumber((start_d.getMonth()+1))+"-"+addZeroNumber(start_d.getDate());
	
	setDateText(start,end);
	setSelectedDay(day);
	closeDateInput();
}

function changeMonth( obj ){
	var month = $(obj).attr("data-month");
	var end = $('#today').val();
	
	var start_d = new Date(end);
	start_d.setMonth(start_d.getMonth()-month);
	
	var start = start_d.getFullYear()+"-"+addZeroNumber((start_d.getMonth()+1))+"-"+addZeroNumber(start_d.getDate());
	
	setDateText(start,end);
	setSelectedMonth(obj);
	closeDateInput();
}
function setSelectedDay( day ){
	$('[id^="btn_day_"]').removeClass('active');
	$('#period').val( day );//선택한 일수에 해당하는 기간 ex) 1일=1, 3일=3
	$('[data-day="'+day+'"]').addClass('active');
}
function setSelectedMonth( obj ){
	$('[id^="btn_month_"]').removeAttr('checked');
	$(obj).attr("checked", true);
	$('#period').val( $(obj).attr("data-month") );//선택한 일수에 해당하는 기간 ex) 1일=1, 3일=3
}
function isValidDateValue(){
	var errmsg = new cls_errmsg();

	try {
		checkDateValidation( true );
		return true;
	} catch (e) {
		errmsg.append(null,e);
	}
	
	if (errmsg.haserror) {
		errmsg.show();
	}
	return false;
}
