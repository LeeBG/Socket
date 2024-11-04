/**
 * API 호출 기능
 */

function getFindOtherDeptApproverList( param , successFunc ){
	$.ajax({
		url: "/data/file/FindOtherDeptApproverList.lin",
		cache: false,
		type: "post",
		headers: { 
			 "Content-Type": "text/plain; charset=utf-8"
		},
		data: JSON.stringify(param),
		success: function(data) {
			if( successFunc ){
				successFunc(data);
			}
		}
	});
}
function getFindDept( param , successFunc ){
	$.ajax({
		url: "/hr/dept/findDept.lin",
		cache: false,
		async : false,
		type: "post",
		headers: { 
	        "Content-Type": "text/plain; charset=utf-8"
	    },
		data: JSON.stringify(param),
		success: function(data) {
			if( successFunc ){
				successFunc(data);
			}
		}
	});
}

function getApprovalLineInfo( level , successFunc ){
	$.ajax({
		url: "/approvalLineInfo.lin?level=" + level,
		cache : false,
		success: function(data) {
			if( successFunc ){
				successFunc(data);
			}
		}
	});
}

function getApprovalLineApprover(level, deptSeq, levelCd, successFunc){
	$.ajax({
		url: "/approvalLineApprover.lin?level=" + level + "&deptSeq=" + deptSeq + "&levelCd=" + levelCd,
		cache : false,
		async : false,
		success: function(data) {
			if( successFunc ){
				successFunc(data);
			}
		}
	});
}

function getLineInfoNLevel( successFunc ){
	$.ajax({
		url: "/approval/lineInfoNLevelMap.lin",
		cache : false,
		async : false,
		success: function(data) {
			if( successFunc ){
				successFunc(data);
			}
		}
	});
}

function getStatisticsData( successFunc ){
	$.ajax({
		url: "/dashboard/data.lin",
		cache : false,
		dataType: "json",
		success: sethtml(data)
	});
	
	function sethtml (response) {
		var content ="";
		for( var i=0; i<response.length; i++ ) {
			var data = response[i];
			content += "<li>" +
					"<input type='checkbox' onclick='" + getApplyOfficeFunction() + "();' name='chk' value='"+office.office_seq+"' id='chk"+i+"'"
					+ (FILTER_OFFICE.indexOf(office.office_seq) > -1? "checked" : "") +" /><label for='chk"+i+"' style='cursor:pointer' >" + office.office_name + "</label>"
				+ "</li>";
		}
		$("#tbody_area").html(content);
	}
}