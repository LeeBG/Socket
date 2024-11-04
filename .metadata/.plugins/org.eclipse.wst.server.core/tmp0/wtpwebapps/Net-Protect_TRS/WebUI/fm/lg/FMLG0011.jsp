<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<script type="text/javascript"
	src="<c:url value="/JavaScript/module/trs.admin.js?v=210108" />"></script>
<script type="text/javascript">
	function cancel() {
		window.close();
	}
</script>
</head>
<body>
	<%--  ${fn:replace(msg, crcn, br)} --%>
	<form id="lform" name="lform" onsubmit="return false;" action=""
		method="post">
		<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
		<input type="hidden" id="exts" name="exts" value="${param.exts}">
		<input type="hidden" id="mime_type" name="mime_type"
			value="${param.mime_type}">
		<c:set var="mime_type" value="${fn:substring(param.mime_type, 0, 4)}" />
		<div class="wrap">
			<div class="popWrap">
				<h3>${fileName}내에 비정상 파일 목록</h3>
				<div class="conBox" style="margin-top: 0px;">
					<div class="popCon">
						<div class="table_area_style01 mg_t20 mg_b10">
							<p style="color: #e05050; margin-bottom: 5px;">※ 마임타입 검사중에
								검출된 비정상 파일 목록입니다.</p>
							<table id="checkMimeTypeTable" summary="비정상 파일 목록"
								style="table-layout: fixed; border: 1px solid #ddd;">
								<caption>비정상 파일 리스트</caption>
								<colgroup>
									<col style="width: 40%;">
									<col style="width: 15%;">
									<col style="width: 30%;">
									<col style="width: 25%;">
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
										<c:choose>
											<c:when test="${fn:contains(item, '스캔')}">
												<c:set var="status" value="0"></c:set>
											</c:when>
											<c:when test="${fn:contains(item, '위변조')}">
												<c:set var="status" value="11"></c:set>
											</c:when>
											<c:when
												test="${fn:contains(item, '차단') || fn:contains(item, '미등록')}">
												<c:set var="status" value="12"></c:set>
											</c:when>
											<c:when test="${fn:contains(item, '바이러스')}">
												<c:set var="status" value="3"></c:set>
											</c:when>
											<c:when test="${fn:contains(item, '검사중')}">
												<c:set var="status" value="5"></c:set>
											</c:when>
											<c:when test="${fn:contains(item, '암호화')}">
												<c:set var="status" value="10"></c:set>
											</c:when>
											<c:otherwise>
												<c:set var="status" value="1"></c:set>
											</c:otherwise>
										</c:choose>
										<tr>
											<c:forEach items="${fn:split(item, ',') }" var="list"
												varStatus="cnt">
												<c:set var="index" value="${cnt.index}" />
												<c:set var="last" value="${cnt.last}" />
												<c:set var="text" value="${list}" />
												<c:if test="${index eq 1}">
													<c:set var="ext" value="${text}" />
												</c:if>
												<c:if test="${index eq 2}">
													<c:set var="mimetype" value="${text}" />
												</c:if>
												<c:set var="isAddableExtension"
													value="${last && (status eq  11 || status eq 12)}" />

												<td
													class="Rborder ${index ne 0 ? 't_center' : '' } vc_scanStatusText n${status} ${isAddableExtension ? 'pd_t5 pd_b5' : 'pd_t12 pd_b12' }"
													style="height: auto;">${text} <c:if
														test="${isAddableExtension && !fn:contains(item, '확장자') && !fn:contains(item, 'OLE') }">
														<br>
														<button class="gradient-btn mg_t3"
															onclick="addExtension('lform','${ext}','${mimetype}');">새
															확장자 추가</button>
													</c:if>
												</td>
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
