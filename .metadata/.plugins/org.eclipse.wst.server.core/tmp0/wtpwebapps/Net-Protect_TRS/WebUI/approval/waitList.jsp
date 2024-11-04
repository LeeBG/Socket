<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="getSiteCode" value="${customfunc:getSiteCode()}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<html>
<head>
<script type="text/javascript">
	bindEventOnSearchDateInput(true);

	function read(approval_seq, data_seq, np_cd) {
		var url = "<c:url value="/approval/approvalView.lin" />?approval_seq=" + approval_seq + "&data_seq=" + data_seq +"&view_type=W" + "&np_cd=" + np_cd;
		var attibute = "resizable=no,scrollbars=yes,width=800,height=750,top=5,left=5,toolbar=no,resizable=no";
		var popupWindow = window.open(url, "lincubeApprovalView", attibute);
		popupWindow.focus();
	}

	function approvalListRefresh(){
		$("#lform").get(0).submit();
	}

	function search() {
		if( ! isValidDateValue() )
			return; 

		$("#searchValue").val($("#searchValueInput").val());
		$("#searchField").val($("select[name=selectSearchField]").val());
		$("#searchPosition").val($("select[name=selectNetworkPosition]").val());

		$("#page").val("1");
		
		$("#lform").get(0).submit();
	}
	
	function allAllowApproval(){
		var errmsg = new cls_errmsg();

		if (!$(":checkbox[name=chk]").is(":checked")) {
			errmsg.append(null, "<spring:message code="approval.waitList.script.allAllow.Approval" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		var cnt = 0;
		$(":checkbox[name=chk]").each(function() {
			if($(this).is(":checked")){
				cnt++;
			}
		});
		
		var ACMessage = "";
		var CompMessage = "";
		<c:if test="${getSiteCode eq 'mcst' || getSiteCode eq 'museum' || getSiteCode eq 'sejong_nl' || getSiteCode eq 'nl'}">
		CompMessage = "(확인)";
		ACMessage = "\n승인이 불가한 항목은 확인 또는 반려 처리 됩니다.";
		</c:if>
		if( confirm(cnt + " 건에 대한 일괄승인" + CompMessage + "을 처리 하시겠습니까?" + ACMessage) ) {
			var requestURL = "<c:url value="/approval/approvalUpdateAllAllow.lin" />";
			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				var resultMessage = response['message'];
				$("#searchValue").val($("#searchValueInput").val());
				$("#searchField").val($("select[name=selectSearchField]").val());
				$("#lform").get(0).submit();
				alert( code == '500' ? resultMessage : cnt + " 건에 대한 "+resultMessage);
			});
		}
	}
	
	function goLastPage(){ 
		var curPage = Number($("#page").val()); 
		if(curPage > 1){ 
			$("#page").val((curPage)-1); 
			$("#lform").get(0).submit(); 
		} 
	} 
	
	function allAllowReject() {
		var errmsg = new cls_errmsg();

		if (!$(":checkbox[name=chk]").is(":checked")) {
			errmsg.append(null, "반려할 자료를 선택해주세요.");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		var cnt = 0;
		$(":checkbox[name=chk]").each(function() {
			if($(this).is(":checked")){
				cnt++;
			}
		});
		
		if( confirm(cnt + " 건에 대한 일괄반려 처리 하시겠습니까?") ) {
			
			var requestURL = "<c:url value="/approval/approvalUpdateAllReject.lin" />";
			resultCheckFunc($("#lform"), requestURL, function(response) {
				var resultMessage = response['message'];
				$("#searchValue").val($("#searchValueInput").val());
				$("#searchField").val($("select[name=selectSearchField]").val());
				$("#lform").get(0).submit();
				alert(cnt + " 건에 대한 "+resultMessage);
			});
		}
	}
	
	
	$(document).ready(function() {
		setDateInputDivPosition();
		checkFocusMessage($("#searchValueInput"),"최대 100자까지 가능합니다.");
		
		<c:if test="${empty approvalList}"> 
		goLastPage(); 
		</c:if>
	});
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/approval/waitList.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="app_type" name="app_type" value="${approvalForm.app_type}" />
<input type="hidden" id="page" name="page" value="${approvalForm.currentPage}"/>
<input type="hidden" id="searchValue" name="searchValue" value="${approvalForm.searchValue}"/>
<input type="hidden" id="searchField" name="searchField"  value="${approvalForm.searchField}" />
<input id="searchPosition" name="searchPosition" type="hidden" value="${approvalForm.searchPosition}"/>
<div class="rightArea">
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold">결재 대기함</h2>
			<p class="breadCrumbs">결재관리 > 결재 대기함</p>
		</div>
	</div>
<div class="conWrap">
	<h3>검색조건</h3>
	<div class="conBox searchBox t_center">
		<div class="topCon nBorder">
			<table summary="정책 검색조건" style="table-layout : fixed" >
			<caption>검색조건, 버튼</caption>
				<colgroup>
				</colgroup>
				<tbody>
					<tr>
						<td class="t_center">
							<jsp:include page="/WebUI/include/date_input_advanced.jsp">
								<jsp:param name="t_day" value="${today}"/>
								<jsp:param name="s_day" value="${approvalForm.startDay}"/>
								<jsp:param name="e_day" value="${approvalForm.endDay}"/>
								<jsp:param name="period" value="${period}"/>
							</jsp:include>
							<c:if test="${oppsiteApprovalOption ne 'N'}">
								<select title="목록 검색조건" class="mg_minor_r20 mg_l20" id="selectNetworkPosition" name="selectNetworkPosition">
									<option value="B" <c:if test="${approvalForm.searchPosition eq 'B' }">selected="selected"</c:if>>전체영역</option>
									<option value="I" <c:if test="${approvalForm.searchPosition eq 'I' }">selected="selected"</c:if>>${INNER} -> ${OUTER}</option>
									<option value="O" <c:if test="${approvalForm.searchPosition eq 'O' }">selected="selected"</c:if>>${OUTER} -> ${INNER}</option>
								</select>
							</c:if>
							<select id="selectSearchField" class="mg_l20" name="selectSearchField" title="목록 검색조건">
								<option <c:if test="${approvalForm.searchField eq 'title'}">selected="selected"</c:if> value="title">제목</option>
								<option <c:if test="${approvalForm.searchField eq 'users_nm'}">selected="selected"</c:if> value="users_nm">요청자</option>
							</select>
							<input id="searchValueInput" name="searchValueInput" type="text" class="text_input long" style="max-width:70%;" placeholder="검색어를 입력해주세요." value="${approvalForm.searchValue}" onkeyup="onlySizeFillter(this,100)" onkeydown="return keyDownEnterDoSearch();"/>
							<button class="btn_common theme" onClick="search()">검색</button>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="conWrap tableBox">
	<h3>목록</h3>
	<div class="conBox">
		<div class="table_area_style01 hoverTable">
			<c:if test="${isAllAllowApproval eq 'Y' || isAllRejectApproval eq 'Y'}">
				<div class="table_area_topCon mg_t10 mg_b5">
					<c:if test="${isAllAllowApproval eq 'Y'}">
						<button type="button" class="btn_common mg_l5" onclick="allAllowApproval();" >승인</button>
					</c:if>
					<c:if test="${isAllRejectApproval eq 'Y'}">
						<button type="button" class="btn_common mg_l5" onclick="allAllowReject();" >반려</button>
					</c:if>
				</div>
			</c:if>
			<table summary="결재관리 테이블입니다." style="table-layout : fixed">
			<caption>일괄승인체크,결재요청자,결재제목,파일,결재요청시각</caption>
				<colgroup>
					<c:if test="${isAllAllowApproval eq 'Y' || isAllRejectApproval eq 'Y'}">
						<col style="width:5%;" />	<!-- 일괄승인체크 -->
					</c:if>
					<col style="width:7%;" />	<!-- 결재상태 -->
					<c:if test="${oppsiteApprovalOption ne 'N'}">
						<col style="width:7%;" />	<!-- 결재요청영역 -->
					</c:if>
					<col style="width:12%;" />	<!-- 요청자 -->
					<col style="width:39%;" />	<!-- 결재제목 -->
					<col style="width:14%;" />	<!-- 전송파일요약 -->
					<col style="width:14%;" />	<!-- 결재요청시각 -->
				</colgroup>
				<thead>
					<tr>
						<c:if test="${isAllAllowApproval eq 'Y' || isAllRejectApproval eq 'Y'}">
						<th class="right_line"><input type="checkbox" class="input_chk" id="allChk" name="allChk" onclick="togchk(this, 'chk');"/></th>
						</c:if>
						<th class="right_line"><spring:message code="common.approval.status"/></th>
						<c:if test="${oppsiteApprovalOption ne 'N'}">
							<th class="right_line">결재요청영역</th>
						</c:if>
						<th class="right_line">요청자</th>
						<th class="right_line">제목</th>
						<th class="right_line">파일</th>
						<th class="right_line">요청시각</th>
					</tr>
				</thead>
				<tbody>
				<c:choose>
					<c:when test="${(isAllAllowApproval eq 'Y' || isAllRejectApproval eq 'Y') && oppsiteApprovalOption ne 'N'}">
						<c:set var="colspan" value="7" />
					</c:when>
					<c:when test="${isAllAllowApproval eq 'Y' || isAllRejectApproval eq 'Y' || oppsiteApprovalOption ne 'N'}">
						<c:set var="colspan" value="6" />
					</c:when>
					<c:otherwise>
						<c:set var="colspan" value="5" />
					</c:otherwise>
				</c:choose>
				<c:choose>
				<c:when test="${empty approvalList}">
					<tr>
						<td class="t_center" colspan="${colspan}"><div class="no_result"><spring:message code="global.script.search.no.result" /></div></td>
					</tr>
				</c:when>
				<c:when test="${not empty approvalList}">
				<c:forEach items="${approvalList}" var="approval">
					<c:if test="${isAllAllowApproval eq 'Y' || isAllRejectApproval eq 'Y'}">
						<c:set var="inputStyle" value="disabled" />
						<c:forEach var="attachFile" items="${approval.attachFileFormList}">
							<c:if test="${attachFile.isNormalFile}">
								<c:set var="inputStyle" value="" />
							</c:if>
						</c:forEach> 
						<c:if test="${getSiteCode eq 'mcst' || getSiteCode eq 'museum' || getSiteCode eq 'sejong_nl' || getSiteCode eq 'nl'}"> 
							<c:set var="inputStyle" value="" />
						</c:if>
						<c:if test="${isAllRejectApproval eq 'Y'}"> 
							<c:set var="inputStyle" value="" />
						</c:if>
					</c:if>
					<tr id="tr_id_${approval.approval_seq}">
						<c:if test="${isAllAllowApproval eq 'Y' || isAllRejectApproval eq 'Y'}">
							<td class="right_line t_center"><input type="checkbox" ${inputStyle} class="input_chk" name="chk" id="chk" value="${approval.approval_seq}" /></td>
						</c:if>
						<c:choose>
						<c:when test="${loginUser.users_id != approval.appr_id}">
							<td class="right_line t_center" onClick="read('${approval.approval_seq}','${approval.data_seq}','${approval.np_cd}'); return false;">${customfunc:codeDes("APP_TYPE", "PR") }</td>
						</c:when>
						<c:otherwise>
							<td class="right_line t_center" onClick="read('${approval.approval_seq}','${approval.data_seq}','${approval.np_cd}'); return false;">${customfunc:codeDes("APP_TYPE", approval.app_type) }</td>
						</c:otherwise>
						</c:choose>
						<c:if test="${oppsiteApprovalOption ne 'N'}">
							<td class="right_line t_center" onClick="read('${approval.approval_seq}','${approval.data_seq}','${approval.np_cd}'); return false;"><span>${customfunc:codeDes("NP_CD", approval.np_cd) }</span></td>
						</c:if>
						<td class="right_line t_center" onClick="read('${approval.approval_seq}','${approval.data_seq}','${approval.np_cd}'); return false;"><span title="${approval.users_nm}(${approval.users_id})"><c:out value="${approval.users_nm}(${approval.users_id})" /></span></td>
						<td class="right_line" onClick="read('${approval.approval_seq}','${approval.data_seq}','${approval.np_cd}'); return false;"><c:out value="${approval.title}" /></td>
						<td class="right_line t_center" onClick="read('${approval.approval_seq}','${approval.data_seq}','${approval.np_cd}'); return false;">${fn:length(approval.attachFileFormList)}<spring:message code="data.file.sendList.list.file.unit" />(<c:out value="${customfunc:BigFileSizeFormat(approval.totalAttachFileSize)}" />)</td>
						<td class="right_line t_center" onClick="read('${approval.approval_seq}','${approval.data_seq}','${approval.np_cd}'); return false;"><fmt:formatDate value="${approval.crt_time}" pattern="yyyy-MM-dd HH:mm" /></td>
					</tr>
				</c:forEach>
				</c:when>
				<c:otherwise>
				</c:otherwise>
				</c:choose>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="${colspan}" class="td_last" style="background-color: #EEEEEE;">
							<jsp:include page="/WebUI/include/footer_list_count_select.jsp">
								<jsp:param name="size" value="${approvalForm.pageListSize}"/>
								<jsp:param name="currentPage" value="${approvalForm.currentPage}"/>
							</jsp:include>
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
