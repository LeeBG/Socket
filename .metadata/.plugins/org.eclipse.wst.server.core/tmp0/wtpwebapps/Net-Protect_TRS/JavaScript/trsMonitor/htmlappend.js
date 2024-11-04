/* list show html */
function setTotalOfficeList ( response ) {
	var content= "";

	$('#list-period').text("※최근" + response.period + "일  데이터");
	if (response.summaryList.length > 0) {
		for ( var i=0; i<response.summaryList.length; i++ ) {
			var office = response.summaryList[i];
			if( i == 0) {
				content = getTotalSum(office);
			}else {
				content += 
					"<tr class='cursor-tr' onclick='detailPop(\""+office.office_seq+"\");'>"
					+ "<td class='Rborder t_left' title='"+office.group_name+"'>"
					+ office.group_name
					+ "</td>"
					+ "<td class='Rborder t_left' title='"+office.office_name+"'>"
					+ office.office_name
					+ "</td>"
					+ "<td class='Rborder t_center' title='"+office.send_count_o+"'>"
					+ office.send_count_o
					+ "</td>"
					+ "<td class='Rborder t_center' title='"+office.send_count_i+"'>"
					+ office.send_count_i
					+ "</td>"
					+ "<td class='Rborder t_center' title='"+office.send_count_total+"'>"
					+ office.send_count_total
					+ "</td>"
					+ "<td class='Rborder t_center' title='"+fileSizeFormat(office.send_size_o)+"'>" 
					+ fileSizeFormat(office.send_size_o)
					+ "</td>"
					+ "<td class='Rborder t_center' title='"+fileSizeFormat(office.send_size_i)+"'>"
					+ fileSizeFormat(office.send_size_i)
					+ "</td>"
					+ "<td class='Rborder t_center' title='"+fileSizeFormat(office.send_size_total)+"'>"
					+ fileSizeFormat(office.send_size_total)
					+ "</td>"
					+ "<td class='Rborder t_center' title='"+office.block_count+"'>"
					+ office.block_count
					+ "</td>"
					+ "<td class='Rborder t_center' title='"+office.send_count_mail+"'>"
					+ office.send_count_mail
					+ "</td>"
					+ "<td class='Rborder t_center' title='"+fileSizeFormat(office.send_size_mail)+"'>"
					+ fileSizeFormat(office.send_size_mail)
					+ "</td>"
					+ "<td class='Rborder t_center' >"
					+ serverStatusText(office.event_status_o)
					+ "</td>"
					+ "<td class='Rborder t_center' >"
					+ serverStatusText(office.event_status_i)
					+ "</td></tr>";
			}
			
		}
	} else {
			content = "<tr>"
			+ "<td class='t_center' colspan='13'>결과가 없습니다</div></td>";
			+"</tr>";
	}
	$('#office_total').html(content);
	
	function getTotalSum(office) {
		var content = "<tr>"
		+ "<td class='Rborder t_center totalSum' >"
		+ office.group_name
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' title='"+office.office_name+"'>"
		+ office.office_name
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' title='"+office.send_count_o+"'>"
		+ office.send_count_o
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' title='"+office.send_count_i+"'>"
		+ office.send_count_i
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' title='"+office.send_count_total+"'>"
		+ office.send_count_total
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' title='"+ fileSizeFormat(office.send_size_o)+"'>" 
		+ fileSizeFormat(office.send_size_o)
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' title='"+fileSizeFormat(office.send_size_i)+"'>"
		+ fileSizeFormat(office.send_size_i)
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' title='"+fileSizeFormat(office.send_size_total)+"'>"
		+ fileSizeFormat(office.send_size_total)
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' title='"+office.block_count+"'>"
		+ office.block_count
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' title='"+office.send_count_mail+"'>"
		+ office.send_count_mail
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' title='"+fileSizeFormat(office.send_size_mail)+"'>"
		+ fileSizeFormat(office.send_size_mail)
		+ "</td>"
		+ "<td class='Rborder t_center totalSum' >-</td>"
		+ "<td class='Rborder t_center totalSum' >-</td></tr>";
		
		return content;
	}
}

/* nation checkbox html */
function setNationInfo (response) {
	//MAIN_FILTER : total.jsp 에서 정의됨
	var content ="";
	for( var i=0; i<response.office.length; i++ ) {
		var office = response.office[i];
		content += "<li>" +
				"<input type='checkbox' onclick='" + getApplyOfficeFunction() + "();' name='chk' value='"+office.office_seq+"' id='chk"+i+"'"
				+ (FILTER_OFFICE.indexOf(office.office_seq) > -1? "checked" : "") +" /><label for='chk"+i+"' style='cursor:pointer' >" + office.office_name + "</label>"
			+ "</li>";
	}
	$("#chk_div").html(content);
	ofilter_manager.searchOffice();
	
	/** 공지사항 상세 페이지 예외처리 **/
	try {
		if(setNoticeSelectedOffice) {
			setNoticeSelectedOffice();
		}		
	}catch(e) {}
	
	function getApplyOfficeFunction() {
		var func;
		try {
			func = ( applyOffice && typeof(applyOffice) == 'function' ) ? 'applyOffice' : 'ofilter_manager.filterOffice';
		} catch(e) {
			func = 'ofilter_manager.filterOffice';
		}
		
		return func;
	}
}

/* leftstatus html */
function setStatusInfo(response) {
	if (response == 'undefinded' || response == null) {
		console.log('response 값이 없습니다.');
	} else {
		$('#office_cnt_total').html(response.office_cnt_total);
		$('#office_cnt_normal').html(response.office_cnt_normal);
		$('#office_cnt_warning').html(response.office_cnt_warning);
		$('#office_cnt_error').html(response.office_cnt_error);
	}
}

/* eventlog html */
function setEventLog(response) {
	var  content = "";
	for( var i=0; i<response.meventlog.length; i++ ) {
		var meventlog = response.meventlog[i];
		content +=
		"<div class='right_event_item'>"
		+ serverStatusIcon(meventlog.event_severity)
		+ "<ul>"
		+ "<li class='event_item nation' title='"+ meventlog.office_name+"' >"
		+ meventlog.office_name+ "</li>"
		+ "<li class='event_item content'>" + meventlog.event_message + "</li>"
		+ "<li class='event_item time'><div class='time-area left'>" + getIoCd(meventlog.io_cd) + "</div><div class='tooltip-content time'><p>" + getDateTime(meventlog.start_time)
		+ "</p></div><div class='time-area right'>" + setServerItemTime(meventlog.event_period_minute, meventlog.event_period_hour, meventlog.event_period_day) + "</div></li>"
		+ "</ul>"
		+ "</div>";
	}

	$('#event-stack').html(content);

	function setServerItemTime(minute, hour, day) {
		if (minute <= 60) {
			return minute + "분전 발생" ;
		} else if (hour <= 24) {
			return hour + "시간전 발생" ;
		} else  {
			return day + "일전 발생" ;
		}
	}

	function getDateTime(time) {
		 var date = new Date(time);
		 return (date.getMonth() + 1) + "월" + date.getDate().toString() + "일 "+ date.getHours() + "시" + date.getMinutes() + "분 발생";
	}

	function getIoCd(type) {
		 return (type == 'I') ? "[업무망]" : "[인터넷망]";
	}
}

/* graph Paging */
function setGraphPaging(response) {
	document.getElementById('prev_btn').onclick = function () {
		graph_manager.graphInit(response.page-1);
	};

	document.getElementById('next_btn').onclick = function () {
		graph_manager.graphInit(response.page+1);
	};

	if (response.office.length < 1) {
		$('.footer-prev').addClass('active');
		$('.footer-next').addClass('active');
		return;
	}

	if (response.page == 1) {
		$('.footer-prev').addClass('active');
	}else {
		$('.footer-prev').removeClass('active');
	}

	if (response.page == response.lastPage) {
		$('.footer-next').addClass('active');
	} else {
		$('.footer-next').removeClass('active');
	}
}

/* eventLog history */
function setEventLogHistory(response) {
	var  content = "";
	if (response.mEventLogList.length > 0) {
		for( var i=0; i<response.mEventLogList.length; i++ ) {
			var meventlog = response.mEventLogList[i];
			content +=
			"<tr><td>" + meventlog.group_name+ "</td>" 
			+"<td>" + meventlog.office_name+ "</td>"
			+"<td>" + meventlog.event_message+ "</td>"
			+"<td>" + serverStatusText(meventlog.event_severity)+ "</td>"
			+"<td>" + getIoCd(meventlog.io_cd)+ "</td>"
			+"<td>" + getTimeStampToDate(meventlog.start_time)+ "</td>"
			+"<td>" + getTimeStampToDate(meventlog.close_time)+ "</td></tr>";
		}

		function getIoCd(type) {
			 return (type == 'I') ? "업무망" : "인터넷망";
		}

	} else {
		content = "<tr>"
			+ "<td class='t_center' colspan='7'>결과가 없습니다</div></td>";
			+"</tr>";
	}
	$('#event-area').html(content);
	getSelectOption(response.searchPosition); //전체-업무망-인터넷망 Selectbox loading

	setPagingHtml(response.paging.totalCount, response.pageList);

	function getSelectOption(io_cd) {
		var selectBox_area = "";
		if (io_cd == 'B' || io_cd == 'undefined') {
			selectBox_area += "<option value='B' selected='selected'>전체영역</option>"
				+"<option value='I'>업무망</option>"
				+"<option value='O'>인터넷망</option>";
		} else if (io_cd == 'I') {
			selectBox_area = "<option value='B'>전체영역</option>"
				+"<option value='I' selected='selected'>업무망</option>"
				+"<option value='O'>인터넷망</option>";
		} else {
			selectBox_area = "<option value='B'>전체영역</option>"
				+"<option value='I'>업무망</option>"
				+"<option value='O' selected='selected'>인터넷망</option>";
		}

		$('#selectNetworkPosition').html(selectBox_area);
	}
}

/* setAdminManagement List */
function setAdminManagement(response) {
	if (response.MOfficeList.length > 0) {
		var content = "";
		for( var i=0; i<response.MOfficeList.length; i++ ) {
			var mOffice = response.MOfficeList[i];
			content +=
			"<tr onclick='addOffice(\"" + mOffice.office_seq + "\")'>"
			+"<td>" + mOffice.office_seq + "</td>"
			+"<td>" + mOffice.group_name + "</td>"
			+"<td>" + mOffice.office_name + "</td>"
			+"<td>" + mOffice.office_ip + "</td>"
			+"<td>" + getStringStr(mOffice.users_name) + "</td>"
			+"<td>" + getStringStr(mOffice.users_phone) + "</td>"
			+"<td>" + getTimeStampToDate(mOffice.crt_time) + "</td>" // getDateTime common.js 에 정의 공통 'YYYY-MM-dd HH:SS:ss 변환'
			+"<td>" + getUseYn(mOffice.use_yn) + "</td>"
			+"<td>" + getSuccessYn(mOffice.success_yn) + "</td></tr>";
		}
	} else {
		content = "<tr>"
			+ "<td class='t_center' colspan='9'>결과가 없습니다</div></td>";
			+"</tr>";
	}

	$('#admin-management').html(content);

	setPagingHtml(response.paging.totalCount, response.pageList);

	function getStringStr(str) {
		return (str == null) ? '없음' : str; 
	}

	function getUseYn(str) {
		return (str == 'Y') ? '사용' : '미사용'; 
	}

	function getSuccessYn(str) {
		return (str == 'Y') ? '성공' : '실패'; 
	}
}

/* countryListManagement html */
function setCountryListManagement(response) {
	var country_content = "<li class='country_li left'>" 
		+ "<input type='radio' id='country_radio_add' name='country_radio' value='' checked='checked' onclick='countryView(this.value)' /><label for='country_radio_add' style='color: aqua;' >신규추가</label>"
		+ "</li>";
	for( var i=0; i<response.mOfficeCountryList.length; i++ ) {
		var mCountry = response.mOfficeCountryList[i];
		country_content +=
		"<li class='country_li left'>"
		+ "<input type='radio' id='country_radio" + i + "' name='country_radio' value='" + mCountry.group_seq 
		+ "' onclick='countryView(" + mCountry.group_seq + ", " + mCountry.parent_group_seq + ")'/>"
		+ "<label for='country_radio" + i + "'>" + mCountry.group_name + "</label></li>";
	}

	$('#country_code').html(country_content);
}

/* groupListManagement html */
function setGroupListManagement(response) {
	var group_content = "<option value=''>선택안함</option>";
	for( var i=0; i<response.mOfficeGroupList.length; i++ ) {
		var mGroup = response.mOfficeGroupList[i];
		group_content +=
		"<option value='" + mGroup.group_seq + "'>"
		+ mGroup.group_name
		+ "</option>";

	}

	$('#parent_group_seq').html(group_content);
}

/* groupObject html */
function setOfficeGroup(response) {
	var locationArr = response.mOfficeGroup.location;
	if (!locationArr == null || !locationArr == "") {
		locationArr = locationArr.split(',');
		$("#location_x").val(locationArr[0]);
		$("#location_y").val(locationArr[1]);
	}

	$("#group_seq").val(response.mOfficeGroup.group_seq);
	$("#group_name").val(response.mOfficeGroup.group_name);
	$("#parent_group_seq").val((response.mOfficeGroup.parent_group_seq == null 
			|| response.mOfficeGroup.parent_group_seq == "") ? "" : response.mOfficeGroup.parent_group_seq);
}

/* mailHistoryList html */
function setMailHistoryList(response) {
	var content = "";
	if (response.mailHistoryList.length > 0) {
		for( var i=0; i<response.mailHistoryList.length; i++ ) {
			var mailHistory = response.mailHistoryList[i];
			var emailAdd = (mailHistory.email == null || mailHistory.email == '' ) ? '' : "(" + mailHistory.email + ")";
			var mailSender = (mailHistory.users_nm == null && mailHistory.email == null) ? mailHistory.users_id : mailHistory.users_nm + emailAdd;
			content +=
				"<tr class='cursor-tr' onclick='detailMailPop(\""+mailHistory.office_seq+"\",  \""+mailHistory.email_seq+"\")'>"
			+ "<td class='Rborder t_center'>"
			+ mailHistory.group_name
			+ "</td>"
			+ "<td class='Rborder t_center'>"
			+ mailHistory.office_name
			+ "</td>"
			+ "<td class='Rborder t_center'>"
			+ mailSender
			+ "</td>"
			+ "<td class='Rborder t_center'>"
			+ mailHistory.receiver
			+ "</td>"
			+ "<td class='Rborder t_center'>"
			+ getDataStatus(mailHistory.send_status) /* getMailStatus 상태값 가져오는 메소드 common.js에 정의 */
			+ "</td>"
			+ "<td class='Rborder t_center' title='"+mailHistory.title+"'>"
			+ mailHistory.title
			+ "</td>"
			+ "<td class='Rborder t_center'>"
			+ getTimeStampToDate(mailHistory.send_time)
			+ "</td></tr>";
		}
	} else {
		content = "<tr>"
			+ "<td class='t_center' colspan='7'>결과가 없습니다</div></td>";
			+"</tr>";
	}

	$("#mail-area").html(content);

	setPagingHtml(response.paging.totalCount, response.pageList); /* paging 세팅하는  메소드 common.js에 정의 */
}