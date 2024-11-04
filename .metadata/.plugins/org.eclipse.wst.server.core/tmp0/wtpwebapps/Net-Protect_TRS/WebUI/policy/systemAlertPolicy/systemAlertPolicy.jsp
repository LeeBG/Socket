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
<html>
<head>

<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<c:set var="disk_limit_min" value="80" />
<c:set var="disk_limit_max" value="99" />
<c:set var="disk_alert_min" value="80" />
<c:set var="disk_alert_max" value="99" />
<c:set var="retry_count_min" value="1" />
<c:set var="retry_count_max" value="60" />
<c:set var="test_cycle_day_min" value="7" />
<c:set var="test_cycle_day_max" value="90" />

<script type="text/javascript">

var disk_limit_min = '${disk_limit_min}';
var disk_limit_max = '${disk_limit_max}';
var disk_limit_err_message = "디스크 사용률은 " + disk_limit_min+ "% 이상 "+ disk_limit_max +"% 이하까지 입력 가능합니다.";
var retry_count_min = '${retry_count_min}';
var retry_count_max = '${retry_count_max}';
var retry_count_err_message = "알림 횟수는 " + retry_count_min+ "회 이상 "+ retry_count_max +"회 이하까지 입력이 가능합니다."; 
var test_cycle_day_min = '${test_cycle_day_min}';
var test_cycle_day_max = '${test_cycle_day_max}';
var test_cycle_day_err_message = "시험주기는 " + test_cycle_day_min+ " 일 이상 "+ retry_count_max +" 이하까지 입력이 가능합니다."; 

function save() {
	if (confirm("시스템 감시 정책을 변경하시겠습니까?")) {
		
		if($("#email_receiver").val().length > 100){
			alert("이메일 100자 이하로 입력 하세요.");
			return;
		}
		
		var errmsg = new cls_errmsg();
		
		if (!isNumber($("#retry_count").val()) || !isValidSameRange($("#retry_count").val(), retry_count_min, retry_count_max)) {
			errmsg.append($("#retry_count"), retry_count_err_message);
		}

		if (!isNumber($("#test_cycle_day").val()) || !isValidSameRange($("#test_cycle_day").val(), test_cycle_day_min, test_cycle_day_max)) {
			errmsg.append($("#test_cycle_day"), test_cycle_day_err_message);
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		var requestURL = "<c:url value="/policy/systemAlertPolicy/updateSystemAlertPolicy.lin" />";
		var successURL = "<c:url value="/policy/systemAlertPolicy/systemAlertPolicy.lin" />";

		resultCheck($("#lform"), requestURL, successURL, true);
	}
}

$(document).ready(function() {
	<c:if test="${auth_cd == 4}">
	allInputDisable();
	</c:if>
	checkFocusMessage($("#retry_count"), retry_count_err_message);
	checkFocusMessage($("#test_cycle_day"), test_cycle_day_err_message);
	emailFocusMessage($("#email_receiver"),"최대 100자까지 가능합니다.");
});

//=== helpPopup start ===
function emailOpneHelpPopup(obj,message){
	var rightArea = $("#wrap");
	var popupPosition = $(obj).offset();
	var helpPopupTop = popupPosition.top + 55;
	var helpPopupLeft = popupPosition.left + 20;
	var helpPopupDiv = "<div class='helpPopup' style='position:absolute; top:"+ helpPopupTop + "px; left:"+ helpPopupLeft + "px; background-color:#fff; border:3px solid orange; padding:12px; z-index:9999;'><p>" + message + "</p></div>";
	rightArea.append(helpPopupDiv);
}

function closeHelpPopup(){
	$('.helpPopup').remove();
}

function emailFocusMessage(obj, message){
	$(obj).blur(function() {
		closeHelpPopup();
	}).focus(function() {
		emailOpneHelpPopup(this, message);
	});
}

</script>

</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/policy/systemAlertPolicy/systemAlertPolicy.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="use_yn" name="use_yn" value="Y">
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">시스템감시정책 관리</h2>
				<p class="breadCrumbs">정책관리 > 시스템감시정책 관리</p>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>시스템 감시 정책</h3>
			<div class="conBox">
				<div class="table_area_style02 Tborder">
					<table summary="로그인정책 설정" style="table-layout : fixed">
					<caption>시스템감시정책 관리</caption>
						<colgroup>
							<col style="width:15%;"/>
							<col style="width:85%;" />
						</colgroup>
						<tbody>
							<tr>
		
		
		
								<th rowspan="3" class="t_left">디스크 용량 감시</th>
								<td>
									${INNER }영역&nbsp;
									<select name="inner_disk_filesystem" id="inner_disk_filesystem">
										<c:if test="${isInnerFileSystemSet eq false}">
										<option value="">FileSystem을 선택하세요</option>
										</c:if>
										<c:forEach items="${innerDiskStatusList }" var="diskStatus">
										<option value="${diskStatus.filesystem}" <c:if test="${diskStatus.filesystem eq  systemAlertPolicy.inner_disk_filesystem}">selected="selected"</c:if>>${diskStatus.filesystem }</option>
										</c:forEach>
									</select>
									&nbsp;&nbsp;FileSystem의 사용률&nbsp;&nbsp;
									<input type="text" readonly="readonly" class="text_input short t_center" id="inner_disk_alert" name="inner_disk_alert" maxlength="${fn:length(disk_alert_max)}" value="80"/> % 이상 일때 알림,&nbsp;&nbsp;
									<input type="text" readonly="readonly" class="text_input short t_center" id="inner_disk_limit" name="inner_disk_limit" maxlength="${fn:length(disk_limit_max)}" value="90"/> % 이상 일때 알림 후 자동 삭제
								</td>
							</tr>
							<tr>
								<td>
									${OUTER }영역&nbsp;
									<select name="outer_disk_filesystem" id="outer_disk_filesystem">
										<c:forEach items="${outerDiskStatusList }" var="diskStatus">
										<option value="${diskStatus.filesystem}" <c:if test="${diskStatus.filesystem eq  systemAlertPolicy.outer_disk_filesystem}">selected="selected"</c:if>>${diskStatus.filesystem }</option>
										</c:forEach>
									</select>
									&nbsp;&nbsp;FileSystem의 사용률&nbsp;&nbsp;
									<input type="text" readonly="readonly" class="text_input short t_center" id="outer_disk_alert" name="outer_disk_alert" maxlength="${fn:length(disk_alert_max)}" value="80"/> % 이상 일때 알림,&nbsp;&nbsp;
									<input type="text" readonly="readonly" class="text_input short t_center" id="outer_disk_limit" name="outer_disk_limit" maxlength="${fn:length(disk_limit_max)}" value="90"/> % 이상 일때 알림 후 자동삭제
								</td>
							</tr>
							<tr>
								<td>
									디스크 사용률 초과 시 <input type="text" class="text_input short t_center" id="retry_count" name="retry_count" maxlength="${fn:length(retry_count_max)}" value="${systemAlertPolicy.retry_count}"/> 회 알림
								</td>
							</tr>
							<tr class="none">
								<th class="t_left">시험 주기</th>
								<td>
									<%-- <input type="text" class="text_input short" id="test_cycle_day" name="test_cycle_day" value="${systemAlertPolicy.test_cycle_day}" size="10" maxlength="10" /> 일 --%>
									<input type="text" class="text_input short" id="test_cycle_day" name="test_cycle_day" value="30" size="10" maxlength="10" /> 일
								</td>
							</tr>
							<tr>
								<th class="t_left">알림 이메일</th>
								<td>
									<textarea id="email_receiver" name="email_receiver" rows="5" cols="35" onkeyup="onlySizeFillter(this,100)"><c:out value="${customfunc:replacern(systemAlertPolicy.email_receiver, ',')}" /></textarea>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="t_center mg_t30 mg_b30">
				<c:if test="${auth_cd != 4}">
					<button class="btn_common theme" onclick="save()">변경</button>
				</c:if>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>