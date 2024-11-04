<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<script type="text/javascript">
function redirect(url) {
	window.location.href = url;
}
</script>
</head>
<body>
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<!-- contents -->
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold">인사정보연동 메뉴</h2>
			<p class="breadCrumbs">인사정보연동 메뉴</p>
		</div>
	</div>
	<div class="rightArea">
	<div class="conWrap tableBox">
		<h3>인사DB동기화 메뉴</h3>
		<div class="conBox">
			<div class="table_area_style01">
				<table summary="인사DB동기화 메뉴" style="table-layout: fixed" class="mg_t10 mg_b10">
					<caption>name, value, button</caption>
					<colgroup>
						<col style="width: 20%;" />
						<col style="width: 20%;" />
					</colgroup>
					<thead>
						<tr>
							<th class="Rborder">메뉴</th>
							<th >이동</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="t_center Rborder">
								인사정보연동 설정
							</td>
							<td class="t_center">
								<button type="button" class="btn_common" onclick="javascript:redirect('/hr/dataSync/setHrSync.lin')">이동</button>
							</td>
						</tr>
						<tr>
							<td class="t_center Rborder">
								결재자설정
							</td>
							<td class="t_center">
								<button type="button" class="btn_common" onclick="javascript:redirect('/hr/dataSync/setAppCon.lin')">이동</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	</div>
</body>
</html>