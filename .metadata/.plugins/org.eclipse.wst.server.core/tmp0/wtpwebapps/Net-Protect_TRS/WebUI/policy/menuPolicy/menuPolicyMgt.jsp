<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="CUD_CD_D" value="${customfunc:codeString('CUD_CD', 'DELETE')}" />
<script type="text/javascript">
	$(document).ready(function() {
		$("input[name=authInfo]").removeAttr('checked');
		$("input[name=authInfo]").change(function() {
			 isChangeMenu();

			var authCd = $(this).val();
			$("#authCd").val(authCd);

			selectFpolAuthMgtList();
		});
	});

	function isDelYn(isDel) {
		if (isDel == 'Y') {
			$('#delBtn').css("display", "");
		} else {
			$('#delBtn').css("display", "none");
		}
	}

	function isChangeMenu() {
		var isChange = false;
		$(":checkbox[name=chk]").each(function(idx , elem) {
			var beforeVal = $(this).attr("title");	// 변경전 체크
			var afterVal = $(this).attr("checked");	// 변경후 체크
			if (beforeVal != afterVal ) 
				isChange = true;
		});
		if(isChange) updateFMPL0010();
	}

	function selectFMPL0020(type) {
		 isChangeMenu();
		$("#type").val(type);
		selectFpolAuthMgtList();
	}

	function selectFpolAuthMgtList() {
		var requestURL = "<c:url value='/policy/authPolicy/selectFpolAuthMgtList.lin' />";

		resultCheckFunc($("#lform"), requestURL, function(response) {
			var programList = response['programList'];
			var programBody = $("#programBody");
			$("#programBody tr").remove();

			for (var i = 0; i < programList.length; i++) {
				var programIds = programList[i].prgm_id;
				var programIdArray = programIds.split(",");

				var programNms = programList[i].prgm_nm;
				var programNmArray = programNms.split(",");

				var programBodyHtml = "";
				var temp = 0;
				for (var j = 0; j < programIdArray.length/4; j++) {
					programBodyHtml += '<tr> \n';
	 				if (j == 0) {	// rowspan 
						programBodyHtml += '<td rowspan="'+ Math.ceil(programIdArray.length/4) +'" class="t_center Rborder" style="background-color:#f1f1f1;">'+programList[i].menu_nm+'</td> \n';
	 				}
	 				for (var k = 0; k <4; k++) {
	 					if(typeof programIdArray[k+temp] != "undefined") {
							programBodyHtml += '<td style="border-bottom:0px;"> \n';
							programBodyHtml += '<input type="checkbox" class="input_chk" name="chk" id="' + programIdArray[k+temp] + '" value="' + programIdArray[k+temp]+'" /> \n';
							programBodyHtml += programNmArray[k+temp] + '\n';
							programBodyHtml += '</td> \n';
	 					}
					}
	 				temp = (3*(j+1)+j+1);
					programBodyHtml += '</td> \n';
					programBodyHtml += '</tr> \n';
				}
				programBody.append(programBodyHtml);
			}

			var authPolicyList = response['authPolicyList'];
			for (var i = 0; i < authPolicyList.length; i++) {
				$('#'+authPolicyList[i].prgm_id+'').attr('checked', 'checked'); // from id
				$('#'+authPolicyList[i].prgm_id+'').attr('title', 'checked'); // from id
			}
		});
	}

	function updateFMPL0010(){
		if (!$(":input[name=authInfo]").is(":checked")) {
			alert("권한이 선택되지 않았습니다.");
			return;
		}

		var programArray = new Array();
		$(":checkbox[name=chk]").each(function(idx , elem){
			var beforeVal = $(this).attr("title");	// 변경전 체크
			var afterVal = $(this).attr("checked");	// 변경후 체크
			var program = new Object();

			if (beforeVal == "checked" &&  afterVal == null) {
				program.cud_cd = "D";
				program.id = $(this).val();
				programArray.push(program); 
			} else if (beforeVal == null &&  afterVal == "checked"){
				program.cud_cd = "C";
				program.id = $(this).val();
				programArray.push(program);
			}
		});

		$('#programArray').val(JSON.stringify(programArray));

		if (confirm("저장하지 않은 변경 값이 있습니다. 변경된 값을 저장하시겠습니까?")) {
			if(programArray != null || programArray != ""){
				var requestURL = "<c:url value="/policy/menuPolicy/updateMenuPolicyMgt.lin" />";
				var successURL = "<c:url value="/policy/menuPolicy/menuPolicyMgt.lin" />";
				resultCheckFunc($("#lform"), requestURL, function(response) {
					var code = response['code'];
					if (code == '200') {
						alert('권한설정이 저장 되었습니다.');
						$(location).attr("href", successURL);
					} else {
						alert('권한설정 저장중 오류가 발생 되었습니다.');
					}
				});
			} else {
				alert('변경된 사항이 없습니다.');
			}
		} 
	}

	function openPopup(cud_cd) {
		if(cud_cd == "U"){
			var auth_cd = $(':radio[name="authInfo"]:checked').val();
			if(auth_cd == null){
				alert('권한이 선택되지 않았습니다.');
				return;
			}
		}
		var auth_cd = $(':radio[name="authInfo"]:checked').val();
		var url = "<c:url value="/policy/menuPolicy/menuPolicyMgtPopup.lin" />?cud_cd="+cud_cd+"&auth_cd="+auth_cd;
		var attibute = "resizable=no,scrollbars=no,width=590,height=300,top=5,left=5,toolbar=no,resizable=no";
		var popupWindow = window.open(url, "popup", attibute);
		popupWindow.focus();
	}

	function deleteAuth(cud_cd){
		var auth_cd = $(':radio[name="authInfo"]:checked').val();
		if (auth_cd == null) {
			alert('권한이 선택되지 않았습니다.');
			return;
		}else{
			if (confirm(" 정말로 삭제 하시겠습니까?")) {
				$("#auth_cd").val(auth_cd);
				$("#cud_cd").val(cud_cd);
				var errmsg = new cls_errmsg();
				if (errmsg.haserror) {
					errmsg.show();
					return;
				}
				var requestURL = "<c:url value="/policy/menuPolicy/insertMenuPolicyMgt.lin" />";
				var successURL = "<c:url value="/policy/menuPolicy/menuPolicyMgt.lin" />";
				var resultStr = "권한이 삭제 되었습니다.";
				var resultErrStr = "권한 삭제 중 에러가 발생 되었습니다.";
				if (cud_cd == '${CUD_CD_D}') {
					resultCheckFunc($("#lform"), requestURL, function(response) {
					var code = response['code'];
						if (code == '200') {
							alert(resultStr);
							$(location).attr("href", successURL);
						} else {
							alert(resultErrStr);
						}
					}); 
				}
			}else{
				return;
			}
		}
	}
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/policy/menuPolicy/menuPolicyMgt.lin" />">
<input id="page" name="page" type="hidden"/>
<input id="pol_seq" name="pol_seq" type="hidden" value = ""/>
<input id="cud_cd" name="cud_cd" type="hidden" value = ""/>
<input id="authCd" name="authCd" type="hidden" value = "0"/>
<input id="auth_cd" name="auth_cd" type="hidden" value = ""/>
<input id="type" name="type" type="hidden" value = "F"/>
<input id="programArray" name="programArray" type="hidden" value = ""/>
<div class="rightArea">
	<div class="conWrap trisectionWrap">
		<div class="conWrap trisection left">
			<h3>권한</h3>
			<div class="conBox">
				<div class="table_area_style01">
					<table summary="권한명" style="table-layout : fixed" class="">
					<caption>권한명</caption>
						<colgroup>
							<col style="width:100%;"/>
						</colgroup>
						<tbody id="authInfoBody">
							<c:forEach items="${authInfoList}" var="authInfo">
									<tr>
										<td class="Rborder">
											<input type="radio" onchange="isDelYn('${authInfo.isdel_yn}')" class="input_radio" name="authInfo" value="${authInfo.auth_cd}"/>
											<label for="${authInfo.auth_cd}label" id="${authInfo.auth_cd}">${authInfo.auth_cd_nm}</label>
										</td>
									</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="btn_area_center mg_t10 mg_b10">
					<button type="button" class="btn_common theme mg_r3" onclick="openPopup('${CUD_CD_C}')">신규</button>
					<button type="button" class="btn_common theme mg_r3" onclick="openPopup('${CUD_CD_U}')">수정</button>
					<button type="button" class="btn_common theme" id="delBtn" onclick="deleteAuth('${CUD_CD_D}')">삭제</button>
				</div>
			</div>
		</div>
		<div class="conWrap trisection right">
			<h3>하위메뉴 권한설정</h3>
			<div class="conBox">
				<div class="tab_box">
					<div id ="tab" class="Rborder tab on" onclick="selectFMPL0020('F')">
						<p ><a href="#">자료전송 권한설정</a></p>
						<!--.viewer_box에 내용보여주기-->
					</div>
					<div id="tab" class="tab" onclick="selectFMPL0020('S')">
						<p ><a href="#" >망연계 권한설정</a></p>
					</div>
					</div>
				</div>
				<div class="table_area_style01 hoverTable mg_t10">
					<table summary="하위메뉴 권한설정" style="table-layout : fixed;">
					<caption>메뉴명</caption>
						<colgroup>
							<col style="width:20%;"/>
							<col style="width:20%;"/>
							<col style="width:20%;"/>
							<col style="width:20%;"/>
							<col style="width:20%;"/>
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder">대분류</th>
								<th class="Rborder" colspan="4">소분류</th>
							</tr>
						</thead>
						<tbody id="programBody">
						</tbody>
					</table>
				</div>
				<div class="btn_area_center Tborder">
					<button type="button" onclick="updateFMPL0010()" class="btn_common theme mg_t10 mg_b10">저장</button>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>