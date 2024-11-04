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
	checkFocusMessage($("#lform").find("input[name='stm_seq']"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#lform").find("input[name='stm_port']"),"최대 5자까지 가능합니다.");
	checkFocusMessage($("#lform").find("input[name='i_server_ip']"),"최대 15자까지 가능합니다.");
	checkFocusMessage($("#lform").find("input[name='o_server_ip']"),"최대 15자까지 가능합니다.");
});

function search() {
	//isVaildCheckVip();
	$("#lform").get(0).submit();
}

function reset(){
	$("#stm_seq").val("");
	$("#stm_port").val("");
	$("#i_server_ip").val("");
	$("#o_server_ip").val("");
}

function insert(stm_seq, cud_cd) {
	
	$("#stm_seq").val(stm_seq);
	$("#cud_cd").val(cud_cd);

	var form = document.lform;
	form.action = "<c:url value="/systemManagement/serverManagement/serverManagementView.lin" />";
	form.submit();
}

function checkDelete() {
	if (!$(":checkbox[name=chk]").is(":checked")) {
		alert("삭제 할 항목을 선택하세요.");
		return;
	}

	if (confirm("선택 목록을 삭제하겠습니까?")) {
		var requestURL = "<c:url value="/systemManagement/serverManagement/deleteServerManagement.lin" />";
		var successURL = "<c:url value="/systemManagement/serverManagement/serverManagementList.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response){
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

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" >
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden"/>
<input id="cud_cd" name="cud_cd" type="hidden" value = ""/>
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
									<th class="Bborder Lborder t_center">서버 ID</th>
									<td class="Bborder" colspan="3"><input type="text" class="text_input" id="stm_seq" name="stm_seq" value="${stmInfoForm.stm_seq}" onkeyup="onlySizeFillter(this,15)"/></td>
									<th class="Bborder Lborder t_center">연계 엔진 PORT</th>
									<td class="Bborder" colspan="3">
										<input type="text" class="text_input" id="stm_port" name="stm_port" value="${stmInfoForm.stm_port}" onkeyup="onlySizeFillter(this,5)" />
									</td>
									<td colspan="2" rowspan="2" class="t_center Lborder">
										<button type="button" class="btn_common theme mg_r5" onclick="reset()">초기화</button>
										<button type="button" class="btn_common theme" onclick="search()">조회</button>
									</td>
								</tr>
								<tr>
									<th class="Bborder Lborder t_center ">보안영역 IP</th>
									<td class="Bborder" colspan="3"><input type="text" class="text_input" id="i_server_ip" name="i_server_ip" placeholder="xxx.xxx.xxx.xxx" onkeyup="onlySizeFillter(this,15)" value="${stmInfoForm.i_server_ip}"/></td>
									<th class="Bborder Lborder t_center">비-보안영역 IP </th>
									<td class="Bborder" colspan="3"><input type="text" class="text_input" id="o_server_ip" name="o_server_ip" placeholder="xxx.xxx.xxx.xxx" onkeyup="onlySizeFillter(this,15)" value="${stmInfoForm.o_server_ip}"/></td>
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
							<button type="button" class="btn_common f_right mg_r5" onclick="insert(0,'${CUD_CD_C}')">서버 추가</button>
						</div>
						<table summary="연계정책목록" style="table-layout : fixed" class="mg_t5">
						<caption>정책ID, 보안 IP, 비보안 IP, 스트리밍 PORT, 보안 가상IP PORT,비보안 가상IP PORT,보안 인터페이스, 비보안 인터페이스,생성날짜</caption>
							<thead>
								<tr>
									<th colspan="1" rowspan="2" class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
									<th colspan="1" rowspan="2" class="Rborder">서버 ID</th>
									<th colspan="1" rowspan="2" class="Rborder">연계 엔진 PORT</th>
									<th colspan="3" class="Rborder">보안 영역</th>
									<th colspan="3" class="Rborder">비-보안 영역</th>
									<th colspan="1" rowspan="2">생성날짜</th>
								</tr>
								<tr>
									<th class="Rborder">IP</th>
									<th class="Rborder">가상IP PORT</th>
									<th class="Rborder">인터페이스</th>
									<th class="Rborder">IP</th>
									<th class="Rborder">가상IP PORT</th>
									<th class="Rborder">인터페이스</th>
								</tr>
							</thead>
							<colgroup>
								<col style="width:3%;"/>
								<col style="width:10%;" />
								<col style="width:8%;" />
								<col style="width:8%;" />
								<col style="width:10%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
								<col style="width:12%;" />
								<col style="width:13%;" />
							</colgroup>
							<tbody>
								<c:if test="${not empty stmInfoFormList}">
									<c:forEach items="${stmInfoFormList}" var="viewStmInfoForm" varStatus="c">
										<tr>
											<c:choose>
											<c:when test="${viewStmInfoForm.del_yn eq 'N'}">
												<td class="td_chekbox Rborder t_center"></td>
											</c:when>
											<c:otherwise>
												<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${viewStmInfoForm.stm_seq}" value="${viewStmInfoForm.stm_seq}"/></td>
											</c:otherwise>
										</c:choose>
											
											<td class="Rborder t_center ${textColorClass}">
												<a onclick="insert('${viewStmInfoForm.stm_seq}', '${CUD_CD_U}')">
													<c:out value="${viewStmInfoForm.stm_seq}" />
												</a>
											</td>
											<td class="Rborder t_center ${textColorClass}">
												<a onclick="insert('${viewStmInfoForm.stm_seq}', '${CUD_CD_U}')">
													<c:out value="${viewStmInfoForm.stm_port}" />
												</a>
											</td>
											<td class="Rborder t_center ${textColorClass}">
												<a onclick="insert('${viewStmInfoForm.stm_seq}', '${CUD_CD_U}')">
													<c:out value="${viewStmInfoForm.i_server_ip}" />
												</a>
											</td>
											<td class="Rborder t_center ${textColorClass}">
												<a onclick="insert('${viewStmInfoForm.stm_seq}', '${CUD_CD_U}')">
													<c:out value="${viewStmInfoForm.i_vip_port}" />
												</a>
											</td>
											<td class="Rborder t_center ${textColorClass}">
												<a onclick="insert('${viewStmInfoForm.stm_seq}', '${CUD_CD_U}')">
													<c:out value="${viewStmInfoForm.in_eth_nm}" />
												</a>
											</td>
											<td class="Rborder t_center ${textColorClass}">
												<a onclick="insert('${viewStmInfoForm.stm_seq}', '${CUD_CD_U}')">
													<c:out value="${viewStmInfoForm.o_server_ip}" />
												</a>
											</td>
											<td class="Rborder t_center ${textColorClass}">
												<a onclick="insert('${viewStmInfoForm.stm_seq}', '${CUD_CD_U}')">
													<c:out value="${viewStmInfoForm.o_vip_port}" />
												</a>
											</td>
											<td class="Rborder t_center ${textColorClass}">
												<a onclick="insert('${viewStmInfoForm.stm_seq}', '${CUD_CD_U}')">
													<c:out value="${viewStmInfoForm.out_eth_nm}" />
												</a>
											</td>
											<td class="Rborder t_center ${textColorClass}">
												<a onclick="insert('${viewStmInfoForm.stm_seq}', '${CUD_CD_U}')">
													<fmt:formatDate value="${viewStmInfoForm.crt_date}" pattern="yyyy-MM-dd HH:mm" />
												</a>
											</td>
										</tr>
									</c:forEach>
								</c:if>  
							</tbody>
							<tfoot>
								<tr>
									<td colspan="10" class="td_last">
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
