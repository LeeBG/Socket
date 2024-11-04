function addIpObjects(chks) {
	$('#btnRemoveIp').show();
	$('#ipObjectListTable').show();
	for (var i = 0; i < chks.length; i++) {
		$('#ipObjectListTable').children("tbody").append("<tr>"+chks[i][0].innerHTML+"</tr>");
	}
	
	setIpObjectData();
}

function delIpObject() {
	$('#ipObjectListTable').children("tbody").find("input:checkbox[name=chk]:checked").parent("td").parent("tr").remove();
	
	setIpObjectData();
}

function setIpObjectData() {
	var inputSeq = "";
	$("#ipObjectListTable input:checkbox[name=chk]").each (
			function(idx) {
				$(this).attr('checked', false);
				var seq = $(this).val();
				inputSeq = inputSeq + seq + ",";
			}
	);
	
	if(inputSeq.length == 0) {
		$('#btnRemoveIp').hide();
		$('#ipObjectListTable').hide();
	}else {
		$('#btnRemoveIp').show();
		$('#ipObjectListTable').show();
		inputSeq = inputSeq.substring(0,inputSeq.length-1);		
	}
	
	$('#ip_object_val').val('');
	$('#ip_object_val').val(inputSeq);
}

function addIpObjectGroup(chks) {
	$('#btnRemoveIpGrp').show();
	$('#ipObjectGroupListTable').show();
	for (var i = 0; i < chks.length; i++) {
		$('#ipObjectGroupListTable').children("tbody").append("<tr>"+chks[i][0].innerHTML+"</tr>");
	}
	
	setIpObjectGroupData();
}

function delIpObjectGroup() {
	$('#ipObjectGroupListTable').children("tbody").find("input:checkbox[name=chk]:checked").parent("td").parent("tr").remove();
	
	setIpObjectGroupData();
}

function setIpObjectGroupData() {
	var inputSeq = "";
	$("#ipObjectGroupListTable input:checkbox[name=chk]").each (
			function(idx) {
				$(this).attr('checked', false);
				var seq = $(this).val();
				inputSeq = inputSeq + seq + ",";
			}
	);
	
	if(inputSeq.length == 0) {
		$('#btnRemoveIpGrp').hide();
		$('#ipObjectGroupListTable').hide();
	}else {
		$('#btnRemoveIpGrp').show();
		$('#ipObjectGroupListTable').show();
		inputSeq = inputSeq.substring(0,inputSeq.length-1);		
	}
	
	$('#ip_object_group_val').val('');
	$('#ip_object_group_val').val(inputSeq);
}

function addDestObjects(chks) {
	$('#btnRemoveDest').show();
	$('#destObjectListTable').show();
	for (var i = 0; i < chks.length; i++) {
		$('#destObjectListTable').children("tbody").append("<tr>"+chks[i][0].innerHTML+"</tr>");
	}
	
	setDestObjectData();
}

function delDestObject() {
	$('#destObjectListTable').children("tbody").find("input:checkbox[name=chk]:checked").parent("td").parent("tr").remove();
	
	setDestObjectData();
}

function setDestObjectData() {
	var inputSeq = "";
	$("#destObjectListTable input:checkbox[name=chk]").each (
			function(idx) {
				$(this).attr('checked', false);
				var seq = $(this).val();
				inputSeq = inputSeq + seq + ",";
			}
	);
	
	if(inputSeq.length == 0) {
		$('#btnRemoveDest').hide();
		$('#destObjectListTable').hide();
	}else {
		inputSeq = inputSeq.substring(0,inputSeq.length-1);		
		$('#btnRemoveDest').show();
		$('#destObjectListTable').show();
	}
	
	$('#dest_object_val').val('');
	$('#dest_object_val').val(inputSeq);
}

function addDestObjectsGroup(chks) {
	$('#btnRemoveDestGrp').show();
	$('#destObjectGroupListTable').show();
	for (var i = 0; i < chks.length; i++) {
		$('#destObjectGroupListTable').children("tbody").append("<tr>"+chks[i][0].innerHTML+"</tr>");
	}
	
	setDestObjectGroupData();
}

function delDestObjectGroup() {
	$('#destObjectGroupListTable').children("tbody").find("input:checkbox[name=chk]:checked").parent("td").parent("tr").remove();
	
	setDestObjectGroupData();
}

function setDestObjectGroupData() {
	var inputSeq = "";
	$("#destObjectGroupListTable input:checkbox[name=chk]").each (
			function(idx) {
				$(this).attr('checked', false);
				var seq = $(this).val();
				inputSeq = inputSeq + seq + ",";
			}
	);
	
	if(inputSeq.length == 0) {
		$('#btnRemoveDestGrp').hide();
		$('#destObjectGroupListTable').hide();
	}else {
		$('#btnRemoveDestGrp').show();
		$('#destObjectGroupListTable').show();
		inputSeq = inputSeq.substring(0,inputSeq.length-1);		
	}
	
	$('#dest_object_group_val').val('');
	$('#dest_object_group_val').val(inputSeq);
}


