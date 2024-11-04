<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>

<script type="text/javascript">

//정책 추가
function add() {
	if(isVaildCheckServerManagement()){
		return false;
	}

	var requestURL = "<c:url value="/systemManagement/serverManagement/insertServerManagement.lin" />";
	var successURL = "<c:url value="/systemManagement/serverManagement/serverManagementList.lin" />";

	resultCheckFunc($("#lform"), requestURL, function(response) {
		var code = response['code'];
		var message = response['message'];
		if (code == "200") {
			alert("정책 추가되었습니다.");
			$(location).attr("href", successURL);
		} else if(code == "500") {
			alert(message);
		}
	});
}

function isVaildCheckServerManagement(){
	
	var stm_port = $("#stm_port").val();
	var i_server_ip = $("#i_server_ip").val();
	var i_vip_port = $("#i_vip_port").val();
	var in_eth_nm = $("#in_eth_nm").val();
	var o_server_ip = $("#o_server_ip").val();
	var o_vip_port = $("#o_vip_port").val();
	var out_eth_nm = $("#out_eth_nm").val();
	
	if(!isValidPort(stm_port)){
		alert("엔진 연계 포트가 올바르지 않습니다.");
		return true;
	}
	
	if(!isValidIP(i_server_ip)){
		alert("보안영역 IP가 올바르지 않습니다. ");
		return true;
	}
	if(!isValidPort(i_vip_port)){
		alert("보안영역 가상 IP 포트가 올바르지 않습니다.");
		return true;
	}
	if(empty(in_eth_nm)){
		alert("보안영역 인터페이스가 올바르지 않습니다.");
		return true;
	}
	
	if(!isValidIP(o_server_ip)){
		alert("비-보안영역 IP가 올바르지 않습니다. ");
		return true;
	}
	if(!isValidPort(o_vip_port)){
		alert("비-보안영역 가상 IP 포트가 올바르지 않습니다.");
		return true;
	}
	if(empty(out_eth_nm)){
		alert("비-보안영역 인터페이스가 올바르지 않습니다.");
		return true;
	}
}

function cancel() {
	location.href = "<c:url value="/systemManagement/serverManagement/serverManagementList.lin" />";
}

$(document).ready(function() {
	checkFocusMessage($("#i_server_ip"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#stm_port"),"최소 2 ~ 65534까지 입력이 가능합니다.");
	checkFocusMessage($("#i_vip_port"),"최소 2 ~ 65534까지 입력이 가능합니다.");
	checkFocusMessage($("#in_eth_nm"),"최대 10자까지 가능합니다.");
	checkFocusMessage($("#o_server_ip"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#o_vip_port"),"최소 2 ~ 65534까지 입력이 가능합니다.");
	checkFocusMessage($("#out_eth_nm"),"최대 10자까지 가능합니다.");
});

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="cud_cd" name="cud_cd" type="hidden" value = "${stmInfoForm.cud_cd}"/>
<input id="stm_seq" name="stm_seq" type="hidden" value = "${stmInfoForm.stm_seq}"/>
	<div class="rightArea">
			<div class="conWrap">
				<h3>서버 추가</h3>
				<div class="conBox">
					<div class="table_area_style02">
						<table summary="연계정책목록" style="table-layout: fixed">
							<caption>요청자, 제목, 요청시간</caption>
							<colgroup>
								<col style="width: 10%;">
								<col style="width: 15%;">
								<col style="width: 75%;">
							</colgroup>
							<tbody>
								<tr>
									<th class="t_center" colspan="2">서버 ID</th>
									<td> <c:out value="${stmInfoForm.stm_seq}" /></td>
								</tr>
								<tr>
									<th class="t_center" colspan="2">엔진 연계 포트</th>
									<td>
										<input type="text" class="text_input mid t_center" id="stm_port" name="stm_port" onkeyup="onlyNumBetweenFillter(this,6,2,65534)" value="${stmInfoForm.stm_port}"/>
									</td>
								</tr>
								<tr>
									<th class="Bborder Lborder t_center" rowspan="3" >보안 영역</th>
									<th class="Bborder Lborder t_center">IP</th>
									<td><input type="text" class="text_input mid" id="i_server_ip" name="i_server_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${stmInfoForm.i_server_ip}"/> 
									</td>
								</tr>
								<tr>
									<th class="Bborder Lborder t_center">가상 IP PORT</th>
									<td>
										<input type="text" class="text_input mid t_center" id="i_vip_port" name="i_vip_port" onkeyup="onlyNumBetweenFillter(this,6,2,65534)" value="${stmInfoForm.i_vip_port}"/>
									</td>
								</tr>
								<tr>
									<th class="Bborder Lborder t_center">인터페이스</th>
									<td>
										<input type="text" class="text_input mid t_center" id="in_eth_nm" name="in_eth_nm" onkeyup="onlySizeFillter(this,10)" value="${stmInfoForm.in_eth_nm}"/>
									</td>
								</tr>
								<tr>
									<th class="Bborder Lborder t_center" rowspan="3" >비-보안 영역</th>
									<th class="Bborder Lborder t_center">IP</th>
									<td><input type="text" class="text_input mid" id="o_server_ip" name="o_server_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${stmInfoForm.o_server_ip}"/> 
									</td>
								</tr>
								<tr>
									<th class="Bborder Lborder t_center">가상 IP PORT</th>
									<td>
										<input type="text" class="text_input mid t_center" id="o_vip_port" name="o_vip_port" onkeyup="onlyNumBetweenFillter(this,6,2,65534)" value="${stmInfoForm.o_vip_port}"/>
									</td>
								</tr>
								<tr>
									<th class="Bborder Lborder t_center">인터페이스</th>
									<td>
										<input type="text" class="text_input mid t_center" id="out_eth_nm" name="out_eth_nm" onkeyup="onlySizeFillter(this,10)" value="${stmInfoForm.out_eth_nm}"/>
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