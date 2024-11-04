<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<html>
<head>

<c:set var="loginUser" value="${sessionScope.loginUser}"/>
<c:set var="filePolicy" value="${filePolicy}"/>
<c:set var="approvalPolicy" value="${loginUser.approvalPolicy}"/>
<c:set var="isApprovalUse" value="${approvalPolicy.approvalUse}"/>
<c:set var="networkPosition" value="${customfunc:getNetworkPosition()}"/>
<c:set var="appYN" value="${approvalForm.app_yn}"/>
<c:set var="getSiteCode" value="${customfunc:getSiteCode()}" />
<script type="text/javascript" src="<c:url value="/JavaScript/module/file.js?v=221104" />"></script>
<script type="text/javascript">
	var data_position = '${approvalForm.np_cd}';
	var file_manager = new NPFileTransManager();
	file_manager.isDownLoad = false;
	
	$(document).ready(function() {
		$('input:checkbox:not(:disabled)').attr('checked','checked');
	});
	
	var dataJsonObj = "";

	function grant(type){
		if (type == 'R') {
			if ('${isApprovalRejectReason}' == 'N') {
				if (confirm("반려 하겠습니까?")) {
					var data_seq = $("#data_seq").val();
					deleteKey(data_seq);
				} else {
					return;
				}
			} else {
				if (confirm("반려 하겠습니까?(반려 사유입력 필수)")) {
					var errmsg = cls_errmsg();
					if (empty($('#reason').val())) errmsg.append($('#reason').val(), "반려사유를 입력해주세요.");

					if (errmsg.haserror) {
						errmsg.show();
						return;
					}

					var data_seq = $("#data_seq").val();
					deleteKey(data_seq);
				} else {
					return;
				}
			}
		}
		
		if (type == 'AC') {
			if (confirm("이상파일 확인처리 하겠습니까?")) {
				var data_seq = $("#data_seq").val();
				deleteKey(data_seq);
			} else {
				return;
			}
		}

		$("#app_type").val(type);

		var requestURL = "<c:url value="/approval/approvalUpdate.lin" />";

		resultCheckFunc($("#lform"), requestURL, function(response) {
			var message = response['message'];
			alert(message);
			window.close();
			window.opener.approvalListRefresh();  
		});
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
	
	function deleteKey(data_seq) {
		var requestURL = "<c:url value="/data/file/deleteKey.lin" />";
		var networkPosition = '${networkPosition}'; 
		var params = {data_seq : data_seq, networkPosition : networkPosition};

		$.ajax({
			type : "post",
			url : requestURL,
			data : params,
			dataType : "json",
			error : function(xhr, status, error) {
				if (xhr.status == 401) {
					resultSessionExpire(xhr);
				} else if (xhr.status == 200) {
					resultInterceptorError(xhr);
				} else {
					console.log("error");
				}
			},
			success : function(response) {
				console.log("succ");
				/* if (successFunc != null) {
					successFunc(response);
				} */
			}
		});
	}
	
	function view(idx){
		var detail_msg = $("#msg"+idx).val();
		var file_nm = $("#fileNm"+idx).val();
		$("#msg").val(detail_msg);
		$("#fileName").val(file_nm);
		
		var leng = detail_msg.split("|");
		var plus = leng.length*30;
		var height= Number(220+plus);
		
		var windowHeight = screen.availHeight - 100;
		if(height > windowHeight){
			height = windowHeight;
		}
		var frm = document.popform;
		var url = "<c:url value="/approval/approvalZipFileBlockList.lin" />";
		var attibute = "resizable=yes,scrollbars=yes,width=1000,height="+height+",top=5,left=5,toolbar=no";
		window.open("", "viewPop", attibute);
		frm.action = url;
		frm.target = "viewPop";
		frm.method ="post";
		frm.submit();
		//popupWindow.focus();
	}	
	
	function dlpview(ath_ord){
		$("#ath_value").val(ath_ord);
		var frm = document.popform;
		var url = "<c:url value="/approval/approvalDlpFileBlockList.lin" />";
		var attibute = "resizable=yes,scrollbars=yes,width=1000,height=560,top=5,left=5,toolbar=no";
		window.open("", "viewPop", attibute);
		frm.action = url;
		frm.target = "viewPop";
		frm.method ="post";
		frm.submit();
	}
</script>
<style>
.cm_view::-webkit-scrollbar-corner{background-color: black;}
.cm_view::-webkit-scrollbar{width:3px;}
.cm_view::-webkit-scrollbar-thumb{background-color: rgba(0, 0, 0, 0.2);}
.info_box_text_red {color:red;}
</style>
</head>
<body>
<form id="lform" name="lform" method="post" action="" onSubmit="return false;">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="app_type" name="app_type" value="${approvalForm.app_type}" />
<input type="hidden" id="np_cd" name="np_cd" value="${approvalForm.np_cd}" />
<input type="hidden" id="approval_seq" name="approval_seq" value="${approvalForm.approval_seq}" />
<input type="hidden" id="app_ord" name="app_ord" value="${approvalForm.app_ord}" />
<input type="hidden" id="data_seq" name="data_seq" value="${data.data_seq}" />
<input type="hidden" id="networkPosition" name="networkPosition" value="${networkPosition}" />

<fieldset>
<div class="wrap">
	<div class="popWrap">
	<h3>상세보기</h3>
	<div class="conBox">
		<!-- 결재자 정보 시작 -->
		<c:if test="${fn:length(data.approvalList ) > 0}">
		<div id="approvalStatusBox" class="approvalStatus_box pd_b30">
			<c:forEach items="${data.approvalList}" var="approval" varStatus="i">
				<c:choose>
				<c:when test="${'N' eq approval.app_yn}">
					<c:set var="approval_status_css" value="approvalStatus_wait"/>
				</c:when>
				<c:when test="${'Y' eq approval.app_yn}">
					<c:set var="approval_status_css" value="approvalStatus_ok"/>
				</c:when>
				<c:when test="${'R' eq approval.app_type}">
					<c:set var="approval_status_css" value="approvalStatus_no"/>
					<c:set var="approvalStatus" value="R"/>
					<c:set var="rejectRsn" value="${approval.reject_rsn}"/>
				</c:when>
				</c:choose>
			<table id="findUsersTable" summary="결재자 상태테이블">
				<caption>결재자 이름, <spring:message code="common.approval.status"/>, 결재시간</caption>
					<colgroup>
						<col style="width:16%;" />
						<col style="width:30%;" />
						<col style="width:24%;" />
						<col style="width:30%;" />
					</colgroup>
					<tbody>
						<tr>
							<c:choose>
								<c:when test="${fn:length(data.approvalList) == 1}">
									<td rowspan="2" class="title">결재자</td>
								</c:when>
								<c:otherwise>
									<td rowspan="2" class="title">${i.count}차결재</td>
								</c:otherwise>
							</c:choose>
							<th>이름</th>
							<th><spring:message code="common.approval.status"/></th>
							<th>결재시간</th>
						</tr>
						<tr>
							<td>
								<c:choose>
								<c:when test="${approval.app_yn eq 'Y'}">
									<c:choose>
										<c:when test="${ not empty approval.real_appr_id and approval.appr_id ne approval.real_appr_id }">
											<c:out value="${approval.real_appr_nm} (원결재자 : ${approval.appr_nm})"/>
										</c:when>
										<c:otherwise>
											<c:out value="${approval.appr_nm}"/>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${ not empty approval.private_appr_nm }">
											<span title="${approval.private_appr_nm_title}"><c:out value="${approval.appr_nm}"/>(대결자 : <c:out value="${approval.private_appr_nm}"/>)</span>
										</c:when>
										<c:otherwise>
											<c:out value="${approval.appr_nm}"/>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${customfunc:codeString('APP_TYPE', 'PROXY') eq approval.app_type}">
									<span class="${approval_status_css}">${customfunc:codeDes("APP_TYPE", approval.app_type) } (${approval.appr_nm} 대결)</span>
									</c:when>
									<c:otherwise>
										<span class="${approval_status_css}">${customfunc:codeDes("APP_TYPE", approval.app_type) }</span>
									</c:otherwise>
								</c:choose>
							</td>
 							<td><fmt:formatDate value="${approval.app_time}" pattern="yyyy-MM-dd HH:mm" /></td>
						</tr>
					</tbody>
			</table>
			</c:forEach>
		</div>
		</c:if>
		<!-- 결재자 정보 끝 -->

		<div class="data_detail_box">
			<dl>
				<dt><spring:message code="data.dataView.data.title" /> : </dt>
				<%-- <dd class="t_left"><c:out value="${data.title}" /></dd> --%>
				<dd><a title="${data.title}" href="javascript:;">${data.title }</a></dd>
			</dl>
			<dl>
				<dt>${customfunc:getMessage('data.dataView.data.comment')} : </dt>
				<dd class="cm_view">
					<c:choose>
							<c:when test="${not empty commentList}">
							<c:forEach var="comment" items="${commentList}">
								<p>${comment}</p>
							</c:forEach>
							</c:when>
							<c:otherwise>
								없음
							</c:otherwise>
					</c:choose>
				</dd>
			</dl>
			<dl>
				<dt>사용자 : </dt>
				<dd>${approvalForm.users_nm}(${approvalForm.users_id})</dd>
			</dl>
			<%-- <dl>
				<dt>수신인 : </dt>
				<dd>${approvalForm.users_nm}(${approvalForm.users_id})</dd>
			</dl> --%>
			<dl>
				<dt><spring:message code="data.dataView.data.requestDate" /> : </dt>
				<dd><fmt:formatDate value="${data.crt_time}" pattern="yyyy-MM-dd HH:mm" /></dd>
			</dl>
			<c:choose>
				<c:when test="${'R' eq approvalForm.app_type}">
					<dl>
						<dt>반려사유 : </dt>
						<dd>
							${approvalForm.reason}
						</dd>
					</dl>
				</c:when>
				<c:when test="${'W' eq view_type && 'Y' eq isApprovalRejectReason}">
					<dl>
						<dt>반려사유 : </dt>
						<dd>
							<textarea rows="1" cols="80" id="reason" name="reason" style="height: 22px;" value="" placeholder="반려사유를 입력해주세요." /></textarea>
						</dd>
					</dl>
				</c:when>
				<c:otherwise>
					<dl>
						<dt><spring:message code="data.dataView.data.grantDate" /> : </dt>
						<dd>
							<c:choose>
								<c:when test="${empty data.rx_time}">
									-
								</c:when>
								<c:otherwise>
									<fmt:formatDate value="${data.rx_time}" pattern="yyyy-MM-dd HH:mm" />
								</c:otherwise>
							</c:choose>
						</dd>
					</dl>
				</c:otherwise>
			</c:choose>
			<dl class="last_item div_approvalview">
				<dt class="last_item blind">첨부파일</dt>
				<dd class="last_item">
					<table class="thBox mg_t10 layout_fixed">
						<tr>
							<th class="allChk c_check ${appYN eq 'Y'?'none':''}"><input type="checkbox" id="allChk" name="allChk" class="input_chk" onclick="togchk(this, 'chk');"/></th>
							<th class="fileName c_name ${appYN eq 'Y'?'l_border_none':'border_l'}"><spring:message code="data.file.fileSendComplete.list.file.name" /></th> 
							<th class="fileVolume c_size border_l"><spring:message code="data.file.fileSendComplete.list.file.size" /></th>
							<c:if test="${appYN eq 'N' && app_download_force eq 'Y'}"><th class="c_download_time border_l"><spring:message code="data.popup.filedownload_time" /></th></c:if>
						</tr>
					</table>
					<div class="scrollBox">
						<table class="layout_fixed" summary="자료전송 정보를 상세히 볼 수 있는 표입니다.">
							<caption>제목, 전송일, 첨부파일</caption>
							<tbody>
							<c:set var="file_cnt" value="0" />
							<c:set var="downloadBtnYN" value="N" />
							<c:if test="${fn:length(data.attachFileFormList) > 0}">
								<!--  1: 클린파일 6: 백신검사 사용 안함 -->
								<c:forEach items="${data.attachFileFormList}" var="attachFile" varStatus="c">
									<c:set var="isCompressFile" value="${customfunc:isCompressFile(attachFile.file_ext)}"/>
									<c:set var="delYn" value="${attachFile.isDeleted ? 'Y' : 'N' }"/>
									<c:set var="isDownloadable" value="false"/>
									<c:set var="file_cnt" value="${c.count }" />
									
									<c:if test="${attachFile.vc_status eq '4' }">
									    <c:set var="fileNameClass">vc_scan_status_info n3</c:set>
										<c:set var="fileVolumeClass">vc_scanStatusText n3</c:set>
										<c:set var="fileVolume"><spring:message code="data.dataView.data.attachFile.scanStatus.3"/></c:set>
									</c:if>
									<c:if test="${attachFile.vc_status eq '0' || attachFile.vc_status eq '3' || attachFile.vc_status eq '10' || attachFile.vc_status eq '11' || attachFile.vc_status eq '12' || attachFile.vc_status eq '14' || attachFile.vc_status eq '16'}">
									    <c:set var="fileNameClass">vc_scan_status_info n${attachFile.vc_status}</c:set>
										<c:set var="fileVolumeClass">vc_scanStatusText n${attachFile.vc_status}</c:set>
										<c:set var="fileVolume"><spring:message code="data.dataView.data.attachFile.scanStatus.${attachFile.vc_status}"/></c:set>
									</c:if>
									<c:if test="${attachFile.vc_status ne '0' && attachFile.vc_status ne '3' && attachFile.vc_status ne '4' && attachFile.vc_status ne '10' && attachFile.vc_status ne '11' && attachFile.vc_status ne '12' && attachFile.vc_status ne '14'}">
									    <c:set var="fileNameClass"></c:set>
										<c:set var="fileVolumeClass"></c:set>
										<c:set var="fileVolume"><c:out value='${customfunc:BigFileSizeFormat(attachFile.file_size)}'/></c:set>
									</c:if>
									<c:if test="${attachFile.vc_status eq '14' }">
										<c:set var="fileNameClass">vc_scan_status_info n14</c:set>
										<c:set var="fileVolumeClass">vc_scanStatusText n12</c:set>
										<c:set var="fileVolume"><spring:message code="data.dataView.data.attachFile.scanStatus.14"/></c:set>
									</c:if>
									<c:if test="${attachFile.vc_status eq '16' }">
										<c:set var="fileNameClass">vc_scan_status_info n16</c:set>
										<c:set var="fileVolumeClass">vc_scanStatusText n${attachFile.vc_status}</c:set>
										<c:set var="fileVolume"><spring:message code="data.dataView.data.attachFile.scanStatus.16"/></c:set>
									</c:if>
									<c:choose>
										<c:when test="${attachFile.dlp_status eq 1 && attachFile.send_result eq '500'}">
											<c:set var="inputStyle" value="disabled"/>
											<c:set var="blockStepClass" value="block_step"/>
										</c:when>
										<c:when test="${(attachFile.apt_status eq 1 || attachFile.apt_status eq 2 
																				|| attachFile.apt_status eq 3 || attachFile.apt_status eq 4) && attachFile.apt_send_yn eq 'N'}">
											<c:set var="inputStyle" value="disabled" />
											<c:set var="blockStepClass" value="block_step" />
										</c:when>
										<c:when test="${attachFile.isNormalFile && delYn eq 'N' && appYN eq 'N'}">
											<c:set var="inputStyle" value=""/>
											<c:set var="downloadBtnYN" value="Y" />
											<c:set var="blockStepClass" value="none"/>
											<c:set var="isDownloadable" value="true"/>
										</c:when>
										<c:when test="${attachFile.vc_status eq '14'}">
											<c:set var="inputStyle" value="disabled"/>
											<c:set var="blockStepClass" value="none"/>
										</c:when>
										<c:when test="${delYn eq 'Y'}">
											<c:set var="fileVolume"><spring:message code="data.dataView.data.attachFile.deleted"/>-${fileVolume}</c:set>
											<c:set var="inputStyle" value="disabled"/>
											<c:set var="blockStepClass" value="block_step"/>
										</c:when>
										<c:otherwise>
											<c:set var="inputStyle" value="disabled"/>
											<c:set var="blockStepClass" value="block_step"/>
										</c:otherwise>
									</c:choose>
									<tr>
										<td class="first-item c_check  ${appYN eq 'Y'?'none':''}">
											<input ${inputStyle} type="checkbox" class="input_chk" name="chk" id="chk" value="${attachFile.ath_ord}" onclick="allCheckBoxCheck()" />
										</td>
										<td class="c_name name_ellipsis">
											<span class="title_filename ${fileNameClass}">
												<c:if test="${ isDownloadable }">
													<a id="download${attachFile.ath_ord}" onclick="oneFileDownloadFromLink( '${approvalForm.np_cd}', '${data.data_seq}' , '${attachFile.ath_ord}' , '${fn:replace(attachFile.file_nm, "'", "\\'") }' ); ">
												</c:if>
													<c:out value="${attachFile.file_nm}" />
												<c:if test="${ isDownloadable }">
													</a>
												</c:if>
											</span>
										<input type="hidden" value="${attachFile.file_nm}" id="filename${attachFile.ath_ord}">
										<c:if test="${ attachFile.file_block_detail_msg != null and !fn:contains(attachFile.file_block_detail_msg, '결재완료') }">
												<c:set var="originalfilename" value="${attachFile.file_nm}" />
												<c:set var="lowerfilename" value="${fn:toLowerCase(originalfilename)}" />
												<c:if test="${attachFile.vc_status ne 13}">
													<c:set var="msg_span">fileBlockDetailMsg_span</c:set>
												</c:if>
												<c:if test="${attachFile.vc_status eq 13 or attachFile.vc_status eq 1 or attachFile.vc_status eq 6}">
													<c:set var="msg_span">fileBlockDetailMsg_span_ap</c:set>
												</c:if>
												<span class="${msg_span}" title="<c:out value="${attachFile.file_block_detail_msg}" />">
													<c:forTokens var="ext" items="${lowerfilename}" delims="." varStatus="status">
													<c:if test="${status.last}">
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
																			<c:if test="${ attachFile.vc_status ne 16 }">
																			<a href="javascript:view(${c.count})"><spring:message code="file.detailview"/></a>
																			</c:if>
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
													</c:if>
													</c:forTokens>
												</span>
										</c:if>
										<c:if test="${attachFile.dlp_status ne 0 }">
											<c:if test="${attachFile.dlp_status eq 1 }">
												<span class="dlp_StatusText">
													<br>※&nbsp;<spring:message code="data.dataView.data.dlp.block.message"/>
													<a class="dlp_DetailStatusText" href="javascript:dlpview(${attachFile.ath_ord})"><spring:message code="file.detailview"/></a>
												</span>
											</c:if>
											<c:if test="${attachFile.dlp_status eq 2 }">
												<span class="dlp_StatusText">
													<br>※&nbsp;<spring:message code="data.dataView.data.dlp.scanfail.message"/>
												</span>
											</c:if>
											<c:if test="${attachFile.dlp_status eq 3 }">
												<span class="dlp_StatusText">
													<br>※&nbsp;<spring:message code="data.dataView.data.dlp.timeout.message"/>
												</span>
											</c:if>
										</c:if>
										<c:if test="${attachFile.apt_status ne 0 }">
												<c:if test="${attachFile.apt_status eq 1 }">
													<span class="dlp_StatusText">
														<br>※&nbsp;<spring:message code="data.dataView.data.apt.block.message"/>														
													</span>
												</c:if>
												<c:if test="${attachFile.apt_status eq 2 or attachFile.apt_status eq 3}">
													<span class="dlp_StatusText">
														<br>※&nbsp;<spring:message code="data.dataView.data.apt.scanfail.message"/>
													</span>
												</c:if>
												<c:if test="${attachFile.apt_status eq 4 }">
													<span class="dlp_StatusText">
														<br>※&nbsp;<spring:message code="data.dataView.data.apt.timeout.message"/>
													</span>
												</c:if>
										</c:if>
										</td>
										<td class="c_size ${fileVolumeClass}">
											${fileVolume}
											<c:if test="${attachFile.block_step != null}">
												<p class="${blockStepClass}">
													<c:if test="${attachFile.block_step eq 'EXTENSION'}">(확장자)</c:if>
													<c:if test="${attachFile.block_step eq 'MIMETYPE'}">(마임타입)</c:if>
													<c:if test="${attachFile.block_step eq 'VIRUSCHASER'}">(VirusChaser백신)</c:if>
													<c:if test="${attachFile.block_step eq 'CLAMAV'}">(ClamAV백신)</c:if>
													<c:if test="${attachFile.block_step eq 'ETC'}">(비정상오류)</c:if>
													<c:if test="${attachFile.block_step eq 'OLE'}">(OLE검사)</c:if>
												</p>
											</c:if>
										</td>
										<c:if test="${appYN eq 'N' && app_download_force eq 'Y'}">
											<td class="c_download_time" id="download_time${attachFile.ath_ord }">
												<c:if test="${attachFile.app_download_time ne null }"><fmt:formatDate value="${attachFile.app_download_time}" pattern="yyyy-MM-dd HH:mm" /></c:if>
												<c:if test="${attachFile.app_download_time eq null }">-</c:if>
											</td>
										</c:if>
									</tr>
								</c:forEach>
							</c:if>
							</tbody>
						</table>
					</div>
					<div class="vc_scan_status_info_box">
						<span class="vc_scan_status_info n0">스캔 실패</span>
						<span class="vc_scan_status_info n3"><spring:message code="data.dataView.data.attachFile.scanStatus.3" /></span>
						<%-- <span class="vc_scan_status_info n4"><spring:message code="data.dataView.data.attachFile.scanStatus.4" /></span> --%>
						<span class="vc_scan_status_info n10"><spring:message code="data.dataView.data.attachFile.scanStatus.10" /></span>
						<span class="vc_scan_status_info n11">위변조 파일</span>
						<span class="vc_scan_status_info n12">차단 파일</span>
						<c:if test="${data.compress_yn eq 'Y'}">
							<span class="vc_scan_status_info n14">중첩압축 파일</span>
						</c:if>
					</div>
					<div class="vc_scan_status_info_box">
						<c:choose>
						<c:when test="${appYN eq 'N'}">
							<span>${customfunc:getMessage('approval.approvalView.script.info.box.text.checkbox')}</span>
							<br><span class="${getSiteCode eq 'kbcard' ? 'info_box_text_red' : ''}">${customfunc:getMessage('approval.approvalView.script.info.box.text')}</span>
						</c:when>
						<c:otherwise>
						결재자는 결재 완료된 자료를 다운로드할 수 없습니다.
						</c:otherwise>
						</c:choose>
					</div>
					<%-- <div class="vc_scan_status_info_box">
						<spring:message code="data.dataView.script.policy.file" />
					</div> --%>
				</dd>
			</dl>
		</div>
		<div class="btn_area_center mg_b15 mg_t5">
		<c:set var="isNormalFile" value="${data.isNormalFile}" />
		<c:set var="AbnormalFileSendFailTotalYn" value="${AbnormalFileSendFailTotalYn}" />
		<c:choose>
			<c:when test="${data.onlyDownloadBtn}">
				<c:set var="none_css" value="none" />
			</c:when>
			<c:otherwise>
				<c:set var="none_css" value="" />
			</c:otherwise>
		</c:choose>
		<c:if test="${'N' eq approvalForm.app_yn}" >
			<c:choose>
				<%-- 전부 이상파일 포함일 경우 기존 로직 태움. --%>
				<c:when test="${AbnormalFileSendFailTotalYn eq 'Y'}">
					<c:choose>
						<c:when test="${downloadBtnYN eq 'Y' }">
							<button type="button" class="btn_big theme mg_r5" id="btnDownload" name="btnDownload"
							onclick="downloadFromLink('input[name=chk]:checked');"><span class="text">&nbsp;다운로드&nbsp;</span><img class="down_loading_img" alt="다운로드로딩바" src="/Images/fileUpload/loading.gif"></button>
							<button type="button" id="app_btn" class="btn_big theme mg_r5 ${none_css}" onclick="grant('Y'); this.onclick=null;">승인</button>
						</c:when>
						<c:otherwise>
							<c:if test="${approvalForm.app_type eq 'AF'}"><%-- 사후승인이면서 다운로드 버튼이 없을 때, --%>
								<button type="button" class="btn_big theme mg_r5" onclick="grant('AC'); this.onclick=null;">확인하고 이력함으로 이동</button>
							</c:if>
						</c:otherwise>
					</c:choose>
					<c:if test="${approvalForm.app_type ne 'AF' || isAfterApprovalRejectYn eq 'Y'}"><%-- 사후승인이 아닐때 만 --%>
						<button type="button" id="rj_btn" class="btn_big theme mg_r5 ${none_css}" onclick="grant('R');">반려</button>
					</c:if>
				</c:when>
				<%-- 1개라도 이상파일 포함일 경우 --%>
				<c:otherwise>
					<c:if test="${downloadBtnYN eq 'Y' }">
						<button type="button" class="btn_big theme mg_r5" id="btnDownload" name="btnDownload"
						onclick="downloadFromLink('input[name=chk]:checked');"><span class="text">&nbsp;다운로드&nbsp;</span><img class="down_loading_img" alt="다운로드로딩바" src="/Images/fileUpload/loading.gif"></button>
						<c:if test="${isNormalFile}">
							<button type="button" id="app_btn" class="btn_big theme mg_r5 ${none_css}" onclick="grant('Y'); this.onclick=null;">승인</button>
						</c:if>
					</c:if>
					<c:if test="${approvalForm.app_type eq 'AF' && !isNormalFile}"><%-- 사후승인이면서 이상파일이 포함되어 있을경우, --%>
						<button type="button" class="btn_big theme mg_r5" onclick="grant('AC'); this.onclick=null;">확인하고 이력함으로 이동</button>
					</c:if>
					<c:if test="${approvalForm.app_type ne 'AF' || isAfterApprovalRejectYn eq 'Y'}"><%-- 사후승인이 아닐때 만 --%>
						<button type="button" id="rj_btn" class="btn_big theme mg_r5 ${none_css}" onclick="grant('R');">반려</button>
					</c:if>
				</c:otherwise>
			</c:choose>
		</c:if>
		<button type="button" class="btn_big mg_r5" onclick="javascript:window.close();">닫기${isAbNormalInFile}</button>
		</div>
	</div>
	</div>
</div>
</fieldset>
</form>
<iframe name="downloadFrame" id="downloadFrame" width="0%" src="about:blank" height="0" style="border-width:1px;border-color:black;border-style:solid;"></iframe>
<form id="popform" name="popform" method="post">
<input type="hidden" id="fileName" name="fileName" value="" />
<%-- <input type="hidden" id="userId" name="userId" value="${data.users_id}" /> --%>
<input type="hidden" name="approval_seq" value="${approvalForm.approval_seq}" />
<input type="hidden" name="data_seq" value="${data.data_seq}" />
<input type="hidden" id="networkPosition" name="networkPosition" value="${data_networkPosition}" />
<input type="hidden" id="ath_value" name="ath_ord" value="" />
<input type="hidden" name="view_type" value="${view_type}" />
<textarea id="msg" name="msg" style="display: none;"></textarea>
</form>
</body>
</html>
