<%@ page contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="getSiteCode" value="${customfunc:getSiteCode()}" />

<input type="hidden" name="startDay" value="${param.s_day}"/>
<input type="hidden" name="endDay" value="${param.e_day}"/>
<input type="hidden" id="period" name="period" value="${param.period}"/>
<input type="hidden" id="today" value="${param.t_day}"/>
<span class="search_day">
	<span id="startDayText">${param.s_day}</span>
</span>
&#126;
<span class="search_day">
	<span id="endDayText">${param.e_day}</span>
</span>
<c:choose>
	<c:when test="${getSiteCode eq 'cnuh' }">
		<button id="btn_day_first" type="button" class="btn_common mg_l5 period_btn ${param.period eq 7 ? 'active':''}" data-day="7" onclick="changeDate(7);">7일</button>
		<button id="btn_day_second" type="button" class="btn_common mg_l5 period_btn ${param.period eq 10 ? 'active':''}" data-day="10" onclick="changeDate(10);">10일</button>
	</c:when>
	<c:when test="${getSiteCode eq 'mcst' || getSiteCode eq 'museum' || getSiteCode eq 'sejong_nl' || getSiteCode eq 'nl'}">
		<input type="radio" id="btn_month_first" ${param.period eq 1 ? 'checked':''} data-month="1" onclick="changeMonth(this);"/> 1개월
		<input type="radio" id="btn_month_second" ${param.period eq 3 ? 'checked':''} data-month="3" onclick="changeMonth(this);"/> 3개월
		<input type="radio" id="btn_month_third" ${param.period eq 6 ? 'checked':''} data-month="6" onclick="changeMonth(this);"/> 6개월
	</c:when>
	<c:otherwise>
		<button id="btn_day_first" type="button" class="btn_common mg_l5 period_btn ${param.period eq 1 ? 'active':''}" data-day="1" onclick="changeDate(1);">1일</button>
		<button id="btn_day_second" type="button" class="btn_common mg_l5 period_btn ${param.period eq 3 ? 'active':''}" data-day="3" onclick="changeDate(3);">3일</button>
	</c:otherwise>
</c:choose>
<a href="javascript:showDateInput();" id="btn_day_manual" class="manualdate_btn ${param.period eq -1 ? 'active':''}" data-day="-1" >
	<span style="vertical-align: middle;">직접입력</span>
	<img id="manIcon" src="/Images/contents/pageLocation_separater.gif">
</a>
<div id="dateInputDiv" class="nonevisible">
	<input type="text" id="startDay" value="${param.s_day}" readonly class="text_input short t_center" style="margin-right:3px;"/>
	~
	<input type="text" id="endDay" value="${param.e_day}" readonly class="text_input short t_center" style="margin-right:3px;"/>
	<button class="btn_common theme mg_l5" type="button" onclick="setDateTextFromDateInputDiv();">적용</button>
</div>
