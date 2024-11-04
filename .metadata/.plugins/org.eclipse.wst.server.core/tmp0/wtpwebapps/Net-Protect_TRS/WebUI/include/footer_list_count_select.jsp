<%@ page contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<style>
.footer_div0 {
	width: 100%; height : 30px;
}
.footer_div1 {
	float: left; width: 33%; height : 30px; text-align: left; margin-top : 15px;
}
.footer_div2 {
	float: left; width: 33%; height : 30px; text-align: center; margin-top : 15px;
}
.footer_div3 {
	float: left; width: 33%; height : 30px; text-align: right; margin-top : 10px;
}
</style>

<div class="footer_div0">
	<div class="footer_div1"><spring:message code="global.script.search.count" arguments="${paging.totalCount}" /></div>
	<div class="footer_div2 pagenate">
		${pageList}
	</div>
	<div class="footer_div3">
		목록 갯수 : 
		<select id="pageListSize" name="pageListSize" title="목록 갯수" class="mg_l20" onchange="goPage(${param.currentPage});">
			<option <c:if test="${param.size == 10}">selected="selected"</c:if> value="10">10</option>
			<option <c:if test="${param.size == 20}">selected="selected"</c:if> value="20">20</option>
			<option <c:if test="${param.size == 30}">selected="selected"</c:if> value="30">30</option>
			<option <c:if test="${param.size == 40}">selected="selected"</c:if> value="40">40</option>
			<option <c:if test="${param.size == 50}">selected="selected"</c:if> value="50">50</option>
		</select>개
	</div>
</div>