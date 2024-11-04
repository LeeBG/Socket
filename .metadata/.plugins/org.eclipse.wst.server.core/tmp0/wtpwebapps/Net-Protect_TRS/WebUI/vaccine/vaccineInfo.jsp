<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<style>
.loading-layer {
    display: block;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(68, 68, 68, 0.3);
    z-index: 11111;
}
.loading-layer .loading-wrap {
    display: table;
    width: 100%;
    height: 100%;
}
.loading-layer .loading-wrap .loading-text {
    display: table-cell;
    vertical-align: middle;
    text-align: center;
    color: #fff;
    text-shadow: 2px 3px 2.6px #a2a2a2;
    font-size: 3.8em;
    position: relative;
    top: -20px;
}
.loading-layer.active-loading .loading-wrap .loading-text span:nth-child(1) {
  animation: loading-01 0.82s infinite;
}
.loading-layer.active-loading .loading-wrap .loading-text span:nth-child(2) {
  animation: loading-02 0.82s infinite;
}
.loading-layer.active-loading .loading-wrap .loading-text span:nth-child(3) {
  animation: loading-03 0.82s infinite;
}

</style>
<html>
<head>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.form.js" />"></script>
<%@include file="/WebUI/include/module_file_resource.jsp" %> <%-- binary.js와 file.js를 import함 --%>
<%@include file="/WebUI/include/script_variables.jsp" %> <%-- 환경 정보를 가져와 env객체에 초기화 --%>
<script type="text/javascript">
var file_manager = new NPFileTransManager();

	bindEventOnSearchDateInput();

	function search() {
		var errmsg = new cls_errmsg();

		try {
			checkDateValidation();
		} catch (e) {
			errmsg.append(null,e);
		}
		
		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		$("#lform").get(0).submit();
	}
	
	function moduleUpdate( fileManager ){
		if ($("#vc_category").val() == 0) {
			alert("백신 종류를 위에서 선택해주세요.(VirusChaser/ClamAV)");
			return; 
		}
		clickInputFiles();

		function clickInputFiles( fileManager ){
			var fileinput = $("<input type='file' multiple>");
			fileinput.on('change',function(e){
				addVcFile ( fileManager, $(this)[0].files );
			});

			fileinput.click();

		}

		function addVcFile ( fileManager , file ) {
			var file_server_connector = null;
			var file = file[0];
			var interval;
			var try_count = 0;
			var file_ext = getFileExtension( file.name );
			if (file_ext != 'tar') { 
				alert('업데이트 할 수 없는 파일이 있습니다.\n확장자가 tar형식이어야 합니다 파일을 확인해주세요.\n[파일목록]\n'+file.name);
				return;
			}

			if (confirm("백신업데이트를 진행 하시겠습니까?")) {
				isloading.start();
				if( file_manager.init() ){
					file_manager.upload(file);
				}
			} else {
				return;
			}

			function getFileExtension( filename ) {
				if( filename.indexOf('.') == -1 ) return '';
				return filename.substring( filename.lastIndexOf('.')+1 , filename.length).toLowerCase();
			}
		}
	}

	$(function(){
		$("#vc_category").change(function(){
			search();
		});
		
		var inner_vc_use_yn = "${inner_vc_use_yn}";

		if (inner_vc_use_yn === 'Y') {
			$('#networkPosition_In').prop('checked', true);
		} else {
			$('#networkPosition_Out').prop('checked', true);
		}
	});
	
	isloading = {
			start : function() {
				console.log('loading start..');
				if (document.getElementById('wfLoading')) {
					return;
				}
				var ele = document.createElement('div');
				ele.setAttribute('id', 'wfLoading');
				ele.className = "loading-layer";
				ele.innerHTML = '<span class="loading-wrap"><span class="loading-text"><span><MARQUEE style="width:150px;height:40px;font-size:30px;padding-top:20px;" behavior="scroll" direction="RIGHT">Loading</MARQUEE></span></span></span>';
				
				$("body").append(ele);
				
				// Animation
				name = "active-loading";
				arr = ele.className.split(" ");
				if (jQuery.inArray('indexOf',arr) == -1) {	//change reson : IE8, IE9
					ele.className += " " + name;
				}
			},
			stop : function() {
				var ele = $('#wfLoading');
				if (ele) {
					ele.remove();
				}
			}
		}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/vaccine/vaccineInfo.lin"/>">
<input type="hidden" id="page" name="page"/>
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" name="jsonfileList" id="jsonfileList" value=""/>
<input type="hidden" name="jsonLastfileList" id="jsonLastfileList" value=""/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">백신 정보</h2>
				<p class="breadCrumbs">시스템 관리 > 백신 정보</p>
			</div>
		</div>
 		<div class="conWrap viewBox">
			<h3>현재 백신 정보</h3>
			<div class="conBox">
				<div class="table_area_style02">
					<table summary="기본 설정 테이블입니다.">
					<caption>name, version, updateTime</caption>
						<colgroup>
							<col style="width:18%;" />
						</colgroup>
						<tbody>
							<tr>
								<th class="t_left">Name</th>
								<td colspan="3">
								<c:choose>
								<c:when test="${customfunc:cacheString('multiVCUseYN') eq 'Y'}">
									<select name="vc_category" id=vc_category>
										<option id="vc_category0" value="0" ${vc_category == 0 ? ' selected' : ''}>All</option>
										<option id="vc_category1" value="1" ${vc_category == 1 ? ' selected' : ''}>Virus Chaser</option>
										<option id="vc_category2" value="2" ${vc_category == 2 ? ' selected' : ''}>Clam AV</option>
									</select>
								</c:when>
								<c:otherwise>
									Virus Chaser
								</c:otherwise>
								</c:choose>
								</td>
							</tr>
							<tr>
								<c:choose>
									<c:when test="${fn:length(vaccineCurrentInfo) > 1}">
										<th class="t_left">Virus Chaser Version</th>
										<td class="t_left" >
										<c:out value="${vaccineCurrentInfo.get(0).vc_version}" />
										<th width="18%">Clam AV Version</th>
										<td><c:out value="${vaccineCurrentInfo.get(1).vc_version}" /></td>
									</c:when>
									<c:when test="${fn:length(vaccineCurrentInfo) == 1}">
										<th class="t_left">Version</th>
										<td class="t_left" >
										<c:out value="${vaccineCurrentInfo.get(0).vc_version}" />
										</td>
									</c:when>
									<c:otherwise>
										<th class="t_left">Version</th>
										<td class="t_left" ></td>
									</c:otherwise>
								</c:choose>
								<!-- 7.67114 -->
							</tr>
							<tr>
								<c:choose>
									<c:when test="${fn:length(vaccineCurrentInfo) > 1}">
										<th class="t_left">Virus Chaser Update Time</th>
										<td class="t_left" >
										<fmt:formatDate value="${vaccineCurrentInfo.get(0).crt_time}" pattern="yyyy-MM-dd HH:mm"/>
										<th width="18%">Clam AV Update Time</th>
										<td><fmt:formatDate value="${vaccineCurrentInfo.get(1).crt_time}" pattern="yyyy-MM-dd HH:mm"/></td>
									</c:when>
									<c:when test="${fn:length(vaccineCurrentInfo) == 1}">
										<th class="t_left">Update Time</th>
										<td class="t_left" >
										<fmt:formatDate value="${vaccineCurrentInfo.get(0).crt_time}" pattern="yyyy-MM-dd HH:mm" />
									</c:when>
									<c:otherwise>
										<th class="t_left">Update Time</th>
										<td class="t_left" ></td>
									</c:otherwise>
								</c:choose>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>백신 수동 업데이트</h3>
			<div class="conBox">
				<div class="table_area_style02">
					<table summary="기본 설정 테이블입니다.">
					<caption>name, version, updateTime</caption>
						<colgroup>
							<col style="width:18%;" />
						</colgroup>
						<tbody>
							<tr>
								<th class="t_left">백신 수동 업데이트</th>
								<td>
									<button class="btn_common theme" onClick="moduleUpdate( file_manager )">수동 업데이트 파일업로드</button>
									<c:if test="${inner_vc_use_yn eq 'Y'}">
										<input type="radio" class="vc_networkPosition in" id="networkPosition_In" name="networkPosition" value="I" checked/>
										<label for="networkPosition_In">${INNER}</label>
									</c:if>
									<input type="radio" class="vc_networkPosition out" id="networkPosition_Out" name="networkPosition" value="O" />
									<label for="networkPosition_Out">${OUTER}</label>
									<br/><br/>
									<span class="vc_comment">※ 수동 업데이트 버튼 클릭 후 파일 선택을 하시면 백신 업데이트가 진행됩니다. 파일형식은 tar 파일만 지원합니다.</span>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
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
										<jsp:param name="s_day" value="${vaccineInfoForm.startDay}"/>
										<jsp:param name="s_hour" value="${vaccineInfoForm.startHour}"/>
										<jsp:param name="s_min" value="${vaccineInfoForm.startMin}"/>
										<jsp:param name="e_day" value="${vaccineInfoForm.endDay}"/>
										<jsp:param name="e_hour" value="${vaccineInfoForm.endHour}"/>
										<jsp:param name="e_min" value="${vaccineInfoForm.endMin}"/>
									</jsp:include>
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
					<table summary="자료 수신함" style="table-layout : fixed">
					<caption>파일명,탐지명,사용자,전송시간</caption>
						<colgroup>
							<col style="width:33%;" />
							<col style="width:33%;" />
							<col style="width:34%;" />
							<col style="width:34%;" />
							<col style="width:34%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder">Name</th>
								<th class="Rborder">Version</th>
								<th class="Rborder">Update Time</th>
								<th class="Rborder">Update server Ip</th>
								<th class="Rborder">Update status</th>
							</tr>
						</thead>
						<tbody>
						<c:choose>
						<c:when test="${not empty vaccineInfoList}">
							<c:forEach items="${vaccineInfoList}" var="vaccineInfo">
							<tr onclick="view('${vaccineInfo.vc_info_seq}')">
								<td class="t_center Rborder">
								<c:if test="${vaccineInfo.vc_category eq 1 }">
									Virus Chaser
								</c:if>
								<c:if test="${vaccineInfo.vc_category eq 2 }">
									ClamAV
								</c:if>
								</td>
								<td class="t_center Rborder"><c:out value="${vaccineInfo.vc_version}"/></td>
								<td class="t_center Rborder" >
									<fmt:formatDate value="${vaccineInfo.crt_time}" pattern="yyyy-MM-dd HH:mm" />
								</td>
								<td class="t_center Rborder"><c:out value="${vaccineInfo.server_ip}"/></td>
								<c:choose>
									<c:when test="${vaccineInfo.vcupdate_status eq 'Y' || vaccineInfo.vcupdate_status eq '0'}">
										<td class="t_center Rborder"><c:out value="성공"/></td>
									</c:when>
									<c:otherwise>
										<td class="t_center Rborder"><c:out value="실패"/></td>
									</c:otherwise>
								</c:choose>
							</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="5"><div class="no_result">결과가 없습니다.</div></td>
							</tr>
						</c:otherwise>
						</c:choose>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="5" class="td_last">
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
