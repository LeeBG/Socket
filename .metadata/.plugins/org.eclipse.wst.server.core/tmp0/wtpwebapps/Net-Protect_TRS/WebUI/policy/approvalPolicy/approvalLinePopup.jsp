<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<title>결재선관리</title>
<link href="<c:url value="/css/ui.tooltip.css?ver=01804100011" />" rel="stylesheet" type="text/css"/>
<script>
var ckName = "appLineList_${np_cd}"
var lineKeys = { "appLineCd" : "radio", "apprStnd" : "text", "useYn" : "text" , "appLineLevel" : "text"};

$(document).ready(function() {
	window.resizeTo($(".wrap")[0].scrollWidth + 20, $(".wrap")[0].scrollHeight+80);
	setAppLineCookieData();
});

function setAppLineCookieData() {
	var cookie = $.cookie(ckName);
	var obj = cookie ? JSON.parse(cookie) : new Array();
	obj.forEach(function(v,i,o) {
		$("input[name='" + ckName + "[" + i + "].appLineCd']").filter('[value="' + v.appLineCd + '"]').attr('checked', true);
	});
}

function clickLineUserSetting(level) {
	window.location.href="/policy/approvalPolicy/approvalLineUserPopup.lin?appLineLevel=" + level + "&appSeq=" + $("#appSeq").val() + "&np_cd=${np_cd}";
}

function ok() {	
	setCookieData();
	window.close();
}

function setCookieData() {
	var cnt = 0;
	var items = new Array();
	var obj;
	for( var i = 0 ; i< $("#appLineLevel").val(); i++ ) {
		obj = {};
		
		obj["appSeq"] = $("#appSeq").val();
		for( var key in lineKeys )
			obj[key] = $("[name='" + ckName + "[" + cnt + "]." + key + "']" + ( ( lineKeys[key] == "radio" ) ? ":checked" : "" ) ).val();
		
		cnt++;
		items.push(obj);
	}
	
	$.cookie(ckName, JSON.stringify(items));
}

function cancle() {
	$.cookie(ckName,null);
	$.cookie("appLineUserList_${np_cd}", null);	//지정결재자
	window.close();
}
</script>
</head>
<body>
	<form id="line_frm">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="wrap">
		<div class="popWrap">
			<h3>결재선관리</h3>
			<div class="conBox" style="overflow:hidden;">
				<div class="popCon">
					<div class="table_area_style01">
						<table cellspacing="0" cellpadding="0" summary="결재선관리" class="">
							<caption>정책ID, 조직도결재?, 지정자결재?</caption>
							<colgroup>
								<col style="width:7%;"/>
								<col style="width:10%;" />
								<col style="width:15%;" />
								<col style="width:15%;" />
								<col style="width:30%;" />
							</colgroup>
							<tr>
								<th class="t_center">정책ID</th>
								<th class="t_center">
									<input type="text" class="text_input" id="appSeq" name="appSeq" value="${appSeq}" readonly="readonly" />
									<input type="hidden" class="text_input" id="appLineLevel" name="appLineLevel" value="${approvalLineList.size()}" />
								</th>
								<th class="t_center">
									<span class="tooltip">조직도결재?
										<span class="tooltiptext tooltip-bottom">사용자의 부서 내의 결재자를 보여줍니다. 부서 내의 결재자가 없는 경우에는 상위 부서의 결재자가 보여집니다.</span>
									</span>
								</th>
								<th class="t_center">
									<span class="tooltip">지정자결재?
										<span class="tooltiptext tooltip-bottom">사용자의 부서와 관계 없이 관리자가 지정한 사용자가 결재자로 보여집니다.</span>
									</span>
								</th>
								<th class="t_center">&nbsp;</th>
							</tr>
							<c:choose>
							<c:when test="${not empty approvalLineList}">
							<c:forEach items="${approvalLineList}" var="lineInfo">
							<tr>
								<td colspan="2" class="Rborder t_center">${lineInfo.appLineLevel}차 결재</td>
								<td colspan="3" class="Rborder">
									<input type="radio" id="radio_DEP_${lineInfo.appLineLevel}" name="appLineList_${np_cd }[${lineInfo.appLineLevel-1}].appLineCd" class="input_chk" value="DEP" ${lineInfo.appLineCd == "DEP" ? ' checked' : ''} ><label for="radio_DEP_level${lineInfo.appLineLevel}">조직도결재</label>&nbsp;
									<input type="radio" id="radio_PICK_${lineInfo.appLineLevel}" name="appLineList_${np_cd }[${lineInfo.appLineLevel-1}].appLineCd" class="input_chk" value="PICK" ${lineInfo.appLineCd == "PICK" ? ' checked' : ''} ><label for="radio_PICK_level${lineInfo.appLineLevel}">지정자결재</label>
									<button type="button" id="app_line_pick_button_${lineInfo.appLineLevel}" class="btn_small" name="app_line_pick_button_level${lineInfo.appLineLevel}" onclick="clickLineUserSetting(${lineInfo.appLineLevel})" />설정</button>
									<input type="hidden" id="apprStnd_${lineInfo.appLineLevel}" name="appLineList_${np_cd }[${lineInfo.appLineLevel-1}].apprStnd" value="${lineInfo.apprStnd }" />
									<input type="hidden" id="useYn_${lineInfo.appLineLevel}" name="appLineList_${np_cd }[${lineInfo.appLineLevel-1}].useYn" value="${lineInfo.useYn }" />
									<input type="hidden" id="appSeq_${lineInfo.appLineLevel}" name="appLineList_${np_cd }[${lineInfo.appLineLevel-1}].appSeq" value="${lineInfo.appSeq }" />
									<input type="hidden" id="appLineLevel_${lineInfo.appLineLevel}" name="appLineList_${np_cd }[${lineInfo.appLineLevel-1}].appLineLevel" value="${lineInfo.appLineLevel }" />
								</td>
							</tr>
							</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="5" align="center"><spring:message code="global.script.search.no.result" /></td>
								</tr>
							</c:otherwise>
							</c:choose>
						</table>
					</div>
				</div>
			</div>
			<div class="btn_area_center mg_t10 mg_b10">
				<button type="button" class="btn_big theme" onclick="ok();">확인</button>
				<button type="button" class="btn_big" onclick="cancle();">취소</button>
			</div>
		</div>
	</div>
	</form>
</body>
</html>