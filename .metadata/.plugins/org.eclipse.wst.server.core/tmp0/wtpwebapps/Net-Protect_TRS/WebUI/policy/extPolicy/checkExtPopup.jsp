<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<script type="text/javascript" src="<c:url value="/JavaScript/webtoolkit.base64.js" />"></script>
<script type="text/javascript">
	function checkMimeType() {
		var frm = document.forms['lform'];
		
		if(window.ActiveXObject){
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			var filepath = document.getElementById('myfile').value; 
			var thefile = fso.getFile(filepath);
			sizeinbytes = thefile.size;
		}else{
			sizeinbytes = document.getElementById('myfile').files[0].size;
		}

		var fSExt = new Array('Bytes', 'KB', 'MB', 'GB');
		var fSize = sizeinbytes;
		var i=0;
		while(fSize>900){
			fSize/=1024;
			i++;
		}
		fSize = (Math.round(fSize*100)/100); 
		
		if(fSExt[i] != "GB"){
			if(fSExt[i] == "Bytes" && fSize == 0){
				alert("파일크기가 0Bytes이므로 검사할 수 없습니다. \n0Bytes 보다 큰 파일로 검사를 진행하시기 바랍니다.");
				return false;
			}else if(fSExt[i] == "MB" && fSize > 10){
				alert("파일크기가 10MB를 초과하므로 검사할 수 없습니다. \n10MB이하 파일로 검사를 진행하시기 바랍니다.");
				return false;
			}
		}else{
			alert("파일크기가 10MB를 초과하므로 검사할 수 없습니다. \n10MB이하 파일로 검사를 진행하시기 바랍니다.");
			return false;
		}		
		
		frm.enctype = "multipart/form-data";
		frm.action = "<c:url value="/policy/extPolicy/checkMimeType.lin" />";
		frm.submit();
	}

	function initialize() {
		parent.document.location.replace(parent.document.location.href);
	}

	function insertData() {
		var requestURL = "<c:url value="/policy/extPolicy/insertExt.lin" />";

		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			if (code == "200") {
				alert(message);
			} else {
				if( message ){
					alert(message);
				}
			}
			window.close();
			location.reload();
		});
	}

	function cancel() {
		window.close();
	}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" action="" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="exts" name="exts" value="${param.exts}">
<input type="hidden" id="mime_type" name="mime_type" value="${param.mime_type}">
<c:set var="mime_type" value="${fn:substring(param.mime_type, 0, 4)}"/>
	<div class="wrap">
		<div class="popWrap">
			<h3>MimeType 검사</h3>
			<div class="conBox">
				<div class="popCon">
					<div class="table_area_style02 mg_t20 mg_b10">
						<div class="table_area_topCon mg_b10">
							<input type="file" class="f_left" id="myfile" name="myfile" />
							<button type="button" class="btn_common theme f_right" onclick="checkMimeType()">MimeType검사</button>
						</div>
						<table id="checkMimeTypeTable" summary="시험정보" style="table-layout : fixed; border:1px solid #ddd; ">
						<caption>시험명,시험위치,시험분류,시험항목,성공코드,Note</caption>
							<colgroup>
								<col style="width:20%;">
								<col style="width:60%;">
								<col style="width:20%;">
							</colgroup>
							<thead>
								<tr>
									<th class="Rborder">확장자</th>
									<th class="Rborder">Mime_Type</th>
									<th>비고</th>
								</tr>
							</thead>
							<tbody>
							<c:choose>
								<c:when test="${not empty param.exts}">
									<tr>
										<td class="Rborder t_center">${param.exts}</td>
										<td class="Rborder t_center">
											<c:if test="${param.mime_type eq 'ENCRYT'}">암호화 파일은 검사 할 수 없습니다.</c:if>
											<c:if test="${mime_type eq 'FAIL' or param.mime_type eq '' or param.mime_type eq null}">마임타입 검출 불가 파일입니다.</c:if>
											<c:if test="${param.mime_type ne 'ENCRYT' and mime_type ne 'FAIL' and param.mime_type ne '' and param.mime_type ne null}">${param.mime_type}</c:if>
										</td>
										<c:choose>
											<c:when test="${'Y' eq param.existYN}">
												<td class="t_center">존재</td>
											</c:when>
											<c:otherwise> 
												<td class="t_center"><c:if test="${param.mime_type ne 'ENCRYT' and mime_type ne 'FAIL' and param.mime_type ne '' and param.mime_type ne null}">추가가능</c:if></td>
											</c:otherwise>
										</c:choose>
									</tr>
								</c:when>
								<c:otherwise>
									<tr>
										<td class="t_center" colspan="3">
											<div class="no_result" style="padding:10px">
												<spring:message code="global.script.search.no.result" />
											</div>
										</td>
									</tr>
								</c:otherwise>
							</c:choose>
							</tbody>
						</table>
					</div>
				<div class="btn_area_center mg_b10">
					<button type="button" class="btn_common theme mg_r5" onclick="initialize()">초기화</button>
					<c:if test="${'Y' ne param.existYN and param.mime_type ne 'ENCRYT' and mime_type ne 'FAIL' and param.mime_type ne '' and param.mime_type ne null and not empty param.exts}">
						<button type="button" class="btn_common theme mg_r5" onclick="insertData()">추가</button>
					</c:if>
					<button type="button" class="btn_common theme" onclick="cancel()">취소</button>
				</div>
				</div>
			</div>
		</div>
	</div>
</form>
 <font color="red" style="padding-left: 10px;">※10MB이하 파일로 검사를 진행하세요.</font>
</body>
</html>
