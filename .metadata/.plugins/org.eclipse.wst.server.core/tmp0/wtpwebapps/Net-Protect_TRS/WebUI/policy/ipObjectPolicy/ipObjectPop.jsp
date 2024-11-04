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
	checkFocusMessage($("#lform").find("input[name='src_st_ip']"),"0.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	checkFocusMessage($("#lform").find("input[name='src_ed_ip']"),"0.0.0.0 ~ 255.255.255.255 까지 입력가능합니다.");
	
	$("#reset").click(function() {
		var ip_object_val = $("#ip_object_val", opener.document).val();
		location.href = "<c:url value="/policy/ipObjectPolicy/ipObjectPop.lin" />?notSeq="+ip_object_val;
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
		window.opener.addIpObjects(chks);
		if(chks.length > 0) {
			window.close();
		}
	});

});


function search() {

	if(isVaildCheckNetPolicy()){
		return false;
	}
	
	$("#notSeq").val($("#ip_object_val", opener.document).val());

	$("#lform").get(0).submit();
}


function view(seq, cud_cd) {
	$("#seq").val(seq);
	$("#cud_cd").val(cud_cd);

	var form = document.lform;
	form.action = "<c:url value="/policy/ipObjectPolicy/ipObjectView.lin" />";
	form.submit();
}

function isVaildCheckNetPolicy() {
	var src_st_ip = $("#src_st_ip").val();
	var src_ed_ip = $("#src_ed_ip").val();
	var startDay = $("#startDay").val();
	var endDay = $("#endDay").val();

	if (!empty(src_st_ip)) {
		if(!isValidIP(src_st_ip)) {
			alert("시작IP가 올바르지 않습니다.");
			return true;
		}
	}
	if (!empty(src_ed_ip)) {
		if(!isValidIP(src_ed_ip)) {
			alert("종료IP가 올바르지 않습니다.");
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

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action='<c:url value="/policy/ipObjectPolicy/ipObjectPop.lin" />' >
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden"/>
<input id="seq" name="seq" type="hidden" value = ""/>
<input id="cud_cd" name="cud_cd" type="hidden" value = ""/>
<input id="notSeq" name="notSeq" type="hidden" value = ""/>

	<!-- contents -->
	<div id="mask2"></div>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="/Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=100 height=100 />
	</div>
	<br />
	<div>
		<!-- <div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold"></h2>
				<p class="breadCrumbs">&nbsp;&nbsp;&nbsp;IP객체관리</p>
			</div>
		</div> -->
			<div class="conWrap">
				<h3>검색조건</h3>
				<div class="conBox">
					<div class="topCon nBorder"  >
						<table summary="정책 검색조건" style="table-layout : fixed" >
						<caption>객체ID, 객체명, 객체IP정보S, 객체IP정보E, 객체구분, 삭제여부, 생성일, 생성자, 수정일, 수정자</caption>
							<colgroup>
								<col style="width:10%;"/>
								<col style="width:18%;" />
								<col style="width:10%;" />
								<col style="width:18%;" />
								<col style="width:10%;"/>
								<col style="width:18%;" />
								<col style="width:16%;" />
							</colgroup>
							<tbody>
								<tr style="border-bottom: solid 1px #ddd;">
									<th class="Rborder Lborder t_center">객체명</th>
									<td class="Rborder Lborder t_center">
										<input type="text" class="text_input" id="obj_nm" name="obj_nm" placeholder="객체명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${ipObjectForm.obj_nm}"/>
									</td>
									<th class="Rborder Lborder t_center">객체구분</th>
									<td class="Rborder Lborder t_center">
										<select id="obj_cd" name="obj_cd" style="width: 150px;">
											<option value="" selected="selected">선택</option>
											<option value="1" <c:if test='${ipObjectForm.obj_cd == 1 }'>selected="selected"</c:if>>ANY</option>
											<option value="2" <c:if test='${ipObjectForm.obj_cd == 2 }'>selected="selected"</c:if>>단일</option>
											<option value="3" <c:if test='${ipObjectForm.obj_cd == 3 }'>selected="selected"</c:if>>대역</option>
											<option value="4" <c:if test='${ipObjectForm.obj_cd == 4 }'>selected="selected"</c:if>>범위</option>
										</select>
									</td>
									<!-- <th class="Rborder Lborder t_center">사용여부</th>
									<td class="Rborder Lborder t_center" >
										<select id="del_yn" name="del_yn" style="width: 150px;">
											<option value="" selected="selected">선택</option>
											<option value="N" <c:if test='${ipObjectForm.del_yn == "N" }'>selected="selected"</c:if>>사용</option>
											<option value="Y" <c:if test='${ipObjectForm.del_yn == "Y" }'>selected="selected"</c:if>>미사용</option>
										</select>
									</td> -->
									<th class="Rborder Lborder t_center">시작IP</th>
									<td class="Rborder Lborder t_center">
										<input type="text" class="text_input" id="src_st_ip" name="src_st_ip" placeholder="xxx.xxx.xxx.xxx" onkeyup="onlySizeFillter(this,15)" value="${ipObjectForm.src_st_ip}" style="width: 150px;"/>
									</td>
									<td rowspan="2" class="t_center Lborder">
										<button type="button" class="btn_common theme mg_r5"  id="reset" >초기화</button>
										<button type="button" class="btn_common theme" onclick="search()">조회</button>
									</td>
								</tr>
								<tr style="border-bottom: solid 1px #ddd;">									
									<th class="Rborder Lborder t_center">종료IP</th>
									<td class="Rborder Lborder t_center">
										<input type="text" class="text_input" id="src_ed_ip" name="src_ed_ip" placeholder="xxx.xxx.xxx.xxx" onkeyup="onlySizeFillter(this,15)" value="${ipObjectForm.src_ed_ip}" style="width: 150px;"/>
									</td>
									<th class="Rborder Lborder t_center">생성일</th>
									<td colspan="3">
										<span class="search_day">
											<input type="text" name="startDay" id="startDay" value="${ipObjectForm.startDay}" readonly="readonly" class="text_input t_center" style="width: 100px;" />
											<img class="img_ico" onclick="showCalendar('lform', 'startDay', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">
										</span>
										&#126;
										<span class="search_day">
											<input type="text" name="endDay" id="endDay" readOnly="" value="${ipObjectForm.endDay}" readonly="readonly" class="text_input short t_center" style="width: 100px;" />
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
									<!-- <th class="Rborder">수정일</th>
									<th class="Rborder">수정자</th> -->
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
								<%-- <col style="width:10%;" />
								<col style="width:10%;" /> --%>
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
							<tfoot>
								<tr>
									<td colspan="11" class="td_last">
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
