<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<%-- <c:set var="netpolicy_max_connection_min" value="${customfunc:miniMaxInteger('netpolicy_max_connection_min')}" />
<c:set var="netpolicy_max_connection_max" value="${customfunc:miniMaxInteger('netpolicy_max_connection_max')}" /> --%>
<c:set var="netpolicy_max_connection_min" value="1" />
<c:set var="netpolicy_max_connection_max" value="65535" />
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />

<script type="text/javascript">

var netpolicy_max_connection_min = "${netpolicy_max_connection_min}";
var netpolicy_max_connection_max = "${netpolicy_max_connection_max}";

$(document).ready(function() {
	closeloading();
	$("input:radio[name=selectIO_CD]:input[value='${io_cd}']").attr("checked", true);
	selectVipList('${io_cd}');

	var cud_cd = '${cud_cd}';
	if (cud_cd == 'C') {
		 $("input[name=useUnused]").attr("disabled",true);
	}

	$('#Src_st_ip').hide();
	$('#src_1').hide();
	$('#Src_ed_ip').hide();
	$('#src_2').hide();
	$('#net_mask').hide();

	$('#Dst_ip').hide();
	$('#src_3').hide();
	$('#Dst_ed_ip').hide();
	$('#src_4').hide();
	$('#dst_net_mask').hide();

	$('#Dst_port').hide();
	$('#src_5').hide();
	$('#Dst_ed_port').hide();
});

//정책 추가
function add() {
	if(!isVaildCheckNetPolicy()){
		return false;
	}
	loading();
	var requestURL = "<c:url value="/policy/streamPolicy/insertStreamPolicy.lin" />";
	var successURL = "<c:url value="/policy/streamPolicy/streamPolicyList.lin" />";
	resultCheckFunc($("#lform"), requestURL, function(response) {
		closeloading();
		var code = response['code'];
		var message = response['message'];
		if (code == "200") {
			alert("정책 추가되었습니다.");
			$(location).attr("href", successURL);
		} else if(code == "500") {
			alert(message);
		}
	});
	resetValue();
}
function resetValue() {
	$('#Src_st_ip').val("");
	$('#Src_ed_ip').val("");
	$('#net_mask').val("");

	$('#Dst_ip').val("");
	$('#Dst_ed_ip').val("");
	$('#dst_net_mask').val("");

	$('#Dst_port').val("");
	$('#Dst_ed_port').val("");
}

function isVaildCheckNetPolicy(){
	var obj_cd = $("input:radio[name=obj_cd]:checked").val();
	var obj_cd2 = $("input:radio[name=obj_cd2]:checked").val();
	var port_obj_cd = $("input:radio[name=port_obj_cd]:checked").val();
	var Stm_name = $("#Stm_name").val();

	var Src_st_ip = $("#Src_st_ip").val();
	var Src_ed_ip = $("#Src_ed_ip").val();
	var net_mask = $("#net_mask").val();
	var Dst_ip = $("#Dst_ip").val();
	var Dst_ed_ip = $("#Dst_ed_ip").val();
	var Dst_net_mask = $("#dst_net_mask").val();
	var Dst_port = $("#Dst_port").val();
	var Dst_ed_port = $("#Dst_ed_port").val();


	if(Stm_name == ''){
		alert("정책이름을 입력해 주세요.");
		return false;
	}
	if(obj_cd == '1'){
		$("#Src_st_ip").val("0.0.0.0");
		$("#Src_ed_ip").val("255.255.255.255");
	}
	if(obj_cd == '2'){
		if(!isValidIP(Src_st_ip)){
			alert("허용IP정보를 제대로 입력해 주세요");
			return false;
		}
	}
	if(obj_cd == '3'){
		if(isValidIP(Src_st_ip) == false){
			alert("허용IP를 제대로 입력해 주세요");
			return false;
		}
		if(net_mask == '') {
			alert("허용IPNetMask를 입력해주세요");
			return false;
		}
	}
	if(obj_cd == '4'){
		if(!isValidIP(Src_st_ip) || !isValidIP(Src_ed_ip)){
			alert("허용IP를 제대로 입력해 주세요.");
			return false;
		}
		
		var st_ip_num = ipToInt(Src_st_ip);
		var ed_ip_num = ipToInt(Src_ed_ip);
		if(st_ip_num > ed_ip_num) {
			alert("허용IP 대역정보가 올바르지 않습니다.");
			return false;
		}
	}
	if(obj_cd2 == '5'){
		$("#Dst_ip").val("0.0.0.0");
		$("#Dst_ed_ip").val("255.255.255.255");
	}
	
	if(obj_cd2 == '6'){
		if(!isValidIP(Dst_ip)){
			alert("목적지IP를 제대로 입력해 주세요");
			return false;
		}
	}
	if(obj_cd2 == '7'){
		if(!isValidIP(Dst_ip)){
			alert("목적지IP를 제대로 입력해 주세요");
			return false;
		}
		if(Dst_net_mask == '') {
			alert("목적지IPNetMask를 입력해주세요");
			return false;
		}
	}
	if(obj_cd2 == '8'){
		if(!isValidIP(Dst_ip) || !isValidIP(Dst_ed_ip)){
			alert("목적지IP를 입력해 주세요.");
			return false;
		}
		var st_ip_num = ipToInt(Dst_ip);
		var ed_ip_num = ipToInt(Dst_ed_ip);
		if(st_ip_num > ed_ip_num) {
			alert("목적지IP 대역정보가 올바르지 않습니다.");
			return false;
		}
	}
	if(port_obj_cd == '9'){
		$("#Dst_port").val("0");
		$("#Dst_ed_port").val("65535");
	}

	return true;
}

function ipToInt(ip) {
    var parts = ip.split(".");
    var res = 0;
    
	res += parseInt(parts[0], 10) << 24;
    res += parseInt(parts[1], 10) << 16;
    res += parseInt(parts[2], 10) << 8;
    res += parseInt(parts[3], 10);
	return res;
}

function cancel() {
	location.href = "<c:url value="/policy/streamPolicy/streamPolicyList.lin" />";
}

function selectVipList(io_cd){
	$("#io_cd").val(io_cd);
	if(io_cd == ''){
		$("#io_cd").val('I');
	}

	var requestURL = "<c:url value="/policy/streamPolicy/selectVIpList.lin" />";

	resultCheckFunc($("#lform"), requestURL, function(response) {
		var selectVirtualIpFormList = response['selectVirtualIpFormList'];
		var result = "";
		if (selectVirtualIpFormList == null || selectVirtualIpFormList.length == 0) {
			
		} else {
			for (var i = 0; i < selectVirtualIpFormList.length; i++) {
				var v_ip = selectVirtualIpFormList[i].v_ip;
				result += "<option value='" + v_ip +"'>"+ v_ip + '</option>';
			}
		}
		$('#rey_ip').html(result);
	});
	
}

function check_USE_RadioValue(){
	var radio = document.getElementsByName('useUnused');
	if(radio[0].checked == true){
		$("#use_yn").val("Y");
	}else if(radio[1].checked == true){
		$("#use_yn").val("N");
	}
	
}

function insertVip() {
	var form = document.lform;
	form.action = "<c:url value="/policy/streamPolicy/vipPolicyList.lin" />";
	form.submit();
}

function loading() {
	$('#mask2').fadeTo("slow",0.4);
	$('.loading_cus').show();
}

function closeloading() {
	$('#mask2, .loading_cus').hide();
}

function objValDisp(cd){
	if(cd == 1){
		$('#Src_st_ip').css("display", "none");
		$('#src_1').css("display", "none");
		$('#Src_ed_ip').css("display", "none");
		$('#src_2').css("display", "none");
		$('#net_mask').css("display", "none");
	}else if(cd == 2){
		$('#Src_st_ip').css("display", "");
		$('#src_1').css("display", "none");
		$('#Src_ed_ip').css("display", "none");
		$('#src_2').css("display", "none");
		$('#net_mask').css("display", "none");
	}else if(cd == 3){
		$('#Src_st_ip').css("display", "");
		$('#src_1').css("display", "none");
		$('#Src_ed_ip').css("display", "none");
		$('#src_2').css("display", "");
		$('#net_mask').css("display", "");
	}else if(cd == 4){
		$('#Src_st_ip').css("display", "");
		$('#src_1').css("display", "");
		$('#Src_ed_ip').css("display", "");
		$('#src_2').css("display", "none");
		$('#net_mask').css("display", "none");
	}else if(cd == 5){
		$('#Dst_ip').css("display", "none");
		$('#src_3').css("display", "none");
		$('#Dst_ed_ip').css("display", "none");
		$('#src_4').css("display", "none");
		$('#dst_net_mask').css("display", "none");
	}else if(cd == 6){
		$('#Dst_ip').css("display", "");
		$('#src_3').css("display", "none");
		$('#Dst_ed_ip').css("display", "none");
		$('#src_4').css("display", "none");
		$('#dst_net_mask').css("display", "none");
	}else if(cd == 7){
		$('#Dst_ip').css("display", "");
		$('#src_3').css("display", "none");
		$('#Dst_ed_ip').css("display", "none");
		$('#src_4').css("display", "");
		$('#dst_net_mask').css("display", "");
	}else if(cd == 8){
		$('#Dst_ip').css("display", "");
		$('#src_3').css("display", "");
		$('#Dst_ed_ip').css("display", "");
		$('#src_4').css("display", "none");
		$('#dst_net_mask').css("display", "none");
	}else if(cd == 9){
		$('#Dst_port').css("display", "none");
		$('#src_5').css("display", "none");
		$('#Dst_ed_port').css("display", "none");
	}else if(cd == 10){
		$('#Dst_port').css("display", "");
		$('#src_5').css("display", "none");
		$('#Dst_ed_port').css("display", "none");
	}else if(cd == 11){
		$('#Dst_port').css("display", "");
		$('#src_5').css("display", "");
		$('#Dst_ed_port').css("display", "");
	}
}

$(document).ready(function() {
	checkFocusMessage($("#Src_st_ip"),"1.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#Dst_ip"),"1.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#Src_ed_ip"),"1.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#Dst_ed_ip"),"1.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#Dst_port"),"최소 1에서 65535까지 입력이 가능합니다.");
	checkFocusMessage($("#Dst_ed_port"),"최소 1 ~ 65535까지 입력이 가능합니다.");
	checkFocusMessage($("#max_connection"),"최소 "+ netpolicy_max_connection_min +" ~ "+ netpolicy_max_connection_max +"까지 입력이 가능합니다.");
	checkFocusMessage($("#note"), "최대 100자까지 가능합니다");
});

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="pol_seq" name="pol_seq" type="hidden" value = "${pol_seq}"/>
<input id="cud_cd" name="cud_cd" type="hidden" value = "${cud_cd}"/>
<input id="mac_addr" name="mac_addr" type="hidden" value = "00-00-00-00-00-00"/>
<input id="io_cd" name="io_cd" type="hidden" value = "${streamPolicyForm.io_cd}"/>
<input id="stm_seq" name="stm_seq" type="hidden" value = "STM00001"/>
<input id="use_yn" name="use_yn" type="hidden" value = "${streamPolicyForm.use_yn}"/>
<input id="in_dev" name="in_dev" type="hidden" value = ""/>
<input id="isdel_yn" name="isdel_yn" type="hidden" value = "${streamPolicyForm.isdel_yn}"/>
	<div id="mask2"></div>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="/Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=100 height=100 />
	</div>
	<div class="rightArea">
			<div class="conWrap">
				<h3>정책추가</h3>
				<div class="conBox">
					<div class="table_area_style02">
						<table summary="연계정책목록" style="table-layout: fixed">
							<caption>요청자, 제목, 요청시간</caption>
							<colgroup>
								<col style="width: 15%;">
								<col style="width: 85%;">
							</colgroup>
							<tbody>
								<tr>
									<th class="t_left">정책 ID</th>
									<td>${pol_seq}</td>
								</tr>
								<tr>
									<th class="t_left">정책 이름</th>
									<td><input type="text" class="text_input long" id="Stm_name" name="Stm_name" style="max-width:70%;" placeholder="정책명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value=""/></td>
								</tr>
								<%-- <tr>
									<th class="t_left">엔진번호</th>
									<td>
									<select title="정책추가 프로토콜" id="proto_cd" name="proto_cd">
										<option value='${streamPolicyForm.proto_cd}'>자동할당</option>
										<option value='${streamPolicyForm.proto_cd}'>0번엔진</option>
										<option value='${streamPolicyForm.proto_cd}'>1번엔진</option>
										<option value='${streamPolicyForm.proto_cd}'>2번엔진</option>
										<option value='${streamPolicyForm.proto_cd}'>3번엔진</option>
										<option value='${streamPolicyForm.proto_cd}'>4번엔진</option>
										<option value='${streamPolicyForm.proto_cd}'>5번엔진</option>
										<option value='${streamPolicyForm.proto_cd}'>6번엔진</option>
										<option value='${streamPolicyForm.proto_cd}'>7번엔진</option>
									</select>
									</td>
								</tr> --%>
								<tr>
									<th class="t_left">망구분</th>
									<td>
										<%-- <c:when test="${streamPolicyForm.io_cd eq 'I'}"> --%>
										<input type="radio" name="selectIO_CD" id="selectIO_CDI" value="I" onclick="selectVipList('I')" checked="checked"/>
										<label for="selectIO_CD" class="mg_r30">보안영역</labiel> 
										<input type="radio" name="selectIO_CD" id="selectIO_CDO" value="O" onclick="selectVipList('O')"/> 
										<label for="selectIO_CD">비-보안영역</label>
									</td>
								</tr>
								<tr>
									<th class="t_left">허용 IP</th>
									<td>
										<input type="radio" name="obj_cd" id="obj_cd" onclick="objValDisp('1');" value="1" <c:if test="${ipObjectForm.obj_cd == 1 || ipObjectForm.obj_cd == null}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">ANY</label>
										<input type="radio" name="obj_cd" id="obj_cd" onclick="objValDisp('2');" value="2" <c:if test="${ipObjectForm.obj_cd == 2}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">단일</label>
										<input type="radio" name="obj_cd" id="obj_cd" onclick="objValDisp('3');" value="3" <c:if test="${ipObjectForm.obj_cd == 3}">checked="checked"</c:if> /> 
										<label for="selectIO_CD" class="mg_r30">Netmask</label>
										<input type="radio" name="obj_cd" id="obj_cd" onclick="objValDisp('4');" value="4" <c:if test="${ipObjectForm.obj_cd == 4}">checked="checked"</c:if> /> 
										<label for="selectIO_CD" class="mg_r30">범위</label>

										<input type="text" class="text_input mid" id="Src_st_ip" name="Src_st_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" />
										<font id="src_1">&nbsp;~&nbsp;</font>
										<input type="text" class="text_input mid" id="Src_ed_ip" name="Src_ed_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" />
										<font id="src_2">&nbsp;/&nbsp;</font>
										<input type="text" class="text_input" id="net_mask" name="net_mask" style="max-width:5%;" onkeyup="onlyNumBetweenFillter(this,2,1,99)" placeholder="xx"/>
										
									</td>
								</tr>
							<%-- <tr>
									<th class="t_left">허용MAC</th>
									<td><input type="text" class="text_input long" id="mac_addr" name="mac_addr" onkeyup="onlySizeFillter(this,17)" value="${streamPolicyForm.mac_addr}" placeholder="xx-xx-xx-xx-xx-xx"/></td>
								</tr> --%>
								<%-- <tr>
									<th class="t_left">중계 IP</th>
									<td>
									<select title="받는 IP" id="rey_ip" name="rey_ip"></select> 
									<label for="workNetworksPort">PORT</label> 
									<input type="text" class="text_input short t_center" id="rey_port" name="rey_port" onkeyup="onlyNumBetweenFillter(this,6,2,65534)" value="${streamPolicyForm.rey_port}"/>
										<button type="button" class="btn_common mg_l5" onclick="insertVip()">추가</button></td>
								</tr> --%>
								<tr>
									<th class="t_left">목적지 IP</th>
									<td>
									<input type="radio" name="obj_cd2" id="obj_cd2" onclick="objValDisp('5');" value="5" <c:if test="${ipObjectForm.obj_cd == 5 || ipObjectForm.obj_cd == null}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">ANY</label>
										<input type="radio" name="obj_cd2" id="obj_cd2" onclick="objValDisp('6');" value="6" <c:if test="${ipObjectForm.obj_cd == 6}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">단일</label>
										<input type="radio" name="obj_cd2" id="obj_cd2" onclick="objValDisp('7');" value="7" <c:if test="${ipObjectForm.obj_cd == 7}">checked="checked"</c:if> /> 
										<label for="selectIO_CD" class="mg_r30">Netmask</label>
										<input type="radio" name="obj_cd2" id="obj_cd2" onclick="objValDisp('8');" value="8" <c:if test="${ipObjectForm.obj_cd == 8}">checked="checked"</c:if> /> 
										<label for="selectIO_CD" class="mg_r30">범위</label>

										<input type="text" class="text_input mid" id="Dst_ip" name="Dst_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value=""/>
										<font id="src_3">&nbsp;~&nbsp;</font>
										<input type="text" class="text_input mid" id="Dst_ed_ip" name="Dst_ed_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value=""/>
										<font id="src_4">&nbsp;/&nbsp;</font>
										<input type="text" class="text_input" id=dst_net_mask name="dst_net_mask" style="max-width:5%;" onkeyup="onlyNumBetweenFillter(this,2,1,99)" placeholder="xx" value="" />
										<%-- <input type="text" class="text_input" id=dst_net_mask name="dst_net_mask" style="max-width:5%;" onkeyup="onlyNumBetweenFillter(this,2,1,99)" placeholder="xx" value="${ipObjectForm.net_mask }" /> --%>
										<%-- <input type="text" class="text_input mid" id="single2" name="single2" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${streamPolicyForm.src_st_ip}"/>
										<font id="src_ed_ip_2">&nbsp;~&nbsp;</font>
										<input type="text" class="text_input mid" id="end2" name="end2" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${streamPolicyForm.dst_ip}"/> --%>
									<%-- <input type="text" class="text_input mid" id="start_ip" name="start_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${streamPolicyForm.dst_ip}"/>
									<label for="workNetworksPort">~</label>
									<input type="text" class="text_input mid" id="end_ip" name="end_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${streamPolicyForm.dst_ip}"/> --%>
									</td>
								</tr>
								<tr>
									<th class="t_left">목적지 PORT</th>
									<td>
										<input type="radio" name="port_obj_cd" id="port_obj_cd" onclick="objValDisp('9');" value="9" <c:if test="${ipObjectForm.obj_cd == 9 || ipObjectForm.obj_cd == null}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">ANY</label>
										<input type="radio" name="port_obj_cd" id="port_obj_cd" onclick="objValDisp('10');" value="10" <c:if test="${ipObjectForm.obj_cd == 10}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">단일</label>
										<input type="radio" name="port_obj_cd" id="port_obj_cd" onclick="objValDisp('11');" value="11" <c:if test="${ipObjectForm.obj_cd == 11}">checked="checked"</c:if> /> 
										<label for="selectIO_CD" class="mg_r30">범위</label>

										
										<input type="text" class="text_input short t_center" id="Dst_port" name="Dst_port" onkeyup="onlyNumBetweenFillter(this,${fn:length(netpolicy_max_connection_max)},${netpolicy_max_connection_min},${netpolicy_max_connection_max})" value="${streamPolicyForm.max_connection}" />
										<font id="src_5">&nbsp;~&nbsp;</font>
										<input type="text" class="text_input short t_center" id="Dst_ed_port" name="Dst_ed_port" onkeyup="onlyNumBetweenFillter(this,${fn:length(netpolicy_max_connection_max)},${netpolicy_max_connection_min},${netpolicy_max_connection_max})" value="${streamPolicyForm.max_connection}" />
										<%-- <input type="text" class="text_input short t_center" id="max_connection" name="max_connection" onkeyup="onlyNumBetweenFillter(this,${fn:length(netpolicy_max_connection_max)},${netpolicy_max_connection_min},${netpolicy_max_connection_max})" value="${streamPolicyForm.max_connection}" /> --%>
									</td>
								</tr>
								<tr>
									<th class="t_left">프로토콜</th>
									<td>
									<select title="프로토콜" id="proto_cd" name="proto_cd">
										<c:choose>
											<c:when test="${transPolicyYN eq 'Y'}">
												<c:forEach items="${protocolCodeList}" var="protocolCodeList">
													<c:if test="${protocolCodeList.cd_val == '100'}">
														<option value='${streamPolicyForm.proto_cd}'>${protocolCodeList.cd_des}</option>
													</c:if>
												</c:forEach>
											</c:when>
											<c:when test="${not empty destObjectForm.proto_cd}">
												<c:forEach items="${protocolCodeList}" var="protocolCodeList">
													<c:choose>
														<c:when test="${destObjectForm.proto_cd eq protocolCodeList.cd_val}">
															<%-- <c:if test="${100 != protocolCodeList.cd_val}"> --%>
																<option value='${protocolCodeList.cd_val}' selected='selected'>${protocolCodeList.cd_des}</option>
															<%-- </c:if> --%>
														</c:when>
														<c:otherwise>
															<%-- <c:if test="${100 != protocolCodeList.cd_val}"> --%>
																<option value='${protocolCodeList.cd_val}'>${protocolCodeList.cd_des}</option>
															<%-- </c:if> --%>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<c:forEach items="${protocolCodeList}" var="protocolCodeList">
													<%-- <c:if test="${100 != protocolCodeList.cd_val}"> --%>
													<option value='${protocolCodeList.cd_val}'>${protocolCodeList.cd_des}</option>
													<%-- </c:if> --%>
												</c:forEach>
											</c:otherwise>
										</c:choose>
										</select>
									</td>
								</tr>
								<tr>
									<th class="t_left">정책 사용여부</th>
									<td>
										<input type="radio" name="useUnused" id="use" ${streamPolicyForm.use_yn eq 'Y' ? ' checked' : ''} value ="Y" onclick="check_USE_RadioValue()" checked="checked"/>
										<label for="use" class="mg_r30">사용</label>
										<%-- <c:if test="${transPolicyYN eq 'N'}"> --%>
											<input type="radio" name="useUnused" id="unused" ${streamPolicyForm.use_yn eq 'N' ? ' checked' : ''} value = "N" onclick="check_USE_RadioValue()" /> 
											<label for="unused">미사용</label>
										<%-- </c:if> --%>
									</td>
								</tr>
								<tr>
									<th class="t_left">설명</th>
									<td>
										<input type="text" class="text_input" id="note" name="note"  value="${streamPolicyForm.note}" onkeyup="onlySizeFillter(this,100)" />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn_area_center mg_t10 mg_b10">
						<button type="button" class="btn_common theme mg_r5" onclick="add()">저장</button>
						<button type="button" class="btn_common theme mg_r5">초기화</button>
						<button type="button" class="btn_common theme" onclick="cancel()">취소</button>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>