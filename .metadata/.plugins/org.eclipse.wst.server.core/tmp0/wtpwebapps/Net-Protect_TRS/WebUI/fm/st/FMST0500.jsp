<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/tags/custom-function.tld" prefix="customfunc"%>
<html>
<head>
<c:set var="CUD_CD_C" value="${customfunc:codeString('CUD_CD', 'INSERT')}" />
<c:set var="CUD_CD_U" value="${customfunc:codeString('CUD_CD', 'UPDATE')}" />
<c:set var="CUD_CD_D" value="${customfunc:codeString('CUD_CD', 'DELETE')}" />
<script type="text/javascript">
	$(document).ready(function() {
		//getsCode();
	});
	function getsCode(id, sCode){
		var requestURL = "<c:url value='/scode/selectScodeList.lin' />?cd=" + sCode;
		resultCheckFunc($("#lform"), requestURL, function(response) {
			var sCodeList = response['sCodeList'];
			if(sCodeList == null || sCodeList.length == 0){
				alert('해당 코드가 없습니다.');
			}else{
				result = "<select id='sCodeSelect' name='sCodeSelect'>";
				for (var i=0; i < sCodeList.length; i++) {
					var cd = sCodeList[i].cd;
					var sCd = sCodeList[i].s_cd;
					var sCdNm = sCodeList[i].s_cd_nm;
					result += "<option value='"+cd+"' onclick='setScode(\'"+cd+"\');'>" + sCd+":"+sCdNm + '</option>';
				}
				result = "</select>";
				$('#'+id).html(result);
			}
		});
	}
	function update() {
		
		var form = document.lform;
		var seq = "";
		var term_cd = "";
		var term_cd_nm = "";
		var term_cd_nm_title = "";
		var term_memo = "";
		var term_memo_title = "";
		var term_val_cd = "";
		var term_val_memo = "";
		var term_str_cd = "";
		var term_str_memo = "";
		var flag = 0;
		$('#values').children().each(function(){	//tr
			$(this).children().each(function(idx){	//td
				seq = "";
				term_cd = "";
				term_cd_nm = "";
				term_cd_nm_title = "";
				//term_val_cd = "";
				term_val_memo = "";
				term_memo = "";
				term_memo_title = "";
				
				term_cd = $(this).parent().children().text();
				$('#q2').val(term_cd);
				if(idx == 1){
					seq = $(this).children().attr("id");
					seq = seq.split('_')[0];
					$('#q1').val(seq);
					term_cd_nm = $(this).children().val();
					term_cd_nm_title = $(this).children().attr("title");
					//term_val_cd = seq+"###"+term_cd+"###"+term_cd_nm;
					//term_str_cd = term_str_cd + term_val_cd+"|||";
					$('#q3').val(term_cd_nm);
					if(term_cd_nm != term_cd_nm_title){
						flag++;
					}
				}
				
				if(idx == 2){
					seq = $(this).children().attr("id");
					seq = seq.split('_')[0];
					term_memo = $(this).children().val();
					term_memo_title = $(this).children().attr("title");
					//term_val_memo = seq+"###"+term_cd+"###"+term_memo;
					//term_str_memo = term_str_memo + term_val_memo+"|||";
					$('#q4').val(term_memo);
					if((term_memo != term_memo_title) || flag != 0){
						flag++;
					}
				}
			});
			if(flag != 0){
				/* alert(
				$('#q1').val()+":"+
				$('#q2').val()+":"+
				$('#q3').val()+":"+
				$('#q4').val()
				); */
				//seq term_cd term_cd_nm term_memo
				term_val_cd = term_val_cd + $('#q1').val() + "###" + $('#q2').val() + "###" + $('#q3').val() + "###" + $('#q4').val() + "|||";
				$('#valueCdList').val(term_val_cd);
				
				flag = 0;
				$('#q1').val('');
				$('#q2').val('');
				$('#q3').val('');
				$('#q4').val('');
			}
		});
		//alert($('#valueCdList').val());
		if($('#valueCdList').val().length != 0){
			$('#valueCdList').val($('#valueCdList').val().substring(0, $('#valueCdList').val().length - 3));
			//alert($('#valueCdList').val());
		}
		/* if(term_str_cd.length != 0){
			alert("term_str_cd == "+term_str_cd);
			$('#valueCdList').val(term_str_cd.substring(0, term_str_cd.length-3));
		}
		
		if(term_str_memo.length != 0){
			alert("term_str_memo == "+term_str_memo);
			$('#valueMemoList').val(term_str_memo.substring(0, term_str_memo.length-3));
		} */
		
		form.action = "<c:url value="/fm/st/FMST0500Update.lin" />";
		form.submit();
	}
	
</script>
</head>
<body>
<form id="lform" name="lform" onsubmit="return false;" method="post" action="<c:url value="/fm/st/FMST0500.lin" />">
	<input id="page" name="page" type="hidden" />
	<input id="valueCdList" name="valueCdList" type="hidden" value="" />
	<input id="q1" name="q1" type="hidden" value="" />
	<input id="q2" name="q2" type="hidden" value="" />
	<input id="q3" name="q3" type="hidden" value="" />
	<input id="q4" name="q4" type="hidden" value="" />
	<!-- contents -->
	<div class="rightArea">
	<div class="conWrap tableBox">
		<h3>목록</h3>
		<div class="conBox">
			<div class="table_area_style01">
				<div class="btn_area_right mg_r10 mg_t10 mg_b10">
					<button type="button" class="btn_common" onclick="update();">적용</button>
				</div>
				<table summary="자료 수신함"
					style="table-layout: fixed">
					<caption>요청자, 제목, 요청시간</caption>
					<colgroup>
						<col style="width: 20%;" />
						<col style="width: 35%;" />
						<col style="width: 45%;" />
					</colgroup>
					<thead>
						<tr>
							<th class="Rborder">용어 코드</th>
							<th class="Rborder">용어 명칭</th>
							<th>용어 설명</th>
						</tr>
					</thead>
					<!-- 
					$('#values').children().each(function(){
						$(this).children().index[1].children().val();
					});
					 -->
					<tbody id="values" class="a">
						<c:choose>
						<c:when test="${not empty fmstList}">
							<c:forEach items="${fmstList}" var="fmstListForm" varStatus="c">
								<tr class="b">
									<td class="t_center Rborder">${fmstListForm.term_cd }</td>
									<td class="t_center Rborder">
										<input type="text" id="${fmstListForm.term_seq }_${c.index}" value="${fmstListForm.term_cd_nm }" title="${fmstListForm.term_cd_nm }" />
									</td>
									<td class="t_center">
										<input type="text" id="${fmstListForm.term_seq }_${c.index}_1" name="" value="${fmstListForm.term_note}" title="${fmstListForm.term_note}"/>
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td class="t_center" colspan="3">
									<div class="no_result">
										<spring:message code="global.script.search.no.result" />
									</div>
								</td>
							</tr>
					</c:otherwise>
				</c:choose>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="3" class="td_last">
								<div class="btn_area_right mg_r10 mg_t10 mg_b10">
									${lastTime } 에 적용 완료 했습니다.
								</div>
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