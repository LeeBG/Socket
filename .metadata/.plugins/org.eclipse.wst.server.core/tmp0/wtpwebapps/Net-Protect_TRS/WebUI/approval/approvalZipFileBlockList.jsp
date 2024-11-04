<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<html>
<head>

<script type="text/javascript">
function cancel() {
	window.close();
}
</script>
</head>
<body>
<%--  ${fn:replace(msg, crcn, br)} --%>
<form id="lform" name="lform" onsubmit="return false;" action="" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="exts" name="exts" value="${param.exts}">
<input type="hidden" id="mime_type" name="mime_type" value="${param.mime_type}">
<c:set var="mime_type" value="${fn:substring(param.mime_type, 0, 4)}"/>
	<div class="wrap">
		<div class="popWrap">
			<h3>${fileName} 내에 비정상 파일 리스트</h3>
			<div class="conBox">
				<div class="popCon">
					<div class="table_area_style01 mg_t20 mg_b10">
						<%-- <div class="table_area_topCon mg_b10" style="padding-left: 10px;">
							${fileName} 
						</div> --%>
						<table id="checkMimeTypeTable" summary="시험정보" style="table-layout : fixed; border:1px solid #ddd; ">
						<caption>비정상 파일 리스트</caption>
							<colgroup>
								<col style="width:40%;">
								<col style="width:10%;">
								<col style="width:35%;">
								<col style="width:15%;">
							</colgroup>
							<thead>
								<tr>
									<th class="Rborder">파일명</th>
									<th class="Rborder">확장자</th>
									<th class="Rborder">Mime_Type</th>
									<th>상태</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${fn:split(msg, '|') }" var="item">
									<tr>
									<c:choose>
										<c:when test="${fn:contains(item, '스캔')}">
											<c:set var="status">vc_scanStatusText n0</c:set>
										</c:when>
										<c:when test="${fn:contains(item, '위변조')}">
											<c:set var="status">vc_scanStatusText n11</c:set>
										</c:when>
										<c:when test="${fn:contains(item, '차단')}">
											<c:set var="status">vc_scanStatusText n12</c:set>
										</c:when>
										
										<c:when test="${fn:contains(item, '바이러스')}">
											<c:set var="status">vc_scanStatusText n3</c:set>
										</c:when>
										<c:when test="${fn:contains(item, '검사중')}">
											<c:set var="status">vc_scanStatusText n5</c:set>
										</c:when>
										<c:when test="${fn:contains(item, '암호화')}">
											<c:set var="status">vc_scanStatusText n10</c:set>
										</c:when>
									<c:otherwise>
										<c:set var="status">vc_scanStatusText n1</c:set>
									</c:otherwise>
									</c:choose>
									<c:forEach items="${fn:split(item, ',') }" var="list"  varStatus="cnt">
										<c:if test="${cnt.count eq 1}">
											<td class="Rborder ${status}">${list}</td>
										</c:if>
										<c:if test="${cnt.count ne 1}">
											<td class="Rborder t_center ${status}">${list}</td>
										</c:if>
										<%-- <td class="Rborder t_center">${list}</td>
										<td class="Rborder t_center"></td>
										<td class="Rborder t_center"></td> --%>
									</c:forEach>
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
