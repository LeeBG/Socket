<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>

<style>
li {
	line-height:20px;
}
</style>
<h3>setting_code에 이용되는 값</h3>
<table summary="설명" style="table-layout: fixed;">
	<caption>value, 설명, setting_code</caption>
	<colgroup>
		<col style="width: 30%;" />
		<col style="width: 40%;" />
		<col style="width: 30%;" />
	</colgroup>
	<thead>
		<tr>
			<th>setting_code</th>
			<th>value</th>
			<th>설명</th>
			
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="Rborder" rowspan="2">
				<li>
					<ul>approval.use</ul>
				</li>
			</td>
			<td class="Rborder">0</td>
			<td>사용안함</td>
		</tr>
		<tr>
			<td class="Rborder">1</td>
			<td>사이트DB쿼리방식 (사이트코드 필수)</td>
		</tr>
		<tr>
			<td class="Rborder" rowspan="3">
				<li>
					<ul>dept.use</ul>
					<ul>user.use</ul>
				</li>
			</td>
			<td class="Rborder">0</td>
			<td>사용안함</td>
		</tr>
		<tr>
			<td class="Rborder">1</td>
			<td>DB연동방식 (사이트코드 필수)</td>
		</tr>
		<tr>
			<td class="Rborder">2</td>
			<td>파일연동방식 (사이트코드 필수)</td>
		</tr>
	</tbody>
</table>