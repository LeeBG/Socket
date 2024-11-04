<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="data_networkPosition" value="${data.networkPosition}" />
<html>
<head>
<script type="text/javascript" src="<c:url value="/JavaScript/module/file.js?v=221104" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.admin.js?v=190109" />"></script>
<script type="text/javascript">
	var data_position = '${data_networkPosition}';
	var file_manager = new NPFileTransManager();
	file_manager.isDownLoad = false;

	$(function() {
		$('input:checkbox:not(:disabled)').attr('checked','checked');
	});

	var dataJsonObj = "";
</script>
</head>
<body>
<form id="lform" name="lform" method="post" action="" onSubmit="return false;">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="email_seq" name="email_seq" value="${data.email_seq}" />
<input type="hidden" id="networkPosition" name="networkPosition" value="${data_networkPosition}" />
<input type="hidden" id="ath_ord" name="ath_ord" value="" />
<fieldset>
<div class="wrap" id="fmlg1011">
	<div class="popWrap">
	<h3>
		<c:if test="${data.attachFileType eq 'notnormal'}">위변조 및 백신이력 </c:if>
		상세보기
	</h3>
	<div class="conBox">
		<div class="data_detail_box mg_t10">
			<dl>
				<dt>메일제목  : </dt>
				<dd class="t_left"><c:out value="${data.email_subject}" /></dd>
			</dl>
			<dl>
				<dt>송신자    : </dt>
				<dd class="t_left"><c:out value="${data.sender_email}" /></dd>
			</dl>
			<dl>
				<dt>수신자    : </dt>
				<dd class="eml_view"><span><c:out value="${data.receiver_email}" /></span></dd>
			</dl>
			<dl>
				<dt>참조       : </dt>
				<dd class="eml_view"><span><c:out value="${data.cc_email == null ? '-' : data.cc_email}" /></span></dd>
			</dl>
			<dl>
				<dt>숨은참조  : </dt>
				<dd class="eml_view"><span><c:out value="${data.bcc_email == null ? '-' : data.bcc_email}" /></span></dd>
			</dl>
			<dl>
				<dt>발송완료일 : </dt>
				<dd class="t_left"><fmt:formatDate value="${data.crt_time}" pattern="yyyy-MM-dd HH:mm" /></dd>
			</dl>
			<c:choose>
				<c:when test="${data.attachFileType eq 'normal'}">
					<div class="text_color_r mg_t15 lh_20">※ 발송 건의 파일 중 정상 파일만 표시합니다.<br>※ 발송 파일 ${data.ath_file_cnt}개 중 ${data.emlFileList.size()}개가 정상 파일입니다.</div>
				</c:when>
				<c:when test="${data.attachFileType eq 'notnormal'}">
					<div class="text_color_r mg_t15 lh_20">※ 발송 건의 파일 중 비정상 파일만 표시합니다.<br>※ 발송 파일 ${data.ath_file_cnt}개 중 ${data.emlFileList.size()}개가 비정상 파일로 검출되었습니다.</div>
				</c:when>
			</c:choose>
			<dl class="last_item div_fmlg001">
				<dt class="last_item blind">첨부파일</dt>
				<dd class="last_item">
					<table class="thBox mg_t10 layout_fixed" style="overflow:visible;">
						<tr>
							<th class="fileName c_name border_l"><spring:message code="data.file.fileSendComplete.list.file.name" /></th> 
							<th class="fileVolume c_size border_l"><spring:message code="data.file.fileSendComplete.list.file.size" /></th>
						</tr>
					</table>
					<div class="scrollBox">
						<table class="layout_fixed" cellspacing="0" cellpadding="0" border="0" summary="자료전송 정보를 상세히 볼 수 있는 표입니다.">
							<caption>제목, 전송일, 첨부파일</caption>
							<tbody>
							<c:if test="${fn:length(data.emlFileList) > 0}">
								<%--  1: 클린파일 6: 백신검사 사용 안함 10: 암호화파일 --%>
								<c:forEach items="${data.emlFileList}" var="attachFile" varStatus="c">
									<c:set var="isCompressFile" value="${customfunc:isCompressFile(attachFile.file_ext)}"/>
									<c:set var="isNormalZipFile" value="false"/>
									<c:set var="fileVolume"><c:out value='${customfunc:BigFileSizeFormat(attachFile.file_size)}' /></c:set>
									<c:set var="blockStepClass" value="none"/>
									<c:set var="fileNameClass"></c:set>
									<c:set var="fileVolumeClass" value="flie_volume"/>
									<c:if test="${(1 != attachFile.vc_status && 6 != attachFile.vc_status && 13 != attachFile.vc_status)}">
										<c:set var="fileNameClass">vc_scan_status_info n${attachFile.vc_status eq 4 ? '3' : attachFile.vc_status}</c:set>
										<c:set var="fileVolumeClass">vc_scanStatusText n${attachFile.vc_status eq 4 ? '3' : attachFile.vc_status}</c:set>
										<c:set var="blockStepClass" value="block_step"/>
										<c:if test="${14 == attachFile.vc_status}">
											<c:set var="blockStepClass" value="none"/>
										</c:if>
									</c:if>
									<tr>
										<td class="c_name name_ellipsis ">
											<span class="title_filename ${fileNameClass}">
												<c:out value="${attachFile.file_nm}" />  
											</span>
											<c:if test="${ attachFile.file_block_detail_msg != null}">
												<c:set var="originalfilename" value="${attachFile.file_nm}" />
												<c:set var="lowerfilename" value="${fn:toLowerCase(originalfilename)}" />
												<c:if test="${attachFile.vc_status ne 13}">
													<c:set var="msg_span">fileBlockDetailMsg_span</c:set>
												</c:if>
												<c:if test="${attachFile.vc_status eq 13 or attachFile.vc_status eq 1 or attachFile.vc_status eq 6}">
													<c:set var="msg_span">fileBlockDetailMsg_span_ap</c:set>
												</c:if>
												<span class="${msg_span}" title="<c:out value="${attachFile.file_block_detail_msg}" />">
													<c:if test="${isCompressFile}">
														<c:choose>
														<c:when test="${attachFile.vc_status eq 3 or attachFile.vc_status eq 4}">
															<br>※&nbsp;<c:out value="${attachFile.file_block_detail_msg}" />
															<br>&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code="vaccine.file.block.detect.virus.zip.discription"/>
														</c:when>
														<c:otherwise>
																<c:choose>
																<c:when test="${fn:contains(attachFile.file_block_detail_msg, '의심') or fn:contains(attachFile.file_block_detail_msg, '암호화된') or fn:contains(attachFile.file_block_detail_msg, '스캔실패') or fn:contains(attachFile.file_block_detail_msg, '결재가')}">
																	<br>※&nbsp;<c:out value="${attachFile.file_block_detail_msg}" />	
																</c:when>
																<c:otherwise>
																	<c:choose>
																	<c:when test="${fn:contains(attachFile.file_block_detail_msg, '확장자') and fn:contains(attachFile.file_block_detail_msg, '마임타입')}">
																		<br>※&nbsp;<c:out value="${attachFile.file_block_detail_msg}" />
																	</c:when>
																	<c:otherwise>
																		<input type="hidden" id="fileNm${c.count}" name="fileNm${c.count}" value="${attachFile.file_nm}">
																		<textarea rows="10" cols="10" id="msg${c.count}" name="msg${c.count}" style="display: none;">${attachFile.file_block_detail_msg}</textarea>
																		<c:if test="${attachFile.vc_status eq 13}">
																			<br>※&nbsp;<spring:message code="data.dataView.data.file.approval.filter.zip"/>
																		</c:if>
																		<c:if test="${attachFile.vc_status ne 13 and attachFile.vc_status ne 1 and attachFile.vc_status ne 6 and attachFile.vc_status ne 14}">
																			<br>※&nbsp;<spring:message code="data.dataView.data.file.forgery.filter.zip"/>
																		</c:if>
																		<c:if test="${attachFile.vc_status eq 1 or attachFile.vc_status eq 6}">
																			<br>※&nbsp;<spring:message code="data.dataView.data.file.approval.filter.zip.encryt"/>
																		</c:if>
																		<c:if test="${attachFile.vc_status eq 14}">
																			<br>※&nbsp;<spring:message code="data.dataView.data.file.approval.filter.zip.compress"/>
																		</c:if>
																		<a href="javascript:view(${c.count})"><spring:message code="file.detailview"/></a>
																		<c:set var="isNormalZipFile" value="true"/>
																	</c:otherwise>
																	</c:choose>
																</c:otherwise>
																</c:choose>	
														</c:otherwise>
														</c:choose>
													</c:if>
													<c:if test="${ ! isCompressFile }">
														<br>※&nbsp;<c:out value="${attachFile.file_block_detail_msg}" />
													</c:if>
												</span>
											</c:if>
										</td>
										<td class="c_size ${fileVolumeClass}">
											${fileVolume}
											<c:if test="${attachFile.block_step != null}">
												<p class="${blockStepClass} ${ ( ! isCompressFile || ! isNormalZipFile ) && (attachFile.vc_status eq 11 || attachFile.vc_status eq 12) ? 'none' : ''}">
													<c:if test="${attachFile.block_step eq 'EXTENSION'}">(확장자)</c:if>
													<c:if test="${attachFile.block_step eq 'MIMETYPE'}">(마임타입)</c:if>
													<c:if test="${attachFile.block_step eq 'VIRUSCHASER'}">(VirusChaser백신)</c:if>
													<c:if test="${attachFile.block_step eq 'CLAMAV'}">(ClamAV백신)</c:if>
													<c:if test="${attachFile.block_step eq 'ETC'}">(비정상오류)</c:if>
												</p>
											</c:if>
											<c:if test="${ ( ! isCompressFile || ! isNormalZipFile ) && (attachFile.vc_status eq 11 || attachFile.vc_status eq 12) && (attachFile.file_block_detail_msg ne '암호화된 zip파일은 전송할 수 없습니다. zip 암호화를 해제 한 후 다시 전송해주세요.')}">
												<button class="gradient-btn mg_t3" onclick="addExtension('extform','${attachFile.file_ext}','${attachFile.file_block_detail_msg}');">새 확장자 추가</button>
											</c:if>
										</td>
										<c:if test="${downloadMaxCnt ne null}">
											<td class="c_download">
											<span id="download_cnt${attachFile.ath_ord}">
												${attachFile.download_cnt}</span>/<span id="download_max_cnt${attachFile.ath_ord}">${downloadMaxCnt}</span>
												<c:if test="${param.view ne 'notnormal'}"><button class="gradient-btn" onclick="resetDownloadCnt('${attachFile.ath_ord}'); this.onclick=null;">초기화</button></c:if>
											</td>
										</c:if>
									</tr>
								</c:forEach>
							</c:if>
							<c:if test="${fn:length(data.emlFileList) == 0}">
							<tr>
								<td class="t_center" colspan="6"><div class="no_result">첨부파일이 없습니다.</div></td>
							</tr>
							</c:if>
							</tbody>
						</table>
					</div>
					<div class="vc_scan_status_info_box">
						<span class="vc_scan_status_info n0">스캔 실패</span>
						<span class="vc_scan_status_info n3"><spring:message code="data.dataView.data.attachFile.scanStatus.3" /></span>
						<span class="vc_scan_status_info n10"><spring:message code="data.dataView.data.attachFile.scanStatus.10" /></span>
						<span class="vc_scan_status_info n11">위변조 파일</span>
						<span class="vc_scan_status_info n12">차단 파일</span>
						<!-- <span class="vc_scan_status_info n14">중첩압축 파일</span> -->
					</div>
				</dd>
			</dl>
		</div>
		<div class="btn_area_center mg_b15 mg_t5">
			<button type="button" class="btn_big" onclick="window.close();">닫기</button>
		</div>
	</div>
	</div>
</div>
</fieldset>
</form>
<form id="popform" name="popform" method="post">
<input type="hidden" id="fileName" name="fileName" value="" />
<input type="hidden" id="email_seq" name="email_seq" value="${data.email_seq}" />
<input type="hidden" id="networkPosition" name="networkPosition" value="${data_networkPosition}" />
<input type="hidden" id="ath_value" name="ath_ord" value="" />
<textarea id="msg" name="msg" style="display: none;"></textarea>
</form>
</body>
</html>
