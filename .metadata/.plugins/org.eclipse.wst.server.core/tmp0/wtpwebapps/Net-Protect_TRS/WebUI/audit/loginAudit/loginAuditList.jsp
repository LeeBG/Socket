<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<c:choose>
	<c:when test="${loginTypeDisplayYn eq 'Y'}">
		<c:set var="colspan" value="7"/>
	</c:when>
	<c:otherwise>
		<c:set var="colspan" value="6"/>
	</c:otherwise>
</c:choose>
<html>
<head>
<c:set var="commonUserIdText" value="${customfunc:getMessage('common.id.commonid')}"/>
<spring:message code="common.id.adminid" var="adminUserIdText"/>
<c:if test="${commonUserIdText ne adminUserIdText}">
<c:set var="userIdText" value="${commonUserIdText} 또는 ${adminUserIdText}"/>
</c:if>
<c:if test="${commonUserIdText eq adminUserIdText}">
<c:set var="userIdText" value="${commonUserIdText}"/>
</c:if>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="CUD_CD_D" value="${customfunc:codeString('CUD_CD', 'DELETE')}" />
<script type="text/javascript">
	bindEventOnSearchDateInput();
	$(document).ready(function() {
		$('#search').click(function(){
			search();
		});

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

		$("#searchValue").val($("#searchValueInput").val());
		$("#searchField").val($("select[name=selectSearchField]").val());

		var frm = document.forms['lform'];
		frm.action = '<c:url value="/audit/loginAudit/loginAuditList.lin" />';
		frm.submit();
		showModal();
	}

	function reset(){
		location.href = '<c:url value="/audit/loginAudit/loginAuditList.lin" />';
	}
	
	$(document).ready(function() {
		checkFocusMessage($("#searchValueInput"),"최대 100자까지 가능합니다.");
	});
	
	function download(){
		if( ! isValidDateValue() )
			return; 

		$("#searchValue").val($("#searchValueInput").val());
		$("#searchField").val($("select[name=selectSearchField]").val());

		var frm = document.forms['lform'];
		frm.action = '<c:url value="/audit/loginAudit/loginAuditExcelDownload.lin" />';
		frm.submit();
		
		frm.action ="<c:url value="/audit/loginAudit/loginAuditList.lin" />";
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
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/audit/loginAudit/loginAuditList.lin" />">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<input id="page" name="page" type="hidden" />
	<input id="searchValue" name="searchValue" type="hidden" value="${loginAuditForm.searchValue}" />
	<input id="searchField" name="searchField" type="hidden" value="${loginAuditForm.searchField}" />
	<input id="system_cd" name="system_cd" type="hidden" value="${loginAuditForm.system_cd}" />
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">로그인 이력</h2>
				<p class="breadCrumbs">로그관리 > 로그인 이력</p>
			</div>
		</div>
		<div class="conWrap">
			<h3>검색조건</h3>
			<div class="conBox searchBox t_center">
				<div class="topCon nBorder">
					<table summary="정책 검색조건" style="table-layout : fixed" >
					<caption>검색조건, 버튼</caption>
						<tbody>
							<colgroup>
								<col style="width:100%;"/>
							</colgroup>
							<tr>
								<td class="t_center">
									<jsp:include page="/WebUI/include/date_input.jsp">
										<jsp:param name="s_day" value="${loginAuditForm.startDay}"/>
										<jsp:param name="s_hour" value="${loginAuditForm.startHour}"/>
										<jsp:param name="s_min" value="${loginAuditForm.startMin}"/>
										<jsp:param name="e_day" value="${loginAuditForm.endDay}"/>
										<jsp:param name="e_hour" value="${loginAuditForm.endHour}"/>
										<jsp:param name="e_min" value="${loginAuditForm.endMin}"/>
									</jsp:include>
									<select id="selectSearchField" name="selectSearchField" title="목록 검색조건" class="mg_l20">
										<option <c:if test="${loginAuditForm.searchField eq 'users_nm'}">selected="selected"</c:if> value="users_nm">사용자명</option>
										<option <c:if test="${loginAuditForm.searchField eq 'users_id'}">selected="selected"</c:if> value="users_id">${userIdText}</option>
										<option <c:if test="${loginAuditForm.searchField eq 'connect_ip'}">selected="selected"</c:if> value="connect_ip">접속IP</option>
									</select>
									<input id="searchValueInput" name="searchValueInput" type="text" class="text_input long" style="max-width:14%;" value="${loginAuditForm.searchValue}" placeholder="검색어를 입력해주세요." onkeyup="onlySizeFillter(this,100)"/>
									<button class="btn_common theme" onClick="search();">검색</button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="t_right pd_r15">
			<!-- <button type="button" id="btnExcelDownload" onclick="download()" style="width:72px;height:21px;background-image:url(../../Images/button/btn_small_style01.gif);background-position:0 -525px;"></button> --> 
			<button type="button"  onclick="download()" class="btn_common theme">엑셀다운로드</button>
		</div>
		<div class="conWrap tableBox">
			<h3>목록</h3>
			<div class="conBox">
				<div class="table_area_style01 hoverTable">
					<table summary="자료 수신함" style="table-layout : fixed">
					<caption>요청자, 제목, 요청시간</caption>
						<colgroup>
							<col style="width:15%;" />
							<col style="width:15%;" />
							<c:if test="${loginTypeDisplayYn eq 'Y'}"><col style="width:15%;" /></c:if>
							<col style="width:15%;" />
							<col style="width:15%;" />
							<col style="width:15%;" />
							<col style="width:15%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder">사용자명(${userIdText})</th>
								<th class="Rborder">접속IP</th>
								<c:if test="${loginTypeDisplayYn eq 'Y'}"><th class="Rborder">로그인 방식</th></c:if>
								<th colspan="Rborder">상태</th>
								<th colspan="Rborder">접속실패횟수</th>
								<th colspan="Rborder">접속위치</th>
								<th colspan="Rborder">접속시간</th>
							</tr>
						</thead>
						<tbody>
						<c:choose>
						<c:when test="${not empty loginAuditFormList}">
							<c:forEach items="${loginAuditFormList}" var="loginAuditForm">
								<tr>
									<td class="t_center Rborder" title="<c:out value="${loginAuditForm.users_nm}(${loginAuditForm.users_id})" />">
										<c:out value="${loginAuditForm.users_nm}(${loginAuditForm.users_id})" />
									</td>
									<td class="t_center Rborder" title="<c:out value="${loginAuditForm.connect_ip}" />">
										<c:out value="${loginAuditForm.connect_ip}" />
									</td>
									<c:if test="${loginTypeDisplayYn eq 'Y'}">
										<td class="t_center Rborder" title="<c:out value="${loginAuditForm.login_type_nm}" />">
											<c:out value="${loginAuditForm.login_type_nm}" />
									</c:if>
									<td class="t_center Rborder" title="<spring:message code="global.script.login.${loginAuditForm.login_cd}" />">
										<spring:message code="global.script.login.${loginAuditForm.login_cd}" />
									</td>
									<td class="t_center Rborder" title="<c:out value="${loginAuditForm.try_count}" />">
										<c:out value="${loginAuditForm.try_count}" />
									</td>
									<td class="t_center Rborder" title="${loginAuditForm.np_cd eq 'I' ? INNER : OUTER}">
										<c:out value="${loginAuditForm.np_cd eq 'I' ? INNER : OUTER}" />
									</td>
									<td class="t_center Rborder" title="<fmt:formatDate value="${loginAuditForm.crt_date}" pattern="yyyy-MM-dd HH:mm" />">
										<fmt:formatDate value="${loginAuditForm.crt_date}" pattern="yyyy-MM-dd HH:mm" />
									</td>
								</tr>
							</c:forEach>
						</c:when>	
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="${colspan}"><div class="no_result">결과가 없습니다.</div></td>
							</tr>
						</c:otherwise>
						</c:choose>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="${colspan}" class="td_last">
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
