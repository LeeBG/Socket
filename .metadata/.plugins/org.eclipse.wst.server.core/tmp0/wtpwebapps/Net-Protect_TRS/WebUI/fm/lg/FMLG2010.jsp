<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<html>
<head>
<script type="text/javascript" src="<c:url value="/JavaScript/module/file.js?v=221104" />"></script>
<script type="text/javascript">
	var file_manager = new NPFileTransManager();
</script>
<style>
.cm_view::-webkit-scrollbar-corner{background-color: black;}
.cm_view::-webkit-scrollbar{width:3px;}
.cm_view::-webkit-scrollbar-thumb{background-color: rgba(0, 0, 0, 0.2);}
</style>
</head>
<body>
<form id="lform" name="lform" method="post" action="" onSubmit="return false;">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="clipboard_seq" name="clipboard_seq" value="${clipboardForm.clipboard_seq}" />
<input type="hidden" id="io_cd" name="io_cd" value="${clipboardForm.io_cd}" />
<fieldset>
<div class="wrap" id="fmlg2010">
	<div class="popWrap">
	<h3>클립보드 이력 상세보기</h3>
	<div class="conBox">
		<div class="data_detail_box">
			<dl>
				<dt><spring:message code="data.dataView.data.title" /> : </dt>
				<dd class="t_left"><c:out value="${clipboardForm.title}" /></dd>
			</dl>
			<dl>
				<dt>사용자 : </dt>
				<dd>${clipboardForm.users_nm}(${clipboardForm.users_id})</dd>
			</dl>
			<dl>
				<dt><spring:message code="data.dataView.data.requestDate" /> : </dt>
				<dd><fmt:formatDate value="${clipboardForm.crt_time}" pattern="yyyy-MM-dd HH:mm" /></dd>
			</dl>
			<dl class="last_item div_fmlg001">
				<dt class="last_item blind">첨부파일</dt>
				<dd class="last_item">
					<div class="d_table" style="width:100%;">
						<c:if test="${clipboardForm.io_cd eq 'O' && clipboardForm.status ne 'SS' }">
							<div class="d_tablecell va_bottom text_color_r" style="width:60%;">※ ${OUTER}의 전송완료되지 않은 파일은 다운로드 불가합니다.</div>
						</c:if>
					</div>
					<table class="thBox mg_t10 layout_fixed" style="overflow:visible;">
						<tr>
							<th class="fileName c_name border_l"><spring:message code="data.file.fileSendComplete.list.file.name" /></th> 
							<th class="fileVolume c_size border_l"><spring:message code="data.file.fileSendComplete.list.file.size" /></th>
						</tr>
					</table>
					<div class="scrollBox">
						<table class="layout_fixed" cellspacing="0" cellpadding="0" border="0">
							<caption>제목, 전송일, 첨부파일</caption>
							<tbody>
							<c:set var="isCanDownloadState" value="${clipboardForm.io_cd eq 'I' || clipboardForm.status eq 'SS'}"/>
							<c:set var="delYn" value="${clipboardForm.in_del_yn }"/>
							<tr>
								<td class="c_name name_ellipsis ">
									<span class="title_filename">
										<c:choose>
											<c:when test="${isCanDownloadState && delYn eq 'N'}">
												<a id="download" onclick="file_manager.downloadClipboard('${clipboardForm.io_cd}', '${clipboardForm.clipboard_seq }');"><c:out value="${clipboardForm.file_nm}" /></a>
											</c:when>
											<c:otherwise>
												<c:out value="${clipboardForm.file_nm}" />  
											</c:otherwise>
										</c:choose>
									</span>
								</td>
								<td class="c_size">
									<c:choose>
										<c:when test="${delYn eq 'Y'}">
											<c:set var="isCanDownloadState" value="N"/>
											삭제
										</c:when>
										<c:otherwise>
											${customfunc:BigFileSizeFormat(clipboardForm.file_size)}
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
							</tbody>
						</table>
					</div>
				</dd>
			</dl>
		</div>
		<div class="btn_area_center mg_b15 mg_t5">
			<c:if test="${isCanDownloadState}">
				<button type="button" class="btn_big theme mg_r5" id="btnDownload" name="btnDownload" onclick="file_manager.downloadClipboard('${clipboardForm.io_cd}', '${clipboardForm.clipboard_seq }');">
					<span class="text">&nbsp;다운로드&nbsp;</span>
					<img class="down_loading_img" alt="다운로드로딩바" src="/Images/fileUpload/loading.gif">
				</button>
			</c:if>
			<button type="button" class="btn_big" onclick="window.close();">닫기</button>
		</div>
	</div>
	</div>
</div>
</fieldset>
</form>
</body>
</html>
