<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc" %>

<html>
<head>
<script type="text/javascript" src="<c:url value="/JavaScript/webtoolkit.base64.js" />"></script>
<script type="text/javascript">

	$(document).ready(function() {
		
		//loadingAction();
		
		$("#query").click(function(){
			$("#queryList").toggle();
		});
	
		$("#queryList > li > a").click(function(){
			$("#select_first").text($(this).text());
			$("#searchField").val($(this).attr('id'));
		});
	
		$('#searchValue').keypress(function(e) {
			if (e.which == 13) {
				//search();
				return false;
			}
		});
	
		$('#find_dept_nm').keypress(function(e) {
			if (e.which == 13) {
				findDept();
				return false;
			}
		});
	
		$("#find_dept_btn").click(function(e){
			$("#findDeptDiv").show();
		});
	
		$("#findDeptDivCloseBtn").click(function(e){
			findDeptDivClose();
		});
	
		$("#find_dept_div_btn").click(function(e){
			findDept();
		});
	});
	
	
	function goPage_in(page) {
		$(":input[name=page]").val(page);
		search('iForm');
	}
	
	function goPage_out(page) {
		$(":input[name=page]").val(page);
		search('oForm');
	}
	
	onload = function() {
		search('iForm');
		search('oForm');
	}
	
	function statusCode(code){
		var status;
		if(code == "110"){
			status = "보안영역 -> 비-보안영역 정책이 추가 되었습니다.";
		}else if(code == "111"){
			status = "비-보안영역 -> 보안영역 정책이 추가 되었습니다.";
		}else if(code == "112"){
			status = "보안영역 -> 비-보안영역 정책이 삭제 되었습니다.";
		}else if(code == "113"){
			status = "비-보안영역 -> 보안영역 정책이 삭제 되었습니다.";
		}else if(code == "210"){
			status = "보안영역 가상 IP 가 추가 되었습니다.";
		}else if(code == "211"){
			status = "비-보안영역 가상 IP 가 추가 되었습니다.";
		}else if(code == "212"){
			status = "보안영역 가상 IP 추가 실패 되었습니다.";
		}else if(code == "213"){
			status = "비-보안영역 가상 IP 추가 실패 되었습니다.";
		}else if(code == "214"){
			status = "보안영역 가상 IP 가 삭제 되었습니다.";
		}else if(code == "215"){
			status = "비-보안영역 가상 IP 가 삭제 되었습니다.";
		}else if(code == "216"){
			status = "보안영역 가상 IP 가 삭제가 실패 되었습니다.";
		}else if(code == "217"){
			status = "비-보안영역 가상 IP 가 삭제가 실패 되었습니다.";
		}else if(code == "400"){
			status = "동일한 가상 IP가 존재합니다.";
		}
		
		return status;
	}
	
	function insertVitualIp(formtxt){
		
		var form = document.getElementById(formtxt);
		var virtualIp = form.virtualIp.value;
		if(isValidIP(virtualIp)){
			loading();
			var requestURL = "<c:url value="/policy/virtualip/virtualIpInsert.lin" />";
			resultCheckFunc($("#"+formtxt+""), requestURL, function(response) {
				var statusWeb =  response['statusWeb'];
				alert(statusCode(statusWeb));
				search(formtxt);
				closeloading();
				
			}); 
		}else{
			alert(virtualIp+"\nIP가 잘못 입력되었습니다.");
		}
		$('#virtualIp').val('');
		$('#comment').val('');
	}
	
	function search(formtxt) {
		var requestURL = "<c:url value="/policy/virtualip/virtualipList.lin" />";
		resultCheckFunc($("#"+formtxt+""), requestURL, function(response) {
			var virtualIpList = response['virtualIpList'];
			var pageList =  response['pageList'];
			var pageIndex =  response['pageIndex'];
			var pageingTotalCount =  response['pageingTotalCount'];
			
			$("#pageList").html(pageList);
			$("#pageIndex").html(pageIndex);
			$("#pageingTotalCount").html(pageingTotalCount);
			
			var virtualIpListTable = "";
			
			if(formtxt == 'iForm'){
				virtualIpListTable = $("#virtualIpList_In tbody");
				$("#virtualIpList_In tbody tr").remove();
			}else{
				virtualIpListTable = $("#virtualIpList_Out tbody");
				$("#virtualIpList_Out tbody tr").remove();
			}
			
			var virtualIp = "";
			if(virtualIpList.length > 0){
				for (var i=0; i < virtualIpList.length; i++) {
					virtualIp += '<tr>\n';
					if(formtxt == 'iForm'){
						virtualIp += '<td class="right_line t_center"><input type="checkbox" class="input_chk" name="chk_in" id="chk_in" value="'+ virtualIpList[i].vip_seq +'"/></td>\n';
					}else{
						virtualIp += '<td class="right_line t_center"><input type="checkbox" class="input_chk" name="chk_out" id="chk_in" value="'+ virtualIpList[i].vip_seq +'"/></td>\n';
					}
					virtualIp += '<td class="right_line t_center">'+virtualIpList[i].vip_eth_name+'</td>\n';
					virtualIp += '<td class="right_line t_center">'+virtualIpList[i].vip_ip+'</td>\n';
					virtualIp += '<td class="right_line t_center">'+virtualIpList[i].vip_comment+'</td>\n';
					virtualIp += '</tr>\n';
					
				}
			}else{
				virtualIp = '<tr>\n';
				virtualIp += '<td class="t_center right_line" colspan="4">결과가 없습니다.</td> \n';
				virtualIp += '</tr>\n';
			}
			
			virtualIpListTable.append(virtualIp);
			
			var page = Base64.decode(pageList);
			pageIndex = Base64.decode(pageIndex);
			
			if(formtxt == 'iForm'){
				$("#pageDiv_in").html(page + pageIndex);
				$("#total_in").html("총 " + pageingTotalCount+"건");
			}else{
				$("#pageDiv_out").html(page + pageIndex);
				$("#total_out").html("총 " + pageingTotalCount+"건");
			}
			
		});
	}
	
	function checkDelete(name,check) {
		
		var errmsg = new cls_errmsg();
		

		if (!$(":checkbox[name=" + name + "]").is(":checked")) {
			errmsg.append(null, "<spring:message code="user.addUserlist.list.script.required.delete" />");
		}

		if (errmsg.haserror) {
			errmsg.show();
			return;
		}

		if (confirm("<spring:message code="user.addUserlist.list.script.confirm.delete" />")) {
			var requestURL = "<c:url value="/policy/virtualip/virtualIpDelete.lin" />";
			loading();
			if(check == 'in'){
				
				resultCheckFunc($("#iForm"), requestURL, function(response) {
					var statusCount =  response['statusCount'];
					alert(statusCount +"개 삭제되었습니다.");
					search('iForm');
					closeloading();
				});
			}else{
				resultCheckFunc($("#oForm"), requestURL, function(response) {
					var statusCount =  response['statusCount'];
					alert(statusCount +"개 삭제되었습니다.");
					search('oForm');
					closeloading();
				});
			}
			
		} 
	}
	
	function loading() {
		var loading_back = "<div id='loading_back' style='position:absolute; width:100%; height:150%; z-index:10; background-color:#000; margin-top:-500px;'></div>"; 
		$("body").append(loading_back);
		$("#loading_back").fadeTo(0, 0.6);
		$('.loading_cus').show();
	}
	
	function closeloading() {
		$("#loading_back").remove();
		$('.loading_cus').hide();
	}
	
	
	
	
</script>
</head>
<body>

<div id="content">
	<c:choose>
		<c:when test="${empty popup}">
			<div id="contentPageHeader">
				<div id="contentPageTitle">
					<h3>정책 관리</h3>
				</div>
				<div id="contentPageLocation">
					<ul>
						<li class="Lfirst"><span>자료전송</span></li>
						<li class="Llast"><span>가상 IP관리</span></li>
					</ul>
				</div>
		</div>
		</c:when>
	</c:choose>
	<div class="loading_cus" style="margin:0 auto;">
		<img src="<c:url value="../../../Images/icon/loading2.gif"/>" alt="로딩중" title="로딩중" width=50 height=50 />
	</div>
	
	<div class="conLeftBox f_left pd_r10" style="width:48%;border-right:1px solid #ddd; min-height:650px;">
	<fieldset>
	<legend>보안영역 설정</legend>
	
	<form name="iForm" id="iForm" method="post" action="" onSubmit="return false;">
	
	<input id="page" name="page" type="hidden" value="${virtualIpForm.currentPage}"/>
	<input id="pagingtotalCount" name="pagingtotalCount" type="hidden"/>
	<input id="vip_gubun" name="vip_gubun"  value ="IN" type="hidden"/>
	

		<h4 class="subTitle mg_t10">보안영역</h4>
		<div class="table_area_style10 box_type05 mg_t20">
			<table cellspacing="0" cellpadding="0" summary="가상IP추가 테이블입니다.">
			<caption>가상IP, 설명, 추가</caption>
				<colgroup>
					<col style="width:20%;" />
					<col style="width:60%;" />
					<col style="width:20%;" />
				</colgroup>
				<tbody>
					<tr>
						<th class="t_left">가상 IP</th>
						<td>
							<input type="text" class="text_input" name="virtualIp" id ="virtualIp" placeholder="xxx.xxx.xxx.xxx"/>
						</td>
						<td rowspan="2" class="t_center">
							<button type="button" class="btn_add_st02 va_middle" onclick="insertVitualIp('iForm')">
								<span class="ir_desc">추가</span>
							</button>
						</td>
					</tr>
					<tr>
						<th class="t_left">설명</th>
						<td>
							<input type="text" class="text_input" name="comment" id="comment" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="table_area_style01">
			<div class="top_con2 mg_t20">
				<button type="button" class="btn_i_del_st02 va_middle" onclick="checkDelete('chk_in','in')">
					<span class="ir_desc">삭제</span>
				</button>
			</div>
			<table id = "virtualIpList_In" cellspacing="0" cellpadding="0" summary="보안영역 가상IP 테이블입니다." style="table-layout : fixed">
			<caption>삭제, 인터페이스명, 가상IP, 설명</caption>
				<colgroup>
					<col style="width:10%;" />
					<col style="width:30%;" />
					<col style="width:30%;" />
					<col style="width:30%;" />
				</colgroup>
				<thead>
					<tr>
						<th class="right_line t_center"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk_in');"/></th>
						<th class="right_line">인터페이스명</th>
						<th class="right_line">가상IP</th>
						<th class="right_line">설명</th>
					</tr>
				</thead>
				
				<tbody>
				
				</tbody>
				<tfoot>
					<tr>
						<td colspan="11" class="td_last">
							<span id ="total_in" class="text_list_number"></span>
							<div id="pageDiv_in" class="pagenate t_center">
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
	</form>
	</fieldset>
	</div>
	<!-- 비-보안영역  -->
	<div class="conRightBox f_right" style="width:49%; ">
	<fieldset>
	<legend>비-보안영역 설정</legend>
	<form name="oForm" id="oForm" method="post" action="" onSubmit="return false;">
	
	<input id="page" name="page" type="hidden" value="${virtualIpForm.currentPage}"/>
	<input id="pagingtotalCount" name="pagingtotalCount" type="hidden"/>
	<input id="vip_gubun" name="vip_gubun"  value ="OUT" type="hidden"/>

		<h4 class="subTitle mg_t10">비-보안영역</h4>
		<div class="table_area_style10 box_type05 mg_t20">
			<table cellspacing="0" cellpadding="0" summary="가상IP추가 테이블입니다.">
			<caption>가상IP, 설명, 추가</caption>
				<colgroup>
					<col style="width:20%;" />
					<col style="width:60%;" />
					<col style="width:20%;" />
				</colgroup>
				<tbody>
					<tr>
						<th class="t_left">가상 IP</th>
						<td>
							<input type="text" class="text_input" name="virtualIp" id ="virtualIp" placeholder="xxx.xxx.xxx.xxx"/>
						</td>
						<td rowspan="2" class="t_center">
							<button type="button" class="btn_add_st02 va_middle" onclick="insertVitualIp('oForm')">
								<span class="ir_desc">추가</span>
							</button>
						</td>
					</tr>
					<tr>
						<th class="t_left">설명</th>
						<td>
							<input type="text" class="text_input" name="comment" id="comment" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="table_area_style01">
			<div class="top_con2 mg_t20">
				<button type="button" class="btn_i_del_st02 va_middle" onclick="checkDelete('chk_out','out')" >
					<span class="ir_desc">삭제</span>
				</button>
			</div>
			<table id = "virtualIpList_Out" cellspacing="0" cellpadding="0" summary="비-보안영역 가상IP 테이블입니다." style="table-layout : fixed">
			<caption>삭제, 인터페이스명, 가상IP, 설명</caption>
				<colgroup>
					<col style="width:10%;" />
					<col style="width:30%;" />
					<col style="width:30%;" />
					<col style="width:30%;" />
				</colgroup>
				<thead>
					<tr>
						<th class="right_line t_center"><input type="checkbox" class="input_chk" onclick="togchk(this, 'chk_out');"/></th>
						<th class="right_line">인터페이스명</th>
						<th class="right_line">가상IP</th>
						<th class="right_line">설명</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="11" class="td_last">
							<span id ="total_out" class="text_list_number"></span>
							<div id="pageDiv_out" class="pagenate t_center">
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
	</form>
	</fieldset>
	</div>
</div>
</body>
</html>
