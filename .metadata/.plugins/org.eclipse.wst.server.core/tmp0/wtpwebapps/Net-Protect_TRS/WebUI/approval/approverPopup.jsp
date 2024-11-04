<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<html>
<head>
<script type="text/javascript">
	var toAddressArray = new Array();
	var ccAddressArray = new Array();

	var toLiCount = 0;
	var ccLiCount = 0;

	var approverList = "";

	$(function() {
		search();

		if ('${addressBook.searchField }' == 'email') {
			$("#select_first").text($("#email").text());
		}

		$("#query").click(function(){
			$("#queryList").toggle();
		});

		$("#queryList > li > a").click(function(){
			$("#select_first").text($(this).text());
			$("#searchField").val($(this).attr('id'));
		});

		//setOriginalAddress();

		$('#btnOk').click(function() {
			var requestURL = "<c:url value="/approval/insertApprover.lin" />";

			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				var message = response['message'];
				alert(message);
				if (code == 200) {
					window.close();
					window.opener.approvalListRefresh();  
				}
			});
		});

		$('#btnClose').click(function() {
			window.close();
		});
	});

	function search() {
		var requestURL = "<c:url value="/approval/searchApproverBook.lin" />";

		resultCheckFunc($("#lform"), requestURL, function(response) {
			if (response['approverList']) {
				approverList = response['approverList'];
			}

			var searchAddressTableTbody = $("#searchAddressTable tbody");
			$("#searchAddressTable tbody tr").remove();

			var result = "";
			if (approverList && approverList.length > 0) {
				for (var i=0; i < approverList.length; i++) {
					result += '<tr> \n';
					result += '	<td><input type="checkbox" class="input_chk" name="chk" id="chk" value="' + approverList[i].users_id + '"/></td> \n';
					result += '	<td>' + approverList[i].users_nm + '</td> \n';
					result += '	<td>' + approverList[i].dept_nm+ '</td> \n';
					result += '	<td>' + approverList[i].position_nm+ '</td> \n';
					result += '</tr> \n';
				}
			}

			searchAddressTableTbody.append(result);
		});
	}
</script>
</head>
<body>
<!-- popup 가로사이즈:640px; -->
<form id="lform" onsubmit="return false;" method="post" action="<c:url value="/approval/approverPopup.lin" />">
<input id="page" name="page" type="hidden"/>
<input id="searchField" name="searchField" type="hidden" value=""/>
	<fieldset>
	<legend>결재자 관리</legend>
	<div class="popup approver_wrap">
		<h1 class="blind">결재자 선택</h1>
		<div class="popupTitlebox">
			<h2 class="popupTitle findApprover">결재자 선택</h2>
		</div>
		<div class="address_box mg_b30">
			<div class="search_address_area">
				<div class="searchBox_addrPopup mg_b5">
					<div class="select_layer_addrPopup" style="overflow:auto;" id="query">
						<a class="select_first" id="select_first">이름</a>
						<ul class="select_layer_list" id="queryList" style="display:none;" >
							<li><a id="name" style="text-align: left;" id="">이름</a></li>
						</ul>
					</div>
					<input type="text" id="searchValue" name="searchValue" class="search_input mg_l5" value="${usersForm.searchValue}"/>
					<button type="submit" class="btn_search_st05" onClick="search()">
						<span class="ir_desc">검색</span>
					</button>
				</div>
				<div class="search_address_list">
					<table id="searchAddressTable" cellspacing="0" cellpadding="0" summary="이름, 부서, 직급">
						<caption>이름, 부서, 직급</caption>
						<colgroup>
							<col style="width:5%;" />
							<col style="width:20%;" />
							<col style="width:47%;" />
						</colgroup>
						<thead>
							<th><input type="checkbox" onclick="togchk(this, 'chk');"/></th>
							<th>이름</th>
							<th>부서</th>
							<th>직급</th>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="popup_bottom_btnArea">
			<button id="btnOk" name="btnOk" type="button" class="btn_ok_wPC_popup">
				<span class="ir_desc">확인</span>
			</button>
			<button id="btnClose" name="btnClose" type="button" class="btn_cancel_popup mg_l10 ">
				<span class="ir_desc">취소</span>
			</button>
		</div>
	</div>
	</fieldset>
</form>
</body>
</html>