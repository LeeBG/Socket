<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>

<!--  fancytree -->
<link rel="stylesheet" type="text/css" href="<c:url value="/css/ui.fancytree.css"/>">
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.js"/>"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.filter.js"/>"></script>

<script type="text/javascript">
	$(function() {
		//기본트리생성\
		$("#tree").fancytree({
			autoScroll : true,
			checkbox : false,
			selectMode : 3,
			quicksearch : true,
			source : {
				url : "<c:url value="/hr/dept/deptTreeRoot.lin" />?mgt_yn=N"
			},
			extensions : ["filter"],
			filter: {
				autoApply: true,
				counter: false,
				mode: "dimm"	//dimm
			},
			lazyLoad : function(event, data) {
				var node = data.node;
				data.result = {
					url : getSubTreeUrl("dept", node),
					data : {
						mode : "children",
						parent : node.key
					},
					// IE에서 리로드안되서 true에서 false로 변경
					cache : false
				};
			},
			loadChildren : function(event, data) {
				data.node.visit(function(subNode) {
					if ( subNode.isUndefined() && subNode.isExpanded() ) {
						var node = subNode;
						var data_seq = node.data.dept_seq;
						subNode.load();
					}
				});
			},
			activate : function(event, data) {
				<c:out value="${param.activeMethod }" ></c:out>
			}
		});
		//fancytree end
		
		<c:if test="${ not empty param.treeHeight }">
			$(".treeBox").height("${param.treeHeight}");
		</c:if>

		addSearchEvent();
	});

	function getSubTreeUrl(type, node) {
		if( type == 'dept' )
			return "<c:url value="/hr/dept/deptTreeSubGroup.lin"/>?mgt_yn=N&p_dept_seq=" + node.data.dept_seq;
		else 
			return "";
	}
	
	var tree_search_filter_opts = {
		autoExpand : false,
		leavesOnly: true,
		highlight: true,
		mode : 'dimm'
		//hideExpandedCounter: false,
		//hideExpanders: false,
		//nodata: false, 
	};

	var tree_search_filter_opts_enter = {
		autoExpand : true,
		leavesOnly: true,
		highlight: true,
		mode : 'hide'
		//hideExpandedCounter: false,
		//hideExpanders: false,
		//nodata: false, 
	};
	
	function addSearchEvent() {
		$("#search").on("keypress", function (e) {
		    if (e.keyCode == 13) {
		        // bad code!
		    	$("button#btnResetSearch").click();
		    }
		});
		
		//검색 버튼클릭
		$("button#btnResetSearch").click(function(e) {
			match = $("input[name=search]").val();
			var tree = $.ui.fancytree.getTree();
			if ($.trim(match) === "") {
				tree.clearFilter();
				return;
			}
			
			// Pass a string to perform case insensitive matching
			n = tree.filterBranches.call(tree, match, tree_search_filter_opts_enter);
		});
	}
</script>
<style>
.conBox {
  overflow:visible;
}
</style>

			<div class="outBox">
				<c:if test="${param.inputInvisible ne 'Y' }">
					<input type="hidden" id="dept_nm" name="dept_nm" /> 
					<input type="hidden" id="dept_seq" name="dept_seq" />
				</c:if>
				<div class="conWrap">
					<h3>부서 목록</h3>
					<div class="conBox">
						<div class="topCon t_center pd_t10 pd_b10 Bborder">
							<c:choose>
								<c:when test="${param.section eq 'approval' }">
									<input type="text" name="search" id="search" class="text_input long" placeholder="부서이름" onkeyup="onlySizeFillter(this,15)"/>
									<button type="button" id="btnResetSearch" class="btn_common theme" >검색</button>
									<button type="button" id="btnAllApproval" class="btn_common theme" >결재자 전체보기</button>
								</c:when>
								<c:when test="${param.section eq 'dept' }">
									<input type="text" name="search" id="search" class="text_input max" placeholder="부서이름"/>
									<button type="button" id="btnResetSearch" class="btn_common theme" >검색</button>
									<c:if test="${auth_cd != 4}">
										<br>
										<button type="button" class="btn_common theme" id="dept_add" onclick="insert()">부서 추가</button>
										<button type="button" class="btn_common theme" id="dept_del" onclick="deptdel()">부서 삭제</button>
									</c:if>
								</c:when>
							</c:choose>
						</div>
						<div id="tree" class="treeBox pd_t10 mg_b10"></div>
					</div>
				</div>
			</div>


