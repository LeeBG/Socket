<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<style>
	*.dis[disabled] {color: #c3bebe; border-color: #dcd6d6;}
</style>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />

<script type="text/javascript">

$(document).ready(function() {
	$('#reset').click(function() {
		location.href = '<c:url value="/policy/streamPolicy/streamPolicyGroupList.lin" />';
	});

	closeloading();
});

function search() {	
	$("#lform").get(0).submit();
}

function view(group_seq, cud_cd, use_yn) {
//	if(use_yn == "N") {
//		return;
//	}
	$("#group_seq").val(group_seq);
	$("#cud_cd").val(cud_cd);

	var form = document.lform;
	form.action = "<c:url value="/policy/streamPolicy/streamPolicyList.lin" />";
	form.submit();
}


function mod(group_seq, cud_cd, pol_seq) {
	$("#group_seq").val(group_seq);
	$("#cud_cd").val(cud_cd);
	$("#pol_seq").val(pol_seq);
	
	var form = document.lform;
	form.action = "<c:url value="/policy/streamPolicy/streamPolicyGroupView.lin" />";
	form.submit();
}

function mod_pol(group_seq, cud_cd, stm_seq) {
	$("#group_seq").val(group_seq);
	$("#cud_cd").val(cud_cd);

	var form = document.lform;
	form.action = "<c:url value="/policy/streamPolicy/streamPolicyView.lin" />";
	form.submit();
}

function checkDelete() {
	if (!$(":checkbox[name=chk]").is(":checked")) {
		alert("삭제 할 항목을 선택하세요.");
		return;
	}

	if (confirm("선택 목록을 삭제하겠습니까?")) {
		var requestURL = "<c:url value="/policy/streamPolicy/deleteStreamPolicyGroup.lin" />";
		var successURL = "<c:url value="/policy/streamPolicy/streamPolicyGroupList.lin" />";			
		
		loading();
		resultCheckFunc($("#lform"), requestURL, function(response){
			closeloading();
			var code = response['code'];
			var message = response['message'];
			
			if(code == "200") {
				alert("정책그룹이 삭제되었습니다.");
				$(location).attr("href", successURL);
			}else if(code == "501") {
				alert(message);
				$(location).attr("href", successURL);
			}else {
				alert("그룹 삭제 중 에러가 발생되었습니다.");
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
<input type="hidden" id="page" name="page" value="" />
<input type="hidden" id="group_seq" name="group_seq" value="0" />
<input type="hidden" id="cud_cd" name="cud_cd" value="" />
<input type="hidden" id="pol_seq" name="pol_seq" value="" />
	<div id="mask2"></div>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="/Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=100 height=100 />
	</div>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">연계 정책관리</h2>
				<p class="breadCrumbs">정책관리 > 연계 정책관리</p>
			</div>
		</div>
			<div class="conWrap">
				<h3>검색조건</h3>
				<div class="conBox">
					<div class="topCon nBorder"  >
						<table summary="정책 검색조건" style="">
						<caption>정책ID, 정책명, 프로토콜, 연계IP, 연계PORT, 목적지IP, 목적지PORT</caption>
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
									<td class="Rborder Lborder t_center" ><input type="text" class="text_input" id="title" name="title" placeholder="그룹명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${streamPolicyGroupForm.title}"/></td>
									<th class="Rborder Lborder t_center">사용여부</th>
									<td class="Rborder Lborder t_center">
										<select id="use_yn" name="use_yn" style="width: 150px;">
											<option value="" selected="selected">선택</option>
											<option value="Y" <c:if test='${streamPolicyGroupForm.use_yn == "Y" }'>selected="selected"</c:if>>사용</option>
											<option value="N" <c:if test='${streamPolicyGroupForm.use_yn == "N" }'>selected="selected"</c:if>>미사용</option>
										</select>
									</td>
									<th class="Rborder Lborder t_center">설명</th>
									<td class="Rborder Lborder t_center" ><input type="text" class="text_input" id="note" name="note" placeholder="설명을 입력해 주세요." onkeyup="onlySizeFillter(this,100)" value="${streamPolicyGroupForm.note}"/></td>
									<td rowspan="2" class="t_center Lborder">
										<button type="button" class="btn_common theme mg_r5" id="reset">초기화</button>
										<button type="button" class="btn_common theme" onclick="search()">조회</button>
									</td>
								</tr>
								<tr>
									<th class="Rborder Lborder t_center">서버 ID</th>
									<td colspan="4">
										<select style="width: 150px" title="서버 ID" id="stm_seq" name="stm_seq">
											<option value="" selected="selected">선택</option>
											<c:if test="${not empty stmInfoFormList}">
												<c:forEach items="${stmInfoFormList}" var="stmInfoForm">
													<c:choose>
														<c:when test="${stmInfoForm.stm_seq eq streamPolicyGroupForm.stm_seq}">
															<option value='${stmInfoForm.stm_seq}' selected='selected'>${stmInfoForm.stm_seq}</option>
														</c:when>
														<c:otherwise>
															<option value='${stmInfoForm.stm_seq}' >${stmInfoForm.stm_seq}</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</c:if>
										</select>
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
							<button type="button" class="btn_common f_right mg_r5" onclick="mod(0,'${CUD_CD_C}')">그룹 추가</button>
						</div>
						<table summary="연계정책목록" style="table-layout : fixed" class="mg_t5">
						<caption>요청자, 제목, 요청시간</caption>
							<thead>
								<tr>
									<th class="Rborder"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk');"/></th>
									<th class="Rborder">그룹명</th>
									<th class="Rborder">서버ID</th>
									<th class="Rborder">설명</th>
									<th class="Rborder">생성일</th>
									<th class="Rborder">생성자</th>
									<th class="Rborder">정책설정</th>
									<th class="Rborder">그룹수정</th>
								</tr>
							</thead>
							<colgroup>
								<col style="width:5%;" />
								<col style="width:20%;" />
								<col style="width:10%;" />
								<col style="width:25%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
								<col style="width:10%;" />
							</colgroup>
							<tbody>
								<c:if test="${not empty streamPolicyGroupList}">
									<c:forEach items="${streamPolicyGroupList}" var="viewStreamPolicyGroupForm" varStatus="c">
										<c:choose>
											<c:when test="${viewStreamPolicyGroupForm.use_yn eq 'Y'}">
												<c:set var="textColorClass">text_color_b</c:set>
											</c:when>
											<c:otherwise>
												<c:set var="textColorClass">text_color_g</c:set>
											</c:otherwise>
										</c:choose>
									<tr>
										 <c:choose>
											<c:when test="${viewStreamPolicyGroupForm.isdel_yn eq 'N'}">
												<td class="td_chekbox Rborder t_center"></td>
											</c:when>
											<c:otherwise>
												<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" name="chk" id="chk_${viewStreamPolicyGroupForm.seq}" value="${viewStreamPolicyGroupForm.seq}"/></td>
											</c:otherwise>
										</c:choose> 
										<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewStreamPolicyGroupForm.title}" />" 
												onclick="view('${viewStreamPolicyGroupForm.seq}', '${CUD_CD_U}', '${viewStreamPolicyGroupForm.use_yn}')">
											<c:out value="${viewStreamPolicyGroupForm.title}" />
										</td>
										<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewStreamPolicyGroupForm.stm_seq}" />" 
												onclick="view('${viewStreamPolicyGroupForm.seq}', '${CUD_CD_U}', '${viewStreamPolicyGroupForm.use_yn}')">
											<c:out value="${viewStreamPolicyGroupForm.stm_seq}" />
										</td>
										<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewStreamPolicyGroupForm.note}" />" 
												onclick="view('${viewStreamPolicyGroupForm.seq}', '${CUD_CD_U}', '${viewStreamPolicyGroupForm.use_yn}')">
											<c:out value="${viewStreamPolicyGroupForm.note}" />
										</td>
										<td class="Rborder t_center ${textColorClass}" title="<fmt:formatDate value="${viewStreamPolicyGroupForm.crt_date}" pattern="yyyy-MM-dd HH:mm" />" 
												onclick="view('${viewStreamPolicyGroupForm.seq}', '${CUD_CD_U}', '${viewStreamPolicyGroupForm.use_yn}')">
											<fmt:formatDate value="${viewStreamPolicyGroupForm.crt_date}" pattern="yyyy-MM-dd HH:mm" />
										</td>
										<td class="Rborder t_center ${textColorClass}" title="<c:out value="${viewStreamPolicyGroupForm.crt_id}" />" 
												onclick="view('${viewStreamPolicyGroupForm.seq}', '${CUD_CD_U}', '${viewStreamPolicyGroupForm.use_yn}')">
											<c:out value="${viewStreamPolicyGroupForm.crt_id}" />
										</td>
										<td class="Rborder t_center ${textColorClass}" >
											<button type="button" class="btn_common f_center dis"  <c:if test="${viewStreamPolicyGroupForm.use_yn == 'N'}">disabled="disabled"</c:if>
											onclick="mod_pol('${viewStreamPolicyGroupForm.seq}', '${CUD_CD_U}', '${viewStreamPolicyGroupForm.stm_seq}')" >설정</button>
										</td>
										<td class="Rborder t_center ${textColorClass}">
											<button type="button" class="btn_common f_center" onclick="mod('${viewStreamPolicyGroupForm.seq}', '${CUD_CD_U}', '${viewStreamPolicyGroupForm.pol_seq}')" >수정</button>
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
