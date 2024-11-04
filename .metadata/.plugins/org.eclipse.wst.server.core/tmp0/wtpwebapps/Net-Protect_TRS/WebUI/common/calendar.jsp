<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<html>
<head>
</head>

<body>
	<div id="calendar_lyr">
		<div class="calendarBox">
			<table cellspacing="1" cellpadding="0" summary="calendar" style="table-layout : fixed"  >
				<tr>
					<td>
						<form name="calendarControl" action="" onSubmit="return false;">
						<table width="100%" cellspacing="0" cellpadding="0" style="table-layout : fixed" class="topTable mg_t5">
							<colgroup>
								<col width="15%;" />
								<col width="70%" />
								<col width="15%;" />
							</colgroup>
							<tr>
								<td class="t_center">
									<input type="button" class="direction prev" onClick="prevMonth()">
								</td>
								<td class="t_center">
									<select name="year" onChange="displayCalendar(0)"></select>
									<select name="month" onChange="displayCalendar(0)">
										<option value="01">1</option>
										<option value="02">2</option>
										<option value="03">3</option>
										<option value="04">4</option>
										<option value="05">5</option>
										<option value="06">6</option>
										<option value="07">7</option>
										<option value="08">8</option>
										<option value="09">9</option>
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
									</select>
								</td>
								<td class="t_center">
									<input type="button" class="direction next" onClick="nextMonth()">
								</td>
							</tr>
						</table>
						</form>
					</td>
				</tr>
				<tr>
					<td>
						<form name="calendarButtons" action="" onSubmit="return false;">
						<table cellspacing="1" cellpadding="0" class="table">
							<tr>
								<td class="header"><spring:message code="common.calendar.sunday" /></td>
								<td class="header"><spring:message code="common.calendar.monday" /></td>
								<td class="header"><spring:message code="common.calendar.tuesday" /></td>
								<td class="header"><spring:message code="common.calendar.wednesday" /></td>
								<td class="header"><spring:message code="common.calendar.thursday" /></td>
								<td class="header"><spring:message code="common.calendar.friday" /></td>
								<td class="header"><spring:message code="common.calendar.saturday" /></td>
							</tr>
							<tr>
								<td class="body"><input type="button" class="red" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="blue" onclick="getDate(this.value)"></td>
							</tr>
							<tr>
								<td class="body"><input type="button" class="red" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="blue" onclick="getDate(this.value)"></td>
							</tr>
							<tr>
								<td class="body"><input type="button" class="red" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="blue" onclick="getDate(this.value)"></td>
							</tr>
							<tr>
								<td class="body"><input type="button" class="red" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="blue" onclick="getDate(this.value)"></td>
							</tr>
							<tr>
								<td class="body"><input type="button" class="red" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="blue" onclick="getDate(this.value)"></td>
							</tr>
							<tr>
								<td class="body"><input type="button" class="red" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="black" onclick="getDate(this.value)"></td>
								<td class="body"><input type="button" class="blue" onclick="getDate(this.value)"></td>
							</tr>
						</table>
						</form>
					</td>
				</tr>
				<tr>
					<td class="t_center">
						<button type="submit" href="javascript:;" onClick="calendarClose();return false;" class="btn_common mg_t5 mg_b5">닫기</button>
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>
