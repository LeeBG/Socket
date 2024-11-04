<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<script type="text/javascript" src="<c:url value="/JavaScript/webtoolkit.base64.js" />"></script>
<script type="text/javascript">
	$(document).ready(function() {
		<c:if test="${auth_cd == 4}">
		allInputDisable();
		</c:if>
		resetAllChk();
		showExtensionTable();
		loadExtsPolicy();
		checkFocusMessage($("#exts_nm"),"1 ~ 50자리까지 입력이 가능합니다.");
		checkFocusMessage($("#note"),"1 ~ 100자리까지 입력이 가능합니다.");
		$("#pageListSize").change(search);
	});

	function initialize() {
		$('#allChk').attr("checked", false);
		$("input[name=chk]").attr("checked", false);
		$('.selected_extension_list').children().remove();
		//window.location.reload();
	}

	function cancel() {
		location.href = "<c:url value="/policy/extPolicy/extPolicyMgt.lin" />";
		//$('#lform').action = "<c:url value="/policy/extPolicy/extPolicyMgt.lin" />";
		//$('#lform').submit();
	}

	function search() {
		var searchConditionValue = $("#searchCondition option:selected").val();
		$("#searchField").val(searchConditionValue);
		$("#page").val(1);
		showExtensionTable();
	}

	function save() {
		titleFilter('exts_nm', 'note');

		var requestURL = "<c:url value="/policy/extPolicy/insertExtPolicyMgt.lin" />";
		var successURL = "<c:url value="/policy/extPolicy/extPolicyMgt.lin" />";

		$(":button").attr("disabled", true);
		resultCheckFunc($("#lform"), requestURL, function(response) {
			$(":button").attr("disabled", false);
			resultSuccess(response, successURL, true);
		});
	}

	function del(seq, ext, mimetype) {
		if(confirm("확장자 : "+ ext +"\nMIME_TYPE : " + mimetype + "\n을(를) 삭제 하시겠습니까?")){
			var requestURL = "<c:url value="/policy/extPolicy/deleteMimeType.lin" />?seq="+seq;
	
			resultCheckFunc($("#lform"), requestURL, function(response) {
				var code = response['code'];
				var message = response['message'];
				if (code == "200") {
					alert(message);
				} else if(code == "500") {
					alert(message);
				}
				location.href = "<c:url value="/policy/extPolicy/extPolicyMgt.lin" />";
			});
		}
	}
	
	function setSelectExts(obj) {
		var seq = "";
		var flag = false;

		$(obj).parent().parent().children().each(function(idx){
			if(idx == 0) {
				if($(this).children().is(":checked")) {
					flag = true;
				} else {
					flag = false;
				}
			}
			if(idx == 1) {
				seq = $(this).html();
			}
			if(flag) {
				if(idx == 2) {
					var htm = $('.selected_extension_list').html();
					var li = "<li><input type='hidden' value='"+seq+"' name='exts' /><span>"+ seq + ". " + $(this).html()+"</span> <button class='btn_del' type='button' id='exts_" + seq +"' onclick='deleteBtn(this, " + seq + ")'><span class='ir_desc'>삭제</span></button></li>";
					htm = htm + li;
					$('.selected_extension_list').html(htm);
				}
			} else {
				$('#exts_'+ seq).parent().remove();
			}
		});
		
	}

	function deleteBtn(obj, seq) {
		$(obj).parent().remove();
		$("#chk_"+seq).attr("checked", false);
	}

	function togchk(obj, name) {
		$("input:checkbox").each(function(idx){
			if(idx != 0 && $(this).is(":checked") == true){
				var seq = $(this).val();
				$('#exts_'+ seq).parent().remove();
			}
		});
		$("input:checkbox[name=" + name + "]").attr("checked", $(obj).is(":checked"));
		$("input:checkbox").each(function(idx){
			if(idx != 0){
				var obj2 = $(this);
				setSelectExts(obj2);
			}
		});
	}

	//확장자목록 불러오기 json
	function showExtensionTable() {
		var requestURL = "<c:url value="/policy/extPolicy/extList.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var fExtsList = response['fExtsList'];
			var paging = response['paging'];
			var pageList =  response['pageList'];
			/* var pageIndex =  response['pageIndex']; */

			var extensionTbody = $("#extensionTable tbody");
			$("#extensionTable tbody tr").remove();
			var extension = "";
			if (fExtsList.length >  0) {
				for (var i=0; i < fExtsList.length; i++) {
					extension = '<tr> \n';
					extension += '	<td class="td_chekbox Rborder t_center"><input type="checkbox" class="input_chk" id="chk_' + fExtsList[i].seq + '"  name="chk" value="' + fExtsList[i].seq + '" onclick="setSelectExts(this)" /></td> \n';
					extension += '	<td class="t_center Rborder">' + fExtsList[i].seq + '</td> \n';
					extension += '	<td class="t_center Rborder">' + fExtsList[i].exts + '</td> \n';
					extension += '	<td class="t_center Rborder">' + fExtsList[i].mime_type + '</td> \n';
					extension += '	<td class="t_center"><button class="btn_del" type="button" onclick=\'del(' + fExtsList[i].seq + ', "' + fExtsList[i].exts + '", "' + fExtsList[i].mime_type + '")\'><span class="ir_desc">삭제</span></button></td> \n';
					extension += '</tr> \n';
					extensionTbody.append(extension);
				}
			} else {
				extension = '<tr> \n';
				extension += '<td class="t_center right_line" colspan="4"><spring:message code="global.script.search.no.result" /></td> \n';
				extension += '</tr> \n';
				extensionTbody.append(extension);
			}

			var page = Base64.decode(pageList);
			//pageIndex = Base64.decode(pageIndex);
			$("#pageDiv").html(page);
			$("#total").html("총 " + paging.totalCount + "건");

			loadChecked();
		});
	}

	//전체체크
	function resetAllChk() {
		if($('#allChk').is(":checked")){
			$('#allChk').attr("checked", false);
		}
	}

	//페이징 처리
	function goPage(page) {
		resetAllChk();
		$("#page").val(page);
		showExtensionTable();
	}

	//li리스트, 체크하기
	function loadChecked() {
		var selectedExtensionList = $('.selected_extension_list');
		$(selectedExtensionList).children().children('span').each(function(idx) {
			var seq = $(this).html().split('.')[0];
			$("#chk_"+ seq).attr("checked", true);
		});
	}

	//정책 수정시 체크된 확장자 불러오기
	function loadExtsPolicy() {
		var extsLoadListJson= ${extsLoadListJson};
		for(key in extsLoadListJson) {
			var htm = $('.selected_extension_list').html();
			var li = "<li><input type='hidden' value='"+key+"' name='exts' /><span>"+ key + ". " + extsLoadListJson[key]+"</span> <button class='btn_del' type='button' id='exts_" + key +"' onclick='deleteBtn(this, " + key + ")'><span class='ir_desc'>삭제</span></button></li>";
			htm = htm + li;
			$('.selected_extension_list').html(htm);
		};
	}

	function openExtsPopup() {
		var url = "<c:url value="/policy/extPolicy/checkExtPopup.lin" />";
		var attibute = "resizable=no,scrollbars=no,width=590,height=300,top=5,left=5,toolbar=no,resizable=no,toolbar=no,resizable=no,url=no";
		var popupWindow = window.open(url, "checkExtPopup", attibute);
		popupWindow.focus();
	}

	function download(){
		var searchConditionValue = $("#searchCondition option:selected").val();
		$("#searchField").val(searchConditionValue);

		var frm = document.lform;
		frm.action="<c:url value="/policy/extPolic/extExcelDownload.lin" />";
		frm.submit();

		frm.action="<c:url value="/policy/extPolicy/extPolicyInfo.lin" />";
	 }
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/policy/extPolicy/extPolicyMgt.lin" />">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input type="hidden" id="page" name="page" />
<input type="hidden" id="crt_id" name="crt_id" value="${fExtsMgtForm.crt_id}">
<input type="hidden" id="cud_cd" name="cud_cd" value="${cud_cd}">
<input type="hidden" id="isdel_yn" name="isdel_yn" value="${fExtsMgtForm.isdel_yn}">
<input type="hidden" id="searchField" name="searchField" value="${fExtsMgtForm.searchField}"/>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">확장자정책 관리</h2>
				<p class="breadCrumbs">정책관리 > 확장자정책 관리</p>
			</div>
		</div>
		<div class="conWrap tableBox viewBox">
			<h3>확장자 정책</h3>
			<div class="conBox">
				<div class="topCon">
					<table summary="확장자 정책" style="table-layout : fixed" >
					<caption>정책, 정책명, 설명, 선택확장자</caption>
						<colgroup>
							<col style="width:7%;"/>
							<col style="width:10%;" />
							<col style="width:5%;" />
							<col style="width:24%;" />
							<col style="width:5%;" />
							<col style="width:44%;" />
						</colgroup>
						<tbody>
							<tr>
								<th class="Bborder t_left pd_l12">정책ID</th>
								<td class="Bborder"><input type="text" class="text_input" id="exts_seq" name="exts_seq" value="${fExtsMgtForm.exts_seq}" readonly="readonly" /></td>
								<th class="Bborder Lborder t_center">정책명</th>
								<td class="Bborder"><input type="text" class="text_input" id="exts_nm" name="exts_nm" onkeyup="onlySizeFillter(this,50)" value="${fExtsMgtForm.exts_nm}" /></td>
								<th class="Bborder Lborder t_center">설명</th>
								<td class="Bborder"><input type="text" class="text_input" id="note" name="note" onkeyup="onlySizeFillter(this,100)" value="${fExtsMgtForm.note}" /></td>
							</tr>
							<tr>
								<th class="va_top pd_t15 t_left pd_l12">선택확장자</th>
								<td colspan="5" class="ulBox">
									<p class="noneList"  style="display:none;">아래 리스트에서 확장자를 선택하세요.</p> 
									<ul class="selected_extension_list" >
									</ul>
								</td>
							</tr>
							<tr>
								<td colspan="6" class="Tborder Bborder t_center">
								<c:if test="${auth_cd != 4}">
									<button type="button" class="btn_big theme mg_r5" onclick="initialize()">초기화</button>
									<button type="button" class="btn_big theme" onclick="save()">저장</button>
								</c:if>
									<button type="button" class="btn_big theme mg_l5" onclick="cancel()">취소</button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="table_area_style01">
					<c:if test="${auth_cd != 4}">
					<div class="table_area_topCon mg_t15 mg_b5">
						<button type="button" class="btn_common grey f_left mg_l5" onclick="openExtsPopup()">새 확장자 추가</button>
						<button type="button"  onclick="download()" class="btn_common grey f_left mg_l5" style="vertical-align: bottom;">엑셀다운로드</button>
						<div class="searchBox f_right t_right mg_r10" style="width:30%;">
							<select id="searchCondition" title="파일전송정책 검색조건">
								<option selected="selected" value="exts">확장자명</option>
								<option value="mime_type">MIME-TYPE</option>
							</select>
							<input type="text" class="text_input long" style="margin-right:-4px;" id="searchValue" name="searchValue" value="${fExtsMgtForm.searchValue}" />
							<button class="btn_search" onclick="search()">검색</button>
						</div>
					</div>
					</c:if>
					<table id="extensionTable" summary="자료 수신함" style="table-layout : fixed" class="mg_t5" >
					<caption>요청자, 제목, 요청시간</caption>
						<colgroup>
							<col style="width:3%;"/>
							<col style="width:17%;" />
							<col style="width:25%;" />
							<col style="width:45%;" />
							<col style="width:10%;" />
						</colgroup>
						<thead>
							<tr>
								<th class="Rborder"><input type="checkbox" class="input_chk" id="allChk" onclick="togchk(this, 'chk');" /></th>
								<th class="Rborder">순번</th>
								<th class="Rborder">확장자명</th>
								<th class="Rborder">MIME-TYPE</th>
								<th class="Rborder">삭제</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="5" class="td_last">
									<span id ="total" class="text_list_number"></span>
									<div id="pageDiv" class="pagenate t_center">
									</div>
									<span class="pagenate_listsize">
										<select id="pageListSize" name="pageListSize">
											<option value="10" <c:if test="${paging.pageListSize == '10'}">selected="selected"</c:if>>10</option>
											<option value="20" <c:if test="${paging.pageListSize == '20'}">selected="selected"</c:if>>20</option>
											<option value="30" <c:if test="${paging.pageListSize == '30'}">selected="selected"</c:if>>30</option>
											<option value="50" <c:if test="${paging.pageListSize == '50'}">selected="selected"</c:if>>50</option>
											<option value="100" <c:if test="${paging.pageListSize == '100'}">selected="selected"</c:if>>100</option>
										</select>
										개 보기
									</span>
								</td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>
