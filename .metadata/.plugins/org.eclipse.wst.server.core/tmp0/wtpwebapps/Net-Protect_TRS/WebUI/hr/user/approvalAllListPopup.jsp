<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<title>결재자 전체보기</title>
<script>

  function download(){
	  var frm = document.excel_frm;
	  frm.action="<c:url value="/hr/user/approvalAllListExcelDownload.lin" />";
	  frm.submit();
  }
</script>
</head>
<body>
	<form id="excel_frm" name="excel_frm">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="wrap">
		<div class="popWrap">
			<h3>결재자 리스트</h3>
			<div class="conBox" style="overflow:hidden;">
						<div class="t_right pd_r10 pd_t5 pd_b5 Bborder">
						<!-- class="btn_common theme" -->				
							<button type="button" id="btnExcelDownload" onclick="download()" style="width:72px;height:21px;background-image:url(../../Images/button/btn_small_style01.gif);background-position:0 -525px;"></button> 
							<!-- <button type="button" id="btnExcelDownload" onclick="download()" class="btn_common theme">엑셀다운로드</button> <br><br> -->
						</div>
				<div class="popCon">
					<div class="table_area_style01">
						<table cellspacing="0" cellpadding="0" summary="결재자 전체보기">
							<caption>결재자</caption>
							<colgroup>
								<col style="width:5%;"/>
								<col style="width:20%;" />
								<col style="width:20%;" />
								<col style="width:25%;" />
								<col style="width:15%;" />
								<col style="width:15%;" />
							</colgroup>
							<tr>
								<th class="t_center">No.</th>
								<th class="t_center">사용자명</th>
								<th class="t_center">${customfunc:getMessage('common.id.commonid')}</th>
								<th class="t_center">부서</th>
								<th class="t_center">직급</th>
								<th class="t_center">직책</th>
							</tr>
							<c:choose> 
							<c:when test="${not empty apprUserList}">
							<c:forEach items="${apprUserList}" var="list" varStatus="status">
							<tr>
								<td class="Rborder t_center" style="<c:if test="${fn:length(apprUserList) eq status.count}">border-bottom: 0px solid #ddd;</c:if>">${status.count}</td>
								<td class="Rborder t_center" style="<c:if test="${fn:length(apprUserList) eq status.count}">border-bottom: 0px solid #ddd;</c:if>">${list.users_nm}</td>
								<td class="Rborder t_center" style="<c:if test="${fn:length(apprUserList) eq status.count}">border-bottom: 0px solid #ddd;</c:if>">${list.users_id}</td>
								<td class="Rborder t_center" style="<c:if test="${fn:length(apprUserList) eq status.count}">border-bottom: 0px solid #ddd;</c:if>">${list.dept_nm}</td>
								<td class="Rborder t_center" style="<c:if test="${fn:length(apprUserList) eq status.count}">border-bottom: 0px solid #ddd;</c:if>">${list.position_nm}</td>
								<td class="Rborder t_center" style="<c:if test="${fn:length(apprUserList) eq status.count}">border-bottom: 0px solid #ddd;</c:if>">${list.job_nm}</td>
							</tr>
							</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="6" align="center"><spring:message code="global.script.search.no.result" /></td>
								</tr>
							</c:otherwise>
							</c:choose>
						</table>
					</div>
				</div>
			</div>
			<!-- <div class="btn_area_center mg_t10 mg_b10">
				<button type="button" class="btn_big theme" onclick="ok();">확인</button>
				<button type="button" class="btn_big" onclick="cancle();">취소</button>
			</div> -->
		</div>
	</div>
	</form>
</body>
</html>