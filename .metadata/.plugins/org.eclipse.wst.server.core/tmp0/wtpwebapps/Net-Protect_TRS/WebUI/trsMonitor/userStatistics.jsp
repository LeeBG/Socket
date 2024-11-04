<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>

<script type="text/javascript">

var jqgrid_manager = new jqGridManager();
$(document).ready(function() {
	bindEventOnSearchDateInput();
	jqgrid_manager.setting("user");
	jqgrid_manager.init(jqgridModel,formVal);
	
	// enter로 검색 
	$("input[name=searchValue]").keydown(function(e){
		if(e.keyCode == 13){
			reload();
		}
	});
});

function download(){

	var frm = document.forms['lform'];
	frm.action = '<c:url value="/trsMonitor/userStatisticsExcelDownlaod.lin" />';
	frm.submit();
	
	frm.action= '<c:url value="/trsMonitor/userStatistics.lin" />';
}

function reload(){
	if( ! isValidDateValue() )
		return; 
	
	jqgrid_manager.setting("user");
	jqgrid_manager.reload(jqgridModel,formVal);
}

</script>
<form id="lform" name="lform" onsubmit="return false;" method="post" >
	<input type="hidden" id="sidx" name="sidx" value="" />
	<input type="hidden" id="sord" name="sord" value="" />
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<input type="hidden" id="inner" value ="${customfunc:codeDes('NP_CD', 'I')}" />
	<input type="hidden" id="outer" value ="${customfunc:codeDes('NP_CD', 'O')}" />
	<div class="detail-container-wrap">
		<div id="officeDetail" style="width: 100%; min-width: 1180px; max-width: 1800px; margin: 0 auto;">
			<div style="width: 95%; margin: 0 auto;">
				<div class="officeDetailLayout">
					<div class="detail-title">
						<jsp:include page="/WebUI/include/detail_Menu.jsp" >
							<jsp:param name="pageName" value="사용자별 통계" />
						</jsp:include>
					</div>
					<div class="users_div">
						<div class="detailBox">
							<div class="table_area_style_total">
								<div class="rightArea">
									<div class="conBox searchBox">
										<div class="topCon">
											<table cellspacing="0" cellpadding="0" summary="검색조건" style="table-layout : fixed" id="searchTable">
											<caption>검색조건, 버튼</caption>
											<tbody>
											<colgroup>
												<col class="col-layout"/>
											</colgroup>
												<tr>
													<td class="test">
														<span class="period">기간선택</span>
														<span class="search_day">
															<input type="text" name="startDay" value="${TrsUserStatistics.startDay}" class="text_input short t_center trs_input"/>
														</span>
														~
														<span class="search_day">
															<input type="text" name="endDay" value="${TrsUserStatistics.endDay}" class="text_input short t_center trs_input"/>
														</span>
														
														<select title="검색조건" id="searchField" name="searchField" style="">
															<option value="user_id" ${TrsUserStatistics.searchField == 'user_id' ? ' selected' : ''}>사용자ID</option>
															<option value="user_nm" ${TrsUserStatistics.searchField == 'user_nm' ? ' selected' : ''}>사용자명</option>
															<option value="dept_nm" ${TrsUserStatistics.searchField == 'dept_nm' ? ' selected' : ''}>부서</option>
														</select>
														<input type="text" name="searchValue" id="searchValue" value="${TrsUserStatistics.searchValue }" placeholder="검색어를 입력해주세요."/>
														
														<button type="button" id="excel_down" class="btn_common trs_button" onclick="download();">엑셀 다운로드</button>
														<button type="button" class="btn_common trs_button" onclick="location.href='userStatistics.lin'">초기화</button>
														<button type="button" class="btn_common trs_button" onclick="reload();">조회</button>
													</td>
												</tr>
											</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="users_div">
						<div class="detailBox">
							<div class="table_area_style_total">
								<table id="mainGrid"></table>
								<div id="pager"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form> 
