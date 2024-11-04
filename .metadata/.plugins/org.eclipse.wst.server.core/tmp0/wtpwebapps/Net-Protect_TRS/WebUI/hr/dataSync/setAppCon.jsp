<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<script type="text/javascript">

	var appConditionUtil = {
			save: function() {
				alert("저장");
			},
			runCondition: function() {
				alert("실행결과");
			},
			addRow: function(obj) {
				obj.closest("tr").before(this.getRowElement());
			},
			deleteRow: function(obj) {
				obj.closest("tr").remove();
			},
			addNewRow: function(obj) {
				obj.closest("tr").before(this.getRowElement());
			},
			getRowElement : function () {
				var row = 
				'<tr class="clause clause-row">'
				+ '<td class="add-remove">'
					+ '<button role="button" tabindex="${status.index}" aria-label="Insert new filter line" class="btn_common controlButton add" onclick="javascript:appConditionUtil.addRow($(this));">&nbsp;</button> '
					+ '<button role="button" tabindex="${status.index}" aria-label="Remove this filter line" class="btn_common controlButton delete" onclick="javascript:appConditionUtil.deleteRow($(this));">&nbsp;</button>'
				+ '</td>'
				+ '<td class="logical t_center">'
					+ '<div id="vss_47" class="combo input-text-box no-edit list drop">'
						+ '<select>'
						+ '<option value="AND">그리고</option>'
							+ '<option value="OR">또는</option>'
						+ '</select>'
					+ '</div>'
				+ '</td>'
				+ '<td class="field t_center">'
					+ '<div id="vss_30" class="combo input-text-box list drop">'
						+ '<div class="wrap">'
							+ '<select>'
								+ '<option value="DEPT_ID">부서코드</option>'
								+ '<option value="DEPT_NM">부서명</option>'
								+ '<option value="POSITION_ID">직책코드</option>'
								+ '<option value="POSITION_NM">직책명</option>'
								+ '<option value="JOB_ID">직무코드</option>'
								+ '<option value="JOB_NM">직무명</option>'
							+ '</select>'
						+ '</div>'
					+ '</div></td>'
					+ '<td class="operator t_center">'
						+ '<div id="vss_33" class="combo input-text-box list drop">'
							+ '<select>'
								+ '<option value="IN">포함</option>'
								+ '<option value="NOTIN">미포함</option>'
							+ '</select>'
						+ '</div>'
					+ '</td>'
				+ '<td class="value t_center">'
					+ '<div id="vss_36" class="field-filter-value-control">'
						+ '<div id="vss_40" class="combo input-text-box list drop">'
							+ '<div class="wrap">'
								+ '<input type="text" placeholder="값을 입력하세요.">'
							+ '</div>'
						+ '</div>'
					+ '</div>'
				+ '</td>'
			+ '</tr>';
				return row;
			}
	}
	
	function redirect(url) {
		window.location.href = url;
	}
</script>
<style>
.controlButton {
	width:25px;
	font-weight: 700;
	color: #5a5a5a;
}
.delete {
	background:transparent url("/Images/button/btn_delete.png") no-repeat center center;
}
.add {
    background:transparent url("/Images/button/btn_add.png") no-repeat center center;
}
</style>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/cache/setCache.lin" />">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<input id="setting_category" name="setting_category" type="hidden" />
	<input id="setting_code" name="setting_code" type="hidden" />
	<input id="value" name="value" type="hidden" />
	
	<div class="topArea">
		<div class="top_page_icon">
			<img src="/Images/icon/icon_page_I_white.png">
		</div>
		<div class="top_title">
			자료전송 시스템 관리자
			</div>
	</div>
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold">결재자 설정</h2>
			<p class="breadCrumbs">결재자 설정</p>
		</div>
	</div>
	
	<!-- contents -->
	<div class="rightArea">
	<div class="conWrap tableBox">
		<h3>인사DB동기화 셋팅</h3>
		<div class="conBox">
			<div class="table_area_style01">
				<div class="btn_area_right mg_r10 mg_t10 mg_b10">
					<button type="button" class="btn_common" onclick="javascript:redirect('/hr/dataSync/index.lin');">인사DB동기화 메뉴로</button>
				</div>
				<div class="btn_area_left mg_l10 mg_t10 mg_b10">
					<input type="text" id="condition_nm" name="condition_nm" placeholder="조건명" style="width:200px;">
					<button type="button" class="btn_common" onclick="javascript:appConditionUtil.save();">저장</button>
					<button type="button" class="btn_common" onclick="javascript:appConditionUtil.runCondition();">실행결과</button>
				</div>
				<div class="filters">
					<fieldset class="source">
						<legend>Filters for top level work items</legend>
						<div id="vss_10" class="query-filter source-filter">
							<table class="clauses">
								<tbody>
									<colgroup>
										<col style="width: 10%;" />
										<col style="width: 15%;" />
										<col style="width: 15%;" />
										<col style="width: 15%;" />
										<col style="width: 45%;" />
									</colgroup>
									<thead>
										<tr class="header">
											<th class="add-remove"></th>
											<th class="logical">그리고/또는</th>
											<th class="field">필드</th>
											<th class="operator">작업형태</th>
											<th class="value">값</th>
										</tr>
									</thead>
									<c:forEach begin="0" end="1" step="1" varStatus="status">
										<tr class="clause clause-row">
											<td class="add-remove">
												<c:if test="${status.count gt 1}">
													<button role="button" tabindex="${status.index}" aria-label="Insert new filter line" class="btn_common controlButton add" onclick="javascript:appConditionUtil.addRow($(this));">&nbsp;</button>
													<button role="button" tabindex="${status.index}" aria-label="Remove this filter line" class="btn_common controlButton delete" onclick="javascript:appConditionUtil.deleteRow($(this));">&nbsp;</button>
												</c:if>
											</td>
											<td class="logical t_center">
												<c:if test="${status.count gt 1}">
													<div id="vss_47" class="combo input-text-box no-edit list drop">
														<select>
															<option value="AND">그리고</option>
															<option value="OR">또는</option>
														</select>
													</div>
												</c:if>
											</td>
											<td class="field t_center">
												<div id="vss_30" class="combo input-text-box list drop">
													<div class="wrap">
														<select>
															<option value="DEPT_ID">부서코드</option>
															<option value="DEPT_NM">부서명</option>
															<option value="POSITION_ID">직책코드</option>
															<option value="POSITION_NM">직책명</option>
															<option value="JOB_ID">직무코드</option>
															<option value="JOB_NM">직무명</option>
														</select>
													</div>
												</div></td>
											<td class="operator t_center">
												<div id="vss_33" class="combo input-text-box list drop">
													<select>
														<option value="IN">포함</option>
														<option value="NOTIN">미포함</option>
													</select>
												</div>
											</td>
											<td class="value t_center">
												<div id="vss_36" class="field-filter-value-control">
													<div id="vss_40" class="combo input-text-box list drop">
														<div class="wrap">
															<input type="text" placeholder="값을 입력하세요.">
														</div>
													</div>
												</div>
											</td>
										</tr>
									</c:forEach>
									<tr class="add-clause clause-row">
										<td class="add-remove" colspan="5">
											<span></span><button class="add-row-link btn_common" onclick="javascript:appConditionUtil.addNewRow($(this));">새 항목 추가</button>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</fieldset>
				</div>
			</div>
		</div>
	</div>
	</div>
</form>
</body>
</html>
