<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<script type="text/javascript" src="<c:url value="/JavaScript/moment.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/calendar.js" />"></script>
<%-- 
-----------------------------------------
parameter example
-----------------------------------------
<jsp:param name="startName" value="start_date" />	: 시작일 input name
<jsp:param name="endName" value="end_date" />	: 종료일 input name
<jsp:param name="width" value="100" />		 : 너비
<jsp:param name="startDay" value="${repository.start_date}" />	: 시작일 값
<jsp:param name="endDay" value="${repository.end_date}" />	: 종료일 값
<jsp:param name="showSPastDate" value="N" /> 	: 시작일 과거날짜 보여주기 여부
<jsp:param name="showEPastDate" value="Y" />	: 종료일 과거날짜 보여주기 여부
<jsp:param name="formName" value="lform" />		: form 이름
--%>
<script>
var nowMDate = moment(now).format('YYYY-MM-DD');
function checkDateBefore(obj) {
	if( (moment(obj.value + " 00:00:00").isBefore(moment(now), 'day')) ) {
		alert("유효하지 않은 날짜입니다. 과거 날짜를 선택할 수 없습니다.");
		obj.value = nowMDate;
	}
}
</script>
<span class="search_day">
<input type="text" name="${param.startName != null ? param.startName : 'startDay' }" id="${param.startName != null ? param.startName : 'startDay' }" value="${param.startDay}" class="text_input short t_center" style="width:${param.width}px;" 
	<c:if test="${ param.showSPastDate eq 'N' }"> onchange="checkDateBefore(this)"</c:if> readonly/>
	<img class="img_ico" onclick="showCalendar('<c:out value="${param.formName}" />', '<c:out value="${param.startName != null ? param.startName : 'startDay' }"/>', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">
</span>
&#126;
<span class="search_day">
	<input type="text" name="${param.endName != null ? param.endName : 'endDay' }" id="${param.endName != null ? param.endName : 'endDay' }" value="${param.endDay}" class="text_input short t_center" style="width:${param.width}px;"
	<c:if test="${ param.showEPastDate eq 'N' }"> onchange="checkDateBefore(this)"</c:if> readonly />
	<img class="img_ico" onclick="showCalendar('<c:out value="${param.formName}"/>', '<c:out value="${param.endName != null ? param.endName : 'endDay' }"/>', event);" src="<c:url value="/Images/icon/ico_cal.gif" />" width="14" height="14">&nbsp;&nbsp;
</span>