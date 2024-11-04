<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<!-- userLeft.jsp -->
<c:set var="systemCode" value="${sessionScope.loginUser.system_cd}" /><!-- T, S -->
<c:set var="getNetworkPosition" value="${customfunc:getNetworkPosition()}" /><!-- I, O -->
<c:set var="getSiteCode" value="${customfunc:getSiteCode()}" />
<!-- 스트림 연계 보안영역 Server : INT_STM_Net-Protect_V2.0.0.345
스트림 연계 비-보안영역 Server : Ext_STM_Net-Protect_V2.0.0.345
자료전송 보안영역 Server : INT_TRS_Net-Protect_V2.0.0.345
자료전송 비-보안영역Server : Ext_TRS_Net-Protect_V2.0.0.345 -->
<!-- systemCode = ${systemCode }
getNetworkPosition = ${getNetworkPosition } -->
<c:set var="prgm_nm" value="" />
<c:set var="version" value="" />
	<c:if test="${getNetworkPosition eq 'I' }">
		<c:set var="prgm_nm" value="INT_TRS_Net-Protect_V" />
		<c:set var="version" value="${customfunc:cacheString('programInfo_Int')}" />
	</c:if>
	<c:if test="${getNetworkPosition eq 'O' }">
		<c:set var="prgm_nm" value="EXT_TRS_Net-Protect_V" />
		<c:set var="version" value="${customfunc:cacheString('programInfo_Ext')}" />
	</c:if>
<c:set var="program_info" value="${prgm_nm }${version }" />
<%-- program_info = ${program_info } --%>
<html>
<head>
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />
<c:set var="cMenuMgtMap" value="${sessionScope.loginUser.cMenuMgtMap}" />
<c:set var="requestURI" value="${pageContext.request.requestURI}"/>
<c:set var="preUrl" value="${ header.referer.replaceAll(pageContext.request.scheme , '').replaceAll(pageContext.request.serverName, '').replaceAll(pageContext.request.serverPort, '') }" />
<c:set var="env" value="${sessionScope.envInfo}" />
<script type="text/javascript">
	var save_class_id = "";
	var authCd = '${sessionScope.loginUser.auth_cd}';
	$(document).ready(function(){
		if (authCd < 5) {
			reloadMenu();
		}

		$('.btn_setting').click(function(){
			var w = screen.availWidth;
			var h = screen.availHeight;
			var w1 = (w/2)-195;
			var h1 = (h/2)-250;
			var url = "<c:url value="/hr/user/modUserPop.lin" />";
			var attibute = "resizable=no,width=520,height=380,top="+h1+",left="+w1+",scrollbars=no,toolbar=no,url=no,margin:10px 10px 8px 20px";
			var popupWindow = window.open(url, "addvirtualip", attibute);
			popupWindow.focus();
		});
		
		setApprovalDocCount("sendList", "FSLG0000");				<%-- 보낸 자료 --%>
		setApprovalDocCount("receiveList", "FSLG0100");				<%-- 받은 자료 --%>
		setApprovalDocCount("approvalWaitList", "FSAP0000");		<%-- 결재 대기함 --%>
		setApprovalDocCount("approvalHistoryList", "FSAP0100");		<%-- 결재 이력함 --%>
		setApprovalDocCount("selfApprovalReqeustList", "FSAR0200");	<%-- 결재 대기함 --%>
		setApprovalDocCount("approvalDeptHistoryList", "FSAP0110");	<%-- 부서결재 이력함 --%>
	});

	function autoOpenLeftMenu(id){
		$('#'+id).parent().parent().hide();
		$('#'+id).parent().parent().parent().click();
		$('#'+id).css({'font-weight':'bold'});
	}

	function cacheReload() {
		var requestURL = "<c:url value="/cache/cacheReload.lin" />";
		var successURL = location.href;
		resultCheck($("#lform"), requestURL, successURL, true);
	}


	
	function reloadMenu(){
		var class_id = "";
		<c:forEach items="${cMenuMgtMap}" var="cMenuMgt" varStatus="index">
			<c:forEach items="${cMenuMgt.value.cPrgmMgtList}" var="cPrgmMgt" varStatus="index2">
				<c:set var="url" value="${fn:split(requestURI,'//')}" />
				<c:if test="${fn:length(url) > 2}"><c:set var="prgm_url" value="/${url[0]}/${url[1]}" /></c:if>
				<c:if test="${fn:indexOf(cPrgmMgt.prgm_url, requestURI) > -1}">
					class_id = '${cMenuMgt.value.class_id}';
					<c:set var="save_class_id" value="${cMenuMgt.value.class_id}"/>
					$('a').each(function(){
						var media = $(this).attr("media");
						var url = '${cPrgmMgt.prgm_url}';
						if(media != "undefined" && media != 'javascript:void(0)'){
							if(url.indexOf(media) > -1){
								autoOpenLeftMenu( $(this).attr("id") );
							}
						}
					});	
				</c:if>
			</c:forEach>
		</c:forEach>

		if (class_id == '') {
			var preUrl = '${preUrl}';
			var id = "";
			$('a').each(function(){
				var l = $(this).attr("media");
				if(l != "undefined"){
					if(l != 'javascript:void(0)'){
						if(preUrl.indexOf(l) > -1){
							id = $(this).attr("id");
							autoOpenLeftMenu(id);
						}
					}
				}
			});
			class_id = '${save_class_id}';
		}

	}

	function switchMenu(id) {
		if (id == "tranferMenu") {
			$("#tranferMenu").show();
			$("#streamMenu").hide();
		} else {
			$("#tranferMenu").hide();
			$("#streamMenu").show();
		} 
	}
	
	function goMenu(url) {
		location.href = url;
	}
	function goEmailLink(url) {
		var id = '${customfunc:pbkdfEncoded256String(sessionScope.loginUser.users_id)}';
		//window.open(url + replace(id),'popup','width=1000, heigth=1000, resizable=yes, scrollbars=yes'); 
		window.open(url + encodeURIComponent(id),'popup','width=1000, heigth=1000, resizable=yes, scrollbars=yes'); 
	}
	
	function replace(inum) {
		inum = inum.replace(/&/g,"%26");
		inum = inum.replace(/\+/g,"%2B");
		return inum;
	}

	function openTrsMonitor() {
		var attibute = 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=1900, height=1000, top=5, left=5';
		var url = "";
		if(authCd == 1) url = "<c:url value="/trsMonitor/dashboard/dashboardView.lin" />";
		else url = "<c:url value="/trsMonitor/totalStatistics/totalStatisticsView.lin" />";
		
		var popupWindow = window.open(url, "trsMonitorPopup", attibute);
		popupWindow.focus();
	}

</script>
<style>
.accessInfoBox {
	bottom: 0px; 
	position: fixed; 
	color: #000000; 
	opacity: 0.83;
	font-size: 11px;
	background-color: #f9f9f9;
	width: 240px;
	border-top: 1px solid #ebebeb;
}
.access-title {
    width: 90px;
    display: inline-block;
	margin-bottom: 2px;
}
.access-content {
	padding-left:5px;
}
.access-version {
	font-weight: bold;
}
#transferNaviType {
	background-color: rgb(181, 181, 181) !important;
	text-shadow: 0 1px 1px rgba(0, 0, 0, 0.6);
	margin-top: -1px;
}
.prgmCntSpan {
	font-weight: bold;
	float: right;
	width: 40px;
    text-align: center;
}
.s1 {
	font-weight: bold;
}
</style>
</head>
<body>
	<div class="leftArea">
		<header>
			<c:choose>
				<c:when test="${sessionScope.loginUser.auth_cd < 5}">
					<h1 class="logo" style="background-image:url('<c:url value="${env.log_fpath }${env.log_fname }" />'); ">
				</c:when>
				<c:when test="${customfunc:getSiteCode() eq 'ftc' }">
					<h1 class="logo"  onclick="javascript:location.href='/site/ftc/sendForm.lin';" style="cursor:pointer; background-image:url('<c:url value="${env.log_fpath }${env.log_fname }" />'); ">
				</c:when>
				<c:otherwise>
					<h1 class="logo"  onclick="javascript:location.href='/data/file/sendForm.lin';" style="cursor:pointer; background-image:url('<c:url value="${env.log_fpath }${env.log_fname }" />'); ">
				</c:otherwise>
			</c:choose>
			LOGO
			</h1>
			<div class="userInfoBox" style="overflow-y: hidden;">
				<c:set var="className" value="${customfunc:getSiteCode() eq 'kins' ? 'kins' : '' }"/>
				<p class="f_left">
					<span class="userName ${className}">${sessionScope.loginUser.users_nm } 님</span> 
				</p>
				<c:choose>
					<c:when test="${customfunc:getSiteCode() eq 'komsco' || customfunc:getSiteCode() eq 'nl' || customfunc:getSiteCode() eq 'mcst' || customfunc:getSiteCode() eq 'museum' ||  customfunc:getSiteCode() eq 'motie' || customfunc:getSiteCode() eq 'sejong_nl'}">
						<c:if test="${sessionScope.loginUser.auth_type < 5 }">
							<div class="f_right" style="height: 100%;">
								<button type="button" class="ir_desc btn_setting f_left">설정</button>
								<button type="button" class="ir_desc btn_logout f_left ${className}" onclick="javascript:location.href='/sign/logout.lin';">로그아웃</button>
							</div>
						</c:if>
					</c:when>
					<c:otherwise>
						<div class="f_right" style="height: 100%;">
							<c:if test="${ sessionScope.loginUser.changingPwdUser }">
								<button type="button" class="ir_desc btn_setting f_left">설정</button>
							</c:if>
							<c:if test="${ customfunc:getSiteCode() ne 'komipo' || sessionScope.loginUser.auth_cd < 5 || !customfunc:isInnerPosition() }"> <%-- 중부발전은 관리자한테만 로그아웃 버튼이 보여진다 --%>
								<button type="button" class="ir_desc btn_logout f_left ${className}" onclick="javascript:location.href='/sign/logout.lin';">로그아웃</button>
							</c:if>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</header>
		<nav>
			<div class="navBox Type1">
			<c:choose>
				<c:when test="${sessionScope.loginUser.auth_cd < 5}"><!-- 자료전송 관리자 -->
					<ul id="tranferMenu" class="list01">
						<c:forEach items="${cMenuMgtMap}" var="cMenuMgt" varStatus="c">
							<c:if test="${cMenuMgt.value.class_id eq '100'}"><!-- c_menu_mgt class_id 100 -->
								<c:if test="${not empty cMenuMgt.value.cPrgmMgtList}">
									<c:choose>
										<c:when test="${cMenuMgt.value.menu_id eq '100100'}"> <!-- 대시보드 메뉴 예외처리 -->
											<li id="DashboardRenewal" style="cursor: pointer;"><a onclick="openTrsMonitor()">> ${cMenuMgt.value.menu_nm }</a></li>
										</c:when>
										<c:otherwise>
												<li><a href="javascript:void(0)">> ${cMenuMgt.value.menu_nm }</a>
												<ul class="list02">
													<c:forEach items="${cMenuMgt.value.cPrgmMgtList}" var="cPrgmMgt" varStatus="index2">
														<li class="<c:if test="${fn:indexOf(cPrgmMgt.prgm_url, requestURI) > -1}">text_bold</c:if>">
															<a href="javascript:void(0)" onclick="goMenu('${cPrgmMgt.prgm_url }')" media="${cPrgmMgt.prgm_url }" id="tranferMenu_list02_${c.count}${index2.count}"> <span class="listStyle">·</span>${cPrgmMgt.prgm_nm } </a>
														</li>
													</c:forEach>
												</ul>
										</c:otherwise>
									</c:choose>
									
								</c:if>
							</c:if>
						</c:forEach>
					</ul>
					<ul id="streamMenu" class="list01" style="display: none;">
						<c:forEach items="${cMenuMgtMap}" var="cMenuMgt" varStatus="index">
							<c:if test="${cMenuMgt.value.class_id eq '300'}"><!-- c_menu_mgt class_id 300 -->
								<c:if test="${not empty cMenuMgt.value.cPrgmMgtList}">
									<li><a href="javascript:void(0)" onfocus="this.blur()">> ${cMenuMgt.value.menu_nm }</a>
										<ul class="list02">
											<c:forEach items="${cMenuMgt.value.cPrgmMgtList}" var="cPrgmMgt" varStatus="index2">
												<li class="<c:if test="${fn:indexOf(cPrgmMgt.prgm_url, requestURI) > -1}">text_bold</c:if>">
													<a href="javascript:void(0)" onclick="goMenu('${cPrgmMgt.prgm_url }');" media="${cPrgmMgt.prgm_url }" id="streamMenu_list02_${index.count}${index2.count}"> <span class="listStyle">·</span>${cPrgmMgt.prgm_nm }</a>
												</li>
											</c:forEach>
										</ul>
								</c:if>
							</c:if>
						</c:forEach>
					</ul>
				</c:when>
				<c:otherwise>
					<ul class="list01">
						<c:forEach items="${cMenuMgtMap}" var="cMenuMgt" varStatus="index">
							<c:choose>
								<%-- 결재권한이 없는 사람은 '결재관리' 메뉴 제거 --%>
								<c:when test="${ cMenuMgt.value.menu_id eq '200300' && ! ( sessionScope.loginUser.authMenuApprovalYn eq 'Y'  || sessionScope.loginUser.proxyApproverAuth eq 'Y' || sessionScope.loginUser.commonUserButHaveApprovalAuth eq 'Y')}" />
								<c:when test="${ cMenuMgt.value.menu_id eq '200500' && sessionScope.loginUser.approvalPolicy.app_direction eq 'N'}" />
								<c:otherwise>							
								<li id="${sessionScope.loginUser.auth_cd}" >
									<a >
									<c:choose>
										<c:when test="${customfunc:getSiteCode() eq 'kins'}">
											<c:if test="${cMenuMgt.value.menu_id eq '200200'}"><img src="/Images/icon/icon_lnb_03.png"/></c:if>
											<c:if test="${cMenuMgt.value.menu_id eq '200201'}"><img src="/Images/icon/icon_lnb_01.png"/></c:if>
											<c:if test="${cMenuMgt.value.menu_id eq '200300'}"><img src="/Images/icon/icon_lnb_02.png"/></c:if>
											<c:if test="${cMenuMgt.value.menu_id eq '200500'}"><img src="/Images/icon/icon_lnb_03.png"/></c:if>
											<span>${cMenuMgt.value.menu_nm }</span>
										</c:when>
										<c:otherwise>
											<c:if test="${cMenuMgt.value.menu_id eq '200200'}"><img src="/Images/icon/icon_lnb_01.png"/></c:if>
											<c:if test="${cMenuMgt.value.menu_id eq '200300'}"><img src="/Images/icon/icon_lnb_02.png"/></c:if>
											<c:if test="${cMenuMgt.value.menu_id eq '200500'}"><img src="/Images/icon/icon_lnb_03.png"/></c:if>
											<span>${cMenuMgt.value.menu_nm }</span>
										</c:otherwise>
									</c:choose>
									</a>
									<c:if test="${not empty cMenuMgt.value.cPrgmMgtList}">
										<ul class="list02">
										<c:forEach items="${cMenuMgt.value.cPrgmMgtList}" var="cPrgmMgt" varStatus="index2">
											<c:choose>
												<%-- 대리결재 설정이 비활성화되면 '대리결재권자설정' 메뉴 제거 --%>
												<c:when test="${ cPrgmMgt.prgm_id eq 'FSAP0200' && sessionScope.loginUser.approvalPolicy.proxy_app_yn ne 'Y' }" />
												<%-- 부재중 설정이 비활성화되면 '부재중결재권자설정' 메뉴 제거 --%>
												<c:when test="${ cPrgmMgt.prgm_id eq 'FSSA0000' && sessionScope.loginUser.approvalPolicy.absence_app_yn ne 'Y' }" />
												<%-- 부재중, 대리결재은 대리결재권 권한만 가진 사람은 '대리결재자설정','부재중결재자설정' 메뉴 제거 --%>
												<c:when test="${ ( cPrgmMgt.prgm_id eq 'FSSA0000' || cPrgmMgt.prgm_id eq 'FSAP0200' ) &&
													( sessionScope.loginUser.authMenuApprovalYn ne 'Y' && sessionScope.loginUser.proxyApproverAuth eq 'Y' ) }" />
												<%-- 미결재건 처리만 가능한 일반사용자는 '대리결재자설정','부재중결재자설정' 메뉴 이용 불가 --%>
												<c:when test="${ ( cPrgmMgt.prgm_id eq 'FSSA0000' || cPrgmMgt.prgm_id eq 'FSAP0200' ) &&
													( sessionScope.loginUser.authMenuApprovalYn ne 'Y' && sessionScope.loginUser.commonUserButHaveApprovalAuth eq 'Y') }" />
												<%-- 자가결재권한이 있으면 '권한요청-자가결재신청' 메뉴 제거 --%>
												<c:when test="${ cPrgmMgt.prgm_id eq 'FSAR0100' && sessionScope.loginUser.approvalPolicy.self_app_yn eq 'Y'}" />
												<%-- 산업자원통상부 메일 바로가기 링크--%>
												<c:when test="${ cPrgmMgt.prgm_id eq 'FSFT0100' && customfunc:getSiteCode() ne 'motie'}" />
												<%-- <c:when test="${ cPrgmMgt.prgm_id eq 'FSAP0000'}">
												<li class="<c:if test="${fn:indexOf(cPrgmMgt.prgm_url, requestURI) > -1}">text_bold</c:if>" id="${cPrgmMgt.prgm_id}">
													<a href="javascript:void(0)"  onclick="goMenu('${cPrgmMgt.prgm_url }');" media="${cPrgmMgt.prgm_url }" onclick="goMenu('${cPrgmMgt.prgm_url }');"id="streamMenu_list02_${index.count}${index2.count}">
														<span class="listStyle">·</span>
													${cPrgmMgt.prgm_nm}(${paging.totalCount})
													</a>
												</li>
												</c:when> --%>
												<%-- 메뉴 출력 --%>
												<c:otherwise>
													<c:choose>
														<%-- 산업자원통상부 메일 바로가기 링크--%>
														<c:when test="${ cPrgmMgt.prgm_id eq 'FSFT0100'}">
														<li class="<c:if test="${fn:indexOf(cPrgmMgt.prgm_url, requestURI) > -1}">text_bold</c:if>" id="${cPrgmMgt.prgm_id}">
															<a href="javascript:void(0)" onclick="goEmailLink('${cPrgmMgt.prgm_url}');" media="${cPrgmMgt.prgm_url }" id="streamMenu_list02_${index.count}${index2.count}">
																<span class="listStyle">·</span>
																<span class="prgmNmSpan">
																<c:if test="${(getSiteCode eq 'mcst' || getSiteCode eq 'museum' || getSiteCode eq 'sejong_nl' || getSiteCode eq 'nl')&& cPrgmMgt.prgm_id eq 'FSFT0000'}">
																<c:if test="${getNetworkPosition eq 'I' }">인터넷망으로&nbsp;</c:if>
																<c:if test="${getNetworkPosition eq 'O' }">업무망으로&nbsp;</c:if>
																</c:if>
																${cPrgmMgt.prgm_nm}
																</span>
																<span class="prgmCntSpan" id="${ cPrgmMgt.prgm_id}-count"></span>
															</a>
														</li>
														</c:when>
														<c:otherwise>
															<li class="<c:if test="${fn:indexOf(cPrgmMgt.prgm_url, requestURI) > -1}">text_bold</c:if>" id="${cPrgmMgt.prgm_id}"> 
																<a href="javascript:void(0)" onclick="goMenu('${cPrgmMgt.prgm_url}');" media="${cPrgmMgt.prgm_url }" id="streamMenu_list02_${index.count}${index2.count}">
																	<span class="listStyle">·</span>
																	<span class="prgmNmSpan">
																	<c:if test="${(getSiteCode eq 'mcst' || getSiteCode eq 'museum'  || getSiteCode eq 'sejong_nl' || getSiteCode eq 'nl')&& cPrgmMgt.prgm_id eq 'FSFT0000'}">
																	<c:if test="${getNetworkPosition eq 'I' }">인터넷망으로&nbsp;</c:if>
																	<c:if test="${getNetworkPosition eq 'O' }">업무망으로&nbsp;</c:if>
																	</c:if>
																	${cPrgmMgt.prgm_nm}
																	</span>
																	<%-- 
																	count 수 보여주기
																	FSAR0200 : 자가결재> 결재 대기함
																	FSAP0000 : 결재관리> 결재 대기함
																	FSAP0100 : 결재관리> 결재 이력함
																	FSAP0110 : 결재관리> 부서결재 이력함
																	FSLG0000 : 자료송수신> 보낸자료
																	FSLG0100 : 자료송수신> 받은자료
																	--%>
																	<span class="prgmCntSpan" id="${ cPrgmMgt.prgm_id}-count"></span>
																</a>
															</li>
														</c:otherwise>
													</c:choose>
												</c:otherwise>
											</c:choose>
										</c:forEach>
										</ul>
									</c:if>
								</li>
								</c:otherwise>	
							</c:choose>
							
						</c:forEach>
					</ul>
				</c:otherwise>
			</c:choose>
			</div>
		</nav>
		<div>
			<div class="pd_l15 pd_r15 pd_b10 pd_t10 accessInfoBox">
				<c:if test="${customfunc:getSiteCode() != 'ftc' || sessionScope.loginUser.auth_cd < 5}">
					<p><b><span class="access-title">세션만료시간</span></b>:<b><span class="access-content" id="remainSessTime"></span></b></p>
				</c:if>
				<p><span class="access-title">마지막 접속 I P</span>:<span class="access-content">${sessionScope.loginUser.lastLoginInfo.lastAccessIp }</span></p>
				<p><span class="access-title">마지막 접속 시간</span>:<span class="access-content">${sessionScope.loginUser.lastLoginInfo.lastAccessDate }</span></p>
				<c:if test="${sessionScope.loginUser.auth_type < 5}">
					<p><span class="access-version">Net-Protect_V3.0</span></p>
					<p><span class="access-version">${program_info}</span></p>
				</c:if>
			</div>
		</div>
	</div>
</body>
</html>
