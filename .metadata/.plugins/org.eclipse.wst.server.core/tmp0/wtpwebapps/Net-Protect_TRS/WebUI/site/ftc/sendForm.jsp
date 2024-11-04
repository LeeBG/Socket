<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="approvalPolicy" value="${loginUser.approvalPolicy}" />
<c:set var="isApprovalUse" value="${approvable }" />
<c:set var="networkPosition" value="${customfunc:getNetworkPosition() }"/>
<c:set var="repositoryTotalSize" value="${ (networkPosition eq 'I') ? repositoryUsedInfo.inner_volume_size : repositoryUsedInfo.outer_volume_size }"/>
<c:choose>
	<c:when test="${!isApprovalUse}">                                      <c:set var="isValidApproval" value="true"/></c:when> <%-- 결재사용안함 --%>
	<c:when test="${isApprovalUse && approvalLineInfo != null}">           <c:set var="isValidApproval" value="true"/></c:when> <%-- 결재선이 정상인경우 --%>
	<c:when test="${isApprovalUse && approvalPolicy.self_app_yn eq 'Y'}">  <c:set var="isValidApproval" value="true"/></c:when> <%-- 자가결재인경우 --%>
	<c:when test="${isApprovalUse && 
	      approvalPolicy.after_app_yn eq 'Y'&& approvalLineInfo != null}"> <c:set var="isValidApproval" value="true"/></c:when> <%-- 사후결재인경우 --%>
	<c:otherwise>                                                          <c:set var="isValidApproval" value="false"/></c:otherwise> <%-- 그 외 비정상 상태 --%>
</c:choose>
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="<c:url value="/JavaScript/numeral.min.js" />"></script>
<%@include file="/WebUI/include/module_file_resource.jsp" %> <%-- binary.js와 file.js를 import함 --%>
<%@include file="/WebUI/include/script_variables.jsp" %> <%-- 환경 정보를 가져와 env객체에 초기화 --%>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.popup.js" />?v=20230130"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.call.js" />?v=20200103"></script>
<c:if test="${userAgent eq true}">
<script type="text/javascript" src="<c:url value="/common/innorix.js" />"></script>
</c:if>

<script type="text/javascript">
var siteCode = '${getSiteCode}';
var saveLastApproval;
var u_id = '${customfunc:pbkdfEncodedString(loginUser.users_id)}';
var selectApprover = null;
var popup_approver_1 = null;
var popup_approver_2 = null;
var approverArray = "";
var approvalUser = '<c:out value="${ approvalUser }" />';
approvalUser = approvalUser.replaceAll("&#034;", "\"");

var file_manager = new NPFileTransManager();
var app_manager = new ApprovalManager();
app_manager.setMustChooseApprover('${isApprovalUse}','${approvalPolicy.self_app_yn}','${approvalLineInfo!=null}');

var alw_app_extension = '${approvalExtension}';
var alw_extension = '${allowExtension}';
var is_white_list = '${isFileExtCheck}';
var afterAppLockPeriod = '<c:out value="${ sessionScope.loginUser.approvalPolicy.after_app_lock_period }"/>';
var isValidApproval = '${isValidApproval}';

	$(document).ready(function() {
		if( app_manager.getMustChooseApprover() ){
			app_manager.initLastApprover();
		}else{
			app_manager.removeLastApprover();
		}

		changeFileSendButton( ('${userAgent}' == 'true') ? $('#innorix_send_button') : $('#send_button') , 'send' );

		<c:if test="${userAgent eq 'true'}">
		innoInit({
			ContainElementID : "innorix_component", // 컴포넌트 출력객체 ID
			ActionElementID : "lform", // 메타정보 전송폼 ID
			UploadURL : "<c:url value="/data/file/upload.lin" />", // 업로드 처리 페이지
			ResultURL : "<c:url value="/data/file/innorixSendResult.lin" />", // Plus 업로드 완료정보 전달 URL 
			ViewType : "1",
			ListStyle : "fullpath",
			MaxTotalSize : "${upSize}MB", // 첨부가능 전체용량 
			MaxFileSize : "${oneSize}MB", // 첨부가능 1개파일 용량
			<c:if test="${not empty upCnt}">
				MaxFileCount : "${upCnt}", // 첨부가능 파일개수
			</c:if>
			CharSet : "UTF-8",
			SetResume : "true",
			ReconnectSec : "2", // 재시도 간격(단위:초)
			ReconnectCount : "5", // 재시도 횟수(-1 : 무제한)
			BkImgURL : "../../Images/common/inno.png",
			TransferMode : "innoexu",
			LogLevel : "7", // 5 = 기본로그 1 + HTTP 통신로그 4
			<c:if test="${not empty uiAllowExtension}">
			<c:choose>
				<c:when test="${isFileExtCheck}">
					ExtFilter: ["문서파일", "${allowExtension};"]
				</c:when>
				<c:otherwise>
					ExtFilterExclude : ["${allowExtension}"]
				</c:otherwise>
			</c:choose>
			</c:if>
		});
		</c:if>
		initTransfer();

		app_manager.initApprovalUser();
		noticeApprovalLockToApprover("Y", afterAppLockPeriod, "${networkPosition}");

		blockImgDragEvent();
	});

	function innoOnEvent(msgEvent, arrParam, objName) {
		if (msgEvent == Event.msgUploadCancel) { // 이노릭스 전송 취소 이벤트
			location.reload();
		}
		if (msgEvent == Event.msgUploadError){
			File.StartUpload();
		}
	}

	// upload_type : 'agent','web','innorix'
	function fileupload() {
		var upload_type = arguments[0];
		var ext_app_send = ( arguments.length > 1 ) ? arguments[1] : 'N';
		var enc_yn = 'Y';

		var send_button = (upload_type == 'innorix') ? $('#innorix_send_button') : $('#send_button');
		if( send_button.hasClass('preparing') || send_button.hasClass('disable') || send_button.hasClass('full')){
			return;
		}

		if( ext_app_send == 'Y') {
			return requestFileUpload();
		}

		if( isCanUploadFile() ){
			if(app_manager.existExtAppTarget()) {
				app_manager.showExtApprovalLinePopUp("<c:url value="/data/file/extApprovalPopup.lin" />");
				return false;
			}

			return requestFileUpload();
		} else {
			return false;
		}

		function requestFileUpload(){
			try {
				if( upload_type == 'web' ){
					if( file_manager.init() ){
						file_manager.upload();
					}else{
						alert('파일을 전송할 수 없는 상태입니다.');
					}
				}else if( upload_type == 'innorix' ) {
					changeFileSendButton( send_button , 'processing' );
					InnoInterface.AddPostData("_folder", "");
					var jsessionId = '${cookie.JSESSIONID.value}';
					InnoInterface.SetSessionID("JSESSIONID=" + jsessionId);
					File.Upload();
				}else{
					s3i_fileUpLoad(JSONFILELIST, "${loginUser.users_id}", enc_yn);
				}
			} catch (e) {
				alert(e);
			}
		}  //end of requestFileUpload

		function isCanUploadFile(){
			var errmsg = new cls_errmsg();
			var fileMaxCnt = $("#upCnt").val();
			var fileCount = ('${userAgent}' == 'true') ? File.GetTotalCount() : '';

			try {
				if( isValidApproval != 'true' ){
					alert("<spring:message code="data.file.sendForm.script.invalid.approval.state"/>");
					return;
				}

				if ('${userAgent}' != 'true') {
					if ( ( upload_type != 'web' && $("#jsonfileList").val() == "" ) 
							|| ( upload_type == 'web' && file_manager.isEmptyFile() )) {
						throw "전송할 파일이 없습니다. 파일을 선택해주세요.";
					}
				}
				if ( ( '${userAgent}' == 'true' && fileCount < 1) ) {
					throw "전송할 파일이 없습니다. 파일을 선택해주세요.";
				}

				if( isRepositoryFull() ) throw "자료함 용량을 초과하여 자료전송이 불가합니다. [자료송수신 > 보낸 자료]에서 자료를 삭제 후 이용해주시기 바랍니다. \n- 자료함 용량 증설을 원하시는 경우 관리자에게 문의하시기 바랍니다.";
				
				if( upload_type == 'web' && ! file_manager.isValidCount(fileMaxCnt) ){
					throw "파일 전송은 최대 "+fileMaxCnt+"개까지 가능합니다.";
				}

			<c:if test="${isApprovalUse}">
				<%-- 자가 결재 체크 --%>
				<%--
				data.file.sendForm.script.selfApproval.request.confirm : 자가결재로 요청 가능합니다. 자가결재로 요청하시겠습니까?
				data.file.sendForm.script.selfApproval.request.valid : 자가결재 권한을 소유하고 있습니다. 자가결재로 요청 가능합니다.
				--%>
				if( ($("#selfAppYn").val() == 'Y') && (app_manager.validateSelfApprovalChecked('<spring:message code="data.file.sendForm.script.selfApproval.request.confirm" />', '<spring:message code="data.file.sendForm.script.selfApproval.request.valid" />') == false) ) 
					return;

				if ($("#afterApproval").attr('checked') && $("#selfApproval").attr('checked')) {
					throw '<spring:message code="data.file.sendForm.script.invalid.both.self.after" />';<%-- 자가결재과 사후결재는 동시에 선택할 수 없습니다. --%>
				} else {
					if( ! $("#selfApproval").attr('checked') ) {
						var approverArray = $("#approverArray").val();
						approverArray = (approverArray == '' || approverArray.empty()) ? approverArray : JSON.parse(approverArray);
						validateSetApprovers( approverArray );
						validateSelfApproverNotSelfMode( approverArray );
						validateDuplicatedApprover( approverArray, false );
					}
				}

				<%-- 사후 결재 제한 체크 --%>
				if( ($("#selfAppYn").val() == 'N') && ($("#afterAppYn").val() == 'Y') && (existsAfterRestrictionLockApprover($("#approverArray").val(), "confirm", true) == false) ) 
					return;

				<%-- 사용자 정책에 대한 결재권한 체크 --%>
				app_manager.checkApprovalAuthority();
			</c:if>

				<%-- 타이틀 검사 --%>
				var titleUseYn = $("#titleUseYn").val();
				if(titleUseYn == "Y"){
					validateNoTitle(false);
				}else{
					validateNoTitle(true);	
				}
				<%-- 확장자 white/black list server 체크 
				file_manager.validateValidExtension();--%>
				var isExistExtAppFile = app_manager.isExistExtAppFile();
				var isNormalFileSend = ! isExistExtAppFile;
				if( ( isExistExtAppFile && ! confirm("<spring:message code="data.file.sendForm.script.extApp.confirm.upload" />") ) <%-- 목록에 결재가 필요한 파일이  존재합니다. 결재자 선택 후 자료전송이 가능합니다.\\n결재자를 선택하시겠습니까? --%>
						|| ( isNormalFileSend && ! confirm("<spring:message code="data.file.sendForm.script.confirm.upload" />") ) ){ <%-- 자료전송을 하시겠습니까? --%>
					return false;
				}
			} catch (e) {
				errmsg.append(null , e);
				errmsg.show();
				return false;
			}
			return true;
		} //end of isCanUploadFile
	}

	function isRepositoryFull() {
		return ( ($("#repositoryUsedRatio").length > 0) && ($("#repositoryUsedRatio").val() > 1) );
	}

	/* 중복된 결재자를 선택했는지 체크, true : 중복 허용 , false : 중복 허용X*/
	function validateDuplicatedApprover( approverArray, allow ) {
		var findApprover;

		if(allow == true) return;

		approverArray.forEach(function(user) {
			findApprover = $.grep( approverArray , function(obj, index) {
				return user.users_id == obj.users_id;
			});
			if( findApprover.length > 1 ) 
				throw '<spring:message code="data.file.sendForm.script.invalid.duplicatedApprover" arguments="' + user.users_nm + '"/>';<%-- 중복된 결재자를 선택할 수 없습니다. 결재자명 : --%>
		});
	}

	/* 빈제목 허용 : true, 빈제목 허용안함 : false */
	function validateNoTitle(allow) {
		var titleSizeMin = $("#titleSizeMin").val();
 		var titleSizeMax = $("#titleSizeMax").val();
 		var titleSize = $("#title").val().length;
 		var retVal = ('${ userAgent }' == 'true') ? File.GetTotalFileInfo() : '';
		if ($("#title").val().empty()) {
			if(allow === true){
				//파일명 입력!!
				if ('${ userAgent }' == 'true') {
					$("#title").val(retVal[0][1]);
				} else {
					$("#title").val(file_manager.files()[0].file.name);
				}
			} else {
				throw '<spring:message code="data.file.sendForm.script.invalid.title2" />'; //자료전송 제목을 입력해야 합니다.
			}
		}else if(Number(titleSizeMin) > Number(titleSize) ||  Number(titleSize) > Number(titleSizeMax)){
			$("#title").focus();
			throw "제목을 "+titleSizeMin+"자 이상 "+titleSizeMax+"자 이하로 입력해주세요.";
		}
	}

	function validateSelfApproverNotSelfMode(approverArray) {
		if ( ! app_manager.checkAppLineApprover(approverArray, '${loginUser.users_id}') ) throw '<spring:message code="data.file.sendForm.script.invalid.approval.selfReqeust" />'; <%-- 본인 결재는 불가능합니다.(자가결재 선택 시 가능) --%>
	}

	function validateSetApprovers(approverValue) {
		var app_level = "${approvalLineLevel}";
		
		if( (approverValue == null || approverValue == '') || (approverValue.length != app_level) ){
			throw "<spring:message code="data.file.sendForm.script.invalid.appr" />";
		}
	}

	function blockImgDragEvent(){
		$('img').on('dragstart',false);
	}
</script>

<script type="text/javascript">
	var userList = "";
	
	function initTransfer() {
		$("#jsonfileList").val("");
		$(':checkbox:checked').prop('checked',false);
		$('input[type="text"]').val('');
		/* checkFocusMessage($("#title"),"최대 100자까지 가능합니다."); */

		(function( type ){
			if('${ userAgent }' == 'true'){
				type = 'file_innorix';
			}
			switch (type) {
			case 'file_web' : $(".file_agent").hide(), $(".file_innorix").hide();
				break;
			case 'file_agent': $(".file_web").hide(), $(".file_innorix").hide();
				break;
			case 'file_innorix': $(".file_agent").hide(), $(".file_web").hide();
				break;
			}
			$("."+type).show();
		})('file_web');

		bindDragEvent();
		app_manager.initApprovalSetting();
		initRepositoryInfo();
	}

	function initRepositoryInfo() {
		if( isRepositoryFull() ) {
			changeFileSendButton($('#send_button'), 'full');
			
			$("#restrictNotice").html("※ 자료함 용량을 초과하여 자료전송을 이용할 수 없습니다.");
		}
	}

	function bindDragEvent(){
		var box = $('#file_uploader');
		var fileMaxCnt = $("#upCnt").val();
		box.on('dragenter', doNothing);
		box.on('dragover', doNothing);
		box.on('drop', function(e){
			if (isDraggedItemIsFile(e)) {
				e.originalEvent.preventDefault();
				appendFileList(file_manager , e.originalEvent.dataTransfer.files, fileMaxCnt);
			}else {
				doNothing(e);
			}
		}); 

		function doNothing (e){
			e.preventDefault();
			e.stopPropagation();
		}

		function isDraggedItemIsFile(e) {
			// handle FF
			if (e.originalEvent.dataTransfer.files.length == 0) {
				return false;
			}
			// handle Chrome
			if (e.originalEvent.dataTransfer.items) {
				if (typeof (e.originalEvent.dataTransfer.items[0].webkitGetAsEntry) == "function") {
					for (var i=0; i<e.originalEvent.dataTransfer.items.length; i++){
						if (e.originalEvent.dataTransfer.items[i].webkitGetAsEntry().isFile == false) {
							return e.originalEvent.dataTransfer.items[i].webkitGetAsEntry().isFile;
						}
					}
				} else if (typeof (e.originalEvent.dataTransfer.items[0].getAsEntry) == "function") {
					return e.originalEvent.dataTransfer.items[0].getAsEntry().isFile;
				}
			}
			return true;
		};
	}
	
	function filedelete(){
		var files = $(".name input[type='checkbox']:checked");
		var fileMaxCnt = $("#upCnt").val();
		if (files == null || files.length == 0) {
			alert("삭제할 파일을 선택해주세요.");
			return;
		} 

		var key;
		for( var i=0; i<files.length; i++ ){
			key = files[i].value;
			file_manager.remove( key );
			$("#file"+key).remove();
			changeFileEmptyUI(file_manager);
			changeExtraFileCountUI(file_manager , fileMaxCnt);
		}
	}
	function chkword(obj, maxByte) {
		
		var strValue = obj.value;
		var strLen = strValue.length;
		var totalByte = 0;
		var len = 0;
		var oneChar = "";
		var str2 = "";

		for (var i = 0; i < strLen; i++) {
			oneChar = strValue.charAt(i);
			if (escape(oneChar).length > 4) {
				totalByte += 2;
			} else {
				totalByte++;
			}

			// 입력한 문자 길이보다 넘치면 잘라내기 위해 저장
			if (totalByte <= maxByte) {
				len = i + 1;
			}
		}

		// 넘어가는 글자는 자른다.
		if (totalByte > maxByte) {
			alert(maxByte + "자를 초과 입력 할 수 없습니다.");
			str2 = strValue.substr(0, len);
			obj.value = str2;
			chkword(obj, 4000);
		}
	}

	function displayExt() {
		var btnElement = document.getElementById("extViewBtn");
		var txtElement = document.getElementById("extView");

		if(txtElement.style.display=='none'){
			txtElement.style.display = 'block';
			btnElement.innerText = '확장자 숨기기';
		}else{
			txtElement.style.display = 'none';
			btnElement.innerText = '확장자 보기';
		}
	}

	function chgTextareaWdLength(obj, maxLength, param) {
		var textLength = obj.value.length;
		var id = obj.id;
		if(textLength > maxLength){
			alert(param+"을 " + maxLength + "자 이하로 입력하여 주세요.\n" + maxLength + "자가 초과된 글자 수는 자동으로 삭제됩니다.");
			obj.value = obj.value.substring(0,maxLength);
		}
		if(id == "title"){
			$("#title-use-legnth").html(obj.value.length);
		}else{
			$("#comment-use-legnth").html(obj.value.length);
		}
	}

	function checkApproval() {
		// 자가결재 클릭 시 
		$("#selfApproval").click(function(){ 
			if( $("#selfApproval").is(":checked")) {
				$("#afterApproval").attr("checked",false);
				$('.approvalSection').hide();
			} else {
				if(siteCode == 'mma'){
					$("#afterApproval").attr("checked",true);
					$('.approvalSection').show();
				}
			}
		});
		
		// 사후결재 클릭 시 
		$("#afterApproval").click(function(){
			if( $("#afterApproval").is(":checked")) {
				$("#selfApproval").attr("checked",false);
				$('.approvalSection').show();
			}
		});
	}
</script>
</head>
<body>
<input type="hidden" name="selfAppYn" id="selfAppYn" value="${approvalPolicy.self_app_yn}"/>
<input type="hidden" name="afterAppYn" id="afterAppYn" value="${approvalPolicy.after_app_yn}"/>

<div class="rightArea">
<form id="lform" name="lform" method="post" onSubmit="return false;">
<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
<input name="name" id="name" type="hidden" value=""/>
<input name="approverArray" id="approverArray" type="hidden" value=""/>
<input name="totalSize" id="totalSize" type="hidden" value=""/>
<input type="hidden" name="jsonfileList" id="jsonfileList" value=""/>
<input type="hidden" name="jsonLastfileList" id="jsonLastfileList" value=""/>
<input type="hidden" name="titleSizeMin" id="titleSizeMin" value="${(titleSizeMin ne '' and titleSizeMin ne null and titleSizeMin ne 0) ? titleSizeMin:5}"/>
<input type="hidden" name="titleSizeMax" id="titleSizeMax" value="${(titleSizeMax ne '' and titleSizeMax ne null and titleSizeMax ne 0) ? titleSizeMax:50}"/>
<input type="hidden" name="titleUseYn" id="titleUseYn" value="${titleUseYn}"/>
<input type="hidden" name="upCnt" id="upCnt" value="${upCnt}"/>

<div class="topWarp">
	<div class="titleBox">
		<h3 class="f_left text_bold">세션만료시간 :</h3><h3 class="f_left text_bold" id="remainSessTime"></h3>
		<h3 class="f_left text_bold">자료전송</h3>
		<p class="breadCrumbs">자료송수신 > 자료전송</p>
	</div>
</div>
<div class="conWrap sendform">
	<h3>
		<c:if test="${networkPosition eq 'I' }">${OUTER}</c:if>
		<c:if test="${networkPosition eq 'O' }">${INNER}</c:if>
		<spring:message code="data.left.data.send.${networkPosition}" />
	</h3>
	<div class="conBox">
		<c:if test="${isApprovalUse}">
		<div class="optionArea">
			<span class="optionTitle">결재정보</span>
			<div class="optionArea_rightBox f_right">
				<div class="approvalInfo">
					<p class="approvalSection">
						<c:if test="${ ! isValidApproval }">
							<span style="padding:4px 0px;"><spring:message code="data.file.sendForm.script.invalid.approval.state"/></span>
						</c:if>
						<c:if test="${ isValidApproval }">
							<span class="mg_l5" style="margin-right:10px;">
								<c:choose>
									<c:when test="${ approvalLineLevel == 0 }">
										<span class="text_bold pd_t5 pd_b5">결재선 정보를 찾을 수 없습니다. 관리자에게 문의하세요.</span>
									</c:when>
									<c:when test="${ approvalLineLevel == 1 }">
										<span class="text_bold">결재자  : </span>
										<span class="signer" id="approver1" data-count="1">결재자를 선택해주세요.</span>
									</c:when>
									<c:when test="${approvalLineInfo != null && fn:length(approvalLineInfo) > 0}">
										<c:forEach var="info" items="${approvalLineInfo }" varStatus="index">
											<span class="text_bold">${ index.count }차  : </span>
											<span class="signer" id="approver${info.appLineLevel }" data-count="${index.count }">(미선택)</span>
										</c:forEach>
									</c:when>
								</c:choose>
							</span>
							<c:if test="${ approvalLineLevel > 0 }">
								<button type="button" class="btn_small darkGrey" id="find_approver_btn" name="find_approver_btn" onclick='app_manager.openApprovalPopup("<c:url value="/data/file/approvalPopup.lin" />");'>${customfunc:getMessage('data.file.sendForm.approval.select.button.txt')}</button>
							</c:if>
						</c:if>
					</p>
					<c:if test="${approvalPolicy.self_app_yn eq 'Y'}">
						<label for="selfApproval">자가결재</label>
						<input type="checkbox" name="selfApproval" id="selfApproval" style="height:20px"/>
					</c:if>
					<c:if test="${approvalPolicy.after_app_yn eq 'Y'}">
						<label for="afterApproval" class="mg_l10">사후결재</label>
						<input type="checkbox" name="afterApproval" id="afterApproval" style="height:20px" checked/>
					</c:if>
				</div>
			</div>
		</div>
		</c:if>
		<div class="h_30">
			<button type="button" class="btn_common theme f_left h_30 w_112 mg_t20 mg_l15" onclick="clickInputFile( file_manager, '${upCnt}')"><img class="btn_icon" alt="파일추가아이콘" src="/Images/icon/icon_file_01.png"/><span>파일추가</span></button>
			<button type="button" class="btn_common theme f_left h_30 w_112 mg_t20 mg_l15" onclick="filedelete()"><img class="btn_icon" alt="파일삭제아이콘" src="/Images/icon/icon_file_02.png"/><span>파일삭제</span></button>
			<button type="button" class="btn_common theme f_right h_50 w_112 mg_t10 mg_b10 mg_r10" id="send_button" onclick="fileupload('web');"><span class="text"></span><img class="loading_img" alt="자료전송로딩바" src="/Images/fileUpload/loading.gif"></button>
		</div>
		<div class="table_area_style02">
			<table cellspacing="0" cellpadding="0" summary="권한명" style="table-layout : fixed" class="">
			<caption>확장자 전송 정책</caption>
				<colgroup>
					<col style="width:100%;"/>
				</colgroup>
				<thead>
					<tr style="border-top:1px solid #ccc">
						<td>
							<label for="title">${customfunc:getMessage('data.file.sendForm.content.title')}</label>
							<input type="text" class="text_input max mg_l30 korean_ime_mode" name="title" id="title" oninput="chgTextareaWdLength(this,'${(titleSizeMax ne '' and titleSizeMax ne null and titleSizeMax ne 0) ? titleSizeMax:50}','제목')"/> 
							<div id="comment-remain-word" class="mg_l5 mg_b5"><span id="title-use-legnth">0</span>/<span>${(titleSizeMax ne '' and titleSizeMax ne null and titleSizeMax ne 0) ? titleSizeMax:50}</span> 자</div><br>
							<span class="text_input max mg_l70" style="color: red;font-size:11px;line-height:20px;">
							<c:if test="${titleUseYn eq 'N'}">
							※ 미입력시 파일명으로 자동입력 전송됩니다. (입력시 ${(titleSizeMin ne '' and titleSizeMin ne null and titleSizeMin ne 0) ? titleSizeMin:5}자 이상 ~ ${(titleSizeMax ne '' and titleSizeMax ne null and titleSizeMax ne 0) ? titleSizeMax:50}자 이하로 입력하세요.)
							</c:if>
							<c:if test="${titleUseYn eq 'Y'}">
							※ (필수) ${(titleSizeMin ne '' and titleSizeMin ne null and titleSizeMin ne 0) ? titleSizeMin:5}자 이상 ~ ${(titleSizeMax ne '' and titleSizeMax ne null and titleSizeMax ne 0) ? titleSizeMax:50}자 이하로 입력하세요.
							</c:if>
							</span><br><br>
							<label for="comment" class="item-align-middel">${customfunc:getMessage('data.file.sendForm.content.comment')}</label>
							<textarea class="text_input max mg_l30 item-align-middel korean_ime_mode" name="comment" id="comment" oninput="chgTextareaWdLength(this,200,'${customfunc:getMessage('data.file.sendForm.content.comment')}')"></textarea>
							<div id="comment-remain-word" class="mg_l5 mg_b5"><span id="comment-use-legnth">0</span>/<span>200</span> 자</div>
						</td>
					</tr>
					<c:if test="${not empty uiAllowExtension or (not empty uiApprovalExtension and filePolicy.exts_ap_yn eq 'Y')}">
					<tr>
						<td class= "<c:if test='${userAgent eq true}'>innorixExt</c:if>" >
							<button type="button" id="extViewBtn" class="btn_small" onclick="displayExt();"><span>확장자 보기</span></button><br><br>
							<div id="extView" style="display: none;">
								<c:if test="${not empty uiAllowExtension}">
									<c:choose>
										<c:when test="${isFileExtCheck}">
											전송 가능 확장자 : ${uiAllowExtension}
										</c:when>
										<c:otherwise>
											전송 불가 확장자 :${uiAllowExtension}
										</c:otherwise>
									</c:choose>
								</c:if>
								<c:if test="${!isApprovalUse and filePolicy.exts_ap_yn eq 'Y' and approvalPolicy.self_app_yn ne 'Y' and filePolicy.bw_cd ne 'N'}">
									<c:if test="${not empty uiAllowExtension}">
										<br><br>
									</c:if>
										결재 확장자 : ${uiApprovalExtension}
								</c:if>
							</div>
						</td>
					</tr>
					</c:if>
				</thead>
			</table>
		</div>
		<%-- Agent용 리스트 --%>
		<div class="fileUpLoadArea file_agent">
			<div class="fileUpLoadBox top">
				<table cellspacing="0" cellpadding="0" summary="파일업로드TOP" style="table-layout : fixed">
				<caption>파일 경로,파일명,크기</caption>
					<colgroup>
						<col style="width:35%;"/>
						<col style="width:55%;"/>
						<col style="width:10%;"/>
					</colgroup>
					<thead>
						<tr>
							<th class="t_left">파일 경로</th>
							<th class="t_left Lborder">파일명</th>
							<th class="t_right Lborder">크기</th>
						</tr>
					</thead>
				</table>
			</div>
			<div class="fileUpLoadBox middle pd_t5 pd_b5" >
				<div id="noResult" class="noResult">선택된 파일이 없습니다.</div>
				<div id="waitBar" class="noResult" style="display:none;"><img src="<c:url value="/Images/common/uploading1.gif"/>"></div>
				<table id="fileInfoListTbody" cellspacing="0" cellpadding="0" summary="파일업로드TOP" style="table-layout : fixed" class="">
				<caption>폴더,이름,크기</caption>
					<colgroup>
						<col style="width:35%;"/>
						<col style="width:55%;"/>
						<col style="width:10%;"/>
					</colgroup>
					<thead>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<%-- 웹 업로드용 리스트 --%>
		<div class="fileUpLoadArea file_web">
			<div class="fileUpLoadBox top">
				<table cellspacing="0" cellpadding="0" summary="파일업로드TOP" style="table-layout : fixed">
				<caption>파일 경로,파일명,크기</caption>
					<colgroup>
						<col style="width:50%;"/>
						<col style="width:30%;"/>
						<col style="width:20%;"/>
					</colgroup>
					<thead>
						<tr>
							<th class="t_left">파일명</th>
							<th class="t_left Lborder">크기</th>
							<th class="t_left Lborder">전송률</th>
						</tr>
					</thead>
				</table>
			</div>
			<div class="fileUpLoadBox middle pd_t5 pd_b5" >
				<div id="file_uploader">
					<p class="empty">
						첨부파일을<br><span style="color:#2893d9;">마우스로 끌어</span> 넣으세요<br>
						<img src="/Images/fileUpload/upload_file.png" style="width:50px;">
					</p>
					<p class="list" style="display:none;">
					</p>
				</div>
			</div>
			<div class="fileUpLoadBox bottom">
				<table cellspacing="0" cellpadding="0" summary="파일업로드BOTTOM" style="table-layout : fixed; border-top: 1px solid #ddd;" class="">
				<caption>개체,폴더</caption>
					<colgroup>
						<col style="width:50%;"/>
						<col style="width:50%;"/>
					</colgroup>
					<thead>
						<tr>
							<th class="t_left">
									<span id="maxFileCount">0</span>&nbsp;
									<c:if test="${upCnt ne null}">
										/ ${upCnt} 
									</c:if>
									개체,
								<span id="maxFileSize">0.00KB</span> 첨부됨
							</th>
							<th class="t_right Lborder">
								<span>
								<c:if test="${upCnt ne null }">
									최대 파일 ${upCnt}개 첨부,
								</c:if>
								 개당 ${customfunc:BigFileSizeFormat(perFileSize) } 까지, 합계 ${customfunc:BigFileSizeFormat(perOnceFileSize) } 까지 첨부가능.</span>
								<c:if test="${ repositoryUsedInfo.volume_use_yn eq 'Y' }">
									<div id="filePolicyDesc" class="mg_t5">
										￮ 자료함 용량 : <fmt:formatNumber value="${ repositoryUsedInfo.usedVolumeSize }" pattern="#,###"/> MB / <fmt:formatNumber value="${ repositoryTotalSize }" pattern="#,###"/> MB (<fmt:formatNumber value="${ repositoryUsedInfo.usedVolumeSize / repositoryTotalSize }" pattern="#,###%"/> 사용중)<br>
										<input type="hidden" id="repositoryUsedRatio" value="${ repositoryUsedInfo.usedVolumeSize / repositoryTotalSize }"/>
										<c:if test="${repositoryUsedInfo.start_date != null }">
											￮ 기간 : <c:out value="${repositoryUsedInfo.start_date }" /> ~ <c:out value="${repositoryUsedInfo.end_date }" />
										</c:if>
									</div>
								</c:if>
							</th>
						</tr>
					</thead>
				</table>
			</div>
		</div>
		<%-- 이노릭스 업로드용 리스트 --%>
		<div class="fileUpLoadArea file_innorix">
			<div id="innorix_component" style="max-width:100%; border: 1px solid #97b4cc; width:99.937%; overflow:hidden; height:260px; display: block;"></div>
			<div class="btn_area_left mg_t10 mg_b10 mg_l10">
				<table class="button_table" style="margin-right: 10px;">
					<tr>
						<td class="h_30 w_112">
							<button type="button" class="btn_common theme" onclick="File.OpenFileDialog();"><img class="btn_icon" alt="파일추가아이콘" src="/Images/icon/icon_file_01.png"/><span>파일추가</span></button>
						</td>
						<td rowspan="3" class="h_100 w_112">
							<button type="button" style="height: 70px;" class="btn_common theme" id="innorix_send_button" onclick="fileupload('innorix')"><span class="text"></span><img class="loading_img" alt="자료전송로딩바" src="/Images/fileUpload/loading.gif"></button>
						</td>
					</tr>
					<tr>
						<td class="h_30">
							<button type="button" class="btn_common theme" onclick="File.RemoveSelectedItems();"><img class="btn_icon" alt="파일삭제아이콘" src="/Images/icon/icon_file_02.png"/><span>파일삭제</span></button>
						</td>
					</tr>
				</table>
				<div class="fileUpLoadBox bottom">
					<p class="notice">
						<div id="restrictNotice"></div>
						<p class="fileNoticeArea">
							<c:if test="${upCnt ne null }">
								￮ 최대 파일 ${upCnt}개 첨부 가능<br/>
							</c:if>
							 ￮ 개당 ${customfunc:BigFileSizeFormat(perFileSize) } 까지, 합계 ${customfunc:BigFileSizeFormat(perOnceFileSize) } 까지 첨부가능.
						</p>
						<c:forEach var="notice" items="${sendNotice}">
							<p>${notice}</p>
						</c:forEach>
					</p>
				</div>
			</div>
		</div>
		<div class="btn_area_left mg_t10 mg_b10 mg_l10 file_web">
			<table class="button_table" style="width: 100%; overflow-wrap: anywhere;">
				<tr>
					<td rowspan="6" class="notice">
						<div id="restrictNotice"></div>
						<c:forEach var="notice" items="${sendNotice}">
							<p style="font-size: 16px;">${notice}</p>
						</c:forEach>
					</td>
				</tr>
			</table>
		</div>
</div>
</div>
</form>
</div>
</body>
</html>
