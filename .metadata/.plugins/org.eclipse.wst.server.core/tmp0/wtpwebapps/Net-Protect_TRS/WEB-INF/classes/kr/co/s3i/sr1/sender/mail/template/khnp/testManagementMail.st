<HTML xmlns="http://www.w3.org/1999/xhtml"><HEAD><TITLE>메일폼-Default</TITLE>
<META name=GENERATOR content="MSHTML 8.00.7601.18446"></HEAD>
<style>
.td_style{
BORDER-BOTTOM: #ccc 1px solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 10px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; FONT-FAMILY: 굴림, gulim, tahoma; COLOR: #494949; FONT-SIZE: 12px; BORDER-TOP: #ccc 1px solid; BORDER-RIGHT: #ccc 1px solid; PADDING-TOP: 10px;
}
.th_style{
BORDER-BOTTOM: #ccc 1px solid; BORDER-LEFT: medium none; PADDING-BOTTOM: 10px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; FONT-FAMILY: 굴림, gulim, tahoma; COLOR: #494949; FONT-SIZE: 12px; BORDER-TOP: #ccc 1px solid; BORDER-RIGHT: #ccc 1px solid; PADDING-TOP: 10px;
background-color:#f5f5f5; width=100; text-align:center;
}

</style>
<BODY>
<DIV style="BORDER-BOTTOM: #ccc 1px solid; BORDER-LEFT: #ccc 1px solid; PADDING-BOTTOM: 40px; PADDING-LEFT: 20px; WIDTH: 560px; PADDING-RIGHT: 20px; BORDER-TOP: #ccc 1px solid; BORDER-RIGHT: #ccc 1px solid; PADDING-TOP: 25px; box-shadow: 2px 2px 2px #ddd; border-radius: 10px">
	<DIV style="MARGIN: 20px auto 0px; WIDTH: 520px">
		<H1 style="BORDER-BOTTOM: #000 2px solid; PADDING-BOTTOM: 10px; FONT-FAMILY: 돋움, dotum, tahoma; MARGIN-BOTTOM: 20px; COLOR: #000; FONT-SIZE: 16px; FONT-WEIGHT: bold">
			$title$
		</H1>
		<TABLE style="BORDER-COLLAPSE: collapse" border=0 cellSpacing=0 cellPadding=0 width="100%">
			<TBODY>
				<TR>
					<TH class="th_style">알림 시간</TH>
					<TD class="td_style">$date$</TD>
				</TR>
				<TR>
					<TH class="th_style">서버 정보</TH>
					<TD class="td_style">$systemName$ $serverName$ ($serverIp$)</TD>
				</TR>
				<TR>
					<TH rowspan="$rowSpan$" class="th_style">실패 항목</TH>
					<TD class="td_style">$firstFailTestName$</TD>
				</TR>
				$elseFailTestNames$
			</TBODY>
		</TABLE>
	</DIV>
	<P style="BORDER-BOTTOM: #e4e4e4 1px solid; BORDER-LEFT: #e4e4e4 1px solid; PADDING-BOTTOM: 15px; LINE-HEIGHT: 16px; MARGIN: 30px auto 0px; PADDING-LEFT: 20px; WIDTH: 480px; PADDING-RIGHT: 20px; FONT-FAMILY: 돋움, dotum, tahoma; BACKGROUND: #f9f9f9; COLOR: #666; FONT-SIZE: 11px; BORDER-TOP: #e4e4e4 1px solid; BORDER-RIGHT: #e4e4e4 1px solid; PADDING-TOP: 15px">$message$</P></DIV></BODY></HTML>