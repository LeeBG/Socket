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

$(document).ready(function() {
	checkFocusMessage($("#obj_nm"),"최대 100자까지 가능합니다.");
	checkFocusMessage($("#dst_ip"),"0.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#rey_st_port"),"1 ~ 65534 까지 가능합니다.");
	checkFocusMessage($("#rey_ed_port"),"1 ~ 65534 까지 가능합니다.");
	checkFocusMessage($("#dst_st_port"),"1 ~ 65534 까지 가능합니다.");
	checkFocusMessage($("#dst_ed_port"),"1 ~ 65534 까지 가능합니다.");
	closeloading();
	
	var io_cd = '${destObjectForm.io_cd }';
	selectVipList(io_cd);

	var port_obj_cd = ('${destObjectForm.port_obj_cd}' == '') ? '1' : '${destObjectForm.port_obj_cd}' ;
	objValDisp(port_obj_cd);
});

//정책 추가
function insert() {
	if(!isVaildCheck()){
		return false;
	}

	loading();
	
	var port_obj_cd = $("input:radio[name=port_obj_cd]:checked").val();
	if(port_obj_cd == 1) {
		$("#rey_ed_port").val($("#rey_st_port").val());
		$("#dst_ed_port").val($("#dst_st_port").val());
	}
	
	var requestURL = "<c:url value="/policy/destObjectPolicy/insertDestObject.lin" />";
	var successURL = "<c:url value="/policy/destObjectPolicy/destObjectList.lin" />";

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
	var rey_st_port = $("#rey_st_port").val();
	var rey_ed_port = $("#rey_ed_port").val();
	var dst_ip = $("#dst_ip").val();
	var dst_st_port = $("#dst_st_port").val();
	var dst_ed_port = $("#dst_ed_port").val();
	var port_obj_cd = $("input:radio[name=port_obj_cd]:checked").val();

	if(obj_nm == ''){
		alert("객체명을 입력해 주세요.");
		return false;
	}

	if(dst_ip == '') {
		alert("<spring:message code="vaild.message.model.NetPolicy.dst_ip" />");
		return false;
	}else {
		if(!isValidIP(dst_ip)) {
			alert("<spring:message code="vaild.message.model.NetPolicy.dst_ip" />");
			return false;
		}
	}

	if(rey_st_port == '') {
		alert("<spring:message code="vaild.message.model.NetPolicy.rey_port" />");
		return false;
	}

	if(dst_st_port == '') {
		alert("<spring:message code="vaild.message.model.NetPolicy.dst_port" />");
		return false;
	}

	if(port_obj_cd == "2") {
		if(rey_ed_port == '') {
			alert("<spring:message code="vaild.message.model.NetPolicy.rey_port" />");
			return false;
		}

		if(dst_ed_port == '') {
			alert("<spring:message code="vaild.message.model.NetPolicy.dst_port" />");
			return false;
		}

		var rey_diff = (Number(rey_ed_port) - Number(rey_st_port));
		if(rey_diff < 0) {
			alert("<spring:message code="vaild.message.model.NetPolicy.rey_port" />");
			return false;
		}

		var dst_diff = (Number(dst_ed_port) - Number(dst_st_port));
		if(rey_diff != dst_diff) {
			alert("중계PORT 대역간의 차이와 목적지PORT 대역간의 차이는 같아야 합니다.");
			return false;
		}
	}

	return true;
}

function cancel() {
	location.href = "<c:url value="/policy/destObjectPolicy/destObjectList.lin" />";
}

function loading() {
	$('#mask2').fadeTo("slow",0.4);
	$('.loading_cus').show();
}

function closeloading() {
	$('#mask2, .loading_cus').hide();
}

function objValDisp(cd) {
	if(cd == 1) {
		$('#rey_port_div').css("display", "none");
		$('#rey_ed_port').css("display", "none");
		$('#dst_port_div').css("display", "none");
		$('#dst_ed_port').css("display", "none");
	}else if(cd == 2) {
		$('#rey_port_div').css("display", "");
		$('#rey_ed_port').css("display", "");
		$('#dst_port_div').css("display", "");
		$('#dst_ed_port').css("display", "");
	}
}

function selectVipList(io_cd){
	var db_rey_ip = '${streamPolicyForm.rey_ip }';
	var sel = "";
	if(io_cd == ''){
		io_cd = 'I';
	}
	$("input:radio[name=io_cd]:input[value='"+io_cd+"']").attr("checked", true);
	
	var requestURL = "<c:url value="/policy/streamPolicy/selectVIpList.lin" />";

	resultCheckFunc($("#lform"), requestURL, function(response) {
		var selectVirtualIpFormList = response['selectVirtualIpFormList'];
		var result = "";
		if (selectVirtualIpFormList == null || selectVirtualIpFormList.length == 0) {
			
		} else {
			for (var i = 0; i < selectVirtualIpFormList.length; i++) {
				var v_ip = selectVirtualIpFormList[i].v_ip;
				if(db_rey_ip == v_ip){
					sel = "selected='selected'";
				}else{
					sel = "";
				}
				result += "<option value='" + v_ip +"' "+sel+">"+ v_ip + '</option>';
			}
		}
		$('#rey_ip').html(result);
	});
	
}


</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="obj_seq" name="obj_seq" type="hidden" value="${obj_seq}"/>
<input id="cud_cd" name="cud_cd" type="hidden" value="${destObjectForm.cud_cd}"/>
<input id="dest_seq" name="dest_seq" type="hidden" value="${destObjectForm.seq}"/>
<input id="isdel_yn" name="isdel_yn" type="hidden" value="${destObjectForm.isdel_yn}"/>
	<div id="mask2"></div>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="/Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=100 height=100 />
	</div>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">목적지객체 관리</h2>
				<p class="breadCrumbs">객체관리 > 목적지객체 관리</p>
			</div>
		</div>
			<div class="conWrap">
				<h3>목적지객체  추가</h3>
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
									<th class="t_left">목적지객체ID</th>
									<td>${destObjectForm.obj_seq}</td>
								</tr>
								<tr>
									<th class="t_left">목적지객체명</th>
									<td>
										<input type="text" class="text_input long" id="obj_nm" name="obj_nm" style="max-width:70%;" placeholder="객체명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${destObjectForm.obj_nm}"/>
									</td>
								</tr>
								<tr>
									<th class="t_left">엔진번호</th>
									<td>
										<select id="tunn_idx" name="tunn_idx">
										<c:forEach begin="0" end="8"  varStatus="c" var="engine_idx">
											<option value="${engine_idx-1 }" <c:if test="${destObjectForm.tunn_idx == (engine_idx-1)}">selected="selected"</c:if>>
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
										<input type="radio" name="io_cd" id="selectIO_CDI" value="I" onclick="selectVipList('I')"/>
										<label for="selectIO_CD" class="mg_r30">보안영역</label> 
										<input type="radio" name="io_cd" id="selectIO_CDO" value="O" onclick="selectVipList('O')"/> 
										<label for="selectIO_CD">비-보안영역</label>
									</td>
								</tr>
								<tr>
									<th class="t_left">포트객체구분</th>
									<td>
										<input type="radio" name="port_obj_cd" id="port_obj_cd1" onclick="objValDisp('1');" 
											value="1" <c:if test="${destObjectForm.port_obj_cd == '1' || destObjectForm.port_obj_cd == null}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">단일</label> 
										<input type="radio" name="port_obj_cd" id="port_obj_cd2" onclick="objValDisp('2');" 
											value="2" <c:if test="${destObjectForm.port_obj_cd == '2'}">checked="checked"</c:if> /> 
										<label for="selectIO_CD" class="mg_r30">범위</label> 
									</td>
								</tr>
								<tr>
									<th class="t_left">중계 IP</th>
									<td>
									<select title="받는 IP" id="rey_ip" name="rey_ip" style="width: 150px;"></select> 
									<label for="workNetworksPort">&nbsp;&nbsp;PORT : </label> 
									<input type="text" class="text_input t_center" id="rey_st_port" name="rey_st_port" onkeyup="onlyNumBetweenFillter(this,6,1,65534)" 
														value="${destObjectForm.rey_st_port}" style="width:60px"/>
									<font id="rey_port_div">&nbsp;~&nbsp;</font>
									<input type="text" class="text_input t_center" id="rey_ed_port" name="rey_ed_port" onkeyup="onlyNumBetweenFillter(this,6,1,65534)" 
														value="${destObjectForm.rey_ed_port}" style="width:60px"/>
								</tr>
								<tr>
									<th class="t_left">목적지IP</th>
									<td>
										<input type="text" class="text_input" id="dst_ip" name="dst_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${destObjectForm.dst_ip}" style="width: 150px;"/>
										<label for="workNetworksPort">&nbsp;&nbsp;PORT : </label>
										<input type="text" class="text_input t_center" id="dst_st_port" name="dst_st_port" onkeyup="onlyNumBetweenFillter(this,6,1,65534)" 
														value="${destObjectForm.dst_st_port}" style="width:60px"/>
										<font id="dst_port_div">&nbsp;~&nbsp;</font>
										<input type="text" class="text_input t_center" id="dst_ed_port" name="dst_ed_port" onkeyup="onlyNumBetweenFillter(this,6,1,65534)" 
														value="${destObjectForm.dst_ed_port}" style="width:60px"/>
									</td>
								</tr>
								<tr>
									<th class="t_left">프로토콜	</th>
									<td>
										<select title="프로토콜" id="proto_cd" name="proto_cd">
										<c:choose>
											<c:when test="${transPolicyYN eq 'Y'}">
												<c:forEach items="${protocolCodeList}" var="protocolCodeList">
													<c:if test="${protocolCodeList.cd_val == '100'}">
														<option value='${destObjectForm.proto_cd}'>${protocolCodeList.cd_des}</option>
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
									<th class="t_left">사용여부</th>
									<td>
										<input type="radio" name="del_yn" id="del_yn" value="N" <c:if test="${destObjectForm.del_yn == 'N' || destObjectForm.del_yn == null}">checked="checked"</c:if> /> 
										<label for="selectIO_CD">사용</label>
										<input type="radio" name="del_yn" id="del_yn" value="Y" <c:if test="${destObjectForm.del_yn == 'Y'}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">미사용</label> 										
									</td>
								</tr>
								<c:if test="${destObjectForm.cud_cd == 'U'}">
								<tr>
									<th class="t_left">생성일시</th>
									<td>
										${destObjectForm.crt_date }
									</td>
								</tr>
								<tr>
									<th class="t_left">생성자</th>
									<td>
										${destObjectForm.crt_id }
									</td>
								</tr>
								<!-- <tr>
									<th class="t_left">수정일tl</th>
									<td>
										${destObjectForm.mod_date }
									</td>
								</tr>
								<tr>
									<th class="t_left">수정자</th>
									<td>
										${destObjectForm.mod_id }
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