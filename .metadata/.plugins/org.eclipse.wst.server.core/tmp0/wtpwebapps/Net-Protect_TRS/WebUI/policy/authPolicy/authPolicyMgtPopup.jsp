<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />

<script type="text/javascript">
$(document).ready(function() {
	var cud_cd = '${fAuthInfoForm.cud_cd}';
	if (cud_cd == '${CUD_CD_U}') {
		$("#auth_cd_nm").val('${fAuthInfo.auth_cd_nm}');
		$("#auth_cd").val('${fAuthInfo.auth_cd}');
	}
	$("#cud_cd").val("${fAuthInfoForm.cud_cd}");
});

function save() {
	if ($("#auth_cd_nm").val() == "") {
		alert("권한명을 입력해 주세요.");
		return;
	}
	if( confirm(" 정말로 저장 하시겠습니까?" ) ){
		var cud_cd = $("#cud_cd").val();	
		var errmsg = new cls_errmsg();
		if (errmsg.haserror) {
			errmsg.show();
			return;
		}
		var requestURL = "<c:url value="/policy/menuPolicy/insertMenuPolicyMgt.lin" />";
		var resultStr = "";
		var resultErrStr = "";
		if (cud_cd == '${CUD_CD_C}') {
			resultStr= "권한이 등록되었습니다.";
			resultErrStr= "권한 등록 중 에러가 발생 되었습니다.";

		} else if (cud_cd == '${CUD_CD_U}'){
			resultStr= "권한이 수정되었습니다.";
			resultErrStr= "권한 수정 중 에러가 발생 되었습니다.";
		}

		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			if (code != '210') {
				if (code == '200') {
					alert(resultStr);
				} else {
					alert(resultErrStr);
				}
				opener.parent.location="<c:url value="/policy/menuPolicy/menuPolicyMgt.lin" />";
				window.close();
			} else {
				alert('이미 사용중인 권한명 입니다. 다른 권한명으로 변경하세요.');
				return;
			}
		}); 
	}else{
		return;
	}
}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="#">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="wrap">
		<div class="popWrap">
			<h3>권한 추가</h3>
			<div class="conBox">
				<div class="popCon t_center mg_t20 mg_b20">
					<input type="text" class="text_input max" id="auth_cd_nm" name="auth_cd_nm" size="15" maxlength="30"/>
					<input type="hidden" class="text_input max" id="auth_cd" name="auth_cd" />
					<input type="hidden" id="cud_cd" name="cud_cd" />
					<button type="button" class="btn_common theme" onclick="save()">확인</button>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>
