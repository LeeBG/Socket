<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>

<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<!--  fancytree -->
<link rel="stylesheet" type="text/css" href="<c:url value="/css/ui.fancytree.css"/>">
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.js"/>"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.filter.js"/>"></script>

<script type="text/javascript">
	$(function(){
		//기본트리생성
		$("#tree").fancytree({
			autoScroll: true,
			checkbox: false,
			selectMode: 1,  
			quicksearch: true,
			source: {
				url: "<c:url value="/hr/user/userTreeRootGroup.lin" />?mgt_yn=N&dept_seq=${customfunc:cacheString('rootDeptSeq')}"
			},
			extensions: ["filter"],
			filter: {
				autoApply: true,
				mode: "hide"	//dimm
			},
			lazyLoad: function(event, data) {
				var node = data.node;
				data.result = {
					url: "<c:url value="/hr/dept/deptTreeSubGroup.lin"/>?mgt_yn=N&p_dept_seq="+node.data.dept_seq,
					data: {mode: "children", parent: node.key},
					cache: false
				};
			},
			loadChildren: function(event, data) {
				data.node.visit(function(subNode){
					if (subNode.isUndefined()) {
						var node = subNode;
						var data_seq = node.data.dept_seq;
						subNode.load();
					}
				});
			},
			activate : function(event, data) {
				var node = data.node;
				if (node.isFolder()) {
					$("input[name=search]").val(node.data.dept_nm);
					$("#dept_seq").val(node.data.dept_seq);
					$("#dept_nm").val(node.data.dept_nm);
				}
			}
		});

		var tree = $("#tree").fancytree("getTree");

	});
	//fancytree end

	function insert() {
		var form = document.lform;
		var node = $("#tree").fancytree("getActiveNode");

		if (node == null) {
			alert('상위 부서을 선택해 주세요');
			return;
		} else {
			form.action = "<c:url value="/hr/dept/deptForm.lin" />?p_dept_seq=" + node.data.dept_seq + "&depth=" + node.data.depth;
			form.submit();
		}
	}

	function isVaildCheckDept(){
		if(empty($("#dept_seq").val())){
			alert("<spring:message code="vaild.message.model.deptManagement.dept_seq" />");
			return true;
		}
		if(empty($("#dept_nm").val())){
			alert("<spring:message code="vaild.message.model.deptManagement.dept_nm" />");
			return true;
		}
		return false;
	}
	
	function closePop(){
		window.close();
	}
	
	function sendParent() {
		if(isVaildCheckDept()){
			return false;
		}
		
		if (confirm($("#dept_nm").val()+" 부서로 선택 하시겠습니까?")) {
			var dept_seq = $('#dept_seq').val();
			var dept_nm = $('#dept_nm').val();
			opener.setChildValue(dept_seq, dept_nm);
			window.close();
		}else{
			alert("취소 되었습니다.");
			return false;
		}
	}

</script>
</head>
<body>
	<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/dept/findDeptPop.lin" />">
		<input type="hidden" id="dept_seq" name="dept_seq" value="" />
		<input type="hidden" id="dept_nm" name="dept_nm" value="" />
		<div>
			<div class="">
				<div class="conWrap">
				<h3>부서 선택</h3>
					<div class="conBox">
						<div class="topCon t_center pd_t10 pd_b10 Bborder">
							<input type="text" name="search"  class="text_input max" placeholder="아래 트리에서 선택해 주세요." readonly="readonly" />
						</div>
				<div id="tree" class="treeBox pd_t10 mg_b10" style="height:500px;"> 	</div>						
					</div>
				</div>
			</div>
		</div>
		<div class="btn_area_center mg_t10 mg_b10">
		<c:if test="${auth_cd != 4}">
			<button type="button" class="btn_common theme mg_l5" onclick="sendParent();">선택</button>
			<button type="button" class="btn_common" onclick="closePop();">닫기</button>
		</c:if>
		</div>
	</form>
</body>
</html>