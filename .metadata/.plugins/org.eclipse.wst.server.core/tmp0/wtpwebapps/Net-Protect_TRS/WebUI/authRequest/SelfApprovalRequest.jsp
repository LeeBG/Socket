<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>

<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="approvalPolicy" value="${loginUser.approvalPolicy}" />
<c:set var="isApprovalUse" value="${approvalPolicy.approvalUse}" />
<c:set var="networkPosition" value="${customfunc:getNetworkPosition() }" />

<html>
<head>
<script type="text/javascript"
	src="<c:url value="/JavaScript/numeral.min.js" />"></script>
<script type="text/javascript">
	var selectApprover = null;
	var popup_approver_1 = null;
	var popup_approver_2 = null;
	var approverArray = "";
	var app_manager = new ApprovalManager();
	
	$(document).ready(function() {
		<c:if test="${approvalUser != null }">
		
		$("#approverArray").val('${approvalUser }');
		
		var jusers = JSON.parse($("#approverArray").val());
		jusers.forEach(function(userInfo) {
			app_manager.setDefaultApprover('approver', userInfo);
		});
		
		</c:if>
		
		$("input[name='request_startdate']").eq(0).val(moment().format('YYYY-MM-DD'));
	});
	
	function openApprovalPopup() {
		var url = "<c:url value="/authRequest/approvalPopup.lin" />";
		var attibute = "resizable=no,scrollbars=yes,width=750,height=750,top=5,left=5,toolbar=no,resizable=no,toolbar=no,resizable=no,url=no";
		var popupWindow = window.open(url, "approvalPopup", attibute);
		popupWindow.focus();
	}
	
	function checkMaxPriod(request_startdate, request_enddate) {
		var eDate = moment(request_enddate);
		var mDate = moment(request_startdate);
		mDate.add(365 , 'days');
		
		return dateCheck(eDate.format('YYYY[-]MM[-]DD'), mDate.format('YYYY[-]MM[-]DD'), "day");
	}

	function validateSetApprovers(approverValue) {
		var app_level = "${approvalLineLevel}";
		try {
			if( (approverValue == null) || (approverValue.length != app_level) ){
				throw "<spring:message code="data.file.sendForm.script.invalid.appr" />";
			}
		} catch (e) {
			alert(e);
			return false;
		}
		
		return true;
	}

	function checkPeriodValidation() {
		var request_startdate = $("input[name='request_startdate']").val();
		var request_enddate = $("input[name='request_enddate']").val();
		try{
			if( ! checkMaxPriod(request_startdate, request_enddate) ) throw "최대 설정기간은 1년 입니다.";
			if( ! dateCheck(request_startdate, request_enddate, "day" ) ) throw "날짜가 올바르지 않습니다. 날짜를 확인해주세요.";
		} catch(e) {
			alert(e);
			return false;
		}
		
		return true;
	}

	function validateTextArea() {
		var TextAreaValue = document.getElementById("request_comment").value;
		try {
			if(TextAreaValue==""){
				throw "사용목적을 적어주세요.";
			}
		} catch (e) {
			alert(e);
			return false;
		}
		
		return true;
	}
	function insertSelfApprovalRequest() {
		if( ! confirm("<spring:message code="common.selfapproval"/>권한을 요청하시겠습니까?") ) return;
		
		var requestURL = "<c:url value="/authRequest/insertSelfApprovalRequest.lin" />";
		var successURL = "<c:url value="/authRequest/SelfApprovalRequest.lin" />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}

	function request() {
		var approverArray = $("#approverArray").val();
		approverArray =approverArray.empty() ? approverArray: JSON.parse(approverArray);
		if(validateSetApprovers(approverArray) == false) return;
		if(checkPeriodValidation() == false ) return;
		if(validateTextArea() == false) return;
		insertSelfApprovalRequest();
	};

	$(document).ready(function() {
		/* checkFocusMessage($("#request_comment"), "최대 100자까지 가능합니다."); */
		$('#request_comment').on('keyup',function(){
			var textLength = $(this).val().length;
			if($(this).val().length > 100){
				alert("사용 목적을 100자 이하로 입력하여 주세요.\n100자가 초과된 글자수는 자동으로 삭제됩니다.");
				var str = $(this).val().substring(0,100);
				$(this).val(str).substring(0,100);
				$(this).val($(this).val.substring(0,100))
			}
		})
	});
</script>
<style>
.table_area_style02 table tr:first-child th{
	width:15%;
}
.table_area_4col tr:first-child td{
	width:35%;
}
</style>
</head>
<body>
	<div class="rightArea">
		<form id="lform" name="lform" method="post" onSubmit="return false;">
			<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
			<input type="hidden" id="startDay" name="startDay" value="${loginUser.csrf }" />
			<input type="hidden" id="endDay" name="endDay" value="${loginUser.csrf }" />
			<input name="approverArray" id="approverArray" type="hidden" value=""/>
			<div class="topWarp">
				<div class="titleBox">
					<h2 class="f_left text_bold"><spring:message code="common.selfapproval"/> 신청</h2>
					<p class="breadCrumbs">권한요청> <spring:message code="common.selfapproval"/> 신청</p>
				</div>
			</div>
			<div class="conWrap">
				<h3><spring:message code="common.selfapproval"/> 신청</h3>
				<div class="conBox">
					<c:if test="${isApprovalUse}">
						<div class="optionArea">
							<span class="optionTitle" style="width:14.3%;">결재정보</span>
							<div class="optionArea_rightBox f_right">
								<div class="approvalInfo">
									<p id="proxy_approvalBox" class="lBar">
										<input type="hidden" name="afterApproval" id="afterApproval" style="height: 20px" />
									</p>
									<p>
										<c:choose>
											<c:when test="${approvalLineLevel == 1}">
												<span class="text_bold">결재자 : </span>
												<span class="signer" id="approver1">결재자를 선택해주세요.</span>
											</c:when>
											<c:otherwise>
												<c:forEach var="info" items="${approvalLineInfo }" varStatus="index">
													<%-- 중부발전용 코드 if문 추가!! --%>
													<c:if test="${ info.appLineLevel eq 1 }">
													<span class="text_bold mg_l5">결재자 : </span>
													<span class="signer" id="approver${info.appLineLevel }" data-count="${index.count }">결재자를 선택해주세요.</span>
													</c:if>
													<c:if test="${ info.appLineLevel ne 1 }">
													<span class="text_bold mg_l5" style="display:none !important;">${index.count }차 : </span>
													<span class="signer" id="approver${info.appLineLevel }" style="display:none !important;" data-count="${index.count }">(미선택)</span>
													</c:if>
												</c:forEach>
											</c:otherwise>
										</c:choose>
										<button type="button" class="btn_small darkGrey" id="find_approver_btn" name="find_approver_btn" onclick="openApprovalPopup();">선택</button>
									</p>
								</div>
							</div>
						</div>
					</c:if>
				</div>
			</div>
			<div class="conWrap">
				<h3>신청자 정보</h3>
				<div class="conBox">
					<div class="table_area_style02 table_area_4col">
						<table>
							<tbody>
								<tr>
									<th class="t_center">이름</th>
									<td class="t_left"><span id="requestUser_NM" name="requestUser_NM">${userInfo.users_nm}</span></td>
									<th class="t_center">${customfunc:getMessage('common.id.commonid')}</th>
									<td class="t_left"><span id="requestUser_Id" name="requestUser_Id">${userInfo.users_id}</span></td>
								</tr>
								<tr>
									<th class="t_center">소속</th>
									<td class="t_left"><span id="requestUser_Dept" name="requestUser_Dept">${userDept.dept_nm}</span></td>
									<th class="t_center">이메일</th>
									<td class="t_left"><span id="requestUser_Email" name="requestUser_Email">${(userInfo.email == null || userInfo.email =="") ? '없음' : userInfo.email}</span></td>
								</tr>
								<tr>
									<th class="t_center">연락처</th>
									<td colspan="3" class="t_left"><span id="requestUser_HP" name="requestUser_HP">${(userInfo.hp == null || userInfo.hp =="") ? '없음' : userInfo.hp}</span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="conWrap">
				<h3>신청 내역</h3>
				<div class="conBox">
					<div class="table_area_style02">
					<table summary="정책 검색조건">
						<tbody>
							<tr>
								<th class="t_center">이용 기간<span style="color:red;">*</span></th>
								<td class="t_left">
									<jsp:include page="/WebUI/common/include/calendar/includeDatePicker.jsp" flush="false">
										<jsp:param name="startName" value="request_startdate" />
										<jsp:param name="endName" value="request_enddate" />
										<jsp:param name="width" value="100" />
										<jsp:param name="startDay" value="" />
										<jsp:param name="endDay" value="" />
										<jsp:param name="formName" value="lform" />
									</jsp:include>
									<div class="mg_t10">※ <spring:message code="common.selfapproval"/> 신청 기한은 최대 1년입니다.</div>
								</td>
							</tr>
							<tr>
								<th class="t_center" style="width:15%;">사용 목적<span style="color:red;">*</span></th>
								<td class="t_left">
									<textarea name="request_comment" id="request_comment" style="width: 100%; height: 70px;"></textarea><br>
<!-- 									<textarea name="request_comment" id="request_comment" style="width: 100%; height: 70px;" placeholder="사용 목적을 상세히 기입해주세요 (최대 100자)"></textarea><br> -->
								</td>
							</tr>
						</tbody>
					</table>
					</div>
				</div>
				<div class="btn_area_center mg_t10 mg_b10 mg_l10">
					<button type="button" class="btn_big theme" onclick="request();">요청</button>
					<button type="button" class="btn_big theme" onclick="history.back();">취소</button>
				</div>
			</div>
		</form>
	</div>
</body>
</html>