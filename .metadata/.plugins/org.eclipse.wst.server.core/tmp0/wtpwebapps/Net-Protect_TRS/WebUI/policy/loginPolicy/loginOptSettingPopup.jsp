<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<title>로그인OTP인증설정</title>
<link href="<c:url value="/css/ui.tooltip.css?ver=01804100011" />" rel="stylesheet" type="text/css"/>
<script>
$(document).ready(function() {
	window.resizeTo($(".wrap")[0].scrollWidth + 20, $(".wrap")[0].scrollHeight+80);
});


function save() {	
	var requestURL = "<c:url value="/policy/loginPolicy/loginOptSetting.lin" />";

	resultCheckFunc($("#lform"), requestURL, function(response) {
		alert(response['message']);
		window.close();
	});
}

function cancle() {
	window.close();
}
</script>
</head>
<body>
	<form id="lform" name="lform" onsubmit="return false;" method="post" >
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="wrap">
		<div class="popWrap otpPop">
			<h3>로그인OTP인증설정</h3>
			<div class="conBox" style="overflow:hidden;">
				<div class="popCon">
					<div class="table_area_style01">
						<table cellspacing="0" cellpadding="0" summary="로그인OTP인증설정" class="">
							<caption>로그인OTP인증설정</caption>
							<colgroup>
								<col style="width:7%;"/>
							</colgroup>
							<tr>
								<th class="t_center" colspan="2">인증설정</th>
								</th>
								<td colspan="3" class="Rborder">
									<input type="radio" id="otp_use_y" name="otp_use" class="input_chk" value="Y" ${LOGIN_OTP_AUTH_YN == "Y" ? ' checked' : ''}><label for="otp_use_y" class="mg_r15 opt_label">활성</label>&nbsp;
									<input type="radio" id="otp_use_n" name="otp_use" class="input_chk" value="N" ${LOGIN_OTP_AUTH_YN == "N" ? ' checked' : ''}><label for="otp_use_n" class="opt_label">비활성</label>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			<div class="btn_area_center mg_t10 mg_b10">
				<button type="button" class="btn_big theme" onclick="save();">확인</button>
				<button type="button" class="btn_big" onclick="cancle();">취소</button>
			</div>
		</div>
	</div>
	</form>
</body>
</html>