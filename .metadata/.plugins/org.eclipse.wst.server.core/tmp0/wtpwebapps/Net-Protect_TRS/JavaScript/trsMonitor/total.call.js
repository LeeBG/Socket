document.write("<script src='/JavaScript/htmlappend.js'></script>");
/**
 * total API 호출 기능
 */

function getEventLogList( ){
	var param = {
			'office_list': FILTER_OFFICE,
			'country_list': FILTER_COUNTRY,
			'page': $('#page').val(),
			'startDay': $('#startDay').val(),
			'endDay': $('#endDay').val(),
			'io_cd': $("select[name=selectNetworkPosition]").val()
	};
	$.ajax({
		type : "get",
		url: "/total/eventHistory/eventHistoryList.lin",
		cache : false,
		data: param,
		dataType: "json",
		success: setEventLogHistory
	});
}

/* officeManagement.jsp List 사용 */
function getOfficeList(){
	var param = {
			'office_list': FILTER_OFFICE,
			'country_list': FILTER_COUNTRY,
			'page': $('#page').val()
	};
	$.ajax({
		type : "get",
		url: "/total/office/officeManagementList.lin",
		cache : false,
		data: param,
		dataType: "json",
		success: setAdminManagement
	});
}

/* countryList List 사용 */
function getCountryList( ){
	$.ajax({
		type : "get",
		url: "/total/office/getCountryList.lin",
		cache : false,
		dataType: "json",
		success: setCountryListManagement
	});
}

/* groupList List 사용 */
function getGroupList( ){
	$.ajax({
		type : "get",
		url: "/total/office/getGroupList.lin",
		cache : false,
		dataType: "json",
		success: setGroupListManagement
	});
}

/* country selectObject 가져오기 */
function getCountry( param ){
	var param = {
		'group_seq' : param
	}
	$.ajax({
		type : "get",
		data: param,
		url: "/total/office/getCountry.lin",
		cache : false,
		dataType: "json",
		success: setOfficeGroup
	});
}

/* MailHistory List */
function getMailHistory( ){
	var param = {
			'office_list': FILTER_OFFICE,
			'country_list': FILTER_COUNTRY,
			'page': $('#page').val(),
			'startDay': $('#startDay').val(),
			'endDay': $('#endDay').val(),
			'searchValue': $("#searchValue").val(),
			'searchField': $("#searchField").val(),
			'searchVcStatus': $("#searchVcStatus").val()
	};
	$.ajax({
		type : "get",
		url: "/total/mailHistory/mailHistoryList.lin",
		cache : false,
		data: param,
		dataType: "json",
		success: setMailHistoryList
	});
}