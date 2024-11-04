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
	checkFocusMessage($("#lform").find("input[name='obj_group_nm']"),"최대 100자까지 가능합니다.");
	checkFocusMessage($("#lform").find("input[name='note']"),"최대 100자까지 가능합니다.");
	
	$('#reset').click(function(){
		location.href = '<c:url value="/policy/ipObjectPolicy/ipObjectGroupList.lin" />';
	});
});

function search() {
	if(isVaildCheckNetPolicy()) {
		return false;
	}
	
	$("#lform").get(0).submit();
}

function view(seq, cud_cd) {
	$("#seq").val(seq);
	$("#cud_cd").val(cud_cd);

	var form = document.lform;
	form.action = "<c:url value="/policy/ipObjectPolicy/ipObjectGroupView.lin" />";
	form.submit();
}

function checkDelete() {
	if (!$(":checkbox[name=chk]").is(":checked")) {
		alert("삭제 할 항목을 선택하세요.");
		return;
	}

	if (confirm("선택 목록을 삭제하겠습니까?")) {
		var requestURL = "<c:url value="/policy/ipObjectPolicy/deleteIpObjectGroup.lin" />";
		var successURL = "<c:url value="/policy/ipObjectPolicy/ipObjectGroupList.lin" />";
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

function isVaildCheckNetPolicy() {
	var startDay = $("#startDay").val();
	var endDay = $("#endDay").val();

	startDay = startDay.replaceAll("-", "");
	endDay = endDay.replaceAll("-", "");
	if(startDay > endDay) {
		alert("시작 날짜("+$("#startDay").val()+")는 종료 날짜("+$("#endDay").val()+")보다 작아야 합니다.");
		return true;
	}

	return false;
}

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden" />
<input id="seq" name="seq" type="hidden" value="" />
<input id="cud_cd" name="cud_cd" type="hidden" value="" />
	<!-- contents -->
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
				<h3>검색조건</h3>
				<div class="conBox">
					<div class="topCon nBorder"  >
						<table summary="정책 검색조건" style="table-layout : fixed" >
						<caption>객체그룹ID, 그룹명, 객체정보, 설명, 사용여부, 생성ID, 생성일시</caption>
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
									<th class="Rborder Lborder t_center">그룹명</th>
									<td class="Rborder Lborder t_center">
										<input type="text" class="text_input" id="obj_group_nm" name="obj_group_nm" placeholder="그룹명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${ipObjectGroupForm.obj_group_nm}"/>
									</td>
									<th class="Rborder Lborder t_center">사용여부</th>
									<td class="Rborder Lborder t_center">
										<select id="del_yn" name="del_yn" style="width: 150px;">
											<option value="" selected="selected">선택</option>
											<option value="N" <c:if test='${ipObjectGroupForm.del_yn == "N" }'>selected="selected"</c:if>>사용</option>
											<option value="Y" <c:if test='${ipObjectGroupForm.del_yn == "Y" }'>selected="selected"</c:if>>미사용</option>
										</select>
									</td>
									<th class="Rborder Lborder t_center">설명</th>
									<td class="Rborder Lborder t_center" >
										<input type="text" class="text_input" id="note" name="note" placeholder="설명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${ipObjectGroupForm.note}"/>
									</td>
									<td rowspan="2" class="t_center Lborder">
										<button type="button" class="btn_common theme mg_r5"  id="reset" >초기화</button>
										<button type="button" class="btn_common theme" onclick="search()">조회</button>
									</td>
								</tr>
								<tr>
									<th class="Rborder Lborder t_center">생성일</th>
									<td colspan="4">
										<span class="search_day">
											<input type="text" name="startDay" id="startDay" value="${ipObjectGroupForm.startDay}" readonly="readonly" class="text_input t_center" style="width: 100px;" />
											<img class="img_ico" onclick="showCalendar('lform', 'startDay', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">
										</span>
										&#126;
										<span class="search_day">
											<input type="text" name="endDay" id="endDay" value="${ipObjectGroupForm.endDay}" readonly="readonly" class="text_input short t_center" style="width: 100px;" />
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
							<button type="button" class="btn_common f_right mg_r5" onclick="view(0,'${CUD_CD_C}')">그룹 추가</button>
						</div>
						<table summary="연계정책목록" style="table-layout : fixed" class="mg_t5">
						<caption>요청자, 제목, 요청시간</caption>
							<thead>
								<tr>
									<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
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
											<c:choose>
												<c:when test="${ipObjectGroupList.isdel_yn eq 'N'}">
													<td class="td_chekbox Rborder t_center"></td>
												</c:when>
												<c:otherwise>
													<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${ipObjectGroupList.seq}" value="${ipObjectGroupList.seq}"/></td>
												</c:otherwise>
											</c:choose>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${ipObjectGroupList.obj_group_seq}" />" onclick="view('${ipObjectGroupList.seq}', '${CUD_CD_U}')">
												<c:out value="${ipObjectGroupList.obj_group_seq}" />
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${ipObjectGroupList.obj_group_nm}" />" onclick="view('${ipObjectGroupList.seq}', '${CUD_CD_U}')">
												<c:out value="${ipObjectGroupList.obj_group_nm}" />
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${ipObjectGroupList.obj_seq_info}" />" onclick="view('${ipObjectGroupList.seq}', '${CUD_CD_U}')">
												<c:out value="${ipObjectGroupList.obj_seq_info}" />
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${ipObjectGroupList.note}" />" onclick="view('${ipObjectGroupList.seq}', '${CUD_CD_U}')">
												<c:out value="${ipObjectGroupList.note}" />
											</td>
											<td class="Rborder t_center ${textColorClass}" 
												title="<c:choose><c:when test="${ipObjectGroupList.del_yn == 'N'}">사용</c:when><c:when test="${ipObjectGroupList.del_yn == 'Y'}">미사용</c:when></c:choose>" onclick="view('${ipObjectGroupList.seq}', '${CUD_CD_U}')">
												<c:choose>
													<c:when test="${ipObjectGroupList.del_yn == 'N'}">사용</c:when>
													<c:when test="${ipObjectGroupList.del_yn == 'Y'}">미사용</c:when>
												</c:choose>
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<c:out value="${ipObjectGroupList.crt_id}" />" onclick="view('${ipObjectGroupList.seq}', '${CUD_CD_U}')">
												<c:out value="${ipObjectGroupList.crt_id}" />
											</td>
											<td class="Rborder t_center ${textColorClass}" title="<fmt:formatDate value="${ipObjectGroupList.crt_date}" pattern="yyyy-MM-dd HH:mm" />" 
													onclick="view('${ipObjectGroupList.seq}', '${CUD_CD_U}')">
												<fmt:formatDate value="${ipObjectGroupList.crt_date}" pattern="yyyy-MM-dd HH:mm" />
											</td>
										</tr>
									</c:forEach>
								</c:if>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="8" class="td_last">
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
