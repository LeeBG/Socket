<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<c:set var="INNER" value="${customfunc:codeDes('NP_CD', 'I')}" />
<c:set var="OUTER" value="${customfunc:codeDes('NP_CD', 'O')}" />
<c:set var="env_cookie_consist_day_size_min" value="${customfunc:miniMaxInteger('env_cookie_consist_day_size_min')}" />
<c:set var="env_cookie_consist_day_size_max" value="${customfunc:miniMaxInteger('env_cookie_consist_day_size_max')}" />
<html>
<head>
<c:set var="systemCode" value="${sessionScope.loginUser.system_cd}" /><!-- T, S -->
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="CUD_CD_D" value="${customfunc:codeString('CUD_CD', 'DELETE')}" />

<c:choose>
	<c:when test="${systemCode eq 'T' }">
		<c:set var="adminTitie" value="관리자PC 자료전송" />
	</c:when>
	<c:otherwise>
		<c:set var="adminTitie" value="관리자PC 스트림 연계" />
	</c:otherwise>
</c:choose>
<script type="text/javascript" src="<c:url value="/JavaScript/module/trs.popup.js" />?v=20181119"></script>
<script type="text/javascript">
var env_cookie_consist_day_size_min = "${env_cookie_consist_day_size_min}";
var env_cookie_consist_day_size_max = "${env_cookie_consist_day_size_max}";
var env_cookie_consist_day = "";

	$(document).ready(function() {
		var user_in_theme_div = '${envForm.user_in_theme_div}';
		var user_out_theme_div = '${envForm.user_out_theme_div}';
		var admin_theme_div = '${envForm.admin_theme_div}';
		$('input[type=radio]').each(function(){
			var nm = $(this).attr("name");
			if(nm == 'user_in_theme_div'){
				if($(this).val() == user_in_theme_div){
					$(this).attr("checked", true);
				}else{
					$(this).attr("checked", false);
				}
			}
			if(nm == 'user_out_theme_div'){
				if($(this).val() == user_out_theme_div){
					$(this).attr("checked", true);
				}else{
					$(this).attr("checked", false);
				}
			}
			if(nm == 'admin_theme_div'){
				if($(this).val() == admin_theme_div){
					$(this).attr("checked", true);
				}else{
					$(this).attr("checked", false);
				}
			}
		});
		/* var frm = document.forms['lform'];
		frm.user_in_theme_div.value = user_in_theme_div;
		frm.user_out_theme_div.value = user_out_theme_div;
		frm.admin_theme_div.value = admin_theme_div;
		alert(user_in_theme_div+":"+ user_out_theme_div +":"+ admin_theme_div); */
	});
	function send(){
		var frm = document.forms['lform'];
		frm.action = '/systemManagement/envManagement/envUpload.lin';
		frm.submit();
	}
	
	function reset(){
		if(confirm("모든내용이 초기화 됩니다.\n초기화 하시겠습니까?")){
			var frm = document.forms['lform'];
			frm.action = '/systemManagement/envManagement/envUpload.lin';
			frm.resetYn.value = 'Y';
			frm.submit();
		}
	}
	function save(){
		if(confirm("저장 하시겠습니까?")){
			if(isVaildCheckSetting()){
				return false;
			}
			var frm = document.forms['lform'];
			frm.action = '/systemManagement/envManagement/envUpload.lin';
			frm.submit();
		}
	}

	function isVaildCheckSetting(){
		if($("#user_in_title").val().length > 50){
			alert("${INNER} <spring:message code="vaild.message.model.env.user_in_title" />");
			return true;
		}
		if($("#user_out_title").val().length > 50){
			alert("${OUTER} <spring:message code="vaild.message.model.env.user_out_title" />");
			return true;
		}
		if($("#admin_title").val().length > 50){
			alert("<spring:message code="vaild.message.model.env.admin_title" />");
			return true;
		}
		if($("#user_in_send_notice").val().length > 300){
			alert("${INNER} <spring:message code="vaild.message.model.env.in_send_notice" />");
			return true;
		}
		if($("#user_out_send_notice").val().length > 300){
			alert("${OUTER} <spring:message code="vaild.message.model.env.out_send_notice" />");
			return true;
		}
		if($("#user_in_bf_login_notice").val().length > 100){
			alert("${INNER} <spring:message code="vaild.message.model.env.in_bf_login_notice" />");
			return true;
		}
		if($("#user_in_af_login_notice").val().length > 100){
			alert("${INNER} <spring:message code="vaild.message.model.env.in_af_login_notice" />");
			return true;
		}
		if($("#user_out_bf_login_notice").val().length > 100){
			alert("${OUTER} <spring:message code="vaild.message.model.env.out_bf_login_notice" />");
			return true;
		}
		if($("#user_out_af_login_notice").val().length > 100){
			alert("${OUTER} <spring:message code="vaild.message.model.env.out_af_login_notice" />");
			return true;
		}
		if($("#copyright").val().length > 100){
			alert("<spring:message code="vaild.message.model.env.copyright" />");
			return true;
		}
		return false;
	}

	function showPreview( id ){
		var $checkbox = $('#'+id+'_check');
		var $textarea = $('#user_'+id);
		txtAreaFilter('user_' + id);
		
		if( ! $checkbox.prop('checked') ){
			alert('공지가 설정되어있지 않습니다.');
			return;
		}
		
		if( id.indexOf('_bf_') > -1 ){
			new NPPopupManager($textarea.val() , 'Y' , '' , env_cookie_consist_day);
		}else {
			new NPTimedNotificationManager($textarea.val() , 'Y' , '' , env_cookie_consist_day);
		}
	}
	
	function txtAreaFilter(id) {
		var textField = document.getElementById(id);
		textField.value = textField.value.replace(/(<([^>]+)>)/ig, "");
	}
	
	function bindEvent(){
		$('.notice_checkbox input[type="checkbox"]').change(function(event){
			var dom = event.target;
			var textarea_id = 'user_'+dom.id.replace('_check','');
			if( dom.checked ){
				$('#'+textarea_id).removeAttr('disabled');
				$('#'+textarea_id).siblings('.preview_btn').removeClass('nonevisible');
			}else{
				$('#'+textarea_id).attr('disabled','disabled');
				$('#'+textarea_id).siblings('.preview_btn').addClass('nonevisible');
			}
		});
	}
	
	$(document).ready(function() {
		checkFocusMessage($("#user_in_title"),"최대 50자까지 가능합니다.");
		checkFocusMessage($("#user_out_title"),"최대 50자까지 가능합니다.");
		checkFocusMessage($("#admin_title"),"최대 50자까지 가능합니다.");
		//checkFocusMessage($("#remote_url"),"최대 100자까지 가능합니다.");
		checkFocusMessage($("#copyright"),"최대 100자까지 가능합니다.");
		checkFocusMessage($("#cookie_consist_day"), env_cookie_consist_day_size_min +" ~ "+ env_cookie_consist_day_size_max +"일 최대 "+ env_cookie_consist_day_size_max.length +"자리까지 입력이 가능합니다.");
		
		bindEvent();
		initCommentEvent();
	});
	
	function initCommentEvent(){
		$("#select_comment").on('change', function(){
			if($("#select_comment option:eq(0)").val() == $("#select_comment option:selected").val()){
				$(".cm_area").val('');
			}else{
				$(".cm_area").val($("#select_comment option:selected").val());
			}
			chgTextareaWdLength($('.cm_area')[0],500,"${customfunc:getMessage('data.file.sendForm.content.comment')}");
		});
	}
	
	function commentSave(cud_cd, comment, seq){
		
		var params = {
			cud_cd : cud_cd,
			comment : comment,
			seq : seq
		}
		
		$.ajax({
			data : params,
			type : "POST",
			dataType : "JSON",
			url: "/env/comment.lin",
			success: function(response) {
				let comment = response['comment'];
				if(comment.length > 10){
					comment = comment.substring(0,10) + "···";
				}
				if(response['cud_cd'] == '${CUD_CD_C}'){
					$("#select_comment").append("<option class='cm_opt' id='" + response['seq'] + "' value='" + response['comment'] + "'>" + comment +"</option>");
					$("#select_comment option:last").prop("selected",true);
					alert("템플릿이 추가되었습니다.");
				}else if(response['cud_cd'] == '${CUD_CD_U}'){
					$("#select_comment option:selected").val(response['comment']);
					$("#select_comment option:selected").text(comment);
					alert("템플릿이 수정되었습니다.");
				}else if(response['cud_cd'] == '${CUD_CD_D}'){
					$("#select_comment option:selected").remove();
					$("#select_comment option:eq(0)").prop("selected",true);
					$(".cm_area").val('');
					alert("템플릿이 삭제되었습니다.");
				}
			},
			error : function(xhr, status, error) {
				if (xhr.status == 401) {
					resultSessionExpire(xhr);
				} else if (xhr.status == 200) {
					resultInterceptorError(xhr);
				} else {
					console.log("error");
				}
			},

		});
	}
	function commentEvent(cud_cd){
		
		var seq = $("#select_comment option:selected").attr("id");
		txtAreaRemoveFilter('cm_area');
		
		if(validCheckComment(cud_cd)) return;
		
		if(cud_cd == '${CUD_CD_U}'){
			if(checkDuplication()){
				if($("#select_comment option:eq(0)").val() == $("#select_comment option:selected").val()){
					if (confirm("템플릿을 추가하겠습니까?")) {
						commentSave('${CUD_CD_C}', $('.cm_area').val(), 0); // 신규입력 후 저장
					}
				}else{
					if (confirm("템플릿을 수정하겠습니까?")) {
						commentSave(cud_cd, $('.cm_area').val(), seq); // 템플릿 수정
					}
				}
			}
		}else if(cud_cd == '${CUD_CD_D}'){
			if (confirm("템플릿을 삭제하겠습니까?")) {
				commentSave(cud_cd, $('.cm_area').val(), seq); // 템플릿 삭제
			}
		}
	}
	
	function checkDuplication(){
		var res = true;
		$('.cm_opt').each(function(index){
			if($('.cm_area').val() == $('.cm_opt').eq(index).val()){
				alert("<spring:message code="valid.message.model.env.comment_duplicate" />");
				res = false;
				return;
			}
		});
		return res;
	}
	
	function validCheckComment(cud_cd){
		if($("#select_comment option:eq(0)").val() == $("#select_comment option:selected").val() && cud_cd == '${CUD_CD_D}'){
			alert("<spring:message code="valid.message.model.env.comment_check" />");
			return true;
		}
		if($('.cm_area').val() == ''){
			alert("<spring:message code="valid.message.model.env.comment_empty" />");
			return true;
		}
	}
	
	function chgTextareaWdLength(obj, maxLength, param) {
		var textLength = obj.value.length;
		if(textLength > maxLength){
			alert(param+"을 " + maxLength + "자 이하로 입력하여 주세요.\n" + maxLength + "자가 초과된 글자 수는 자동으로 삭제됩니다.");
			obj.value = obj.value.substring(0,maxLength);
		}
		
		$("#comment-use-legnth").html(obj.value.length);
	}
	
	function txtAreaRemoveFilter(id){
		var textField = document.getElementById(id);
		if(textField.value.includes("\"") || textField.value.includes("<") || textField.value.includes(">")){
			textField.value = textField.value.replaceAll("\"","");
			textField.value = textField.value.replaceAll("<","");
			textField.value = textField.value.replaceAll(">","");
			alert('<spring:message code="valid.message.model.env.comment_not_allow_remove" />');
		}
	}
	
</script>
<style type="text/css">
textarea{resize:none;}
</style>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/systemManagement/envManagement/envUpload.lin" />" enctype="multipart/form-data">
	<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
	<input id="page" name="page" type="hidden" />
	<input id="resetYn" name="resetYn" type="hidden" />
	<!-- contents -->
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">환경 설정</h2>
				<p class="breadCrumbs">시스템관리 > 환경 설정</p>
			</div>
		</div>
		<div class="conWrap viewBox">
			<h3>화면설정</h3>
			<div class="conBox">
				<div class="table_area_style02">
					<table summary="기본 설정 테이블입니다.">
					<caption>중복 로그인, 세션 유지 시간, 패스워드 복잡도</caption>
						<colgroup>
							<col style="width:18%;" />
							<col style="width:78%;" />
						</colgroup>
						<tbody>
							<tr>
								<th class="t_left">로그인 페이지 로고 등록</th>
								<td>
									<div class="logo_preview mg_b5" >
									<!-- <img src="../../Images/common/logo_s3i.gif"  class="logo_preview_img" /> -->
									<img src="${envForm.login_log_fpath }${envForm.login_log_fname }"  class="logo_preview_img" />
									</div>
									<input type="file" name="file2" id="file2" class="" />
									<p class="mg_t20">※ GIF, PNG가능(배경 투명), 파일명 영문 or 숫자</p>
								</td>
							</tr>
							<tr>
								<th class="t_left">메뉴 로고 등록</th>
								<td>
									<div class="logo_preview mg_b5" >
									<!-- <img src="../../Images/common/logo_s3i.gif"  class="logo_preview_img" /> -->
									<img src="${envForm.log_fpath }${envForm.log_fname }"  class="logo_preview_img" />
									</div>
									<input type="file" name="file1" id="file1" class="" />
									<p class="mg_t20">※ 가로:최대120px , 세로:최대25px, GIF, PNG가능(배경 투명), 파일명 영문 or 숫자</p>
								</td>
							</tr>
							<c:if test="${comment_template_yn}">
								<tr>
									<th class="t_left">자료전송 목적 템플릿 설정</th>
									<td>
										<select id="select_comment" name="comment">
											<option selected>==== 신규 입력 ====</option>
											<c:choose>
											<c:when test="${not empty commentFormList}">
												<c:forEach items="${commentFormList}" var="commentForm">
												<option class="cm_opt" id="${commentForm.seq }" value="${commentForm.comment }">
													<c:choose>
														<c:when test="${fn:length(commentForm.comment) > 10}">
															${fn:substring(commentForm.comment,0,10)}···
														</c:when>
														<c:otherwise>
															${commentForm.comment}
														</c:otherwise>
													</c:choose>													
												</option>
												</c:forEach>
											</c:when>
											</c:choose>
										</select>
										<button type="button" class="btn_common theme" onclick="commentEvent('${CUD_CD_U}')">저장</button>
										<button type="button" class="btn_common theme" onclick="commentEvent('${CUD_CD_D}')">삭제</button>
										<br>
										<textarea id="cm_area" class="text_input max item-align-middel korean_ime_mode cm_area pd_l1" oninput="chgTextareaWdLength(this,500,'${customfunc:getMessage('data.file.sendForm.content.comment')}')"></textarea>
										<div id="comment-remain-word" class="mg_l5 mg_b5"><span id="comment-use-legnth">0</span>/<span>500</span> 자</div>
									</td> 
								</tr>
							</c:if>
							<c:choose>
								<c:when test="${systemCode eq 'T' }">
									<tr>
										<th class="t_left" rowspan="4">${INNER}PC 테마 및 문구 설정</th>
										<td>
											<span class="pd_r8">
												<label for="" class="text_bold">Title</label>
												<input type="text" id="user_in_title" name="user_in_title" onkeyup="onlySizeFillter(this,50)" class="text_input mid t_center" value="${envForm.user_in_title }" placeholder="업무망PC 자료전송"/>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											<span class="pd_r8">
												<label for="" class="text_bold">자료전송관련 안내 문구</label><br>
												<textarea id="user_in_send_notice" name="user_in_send_notice" onkeyup="onlySizeFillter(this,300)" 
														class="va_top Aborder pd_l1">${envForm.user_in_send_notice}</textarea>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											<span class="pd_r8">
												<div><label for="" class="text_bold">공지 사용 여부 및 문구</label></div>
												<div class="env_notice_div">
													<span class="notice_checkbox">
														<input type="checkbox" id="in_bf_login_notice_check" ${ envForm.user_in_bf_login_notice ne null ? 'checked' : '' }/>
														<label for="in_bf_login_notice_check">${customfunc:getMessage('login.bf.notification')}</label>
													</span>
													<button class="btn_common theme preview_btn ${ envForm.user_in_bf_login_notice ne null ? '' : 'nonevisible' }" onclick="showPreview('in_bf_login_notice');">미리보기</button><br>
													<textarea id="user_in_bf_login_notice" name="user_in_bf_login_notice" onkeyup="onlySizeFillter(this,100)" class="Aborder pd_l1" ${ envForm.user_in_bf_login_notice ne null ? '' : 'disabled' }>${envForm.user_in_bf_login_notice}</textarea>
												</div>
												<div class="env_notice_div">
													<span class="notice_checkbox">
														<input type="checkbox" id="in_af_login_notice_check" ${ envForm.user_in_af_login_notice ne null ? 'checked' : '' }>
														<label for="in_af_login_notice_check">로그인 후 공지</label>
													</span>
													<button class="btn_common theme preview_btn ${ envForm.user_in_af_login_notice ne null ? '' : 'nonevisible' }" onclick="showPreview('in_af_login_notice');">미리보기</button><br>
													<textarea id="user_in_af_login_notice" name="user_in_af_login_notice" onkeyup="onlySizeFillter(this,100)" class="Aborder pd_l1" ${ envForm.user_in_af_login_notice ne null ? '' : 'disabled' }>${envForm.user_in_af_login_notice}</textarea>
												</div>
											</span>
										</td>
									</tr>
									<tr>
										<td class="themeSetBox">
											<ul>
												<li class="first-item">
													<input type="radio" id="user_in_theme_div1" name="user_in_theme_div" value="1" />
													<label for="">Blue</label><br/>
													<img src="../../Images/contents/type_blue.gif" alt="blue" title="blue" class="mg_t5"/>
												</li>
												<li>
													<input type="radio" id="user_in_theme_div2" name="user_in_theme_div" value="2" />
													<label for="">Light blue</label><br/>
													<img src="../../Images/contents/type_lightBlue.gif" alt="lightBlue" title="lightBlue" class="mg_t5"/>
												</li>
												<li>
													<input type="radio" id="user_in_theme_div3" name="user_in_theme_div" value="3"/>
													<label for="">Red</label><br/>
													<img src="../../Images/contents/type_red.gif" alt="red" title="red" class="mg_t5"/>
												</li>
												<li>
													<input type="radio" id="user_in_theme_div4" name="user_in_theme_div" value="4"/> 
													<label for="">Orange</label><br/>
													<img src="../../Images/contents/type_orange.gif" alt="orange" title="orange" class="mg_t5"/>
												</li>
												<li>
													<input type="radio" id="user_in_theme_div5" name="user_in_theme_div" value="5"/>
													<label for="">Green</label><br/>
													<img src="../../Images/contents/type_green.gif" alt="green" title="green" class="mg_t5"/>
												</li>
												<li>
													<input type="radio" id="user_in_theme_div6" name="user_in_theme_div" value="6"/>
													<label for="">Grey</label><br/>
													<img src="../../Images/contents/type_grey.gif" alt="grey" title="grey" class="mg_t5"/>
												</li>
											</ul>
										</td>
									</tr>
									<tr>
										<th class="t_left" rowspan="4">${OUTER}PC 테마 및 문구 설정</th>
										<td>
											<span class="pd_r8">
												<label for="" class="text_bold">Title</label>
												<input type="text" id="user_out_title" name="user_out_title" onkeyup="onlySizeFillter(this,50)" class="text_input mid t_center" value="${envForm.user_out_title }" placeholder="인터넷망PC 자료전송"/>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											<span class="pd_r8">
												<label for="" class="text_bold">자료전송관련 안내 문구</label><br>
												<textarea id="user_out_send_notice" name="user_out_send_notice" onkeyup="onlySizeFillter(this,300)" 
														class="va_top Aborder pd_l1">${envForm.user_out_send_notice}</textarea>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											<span class="pd_r8">
												<div><label for="" class="text_bold">공지 사용 여부 및 문구</label></div>
												<div class="env_notice_div">
													<span class="notice_checkbox">
														<input type="checkbox" id="out_bf_login_notice_check" ${ envForm.user_out_bf_login_notice ne null ? 'checked' : '' }/>
														<label for="out_bf_login_notice_check">${customfunc:getMessage('login.bf.notification')}</label>
													</span>
													<button class="btn_common theme preview_btn ${ envForm.user_out_bf_login_notice ne null ? '' : 'nonevisible' }" onclick="showPreview('out_bf_login_notice');">미리보기</button><br>
													<textarea id="user_out_bf_login_notice" name="user_out_bf_login_notice" onkeyup="onlySizeFillter(this,100)" class="Aborder pd_l1" ${ envForm.user_out_bf_login_notice ne null ? '' : 'disabled' }>${envForm.user_out_bf_login_notice}</textarea>
												</div>
												<div class="env_notice_div">
													<span class="notice_checkbox">
														<input type="checkbox" id="out_af_login_notice_check" ${ envForm.user_out_af_login_notice ne null ? 'checked' : '' }>
														<label for="out_af_login_notice_check">로그인 후 공지</label>
													</span>
													<button class="btn_common theme preview_btn ${ envForm.user_out_af_login_notice ne null ? '' : 'nonevisible' }" onclick="showPreview('out_af_login_notice');">미리보기</button><br>
													<textarea id="user_out_af_login_notice" name="user_out_af_login_notice" onkeyup="onlySizeFillter(this,100)" class="Aborder pd_l1" ${ envForm.user_out_af_login_notice ne null ? '' : 'disabled' }>${envForm.user_out_af_login_notice}</textarea>
												</div>
											</span>
										</td>
									</tr>
									<tr>
										<td class="themeSetBox">
											<ul>
												<li class="first-item">
													<input type="radio" id="user_out_theme_div1" name="user_out_theme_div" value="1" />
													<label for="">Blue</label><br/>
													<img src="../../Images/contents/type_blue.gif" alt="blue" title="blue" class="mg_t5"/>
												</li>
												<li>
													<input type="radio" id="user_out_theme_div2" name="user_out_theme_div" value="2" />
													<label for="">Light blue</label><br/>
													<img src="../../Images/contents/type_lightBlue.gif" alt="lightBlue" title="lightBlue" class="mg_t5"/>
												</li>
												<li>
													<input type="radio" id="user_out_theme_div3" name="user_out_theme_div" value="3" />
													<label for="">Red</label><br/>
													<img src="../../Images/contents/type_red.gif" alt="red" title="red" class="mg_t5"/>
												</li>
												<li>
													<input type="radio" id="user_out_theme_div4" name="user_out_theme_div" value="4" /> 
													<label for="">Orange</label><br/>
													<img src="../../Images/contents/type_orange.gif" alt="orange" title="orange" class="mg_t5"/>
												</li>
												<li>
													<input type="radio" id="user_out_theme_div5" name="user_out_theme_div" value="5" />
													<label for="">Green</label><br/>
													<img src="../../Images/contents/type_green.gif" alt="green" title="green" class="mg_t5"/>
												</li>
												<li>
													<input type="radio" id="user_out_theme_div6" name="user_out_theme_div" value="6" />
													<label for="">Grey</label><br/>
													<img src="../../Images/contents/type_grey.gif" alt="grey" title="grey" class="mg_t5"/>
												</li>
											</ul>
										</td>
									</tr>
								</c:when>
								<c:otherwise>
									<input type="hidden" id="user_in_title" name="user_in_title" onkeyup="onlySizeFillter(this,50)" class="text_input mid t_center" value="${envForm.user_in_title }" />
									<input type="hidden" id="user_out_title" name="user_out_title" onkeyup="onlySizeFillter(this,50)" class="text_input mid t_center" value="${envForm.user_out_title }"/>
									<input type="hidden" id="user_in_theme_div" name="user_in_theme_div" value="${envForm.user_in_theme_div}" />
									<input type="hidden" id="user_out_theme_div" name="user_out_theme_div" value="${envForm.user_out_theme_div}" />
								</c:otherwise>
							</c:choose>
							
							<tr>
								<th class="t_left" rowspan="2">관리자PC 테마 및 문구 설정</th>
								<td>
									<span class="pd_r8">
										<label for="" class="text_bold">Title</label>
										<input type="text" id="admin_title" name="admin_title" onkeyup="onlySizeFillter(this,50)" class="text_input mid t_center" value="${envForm.admin_title }" placeholder="${adminTitie}"/>
									</span>
								</td>
							</tr>
							<tr>
								<td class="themeSetBox">
									<ul>
										<li class="first-item">
											<input type="radio" id="admin_theme_div1" name="admin_theme_div" value="1" />
											<label for="">Blue</label><br/>
											<img src="../../Images/contents/type_blue.gif" alt="blue" title="blue" class="mg_t5"/>
										</li>
										<li>
											<input type="radio" id="admin_theme_div2" name="admin_theme_div" value="2" />
											<label for="">Light blue</label><br/>
											<img src="../../Images/contents/type_lightBlue.gif" alt="lightBlue" title="lightBlue" class="mg_t5"/>
										</li>
										<li>
											<input type="radio" id="admin_theme_div3" name="admin_theme_div" value="3" />
											<label for="">Red</label><br/>
											<img src="../../Images/contents/type_red.gif" alt="red" title="red" class="mg_t5"/>
										</li>
										<li>
											<input type="radio" id="admin_theme_div4" name="admin_theme_div" value="4"/> 
											<label for="">Orange</label><br/>
											<img src="../../Images/contents/type_orange.gif" alt="orange" title="orange" class="mg_t5"/>
										</li>
										<li>
											<input type="radio" id="admin_theme_div5" name="admin_theme_div" value="5"/>
											<label for="">Green</label><br/>
											<img src="../../Images/contents/type_green.gif" alt="green" title="green" class="mg_t5"/>
										</li>
										<li>
											<input type="radio" id="admin_theme_div6" name="admin_theme_div" value="6"/>
											<label for="">Grey</label><br/>
											<img src="../../Images/contents/type_grey.gif" alt="grey" title="grey" class="mg_t5"/>
										</li>
									</ul>
								</td>
							</tr>
							<%-- <tr>
								<th class="t_left">원격지원 URL</th>
								<td><input type="text" id="remote_url" name="remote_url" class="text_input long t_center" onkeyup="onlySizeFillter(this,100)" value="${envForm.remote_url }" placeholder="http://www.s3i.co.kr"/></td>
							</tr> --%>
							<tr>
								<th class="t_left">공지사항 다시 보지 않기 기간 설정</th>
								<td><input type="text" class="text_input" style="width:50px;" id="cookie_consist_day" name="cookie_consist_day" onkeyup="onlyNumBetweenFillter(this,${fn:length(env_cookie_consist_day_size_max)},${env_cookie_consist_day_size_min},${env_cookie_consist_day_size_max})" value="${envForm.cookie_consist_day }" size="10" maxlength="2" /> 일</td>
							</tr>
							<tr>
								<th class="t_left">저작권</th>
								<td><input type="text" id="copyright" name="copyright" class="text_input long t_center" onkeyup="onlySizeFillter(this,100)" value="${envForm.copyright }" placeholder="COPYRIGHT(C) S3i. ALL RIGHTS RESERVED."/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="t_center mg_t10 mg_b10">
					<button class="btn_common theme" onclick="save();">저장</button>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>