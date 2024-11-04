<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<html>
<head>
<link href="/css/calendar.css" rel="stylesheet" type="text/css" />

<c:set var="loginUser" value="${sessionScope.loginUser}"/>
<c:set var="approvalPolicy" value="${loginUser.approvalPolicy}"/>
<c:set var="isApprovalUse" value="${approvalPolicy.approvalUse}"/>
<c:set var="networkPosition" value="${customfunc:getNetworkPosition()}"/>

<script type="text/javascript">

	
	$(document).ready(function() {
		$("#calendar_lyr").hide();
	});
	function grant(type){
		if (type == 'R') {
			if (confirm("반려 하겠습니까?")) {
				var request_seq = $("#request_seq").val();
			} else {
				return;
			}
		}

		$("#app_type").val(type);

		var requestURL = "<c:url value="/authRequest/selfApprovalRequestUpdate.lin" />";

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
	
	function deleteKey(request_seq) {
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
	function updateSelfApprovalDate(){
		$("#request_startdate_dl").hide();
		/* $("#request_startdate_text").toggle(); */
		$("#request_enddate_dl").hide();
		/* $("#request_enddate_text").toggle(); */
		$("#DatePicker").toggle();
		$("#updateSelfApprovalDate_btn").hide();
		$("#updateSelfApprovalDateComplete_btn").toggle();
		$("#back_btn").toggle();
		$("input[name='request_startdate']").eq(0).val(moment().format('YYYY-MM-DD'));
	};
	function back(){
		$("#request_startdate_dl").show();
		/* $("#request_startdate_text").toggle(); */
		$("#request_enddate_dl").show();
		/* $("#request_enddate_text").toggle(); */
		$("#DatePicker").toggle();
		$("#updateSelfApprovalDate_btn").show();
		$("#updateSelfApprovalDateComplete_btn").toggle();
		$("#back_btn").toggle();
	}

	function checkPeriodValidation() {
		var request_startdate = $("input[name='startDay']").val();
		var request_enddate = $("input[name='endDay']").val();
		try{
			if( ! checkMaxPriod(request_startdate, request_enddate) ) throw "최대 설정기간은 1년 입니다.";
			if( ! dateCheck(request_startdate, request_enddate, "day" ) ) throw "날짜가 올바르지 않습니다. 날짜를 확인해주세요.";
		} catch(e) {
			alert(e);
			return false;
		}
		
		return true;
	}

	function checkMaxPriod(request_startdate, request_enddate) {
		var eDate = moment(request_enddate);
		var mDate = moment(request_startdate);
		mDate.add(365 , 'days');
		return dateCheck(eDate.format('YYYY[-]MM[-]DD'), mDate.format('YYYY[-]MM[-]DD'), "day");
	}

	function updateSelfApprovalComplete(){
		if(checkPeriodValidation() == false ) return;
		if( ! confirm("자가결재기간을 변경하시겠습니까?") ) return;

		var requestURL = "<c:url value="/authRequest/updateSelfApprovalRequest.lin" />";
		var successURL = "<c:url value="/authRequest/SelfApprovalRequestApprovalView.lin" />" + "?approval_seq=${param.approval_seq}&request_seq=${authRequestForm.request_seq}&view_type=W ";
		resultCheck($("#lform"), requestURL, successURL, true);
	}
</script>
</head>
<body>
<form id="lform" name="lform" method="post" action="" onSubmit="return false;">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="app_type" name="app_type" value="${approvalForm.app_type}" />
<c:if  test="${'N' eq approvalForm.app_yn && 'Y' eq approvalForm.app_turn_yn}">
	<input type="hidden" id="approval_seq" name="approval_seq" value="${approvalForm.approval_seq}" />
	<input type="hidden" id="app_ord" name="app_ord" value="${approvalForm.app_ord}" />
</c:if>
<input type="hidden" id="request_seq" name="request_seq" value="${authRequestForm.request_seq}" />
<input type="hidden" id="networkPosition" name="networkPosition" value="${networkPosition}" />
<fieldset>
<div class="wrap">
	<div class="popWrap">
	<h3>상세보기</h3>
	<div class="conBox">
		<!-- 결재자 정보 시작 -->
		<%-- <c:out value="${approvalFormList}"></c:out> --%>
		<%-- <c:out value="${loginUser.users_id}"></c:out> --%>
		<%-- <c:out value="${approvalForm}"></c:out> --%>
		<%-- <c:out value="${approvalFormList}"></c:out> --%>
		<c:if test="${fn:length(approvalFormList ) > 0}">
		<div id="approvalStatusBox" class="approvalStatus_box pd_b30">
			<c:forEach items="${approvalFormList}" var="approval" varStatus="i">
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
				<caption>결재자 이름, 결재상태, 결재시간</caption>
					<colgroup>
						<col style="width:16%;" />
						<col style="width:30%;" />
						<col style="width:24%;" />
						<col style="width:30%;" />
					</colgroup>
					<tbody>
						<tr>
							<c:choose>
								<c:when test="${fn:length(approvalFormList) == 1}">
									<td rowspan="2" class="title">결재자</td>
								</c:when>
								<c:otherwise>
									<td rowspan="2" class="title">${i.count}차결재</td>
								</c:otherwise>
							</c:choose>
							<th>이름</th>
							<th>결재상태</th>
							<th>결재시간</th>
						</tr>
						<tr>
							<c:choose>
								<c:when test="${approval.app_yn eq 'N' || approval.app_type eq 'WD' || approval.appr_nm eq approval.real_appr_nm}">
									<td><c:out value="${approval.appr_nm}"/></td>
								</c:when>
								<c:otherwise>
									<td><c:out value="${approval.real_appr_nm} (${approval.appr_nm})"/></td>
								</c:otherwise>
							</c:choose>
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
				<dd><a title="[자가결재요청]${authRequestForm.request_comment}" href="javascript:;">[자가결재요청]${authRequestForm.request_comment}</a></dd>
			</dl>
			<dl>
				<dt>요청자 : </dt>
				<dd>${approvalFormList[0].users_nm}(${approvalFormList[0].users_id})</dd>
			</dl>
			<dl id = "request_startdate_dl">
				<dt>권한요청시작일: </dt>
				<dd><c:out value="${authRequestForm.request_startdate}" /></dd>
				<%-- <dd id = "request_startdate_text" style="display:none;"><input type="text" name="request_startdate_text" style = "width:200px;" value ="<c:out value="${authRequestForm.request_startdate}" />"/></dd> --%>
				</dl>
			<dl id = "request_enddate_dl">
				<dt>권한요청마감일 : </dt>
				<dd><c:out value="${authRequestForm.request_enddate}" /></dd>
				<%-- <dd id = "request_enddate_text" style="display:none;"><input type="text" name= "request_enddate_text" style = "width:200px;" value ="<c:out value="${authRequestForm.request_enddate}" />"/></dd> --%>
			</dl>
			<div class="conBox" id="DatePicker" style="display:none">
				<div class="table_area_style02">
				<table summary="정책 검색조건">
					<tbody>
						<tr>
							<th class="t_center">이용 기간<span style="color:red;">*</span></th>
							<td class="t_left">
								<jsp:include page="/WebUI/common/include/calendar/includeDatePicker.jsp" flush="false">
									<jsp:param name="startName" value="startDay" />
									<jsp:param name="endName" value="endDay" />
									<jsp:param name="width" value="100" />
									<jsp:param name="startDay" value="${fn:substring(authRequestForm.request_startdate,0,10)}" />
									<jsp:param name="endDay" value="${fn:substring(authRequestForm.request_enddate,0,10)}" />
									<jsp:param name="formName" value="lform" />
								</jsp:include>
								<div class="mg_t10">※ 자가결재 신청 기한은 최대 1년입니다.</div>
							</td>
						</tr>
					</tbody>
				</table>
				</div>
			</div>
			<dl>
				<dt>사용 목적 : </dt>
				<%-- <dd class="t_left"><c:out value="${data.title}" /></dd> --%>
				<dd><a title="${authRequestForm.request_comment}" href="javascript:;">${authRequestForm.request_comment}</a></dd>
			</dl>
			<c:choose>
				<c:when test="${'R' eq approvalStatus}">
					<dl>
						<dt>반려사유 : </dt>
						<dd>
							${rejectRsn}
						</dd>
					</dl>
				</c:when>
				<c:otherwise>
				</c:otherwise>
			</c:choose>
		</div>
			<div class="btn_area_center mg_b15 mg_t5">
					<c:choose>
					<c:when test="${'N' eq approvalForm.app_yn && 'Y' eq approvalForm.app_turn_yn}" >
							<button type="button" class="btn_big theme mg_r5" onclick="grant('Y');">승인</button>
						<c:if test="${approvalForm.app_type ne 'AF'}">
							<button type="button" class="btn_big theme mg_r5" onclick="grant('R');">반려</button>
						</c:if>
					</c:when>
					</c:choose>
		<c:choose>
			<c:when test= "${loginUser.auth_cd eq 1}">
			<button type="button" id="updateSelfApprovalDate_btn" class="btn_big mg_r5" onclick="updateSelfApprovalDate()">기간수정</button>	
			</c:when>
		</c:choose>
		<button type="button" id= "updateSelfApprovalDateComplete_btn" style="display:none" class="btn_big mg_r5" onclick="updateSelfApprovalComplete();">수정완료</button>
		<button type="button" id= "back_btn" style="display:none" class="btn_big mg_r5" onclick="back();">취소</button>
		<button type="button" class="btn_big mg_r5" onclick="javascript:window.close();">닫기</button>
		</div>
	</div>
	</div>
</div>
</fieldset>
</form>
<jsp:include page="/WebUI/common/calendar.jsp" flush="false" />
</body>
</html>