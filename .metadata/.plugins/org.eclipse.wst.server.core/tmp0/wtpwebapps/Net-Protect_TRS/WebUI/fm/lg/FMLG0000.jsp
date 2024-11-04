<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<c:set var="ft_css" value="${dataForm.isAppTypeDisplayUse ? 'ft_8' : '' }" />
<html>
<head>
<script type="text/javascript">
	bindEventOnSearchDateInput();
	$(document).ready(function() {
		$('#searchValue').keypress(function(e) {
			if (e.which == 13) {
				search();
				return false;
			}
		});
		totalCount();
		$("#pageListSize").change(search);
	});

	function reset(){
		location.href = '<c:url value="/fm/lg/FMLG0000.lin" />';
	}

	function search(){
		if( ! isValidDateValue() )
			return; 
		
		$("#page").val("1");
		$("#searchValue").val($('#searchValueInput').val());
		$("#searchField").val($("select[name=selectSearchField]").val());
		$("#networkPosition").val($("select[name=selectNetworkPosition]").val());
		$("#searchPosition").val($("select[name=selectNetworkPosition]").val());

		var frm = document.lform;
		frm.action="<c:url value="/fm/lg/FMLG0000.lin" />";
		frm.submit();
		showModal();
	}

	function view(data_seq , searchPosition){
		var networkPosition = (searchPosition == null)?'${dataForm.networkPosition }':searchPosition;
		var url = "<c:url value="/fm/lg/FMLG0010.lin" />?data_seq=" + data_seq + "&networkPosition="+networkPosition;
		var attibute = "resizable=yes,scrollbars=yes,width=800,height=750,top=5,left=5,toolbar=no";
		var popupWindow = window.open(url, "lincubeSendList", attibute);
		popupWindow.focus();
	}
	
	$(document).ready(function() {
		checkFocusMessage($("#searchValueInput"),"최대 100자까지 가능합니다.");
	});
	
	function download(){
		if( ! isValidDateValue() )
			return; 
		
		$("#searchValue").val($('#searchValueInput').val());
		$("#searchField").val($("select[name=selectSearchField]").val());
		$("#networkPosition").val($("select[name=selectNetworkPosition]").val());
		$("#searchPosition").val($("select[name=selectNetworkPosition]").val());
		
		var frm = document.lform;
		frm.action="<c:url value="/fm/lg/dataLogListExcelDownload.lin" />";
		frm.submit();
		  
		frm.action="<c:url value="/fm/lg/FMLG0000.lin" />";
	 }
	
	function totalCount(){
		var requestURL = "<c:url value="/fm/lg/getDataTotalCount.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var dataTotalListCount = response['dataTotalListCount'];
			var msg = '<spring:message code="global.script.search.count" arguments='###'/>';
			msg = msg.replace('###',addComma(dataTotalListCount));
			$("#totalCnt").text(msg);
			$("#totalCount").val(dataTotalListCount);
			calldataList();
		});
	}
	
	function calldataList(){
		var requestURL = "<c:url value="/list/getPagenation.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var pageList = response['pageList'];
			var msg = '<spring:message code="global.script.search.count" arguments='###'/>';
			$("#pageList").html(pageList);
		});
	}
	
	function addComma(data_value) {
		return Number(data_value).toLocaleString('en');
	}
	
	function controlModal( show_hide_code , text ){
		var modal_alert_dom = document.getElementById("modal_alert");
		if( text ){
			changeInnerHtml( document.getElementById("modal_alert_text") , text );
		}
		if( show_hide_code == 'show' ){
			showUI( modal_alert_dom );
		}
		if( show_hide_code == 'hide' ){
			hideUI( modal_alert_dom );
		}
	}

	function showModal() {
		controlModal('show');
	}
	
	function hideModal() {
		controlModal( 'hide' );
	}

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/fm/lg/FMLG0000.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden" value="${currentPage}" />
<input id="searchValue" name="searchValue" type="hidden" value="${dataForm.searchValue }"/>
<input id="searchField" name="searchField" type="hidden" value="${dataForm.searchField}" />
<input id="networkPosition" name="networkPosition" type="hidden" value="${dataForm.networkPosition}" />
<input id="searchPosition" name="searchPosition" type="hidden" value="${dataForm.searchPosition}"/>
<input id="totalCount" name="totalCount" type="hidden" value=""/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">자료전송 이력</h2>
				<p class="breadCrumbs">로그관리 > 자료전송 이력</p>
			</div>
		</div>
		<div class="conWrap">
			<h3>검색조건</h3>
			<div class="conBox searchBox t_center">
				<div class="topCon nBorder">
					<table summary="정책 검색조건" style="table-layout : fixed" >
					<caption>검색조건, 버튼</caption>
						<tbody>
							<tr>
								<td class="t_center">
									<jsp:include page="/WebUI/include/date_input.jsp">
										<jsp:param name="s_day" value="${dataForm.startDay}"/>
										<jsp:param name="s_hour" value="${dataForm.startHour}"/>
										<jsp:param name="s_min" value="${dataForm.startMin}"/>
										<jsp:param name="e_day" value="${dataForm.endDay}"/>
										<jsp:param name="e_hour" value="${dataForm.endHour}"/>
										<jsp:param name="e_min" value="${dataForm.endMin}"/>
									</jsp:include>
									<select title="목록 검색조건" class="mg_l20" id="selectNetworkPosition" name="selectNetworkPosition">
										<option value="B" <c:if test="${dataForm.searchPosition eq 'B' }">selected="selected"</c:if>>전체영역</option>
										<option value="I" <c:if test="${dataForm.searchPosition eq 'I' }">selected="selected"</c:if>>${INNER} -> ${OUTER}</option>
										<option value="O" <c:if test="${dataForm.searchPosition eq 'O' }">selected="selected"</c:if>>${OUTER} -> ${INNER}</option>
									</select>
									<select title="목록 검색조건2" id="selectSearchField" name="selectSearchField">
										<option <c:if test="${dataForm.searchField eq 'users_nm'}">selected="selected"</c:if> value="users_nm">사용자</option>
										<option <c:if test="${dataForm.searchField eq 'users_id'}">selected="selected"</c:if> value="users_id">${customfunc:getMessage('common.id.commonid')}</option>
										<option <c:if test="${dataForm.searchField eq 'dept_nm'}">selected="selected"</c:if> value="dept_nm">부서명</option>
										<option <c:if test="${dataForm.searchField eq 'file_nm'}">selected="selected"</c:if> value="file_nm">파일명</option>
									</select>
									<input type="text" class="text_input long" id="searchValueInput" name="searchValueInput" value="${dataForm.searchValue }" style="max-width:14%;" placeholder="검색어를 입력해주세요." onkeyup="onlySizeFillter(this,100)"/>
									<button class="btn_common theme" onclick="search();">조회</button>
									<!-- <button class="btn_common theme mg_r10">엑셀다운로드</button> -->
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="t_right pd_r15">
			<button type="button"  onclick="download()" class="btn_common theme">엑셀다운로드</button>
			<!-- <button type="button" id="btnExcelDownload" onclick="download()" style="width:72px;height:21px;background-image:url(../../Images/button/btn_small_style01.gif);background-position:0 -525px;"></button> -->
		</div>
		<div class="conWrap tableBox">
			<h3><c:choose>
					<c:when test="${dataForm.searchPosition eq 'B'}">
					전체영역 
					</c:when>
					<c:when test="${dataForm.networkPosition eq 'I' }">
					${INNER}영역 --> ${OUTER}영역
					</c:when>
					<c:otherwise>
					${OUTER}영역 --> ${INNER}영역
					</c:otherwise>
				</c:choose>자료전송 이력 </h3>
			<div class="conBox">
				<div class="table_area_style01 hoverTable">
					<c:if test="${dataForm.searchPosition eq 'B'}">
						<c:set var="col1" value="12%"/>
						<c:set var="col2" value="12%"/>
						<c:set var="col3" value="${dataForm.isAppTypeDisplayUse ? '10%': '11%'}"/>
						<c:set var="app_col1" value="10%" />
						<c:set var="app_col2" value="12%" />
						<c:set var="app_col3" value="13%" />
						<c:set var="app_col4" value="13%" />
						<c:set var="col4" value="${dataForm.isAppTypeDisplayUse ? '8%' : '12%'}"/>
						<c:set var="col5" value="${dataForm.isAppTypeDisplayUse ? '20%': '30%'}"/>
						<c:set var="col6" value="12%"/>
						<c:set var="col7" value="11%"/>
						<c:set var="col8" value="12%"/>
					</c:if>
					<c:if test="${dataForm.searchPosition ne 'B'}">
						<c:set var="col1" value="0%"/>
						<c:set var="col2" value="12%"/>
						<c:set var="col3" value="${dataForm.isAppTypeDisplayUse ? '10%': '12%'}"/>
						<c:set var="app_col1" value="10%" />
						<c:set var="app_col2" value="12%" />
						<c:set var="app_col3" value="13%" />
						<c:set var="app_col4" value="13%" />
						<c:set var="col4" value="${dataForm.isAppTypeDisplayUse ? '8%' : '12%'}"/>
						<c:set var="col5" value="${dataForm.isAppTypeDisplayUse ? '30%' : '40%'}"/>
						<c:set var="col6" value="12%"/>
						<c:set var="col7" value="12%"/>
						<c:set var="col8" value="12%"/>
					</c:if>
					<table cellspacing="0" cellpadding="0" summary="자료 수신함" style="table-layout : fixed">
					<caption>요청자, 제목, 요청시간</caption>
						<colgroup>
							<c:if test="${dataForm.searchPosition eq 'B'}"><col style="width:${col1};" /></c:if>
							<col style="width:${col2};" />
							<col style="width:${col3};" />
							<c:if test="${dataForm.isAppTypeDisplayUse}">
								<col style="width:${app_col1};" />
								<col style="width:${app_col2};" />
								<col style="width:${app_col3};" />
								<col style="width:${app_col4};" />
							</c:if>
							<col style="width:${col4};" />
							<col style="width:${col5};" />
							<col style="width:${col6};" />
							<col style="width:${col7};" />
							<col style="width:${col8};" />
						</colgroup>
						<thead>
							<tr>
								<c:if test="${dataForm.searchPosition eq 'B'}"><th class="Rborder">전송영역</th></c:if>
								<th class="Rborder">부서명</th>
								<th class="Rborder">사용자</th>
								<c:if test="${dataForm.isAppTypeDisplayUse}">
									<th class="Rborder">결재자</th>
									<th class="Rborder">결재상태</th>
									<th class="Rborder">결재시간</th>
									<th class="Rborder">다운로드 시간</th>
								</c:if>
								<th class="Rborder">전송상태</th>
								<th class="Rborder">제목</th>
								<th class="Rborder">첨부파일</th>
								<th class="Rborder">접속IP</th>
								<th class="Rborder">전송시간</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
							<c:when test="${not empty dataList}">
							<c:forEach items="${dataList }" var="data">
								<tr class="${ft_css}" onclick="view('${data.data_seq}');">
									<td class="t_center Rborder"><c:out value="${data.dept_nm }" /></td>
									<td class="t_center Rborder"><c:out value="${data.users_nm }(${data.users_id })"/></td>
									<c:if test="${dataForm.isAppTypeDisplayUse}">
										<td class="t_center Rborder"><c:out value="${data.appr_id eq null ? '-' : customfunc:getApprInfo(data.appr_nm,data.appr_id)}" /></td>
										<td class="t_center Rborder"><c:out value="${data.appr_type eq null ? '-' : customfunc:codeDes('APP_TYPE', data.appr_type)}"/></td>
										<td class="t_center Rborder"><c:out value="${data.appr_time eq null ? '-' : customfunc:getDateTime(data.appr_time)}"/></td>
										<td class="t_center Rborder"><c:out value="${data.max_download_time eq null ? '-' : customfunc:getDateTime(data.max_download_time)}"/></td>
									</c:if>
									<td class="t_center Rborder">
										<c:out value="${customfunc:codeDes('DATA_STATUS', data.status)}"/>
									</td>
									<td class="t_center Rborder"><c:out value="${data.title }" escapeXml="true" /></td>
									<td class="t_center Rborder">
										${data.file_total_count} <spring:message code="data.file.sendList.list.file.unit" />(<c:out value="${customfunc:BigFileSizeFormat(data.file_total_size)}" />)
									</td>
									<td class="t_center Rborder">${data.connect_ip }</td>
									<td class="t_center "><fmt:formatDate value="${data.crt_time}" pattern="yyyy-MM-dd HH:mm" /></td>
								</tr>
								</c:forEach>
							</c:when>
							<c:when test="${not empty dataTotalList}">
								<c:forEach items="${dataTotalList }" var="data">
									<%-- 결재상태 확인하기 위해 approval_last변수 초기화 --%>
								<tr class="${ft_css}" onclick="view('${data.data_seq}','${data.networkPosition }');">
									<c:if test="${dataForm.searchPosition eq 'B'}">
									<c:if test="${data.networkPosition eq 'I'}"><td class="t_center Rborder">${INNER} -> ${OUTER}</td></c:if>
									<c:if test="${data.networkPosition eq 'O'}"><td class="t_center Rborder">${OUTER} -> ${INNER}</td></c:if>
									</c:if>
									<td class="t_center Rborder"><c:out value="${data.dept_nm }" /></td>
									<td class="t_center Rborder"><c:out value="${data.users_nm }(${data.users_id })"/></td>
									<c:if test="${dataForm.isAppTypeDisplayUse}">
										<td class="t_center Rborder"><c:out value="${data.appr_id eq null ? '-' : customfunc:getApprInfo(data.appr_nm,data.appr_id)}" /></td>
										<td class="t_center Rborder"><c:out value="${data.appr_type eq null ? '-' : customfunc:codeDes('APP_TYPE', data.appr_type)}"/></td>
										<td class="t_center Rborder"><c:out value="${data.appr_time eq null ? '-' : customfunc:getDateTime(data.appr_time)}"/></td>
										<td class="t_center Rborder"><c:out value="${data.max_download_time eq null ? '-' : customfunc:getDateTime(data.max_download_time)}"/></td>
									</c:if>
									<td class="t_center Rborder">
										<c:out value="${customfunc:codeDes('DATA_STATUS', data.status)}"/>
									</td>
									<td class="t_center Rborder"><c:out value="${data.title }" escapeXml="true" /></td>
									<td class="t_center Rborder">
										${data.file_total_count}<spring:message code="data.file.sendList.list.file.unit" />(<c:out value="${customfunc:BigFileSizeFormat(data.file_total_size)}" />)
									</td>
									<td class="t_center Rborder">${data.connect_ip }</td>
									<td class="t_center "><fmt:formatDate value="${data.crt_time}" pattern="yyyy-MM-dd HH:mm" /></td>
								</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td class="t_center" colspan="${colspan}">
										<div class="no_result">결과가 없습니다.</div>
									</td>
								</tr>
							</c:otherwise>
							</c:choose>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="${colspan}" class="td_last">
									<span class="text_list_number" id="totalCnt"></span><%-- <spring:message code="global.script.search.count" arguments="${paging.totalCount}" /> --%></span>
									<!-- <span class="text_list_number" id="totalCnt"> 건</span> -->
									<div class="pagenate t_center" id="pageList">
										<%-- ${pageList} --%>
									</div>
									<span class="pagenate_listsize">
										<select id="pageListSize" name="pageListSize">
											<option value="20" <c:if test="${paging.pageListSize == '20'}">selected="selected"</c:if>>20</option>
											<option value="30" <c:if test="${paging.pageListSize == '30'}">selected="selected"</c:if>>30</option>
											<option value="50" <c:if test="${paging.pageListSize == '50'}">selected="selected"</c:if>>50</option>
											<option value="100" <c:if test="${paging.pageListSize == '100'}">selected="selected"</c:if>>100</option>
										</select>
										개 보기
									</span>
								</td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
		</div>
	</div>
</form>
<jsp:include page="/WebUI/include/modal_alert.jsp" />
</body>
</html>
