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

$(document).ready(function() {
	checkFocusMessage($("#note"), "최대 100자까지 가능합니다");
	checkFocusMessage($("#title"), "최대 100자까지 가능합니다");
	
	var cud_cd = '${cud_cd}';
	if (cud_cd == 'C') {
		 $("input[name=use_yn]").attr("disabled", true);
	}else {
		 $("#stm_seq").attr("disabled", true);
	}

	closeloading();
});

//정책 추가
function add() {
	if(isVaildCheck()) {
		return false;
	}

	loading();
	
	 $("input[name=use_yn]").attr("disabled", false);
	 $("#stm_seq").attr("disabled", false);
	var requestURL = "<c:url value="/policy/streamPolicy/insertStreamPolicyGroup.lin" />";
	var successURL = "<c:url value="/policy/streamPolicy/streamPolicyGroupList.lin" />";

	resultCheckFunc($("#lform"), requestURL, function(response) {
		closeloading();
		var code = response['code'];
		var message = response['message'];
		if (code == "200") {
			alert("그룹이 설정되었습니다.");
			$(location).attr("href", successURL);
		} else if(code == "500") {
			alert(message);
			$(location).attr("href", successURL);
		}
	});
}

function isVaildCheck() {
	var note = $("#note").val();
	var title = $("#title").val();
	
	if(title.length == 0) {
		alert("그룹명을 입력해 주세요.");
		return true;
	}
	
	if(note.length == 0) {
		alert("설명을 입력해 주세요.");
		return true;
	}

	return false;
}

function cancel() {
	location.href = "<c:url value="/policy/streamPolicy/streamPolicyGroupList.lin" />";
}

function loading() {
	$('#mask2').fadeTo("slow",0.4);
	$('.loading_cus').show();
}

function closeloading() {
	$('#mask2, .loading_cus').hide();
}

</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="seq" name="seq" value="${streamPolicyGroupForm.seq}"/>
<input type="hidden" id="group_seq" name="group_seq" value="${streamPolicyGroupForm.seq}" />
<input type="hidden" id="cud_cd" name="cud_cd" value="${cud_cd}"/>
<input type="hidden" id="pol_seq" name="pol_seq" value="${streamPolicyGroupForm.pol_seq}" />

	<div id="mask2"></div>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="/Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=100 height=100 />
	</div>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">연계 정책관리</h2>
				<p class="breadCrumbs">정책관리 > 연계 정책관리</p>
			</div>
		</div>
			<div class="conWrap">
				<h3>그룹추가</h3>
				<div class="conBox">
					<div class="table_area_style02">
						<table summary="연계정책목록" style="table-layout: fixed">
							<caption>요청자, 제목, 요청시간</caption>
							<colgroup>
								<col style="width: 15%;">
								<col style="width: 85%;">
							</colgroup>
							<tbody>
								<tr>
									<th class="t_left">그룹명</th>
									<td>
										<input type="text" class="text_input" id="title" name="title" style="max-width:50%;" onkeyup="onlySizeFillter(this,100)" value="${streamPolicyGroupForm.title}" />
									</td>
								</tr>
								<tr>
									<th class="t_left">서버 ID</th>
									<td>
										<select style="width: 150px" title="서버 ID" id="stm_seq" name="stm_seq">
											<c:if test="${not empty stmInfoFormList}">
												<c:forEach items="${stmInfoFormList}" var="stmInfoForm">
													<c:choose>
														<c:when test="${stmInfoForm.stm_seq eq streamPolicyGroupForm.stm_seq}">
															<option value='${stmInfoForm.stm_seq}' selected='selected'>${stmInfoForm.stm_seq}</option>
														</c:when>
														<c:otherwise>
															<option value='${stmInfoForm.stm_seq}' >${stmInfoForm.stm_seq}</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</c:if>
										</select>
									</td>
								</tr>
								<tr>
									<th class="t_left">설명</th>
									<td>
										<input type="text" class="text_input" id="note" name="note" style="max-width:50%;" onkeyup="onlySizeFillter(this,100)" value="${streamPolicyGroupForm.note}" />
									</td>
								</tr>
								<tr>
									<th class="t_left">사용여부</th>
									<td>
										<input type="radio" name="use_yn" id="use_yn"  value ="Y"  <c:if test="${streamPolicyGroupForm.use_yn == 'Y' || streamPolicyGroupForm.use_yn == null || streamPolicyGroupForm.use_yn == ''}">checked="checked"</c:if>/>
										<label for="use" class="mg_r30">사용</label>
										<input type="radio" name="use_yn" id="use_yn"  value="N" <c:if test="${streamPolicyGroupForm.use_yn == 'N'}">checked="checked"</c:if>/> 
										<label for="unused">미사용</label>
									</td>
								</tr>
								<c:if test="${cud_cd eq 'U' }">
								<tr>
									<th class="t_left">생성자</th>
									<td>
										${streamPolicyGroupForm.crt_id}
									</td>
								</tr>
								<tr>
									<th class="t_left">생성일</th>
									<td>										
										<fmt:formatDate value="${streamPolicyGroupForm.crt_date }" pattern="yyyy-MM-dd HH:mm" />
									</td>
								</tr>
								</c:if>
							</tbody>
						</table>
					</div>
					<div class="btn_area_center mg_t10 mg_b10">
						<button type="button" class="btn_common theme mg_r5" onclick="add()">저장</button>
						<button type="button" class="btn_common theme" onclick="cancel()">취소</button>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>