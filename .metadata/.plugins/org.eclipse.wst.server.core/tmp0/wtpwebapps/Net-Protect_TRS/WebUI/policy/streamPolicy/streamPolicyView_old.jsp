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
	closeloading();
	$("input:radio[name=selectIO_CD]:input[value='${io_cd}']").attr("checked", true);
	selectVipList('${io_cd}');

	var cud_cd = '${cud_cd}';
	if (cud_cd == 'C') {
		 $("input[name=useUnused]").attr("disabled",true);
	}
	
	setSrc_St_Ip();
});

//정책 추가
function add() {
	var src_st_ip_any_yn = $(":input:radio[name=src_st_ip_any_yn]:checked").val();
	if(src_st_ip_any_yn == 'Y'){
		$('#src_st_ip').val('0.0.0.0');
	}
	if(isVaildCheckNetPolicy()){
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
			$(location).attr("href", successURL);
		}
	});
}

function isVaildCheckNetPolicy(){
	var src_st_ip = $("#src_st_ip").val();
	var mac_addr = $("#mac_addr").val();
	var rey_ip = $("#rey_ip").val();
	var rey_port = $("#rey_port").val();
	var dst_ip = $("#dst_ip").val();
	var dst_port = $("#dst_port").val();
	var max_connection = $("#max_connection").val();
	var note = $("#note").val();

	if(!isValidIP(src_st_ip)){
		alert("<spring:message code="vaild.message.model.NetPolicy.src_st_ip" />");
		return true;
	}
	if(!isValidMac(mac_addr)){
		alert("<spring:message code="vaild.message.model.NetPolicy.mac_addr" />");
		return true;
	}
	if(!isValidIP(rey_ip)){
		alert("<spring:message code="vaild.message.model.NetPolicy.rey_ip" />");
		return true;
	}
	if(!isValidPort(rey_port)){
		alert("<spring:message code="vaild.message.model.NetPolicy.rey_port" />");
		return true;
	}
	if(!isValidIP(dst_ip)){
		alert("<spring:message code="vaild.message.model.NetPolicy.dst_ip" />");
		return true;
	}
	if(!isValidPort(dst_port)){
		alert("<spring:message code="vaild.message.model.NetPolicy.dst_port" />");
		return true;
	}
	if(!isValidSameRange(max_connection,netpolicy_max_connection_min,netpolicy_max_connection_max)){
		alert("<spring:message code="vaild.message.model.NetPolicy.max_connection" />");
		return true;
	}
	if(!isValidSameRange(note,0,100)){
		alert("<spring:message code="vaild.message.model.NetPolicy.note" />");
		return true;
	}

	return false;
}

function cancel() {
	location.href = "<c:url value="/policy/streamPolicy/streamPolicyList.lin" />";
}

function selectVipList(io_cd){
	$("#io_cd").val(io_cd);

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

function setAnyYn(yn){
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
}
function setSrc_St_Ip(){
	var ip = $('#src_st_ip').val();
	if(ip == null){	//정책추가 페이지일 경우
		$("#src_st_ip_any_yn_y").attr("checked",false);
		$("#src_st_ip_any_yn_n").attr("checked",true);
	}else{	//정책수정 페이지일 경우
		if(ip == '0.0.0.0'){	//ANY
			$("#src_st_ip_any_yn_y").attr("checked",true);
			$("#src_st_ip_any_yn_n").attr("checked",false);
			$('#src_st_ip').css("display", "none");
		}else{	//SINGLE
			$("#src_st_ip_any_yn_y").attr("checked",false);
			$("#src_st_ip_any_yn_n").attr("checked",true);
			$('#src_st_ip').css("display", "");
		}
	}
}



$(document).ready(function() {
	checkFocusMessage($("#src_st_ip"),"0.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#mac_addr"),"최대 17자까지 가능합니다.");
	checkFocusMessage($("#rey_port"),"최소 1 ~ 65534까지 입력이 가능합니다.");
	checkFocusMessage($("#dst_ip"),"0.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#dst_port"),"최소 1 ~ 65534까지 입력이 가능합니다.");
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
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">연계 정책관리</h2>
				<p class="breadCrumbs">정책관리 > 연계 정책관리</p>
			</div>
		</div>
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
								<!-- <tr style="display: none;"> -->
									<th class="t_left">엔진번호</th>
									<td>
										<select id="tunn_idx" name="tunn_idx">
										<c:forEach begin="0" end="8"  varStatus="c" var="engine_idx">
											<option value="${engine_idx-1 }" <c:if test="${streamPolicyForm.tunn_idx == (engine_idx-1)}">selected="selected"</c:if>>
												<c:choose>
												<c:when test="${(engine_idx-1) == -1}">자동할당</c:when>
												<c:otherwise>${engine_idx-1 }번 엔진</c:otherwise>
												</c:choose>
											</option>
										</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<th class="t_left">망구분</th>
									<td>
										<%-- <c:when test="${streamPolicyForm.io_cd eq 'I'}"> --%>
										<input type="radio" name="selectIO_CD" id="selectIO_CDI" value="I" onclick="selectVipList('I')"/>
										<label for="selectIO_CD" class="mg_r30">보안영역</label> 
										<input type="radio" name="selectIO_CD" id="selectIO_CDO" value="O" onclick="selectVipList('O')"/> 
										<label for="selectIO_CD">비-보안영역</label>
									</td>
								</tr>
								<tr>
									<th class="t_left">허용 IP</th>
									<td>
									<input type="radio" name="src_st_ip_any_yn" id="src_st_ip_any_yn_y" value="Y" onclick="setAnyYn('Y')" />
									<label for="selectIO_CD" class="mg_r30">ANY</label>
									<input type="radio" name="src_st_ip_any_yn" id="src_st_ip_any_yn_n" value="N" onclick="setAnyYn('N')" />
									<label for="selectIO_CD" class="mg_r30">SINGLE</label>
									<input type="text" class="text_input mid" id="src_st_ip" name="src_st_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${streamPolicyForm.src_st_ip}"/> 
									</td>
								</tr>
<%-- 								<tr>
									<th class="t_left">허용MAC</th>
									<td><input type="text" class="text_input long" id="mac_addr" name="mac_addr" onkeyup="onlySizeFillter(this,17)" value="${streamPolicyForm.mac_addr}" placeholder="xx-xx-xx-xx-xx-xx"/></td>
								</tr> --%>
								<tr>
									<th class="t_left">중계 IP</th>
									<td>
									<select title="받는 IP" id="rey_ip" name="rey_ip"></select> 
									<label for="workNetworksPort">PORT</label> 
									<input type="text" class="text_input short t_center" id="rey_port" name="rey_port" onkeyup="onlyNumBetweenFillter(this,6,1,65534)" value="${streamPolicyForm.rey_port}"/>
										<button type="button" class="btn_common mg_l5" onclick="insertVip()">추가</button></td>
								</tr>
								<tr>
									<th class="t_left">목적지 IP</th>
									<td><input type="text" class="text_input mid" id="dst_ip" name="dst_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${streamPolicyForm.dst_ip}"/>
									<label for="workNetworksPort">PORT</label> 
									<input type="text" class="text_input short t_center" id="dst_port" name="dst_port" onkeyup="onlyNumBetweenFillter(this,6,1,65534)" value="${streamPolicyForm.dst_port}"/></td>
								</tr>
								<tr>
									<th class="t_left">프로토콜</th>
									<td>
										<select title="정책추가 프로토콜" id="proto_cd" name="proto_cd">
										<c:choose>
											<c:when test="${transPolicyYN eq 'Y'}">
												<c:forEach items="${protocolCodeList}" var="protocolCodeList">
													<c:if test="${protocolCodeList.cd_val == '100'}">
														<option value='${streamPolicyForm.proto_cd}'>${protocolCodeList.cd_des}</option>
													</c:if>
												</c:forEach>
											</c:when>
											<c:when test="${not empty streamPolicyForm.proto_cd}">
												<c:forEach items="${protocolCodeList}" var="protocolCodeList">
													<c:choose>
														<c:when test="${streamPolicyForm.proto_cd eq protocolCodeList.cd_val}">
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
									<th class="t_left">최대 연결수</th>
									<td>
										<input type="text" class="text_input short t_center" id="max_connection" name="max_connection" onkeyup="onlyNumBetweenFillter(this,${fn:length(netpolicy_max_connection_max)},${netpolicy_max_connection_min},${netpolicy_max_connection_max})" value="${streamPolicyForm.max_connection}" />
									</td>
								</tr>
								<tr>
									<th class="t_left">정책 사용여부</th>
									<td>
										<input type="radio" name="useUnused" id="use" ${streamPolicyForm.use_yn eq 'Y' ? ' checked' : ''} value ="Y" onclick="check_USE_RadioValue()"/>
										<label for="use" class="mg_r30">사용</label>
										<c:if test="${transPolicyYN eq 'N'}">
											<input type="radio" name="useUnused" id="unused" ${streamPolicyForm.use_yn eq 'N' ? ' checked' : ''} value = "N" onclick="check_USE_RadioValue()" /> 
											<label for="unused">미사용</label>
										</c:if>
									</td>
								</tr>
								<tr>
									<th class="t_left">설명</th>
									<td>
										<input type="text" class="text_input" id="note" name="note"  value="${streamPolicyForm.note}" onkeyup="onlySizeFillter(this,100)" size="100" />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn_area_center mg_t10 mg_b10">
						<button type="button" class="btn_common theme mg_r5" onclick="add()">저장</button>
						<button type="button" class="btn_common theme" onclick="cancel()">취소</button>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>