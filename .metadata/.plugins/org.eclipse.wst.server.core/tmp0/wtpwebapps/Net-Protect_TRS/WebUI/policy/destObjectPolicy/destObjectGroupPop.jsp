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
	
	$('#reset').click(function() {
		var dest_object_group_val = $("#dest_object_group_val", opener.document).val();
		location.href = "<c:url value="/policy/destObjectPolicy/destObjectGroupPop.lin" />?notSeq="+dest_object_group_val;
	});

	$("#addParent").click(function(){	//부모창으로 객체 전송
		var values='';
		
		var chks = new Array();
        var bool = false;
		$('.mg_t5 tbody tr').each(function(idx){
			bool = false;
			if($(this).children("td").eq(0).children().is(":checked")) {
				chks.push($(this));
			}			
		});
		window.opener.addDestObjectsGroup(chks);
		if(chks.length > 0) {
			window.close();
		}
	});
	
});

function search() {
	if(isVaildCheckNetPolicy()) {
		return false;
	}
	
	$("#notSeq").val($("#dest_object_group_val", opener.document).val());
	$("#lform").get(0).submit();
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
<input id="notSeq" name="notSeq" type="hidden" value = ""/>
	<!-- contents -->
	<div id="mask2"></div>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="/Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=100 height=100 />
	</div>
	<div>
		<!-- <div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold"></h2>
				<p class="breadCrumbs">목적지객체 그룹관리</p>
			</div>
		</div>  -->
			<div class="conWrap">
				<h3>검색조건</h3>
				<div class="conBox">
					<div class="topCon nBorder"  >
						<table summary="정책 검색조건" style="table-layout : fixed" >
						<caption>객체그룹ID, 그룹명, 객체정보, 설명, 사용여부, 생성ID, 생성일시</caption>
							<colgroup>
								<col style="width:10%;"/>
								<col style="width:19%;" />
								<col style="width:10%;" />
								<col style="width:19%;" />
								<col style="width:10%;"/>
								<col style="width:19%;" />
								<col style="width:13%;" />
							</colgroup>
							<tbody>
								<tr style="border-bottom: solid 1px #ddd;">
									<th class="Rborder Lborder t_center">그룹명</th>
									<td class="Rborder Lborder t_center">
										<input type="text" class="text_input" id="obj_group_nm" name="obj_group_nm" placeholder="그룹명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${destObjectGroupForm.obj_group_nm}"/>
									</td>
									<!-- <th class="Rborder Lborder t_center">사용여부</th>
									<td class="Rborder Lborder t_center">
										<select id="del_yn" name="del_yn" style="width:150px;">
											<option value="" selected="selected">선택</option>
											<option value="N" <c:if test='${destObjectGroupForm.del_yn == "N" }'>selected="selected"</c:if>>사용</option>
											<option value="Y" <c:if test='${destObjectGroupForm.del_yn == "Y" }'>selected="selected"</c:if>>미사용</option>
										</select>
									</td> -->
									<th class="Rborder Lborder t_center">설명</th>
									<td colspan="3" class="Rborder Lborder t_center" >
										<input type="text" class="text_input" id="note" name="note" placeholder="설명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${destObjectGroupForm.note}"/>
									</td>
									<td rowspan="2" class="t_center Lborder">
										<button type="button" class="btn_common theme mg_r5"  id="reset" >초기화</button>
										<button type="button" class="btn_common theme" onclick="search()">조회</button>
									</td>
								</tr>
								<tr>
									<th class="Rborder Lborder t_center">생성일</th>
									<td colspan="5">
										<span class="search_day">
											<input type="text" name="startDay" id="startDay" value="${destObjectGroupForm.startDay}" readonly="readonly" class="text_input t_center" style="width: 100px;" />
											<img class="img_ico" onclick="showCalendar('lform', 'startDay', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">
										</span>
										&#126;
										<span class="search_day">
											<input type="text" name="endDay" id="endDay" value="${destObjectGroupForm.endDay}" readonly="readonly" class="text_input short t_center" style="width: 100px;" />
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
							<button type="button" class="btn_common f_left mg_l5" id="addParent">추가</button>
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
											<c:choose>
												<c:when test="${destObjectGroupList.isdel_yn eq 'N'}">
													<td class="td_chekbox Rborder t_center"></td>
												</c:when>
												<c:otherwise>
													<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${destObjectGroupList.seq}" value="${destObjectGroupList.seq}"/></td>
												</c:otherwise>
											</c:choose>
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
