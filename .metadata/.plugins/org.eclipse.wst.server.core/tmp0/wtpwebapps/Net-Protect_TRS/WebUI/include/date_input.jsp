<%@ page contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<span class="search_day">
	<input type="text" name="startDay" id="startDay" placeholder="YYYY-MM-DD" value="${param.s_day}" readonly class="text_input short t_center" style="margin-right:3px;"/>
	<input type="text" name="startHour" id="startHour" placeholder="HH" maxLength="2" value="${param.s_hour}" style="width:40px;" /><span class="b_text"><spring:message code="data.file.receiveList.search.sendDate.hour" /></span>
	<input type="text" name="startMin"  id="startMin" placeholder="MM" maxLength="2" value="${param.s_min}" style="width:40px;" /><span class="b_text"><spring:message code="data.file.receiveList.search.sendDate.minute" /></span>
</span>
&#126;
<span class="search_day">
	<input type="text" name="endDay" id="endDay" placeholder="YYYY-MM-DD" value="${param.e_day}" class="text_input short t_center" readonly  style="margin-right:3px;"/>
	<input type="text" name="endHour" id="endHour" placeholder="HH" maxLength="2" value="${param.e_hour}" style="width:40px;" /><span class="b_text"><spring:message code="data.file.receiveList.search.sendDate.hour" /></span>
	<input type="text" name="endMin" id="endMin" placeholder="MM" maxLength="2" value="${param.e_min}" style="width:40px;" /><span class="b_text"><spring:message code="data.file.receiveList.search.sendDate.minute" /></span>
</span>
