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
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="CUD_CD_D" value="${customfunc:codeString('CUD_CD', 'DELETE')}" />
<c:set var="is_trans_flag" value="${trans_mail_flag == null || trans_mail_flag == 'T' ? true : false}" />
								
<script type="text/javascript">
	bindEventOnSearchDateInput();
	
	$(document).ready(function() {
		selectBoxControll();

		$('#reset').click(function(){
			reset();
		});
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

	function selectBoxControll () {
		var sendr_email_select = ('${attachFileForm.searchField}' == 'sender_email') ? 'selected' : '';
		var users_nm_select = ('${attachFileForm.searchField}' == 'users_nm_select') ? 'selected' : '';
		var users_id_select = ('${attachFileForm.searchField}' == 'users_id') ? 'selected' : '';

		var radio_val = $('input[name=trans_mail]:checked').val();
		if (radio_val == 'M') {
			$("#searchField option[value='users_id']").remove();
			$("#searchField option[value='users_nm']").remove();
			$("#searchField").append('<option ' + sendr_email_select + ' value=sender_email>송신자</option>');
		}

		$("input[name='trans_mail']").change(function(){
			var trans_mail_flag = $("input[name='trans_mail']:checked").val();
			if($("input[name='trans_mail']:checked").val() == 'M'){
				changeValueTag();
				$("#searchField option[value='users_id']").remove();
				$("#searchField option[value='users_nm']").remove();
				$("#searchField").append('<option ' + sendr_email_select + ' value=sender_email>송신자</option>');
			}	
			else if($("input[name='trans_mail']:checked").val() == 'T'){
				changeValueTag();
				$("#searchField option[value='sender_email']").remove();
				$("#searchField").append('<option '+ users_nm_select +' value=users_nm>전송인</option>');
				$("#searchField").append('<option ' + users_id_select + ' value=users_id>아이디</option>');
			}
		});
	}
	
	function reset(){
		location.href = '<c:url value="/fm/lg/FMLG0600.lin" />';
	}

	function search(){
		if( ! isValidDateValue() )
			return;

		var frm = document.forms['lform'];
		frm.action = '<c:url value="/fm/lg/FMLG0600.lin" />';
		frm.submit();
		showModal();
	}
	
	function view(data_seq , searchPosition, ord){
		var networkPosition = searchPosition;
		var url = "<c:url value="/fm/lg/FMLG0010.lin" />?data_seq=" + data_seq + "&networkPosition="+networkPosition + "&ord=" + ord+"&view=notnormal" ;
		if ('${trans_mail_flag}' == 'M') url = "<c:url value="/fm/lg/FMLG1011.lin" />?email_seq=" + data_seq + "&networkPosition="+networkPosition + "&ord=" + ord+"&view=notnormal";
		var attibute = "resizable=yes,scrollbars=yes,width=800,height=800,top=5,left=5,toolbar=no";
		var popupWindow = window.open(url, "lincubeSendList", attibute);
		popupWindow.focus();
	}
	
	$(document).ready(function() {
		checkFocusMessage($("#searchValue"),"최대 100자까지 가능합니다.");
	});
	
	function download(){
		var trans_mail = '${trans_mail_flag}';
		if( ! isValidDateValue() )
			return;
		
		var frm = document.forms['lform'];
		frm.action = '<c:url value="/fm/lg/vcFileListExcelDownload.lin" />?trans_mail' + trans_mail;
		frm.submit();
		
		frm.action="<c:url value="/fm/lg/FMLG0600.lin" />";
	 }
	
	function changeValueTag(){
		var radio_val = $('input[name=trans_mail]:checked').val();
		var $vc = $('#searchVcStatus');
		var $else = $('#searchValue');
		if (radio_val == 'M' &&  $('#searchField').val() == 'users_nm') {
			$vc.removeClass('none');
			$else.addClass('none');
		} else if (radio_val == 'M' &&  $('#searchField').val() == 'users_id') {
			$vc.removeClass('none');
			$else.addClass('none');
		} else if (radio_val == 'T' && $('#searchField').val() == 'sender_email') {
			$vc.removeClass('none');
			$else.addClass('none');
		} else {
			if( $('#searchField').val() == 'vc_status'){
				$vc.removeClass('none');
				$else.addClass('none');
			}else{
				$vc.addClass('none');
				$else.removeClass('none');
			}
		}
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
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/fm/lg/FMLG0600.lin" />">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<input id="page" name="page" type="hidden" />
	<!-- contents -->
<div class="rightArea">
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold">백신이력</h2>
			<p class="breadCrumbs">로그관리 > 백신이력</p>
		</div>
	</div>
	<div class="conWrap">
	<h3>검색조건</h3>
	<div class="conBox searchBox t_center">
		<div class="topCon nBorder"  >
			<table summary="정책 검색조건" style="table-layout : fixed" >
			<caption>검색조건, 버튼</caption>
				<colgroup>
				</colgroup>
				<tbody>
					<tr>
						<td class="t_center">
							<jsp:include page="/WebUI/include/date_input.jsp">
								<jsp:param name="s_day" value="${attachFileForm.startDay}"/>
								<jsp:param name="s_hour" value="${attachFileForm.startHour}"/>
								<jsp:param name="s_min" value="${attachFileForm.startMin}"/>
								<jsp:param name="e_day" value="${attachFileForm.endDay}"/>
								<jsp:param name="e_hour" value="${attachFileForm.endHour}"/>
								<jsp:param name="e_min" value="${attachFileForm.endMin}"/>
							</jsp:include>
							<div style="display:none">
							<input type="radio" id="trans_flag" name="trans_mail" value="T" style="margin-left: 15px;" ${is_trans_flag ? ' checked' : ''}/>
							<label for="trans_flag">자료교환</label>
							<input type="radio" id="mail_flag" name="trans_mail" value="M" ${!is_trans_flag ? ' checked' : ''}/>
							<label for="mail_flag">메일연계</label>
							</div>
							<select id="searchField" name="searchField" title="목록 검색조건" class="mg_l20" onchange="changeValueTag();">
								<option ${attachFileForm.searchField eq 'vc_status' ? 'selected' : ''} value="vc_status">탐지명</option>
								<option ${attachFileForm.searchField eq 'users_nm' ? 'selected' : ''} value="users_nm">전송인</option>
								<option ${attachFileForm.searchField eq 'users_id' ? 'selected' : ''} value="users_id">${customfunc:getMessage('common.id.commonid')}</option>
							</select>
							<select id="searchVcStatus" name="searchVcStatus" class="${attachFileForm.searchField ne null && attachFileForm.searchField ne 'vc_status'?'none':'' }">
								<option value="all">전체</option>
								<c:if test="${attachFileForm.vcStatusList != null}">
									<c:forEach items="${attachFileForm.vcStatusList}" var="vcStatusList">
									<c:if test="${vcStatusList ne '4'}">
										<option value="${vcStatusList}" ${attachFileForm.searchVcStatus ne 'all' && attachFileForm.searchVcStatus eq vcStatusList ? 'selected':''}><spring:message code="data.dataView.data.attachFile.scanStatus.${vcStatusList}" /></option>
									</c:if>
									</c:forEach>
								</c:if>
							</select>
							<input id="searchValue" name="searchValue" type="text" class="text_input long ${attachFileForm.searchField eq null || attachFileForm.searchField eq 'vc_status'?'none':'' }" style="max-width:14%;" value="${attachFileForm.searchValue}" placeholder="검색어를 입력해주세요." onkeyup="onlySizeFillter(this,100)"/>
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
				<table summary="자료 수신함" style="table-layout : fixed">
				<caption>파일명,전송위치,탐지명,사용자,전송시간</caption>
					<colgroup>
						<col style="width:12%;" />
						<col style="width:12%;" />
						<col style="width:12%;" />
						<col style="width:12%;" />
						<col style="width:16%;" />
						<col style="width:12%;" />
						<c:if test="${is_trans_flag}">
							<col style="width:12%;" />
						</c:if>
						<col style="width:12%;" />
					</colgroup>
					<thead>
						<tr>
							<th class="Rborder"><spring:message code="data.th.messages.sender.${trans_mail_flag}" /></th>
							<th class="Rborder"><spring:message code="data.th.messages.user.${trans_mail_flag}" /></th>
							<th class="Rborder">부서</th>
							<th class="Rborder">탐지명</th>
							<th class="Rborder">파일명</th>
							<th class="Rborder">파일크기</th>
							<c:if test="${is_trans_flag}">
								<th class="Rborder">접속IP</th>
							</c:if>
							<th class="Rborder"><spring:message code="data.th.messages.time.${trans_mail_flag}" /></th>
						</tr>
					</thead>
					<tbody>
					<c:choose>
					<c:when test="${not empty vcAttachFileFormList}">
						<c:forEach items="${vcAttachFileFormList}" var="vcAttachFileForm">
							<tr onclick="view('${is_trans_flag ? vcAttachFileForm.data_seq : vcAttachFileForm.email_seq}','${vcAttachFileForm.np_cd}', '${vcAttachFileForm.ath_ord}')">
							<c:if test="${vcAttachFileForm.np_cd eq 'I'}"><td class="t_center Rborder">${INNER} -> ${OUTER}</td></c:if>
							<c:if test="${vcAttachFileForm.np_cd eq 'O'}"><td class="t_center Rborder">${OUTER} -> ${INNER}</td></c:if>
							<c:choose>
								<c:when test="${is_trans_flag}">
									<td class="t_center Rborder"><c:out value="${vcAttachFileForm.users_nm}(${vcAttachFileForm.crtr_id})"/></td>
								</c:when>
								<c:otherwise>
									<td class="t_center Rborder"><c:out value="${vcAttachFileForm.sender_email}"/></td>
								</c:otherwise>
							</c:choose>
							<td class="t_center Rborder"><c:out value="${vcAttachFileForm.dept_nm}"/></td>
							<td class="t_center Rborder"><c:out value="${vcAttachFileForm.virus_name}"/></td>
							<td class="t_center Rborder"><c:out value="${vcAttachFileForm.file_nm}"/></td>
							<td class="t_center Rborder"><c:out value="${customfunc:BigFileSizeFormat(vcAttachFileForm.file_size)}"/></td>
							<c:if test="${is_trans_flag}">
								<td class="t_center Rborder"><c:out value="${vcAttachFileForm.connect_ip}"/></td>
							</c:if>
							<td class="t_center Rborder" >
								<fmt:formatDate value="${vcAttachFileForm.crt_time}" pattern="yyyy-MM-dd HH:mm" />
							</td>
						</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td class="t_center" colspan="${is_trans_flag ?  8 : 7}"><div class="no_result">결과가 없습니다.</div></td>
						</tr>
					</c:otherwise>
					</c:choose>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="${is_trans_flag ?  8 : 7}" class="td_last">
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
