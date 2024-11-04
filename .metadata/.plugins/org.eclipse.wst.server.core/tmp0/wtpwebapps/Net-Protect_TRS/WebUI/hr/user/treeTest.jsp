<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<link href="<c:url value="/JavaScript/dist/themes/default/style.min.css" />" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<c:url value="/JavaScript/dist/jstree.min.js" />"></script>
<script type="text/javascript">
	$(function(){ 
		$('#jstree').jstree();
		$('#jstree').on("changed.jstree", function (e, data) {
			alert(data.selected);
		});

		$('button').on('click', function () {
			$('#jstree').jstree(true).select_node('child_node_1');
			$('#jstree').jstree('select_node', 'child_node_1');
			$.jstree.reference('#jstree').select_node('child_node_1');
		});
	});
</script>
</head>
<body>
	<div id="jstree">
		<ul>
			<li>Root node 1
				<ul>
					<li id="child_node_1">Child node 1</li>
					<li>Child node 2</li>
				</ul>
			</li>
			<li>Root node 2</li>
		</ul>
	</div>
	<button>demo button</button>
</body>
</html>