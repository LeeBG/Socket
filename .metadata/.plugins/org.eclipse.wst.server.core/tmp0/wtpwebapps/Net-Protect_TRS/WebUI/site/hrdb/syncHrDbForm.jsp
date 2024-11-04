<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<style>
.loading-layer {
    display: block;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(68, 68, 68, 0.3);
    z-index: 11111;
}
.loading-layer .loading-wrap {
    display: table;
    width: 100%;
    height: 100%;
}
.loading-layer .loading-wrap .loading-text {
    display: table-cell;
    vertical-align: middle;
    text-align: center;
    color: #fff;
    text-shadow: 2px 3px 2.6px #a2a2a2;
    font-size: 3.8em;
    position: relative;
    top: -20px;
}
.loading-layer.active-loading .loading-wrap .loading-text span:nth-child(1) {
  animation: loading-01 0.82s infinite;
}
.loading-layer.active-loading .loading-wrap .loading-text span:nth-child(2) {
  animation: loading-02 0.82s infinite;
}
.loading-layer.active-loading .loading-wrap .loading-text span:nth-child(3) {
  animation: loading-03 0.82s infinite;
}

</style>

<html>
<head>


<script type="text/javascript">
function hrdbSync() {
	var requestURL = "<c:url value="/site/hrdb/syncHrDb.lin" />";
	isloading.start();
	 resultCheckFunc($("#lform"), requestURL, function(response) {
		var code = response['code'];
		if (code == 200) {
			alert('인사정보 동기화가 완료되었습니다');
			isloading.stop();
			location.reload();
		} else {
			alert('인사정보 동기화 중 오류가 발생하였습니다.');
			 isloading.stop();
			 location.reload();
		}
	}); 
}


	isloading = {
		start : function() {
			if (document.getElementById('wfLoading')) {
				return;
			}
			var ele = document.createElement('div');
			ele.setAttribute('id', 'wfLoading');
			ele.className = "loading-layer";
			ele.innerHTML = '<span class="loading-wrap"><span class="loading-text"><span><MARQUEE style="width:150px;height:40px;font-size:30px;padding-top:20px;" behavior="scroll" direction="RIGHT">Loading</MARQUEE></span></span></span>';
			
			$("body").append(ele);
			
			// Animation
			name = "active-loading";
			arr = ele.className.split(" ");
			if (jQuery.inArray('indexOf',arr) == -1) {	//change reson : IE8, IE9
				ele.className += " " + name;
			}
		},
		stop : function() {
			var ele = $('#wfLoading');
			if (ele) {
				ele.remove();
			}
		}
	}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/site/hrdb/syncHrDbForm.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">인사정보연동</h2>
				<p class="breadCrumbs">인사관리 > 인사정보연동</p>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>인사정보연동</h3>
			<div class="conBox">
				<div class="table_area_style02 Tborder">
					<table summary="로그인정책 설정" style="table-layout : fixed">
					<caption>시스템감시정책 관리</caption>
						<colgroup>
							<col style="width:15%;"/>
							<col style="width:85%;" />
						</colgroup>
						<tbody>
							<tr>
								<th rowspan="3" class="t_left">인사정보 수동 동기화</th>
								<c:choose>
								<c:when test= "${workTime == null}">
								<td>
									최신 인사DB동기화 날짜를 가져올 수 없습니다. 인사DB동기화를 진행해주세요.
								</td>
								</c:when>
								<c:when test = "${workTime != null}">
								<td>
									마지막 동기화 날짜 : <c:out value="${workTime}"></c:out>
								</td>
								</c:when>
								</c:choose>
							</tr>
							<tr>
								<td>
									<button class="btn_common theme" onClick="hrdbSync()">동기화</button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>
