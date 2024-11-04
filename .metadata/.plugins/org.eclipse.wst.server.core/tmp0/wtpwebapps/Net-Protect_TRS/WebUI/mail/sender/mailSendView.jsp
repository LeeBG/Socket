<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<html>
<head>
<link href="<c:url value="/css/ui.tooltip.css?ver=01804100011" />" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="<c:url value="/JavaScript/s3iFileWSock.js" />"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/file.js?v=190401" />"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('#Progress_Loading').hide(); //첫 시작시 로딩바를 숨겨준다.
})

function sendmail( ) { //메일 발송
	if( $('#email .img_ico').length  > 0 ){
		alert("메일을 발송중입니다.");
		return;
	}

	if (confirm("메일발송을 하시겠습니까?")) {
		
		if ($("#receiver").val() == "") {
			alert("받는사람을 입력해주세요");
			$("#receiver").focus();
			return;
		}

		var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		var receiver_array = $("#receiver").val().split(",");

		for (var i=0; i<receiver_array.length; i++) {
			receiver_array[i] = receiver_array[i].trim();
			if (!regExp.test(receiver_array[i])) {
				alert("잘못 입력된 이메일 주소가 있습니다.\n받는사람 이메일 주소를 다시 확인해주세요.");
				return;
			}
		}
		$("#receive").val(receiver_array.join(","));

		if (!$("#cc").val() == "") {
			var cc_array = $("#cc").val().split(",");
			for (var i=0; i<cc_array.length; i++) {
				cc_array[i] = cc_array[i].trim();
				if (!regExp.test(cc_array[i])) {
					alert("잘못 입력된 이메일 주소가 있습니다.\n참조 이메일 주소를 다시 확인해주세요.");
					return;
				}
			}
			$("#cc").val(cc_array.join(","));
		}
		$('#email').find('.text').html('발송중..<img class="img_ico" src="<c:url value="/Images/common/loading.gif" />" width="14" height="14">');
		var requestURL = "<c:url value="/mail/sender/sendMail.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var code = response['code'];
			var message = response['message'];
			alert(message);
			window.close();
		});
	}
}

function windowclose() { //창 닫기
	window.close();
	if( $('#email .img_ico').length  > 0 ){
		if (confirm("메일을 발송중 입니다. 창을 닫으시겠습니까?")) {
			window.close();
		}
	}
}
</script>
<style>
::-webkit-scrollbar-corner{background-color: black;}
::-webkit-scrollbar{width:8px;}
::-webkit-scrollbar-thumb{background-color: rgba(0, 0, 0, 0.2);}
</style>
</head>
<body>
<form name="lform" id="lform" method="post" action="" onSubmit="return false;">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="data_seq" name="data_seq" value="${data_seq}" />
<input type="hidden" id="ath_ords" name="ath_ords" value="${ath_ords}" />
<input type="hidden" id="networkPosition" name="networkPosition" value="${networkPosition}" />
<div id = "Progress_Loading"><!-- 로딩바 -->
	<img class="img_ico" src="<c:url value="/Images/common/loading.gif" />" width="14" height="14">
</div>
<fieldset>
	<div class="mail_send">
		<h3>메일 작성</h3>
			<div class="table_area_style02 mg_b10">
				<table cellspacing="3" cellpadding="3" summary="입력 테이블입니다.">
				<caption>메일 작성</caption>
				<tbody>
						<tr>
							<th class="th_area">보내는사람</th>
							<td>
								<div class="sender_area">
									<input type="text" class="text_input" id="sender" name="sender" value="${emailAddress}" autocomplete="off" style="width: 100%;" readonly />
								</div>
							</td>
						</tr>
						<tr>
							<th class="th_area">받는사람</th>
							<td>
								<div class="receiver_area">
									<input type="text" class="text_input" id="receiver" name="receiver" value="" placeholder="ex) test1@s3i.co.kr, test2@naver.com" autocomplete="off" style="width: 100%;" />
								</div>
							</td>
						</tr>
						<tr>
							<th class="th_area">참조</th>
							<td>
								<div class="receiver_cc_area">
									<input type="text" id="cc" name="cc" class="text_input" placeholder="ex) test1@s3i.co.kr, test2@naver.com" style="width: 100%;"/>
								</div>
							</td>
						</tr>
						<tr>
							<th class="th_area">제목</th>
							<td>
							<div class="title_area" >
								<input type="text" class="text_input" id="title" name="title" value=""/>
							</div>
							</td>
						</tr>
						<table class="thBox layout_fixed">
							<table class="thBox layout_fixed">
							<tr>
								<th class='f_name' style="padding:5px 0;"><span style="margin-left: 10px;"><spring:message code="data.file.fileSendComplete.list.file.name" /></span></th> 
								<th class='f_size' style="padding:5px 0;"><span style="margin-left: 10px;"><spring:message code="data.file.fileSendComplete.list.file.size" /></span></th>
							</tr>
							</table>
							<div class="mail_scrollBox">
							<table class="layout_fixed">
							<c:forEach items="${attachFileList}" var="attachFile" varStatus="i">
							<tr>
								<td class="f_name name_ellipsis">
									<span class="mail_span">
										<c:out value='${attachFile.file_nm}'/>
									</span>
								</td>
								<td class="f_size name_ellipsis">
									<span class="mail_span">
										<c:out value='${customfunc:BigFileSizeFormat(attachFile.file_size)}'/>
									</span>
								</td>
							</tr>
							</c:forEach>
							</table>
							</div>
						</table>
						</tr>
						<tr>
							<td class="td_area">
								<textarea class="wrap_textarea" placeholder='메일 내용을 입력해주세요' id="content" name="content" ></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		<br/>
		<div class="btn_div">
			<button type="button" id="email" name="email" onclick="sendmail();"><span class="text">메일발송</span></button>
			<button type="button" onclick="windowclose();">닫기</button>
		</div>
	</div>
</fieldset>
</form>
</body>
</html>