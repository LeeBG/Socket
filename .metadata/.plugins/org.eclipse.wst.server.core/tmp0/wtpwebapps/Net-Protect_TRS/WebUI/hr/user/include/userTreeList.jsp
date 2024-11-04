<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<c:set var="auth_cd" value="${sessionScope.loginUser.auth_cd}" />

<!--  fancytree -->
<link rel="stylesheet" type="text/css" href="<c:url value="/css/ui.fancytree.css"/>">
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.js"/>"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.filter.js"/>"></script>
<script type="text/javascript" src="<c:url value="/JavaScript/jquery.fancytree.table.js"/>"></script>

<script type="text/javascript">
	$(function() {
		//기본트리생성\
		$("#depttree").fancytree({
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
					url : "<c:url value="/hr/dept/deptTreeSubGroup.lin"/>?mgt_yn=N&p_dept_seq=${customfunc:cacheString('rootDeptSeq')}&use_yn=${param.useYn}",
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
				var is_mid_auth = '${param.midadmin_auth}';
				if("${auth_cd}" == 3 && is_mid_auth != 'Y') {
					var deptGroup = JSON.parse('${deptGroupList}');
					var chkGroupFlag = false;
					deptGroup.forEach(function(value, idx) {
						if(value.manage_value == data.node.data.dept_seq){
							chkGroupFlag = true;
						}
					});
 					if(!chkGroupFlag) {
						alert('권한이 없는 부서입니다. \n권한 추가는 관리자에게 문의해주세요.');
						$('#userTbody').empty();
						return false;
 					}
 					activeDept(event, data);
				} else {
					activeDept(event, data);
				}
			}
		});
		
		//기본트리생성\
		$("#usertreeTb").fancytree({
			autoScroll: true,
			checkbox : false,
			tooltip : true,
			selectMode : 3,
			quicksearch : true,
			extensions : ["filter","table"],
			filter: {
				autoApply: true,
				counter: false,
				mode: "dimm"	//dimm
			},
			table: {
				indentation: 18,      // indent 18px per node level
				nodeColumnIdx: 0,
			},
			activate : function(event, data) {
				activeDeptTree(data.node.data.dept_seq);
				<c:out value="${param.activeUserMethod }" ></c:out>
			},
			renderColumns: function(event, data) {
				var node = data.node;
				$tdList = $(node.tr).find(">td");
				if(node.data.use_yn == 'N') $tdList.addClass("user-not-used");
				$tdList.eq(2).attr("title", node.data.users_dept_nm);
				$tdList.eq(2).text( node.data.users_dept_nm );
				$tdList.eq(1).attr("title", node.key);
				$tdList.eq(1).text( node.key );
			}
		});
		//fancytree end
		
		<c:if test="${ not empty param.depttreeHeight }">
			$(".deptDiv").height("${param.depttreeHeight}");
		</c:if>
		<c:if test="${ not empty param.usertreeHeight }">
			$(".userDiv").height("${param.usertreeHeight}");
		</c:if>
		<c:if test="${ not empty param.width}">
			$(".outBox").width("${param.width}");
		</c:if>
		
		addSearchEvent();
		
		function activeDeptTree(dept_seq) {
			var node = $("#depttree").fancytree("getTree").getNodeByKey(dept_seq);
			if(node != null && node != 'undefined' && node != "") {
				//clearDeptTitle();
				//node.setTitle("<mark>" + node.title + "</mark>");
				node.makeVisible({scrollIntoView: true});
			}
		}
	});
	
	function clearDeptTitle() {
		$("#depttree").find("span.fancytree-title > mark").each(function() {
			var content = $(this).html();
			$(this).parent().html(content);
		});
	}
	
	function activeDept(event, data) {
		$("#search").val("");
		<c:if test="${ not empty param.beforeActiveDeptNodeMethod }">
			<c:out value="${param.beforeActiveDeptNodeMethod }" />
		</c:if>
		getDeptUserInfo(event, data.node);
	}
	
	function getDeptUserInfo(event, node) {
		var requestURL = "<c:url value="/hr/user/userTreeSubGroup.lin" />?mgt_yn=N"
				+"&use_yn=${param.useYn}&validUser=${param.validUser}&onlyApprover="+$("#onlyApprover").val()+"&midadmin_auth=${param.midadmin_auth}";
		
		var dept_seq = (node != null) ? node.data.dept_seq : null;
		if( dept_seq != null && dept_seq != 'undefined' && dept_seq != "" ) {
			requestURL += "&dept_seq=" + dept_seq;
		}
		
		var searchValue = $("#search").val();
		if( searchValue != null && searchValue != 'undefined' && searchValue != "" ) {
			requestURL += "&search=" + encodeURI(encodeURIComponent(searchValue));
		}

		$("#usertreeTb").fancytree("getRootNode").removeChildren();
		
		$.ajax({
			type : "get",
			url : requestURL,
			dataType : "json",
			cache : false,
			error : function(xhr, status, error) {
				if (xhr.status == 401) {
					resultSessionExpire(xhr);
				} else if (xhr.status == 200) {
					resultInterceptorError(xhr);
				} else {
					console.log("error");
				}
			},
			success : function(response) {
				$("#usertreeTb").fancytree("getRootNode").addChildren(response);
			}
		});
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
			var type = $("#searchType").val();
			if (type == "dept") {
				match = $("input[name=search]").val();
				var tree = $.ui.fancytree.getTree();
				if ($.trim(match) === "") {
					tree.clearFilter();
					return;
				}
				
				// Pass a string to perform case insensitive matching
				n = tree.filterBranches.call(tree, match, tree_search_filter_opts_enter);
			} else if (type == "user") {
				$.ui.fancytree.getTree().clearFilter();
				getDeptUserInfo(null, $("#depttree").fancytree("getActiveNode"));
			}
		});
	}
	
	function approvalSearchUser() {
		if("${param.isApproverListYn}" != 'Y'){
			return;
		}
		$("#onlyApprover").change(function(){
			if($("#onlyApprover").is(":checked")){
				$("#onlyApprover").val('');
				getDeptUserInfo(null, $("#depttree").fancytree("getActiveNode")); // 체크박스를 체크할때 마다 바뀜.
			}else{
				$("#onlyApprover").val('Y');
				getDeptUserInfo(null, $("#depttree").fancytree("getActiveNode")); // 체크박스를 체크할때 마다 바뀜.
			}
		});
	}
	
	$(document).ready(function() {
		approvalSearchUser();
	});
</script>
<style>
.conBox {
  overflow:visible;
}

.userDiv {
	width:100%;
}

#usertree {
	border-top: 1px solid #ddd;
    border-bottom: 1px solid #ddd;
}
#usertreeTb, #usertreeTitle {
	width: 100%;
	font-size: 10pt;
	table-layout: fixed;
}

#usertreeTitle tr {
    border-bottom: 1px solid #ddd;
    background-color: #f9f9f9;
    height: 30px;
    font-size: 13px;
}

#usertreeTbDiv {
	/* height: ${param.usertreeHeight}px; */
	height: 88%;
	overflow: auto;
	overflow-x: hidden;
}

#usertreeTb tr {
	cursor: pointer;
}

#usertreeTb td, #usertreeTb td > span {
	overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    word-break: break-all;
    padding-left: 8px;
    vertical-align: middle;
}

#usertreeTb span.fancytree-title {
   /*  vertical-align: middle !important;
    display: inline !important; */
    vertical-align: middle !important;
    display: inline-block;
    line-height: 19px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    word-break: break-all;
    width: 68%;
    padding: 0;
}

#usertreeTb span.fancytree-expander, #usertreeTb span.fancytree-icon {
	margin-top: 0;
	vertical-align: middle;
}

#usertreeTb .fancytree-expander {
	width: 0;
}
</style>

			<div class="outBox">
				<c:if test="${param.inputInvisible ne 'Y' }">
					<input type="hidden" id="users_nm" name="users_nm" /> 
					<input type="hidden" id="users_id" name="users_id" /> 
					<input type="hidden" id="dept_nm" name="dept_nm" /> 
					<input type="hidden" id="dept_seq" name="dept_seq" />
				</c:if>
				<div class="conWrap">
					<h3>
					<c:choose>
						<c:when test="${param.isApproverListYn eq 'Y'}">
							결재자 목록 
							<div class="search_checkBox">
							<input class="search_checkBox_input" type="checkbox" id="onlyApprover" name="onlyApprover" value="Y"/>
							<label for="onlyApprover">일반 사용자 포함</label>
							</div>
						</c:when>
						<c:otherwise>사용자 목록</c:otherwise>
					</c:choose>
					</h3>
					<div class="conBox">
						<div class="topCon t_center pd_t10 pd_b10 Bborder">
							<select id="searchType" name="searchType">
								<option value="user">사용자</option>
								<option value="dept">부서</option>
							</select>
							<input type="text" name="search" id="search" class="text_input max" placeholder="검색 값을 입력하세요." onkeyup="onlySizeFillter(this,15)" />
							<button type="button" id="btnResetSearch" class="btn_common theme">검색</button>
							<c:if test="${ ( param.ableUserControl eq 'Y' ) and ( auth_cd != 4 ) }">
								<br>
								<button type="button" class="btn_common theme" onclick="insert()">사용자추가</button>
								<button type="button" class="btn_common theme" onclick="userdel()">사용자삭제</button>
							</c:if>
						</div>
						<div id="depttree" class="deptDiv pd_t10 mg_b10"></div>
						<div id="usertree" class="userDiv mg_b10">
							<table id="usertreeTitle" >
								<colgroup>
									<col width="30%"></col>
									<col width="30%"></col>
									<col width="40%"></col>
								</colgroup>
								<thead>
									<tr>
										<th>사용자명</th>
										<th>${customfunc:getMessage('common.id.commonid')}</th>
										<th>부서명</th>
									</tr>
								</thead>
							</table>
							<div id="usertreeTbDiv">
								<table id="usertreeTb" >
									<colgroup>
										<col width="30%"></col>
										<col width="30%"></col>
										<col width="40%"></col>
									</colgroup>
									<tbody id="userTbody">
										<tr>
											<td></td>
											<td></td>
											<td></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>


