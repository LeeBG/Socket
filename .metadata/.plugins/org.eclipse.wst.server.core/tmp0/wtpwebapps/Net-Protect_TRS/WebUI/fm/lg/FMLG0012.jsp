<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<html>
<head>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.dlp.js" />"></script>
<script type="text/javascript">
function cancel() {
	 window.close();
}
$(function() {
	dlpDetail();
});
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" action="" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="wrap">
		<div class="popWrap">
			<h3>${file_nm} 개인정보검출 내역</h3>
			<div class="conBox detail_header_layout">
				<div class="popCon">
					<div class="table_area_style01 mg_t20 mg_b10">
						<p class="detail_header">※ 개인정보검출 검사중에 검출된 비정상 목록입니다.</p>
						<table id="checkMimeTypeTable" summary="비정상 파일 목록" >
						<caption>비정상 리스트</caption>
							<colgroup>
							<c:choose>
								<c:when test="${dlp_company}">
									<col style="width:10%">
									<col style="width:15%;">
									<col style="width:10%;">
									<col style="width:65%;">
								</c:when>
								<c:otherwise>
									<col style="width:20%;">
									<col style="width:80%;">
								</c:otherwise>
							</c:choose>
							</colgroup>
							<thead>
								<tr class="t_height">
									<c:choose>
										<c:when test="${dlp_company}">
											<th class="Rborder">구분</th>
											<th class="Rborder">분류</th>
											<th class="Rborder">건수</th>
											<th>내용</th>
										</c:when>
										<c:otherwise>
											<th class="Rborder">분류</th>
											<th>내용</th>
										</c:otherwise>
									</c:choose>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${dlpBlockList}" var="dlpBlock">
									<tr class="t_height dlp_StatusText">
									<c:choose>
										<c:when test="${dlp_company}">
											<td class="t_center Rborder">${dlpBlock.classify }<input type="hidden" class="dlp_img_cd" value="${dlpBlock.img_cd }"></td>
											<td class="t_center Rborder">${dlpBlock.count }건</td>
											<td class="t_center t_content">${dlpBlock.content }</td>
										</c:when>
										<c:otherwise>
											<td class="t_center Rborder">${dlpBlock.classify }</td>
											<td class="t_center t_content">${dlpBlock.content }</td>
										</c:otherwise>
									</c:choose>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				<div class="btn_area_center mg_b10">	
					<button type="button" class="btn_common theme" onclick="cancel()">닫기</button>
				</div>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>
