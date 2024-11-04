<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<c:set var="SUCC" value="${customfunc:codeDes('RST_CD', 'S')}" />
<c:set var="FAIL" value="${customfunc:codeDes('RST_CD', 'F')}" />
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
		
		clickInputFiles();

		function clickInputFiles( fileManager ){
			var fileinput = $("<input type='file' multiple>");
			fileinput.on('change',function(e){
				addAgentFile ( fileManager, $(this)[0].files );
			});

			fileinput.click();

		}

		function addAgentFile ( fileManager , file ) {
			var file_server_connector = null;
			var file = file[0];
			var interval;
			var try_count = 0;
			var file_ext = getFileExtension( file.name );
			if (file_ext != 'tar') { 
				alert('업데이트 할 수 없는 파일이 있습니다.\n확장자가 tar형식이어야 합니다 파일을 확인해주세요.\n[파일목록]\n'+file.name);
				return;
			}

			if (confirm("에이전트 배포를 진행 하시겠습니까?")) {
				isloading.start();
				if( file_manager.init() ){
					file_manager.upload(file, true);
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
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/systemManagement/commonManagement/agentInfo.lin"/>">
<input type="hidden" id="page" name="page"/>
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" name="jsonfileList" id="jsonfileList" value=""/>
<input type="hidden" name="jsonLastfileList" id="jsonLastfileList" value=""/>
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">에이전트 정보</h2>
				<p class="breadCrumbs">시스템 관리 > 에이전트 정보</p>
			</div>
		</div>
 	<div class="conWrap viewBox">
			<h3>현재 에이전트 정보</h3>
			<div class="conBox">
				<div class="table_area_style02">
					<table summary="기본 설정 테이블입니다.">
					<caption> version, updateTime</caption>
						<colgroup>
							<col style="width:18%;" />
						</colgroup>
						<tbody>
							
							<tr>
								<th class="t_left">Version</th>
								<td class="t_left" >${agentCurrentInfo.agent_version }</td>
							</tr>
							<tr>
								<th class="t_left">Update Time</th>
								<td class="t_left" >
									<fmt:formatDate value="${agentCurrentInfo.crt_date}" pattern="yyyy-MM-dd HH:mm" />
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	<div class="conWrap viewBox">
		<h3>에이전트 수동 업데이트</h3>
		<div class="conBox">
			<div class="table_area_style02">
				<table summary="기본 설정 테이블입니다.">
				<caption>version, updateTime</caption>
					<colgroup>
						<col style="width:18%;" />
					</colgroup>
					<tbody>
						<tr>
							<th class="t_left">에이전트 수동 업데이트</th>
							<td>
								<button class="btn_common theme" onClick="moduleUpdate( file_manager )">수동 업데이트 파일업로드</button>
								<span class="vc_comment">※ 수동 업데이트 버튼 클릭 후 파일 선택을 하시면 에이전트 업데이트가 진행됩니다. 파일형식은 tar 파일만 지원합니다.</span>
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
								<jsp:param name="s_day" value="${agentInfoForm.startDay}"/>
								<jsp:param name="s_hour" value="${agentInfoForm.startHour}"/>
								<jsp:param name="s_min" value="${agentInfoForm.startMin}"/>
								<jsp:param name="e_day" value="${agentInfoForm.endDay}"/>
								<jsp:param name="e_hour" value="${agentInfoForm.endHour}"/>
								<jsp:param name="e_min" value="${agentInfoForm.endMin}"/>
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
					<colgroup>
						<col style="width:30%;" />
						<col style="width:10%;" />
						<col style="width:22%;" />
						<col style="width:22%;" />
						<col style="width:10%;" />
					</colgroup>
					<thead>
						<tr>
							<th class="Rborder">File Name</th>
							<th class="Rborder">Version</th>
							<th class="Rborder">Update Time</th>
							<th class="Rborder">Update Server IP</th>
							<th class="Rborder">상태</th>
						</tr>
					</thead>
					<tbody>
					<c:choose>
						<c:when test="${not empty agentInfoList}">
							<c:forEach items="${agentInfoList}" var="agentInfo">
								<tr>
									<td class="t_center Rborder"><c:out value="${agentInfo.agent_file_nm}"/></td>
									<td class="t_center Rborder"><c:out value="${agentInfo.agent_version}"/></td>
									<td class="t_center Rborder">
										<fmt:formatDate value="${agentInfo.crt_date}" pattern="yyyy-MM-dd HH:mm" />
									</td>
									<td class="t_center Rborder"><c:out value="${agentInfo.server_ip}"/></td>
									<td class="t_center Rborder"><c:out value="${agentInfo.status == 'S' ? SUCC : FAIL}"/></td>
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