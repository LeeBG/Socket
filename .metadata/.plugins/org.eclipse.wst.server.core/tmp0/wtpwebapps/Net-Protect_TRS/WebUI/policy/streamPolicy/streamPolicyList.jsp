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

<script type="text/javascript">

$(document).ready(function() {
	checkFocusMessage($("#lform").find("input[name='pol_seq']"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#lform").find("input[name='rey_ip']"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#lform").find("input[name='dst_ip']"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#lform").find("input[name='rey_port']"),"65534 까지 가능합니다.");
	checkFocusMessage($("#lform").find("input[name='dst_port']"),"65534 까지 가능합니다.");
});

function search() {
	isVaildCheckVip();
	$("#lform").get(0).submit();
}

function isVaildCheckVip(formtxt){
	
	var rey_ip = $("#lform").find("input[name='rey_ip']").val();
	if(!isValidIPSimple(rey_ip)){
		alert("중계 "+"<spring:message code="vaild.message.model.ip" />");
		return true;
	}
	var dst_ip = $("#lform").find("input[name='dst_ip']").val();
	if(!isValidIPSimple(dst_ip)){
		alert("목적지 "+"<spring:message code="vaild.message.model.ip" />");
		return true;
	}
	
	var rey_port = $("#lform").find("input[name='rey_port']").val();
	if(isValidPort(Number(rey_port))){
		alert("중계 PORT가 올바르지 않습니다.");
		return true;
	}
	var dst_port = $("#lform").find("input[name='dst_port']").val();
	if(isValidPort(Number(dst_port))){
		alert("목적지 PORT가 올바르지 않습니다.");
		return true;
	}
	return false;
}

function reset(){
	$("#pol_seq").val("");
	$("#rey_ip").val("");
	$("#proto_cd").val("");
	$("#rey_ip").val("");
	$("#dst_ip").val("");
	$("#dst_port").val("");
}

function insert(pol_seq, cud_cd, io_cd) {
	$("#pol_seq").val(pol_seq);
	$("#cud_cd").val(cud_cd);
	$("#io_cd").val(io_cd);

	var form = document.lform;
	form.action = "<c:url value="/policy/streamPolicy/streamPolicyView.lin" />";
	form.submit();
	//location.href = "<c:url value="/policy/streamPolicy/streamPolicyView.lin" />";
}

function checkDelete() {
	if (!$(":checkbox[name=chk]").is(":checked")) {
		alert("삭제 할 항목을 선택하세요.");
		return;
	}

	if (confirm("선택 목록을 삭제하겠습니까?")) {
		var requestURL = "<c:url value="/policy/streamPolicy/deleteStreamPolicy.lin" />";
		var successURL = "<c:url value="/policy/streamPolicy/streamPolicyList.lin" />";
		loading();
		resultCheckFunc($("#lform"), requestURL, function(response){
			closeloading();
			var code = response['code'];
			var message = response['message'];
			
			if(code == "200"){
				alert("정책이 삭제되었습니다.");
				$(location).attr("href", successURL);
			}else {
				alert("정책 삭제 도중 에러가 발생되었습니다.");
			}
			
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

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" >
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden"/>
<input id="cud_cd" name="cud_cd" type="hidden" value = ""/>
<input id="io_cd" name="io_cd" type="hidden" value = ""/>
<input id="protocol" name="protocol" type="hidden" value = ""/>
<input name="DETECT" id="DETECT" type="hidden" value="${res}"/>
	<!-- contents -->
	<div id="mask2"></div>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="/Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=100 height=100 />
	</div>
	<div class="rightArea">
			<div class="conWrap">
				<h3>검색조건</h3>
				<div class="conBox">
					<div class="topCon nBorder"  >
						<table summary="정책 검색조건" style="table-layout : fixed" >
						<caption>정책ID, 정책명, 프로토콜, 연계IP, 연계PORT, 목적지IP, 목적지PORT</caption>
							<colgroup>
								<col style="width:10%;"/>
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
							</colgroup>
							<tbody>
								<tr>
									<th class="Bborder Lborder t_center">정책ID</th>
									<td class="Bborder" colspan="3"><input type="text" class="text_input" id="pol_seq" name="pol_seq" value="${streamPolicyForm.pol_seq}" onkeyup="onlySizeFillter(this,15)"/></td>
									<th class="Bborder Lborder t_center"></th>
									<td class="Bborder" colspan="3"></td>
									<th class="Bborder Lborder t_center">프로토콜</th>
									<td class="Bborder t_center">
										<div id="protoList"></div>
										<select title="파일전송정책 검색조건" id="proto_cd" name="proto_cd">
											<option value="all">전체</option>
											<c:choose>
												<c:when test="${not empty streamPolicyForm.proto_cd}">
													<c:forEach items="${protocolCodeList}" var="protocolCodeList">
														<c:choose>
															<c:when test="${streamPolicyForm.proto_cd eq protocolCodeList.cd_val}">
																<option value='${protocolCodeList.cd_val}' selected='selected'>${protocolCodeList.cd_des}</option>
															</c:when>
															<c:otherwise>
																<option value='${protocolCodeList.cd_val}'>${protocolCodeList.cd_des}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</c:when>
												<c:otherwise>
													<c:forEach items="${protocolCodeList}" var="protocolCodeList">
														<option value='${protocolCodeList.cd_val}'>${protocolCodeList.cd_des}</option>
													</c:forEach>
												</c:otherwise>
											</c:choose>
										</select>
									</td>
								</tr>
								<tr>
									<th class="Bborder Lborder t_center ">정책이름</th>
									<td class="Bborder" colspan="3"><input type="text" class="text_input" id="rey_ip" name="rey_ip" onkeyup="onlySizeFillter(this,15)" value="${streamPolicyForm.rey_ip}"/></td>
									<th class="Bborder Lborder t_center">망구분</th>
									<td class="Bborder" colspan="3"><input type="text" class="text_input" id="rey_port" name="rey_port" onkeyup="onlySizeFillter(this,5)" value="${streamPolicyForm.rey_port}"/></td>
									<td colspan="2" rowspan="2" class="t_center Lborder">
										<button type="button" class="btn_common theme mg_r5" onclick="reset()">초기화</button>
										<button type="button" class="btn_common theme" onclick="search()">조회</button>
									</td>
								</tr>
								<tr>
									<th class="t_center Lborder">목적지 IP</th>
									<td colspan="3"><input type="text" class="text_input" class="text_input" id="dst_ip" name="dst_ip" placeholder="xxx.xxx.xxx.xxx" onkeyup="onlySizeFillter(this,15)" value="${streamPolicyForm.dst_ip}"/></td>
									<th class="t_center Lborder">목적지 PORT</th>
									<td colspan="3"><input type="text" class="text_input" class="text_input" id="dst_port" name="dst_port" onkeyup="onlySizeFillter(this,5)" value="${streamPolicyForm.dst_port}"/></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="conWrap">
				<h3>목록</h3>
				<div class="conBox">
					<div class="table_area_style01 hoverTable">
						<div class="table_area_topCon mg_t15 mg_b5">
							<button type="button" class="btn_common f_left mg_l5" onclick="checkDelete()">삭제</button>
							<button type="button" class="btn_common f_right mg_r5" onclick="insert(0,'${CUD_CD_C}')">새 정책 추가</button>
						</div>
						<table summary="연계정책목록" style="table-layout : fixed" class="mg_t5">
						<caption>요청자, 제목, 요청시간</caption>
							<thead>
								<tr>
									<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
									<th class="Rborder">정책ID</th>
									<th class="Rborder">정책이름</th>
									<th class="Rborder">서버ID</th>
									<th class="Rborder">망구분</th>
									<th class="Rborder">허용IP</th>
									<!-- <th class="Rborder">중계 IP</th>
									<th class="Rborder">중계PORT</th> -->
									<th class="Rborder">목적지IP</th>
									<th class="Rborder">목적지PORT</th>
									<th class="Rborder">프로토콜</th>
									<th class="Rborder">사용 여부</th>
									<th>생성날짜</th>
								</tr>
							</thead>
							<colgroup>
								<col style="width:3%;"/>
								<col style="width:8%;" />
								<col style="width:8%;" />
								<col style="width:8%;" />
								<col style="width:8%;" />
								<col style="width:13%;" />
								<%-- <col style="width:8%;" />
								<col style="width:8%;" /> --%>
								<col style="width:13%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:5%;" />
								<col style="width:22%;" />
							</colgroup>
							<tbody>
								<c:if test="${not empty streamPolicyFormList}">
									<c:forEach items="${streamPolicyFormList}" var="streamPolicyForm" varStatus="c">
										<c:choose>
											<c:when test="${streamPolicyForm.use_yn eq 'Y'}">
												<c:set var="textColorClass">text_color_b</c:set>
											</c:when>
											<c:otherwise>
												<c:set var="textColorClass">text_color_g</c:set>
											</c:otherwise>
										</c:choose>
										<tr>
										<c:choose>
											<c:when test="${streamPolicyForm.isdel_yn eq 'N'}">
												<td class="td_chekbox Rborder t_center"></td>
											</c:when>
											<c:otherwise>
												<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${streamPolicyForm.pol_seq}" value="${streamPolicyForm.pol_seq}"/></td>
											</c:otherwise>
										</c:choose>
										<td class="Rborder t_center ${textColorClass}">
											<a onclick="insert('${streamPolicyForm.pol_seq}', '${CUD_CD_U}', '${streamPolicyForm.io_cd}')">
											<c:out value="${streamPolicyForm.pol_seq}" />
											</a>
										</td>
										<td class="Rborder t_center ${textColorClass}">
											<a onclick="insert('${streamPolicyForm.pol_seq}', '${CUD_CD_U}', '${streamPolicyForm.io_cd}')">
											<c:out value="${streamPolicyForm.stm_name}" />
											</a>
										</td>
										<td class="Rborder t_center ${textColorClass}">
											<a onclick="insert('${streamPolicyForm.pol_seq}', '${CUD_CD_U}', '${streamPolicyForm.io_cd}')">
											<c:out value="${streamPolicyForm.stm_seq}" />
											</a>
										</td>
										<td class="Rborder t_center ${textColorClass}">
											<a onclick="insert('${streamPolicyForm.pol_seq}', '${CUD_CD_U}', '${streamPolicyForm.io_cd}')">
											<c:out value="${customfunc:codeDes('NP_CD', streamPolicyForm.io_cd)}"/>
											</a>
										</td>
										<td class="Rborder t_center ${textColorClass}">
											<a onclick="insert('${streamPolicyForm.pol_seq}', '${CUD_CD_U}', '${streamPolicyForm.io_cd}')">
											<c:choose>
													<c:when test="${streamPolicyForm.obj_cd eq '1'}">ANY</c:when>
													<c:when test="${streamPolicyForm.obj_cd eq '2'}"><c:out value="${streamPolicyForm.src_ed_ip}" /></c:when>
													<c:when test="${streamPolicyForm.obj_cd eq '3'}"><c:out value="${streamPolicyForm.src_st_ip}" />~<c:out value="${streamPolicyForm.src_ed_ip}" /></c:when>
													<c:when test="${streamPolicyForm.obj_cd eq '4'}"><c:out value="${streamPolicyForm.src_st_ip}" />~<c:out value="${streamPolicyForm.src_ed_ip}" /></c:when>
											</c:choose>
											</a>
										</td>
										<td class="Rborder t_center ${textColorClass}">
											<a onclick="insert('${streamPolicyForm.pol_seq}', '${CUD_CD_U}', '${streamPolicyForm.io_cd}')">
											<c:choose>
													<c:when test="${streamPolicyForm.obj_cd2 eq '5'}">ANY</c:when>
													<c:when test="${streamPolicyForm.obj_cd2 eq '6'}"><c:out value="${streamPolicyForm.dst_ed_ip}" /></c:when>
													<c:when test="${streamPolicyForm.obj_cd2 eq '7'}"><c:out value="${streamPolicyForm.dst_ip}" />~<c:out value="${streamPolicyForm.dst_ed_ip}" /></c:when>
													<c:when test="${streamPolicyForm.obj_cd2 eq '8'}"><c:out value="${streamPolicyForm.dst_ip}" />~<c:out value="${streamPolicyForm.dst_ed_ip}" /></c:when>
											</c:choose>
											</a>
										</td>
										<td class="Rborder t_center ${textColorClass}">
											<a onclick="insert('${streamPolicyForm.pol_seq}', '${CUD_CD_U}', '${streamPolicyForm.io_cd}')">
											<c:choose>
													<c:when test="${streamPolicyForm.port_obj_cd eq '9'}">ANY</c:when>
													<c:when test="${streamPolicyForm.port_obj_cd eq '10'}"><c:out value="${streamPolicyForm.dst_ed_port}" /></c:when>
													<c:when test="${streamPolicyForm.port_obj_cd eq '11'}"><c:out value="${streamPolicyForm.dst_port}" />~<c:out value="${streamPolicyForm.dst_ed_port}" /></c:when>
											</c:choose>
											</a>
										</td>
										<td class="Rborder t_center ${textColorClass}">
											<%-- <a onclick="insert('${streamPolicyForm.pol_seq}', '${CUD_CD_U}', '${streamPolicyForm.io_cd}')">
											<c:out value="${streamPolicyForm.protocol}" />
											</a> --%>
											<a onclick="insert('${streamPolicyForm.pol_seq}', '${CUD_CD_U}', '${streamPolicyForm.io_cd}')">
												<c:out value="${customfunc:codeDes('PROTO_CD', streamPolicyForm.proto_cd)}"/>
											</a>
										</td>
										<td class="Rborder t_center ${textColorClass}" 
												title="<c:choose><c:when test="${streamPolicyForm.use_yn eq 'N'}">미사용</c:when><c:when test="${streamPolicyForm.use_yn eq 'Y'}">사용</c:when></c:choose>" 
												onclick="view('${streamPolicyForm.seq}', '${CUD_CD_U}')">
												<c:choose>
													<c:when test="${streamPolicyForm.use_yn eq 'N'}">미사용</c:when>
													<c:when test="${streamPolicyForm.use_yn eq 'Y'}">사용</c:when>
												</c:choose>
											</td>
										<td class="t_center ${textColorClass}">
											<a onclick="insert('${streamPolicyForm.pol_seq}', '${CUD_CD_U}', '${streamPolicyForm.io_cd}')">
												<fmt:formatDate value="${streamPolicyForm.crt_date}" pattern="yyyy-MM-dd HH:mm" />
											</a>
										</td>
										</tr>
										</c:forEach>
										</c:if>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="12" class="td_last">
									<span class="text_list_number"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></span>
									<div class="pagenate t_center">
										${pageList}
									</div>
									</td>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>
		</div>
	
</form>
</body>
</html>
