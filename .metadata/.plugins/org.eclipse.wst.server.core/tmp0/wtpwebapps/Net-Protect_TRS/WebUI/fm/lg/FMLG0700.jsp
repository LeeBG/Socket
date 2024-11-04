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
<c:set var="searchPosition" value="${approvalForm.searchPosition }" />
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

	function approvalChange() {
		var form = document.lform;
 		if (!$('input:checkbox[name=chk]').is(':checked')) {
			alert("변경할 이력을 선택하세요.");
			return;
		}

 		form.action = "<c:url value="/fm/lg/changeApprovalFMLG0700.lin" />";
		form.submit();
	}

	function popupview(){
		var url = "<c:url value="/fm/lg/approvalLockPopupList.lin" />";
		var attibute = "width=1000, height=800, directories=no, resizable=yes, scrollbars=yes, top=5, left=5, toolbar=no";
		var popupWindow = window.open(url, "popup", attibute);
		popupWindow.focus();
	}

	function search(){
		if( ! isValidDateValue() )
			return; 
		
		$("#searchValue").val($('#searchValueInput').val());
		$("#searchField").val($("#selectSearchField").val());
		
		var network_approval_val_split = $("#networkApprovalSearch").val().split("_");
		$("#np_cd").val(network_approval_val_split[0]);
		$("#searchPosition").val(network_approval_val_split[1]);

		$("#lform").get(0).submit();
		showModal();
	}

	$(document).ready(function() {
		checkFocusMessage($("#searchValueInput"),"최대 100자까지 가능합니다.");
	});
	
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
		<c:if test="${getSiteCode eq 'mcst' || getSiteCode eq 'museum' || getSiteCode eq 'sejong_nl'}">
		CompMessage = "(확인)";
		ACMessage = "\n승인이 불가한 항목은 확인 또는 반려 처리 됩니다.";
		</c:if>
		if( confirm(cnt + " 건에 대한 일괄승인" + CompMessage + "을 처리 하시겠습니까?" + ACMessage) ) {
			var requestURL = "<c:url value="/approval/approvalUpdateAllAllow.lin" />";
			resultCheckFunc($("#lform"), requestURL, function(response) {
				var resultMessage = response['message'];
				$("#lform").get(0).submit();
				alert(cnt + " 건에 대한 "+resultMessage);
			});
		}
	}

	function download(){
		if( ! isValidDateValue() )
			return; 
		
		$("#searchValue").val($('#searchValueInput').val());
		$("#searchField").val($("#selectSearchField").val());
		
		//netwprkApprovalSearch 값은 '{np_cd}_{searchPosition}'으로 조합되어있다.
		var network_approval_val_split = $("#networkApprovalSearch").val().split("_");
		$("#np_cd").val(network_approval_val_split[0]);
		$("#searchPosition").val(network_approval_val_split[1]);

		var frm = document.lform;
		frm.action="<c:url value="/fm/lg/UnApprovalLogCreteExcelDownload.lin" />";
		frm.submit();
		frm.action="<c:url value="/fm/lg/FMLG0700.lin" />";
	}

	function read(data_seq) {
		var network_approval_val_split = $("#networkApprovalSearch").val().split("_");
		var networkposition = network_approval_val_split[0];
		var url = "<c:url value="/fm/lg/FMLG0010.lin" />?data_seq=" + data_seq + "&networkPosition="+networkposition;
		var attibute = "resizable=no,scrollbars=yes,width=800,height=700,top=5,left=5,toolbar=no,resizable=no";
		var popupWindow = window.open(url, "lincubeApprovalView", attibute);
		popupWindow.focus();
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
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/fm/lg/FMLG0700.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input id="page" name="page" type="hidden" />
<input id="searchPosition" name="searchPosition" type="hidden" value="${approvalForm.searchPosition}" />
<input id="np_cd" name="np_cd" type="hidden" value="${approvalForm.np_cd}" />
<input id="searchValue" name="searchValue" type="hidden" value="${approvalForm.searchValue }"/>
<input id="searchField" name="searchField" type="hidden" value="${approvalForm.searchField}" />
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">결재미처리 이력</h2>
				<p class="breadCrumbs">로그관리 > 결재미처리 이력</p>
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
										<jsp:param name="s_day" value="${approvalForm.startDay}"/>
										<jsp:param name="s_hour" value="${approvalForm.startHour}"/>
										<jsp:param name="s_min" value="${approvalForm.startMin}"/>
										<jsp:param name="e_day" value="${approvalForm.endDay}"/>
										<jsp:param name="e_hour" value="${approvalForm.endHour}"/>
										<jsp:param name="e_min" value="${approvalForm.endMin}"/>
									</jsp:include>
									<select title="목록 검색조건" class="mg_l21" id="networkApprovalSearch" name="network_approval_search">
										<option value="I_AF" ${(approvalForm.np_cd eq 'I' && approvalForm.searchPosition eq 'AF')?'selected' :''} >${INNER} 사후결재</option>
										<option value="I_W" ${(approvalForm.np_cd eq 'I' && approvalForm.searchPosition eq 'W')?'selected' :''} >${INNER} 사전결재</option>
										<option value="O_AF" ${(approvalForm.np_cd eq 'O' && approvalForm.searchPosition eq 'AF')?'selected' :''} >${OUTER} 사후결재</option>
										<option value="O_W" ${(approvalForm.np_cd eq 'O' && approvalForm.searchPosition eq 'W')?'selected' :''} >${OUTER} 사전결재</option>
									</select>
									<select title="목록 검색조건2" id="selectSearchField" name="selectSearchField">
										<option <c:if test="${approvalForm.searchField eq 'appr_id'}">selected="selected"</c:if> value="appr_id">결재자 이름 및 ${customfunc:getMessage('common.id.commonid')}</option>
										<option <c:if test="${approvalForm.searchField eq 'users_id'}">selected="selected"</c:if> value="users_id">요청자 이름 및 ${customfunc:getMessage('common.id.commonid')}</option>
										<option <c:if test="${approvalForm.searchField eq 'title'}">selected="selected"</c:if> value="title">제목</option>
									</select>
									<input type="text" class="text_input long" id="searchValueInput" name="searchValueInput" value="${approvalForm.searchValue }" style="max-width:14%;" placeholder="검색어를 입력해주세요." onkeyup="onlySizeFillter(this,100)"/>
									<button class="btn_common theme" onclick="search();">조회</button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	 	<div class="t_right pd_l15 pd_r15">
	 		<c:if test="${isUnprocessedApproval eq 'Y' && loginUser.auth_cd eq 1}">
				<button type="button" id="change_btn" onclick="approvalChange()" class="btn_common theme f_left" >결재자변경</button>
			</c:if>
			<c:if test="${isUnprocessedApprovalAllow eq 'Y' && loginUser.auth_cd eq 1 && searchPosition eq 'AF'}">
				<button type="button" id="allow_btn" onclick="allAllowApproval()" class="btn_common theme f_left mg_l5">일괄승인</button>
			</c:if>
			<button type="button"  onclick="popupview()" class="btn_common theme">사후결재제한결재자목록</button>
			<button type="button"  onclick="download()" class="btn_common theme">결재미처리이력엑셀다운로드</button>
		</div>
		<div class="conWrap">
			<h3><c:choose>
					<c:when test="${approvalForm.np_cd eq 'I' && approvalForm.searchPosition eq 'W'}">
					${INNER} -> ${OUTER} 사전결재
					</c:when>
					<c:when test="${approvalForm.np_cd eq 'I' && approvalForm.searchPosition eq 'AF'}">
					${INNER} -> ${OUTER} 사후결재
					</c:when>
					<c:when test="${approvalForm.np_cd eq 'O' && approvalForm.searchPosition eq 'W'}">
					${OUTER} -> ${INNER} 사전결재
					</c:when>
					<c:otherwise>
					${OUTER} -> ${INNER} 사후결재
					</c:otherwise>
				</c:choose> 미처리 이력</h3>
			<div class="conBox">
				<div class="table_area_style01 hoverTable">
					<table cellspacing="0" cellpadding="0" summary="미승인 처리함" style="table-layout : fixed">
					<caption>요청자, 제목, 요청시간</caption>
						<colgroup>
							<c:if test="${isUnprocessedApproval eq 'Y' && loginUser.auth_cd eq 1 || isUnprocessedApprovalAllow eq 'Y' && loginUser.auth_cd eq 1 && searchPosition eq 'AF'}">
								<col style="width:3%;"/>
							</c:if>
							<col style="width:13%;" />
							<col style="width:13%;" />
							<col style="width:12%;" />
							<col style="width:30%;" />
							<col style="width:15%;" />
							<col style="width:17%;" />
						</colgroup>
						<thead>
							<tr>
								<c:if test="${isUnprocessedApproval eq 'Y' && loginUser.auth_cd eq 1 || isUnprocessedApprovalAllow eq 'Y' && loginUser.auth_cd eq 1 && searchPosition eq 'AF'}">
									<th class="Rborder"><input type="checkbox" id="chk_list" class="input_chk" onclick="togchk(this, 'chk');"/></th>
								</c:if>
								<th class="Rborder">결재자</th>
								<th class="Rborder">결재자${customfunc:getMessage('common.id.commonid')}</th>
								<th class="Rborder">결재자부서</th>
								<th class="Rborder">제목</th>
								<th class="Rborder">요청자</th>
								<th class="Rborder">전송시간</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
										<c:when test="${not empty selectApprovalList}">
											<c:forEach items="${selectApprovalList}" var="approvalForm" varStatus="status">
												<c:choose>
													<c:when test="${approvalForm.private_appr_nm ne ''}">
														<c:set value="${approvalForm.appr_nm} (대결자:${approvalForm.private_appr_nm})" var="private_appr_nm" />
													</c:when>
													<c:otherwise>
														<c:set value="${approvalForm.appr_nm}" var="private_appr_nm" />
													</c:otherwise>
												</c:choose>
												<c:choose>
													<c:when test="${approvalForm.private_appr_id ne ''}">
														<c:set value="${approvalForm.appr_id} (대결자:${approvalForm.private_appr_id})" var="private_appr_id" />
													</c:when>
													<c:otherwise>
														<c:set value="${approvalForm.appr_id}" var="private_appr_id" />
													</c:otherwise>
												</c:choose>
												
												<tr>
													<c:if test="${isUnprocessedApproval eq 'Y' && loginUser.auth_cd eq 1 || isUnprocessedApprovalAllow eq 'Y' && loginUser.auth_cd eq 1 && searchPosition eq 'AF'}">
														<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" id="chk_${approvalForm.data_seq}" name="chk" value="${approvalForm.approval_seq}"/></td>
													</c:if>
													<td class="t_center Rborder" onClick="read('${approvalForm.data_seq}'); return false;" title="<c:out value="${private_appr_nm}" />">
														<c:out value="${private_appr_nm}" />
													</td>
													<td class="t_center Rborder" onClick="read('${approvalForm.data_seq}'); return false;" title="<c:out value="${private_appr_id}" />">
														<c:out value="${private_appr_id}" />
													</td>
													<td class="t_center Rborder" onClick="read('${approvalForm.data_seq}'); return false;" title="${approvalForm.dept_nm}"><c:out value="${approvalForm.dept_nm}" /></td>
													<td class="t_center Rborder" onClick="read('${approvalForm.data_seq}'); return false;" title="${approvalForm.title}"><c:out value="${approvalForm.title}" /></td>
													<td class="t_center Rborder" onClick="read('${approvalForm.data_seq}'); return false;" title="${approvalForm.users_nm}"><c:out value="${approvalForm.users_nm}" />(<c:out value="${approvalForm.users_id}" />)</td>
													<td class="t_center Rborder" onClick="read('${approvalForm.data_seq}'); return false;" title="<fmt:formatDate value="${approvalForm.crt_time}" pattern="yyyy-MM-dd kk:mm" />"><fmt:formatDate value="${approvalForm.crt_time}" pattern="yyyy-MM-dd kk:mm" /></td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr>
												<td class="t_center" colspan="7"><div class="no_result"> 결과가 없습니다.</div></td>
											</tr>
										</c:otherwise>
									</c:choose>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="7" class="td_last">
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
