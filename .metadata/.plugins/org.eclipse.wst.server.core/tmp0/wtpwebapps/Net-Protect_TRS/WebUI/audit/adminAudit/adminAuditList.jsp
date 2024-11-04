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
	bindEventOnSearchDateInput();
	
	$(document).ready(function() {
		$('#searchValue').keypress(function(e) {
			if (e.which == 13) {
				search();
				return false;
			}
		});

		$("#pageListSize").change(search);
	});
	
	function select_menu(menu){
		var menu_id = $(menu).val();
		$("#menu_id").val(menu_id);

		var requestURL = "<c:url value='/audit/adminAudit/selectMenuList.lin' />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var resultAuditCodeList = response['resultAuditCodeList'];
			var result = "";
			var sel = "";
			if (resultAuditCodeList == null || resultAuditCodeList.length == 0) {
			} else {
				result += "<option value='all'>전체</option>";
				for (var i = 0; i < resultAuditCodeList.length; i++) {
					sel = "";
					var cd_nm = resultAuditCodeList[i].cd_nm;
					var cd_des = resultAuditCodeList[i].cd_des;
					if(cd_nm == '${adminAuditForm.searchProgramId}'){
						sel = "selected='selected'";
					}
					result += "<option value='" + cd_nm +"' "+sel+">"+ cd_des + '</option>';
				}
			}
			$('#searcProgramId').html('');
			$('#searcProgramId').html(result);
		});
	}

	function search(){
		if( ! isValidDateValue() )
			return;

		var frm = document.forms['lform'];
		frm.action = '<c:url value="/audit/adminAudit/adminAuditList.lin" />';
		frm.submit();
		showModal();
	}

	function openPopup(seq){
		if(seq == null){
			alert('상세보기 버튼이 정상적으로 선택되지 않았습니다.');
			return;
		}
		var url = "<c:url value="/audit/adminAudit/adminAuditPopup.lin" />?seq="+seq;
		var attibute = "width=500, height=800, directories=no, resizable=yes, scrollbars=yes, top=5, left=5, toolbar=no";
		var popupWindow = window.open(url, "popup", attibute);
		popupWindow.focus();
	}
	
	function download(){
		if( ! isValidDateValue() )
			return;

		var frm = document.forms['lform'];
		frm.action = '<c:url value="/audit/adminAudit/adminAuditExcelDownload.lin" />';
		frm.submit();
		
		frm.action ="<c:url value="/audit/adminAudit/adminAuditList.lin" />";
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
	<input id="page" name="page" type="hidden"/>
	<input id="menu_id" name="menu_id" type="hidden"/>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">관리자 변경 이력</h2>
				<p class="breadCrumbs">로그관리 > 관리자 변경 이력</p>
			</div>
		</div>
			<div class="conWrap">
				<h3>검색조건</h3>
				<div class="conBox searchBox t_center">
				<div class="topCon nBorder">
					<table cellspacing="0" cellpadding="0" summary="정책 검색조건" style="table-layout : fixed" >
					<caption>검색조건, 버튼</caption>
						<tbody>
							<colgroup>
								<col style="width:100%;"/>
							</colgroup>
							<tr>
								<td class="t_center" id="searchValue">
									<jsp:include page="/WebUI/include/date_input.jsp">
										<jsp:param name="s_day" value="${adminAuditForm.startDay}"/>
										<jsp:param name="s_hour" value="${adminAuditForm.startHour}"/>
										<jsp:param name="s_min" value="${adminAuditForm.startMin}"/>
										<jsp:param name="e_day" value="${adminAuditForm.endDay}"/>
										<jsp:param name="e_hour" value="${adminAuditForm.endHour}"/>
										<jsp:param name="e_min" value="${adminAuditForm.endMin}"/>
									</jsp:include>
									&nbsp;
									항목명
									<select title="메뉴명" id="searchMenuId" name="searchMenuId" onchange="select_menu(this);">
										<option value="all">전체</option>
										<c:choose>
											<c:when test="${not empty adminAuditForm.searchMenuId}">
												<c:forEach items="${menuCodeList}" var="menuCodeList">
													<c:choose>
														<c:when test="${adminAuditForm.searchMenuId eq menuCodeList.cd_cate}">
															<option value='${menuCodeList.cd_cate}' selected='selected'>${menuCodeList.cd_cate_nm}</option>
														</c:when>
														<c:otherwise>
															<option value='${menuCodeList.cd_cate}'>${menuCodeList.cd_cate_nm}</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<c:forEach items="${menuCodeList}" var="menuCodeList" varStatus="status">
													<option value='${menuCodeList.cd_cate}'>${menuCodeList.cd_cate_nm}</option>
												</c:forEach>
											</c:otherwise>
										</c:choose>
									</select>
										&nbsp;	
										프로그램명											
										<select title="프로그램 검색조건" id="searcProgramId" name="searchProgramId">
											<option value="all">전체</option>
											<c:choose>
												<c:when test="${not empty adminAuditForm.searchProgramId}">
													<c:forEach items="${programCodeList}" var="programCodeList">
														<c:choose>
															<c:when test="${adminAuditForm.searchProgramId eq programCodeList.cd_nm}">
																<option value='${programCodeList.cd_nm}' selected='selected'>${programCodeList.cd_des}</option>
															</c:when>
															<c:otherwise>
																<option value='${programCodeList.cd_nm}'>${programCodeList.cd_des}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</c:when>
												<c:otherwise>
													<c:forEach items="${programCodeList}" var="programCodeList" varStatus="status">
														<option value='${programCodeList.cd_nm}'>${programCodeList.cd_des}</option>
													</c:forEach>
												</c:otherwise>
											</c:choose>
										</select>								
									<button type="button" class="btn_common theme" onclick="search();">조회</button>
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
			<div class="conWrap">
				<h3>목록</h3>
				<div class="conBox">
					<div class="table_area_style01 hoverTable">
						<table cellspacing="0" cellpadding="0" summary="연계정책목록" style="table-layout : fixed" class="mg_t5">
						<caption>프로그램명,성공여부,이력내용,일시,상세</caption>
						<colgroup>
							<col style="width:10%;"/>
							<col style="width:40%;" />
							<col style="width:7%;" />
							<col style="width:15%;" />
							<col style="width:8%;" />
							<col style="width:10%;" />
						</colgroup>
							<thead>
								<tr>
									<th class="Rborder">프로그램명</th>
									<th class="Rborder">이력내용</th>
									<th class="Rborder">성공여부</th>
									<th class="Rborder">일시</th>
									<th class="Rborder">관리자ID</th>
									<th>상세</th>
								</tr>
							</thead>
							<tbody>
							<c:choose>
								<c:when test="${not empty adminAuditFormList}">
									<c:forEach items="${adminAuditFormList}" var="adminAuditFormList">
										<tr>
											<td class="t_center Rborder">
												<c:out value="${customfunc:getAdminAuditCodeDes(adminAuditForm.system_cd,adminAuditFormList.log_code)}" />
											</td>
											<td class="Rborder" style="padding-left: 15px;">
												<c:out value="${adminAuditFormList.log_text}" />
											</td>
											<td class="t_center Rborder">
												<c:choose>
													<c:when test="${adminAuditFormList.suc_yn eq 'Y'}">
														성공
													</c:when>
													<c:otherwise>
														실패
													</c:otherwise>
												</c:choose>
											</td>
											<td class="t_center Rborder">
												<fmt:formatDate value="${adminAuditFormList.crt_date}" pattern="yyyy-MM-dd HH:mm" />
											</td>
											<td class="t_center Rborder">
												<c:out value="${adminAuditFormList.crt_id}" />
											</td>
											<td class="t_center Rborder">
												<c:if test="${adminAuditFormList.suc_yn eq 'Y'}" >
													<c:if test="${adminAuditFormList.button_yn eq 'Y'}">
														<button class="btn_small" onclick="openPopup('${adminAuditFormList.seq}')">상세보기</button>
													</c:if>
												</c:if>
											</td>
										</tr>
									</c:forEach>
								</c:when>	
								<c:otherwise>
									<tr>
										<td class="t_center" colspan="6"><div class="no_result">결과가 없습니다.</div></td>
									</tr>
								</c:otherwise>
								</c:choose>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="6" class="td_last">
										<span class="text_list_number">
											<spring:message code="global.script.search.count" arguments="${paging.totalCount}" />
										</span>
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
