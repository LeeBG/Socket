<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<script type="text/javascript" src="<c:url value="/JavaScript/moment.js" />"></script>
<script type="text/javascript">
function initRepoVolumePeriod() {
	
	checkFocusMessage($("#repoPeriodInput"), "1 ~ 999자리까지 입력이 가능합니다.");
	
	$("#repoStartDateSpan").html(moment(now).format('YYYY-MM-DD'));
	$("#repoEndDateSpan").html(moment(now).format('YYYY-MM-DD'));
	
	$("#repoPeriodInput").on('keyup',function(event) {
		onlyNumBetweenFillter( $(this).get(0), 3, 1, 999 );
		changeRepoVolumePeriod( $(this) );
	});
}

function changeRepoVolumePeriod(obj) {
	var value = obj.val();
	if( value.length == 0 ) value = 0;
	
	$("#repoEndDateSpan").html(moment(now).add(value, 'days').format('YYYY-MM-DD'));
}
</script>

<input type="hidden" id="start_date" name="start_date" value="${param.start_date_value}" />
<input type="hidden" id="end_date" name="end_date" value="${param.end_date_value}" />