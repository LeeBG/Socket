<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<!-- userLeft.jsp -->
<c:set var="systemCode" value="${sessionScope.loginUser.system_cd}" /><!-- T, S -->
<c:set var="getNetworkPosition" value="${customfunc:getNetworkPosition()}" /><!-- I, O -->
<!-- 스트림 연계 보안영역 Server : INT_STM_Net-Protect_V2.0.0.345
스트림 연계 비-보안영역 Server : Ext_STM_Net-Protect_V2.0.0.345
자료전송 보안영역 Server : INT_TRS_Net-Protect_V2.0.0.345
자료전송 비-보안영역Server : Ext_TRS_Net-Protect_V2.0.0.345 -->
<!-- systemCode = ${systemCode }
getNetworkPosition = ${getNetworkPosition } -->
<c:set var="prgm_nm" value="" />
<c:set var="version" value="" />
<c:choose>
	<c:when test="${systemCode eq 'T' }">
		<c:if test="${getNetworkPosition eq 'I' }">
			<c:set var="prgm_nm" value="INT_TRS_Net-Protect_V" />
			<c:set var="version" value="${customfunc:cacheString('programInfo_Int')}" />
		</c:if>
		<c:if test="${getNetworkPosition eq 'O' }">
			<c:set var="prgm_nm" value="Ext_TRS_Net-Protect_V" />
			<c:set var="version" value="${customfunc:cacheString('programInfo_Ext')}" />
		</c:if>
	</c:when>
	<c:when test="${systemCode eq 'S' }">
		<c:if test="${getNetworkPosition eq 'I' }">
			<c:set var="prgm_nm" value="INT_STM_Net-Protect_V" />
			<c:set var="version" value="${customfunc:cacheString('programInfo_Int')}" />
		</c:if>
		<c:if test="${getNetworkPosition eq 'O' }">
			<c:set var="prgm_nm" value="Ext_STM_Net-Protect_V" />
			<c:set var="version" value="${customfunc:cacheString('programInfo_Ext')}" />
		</c:if>
	</c:when>
	<c:otherwise><c:set var="prgm_nm" value="INT_STM_Net-Protect_V" /></c:otherwise>
</c:choose>
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
	});

	function autoOpenLeftMenu(id){
		$('#'+id).parent().parent().hide();
		$('#'+id).parent().parent().parent().click();
		$('#'+id).css({'color':'#363636', 'font-weight':'bold'});
	}

	function cacheReload() {
		var requestURL = "<c:url value="/cache/cacheReload.lin" />";
		var successURL = location.href;
		resultCheck($("#lform"), requestURL, successURL, true);
	}


	
	function reloadMenu(){
		$('.list02').each(function() {
			if (this.id < eval(3)) {
				$(this).hide();
			}
		});

		var class_id = "";
		<c:forEach items="${cMenuMgtMap}" var="cMenuMgt" varStatus="index">
			<c:forEach items="${cMenuMgt.value.cPrgmMgtList}" var="cPrgmMgt" varStatus="index2">
				<c:set var="url" value="${fn:split(requestURI,'//')}" />
				<c:if test="${fn:length(url) > 2}"><c:set var="prgm_url" value="/${url[0]}/${url[1]}" /></c:if>
				<c:if test="${fn:indexOf(cPrgmMgt.prgm_url, requestURI) > -1}">
					class_id = '${cMenuMgt.value.class_id}';
					<c:set var="save_class_id" value="${cMenuMgt.value.class_id}"/>
					$('a').each(function(){
						var l = $(this).attr("media");
						var url = '${cPrgmMgt.prgm_url}';
						if(l != "undefined"){
							if(l != 'javascript:void(0)'){
								if(url.indexOf(l) > -1){
									id = $(this).attr("id");
									autoOpenLeftMenu(id);
								}
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

		if (authCd < 3) {
			$("#transferNaviType").click();
		} else if (authCd < 5) {
			$("#streamNaviType").click();
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
</script>
</head>
<body>
	<div class="leftArea">
		<div class="ir_desc leftArea_display hide">메뉴 숨기기/보기</div>
		<header>
			<h1>
				<img src="<c:url value="${env.log_fpath }${env.log_fname }" />" alt="logo" title="logo" width="225" />
			</h1>
			<div class="userInfoBox mg_t30">
				<p class="f_left">
					<span class="userName">${sessionScope.loginUser.users_nm } 님</span> 
				</p>
				<div class="f_right" style="height: 100%;">
					<button type="button" class="ir_desc btn_setting f_left">설정</button>
					<button type="button" class="ir_desc btn_logout f_left" onclick="javascript:location.href='/sign/logout.lin';">로그아웃</button>
				</div>
			</div>
		</header>
		<nav>
			<c:if test="${sessionScope.loginUser.auth_cd < 5}">
			<div class="navType">
				<ul>
					<c:choose>
						<c:when test="${sessionScope.loginUser.auth_cd < 5}">
						<li id="transferNaviType" onclick="javascript:switchMenu('tranferMenu');">자료전송 관리자</li>
						</c:when>
					</c:choose>
				</ul>
			</div>
			</c:if>
			<div class="navBox Type1">
			<c:choose>
				<c:when test="${sessionScope.loginUser.auth_cd < 5}"><!-- 자료전송 관리자 -->
					<ul id="tranferMenu" class="list01">
						<c:forEach items="${cMenuMgtMap}" var="cMenuMgt" varStatus="c">
							<c:if test="${cMenuMgt.value.class_id eq '100'}"><!-- c_menu_mgt class_id 100 -->
								<c:if test="${not empty cMenuMgt.value.cPrgmMgtList}">
									<li><a href="javascript:void(0)">> ${cMenuMgt.value.menu_nm }</a>
										<ul class="list02">
											<c:forEach items="${cMenuMgt.value.cPrgmMgtList}" var="cPrgmMgt" varStatus="index2">
												<li class="<c:if test="${fn:indexOf(cPrgmMgt.prgm_url, requestURI) > -1}">text_bold</c:if>">
													<a href="javascript:void(0)" onclick="goMenu('${cPrgmMgt.prgm_url }')" media="${cPrgmMgt.prgm_url }" id="tranferMenu_list02_${c.count}${index2.count}"> <span class="listStyle">·</span>${cPrgmMgt.prgm_nm } </a>
												</li>
											</c:forEach>
										</ul>
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
							<li id="${sessionScope.loginUser.auth_cd}" >
								<a >${cMenuMgt.value.menu_nm }</a>
								<c:if test="${not empty cMenuMgt.value.cPrgmMgtList}">
									<ul id="${sessionScope.loginUser.auth_cd}" class="list02">
									<c:forEach items="${cMenuMgt.value.cPrgmMgtList}" var="cPrgmMgt" varStatus="index2">
										<c:choose>
											<c:when test="${sessionScope.loginUser.approvalPolicy.proxy_app_yn == 'N' && cPrgmMgt.prgm_id == 'FSAP0200'}">
											</c:when>
											<c:when test="${sessionScope.loginUser.approvalPolicy.absence_app_yn == 'N' && cPrgmMgt.prgm_id == 'FSSA0000'}">
											</c:when>
											<c:otherwise>
												<li class="<c:if test="${fn:indexOf(cPrgmMgt.prgm_url, requestURI) > -1}">text_bold</c:if>">
													<a href="javascript:void(0)"  onclick="goMenu('${cPrgmMgt.prgm_url }');" media="${cPrgmMgt.prgm_url }" onclick="goMenu('${cPrgmMgt.prgm_url }');"id="streamMenu_list02_${index.count}${index2.count}">
														<span class="listStyle">·</span>
													${cPrgmMgt.prgm_nm}
													</a>
												</li>
											</c:otherwise>
										</c:choose>
									</c:forEach>
									</ul>
								</c:if>
							</li>
						</c:forEach>
					</ul>
				</c:otherwise>
			</c:choose>
			</div>
		</nav>
		<div class="vcInfoBox mg_t30">
			<c:choose>
				<c:when test="${auth_cd == 1}">
					<p class="f_left" onclick="cacheReload();">
						&nbsp;&nbsp;Ver : ${program_info }
					</p>
				</c:when>
				<c:otherwise>
					<p class="f_left">
						&nbsp;&nbsp;Ver : ${program_info }
					</p>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</body>
</html>