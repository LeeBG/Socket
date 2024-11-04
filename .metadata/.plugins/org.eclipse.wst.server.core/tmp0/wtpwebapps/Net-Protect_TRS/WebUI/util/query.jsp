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
function submit() {
	document.lform.action = "/util/query.lin";
	document.lform.submit();
}
</script>
</head>
<body>
	<div class="rightArea">
		<div class="topWarp">
			<div class="titleBox">
				<h2 class="f_left text_bold">SQL Query Excutor</h2>
			</div>
		</div>
		<div class="contWarpper">
			<form id="lform" method="post">
				<div id="dbInfo" class="table_area_style01">
					<%-- <table style="width: 80%">
						<colgroup>
							<col width="30%"/>
							<col width="70%"/>
						</colgroup>
						<tr>
							<td colspan="2" style="font-weight:800;">
								Oracle 접속 정보
							</td>
						</tr>
						<tr>
							<td>driver</td>
							<td><input type="text" name="driver" class="text_input max" value='<c:out value="${driver }"/>' readonly/></td>
						</tr>
						<tr>
							<td>url</td>
							<td><input type="text" name="url" class="text_input max" value='<c:out value="${url }"/>' readonly/></td>
						</tr>
						<tr>
							<td>user</td>
							<td><input type="text" name="username" class="text_input max" value='<c:out value="${username }"/>'/></td>
						</tr>
						<tr>
							<td>password</td>
							<td><input type="password" name="password" class="text_input max" value='<c:out value="${password }"/>'/></td>
						</tr> 
					</table> --%>
				</div>
				<div id="inputDiv">
					
					<input type="hidden" id="csrf" name="csrf" value="${loginUser.csrf }" />
					<textarea style="width:90%; height:200px;float:left; margin-left:5px; margin-top:5px;" name="query"><c:choose><c:when test="${ excutedQuery != null }"><c:out value="${ excutedQuery }"/></c:when><c:otherwise>이곳에 쿼리를 작성해주세요.</c:otherwise></c:choose></textarea>
					<button class="btn_common mg_l5 mg_t5" onclick="submit()">실행</button>
					
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
						
						//1. JDBC 드라이버 로딩하기
						Class.forName(driver);
						
						//2. DB 서버 접속하기
						conn = DriverManager.getConnection(url, userid, pwd);
						
						stmt = conn.createStatement();
						stmt.setQueryTimeout(60);	//60sec
						
						if( sql != null && ! sql.equals("") ) {
							rs = stmt.executeQuery(sql);
						}
							
					 	if( rs != null ) {
					 		/* ************************************************
					 		* 컬럼 정보 출력 start
					 		************************************************* */
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
					 		/* ************************************************
					 		* 컬럼 정보 출력 end
					 		************************************************* */
					 		
					 		/* ************************************************
					 		* 행 출력 start
					 		************************************************* */
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
					 		/* ************************************************
					 		* 행 출력 end
					 		************************************************* */
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
	</div>
</body>
</html>