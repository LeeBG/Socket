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
	checkFocusMessage($("#lform").find("input[name='obj_nm']"),"최대 100자까지 가능합니다.");
	checkFocusMessage($("#lform").find("input[name='rey_ip']"),"0.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#lform").find("input[name='dst_ip']"),"0.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	
	$('#reset').click(function(){
		location.href = '<c:url value="/policy/destObjectPolicy/destObjectList.lin" />';
	});
});

function search() {
	if(isVaildCheckNetPolicy()){
		return false;
	}
	
	$("#lform").get(0).submit();
}

function isVaildCheckNetPolicy() {
	var rey_ip = $("#rey_ip").val();
	var dst_ip = $("#dst_ip").val();
	var startDay = $("#startDay").val();
	var endDay = $("#endDay").val();

	if (!empty(rey_ip)) {
		if(!isValidIP(rey_ip)){
			alert("<spring:message code="vaild.message.model.NetPolicy.rey_ip" />");
			return true;
		}
	}
	
	if (!empty(dst_ip)) {
		if(!isValidIP(dst_ip)){
			alert("<spring:message code="vaild.message.model.NetPolicy.dst_ip" />");
			return true;
		}
	}
	
	startDay = startDay.replaceAll("-", "");
	endDay = endDay.replaceAll("-", "");
	if(startDay > endDay) {
		alert("시작 날짜("+$("#startDay").val()+")는 종료 날짜("+$("#endDay").val()+")보다 작아야 합니다.");
		return true;
	}

	return false;
}

function view(seq, cud_cd) {
	$("#seq").val(seq);
	$("#cud_cd").val(cud_cd);

	var form = document.lform;
	form.action = "<c:url value="/policy/destObjectPolicy/destObjectView.lin" />";
	form.submit();
}

function checkDelete() {
	if (!$(":checkbox[name=chk]").is(":checked")) {
		alert("삭제 할 항목을 선택하세요.");
		return;
	}

	if (confirm("선택 목록을 삭제하겠습니까?")) {
		var requestURL = "<c:url value="/policy/destObjectPolicy/deleteDestObject.lin" />";
		var successURL = "<c:url value="/policy/destObjectPolicy/destObjectList.lin" />";
		loading();
		resultCheckFunc($("#lform"), requestURL, function(response){
			closeloading();
			var code = response['code'];
			var message = response['message'];
			
			if(code == "200"){
				alert("정책이 삭제되었습니다.");
				$(location).attr("href", successURL);
			}else if(code == "501") {
				alert(message);
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
<input id="seq" name="seq" type="hidden" value = ""/>
<input id="cud_cd" name="cud_cd" type="hidden" value = ""/>
	<!-- contents -->
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
				<h3>검색조건</h3>
				<div class="conBox">
					<div class="topCon nBorder"  >
						<table summary="정책 검색조건" style="table-layout : fixed" >
						<caption>객체ID, 객체명, 객체IP정보S, 객체IP정보E, 객체구분, 삭제여부, 생성일, 생성자, 수정일, 수정자</caption>
							<colgroup>
								<col style="width:10%;"/>
								<col style="width:20%;" />
								<col style="width:10%;" />
								<col style="width:20%;" />
								<col style="width:10%;"/>
								<col style="width:20%;" />
								<col style="width:10%;" />
							</colgroup>
							<tbody>
								<tr style="border-bottom: solid 1px #ddd;">
									<th class="Rborder Lborder t_center">객체명</th>
									<td class="Rborder Lborder t_center">
										<input type="text" class="text_input" id="obj_nm" name="obj_nm" placeholder="객체명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${destObjectForm.obj_nm}"/>
									</td>
									<th class="Rborder Lborder t_center">망구분</th>
									<td class="Rborder Lborder t_center">
										<select name="io_cd" style="width: 150px;">
											<option value="">선택</option>
											<option value="I" <c:if test="${param.io_cd == 'I' }">selected="selected"</c:if>>보안영역</option>
											<option value="O" <c:if test="${param.io_cd == 'O' }">selected="selected"</c:if>>비-보안영역</option>
										</select>
									</td>
									<th class="Rborder Lborder t_center">프로토콜</th>
									<td class="Rborder Lborder t_center">
										<select title="정책추가 프로토콜" id="proto_cd" name="proto_cd" style="width: 150px;">
										<option value="">선택</option>
										<c:choose>
											<c:when test="${transPolicyYN eq 'Y'}">
												<c:forEach items="${protocolCodeList}" var="protocolCodeList">
													<c:if test="${protocolCodeList.cd_val == '100'}">
														<option value='${param.proto_cd}'>${protocolCodeList.cd_des}</option>
													</c:if>
												</c:forEach>
											</c:when>
											<c:when test="${not empty param.proto_cd}">
												<c:forEach items="${protocolCodeList}" var="protocolCodeList">
													<c:choose>
														<c:when test="${param.proto_cd eq protocolCodeList.cd_val}">
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
									<td rowspan="3" class="t_center Lborder">
										<button type="button" class="btn_common theme mg_r5"  id="reset" >초기화</button>
										<button type="button" class="btn_common theme" onclick="search()">조회</button>
									</td>
									
								</tr>
								<tr style="border-bottom: solid 1px #ddd;">
									<th class="Rborder Lborder t_center">중계IP</th>
									<td class="Rborder Lborder t_center">
										<input type="text" class="text_input" id="rey_ip" name="rey_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${param.rey_ip}"  style="width: 150px;"/>
										<!-- <select title="받는 IP" id="rey_ip" name="rey_ip"></select> -->
									</td>									
									<th class="Rborder Lborder t_center">목적지IP</th>
									<td class="Rborder Lborder t_center">
										<input type="text" class="text_input" id="dst_ip" name="dst_ip" onkeyup="onlySizeFillter(this,15)" placeholder="xxx.xxx.xxx.xxx" value="${param.dst_ip}"  style="width: 150px;"/>
									</td>
									<th class="Rborder Lborder t_center">사용여부</th>
									<td class="Rborder Lborder t_center">
										<select id="del_yn" name="del_yn" style="width: 150px;">
											<option value="" selected="selected">선택</option>
											<option value="N" <c:if test='${destObjectForm.del_yn == "N" }'>selected="selected"</c:if>>사용</option>
											<option value="Y" <c:if test='${destObjectForm.del_yn == "Y" }'>selected="selected"</c:if>>미사용</option>
										</select>
									</td>
									
								</tr>
								<tr>
									<th class="Rborder Lborder t_center">생성일</th>
									<td colspan="4">
										<span class="search_day">
											<input type="text" name="startDay" id="startDay" value="${destObjectForm.startDay}" readonly="readonly" class="text_input t_center" style="width: 100px;" />
											<img class="img_ico" onclick="showCalendar('lform', 'startDay', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">
										</span>
										&#126;
										<span class="search_day">
											<input type="text" name="endDay" id="endDay" readOnly="" value="${destObjectForm.endDay}" readonly="readonly" class="text_input short t_center" style="width: 100px;" />
											<img class="img_ico" onclick="showCalendar('lform', 'endDay', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">&nbsp;&nbsp;
										</span>
									</td>
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
							<button type="button" class="btn_common f_right mg_r5" onclick="view(0,'${CUD_CD_C}')">객체 추가</button>
						</div>
						<table summary="연계정책목록" style="table-layout : fixed" class="mg_t5">
						<caption>요청자, 제목, 요청시간</caption>
							<thead>
								<tr>
									<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
									<th class="Rborder">목적지객체ID</th>
									<th class="Rborder">목적지객체명</th>
									<th class="Rborder">엔진번호</th>
									<th class="Rborder">망구분</th>
									<th class="Rborder">중계IP</th>
									<th class="Rborder">중계PORT</th>
									<th class="Rborder">목적지IP</th>
									<th class="Rborder">목적지PORT</th>
									<th class="Rborder">프로토콜</th>
									<th class="Rborder">사용여부</th>
									<th class="Rborder">생성일시</th>
									<th class="Rborder">생성자</th>
								</tr>
							</thead>
							<colgroup>
								<col style="width:5%;"/>
								<col style="width:7%;"/>
								<col style="width:8%;" />
								<col style="width:5%;" />
								<col style="width:6%;" />
								<col style="width:8%;" />
								<col style="width:8%;" />
								<col style="width:8%;" />
								<col style="width:8%;" />
								<col style="width:8%;" />
								<col style="width:5%;" />
								<col style="width:8%;" />
								<col style="width:8%;" />
							</colgroup>
							<tbody>
								<c:if test="${not empty destObjectList}">
									<c:forEach items="${destObjectList}" var="destObjectList" varStatus="c">
										<c:choose>
											<c:when test="${destObjectList.del_yn eq 'Y'}">
												<c:set var="textColorClass">text_color_g</c:set>
											</c:when>
											<c:otherwise>
												<c:set var="textColorClass">text_color_b</c:set>
											</c:otherwise>
										</c:choose>
										<tr>
											<c:choose>
												<c:when test="${viewipObjedestObjectForm_yn eq 'N'}">
													<td class="td_chekbox Rborder t_center"></td>
												</c:when>
												<c:otherwise>
													<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${destObjectList.seq}" value="${destObjectList.seq}"/></td>
												</c:otherwise>
											</c:choose>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.obj_seq}" />" onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:out value="${destObjectList.obj_seq}" />
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.obj_nm}" />" onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:out value="${destObjectList.obj_nm}" />
											</td>
											<!--  -->
											<!--  -->
											<!--  -->
											<!--  -->
											<!--  -->
											<td class="Rborder t_center ${textColorClass}" 
												title="<c:choose><c:when test="${destObjectList.tunn_idx eq '-1'}">자동할당</c:when><c:otherwise><c:out value="${destObjectList.tunn_idx}" />번 엔진</c:otherwise></c:choose>"  
												onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:choose>
													<c:when test="${destObjectList.tunn_idx eq '-1'}">자동할당</c:when>
													<c:otherwise><c:out value="${destObjectList.tunn_idx}" />번 엔진</c:otherwise>
												</c:choose>
											</td>
											<td class="Rborder t_center ${textColorClass}"  
													title="<c:choose><c:when test="${destObjectList.io_cd eq 'I'}">보안영역</c:when><c:when test="${destObjectList.io_cd eq 'O'}">비-보안영역</c:when></c:choose>" 
													onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:choose>
													<c:when test="${destObjectList.io_cd eq 'I'}">보안영역</c:when>
													<c:when test="${destObjectList.io_cd eq 'O'}">비-보안영역</c:when>
												</c:choose>
											</td>
											
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.rey_ip}" />" onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:out value="${destObjectList.rey_ip}" />
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.rey_st_port}" />~<c:out value="${destObjectList.rey_ed_port}" />" 
												onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:choose>
													<c:when test="${destObjectList.port_obj_cd eq '1'}"><c:out value="${destObjectList.rey_st_port}" /></c:when>
													<c:when test="${destObjectList.port_obj_cd eq '2'}"><c:out value="${destObjectList.rey_st_port}" />~<c:out value="${destObjectList.rey_ed_port}" /></c:when>
												</c:choose>
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.dst_ip}" />" onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:out value="${destObjectList.dst_ip}" />
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.dst_st_port}" />~<c:out value="${destObjectList.dst_ed_port}" />" 
												onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:choose>
													<c:when test="${destObjectList.port_obj_cd eq '1'}"><c:out value="${destObjectList.dst_st_port}" /></c:when>
													<c:when test="${destObjectList.port_obj_cd eq '2'}"><c:out value="${destObjectList.dst_st_port}" />~<c:out value="${destObjectList.dst_ed_port}" /></c:when>
												</c:choose>
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.proto_val}" />" onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:out value="${destObjectList.proto_val}" />
											</td>
											<!--  -->
											<!--  -->
											<!--  -->
											<!--  -->
											<!--  -->
											<td class="Rborder t_center ${textColorClass}" 
												title="<c:choose><c:when test="${destObjectList.del_yn eq 'Y'}">미사용</c:when><c:when test="${destObjectList.del_yn eq 'N'}">사용</c:when></c:choose>" 
												onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:choose>
													<c:when test="${destObjectList.del_yn eq 'Y'}">미사용</c:when>
													<c:when test="${destObjectList.del_yn eq 'N'}">사용</c:when>
												</c:choose>
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<fmt:formatDate value="${destObjectList.crt_date}" pattern="yyyy-MM-dd HH:mm" />" onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<fmt:formatDate value="${destObjectList.crt_date}" pattern="yyyy-MM-dd HH:mm" />
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.crt_id}" />" onclick="view('${destObjectList.seq}', '${CUD_CD_U}')">
												<c:out value="${destObjectList.crt_id}" />
											</td>
										</tr>
									</c:forEach>
								</c:if>  
							</tbody>
							<tfoot>
								<tr>
									<td colspan="13" class="td_last">
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
