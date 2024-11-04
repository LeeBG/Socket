<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>

<script type="text/javascript" src="/JavaScript/stream_policy.js"></script>
<script type="text/javascript">

$(document).ready(function() {
	closeloading();
	checkFocusMessage($("#obj_group_nm"),"최대 100자까지 가능합니다.");
	checkFocusMessage($("#note"),"최대 100자까지 가능합니다.");

	setIpObjectData();
});

function openIpObject() {
	var ip_object_val = $("#ip_object_val").val();
	var url = "<c:url value="/policy/ipObjectPolicy/ipObjectPop.lin" />?notSeq="+ip_object_val;
	var attibute = "resizable=no,scrollbars=no,width=1024,height=768,top=5,left=5,toolbar=no,resizable=no";
	var popupWindow = window.open(url, "openIpObject", attibute);
	popupWindow.focus();
}

function insert() {
	if(!isVaildCheck()){
		return false;
	}

	loading();
	
	var requestURL = "<c:url value="/policy/ipObjectPolicy/insertIpObjectGroup.lin" />";
	var successURL = "<c:url value="/policy/ipObjectPolicy/ipObjectGroupList.lin" />";

	resultCheckFunc($("#lform"), requestURL, function(response) {
		closeloading();
		var code = response['code'];
		var message = response['message'];
		if (code == "200") {
			alert("요청이 성공 하였습니다.");
			$(location).attr("href", successURL);
		} else if(code == "500") {
			alert(message);
		}
	});
}

function isVaildCheck() {
	var obj_group_nm = $("#obj_group_nm").val();
	var del_yn = $("input:radio[name=del_yn]:checked").val();
	var note = $("#note").val();
	var ip_object_val = $("#ip_object_val").val();

	if(obj_group_nm == '') {
		alert("그룹명을 입력해 주세요.");
		return false;
	}

	if(ip_object_val == '') {
		alert("허용IP 객체를 추가 해 주세요.");
		return false;
	}
	
	if(!(del_yn == 'Y' || del_yn == 'N')) {
		alert("사용 유무를 선택해 주세요.");
		return false;
	}

	if(note == '') {
		alert("설명을 입력해 주세요.");
		return false;
	}
	return true;
}

function loading() {
	$('#mask2').fadeTo("slow",0.4);
	$('.loading_cus').show();
}

function closeloading() {
	$('#mask2, .loading_cus').hide();
}

function cancel() {
	location.href = "<c:url value="/policy/ipObjectPolicy/ipObjectGroupList.lin" />";
}

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="obj_group_seq" name="obj_group_seq" type="hidden" value="${ipObjectGroupForm.obj_group_seq}"/>
<input id="ip_object_val" name="obj_seq" type="hidden" value=""/>
<input id="cud_cd" name="cud_cd" type="hidden" value="${param.cud_cd}"/>
<input id="seq" name="seq" type="hidden" value="${param.seq }"/>
<input id="isdel_yn" name="isdel_yn" type="hidden" value="${ipObjectGroupForm.isdel_yn}"/>
	<div id="mask2"></div>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="/Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=100 height=100 />
	</div>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">IP객체그룹 관리</h2>
				<p class="breadCrumbs">객체관리 > IP객체그룹 관리</p>
			</div>
		</div>
			<div class="conWrap">
				<h3> IP객체그룹 추가</h3>
				<div class="conBox">
					<div class="table_area_style01">
						<table summary="연계정책목록" style="table-layout: fixed">
							<caption>요청자, 제목, 요청시간</caption>
							<colgroup>
								<col style="width: 15%;">
								<col style="width: 85%;">
							</colgroup>
							<tbody>
								<tr>
									<th class="t_left">객체 그룹 ID</th>
									<td style="padding: 15px;">${ipObjectGroupForm.obj_group_seq}</td>
								</tr>
								<tr>
									<th class="t_left">그룹명</th>
									<td style="padding: 15px;">
										<input type="text" class="text_input long" id="obj_group_nm" name="obj_group_nm" style="max-width:70%;" placeholder="객체 그룹명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${ipObjectGroupForm.obj_group_nm}"/>
									</td>
								</tr>
								<tr>
									<th class="t_left">허용IP 객체</th>
									<td style="padding: 15px;">
										<button type="button" class="btn_common f_left mg_l5" onclick="openIpObject();" style="margin-bottom: 5px; margin-left: -2px;">IP객체추가</button>
										<button type="button" id="btnRemoveIp" class="btn_common f_left mg_l5" style="display : none;" onclick="delIpObject()">IP객체삭제</button>										
										<div>
											<table id="ipObjectListTable" summary="연계정책목록" style="table-layout : fixed;border: 1px solid;border-color: #dddddd;display : none;" class="mg_t5">
												<caption>요청자, 제목, 요청시간</caption>
												<thead>
													<tr>
														<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
														<th class="Rborder">객체ID</th>
														<th class="Rborder">객체명</th>
														<th class="Rborder">시작IP</th>
														<th class="Rborder">종료IP</th>
														<th class="Rborder">NetMask</th>
														<th class="Rborder">최대<br />연결수</th>
														<th class="Rborder">객체<br />구분</th>
														<th class="Rborder">사용<br />여부</th>
														<th class="Rborder">생성일</th>
														<th class="Rborder">생성자</th>
													</tr>
												</thead>
												<colgroup>
													<col style="width:5%;"/>
													<col style="width:8%;"/>
													<col style="width:12%;" />
													<col style="width:10%;" />
													<col style="width:10%;" />
													<col style="width:10%;" />
													<col style="width:5%;" />
													<col style="width:5%;" />
													<col style="width:5%;" />
													<col style="width:10%;" />
													<col style="width:10%;" />
												</colgroup>
												<tbody>
													<c:if test="${not empty ipObjectList}">
														<c:forEach items="${ipObjectList}" var="viewipObjectForm" varStatus="c">
															<c:choose>
																<c:when test="${viewipObjectForm.del_yn eq 'Y'}">
																	<c:set var="textColorClass">text_color_g</c:set>
																</c:when>
																<c:otherwise>
																	<c:set var="textColorClass">text_color_b</c:set>
																</c:otherwise>
															</c:choose>
															<tr>
																<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${viewipObjectForm.seq}" value="${viewipObjectForm.seq}"/></td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewipObjectForm.obj_seq}" />">
																	<c:out value="${viewipObjectForm.obj_seq}" />
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewipObjectForm.obj_nm}" />">
																	<c:out value="${viewipObjectForm.obj_nm}" />
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewipObjectForm.src_st_ip}" />">												
																	<c:choose>
																		<c:when test="${viewipObjectForm.obj_cd eq '1'}">-</c:when>
																		<c:otherwise><c:out value="${viewipObjectForm.src_st_ip}" /></c:otherwise>
																	</c:choose>
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewipObjectForm.src_ed_ip}" />">												
																	<c:choose>
																		<c:when test="${viewipObjectForm.obj_cd eq '1'}">-</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '2'}">-</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '3'}"><c:out value="${viewipObjectForm.src_ed_ip}" /></c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '4'}">-</c:when>
																	</c:choose>
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewipObjectForm.net_mask}" />" >
																	<c:choose>
																		<c:when test="${viewipObjectForm.obj_cd eq '1'}">-</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '2'}">-</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '3'}">-</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '4'}"><c:out value="${viewipObjectForm.net_mask}" /></c:when>
																	</c:choose>
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewipObjectForm.max_connection}" />">
																	<c:out value="${viewipObjectForm.max_connection}" />
																</td>
																<td class="Rborder t_center ${textColorClass}" 
																	title="<c:choose><c:when test="${viewipObjectForm.obj_cd eq '1'}">ANY</c:when><c:when test="${viewipObjectForm.obj_cd eq '2'}">단일</c:when><c:when test="${viewipObjectForm.obj_cd eq '3'}">대역</c:when><c:when test="${viewipObjectForm.obj_cd eq '4'}">범위</c:when></c:choose>">
																	<c:choose>
																		<c:when test="${viewipObjectForm.obj_cd eq '1'}">ANY</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '2'}">단일</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '3'}">대역</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '4'}">범위</c:when>
																	</c:choose>
																</td>
																<td class="Rborder t_center ${textColorClass}" 
																	title="<c:choose><c:when test="${viewipObjectForm.del_yn eq 'N'}">사용</c:when><c:when test="${viewipObjectForm.del_yn eq 'Y'}">미사용</c:when></c:choose>">
																	<c:choose>
																		<c:when test="${viewipObjectForm.del_yn eq 'N'}">사용</c:when>
																		<c:when test="${viewipObjectForm.del_yn eq 'Y'}">미사용</c:when>
																	</c:choose>
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<fmt:formatDate value="${viewipObjectForm.crt_date}" pattern="yyyy-MM-dd HH:mm" />">
																	<fmt:formatDate value="${viewipObjectForm.crt_date}" pattern="yyyy-MM-dd HH:mm" />
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewipObjectForm.crt_id}" />">
																	<c:out value="${viewipObjectForm.crt_id}" />
																</td>
															</tr>
														</c:forEach>
													</c:if>
												</tbody>
											</table>																	
										</div>
									</td>
								</tr>
								<!-- <tr>
									<th class="t_left">객체정보</th>
									<td>
										<input type="button" id="" name="" value="객체추가" onclick="addIpObject();" />
										<div id="ipObjectList">
											<c:forEach items="${ipObjectList}" varStatus="c" var="ipObjectList">
												<div>
													<div class="showDivLayer" onmouseover="showDiv('${ipObjectList.seq }');" onmouseout="hideDiv('${ipObjectList.seq }');">
													${ipObjectList.obj_nm }
													</div>
												</div>
												<div>
													<table id="show_div_${ipObjectList.seq }" style="display : none;" border="1">
														<tr>
															<td>객체ID</td>
															<td>객체명</td>
															<td>객체IP정보S</td>
															<td>객체IP정보E</td>
															<td>최대연결수</td>
															<td>객체구분</td>
															<td>삭제여부</td>
															<td>생성일</td>
															<td>생성자</td>
														</tr>
														<tr>
															<td>${ipObjectList.obj_seq }</td>
															<td>${ipObjectList.obj_nm }</td>
															<td>${ipObjectList.src_st_ip }</td>
															<td>${ipObjectList.src_ed_ip }</td>
															<td>${ipObjectList.max_connection }</td>
															<td>${ipObjectList.obj_cd }</td>
															<td>${ipObjectList.del_yn }</td>
															<td>${ipObjectList.crt_date }</td>
															<td>${ipObjectList.crt_id }</td>
														</tr>
													</table>
												</div>
											</c:forEach>
										</div>
									</td>
								</tr> -->
								<tr>
									<th class="t_left">사용여부</th>
									<td style="padding: 15px;">
										<input type="radio" name="del_yn" id="del_yn" value="N" <c:if test="${ipObjectGroupForm.del_yn == 'N' || ipObjectGroupForm.del_yn == null || ipObjectGroupForm.del_yn == ''}">checked="checked"</c:if> /> 
										<label for="selectIO_CD">사용</label>
										<input type="radio" name="del_yn" id="del_yn" value="Y" <c:if test="${ipObjectGroupForm.del_yn == 'Y'}">checked="checked"</c:if> />
										<label for="selectIO_CD" class="mg_r30">미사용</label> 
									</td>
								</tr>
								<tr>
									<th class="t_left">설명</th>
									<td style="padding: 15px;">
										<input type="text" class="text_input" id="note" name="note"  value="${ipObjectGroupForm.note}" placeholder="설명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" size="100" /> 
									</td>
								</tr>
								<c:if test="${cud_cd eq 'U' }">
								<tr>
									<th class="t_left">생성일</th>
									<td style="padding: 15px;">										
										<fmt:formatDate value="${ipObjectGroupForm.crt_date }" pattern="yyyy-MM-dd HH:mm" />
									</td>
								</tr>
								<tr>
									<th class="t_left">생성자</th>
									<td style="padding: 15px;">
										${ipObjectGroupForm.crt_id }
									</td>
								</tr>
								<!-- <tr>
									<th class="t_left">수정일</th>
									<td style="padding: 15px;">										
										<fmt:formatDate value="${ipObjectGroupForm.mod_date }" pattern="yyyy-MM-dd HH:mm" />
									</td>
								</tr>
								<tr>
									<th class="t_left">수정자</th>
									<td style="padding: 15px;">
										${ipObjectGroupForm.mod_id }
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