<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<html>
<head>
<script type="text/javascript">
	bindEventOnSearchDateInput();
	
	$(document).ready(function() {
		checkFocusMessage($("#searchValue"),"최대 100자까지 가능합니다.");
		$('#searchValue').keypress(function(e) {
			if (e.which == 13) {
				search();
				return false;
			}
		});
		$("#pageListSize").change(search);
	});

	function search(){
		if( ! isValidDateValue() )
			return;
		
		var frm = document.lform;
		frm.action="<c:url value="/fm/lg/FMLG2000.lin" />";
		frm.submit();
		showModal();
	}

	function view(clipboard_seq , io_cd){
		var url = "<c:url value="/fm/lg/FMLG2010.lin" />?clipboard_seq=" + clipboard_seq + "&io_cd=" + io_cd;
		var attibute = "resizable=yes,scrollbars=yes,width=800,height=735,top=5,left=5,toolbar=no";
		var popupWindow = window.open(url, "clipboardList", attibute);
		popupWindow.focus();
	}
	
	function download(){
		if( ! isValidDateValue() )
			return;
		
		var frm = document.forms['lform'];
		frm.action = '<c:url value="/fm/lg/clipboardLogListExcelDownload.lin" />';
		frm.submit();
		frm.action="<c:url value="/fm/lg/FMLG2000.lin" />";
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
<form id="lform" name="lform" onsubmit="return false;" method="post" >
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<input id="page" name="page" type="hidden" />
<div class="rightArea">
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold">클립보드 이력</h2>
			<p class="breadCrumbs">로그관리 > 클립보드이력</p>
		</div>
	</div>
	<div class="conWrap">
		<h3>검색조건</h3>
		<div class="conBox searchBox t_center">
			<div class="topCon nBorder"  >
				<table summary="정책 검색조건">
				<caption>검색조건, 버튼</caption>
					<colgroup>
					</colgroup>
					<tbody>
						<tr>
							<td class="t_center">
								<jsp:include page="/WebUI/include/date_input.jsp">
									<jsp:param name="s_day" value="${clipboard.startDay}"/>
									<jsp:param name="s_hour" value="${clipboard.startHour}"/>
									<jsp:param name="s_min" value="${clipboard.startMin}"/>
									<jsp:param name="e_day" value="${clipboard.endDay}"/>
									<jsp:param name="e_hour" value="${clipboard.endHour}"/>
									<jsp:param name="e_min" value="${clipboard.endMin}"/>
								</jsp:include>
								<select id="searchField" name="searchField" title="목록 검색조건" class="mg_l20">
									<option <c:if test="${clipboard.searchField eq 'users_nm'}">selected="selected"</c:if> value="users_nm">사용자</option>
									<option <c:if test="${clipboard.searchField eq 'users_id'}">selected="selected"</c:if> value="users_id">${customfunc:getMessage('common.id.commonid')}</option>
									<option <c:if test="${clipboard.searchField eq 'dept_nm'}">selected="selected"</c:if> value="dept_nm">부서명</option>
								</select>
								
								<input type="text" class="text_input long" id="searchValueInput" name="searchValue" value="${clipboard.searchValue }" style="max-width:14%;" placeholder="검색어를 입력해주세요." onkeyup="onlySizeFillter(this,100)"/>
								<button class="btn_common theme" onClick="search();">검색</button>
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
		<h3>목록</h3>
		<div class="conBox">
			<div class="table_area_style01 hoverTable">
				<table>
				<caption>파일명,전송위치,탐지명,사용자,전송시간</caption>
					<colgroup>
						<col style="width:12%;" />
						<col style="width:12%;" />
						<col style="width:12%;" />
						<col style="width:12%;" />
						<col style="width:16%;" />
						<col style="width:12%;" />
						<col style="width:12%;" />
						<col style="width:12%;" />
					</colgroup>
					<thead>
						<tr>
							<th class="Rborder">전송영역</th>
							<th class="Rborder">부서명</th>
							<th class="Rborder">사용자</th>
							<th class="Rborder">전송상태</th>
							<th class="Rborder">제목</th>
							<th class="Rborder">파일크기</th>
							<th class="Rborder">접속IP</th>
							<th class="Rborder">전송시간</th>
						</tr>
					</thead>
					<tbody>
					<c:choose>
					<c:when test="${not empty clipboardList}">
						<c:forEach items="${clipboardList}" var="clipboardForm">
						<tr onclick="view('${clipboardForm.clipboard_seq}','${clipboardForm.io_cd}')">
							<c:if test="${clipboardForm.io_cd eq 'I'}"><td class="t_center Rborder">${INNER} -> ${OUTER}</td></c:if>
							<c:if test="${clipboardForm.io_cd eq 'O'}"><td class="t_center Rborder">${OUTER} -> ${INNER}</td></c:if>
							<td class="t_center Rborder"><c:out value="${clipboardForm.dept_nm}"/></td>
							<td class="t_center Rborder"><c:out value="${clipboardForm.users_nm}(${clipboardForm.users_id})"/></td>
							<td class="t_center Rborder"><c:out value="${customfunc:codeDes('DATA_STATUS', clipboardForm.status)}"/></td>
							<td class="t_center Rborder"><c:out value="${clipboardForm.title}"/></td>
							<td class="t_center Rborder"><c:out value="${customfunc:BigFileSizeFormat(clipboardForm.file_size)}"/></td>
							<td class="t_center Rborder"><c:out value="${clipboardForm.connect_ip}"/></td>
							<td class="t_center Rborder" >
								<fmt:formatDate value="${clipboardForm.crt_time}" pattern="yyyy-MM-dd HH:mm" />
							</td>
						</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td class="t_center" colspan="8"><div class="no_result">결과가 없습니다.</div></td>
						</tr>
					</c:otherwise>
					</c:choose>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="8" class="td_last">
								<span class="text_list_number"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></span>
								<div class="pagenate t_center">
									${pageList}
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
