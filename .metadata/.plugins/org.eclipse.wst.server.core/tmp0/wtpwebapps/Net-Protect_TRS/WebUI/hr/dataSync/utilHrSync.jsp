<%@page import="kr.co.s3i.sr1.common.cipher.AES128Utility"%>
<%@page import="kr.co.s3i.sr1.common.utility.CommonUtility"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<c:set var="loginUser" value="${sessionScope.loginUser}" />
<html>
<head>
<title>SQL Query Excutor</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="Pragma" content="no-cache" />
<style type="text/css">
div#inputDiv {
	width: 100%;
	height: 250px;
}
div#resultDiv {
	width: 100%;
}
div.contWarpper {
	margin-left: 5px;
	margin-right: 5px;
}
</style>
<script type="text/javascript">
function btnExe() {
	$("#callExecution").val("use");
	$("#useMode").val($('input:radio[name="SyncUse"]:checked').val());
	$("#approvalIO").val($("select[name=selectApprovalIO]").val());
	if ($('textarea[name=query]').val() == 0) {
		alert('쿼리를 입력하세요.');
		return;
	}
	$("#lform").get(0).submit();
}

function read() {
	$("#useMode").val($('input:radio[name="SyncUse"]:checked').val());
	$("#approvalIO").val($("select[name=selectApprovalIO]").val());
	$("#lform").get(0).submit();
}

function save() {
	$("#useMode").val($('input:radio[name="SyncUse"]:checked').val());
	$("#approvalIO").val($("select[name=selectApprovalIO]").val());

	if ($('textarea[name=query]').val() == 0) {
		alert('쿼리를 입력하세요.');
		return;
	}
	if (confirm("저장하시겠습니까?")) {
		var requestURL = "<c:url value="/hr/dataSync/updateUtilHrSync.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			if( response['result'] == '200'){
				alert('저장 성공하였습니다.')
				$("#lform").get(0).submit();
			} else {
				alert('저장 실패하였습니다.')
			}
		});
	}
}

function btnDelete() {
	$("#useMode").val($('input:radio[name="SyncUse"]:checked').val());
	$("#delPoint").val("Y");

	if (confirm("삭제하시겠습니까?")) {
		var requestURL = "<c:url value="/hr/dataSync/updateUtilHrSync.lin" />";
		resultCheckFunc($("#lform"), requestURL, function(response) {
			if( response['result'] == '200'){
				alert('삭제 성공하였습니다.')
				$("#lform").get(0).submit();
			} else {
				alert('삭제 실패하였습니다.')
			}
		});
	}
}

function self_close() {
	self.opener = self;
	window.close();
}

</script>
</head>
<body>
	<div class="topWarp">
		<div class="top_title">
			<h2 class="text_bold">쿼리 연동 저장</h2>
		</div>
	</div>
	<div class="contWarpper">
		<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/hr/dataSync/utilHrSync.lin" />">
		<input type="hidden"id="useMode" name="useMode" />
		<input type="hidden"id="delPoint" name="delPoint" />
		<input type="hidden"id="useCategory" name="useCategory" />
		<input type="hidden"id="callExecution" name="callExecution" />
		<input type="hidden"id="approvalIO" name="approvalIO" value="${selectApprovalIO}"/>
			<div class ="mg_t20 mg_b20">
				<input type="radio" name="SyncUse" id="userSyncUse" value="user.query" ${useMode == "user.query" ? ' checked' : ''} onclick="read()" /><label class="mg_l5" for="userSyncUse">사용자</label>
				<input type="radio" name="SyncUse" id="deptSyncUse" value="dept.query" ${useMode == "dept.query" ? ' checked' : ''} onclick="read()" /><label class="mg_l5" for="deptSyncUse">부서</label>
				<input type="radio" name="SyncUse" id="approvalSyncUse" value="approval.query" ${useMode == "approval.query" ? ' checked' : ''} onclick="read()" /><label class="mg_l5" for="approvalSyncUse">결재권자</label>
				<c:if test="${useMode == 'approval.query'}">
					<select id="selectApprovalIO" name="selectApprovalIO" title="결재권자 분류" class="mg_l5">
						<option <c:if test="${selectApprovalIO eq '1'}">selected="selected"</c:if> id="in" value="1">내부DB</option>
						<option <c:if test="${selectApprovalIO eq '2'}">selected="selected"</c:if> id="out" value="2">외부DB</option>
					</select>
				</c:if>
			</div>
			<div id="inputDiv">
				<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
				<textarea style="width:90%; height:200px;float:left; margin-left:5px; margin-top:5px;" name="query" placeholder="이곳에 쿼리를 작성해주세요.">${setSettingValue}</textarea>
				<button class="btn_common mg_l5 mg_t5" onclick="btnExe()">실행</button>
				<button class="btn_common mg_l5 mg_t5" onclick="save()">저장</button>
				<button class="btn_common mg_l5 mg_t5" onclick="btnDelete()">삭제</button>
				<button class="btn_common mg_l5 mg_t5" onclick="self_close()">닫기</button>
			</div>
		</form>
		<div id="resultDiv" class="table_area_style01 mg_t10">
			<c:if test="${ excutedQuery != null }">
				<table>
				<%
				ResultSet rs = null;
				Statement stmt = null;
				Connection conn = null;
				AES128Utility aesUtil = new AES128Utility();

				try{
					String driver = aesUtil.decode(request.getAttribute("driver").toString());
					String url = aesUtil.decode(request.getAttribute("url").toString());
					String userid = aesUtil.decode(request.getAttribute("username").toString());
					String pwd = aesUtil.decode(request.getAttribute("password").toString());
					String sql = request.getAttribute("excutedQuery").toString();

					Class.forName(driver);

					conn = DriverManager.getConnection(url, userid, pwd);

					stmt = conn.createStatement();
					stmt.setQueryTimeout(60);	//60sec

					if( sql != null && ! sql.equals("") ) {
						rs = stmt.executeQuery(sql);
					}

				 	if( rs != null ) {
				 		ResultSetMetaData metaData = rs.getMetaData();
				 		int colcount = metaData.getColumnCount();
				 		out.println("<tr>\n");
				 		for(int i=1; i<=colcount; i++) {
				 			out.print("<th title='");
				 			out.print(metaData.getColumnLabel(i));
				 			out.print("'>");
				 			out.print(metaData.getColumnLabel(i));
				 			out.print("</th>");
				 		}
				 		out.println("</tr>");
				 		
				 		int rowcount = 0;
				 		while(rs.next()) {
				 			rowcount++;

				 			out.println("<tr>\n");
				 			for(int i=1; i<= colcount; i++) {
				 				out.print("<td title='");
				 				out.print(rs.getString(i));
				 				out.print("'>");
				 				out.print(rs.getString(i));
				 				out.print("</td>");
				 			}
				 			out.println("</tr>\n");
				 		}
				 		out.print("<tr>\n<td colspan='");
				 		out.print(colcount);
				 		out.print("'><b> * row count : ");
				 		out.print(rowcount);
				 		out.println("</b></td></tr>\n");
				 	} else {
				 		out.println("<tr><td>ResultSet is empty!!</td></tr>");
				 	}
				} catch(Exception e) {
					out.print("<pre>");
					out.println(CommonUtility.getPrintStacTraceString(e));
					out.print("</pre>");
				} finally {
					if(rs != null) rs.close();
					if(stmt != null) stmt.close();
					if(conn != null) conn.close();
				}
				%>
				</table>
			</c:if><br/>
		</div>
	</div>
</body>
</html>