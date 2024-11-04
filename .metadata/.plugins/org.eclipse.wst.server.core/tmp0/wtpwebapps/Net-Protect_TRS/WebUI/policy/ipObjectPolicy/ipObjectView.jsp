<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>

<c:set var="netpolicy_max_connection_min" value="${customfunc:miniMaxInteger('netpolicy_max_connection_min')}" />
<c:set var="netpolicy_max_connection_max" value="${customfunc:miniMaxInteger('netpolicy_max_connection_max')}" />

<script type="text/javascript">

var netpolicy_max_connection_min = "${netpolicy_max_connection_min}";
var netpolicy_max_connection_max = "${netpolicy_max_connection_max}";

$(document).ready(function() {
	checkFocusMessage($("#obj_nm"),"최대 100자까지 가능합니다.");
	checkFocusMessage($("#src_st_ip"), "0.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#src_ed_ip"), "0.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#max_connection"),"최소 "+ netpolicy_max_connection_min +" ~ "+ netpolicy_max_connection_max +"까지 입력이 가능합니다.");
	
	closeloading();
	var cud_cd = '${cud_cd}';
	var obj_cd = ('${ipObjectForm.obj_cd}' == '') ? '2' : '${ipObjectForm.obj_cd}' ;
	//int timeout = (expireTime > 0 ? expireTime : BaseCode.DEFAULT_SESSION_TIMEOUT);  
	objValDisp(obj_cd);
});


function setValueIpObject(){
	var obj_cd = $("input:radio[name=obj_cd]:checked").val();
	if(validIpObject()){	//src_st_ip이 빈값이 아니면
		if(obj_cd == 1){
			$("#src_st_ip").val("0.0.0.0");
			$("#src_ed_ip").val("255.255.255.255");
		}else if(obj_cd == 2){
			$("#src_ed_ip").val($("#src_st_ip").val());
		}
	//2대역 3범위netmask는 그냥 두고
	}
}

function validIpObject(){
	var obj_cd = $("input:radio[name=obj_cd]:checked").val();
	var src_st_ip = $('#src_st_ip').val();
	if(obj_cd == 1){
		return true;
	}else{
		if(src_st_ip == null || src_st_ip == undefined || src_st_ip == ""){
			return false;
		}else{
			return true;
		}
	}
}
//정책 추가
function insert() {
	if(!isVaildCheck()){
		return false;
	}

	loading();
	
	setValueIpObject();	//객체구분별 IP값 셋팅하기

	var jsonObj = $.parseJSON($("#lform"));
	var params = null;
	if (jsonObj == null || typeof jsonObj != 'object') {
		params = $("#lform").serialize();
	} else {
		params = jsonObj;
	}
	
	var requestURL = "<c:url value="/policy/ipObjectPolicy/insertIpObject.lin" />";
	var successURL = "<c:url value="/policy/ipObjectPolicy/ipObjectList.lin" />";

	resultCheckFunc($("#lform"), requestURL, function(response) {
		closeloading();
		var code = response['code'];
		var message = response['message'];
		if (code == "200") {
			alert("요청이 성공 하였습니다.");
			$(location).attr("href", successURL);
		} else if(code == "500") {
			alert(message);
		} else if(code == "501") {
			alert(message);
		}
	});
}

function isVaildCheck(){
	var obj_nm = $("#obj_nm").val();
	var obj_cd = $("input:radio[name=obj_cd]:checked").val()
	var src_st_ip = $("#src_st_ip").val();
	var src_ed_ip = $("#src_ed_ip").val();
	var net_mask = $("#net_mask").val();
	var del_yn = $("input:radio[name=del_yn]:checked").val();
	var max_connection = $("#max_connection").val();

	if(obj_nm == ''){
		alert("객체명을 입력해 주세요.");
		return false;
	}
	
	if(obj_cd == ''){
		alert("객체구분을 선택해 주세요.");
		return false;
	}
	
	if(obj_cd == 2){
		if(!isValidIP(src_st_ip)){
			alert("객체IP정보를 입력해 주세요.");
			return false;
		}
	}
	
	if(obj_cd == 3){
		if(!isValidIP(src_st_ip) || !isValidIP(src_ed_ip)){
			alert("객체IP정보를 입력해 주세요.");
			return false;
		}
		
		var st_ip_num = ipToInt(src_st_ip);
		var ed_ip_num = ipToInt(src_ed_ip);
		if(st_ip_num > ed_ip_num) {
			alert("객체IP 대역정보가 올바르지 않습니다.");
			return false;
		}
	}
	
	if(!(del_yn == 'Y' || del_yn == 'N')) {
		alert("사용 유무를 선택해 주세요.");
		return false;
	}
	
	if(obj_cd == 4) {
		if(!isValidIP(src_st_ip)) {
			alert("객체IP정보를 입력해 주세요.");
			return false;
		}
		if(net_mask == '') {
			alert("NetMask를 입력해 주세요.");
			return false;			
		}
	}

	if(max_connection == '') {
		alert("최대 연결수를 입력해 주세요.");
		return false;
	}
	
	if(!isValidSameRange(max_connection,netpolicy_max_connection_min,netpolicy_max_connection_max)) {
		alert("<spring:message code="vaild.message.model.NetPolicy.max_connection" />");
		return false;
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
	location.href = "<c:url value="/policy/ipObjectPolicy/ipObjectList.lin" />";
}

function loading() {
	$('#mask2').fadeTo("slow",0.4);
	$('.loading_cus').show();
}

function closeloading() {
	$('#mask2, .loading_cus').hide();
}

/*function setAnyYn(yn){
	var ip = $('#src_st_ip').val();
	if(yn == 'Y'){	//ANY
		$("#src_st_ip_any_yn_y").attr("checked",true);
		$("#src_st_ip_any_yn_n").attr("checked",false);
		$('#src_st_ip').css("display", "none");
	}else if(yn == 'N'){	//SINGLE
		$("#src_st_ip_any_yn_y").attr("checked",false);
		$("#src_st_ip_any_yn_n").attr("checked",true);
		$('#src_st_ip').css("display", "");
	}
}*/

function objValDisp(cd){
	if(cd == 1){
		$('#src_st_ip').css("display", "none");
		$('#src_ed_ip').css("display", "none");
		$('#src_ed_ip_1').css("display", "none");
		$('#net_mask').css("display", "none");
		$('#net_mask_1').css("display", "none");
	}else if(cd == 2){
		$('#src_st_ip').css("display", "");
		$('#src_ed_ip').css("display", "none");
		$('#src_ed_ip_1').css("display", "none");
		$('#net_mask').css("display", "none");
		$('#net_mask_1').css("display", "none");
	}else if(cd == 3){
		$('#src_st_ip').css("display", "");
		$('#src_ed_ip').css("display", "");
		$('#src_ed_ip_1').css("display", "");
		$('#net_mask').css("display", "none");
		$('#net_mask_1').css("display", "none");
	}else if(cd == 4){
		$('#src_st_ip').css("display", "");
		$('#src_ed_ip').css("display", "none");
		$('#src_ed_ip_1').css("display", "none");
		$('#net_mask').css("display", "");
		$('#net_mask_1').css("display", "");
	}
}

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="obj_seq" name="obj_seq" type="hidden" value="${obj_seq}"/>
<input id="cud_cd" name="cud_cd" type="hidden" value="${cud_cd}"/>
<input id="seq" name="seq" type="hidden" value="${ipObjectForm.seq }"/>
<input id="isdel_yn" name="isdel_yn" type="hidden" value="${ipObjectForm.isdel_yn}"/>
	<div id="mask2"></div>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="/Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=100 height=100 />
	</div>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">IP객체관리</h2>
				<p class="breadCrumbs">객체관리 > IP객체관리</p>
			</div>
		</div>
			<div class="conWrap">
				<h3>IP객체 추가</h3>
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
									<th class="t_left">객체 ID</th>
									<td>${obj_seq}</td>
								</tr>
								<tr>
									<th class="t_left">객체명</th>
									<td>
										<input type="text" class="text_input long" id="obj_nm" name="obj_nm" style="max-width:70%;" placeholder="객체명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${ipObjectForm.obj_nm}"/>
									</td>
								</tr>
								<tr>
									<th class="t_left">객체구분</th>
									<td>
										<input type="radio" name="obj_cd" id="obj_cd1" onclick="objValDisp('1');" value="1" <c:if test="${ipObjectForm.obj_cd == 1}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">ANY</label> 
										<input type="radio" name="obj_cd" id="obj_cd2" onclick="objValDisp('2');" value="2" <c:if test="${ipObjectForm.obj_cd == 2 || ipObjectForm.obj_cd == null}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">단일</label> 
										<input type="radio" name="obj_cd" id="obj_cd3" onclick="objValDisp('3');" value="3" <c:if test="${ipObjectForm.obj_cd == 3}">checked="checked"</c:if> /> 
										<label for="selectIO_CD" class="mg_r30">범위</label> 
										<input type="radio" name="obj_cd" id="obj_cd4" onclick="objValDisp('4');" value="4" <c:if test="${ipObjectForm.obj_cd == 4}">checked="checked"</c:if> /> 
										<label for="selectIO_CD" class="mg_r30">대역</label> 
									</td>
								</tr>
								<tr>
									<th class="t_left">객체IP정보</th>
									<td class="i_ip">
										<input type="text" class="text_input" id="src_st_ip" name="src_st_ip" style="max-width:11%;" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${ipObjectForm.src_st_ip }" />
										<font id="src_ed_ip_1">&nbsp;~&nbsp;</font>
										<input type="text" class="text_input" id="src_ed_ip" name="src_ed_ip" style="max-width:11%;" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${ipObjectForm.src_ed_ip }" />
										<font id="net_mask_1">&nbsp;/&nbsp;</font><input type="text" class="text_input" id="net_mask" name="net_mask" style="max-width:5%;" onkeyup="onlyNumBetweenFillter(this,2,1,99)" placeholder="xx" value="${ipObjectForm.net_mask }" />
									</td>
								</tr>
								<tr>
									<th class="t_left">최대 연결수</th>
									<td class="i_ip">
										<input type="text" class="text_input short t_center" id="max_connection" name="max_connection" onkeyup="onlyNumBetweenFillter(this,${fn:length(netpolicy_max_connection_max)},${netpolicy_max_connection_min},${netpolicy_max_connection_max})" value="${ipObjectForm.max_connection}" />
									</td>
								</tr>
								<tr>
									<th class="t_left">사용여부</th>
									<td>
										<input type="radio" name="del_yn" id="del_yn" value="N" <c:if test="${ipObjectForm.del_yn == 'N' || ipObjectForm.del_yn == null}">checked="checked"</c:if> /> 
										<label for="selectIO_CD">사용</label>
										<input type="radio" name="del_yn" id="del_yn" value="Y" <c:if test="${ipObjectForm.del_yn == 'Y'}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">미사용</label> 
										
									</td>
								</tr>
								<c:if test="${cud_cd == 'U'}">
								<tr>
									<th class="t_left">생성일</th>
									<td>
										<fmt:formatDate value="${ipObjectForm.crt_date }" pattern="yyyy-MM-dd HH:mm" />
									</td>
								</tr>
								<tr>
									<th class="t_left">생성자</th>
									<td>
										${ipObjectForm.crt_id }
									</td>
								</tr>
								<!-- <tr>
									<th class="t_left">수정일</th>
									<td>										
										<fmt:formatDate value="${ipObjectForm.mod_date }" pattern="yyyy-MM-dd HH:mm" />
									</td>
								</tr>
								<tr>
									<th class="t_left">수정자</th>
									<td>
										${ipObjectForm.mod_id }
									</td>
								</tr> -->
								</c:if>
							</tbody>
						</table>
					</div>
					<div class="btn_area_center mg_t10 mg_b10">
						<button type="button" class="btn_common theme mg_r5" onclick="insert()">저장</button>
						<button type="button" class="btn_common theme" onclick="cancel()">취소</button>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>