<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<%@include file="/WebUI/include/encryptUtil.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
	checkFocusMessage($("#server"),"최대 15자까지 가능합니다.(1.1.1.1 ~ 255.255.255.254)");
	checkFocusMessage($("#port"),"최소 2 ~ 65534까지 입력이 가능합니다.");
	checkFocusMessage($("#userName"),"최대 45자까지 가능합니다.");
	checkFocusMessage($("#userPassword"),"최대 20자까지 가능합니다.");
});

	function cancel() {
		location.href = "<c:url value="/systemManagement/mailManagement/mailServerInfo.lin" />";
	}

	function save() {
		var errmsg = new cls_errmsg();
		if (empty($("#server").val())) {
			errmsg.append($("#server"), "메일서버 IP 정보를 입력해 주세요.");
		} else if (empty($("#port").val())) {
			errmsg.append($("#port"), "포트 정보를 입력해 주세요.");
		} else if (!empty($("#userName").val()) || !empty($("#userPassword").val()) ){
			if($("#userName").val() == $("#userPassword").val()){
				errmsg.append($("#userPassword"), "발신계정 ID와 동일한 발신계정 비밀번호는 사용 불가능합니다.");
			}
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		if (confirm("변경된 내용을 저장하시겠습니까?")) {
			
			if( $('#userPassword').val() ) {
				aesUtil.encryptJQSelectorValue( $('#userPassword') );			
			}
			
			var requestURL = "<c:url value="/systemManagement/mailManagement/insertMailServerInfo.lin" />";
			var successURL = "<c:url value="/systemManagement/mailManagement/mailServerInfo.lin" />";
			
			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				var message = response['message'];
				
				alert(message);
				$(location).attr("href", successURL);
			});
		}
	}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/systemManagement/mailManagement/mailServerInfo.lin" />" >
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">메일서버 설정</h2>
				<p class="breadCrumbs">시스템 관리 > 메일서버 설정</p>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>메일서버 정보</h3>
			<div class="conBox">
				<div class="table_area_style02">
					<table summary="기본 설정 테이블입니다.">
					<caption>server, port, userAuthYN</caption>
						<colgroup>
							<col style="width:10%;" />
							<col style="width:90%;" />
						</colgroup>
						<tbody>
							<tr>
								<th class="t_left">메일서버 IP</th>
								<td>
									<input type="text" class="text_input" id="server" name="server" value="${outgoingSMTP.server}" maxlength="25"/>
								</td>
							</tr>
							<tr>
								<th class="t_left">포트</th>
								<td class="t_left" >
									<input type="text" class="text_input" id="port" name="port" value="${outgoingSMTP.port}" onkeyup="onlyNumBetweenFillter(this,6,1,65534)" />
								</td>
							</tr>
							<tr>
								<th class="t_left">메일 인코딩</th>
								<td>
									<%-- <input type="text" class="text_input" id="mail_encoding" name="mail_encoding" value="${outgoingSMTP.mail_encoding}" maxlength="50"/> --%>
									<select id="mail_encoding" name="mail_encoding" style="width: 150px;">
										<option value="EUC-KR" ${ ( outgoingSMTP.mail_encoding eq 'EUC-KR' ) ? "selected='selected'" : ""} >EUC-KR</option>
										<option value="UTF-8" ${ ( outgoingSMTP.mail_encoding eq 'UTF-8' ) ? "selected='selected'" : ""} >UTF-8</option>
									</select>
								</td>
							</tr>
							<tr>
								<th class="t_left">인증여부</th>
								<td class="t_left" >
									<input type="radio" id="userAuthYN_Y" name="userAuthYN" value="Y" ${outgoingSMTP.userAuthYN == "Y" ? ' checked' : ''} />
									<label for="userAuthYN_Y" class="mg_r30">인증</label>
									<input type="radio" id="userAuthYN_N" name="userAuthYN" value="N" ${outgoingSMTP.userAuthYN == "N" ? ' checked' : ''} />
									<label for="userAuthYN_N">미 인증</label>
								</td>
							</tr>
							<tr>
								<th class="t_left">발신계정 ID</th>
								<td class="t_left" >
									<input type="text" class="text_input" id="userName" name="userName" value="${outgoingSMTP.userName}" maxlength="50"/>
								</td>
							</tr>
							<tr>
								<th class="t_left">발신계정 비밀번호</th>
								<td class="t_left" >
									<input type="password" class="text_input" id="userPassword" name="userPassword" value="${userPassword}" maxlength="20"/>
								</td>
							</tr>
							<tr>
								<th class="t_left">발송자이메일</th>
								<td class="t_left" >
									<input type="text" name="snd_email" id="snd_email" class="text_input" value="${outgoingSMTP.snd_email}" maxlength="50"/>
								</td>
							</tr>
							<tr>
								<th class="t_left">발송자표시이름</th>
								<td class="t_left" >
									<input type="text" name="snder_nm" id="snder_nm" class="text_input" value="${outgoingSMTP.snder_nm}" maxlength="30" />
								</td>
							</tr>
							<tr>
								<th class="t_left">StartTLS</th>
								<td class="t_left" >
									<input type="radio" id="startTlsYN_Y" name="startTlsYN" value="Y" ${outgoingSMTP.startTlsYN == "Y" ? ' checked' : ''} />
									<label for="startTlsYN_Y" class="mg_r30">적용</label>
									<input type="radio" id="startTlsYN_N" name="startTlsYN" value="N" ${outgoingSMTP.startTlsYN == "N" ? ' checked' : ''} />
									<label for="startTlsYN_N">미 적용</label>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="t_center mg_t30 mg_b30">
				<c:if test="${auth_type != 4}">
					<button class="btn_common theme" onclick="save()">저장</button>
				</c:if>
					<button class="btn_common theme" onclick="cancel()">취소</button>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>
