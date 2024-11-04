<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<script type="text/javascript">
	bindEventOnSearchDateInput(true);

	$(document).ready(function() {
		setDateInputDivPosition();
		if ('${dataForm.searchField }' == 'file_nm') {
			$("#select_first").text($("#file_nm").text());
		}

		$("#pageLine").click(function(){
			$("#pageLineList").toggle();
		});

		$("#pageLineList > li > a").click(function(){
			$("#select_pageLine_first").text($(this).text());
		});

		$('.vcstatus_tooltip').tooltip({
			track:true,
			items : "[data-password_cnt],[data-scanfail_cnt],[data-infected_cnt],[data-filtering_cnt],[data-forgery_cnt],[data-compress_cnt],[data-dlp_cnt],[data-apt_cnt]",
			content: function(){
				$el = $(this);
				return getTooltipContent( $el );
			}
		});
		
		function getTooltipContent($el){
			var html = '';
			if( $el.attr('data-password_cnt') > 0 ){
				html += (html != '') ? '<br>' : '';
				html += '암호화파일 : '+$el.attr('data-password_cnt');
			}
			if( $el.attr('data-scanfail_cnt') > 0 ){
				html += (html != '') ? '<br>' : '';
				html += '스캔실패 : '+$el.attr('data-scanfail_cnt');
			}
			if( $el.attr('data-infected_cnt') > 0 ){
				html += (html != '') ? '<br>' : '';
				html += '바이러스파일 : '+$el.attr('data-infected_cnt');
			}
			if( $el.attr('data-filtering_cnt') > 0 ){
				html += (html != '') ? '<br>' : '';
				html += '차단파일 : '+$el.attr('data-filtering_cnt');
			}
			if( $el.attr('data-forgery_cnt') > 0 ){
				html += (html != '') ? '<br>' : '';
				html += '위변조파일 : '+$el.attr('data-forgery_cnt');
			}
			if( $el.attr('data-compress_cnt') > 0 ){
				html += (html != '') ? '<br>' : '';
				html += '중첩압축파일 : '+$el.attr('data-compress_cnt');
			}
			if( $el.attr('data-dlp_cnt') > 0 ){
				html += (html != '') ? '<br>' : '';
				html += '개인정보검출파일 : '+$el.attr('data-dlp_cnt');
			}
			if( $el.attr('data-apt_cnt') > 0 ){
				html += (html != '') ? '<br>' : '';
				html += 'APT검출파일 : '+$el.attr('data-apt_cnt');
			}
			return html;
		}
	});

	function search() {
		if( ! isValidDateValue() )
			return; 

		$("#lform").get(0).submit();
	}

	function read(sequence) {
		var url = "<c:url value="/data/file/dataView.lin" />?data_seq=" + sequence + "&networkPosition=${dataForm.networkPosition }";
		var attibute = "resizable=no,scrollbars=yes,width=800,height=700,top=5,left=5,toolbar=no,resizable=no";
		var popupWindow = window.open(url, "lincubeSendList", attibute);
		popupWindow.focus();
	}

	function del() {
		var errmsg = new cls_errmsg();

		if (!$(":checkbox[name=chk]").is(":checked")) {
			errmsg.append(null, "<spring:message code="data.file.sendList.search.script.required.delete" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		if (confirm("<spring:message code="data.file.sendList.search.script.confirm.delete" />")) {
			var requestURL = "<c:url value="/data/file/delete.lin" />";
			var successURL = "<c:url value="/data/file/receiveList.lin" />";
			resultCheck($("#lform"), requestURL, successURL, true);
		}
	}
	
	function allCheckBoxCheck(){
		var isCheckBox = true;
		$('input:checkbox[name="chk"]').each(function() {
			if(this.checked == false){
				$("#allChk").attr('checked', false);
				isCheckBox = false;
			}
		});
		
		if(isCheckBox){
			$("#allChk").attr('checked', true);
		}
	}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/data/file/receiveList.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<div class="rightArea">
<input id="page" name="page" type="hidden"/>
<input id="type" name="type" type="hidden" value="rx"/>

<div class="topWarp">
	<div class="titleBox">
		<h2 class="f_left text_bold">받은 자료</h2>
		<p class="breadCrumbs">자료송수신 &gt; 받은 자료</p>
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
							<jsp:include page="/WebUI/include/date_input_advanced.jsp">
								<jsp:param name="t_day" value="${today}"/>
								<jsp:param name="s_day" value="${dataForm.startDay}"/>
								<jsp:param name="e_day" value="${dataForm.endDay}"/>
								<jsp:param name="period" value="${period}"/>
							</jsp:include>
							<select id="searchField" name="searchField" title="목록 검색조건" class="mg_l20">
								<option value="title" ${dataForm.searchField eq 'title' ? 'selected' : ''}><spring:message code="data.file.receiveList.search.select.title" /></option>
								<option value="file_nm" ${dataForm.searchField eq 'file_nm' ? 'selected' : ''}><spring:message code="data.file.receiveList.search.select.fileName" /></option>
							</select>
							<input id="searchValue" name="searchValue" type="text" class="text_input long" style="max-width:70%;" value="${dataForm.searchValue}" placeholder="검색어를 입력해주세요." onkeydown="return keyDownEnterDoSearch();"/>
							<button class="btn_common theme" onClick="search();">검색</button>
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
			<div class="table_area_topCon mg_t10 mg_b5">
				<button type="button" class="btn_common mg_l5" onclick="del();" >삭제</button>
			</div>
			<table cellspacing="0" cellpadding="0" summary="받은자료" style="table-layout : fixed">
			<caption>삭제유무, 중요, 제목, 파일, 전송일</caption>
				<colgroup>
					<col style="width:5%;" />
					<col style="width:13%;" />
					<col style="width:36%;" />
					<col style="width:13%;" />
					<col style="width:13%;" />
				</colgroup>
				<thead>
					<tr>
						<th class="right_line"><input type="checkbox" class="input_chk" id="allChk" name="allChk" onclick="togchk(this, 'chk');"/></th>
						<th><spring:message code="data.file.sendList.list.status" /></th>
						<th><spring:message code="data.file.sendList.list.title" /></th>
						<th><spring:message code="data.file.sendList.list.file" /></th>
						<th><spring:message code="data.file.sendList.list.sendDate" /></th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty dataList}">
						<c:forEach items="${dataList}" var="data">
							<c:forEach items="${data.approvalList}" var="approval" varStatus="i">
								<c:if test="${i.last}">
									<c:set var="approval_last" value="${approval}"/>
								</c:if>
							</c:forEach>
							<c:set var="approvalWait" value="(${customfunc:getMessage('approval.list.approvalStatus.wait')})"/>	
							<tr id="tr_id_${data.data_seq}">
								<td class="right_line t_center"><input type="checkbox" class="input_chk" name="chk" id="chk" value="${data.data_seq}" onclick="allCheckBoxCheck()"/></td>
								<td class="t_center text_red" onClick="read('${data.data_seq}'); return false;">
									${customfunc:codeDes('DATA_STATUS', data.status)}
									${approval_last.app_type eq 'AF' ? approvalWait : ''}
								</td>
								<td onClick="read('${data.data_seq}'); return false;">
									<c:if test="${data.attachFileListMeta.notnormal_cnt > 0}">
										<span class="dlp_span vcstatus_tooltip"
										data-password_cnt="${data.attachFileListMeta.password_cnt}"
										data-scanfail_cnt="${data.attachFileListMeta.scanfail_cnt}"
										data-infected_cnt="${data.attachFileListMeta.infected_cnt}"
										data-approval_cnt="${data.attachFileListMeta.approval_cnt}"
										data-filtering_cnt="${data.attachFileListMeta.filtering_cnt}"
										data-forgery_cnt="${data.attachFileListMeta.forgery_cnt}"
										data-compress_cnt="${data.attachFileListMeta.compress_cnt}"
										></span>
									</c:if>
									<c:if test="${data.attachFileListMeta.dlp_cnt > 0}">
										<span class="warning_span vcstatus_tooltip"
										data-dlp_cnt="${data.attachFileListMeta.dlp_cnt }"
										></span>
									</c:if>
									<c:if test="${data.attachFileListMeta.apt_cnt > 0}">
										<span class="warning_span vcstatus_tooltip"
										data-apt_cnt="${data.attachFileListMeta.apt_cnt }"
										></span>
									</c:if>
									<c:out value="${data.title }" escapeXml="true" />
								</td>
								<td class="t_center" onClick="read('${data.data_seq}'); return false;">
									${fn:length(data.attachFileFormList)}<spring:message code="data.file.sendList.list.file.unit" />(<c:out value="${customfunc:BigFileSizeFormat(data.totalAttachFileSize)}" />)
								</td>
								<td class="t_center" onClick="read('${data.data_seq}'); return false;"><fmt:formatDate value="${data.crt_time}" pattern="yyyy-MM-dd HH:mm" /></td>
							</tr>
						</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="5"><div class="no_result"><spring:message code="global.script.search.no.result" /></div></td>
							</tr>
						</c:otherwise>
						</c:choose>
					
				</tbody>
				<tfoot>
					<tr>
						<td class="td_last t_center" colspan="5" style="background-color: #EEEEEE;">
						<jsp:include page="/WebUI/include/footer_list_count_select.jsp">
							<jsp:param name="size" value="${dataForm.pageListSize}"/>
							<jsp:param name="currentPage" value="${dataForm.currentPage}"/>
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
<iframe name="downloadFrame" id="downloadFrame" width="0%" src="about:blank" height="0" style="border-width:1px;border-color:black;border-style:solid;"></iframe>
</body>
</html>
