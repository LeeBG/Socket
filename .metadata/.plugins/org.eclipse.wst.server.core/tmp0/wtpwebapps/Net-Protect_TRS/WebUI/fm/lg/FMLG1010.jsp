<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<script type="text/javascript">
	bindEventOnSearchDateInput();
	$(document).ready(function() {
		checkFocusMessage($("#searchValueInput"),"최대 100자까지 가능합니다.");
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
		location.href = '<c:url value="/fm/lg/FMLG1010.lin" />';
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
		frm.action="<c:url value="/fm/lg/FMLG1010.lin" />";
		frm.submit();
		showModal();
	}

	function view(email_seq , searchPosition){
		var networkPosition = (searchPosition == null)?'${emlData.networkPosition }':searchPosition;
		var url = "<c:url value="/fm/lg/FMLG1011.lin" />?email_seq=" + email_seq + "&networkPosition="+networkPosition;
		var attibute = "resizable=yes,scrollbars=yes,width=800,height=700,top=5,left=5,toolbar=no";
		var popupWindow = window.open(url, "transEmlView", attibute);
		popupWindow.focus();
	}
	
	function download(){
		if( ! isValidDateValue() )
			return; 
		
		$("#searchValue").val($('#searchValueInput').val());
		$("#searchField").val($("select[name=selectSearchField]").val());
		$("#networkPosition").val($("select[name=selectNetworkPosition]").val());
		$("#searchPosition").val($("select[name=selectNetworkPosition]").val());
		
		var frm = document.lform;
		frm.action="<c:url value="/fm/lg/emlDataLogListExcelDownload.lin" />";
		frm.submit();
		  
		frm.action="<c:url value="/fm/lg/FMLG1010.lin" />";
	 }
	
	function totalCount(){
		var requestURL = "<c:url value="/fm/lg/getEmlDataTotalCount.lin" />";
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
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/fm/lg/FMLG1010.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden" value="${currentPage}" />
<input id="searchValue" name="searchValue" type="hidden" value="${emlData.searchValue }"/>
<input id="searchField" name="searchField" type="hidden" value="${emlData.searchField}" />
<input id="networkPosition" name="networkPosition" type="hidden" value="${emlData.networkPosition}" />
<input id="searchPosition" name="searchPosition" type="hidden" value="${emlData.searchPosition}"/>
<input id="totalCount" name="totalCount" type="hidden" value=""/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">메일연계 이력</h2>
				<p class="breadCrumbs">로그관리 > 메일연계 이력</p>
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
										<jsp:param name="s_day" value="${emlData.startDay}"/>
										<jsp:param name="s_hour" value="${emlData.startHour}"/>
										<jsp:param name="s_min" value="${emlData.startMin}"/>
										<jsp:param name="e_day" value="${emlData.endDay}"/>
										<jsp:param name="e_hour" value="${emlData.endHour}"/>
										<jsp:param name="e_min" value="${emlData.endMin}"/>
									</jsp:include>
									<select title="목록 검색조건" class="mg_l20" id="selectNetworkPosition" name="selectNetworkPosition">
										<option value="B" <c:if test="${emlData.searchPosition eq 'B' }">selected="selected"</c:if>>전체영역</option>
										<option value="I" <c:if test="${emlData.searchPosition eq 'I' }">selected="selected"</c:if>>업무망 -> 인터넷망</option>
										<option value="O" <c:if test="${emlData.searchPosition eq 'O' }">selected="selected"</c:if>>인터넷망 -> 업무망</option>
									</select>
									<select title="목록 검색조건2" id="selectSearchField" name="selectSearchField">
										<option <c:if test="${emlData.searchField eq 'sender_email'}">selected="selected"</c:if> value="sender_email">송신자</option>
										<option <c:if test="${emlData.searchField eq 'receiver_email'}">selected="selected"</c:if> value="receiver_email">수신자</option>
										<option <c:if test="${emlData.searchField eq 'email_subject'}">selected="selected"</c:if> value="email_subject">메일제목</option>
									</select>
									<input type="text" class="text_input long" id="searchValueInput" name="searchValueInput" value="${emlData.searchValue }" style="max-width:14%;" placeholder="검색어를 입력해주세요." onkeyup="onlySizeFillter(this,100)"/>
									<button class="btn_common theme" onclick="search();">조회</button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="t_right pd_r15">
			<button type="button"  onclick="download()" class="btn_common theme">엑셀다운로드</button>
		</div>
		<div class="conWrap tableBox">
			<h3><c:choose>
					<c:when test="${emlData.searchPosition eq 'B'}">
					전체영역 
					</c:when>
					<c:when test="${emlData.networkPosition eq 'I' }">
					업무망영역 --> 인터넷망영역
					</c:when>
					<c:otherwise>
					인터넷망영역 --> 업무망영역
					</c:otherwise>
				</c:choose>메일연계 이력 </h3>
			<div class="conBox">
				<div class="table_area_style01 hoverTable">
					<c:if test="${emlData.searchPosition eq 'B'}">
						<c:set var="col1" value="12%"/>
						<c:set var="col2" value="13%"/>
						<c:set var="col3" value="13%"/>
						<c:set var="col4" value="20%"/>
						<c:set var="col5" value="12%"/>
						<c:set var="col6" value="11%"/>
						<c:set var="col7" value="12%"/>
					</c:if>
					<c:if test="${emlData.searchPosition ne 'B'}">
						<c:set var="col1" value="0%"/>
						<c:set var="col2" value="13%"/>
						<c:set var="col3" value="13%"/>
						<c:set var="col4" value="20%"/>
						<c:set var="col5" value="12%"/>
						<c:set var="col6" value="12%"/>
						<c:set var="col7" value="12%"/>
					</c:if>
					<table cellspacing="0" cellpadding="0" summary="메일연계" style="table-layout : fixed">
					<caption>발송영역, 송신자, 수신자, 메일제목, 첨부파일, 발송결과, 발송시간</caption>
						<colgroup>
							<c:if test="${emlData.searchPosition eq 'B'}"><col style="width:${col1};" /></c:if>
							<col style="width:${col2};" />
							<col style="width:${col3};" />
							<col style="width:${col4};" />
							<col style="width:${col5};" />
							<col style="width:${col6};" />
							<col style="width:${col7};" />
						</colgroup>
						<thead>
							<tr>
								<c:if test="${emlData.searchPosition eq 'B'}"><th class="Rborder">발송영역</th></c:if>
								<th class="Rborder">송신자</th>
								<th class="Rborder">수신자</th>
								<th class="Rborder">메일제목</th>
								<th class="Rborder">첨부파일</th>
								<th class="Rborder">발송결과</th>
								<th class="Rborder">발송시간</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
							<c:when test="${not empty dataList}">
								<c:forEach items="${dataList }" var="data">
								<tr onclick="view('${data.email_seq}');">
									<td class="t_center Rborder"><c:out value="${data.sender_email }"/></td>
									<td class="t_center Rborder"><c:out value="${data.receiver_email}"/></td>
									<td class="t_center Rborder"><c:out value="${data.email_subject }" escapeXml="true" /></td>
									<td class="t_center Rborder">
										${data.file_total_count} <spring:message code="data.file.sendList.list.file.unit" />(<c:out value="${customfunc:BigFileSizeFormat(data.file_total_size)}" />)
									</td>
									<td class="t_center Rborder">${data.result }</td>
									<td class="t_center "><fmt:formatDate value="${data.crt_time}" pattern="yyyy-MM-dd HH:mm" /></td>
								</tr>
								</c:forEach>
							</c:when>
							<c:when test="${not empty dataTotalList}">
								<c:forEach items="${dataTotalList }" var="data">
								<tr onclick="view('${data.email_seq}','${data.networkPosition }');">
									<c:if test="${emlData.searchPosition eq 'B'}">
									<c:if test="${data.networkPosition eq 'I'}"><td class="t_center Rborder">업무망 -> 인터넷망</td></c:if>
									<c:if test="${data.networkPosition eq 'O'}"><td class="t_center Rborder">인터넷망 -> 업무망</td></c:if>
									</c:if>
									<td class="t_center Rborder"><c:out value="${data.sender_email }"/></td>
									<td class="t_center Rborder"><c:out value="${data.receiver_email}"/></td>
									<td class="t_center Rborder"><c:out value="${data.email_subject }" escapeXml="true" /></td>
									<td class="t_center Rborder">
										<c:if test="${data.file_total_count eq '0'}">
											첨부파일 없음
										</c:if>
										<c:if test="${data.file_total_count ne '0'}">
											${data.file_total_count} <spring:message code="data.file.sendList.list.file.unit" />(<c:out value="${customfunc:BigFileSizeFormat(data.file_total_size)}" />)
										</c:if>
									</td>
									<td class="t_center Rborder">
										<c:out value="${customfunc:codeDes('EML_DATA_STATUS', data.result)}"/>
									</td>
									<td class="t_center "><fmt:formatDate value="${data.crt_time}" pattern="yyyy-MM-dd HH:mm" /></td>
								</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<c:if test="${emlData.searchPosition ne 'B'}"><td class="t_center" colspan="6"></c:if>
									<c:if test="${emlData.searchPosition eq 'B'}"><td class="t_center" colspan="7"></c:if>
										<div class="no_result">결과가 없습니다.</div>
									</td>
								</tr>
							</c:otherwise>
							</c:choose>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="${emlData.searchPosition eq 'B' ? 7 : 6}" class="td_last">
									<span class="text_list_number" id="totalCnt"></span>
									<div class="pagenate t_center" id="pageList">
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
