<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>

<script type="text/javascript" src="/JavaScript/stream_policy.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	setIpObjectData();
	setIpObjectGroupData();
	setDestObjectData();
	setDestObjectGroupData();

	closeloading();
	
	var cud_cd = '${cud_cd}';
	if (cud_cd == 'C') {
		$("input[name=useUnused]").attr("disabled",true);
	}	
});

function togChkPol(obj, name, parent) {
	$("#"+parent+" input:checkbox[name=" + name + "]").attr("checked", $(obj).is(":checked"));
}

function loading() {
	$('#mask2').fadeTo("slow",0.4);
	$('.loading_cus').show();
}

function closeloading() {
	$('#mask2, .loading_cus').hide();
}


//정책 추가
function add() {
	if(isVaildCheckNetPolicy()) {
		return false;
	}
	
	loading();
	//check_USE_RadioValue();
	var requestURL = "<c:url value="/policy/streamPolicy/insertStreamPolicy.lin" />";
	var successURL = "<c:url value="/policy/streamPolicy/streamPolicyGroupList.lin" />";

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

function isVaildCheckNetPolicy() {	
	//var note = $("#note").val();
	var ip_object_val 				= $("#ip_object_val").val();
	var ip_object_group_val 		= $("#ip_object_group_val").val();
	var dest_object_val 			= $("#dest_object_val").val();
	var dest_object_group_val 	= $("#dest_object_group_val").val();

//	if(note == '') {
//		alert("설명을 입력해 주세요.");
//		return true;
//	}

	if(ip_object_val == '' && ip_object_group_val == '') {
		alert("허용IP 정책을 추가해 주세요.");
		return true;
	}

	if(dest_object_val == '' && dest_object_group_val == '') {
		alert("목적지 정책을 추가해 주세요.");
		return true;
	}
	
	return false;
}

function cancel() {
	location.href = "<c:url value="/policy/streamPolicy/streamPolicyGroupList.lin" />";
}

function check_USE_RadioValue() {
	var radio = document.getElementsByName('useUnused');
	if(radio[0].checked == true) {
		$("#use_yn").val("Y");
	}else if(radio[1].checked == true) {
		$("#use_yn").val("N");
	}	
}

function openIpObject() {
	var ip_object_val = $("#ip_object_val").val();
	var url = "<c:url value="/policy/ipObjectPolicy/ipObjectPop.lin" />?notSeq="+ip_object_val;
	var attibute = "resizable=no,scrollbars=no,width=1024,height=768,top=5,left=5,toolbar=no,resizable=no";
	var popupWindow = window.open(url, "openIpObject", attibute);
	popupWindow.focus();
}

function openIpObjectGroupList() {
	var ip_object_group_val = $("#ip_object_group_val").val();
	var url = "<c:url value="/policy/ipObjectPolicy/ipObjectGroupPop.lin" />?notSeq="+ip_object_group_val;
	var attibute = "resizable=no,scrollbars=no,width=1024,height=768,top=5,left=5,toolbar=no,resizable=no";
	var popupWindow = window.open(url, "openIpObjectGroupList", attibute);
	popupWindow.focus();
}

function openDestObject() {
	var dest_object_val = $("#dest_object_val").val();
	var url = "<c:url value="/policy/destObjectPolicy/destObjectPop.lin" />?notSeq="+dest_object_val;
	var attibute = "resizable=no,scrollbars=no,width=1024,height=768,top=5,left=5,toolbar=no,resizable=no";
	var popupWindow = window.open(url, "openDestObject", attibute);
	popupWindow.focus();
}

function openDestObjectGroup() {
	var dest_object_group_val = $("#dest_object_group_val").val();
	var url = "<c:url value="/policy/destObjectPolicy/destObjectGroupPop.lin" />?notSeq="+dest_object_group_val;
	var attibute = "resizable=no,scrollbars=no,width=1024,height=768,top=5,left=5,toolbar=no,resizable=no";
	var popupWindow = window.open(url, "openDestObjectGroup", attibute);
	popupWindow.focus();
}
</script>
</head>
<body>
<form:form commandName="NameVO" name="dataForm" id="dataForm" ></form:form>
<form id="lform" name="lform" onsubmit="return false;" method="post">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<input id="cud_cd" name="cud_cd" type="hidden" value="${cud_cd}"/>
	<input id="stm_seq" name="stm_seq" type="hidden" value="${stm_seq}"/>
	<input id="use_yn" name="use_yn" type="hidden" value="Y" />
	<input id="isdel_yn" name="isdel_yn" type="hidden" value=""/>
	<input id="ip_object_val" name="ip_object_val" type="hidden" value=""/>
	<input id="ip_object_group_val" name="ip_object_group_val" type="hidden" value=""/>
	<input id="dest_object_val" name="dest_object_val" type="hidden" value=""/>
	<input id="dest_object_group_val" name="dest_object_group_val" type="hidden" value=""/>
	<input id="group_seq" name="group_seq" type="hidden" value="${param.group_seq }" />
	
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
				<h3>정책설정</h3>
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
									<th class="t_left">정책 그룹명</th>
									<td style="padding: 15px;">${streamPolicy.group_name}</td>
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
														<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togChkPol(this, 'chk', 'ipObjectListTable');"/></th>
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
																	title="<c:choose><c:when test="${viewipObjectForm.obj_cd eq '1'}">ANY</c:when><c:when test="${viewipObjectForm.obj_cd eq '2'}">단일</c:when><c:when test="${viewipObjectForm.obj_cd eq '3'}">범위</c:when><c:when test="${viewipObjectForm.obj_cd eq '4'}">대역</c:when></c:choose>">
																	<c:choose>
																		<c:when test="${viewipObjectForm.obj_cd eq '1'}">ANY</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '2'}">단일</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '3'}">범위</c:when>
																		<c:when test="${viewipObjectForm.obj_cd eq '4'}">대역</c:when>
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
								<tr>
									<th class="t_left">허용IP 그룹객체</th>
									<td style="padding: 15px;">
										<!-- <input type="button" id="" name="" value="IP그룹추가" onclick="openIpObjectGroupList();" />  -->
										<button type="button" class="btn_common f_left mg_l5" onclick="openIpObjectGroupList();" style="margin-bottom: 5px; margin-left: -2px;">IP그룹추가</button>
										<button type="button" id="btnRemoveIpGrp" class="btn_common f_left mg_l5" style="display : none;" onclick="delIpObjectGroup()">IP그룹삭제</button>
										<div >
											<table id="ipObjectGroupListTable" summary="연계정책목록" style="table-layout : fixed;border: 1px solid;border-color: #dddddd;display : none;" class="mg_t5">
												<caption>요청자, 제목, 요청시간</caption>
													<thead>
														<tr>
															<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togChkPol(this, 'chk', 'ipObjectGroupListTable');"/></th>
															<th class="Rborder">객체그룹ID</th>
															<th class="Rborder">그룹명</th>
															<th class="Rborder">객체정보</th>
															<th class="Rborder">설명</th>
															<th class="Rborder">사용여부</th>
															<th class="Rborder">생성ID</th>
															<th class="Rborder">생성일시</th>
														</tr>
													</thead>
													<colgroup>
														<col style="width:5%;"/>
														<col style="width:13%;"/>
														<col style="width:13%;" />
														<col style="width:13%;" />
														<col style="width:13%;" />
														<col style="width:13%;" />
														<col style="width:13%;" />
														<col style="width:13%;" />
													</colgroup>
													<tbody>
														<c:if test="${not empty ipObjectGroupList}">
															<c:forEach items="${ipObjectGroupList}" var="ipObjectGroupList" varStatus="c">
																<c:choose>
																	<c:when test="${ipObjectGroupList.del_yn eq 'Y'}">
																		<c:set var="textColorClass">text_color_g</c:set>
																	</c:when>
																	<c:otherwise>
																		<c:set var="textColorClass">text_color_b</c:set>
																	</c:otherwise>
																</c:choose>
																<tr>
																	<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${ipObjectGroupList.seq}" value="${ipObjectGroupList.seq}"/></td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${ipObjectGroupList.obj_group_seq}" />" >
																		<c:out value="${ipObjectGroupList.obj_group_seq}" />
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${ipObjectGroupList.obj_group_nm}" />" >
																		<c:out value="${ipObjectGroupList.obj_group_nm}" />
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${ipObjectGroupList.obj_seq_info}" />" >
																		<c:out value="${ipObjectGroupList.obj_seq_info}" />
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${ipObjectGroupList.note}" />" >
																		<c:out value="${ipObjectGroupList.note}" />
																	</td>
																	<td class="Rborder t_center ${textColorClass}" 
																		title="<c:choose><c:when test="${ipObjectGroupList.del_yn == 'N'}">사용</c:when><c:when test="${ipObjectGroupList.del_yn == 'Y'}">미사용</c:when></c:choose>" >
																		<c:choose>
																			<c:when test="${ipObjectGroupList.del_yn == 'N'}">사용</c:when>
																			<c:when test="${ipObjectGroupList.del_yn == 'Y'}">미사용</c:when>
																		</c:choose>
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${ipObjectGroupList.crt_id}" />" >
																		<c:out value="${ipObjectGroupList.crt_id}" />
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<fmt:formatDate value="${ipObjectGroupList.crt_date}" pattern="yyyy-MM-dd HH:mm" />" >
																		<fmt:formatDate value="${ipObjectGroupList.crt_date}" pattern="yyyy-MM-dd HH:mm" />
																	</td>
																</tr>
															</c:forEach>
														</c:if>
													</tbody>
											</table>										
										</div>
									</td>
								</tr>
								<tr>
									<th class="t_left">목적지객체</th>
									<td style="padding: 15px;">
										<!-- <input type="button" id="" name="" value="목적지객체추가" onclick="openDestObject();" /> -->
										<button type="button" class="btn_common f_left mg_l5" onclick="openDestObject();" style="margin-bottom: 5px; margin-left: -2px;">목적지객체추가</button>
										<button type="button" id="btnRemoveDest" class="btn_common f_left mg_l5" style="display : none;" onclick="delDestObject()">목적지객체삭제</button>
										<div >
											<table id="destObjectListTable" summary="연계정책목록" style="table-layout : fixed;border: 1px solid;border-color: #dddddd;display : none;" class="mg_t5" >
												<caption>요청자, 제목, 요청시간</caption>
												<thead>
													<tr>
														<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togChkPol(this, 'chk', 'destObjectListTable');"/></th>
														<th class="Rborder">객체ID</th>
														<th class="Rborder">객체명</th>
														<th class="Rborder">엔진번호</th>
														<th class="Rborder">망구분</th>
														<th class="Rborder">중계IP</th>
														<th class="Rborder">중계PORT</th>
														<th class="Rborder">목적지IP</th>
														<th class="Rborder">목적지PORT</th>
														<th class="Rborder">프로토콜</th>
														<th class="Rborder">사용여부</th>
														<th class="Rborder">생성일</th>
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
																	<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${destObjectList.seq}" value="${destObjectList.seq}"/></td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.obj_seq}" />" >
																		<c:out value="${destObjectList.obj_seq}" />
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.obj_nm}" />" >
																		<c:out value="${destObjectList.obj_nm}" />
																	</td>
																	<td class="Rborder t_center ${textColorClass}" 
																		title="<c:choose><c:when test="${destObjectList.tunn_idx eq '-1'}">자동할당</c:when><c:otherwise><c:out value="${destObjectList.tunn_idx}" />번 엔진</c:otherwise></c:choose>" >
																		<c:choose>
																			<c:when test="${destObjectList.tunn_idx eq '-1'}">자동할당</c:when>
																			<c:otherwise><c:out value="${destObjectList.tunn_idx}" />번 엔진</c:otherwise>
																		</c:choose>
																	</td>
																	<td class="Rborder t_center ${textColorClass}" 
																		title="<c:choose><c:when test="${destObjectList.io_cd eq 'I'}">보안영역</c:when><c:when test="${destObjectList.io_cd eq 'O'}">비-보안영역</c:when></c:choose>" >
																		<c:choose>
																			<c:when test="${destObjectList.io_cd eq 'I'}">보안영역</c:when>
																			<c:when test="${destObjectList.io_cd eq 'O'}">비-보안영역</c:when>
																		</c:choose>
																	</td>
																	
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.rey_ip}" />" >
																		<c:out value="${destObjectList.rey_ip}" />
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.rey_st_port}" />~<c:out value="${destObjectList.rey_ed_port}" />" >
																		<c:choose>
																			<c:when test="${destObjectList.port_obj_cd eq '1'}"><c:out value="${destObjectList.rey_st_port}" /></c:when>
																			<c:when test="${destObjectList.port_obj_cd eq '2'}"><c:out value="${destObjectList.rey_st_port}" />~<c:out value="${destObjectList.rey_ed_port}" /></c:when>
																		</c:choose>
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.dst_ip}" />" >
																		<c:out value="${destObjectList.dst_ip}" />
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.dst_st_port}" />~<c:out value="${destObjectList.dst_ed_port}" />" >
																		<c:choose>
																			<c:when test="${destObjectList.port_obj_cd eq '1'}"><c:out value="${destObjectList.dst_st_port}" /></c:when>
																			<c:when test="${destObjectList.port_obj_cd eq '2'}"><c:out value="${destObjectList.dst_st_port}" />~<c:out value="${destObjectList.dst_ed_port}" /></c:when>
																		</c:choose>
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.proto_val}" />" >
																		<c:out value="${destObjectList.proto_val}" />
																	</td>
																	<!--  -->
																	<!--  -->
																	<!--  -->
																	<!--  -->
																	<!--  -->
																	<td class="Rborder t_center ${textColorClass}" 
																		title="<c:choose><c:when test="${destObjectList.del_yn eq 'Y'}">미사용</c:when><c:when test="${destObjectList.del_yn eq 'N'}">사용</c:when></c:choose>" >
																		<c:choose>
																			<c:when test="${destObjectList.del_yn eq 'Y'}">미사용</c:when>
																			<c:when test="${destObjectList.del_yn eq 'N'}">사용</c:when>
																		</c:choose>
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<fmt:formatDate value="${destObjectList.crt_date}" pattern="yyyy-MM-dd HH:mm" />" >
																		<fmt:formatDate value="${destObjectList.crt_date}" pattern="yyyy-MM-dd HH:mm" />
																	</td>
																	<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectList.crt_id}" />" >
																		<c:out value="${destObjectList.crt_id}" />
																	</td>
																</tr>
															</c:forEach>
														</c:if>
													</tbody>
											</table>
										</div>
									</td>
								</tr>
								<tr>
									<th class="t_left">목적지객체 그룹</th>
									<td style="padding: 15px;">
										<!-- <input type="button" id="" name="" value="목적지그룹추가" onclick="openDestObjectGroup();" /> -->
										<button type="button" class="btn_common f_left mg_l5" onclick="openDestObjectGroup();" style="margin-bottom: 5px; margin-left: -2px;">목적지그룹추가</button>
										<button type="button" id="btnRemoveDestGrp" class="btn_common f_left mg_l5" style="display : none;" onclick="delDestObjectGroup()">목적지그룹삭제</button>
										<div>
											<table id="destObjectGroupListTable" summary="연계정책목록" style="table-layout : fixed;border: 1px solid;border-color: #dddddd;display : none;" class="mg_t5" >
											<caption>요청자, 제목, 요청시간</caption>
												<thead>
													<tr>
														<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togChkPol(this, 'chk', 'destObjectGroupListTable');"/></th>
														<th class="Rborder">객체그룹ID</th>
														<th class="Rborder">그룹명</th>
														<th class="Rborder">객체정보</th>
														<th class="Rborder">설명</th>
														<th class="Rborder">사용여부</th>
														<th class="Rborder">생성ID</th>
														<th class="Rborder">생성일시</th>
													</tr>
												</thead>
												<colgroup>
													<col style="width:5%;"/>
													<col style="width:13%;"/>
													<col style="width:13%;" />
													<col style="width:13%;" />
													<col style="width:13%;" />
													<col style="width:13%;" />
													<col style="width:13%;" />
													<col style="width:13%;" />
												</colgroup>
												<tbody>
													<c:if test="${not empty destObjectGroupList}">
														<c:forEach items="${destObjectGroupList}" var="destObjectGroupList" varStatus="c">
															<c:choose>
																<c:when test="${destObjectGroupList.del_yn eq 'Y'}">
																	<c:set var="textColorClass">text_color_g</c:set>
																</c:when>
																<c:otherwise>
																	<c:set var="textColorClass">text_color_b</c:set>
																</c:otherwise>
															</c:choose>
															<tr>
																<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${destObjectGroupList.seq}" value="${destObjectGroupList.seq}"/></td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectGroupList.obj_group_seq}" />" >
																	<c:out value="${destObjectGroupList.obj_group_seq}" />
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectGroupList.obj_group_nm}" />" >
																	<c:out value="${destObjectGroupList.obj_group_nm}" />
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectGroupList.obj_seq_info}" />" >
																	<c:out value="${destObjectGroupList.obj_seq_info}" />
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectGroupList.note}" />" >
																	<c:out value="${destObjectGroupList.note}" />
																</td>
																<td class="Rborder t_center ${textColorClass}" 
																	title="<c:choose><c:when test="${destObjectGroupList.del_yn == 'N'}">사용</c:when><c:when test="${destObjectGroupList.del_yn == 'Y'}">미사용</c:when></c:choose>" >
																	<c:choose>
																		<c:when test="${destObjectGroupList.del_yn == 'N'}">사용</c:when>
																		<c:when test="${destObjectGroupList.del_yn == 'Y'}">미사용</c:when>
																	</c:choose>
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<c:out value="${destObjectGroupList.crt_id}" />" >
																	<c:out value="${destObjectGroupList.crt_id}" />
																</td>
																<td class="Rborder t_center ${textColorClass}" title="<fmt:formatDate value="${destObjectGroupList.crt_date}" pattern="yyyy-MM-dd HH:mm" />" >
																	<fmt:formatDate value="${destObjectGroupList.crt_date}" pattern="yyyy-MM-dd HH:mm" />
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
									<th class="t_left">정책 사용여부</th>
									<td style="padding: 15px;">
										<input type="radio" name="useUnused" id="use" ${streamPolicy.use_yn eq 'Y' ? ' checked' : ''} value="Y" onclick="check_USE_RadioValue()"/>
										<label for="use" class="mg_r30">사용</label>
											<input type="radio" name="useUnused" id="unused" ${streamPolicy.use_yn eq 'N' ? ' checked' : ''} value="N" onclick="check_USE_RadioValue()" /> 
											<label for="unused">미사용</label>
									</td>
								</tr> 
								<tr>
									<th class="t_left">설명</th>
									<td style="padding: 15px;">
										<input type="text" class="text_input" id="note" name="note"  value="${streamPolicy.note}" onkeyup="onlySizeFillter(this,100)" size="100" />
									</td>
								</tr>-->
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