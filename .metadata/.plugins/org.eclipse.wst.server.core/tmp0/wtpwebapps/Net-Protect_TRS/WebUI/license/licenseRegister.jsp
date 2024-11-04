<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>

<html>
<head>
<script type="text/javascript">
function cancel() {
	location.href = "<c:url value="/license/licenseAdmin.lin" />";
}

function save() {
	var errmsg = new cls_errmsg();

	if (empty($("#Site_id").val()) || $("#Site_id").val().length > 11) {
		errmsg.append($("#Site_id"), "사이트아이디가 올바르지 않습니다.");

	} else if (empty($("#License_code").val())) {
		errmsg.append($("#License_code"), "라이센스 코드가 올바르지 않습니다.");

	}

	if (errmsg.haserror) {
		errmsg.show();
		return;
	}

	var requestURL = "<c:url value="/license/licenseAddRegister.lin" />";
	var successURL = "<c:url value="/license/licenseAdmin.lin" />";
	resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			if (code == '200') {
				alert('라이센스가 등록 되었습니다.');
				$(location).attr("href", successURL);
			} else {
				alert('라이센스 등록중 오류가 발생하였습니다. 라이센스 코드를 다시 확인해 주세요');
			}
	});

}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">라이센스 관리</h2>
				<p class="breadCrumbs">라이센스 관리 > 라이센스 관리</p>
			</div>
		</div>
	<div class="conWrap tableBox">
			<h3>목록</h3>
			<div class="conBox">
				<div class="table_area_style01 hoverTable">
					<div class="">
					</div>
					<table summary="라이센스등록"  style="table-layout : fixed" class="mg_t5">
						<tbody>
							<tr>
								<th class="t_left">사이트아이디</th>
								<td><input type="text" class="text_input" id="Site_id" name="Site_id" size="10" width="50%" maxlength="15" placeholder="xxx.xxx.xxx" /></td>
							</tr>
							<tr>	
								<th class="t_left">라이센스 코드</th>
								<td><input type="text"  class="text_input" id="License_code" name="License_code" size="35" width="100%" maxlength="128" placeholder="라이센스 코드를 입력하세요" /></td>
							</tr>
						</tbody>
					</table>
							<div class="t_center mg_t30 mg_b30">
								<button class="btn_common theme" onclick="save()">저장</button>
								<button type="button" class="btn_common" onclick="cancel()">취소</button>
							</div>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>