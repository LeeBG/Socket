<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />

<script type="text/javascript" src="<c:url value="/JavaScript/webtoolkit.base64.js" />"></script>
<script type="text/javascript">

$(document).ready(function() {
	closeloading();
	search('iform');
	search('oform');
});

function isVaildCheckVip(formtxt){
	var messageTitle = formtxt == "iform" ? "보안영역" : "비-보안영역"; 
	var v_ip = $("#"+formtxt).find("input[name='v_ip']").val();
	if(!isValidIP2(v_ip)){
		alert("[" + messageTitle + "] "+"<spring:message code="vaild.message.model.VirtualIp.v_ip" />");
		return true;
	}
	return false;
}

function add(formtxt){
	
	if(isVaildCheckVip(formtxt)){
		return false;
	}
	
	loading();
	var requestURL = "<c:url value="/policy/streamPolicy/insertvirtualIp.lin" />";
	resultCheckFunc($("#"+formtxt+""), requestURL, function(response) {
		var insetResult = response['insetResult'];
		var code = response['code'];
		var message = response['message'];
		var messageTitle = formtxt == "iform" ? "보안영역" : "비-보안영역"; 
		closeloading();
		
		if(insetResult == "S"){
			alert("[" + messageTitle + "] 가상 IP 추가되었습니다.");
		}else if(code == "500"){
			alert("[" + messageTitle + "] " + message);
		}else{
			alert("[" + messageTitle + "] 가상 IP 실패 되었습니다.");
		}
		search(formtxt);
		
	});
}



function search(formtxt) {
	var requestURL = "<c:url value="/policy/streamPolicy/virtualIpList.lin" />";
	resultCheckFunc($("#"+formtxt+""), requestURL, function(response) {
		var virtualIpList = response['virtualIpList'];
		var pageList =  response['pageList'];
		var pageIndex =  response['pageIndex'];
		var pageingTotalCount =  response['pageingTotalCount'];
		
		$("#pageList").html(pageList);
		$("#pageIndex").html(pageIndex);
		$("#pageingTotalCount").html(pageingTotalCount);
		
		var virtualIpListTable = "";
		
		if(formtxt == 'iform'){
			virtualIpListTable = $("#virtualIpList_In tbody");
			$("#virtualIpList_In tbody tr").remove();
		}else{
			virtualIpListTable = $("#virtualIpList_Out tbody");
			$("#virtualIpList_Out tbody tr").remove();
		}
		var disabledStr = '';
		var virtualIp = "";
		if(virtualIpList.length > 0){
			for (var i=0; i < virtualIpList.length; i++) {
				virtualIp += '<tr>\n';
				if(formtxt == 'iform'){
					if(virtualIpList[i].isdel_yn == 'N'){
						virtualIp += '<td class="right_line t_center"></td>\n';
					}else{
						virtualIp += '<td class="right_line t_center"><input type="checkbox" class="input_chk" name="chk_in" id="chk_in" value="'+ virtualIpList[i].seq +'"/></td>\n';
					}
				}else{	//oform
					if(virtualIpList[i].isdel_yn == 'N'){
						virtualIp += '<td class="right_line t_center"></td>\n';
					}else{
						virtualIp += '<td class="right_line t_center"><input type="checkbox" class="input_chk" name="chk_out" id="chk_out" value="'+ virtualIpList[i].seq +'"/></td>\n';
					}
				}
				virtualIp += '<td class="right_line t_center">'+virtualIpList[i].stm_seq+'</td>\n';
				virtualIp += '<td class="right_line t_center">'+virtualIpList[i].eth_nm+'</td>\n';
				virtualIp += '<td class="right_line t_center">'+virtualIpList[i].v_ip+'</td>\n';
				virtualIp += '<td class="right_line t_center">'+virtualIpList[i].netmask+'</td>\n';
				virtualIp += '<td class="right_line t_center">'+virtualIpList[i].note+'</td>\n';
				virtualIp += '</tr>\n';
				
			}
		}else{
			virtualIp = '<tr>\n';
			virtualIp += '<td class="t_center right_line" colspan="4">결과가 없습니다.</td> \n';
			virtualIp += '</tr>\n';
		}
		
		virtualIpListTable.append(virtualIp);
		
		var page = Base64.decode(pageList);
		pageIndex = Base64.decode(pageIndex);
		
		if(formtxt == 'iform'){
			$("#pageDiv_in").html(page + pageIndex);
			$("#total_in").html("총 " + pageingTotalCount+"건");
		}else{
			$("#pageDiv_out").html(page + pageIndex);
			$("#total_out").html("총 " + pageingTotalCount+"건");
		}
		
	});
}

function goPage_in(page) {
	$(":input[name=page]").val(page);
	search('iform');
}

function goPage_out(page) {
	$(":input[name=page]").val(page);
	search('oform');
}

function checkDelete(formtxt) {
	if(formtxt == "iform"){
		if (!$(":checkbox[name=chk_in]").is(":checked")) {
			alert("삭제 할 항목을 선택하세요.");
			return;
		}
	}else{
		if (!$(":checkbox[name=chk_out]").is(":checked")) {
			alert("삭제 할 항목을 선택하세요.");
			return;
		}
	}
	

	if (confirm("선택 목록을 삭제하겠습니까?")) {
		loading();
		var requestURL = "<c:url value="/policy/streamPolicy/deleteVirualIp.lin" />";
		resultCheckFunc($("#"+formtxt+""), requestURL, function(response) {
			closeloading();
			alert("가상 IP 삭제되었습니다.");
			search(formtxt);
		});
	}
}

function loading() {
	$('#mask2').fadeTo("slow",0.4);
	$('.loading_cus').show();
}

function closeloading() {
	$('#mask2, .loading_cus').hide();
}

$(document).ready(function() {
	checkFocusMessage($("#iform").find("input[name='v_ip']"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#iform").find("input[name='netmask']"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#iform").find("input[name='note']"),"최대 100자까지 가능합니다.");
	checkFocusMessage($("#oform").find("input[name='v_ip']"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#oform").find("input[name='netmask']"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#oform").find("input[name='note']"),"최대 100자까지 가능합니다.");
});
	
</script>
</head>
<body>
<!-- contents -->
<div class="rightArea">
	<div id="mask2"></div>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="/Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=100 height=100 />
	</div>
		<div class="conWrap viewBox">
			<h3>가상IP 관리</h3>
			
			<div class="conBox">
				<div class="tableArea">
					<div class="left_tableBox">
					<form name="iform" id="iform" method="post" onsubmit="return false;" method="post">
					<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
					<input id="io_cd" name="io_cd" type="hidden" value = "I"/>
					<input id="page" name="page" type="hidden"/>
					<input id="pagingtotalCount" name="pagingtotalCount" type="hidden"/>
					
					<div class="table_area_topCon title">보안영역</div>
					<div class="table_area_topCon addIPBox Bborder">
						<table cellspacing="0" cellpadding="0" summary="보안영역 가상IP 추가" style="table-layout : fixed;" class="mg_t10 mg_b10">
						<caption>인터페이스명, 가상IP설명</caption>
							<colgroup>
								<col style="width:15%;"/>
								<col style="width:75%;" />
								<col style="width:10%;" />
							</colgroup>
							<tbody>
								<tr>
									<th class="t_left">서버 ID</th>
									<td>
										<select style="width: 100%;" title="서버 ID" id="stm_seq" name="stm_seq">
											<c:if test="${not empty stmInfoFormList}">
												<c:forEach items="${stmInfoFormList}" var="stmInfoForm">
													<c:choose>
														<c:when test="${stmInfoForm.stm_seq eq 'STM00001'}">
															<option value='${stmInfoForm.stm_seq}' selected='selected'>${stmInfoForm.stm_seq}</option>
														</c:when>
														<c:otherwise>
															<option value='${stmInfoForm.stm_seq}' >${stmInfoForm.stm_seq}</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</c:if>
										</select>
									</td>
								</tr>
								<tr>
									<th class="t_left">가상 IP</th>
									<td><input type="text" class="text_input" id="v_ip" name="v_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx"/></td>
									<td rowspan="2" class="t_center">
										<button type="button" class="btn_common theme" onclick="add('iform')">추가</button>
									</td>
								</tr>
								<tr>
									<th class="t_left">NetMask</th>
									<td><input type="text" class="text_input" id="netmask" name="netmask" onkeyup="onlySizeFillter(this,15)"/></td>
								</tr>
								<tr>
									<th class="t_left">설명</th>
									<td><input type="text" class="text_input" id="note" name="note" onkeyup="onlySizeFillter(this,100)"/></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="table_area_style01 hoverTable">
						<div class="table_area_topCon t_left mg_t10 mg_b5">
							<button type="button" class="btn_common mg_l5" onclick="checkDelete('iform')">삭제</button>
						</div>
						<table cellspacing="0" cellpadding="0" summary="비-보안영역 가상IP리스트" id="virtualIpList_In" style="table-layout : fixed" class="mg_t5">
						<caption>요청자, 제목, 요청시간</caption>
							<colgroup>
								<col style="width:7%;"/>
								<col style="width:15%;" />
								<col style="width:20%;" />
								<col style="width:20%;" />
								<col style="width:20%;"/>
								<col style="width:23%;"/>
							</colgroup>
							<thead>
								<tr>
									<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk_in');"/></th>
									<th class="Rborder">서버 ID</th>
									<th class="Rborder">인터페이스명</th>
									<th class="Rborder">가상IP</th>
									<th class="Rborder">NetMask</th>
									<th class="Rborder">설명</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="11" class="td_last" style="border-bottom:0;">
										<span class="text_list_number" id ="total_in"></span>
										<div class="pagenate t_center" id="pageDiv_in" ></div>
									</td>
								</tr>
							</tfoot>
						</table>
					</div>
					</form>
				</div>
				<div class="right_tableBox">
					<form name="oform" id="oform" onsubmit="return false;" method="post" >
					<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
					<input id="io_cd" name="io_cd" type="hidden" value = "O"/>
					<input id="page" name="page" type="hidden"/>
					<input id="pagingtotalCount" name="pagingtotalCount" type="hidden"/>
					
					<div class="table_area_topCon title">비-보안영역</div>
					<div class="table_area_topCon addIPBox Bborder">
						<table cellspacing="0" cellpadding="0" summary="비-보안영역 가상IP 추가" style="table-layout : fixed;" class="mg_t10 mg_b10">
						<caption>인터페이스명, 가상IP설명</caption>
							<colgroup>
								<col style="width:15%;"/>
								<col style="width:75%;" />
								<col style="width:10%;" />
							</colgroup>
							<tbody>
								<tr>
									<th class="t_left">서버 ID</th>
									<td>
										<select style="width: 100%;" title="서버 ID" id="stm_seq" name="stm_seq">
											<c:if test="${not empty stmInfoFormList}">
												<c:forEach items="${stmInfoFormList}" var="stmInfoForm">
													<c:choose>
														<c:when test="${stmInfoForm.stm_seq eq 'STM00001'}">
															<option value='${stmInfoForm.stm_seq}' selected='selected'>${stmInfoForm.stm_seq}</option>
														</c:when>
														<c:otherwise>
															<option value='${stmInfoForm.stm_seq}' >${stmInfoForm.stm_seq}</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</c:if>
										</select>
									</td>
								</tr>
								<tr>
									<th class="t_left">가상 IP</th>
									<td><input type="text" class="text_input" id="v_ip" name="v_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" /></td>
									<td rowspan="2" class="t_center">
										<button type="button" class="btn_common theme" onclick="add('oform')">추가</button>
									</td>
								</tr>
								<tr>
									<th class="t_left">NetMask</th>
									<td><input type="text" class="text_input" id="netmask" name="netmask" onkeyup="onlySizeFillter(this,15)"/></td>
								</tr>
								<tr>
									<th class="t_left">설명</th>
									<td><input type="text" class="text_input" id="note" name="note" onkeyup="onlySizeFillter(this,100)"/></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="table_area_style01 hoverTable">
						<div class="table_area_topCon t_left mg_t10 mg_b5">
							<button type="button" class="btn_common mg_l5" onclick="checkDelete('oform')" >삭제</button>
						</div>
						<table cellspacing="0" cellpadding="0" summary="보안영역 가상IP리스트" id="virtualIpList_Out" style="table-layout : fixed" class="mg_t5">
						<caption>요청자, 제목, 요청시간</caption>
							<colgroup>
								<col style="width:7%;"/>
								<col style="width:15%;" />
								<col style="width:20%;" />
								<col style="width:20%;" />
								<col style="width:20%;"/>
								<col style="width:23%;"/>
							</colgroup>
							<thead>
								<tr>
									<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk_in');"/></th>
									<th class="Rborder">서버 ID</th>
									<th class="Rborder">인터페이스명</th>
									<th class="Rborder">가상IP</th>
									<th class="Rborder">NetMask</th>
									<th class="Rborder">설명</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="11" class="td_last" style="border-bottom:0;">
										<span class="text_list_number" id ="total_out"></span>
										<div class="pagenate t_center" id="pageDiv_out" ></div>
									</td>
								</tr>
							</tfoot>
						</table>
					</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>