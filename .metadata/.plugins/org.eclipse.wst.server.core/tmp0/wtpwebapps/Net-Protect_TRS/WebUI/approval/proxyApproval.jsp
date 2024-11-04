<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<c:set var="getSiteCode" value="${customfunc:getSiteCode()}" />

<link href="<c:url value="/css/calendar.css" />" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<c:url value="/JavaScript/calendar.js" />"></script>
<script type="text/javascript">
	var proxyMaxPeriod = "<c:out value="${proxyMaxPeriod}"/>";
	var siteCode = "<c:out value="${customfunc:getSiteCode()}"/>";
	var periodDuplicationYn =  "<c:out value="${periodDuplicationYn}"/>";
	var proxyPeriodUseYn =  "<c:out value="${proxyPeriodUseYn}"/>";

	$(document).ready(function() {
		bindEventOnSearchDateInput(false, true);

		$('input[type="text"]').keydown(function() {
			if (event.keyCode === 13) {
				event.preventDefault();
				search();
			};
		});
	});

	function search() {
		$("#searchValue").val($("#proxy_search_value").val());
		$("#page").val("1");

		$("#lform").get(0).submit();
	}
	
	function insertProxyApproval(users_id, users_nm) {
		var errmsg = new cls_errmsg();
		
		$("input[name='del_proxy_id']").each(function() {
		    if(users_id == $(this).val()) {
		    	errmsg.append(null, "이미 대리결재자로 설정돼 있는 사용자 입니다.");
				return;
			}
		});

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}
		
		if (confirm("대리 결재자를 추가 하겠습니까?")) {

			// 대결자 기간 중복 체크 허용 or 대결자 기간 미사용일경우 submit
			if ( periodDuplicationYn == 'N' || proxyPeriodUseYn == 'N' ) {
				$("#proxy_id").val(users_id);
				var requestURL = "<c:url value="/approval/updateProxyApproval.lin" />";
				var successURL = "<c:url value="/approval/proxyApproval.lin" />";
				resultCheck($("#lform"), requestURL, successURL, true);
			} else {
				// 기간 중복체크 시 append 된게 있는지 체크한다.
				var isAppendProxy = document.getElementsByName('isAppendProxy');
				if (isAppendProxy.length > 0) {
					alert("설정중인 대리결재자의 기간을 설정한 후 저장해주세요.");
				} else {
					setProxyApprovers(users_id, users_nm);
				}
			}

		}
	}
	
	function delProxy(proxy_id){
		if (confirm("대리결재자를 삭제 하겠습니까?")) {
			$("#proxy_id").val(proxy_id);

			var requestURL = "<c:url value="/approval/deleteProxyApproval.lin" />";
			var successURL = "<c:url value="/approval/proxyApproval.lin" />";
			resultCheck($("#lform"), requestURL, successURL, true);
		}
	}
	
	function updatePeriod(proxy_id) {
		if ( periodDuplicationYn == 'Y' ) {
			if (appendCheckPeriodValidation(proxy_id) == false) return;
		}

		if( ! confirm("기간을 변경하시겠습니까?") ) return;
		
		if( checkPeriodValidation(proxy_id) == false ) return;
		$("#proxy_id").val(proxy_id);
		$("#start_date").val($("input[name='"+proxy_id+"_start_date']").val());
		$("#end_date").val($("input[name='"+proxy_id+"_end_date']").val());
		
		var requestURL = "<c:url value="/approval/proxyPeriod.lin" />";
		var successURL = "<c:url value="/approval/proxyApproval.lin" />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}
	
	function checkPeriodValidation(proxy_id) {
		var startDate = $("input[name='"+proxy_id+"_start_date']").val();
		var endDate = $("input[name='"+proxy_id+"_end_date']").val();
		
		try{
			<c:if test="${ proxyMaxPeriod != null && proxyMaxPeriod > 0}">
				if( ! checkProxyMaxPriod(startDate, endDate) ) throw "최대 설정기간은 " + proxyMaxPeriod + "일 입니다";
			</c:if>
			if( ! dateCheck(startDate, endDate, "day" ) ) throw "날짜가 올바르지 않습니다. 날짜를 확인해주세요.";
		} catch(err) {
			alert(err);
			return false;
		}
		
		return true;
	}
	
	function checkProxyMaxPriod(startDate, endDate) {
		var eDate = moment(endDate);
		var mDate = moment(startDate);
		mDate.add(proxyMaxPeriod , 'days');
		
		return dateCheck(eDate.format('YYYY[-]MM[-]DD'), mDate.format('YYYY[-]MM[-]DD'), "day");
	}

	function setDisabledSearchBox(target){
		var obj = target;
		$(obj).css("display", "none"); 
	}

	function delTable (users_id) {
		$("#" + users_id + "_tr").remove();
	}

	function setProxyApprovers(users_id, users_nm) {
		var result = "";
		result += '	<tr id="' + users_id + '_tr">\n';
		result += '	<td><span id="span_proxy_id">' + users_nm  + ' (' + users_id + ')</span></td>&nbsp;\n';
		result += '	<input type="hidden" name="del_proxy_id" id="' + users_id + '_proxy" data-period-set="false" value=\'' + users_id + '\'"/> \n';
		result += '	<input type="hidden" name="isAppendProxy" value="true"/> \n';

		if ('${proxyPeriodUseYn}' == 'Y') {
			result += '<td> \n';
			result += '<input type="text" id="' + users_id + '_startDay" name="' + users_id + '_start_date" readonly class="text_input short t_center" style="width:100px;"/>\n';
			result += '~\n';
			result += '<input type="text" id="' + users_id + '_endDay" name="' + users_id + '_end_date" readonly class="text_input short t_center" style="width:100px;"/>\n';
			result += '<button class="btn_common theme"  onclick="appendUpdatePeriod(\'' + users_id + '\');">저장</button>\n';
			
			if ('${proxyMaxPeriod}' != null && '${proxyMaxPeriod}' > 0 ) {
				result += '<div id="'+ users_id + '_div_proxy_period_desc" style="margin-top: 5px; " >대리결재 기간을 설정해주세요.</div>\n';
			}

			result += '</td>';
		}

		result += '<td> \n';
		result += '<div><button class="btn_del" type="button" id="'+ users_id + '_del" onclick="delTable(\'' + users_id + '\');"><span class="ir_desc">삭제</span></button></td> \n';
		result += '</td> \n';
		result += '	</tr>\n';

		$("#proxyUsersTable tbody").append(result);
		$("span[name='span_proxy_id']").remove();
		bindEventOnSearchDateInput(false, true);
	}
	
	function appendUpdatePeriod(proxy_id) {
		if (appendCheckPeriodValidation(proxy_id) == false) return;
		if( ! confirm("기간을 설정하시겠습니까?") ) return;
		if( checkPeriodValidation(proxy_id) == false ) return;

		$("#proxy_id").val(proxy_id);
		$("#start_date").val($("input[name='"+proxy_id+"_start_date']").val());
		$("#end_date").val($("input[name='"+proxy_id+"_end_date']").val());
		$("#" + proxy_id + "_div_proxy_period_desc").html('').append('대리결재자 설정 기간은 최대 ' + ${proxyMaxPeriod }+ '일입니다.')
		$("#" + proxy_id + "_proxy").attr("data-period-set", "true");

		$("#proxy_id").val(proxy_id);

		var requestURL = "<c:url value="/approval/updateProxyApproval.lin" />";
		var successURL = "<c:url value="/approval/proxyApproval.lin" />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}

	// 기간 설정 대리결재자 validation check 로직
	function appendCheckPeriodValidation(proxy_id) {
		var start_date = $("input[name='"+proxy_id+"_start_date']").val();
		var end_date = $("input[name='"+proxy_id+"_end_date']").val();
		var isValid = true;

		if (start_date == '') {
			alert("시작날짜를 입력해주세요.");
			$("input[name='"+proxy_id+"_start_date']").focus();
			return false;
		}

		if (end_date == '') {
			alert("종료날짜를 입력해주세요.");
			$("input[name='"+proxy_id+"_end_date']").focus();
			return false;
		}

		$("input[name='del_proxy_id']").each(function () {
			if ($(this).val() == proxy_id) return true;
			if (!$("#" + $(this).val() + "_proxy").attr("data-period-set")) return true; 

			var existingStartDate = $("input[name='" + $(this).val() + "_init_start_date']").val();
			var existingEndDate = $("input[name='" + $(this).val() + "_init_end_date']").val();

			// 입력받은값 (start_date/end_date)이 기존 기간 사이에 있거나, 입력받은값이  기존 기간을 포함하거나.
			if ((start_date >= existingStartDate && start_date <= existingEndDate) || 
				(end_date >= existingStartDate && end_date <= existingEndDate) || 
				(start_date <= existingStartDate && end_date >= existingEndDate)) {
					alert("선택한 기간이 이미 설정된 대리결재자의 기간과 중복됩니다.");
					isValid = false;
					return false; // each문 종료
			}
		});

		return isValid;
	}
</script>

</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/approval/proxyApproval.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="page" name="page" value="${privateApprovalForm.currentPage}"/>
<input type="hidden" id="proxy_id" name="proxy_id" value="${privateApprovalForm.proxy_id}"/>
<input type="hidden" id="proxy_nm" name="proxy_nm" value="${privateApprovalForm.proxy_nm}"/>
<input type="hidden" id="searchValue" name="searchValue" value="${privateApprovalForm.searchValue}"/>
<input type="hidden" id="start_date" name="start_date" value="" />
<input type="hidden" id="end_date" name="end_date" value="" />
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">대리결재자 설정</h2>
				<p class="breadCrumbs">결재관리 > 대리결재자 설정</p>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>대리결재자 설정</h3>
			<div class="conBox">
				<div class="table_area_style02 Tborder">
					<table summary="로그인정책 설정" style="table-layout : fixed">
					<caption>대리결재자 설정</caption>
						<colgroup>
							<col style="width:15%;"/>
							<col style="width:85%;" />
						</colgroup>
						<tbody>
							<tr>
								<th class="t_left">대리결재자</th>
								<td>
									<div class="t_center mg_t10">
									<table id="proxyUsersTable">
										<caption>체크박스, 성명, 직급, 부서</caption>
										<colgroup>
											<col style="width:30%;"/>
											<c:if test="${proxyPeriodUseYn eq 'Y'}">
												<col style="width:50%;"/>
											</c:if>
											<col style="width:20%;"/>
										</colgroup>
										<thead>
											<tr>
												<th class="Rborder">성명(${customfunc:getMessage('common.id.commonid')})</th>
												
												<c:if test="${proxyPeriodUseYn eq 'Y'}">
													<th class="Rborder">기간</th>
												</c:if>
												
												<th class="Rborder"></th>
											</tr>
										</thead>
										<tbody>
											<c:if test="${fn:length(proxyUserList) > 0}">
											<c:forEach items="${proxyUserList}" var="proxyUser">
											<tr>
												<td>
													<span id="span_proxy_id">${proxyUser.proxy_nm} (${proxyUser.proxy_id})</span>&nbsp;
													<input type="hidden" name="del_proxy_id" id="${proxyUser.proxy_id}_proxy" data-period-set="true" value="${proxyUser.proxy_id}"/>
												</td>
												<c:if test="${proxyPeriodUseYn eq 'Y'}">
													<td>
														<input type="text" id="${proxyUser.proxy_id}_startDay" name="${proxyUser.proxy_id}_start_date" value="${proxyUser.display_start_date}" readonly class="text_input short t_center" style="width:100px;"/>
														~
														<input type="text" id="${proxyUser.proxy_id}_endDay" name="${proxyUser.proxy_id}_end_date" value="${proxyUser.display_end_date}" readonly class="text_input short t_center" style="width:100px;"/>
														<button class="btn_common theme"  onclick="updatePeriod('${proxyUser.proxy_id}');">
																변경
														</button>
														<c:if test="${ proxyMaxPeriod != null && proxyMaxPeriod > 0 }">
															<div id="div_proxy_period_desc" style="margin-top: 5px; " >대리결재자 설정 기간은 최대 ${proxyMaxPeriod }일입니다.</div>
														</c:if>
														<input type="hidden" id="${proxyUser.proxy_id}_init_startDay" name="${proxyUser.proxy_id}_init_start_date" value="${proxyUser.display_start_date}" >
														<input type="hidden" id="${proxyUser.proxy_id}_init_endDay" name="${proxyUser.proxy_id}_init_end_date" value="${proxyUser.display_end_date}" >
													</td>
												</c:if>
												<td>
													<button class="btn_common mg_l5" id="${proxyUser.proxy_id}" onclick="delProxy('${proxyUser.proxy_id}')" >
															삭제
													</button>
												</td>
											</tr>
											</c:forEach>
											</c:if>
											<c:if test="${fn:length(proxyUserList) == 0}">
												<tr>
													<td style="padding : 15px 5px 0px 20px; border-bottom : none;" colspan="3"><span id="span_proxy_id" name="span_proxy_id" class="no_result">지정된 대리 결재자가 없습니다.</span></td>
												</tr>
											</c:if>
										</tbody>
									</table>
									</div>
								</td>
							</tr>
							<tr id="approver_searchBox">
								<th class="t_left">대리결재자 선택</th>
								<td>
									<div id="findApproverDiv" class="sub_findApprover_wrap">
										<div class="sub_findApprover_box">
											<input type="text" class="text_input mid" id="proxy_search_value" name="proxy_search_value" value="${privateApprovalForm.searchValue}"/>&nbsp;
											<button class="btn_common theme" onclick="search()">
												검색
											</button>
										</div>
										<div class="t_center mg_t10 mg_b10">
											<table summary="결재관리 테이블입니다." style="table-layout : fixed">
											<caption>체크박스, 성명, 직급, 부서</caption>
												<colgroup>
													<col style="width:30%;"/>
													<col style="width:20%;"/>
													<col style="width:30%;" />
													<col style="width:20%;" />
												</colgroup>
												<thead>
													<tr>
														<th class="Rborder">성명(${customfunc:getMessage('common.id.commonid')})</th>
														<c:choose>
															<c:when test="${getSiteCode eq 'kcredit' }">
																<th class="Rborder">직책</th>
															</c:when>
															<c:otherwise>
																<th class="Rborder">직급</th>
															</c:otherwise>
														</c:choose>
														<th class="Rborder">부서명</th>
														<th class="Rborder"></th>
													</tr>
												</thead>
												<tbody>
												<c:choose>
													<c:when test="${not empty userList}">
													<c:forEach items="${userList}" var="user">
														<tr>
															<td><span style="padding-left:13px;">${user.users_nm} (${user.users_id})</span></td>
															<c:choose>
																<c:when test="${getSiteCode eq 'kcredit' }">
																	<td>${user.job_nm}</td>
																</c:when>
																<c:otherwise>
																	<td>${user.position_nm}</td>
																</c:otherwise>
															</c:choose>
															<td>${user.dept_nm}</td>
															<td><button class="btn_common theme" onclick="insertProxyApproval('${user.users_id}', '${user.users_nm}')" >추가</button></td>
														</tr>
													</c:forEach>
													</c:when>
													<c:otherwise>
														<tr>
															<td class="t_center" colspan="4"><div class="no_result"><spring:message code="person.findUsersPopup.script.no.user" /></div></td>
														</tr>
													</c:otherwise>
												</c:choose>
												</tbody>
												<tfoot>
													<tr>
														<td colspan="4" class="td_last" style="background-color: #EEEEEE;">
															<jsp:include page="/WebUI/include/footer_list_count_select.jsp">
																<jsp:param name="size" value="${privateApprovalForm.pageListSize}"/>
																<jsp:param name="currentPage" value="${privateApprovalForm.currentPage}"/>
															</jsp:include>
														</td>
													</tr>
												</tfoot>
											</table>
										</div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/WebUI/common/calendar.jsp" %>
</form>
</body>
</html>
