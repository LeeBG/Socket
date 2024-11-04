<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<%@include file="/WebUI/include/encryptUtil.jsp" %>
<script type="text/javascript">
	function updateCache(category, code, idx, value) {
		$("#setting_category").val(category);
		$("#setting_code").val(code);
		$("#value").val($("#value_" + idx).val());
		
		var requestURL = "<c:url value='/hr/dataSync/updateHrSync.lin' />";
		var successURL = "<c:url value='/hr/dataSync/setHrSync.lin' />";
		resultCheck($("#lform"), requestURL, successURL, true);
	}
	
	function redirect(url) {
		window.location.href = url;
	}
	
	$(document).ready(function() {
		$("input[name='userSyncUse']").change(function() {
			showOptionDetailDiv($(this).val(), "user");
		});
		
		$("input[name='deptSyncUse']").change(function() {
			showOptionDetailDiv($(this).val(), "dept");
		});
		
		$("input[name='approvalSyncUse']").change(function() {
			showOptionDetailDiv($(this).val(), "approval");
		});
	});
	
	function showOptionDetailDiv(optionId, section) {
		var divName = section + "SyncUse";
		var classSelector = "." + section + "SyncUseDetail";
		$(classSelector).each(function() {
			if( $(this).attr("id") == divName + optionId + "Div" ) $(this).removeClass("none");
			else $(this).addClass("none");
		})
	}
	
	function save() {
		if (confirm("인사정보연동 설정을 저장하시겠습니까?")) {
			
			var requestURL = "<c:url value="/hr/dataSync/updateHrSyncData.lin" />";
			var successURL = "<c:url value="/hr/dataSync/setHrSync.lin" />";

			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				var message = response['message'];
				if (code == '200') {
					alert('설정을 저장하였습니다.');
					$(location).attr("href", successURL);
				} else {
					alert(message);
					$(location).attr("href", successURL);
				}
			});
		}
	}
	
	function popUpView(useMode){
		$("#useMode").val(useMode);
		var url = "<c:url value="/hr/dataSync/utilHrSync.lin" />";
		var attibute = "width=1000, height=800, directories=no, resizable=yes, scrollbars=yes, top=5, left=5, toolbar=no";
		var popupWindow = window.open(url, "popup", attibute);
		popupWindow.focus();

		var form = document.forms['lform'];
		form.action = "<c:url value="/hr/dataSync/utilHrSync.lin" />";
		form.method="POST";
		form.target="popup";
		form.submit();
	}
</script>
<style>
li {
	line-height:20px;
}

input[type='radio'], label{
	cursor: pointer;
}

label:hover{
	color: #7daad9 !important;
}
div.syncDetailDiv{
	margin-top: 8px;
	/*margin-left: 30px;*/
	line-height: 30px;
	border: 1px solid #dedede;
    padding: 10px 15px;
    border-radius: 4px;
    font-size: 13px;
}

.settingOptionDiv input[type='radio']:checked+label {
	color: #0c5199;
}

.detailOption strong {
	display: inline-block;
	float: left;
	width: 115px;
	font-weight: 400;
}

div.settingOptionDiv {
	line-height: 25px;
}

div.settingOptionDiv .settingOptionDesc {
	margin-left: 20px;
	font-size: 12px;
}
.selectMiddle {
	width: 150px;
}
.sectionDiv:not(:last-child) {
	padding-bottom: 20px;
    border-bottom: 1px solid #dedede;
    margin-bottom: 20px;
}

</style>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/dataSync/setHrSync.lin" />">
	<input type="hidden"id="useMode" name="useMode" />
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<!-- contents -->
	<div class="topWarp">
		<div class="titleBox">
			<h2 class="f_left text_bold">인사정보연동 설정</h2>
			<p class="breadCrumbs">인사정보연동 설정</p>
		</div>
	</div>
	<div class="rightArea">
		<div class="btn_area_right mg_r10 mg_t10 mg_b10">
			<button type="button" class="btn_common" onclick="javascript:redirect('/hr/dataSync/index.lin');">인사정보연동 메뉴로</button>
		</div>
		<div class="conWrap tableBox">
			<h3>인사정보연동 설정</h3>
			<div class="conBox">
				<div class="table_area_style02">
					
					<table summary="인사DB동기화 셋팅" style="table-layout: fixed" >
						<caption>name, value, button</caption>
						<colgroup>
							<col style="width: 20%;" />
							<col style="width: 80%;" />
						</colgroup>
						<tbody id="values">
							<tr>
								<th class="Rborder">연동 사용 설정</th>
								<td class="Rborder Tborder">
									<div class="sectionDiv">
										<div class="settingOptionDiv">
											<div class="text_bold">사용자 목록 연동 </div>
											<input type="radio" name="userSyncUse" id="userSyncUse0" value="0" <c:if test="${hrSyncData.userSyncUse eq '0' }">checked</c:if> > <label for="userSyncUse0">사용 안함</label><br>
											<input type="radio" name="userSyncUse" id="userSyncUse1" value="1" <c:if test="${hrSyncData.userSyncUse eq '1' }">checked</c:if> > <label for="userSyncUse1">쿼리연동방식</label>
											<button type="button" class="btn_common mg_15 " onclick="popUpView('user.query');" >설정</button><br>
											<div class="settingOptionDesc">- SQL쿼리를 활용해서 사용자 목록을 동기화합니다.</div>
											<input type="radio" name="userSyncUse" id="userSyncUse2" value="2" <c:if test="${hrSyncData.userSyncUse eq '2' }">checked</c:if> > <label for="userSyncUse2">파일연동방식</label>
											<div class="settingOptionDesc">- 파일을 활용해서 사용자 목록을 동기화합니다. 파일 위치, 인코딩 설정이 필수 입니다.</div>
											<input type="radio" name="userSyncUse" id="userSyncUse3" value="3" <c:if test="${hrSyncData.userSyncUse eq '3' }">checked</c:if> > <label for="userSyncUse3">XML연동방식</label>
											<div class="settingOptionDesc">- XML 파일을 활용해서 사용자 목록을 동기화합니다. 파일 위치, 인코딩 설정이 필수 입니다.</div>
											<input type="radio" name="userSyncUse" id="userSyncUse4" value="4" <c:if test="${hrSyncData.userSyncUse eq '4' }">checked</c:if> > <label for="userSyncUse4">AD연동방식</label>
											<div class="settingOptionDesc">- AD연동을 활용해서 사용자 목록을 동기화합니다.</div>
											<input type="radio" name="userSyncUse" id="userSyncUse5" value="5" <c:if test="${hrSyncData.userSyncUse eq '5' }">checked</c:if> > <label for="userSyncUse4">API연동방식</label>
											<div class="settingOptionDesc">- API연동을 활용해서 사용자 목록을 동기화합니다.</div>
										</div>

										<div id="userSyncUse1Div" class='userSyncUseDetail syncDetailDiv <c:if test="${ hrSyncData.userSyncUse ne '1' }">none</c:if>' >
											<div class="text_bold">쿼리연동방식 상세 설정</div>
											<div class="detailOption">※ 쿼리연동방식을 사용하기 위해서 HrSync_<c:out value="${siteCode }" />.selectSiteUserList_<c:out value="${siteCode }" /> 쿼리Key가 등록되어 있어야 합니다.</div>
										</div>
										
										<div id="userSyncUse2Div" class='userSyncUseDetail syncDetailDiv <c:if test="${ hrSyncData.userSyncUse ne '2' }">none</c:if>' >
											<div class="text_bold">파일연동방식 상세 설정</div>
											<div class="detailOption">
												<strong>연동 파일 위치</strong>
												<input class="text_input long" name="userFileLocation" type="text" value="${hrSyncData.userFileLocation }" /><br>
												<strong>파일 인코딩</strong>
												<select id="userFileEncoding" name="userFileEncoding" class="selectMiddle">
													<option value="EUC-KR" ${ ( hrSyncData.userFileEncoding eq 'EUC-KR' ) ? "selected='selected'" : ""} >EUC-KR</option>
													<option value="UTF-8" ${ ( hrSyncData.userFileEncoding eq 'UTF-8' ) ? "selected='selected'" : ""} >UTF-8</option>
												</select>
											</div>
										</div>
										<div id="userSyncUse3Div" class='userSyncUseDetail syncDetailDiv <c:if test="${ hrSyncData.userSyncUse ne '3' }">none</c:if>' >
											<div class="text_bold">XML연동방식 상세 설정</div>
											<div class="detailOption">
												<strong>연동 XML 위치</strong>
												<input class="text_input long" name="userXmlLocation" type="text" value="${hrSyncData.userXmlLocation }" /><br>
												<strong>XML nodeName</strong>
												<input class="text_input long" name="userXmlNodeName" type="text" value="${hrSyncData.userXmlNodeName }" /><br>
												<strong>XML 인코딩</strong>
												<select id="userXmlEncoding" name="userXmlEncoding" class="selectMiddle">
													<option value="EUC-KR" ${ ( hrSyncData.userXmlEncoding eq 'EUC-KR' ) ? "selected='selected'" : ""} >EUC-KR</option>
													<option value="UTF-8" ${ ( hrSyncData.userXmlEncoding eq 'UTF-8' ) ? "selected='selected'" : ""} >UTF-8</option>
												</select>
											</div>
										</div>
									</div>
									<div class="sectionDiv">
										<div class="settingOptionDiv">
											<div class="text_bold">부서 목록 연동</div>
											<input type="radio" name="deptSyncUse" id="deptSyncUse0" value="0" <c:if test="${hrSyncData.deptSyncUse eq '0' }">checked</c:if> > <label for="deptSyncUse0">사용 안함</label><br>
											<input type="radio" name="deptSyncUse" id="deptSyncUse1" value="1" <c:if test="${hrSyncData.deptSyncUse eq '1' }">checked</c:if> > <label for="deptSyncUse1">쿼리연동방식</label>
											<button type="button" class="btn_common mg_15 " onclick="popUpView('dept.query');" >설정</button><br>
											<div class="settingOptionDesc">- SQL쿼리를 활용해서 부서 목록을 동기화합니다.</div>
											<input type="radio" name="deptSyncUse" id="deptSyncUse2" value="2" <c:if test="${hrSyncData.deptSyncUse eq '2' }">checked</c:if> > <label for="deptSyncUse2">파일연동방식</label>
											<div class="settingOptionDesc">- 파일을 활용해서 부서 목록을 동기화합니다. 파일 위치, 인코딩 설정이 필수 입니다.</div>
											<input type="radio" name="deptSyncUse" id="deptSyncUse3" value="3" <c:if test="${hrSyncData.deptSyncUse eq '3' }">checked</c:if> > <label for="deptSyncUse3">XML연동방식</label>
											<div class="settingOptionDesc">- XML 파일을 활용해서 부서 목록을 동기화합니다. 파일 위치, 인코딩 설정이 필수 입니다.</div>
											<input type="radio" name="deptSyncUse" id="deptSyncUse4" value="4" <c:if test="${hrSyncData.deptSyncUse eq '4' }">checked</c:if> > <label for="deptSyncUse4">AD연동방식</label>
											<div class="settingOptionDesc">- AD연동을 활용해서 부서 목록을 동기화합니다.</div>
											<input type="radio" name="deptSyncUse" id="deptSyncUse5" value="5" <c:if test="${hrSyncData.deptSyncUse eq '5' }">checked</c:if> > <label for="deptSyncUse5">API연동방식</label>
											<div class="settingOptionDesc">- API연동을 활용해서 사용자 목록을 동기화합니다.</div>
										</div>
										
										<div id="deptSyncUse1Div" class='deptSyncUseDetail syncDetailDiv <c:if test="${ hrSyncData.deptSyncUse ne '1' }">none</c:if>' >
											<div class="text_bold">쿼리연동방식 상세 설정</div>
											<div class="detailOption">※ 쿼리연동방식을 사용하기 위해서 HrSync_<c:out value="${siteCode }" />.selectSiteDeptList_<c:out value="${siteCode }" /> 쿼리Key가 등록되어 있어야 합니다.</div>
										</div>
										<div id="deptSyncUse2Div" class='deptSyncUseDetail syncDetailDiv <c:if test="${ hrSyncData.deptSyncUse ne '2' }">none</c:if>' >
											<div class="text_bold">파일연동방식 상세 설정</div>
											<div class="detailOption">
												<strong>연동 파일 위치</strong>
												<input class="text_input long" name="deptFileLocation" type="text" value='<c:out value="${hrSyncData.deptFileLocation }"/>' /><br>
												<strong>파일 인코딩</strong>
												<select id="deptFileEncoding" name="deptFileEncoding" class="selectMiddle">
													<option value="EUC-KR" <c:if test="${hrSyncData.deptFileEncoding eq 'EUC-KR' }">selected='selected'</c:if> >EUC-KR</option>
													<option value="UTF-8" <c:if test="${hrSyncData.deptFileEncoding eq 'UTF-8' }">selected='selected'</c:if> >UTF-8</option>
												</select>
											</div>
										</div>
										<div id="deptSyncUse3Div" class='deptSyncUseDetail syncDetailDiv <c:if test="${ hrSyncData.deptSyncUse ne '3' }">none</c:if>' >
											<div class="text_bold">XML 연동방식 상세 설정</div>
											<div class="detailOption">
												<strong>연동 XML 위치</strong>
												<input class="text_input long" name="deptXmlLocation" type="text" value='<c:out value="${hrSyncData.deptXmlLocation }"/>' /><br>
												<strong>XML NodeName</strong>
												<input class="text_input long" name="deptXmlNodeName" type="text" value="${hrSyncData.deptXmlNodeName }" /><br>
												<strong>파일 인코딩</strong>
												<select id="deptXmlEncoding" name="deptXmlEncoding" class="selectMiddle">
													<option value="EUC-KR" <c:if test="${hrSyncData.deptXmlEncoding eq 'EUC-KR' }">selected='selected'</c:if> >EUC-KR</option>
													<option value="UTF-8" <c:if test="${hrSyncData.deptXmlEncoding eq 'UTF-8' }">selected='selected'</c:if> >UTF-8</option>
												</select>
											</div>
										</div>
									</div>
									
									<div class="sectionDiv">
										<div class="settingOptionDiv">
											<div class="text_bold">결재권자 연동</div>
											<input type="radio" name="approvalSyncUse" id="apprSyncUse0" value="0" <c:if test="${hrSyncData.approvalSyncUse eq '0' }">checked</c:if> > <label for="apprSyncUse0">사용 안함</label><br>
											<input type="radio" name="approvalSyncUse" id="apprSyncUse1" value="1" <c:if test="${hrSyncData.approvalSyncUse eq '1' }">checked</c:if> > <label for="apprSyncUse1">쿼리연동방식</label>
											<button type="button" class="btn_common mg_15 " onclick="popUpView('approval.query');" >설정</button>
										</div>
										
										<div id="approvalSyncUse1Div" class='approvalSyncUseDetail syncDetailDiv <c:if test="${ hrSyncData.approvalSyncUse ne '1' }">none</c:if>' >
											<div class="text_bold">쿼리연동방식 상세 설정</div>
											<div class="detailOption">※ 쿼리연동방식을 사용하기 위해서 HrSync_<c:out value="${siteCode }" />.selectDeptApprovalUser_<c:out value="${siteCode }" /> 쿼리Key가 등록되어 있어야 합니다.</div>
										</div>
									</div>
									
									<div class="sectionDiv">
										<div class="settingOptionDiv">
											<div class="text_bold">정책 연동</div>
											<input type="radio" name="policySyncUse" id="policySyncUse1" value="1" checked="checked" readonly="readonly"> <label for="policySyncUse1">사용</label>
										</div>
									</div>
									
								</td>
							</tr>
							<tr>
								<th class="Rborder">동기화 기본 정책 설정</th>
								<td class="Rborder">
									<table summary="인사DB동기화 셋팅" style="table-layout: fixed" >
										<caption>name, value, button</caption>
										<colgroup>
											<col style="width: 25%;" />
											<col style="width: 25%;" />
											<col style="width: 25%;" />
											<col style="width: 25%;" />
										</colgroup>
										<tbody id="values" class="a">
											<tr>
												<th class="Rborder Lborder Tborder">설정 타입</th>
												<th class="Rborder Tborder">결재정책</th>
												<th class="Rborder Tborder">파일정책</th>
												<th class="Rborder Tborder">로그인정책</th>
											</tr>
											<tr>
												<th class="Rborder Lborder">일반사용자 정책</th>
												<td class="Rborder Tborder t_center">
													<c:if test="${ not empty approvalPolicyList }">
														<select name="userAPolSeq">
															<c:forEach items="${ approvalPolicyList }" var="list">
																<option value="${list.app_seq }" <c:if test="${hrSyncData.userAPolSeq eq list.app_seq }">selected='selected'</c:if> >
																	<c:out value="${list.app_nm }" />
																</option>
															</c:forEach>
														</select>
													</c:if>
												</td>
												<td class="Rborder Tborder t_center">
													<c:if test="${ not empty fPolFileMgtList }">
														<select name="userFPolSeq">
															<c:forEach items="${ fPolFileMgtList }" var="list">
																<option value="${list.pol_seq }" <c:if test="${hrSyncData.userFPolSeq eq list.pol_seq }">selected='selected'</c:if> >
																	<c:out value="${list.pol_nm }" />
																</option>
															</c:forEach>
														</select>
													</c:if>
												</td>
												<td class="Rborder Tborder t_center">
													<c:if test="${ not empty cPolLoginMgtList }">
														<select name="userLPolSeq">
															<c:forEach items="${ cPolLoginMgtList }" var="list">
																<option value="${list.login_seq }" <c:if test="${hrSyncData.userLPolSeq eq list.login_seq }">selected='selected'</c:if> >
																	<c:out value="${list.login_nm }" />
																</option>
															</c:forEach>
														</select>
													</c:if>
												</td>
											</tr>
											<tr>
												<th class="Rborder Lborder">결재자 정책</th>
												<td class="Rborder Tborder t_center">
													<c:if test="${ not empty approvalPolicyList }">
														<select name="approvalAPolSeq">
															<c:forEach items="${ approvalPolicyList }" var="list">
																<option value="${list.app_seq }" <c:if test="${hrSyncData.approvalAPolSeq eq list.app_seq }">selected='selected'</c:if> >
																	<c:out value="${list.app_nm }" />
																</option>
															</c:forEach>
														</select>
													</c:if>
												</td>
												<td class="Rborder Tborder t_center">
													<c:if test="${ not empty fPolFileMgtList }">
														<select name="approvalFPolSeq">
															<c:forEach items="${ fPolFileMgtList }" var="list">
																<option value="${list.pol_seq }" <c:if test="${hrSyncData.approvalFPolSeq eq list.pol_seq }">selected='selected'</c:if> >
																	<c:out value="${list.pol_nm }" />
																</option>
															</c:forEach>
														</select>
													</c:if>
												</td>
												<td class="Rborder Tborder t_center">
													<c:if test="${ not empty cPolLoginMgtList }">
														<select name="approvalLPolSeq">
															<c:forEach items="${ cPolLoginMgtList }" var="list">
																<option value="${list.login_seq }" <c:if test="${hrSyncData.approvalLPolSeq eq list.login_seq }">selected='selected'</c:if> >
																	<c:out value="${list.login_nm }" />
																</option>
															</c:forEach>
														</select>
													</c:if>
												</td>
											</tr>
											<tr>
												<th class="Rborder Lborder">부서 정책</th>
												<td class="Rborder Tborder t_center">
													<c:if test="${ not empty approvalPolicyList }">
														<select name="deptAPolSeq">
															<c:forEach items="${ approvalPolicyList }" var="list">
																<option value="${list.app_seq }" <c:if test="${hrSyncData.deptAPolSeq eq list.app_seq }">selected='selected'</c:if> >
																	<c:out value="${list.app_nm }" />
																</option>
															</c:forEach>
														</select>
													</c:if>
												</td>
												<td class="Rborder Tborder t_center">
													<c:if test="${ not empty fPolFileMgtList }">
														<select name="deptFPolSeq">
															<c:forEach items="${ fPolFileMgtList }" var="list">
																<option value="${list.pol_seq }" <c:if test="${hrSyncData.deptFPolSeq eq list.pol_seq }">selected='selected'</c:if> >
																	<c:out value="${list.pol_nm }" />
																</option>
															</c:forEach>
														</select>
													</c:if>
												</td>
												<td class="Rborder Tborder t_center">
													<c:if test="${ not empty cPolLoginMgtList }">
														<select name="deptLPolSeq">
															<c:forEach items="${ cPolLoginMgtList }" var="list">
																<option value="${list.login_seq }" <c:if test="${hrSyncData.deptLPolSeq eq list.login_seq }">selected='selected'</c:if> >
																	<c:out value="${list.login_nm }" />
																</option>
															</c:forEach>
														</select>
													</c:if>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<th class="Rborder">사용자 패스워드 설정</th>
								<td class="Rborder">
									<div class="settingOptionDiv">
										<div class="text_bold">초기 패스워드</div>
										<input class="text_input mid" type="password" name="defaultPassword" id="defaultPassword" maxlength="30"  value='<c:out value="${hrSyncData.defaultPassword }" />' />
										<div class="syncDetailDiv">
											※ 신규 사용자의 초기 패스워드 입니다. 기본 패스워드 설정 값이 공백인 경우, 사용자 초기 패스워드로 사용자ID가 적용됩니다.
										</div>
									</div>
									<div class="settingOptionDiv mg_t15">
										<div class="text_bold">사용자 패스워드 초기화 사용 여부</div>
										<input type="radio" name="pwdInitButtonUse" id="pwdInitButtonUseY" value="Y" <c:if test="${hrSyncData.pwdInitButtonUse eq 'Y' }">checked</c:if> /> <label for="pwdInitButtonUseY" class="mg_r5">사용</label>
										<input type="radio" name="pwdInitButtonUse" id="pwdInitButtonUseN" value="N" <c:if test="${hrSyncData.pwdInitButtonUse eq 'N' }">checked</c:if> /> <label for="pwdInitButtonUseN">사용안함</label>
									</div>
								</td>
							</tr>
						</tbody>
						<tfoot>
						</tfoot>
					</table>
				</div>
				<div class="t_center mg_t30 mg_b30">
					<button class="btn_common theme" onclick="save()">저장</button>
					<button class="btn_common theme" onclick="cancel()">취소</button>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>
